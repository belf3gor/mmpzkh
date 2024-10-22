#Область ОписаниеПеременных

// СтандартныеПодсистемы

// Хранилище глобальных переменных.
//
// ПараметрыПриложения - Соответствие - хранилище переменных, где:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Инициализация (на примере СообщенияДляЖурналаРегистрации):
//   ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
//   Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Использование (на примере СообщенияДляЖурналаРегистрации):
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(...);
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"] = ...;
Перем ПараметрыПриложения Экспорт;

// Конец СтандартныеПодсистемы

//РаботаСВнешнимОборудованием
Перем глПодключаемоеОборудование Экспорт; // для кэширования на клиенте
Перем глПодключаемоеОборудованиеСобытиеОбработано Экспорт; // для предотвращения повторной обработки события

Перем глДоступныеТипыОборудования Экспорт;
//Конец РаботаСВнешнимОборудованием

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередНачаломРаботыСистемы(Отказ)
	
	// Квартплата +
	
	// Запуск программы запрещен, если нет административных прав, или недоступна роль "Пользователь".
	// Это необходимо для доступа к служебным константам и др. объектам КВП.
	Если Не КВП_ПрочиеПроцедурыИФункции.РолиДляЗапускаПрограммыДоступны() Тогда
		
		ПоказатьПредупреждение( , "Вам не назначена роль ""Пользователь"". Запуск конфигурации невозможен.");
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	// Управление режимом отладки +
	
	// Каждый раз при запуске системы принудительно отключаем режим отладки.
	УПЖКХ_ОбщегоНазначенияСервер.УстановитьИспользованиеРежимаОтладкиПоУмолчанию();
	
	// Управление режимом отладки -
	
	// Запускает клиент тестирования и выполняет сценарий, если в форме настроек
	// обработки "ОТР_ЗапускСценариевДействийПользователя" установлены настройки для автоматического запуска сценария.
	ОТР_ЗапускСценариевДействийПользователяКлиент.ЗапуститьСценарий(ПараметрЗапуска,Отказ);
	
	// Квартплата -
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователейКлиент.ПередНачаломРаботыСистемы();
	// Конец ИнтернетПоддержкаПользователей
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПередНачаломРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
	//РаботаСВнешнимОборудованием
	МенеджерОборудованияКлиент.ПриНачалеРаботыСистемы();
	//Конец РаботаСВнешнимОборудованием
	
	// АТК +
	// Если запуск программы выполняется в режиме автоматического тестирования
	// конфигурации, то выполнение стандартных обработчиков прекращаем.
	Если ПроверитьНеобходимостьИЗапуститьАвтоматическоеТестированиеКонфигурации() Тогда
		Возврат;
	КонецЕсли;
	// АТК -
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения);
	// Конец СтандартныеПодсистемы
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПередЗавершениемРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	// ПодключаемоеОборудование
	// Подготовить данные
	
	ОписаниеСобытия = Новый Структура();
	ОписаниеОшибки  = "";
	
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие",  Событие);
	ОписаниеСобытия.Вставить("Данные",   Данные);
	
	глПодключаемоеОборудованиеСобытиеОбработано = Ложь;
	
	// Передать на обработку данные.
	Результат = МенеджерОборудованияКлиент.ОбработатьСобытиеОтУстройства(ОписаниеСобытия, ОписаниеОшибки);
	Если Не Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При обработке внешнего события от устройства произошла ошибка.'")
		                                                 + Символы.ПС + ОписаниеОшибки);
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиПодсистемыКвартплаты

// Квартплата +

///////////////////////////////////////////////////////////////////////////
// ИНТЕГРАЦИЯ С БП 3.0

// В данной конфигурации могут использоваться две текущие версии конфигурации:
// 1. Версия ЖКХ - версии текущей конфигурации ЖКХ. Указывается в свойстве "Версия" дерева конфигурации.
// 2. Версия БП - соответствует версии БП, на которой собрана текущая версия конфигурации ЖКХ. Определяется
//    по версии ЖКХ с помощью функции КВП_ПрочиеПроцедурыИФункции.НомерВерсииТиповойКонфигурации(ВерсияЖКХ).
//
// В той или иной ситуации необходимо использовать версию №1 или №2.
// Необходимо придерживаться следующего правила: если для механизма необходима версия типовой БП, например
// для сдачи регл. отчетности, то используем версию БП, если же механизм касается только ЖКХ, то версию ЖКХ.
//
// Версия ЖКХ используется в следующих механизмах и объектах:
// - Обновление конфигурации - механизм обновления конфигурации в режиме 1С:Предприятие:
//      ОМ "ОбновлениеКонфигурацииКлиент"
//      Обработка "ОбновлениеКонфигурации"
// - Механизм обновления подсистемы ЖКХ
//      ОМ "УПЖКХ_ОбновлениеИнформационнойБазыКлиент"
//      Обработка "КВП_ОбновлениеИнформационнойБазы".
//
// Версия БП используется в следующих механизмах и объектах:
// - Механизм обновления типовых подсистем, а именно подсистемы БП
// - Выгрузка загрузка данных
// - Доп. отчеты и обработки в модели сервиса
// - Информационный центр
// - Описание изменений системы
// - Документооборот с сконтролирующими органами
// - Конвертация объектов ИБ
// - Общие объекты регл. отчетности
// - Синхронизация данных с v77

// Квартплата -

// АТК +

// Функция проверяет и при необходимости запускает автоматическое тестирование конфигурации.
//
Функция ПроверитьНеобходимостьИЗапуститьАвтоматическоеТестированиеКонфигурации()
	
	ЗапускВРежимеАвтоматическогоТестированияКонфигурации = Ложь;
	
	// Проверка параметра запуска, который определяет, что программа
	// запущена в режиме автоматического тестирования.
	Если Найти(ПараметрЗапуска, "ВыполнитьАвтоматическоеТестированиеКонфигурации") > 0 Тогда
		
		// Пример строки параметров доступа к менеджеру тестирования:
		//    /с ВыполнитьАвтоматическоеТестированиеКонфигурации СтрокаСоединения&File="D:\Лукьянов\Базы\Автоматическое тестирование конфигураций";& Логин&Пользователь& Пароль&&
		
		КлючПоискаПараметраСтрокиСоединения = "СтрокаСоединения&";
		КлючПоискаПараметраЛогина           = "Логин&";
		КлючПоискаПараметраПароля           = "Пароль&";
		
		ПозицияНачалаСтрокиСоединенияКМенеджеруТестирования = Найти(ПараметрЗапуска, КлючПоискаПараметраСтрокиСоединения);
		ПозицияНачалаЛогинаКМенеджеруТестирования           = Найти(ПараметрЗапуска, КлючПоискаПараметраЛогина);
		ПозицияНачалаПароляКМенеджеруТестирования           = Найти(ПараметрЗапуска, КлючПоискаПараметраПароля);
		
		Если ПозицияНачалаСтрокиСоединенияКМенеджеруТестирования > 0 Тогда
			
			// Значения параметров по умолчанию.
			МенеджерТестирования_СтрокаСоединения = "";
			МенеджерТестирования_Логин            = "";
			МенеджерТестирования_Пароль           = "";
			
			// Получение значений параметров из параметров запуска.
			
			Если ПозицияНачалаСтрокиСоединенияКМенеджеруТестирования > 0 Тогда
				
				врСтрокаПараметров = Прав(ПараметрЗапуска, СтрДлина(ПараметрЗапуска) - ПозицияНачалаСтрокиСоединенияКМенеджеруТестирования - СтрДлина(КлючПоискаПараметраСтрокиСоединения) + 1);
				
				ПозицияОкончанияПараметра = Найти(врСтрокаПараметров, "&");
				Если ПозицияОкончанияПараметра > 0 Тогда
					МенеджерТестирования_СтрокаСоединения = Лев(врСтрокаПараметров, ПозицияОкончанияПараметра - 1);
				КонецЕсли;
				
			КонецЕсли;
			
			Если ПозицияНачалаЛогинаКМенеджеруТестирования > 0 Тогда
				
				врСтрокаПараметров = Прав(ПараметрЗапуска, СтрДлина(ПараметрЗапуска) - ПозицияНачалаЛогинаКМенеджеруТестирования - СтрДлина(КлючПоискаПараметраЛогина) + 1);
				
				ПозицияОкончанияПараметра = Найти(врСтрокаПараметров, "&");
				Если ПозицияОкончанияПараметра > 0 Тогда
					МенеджерТестирования_Логин = Лев(врСтрокаПараметров, ПозицияОкончанияПараметра - 1);
				КонецЕсли;
				
			КонецЕсли;
			
			Если ПозицияНачалаПароляКМенеджеруТестирования > 0 Тогда
				
				врСтрокаПараметров = Прав(ПараметрЗапуска, СтрДлина(ПараметрЗапуска) - ПозицияНачалаПароляКМенеджеруТестирования - СтрДлина(КлючПоискаПараметраПароля) + 1);
				
				ПозицияОкончанияПараметра = Найти(врСтрокаПараметров, "&");
				Если ПозицияОкончанияПараметра > 0 Тогда
					МенеджерТестирования_Пароль = Лев(врСтрокаПараметров, ПозицияОкончанияПараметра - 1);
				КонецЕсли;
				
			КонецЕсли;
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("МенеджерТестирования_СтрокаСоединения", МенеджерТестирования_СтрокаСоединения);
			ПараметрыФормы.Вставить("МенеджерТестирования_Логин",            МенеджерТестирования_Логин);
			ПараметрыФормы.Вставить("МенеджерТестирования_Пароль",           МенеджерТестирования_Пароль);
			
			ОткрытьФорму("Справочник.АТК_ОбработкиАвтоматическогоТестирования.Форма.ФормаАвтоматическогоТестированияКонфигурации", ПараметрыФормы);
			
			ЗапускВРежимеАвтоматическогоТестированияКонфигурации = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ЗапускВРежимеАвтоматическогоТестированияКонфигурации;
	
КонецФункции
// АТК -

#КонецОбласти

#Область Инициализация

глПодключаемоеОборудованиеСобытиеОбработано = Ложь;

#КонецОбласти
