#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагрузитьПараметрыВРеквизитыФормы();
	ПриходныйКассовыйОрдерФормы.ПодготовитьФормуНаСервере(ЭтотОбъект);
	ПриходныйКассовыйОрдерФормы.УстановитьВидимостьСчетовУчета(ЭтотОбъект);
	ПриходныйКассовыйОрдерФормы.УстановитьУсловноеОформление(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы
		И (Модифицированность ИЛИ ПеренестиВДокумент) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И НЕ ПеренестиВДокумент Тогда
		
		Отказ = Истина;
		
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена,, КодВозвратаДиалога.Да);
		
	ИначеЕсли ПеренестиВДокумент Тогда
		
		Отказ = НЕ ПроверитьЗаполнение();
		
		Если Отказ Тогда
			Модифицированность = Истина;
			ПеренестиВДокумент = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ПеренестиВДокумент Тогда
		ИсходящиеПараметры = Новый Структура("СвойстваПлатежа");
		ЗаполнитьЗначенияСвойств(ИсходящиеПараметры,  ЭтотОбъект);
		ИсходящиеПараметры.Вставить("СуммаДокумента", Объект.СуммаДокумента);
		ИсходящиеПараметры.Вставить("Графа5_УСН",     Объект.Графа5_УСН);
		ИсходящиеПараметры.Вставить("АдресХранилищаРасшифровкаПлатежа", АдресХранилищаРасшифровкаПлатежа);
		Модифицированность = Ложь;
		ОповеститьОВыборе(ИсходящиеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Документы.ПриходныйКассовыйОрдер.ОбработкаПроверкиЗаполненияРасшифровкаПлатежа(
		Объект, ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	// Чтобы дважды не вызывать сервер, сразу поместим во временное хранилище 
	// таблицу РасшифровкаПлатежа.
	Если НЕ Отказ Тогда
		АдресХранилищаРасшифровкаПлатежа = ПоместитьРасшифровкаПлатежаВоВременноеХранилище();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыРасшифровкаПлатежа

&НаКлиенте
Процедура РасшифровкаПлатежаПослеУдаления(Элемент)
	
	ПеренумероватьСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПриИзменении(Элемент)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаПриИзменении(ЭтотОбъект, Элемент);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаПриОкончанииРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПередУдалением(Элемент, Отказ)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаПередУдалением(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаПриНачалеРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, Копирование);
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.НомерСтроки = РасшифровкаПлатежа.Количество();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаДоговорКонтрагентаПриИзменении(Элемент)
	
	СтрокаПлатеж = Элементы.РасшифровкаПлатежа.ТекущиеДанные;
	
	ПриходныйКассовыйОрдерФормыКлиентСервер.ИнициализироватьСвойстваПлатежа(ЭтотОбъект); // Только создаем структуру, если она еще не создана.
	
	Если СтрокаПлатеж.ДоговорКонтрагента = СвойстваПлатежа.ДоговорКонтрагента Тогда
		Возврат;
	КонецЕсли;
	
	РасшифровкаПлатежаДоговорКонтрагентаПриИзмененииСервер(СтрокаПлатеж.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаДоговорКонтрагентаОткрытие(Элемент, СтандартнаяОбработка)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаДоговорКонтрагентаОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаДоговорКонтрагентаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаДоговорКонтрагентаОбработкаВыбора(ЭтотОбъект, 
		Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаДоговорКонтрагентаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаДоговорКонтрагентаАвтоПодбор(ЭтотОбъект, 
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСтатьяДвиженияДенежныхСредствПриИзменении(Элемент)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаСтатьяДвиженияДенежныхСредствПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаВыручкиСтатьяДвиженияДенежныхСредствПриИзменении(Элемент)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаВыручкиСтатьяДвиженияДенежныхСредствПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСпособПогашенияЗадолженностиПриИзменении(Элемент)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаСпособПогашенияЗадолженностиПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСделкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаСделкаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСуммаПлатежаПриИзменении(Элемент)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаСуммаПлатежаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаКурсВзаиморасчетовПриИзменении(Элемент)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаКурсВзаиморасчетовПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаКурсВзаиморасчетовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаКурсВзаиморасчетовНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСуммаВзаиморасчетовПриИзменении(Элемент)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаСуммаВзаиморасчетовПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСтавкаНДСПриИзменении(Элемент)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаСтавкаНДСПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСчетУчетаРасчетовСКонтрагентомПриИзменении(Элемент)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаСчетУчетаРасчетовСКонтрагентомПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПолеОтражениеАвансаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаПолеОтражениеАвансаОбработкаВыбора(ЭтотОбъект, 
		Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПолеОтражениеАвансаПриИзменении(Элемент)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаПолеОтражениеАвансаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПолеОтражениеАвансаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаПолеОтражениеАвансаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПолеОтражениеДоходаПриИзменении(Элемент)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаПолеОтражениеДоходаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПолеОтражениеДоходаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаПолеОтражениеДоходаНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПолеОтражениеДоходаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаПолеОтражениеДоходаОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыРасшифровкаВыручки

&НаКлиенте
Процедура РасшифровкаВыручкиПриИзменении(Элемент)
	
	СуммаДоИзменения = Объект.СуммаДокумента;
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаВыручкиПриИзменении(ЭтотОбъект);
	
	Если ПрименениеУСН И СуммаДоИзменения <> Объект.СуммаДокумента Тогда
		ЗаполнитьОтражениеВУСН(Истина, Ложь);
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаВыручкиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаВыручкиПриОкончанииРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаВыручкиПередУдалением(Элемент, Отказ)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаВыручкиПередУдалением(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаВыручкиСуммаПлатежаПриИзменении(Элемент)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаВыручкиСуммаПлатежаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаВыручкиСтавкаНДСПриИзменении(Элемент)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаВыручкиСтавкаНДСПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаВыручкиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаВыручкиПриНачалеРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, Копирование);
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.НомерСтроки = РасшифровкаПлатежа.Количество();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаВыручкиПолеОтражениеДоходаПриИзменении(Элемент)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаПолеОтражениеДоходаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаВыручкиПолеОтражениеДоходаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаПолеОтражениеДоходаНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаВыручкиПолеОтражениеДоходаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПриходныйКассовыйОрдерФормыКлиент.РасшифровкаПлатежаПолеОтражениеДоходаОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьИСохранить(Команда)
	
	Если Модифицированность Тогда
		ПеренестиВДокумент = Истина;
		Закрыть(КодВозвратаДиалога.OK);
	Иначе
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеФункцииИПроцедуры

&НаКлиенте
Процедура ПеренумероватьСтроки()
	
	Для Счетчик = 0 По РасшифровкаПлатежа.Количество() - 1 Цикл
		РасшифровкаПлатежа[Счетчик].НомерСтроки = Счетчик + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьРасшифровкаПлатежаВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(РасшифровкаПлатежа.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПараметрыВРеквизитыФормы()
	
	Объект = Новый Структура;
	Для каждого ПараметрЗаполнения Из Параметры.ПараметрыФормы.Шапка Цикл
		Объект.Вставить(ПараметрЗаполнения.Ключ, ПараметрЗаполнения.Значение);
	КонецЦикла;
	
	Объект.Вставить("ДополнительныеСвойства", Новый Структура()); // Используется при проверке заполнения.

	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ПараметрыФормы.Шапка);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ПараметрыФормы);
	
	Если ЗначениеЗаполнено(Параметры.ПараметрыФормы.АдресХранилищаРасшифровкаПлатежа) Тогда
		РасшифровкаПлатежа.Загрузить(ПолучитьИзВременногоХранилища(Параметры.ПараметрыФормы.АдресХранилищаРасшифровкаПлатежа));
	КонецЕсли;
	
	Ссылка = Параметры.Ключ;
	
	Если РасшифровкаПлатежа.Количество() = 0 Тогда
		РасшифровкаПлатежа.Добавить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РасшифровкаПлатежаДоговорКонтрагентаПриИзмененииСервер(ИдСтроки)
	
	СтрокаПлатеж = РасшифровкаПлатежа.НайтиПоИдентификатору(ИдСтроки);
	
	ПриходныйКассовыйОрдерФормы.РасшифровкаПлатежаДоговорКонтрагентаПриИзмененииНаСервере(ЭтотОбъект, СтрокаПлатеж);
	
КОнецПроцедуры

&НаСервере
Процедура ЗаполнитьОтражениеВУСН(ЗаполнитьСуммы = Истина, ЗаполнитьСодержание = Ложь)
	
	ПриходныйКассовыйОрдерФормы.ЗаполнитьОтражениеВУСН(ЭтотОбъект, ЗаполнитьСуммы, ЗаполнитьСодержание);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЗАВЕРШЕНИЕ НЕМОДАЛЬНЫХ ВЫЗОВОВ

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


