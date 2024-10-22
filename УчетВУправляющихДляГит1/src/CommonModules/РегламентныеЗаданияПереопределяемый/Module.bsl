///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет следующие свойств регламентных заданий:
//  - зависимость от функциональных опций;
//  - возможность выполнения в различных режимах работы программы;
//  - прочие параметры.
//
// Параметры:
//  Настройки - ТаблицаЗначений - таблица значений с колонками:
//    * РегламентноеЗадание - ОбъектМетаданных:РегламентноеЗадание - регламентное задание.
//    * ФункциональнаяОпция - ОбъектМетаданных:ФункциональнаяОпция - функциональная опция,
//        от которой зависит регламентное задание.
//    * ЗависимостьПоИ      - Булево - если регламентное задание зависит более чем
//        от одной функциональной опции и его необходимо включать только тогда,
//        когда все функциональные опции включены, то следует указывать Истина
//        для каждой зависимости.
//        По умолчанию Ложь - если хотя бы одна функциональная опция включена,
//        то регламентное задание тоже включено.
//    * ВключатьПриВключенииФункциональнойОпции - Булево, Неопределено - если Ложь, то при
//        включении функциональной опции регламентное задание не будет включаться. Значение
//        Неопределено соответствует значению Истина.
//        По умолчанию - Неопределено.
//    * ДоступноВПодчиненномУзлеРИБ - Булево, Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в РИБ.
//        По умолчанию - Неопределено.
//    * ДоступноВАвтономномРабочемМесте - Булево, Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в автономном рабочем месте.
//        По умолчанию - Неопределено.
//    * ДоступноВМоделиСервиса      - Булево, Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в модели сервиса.
//        По умолчанию - Неопределено.
//    * РаботаетСВнешнимиРесурсами  - Булево - Истина, если регламентное задание модифицирует данные
//        во внешних источниках (получение почты, синхронизация данных и т.п.). Не следует устанавливать
//        значение Истина для регламентных заданий, не модифицирующих данные во внешних источниках.
//        Например, регламентное задание ЗагрузкаКурсовВалют. Регламентные задания, работающие с внешними ресурсами,
//        автоматически отключаются в копии информационной базы. По умолчанию - Ложь.
//    * Параметризуется             - Булево - Истина, если регламентное задание параметризованное.
//        По умолчанию - Ложь.
//
// Пример:
//	Настройка = Настройки.Добавить();
//	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеСтатусовДоставкиSMS;
//	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьПочтовыйКлиент;
//	Настройка.ДоступноВМоделиСервиса = Ложь;
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЗагрузкаКурсовВалют;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВалютныйУчет;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеПроверокКонтролирующимиОрганамиПоТаблицеОрганизаций;
	Настройка.Параметризуется = Истина;
	
	// ЕГАИС
	ИнтеграцияЕГАИС.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	// Конец ЕГАИС
	
	// ИнтеграцияГИСМ
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОтправкаПолучениеДанныхГИСМ;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ;
	// Конец ИнтеграцияГИСМ
	
	ЭлектронноеВзаимодействие.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	
	ОбщегоНазначенияБРО.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборот = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияС1СДокументооборот");
		МодульИнтеграцияС1СДокументооборот.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом

	// Универсальный обмен с банками
	УниверсальныйОбменСБанками.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	
	ОбменДаннымиСВнешнимиСистемамиБПИнтеграцияПодсистем.ЗарегистрироватьРегламентноеЗадание(Настройки);
	
КонецПроцедуры

// Позволяет переопределить настройки подсистемы, заданные по умолчанию.
//
// Параметры:
//  Настройки - Структура - структура с ключами:
//    * РасположениеКомандыСнятияБлокировки - Строка - определяет расположение команды снятия
//                                                     блокировки работы с внешними ресурсами
//                                                     при перемещении информационной базы.
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
КонецПроцедуры


#КонецОбласти