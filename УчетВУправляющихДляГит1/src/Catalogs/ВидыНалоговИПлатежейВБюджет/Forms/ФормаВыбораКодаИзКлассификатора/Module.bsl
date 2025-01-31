
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ИмяМакета")
		ИЛИ ПустаяСтрока(Параметры.ИмяМакета) Тогда
		Отказ = Истина;
		Возврат;
	Иначе
		ИмяМакета  = Параметры.ИмяМакета;
		ГодПлатежа = Параметры.ГодПлатежа;
		ГодНачалаДействияПриказа = Формат(ГодПлатежа, "ЧГ=");
	КонецЕсли;
	
	Если ИмяМакета = "АдминистраторыДоходовБюджетов" Тогда
		Элементы.ГодНачалаДействияПриказаВыбор.Видимость = Ложь;
	Иначе
		ОпределитьНомерПриказа();
	КонецЕсли;
	
	НастроитьСписокВыбора();
	
	Если Параметры.Свойство("АдминистраторДохода") Тогда
		Элементы.СтрокаПоиска.РасширеннаяПодсказка.Заголовок = Параметры.АдминистраторДохода;
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Заголовок + ": " + Параметры.Заголовок;
	КонецЕсли;
	
	Если Параметры.Свойство("СтрокаПоиска") Тогда
		СтрокаПоиска = Параметры.СтрокаПоиска;
	КонецЕсли;
	
	Макет = Справочники.ВидыНалоговИПлатежейВБюджет.ПолучитьМакет(ИмяМакета);
	
	// Первые две колонки предназначены для показа пользователю, остальные - служебные.
	Пока Макет.ШиринаТаблицы > 2 Цикл
		Макет.УдалитьОбласть(Макет.Область(, 3,, 3), ТипСмещенияТабличногоДокумента.ПоГоризонтали);
	КонецЦикла;
	
	ТабДокумент.Вывести(Макет);
	ТабДокумент.ФиксацияСверху = 1;
	
	Если НЕ ПустаяСтрока(СтрокаПоиска) Тогда
		Если Параметры.Свойство("КБКИсходный") И НЕ ПустаяСтрока(Параметры.КБКИсходный) Тогда
			ИмяОбласти = ИскатьСтрокуВТаблицеНаСервере(СтрокаПоиска, СтрЗаменить(Параметры.КБКИсходный, " ", ""));
		Иначе
			ИмяОбласти = ИскатьСтрокуВТаблицеНаСервере(СтрокаПоиска);
		КонецЕсли;
		
		Если ИмяОбласти = "" Тогда
			ТекущийЭлемент   = Элементы.СтрокаПоиска;
		Иначе
			НайденнаяОбласть = ТабДокумент.Область(ИмяОбласти);
			ТекущийЭлемент   = Элементы.ТабДокумент;
			ТекущийЭлемент.ТекущаяОбласть = НайденнаяОбласть;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиСтроку(Команда)
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		ТекущийЭлемент = Элементы.СтрокаПоиска;
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ВыполнитьПоиск", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Область = Элементы.ТабДокумент.ТекущаяОбласть;
	ВыполнитьВыбор(Область);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		ТекущийЭлемент = Элементы.СтрокаПоиска;
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ВыполнитьПоиск", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокументВыбор(Элемент, Область, СтандартнаяОбработка)
	
	ВыполнитьВыбор(Область);
	
КонецПроцедуры

&НаКлиенте
Процедура ГодНачалаДействияПриказаВыборПриИзменении(Элемент)
	
	СформироватьМакетВыбора();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьМакетВыбора()
	
	ОпределитьНомерПриказа();
	
	Макет = Справочники.ВидыНалоговИПлатежейВБюджет.ПолучитьМакет(ИмяМакета);
	
	// Первые две колонки предназначены для показа пользователю, остальные - служебные.
	Пока Макет.ШиринаТаблицы > 2 Цикл
		Макет.УдалитьОбласть(Макет.Область(, 3,, 3), ТипСмещенияТабличногоДокумента.ПоГоризонтали);
	КонецЦикла;
	
	ТабДокумент.Очистить();
	ТабДокумент.Вывести(Макет);
	ТабДокумент.ФиксацияСверху = 1;
	
	Если НЕ ПустаяСтрока(СтрокаПоиска) Тогда
		ПодстрокаПоиска = ОбработатьСтрокуПоиска(СтрокаПоиска);
		ИмяОбласти = ИскатьСтрокуВТаблицеНаСервере(ПодстрокаПоиска);
		Если ИмяОбласти = "" Тогда
			ТекущийЭлемент = Элементы.СтрокаПоиска;
			Возврат;
		Иначе
			НайденнаяОбласть = ТабДокумент.Область(ИмяОбласти);
		КонецЕсли;
		
		ТекущийЭлемент = Элементы.ТабДокумент;
		ТекущийЭлемент.ТекущаяОбласть = НайденнаяОбласть;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИскатьСтрокуВТаблицеНаСервере(СтрокаПоиска, КБКИсходный = "")
	Перем НайденнаяОбласть;
	
	ТекущаяОбласть = Элементы.ТабДокумент.ТекущаяОбласть;
	
	Если НЕ ПустаяСтрока(КБКИсходный) Тогда
		// Проверим что мы не стоим на нужной строке, т.к. поиск от "текущей" ячейки не включает ее саму в поиск.
		Если ТабДокумент.Область(ТекущаяОбласть.Верх, 1).Текст = КБКИсходный Тогда
			НайденнаяОбласть = ТекущаяОбласть;
		Иначе
			НайденнаяОбласть = ТабДокумент.НайтиТекст(КБКИсходный, ТекущаяОбласть,,,,, Истина);
		КонецЕсли;
	КонецЕсли;
	
	Если НайденнаяОбласть = Неопределено Тогда
		// Проверим что мы не стоим на нужной строке.
		Если СтрДлина(СтрокаПоиска) = 17 И ТабДокумент.Область(ТекущаяОбласть.Верх, 1).Текст = СтрокаПоиска
			ИЛИ СтрНайти(ТабДокумент.Область(ТекущаяОбласть.Верх, 2).Текст, СтрокаПоиска) > 0
			ИЛИ СтрДлина(СтрокаПоиска) < 17 И СтрНайти(ТабДокумент.Область(ТекущаяОбласть.Верх, 1).Текст, СтрокаПоиска) > 0 Тогда
			НайденнаяОбласть = ТекущаяОбласть;
		Иначе
			НайденнаяОбласть = ТабДокумент.НайтиТекст(СтрокаПоиска, ТекущаяОбласть,,,,, Истина);
		КонецЕсли;
	КонецЕсли;
	
	Если НайденнаяОбласть = Неопределено Тогда
		НайденнаяОбласть = ТабДокумент.НайтиТекст(СтрокаПоиска,,,,,, Истина);
		
		Если НайденнаяОбласть = Неопределено Тогда
			// Возможно КБК ищут в том виде, который рекомендуют ФНС к зачислению в бюджет.
			// Попробуем привести его к виду, установленному Минфином и выполнить поиск.
			
			СтрокаПоискаБезПробелов = СтрЗаменить(СтрокаПоиска, " ", "");
			
			// если в строке поиска присутствую символы отличные от цифр, то это не КБК,
			// а значит искали название статьи и не нашли.
			Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаПоискаБезПробелов) Тогда
				Возврат "";
			КонецЕсли;
			
			Если НайденнаяОбласть = Неопределено Тогда
				ДлинаСтрокиПоиска = СтрДлина(СтрокаПоискаБезПробелов);
				ЛеваяЧастьСтроки  = СтрокаПоискаБезПробелов;
				ПраваяЧастьСтроки = "";
				Если ДлинаСтрокиПоиска > 10 Тогда
					ЛеваяЧастьСтроки  = Лев(СтрокаПоискаБезПробелов, 10);
					ПраваяЧастьСтроки = Сред(СтрокаПоискаБезПробелов, 11);
					
					ДлинаПравойЧасти  = СтрДлина(ПраваяЧастьСтроки);
					ПраваяЧастьСтроки =
						Лев(("0000" + ?(ДлинаПравойЧасти > 4, Сред(ПраваяЧастьСтроки, 5), "")), ДлинаПравойЧасти);
				КонецЕсли;
				
				СтрокаПоискаБезПробелов = ЛеваяЧастьСтроки + ПраваяЧастьСтроки;
				НайденнаяОбласть = ТабДокумент.НайтиТекст(СтрокаПоискаБезПробелов, ТекущаяОбласть,,,,, Истина);
			КонецЕсли;
			
		КонецЕсли;
		
		Если НайденнаяОбласть = Неопределено Тогда
			Возврат "";
		КонецЕсли;
	КонецЕсли;
	
	Возврат НайденнаяОбласть.Имя;
	
КонецФункции

&НаСервере
Процедура ИскатьСтрокуНаСервере(НичегоНеНашли)
	
	ПодстрокаПоиска = ОбработатьСтрокуПоиска(СтрокаПоиска);
	
	Если ПодстрокаПоиска = СтрокаПоиска Тогда
		ИмяОбласти = ИскатьСтрокуВТаблицеНаСервере(ПодстрокаПоиска);
	Иначе
		ИмяОбласти = ИскатьСтрокуВТаблицеНаСервере(ПодстрокаПоиска, СтрЗаменить(СтрокаПоиска, " ", ""));
	КонецЕсли;
	
	Если ИмяОбласти = "" Тогда
		НичегоНеНашли = Истина;
		ТекущийЭлемент = Элементы.СтрокаПоиска;
		Возврат;
	Иначе
		НайденнаяОбласть = ТабДокумент.Область(ИмяОбласти);
	КонецЕсли;
	
	// Переведем фокус с кнопки поиска (или строки поиска) на найденное значение макета.
	ТекущийЭлемент = Элементы.ТабДокумент;
	ТекущийЭлемент.ТекущаяОбласть = НайденнаяОбласть;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбработатьСтрокуПоиска(СтрокаПоиска)
	
	// Если больше 26 символов, скорее всего это не Код БК, а текст -
	// см. шаблон отформатированного КБК: 182 1 01 01011 01 1000 110.
	Если СтрДлина(СокрЛП(СтрокаПоиска)) > 26 Тогда
		Возврат СтрокаПоиска;
	КонецЕсли;
	
	// Попробуем получить Код БК
	СтрокаПоискаБезПробелов = СтрЗаменить(СтрокаПоиска, " ", "");
	
	// В Коде БК должны быть только цифры
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаПоискаБезПробелов) Тогда
		Возврат СтрокаПоиска;
	КонецЕсли;
	
	Если СтрДлина(СтрокаПоискаБезПробелов) = 20 Тогда
		СтрокаПоиска = Сред(СтрокаПоискаБезПробелов, 4);
	Иначе
		СтрокаПоиска = СтрокаПоискаБезПробелов;
	КонецЕсли;
	
	Если СтрДлина(СтрокаПоиска) = 17 Тогда
		ВидДохода = Лев(СтрокаПоиска, 10);
		КОСГУ = Сред(СтрокаПоиска, 15);
		
		ПодстрокаПоиска = ВидДохода + "0000" + КОСГУ;
	Иначе
		ПодстрокаПоиска = СтрокаПоиска;
	КонецЕсли;
		
	Возврат ПодстрокаПоиска;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьВыбор(Область)

	ВыбранныйКод = ТабДокумент.Область(Область.Верх, 1, Область.Верх, 1).Текст;
	Если ПустаяСтрока(ВыбранныйКод) 
		ИЛИ НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ВыбранныйКод) Тогда
		ПоказатьПредупреждение( , НСтр("ru = 'Выберите строку с кодом'"));
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(ВыбранныйКод);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоиск()
	
	НичегоНеНашли = Ложь;
	ИскатьСтрокуНаСервере(НичегоНеНашли);
	
	Если НичегоНеНашли Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Строка не найдена'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьСписокВыбора()
	
	СписокВыбора = Элементы.ГодНачалаДействияПриказаВыбор.СписокВыбора;
	СписокВыбора.Очистить();
	
	ДатаАктуальностиКлассификатора = Справочники.ВидыНалоговИПлатежейВБюджет.ДатаАктуальностиКлассификатора();
	Период = КонецГода(ДатаАктуальностиКлассификатора) + 1;
	
	СписокВыбора.Добавить(Формат(Год(ДатаАктуальностиКлассификатора), "ЧГ="), Формат(ДатаАктуальностиКлассификатора, "ДФ='yyyy ""г.""'"));
	СписокВыбора.Добавить(Формат(Год(Период), "ЧГ="), Формат(Период, "ДФ='yyyy ""г.""'"));
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьНомерПриказа()
	
	Если ГодНачалаДействияПриказа = "2018" Тогда
		ИмяМакета      = "КлассификацияДоходовБюджетов";
		НадписьПриказа = НСтр("ru = 'по приказу Минфина от 01.07.2013 г. № 65н
			|(в редакции приказа Минфина от 20.09.2018 г. № 198н)'");
	Иначе
		ИмяМакета      = "КлассификацияДоходовБюджетов2019";
		НадписьПриказа = НСтр("ru = 'по приказу Минфина от 08.06.2018 г. № 132н
			|(в редакции приказа Минфина от 25.06.2019 г. № 103н)'");
	КонецЕсли;
	
	Элементы.ГодНачалаДействияПриказаВыбор.РасширеннаяПодсказка.Заголовок = НадписьПриказа;
	
КонецПроцедуры

#КонецОбласти
