#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
	
Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
		
	Если НаДату > '20110101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.ВерсияФСГС;
	КонецЕсли;
		
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 27.07.2012 № 423.";
	НоваяФорма.РедакцияФормы	  = "от 27.07.2012 № 423.";
	НоваяФорма.ДатаНачалоДействия = '20130101';
	// Ранее срок действия был по 31 декабря 2013 года.
	// Поскольку за 2013 год должна представляться уже ФормаОтчета2014Кв1 (утверждена приказом Росстата от 23.07.2013 № 291)
	// срок действия данной формы сокращен до 30 ноября 2013 года.
	// Из процедуры ПоказатьПериод(Форма) модуля Основной формы убрана "заплатка",
	// принудительно назначавшая на период "2013 год" форму отчета ФормаОтчета2014Кв1.
	НоваяФорма.ДатаКонецДействия  = '20131130';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 23.07.2013 № 291.";
	НоваяФорма.РедакцияФормы	  = "от 23.07.2013 № 291.";
	// Ранее срок действия был с 01 января 2014 года.
	НоваяФорма.ДатаНачалоДействия = '20131201';
	НоваяФорма.ДатаКонецДействия  = '20141231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 27.08.2014 № 535.";
	НоваяФорма.РедакцияФормы	  = "от 27.08.2014 № 535.";
	НоваяФорма.ДатаНачалоДействия = '20141201';
	НоваяФорма.ДатаКонецДействия  = '20151231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 03.12.2015 № 613.";
	НоваяФорма.РедакцияФормы	  = "от 03.12.2015 № 613.";
	НоваяФорма.ДатаНачалоДействия = '20151201';
	НоваяФорма.ДатаКонецДействия  = '20161231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 05.08.2016 № 390.";
	НоваяФорма.РедакцияФормы	  = "от 05.08.2016 № 390.";
	НоваяФорма.ДатаНачалоДействия = '20161201';
	НоваяФорма.ДатаКонецДействия  = '20171231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2018Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 01.08.2017 № 509.";
	НоваяФорма.РедакцияФормы	  = "от 01.08.2017 № 509.";
	НоваяФорма.ДатаНачалоДействия = '20171201';
	НоваяФорма.ДатаКонецДействия  = '20181231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 28.08.2018 № 519.";
	НоваяФорма.РедакцияФормы	  = "от 28.08.2018 № 519.";
	НоваяФорма.ДатаНачалоДействия = '20181201';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20130101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "616007", '20120727', "423", "ФормаОтчета2013Кв1");
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "616007", '20130723', "291", "ФормаОтчета2014Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "616007", '20140827', "535", "ФормаОтчета2015Кв1");
	Форма20160101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "616007", '20151203', "613", "ФормаОтчета2016Кв1");
	Форма20160101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "616007", '20160805', "390", "ФормаОтчета2017Кв1");
	Форма20160101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "616007", '20170801', "509", "ФормаОтчета2018Кв1");
	РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20160101, "05-12-2017");
	Форма20160101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "616007", '20180828', "519", "ФормаОтчета2019Кв1");
	РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20160101, "24-12-2018");
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#Если Не ВнешнееСоединение Тогда
#Область ФормированиеТекстаВыгрузки

Функция СформироватьСпискиВыбора(ИмяОтчета)
	
	СвойстваПоказателей = Новый ТаблицаЗначений;
	СвойстваПоказателей.Колонки.Добавить("Показатель", Новый ОписаниеТипов("Строка"));
	СвойстваПоказателей.Колонки.Добавить("Длина", Новый ОписаниеТипов("Число"));
	СвойстваПоказателей.Колонки.Добавить("Тип", Новый ОписаниеТипов("Строка"));
	СвойстваПоказателей.Колонки.Добавить("ТекстПриВыборе", Новый ОписаниеТипов("Строка"));
	СвойстваПоказателей.Колонки.Добавить("ТаблицаЗначений", Новый ОписаниеТипов("ТаблицаЗначений"));
	
	МакетСоставаПоказателей = Отчеты[ИмяОтчета].ПолучитьМакет("Списки2017Кв1");
	
	КоллекцияСписковВыбора = Новый Соответствие;
	Для Каждого Область Из МакетСоставаПоказателей.Области Цикл
		Если Область.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
			ВерхОбласти = Область.Верх;
			НизОбласти = Область.Низ;
			ТаблСписка = Новый ТаблицаЗначений;
			ТаблСписка.Колонки.Добавить("Код",,, МакетСоставаПоказателей.Область(ВерхОбласти, 1, ВерхОбласти, 1).ШиринаКолонки);
			ТаблСписка.Колонки.Добавить("Название",,, МакетСоставаПоказателей.Область(ВерхОбласти, 2, ВерхОбласти, 2).ШиринаКолонки);
			Если Область.Имя = "СправочникЕдиницИзмерения" Тогда
				ТаблСписка.Колонки.Добавить("УслОбозначение",,"Условное обозначение", МакетСоставаПоказателей.Область(ВерхОбласти, 3, ВерхОбласти, 3).ШиринаКолонки);
			КонецЕсли;
			Для НомСтр = ВерхОбласти По НизОбласти Цикл
				КодПоказателя = СокрП(МакетСоставаПоказателей.Область(НомСтр, 1).Текст);
				Если КодПоказателя <> "###" Тогда
					НовСтрока = ТаблСписка.Добавить();
					НовСтрока.Код = КодПоказателя;
					НовСтрока.Название = СокрП(МакетСоставаПоказателей.Область(НомСтр, 2).Текст);
					Если Область.Имя = "СправочникЕдиницИзмерения" Тогда
						НовСтрока.УслОбозначение = СокрП(МакетСоставаПоказателей.Область(НомСтр, 3).Текст);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			КоллекцияСписковВыбора.Вставить(Область.Имя, ТаблСписка);
		КонецЕсли;
	КонецЦикла;
	
	ДобавитьСтрокуОписанияВвода(СвойстваПоказателей, "П000001000109",  10, , "", КоллекцияСписковВыбора["СправочникПричинИзмененияЦены"]);
	ДобавитьСтрокуОписанияВвода(СвойстваПоказателей, "П000001000106", 250, , "", КоллекцияСписковВыбора["СправочникЕдиницИзмерения"]);
	ДобавитьСтрокуОписанияВвода(СвойстваПоказателей, "П000001000105", 250, , "", КоллекцияСписковВыбора["СправочникКаналовРеализации"]);
		
	Возврат СвойстваПоказателей;
	
КонецФункции

Процедура ДобавитьСтрокуОписанияВвода(ТаблицаПараметров, Показатель, Длина, Тип = Неопределено, ТекстПриВыборе = Неопределено, Значения = Неопределено) Экспорт 
	
	НовСтр = ТаблицаПараметров.Добавить();
	НовСтр.Показатель = Показатель;
	НовСтр.Тип = Тип;
	НовСтр.Длина = Длина;
	НовСтр.ТекстПриВыборе = ТекстПриВыборе;
	Если ТипЗнч(Значения) = Тип("ТаблицаЗначений") Тогда
		НовСтр.ТаблицаЗначений = Значения.Скопировать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнительныеПоказатели1ЦеныПроизв(ТекСтруктура, СвойстваПоказателей)
	
	Перем ТекЗначение, ТекЗначение3, ТекЗначение4;
	
	НомСуффикса = 1;
	Пока ТекСтруктура.Свойство("П000001000106_" + Формат(НомСуффикса, "ЧГ="), ТекЗначение) Цикл
		Попытка
			ТекСтрокаТЗ = СвойстваПоказателей.НайтиСтроки(Новый Структура("Показатель", "П000001000106"))[0].ТаблицаЗначений.НайтиСтроки(Новый Структура("УслОбозначение", ТекЗначение))[0];
		Исключение
			ТекСтрокаТЗ = Неопределено;
		КонецПопытки;
		Если ТекСтрокаТЗ <> Неопределено Тогда
			Если ЗначениеЗаполнено(ТекСтрокаТЗ.Код) Тогда
				ТекСтруктура.Вставить("ПД00001000106_" + Формат(НомСуффикса, "ЧГ="), Число(ТекСтрокаТЗ.Код));
			Иначе
				ТекСтруктура.Вставить("ПД00001000106_" + Формат(НомСуффикса, "ЧГ="), "");
			КонецЕсли;
		Иначе
			ТекСтруктура.Вставить("ПД00001000106_" + Формат(НомСуффикса, "ЧГ="), "");
		КонецЕсли;
		НомСуффикса = НомСуффикса + 1;
	КонецЦикла;
	
	НомСуффикса = 1;
	Пока ТекСтруктура.Свойство("П000001000103_" + Формат(НомСуффикса, "ЧГ="), ТекЗначение3)
		И ТекСтруктура.Свойство("П000001000104_" + Формат(НомСуффикса, "ЧГ="), ТекЗначение4) Цикл
		Если ЗначениеЗаполнено(ТекЗначение3) И ЗначениеЗаполнено(ТекЗначение4) Тогда
			ТекСтруктура.Вставить("ПД00001000134_" + Формат(НомСуффикса, "ЧГ="), СокрЛП(ТекЗначение4) + "/ " + СокрЛП(ТекЗначение3));
		ИначеЕсли ЗначениеЗаполнено(ТекЗначение3) Тогда
			ТекСтруктура.Вставить("ПД00001000134_" + Формат(НомСуффикса, "ЧГ="), СокрЛП(ТекЗначение3));
		ИначеЕсли ЗначениеЗаполнено(ТекЗначение4) Тогда
			ТекСтруктура.Вставить("ПД00001000134_" + Формат(НомСуффикса, "ЧГ="), СокрЛП(ТекЗначение4));
		Иначе
			ТекСтруктура.Вставить("ПД00001000134_" + Формат(НомСуффикса, "ЧГ="), "");
		КонецЕсли;
		НомСуффикса = НомСуффикса + 1;
	КонецЦикла;
	
Конецпроцедуры

Функция ТекстВыгрузкиОтчетаСтатистики(мСохраненныйДок, ВыбраннаяФорма) Экспорт 
	ТекстВыгрузки = "";
	Если ВыбраннаяФорма = "ФормаОтчета2017Кв1" Тогда 
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(мСохраненныйДок, "Периодичность,Организация,ДатаПодписи,ИсточникОтчета");
		ИмяАтрибутов = ?(РеквизитыДокумента.Периодичность = Перечисления.Периодичность.Месяц, "АтрибВыгрузкиXML2017Кв1_месяц", "АтрибВыгрузкиXML2017Кв1_год");
		КонтекстФормы = УниверсальныйОтчетСтатистики.СформироватьКонтекстФормыДляПоказателей(мСохраненныйДок);
		ПараметрыВыгрузки = УниверсальныйОтчетСтатистики.СформироватьСтруктуруПараметров(КонтекстФормы, мСохраненныйДок, ИмяАтрибутов);
		СвойстваПоказателей = СформироватьСпискиВыбора(РеквизитыДокумента.ИсточникОтчета);
		ДополнительныеПоказатели1ЦеныПроизв(КонтекстФормы.ПолеТабличногоДокументаФормаОтчета, СвойстваПоказателей);
		ДеревоВыгрузки = РегламентированнаяОтчетность.ПолучитьДеревоВыгрузки(КонтекстФормы, "СхемаВыгрузкиXML2013Кв1");
		УниверсальныйОтчетСтатистики.ЗаполнитьДанными(КонтекстФормы, ДеревоВыгрузки, ПараметрыВыгрузки);
		ТекстВыгрузки = РегламентированнаяОтчетность.ВыгрузитьДеревоВXML(ДеревоВыгрузки, ПараметрыВыгрузки);
	ИначеЕсли ВыбраннаяФорма = "ФормаОтчета2018Кв1" Тогда 
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(мСохраненныйДок, "Периодичность,Организация,ДатаПодписи,ИсточникОтчета");
		ИмяАтрибутов = ?(РеквизитыДокумента.Периодичность = Перечисления.Периодичность.Месяц, "АтрибВыгрузкиXML2018Кв1_месяц", "АтрибВыгрузкиXML2018Кв1_год");
		КонтекстФормы = УниверсальныйОтчетСтатистики.СформироватьКонтекстФормыДляПоказателей(мСохраненныйДок);
		ПараметрыВыгрузки = УниверсальныйОтчетСтатистики.СформироватьСтруктуруПараметров(КонтекстФормы, мСохраненныйДок, ИмяАтрибутов);
		СвойстваПоказателей = СформироватьСпискиВыбора(РеквизитыДокумента.ИсточникОтчета);
		ДополнительныеПоказатели1ЦеныПроизв(КонтекстФормы.ПолеТабличногоДокументаФормаОтчета, СвойстваПоказателей);
		ДеревоВыгрузки = РегламентированнаяОтчетность.ПолучитьДеревоВыгрузки(КонтекстФормы, "СхемаВыгрузкиXML2013Кв1");
		УниверсальныйОтчетСтатистики.ЗаполнитьДанными(КонтекстФормы, ДеревоВыгрузки, ПараметрыВыгрузки);
		ТекстВыгрузки = РегламентированнаяОтчетность.ВыгрузитьДеревоВXML(ДеревоВыгрузки, ПараметрыВыгрузки);
	ИначеЕсли ВыбраннаяФорма = "ФормаОтчета2019Кв1" Тогда 
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(мСохраненныйДок, "Периодичность,Организация,ДатаПодписи,ИсточникОтчета");
		ИмяАтрибутов = ?(РеквизитыДокумента.Периодичность = Перечисления.Периодичность.Месяц, "АтрибВыгрузкиXML2019Кв1_месяц", "АтрибВыгрузкиXML2019Кв1_год");
		КонтекстФормы = УниверсальныйОтчетСтатистики.СформироватьКонтекстФормыДляПоказателей(мСохраненныйДок);
		ПараметрыВыгрузки = УниверсальныйОтчетСтатистики.СформироватьСтруктуруПараметров(КонтекстФормы, мСохраненныйДок, ИмяАтрибутов);
		СвойстваПоказателей = СформироватьСпискиВыбора(РеквизитыДокумента.ИсточникОтчета);
		ДополнительныеПоказатели1ЦеныПроизв(КонтекстФормы.ПолеТабличногоДокументаФормаОтчета, СвойстваПоказателей);
		ДеревоВыгрузки = РегламентированнаяОтчетность.ПолучитьДеревоВыгрузки(КонтекстФормы, "СхемаВыгрузкиXML2019Кв1");
		УниверсальныйОтчетСтатистики.ЗаполнитьДанными(КонтекстФормы, ДеревоВыгрузки, ПараметрыВыгрузки);
		ТекстВыгрузки = РегламентированнаяОтчетность.ВыгрузитьДеревоВXML(ДеревоВыгрузки, ПараметрыВыгрузки);
	КонецЕсли;
	
	Возврат ТекстВыгрузки;
КонецФункции

#КонецОбласти
#КонецЕсли

#КонецЕсли