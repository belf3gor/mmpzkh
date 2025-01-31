////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОтправкаПочтовыхСообщений.ПриСозданииНаСервере(ЭтотОбъект);
	
	СписокСвойств = "ИмяТаблицы";
	Если Параметры.Свойство(СписокСвойств) Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, СписокСвойств);
	КонецЕсли;
	
	// В случае заданного отбора по договору - добавляем пустой договор, так как реквизит в счете не обязательный и может быть незаполнен.
	Если Параметры.Свойство("Отбор") 
		И Параметры.Отбор.Свойство("ДоговорКонтрагента") Тогда 
	
		Документы.СчетНаОплатуПокупателю.ДополнитьОтборПоДоговору(Параметры.Отбор.ДоговорКонтрагента);
	
	КонецЕсли; 
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"СтатусОплатыПоУмолчанию", Перечисления.СтатусОплатыСчета.СтатусНовогоДокумента());
	Список.Параметры.УстановитьЗначениеПараметра(
		"СтатусОтгрузкиПоУмолчанию", Перечисления.СтатусыОтгрузки.СтатусНовогоДокумента());
	
	ОбщегоНазначенияБП.УстановитьВидимостьКолонокДополнительнойИнформации(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти
