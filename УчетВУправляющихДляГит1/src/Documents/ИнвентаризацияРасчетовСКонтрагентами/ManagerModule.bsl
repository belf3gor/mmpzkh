#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 6, 0);
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Акт инвентаризации расчетов (ИНВ-17)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ИНВ17";
	КомандаПечати.Представление = НСтр("ru = 'Акт инвентаризации расчетов (ИНВ-17)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Приказ о проведении инвентаризации (ИНВ-22)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ИНВ22";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о проведении инвентаризации (ИНВ-22)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Реестр документов ""Акт инвентаризации расчетов""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИНВ17") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ИНВ17", "ИНВ-17 (акт инвентаризации)", 
			ПечатьИНВ17(МассивОбъектов, ОбъектыПечати), , "Документ.ИнвентаризацияРасчетовСКонтрагентами.ПФ_MXL_ИНВ17");
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИНВ22") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ИНВ22", "ИНВ-22 (приказ)", 
			ПечатьИНВ22(МассивОбъектов, ОбъектыПечати), , "ОбщийМакет.ПФ_MXL_ИНВ22");
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	
	
КонецПроцедуры

Функция ПолучитьВыборкуШапок(МассивОбъектов)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Инвентаризация.Ссылка КАК Ссылка,
	|	Инвентаризация.Дата КАК Дата,
	|	Инвентаризация.Номер КАК Номер,
	|	ВЫБОР
	|		КОГДА Инвентаризация.ДокументОснованиеДата = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА Инвентаризация.Дата
	|		ИНАЧЕ Инвентаризация.ДокументОснованиеДата
	|	КОНЕЦ КАК ДатаДокумента,
	|	Инвентаризация.ДокументОснованиеНомер КАК НомерДокумента,
	|	Инвентаризация.Организация КАК Организация,
	|	Инвентаризация.ДатаНачалаИнвентаризации КАК ДатаНачалаИнвентаризации,
	|	Инвентаризация.ДатаОкончанияИнвентаризации КАК ДатаОкончанияИнвентаризации,
	|	Инвентаризация.ДокументОснованиеВид КАК ДокументОснованиеВид,
	|	Инвентаризация.ДокументОснованиеДата КАК ДокументОснованиеДата,
	|	Инвентаризация.ДокументОснованиеНомер КАК ДокументОснованиеНомер,
	|	Инвентаризация.ПричинаПроведенияИнвентаризации КАК ПричинаПроведенияИнвентаризации,
	|	Инвентаризация.ИнвентаризационнаяКомиссия.(
	|		ФизЛицо КАК ФизЛицо,
	|		Председатель КАК Председатель
	|	) КАК ИнвентаризационнаяКомиссия
	|ИЗ
	|	Документ.ИнвентаризацияРасчетовСКонтрагентами КАК Инвентаризация
	|ГДЕ
	|	Инвентаризация.Ссылка В(&МассивСсылок)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Ссылка,
	|	Председатель УБЫВ";
	
	Возврат Запрос.Выполнить().Выбрать();

КонецФункции

Функция ПечатьИНВ17(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб			= Истина;
	ТабДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ИнвентаризацияРасчетовСКонтрагентами_ИНВ17";

	ЗапросКонтрагенты = Новый Запрос;
	ЗапросКонтрагенты.УстановитьПараметр("МассивСсылок", МассивОбъектов);
	
	ЗапросКонтрагенты.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИнвентаризацияКонтрагенты.Контрагент КАК Ссылка,
	|	ИнвентаризацияКонтрагенты.Ссылка.Дата КАК ДатаСведений
	|ПОМЕСТИТЬ КонтрагентыНаДаты
	|ИЗ
	|	Документ.ИнвентаризацияРасчетовСКонтрагентами.Контрагенты КАК ИнвентаризацияКонтрагенты
	|ГДЕ
	|	ИнвентаризацияКонтрагенты.Ссылка В(&МассивСсылок)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонтрагентыНаДаты.Ссылка КАК Ссылка,
	|	КонтрагентыНаДаты.ДатаСведений,
	|	МАКСИМУМ(ИсторияНаименованийКонтрагентов.Период) КАК Период
	|ПОМЕСТИТЬ ДатыСведенийОНаименованияхКонтрагентов
	|ИЗ
	|	КонтрагентыНаДаты КАК КонтрагентыНаДаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты.ИсторияНаименований КАК ИсторияНаименованийКонтрагентов
	|		ПО КонтрагентыНаДаты.Ссылка = ИсторияНаименованийКонтрагентов.Ссылка
	|			И КонтрагентыНаДаты.ДатаСведений >= ИсторияНаименованийКонтрагентов.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	КонтрагентыНаДаты.Ссылка,
	|	КонтрагентыНаДаты.ДатаСведений
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонтрагентыНаДаты.Ссылка КАК Ссылка,
	|	КонтрагентыНаДаты.ДатаСведений,
	|	КонтрагентыНаДаты.Ссылка.Наименование КАК Наименование,
	|	ЕСТЬNULL(ИсторияНаименованийКонтрагентов.НаименованиеПолное, КонтрагентыНаДаты.Ссылка.НаименованиеПолное) КАК НаименованиеПолное
	|ПОМЕСТИТЬ СведенияОНаименованииКонтрагентаНаДату
	|ИЗ
	|	КонтрагентыНаДаты КАК КонтрагентыНаДаты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДатыСведенийОНаименованияхКонтрагентов КАК ДатыСведенийОНаименованияхКонтрагентов
	|		ПО (ДатыСведенийОНаименованияхКонтрагентов.Ссылка = КонтрагентыНаДаты.Ссылка)
	|			И (ДатыСведенийОНаименованияхКонтрагентов.ДатаСведений = КонтрагентыНаДаты.ДатаСведений)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты.ИсторияНаименований КАК ИсторияНаименованийКонтрагентов
	|		ПО (ДатыСведенийОНаименованияхКонтрагентов.Ссылка = ИсторияНаименованийКонтрагентов.Ссылка)
	|			И (ДатыСведенийОНаименованияхКонтрагентов.Период = ИсторияНаименованийКонтрагентов.Период)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КонтрагентыНаДаты.Ссылка,
	|	КонтрагентыНаДаты.ДатаСведений
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Инвентаризация.ВидЗадолженности КАК ВидЗадолженности,
	|	Инвентаризация.Контрагент КАК Контрагент,
	|	ЕСТЬNULL(СведенияОНаименованииКонтрагентаНаДату.НаименованиеПолное, """") КАК КонтрагентНаименованиеПолное,
	|	ЕСТЬNULL(СведенияОНаименованииКонтрагентаНаДату.Наименование, """") КАК КонтрагентНаименование,
	|	Инвентаризация.СчетРасчетов КАК СчетРасчетов,
	|	ПРЕДСТАВЛЕНИЕ(Инвентаризация.СчетРасчетов) КАК СчетРасчетовПредставление,
	|	МИНИМУМ(Инвентаризация.НомерСтроки) КАК НомерСтроки,
	|	СУММА(Инвентаризация.Подтверждено + Инвентаризация.НеПодтверждено) КАК Всего,
	|	СУММА(Инвентаризация.Подтверждено) КАК Подтверждено,
	|	СУММА(Инвентаризация.НеПодтверждено) КАК НеПодтверждено,
	|	СУММА(Инвентаризация.ИстекСрокДавности) КАК ИстекСрокДавности,
	|	Инвентаризация.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ИнвентаризацияРасчетовСКонтрагентами.Контрагенты КАК Инвентаризация
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИнвентаризацияРасчетовСКонтрагентами КАК ИнвентаризацияРасчетовСКонтрагентами
	|		ПО (ИнвентаризацияРасчетовСКонтрагентами.Ссылка = Инвентаризация.Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СведенияОНаименованииКонтрагентаНаДату КАК СведенияОНаименованииКонтрагентаНаДату
	|		ПО (СведенияОНаименованииКонтрагентаНаДату.Ссылка = Инвентаризация.Контрагент)
	|			И (СведенияОНаименованииКонтрагентаНаДату.ДатаСведений = ИнвентаризацияРасчетовСКонтрагентами.Дата)
	|ГДЕ
	|	Инвентаризация.Ссылка В(&МассивСсылок)
	|
	|СГРУППИРОВАТЬ ПО
	|	Инвентаризация.Ссылка,
	|	Инвентаризация.ВидЗадолженности,
	|	Инвентаризация.Контрагент,
	|	ПОДСТРОКА(Инвентаризация.Контрагент.НаименованиеПолное, 1, 200),
	|	Инвентаризация.СчетРасчетов,
	|	ЕСТЬNULL(СведенияОНаименованииКонтрагентаНаДату.НаименованиеПолное, """"),
	|	ЕСТЬNULL(СведенияОНаименованииКонтрагентаНаДату.Наименование, """")
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки,
	|	Инвентаризация.СчетРасчетов.Порядок
	|ИТОГИ
	|	СУММА(Всего),
	|	СУММА(Подтверждено),
	|	СУММА(НеПодтверждено),
	|	СУММА(ИстекСрокДавности)
	|ПО
	|	Ссылка,
	|	ВидЗадолженности";
	
	РезультатКонтрагенты = ЗапросКонтрагенты.Выполнить();
	ВыборкаПоВидуДокумента = РезультатКонтрагенты.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИнвентаризацияРасчетовСКонтрагентами.ПФ_MXL_ИНВ17");
	ПервыйДокумент = Истина;

	ВыборкаШапок = ПолучитьВыборкуШапок(МассивОбъектов);
	Пока ВыборкаШапок.Следующий() Цикл
	
		Если НЕ ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
				
		// Варианты заголовков разделов с подписями печатной формы	
		ЗаголовокРазделаПодписей = Новый Структура();
		ЗаголовокРазделаПодписей.Вставить("ПредседательКомиссии", "Председатель комиссии");
		ЗаголовокРазделаПодписей.Вставить("ЧленыКомиссии",        "Члены комиссии");
		
		// Формирование шапки
		Шапка = Макет.ПолучитьОбласть("Шапка");
		Шапка.Параметры.Заполнить(ВыборкаШапок);
		
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ВыборкаШапок.Организация, ВыборкаШапок.Дата);
		Шапка.Параметры.Организация          = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации);
		Шапка.Параметры.ОрганизацияКодПоОКПО = СведенияОбОрганизации.КодПоОКПО;
		
		Шапка.Параметры.НомерДокумента = ВыборкаШапок.Номер;
		Шапка.Параметры.ДеньДокумента  = День(ВыборкаШапок.Дата);
		Шапка.Параметры.МесяцДокумента = Сред(Формат(ВыборкаШапок.Дата, "ДЛФ=ДД"), 
														 СтрНайти(Формат(ВыборкаШапок.Дата, "ДЛФ=ДД"), " "));
														 
		ТабДокумент.Вывести(Шапка);

		// Формирование строк дебиторской задолженности
		ПодвалТаблицыДт = Макет.ПолучитьОбласть("ПодвалТаблицыДт");
		СтрокаТаблицыДт = Макет.ПолучитьОбласть("СтрокаТаблицыДт");
		
		СтруктураПоиска = Новый Структура("Ссылка", ВыборкаШапок.Ссылка);
		
		Если ВыборкаПоВидуДокумента.НайтиСледующий(СтруктураПоиска) Тогда
			ВыборкаПоВидуЗадолженности = ВыборкаПоВидуДокумента.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Иначе
			Продолжить;
		КонецЕсли;
					
		СтруктураПоиска = Новый Структура("ВидЗадолженности", Перечисления.ВидыЗадолженности.Дебиторская);
				
		Если ВыборкаПоВидуЗадолженности.НайтиСледующий(СтруктураПоиска) Тогда

			ПодвалТаблицыДт.Параметры.Заполнить(ВыборкаПоВидуЗадолженности);
			
			ВыборкаПоКонтрагенту = ВыборкаПоВидуЗадолженности.Выбрать();
			Пока ВыборкаПоКонтрагенту.Следующий() Цикл
				СтрокаТаблицыДт.Параметры.Заполнить(ВыборкаПоКонтрагенту);
				СтрокаТаблицыДт.Параметры.КонтрагентПредставление = ?(ПустаяСтрока(ВыборкаПоКонтрагенту.КонтрагентНаименованиеПолное),
																	ВыборкаПоКонтрагенту.КонтрагентНаименование, 
																	ВыборкаПоКонтрагенту.КонтрагентНаименованиеПолное);
				ТабДокумент.Вывести(СтрокаТаблицыДт);
			КонецЦикла;
			
		КонецЕсли;
	
		ТабДокумент.Вывести(ПодвалТаблицыДт);
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		// Шапка оборотной стороны Акта
		ШапкаОборот = Макет.ПолучитьОбласть("ШапкаОборот");
		ТабДокумент.Вывести(ШапкаОборот);
		
		// Формирование строк кредиторской задолженности
		ПодвалТаблицыКт = Макет.ПолучитьОбласть("ПодвалТаблицыКт");
		СтрокаТаблицыКт = Макет.ПолучитьОбласть("СтрокаТаблицыКт");
				
		ВыборкаПоВидуЗадолженности.Сбросить();
		
		СтруктураПоиска = Новый Структура("ВидЗадолженности", Перечисления.ВидыЗадолженности.Кредиторская);
		
		Если ВыборкаПоВидуЗадолженности.НайтиСледующий(СтруктураПоиска) Тогда
								
			ПодвалТаблицыКт.Параметры.Заполнить(ВыборкаПоВидуЗадолженности);
			
			ВыборкаПоКонтрагенту = ВыборкаПоВидуЗадолженности.Выбрать();
			Пока ВыборкаПоКонтрагенту.Следующий() Цикл
				СтрокаТаблицыКт.Параметры.Заполнить(ВыборкаПоКонтрагенту);
				СтрокаТаблицыКт.Параметры.КонтрагентПредставление = ?(ПустаяСтрока(ВыборкаПоКонтрагенту.КонтрагентНаименованиеПолное),
																		ВыборкаПоКонтрагенту.КонтрагентНаименование, 
																		ВыборкаПоКонтрагенту.КонтрагентНаименованиеПолное);
				ТабДокумент.Вывести(СтрокаТаблицыКт);
			КонецЦикла;
				
		КонецЕсли;
				
		ТабДокумент.Вывести(ПодвалТаблицыКт);
		
		// Подвал печатной формы
		Подвал = Макет.ПолучитьОбласть("Подвал");
		ТабДокумент.Вывести(Подвал);
		
		Подпись = Макет.ПолучитьОбласть("Подпись");
		ТаблицаИнвентаризационнаяКомиссия = ВыборкаШапок.ИнвентаризационнаяКомиссия.Выгрузить();
		
		// Выведем подпись председателя инвентаризационной комиссии
		ПредседательКомиссии = ТаблицаИнвентаризационнаяКомиссия.Найти(Истина, "Председатель");
		
		Если ПредседательКомиссии <> Неопределено Тогда
			
			ДанныеПредседателя = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(ВыборкаШапок.Организация, ПредседательКомиссии.ФизЛицо, ВыборкаШапок.Дата);
				
			Подпись.Параметры.ЗаголовокРазделаПодписей = ЗаголовокРазделаПодписей.ПредседательКомиссии;
			Подпись.Параметры.Должность                = ДанныеПредседателя.Должность;
			Подпись.Параметры.РасшифровкаПодписи       = ДанныеПредседателя.Представление;
			
		Иначе
			
			Подпись.Параметры.ЗаголовокРазделаПодписей = ЗаголовокРазделаПодписей.ПредседательКомиссии;
			Подпись.Параметры.Должность                = "";
			Подпись.Параметры.РасшифровкаПодписи       = "";
			
		КонецЕсли;
			
		ТабДокумент.Вывести(Подпись);
		
		// Выведем подписи членов комиссии
		ВыводитьЗаголовок = Истина;
		
		// Сформируем список членов комиссии
		СписокЧленовКомиссии = Новый Массив();
		
		Для Каждого Строка Из ТаблицаИнвентаризационнаяКомиссия Цикл
			Если НЕ Строка.Председатель Тогда
				СписокЧленовКомиссии.Добавить(Строка.ФизЛицо);
			КонецЕсли;
		КонецЦикла;
		
		ДанныеЧленовКомиссии = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛиц(ВыборкаШапок.Организация, СписокЧленовКомиссии, ВыборкаШапок.Дата);
		
		// Сначала выведем членов комиссии из выборки
		Для Каждого ЧленКомиссии Из ДанныеЧленовКомиссии Цикл
			
			Если НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабДокумент, Подпись) Тогда
				
				// Выведем разрыв страницы
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ВыводитьЗаголовок = Истина; // на новой странице выведем заголовок набора подписей
			
			КонецЕсли;
			
			Подпись.Параметры.ЗаголовокРазделаПодписей = ?(ВыводитьЗаголовок, 
			                                               ЗаголовокРазделаПодписей.ЧленыКомиссии,
														   "");
			Подпись.Параметры.Должность                = ЧленКомиссии.Должность;
			Подпись.Параметры.РасшифровкаПодписи       = ЧленКомиссии.Представление;
			
			ТабДокумент.Вывести(Подпись);
			
			ВыводитьЗаголовок = Ложь; // в следующей итерации вывод заголовка не нужен
			
		КонецЦикла;
		
		// Затем выведем пустые места для подписей (чтобы в итоге получилось не менее 3-х
		// подписей, как в форме, утвержденной Госкомстатом)
		Если ДанныеЧленовКомиссии.Количество() < 3 Тогда
			
			Если НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабДокумент, Подпись) Тогда
				
				// Выведем разрыв страницы
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ВыводитьЗаголовок = Истина; // на новой странице выведем заголовок набора подписей
			
			КонецЕсли;
			
			Для Итератор = (ДанныеЧленовКомиссии.Количество() + 1) По 3 Цикл
				
				Подпись.Параметры.ЗаголовокРазделаПодписей = ?(ВыводитьЗаголовок, 
				                                               ЗаголовокРазделаПодписей.ЧленыКомиссии,
															   "");
				Подпись.Параметры.Должность                = "";
				Подпись.Параметры.РасшифровкаПодписи       = "";
				
				ТабДокумент.Вывести(Подпись);
				
				ВыводитьЗаголовок = Ложь; // в следующей итерации вывод заголовка не нужен
				
			КонецЦикла;
		
		КонецЕсли;

	
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, ВыборкаШапок.Ссылка);

	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПечатьИНВ22(МассивОбъектов, ОбъектыПечати)

	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб			= Истина;
	ТабДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ИнвентаризацияРасчетовСКонтрагентами_ИНВ22";

	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ИНВ22");
	ПервыйДокумент = Истина;

	// Варианты заголовков разделов с подписями печатной формы	
	ЗаголовокРазделаПодписей = Новый Структура();
	ЗаголовокРазделаПодписей.Вставить("ПредседательКомиссии", "Председатель комиссии");
	ЗаголовокРазделаПодписей.Вставить("ЧленыКомиссии",        "Члены комиссии");
	
	// Получаем области макета для вывода в табличный документ
	Шапка   = Макет.ПолучитьОбласть("Шапка");
	Подпись = Макет.ПолучитьОбласть("Подпись");
	Подвал  = Макет.ПолучитьОбласть("Подвал");
	
	ВыборкаШапок = ПолучитьВыборкуШапок(МассивОбъектов);
	Пока ВыборкаШапок.Следующий() Цикл
	
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		ТаблицаИнвентаризационнаяКомиссия = ВыборкаШапок.ИнвентаризационнаяКомиссия.Выгрузить();

		// Выведем шапку документа
		
		Шапка.Параметры.Заполнить(ВыборкаШапок);
		Шапка.Параметры.НаименованиеИмуществаОбязательств = "расчетов с покупателями, поставщиками и прочими дебиторами и кредиторами";
		Если ЗначениеЗаполнено(ВыборкаШапок.НомерДокумента) Тогда
			Шапка.Параметры.НомерДокумента = ВыборкаШапок.НомерДокумента;
		Иначе
			Шапка.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаШапок.Номер, Истина, Ложь);
		КонецЕсли;
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ВыборкаШапок.Организация, ВыборкаШапок.Дата);
		Шапка.Параметры.Организация          = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации);
		Шапка.Параметры.ОрганизацияКодПоОКПО = СведенияОбОрганизации.КодПоОКПО;
		
		ТабДокумент.Вывести(Шапка);
		
		// Выведем подпись председателя инвентаризационной комиссии
		ПредседательКомиссии = ТаблицаИнвентаризационнаяКомиссия.Найти(Истина, "Председатель");
		
		Если ПредседательКомиссии <> Неопределено Тогда
			
			ДанныеПредседателя = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(ВыборкаШапок.Организация, ПредседательКомиссии.ФизЛицо, ВыборкаШапок.Дата);
				
			Подпись.Параметры.ЗаголовокРазделаПодписей = ЗаголовокРазделаПодписей.ПредседательКомиссии;
			Подпись.Параметры.Должность                = ДанныеПредседателя.Должность;
	    	Подпись.Параметры.НаименованиеЧленаКомисси = ПредседательКомиссии.ФизЛицо.Наименование;
			
		Иначе
			
			Подпись.Параметры.ЗаголовокРазделаПодписей = ЗаголовокРазделаПодписей.ПредседательКомиссии;
			Подпись.Параметры.Должность                = "";
			Подпись.Параметры.НаименованиеЧленаКомисси = "";
			
		КонецЕсли;
			
		ТабДокумент.Вывести(Подпись);
		
		// Выведем подписи членов комиссии
		ВыводитьЗаголовок = Истина;
		
		// Сформируем список членов комиссии
		СписокЧленовКомиссии = Новый Массив();
		
		Для Каждого Строка Из ТаблицаИнвентаризационнаяКомиссия Цикл
			Если НЕ Строка.Председатель Тогда
				СписокЧленовКомиссии.Добавить(Строка.ФизЛицо);
			КонецЕсли;
		КонецЦикла;
		
		ДанныеЧленовКомиссии = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛиц(ВыборкаШапок.Организация, СписокЧленовКомиссии, ВыборкаШапок.Дата);
		
		// Сначала выведем членов комиссии из выборки
		Для Каждого ЧленКомиссии Из ДанныеЧленовКомиссии Цикл
			
			Если НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабДокумент, Подпись) Тогда
				
				// Выведем разрыв страницы
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ВыводитьЗаголовок = Истина; // на новой странице выведем заголовок набора подписей
			
			КонецЕсли;
			
			Подпись.Параметры.ЗаголовокРазделаПодписей = ?(ВыводитьЗаголовок, 
			                                               ЗаголовокРазделаПодписей.ЧленыКомиссии,
														   "");
			Подпись.Параметры.Должность                = ЧленКомиссии.Должность;
		    Подпись.Параметры.НаименованиеЧленаКомисси = ЧленКомиссии.Фамилия + " " + ЧленКомиссии.Имя + " " + ЧленКомиссии.Отчество;
			
			ТабДокумент.Вывести(Подпись);
			
			ВыводитьЗаголовок = Ложь; // в следующей итерации вывод заголовка не нужен
			
		КонецЦикла;
		
		// Затем выведем пустые места для подписей (чтобы в итоге получилось не менее 3-х
		// подписей, как в форме, утвержденной Госкомстатом)
		Если ДанныеЧленовКомиссии.Количество() < 3 Тогда
			
			Если НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабДокумент, Подпись) Тогда
				
				// Выведем разрыв страницы
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ВыводитьЗаголовок = Истина; // на новой странице выведем заголовок набора подписей
			
			КонецЕсли;
			
			Для Итератор = (ДанныеЧленовКомиссии.Количество() + 1) По 3 Цикл
				
				Подпись.Параметры.ЗаголовокРазделаПодписей = ?(ВыводитьЗаголовок, 
				                                               ЗаголовокРазделаПодписей.ЧленыКомиссии,
															   "");
				Подпись.Параметры.Должность                = "";
				Подпись.Параметры.НаименованиеЧленаКомисси = "";
				
				ТабДокумент.Вывести(Подпись);
				
				ВыводитьЗаголовок = Ложь; // в следующей итерации вывод заголовка не нужен
				
			КонецЦикла;
		
		КонецЕсли;
		
		// Выведем подвал приказа
		Если НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабДокумент, Подвал) Тогда
			
			// Выведем разрыв страницы
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		Подвал.Параметры.НаименованиеИмуществаОбязательств = "расчеты с покупателями, поставщиками и прочими дебиторами и кредиторами";
		Подвал.Параметры.ДатаНачалаИнвентаризации          = Формат(ВыборкаШапок.ДатаНачалаИнвентаризации, "ДЛФ=DD");
		Подвал.Параметры.ДатаОкончанияИнвентаризации       = Формат(ВыборкаШапок.ДатаОкончанияИнвентаризации, "ДЛФ=DD");
		Подвал.Параметры.ПричинаПроведенияИнвентаризации   = ВыборкаШапок.ПричинаПроведенияИнвентаризации;
		
		Руководители = ОтветственныеЛицаБП.ОтветственныеЛица(ВыборкаШапок.Организация, ВыборкаШапок.Дата);
		Подвал.Параметры.ДолжностьРуководителя          = Руководители.РуководительДолжностьПредставление;
		Подвал.Параметры.РасшифровкаПодписиРуководителя = Руководители.РуководительПредставление;
		
		ТабДокумент.Вывести(Подвал);

		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, ВыборкаШапок.Ссылка);

	КонецЦикла;	
	
	Возврат ТабДокумент;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОВЕРКА ЗАПОЛНЕНИЯ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты, ДокументОбъектИлиФорма = Неопределено, ВФорме = Ложь) Экспорт

	МассивНепроверяемыхРеквизитов = Новый Массив();

	// Если Контрагент или СчетРасчетов не заполнены, то ошибка не выведется, т.к. визуально табличная часть
	//  Контрагенты на форме не представлена. Надо обрабатывать вручную.
	МассивНепроверяемыхРеквизитов.Добавить("Контрагенты.Контрагент");
	МассивНепроверяемыхРеквизитов.Добавить("Контрагенты.СчетРасчетов");

	Если ВФорме Тогда
		Объект = ДокументОбъектИлиФорма.Объект;
		ДокументОбъект = Неопределено;
	Иначе
		Объект = ДокументОбъектИлиФорма;
		ДокументОбъект = ДокументОбъектИлиФорма;
	КонецЕсли;

	// Таблицы значений можно проверить только в форме
	Если ВФорме Тогда
		НомерСтрокиДебиторов  = 0;
		НомерСтрокиКредиторов = 0;
		Для Каждого СтрокаТаблицы Из Объект.Контрагенты Цикл
			// В каждой строке табличной части "Контрагенты" должно быть заполнено или Подтверждено или НеПодтверждено
			Если (СтрокаТаблицы.Подтверждено = 0) И (СтрокаТаблицы.НеПодтверждено = 0) Тогда
				Если СтрокаТаблицы.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
						"Колонка",
						"Корректность",
						НСтр("ru = 'Всего'"),
						НомерСтрокиДебиторов + 1,
						"Дебиторы",
						"Должна быть заполнена хотя бы одна из сумм: Подтверждено или Не подтверждено.");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, "Дебиторы[" + Формат(НомерСтрокиДебиторов, "ЧН=0; ЧГ=") + "].Всего", , Отказ);
				Иначе
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
						"Колонка",
						"Корректность",
						НСтр("ru = 'Всего'"),
						НомерСтрокиКредиторов + 1,
						"Кредиторы",
						"Должна быть заполнена хотя бы одна из сумм: Подтверждено или Не подтверждено.");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, "Кредиторы[" + Формат(НомерСтрокиКредиторов, "ЧН=0; ЧГ=") + "].Всего", , Отказ);
				КонецЕсли;
			КонецЕсли;
			Если СтрокаТаблицы.Контрагент.Пустая() Тогда
				Если СтрокаТаблицы.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
						"Колонка",
						"Заполнение",
						НСтр("ru = 'Контрагент'"),
						НомерСтрокиДебиторов + 1,
						"Дебиторы");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, "Дебиторы[" + Формат(НомерСтрокиДебиторов, "ЧН=0; ЧГ=") + "].Контрагент", , Отказ);
				Иначе
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
						"Колонка",
						"Заполнение",
						НСтр("ru = 'Контрагент'"),
						НомерСтрокиКредиторов + 1,
						"Кредиторы");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, "Кредиторы[" + Формат(НомерСтрокиКредиторов, "ЧН=0; ЧГ=") + "].Контрагент", , Отказ);
				КонецЕсли;
			КонецЕсли;
			Если СтрокаТаблицы.СчетРасчетов.Пустая() Тогда
				Если СтрокаТаблицы.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
						"Колонка",
						"Заполнение",
						НСтр("ru = 'СчетРасчетов'"),
						НомерСтрокиДебиторов + 1,
						"Дебиторы");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, "Дебиторы[" + Формат(НомерСтрокиДебиторов, "ЧН=0; ЧГ=") + "].СчетРасчетов", , Отказ);
				Иначе
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
						"Колонка",
						"Заполнение",
						НСтр("ru = 'СчетРасчетов'"),
						НомерСтрокиКредиторов + 1,
						"Кредиторы");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументОбъект, "Кредиторы[" + Формат(НомерСтрокиКредиторов, "ЧН=0; ЧГ=") + "].СчетРасчетов", , Отказ);
				КонецЕсли;
			КонецЕсли;
			Если СтрокаТаблицы.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
				НомерСтрокиДебиторов  = НомерСтрокиДебиторов + 1;
			Иначе
				НомерСтрокиКредиторов = НомерСтрокиКредиторов + 1;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "ПричинаПроведенияИнвентаризации");
	
	Возврат Результат;
	
КонецФункции

#Область ЗаполнениеПоОстаткам

Функция НовыеПараметрыЗаполнения(Объект) Экспорт
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("АдресХранилищаСОшибками");
	ПараметрыЗаполнения.Вставить("ДатаОкончанияАктуализации", '00010101');
	ПараметрыЗаполнения.Вставить("Контрагенты", Новый Структура);
	
	ПараметрыЗаполнения.Вставить("Организация", Объект.Организация);
	ПараметрыЗаполнения.Вставить("Дата",        Объект.Дата);
	
	МассивСчетов = Новый Массив;
	Для каждого СтрокаСчета Из Объект.СчетаРасчетов Цикл
		Если ЗначениеЗаполнено(СтрокаСчета.СчетРасчетов) И СтрокаСчета.УчаствуетВРасчетах Тогда
			МассивСчетов.Добавить(СтрокаСчета.СчетРасчетов);
		КонецЕсли; 
	КонецЦикла;
	ПараметрыЗаполнения.Вставить("СчетаРасчетов", МассивСчетов);
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

Функция НовыйРезультатЗаполнения() Экспорт
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЗаданиеВыполнено",   Ложь);
	СтруктураПараметров.Вставить("ОткрытьФормуОшибки", Ложь);
	СтруктураПараметров.Вставить("Контрагенты",        Новый Структура);
	
	Возврат СтруктураПараметров;
	
КонецФункции

// Получает таблицы расчетов по задолженностям указанного вида. Предназначена для запуска фоновым заданием.
//
// Параметры:
//  ПараметрыЗаполнения - Структура - см. НовыеПараметрыЗаполнения().
//  АдресХранилища - Строка - место, куда фоновое задание поместит результат.
//
Процедура ЗаполнитьПоОстаткам(ПараметрыЗаполнения, АдресХранилища) Экспорт

	Результат = НовыйРезультатЗаполнения();
	
	Если ЗначениеЗаполнено(ПараметрыЗаполнения.ДатаОкончанияАктуализации) Тогда
		
		ПараметрыРасчета = УчетВзаиморасчетовОтложенноеПроведение.НовыеПараметрыРасчета();
		ПараметрыРасчета.Организация                = ПараметрыЗаполнения.Организация;
		ПараметрыРасчета.ДатаОкончания              = ПараметрыЗаполнения.ДатаОкончанияАктуализации;
		ПараметрыРасчета.АдресХранилищаСОшибками    = ПараметрыЗаполнения.АдресХранилищаСОшибками;
		ПараметрыРасчета.СообщатьПрогрессВыполнения = Ложь;
		
		РезультатРасчета = УчетВзаиморасчетовОтложенноеПроведение.ВыполнитьОтложенныеРасчеты(ПараметрыРасчета);
		Если РезультатРасчета.КоличествоДоговоровСОшибками <> 0 Тогда
			
			// При актуализации возникла ошибка. Необходимо сообщить о ней пользователю.
			Результат.ОткрытьФормуОшибки = Истина;
			ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;	
	
	МассивИсключаемыхСчетов = Новый Массив();
	МассивИсключаемыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.Паи);
	МассивИсключаемыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.Акции);
	МассивИсключаемыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.ДолговыеЦенныеБумаги);
	МассивИсключаемыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.НДСпоАвансамИПредоплатам);
	МассивИсключаемыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.НДСпоАвансамИПредоплатамВыданным);
	МассивИсключаемыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыНДСНалоговогоАгента);
	МассивИсключаемыхСчетов.Добавить(ПланыСчетов.Хозрасчетный.НДСНачисленныйПоОтгрузке);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Дата", Новый Граница(КонецДня(ПараметрыЗаполнения.Дата), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация",             ПараметрыЗаполнения.Организация);
	Запрос.УстановитьПараметр("МассивСчетов",            ПараметрыЗаполнения.СчетаРасчетов);
	Запрос.УстановитьПараметр("МассивИсключаемыхСчетов", МассивИсключаемыхСчетов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Счет,
	|	Хозрасчетный.Вид КАК Вид
	|ПОМЕСТИТЬ МассивСчетов
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&МассивСчетов)
	|	И НЕ Хозрасчетный.Ссылка В (&МассивИсключаемыхСчетов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет";
	Запрос.Выполнить();
	
	ТекстЗапросаЗадолженности =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто1 КАК Справочник.Контрагенты) КАК Контрагент,
	|	ХозрасчетныйОстатки.Счет КАК СчетРасчетов,
	|	СУММА(ВЫБОР
	|			КОГДА МассивСчетов.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
	|					ИЛИ ХозрасчетныйОстатки.СуммаОстатокДт > 0
	|				ТОГДА ХозрасчетныйОстатки.СуммаОстатокДт
	|			ИНАЧЕ ХозрасчетныйОстатки.СуммаОстатокКт
	|		КОНЕЦ) КАК Подтверждено,
	|	СУММА(ВЫБОР
	|			КОГДА МассивСчетов.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
	|					ИЛИ ХозрасчетныйОстатки.СуммаОстатокДт > 0
	|				ТОГДА ХозрасчетныйОстатки.СуммаОстатокДт
	|			ИНАЧЕ ХозрасчетныйОстатки.СуммаОстатокКт
	|		КОНЕЦ) КАК Всего
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&Дата,
	|			Счет В
	|				(ВЫБРАТЬ
	|					МассивСчетов.Счет
	|				ИЗ
	|					МассивСчетов),
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты),
	|			Организация = &Организация) КАК ХозрасчетныйОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МассивСчетов КАК МассивСчетов
	|		ПО ХозрасчетныйОстатки.Счет = МассивСчетов.Счет
	|ГДЕ
	|	&ТекстУсловияВидаЗадолженности
	|
	|СГРУППИРОВАТЬ ПО
	|	ХозрасчетныйОстатки.Счет,
	|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто1 КАК Справочник.Контрагенты)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Контрагент,
	|	СчетРасчетов
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Для каждого ИмяТаблицыЗадолженности Из ПараметрыЗаполнения.Контрагенты Цикл
		
		Если ИмяТаблицыЗадолженности.Ключ = "Дебиторы" Тогда
			ТекстУсловияВидаЗадолженности = "(МассивСчетов.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
		|			ИЛИ ХозрасчетныйОстатки.СуммаОстатокДт > 0)";
		Иначе 
			ТекстУсловияВидаЗадолженности = "(МассивСчетов.Вид = Значение(ВидСчета.Пассивный)
		|			ИЛИ ХозрасчетныйОстатки.СуммаОстатокКт > 0)";
		КонецЕсли;
		Запрос.Текст = СтрЗаменить(ТекстЗапросаЗадолженности, "&ТекстУсловияВидаЗадолженности", ТекстУсловияВидаЗадолженности);
		
		РезультатЗапроса = Запрос.Выполнить();

		Результат.Контрагенты.Вставить(ИмяТаблицыЗадолженности.Ключ, РезультатЗапроса.Выгрузить());
		Результат.ЗаданиеВыполнено = Истина;
	
	КонецЦикла; 
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли