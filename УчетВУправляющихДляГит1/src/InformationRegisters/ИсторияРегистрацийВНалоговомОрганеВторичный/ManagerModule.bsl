#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(СтруктурнаяЕдиница)
	|	ИЛИ ЗначениеРазрешено(СтруктурнаяЕдиница.Владелец)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьВторичныеДанныеИсторияРегистрацийВНалоговомОргане(ПараметрыОбновления = Неопределено) Экспорт
	ЗаполнитьВторичныеДанные();
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
КонецПроцедуры

Процедура ЗаполнитьВторичныеДанные(СтруктурнаяЕдиница = Неопределено) Экспорт
	
	Набор = РегистрыСведений.ИсторияРегистрацийВНалоговомОрганеВторичный.СоздатьНаборЗаписей();
	Набор.ОбменДанными.Загрузка = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИсторияРегистрацийВНалоговомОргане.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
	|	ИсторияРегистрацийВНалоговомОргане.Период КАК Период
	|ИЗ
	|	РегистрСведений.ИсторияРегистрацийВНалоговомОргане КАК ИсторияРегистрацийВНалоговомОргане
	|ГДЕ
	|	ИсторияРегистрацийВНалоговомОргане.СтруктурнаяЕдиница = &СтруктурнаяЕдиница
	|
	|УПОРЯДОЧИТЬ ПО
	|	СтруктурнаяЕдиница,
	|	Период";
	
	Если СтруктурнаяЕдиница = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИсторияРегистрацийВНалоговомОргане.СтруктурнаяЕдиница = &СтруктурнаяЕдиница", "(ИСТИНА)");
		Набор.Записать();
	Иначе
		Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Если СтруктурнаяЕдиница <> Неопределено Тогда
			Набор.Отбор.СтруктурнаяЕдиница.Установить(СтруктурнаяЕдиница);
			Набор.Записать();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Пока Выборка.СледующийПоЗначениюПоля("СтруктурнаяЕдиница") Цикл
		
		Набор.Отбор.СтруктурнаяЕдиница.Установить(Выборка.СтруктурнаяЕдиница);
		
		Пока Выборка.Следующий() Цикл
			Если Набор.Количество() > 0 Тогда
				Набор[Набор.Количество() - 1].ДатаОкончания = Выборка.Период - 1;
			КонецЕсли;
			
			Запись = Набор.Добавить();
			Запись.ДатаНачала = Выборка.Период;
			Запись.СтруктурнаяЕдиница = Выборка.СтруктурнаяЕдиница;
			Запись.РегистрацияВНалоговомОргане = Выборка.РегистрацияВНалоговомОргане;
		КонецЦикла;
		
		Набор[Набор.Количество() - 1].ДатаОкончания = ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата();
		Набор.Записать();
		Набор.Очистить();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли