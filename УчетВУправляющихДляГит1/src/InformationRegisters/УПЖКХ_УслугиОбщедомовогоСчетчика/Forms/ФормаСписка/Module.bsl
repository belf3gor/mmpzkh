
#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура устанавливает условное оформление для элементов управления формы.
//
Процедура УстановитьУсловноеОформление(ТекущаяУслуга)
	
	// Выделяет ячейки с текущей услугой.
	
	// Условное оформление для колонки "Услуга".
	ЭлементОформленияУслуга = Список.УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбора = ЭлементОформленияУслуга.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Услуга");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = ТекущаяУслуга;
	ЭлементОтбора.Использование  = Истина;
	
	ЭлементОформленияУслуга.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,, Истина));
	
	ПолеОформления = ЭлементОформленияУслуга.Поля.Элементы.Добавить();
	ПолеОформления.Поле          = Новый ПолеКомпоновкиДанных("Услуга");
	ПолеОформления.Использование = Истина;
	
	// Условное оформление для колонки "УслугаОбщедомовогоСчетчика".
	ЭлементОформленияУслугаОбщедомовогоСчетчика = Список.УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбора = ЭлементОформленияУслугаОбщедомовогоСчетчика.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("УслугаОбщедомовогоСчетчика");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = ТекущаяУслуга;
	ЭлементОтбора.Использование  = Истина;
	
	ЭлементОформленияУслугаОбщедомовогоСчетчика.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,, Истина));
	
	ПолеОформления = ЭлементОформленияУслугаОбщедомовогоСчетчика.Поля.Элементы.Добавить();
	ПолеОформления.Поле          = Новый ПолеКомпоновкиДанных("УслугаОбщедомовогоСчетчика");
	ПолеОформления.Использование = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ОбщиеМеханизмыИКоманды
	ОТР_ПодключаемыеОбщиеМеханизмыИКоманды.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ОбщиеМеханизмыИКоманды
	
	// Если получена текущая услуга, т.е. регистр открыли из
	// другой формы и передали текущую услугу,
	// то отбраем элементы регистра содержающие данную услугу
	// и выделяем ее для того, чтобы пользователю было понятно,
	// где услуга является зависимой, а где базой.
	Если Параметры.Свойство("Услуга") Тогда
		
		// Отбираем текущую услугу.
		ГруппаИли = УПЖКХ_ТиповыеМетодыКлиентСервер.СоздатьГруппуЭлементовОтбора(Список.КомпоновщикНастроек.Настройки.Отбор.Элементы,
					"ГруппаОтбор", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьЭлементОтбора(
					ГруппаИли, "Услуга", Параметры.Услуга, ВидСравненияКомпоновкиДанных.Равно);
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьЭлементОтбора(
					ГруппаИли, "УслугаОбщедомовогоСчетчика", Параметры.Услуга, ВидСравненияКомпоновкиДанных.Равно);
		
		// Выделяем текущую услугу.
		УстановитьУсловноеОформление(Параметры.Услуга);
		
	КонецЕсли;
	
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

#КонецОбласти
