
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользуетсяОбменСБанками = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ЗначениеФункциональнойОпции(
		"ИспользоватьОбменСБанками");
	Если НЕ ИспользуетсяОбменСБанками Тогда
		ТекстСообщения = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ТекстСообщенияОНеобходимостиНастройкиСистемы(
			"РаботаСБанками");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьПараметры();
	Элементы.ВыполнитьОбменСБанком.Доступность = ЗначениеЗаполнено(Объект.НастройкаОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		Элементы.ВыпискиБанка.Обновить();
	ИначеЕсли ИмяСобытия = "ПолученыВыписки" Тогда
		Элементы.ВыпискиБанка.Обновить();
		ПоследнийЭД = ПоследнийЭД(Объект.НастройкаОбмена);
		Если ЗначениеЗаполнено(ПоследнийЭД) Тогда
			Элементы.ВыпискиБанка.ТекущаяСтрока = ПоследнийЭД;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НастройкаОбменаПриИзменении(Элемент)
	
	ЗаполнитьПараметры();
	Модифицированность = Ложь;
	Элементы.ВыполнитьОбменСБанком.Доступность = ЗначениеЗаполнено(Объект.НастройкаОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	Модифицированность = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыписки

&НаКлиенте
Процедура ВыпискиБанкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Элементы.ВыпискиБанка.ТекущаяСтрока = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗапроситьВыписку(Команда)
	
	Если Не ЗначениеЗаполнено(Период) Тогда
		СообщениеТекст = НСтр("ru = 'Необходимо выбрать период запроса'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеТекст, , "Период");
		Возврат;
	КонецЕсли;
	
	ОбменСБанкамиКлиент.ПолучитьВыпискуБанка(
		Объект.НастройкаОбмена, Период.ДатаНачала, Период.ДатаОкончания, Элементы.ВыпискиБанка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьПараметры()
	
	Если ЗначениеЗаполнено(Объект.НастройкаОбмена) Тогда
		РеквизитыНастройкиОбмена = РеквизитыНастройкиОбмена(Объект.НастройкаОбмена);
		Объект.Банк         = РеквизитыНастройкиОбмена.Банк;
		Объект.Организация  = РеквизитыНастройкиОбмена.Организация;
		ПрограммаБанка      = РеквизитыНастройкиОбмена.ПрограммаБанка;
	Иначе
		СправочникОрганизации = ЭлектронноеВзаимодействиеСлужебныйКлиентПовтИсп.ИмяПрикладногоСправочника("Организации");
		СправочникБанки = ЭлектронноеВзаимодействиеСлужебныйКлиентПовтИсп.ИмяПрикладногоСправочника("Банки");
		Объект.Банк        = ПредопределенноеЗначение("Справочник." + СправочникБанки + ".ПустаяСсылка");
		Объект.Организация = ПредопределенноеЗначение("Справочник." + СправочникОрганизации + ".ПустаяСсылка");
		ПрограммаБанка     = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.ПустаяСсылка");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.НастройкаОбмена) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ВыпискиБанка, "НастройкаОбмена", Объект.НастройкаОбмена);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ВыпискиБанка, "НастройкаОбмена");
	КонецЕсли;

	Элементы.ГруппаДоступа.Доступность = ЗначениеЗаполнено(Объект.НастройкаОбмена);

	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РеквизитыНастройкиОбмена(НастройкаОбмена)
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаОбмена, "Организация, Банк, ПрограммаБанка");
	
КонецФункции

&НаСервереБезКонтекста
Функция ПоследнийЭД(НастройкаОбмена)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СообщениеОбменСБанками.Ссылка КАК СообщениеОбменСБанками
	|ИЗ
	|	Документ.СообщениеОбменСБанками КАК СообщениеОбменСБанками
	|ГДЕ
	|	СообщениеОбменСБанками.НастройкаОбмена = &НастройкаОбмена
	|	И СообщениеОбменСБанками.ВидЭД = ЗНАЧЕНИЕ(Перечисление.ВидыЭДОбменСБанками.ВыпискаБанка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	СообщениеОбменСБанками.Дата УБЫВ";
	Запрос.УстановитьПараметр("НастройкаОбмена", НастройкаОбмена);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СообщениеОбменСБанками;
	КонецЕсли
	
КонецФункции

&НаКлиенте
Процедура ВыпискиБанкаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбменСБанкамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(ВыбраннаяСтрока);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

