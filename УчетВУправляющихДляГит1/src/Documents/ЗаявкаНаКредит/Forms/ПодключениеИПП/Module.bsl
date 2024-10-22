#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отказ = Истина;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПодключенияИнтернетПоддержки", ЭтотОбъект);	

	ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОписаниеОповещения, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеПодключенияИнтернетПоддержки(Результат, ДополнительныеПараметры) Экспорт

	Если Результат <> Неопределено Тогда
		// Откроем основную форму новой заявки.
		ОткрытьФорму("Документ.ЗаявкаНаКредит.ФормаОбъекта");
	Иначе
		// Пользователь отказался от подключения либо у него не хватило прав.
		ТекстСообщения = НСтр("ru = 'Для отправки заявок на кредит необходимо подключение Интернет-поддержки'");
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;
	
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
