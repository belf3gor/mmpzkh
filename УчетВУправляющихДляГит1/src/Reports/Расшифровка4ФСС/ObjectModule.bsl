#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура СформироватьОтчетРасшифровку(Параметры, ДокументРезультат) Экспорт
	
	ИмяПоля = Лев(Параметры.ИДИменПоказателей[0], 13);
	ДатаНачалаНП = НачалоДня(Параметры.мДатаНачалаПериодаОтчета);
	ДатаКонцаНП  = КонецДня(Параметры.мДатаКонцаПериодаОтчета);
	ИсточникРасшифровки = ОбщегоНазначения.ОбщийМодуль(Параметры.ИсточникРасшифровки);
	
	// Получаем данные расшифровки.
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить(Параметры.ИмяСКД); // Имя внешнего набора данных совпадает с ключем варианта.
	
	ИсточникРасшифровки.РасчетПоказателей4ФСС(Параметры.ИмяРасчета, ДатаНачалаНП, ДатаКонцаНП, Параметры.Организация, ВнешниеНаборыДанных, Истина);
	
	// Удалим строки с нулевым значением показателя.
	Данные = ВнешниеНаборыДанных[Параметры.ИмяСКД];
	ВсегоСтрок = Данные.Количество();
	Для Сч = 1 По ВсегоСтрок Цикл
		СтрокаДанных = Данные[ВсегоСтрок - Сч];
		Если Не ЗначениеЗаполнено(СтрокаДанных[ИмяПоля]) Тогда
			Данные.Удалить(СтрокаДанных)
		КонецЕсли;
	КонецЦикла;

	Если Параметры.Свойство("ЗначениеТекущегоПоказателя") Тогда
		ЗарплатаКадры.ВывестиПредупреждениеОРасхожденииПоказателяСРасшифровкой(Параметры.ЗначениеТекущегоПоказателя, Данные.Итог(ИмяПоля), ДокументРезультат);
	КонецЕсли;
	
	// Настраиваем СКД и выводим отчет.
	СхемаКомпоновкиДанных = ПолучитьМакет(Параметры.ИмяСКД);
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек[Параметры.ИмяСКД].Настройки);
	НастройкиКомпоновки = КомпоновщикНастроек.Настройки;
	
	ОтчетыСервер.ДобавитьВыбранноеПоле(НастройкиКомпоновки, ИмяПоля, ?(Параметры.Свойство("ЗаголовокПоля") И ЗначениеЗаполнено(Параметры.ЗаголовокПоля), Параметры.ЗаголовокПоля, ""));
    Если Параметры.Свойство("Раздел31ФИО") И ЗначениеЗаполнено(Параметры.Раздел31ФИО) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НастройкиКомпоновки.Отбор, "ФИО", Параметры.Раздел31ФИО, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
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

#КонецЕсли