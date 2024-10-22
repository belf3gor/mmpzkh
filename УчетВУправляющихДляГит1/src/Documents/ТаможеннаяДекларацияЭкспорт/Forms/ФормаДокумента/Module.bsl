
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	НадписьВыбор = НСтр("ru='Выбор'");
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"БП.Документ.ТаможеннаяДекларацияЭкспорт",
		"ФормаДокумента",
		НСтр("ru='Новости: Таможенная декларация (экспорт)'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.ТаможеннаяДекларацияЭкспорт.Форма.ФормаДокументыОснования" Тогда
		
		Если ТолькоПросмотр Тогда
			Возврат;
		КонецЕсли;
		
		Модифицированность = Истина;
		ОбработкаВыбораОснований(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьЗаголовокФормы();
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) И НЕ Объект.Организация = ВыбранноеЗначение Тогда
		Объект.ДокументОснование = Неопределено;
		Объект.ДокументыОснования.Очистить();
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",          НСтр("ru='Выбор кода операции'"));
	ПараметрыФормы.Вставить("ТаблицаЗначений",    КодыОперации);
	ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", Объект.КодОперации));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборКодаОперацииЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы",
		ПараметрыФормы,
		ЭтотОбъект,
		УникальныйИдентификатор, , ,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВыборНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьОснование();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьДокументыОснованияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьОснование();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьИзменитьНажатие(Элемент)
	
	ВыбратьОснование();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтаФорма,
		Команда
	);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьСостояниеДокумента();
	УстановитьЗаголовокФормы();
	ЗаполнитьКоллекциюСписковВыбора();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(ЭтотОбъект)
	
	Элементы = ЭтотОбъект.Элементы;
	Объект   = ЭтотОбъект.Объект;
	
	// Представление ссылки "Документы-основания"
	КоличествоОснований = Объект.ДокументыОснования.Количество();
	
	Элементы.НадписьВыбор.Видимость              = КоличествоОснований = 0;
	Элементы.ГруппаОдноОснование.Видимость       = КоличествоОснований = 1;
	Элементы.НадписьДокументыОснования.Видимость = КоличествоОснований > 1;
	
	Если КоличествоОснований > 1 Тогда
		
		ФормСтрока     = "Л = ru_RU; ЧДЦ=0";
		ПарПредмета    = "документ,документа,документов,м,,,,0";
		ПрописьЧисла   = ЧислоПрописью(КоличествоОснований, ФормСтрока, ПарПредмета);
		ИндексПредмета = СтрНайти(ПрописьЧисла, "док");
		ТекстДокументы = Строка(КоличествоОснований) + " " + Сред(ПрописьЧисла, ИндексПредмета, СтрДлина(ПрописьЧисла)- ИндексПредмета - 3);
		ТекстНадписи   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 (%2 и еще %3)'"), 
			ТекстДокументы, 
			Строка(Объект.ДокументыОснования[0].ДокументОснование),
			КоличествоОснований - 1);
		
		ЭтотОбъект.НадписьДокументыОснования = ТекстНадписи;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОснование()
	
	ЕстьОшибкиЗаполнения = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда 
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Поле", "Заполнение", НСтр("ru = 'Организация'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Организация", "Объект" , ЕстьОшибкиЗаполнения);
	КонецЕсли;
	
	Если ЕстьОшибкиЗаполнения Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = ПараметрыФормыПодбораОснования();
	
	ОткрытьФорму("Документ.ТаможеннаяДекларацияЭкспорт.Форма.ФормаДокументыОснования",
		ПараметрыФормы,
		ЭтотОбъект,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыФормыПодбораОснования()
	
	СтруктураПараметров = Новый Структура;
	ДанныеЗаполнения    = Новый Структура;
	ЗначениеОтбора      = Новый Структура;
	
	Если Объект.ДокументыОснования.Количество() > 0 Тогда
		ДанныеЗаполнения.Вставить("СписокДокументовОснований", Новый СписокЗначений);
		Для Каждого СтрокаТаблицы Из Объект.ДокументыОснования Цикл
			ДанныеЗаполнения.СписокДокументовОснований.Добавить(СтрокаТаблицы.ДокументОснование)
		КонецЦикла;
	КонецЕсли;
	
	ЗначениеОтбора.Вставить("Организация", Объект.Организация);
	
	СтруктураПараметров.Вставить("ДанныеЗаполнения", ДанныеЗаполнения);
	СтруктураПараметров.Вставить("Отбор"           , ЗначениеОтбора);
	СтруктураПараметров.Вставить("ТолькоПросмотр"  , ТолькоПросмотр);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбораОснований(ВыбранноеЗначение)
	
	Объект.ДокументыОснования.Очистить();
	Для Каждого СтрокаСписка Из ВыбранноеЗначение Цикл
		Если СтрокаСписка.Значение.Пустая() Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаТаблицы = Объект.ДокументыОснования.Добавить();
		СтрокаТаблицы.ДокументОснование = СтрокаСписка.Значение;
	КонецЦикла;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Заголовок = Документы.ТаможеннаяДекларацияЭкспорт.ПредставлениеДокумента(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКоллекциюСписковВыбора()
	
	МакетСоставаПоказателей = Отчеты.РегламентированныйОтчетРеестрНДСПриложение5.ПолучитьМакет("СпискиВыбора2015Кв4");
	
	КоллекцияСписковВыбора = Новый Структура;
	Для Каждого Область Из МакетСоставаПоказателей.Области Цикл
		Если Область.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
			ВерхОбласти = Область.Верх;
			НизОбласти  = Область.Низ;
			Коды = Новый ТаблицаЗначений;
			Коды.Колонки.Добавить("Код");
			Коды.Колонки.Добавить("Название");
			Коды.Колонки.Добавить("РезультатПроверки");
			Для НомерСтроки = ВерхОбласти По НизОбласти Цикл
				КодПоказателя = СокрП(МакетСоставаПоказателей.Область(НомерСтроки, 1).Текст);
				Если КодПоказателя <> "###" Тогда
					НовСтрока = Коды.Добавить();
					НовСтрока.Код               = КодПоказателя;
					НовСтрока.Название          = СокрП(МакетСоставаПоказателей.Область(НомерСтроки, 2).Текст);
					НовСтрока.РезультатПроверки = СокрП(МакетСоставаПоказателей.Область(НомерСтроки, 3).Текст);
				КонецЕсли;
			КонецЦикла;
			КоллекцияСписковВыбора.Вставить(Область.Имя, Коды);
		КонецЕсли;
	КонецЦикла;
	
	Если КоллекцияСписковВыбора.Свойство("ВидыДокумента") Тогда
		СписокВыбора = Элементы.СопроводительныеДокументыВидДокумента.СписокВыбора;
		СписокВыбора.Очистить();
		Для Каждого ВидДокумента Из КоллекцияСписковВыбора.ВидыДокумента Цикл
			Если НЕ ЗначениеЗаполнено(ВидДокумента.Код) Тогда
				Продолжить;
			КонецЕсли;
			СписокВыбора.Добавить(ВидДокумента.Код, ВидДокумента.Код + " - " + ВидДокумента.Название);
		КонецЦикла;
	КонецЕсли;
	
	Если КоллекцияСписковВыбора.Свойство("КодыВидаТС") Тогда
		СписокВыбора = Элементы.СопроводительныеДокументыКодТС.СписокВыбора;
		СписокВыбора.Очистить();
		Для Каждого КодВидаТС Из КоллекцияСписковВыбора.КодыВидаТС Цикл
			Если НЕ ЗначениеЗаполнено(КодВидаТС.Код) Тогда
				Продолжить;
			КонецЕсли;
			СписокВыбора.Добавить(КодВидаТС.Код, КодВидаТС.Код + " - " + КодВидаТС.Название);
		КонецЦикла;
	КонецЕсли;
	
	Если КоллекцияСписковВыбора.Свойство("КодыОпераций") Тогда
		Для Каждого КодОперации Из КоллекцияСписковВыбора.КодыОпераций Цикл
			Если НЕ ЗначениеЗаполнено(КодОперации.Код) Тогда
				Продолжить;
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(КодыОперации.Добавить(), КодОперации);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКодаОперацииЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.КодОперации = РезультатВыбора.Код;
	
КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()
	
	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти