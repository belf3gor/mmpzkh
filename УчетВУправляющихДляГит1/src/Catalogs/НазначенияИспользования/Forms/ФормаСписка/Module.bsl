#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		Если ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
			Услуга   = Параметры.Отбор.Владелец.Услуга;
			Владелец = Параметры.Отбор.Владелец;
		КонецЕсли;
	Иначе
		ТекстСообщения = НСтр("ru='Непосредственное открытие этой формы не предусмотрено.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.НазначенияИспользования);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Услуга Тогда
		Сообщение = НСтр("ru='Для номенклатуры %Владелец% не применяются назначения использования!'");
		Сообщение = СтрЗаменить(Сообщение, "%Владелец%", Владелец); 
		ПоказатьПредупреждение( , Сообщение);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

#КонецОбласти
