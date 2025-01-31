#Область СлужебныйПрограмныйИнтерфейс

// Возвращает через второй параметр признак наличия табачной продукции.
//
// Параметры:
//  Коллекция             - ДанныеФормыКоллекция - ТЧ с товарами.
//  ЕстьТабачнаяПродукция - Булево - Исходящий, признак наличия табачной продукции.
Процедура ЕстьТабачнаяПродукцияВКоллекции(Коллекция, ЕстьТабачнаяПродукция) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаТовары", Коллекция.Выгрузить(, "Номенклатура"));

	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ
	|	ВремТаблТаблицаТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|
	|;
	|
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЕстьТабачнаяПродукция
	|ИЗ
	|	ВремТаблТаблицаТовары КАК ТаблицаТовары
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ТаблицаТовары.Номенклатура = СправочникНоменклатура.Ссылка
	|ГДЕ
	|	СправочникНоменклатура.ТабачнаяПродукция
	|";
	
	Результат = Запрос.Выполнить();
	
	ЕстьТабачнаяПродукция = НЕ Результат.Пустой();
	
КонецПроцедуры

// Возвращает через второй параметр таблицу товаров документа.
//
// Параметры:
//  Контекст             - УправляемаяФорма, ДокументСсылка - контекст определения типа документа.
//  ТаблицаТабачнойПродукции - ТаблицаЗначений - Исходящий, таблица с товарами документа.
Процедура ПриОпределенииТабачнойПродукцииДокумента(Контекст, ТаблицаТабачнойПродукции) Экспорт
	
	ТаблицаТабачнойПродукции = ИнтеграцияМОТПБП.ТаблицаТабачнойПродукцииДокумента(Контекст);
	
КонецПроцедуры

// Предназначена для реализации функциональности по отражению результатов проверки и подбора в документе, из которого была вызвана соотвествующая форма.
// 
// Параметры:
//  ПараметрыОкончанияСканирования - (См. ПроверкаИПодборМОТП.ЗафиксироватьРезультатПроверкиИПодбора).
Процедура ОтразитьРезультатыСканированияВДокументе(ПараметрыОкончанияСканирования) Экспорт
	
	ИнтеграцияМОТПБП.ОтразитьРезультатыСканированияВДокументе(ПараметрыОкончанияСканирования);
	
КонецПроцедуры

// Получает сформированный ранее Акт о расхождениях для переданного документа.
// 
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ, для которого необходимо получить Акт о расхождениях:
//  АктОРасхождениях - ДокументСсылка - ссылка на Акт о расхождениях:
Процедура ПолучитьСформированныйАктОРасхождениях(Документ, АктОРасхождениях) Экспорт
	
	
КонецПроцедуры

// Заполняет в табличной части служебные реквизиты, например: признак использования характеристик номенклатуры.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма.
//  ТабличнаяЧасть - ДанныеФормыКоллекция, ТаблицаЗначений - таблица для заполнения.
Процедура ЗаполнитьСлужебныеРеквизитыВКоллекции(Форма, ТабличнаяЧасть) Экспорт
	
	
КонецПроцедуры

#Область СерииНоменклатуры

// Определяет параметры указания серий для товаров, указанных в форме.
//
// Параметры:
//  Форма - УправляемаяФорма - форма с товарами, для которой необходимо определить параметры указания серий.
//  ПараметрыУказанияСерий - Структура - заполняемые параметры указания серий, состав полей структуры задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
Процедура ЗаполнитьПараметрыУказанияСерий(Форма, ПараметрыУказанияСерий) Экспорт
	
	
КонецПроцедуры

// Формирует текст запроса для расчета статусов указания серий
// Параметры:
//  ТекстЗапроса           - Строка    - формируемый текст запроса.
//  ПараметрыУказанияСерий - Структура - состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий
Процедура СформироватьТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий, ТекстЗапроса) Экспорт
	
	
КонецПроцедуры

// (См. НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий)
Процедура ЗаполнитьСтатусыУказанияСерий(Форма, ПараметрыУказанияСерий) Экспорт
	
	
КонецПроцедуры

// Возвращает через параметр наличие права на добавление элементов справочника СерииНоменклатуры
//
// Параметры:
//  ПравоДобавлениеСерий - Булево - исходящий, наличие права на добавление.
Процедура ОпределитьПравоДобавлениеСерий(ПравоДобавлениеСерий) Экспорт
	
	
КонецПроцедуры

// Устанавливает режим просмотра (доступности, для команд) элементам формы.
//   Переопределение необходимо использовать для совместной работы с аналогичными механизмами.
//   Обработанные здесь реквизиты мледует удалить из массива "Блокируемые элементы".
// 
// Параметры:
//  Форма               - УправляемаяФорма - форма в которой производится изменение доступности
//  БлокируемыеЭлементы - Массив - наименования реквизитов
//  Заблокировать       - Булево - заблокировать или разблокировать реквизиты
Процедура УстановитьТолькоПросмотрЭлементов(
		Форма,
		БлокируемыеЭлементы,
		Заблокировать) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПараметрыИнтеграцииФормыПроверкиИПодбора

// Заполняет специфику интеграции формы проверки и подбора в конкретную форму.
//
// Параметры:
//  Форма - УправляемаяФорма - форма для которой настраиваются параметры интеграции.
//  ПараметрыИнтеграции - (См.ПроверкаИПодборПродукцииМОТП.ПараметрыИнтеграцииФормыПроверкиИПодбора).
Процедура ПриОпределенииПараметровИнтеграцииФормыПроверкиИПодбора(Форма, ПараметрыИнтеграции) Экспорт

	Если СтрНайти(Форма.ИмяФормы, "Документ.ПоступлениеТоваровУслуг") > 0 Тогда
		ПараметрыИнтеграции.ИспользоватьБезТабачнойПродукции = Истина;
		ПараметрыИнтеграции.ИспользоватьСтатусПроверкаЗавершена = Ложь;
		ПараметрыИнтеграции.ИмяРодительскойГруппыФормы = "ГруппаТовары";
		ПараметрыИнтеграции.ИспользоватьКолонкуСтатусаПроверкиПодбора  = Истина;
		ПараметрыИнтеграции.БлокироватьТабличнуюЧастьТоварыПриПроверке = Ложь;
	ИначеЕсли СтрНайти(Форма.ИмяФормы, "Документ.РеализацияТоваровУслуг") > 0 Тогда
		ПараметрыИнтеграции.ИспользоватьБезТабачнойПродукции = Истина;
		ПараметрыИнтеграции.ИспользоватьСтатусПроверкаЗавершена = Ложь;
		ПараметрыИнтеграции.ИмяРодительскойГруппыФормы = "ГруппаТовары";
		ПараметрыИнтеграции.ИмяЭлементаФормыТовары = "ТоварыГруппаНоменклатура";
		ПараметрыИнтеграции.ИспользоватьКолонкуСтатусаПроверкиПодбора  = Истина;
		ПараметрыИнтеграции.БлокироватьТабличнуюЧастьТоварыПриПроверке = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет специфику применения интеграции формы проверки и подбора в конкретную форму.
//
// Параметры:
//  Форма - УправляемаяФорма - форма для которой применяются параметры интеграции.
//
Процедура ПриПримененииПараметровИнтеграцииФормыПроверкиИПодбора(Форма) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
