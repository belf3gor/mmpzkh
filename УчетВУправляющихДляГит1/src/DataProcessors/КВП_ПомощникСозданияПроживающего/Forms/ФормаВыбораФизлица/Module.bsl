
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ФизЛица") Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьЭлементОтбора(СписокФизЛиц.Отбор, "Ссылка", Параметры.ФизЛица,
																ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриЗакрытии" формы.
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Оповестить("ЗакрытаФормаВыбораФизлиц", ВыбранноеФизлицо, );
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Обработчик события "Выбор" поля "СписокФизЛиц".
Процедура СписокФизЛицВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ВыбраннаяСтрока = Неопределено Тогда
		ПараметрыФормы = Новый Структура("Ключ", ВыбраннаяСтрока);
		ОткрытьФорму("Справочник.ФизическиеЛица.Форма.ФормаЭлемента", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПередНачаломДобавления" поля "СписокФизЛиц".
Процедура СписокФизЛицПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

#Область ОбработчикиКомандФормы

&НаКлиенте
// Обработчик команды "ВыбратьОтмеченноеВСписке".
Процедура ВыбратьВыделенноеВСписке(Команда)
	
	Если Не Элементы.СписокФизЛиц.ТекущаяСтрока = Неопределено Тогда
		ВыбранноеФизлицо = Элементы.СписокФизЛиц.ТекущаяСтрока;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
// Обработчик команды "СоздатьНовоеФизлицо".
Процедура СоздатьНовоеФизлицо(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти