#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.ПараметрВладелец.Пустая() Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Владелец", Параметры.ПараметрВладелец,
																ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;
	
	Если Не Параметры.ПараметрРодитель.Пустая() Тогда
		Элементы.Список.ТекущийРодитель = Параметры.ПараметрРодитель;
	КонецЕсли;
	
	// ОбщиеМеханизмыИКоманды
	ОТР_ПодключаемыеОбщиеМеханизмыИКоманды.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ОбщиеМеханизмыИКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ЧастоЗадаваемыеВопросы
&НаКлиенте
// Подключаемый обработчик команды перехода к часто задаваемым вопросам.
Процедура Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда)
	
	ОТР_ЧастоЗадаваемыеВопросыКлиент.Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда);
	
КонецПроцедуры
// Конец ЧастоЗадаваемыеВопросы

// СхемыУчета
&НаКлиенте
// Подключаемый обработчик команды перехода к схеме учета.
Процедура Подключаемый_ОткрытьСхемуУчета(Команда)
	
	ОТР_СхемыУчетаКлиент.Подключаемый_ОткрытьСхемуУчета(ЭтаФорма.ИмяФормы);
	
КонецПроцедуры
// Конец СхемыУчета

#КонецОбласти