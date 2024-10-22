
#Область СлужебныеПроцедурыИФункции

// Формирует строку описания правила отбора
//
// Параметры
//  <Правило>  - <СправочникСсылка.смсПравилаОтбораПолучателей> - Правило отбора получателей.
//
// Возвращаемое значение:
//   <Строка>    - Строка описания правила.
//
Функция ПолучитьОписаниеПравилаОтбораПолучателей(Правило) Экспорт
	
	Если Не ЗначениеЗаполнено(Правило) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если Правило.ЭтоГруппа Тогда
		Возврат "";
	КонецЕсли; 
	
	СтрокаПравило = "";
	
	НастройкиКомпоновкиДанных = Правило.КомпоновщикНастроек.Получить();
	
	Если Не НастройкиКомпоновкиДанных = Неопределено Тогда
		СтрокаПравило = Строка(НастройкиКомпоновкиДанных.Отбор);
	КонецЕсли;
	
	Возврат СтрокаПравило;
	
КонецФункции // смсПолучиьОписаниеПравилаОтбораПолучателей()

// Формирует таблицу значений со списком получателей
//
// Параметры
//  ПравилаОтбораПолучателей - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  СтопЛист - Список значений - список номеров из стоп листа.
//
// Возвращаемое значение:
//   <ТаблицаЗначений>   - Список получателей с номерами телефонов.
//
Функция ПолучитьСписокПолучателей(НастройкиКомпоновки, ДополнительныеПараметры) Экспорт
	
	Попытка
		
		СхемаПравилаОтбора = Справочники.смсПравилаОтбораПолучателей.ПолучитьМакет("СхемаПравилОтбораПереопределяемый");
		
		КомпоновщикМакета   = Новый КомпоновщикМакетаКомпоновкиДанных();
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаПравилаОтбора));
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновки);
		
		КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
		
		МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаПравилаОтбора, КомпоновщикНастроек.ПолучитьНастройки(),,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
		ТекстЗапроса  = МакетКомпоновкиДанных.НаборыДанных.ОсновнойНаборДанных.Запрос;
		ЗапросПравило = Новый Запрос(ТекстЗапроса);
		Для Каждого Параметр Из МакетКомпоновкиДанных.ЗначенияПараметров Цикл
			ЗапросПравило.Параметры.Вставить(Параметр.Имя, Параметр.Значение);
		КонецЦикла;
		
		// Устанавливаем дополнительные параметры запроса
		смсНастройкаПереопределяемый.УстановитьДополнительныеПараметрыЗапроса(ЗапросПравило, ДополнительныеПараметры);
		
		ТаблицаПолучателей = ЗапросПравило.Выполнить().Выгрузить();
		
	Исключение
		
		Возврат Неопределено;
		
	КонецПопытки;
	
	// Получаем текст запроса для добавления номера телефона в таблицу
	ТекстЗапросаНомеровТелефонов = смсНастройкаПереопределяемый.ПолучитьТекстЗапросаНомеровТелефонов();
	
	Запрос = Новый Запрос(ТекстЗапросаНомеровТелефонов);
	Запрос.УстановитьПараметр("ТаблицаПолучателей", ТаблицаПолучателей);
	
	ПолнаяТаблицаПолучателей = Запрос.Выполнить().Выгрузить();
	
	ОбработатьТелефонныеНомераПолучателей(ПолнаяТаблицаПолучателей);
	
	ТаблицаПолучателей = ПрименитьСтопЛистРассылки(ПолнаяТаблицаПолучателей);
	
	Возврат ТаблицаПолучателей;
	
КонецФункции // ПолучитьСписокПолучателей()

// Удаляет из Таблицы получателей номера, находящиеся в стоп-листе
// Параметры
//  ТаблицаПолучателей - ТаблицаЗначений - Таблица с получателями.
//
// Возвращаемое значение:
//   ТаблицаПолучателей   - Таблица с номерами телефонов.
//
Функция ПрименитьСтопЛистРассылки(ТаблицаПолучателей) Экспорт
	
	//ИмяКолонки = ТаблицаПолучателей.Колонки.Получить(2).Имя;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ *
	|ПОМЕСТИТЬ врТаблицаПолучателей
	|ИЗ
	|	&ТаблицаПолучателей КАК ТаблицаПолучателей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ *
	|ИЗ
	|	врТаблицаПолучателей КАК врТаблицаПолучателей
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.смсСтопЛистДляРассылки КАК смсСтопЛистДляРассылки
	|		ПО врТаблицаПолучателей.НомерТелефона = смсСтопЛистДляРассылки.НомерТелефона
	|ГДЕ
	|	смсСтопЛистДляРассылки.НомерТелефона ЕСТЬ NULL";
	Запрос.УстановитьПараметр("ТаблицаПолучателей", ТаблицаПолучателей);
	РезультирующаяТаблицаПолучателей = Запрос.Выполнить().Выгрузить();
	
	Возврат РезультирующаяТаблицаПолучателей;
	
КонецФункции // ПрименитьСтопЛистРассылки()

// Проверяет номер телефона на наличие его в стоп-листе
// Параметры
//  НомерТелефона - Строка - Номер телефона на проверку.
//
// Возвращаемое значение:
//   Булево   - есть ли номер телефона в стоп-листе.
//
Функция НомерТелефонаВСтопЛисте(НомерТелефона) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	смсСтопЛистДляРассылки.НомерТелефона
	|ИЗ
	|	РегистрСведений.смсСтопЛистДляРассылки КАК смсСтопЛистДляРассылки
	|ГДЕ
	|	смсСтопЛистДляРассылки.НомерТелефона = &НомерНаПроверку";
	Запрос.УстановитьПараметр("НомерНаПроверку", НомерТелефона);
	
	Возврат (Не Запрос.Выполнить().Пустой());
	
	КонецФункции // НомерТелефонаВСтопЛисте()

// Удаляет из номеров телефонов каждой строки Таблицы получателей 
// все нечисловые символы.
//
// Параметры
//  ТаблицаПолучателей - ТаблицаЗначений - Таблица с получателями.
//
Процедура ОбработатьТелефонныеНомераПолучателей(ТаблицаПолучателей) Экспорт
	
	// Процедура оставляет в строке номера телефона только цифровые символы,
	// так как номер телефона получателя должен содержать 11 числовых символов начиная с цифры "7".
	Для Каждого ТекСтрока Из ТаблицаПолучателей Цикл
		
		ИсходнаяСтрока = ТекСтрока.НомерТелефона;
		ИтоговаяСтрока = "";
		
		Для НомерСимвола = 1 По СтрДлина(ИсходнаяСтрока) Цикл
			ТекущийСимвол = Сред(ИсходнаяСтрока, НомерСимвола, 1);
			КодСимвола = КодСимвола(ТекущийСимвол);
			Если КодСимвола >= 48 И КодСимвола <= 57 Тогда
				ИтоговаяСтрока = ИтоговаяСтрока + ТекущийСимвол;
			КонецЕсли;
		КонецЦикла;
		
		ТекСтрока.НомерТелефона = ИтоговаяСтрока;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти