
#Область ПроцедурыИФункцииОбщегоНазначения

&НаСервере
// Процедура обновляет список стояков текущего проекта.
//
Процедура ОбновитьТаблицуСтояковНаСервере(ТекущийОбъект)
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьЭлементОтбора(СписокСтояков.Отбор, "Владелец", ТекущийОбъект.Ссылка, ВидСравненияКомпоновкиДанных.Равно);
	
КонецПроцедуры // ОбновитьТаблицуСтояковНаСервере()

&НаКлиенте
Процедура ОткрытьФормуПомощникаСозданияСтояковПроекта()
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ПроектПомещения", Объект.Ссылка);
	
	ОткрытьФорму("Справочник.УПЖКХ_ПроектыПомещений.Форма.ПомощникСозданияСтояковПроекта", 
					ПараметрыОткрытия, 
					ЭтаФорма,,,,,
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьТаблицуСтояковНаСервере(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Устанавливаем отбор по проекту для стояков.
	Если Объект.Ссылка.Пустая() Тогда
		ОбновитьТаблицуСтояковНаСервере(ТекущийОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ОбработкаОповещения" формы.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСведенияОСтояках" Тогда
		Элементы.СписокСтояков.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Обработчик команды "ПомощникСозданияСтояков".
//
Процедура ПомощникСозданияСтояков(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		ТекстВопроса = "Перед созданием стояков проект необходимо записать. Продолжить?";
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбработатьРезультатВопросаПередНачаломСозданияСтояков", ЭтотОбъект), 
							ТекстВопроса, 
							РежимДиалогаВопрос.ДаНет, 
							, 
							КодВозвратаДиалога.Да);
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуПомощникаСозданияСтояковПроекта();
	
КонецПроцедуры

&НаКлиенте
// Процедура-обработчик результата вопроса, вызванного в процедуре "ПомощникСозданияСтояков()".
Процедура ОбработатьРезультатВопросаПередНачаломСозданияСтояков(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да И Записать() Тогда
		ОткрытьФормуПомощникаСозданияСтояковПроекта();
	КонецЕсли;
	
КонецПроцедуры // ОбработатьРезультатВопросаПередНачаломСозданияСтояков()

#КонецОбласти
