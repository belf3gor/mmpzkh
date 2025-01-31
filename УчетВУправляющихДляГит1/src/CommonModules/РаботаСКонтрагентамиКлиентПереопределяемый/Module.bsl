///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПроверкаКонтрагентов

// Определение по имени события обработки оповещения необходимости выполнить запуск проверки контрагентов.
//
// Параметры:
//  Форма							 - УправляемаяФорма - Форма документа, в котором возникло событие обработки оповещения.
//  ИмяСобытия						 - Строка - Имя события обработки оповещения.
//  Параметр						 - Произвольный - Параметр обработки оповещения.
//  Источник						 - Произвольный - Источник обработки оповещения.
//  ТребуетсяПроверкаКонтрагентов	 - Булево - Результат определения необходимости выполнять проверку контрагента по
//                                            наступлению события.
Процедура ОпределитьНеобходимостьПроверкиКонтрагентовВОбработкеОповещения(
		Форма, ИмяСобытия, Параметр, Источник, ТребуетсяПроверкаКонтрагентов) Экспорт
	
	ДокументОбъект 	= Форма.Объект;
	ДокументСсылка 	= ДокументОбъект.Ссылка;
	ТипДокумента 	= ТипЗнч(ДокументСсылка);
	
	Если (ТипДокумента = Тип("ДокументСсылка.СчетФактураВыданный")
		ИЛИ ТипДокумента = Тип("ДокументСсылка.СчетФактураПолученный")) Тогда
		
		// В счетах-фактурах проверку выполняем только при записи контрагента
		ТребуетсяПроверкаКонтрагентов = ИмяСобытия = "Запись_Контрагенты";
		
	ИначеЕсли ИмяСобытия = "Запись_СчетФактураПолученный" 
		ИЛИ ИмяСобытия = "Запись_СчетФактураВыданный"
		ИЛИ ИмяСобытия = "Запись_СчетФактураВыданныйКорректировочный"
		ИЛИ ИмяСобытия = "Запись_СчетФактураПолученныйКорректировочный" Тогда
		
		// Проверяем только если в документе счет-фактура находится в подвале
		
		ТребуетсяПроверкаКонтрагентов = ПроверкаКонтрагентовКлиентСервер.ЭтоДокументСоСчетомФактуройВПодвале(Форма);
		
	ИначеЕсли ИмяСобытия = "Запись_Контрагенты" Тогда
		
		// При записи контрагента проверку делаем в любом случае
		ТребуетсяПроверкаКонтрагентов = Истина;
		
	Иначе
		
		ТребуетсяПроверкаКонтрагентов = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Позволяет заменить стандартное предложение включить проверку контрагентов.
//
// Параметры:
//  СтандартнаяОбработка  - Булево - Истина, если нужно сохранить стандартное поведение.
//
Процедура ПредложитьВключитьПроверкуКонтрагентов(СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
