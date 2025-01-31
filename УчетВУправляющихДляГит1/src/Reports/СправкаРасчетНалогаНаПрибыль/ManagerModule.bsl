#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет поддерживаемый набор суммовых показателей справки-расчета.
// См. соответствующие методы модулей подсистемы СправкиРасчеты.
// Справка-расчет должна поддерживать хотя бы один набор.
// Если поддерживается несколько наборов, то конкретный набор выбирается в форме
// и передается через свойство отчета НаборПоказателейОтчета.
//
// Возвращаемое значение:
//  Массив - номера наборов суммовых показателей.
//
Функция ПоддерживаемыеНаборыСуммовыхПоказателей() Экспорт
	
	Возврат СправкиРасчетыКлиентСервер.ВсеНаборыСуммовыхПоказателей();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиБухгалтерскиеОтчеты

Функция ПолучитьТекстЗаголовка(Контекст) Экспорт 
	
	Возврат СправкиРасчеты.ЗаголовокОтчета(Контекст);
	
КонецФункции

Процедура ПриВыводеЗаголовка(Контекст, КомпоновщикНастроек, Результат) Экспорт
	
	СправкиРасчеты.ВывестиШапкуОтчета(Результат, Контекст);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(Контекст, Результат) Экспорт
	
	СчетчикПримечаний = СправкиРасчеты.ОформитьРезультатОтчета(Результат, Контекст);
	
	УстановитьСтавкиНалогаНаПрибыль(Результат, Контекст.СтавкаНалогаНаПрибыль);
	
	ДобавитьПримечаниеПолныеРубли(Результат, Контекст.ПоказательВР, СчетчикПримечаний);
	
КонецПроцедуры

#КонецОбласти

#Область ТонкаяНастройка

Процедура УстановитьСтавкиНалогаНаПрибыль(Результат, СтавкаНалогаНаПрибыль)
	
	// Расчетная ставка может быть определена во внешнем наборе данных, после компоновки макета.
	// Поэтому вместо передачи параметров обычным способом, значения параметров шаблонов заголовков
	// передаются через строки особого формата в макете.
	
	Область = Результат.НайтиТекст("##РасчетнаяСтавкаНалогаНаПрибыль##",Результат.Область("r1c1"));
	Если Область = Неопределено Тогда
		СтавкаНалогаНаПрибыль = "" + СтавкаНалогаНаПрибыль + " %";	
	Иначе	
		Имя = Область.Имя;
		Область = Результат.Область(Сред(Имя,1,СтрДлина(Имя)-1) + (Число(Прав(Имя,1)) + 1));
		СтавкаНалогаНаПрибыль = Область.Текст + " %";
		Область = Результат.Область(Область.Верх, , Область.Низ);
		Область.Очистить(Истина,Истина,Истина);
	КонецЕсли;

	Область = Результат.НайтиТекст("##СтавкаНалогаНаПрибыль##",Результат.Область("r1c1"));
	Пока НЕ Область = Неопределено Цикл
		Область.Текст = СтрЗаменить(Область.Текст,"##СтавкаНалогаНаПрибыль##",СтавкаНалогаНаПрибыль);
		Область = Результат.НайтиТекст("##СтавкаНалогаНаПрибыль##",Область);
	КонецЦикла;
	
КонецПроцедуры
	
Процедура ДобавитьПримечаниеПолныеРубли(Результат, ПоказательВР, СчетчикПримечаний)
	
	Если Не ПоказательВР Тогда
		Возврат;
	КонецЕсли;
		
	СправкиРасчеты.ДобавитьПримечание(
		Результат,
		НСтр("ru = 'Сумма налога исчисляется в полных рублях.п. 6 ст. 52 НК РФ'"),
		СчетчикПримечаний);
		
КонецПроцедуры
	
#КонецОбласти

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Ложь);
	Результат.Вставить("ИспользоватьПриВыводеЗаголовка",     Истина);
	Результат.Вставить("ИспользоватьВнешниеНаборыДанных",    Истина);
	Результат.Вставить("ИспользоватьПривилегированныйРежим", Истина);
	
	Возврат Результат;
													
КонецФункции

Функция НайтиПоИмени(Структура, Имя)
	Группировка = Неопределено;
	Для каждого Элемент Из Структура Цикл
		Если ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
		Иначе
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
			Для каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
				Если Не ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
					Если Поле.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
						Возврат Элемент;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Элемент.Структура.Количество() = 0 Тогда
				Продолжить;
			Иначе
				Группировка = НайтиПоИмени(Элемент.Структура, Имя);
				Если Не Группировка = Неопределено Тогда
					Возврат	Группировка;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	Перем ПустойЗапрос;
	
	ЗапросРасчетСтавкиНалогаНаПрибыль = Неопределено;
	НалоговыйУчетОбособленныхПодразделений.ВыполнитьЗапросРасчетСтавкиНалогаНаПрибыльЗаМесяц(
		ЗапросРасчетСтавкиНалогаНаПрибыль, ПараметрыОтчета.Организация, КонецДня(ПараметрыОтчета.КонецПериода));
		
	ЗапросРасчетНалогаНаПрибыль = Неопределено;
	НалоговыйУчетОбособленныхПодразделений.ВыполнитьЗапросРасчетНалогаНаПрибыль(
		ЗапросРасчетНалогаНаПрибыль, ПараметрыОтчета.Организация, КонецДня(ПараметрыОтчета.КонецПериода));
		
	ТекстПустогоЗапроса =
	"ВЫБРАТЬ
	|	НЕОПРЕДЕЛЕНО КАК Организация,
	|	NULL КАК СтавкаСубъектРФ,
	|	NULL КАК СуммаНалогГод,
	|	NULL КАК СуммаНалогМесяц,
	|	NULL КАК СуммаНалогОстальныеМесяцы,
	|	NULL КАК Бюджет,
	|	NULL КАК ДоляНалоговойБазы,
	|	NULL КАК РегистрацияВНалоговомОргане,
	|	NULL КАК ОрганизацияГоловнаяОрганизация,
	|	NULL КАК Ставка,
	|	NULL КАК СуммаНалога,
	|	NULL КАК СуммаБазы";
		
	Если ЗапросРасчетСтавкиНалогаНаПрибыль = Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстПустогоЗапроса;
		ПустойЗапрос = Запрос.Выполнить();
	
		ЗапросРасчетСтавкиНалогаНаПрибыль = ПустойЗапрос;
		
	КонецЕсли;	
	
	Если ЗапросРасчетНалогаНаПрибыль = Неопределено Тогда
		
		Если ПустойЗапрос = Неопределено Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = ТекстПустогоЗапроса;
			ПустойЗапрос = Запрос.Выполнить();
		КонецЕсли;
		
		ЗапросРасчетНалогаНаПрибыль = ПустойЗапрос;
		
	КонецЕсли;	
	
	Возврат Новый Структура("ЗапросРасчетСтавкиНалогаНаПрибыль,ЗапросРасчетНалогаНаПрибыль",
							ЗапросРасчетСтавкиНалогаНаПрибыль,
							ЗапросРасчетНалогаНаПрибыль);
		
КонецФункции	

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", ПараметрыОтчета.НачалоПериода);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		
		Если Не ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
			НачалоМесяца = ПараметрыОтчета.НачалоПериода;
		ИначеЕсли ПараметрыОтчета.НачалоПериода = НачалоМесяца(ПараметрыОтчета.КонецПериода) Тогда
			НачалоМесяца = ПараметрыОтчета.НачалоПериода;
		ИначеЕсли Месяц(ПараметрыОтчета.КонецПериода) = 1 Тогда
			НачалоМесяца = ПараметрыОтчета.НачалоПериода;
		Иначе
			НачалоМесяца = Макс(ПараметрыОтчета.НачалоПериода, НачалоМесяца(ПараметрыОтчета.КонецПериода));
		КонецЕсли;
		
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоМесяца", НачалоМесяца);
		
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,"ПоддержкаПБУ18",УчетнаяПолитика.ПоддержкаПБУ18(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода));
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,"ВключатьОбособленныеПодразделения",ПараметрыОтчета.ВключатьОбособленныеПодразделения);

	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,
														"ИспользуютсяОбособленныеПодразделения",
														БухгалтерскийУчетПереопределяемый.ОбособленноеПодразделение(ПараметрыОтчета.Организация));
														
	БазаРаспределенияКосвенныхРасходовПоВидамДеятельности = УчетнаяПолитика.БазаРаспределенияКосвенныхРасходовПоВидамДеятельности(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	Если ЗначениеЗаполнено(БазаРаспределенияКосвенныхРасходовПоВидамДеятельности) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,"УчитыватьВсеДоходы", 
			БазаРаспределенияКосвенныхРасходовПоВидамДеятельности = 
				Перечисления.БазыРаспределенияКосвенныхРасходовПоВидамДеятельности.ДоходыОтРеализацииИВнереализационные);
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,"УчитыватьВсеДоходы",Истина);
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,"ИспользуетсяЕНВД",Константы.ИспользуетсяЕНВД.Получить());
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НалоговыйУчет",Ложь);	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "БУПРВР",Ложь);	
		ПоказыватьЕНВД = НЕ ПараметрыОтчета["ПоказательНУ"];
	Если НЕ ПоказыватьЕНВД Тогда 
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НалоговыйУчет",Истина);	
	Конецесли;
	Если ПараметрыОтчета["ПоказательВР"] Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "БУПРВР",Истина);	
    КонецЕсли;
	
	// Параметры для заголовков колонок
	// - СтавкаНалогаНаПрибыль
	СтавкаНалогаНаПрибыль = РасчетНалогаНаПрибыль.СуммарнаяУстановленнаяСтавкаНалога(
		ПараметрыОтчета.КонецПериода,
		ПараметрыОтчета.Организация,
		"Процент");
	
	ПараметрыОтчета.Вставить("СтавкаНалогаНаПрибыль", СтавкаНалогаНаПрибыль);
			
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтавкаНалогаНаПрибыль", СтавкаНалогаНаПрибыль);
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	// - СноскаНалоговыйПериод
	СноскаНалоговыйПериод = "";
	СправкиРасчеты.ДополнитьПериодОтчетаПримечанием(СноскаНалоговыйПериод, ПараметрыОтчета);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СноскаНалоговыйПериод", СноскаНалоговыйПериод);
	
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
	МассивПоказателей.Добавить("НУ");
	МассивПоказателей.Добавить("ПР");
	МассивПоказателей.Добавить("ВР");
	
	МассивТаблицОтчета = Новый Массив;
	МассивТаблицОтчета.Добавить("ОсновнаяДеятельность");
	МассивТаблицОтчета.Добавить("НеосновнаяДеятельность");
	МассивТаблицОтчета.Добавить("ОсновнаяДеятельностьЕНВД");
	МассивТаблицОтчета.Добавить("НеосновнаяДеятельностьЕНВД");
	МассивТаблицОтчета.Добавить("УбыткиПрошлыхЛет");
	МассивТаблицОтчета.Добавить("ВсегоОСН");
	МассивТаблицОтчета.Добавить("ВсегоЕНВД");
	
	Для Каждого ИмяТаблицы Из МассивТаблицОтчета Цикл
		
		Группировка = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"Заголовки." + ИмяТаблицы);
		
		//Видимость Таблицы ЕНВД
		Если (СтрНайти(ИмяТаблицы,"ЕНВД") <> 0) и (НЕ ПоказыватьЕНВД) Тогда
			Группировка.Использование = Ложь;
			Продолжить;
		КонецЕсли;	
		
		Таблица = НайтиПоИмени(Группировка.Структура,ИмяТаблицы);
		
		ГруппировкаПоказатель = НайтиПоИмени(Таблица.Строки,"Показатель");
		Отбор = ГруппировкаПоказатель.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		Отбор.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		// Колонка "показатели"
		Если КоличествоПоказателей > 1 Тогда
			Колонка = Таблица.Колонки.Добавить();
			Колонка.Имя           = "Показатели";
			Колонка.Использование = Истина;
			
			ГруппаПоказатели = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ГруппаПоказатели.Использование = Истина;
			ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
			
			Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
				Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ИмяПоказателя);
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;
		
		// Колонка "за текущий месяц"
		//
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = ИмяТаблицы + ".ЗаТекущийМесяц";
		Колонка.Использование = Истина;
		
		//Группа "Доходы"
		ГруппаДоходыМесяц = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаДоходыМесяц.Использование = Истина;
		ГруппаДоходыМесяц.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		ГруппаДоходыМесяц.Заголовок	 = "Доходы без НДС, акцизов и пошлин";
		
		//Группа "Расходы"
		ГруппаРасходыМесяц = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаРасходыМесяц.Использование = Истина;
		ГруппаРасходыМесяц.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		ГруппаРасходыМесяц.Заголовок	 = "Расходы без НДС, акцизов и пошлин";
		
		//Группа "ПрибыльУбыток"
		ГруппаПрибыльУбытокМесяц = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПрибыльУбытокМесяц.Использование = Истина;
		ГруппаПрибыльУбытокМесяц.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		ГруппаПрибыльУбытокМесяц.Заголовок	 = "Прибыль (+) убыток (-) гр.2 - гр.3";
		
		
		// Колонка "за прошлые месяцы года"
		//
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = ИмяТаблицы + ".ЗаПрошлыеМесяцы";
		Колонка.Использование = Истина;
		
		//Группа "Доходы"
		ГруппаДоходыПрошлыеМесяцы = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаДоходыПрошлыеМесяцы.Использование = Истина;
		ГруппаДоходыПрошлыеМесяцы.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		ГруппаДоходыПрошлыеМесяцы.Заголовок	 = "Доходы без НДС, акцизов и пошлин";
		
		//Группа "Расходы"
		ГруппаРасходыПрошлыеМесяцы = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаРасходыПрошлыеМесяцы.Использование = Истина;
		ГруппаРасходыПрошлыеМесяцы.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		ГруппаРасходыПрошлыеМесяцы.Заголовок	 = "Расходы без НДС, акцизов и пошлин";
		
		//Группа "ПрибыльУбыток"
		ГруппаПрибыльУбытокПрошлыеМесяцы = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПрибыльУбытокПрошлыеМесяцы.Использование = Истина;
		ГруппаПрибыльУбытокПрошлыеМесяцы.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		ГруппаПрибыльУбытокПрошлыеМесяцы.Заголовок	 = "Прибыль (+)" + символы.ПС + "убыток (-)" + символы.ПС + "гр.2 - гр.3";
		
		// Колонка "за текущий год"
		//
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = ИмяТаблицы + ".ЗаГод";
		Колонка.Использование = Истина;
		
		//Группа "Доходы"
		ГруппаДоходыГод = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаДоходыГод.Использование = Истина;
		ГруппаДоходыГод.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		ГруппаДоходыГод.Заголовок	 = "Доходы без НДС, акцизов и пошлин";
		
		//Группа "Расходы"
		ГруппаРасходыГод = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаРасходыГод.Использование = Истина;
		ГруппаРасходыГод.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		ГруппаРасходыГод.Заголовок	 = "Расходы без НДС, акцизов и пошлин";
		
		//Группа "ПрибыльУбыток"
		ГруппаПрибыльУбытокГод = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПрибыльУбытокГод.Использование = Истина;
		ГруппаПрибыльУбытокГод.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		ГруппаПрибыльУбытокГод.Заголовок	 = "Прибыль (+)" + символы.ПС + "убыток (-)" + символы.ПС + "гр.2 - гр.3";
		
		ОтборГруппировки = Группировка.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
        ОтборГруппировки.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		ОтборГруппировкиВсего = Группировка.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
        ОтборГруппировкиВсего.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		ОтборГруппировкиВсего.Использование = Ложь;
		
		//Добавляем показатели в группы
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				
				//Показатели текущего месяца
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДоходыМесяц, ИмяТаблицы + ".Доход" + ИмяПоказателя + "Месяц");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаРасходыМесяц, ИмяТаблицы +  ".Расход" + ИмяПоказателя + "Месяц");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПрибыльУбытокМесяц, ИмяТаблицы + ".ПрибыльУбыток" + ИмяПоказателя + "Месяц");
				
				//Строка показывается если хотя бы одна из ВЫВОДИМЫХ сумм не равна нулю
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Отбор, ИмяТаблицы + ".Доход" + ИмяПоказателя + "Месяц",0,ВидСравненияКомпоновкиДанных.НеРавно);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Отбор, ИмяТаблицы + ".Расход" + ИмяПоказателя + "Месяц",0,ВидСравненияКомпоновкиДанных.НеРавно);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Отбор, ИмяТаблицы + ".ПрибыльУбыток" + ИмяПоказателя + "Месяц",0,ВидСравненияКомпоновкиДанных.НеРавно);
				
				//Показатели прошлых месяцев
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДоходыПрошлыеМесяцы, ИмяТаблицы +  ".Доход" + ИмяПоказателя + "ОстальныеМесяцы");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаРасходыПрошлыеМесяцы, ИмяТаблицы +  ".Расход" + ИмяПоказателя + "ОстальныеМесяцы");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПрибыльУбытокПрошлыеМесяцы, ИмяТаблицы +  ".ПрибыльУбыток" + ИмяПоказателя + "ОстальныеМесяцы");
				
				//Строка показывается если хотя бы одна из ВЫВОДИМЫХ сумм не равна нулю
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Отбор, ИмяТаблицы + ".Доход" + ИмяПоказателя + "ОстальныеМесяцы",0,ВидСравненияКомпоновкиДанных.НеРавно);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Отбор, ИмяТаблицы + ".Расход" + ИмяПоказателя + "ОстальныеМесяцы",0,ВидСравненияКомпоновкиДанных.НеРавно);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Отбор, ИмяТаблицы + ".ПрибыльУбыток" + ИмяПоказателя + "ОстальныеМесяцы",0,ВидСравненияКомпоновкиДанных.НеРавно);
				
				//Показатели текущего года
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДоходыГод, ИмяТаблицы +  ".Доход" + ИмяПоказателя + "Год");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаРасходыГод, ИмяТаблицы +  ".Расход" + ИмяПоказателя + "Год");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПрибыльУбытокГод, ИмяТаблицы +  ".ПрибыльУбыток" + ИмяПоказателя + "Год");
				
				//Строка показывается если хотя бы одна из ВЫВОДИМЫХ сумм не равна нулю
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Отбор, ИмяТаблицы + ".Доход" + ИмяПоказателя + "Год",0,ВидСравненияКомпоновкиДанных.НеРавно);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Отбор, ИмяТаблицы + ".Расход" + ИмяПоказателя + "Год",0,ВидСравненияКомпоновкиДанных.НеРавно);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Отбор, ИмяТаблицы + ".ПрибыльУбыток" + ИмяПоказателя + "Год",0,ВидСравненияКомпоновкиДанных.НеРавно);
				
				//Отбор для всей таблицы (если нет данных по выводимым суммам таблица не показывается)
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, ИмяТаблицы + ".Доход" + ИмяПоказателя + "Месяц",0,ВидСравненияКомпоновкиДанных.НеРавно);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, ИмяТаблицы + ".Расход" + ИмяПоказателя + "Месяц",0,ВидСравненияКомпоновкиДанных.НеРавно);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, ИмяТаблицы + ".ПрибыльУбыток" + ИмяПоказателя + "Месяц",0,ВидСравненияКомпоновкиДанных.НеРавно);
				
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, ИмяТаблицы + ".Доход" + ИмяПоказателя + "ОстальныеМесяцы",0,ВидСравненияКомпоновкиДанных.НеРавно);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, ИмяТаблицы + ".Расход" + ИмяПоказателя + "ОстальныеМесяцы",0,ВидСравненияКомпоновкиДанных.НеРавно);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, ИмяТаблицы + ".ПрибыльУбыток" + ИмяПоказателя + "ОстальныеМесяцы",0,ВидСравненияКомпоновкиДанных.НеРавно);
				
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, ИмяТаблицы + ".Доход" + ИмяПоказателя + "Год",0,ВидСравненияКомпоновкиДанных.НеРавно);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, ИмяТаблицы + ".Расход" + ИмяПоказателя + "Год",0,ВидСравненияКомпоновкиДанных.НеРавно);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, ИмяТаблицы + ".ПрибыльУбыток" + ИмяПоказателя + "Год",0,ВидСравненияКомпоновкиДанных.НеРавно);
				
				// Отбор для итоговых таблиц, если есть только один вид деятельности то не нужно выводить таблицу с итогом по всем видам деятельности
				Если СтрНайти(ИмяТаблицы,"Всего") <> 0 Тогда
					
					ОтборГруппировкиВсего.Использование = Истина;
					
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкиВсего, //ЭлементСтруктуры 
							ИмяТаблицы + ".Доход" + ИмяПоказателя + "Месяц", //Поле
							Новый ПолеКомпоновкиДанных("ОсновнаяДеятельность" + ?(СтрНайти(ИмяТаблицы,"ЕНВД") <> 0,"ЕНВД","") + ".Доход" + ИмяПоказателя + "Месяц"), //Значение
							ВидСравненияКомпоновкиДанных.НеРавно); // ВидСравнения
					
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкиВсего, //ЭлементСтруктуры 
							ИмяТаблицы + ".Расход" + ИмяПоказателя + "Месяц", //Поле
							Новый ПолеКомпоновкиДанных("ОсновнаяДеятельность" + ?(СтрНайти(ИмяТаблицы,"ЕНВД") <> 0,"ЕНВД","") + ".Расход" + ИмяПоказателя + "Месяц"), //Значение
							ВидСравненияКомпоновкиДанных.НеРавно); // ВидСравнения
					
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкиВсего,//ЭлементСтруктуры 
							ИмяТаблицы + ".ПрибыльУбыток" + ИмяПоказателя + "Месяц", //Поле
							Новый ПолеКомпоновкиДанных("ОсновнаяДеятельность" + ?(СтрНайти(ИмяТаблицы,"ЕНВД") <> 0,"ЕНВД","") + ".ПрибыльУбыток" + ИмяПоказателя + "Месяц"), //Значение
							ВидСравненияКомпоновкиДанных.НеРавно); // ВидСравнения
					
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкиВсего, //ЭлементСтруктуры  
							ИмяТаблицы + ".Доход" + ИмяПоказателя + "ОстальныеМесяцы", //Поле
							Новый ПолеКомпоновкиДанных( "ОсновнаяДеятельность" + ?(СтрНайти(ИмяТаблицы,"ЕНВД") <> 0,"ЕНВД","") + ".Доход" + ИмяПоказателя + "ОстальныеМесяцы"), //Значение 
							ВидСравненияКомпоновкиДанных.НеРавно); // ВидСравнения
					
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкиВсего, //ЭлементСтруктуры  
							ИмяТаблицы + ".Расход" + ИмяПоказателя + "ОстальныеМесяцы", //Поле
							Новый ПолеКомпоновкиДанных("ОсновнаяДеятельность" + ?(СтрНайти(ИмяТаблицы,"ЕНВД") <> 0,"ЕНВД","") + ".Расход" + ИмяПоказателя + "ОстальныеМесяцы"), //Значение 
							ВидСравненияКомпоновкиДанных.НеРавно); // ВидСравнения
					
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкиВсего, //ЭлементСтруктуры  
							ИмяТаблицы + ".ПрибыльУбыток" "ОстальныеМесяцы", //Поле
							Новый ПолеКомпоновкиДанных( "ОсновнаяДеятельность" + ?(СтрНайти(ИмяТаблицы,"ЕНВД") <> 0,"ЕНВД","") + ".ПрибыльУбыток" + ИмяПоказателя + "ОстальныеМесяцы"), //Значение 
							ВидСравненияКомпоновкиДанных.НеРавно); // ВидСравнения
					
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкиВсего, //ЭлементСтруктуры  
							ИмяТаблицы + ".Доход" + ИмяПоказателя + "Год", //Поле 
							Новый ПолеКомпоновкиДанных("ОсновнаяДеятельность" + ?(СтрНайти(ИмяТаблицы,"ЕНВД") <> 0,"ЕНВД","") + ".Доход" + ИмяПоказателя + "Год"), //Значение 
							ВидСравненияКомпоновкиДанных.НеРавно); // ВидСравнения
					
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкиВсего, //ЭлементСтруктуры 
							ИмяТаблицы + ".Расход" + ИмяПоказателя + "Год", //Поле 
							Новый ПолеКомпоновкиДанных("ОсновнаяДеятельность" + ?(СтрНайти(ИмяТаблицы,"ЕНВД") <> 0,"ЕНВД","") + ".Расход" + ИмяПоказателя + "Год"), //Значение 
							ВидСравненияКомпоновкиДанных.НеРавно); // ВидСравнения
					
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировкиВсего, //ЭлементСтруктуры 
							ИмяТаблицы + ".ПрибыльУбыток" + ИмяПоказателя + "Год", //Поле
							Новый ПолеКомпоновкиДанных("ОсновнаяДеятельность" + ?(СтрНайти(ИмяТаблицы,"ЕНВД") <> 0,"ЕНВД","") + ".ПрибыльУбыток" + ИмяПоказателя + "Год"), //Значение 
							ВидСравненияКомпоновкиДанных.НеРавно); // ВидСравнения
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	//Налог на прибыль
	    ИмяТаблицы = "НалогНаПрибыль";
		
		Группировка = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"Заголовки." + ИмяТаблицы);
		ОтборГруппировки = Группировка.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
        ОтборГруппировки.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		Таблица = НайтиПоИмени(Группировка.Структура,ИмяТаблицы);
		
		Если КоличествоПоказателей > 1 Тогда
			Колонка = Таблица.Колонки.Добавить();
			Колонка.Имя           = "Показатели";
			Колонка.Использование = Истина;
			ГруппаПоказатели = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ГруппаПоказатели.Использование = Истина;
			ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели,"Показатели.БУ");
		КонецЕсли;
		
		// Колонка "за текущий месяц"
		//
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = ИмяТаблицы + ".ЗаТекущийМесяц";
		Колонка.Использование = Истина;
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Колонка.Выбор,ИмяТаблицы + ".НалогМесяц");
		
		// Колонка "за прошлые месяцы года"
		//
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = ИмяТаблицы + ".ЗаПрошлыеМесяцы";
		Колонка.Использование = Истина;
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Колонка.Выбор,ИмяТаблицы + ".НалогОстальныеМесяцы");
		
		// Колонка "за текущий год"
		//
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = ИмяТаблицы + ".ЗаГод";
		Колонка.Использование = Истина;
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Колонка.Выбор,ИмяТаблицы + ".НалогГод");
		
		//Отбор по всей таблице
		Если ПараметрыОтчета.ПоказательНУ Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, ИмяТаблицы + ".НалогМесяц",0,ВидСравненияКомпоновкиДанных.НеРавно);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, ИмяТаблицы + ".НалогОстальныеМесяцы",0,ВидСравненияКомпоновкиДанных.НеРавно);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, ИмяТаблицы + ".НалогГод",0,ВидСравненияКомпоновкиДанных.НеРавно);
		КонецЕсли;
		
		//Отбор на строки таблицы
		Группировка = НайтиПоИмени(Таблица.Строки,"Показатель");
		ОтборСтроки = Группировка.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ОтборСтроки.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборСтроки, ИмяТаблицы + ".НалогМесяц",0,ВидСравненияКомпоновкиДанных.НеРавно);
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборСтроки, ИмяТаблицы + ".НалогОстальныеМесяцы",0,ВидСравненияКомпоновкиДанных.НеРавно);
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборСтроки, ИмяТаблицы + ".НалогГод",0,ВидСравненияКомпоновкиДанных.НеРавно);
		
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	КоличествоВыведенныхПримечаний = 0;
	Если СправкиРасчеты.ТребуетсяДополнитьПериодОтчетаПримечанием(ПараметрыОтчета) Тогда
		КоличествоВыведенныхПримечаний = КоличествоВыведенныхПримечаний + 1;
	КонецЕсли;
	
	Если ПараметрыОтчета.ПоказательНУ Тогда
		НомерРасчетаНалога 	= 6;
		НомерНалога 		= 5;
	Иначе
		НомерРасчетаНалога 	= 9;
		НомерНалога 		= 8;
	Конецесли;	
	
	МакетКомпоновки.Тело[0].Тело[НомерРасчетаНалога].Тело[1].Строки[0].Тело.Удалить(МакетКомпоновки.Тело[0].Тело[НомерРасчетаНалога].Тело[1].Строки[0].Тело[1]);
	Параметры = МакетКомпоновки.Макеты[МакетКомпоновки.Тело[0].Тело[НомерРасчетаНалога].Тело[1].Строки[0].МакетПодвала.Макет].Параметры;
	Параметры.Удалить(Параметры[0]);
	Параметры.Удалить(Параметры[0]);
	Параметры.Удалить(Параметры[0]);
	
	ТелоНалогНаПрибыль = МакетКомпоновки.Тело[0].Тело[НомерНалога];
	Если ТелоНалогНаПрибыль.Имя = "ЗаголовокНалогНаПрибыль" Тогда
		
		ГруппировкаРасчетНалогаНаПрибыль = ТелоНалогНаПрибыль.Тело[1].Строки[0].Тело[0];
		ТелоНалогНаПрибыль.Тело[1].Строки[0].Тело.Удалить(ГруппировкаРасчетНалогаНаПрибыль);
		МакетКомпоновки.Макеты[ТелоНалогНаПрибыль.Тело[1].Строки[0].МакетПодвала.Макет].Макет[0].Ячейки[0].Элементы[0].Значение = "Налог на прибыль";
		
		Если ПараметрыОтчета.ПоказательНУ Тогда
			ГруппировкаРасчетНалогаНаПрибыль = ТелоНалогНаПрибыль.Тело[1].Строки[0].Тело[0];
			ТелоНалогНаПрибыль.Тело[1].Строки[0].Тело.Удалить(ГруппировкаРасчетНалогаНаПрибыль);
		ИначеЕсли Не ПараметрыОтчета.ПоказательВР Тогда
			ТелоНалогНаПрибыль.Тело[1].Строки[0].МакетПодвала.Макет = "";
			ТелоНалогНаПрибыль.Тело[1].Строки[0].МакетПодвала.МакетРесурсов.Очистить();
		Иначе
			
			// Добавим примечание *
			КоличествоВыведенныхПримечаний = КоличествоВыведенныхПримечаний + 1;
			СимволыПримечания = СправкиРасчеты.СимволыПримечания(КоличествоВыведенныхПримечаний);
			
			МакетКомпоновки.Макеты[ТелоНалогНаПрибыль.Тело[1].Строки[0].МакетПодвала.Макет].Макет[0].Ячейки[0].Элементы.Добавить(Тип("ПолеОбластиКомпоновкиДанных")).Значение = СимволыПримечания;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("ПР");
	НаборПоказателей.Добавить("ВР");
	
	Возврат НаборПоказателей;
	
КонецФункции
 
Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийИНалоговыйУчет, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.БухгалтерияПредприятияПодсистемы.Подсистемы.ПростойИнтерфейс.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты, "");
	КонецЦикла;	
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

Функция ВариантыНастроек() Экспорт
	
	Массив = Новый Массив;
	
	Массив.Добавить(Новый Структура("Имя, Представление","РасчетНалогаНаПрибыль", "Расчет налога на прибыль"));
	
	Возврат Массив;
	
КонецФункции


#КонецЕсли