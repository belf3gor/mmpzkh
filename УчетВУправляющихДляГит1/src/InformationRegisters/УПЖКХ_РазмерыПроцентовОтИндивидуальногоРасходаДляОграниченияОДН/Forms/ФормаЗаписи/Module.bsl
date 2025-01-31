
#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы записи.
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		Запись.Организация = УПЖКХ_ТиповыеМетодыВызовСервера.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		ЗаполнитьЗначенияСвойств(Запись, ЭтаФорма.Параметры.ЗначенияЗаполнения);
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти