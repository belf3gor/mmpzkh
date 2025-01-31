#Область ПрограммныйИнтерфейс

Процедура ВидыПодключаемыхКоманд(Результат) Экспорт
	
	Результат = Новый Массив;
	
КонецПроцедуры

#Область КомандыДокументовВЕТИС

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыИсходящейТранспортнойОперации(Команды) Экспорт
	
	ПодключаемыеКомандыВЕТИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"РеализацияТоваровУслуг",  НСтр("ru = 'Реализация товаров и услуг'"));
	ПодключаемыеКомандыВЕТИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ВозвратТоваровПоставщику",  НСтр("ru = 'Возврат товаров поставщику'"));
	ПодключаемыеКомандыВЕТИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПеремещениеТоваров",  НСтр("ru = 'Перемещение товаров'"));
	
КонецПроцедуры

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыВходящейТранспортнойОперации(Команды) Экспорт
	
	ПодключаемыеКомандыВЕТИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ПоступлениеТоваровУслуг", НСтр("ru = 'Поступление товаров и услуг'"));
	ПодключаемыеКомандыВЕТИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПоступлениеТоваровУслуг",  НСтр("ru = 'Поступление товаров и услуг'"));
	
КонецПроцедуры

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыПроизводственнойОперации(Команды) Экспорт
	
	ПодключаемыеКомандыВЕТИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ОтчетПроизводстваЗаСмену",  НСтр("ru = 'Отчет производства за смену'"));
	
КонецПроцедуры

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыИнвентаризацииПродукции(Команды) Экспорт
	
	ПодключаемыеКомандыВЕТИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"СписаниеТоваров",  НСтр("ru = 'Списание товаров'"));
	ПодключаемыеКомандыВЕТИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ОприходованиеТоваров",  НСтр("ru = 'Оприходование товаров'"));
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеВидимостьюКомандВЕТИС

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандИсходящейТранспортнойОперации(Форма, КомандыОбъекта) Экспорт
	
	Если ЗначениеЗаполнено(Форма.Объект.ДокументОснование)Тогда
		Форма.Элементы.ГруппаКомандыЗаполненияОснования.Видимость = Ложь;
		Возврат;
	Иначе 
		Форма.Элементы.ГруппаКомандыЗаполненияОснования.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандВходящейТранспортнойОперации(Форма, КомандыОбъекта) Экспорт
	
	Если ЗначениеЗаполнено(Форма.Объект.ДокументОснование)Тогда
		Форма.Элементы.ГруппаКомандыЗаполненияОснования.Видимость = Ложь;
		Возврат;
	Иначе 
		Форма.Элементы.ГруппаКомандыЗаполненияОснования.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандПроизводственнойОперации(Форма, КомандыОбъекта) Экспорт
	
	Если ЗначениеЗаполнено(Форма.Объект.ДокументОснование)Тогда
		Форма.Элементы.ГруппаКомандыЗаполненияОснования.Видимость = Ложь;
		Возврат;
	Иначе 
		Форма.Элементы.ГруппаКомандыЗаполненияОснования.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандИнвентаризацииПродукции(Форма, КомандыОбъекта) Экспорт
	
	Если ЗначениеЗаполнено(Форма.Объект.ДокументОснование)Тогда
		Форма.Элементы.ГруппаКомандыЗаполненияОснования.Видимость = Ложь;
		Возврат;
	Иначе 
		Форма.Элементы.ГруппаКомандыЗаполненияОснования.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
