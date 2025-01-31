
#Область ОбработчикиКомандФормы

&НаСервере
// Процедура-обработчик события "ПриСозданииНаСервере"
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ДатаПогашения") Тогда
		
		// При открытии формы сразу установим значение даты.
		ДатаПогашения = Параметры.ДатаПогашения;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// При нажетии Кнопки ОК закрывается форма "ДатаПогашения".
Процедура КомандаОК(Команда)
	Закрыть(ДатаПогашения);
КонецПроцедуры

#КонецОбласти