#Область ПроцедурыИФункцииОбщегоНазначения

&НаСервереБезКонтекста
// Функция возвращает соответствие между ссылкой на категорию должника и строку представления.
//
Функция ПолучитьСоответствиеПредставленийИКатегорийДолжников(МассивКатегорий)
	
	СоответствиеКатегорийИПредставлений = Новый Соответствие;
	
	// Получаем исходные данные для формирования представлений.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УПЖКХ_КатегорииДолжников.Ссылка КАК КатегорияДолжника,
	|	УПЖКХ_КатегорииДолжников.ПоПериоду КАК ПоПериоду,
	|	УПЖКХ_КатегорииДолжников.ПоПериодуОт КАК ПоПериодуОт,
	|	УПЖКХ_КатегорииДолжников.ПоПериодуДо КАК ПоПериодуДо,
	|	УПЖКХ_КатегорииДолжников.ПоСумме КАК ПоСумме,
	|	УПЖКХ_КатегорииДолжников.ПоСуммеОт КАК ПоСуммеОт,
	|	УПЖКХ_КатегорииДолжников.ПоСуммеДо КАК ПоСуммеДо
	|ИЗ
	|	Справочник.УПЖКХ_КатегорииДолжников КАК УПЖКХ_КатегорииДолжников
	|ГДЕ
	|	УПЖКХ_КатегорииДолжников.Ссылка В(&МассивКатегорий)";
	
	Запрос.УстановитьПараметр("МассивКатегорий", МассивКатегорий);
	
	ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Формирует элементы соответствия. Для каждой категории определяется строка представления.
		СоответствиеКатегорийИПредставлений.Вставить(ВыборкаДетальныеЗаписи.КатегорияДолжника, УПЖКХ_РаботаСДолжниками.СформироватьПредставлениеКатегорииПоИсходнымДанным(ВыборкаДетальныеЗаписи));
	КонецЦикла;
	
	Возврат СоответствиеКатегорийИПредставлений;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
// Процедура-обработчик события "ПриПолученииДанныхНаСервере" динамического списка "Список".
//
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	МассивКатегорий = Новый Массив;
	
	Для Каждого СтрокаСписка Из Строки Цикл
		
		Если Не СтрокаСписка.Значение.Данные.Свойство("УсловияОтнесенияДолжникаККатегории") Тогда
			Возврат;
		КонецЕсли;
	
		// Добавляет ссылки на категории в массив.
		МассивКатегорий.Добавить(СтрокаСписка.Ключ);
		
	КонецЦикла;
	
	// Получаем соответсвие категорий и представлений.
	СоответствиеКатегорийИПредставлений = ПолучитьСоответствиеПредставленийИКатегорийДолжников(МассивКатегорий);
	
	// Отображаем строки представления в динамическком списке.
	Для Каждого СтрокаСписка Из Строки Цикл
		СтрокаСписка.Значение.Данные.УсловияОтнесенияДолжникаККатегории = СоответствиеКатегорийИПредставлений.Получить(СтрокаСписка.Ключ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти