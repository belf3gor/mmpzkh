
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПечати

// Процедура печати листовки о мобильном приложении.
//
Процедура ПечатьЛистовкиМобильноеПриложение(ПараметрыПечати, АдресРезультата) Экспорт
	
	Макет               = УПЖКХ_ТиповыеМетодыСервер.ПолучитьМакет(ПараметрыПечати.ИмяМакета);
	Область             = Макет.ПолучитьОбласть(ПараметрыПечати.ИмяТекущейЛистовки);
	ПараметрыЗаполнения = ПараметрыПечати.ПараметрыЗаполнения;
	РезультатПечати     = Новый ТабличныйДокумент;
	
	Если ПараметрыЗаполнения.ПечататьПерсональныеЛистовки = "Не печатать" Тогда
		
		ПараметрыЗаполнения.Вставить("ТекстИнструкция", "Введите идентификатор, который Вам предоставила Ваша управляющая компания ЖКХ или ТСЖ.");
		
		СформироватьЛистовку(РезультатПечати, Истина, Область, ПараметрыЗаполнения);
		
	Иначе
		
		ТекущаяДата              = ТекущаяДата();
		ТаблицаИдентификаторовЛС = ПолучитьТаблицуИдентификаторовЛицевыхСчетов(ПараметрыЗаполнения);
		МассивЛС                 = ТаблицаИдентификаторовЛС.ВыгрузитьКолонку("ЛицевойСчет");
		ТаблицаВладельцевЛС      = УПЖКХ_ПечатьКвитанцийСервер.ПолучитьТаблицуВладельцевЛицевыхСчетов(ТекущаяДата, МассивЛС);
		
		ПараметрыЗаполнения.Вставить("НомерЛС");
		ПараметрыЗаполнения.Вставить("Идентификатор");
		ПараметрыЗаполнения.Вставить("ФИО");
		ПараметрыЗаполнения.Вставить("Адрес");
		ПараметрыЗаполнения.Вставить("ТекстИнструкция");
		
		ПервыйЭлемент = Истина;
		Для Каждого ТекЛС из ТаблицаИдентификаторовЛС Цикл
			ПодготовитьКПечатиСтруктуруСПараметрами(ПараметрыЗаполнения, ТаблицаВладельцевЛС, ТекЛС, ТекущаяДата);
			СформироватьЛистовку(РезультатПечати, ПервыйЭлемент, Область, ПараметрыЗаполнения);
		КонецЦикла;
		
	КонецЕсли;
	
	АдресРезультата = ПоместитьВоВременноеХранилище(РезультатПечати, АдресРезультата);
	
КонецПроцедуры

// Подготавливает к печати структуру с параметрами, которыми требуется заполнить памятку.
//
Функция ПодготовитьКПечатиСтруктуруСПараметрами(СтруктураПараметров, ТаблицаВладельцевЛС, ТекЛС, ТекущаяДата)
	
	// Базовые сведения по л/с.
	ЛицевойСчет = ТекЛС.ЛицевойСчет;
	
	СтруктураПараметров.НомерЛС       = НомерЛицевогоСчета(ЛицевойСчет);
	СтруктураПараметров.Идентификатор = ТекЛС.Идентификатор;
	
	// ФИО владельца л/с.
	СтрокаВладельцаЛС = ТаблицаВладельцевЛС.Найти(ЛицевойСчет, "ЛицевойСчет");
	Если СтрокаВладельцаЛС = Неопределено Тогда
		ВладелецЛС = "";
	Иначе
		ВладелецЛС = СтрокаВладельцаЛС.Владелец;
	КонецЕсли;
	СтруктураПараметров.ФИО = ВладелецЛС;
	
	// Адрес здания.
	АдресДома = ПолучитьПредставлениеАдресаОбъекта(ТекЛС.Здание, Перечисления.КВП_ВидыАдресов.Здание, ТекущаяДата);
	
	// Адрес помещения.
	Отбор = Новый Структура;
	Отбор.Вставить("Вид", Справочники.ВидыКонтактнойИнформации.УПЖКХ_АдресДоставкиСчетовИКвитанцийЛицевогоСчета);
	СтрокиАдреса = ЛицевойСчет.КонтактнаяИнформация.НайтиСтроки(Отбор);
	Если НЕ СтрокиАдреса.Количество() = 0 Тогда
		АдресДома = СтрокиАдреса[0].Представление;
		Адрес     = Адрес + " (адрес доставки: " + АдресДома + ")";
	Иначе
		Адрес     = ПолучитьАдресПомещения(АдресДома, ТекЛС.Помещение);
	КонецЕсли;
	СтруктураПараметров.Адрес = Адрес;
	
	СтруктураПараметров.ТекстИнструкция = "Для Вашего лицевого счета " + ЛицевойСчет + " введите Ваш персональный идентификатор:";
	
КонецФункции

// Формирует таблицу идентификаторов лицевых счетов.
//
Функция ПолучитьТаблицуИдентификаторовЛицевыхСчетов(ПараметрыЗаполнения)
	
	Если ПараметрыЗаполнения.ПечататьПерсональныеЛистовки = "По всем" Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УПЖКХ_ИдентификаторыЛицевыхСчетовВМобильномПриложении.Идентификатор,
		|	УПЖКХ_ИдентификаторыЛицевыхСчетовВМобильномПриложении.ЛицевойСчет
		|ПОМЕСТИТЬ втИдентификаторыЛС
		|ИЗ
		|	РегистрСведений.УПЖКХ_ИдентификаторыЛицевыхСчетовВМобильномПриложении КАК УПЖКХ_ИдентификаторыЛицевыхСчетовВМобильномПриложении
		|ГДЕ
		|	НЕ УПЖКХ_ИдентификаторыЛицевыхСчетовВМобильномПриложении.ЛицевойСчет = ЗНАЧЕНИЕ(Справочник.КВП_ЛицевыеСчета.ПустаяСсылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УПЖКХ_ОтветственныйСобственникНанимательЛицевогоСчетаСрезПоследних.ЛицевойСчет,
		|	УПЖКХ_ОтветственныйСобственникНанимательЛицевогоСчетаСрезПоследних.ОтветственныйВладелец КАК Владелец
		|ПОМЕСТИТЬ втВладельцы
		|ИЗ
		|	РегистрСведений.УПЖКХ_ОтветственныйСобственникНанимательЛицевогоСчета.СрезПоследних(
		|			,
		|			ЛицевойСчет В
		|				(ВЫБРАТЬ
		|					втИдентификаторыЛС.ЛицевойСчет
		|				ИЗ
		|					втИдентификаторыЛС КАК втИдентификаторыЛС)) КАК УПЖКХ_ОтветственныйСобственникНанимательЛицевогоСчетаСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втИдентификаторыЛС.ЛицевойСчет,
		|	втИдентификаторыЛС.Идентификатор,
		|	втИдентификаторыЛС.ЛицевойСчет.Адрес КАК Помещение,
		|	втИдентификаторыЛС.ЛицевойСчет.Адрес.Владелец КАК Здание,
		|	втВладельцы.Владелец
		|ИЗ
		|	втИдентификаторыЛС КАК втИдентификаторыЛС
		|		ЛЕВОЕ СОЕДИНЕНИЕ втВладельцы КАК втВладельцы
		|		ПО втИдентификаторыЛС.ЛицевойСчет = втВладельцы.ЛицевойСчет";
		Таблица = Запрос.Выполнить().Выгрузить();
		
		Если Таблица.Количество() = 0 Тогда
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю("Для лицевых счетов нет уникальных идентификаторов на сервисе мобильного приложения «ЖКХ: Личный кабинет».
																|Присвоение уникальных идентификаторов происходит при первой выгрузке лицевых счетов на данный сервис
																|в разделе ""Мобильные приложения"" - ""Обмен данными с мобильным приложением ""ЖКХ: Личный кабинет"".");
		КонецЕсли;
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УПЖКХ_ИдентификаторыЛицевыхСчетовВМобильномПриложении.Идентификатор КАК Идентификатор,
		|	УПЖКХ_ИдентификаторыЛицевыхСчетовВМобильномПриложении.ЛицевойСчет КАК ЛицевойСчет
		|ПОМЕСТИТЬ втИдентификаторыЛС
		|ИЗ
		|	РегистрСведений.УПЖКХ_ИдентификаторыЛицевыхСчетовВМобильномПриложении КАК УПЖКХ_ИдентификаторыЛицевыхСчетовВМобильномПриложении
		|ГДЕ
		|	УПЖКХ_ИдентификаторыЛицевыхСчетовВМобильномПриложении.ЛицевойСчет В(&СписокЛС)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УПЖКХ_ОтветственныйСобственникНанимательЛицевогоСчетаСрезПоследних.ЛицевойСчет КАК ЛицевойСчет,
		|	УПЖКХ_ОтветственныйСобственникНанимательЛицевогоСчетаСрезПоследних.ОтветственныйВладелец КАК Владелец
		|ПОМЕСТИТЬ втВладельцы
		|ИЗ
		|	РегистрСведений.УПЖКХ_ОтветственныйСобственникНанимательЛицевогоСчета.СрезПоследних(
		|			,
		|			ЛицевойСчет В
		|				(ВЫБРАТЬ
		|					втИдентификаторыЛС.ЛицевойСчет
		|				ИЗ
		|					втИдентификаторыЛС КАК втИдентификаторыЛС)) КАК УПЖКХ_ОтветственныйСобственникНанимательЛицевогоСчетаСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втИдентификаторыЛС.ЛицевойСчет КАК ЛицевойСчет,
		|	втИдентификаторыЛС.Идентификатор КАК Идентификатор,
		|	втИдентификаторыЛС.ЛицевойСчет.Адрес КАК Помещение,
		|	втИдентификаторыЛС.ЛицевойСчет.Адрес.Владелец КАК Здание,
		|	втВладельцы.Владелец КАК Владелец
		|ИЗ
		|	втИдентификаторыЛС КАК втИдентификаторыЛС
		|		ЛЕВОЕ СОЕДИНЕНИЕ втВладельцы КАК втВладельцы
		|		ПО втИдентификаторыЛС.ЛицевойСчет = втВладельцы.ЛицевойСчет";
		
		Запрос.УстановитьПараметр("СписокЛС", ПараметрыЗаполнения.СписокЛС);
		Таблица = Запрос.Выполнить().Выгрузить();
		
		Если Таблица.Количество() = 0 Тогда
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю("Для выбранных лицевых счетов нет уникальных идентификаторов на сервисе мобильного приложения «ЖКХ: Личный кабинет».");
		Иначе
			Для Каждого ТекущийЛС Из ПараметрыЗаполнения.СписокЛС Цикл
				Если Таблица.НайтиСтроки(Новый Структура("ЛицевойСчет", ТекущийЛС.Значение)).Количество() = 0 Тогда
					УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю("Для лицевого счета """ + Строка(ТекущийЛС.Значение) + """ нет уникального идентификатора на сервисе мобильного приложения «ЖКХ: Личный кабинет».");
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Таблица;
	
КонецФункции

// Формирует текущую листовку.
//
Процедура СформироватьЛистовку(РезультатПечати, ПервыйЭлемент, Область, СтруктураПараметров)
	
	Если ПервыйЭлемент Тогда
		ПервыйЭлемент = Ложь;
	Иначе
		РезультатПечати.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	
	Область.Параметры.Заполнить(СтруктураПараметров);
	
	РезультатПечати.Вывести(Область);
	РезультатПечати.АвтоМасштаб        = Истина;
	РезультатПечати.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли