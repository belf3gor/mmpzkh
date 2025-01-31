#Область ПрограммныйИнтерфейс

// Определяет использование актов о расхождении после приемки для документа
// 
// Параметры:
// 	Документ     - ДокументСсылка - документ, для которого необходимо определить возможность использования актов о расхождении
// 	Используется - Булево - в данный параметр необходимо установить признак использования актов, по умолчанию установлен в Ложь.
Процедура ОпределитьИспользованиеАктовОРасхождениииПослеПриемки(Документ, Используется) Экспорт
	
	
КонецПроцедуры

// Зполняет переданную таблицу данные из ТЧ документа.
// 
// Параметры:
// 	Документ - ДокументСсылка - Документ из ТЧ которого будет происходить заполнение.
// 	ТаблицаПродукции - ТаблицаЗначений - Таблица для заполнения данными из документа.
//
Процедура СформироватьТаблицуТабачнойПродукцииДокумента(Документ, ТаблицаПродукции) Экспорт
	
	ИнтеграцияМОТПБП.СформироватьТаблицуТабачнойПродукцииДокумента(Документ, ТаблицаПродукции);
	
КонецПроцедуры

#Область Серии

// Предназачена для реализации механизма генерации серий номенклатуры по переданным данным
// 
// Параметры:
// 	ДанныеДляГенерации - (См. ИнтеграцияМОТПУТКлиентСервер.СтруктураДанныхДляГенерацииСерии) - Данные для генерации.
Процедура СгенерироватьСерии(ДанныеДляГенерации) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс


#Область ЭлектроннаяПодпись

// Предназначена для получения сертификата на компьютере по строке отпечатка.
// (См. ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку)
//
// Параметры:
//   Сертификат             - СертификатКриптографии - найденный сертификат электронной подписи и шифрования.
//   Отпечаток              - Строка - Base64 кодированный отпечаток сертификата.
//   ТолькоВЛичномХранилище - Булево - если Истина, тогда искать в личном хранилище, иначе везде.
//   СтандартнаяОбработка   - Булево - признак обработки стандартной библиотекой (установить Ложь при переопределении)
//
Процедура ПриОпределенииСертификатаПоОтпечатку(Сертификат, Отпечаток, ТолькоВЛичномХранилище, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
