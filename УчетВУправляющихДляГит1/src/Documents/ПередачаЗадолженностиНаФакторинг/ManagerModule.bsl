#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 20, 0);
	
КонецФункции

Процедура ЗадолженностьКонтрагента(СтруктураПараметров, АдресХранилища) Экспорт
	
	СтруктураДанныхЗаполнения = Новый Структура();
	СтруктураДанныхЗаполнения.Вставить("Успешно", Истина);
	
	Если НЕ ПроверитьОтложенныеРасчеты(СтруктураПараметров) Тогда
		СтруктураДанныхЗаполнения.Успешно = Ложь;
		ПоместитьВоВременноеХранилище(СтруктураПараметров, АдресХранилища);
		Возврат;
	КонецЕсли;
	
	СчетаУчетаРасчетов = БухгалтерскиеОтчеты.СчетаУчетаРасчетовПокупателей();
	СчетаРасчетовСАналитикойПоДокументам = СчетаУчетаРасчетов.СчетаСДокументомРасчетов;
	СчетаРасчетовБезАналитикиПоДокументам = СчетаУчетаРасчетов.СчетаБезДокументаРасчетов;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", СтруктураПараметров.Организация);
	Запрос.УстановитьПараметр("Контрагент",  СтруктураПараметров.Контрагент);
	Запрос.УстановитьПараметр("Договор",     СтруктураПараметров.Договор);
	Запрос.УстановитьПараметр("СчетаРасчетовСАналитикойПоДокументам",  СчетаРасчетовСАналитикойПоДокументам);
	Запрос.УстановитьПараметр("СчетаРасчетовБезАналитикиПоДокументам", СчетаРасчетовБезАналитикиПоДокументам);
	ВидыСубконтоБезДокументов = Новый Массив();
	ВидыСубконтоБезДокументов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоБезДокументов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	Запрос.УстановитьПараметр("ВидыСубконтоБезДокументов",ВидыСубконтоБезДокументов);
	Если СтруктураПараметров.ЭтоНовый Тогда
		Запрос.УстановитьПараметр("Период", Новый МоментВремени(КонецДня(СтруктураПараметров.Дата), СтруктураПараметров.Ссылка));
	Иначе
		Запрос.УстановитьПараметр("Период", Новый МоментВремени(СтруктураПараметров.Дата, СтруктураПараметров.Ссылка));
	КонецЕсли;
	
	ВидыСубконтоСДокументами = Новый Массив();
	ВидыСубконтоСДокументами.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоСДокументами.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	ВидыСубконтоСДокументами.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами);
	Запрос.УстановитьПараметр("ВидыСубконтоСДокументами", ВидыСубконтоСДокументами);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Счет КАК СчетУчетаРасчетов,
		|	НЕОПРЕДЕЛЕНО КАК Сделка,
		|	ХозрасчетныйОстатки.СуммаОстаток КАК Сумма
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период,
		|			Счет В (&СчетаРасчетовБезАналитикиПоДокументам)
		|				И НЕ Счет.Валютный,
		|			&ВидыСубконтоБезДокументов,
		|			Организация = &Организация
		|				И Субконто1 = &Контрагент
		|				И Субконто2 = &Договор) КАК ХозрасчетныйОстатки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Счет,
		|	ХозрасчетныйОстатки.Субконто3,
		|	ХозрасчетныйОстатки.СуммаОстаток
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период,
		|			Счет В (&СчетаРасчетовСАналитикойПоДокументам)
		|				И НЕ Счет.Валютный,
		|			&ВидыСубконтоСДокументами,
		|			Организация = &Организация
		|				И Субконто1 = &Контрагент
		|				И Субконто2 = &Договор) КАК ХозрасчетныйОстатки";
	
	ТаблицаДебиторскаяЗадолженность = Запрос.Выполнить().Выгрузить();
	
	СтруктураДанныхЗаполнения.Вставить("ДебиторскаяЗадолженность", ТаблицаДебиторскаяЗадолженность);
	ПоместитьВоВременноеХранилище(СтруктураДанныхЗаполнения, АдресХранилища);
	
КонецПроцедуры

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

#Область ПодготовкаПараметровПроведения

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
	
	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("СтатьяПрочиеДоходыИРасходы", 
		ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ПрочиеДоходыИРасходы.УступкаПраваТребованияПоДоговоруФакторинга"));
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	Результат    = Запрос.ВыполнитьПакет();
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаДебиторскаяЗадолженность(НомераТаблиц)
		+ ТекстЗапросаРеквизитыДокументаИП(НомераТаблиц)
		+ ТекстЗапросаДебиторскаяЗадолженностьИП(НомераТаблиц)
		+ ТекстЗапросаРегистрацияОтложенныхРасчетовСКонтрагентами(НомераТаблиц, ПараметрыПроведения, Реквизиты);
		
	Результат = Запрос.ВыполнитьПакет();
	
	Если НЕ ПустаяСтрока(Запрос.Текст) Тогда
		Для Каждого НомерТаблицы Из НомераТаблиц Цикл
			ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
		КонецЦикла;
	КонецЕсли;
	
	Возврат ПараметрыПроведения;
КонецФункции 

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)
	
	НомераТаблиц.Вставить("ВременнаяТаблицаРеквизиты", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПередачаЗадолженностиНаФакторинг.Ссылка КАК Регистратор,
	|	ПередачаЗадолженностиНаФакторинг.Дата КАК Период,
	|	ПередачаЗадолженностиНаФакторинг.Организация КАК Организация,
	|	ПередачаЗадолженностиНаФакторинг.Контрагент КАК Контрагент,
	|	ПередачаЗадолженностиНаФакторинг.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ПередачаЗадолженностиНаФакторинг.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|	&СтатьяПрочиеДоходыИРасходы КАК СтатьяПрочиеДоходыИРасходы,
	|	ПередачаЗадолженностиНаФакторинг.ФакторинговаяКомпания КАК ФакторинговаяКомпания,
	|	ПередачаЗадолженностиНаФакторинг.ДоговорФакторинга КАК ДоговорФакторинга,
	|	ПередачаЗадолженностиНаФакторинг.СуммаДокумента КАК СуммаДокумента
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.ПередачаЗадолженностиНаФакторинг КАК ПередачаЗадолженностиНаФакторинг
	|ГДЕ
	|	ПередачаЗадолженностиНаФакторинг.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.Регистратор КАК Регистратор,
	|	Реквизиты.Период КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.Контрагент КАК Контрагент,
	|	Реквизиты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	Реквизиты.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|	Реквизиты.СтатьяПрочиеДоходыИРасходы КАК СтатьяПрочиеДоходыИРасходы,
	|	Реквизиты.ФакторинговаяКомпания КАК ФакторинговаяКомпания,
	|	Реквизиты.ДоговорФакторинга КАК ДоговорФакторинга,
	|	Реквизиты.СуммаДокумента КАК СуммаДокумента
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	
	Возврат ТекстЗапроса;
КонецФункции

Функция ТекстЗапросаДебиторскаяЗадолженность(НомераТаблиц)
	
	НомераТаблиц.Вставить("ДебиторскаяЗадолженность", НомераТаблиц.Количество());
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ПередачаЗадолженностиНаФакторингДебиторскаяЗадолженность.Сделка КАК Сделка,
	|	ПередачаЗадолженностиНаФакторингДебиторскаяЗадолженность.Сумма КАК Сумма,
	|	ПередачаЗадолженностиНаФакторингДебиторскаяЗадолженность.СчетУчетаРасчетов КАК СчетУчетаРасчетов
	|ИЗ
	|	Документ.ПередачаЗадолженностиНаФакторинг.ДебиторскаяЗадолженность КАК ПередачаЗадолженностиНаФакторингДебиторскаяЗадолженность
	|ГДЕ
	|	ПередачаЗадолженностиНаФакторингДебиторскаяЗадолженность.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
КонецФункции

Функция ТекстЗапросаРеквизитыДокументаИП(НомераТаблиц)
	
	НомераТаблиц.Вставить("РеквизитыДокументаИП", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПередачаЗадолженностиНаФакторинг.Ссылка КАК Регистратор,
	|	ПередачаЗадолженностиНаФакторинг.Дата КАК Период,
	|	ПередачаЗадолженностиНаФакторинг.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировкаДолга.Прочее) КАК ВидОперации
	|ИЗ
	|	Документ.ПередачаЗадолженностиНаФакторинг КАК ПередачаЗадолженностиНаФакторинг
	|ГДЕ
	|	ПередачаЗадолженностиНаФакторинг.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаДебиторскаяЗадолженностьИП(НомераТаблиц)
	
	НомераТаблиц.Вставить("ДебиторскаяЗадолженностьИП", НомераТаблиц.Количество());
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ПередачаЗадолженностиНаФакторингДебиторскаяЗадолженность.Сделка КАК ДокументРасчетов,
	|	ПередачаЗадолженностиНаФакторингДебиторскаяЗадолженность.Сумма КАК СуммаБУ,
	|	ПередачаЗадолженностиНаФакторингДебиторскаяЗадолженность.СчетУчетаРасчетов КАК СчетУчетаРасчетов
	|ИЗ
	|	Документ.ПередачаЗадолженностиНаФакторинг.ДебиторскаяЗадолженность КАК ПередачаЗадолженностиНаФакторингДебиторскаяЗадолженность
	|ГДЕ
	|	ПередачаЗадолженностиНаФакторингДебиторскаяЗадолженность.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

#КонецОбласти

#Область ФормированиеДвижений

Функция ПодготовитьПараметрыПередачаЗадолженностиНаФакторинг(ТаблицаДебиторскаяЗадолженность, ТаблицаРеквизиты)
	
	Параметры = Новый Структура;
	
	// Подготовка таблицы шапки документа.
	СписокОбязательныхКолонок = ""
	+ "Период,"         	// <Дата> - дата докумета, записывающего движения
	+ "Регистратор,"    	// <Регистратор> - документ, записывающий движения в регистры
	+ "Организация,"		// <СправочникСсылка.Организации> - организация документа
	+ "Контрагент,"			// <СправочникСсылка.Контрагенты> - контрагент, задолженность которого уступается фактору
	+ "ДоговорКонтрагента," // <СправочникСсылка.Договора> - договор контрагента, задолжность по которому уступается фактору
	+ "ФакторинговаяКомпания," // <СправочникСсылка.Контрагенты> - контрагент, который выступает в качестве факторинговой компании
	+ "ДоговорФакторинга,"	// <СправочникСсылка.Договора> - договор контрагента, на основании которого осуществляется передача задолженности.
	+ "ПодразделениеОрганизации," // <Ссылка на справочник подразделений>
	+ "СтатьяПрочиеДоходыИРасходы" // <СправочникСсылка.ПрочиеДоходыРасходы> - статья доходов/расходов для операции факторинга
	;
	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаРеквизиты, СписокОбязательныхКолонок));

	// Подготовка таблицы товаров документа, по которым проводится переоценка.
	СписокОбязательныхКолонок = ""
	+ "Сделка,"      // <ДокументСсылка.РеализацияТоваровУслуг> - Документ, по которому возникается задолженность контрагента
	+ "Сумма,"       // <Число(15,2)> - сумма финансирования в валюте регламентированного учета
	+ "СчетУчетаРасчетов" // <ПланСчетов.Хозрасчетный> - счет расчетов с контрагентом
	;
	Параметры.Вставить("ТаблицаДебиторскаяЗадолженность", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаДебиторскаяЗадолженность, СписокОбязательныхКолонок));

	Возврат Параметры;

КонецФункции

Процедура СформироватьДвиженияПередачаЗадолженностиНаФакторинг(ТаблицаДебиторскаяЗадолженность, ТаблицаРеквизиты, Движения, Отказ) Экспорт
	
	Параметры = ПодготовитьПараметрыПередачаЗадолженностиНаФакторинг(ТаблицаДебиторскаяЗадолженность, ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Параметры.Реквизиты[0]);
	
	// 1. Возникновение обязательства по договору факторинга.
	Проводка = Движения.Хозрасчетный.Добавить();
	
	Проводка.Период       = Реквизиты.Период;
	Проводка.Организация  = Реквизиты.Организация;
	Проводка.Содержание   = НСтр("ru = 'Отражены доходы от уступки права требования долга по договору факторинга'");
	
	Проводка.СчетДт = ПланыСчетов.Хозрасчетный.РасчетыСФакторинговымиКомпаниями;
	БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Контрагенты", Реквизиты.ФакторинговаяКомпания);
	БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Договоры", Реквизиты.ДоговорФакторинга);
	
	СвойстваСчетаДт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетДт);
	Если СвойстваСчетаДт.УчетПоПодразделениям Тогда
		Проводка.ПодразделениеДт = Реквизиты.ПодразделениеОрганизации;
	КонецЕсли;
	
	Проводка.СчетКт = ПланыСчетов.Хозрасчетный.ПрочиеДоходы;
	БухгалтерскийУчет.УстановитьСубконто(
		Проводка.СчетКт, Проводка.СубконтоКт, "ПрочиеДоходыИРасходы", Реквизиты.СтатьяПрочиеДоходыИРасходы);
	СвойстваСчетаКт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетКт);
	Если СвойстваСчетаКт.УчетПоПодразделениям Тогда
		Проводка.ПодразделениеКт = Реквизиты.ПодразделениеОрганизации;
	КонецЕсли;
	
	Проводка.Сумма = Параметры.ТаблицаДебиторскаяЗадолженность.Итог("Сумма");
	
	Для каждого СтрокаТаблицы Из Параметры.ТаблицаДебиторскаяЗадолженность Цикл
		
		// 2. Списание задолженности контрагента.
		Проводка = Движения.Хозрасчетный.Добавить();
		
		Проводка.Период       = Реквизиты.Период;
		Проводка.Организация  = Реквизиты.Организация;
		Проводка.Содержание   = НСтр("ru = 'Отражены расходы в виде суммы уступленного требования по договору факторинга'");
	
		Проводка.СчетДт = ПланыСчетов.Хозрасчетный.ПрочиеРасходы;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "ПрочиеДоходыИРасходы", Реквизиты.СтатьяПрочиеДоходыИРасходы);
		СвойстваСчетаДт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетДт);
		Если СвойстваСчетаДт.УчетПоПодразделениям Тогда
			Проводка.ПодразделениеДт = Реквизиты.ПодразделениеОрганизации;
		КонецЕсли;
		
		Проводка.СчетКт = СтрокаТаблицы.СчетУчетаРасчетов;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", Реквизиты.Контрагент);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Договоры", Реквизиты.ДоговорКонтрагента);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "ДокументыРасчетовСКонтрагентами", СтрокаТаблицы.Сделка);
		
		СвойстваСчетаКт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетКт);
		Если СвойстваСчетаКт.УчетПоПодразделениям Тогда
			Проводка.ПодразделениеКт = Реквизиты.ПодразделениеОрганизации;
		КонецЕсли;
		
		Проводка.Сумма = СтрокаТаблицы.Сумма;
		
	КонецЦикла;
	
	Движения.Хозрасчетный.Записывать = Истина;
	
КонецПроцедуры

Функция ПодготовитьПараметрыФормированияПрочиеРасчеты(ТаблицаРеквизиты, ТаблицаВзаиморасчеты)
	
	Параметры = Новый Структура;
	
	// Подготовка таблицы Взаиморасчеты
	СписокОбязательныхКолонок = ""
	+ "Сделка,"	// <ДокументСсылка.*>
	+ "Сумма"	// <Число, 15, 2> - сумма выручки с НДС в рублях
	;
	Параметры.Вставить("ТаблицаВзаиморасчетов", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаВзаиморасчеты, СписокОбязательныхКолонок));
		
	// Подготовка таблицы Взаиморасчеты
	СписокОбязательныхКолонок = ""
	+ "Организация,"				// <СправочникСсылка.Организации>
	+ "Период,"						// <Дата>
	+ "Регистратор,"				// <ДокументСсылка>
	+ "Контрагент,"					// <СправочникСсылка.Контрагенты>
	+ "ДоговорКонтрагента,"			// <СправочникСсылка.ДоговорыКонтрагентов>
	+ "ФакторинговаяКомпания,"		// <СправочникСсылка.Контрагенты>
	+ "ДоговорФакторинга,"			// <СправочникСсылка.ДоговорыКонтрагентов>
	+ "СуммаДокумента"				// <Число, 15, 2>
	;
	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаРеквизиты, СписокОбязательныхКолонок));
	
	Возврат Параметры;

КонецФункции 

Функция ПодготовитьТаблицуПрочиеРасчетыИП(ТаблицаРеквизиты, ТаблицаВзаиморасчеты, Отказ) Экспорт
	
	Результат = УчетВзаиморасчетов.ПустаяТаблицаПоПрочимРасчетам();
	
	Если Не ЗначениеЗаполнено(ТаблицаРеквизиты) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Реквизиты = ТаблицаРеквизиты[0];
	Организация = Реквизиты.Организация;
	Период      = Реквизиты.Период;
	
	Если Не УчетнаяПолитика.ПлательщикНДФЛ(Организация, Период) Тогда
		Возврат Результат;
	КонецЕсли;
	
	СпособОценкиТоваровВРознице = УчетнаяПолитика.СпособОценкиТоваровВРознице(Организация, Период);
	Если Не УчетнаяПолитика.ПрименяетсяУСНПатент(Организация, Период)
	   И СпособОценкиТоваровВРознице = Перечисления.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости Тогда
		// Отражение выручки в НТТ при учете по продажным ценам в КУДиР ИП на ОСНО не поддерживается.
		Возврат Результат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыФормированияПрочиеРасчеты(ТаблицаРеквизиты, ТаблицаВзаиморасчеты);
	ТаблицаВзаиморасчетов = Параметры.ТаблицаВзаиморасчетов;
	
	Реквизиты = Параметры.Реквизиты[0];
	Регистратор           = Реквизиты.Регистратор;
	СуммаДокумента        = Реквизиты.СуммаДокумента;
	СчетУчета             = ПланыСчетов.Хозрасчетный.РасчетыСФакторинговымиКомпаниями;
	ФакторинговаяКомпания = Реквизиты.ФакторинговаяКомпания;
	ДоговорФакторинга     = Реквизиты.ДоговорФакторинга;
	
	СуммаДляРаспределения = СуммаДокумента;
	
	Для Каждого СтрокаВзаиморасчетов Из ТаблицаВзаиморасчетов Цикл
		
		РаспределеннаяСумма = Мин(СуммаДляРаспределения, СтрокаВзаиморасчетов.Сумма);
		Если СуммаДляРаспределения = 0 Тогда
			Прервать;
		КонецЕсли;
		
		НоваяСтрока = Результат.Добавить();
		НоваяСтрока.Организация = Организация;
		НоваяСтрока.Регистратор = Регистратор;
		НоваяСтрока.Период      = Период;
		НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Приход;
		НоваяСтрока.СчетУчета   = СчетУчета;
		НоваяСтрока.Сумма       = РаспределеннаяСумма;
		
		НоваяСтрока.Контрагент         = ФакторинговаяКомпания;
		НоваяСтрока.ДоговорКонтрагента = ДоговорФакторинга;
		НоваяСтрока.РасчетныйДокумент  = СтрокаВзаиморасчетов.Сделка;
		
		СуммаДляРаспределения = СуммаДляРаспределения - РаспределеннаяСумма;
		
	КонецЦикла;
	
	Если СуммаДляРаспределения > 0 Тогда
		
		НоваяСтрока = Результат.Добавить();
		
		НоваяСтрока.Организация = Организация;
		НоваяСтрока.Регистратор = Регистратор;
		НоваяСтрока.Период      = Период;
		НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Приход;
		
		НоваяСтрока.Контрагент         = ФакторинговаяКомпания;
		НоваяСтрока.ДоговорКонтрагента = ДоговорФакторинга;
		НоваяСтрока.СчетУчета          = СчетУчета;
		
		НоваяСтрока.РасчетныйДокумент  = Регистратор;
		НоваяСтрока.Сумма              = СуммаДляРаспределения;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОтложенноеПроведение

Функция ПроверитьОтложенныеРасчеты(СтруктураПараметров)

	УстановитьПривилегированныйРежим(Истина);

	ПараметрыРасчета = УчетВзаиморасчетовОтложенноеПроведение.НовыеПараметрыРасчета();
	ПараметрыРасчета.Организация             = СтруктураПараметров.Организация;
	ПараметрыРасчета.ДатаОкончания           = СтруктураПараметров.Дата;
	ПараметрыРасчета.Контрагент              = СтруктураПараметров.Контрагент;
	ПараметрыРасчета.ДоговорКонтрагента      = СтруктураПараметров.Договор;
	
	Результат = УчетВзаиморасчетовОтложенноеПроведение.ВыполнитьОтложенныеРасчеты(ПараметрыРасчета);
	
	Возврат Результат.КоличествоДоговоровСОшибками = 0;

КонецФункции

Функция ТекстЗапросаРегистрацияОтложенныхРасчетовСКонтрагентами(НомераТаблиц, ПараметрыПроведения, Реквизиты)
	
	Если НЕ ПроведениеСервер.ИспользуетсяОтложенноеПроведение(Реквизиты.Организация, Реквизиты.Период) Тогда
		ПараметрыПроведения.Вставить("РасчетыСКонтрагентамиОтложенноеПроведение", Неопределено);
		Возврат "";
	КонецЕсли;
	
	НомераТаблиц.Вставить("РасчетыСКонтрагентамиОтложенноеПроведение", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Контрагент КАК Контрагент,
	|	Реквизиты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	Реквизиты.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	Реквизиты.ДоговорКонтрагента.ВидДоговора КАК ВидДоговора,
	|	Реквизиты.Период КАК Дата
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

#КонецОбласти

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Передача задолженности на факторинг""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
	
КонецПроцедуры

Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, НастройкиОбъекта) Экспорт

	

КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Контрагент");
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли