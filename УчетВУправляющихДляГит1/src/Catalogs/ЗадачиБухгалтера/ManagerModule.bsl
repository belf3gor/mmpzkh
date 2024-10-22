#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьТребованиямиНормативныхДокументов() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		// Предопределенные элементы не следует создавать в подчиненных узлах РИБ
 		Возврат;
	КонецЕсли;

	ПредопределенныеПравила = ПредопределенныеПравила();
	Если ПредопределенныеПравила = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗагруженныеЗадачи = Новый Соответствие;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗадачиКалендаряБухгалтера.Код КАК Идентификатор,
	|	ЗадачиКалендаряБухгалтера.Наименование,
	|	ЗадачиКалендаряБухгалтера.Ссылка,
	|	ЗадачиКалендаряБухгалтера.НаименованиеПолное,
	|	ЗадачиКалендаряБухгалтера.РеквизитДопУпорядочивания
	|ПОМЕСТИТЬ ЗадачиБухгалтера
	|ИЗ
	|	Справочник.ЗадачиБухгалтера КАК ЗадачиКалендаряБухгалтера
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗадачиКалендаряБухгалтера.Идентификатор КАК Идентификатор,
	|	ЗадачиКалендаряБухгалтера.Наименование КАК Наименование,
	|	ЗадачиКалендаряБухгалтера.Ссылка КАК Ссылка,
	|	ЗадачиКалендаряБухгалтера.НаименованиеПолное,
	|	ЗадачиКалендаряБухгалтера.РеквизитДопУпорядочивания
	|ИЗ
	|	ЗадачиБухгалтера КАК ЗадачиКалендаряБухгалтера
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗадачиКалендаряБухгалтера.Ссылка КАК Задача,
	|	Требования.Код КАК ИдентификаторТребования,
	|	Требования.Ссылка КАК Требование,
	|	Требования.ДатаИзменения
	|ИЗ
	|	ЗадачиБухгалтера КАК ЗадачиКалендаряБухгалтера
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПравилаПредставленияОтчетовУплатыНалогов КАК Требования
	|		ПО ЗадачиКалендаряБухгалтера.Ссылка = Требования.Владелец";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ЗагруженныеРанееЗадачи = РезультатЗапроса[1].Выгрузить();
	ЗагруженныеРанееЗадачи.Индексы.Добавить("Идентификатор");
	ЗагруженныеРанееТребования = РезультатЗапроса[2].Выгрузить();
	ЗагруженныеРанееЗадачи.Индексы.Добавить("Идентификатор");
	ЗагруженныеРанееТребования.Индексы.Добавить("Задача,ИдентификаторТребования");
	
	Для Каждого НаборТребований Из ПредопределенныеПравила Цикл // Набор описывает требования к выполнению бухгалтером какой-то задачи, например "НДС"
		
		// Синхронизируем справочник ЗадачиБухгалтера
		Выборка = ЗагруженныеРанееЗадачи.НайтиСтроки(Новый Структура("Идентификатор", НаборТребований.Идентификатор));
		
		Если Выборка.Количество() = 0 Тогда
			Объект = Справочники.ЗадачиБухгалтера.СоздатьЭлемент();
			Объект.Код                       = НаборТребований.Идентификатор;
			Объект.Наименование              = НаборТребований.Представление;
			Объект.НаименованиеПолное        = НаборТребований.НаименованиеПолное;
			Объект.РеквизитДопУпорядочивания = НаборТребований.Порядок;
			Объект.Записать();
			Задача = Объект.Ссылка;
		Иначе
			ЗагруженнаяРанееЗадача = Выборка[0];
			Задача = ЗагруженнаяРанееЗадача.Ссылка;
			Если ЗагруженнаяРанееЗадача.Наименование <> НаборТребований.Представление 
				Или ЗагруженнаяРанееЗадача.НаименованиеПолное <> НаборТребований.НаименованиеПолное
				Или ЗагруженнаяРанееЗадача.РеквизитДопУпорядочивания <> НаборТребований.Порядок Тогда
				
				Объект = ЗагруженнаяРанееЗадача.Ссылка.ПолучитьОбъект();
				Объект.Наименование              = НаборТребований.Представление;
				Объект.НаименованиеПолное        = НаборТребований.НаименованиеПолное;
				Объект.РеквизитДопУпорядочивания = НаборТребований.Порядок;
				Объект.Записать();
				
			КонецЕсли;
		КонецЕсли;
		
		// Синхронизируем справочник ПравилаПредставленияОтчетовУплатыНалогов
		
		Для Каждого ОписаниеТребования Из НаборТребований.Требования Цикл
			
			Отбор = Новый Структура;
			Отбор.Вставить("Задача",                  Задача);
			Отбор.Вставить("ИдентификаторТребования", ОписаниеТребования.Идентификатор);
			Выборка = ЗагруженныеРанееТребования.НайтиСтроки(Отбор);
			
			Объект = Неопределено;
			Если Выборка.Количество() = 0 Тогда
				Объект = Справочники.ПравилаПредставленияОтчетовУплатыНалогов.СоздатьЭлемент();
				Объект.Владелец      = Задача;
				Объект.Код           = ОписаниеТребования.Идентификатор;
			Иначе
				ЗагруженноеРанееТребование = Выборка[0];
				Если ЗагруженноеРанееТребование.ДатаИзменения < ОписаниеТребования.ДатаИзменения Тогда
					Объект = ЗагруженноеРанееТребование.Требование.ПолучитьОбъект();
				КонецЕсли;
			КонецЕсли;
			
			Если Объект = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Объект.РеквизитДопУпорядочивания = ОписаниеТребования.Порядок;
			ЗаполнитьЗначенияСвойств(Объект, ОписаниеТребования, , "Условия");
			
			Объект.Условия.Очистить();
			Для Каждого Условие Из ОписаниеТребования.Условия Цикл
				Объект.Условия.Добавить().Условие = Условие;
			КонецЦикла;
			
			Объект.Записать();
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТребованияНормативныхДокументовXML() Экспорт
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	Запись.ЗаписатьОбъявлениеXML();
	
	ПространствоИмен = Метаданные.ПакетыXDTO.ПравилаПредставленияОтчетовУплатыНалогов.ПространствоИмен;
	ТипПравила    = ФабрикаXDTO.Тип(ПространствоИмен, "ПравилаПредставленияОтчетовУплатыНалогов");
	ТипЗадача     = ФабрикаXDTO.Тип(ПространствоИмен, "Задача");
	ТипТребование = ФабрикаXDTO.Тип(ПространствоИмен, "Требование");
	ТипУсловие    = ФабрикаXDTO.Тип(ПространствоИмен, "Условие");
	
	Правила = ФабрикаXDTO.Создать(ТипПравила);
	Правила.ВерсияФормата = "3.0.1.4";
	
	ПредыдущаяВерсияПравил = ПредопределенныеПравила();
	
	ВыборкаЗадачи = Справочники.ЗадачиБухгалтера.Выбрать(,,,"РеквизитДопУпорядочивания");
	Пока ВыборкаЗадачи.Следующий() Цикл
		
		Если ВыборкаЗадачи.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		
		Задача = ФабрикаXDTO.Создать(ТипЗадача);
		Задача.Идентификатор      = ВыборкаЗадачи.Код;
		Задача.Представление      = ВыборкаЗадачи.Наименование;
		
		Задача.НаименованиеПолное = ВыборкаЗадачи.НаименованиеПолное;
		Задача.Порядок            = ВыборкаЗадачи.РеквизитДопУпорядочивания;
		
		ВыборкаТребования = Справочники.ПравилаПредставленияОтчетовУплатыНалогов.Выбрать(,ВыборкаЗадачи.Ссылка,,"РеквизитДопУпорядочивания");
		Пока ВыборкаТребования.Следующий() Цикл
			
			Если ВыборкаТребования.ПометкаУдаления Тогда
				Продолжить;
			КонецЕсли;
			
			Требование = ФабрикаXDTO.Создать(ТипТребование);
			Требование.Идентификатор = ВыборкаТребования.Код;
			Требование.Порядок       = ВыборкаТребования.РеквизитДопУпорядочивания;
			ЗаполнитьЗначенияСвойств(Требование, ВыборкаТребования);
			
			Для Каждого ВыборкаУсловия Из ВыборкаТребования.Условия Цикл 
				
				Если ЗначениеЗаполнено(ВыборкаУсловия.Условие) Тогда
					Требование.Условие.Добавить(ВыборкаУсловия.Условие);
				КонецЕсли;
				
			КонецЦикла;
			
			// Если какие-либо параметры требования отличаются от предыдущей версии,
			// то обновим номер версии
			Если ВерсияТребованияОтличается(ПредыдущаяВерсияПравил, ВыборкаЗадачи.Код, Требование) Тогда
				Требование.ДатаИзменения = НачалоДня(ТекущаяДатаСеанса());
			КонецЕсли;
			
			Задача.Требование.Добавить(Требование);
			
		КонецЦикла;
		
		Правила.Задача.Добавить(Задача);
		
	КонецЦикла;
	
	
	ФабрикаXDTO.ЗаписатьXML(
		Запись, 
		Правила,
		"ПравилаПредставленияОтчетовУплатыНалогов",
		ПространствоИмен,
		,
		НазначениеТипаXML.Явное);
	
	Возврат Запись.Закрыть();
	
КонецФункции

Функция ПредставлениеЗадачи(Задача) Экспорт
	
	Представление = СокрЛП(Задача);
	Представление = ВРег(Лев(Представление, 1)) + Сред(Представление, 2);
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти

#Область ПрикладныеПравила

Функция МожноВыполнятьСверку(ПараметрыКоманды) Экспорт
	
	ЗадачиРосприроднадзора = ЗадачиРосприроднадзора();
	Если ЗадачиРосприроднадзора.Найти(ПараметрыКоманды.ИдентификаторЗадачи) <> Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ПараметрыКоманды.Действие = Перечисления.ВидыДействийКалендаряБухгалтера.УплатаНалога
		ИЛИ ПараметрыКоманды.Действие = Перечисления.ВидыДействийКалендаряБухгалтера.Отчет
			И ПараметрыКоманды.ИдентификаторЗадачи <> "БухгалтерскаяОтчетность"
			И ПараметрыКоманды.ИдентификаторЗадачи <> "СведенияОСреднесписочнойЧисленности"
			И ПараметрыКоманды.ИдентификаторЗадачи <> "СтатистическаяОтчетность";
	
КонецФункции

Функция ЗадачиРосприроднадзора() Экспорт
	
	ЗадачиРосприроднадзора = Новый Массив;
	ЗадачиРосприроднадзора.Добавить("ПлатаЗаНегативноеВоздействиеНаОкружающуюСреду");
	ЗадачиРосприроднадзора.Добавить("ЭкологическийСбор");
	ЗадачиРосприроднадзора.Добавить("Росприроднадзор");
	
	Возврат Новый ФиксированныйМассив(ЗадачиРосприроднадзора);
	
КонецФункции

Процедура ПродлитьСрокНапоминанияПроверитьПереченьФормСтатистики(Правила)
	
	// Оптимальный срок напоминания определен по формам МП (микро) и 1-ИП.
	// Может оказаться, что
	// - предприятию не надо сдавать эти формы, но следует сдать другие, с более поздним сроком
	// - на момент обновления данных о требованиях нормативных документов оптимальный срок уже истек.
	// В этом случае напоминания имеет смысл показывать и дальше - вплоть до крайнего срока,
	// позже которого точно не успеем предоставить никакую из форм отчетности за этот год.
	//
	// Поэтому, если оптимальный срок, указанный в правилах, уже истек,
	// то продлим его до текущей даты, но не позднее, чем крайний срок.
	
	КрайнийСрокНапоминания = '2017-04-01'; // можно еще успеть предоставить ТЗВ-МП
	
	Сегодня = НачалоДня(ТекущаяДатаСеанса());
	
	Если Сегодня > КрайнийСрокНапоминания Тогда
		// уже совсем поздно
		Возврат;
	КонецЕсли;
	
	ОписаниеЗадачи = Правила.Найти("СтатистическаяОтчетность", "Идентификатор");
	Если ОписаниеЗадачи = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИменаТребований = Новый Массив;
	ИменаТребований.Добавить("ПроверитьПереченьФормФизлица");
	ИменаТребований.Добавить("ПроверитьПереченьФормЮрлица");
	
	Для Каждого ИмяТребования Из ИменаТребований Цикл
		
		Требование = ОписаниеЗадачи.Требования.Найти(ИмяТребования, "Идентификатор");
		Если Требование = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ОптимальнаяДата = ДобавитьМесяц('2016-12-31', Требование.СрокМесяцев) + Требование.СрокДней * 24 * 60 * 60;
		
		Если ОптимальнаяДата >= Сегодня Тогда
			// успеваем напомнить вовремя, не надо продлять срок
			Продолжить;
		КонецЕсли;
		
		Требование.СрокМесяцев   = Месяц(Сегодня) - 1;
		Требование.СрокДней      = День(Сегодня);
		Требование.ДатаИзменения = Сегодня; // если продляли срок напоминания, то продленный срок должен остаться и после того, когда пройдет крайний срок
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает реквизиты справочника, которые образуют естественный ключ
//  для элементов справочника.
//
// Возвращаемое значение: Массив(Строка) - массив имен реквизитов, образующих
//  естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив();
	
	Результат.Добавить("Код");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЧтениеФайла // Чтение файла с требованиями нормативных документов

Функция НовыйОписаниеТребования()
	
	ОписаниеСправочника = Метаданные.Справочники.ПравилаПредставленияОтчетовУплатыНалогов;
	ОписаниеРеквизитов  = ОписаниеСправочника.Реквизиты;
	ТипИдентификатора   = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(ОписаниеСправочника.ДлинаКода));
	ТипНаименования     = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(ОписаниеСправочника.ДлинаНаименования));
	
	Требования = Новый ТаблицаЗначений;
	Требования.Колонки.Добавить("Идентификатор",                 ТипИдентификатора); // Строковой идентификатор требования (уникален в пределах задачи)
	Требования.Колонки.Добавить("Наименование",                  ТипНаименования);
	Требования.Колонки.Добавить("Порядок",                       Новый ОписаниеТипов("Число"));
	Требования.Колонки.Добавить("ДатаИзменения",                 ОписаниеРеквизитов.ДатаИзменения.Тип);
	Требования.Колонки.Добавить("ЕстьИнформацияНаИТС",           ОписаниеРеквизитов.ЕстьИнформацияНаИТС.Тип);
	// Условия, в которых следует применять это требование
	Требования.Колонки.Добавить("НачалоДействия",                ОписаниеРеквизитов.НачалоДействия.Тип); // Дата, начиная с которой применяются требования, которые предусматривают это требование
	Требования.Колонки.Добавить("КонецДействия",                 ОписаниеРеквизитов.КонецДействия.Тип); // Дата, по которую применяются требования, которые предусматривают это требование
	Требования.Колонки.Добавить("Условия",                       Новый ОписаниеТипов("Массив")); // Условия, при выполнении которых применяется требование. Выбираются из классификатора КлассификаторУсловий()
	// Способ выполнения требования
	Требования.Колонки.Добавить("Описание",                      ОписаниеРеквизитов.Описание.Тип); // Особая часть представления для пользователя
	Требования.Колонки.Добавить("Действие",                      ОписаниеРеквизитов.Действие.Тип); // Отчет, УплатаНалога
	Требования.Колонки.Добавить("ФинансовыйПериод",              ОписаниеРеквизитов.ФинансовыйПериод.Тип); // Налоговый период (для задач, не связанных с налогами - отчетный период)
	Требования.Колонки.Добавить("РасширенныйПервыйНалоговыйПериод",
                                                                 ОписаниеРеквизитов.РасширенныйПервыйНалоговыйПериод.Тип); // Условие, при котором налоговый (отчетный) период может быть расширен
	Требования.Колонки.Добавить("Периодичность",                 ОписаниеРеквизитов.Периодичность.Тип); // Периодичность выполнения действия в рамках отчетного периода
	Требования.Колонки.Добавить("ОграничениеПериода",            ОписаниеРеквизитов.ОграничениеПериода.Тип); // Периоды (в рамках финансового), в которые действие не следует выполнять
	Требования.Колонки.Добавить("СрокМесяцев",                   ОписаниеРеквизитов.СрокМесяцев.Тип); // Срок выполнения действия после окончания периода, к которому оно относится.
	Требования.Колонки.Добавить("СрокДней",                      ОписаниеРеквизитов.СрокДней.Тип); // Срок выполнения действия после окончания периода, к которому оно относится. 
	Требования.Колонки.Добавить("ПеренестиНаРабочийДень",        ОписаниеРеквизитов.ПеренестиНаРабочийДень.Тип); // -1 - на предыдущий, +1 - на следующий
	
	Требования.Колонки.Добавить("БазовыйПериод",                 ОписаниеРеквизитов.БазовыйПериод.Тип);
	Требования.Колонки.Добавить("ОтставаниеБазовогоПериода",     ОписаниеРеквизитов.ОтставаниеБазовогоПериода.Тип);
	
	Требования.Индексы.Добавить("Идентификатор");
	
	Возврат Требования;
	
КонецФункции

Функция ПредопределенныеПравила()
	
	Макет = Справочники.ЗадачиБухгалтера.ПолучитьМакет("ТребованияНормативныхДокументов");
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Макет.ПолучитьТекст());
	Объект = ФабрикаXDTO.ПрочитатьXML(Чтение);
	
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(Объект.ВерсияФормата, "3.0.2.0") >= 0 Тогда
		Возврат Неопределено; // Неподдерживаемая версия правил
	КонецЕсли;
	
	ДлинаНаименования   = Метаданные.Справочники.ЗадачиБухгалтера.ДлинаНаименования;
	ДлинаИдентификатора = Метаданные.Справочники.ЗадачиБухгалтера.ДлинаКода;
	
	Правила = Новый ТаблицаЗначений;
	Правила.Колонки.Добавить("Идентификатор",      Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(ДлинаИдентификатора)));
	Правила.Колонки.Добавить("Представление",      Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(ДлинаНаименования)));
	Правила.Колонки.Добавить("НаименованиеПолное", Новый ОписаниеТипов("Строка"));
	Правила.Колонки.Добавить("Порядок",            Новый ОписаниеТипов("Число"));
	Правила.Колонки.Добавить("Требования",         Новый ОписаниеТипов("ТаблицаЗначений"));
	Правила.Индексы.Добавить("Идентификатор");
	
	// Читаем тело файла правил
	Для Каждого Задача Из Объект.Задача Цикл
		
		НаборПравил = Правила.Добавить();
		ЗаполнитьЗначенияСвойств(НаборПравил, Задача);
		
		НаборПравил.Требования = НовыйОписаниеТребования();
		
		Для Каждого Требование Из Задача.Требование Цикл
			
			НовоеТребование = НаборПравил.Требования.Добавить();
			ЗаполнитьЗначенияСвойств(НовоеТребование, Требование);
			
			Для Каждого Условие Из Требование.Условие Цикл
				
				НовоеТребование.Условия.Добавить(Условие);
				
			КонецЦикла;
				
		КонецЦикла;
				
	КонецЦикла;
	
	// Квартплата +
	// В состав отчетов "Статистика" необходимо добавить два регл. отчета подсистемы ЖКХ.
	// Для этого находим группу отчетов "Статистическая отчетность" и добавляем в нее отчеты.
	Для каждого Задача Из Правила Цикл
		
		Если Задача.Идентификатор = "СтатистическаяОтчетность" Тогда
			
			// Для добавления отчета в состав правил необходимо определить структуру
			// со свойствами и значениями и заполнить ею новую строку правил.
			// Перечень свойств правил определен в функции НовыйОписаниеТребования().
			
			// Добавим отчет №1-ПУ(ЖКХ).
			СтруктураОтчета_1ПУ_ЖКХ = Новый Структура;
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("Идентификатор",                "2015_1ПУ_ЖКХ");
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("Наименование",                 "Форма 1-ПУ (ЖКХ) ""Сведения о приборах учета потребления коммунальных услуг в жилищном фонде""");
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("Порядок",                       9998);
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("ДатаИзменения",                 '20150819');
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("ЕстьИнформацияНаИТС",           Ложь);
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("Описание",                      "форма 1-ПУ (ЖКХ)");
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("Действие",                      Перечисления.ВидыДействийКалендаряБухгалтера.Отчет);
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("ФинансовыйПериод",              Перечисления.Периодичность.Год);
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("Периодичность",                 Перечисления.Периодичность.Год);
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("СрокМесяцев",                   2); // Срок предоставления - 1 марта после отчетного периода.
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("СрокДней",                      0);
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("СрокМожетЗакончитьсяВВыходной", Истина);
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("БазовыйПериод",                 Перечисления.Периодичность.Год);
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("ОтставаниеБазовогоПериода",     0);
			
			// Условия выполнения правила.
			МассивУсловий = Новый Массив;
			МассивУсловий.Добавить(Перечисления.УсловияПримененияТребованийЗаконодательства.ЮридическиеЛица);
			МассивУсловий.Добавить(Перечисления.УсловияПримененияТребованийЗаконодательства.ПравилоВыбраноПользователем);
			СтруктураОтчета_1ПУ_ЖКХ.Вставить("Условия", МассивУсловий);
			
			// Добавление нового правила и заполнение его свойста.
			ЗаполнитьЗначенияСвойств(Задача.Требования.Добавить(), СтруктураОтчета_1ПУ_ЖКХ);
			
			// Добавим отчет "Сведения о жилфонде"
			СтруктураОтчета_ЖилФонд = Новый Структура;
			СтруктураОтчета_ЖилФонд.Вставить("Идентификатор",                 "2013_1_ЖилФонд");
			СтруктураОтчета_ЖилФонд.Вставить("Наименование",                  "Форма 1-жилфонд ""Сведения о жилищном фонде""");
			СтруктураОтчета_ЖилФонд.Вставить("Порядок",                       9999);
			СтруктураОтчета_ЖилФонд.Вставить("ДатаИзменения",                 '20140919');
			СтруктураОтчета_ЖилФонд.Вставить("ЕстьИнформацияНаИТС",           Ложь);
			СтруктураОтчета_ЖилФонд.Вставить("Описание",                      "форма 1-жилфонд");
			СтруктураОтчета_ЖилФонд.Вставить("Действие",                      Перечисления.ВидыДействийКалендаряБухгалтера.Отчет);
			СтруктураОтчета_ЖилФонд.Вставить("ФинансовыйПериод",              Перечисления.Периодичность.Год);
			СтруктураОтчета_ЖилФонд.Вставить("Периодичность",                 Перечисления.Периодичность.Год);
			СтруктураОтчета_ЖилФонд.Вставить("СрокМесяцев",                   0);
			СтруктураОтчета_ЖилФонд.Вставить("СрокДней",                      55); // Срок предоставления - 25 февраля после отчетного периода.
			СтруктураОтчета_ЖилФонд.Вставить("СрокМожетЗакончитьсяВВыходной", Ложь);
			СтруктураОтчета_ЖилФонд.Вставить("БазовыйПериод",                 Перечисления.Периодичность.Год);
			СтруктураОтчета_ЖилФонд.Вставить("ОтставаниеБазовогоПериода",     0);
			
			// Условия выполнения правила.
			МассивУсловий = Новый Массив;
			МассивУсловий.Добавить(Перечисления.УсловияПримененияТребованийЗаконодательства.ЮридическиеЛица);
			МассивУсловий.Добавить(Перечисления.УсловияПримененияТребованийЗаконодательства.ПравилоВыбраноПользователем);
			СтруктураОтчета_ЖилФонд.Вставить("Условия", МассивУсловий);
			
			// Добавление нового правила и заполнение его свойста.
			ЗаполнитьЗначенияСвойств(Задача.Требования.Добавить(), СтруктураОтчета_ЖилФонд);
			
			// После добавления отчетов правила можно прервать цикл.
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	// Квартплата -
	
	ПродлитьСрокНапоминанияПроверитьПереченьФормСтатистики(Правила);
	
	Возврат Правила;
	
КонецФункции

#КонецОбласти

// Требование - ЗначениеXDTO
Функция ВерсияТребованияОтличается(ПредыдущаяВерсияПравил, ИдентификаторЗадачи, Требование)
	
	Если ПредыдущаяВерсияПравил = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПредыдущаяВерсияНабораТребований = ПредыдущаяВерсияПравил.Найти(ИдентификаторЗадачи, "Идентификатор");
	Если ПредыдущаяВерсияНабораТребований = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПредыдущаяВерсияТребования = ПредыдущаяВерсияНабораТребований.Требования.Найти(Требование.Идентификатор, "Идентификатор");
	Если ПредыдущаяВерсияТребования = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Сравним версии требований
	// Требование - ЗначениеXDTO, ПредыдущаяВерсияТребования - строка таблицы значений
	// Для сравнения версий приведем их к одинаковому формату хранения
	
	НоваяВерсияЗначенияПолей      = Новый Массив;
	ПредыдущаяВерсияЗначенияПолей = Новый Массив;
	
	Поля = ПредыдущаяВерсияНабораТребований.Требования.Колонки;
	Для Каждого ОписаниеПоля Из Поля Цикл
		
		ПредыдущаяВерсияЗначениеПоля = ПредыдущаяВерсияТребования[ОписаниеПоля.Имя];
		
		Если ОписаниеПоля.Имя = "Условия" Тогда
			
			// В XDTO это СписокXDTO. И он отличается именем.
			ЗначенияСписка = Новый Массив;
			Для ИндексЭлемента = 0 По Требование.Условие.Количество() - 1 Цикл
				ЗначенияСписка.Добавить(Требование.Условие.Получить(ИндексЭлемента));
			КонецЦикла;
			НоваяВерсияЗначениеПоля = ЗначенияСписка;
			
		Иначе
			НоваяВерсияЗначениеПоля = Требование[ОписаниеПоля.Имя];
		КонецЕсли;
		
		НоваяВерсияЗначенияПолей.Добавить(НоваяВерсияЗначениеПоля);
		ПредыдущаяВерсияЗначенияПолей.Добавить(ПредыдущаяВерсияЗначениеПоля);
		
	КонецЦикла;
	
	Возврат Не ОбщегоНазначения.ДанныеСовпадают(НоваяВерсияЗначенияПолей, ПредыдущаяВерсияЗначенияПолей);
	
КонецФункции

#КонецОбласти	

#КонецЕсли
