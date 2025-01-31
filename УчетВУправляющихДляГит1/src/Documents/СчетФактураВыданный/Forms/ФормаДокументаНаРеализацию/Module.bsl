
#Область ОписаниеПеременных

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Перем ПроверкаКонтрагентовПараметрыОбработчикаОжидания Экспорт;
&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОтправкаПочтовыхСообщений.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();

		// Перед вводом на основании нужно актуализировать взаиморасчеты.
		Если ПолучитьФункциональнуюОпцию("ИспользоватьОтложенноеПроведение")
			И ЗначениеЗаполнено(Параметры.Основание)
			И Объект.ПлатежноРасчетныеДокументы.Количество() = 0 Тогда
				НачатьАктуализациюРасчетовСКонтрагентами();
		КонецЕсли;
		
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереДокумент(ЭтотОбъект, Параметры);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.Документ.СчетФактураВыданный",
		"ФормаДокументаНаРеализацию",
		НСтр("ru='Новости: Счет-фактура выданный'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
	// Подсистема "ОбменСКонтрагентами".
	ОбменСКонтрагентамиБП.КомандыЭДО_ФормаДокумента(ЭтотОбъект);
	// Конец подсистема "ОбменСКонтрагентами".
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.СчетФактураВыданный.Форма.ФормаДокументыОснования" Тогда
		Модифицированность	= Истина;
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Модифицированность	= Истина;
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыОповещения = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаДокумента();
	ПараметрыОповещения.Форма = ЭтотОбъект;
	ПараметрыОповещения.ДокументСсылка = Объект.Ссылка;
	ПараметрыОповещения.ДекорацияСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыОповещения.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаДокумента(ИмяСобытия, Параметр, Источник, ПараметрыОповещения);
	// Конец подсистема "ОбменСКонтрагентами".
	
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

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "ПроведениеСчетФактураВыданныйНаРеализацию";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередЗаписьюНаСервереДокумент(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПредставлениеДокумента = Документы.СчетФактураВыданный.ПолучитьПредставлениеДокумента(Объект.Ссылка, Объект.ВидСчетаФактуры);

	УстановитьЗаголовокФормы(ЭтаФорма, ПредставлениеДокумента);
	
	УчетНДСКлиентСервер.ДополнитьПараметрыСобытияЗаписьСчетаФактуры(ПараметрыЗаписи);
	ПараметрыЗаписи.ДокументыОснования = ОбщегоНазначения.ВыгрузитьКолонку(ТекущийОбъект.ДокументыОснования, "ДокументОснование", Истина);
	ПараметрыЗаписи.РеквизитыСФ        = УчетНДСВызовСервера.РеквизитыДляНадписиОСчетеФактуреВыданном(ТекущийОбъект.Ссылка);
	
	УстановитьСостояниеДокумента();
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыПослеЗаписи = ОбменСКонтрагентами.ПараметрыПослеЗаписиНаСервере();
	ПараметрыПослеЗаписи.Форма = ЭтотОбъект;
	ПараметрыПослеЗаписи.ДокументСсылка = Объект.Ссылка;
	ПараметрыПослеЗаписи.ДекорацияСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыПослеЗаписи.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	
	ОбменСКонтрагентами.ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, ПараметрыПослеЗаписи);
	// Конец подсистема "ОбменСКонтрагентами".
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УчетНДСКлиентСервер.ДополнитьПараметрыСобытияЗаписьСчетаФактуры(ПараметрыЗаписи); // На 8.2 в web-клиенте ПараметрыЗаписи могут быть не инициализированы
	
	// Обновляем информацию о счете-фактуре в открытых формах документов-оснований
	Оповестить("Запись_СчетФактураВыданный", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Идет актуализация.
	Если ДлительнаяОперация <> Неопределено Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОжидатьАктуализацию", 0.1, Истина);
	КонецЕсли;

	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОткрытииДокумент(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
	// Подсистема "ОбменСКонтрагентами"
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец Подсистема "ОбменСКонтрагентами"
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;
	
	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);
		
	// Проверка на изменение ответственных лиц.
	Если НЕ ТребуетсяВызовСервера Тогда
		Если ТипЗнч(ДатыИзмененияОтветственныхЛиц) = Тип("ФиксированныйМассив") Тогда
		 	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиентСервер.ДатыПринадлежатРазнымИнтервалам(Объект.Дата, 
		 		ТекущаяДатаДокумента, ДатыИзмененияОтветственныхЛиц);
		КонецЕсли;
	КонецЕсли;
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Объект.Дата);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	КонтрагентПриИзмененииНаСервере();
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеКППКонтрагентаНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров	= Новый Структура("Контрагент, КППКонтрагента, РольКонтрагента");
	СтруктураПараметров.РольКонтрагента	= "Покупатель";
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, Объект);
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораКПП", СтруктураПараметров, ЭтаФорма)

КонецПроцедуры

&НаКлиенте
Процедура ВыставленПриИзменении(Элемент)
	
	ПриИзмененииПризнакаВыставления();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПризнакаВыставления()
	
	Если НЕ Объект.Выставлен Тогда
		Объект.ДатаВыставления	= '00010101';
	Иначе
		Объект.ДатаВыставления	= Объект.Дата;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетФактураНеВыставляетсяПриИзменении(Элемент)

	СчетФактураНеВыставляетсяПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущийКод = Элемент.СписокВыбора.НайтиПоЗначению(Объект.КодВидаОперации);
	ОповещениеВыбора = Новый ОписаниеОповещения("ВыборИзСпискаЗавершение",ЭтотОбъект);
	ПоказатьВыборИзСписка(ОповещениеВыбора, Элемент.СписокВыбора, Элемент, ТекущийКод);
	
КонецПроцедуры

&НаКлиенте
Процедура КодСпособаВыставленияПриИзменении(Элемент)
	
	Если Объект.КодСпособаВыставления = 2 Тогда
		Объект.Выставлен = Ложь;
		Объект.ДатаВыставления = '00010101';
	Иначе
		Объект.Выставлен = Истина;
		ПриИзмененииПризнакаВыставления();
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСостояниеЭДОНажатие(Элемент)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ДекорацияСостояниеЭДОНажатие(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	ОтветственныйПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПродавецПриИзменении(Элемент)
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторГосКонтрактаРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ВключитьИспользованиеГособоронзаказа" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Обработка.ФункциональностьПрограммы.Форма.ФормаФункциональностьПрограммы",
			Новый Структура("ТекущаяСтраница", "ГруппаРасчеты"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПлатежноРасчетныеДокументы

&НаКлиенте
Процедура ПлатежноРасчетныеДокументыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриНачалеРедактированияТабличнойЧасти(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежноРасчетныеДокументыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОкончанииРедактированияТабличнойЧасти(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКонтрагентов(Команда)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПроверитьКонтрагентовВДокументеПоКнопке(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОснование(Команда)
	
	ВыбратьОснование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()

	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	УстановитьСостояниеДокумента();
	
	ТекущаяДатаДокумента	= Объект.Дата;
	
	ДатыИзмененияОтветственныхЛиц = ОтветственныеЛицаБППовтИсп.ДатыИзмененияОтветственныхЛицОрганизаций(Объект.Организация);
	
	ЗаполнитьСписокКодовОпераций();
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		КППКонтрагента	= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Контрагент, "КПП");
	Иначе
		КППКонтрагента	= "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ДоговорКонтрагента, "ВидДоговора, СчетаФактурыОтИмениОрганизации");
		ВидДоговораКонтрагента         = РеквизитыДоговора.ВидДоговора;
		СчетаФактурыОтИмениОрганизации = РеквизитыДоговора.СчетаФактурыОтИмениОрганизации = Истина;
	Иначе
		ВидДоговораКонтрагента         = Перечисления.ВидыДоговоровКонтрагентов.ПустаяСсылка();
		СчетаФактурыОтИмениОрганизации = Ложь;
	КонецЕсли;
	
	// Продавец, от имени которого составлен счет-фактура, не изменяется при работе с формой,
	// заполняется только при создании на основании документа "Отчет комитенту" (вид операции "Отчет о закупках").
	Элементы.Продавец.Видимость = ЗначениеЗаполнено(Объект.Продавец) И НЕ (Объект.СводныйКомиссионный И ВидДоговораКонтрагента = Перечисления.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку
		ИЛИ СчетаФактурыОтИмениОрганизации);
	
	Для каждого СтрокаОснования Из Объект.ДокументыОснования Цикл
		Если ЗначениеЗаполнено(СтрокаОснования.ДокументОснование) Тогда
			НаОснованииОтчетаКомиссионера    = ТипЗнч(СтрокаОснования.ДокументОснование) = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах");
			НаОснованииНачислениеНДСпоСМР    = ТипЗнч(СтрокаОснования.ДокументОснование) = Тип("ДокументСсылка.НачислениеНДСпоСМРхозспособом");
			НаОснованииБезвозмезднаяПередача = ТипЗнч(СтрокаОснования.ДокументОснование) = Тип("ДокументСсылка.ПередачаТоваров");
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	УстановитьВидимость();
	
	ПредставлениеДокумента = Документы.СчетФактураВыданный.ПолучитьПредставлениеДокумента(Объект.Ссылка, Объект.ВидСчетаФактуры);
	УстановитьЗаголовокФормы(ЭтаФорма, ПредставлениеДокумента);
	
	УправлениеФормой(ЭтаФорма);
	Если Обработки.ФункциональностьПрограммы.ДоступнаФункциональностьГособоронзаказ() Тогда
		Элементы.ИдентификаторГосКонтракта.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ДатаДляФункциональныхОпций = ?(Объект.Исправление, Объект.ДатаИсходногоДокумента, Объект.Дата);
	
	ИспользуетсяПостановлениеНДС1137 = УчетНДСПереопределяемый.ИспользуетсяПостановлениеНДС1137(ДатаДляФункциональныхОпций);
	ВедетсяУчетНДСПоФЗ81 = УчетНДС.ВедетсяУчетНДСПоФЗ81(ДатаДляФункциональныхОпций);
	ВедетсяУчетНДСПоФЗ56 = УчетНДС.ВедетсяУчетНДСПоФЗ56(ДатаДляФункциональныхОпций);
	
	ОтражатьСуммыВЖурнале = Объект.ДатаВыставления >= '20150101' И (ПолучитьФункциональнуюОпцию("ОсуществляетсяЗакупкаТоваровУслугДляКомитентов")
		ИЛИ ПолучитьФункциональнуюОпцию("ОсуществляетсяРеализацияТоваровУслугКомитентов"));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	СчетФактураОтИмениПродавца = ЗначениеЗаполнено(Объект.Продавец) 
		И НЕ (Объект.СводныйКомиссионный И ВидДоговораКонтрагента = Перечисления.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку
			ИЛИ СчетаФактурыОтИмениОрганизации);
	
	Элементы.Продавец.Видимость = СчетФактураОтИмениПродавца;
	
	Элементы.ПредставлениеКППКонтрагента.Видимость = ИспользуетсяПостановлениеНДС1137 И
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Контрагент, "ЮридическоеФизическоеЛицо") <> Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
		
	Если НаОснованииБезвозмезднаяПередача Тогда
		Элементы.Контрагент.Доступность = ЗначениеЗаполнено(Объект.Контрагент);
	КонецЕсли;
		
КонецПроцедуры


&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы	= Форма.Элементы;
	Объект		= Форма.Объект;
	
	Если Объект.СформированПриВводеНачальныхОстатковНДС Тогда
		Форма.ТолькоПросмотр	= Истина;
	КонецЕсли;
	
	УказанДокументОснование = Объект.ДокументыОснования.Количество() > 0;
	
	Элементы.ГруппаКонтрагентКППКонтрагента.Доступность				= НЕ Форма.НаОснованииНачислениеНДСпоСМР;
	
	ЭтоИсправлениеПоПостановлению1137 = Форма.ИспользуетсяПостановлениеНДС1137 И Объект.Исправление;
	Элементы.НомерИсправленияСистемный.Доступность = ЭтоИсправлениеПоПостановлению1137;
	Элементы.НомерИсходногоДокумента.Доступность   = ЭтоИсправлениеПоПостановлению1137;
	Элементы.ДатаИсходногоДокумента.Доступность    = ЭтоИсправлениеПоПостановлению1137;
	
	Если ЭтоИсправлениеПоПостановлению1137 Тогда
		Форма.РеквизитыИсправляемыйСФНадпись = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 от %2'"),
			Объект.НомерИсходногоДокумента,Формат(Объект.ДатаИсходногоДокумента,"ДЛФ=Д"));
	КонецЕсли;
	
	Элементы.РеквизитыТекущийСФ.Видимость             = НЕ ЭтоИсправлениеПоПостановлению1137;
	Элементы.РеквизитыИсправляемыйСФНадпись.Видимость = ЭтоИсправлениеПоПостановлению1137;
	Элементы.ГруппаРеквизитыИсправления.Видимость     = ЭтоИсправлениеПоПостановлению1137;
	Элементы.ИдентификаторГосКонтракта.Видимость      = Форма.ВедетсяУчетНДСПоФЗ56;
	
	Элементы.ГруппаКомиссия.Видимость = Форма.ОтражатьСуммыВЖурнале;
	
	КоличествоОснований = Объект.ДокументыОснования.Количество();
	
	Если КоличествоОснований = 0 Тогда
		Форма.НадписьВыбор = НСтр("ru = 'Выбор'");
	ИначеЕсли КоличествоОснований > 1 Тогда
		Предмет = "документ,документа,документов,м,,,,0";
		Форма.НадписьДокументыОснования = ОбщегоНазначенияБПКлиентСервер.ПредставлениеСсылкиПредмета(
			Предмет, "док", Объект.ДокументыОснования[0].ДокументОснование, КоличествоОснований);
	КонецЕсли;
	
	Элементы.НадписьВыбор.Видимость               = КоличествоОснований = 0;
	Элементы.ГруппаНадписьОдноОснование.Видимость = КоличествоОснований = 1;
	Элементы.НадписьДокументыОснования.Видимость  = КоличествоОснований > 1;
	
	Элементы.ГруппаКодВидаОперации.Видимость		= Форма.ИспользуетсяПостановлениеНДС1137;
	Элементы.СчетФактураНеВыставляется.Доступность	= Форма.ИспользуетсяПостановлениеНДС1137;
	
	ТекущийКод = Элементы.КодВидаОперации.СписокВыбора.НайтиПоЗначению(Объект.КодВидаОперации);
	Если ТекущийКод <> Неопределено Тогда 
		Форма.НадписьВидОперации = Сред(ТекущийКод.Представление, 5);
	Иначе
		Форма.НадписьВидОперации = "";
	КонецЕсли;
	
	Элементы.Выставлен.Доступность					= Форма.ИспользуетсяПостановлениеНДС1137 И НЕ Объект.СчетФактураНеВыставляется;
	Элементы.ДатаВыставления.Доступность			= Форма.ИспользуетсяПостановлениеНДС1137 И НЕ Объект.СчетФактураНеВыставляется И Объект.Выставлен;
	Элементы.КодСпособаВыставления.Видимость		= Форма.ИспользуетсяПостановлениеНДС1137;
	Элементы.КодСпособаВыставления.Доступность	= НЕ Объект.СчетФактураНеВыставляется;
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Если НЕ ПустаяСтрока(Объект.КППКонтрагента) Тогда
			ЗначениеКППКонтрагента = Объект.КППКонтрагента;
		Иначе
			ЗначениеКППКонтрагента = Форма.КППКонтрагента;
		КонецЕсли;
		
		Форма.ПредставлениеКППКонтрагента	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'КПП %1'"), ?(ПустаяСтрока(ЗначениеКППКонтрагента), "<не задан>", ЗначениеКППКонтрагента));
	Иначе
		Форма.ПредставлениеКППКонтрагента = "";
	КонецЕсли;
	
	ЭтоЮрЛицо = ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Объект.Организация);
	
	Элементы.Руководитель.Видимость = Истина;
	Если ЭтоЮрЛицо Тогда
		Элементы.Руководитель.Заголовок = НСтр("ru = 'Руководитель'");
		Элементы.ГлавныйБухгалтер.Видимость = Истина;
	ИначеЕсли Форма.ВедетсяУчетНДСПоФЗ81 Тогда
		Элементы.Руководитель.Заголовок = НСтр("ru = 'Предприниматель'");
		Элементы.ГлавныйБухгалтер.Видимость = Ложь;
	Иначе
		Элементы.Руководитель.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	УстановитьКодВидаОперацииНаСервере();
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(Объект);

	Если НЕ ИспользуетсяПостановлениеНДС1137 Тогда
		
		Объект.Исправление             = Ложь;
		Объект.НомерИсправления        = 0;
		Объект.НомерИсходногоДокумента = "";
		Объект.ДатаИсходногоДокумента  = '00010101';
		Объект.Продавец                = Неопределено;

	ИначеЕсли Объект.Выставлен Тогда
		Объект.ДатаВыставления = Объект.Дата;
	КонецЕсли;
	
	ЗаполнитьСписокКодовОпераций();
	УстановитьВидимость();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКодовОпераций()
	
	УчетНДС.ЗаполнитьСписокКодовВидовОпераций(
		Перечисления.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры,
		Элементы.КодВидаОперации.СписокВыбора,
		Объект.Дата);
		
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	Объект.ДокументОснование	= Неопределено;
	Объект.ДокументыОснования.Очистить();
	Объект.ПлатежноРасчетныеДокументы.Очистить();
	
	УстановитьФункциональныеОпцииФормы();
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(Объект);
	
	ДатыИзмененияОтветственныхЛиц = ОтветственныеЛицаБППовтИсп.ДатыИзмененияОтветственныхЛицОрганизаций(Объект.Организация);
	
	ЗаполнитьПорядокВыставленияСчетаФактуры();
	
	Объект.СуммаДокумента		= 0;
	Объект.СуммаНДСДокумента	= 0;
	Объект.СуммаУвеличение		= 0;
	Объект.СуммаУменьшение		= 0;
	Объект.СуммаНДСУвеличение	= 0;
	Объект.СуммаНДСУменьшение	= 0;
	
	УстановитьВидимость();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()

	КонтрагентОбработатьИзменениеНаСервере();
	
	УстановитьВидимость();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура КонтрагентОбработатьИзменениеНаСервере()

	Объект.ДокументОснование	= Неопределено;
	Объект.ДоговорКонтрагента	= Неопределено;
	ВидДоговораКонтрагента 		= Неопределено;
	Объект.СуммаДокумента 		= 0;
	Объект.СуммаНДСДокумента 	= 0;
	Объект.ДокументыОснования.Очистить();
	Объект.ПлатежноРасчетныеДокументы.Очистить();
	
	ЗаполнитьПорядокВыставленияСчетаФактуры();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПорядокВыставленияСчетаФактуры()
	
	СтруктураПараметров = Новый Структура("СчетФактураНеВыставляется, ДокументОснование, ВидСчетаФактуры, Дата");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, Объект);
	
	ПараметрыВыставления = Документы.СчетФактураВыданный.ОпределитьПорядокВыставленияСчетаФактуры(СтруктураПараметров);
	ЗаполнитьЗначенияСвойств(Объект, ПараметрыВыставления);
	
КонецПроцедуры

&НаСервере
Процедура ОтветственныйПриИзмененииНаСервере()
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(Объект);
	
КонецПроцедуры

&НаСервере
Процедура СчетФактураНеВыставляетсяПриИзмененииНаСервере()

	Если Объект.СчетФактураНеВыставляется Тогда
		Объект.Выставлен				= Ложь;
		Объект.ДатаВыставления			= '00010101';
		Объект.КодСпособаВыставления	= 1;
	КонецЕсли;
	
	УстановитьКодВидаОперацииНаСервере();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДатыНомераПлатежноРасчетныхДокументов()

	МассивОснований	= ОбщегоНазначения.ВыгрузитьКолонку(Объект.ДокументыОснования, "ДокументОснование", Истина);
	Объект.ПлатежноРасчетныеДокументы.Загрузить(
		Документы.СчетФактураВыданный.ДатыНомераПлатежноРасчетныхДокументов(МассивОснований));

КонецПроцедуры

&НаСервере
Процедура ОпределениеПараметровСчетаФактурыНаРеализациюСервер()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ОпределениеПараметровСчетаФактурыНаРеализацию();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКодВидаОперацииНаСервере(КодВидаОперацииОснования = Неопределено)
	
	СтруктураПараметров	= Новый Структура;
	СтруктураПараметров.Вставить("Дата",						Объект.Дата);
	СтруктураПараметров.Вставить("ВидСчетаФактуры",				Объект.ВидСчетаФактуры);
	СтруктураПараметров.Вставить("Исправление",					Объект.Исправление);
	СтруктураПараметров.Вставить("Контрагент",					Объект.Контрагент);
	СтруктураПараметров.Вставить("ДоговорКонтрагента",			Объект.ДоговорКонтрагента);
	СтруктураПараметров.Вставить("Продавец",					Объект.Продавец);
	СтруктураПараметров.Вставить("СчетФактураНеВыставляется",	Объект.СчетФактураНеВыставляется);
	СтруктураПараметров.Вставить("СчетФактураБезНДС",			Объект.СчетФактураБезНДС);
	СтруктураПараметров.Вставить("КодВидаОперации",				Объект.КодВидаОперации);
	СтруктураПараметров.Вставить("ДокументыОснования",			Объект.ДокументыОснования.Выгрузить(,"ДокументОснование"));
	
	Объект.КодВидаОперации	= Документы.СчетФактураВыданный.ПолучитьКодВидаОперации(СтруктураПараметров, КодВидаОперацииОснования);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокФормы(Форма, ПредставлениеДокумента)
	
	Форма.Заголовок = ПредставлениеДокумента.СчетФактураПредставление;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьСчетФактураНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение( , Объект.ИсправляемыйСчетФактура);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОснование()
	
	ЕстьОшибкиЗаполнения = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда 
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Поле", "Заполнение", НСтр("ru = 'Организация'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Организация", "Объект" , ЕстьОшибкиЗаполнения);
	КонецЕсли;
		
	Если Не ЗначениеЗаполнено(Объект.Контрагент) и Не НаОснованииБезвозмезднаяПередача Тогда 
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Поле", "Заполнение", НСтр("ru = 'Контрагент'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Контрагент", "Объект" , ЕстьОшибкиЗаполнения);
	КонецЕсли;
	
	Если ЕстьОшибкиЗаполнения Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = ПолучитьСтруктуруПараметровФормы();
		
	ОткрытьФорму("Документ.СчетФактураВыданный.Форма.ФормаДокументыОснования",
			ПараметрыФормы,
			ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтруктуруПараметровФормы()
	
	СтруктураПараметров = Новый Структура();
	ЗначенияЗаполнения 	= Новый Структура();
	ЗначениеОтбора 		= Новый Структура();
	
	Если Объект.ДокументыОснования.Количество() > 0 Тогда 
		ЗначенияЗаполнения.Вставить("СписокДокументовОснований", Новый СписокЗначений);
		Для Каждого СтрокаТаблицы Из Объект.ДокументыОснования Цикл
			ЗначенияЗаполнения.СписокДокументовОснований.Добавить(СтрокаТаблицы.ДокументОснование)
		КонецЦикла;
	КонецЕсли;
	
	ЗначенияЗаполнения.Вставить("ТипСчетаФактуры", "Выданный");
	ЗначенияЗаполнения.Вставить("ВидСчетаФактуры", Объект.ВидСчетаФактуры);
	ЗначенияЗаполнения.Вставить("Исправление", Объект.Исправление);
	ЗначенияЗаполнения.Вставить("СчетФактура", Объект.Ссылка);
	ЗначенияЗаполнения.Вставить("НаОснованииБезвозмезднаяПередача", НаОснованииБезвозмезднаяПередача);
	
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения); 
	
	ЗначениеОтбора.Вставить("Организация", Объект.Организация);
	ЗначениеОтбора.Вставить("Контрагент", Объект.Контрагент);
	ЗначениеОтбора.Вставить("Договор", Объект.ДоговорКонтрагента);
	ЗначениеОтбора.Вставить("Валюта", Объект.ВалютаДокумента);
		
	СтруктураПараметров.Вставить("Отбор", ЗначениеОтбора);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение)

	Объект.ДокументыОснования.Очистить();
	
	Если ВыбранноеЗначение.Количество() = 0 Тогда
		
		Объект.ДоговорКонтрагента 	= Неопределено;
		Объект.СуммаДокумента 		= 0;
		Объект.СуммаНДСДокумента 	= 0;
		Объект.ПлатежноРасчетныеДокументы.Очистить();
		
	Иначе
		
		Для Каждого СтрокаСписка Из ВыбранноеЗначение Цикл
			Если СтрокаСписка.Значение.Пустая() Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаТаблицы = Объект.ДокументыОснования.Добавить();
			СтрокаТаблицы.ДокументОснование = СтрокаСписка.Значение;
		КонецЦикла;
		ОпределениеПараметровСчетаФактурыНаРеализациюСервер();
		ВидДоговораКонтрагента	= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДоговорКонтрагента, "ВидДоговора");
		Если НЕ ВидДоговораКонтрагента = Перечисления.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку Тогда
			Объект.Продавец	= Неопределено;
		КонецЕсли;
		ЗаполнитьДатыНомераПлатежноРасчетныхДокументов();
		
	КонецЕсли;
	
	УстановитьВидимость();
	УстановитьКодВидаОперацииНаСервере();
	
	УправлениеФормой(ЭтаФорма);
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьДокументыОснованияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьОснование();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПолучитьРежимЗаписи();
	
	Если ЭтаФорма.Записать(Новый Структура("РежимЗаписи", РежимЗаписи)) Тогда 
		ЭтаФорма.Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииПриИзменении(Элемент)
	
	ТекущийКод = Элемент.СписокВыбора.НайтиПоЗначению(Объект.КодВидаОперации);
	Если ТекущийКод <> Неопределено Тогда
		НадписьВидОперации = Сред(ТекущийКод.Представление, 5);
	Иначе
		НадписьВидОперации = "";
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПолучитьРежимЗаписи()
	
	Проводить = Истина;
	
	Для Каждого Стр из Объект.ДокументыОснования Цикл
		Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Стр.ДокументОснование, "Проведен") Тогда
			Проводить = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Проводить Тогда
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
	Иначе
		РежимЗаписи = РежимЗаписиДокумента.Запись;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ДатаВыставленияПриИзменении(Элемент)
	
	Если Объект.ДатаВыставления < Объект.Дата Тогда 
		Объект.ДатаВыставления = Объект.Дата;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВыборНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьОснование();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборИзСпискаЗавершение(ВыбранныйКод, ДополнительныеПараметры) Экспорт

	Если ВыбранныйКод <> Неопределено Тогда
		Модифицированность = Истина;
		Объект.КодВидаОперации = ВыбранныйКод.Значение;
		НадписьВидОперации = Сред(ВыбранныйКод.Представление, 5);
	КонецЕсли;

КонецПроцедуры

#Область АктуализацияРасчетовСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ОжидатьАктуализацию()
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультатАктуализации", ЭтотОбъект);
		
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Актуализация расчетов с контрагентами'");
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатАктуализации(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ВыполненаАктуализация(Результат) Тогда
		
		ОбщегоНазначенияБПКлиент.ОткрытьФормуОшибокПерепроведения(ЭтотОбъект, АдресХранилищаСОшибками);
		АдресХранилищаСОшибками = "";
		
	КонецЕсли;
	ДлительнаяОперация = Неопределено;
	
КонецПроцедуры

&НаСервере
Функция ВыполненаАктуализация(Результат)
	
	Если Результат.Свойство("АдресРезультата")
	   И ЭтоАдресВременногоХранилища(Результат.АдресРезультата) Тогда
		РезультатРасчета = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		УдалитьИзВременногоХранилища(Результат.АдресРезультата);
	Иначе
		РезультатРасчета = Результат;
	КонецЕсли;
	
	Если РезультатРасчета.Свойство("Сообщения")
	   И РезультатРасчета.Сообщения.Количество() > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДатыНомераПРД = Документы.СчетФактураВыданный.ДатыНомераПлатежноРасчетныхДокументов(
		Объект.ДокументыОснования.Выгрузить(, "ДокументОснование").ВыгрузитьКолонку("ДокументОснование"));
	Для каждого СтрокаТаблицы Из ДатыНомераПРД Цикл
		НоваяСтрока = Объект.ПлатежноРасчетныеДокументы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура НачатьАктуализациюРасчетовСКонтрагентами()
	
	РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Основание, "Проведен,Организация,Дата");
	
	Если Не РеквизитыОснования.Проведен Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка по договорам документа-основания.
	// Проверим, есть ли необходимость актуализировать по договорам, используемым в документе.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Основание",   Параметры.Основание);
	Запрос.УстановитьПараметр("Организация", РеквизитыОснования.Организация);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасчетыСКонтрагентамиОтложенноеПроведение.ДоговорКонтрагента КАК ДоговорКонтрагента
	|ИЗ
	|	РегистрСведений.РасчетыСКонтрагентамиОтложенноеПроведение КАК РасчетыСКонтрагентамиОтложенноеПроведение
	|ГДЕ
	|	РасчетыСКонтрагентамиОтложенноеПроведение.Документ = &Основание
	|	И РасчетыСКонтрагентамиОтложенноеПроведение.Организация = &Организация";
	
	ДоговорыДокумента = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДоговорКонтрагента");
	
	Если ДоговорыДокумента.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
		
	МоментАктуальности = УчетВзаиморасчетовОтложенноеПроведение.МоментАктуальностиОтложенныхРасчетов(
		РеквизитыОснования.Организация, РеквизитыОснования.Дата, Неопределено, ДоговорыДокумента);
		
	Если МоментАктуальности = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	АдресХранилищаСОшибками = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);

	ПараметрыПроцедуры = УчетВзаиморасчетовОтложенноеПроведение.НовыеПараметрыРасчета();
	ПараметрыПроцедуры.Организация             = РеквизитыОснования.Организация;
	ПараметрыПроцедуры.ДатаОкончания           = РеквизитыОснования.Дата;
	ПараметрыПроцедуры.Документ                = Параметры.Основание;
	ПараметрыПроцедуры.ОстанавливатьсяПоОшибке = Истина;
	ПараметрыПроцедуры.АдресХранилищаСОшибками = АдресХранилищаСОшибками;
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = НСтр("ru = 'Актуализация для выписки счета-фактуры'");
	ПараметрыВыполненияВФоне.КлючФоновогоЗадания = Параметры.Основание;
	ПараметрыВыполненияВФоне.ОжидатьЗавершение = 0;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне("УчетВзаиморасчетовОтложенноеПроведение.ВыполнитьОтложенныеРасчетыВФоне",
		ПараметрыПроцедуры, ПараметрыВыполненияВФоне);
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаКонтрагентов

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПроверкиКонтрагентов()
	ПроверкаКонтрагентовКлиент.ОбработатьРезультатПроверкиКонтрагентовВДокументе(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаСервере
Процедура ОтобразитьРезультатПроверкиКонтрагента() Экспорт
	ПроверкаКонтрагентов.ОтобразитьРезультатПроверкиКонтрагентаВДокументе(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаСервере
Процедура ПроверитьКонтрагентовФоновоеЗадание(ПараметрыФоновогоЗадания) Экспорт
	ПроверкаКонтрагентов.ПроверитьКонтрагентовВДокументеФоновоеЗадание(ЭтотОбъект, ПараметрыФоновогоЗадания);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

#КонецОбласти

#КонецОбласти


