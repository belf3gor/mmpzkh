#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура СформироватьОтчетРасшифровку(Параметры, ДокументРезультат) Экспорт
	
	ИмяПоля = Лев(Параметры.ИДИменПоказателей[0], 13);
	ДатаНачалаНП = НачалоДня(Параметры.ДатаНачалаПериодаОтчета);
	ДатаКонцаНП  = КонецДня(Параметры.ДатаКонцаПериодаОтчета);
	ИсточникРасшифровки = ОбщегоНазначения.ОбщийМодуль(Параметры.ИсточникРасшифровки);
	
	// Получаем данные расшифровки.
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить(Параметры.ИмяСКД); // Имя внешнего набора данных совпадает с ключем варианта.
		
	ИсточникРасшифровки.РасчетПоказателейРСВ(Параметры.ИмяРасчета, ДатаНачалаНП, ДатаКонцаНП, Параметры.Организация, ВнешниеНаборыДанных, Истина, ?(Параметры.ДатаПодписи > ДатаКонцаНП,Параметры.ДатаПодписи, ДатаКонцаНП));
	
	// Удалим строки с нулевым значением показателя.
	Данные = ВнешниеНаборыДанных[Параметры.ИмяСКД];
	ВсегоСтрок = Данные.Количество();
	Для Сч = 1 По ВсегоСтрок Цикл
		СтрокаДанных = Данные[ВсегоСтрок - Сч];
		Если Не ЗначениеЗаполнено(СтрокаДанных[ИмяПоля]) Тогда
			Данные.Удалить(СтрокаДанных)
		КонецЕсли;
	КонецЦикла;
	
	// Подготовим табличку для проверки с учетом отборов.
	ДанныеДляПроверки = Неопределено;
	Если Параметры.Свойство("ЗначениеТекущегоПоказателя") Тогда
		ДанныеДляПроверки = Данные.Скопировать();
	КонецЕсли;
	
	// Настраиваем СКД и выводим отчет.
	СхемаКомпоновкиДанных = ПолучитьМакет(Параметры.ИмяСКД);
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек[Параметры.ИмяСКД].Настройки);
	НастройкиКомпоновки = КомпоновщикНастроек.Настройки;
	
	ОтчетыСервер.ДобавитьВыбранноеПоле(НастройкиКомпоновки, ИмяПоля, ?(Параметры.Свойство("ЗаголовокПоля") И ЗначениеЗаполнено(Параметры.ЗаголовокПоля), Параметры.ЗаголовокПоля, " "));
	
	Если Параметры.Свойство("Раздел1Прил1КодТарифа") И ЗначениеЗаполнено(Параметры.Раздел1Прил1КодТарифа) Тогда
		ЗначениеОтбора = Неопределено;
		Если Параметры.Раздел1Прил1КодТарифа = "01" Тогда
			ЗначениеОтбора = Справочники.ВидыТарифовСтраховыхВзносов.ОбщийНалоговыйРежим;
		Иначе
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ВидыТарифовСтраховыхВзносов.Ссылка
			|ИЗ
			|	Справочник.ВидыТарифовСтраховыхВзносов КАК ВидыТарифовСтраховыхВзносов
			|ГДЕ
			|	ВидыТарифовСтраховыхВзносов.КодФНС = &КодФНС";
			Запрос.УстановитьПараметр("КодФНС", Параметры.Раздел1Прил1КодТарифа);
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				ЗначениеОтбора = Выборка.Ссылка	
			КонецЕсли;
		КонецЕсли;
		Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
			ДобавитьОтборПоПараметру(НастройкиКомпоновки, "ВидТарифаСтраховыхВзносов", ЗначениеОтбора, ДанныеДляПроверки)
		КонецЕсли;
	КонецЕсли;
	Если Параметры.Свойство("Раздел1Прил1Подр1_3_1ПризнакОснования") И ЗначениеЗаполнено(Параметры.Раздел1Прил1Подр1_3_1ПризнакОснования) Тогда
		ДобавитьОтборПоПараметру(НастройкиКомпоновки, "П11131М100101", Параметры.Раздел1Прил1Подр1_3_1ПризнакОснования, ДанныеДляПроверки)
	КонецЕсли;
	Если Параметры.Свойство("Раздел1Прил1Подр1_3_2КодОснования") И ЗначениеЗаполнено(Параметры.Раздел1Прил1Подр1_3_2КодОснования) Тогда
		ДобавитьОтборПоПараметру(НастройкиКомпоновки, "П11132М100101", Параметры.Раздел1Прил1Подр1_3_2КодОснования, ДанныеДляПроверки)
	КонецЕсли;
	Если Параметры.Свойство("Раздел1Прил1Подр1_3_2КодКлассаУсловий") И ЗначениеЗаполнено(Параметры.Раздел1Прил1Подр1_3_2КодКлассаУсловий) Тогда
		ДобавитьОтборПоПараметру(НастройкиКомпоновки, "П11132М100301", Параметры.Раздел1Прил1Подр1_3_2КодКлассаУсловий, ДанныеДляПроверки)
	КонецЕсли;
	Если Параметры.Свойство("Раздел1Прил1Подр1_4КодОснования") И ЗначениеЗаполнено(Параметры.Раздел1Прил1Подр1_4КодОснования) Тогда
		ДобавитьОтборПоПараметру(НастройкиКомпоновки, "П01114М100101", Параметры.Раздел1Прил1Подр1_4КодОснования, ДанныеДляПроверки)
	КонецЕсли;
	
	Если ДанныеДляПроверки <> Неопределено Тогда
		ЗарплатаКадры.ВывестиПредупреждениеОРасхожденииПоказателяСРасшифровкой(Параметры.ЗначениеТекущегоПоказателя, ДанныеДляПроверки.Итог(ИмяПоля), ДокументРезультат);
		ДанныеДляПроверки = Неопределено;
	КонецЕсли;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	Если СхемаКомпоновкиДанных = Неопределено Тогда
		СтандартнаяОбработка = Ложь
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьОтборПоПараметру(НастройкиКомпоновки, ИмяОтбора, ЗначениеОтбора, ДанныеДляПроверки)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НастройкиКомпоновки.Отбор, ИмяОтбора, ЗначениеОтбора, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	Если ДанныеДляПроверки <> Неопределено И ДанныеДляПроверки.Колонки.Найти(ИмяОтбора) <> Неопределено Тогда
		ДанныеДляПроверки = ДанныеДляПроверки.Скопировать(ДанныеДляПроверки.НайтиСтроки(Новый Структура(ИмяОтбора, ЗначениеОтбора)))
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
