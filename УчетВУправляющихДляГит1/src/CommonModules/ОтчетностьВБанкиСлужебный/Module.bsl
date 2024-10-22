////////////////////////////////////////////////////////////////////////////////
// ОтчетностьВБанкиСлужебный: Механизм отправки отчетов в банки.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Добавляет дополнительные параметры в ЗаписьJSON
//
// Параметры:
//  ЗаписьJSON - ЗаписьJSON - запись, в которую добавляются дополнительные параметры;
//  ПараметрыКлиента - Структура - содержит параметры клиентского приложения.
//        * ТипПлатформы - Строка - тип клиентского приложения;
//        * ВерсияОС - Строка - версия ОС на клиенте;
//
Процедура ДобавитьДополнительныеПараметры(ЗаписьJSON, ПараметрыКлиента) Экспорт
	
	ЗаписьJSON.ЗаписатьИмяСвойства("params");
	ЗаписьJSON.ЗаписатьНачалоМассива();
	
	Язык = ТекущийЯзык();
	
	Если Язык = Неопределено Тогда
		Язык = КодОсновногоЯзыкаИнтерфейсаКонфигурации();
	ИначеЕсли ТипЗнч(Язык) = Тип("ОбъектМетаданных") Тогда
		Язык = Язык.КодЯзыка;
	КонецЕсли;
	
	ДобавитьПараметр(ЗаписьJSON,"сonfigLanguage", Язык);
	
	Язык = Метаданные.ОсновнойЯзык.КодЯзыка;
	ДобавитьПараметр(ЗаписьJSON,"сonfigMainLanguage", Язык);
	
	КодЛокализации = КодЛокализацииИнформационнойБазы();
	ДобавитьПараметр(ЗаписьJSON, "сurLocalizationCode", КодЛокализации);

	ЛокализацияПлатформы = ТекущийЯзыкСистемы();
	ДобавитьПараметр(ЗаписьJSON, "systemLanguage", ЛокализацияПлатформы);
	
	СмещениеВремени = Формат((ТекущаяДатаСеанса() - ТекущаяУниверсальнаяДата()), "ЧГ=0");
	ДобавитьПараметр(ЗаписьJSON, "clientTimeOffsetGMT", СмещениеВремени);

	ДобавитьПараметр(ЗаписьJSON, "clientPlatformType", ПараметрыКлиента.ТипПлатформы);
	ДобавитьПараметр(ЗаписьJSON, "clientOSVersion", ПараметрыКлиента.ВерсияОС);
	
	СистИнфо = Новый СистемнаяИнформация;
	ДобавитьПараметр(ЗаписьJSON, "serverPlatformType", Строка(СистИнфо.ТипПлатформы));
	ДобавитьПараметр(ЗаписьJSON, "serverOSVersion", СистИнфо.ВерсияОС);
	
	ДобавитьПараметр(ЗаписьJSON, "libraryVersion", ИнтернетПоддержкаПользователейКлиентСервер.ВерсияБиблиотеки());
	
	ДобавитьПараметр(ЗаписьJSON, "configName", Метаданные.Имя);
	ДобавитьПараметр(ЗаписьJSON, "configVersion", Метаданные.Версия);
	ДобавитьПараметр(ЗаписьJSON, "vendor", Метаданные.Поставщик);
	ДобавитьПараметр(ЗаписьJSON, "IBID", СтандартныеПодсистемыСервер.ИдентификаторИнформационнойБазы());
	
	НастройкиСоединения = ИнтернетПоддержкаПользователейСлужебныйПовтИсп.НастройкиСоединенияССерверамиИПП();
	Если НастройкиСоединения.ДоменРасположенияСерверовИПП = 0 Тогда
		ДоменнаяЗона = "ru";
	ИначеЕсли НастройкиСоединения.ДоменРасположенияСерверовИПП = 1 Тогда
		ДоменнаяЗона = "eu";
	КонецЕсли;

	ДобавитьПараметр(ЗаписьJSON, "domainZone", ДоменнаяЗона);
	ДобавитьПараметр(ЗаписьJSON, "countryId", "");
	
	ДобавитьПараметр(ЗаписьJSON, "PlatformVersion", СистИнфо.ВерсияПриложения);
	ДобавитьПараметр(ЗаписьJSON, "ConfigLanguage", КодЯзыкаИнтерфейсаКонфигурации());
	КодОсновногоЯзыкаИнтерфейса = КодОсновногоЯзыкаИнтерфейсаКонфигурации();
	ДобавитьПараметр(ЗаписьJSON, "ConfigMainLanguage", КодОсновногоЯзыкаИнтерфейса);
	ДобавитьПараметр(ЗаписьJSON, "CurLocalizationCode", ТекущийКодЛокализации());
	ДобавитьПараметр(ЗаписьJSON, "IBUserName", ИмяПользователя());
	
	ЗаписьJSON.ЗаписатьКонецМассива();
	
КонецПроцедуры

// Обновляет внешние компоненты через интернет в фоновом процессе.
//
// Параметры:
//  Параметры - Структура - параметры фоновой процедуры. Содержит поля:
//      * ПараметрыКлиента - Структура - содержит параметры клиентского приложения.
//        ** ТипПлатформы - Строка - тип клиентского приложения;
//        ** ВерсияОС - Строка - версия ОС на клиенте;
//  Адрес - Строка - адрес временного хранилища, в который помещается массив.
//
Процедура ОбновитьСтатусыОтчетов(Параметры, Адрес) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РегламентированныйОтчет.Идентификатор,
	               |	РегламентированныйОтчет.Ссылка
	               |ИЗ
	               |	Документ.РегламентированныйОтчет КАК РегламентированныйОтчет
	               |ГДЕ
	               |	НЕ РегламентированныйОтчет.Идентификатор = """"
	               |	И РегламентированныйОтчет.СтатусОтчета = &СтатусОтправлено";
	Запрос.УстановитьПараметр("СтатусОтправлено", НСтр("ru = 'Отправлено'"));
	Результат = Запрос.Выполнить();
	
	МассивОтчетов = Новый Массив;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ВремФайл = ПолучитьИмяВременногоФайла();
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.ОткрытьФайл(ВремФайл);
		
		ЗаписьJSON.ЗаписатьНачалоОбъекта();
		ЗаписьJSON.ЗаписатьИмяСвойства("reportGuid");
		ЗаписьJSON.ЗаписатьЗначение(Выборка.Идентификатор);
		
		ДобавитьДополнительныеПараметры(ЗаписьJSON, Параметры.ПараметрыКлиента);
		
		ЗаписьJSON.ЗаписатьКонецОбъекта();
		ЗаписьJSON.Закрыть();
		
		Данные = Новый ДвоичныеДанные(ВремФайл);
		
		Попытка
			УдалитьФайлы(ВремФайл);
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Отчетность в банки. Ошибка удаления временного файла'"),
				УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		Заголовки = Новый Соответствие;
		Заголовки.Вставить("Content-Type", "application/json");
		
		Результат = ОтправитьЗапросНаСервер(
			"https://reportbank.1c.ru", "/api/rest/report/checkStatus/", Заголовки, Данные, Истина, 30);
		
		Успех = Ложь;
		ТекстСообщения = ""; ТекстОшибки = "";
		
		Если Результат.Статус Тогда
			ДанныеОтвета = ДанныеИзСтрокиJSON(Результат.Тело);
			Статус = ДанныеОтвета.status;
			Если Статус = "DELIVERED" Тогда
				ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
				ДокументОбъект.СтатусОтчета = НСтр("ru = 'Доставлено'");
				ДокументОбъект.Записать();
				МассивОтчетов.Добавить(Выборка.Ссылка);
			ИначеЕсли Статус = "REJECTED" Тогда
				ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
				ДокументОбъект.СтатусОтчета = НСтр("ru = 'Отклонено'");
				ДокументОбъект.Записать();
				МассивОтчетов.Добавить(Выборка.Ссылка);
			КонецЕсли;
			
		Иначе
			Если ЗначениеЗаполнено(Результат.Тело) Тогда
				ДанныеОтвета = ДанныеИзСтрокиJSON(Результат.Тело);
				Если НЕ Данные = Неопределено Тогда
					Если ДанныеОтвета.Свойство("errorText") Тогда
						ТекстСообщения = ДанныеОтвета.errorText;
					Иначе
						ТекстСообщения = НСтр("ru = 'Получена неизвестная ошибка с сервиса Бизнес-сеть.'");
					КонецЕсли;
				КонецЕсли;
				ТекстОшибки = НСтр("ru = 'Ошибка получения статуса отчета через сервис Бизнес-сеть.
									|Код состояния: %1
									|%2'");
				ТекстОшибки = СтрШаблон(ТекстОшибки, Результат.КодСостояния, Результат.Тело);
			Иначе
				ТекстСообщения = Результат.СообщениеОбОшибке;
				ТекстОшибки = НСтр("ru = 'Ошибка получения статуса отчета через сервис Бизнес-сеть.
									|Код состояния: %1'");
				ТекстОшибки = СтрШаблон(ТекстОшибки, Результат.КодСостояния);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(МассивОтчетов, Адрес);
	
	Если ЗначениеЗаполнено(ТекстОшибки)Тогда
		ВидОперации = НСтр("ru = 'Получение статуса отчета через сервис Бизнес-сеть.'");
		ОтчетностьВБанкиСлужебныйВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки, ТекстСообщения);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
КонецПроцедуры

// Получает данные из строки в формате JSON.
// 
// Параметры:
//    Строка - Строка - Строка данных в формате JSON
// 
// Возвращаемое значение:
//    Структура - данные JSON в виде структуры.
//
Функция ДанныеИзСтрокиJSON(Строка) Экспорт
	
	Результат = Неопределено;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	Попытка
		ЧтениеJSON.УстановитьСтроку(Строка);
		Результат = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
	Исключение
		Операция = НСтр("ru = 'Чтение ответа от сервиса Бизнес-сеть.'");
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = НСтр("ru = 'При чтении ответа от сервиса Бизнес-сеть произошла ошибка:
									|%1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, КраткоеПредставлениеОшибки);
		ОтчетностьВБанкиСлужебныйВызовСервера.ОбработатьОшибку(Операция, ПодробноеПредставлениеОшибки, ТекстСообщения);
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Отправляет данные через интернет.
//
// Параметры:
//  АдресСервера - Строка - URI;
//  Ресурс - Строка - ресурс, на который отправляются данные;
//  Заголовки - Соответствие - заголовки запроса;
//  Данные - ДвоичныеДанные - тело запроса;
//  ПолучитьТелоКакСтроку - Булево - признак необходимости получения тела как строки;
//  Таймаут - Число - таймаут ожидания ответа сервера;
//
// Возвращаемое значение:
//   Структура - Структура со свойствами:
//      * Статус - Булево - результат получения файла. Истина - операция выполнена успешно.
//      * Тело - ДвоичныеДанные; Строка; Неопределено - данные ответа сервера.
//      * СообщениеОбОшибке - Строка; Неопределено - сообщение об ошибке, если статус Ложь.
//      * КодСостояния - Число; Неопределено - код состояния HTTP-ответа. Наличие кода означает, что был ответ от сервера.
//
Функция ОтправитьЗапросНаСервер(АдресСервера, Ресурс, Заголовки = Неопределено, Данные = Неопределено, ПолучитьТелоКакСтроку = Ложь, Таймаут = 60) Экспорт
	
	СтруктураВозврата = Новый Структура("Статус, Тело, СообщениеОбОшибке, КодСостояния");
	
	Соединение = СоединениеССервером(АдресСервера, Таймаут);

	Если ЗначениеЗаполнено(Заголовки) Тогда
		HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	Иначе
		HTTPЗапрос = Новый HTTPЗапрос(Ресурс);
	КонецЕсли;
	
	Если НЕ Данные = Неопределено Тогда
		HTTPЗапрос.УстановитьТелоИзДвоичныхДанных(Данные);
	КонецЕсли;

	Попытка
		Ответ = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	Исключение
		СтруктураВозврата.Статус = Ложь;
		СтруктураВозврата.СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат СтруктураВозврата;
	КонецПопытки;
	
	HTTPЗапрос = Неопределено;
	
	Если Ответ.КодСостояния = 200 Тогда
		СтруктураВозврата.Статус = Истина;
		Если ПолучитьТелоКакСтроку Тогда
			СтруктураВозврата.Тело = Ответ.ПолучитьТелоКакСтроку();
		Иначе
			СтруктураВозврата.Тело = Ответ.ПолучитьТелоКакДвоичныеДанные();
		КонецЕсли;
	Иначе
		СтруктураВозврата.Статус = Ложь;
		СтруктураВозврата.СообщениеОбОшибке = РасшифровкаКодаСостоянияHTTP(Ответ.КодСостояния);
		СтруктураВозврата.Тело = Ответ.ПолучитьТелоКакСтроку();
	КонецЕсли;
	
	СтруктураВозврата.КодСостояния = Ответ.КодСостояния;

	Возврат СтруктураВозврата;
	
КонецФункции

// Формирует описание счета для электронного представления формата 5.06 подверсии 2.9.
// 
// Параметры:
//  АдресСервера - Строка, ПланСчетовСсылка - Код счета или ссылка на счет.
//
// Возвращаемое значение:
//   Структура - Структура со свойствами:
//      * КодСчета - Строка - код описываемого счета;
//      * НаименованиеСчета - Строка - наименование описываемого счета;
//      * ТипСчета - Строка - тип описываемого счета (А, П, АП);
//      * КодСчетаР - Строка - код родителя описываемого счета;
//      * ТипСчетаР - Строка - наименование родителя описываемого счета;
//      * КодСчетаРР - Строка - код родителя родителя описываемого счета;
//      * ТипСчетаРР - Строка - наименование родителя родителя описываемого счета.
//
Функция ОписаниеСчетаДляВыгрузки(СчетКодСчета) Экспорт
	
	ОписаниеСчета = Новый Структура;
	
	ОписаниеСчета.Вставить("КодСчета", "");
	ОписаниеСчета.Вставить("НаименованиеСчета", "");
	ОписаниеСчета.Вставить("ТипСчета", "");
	
	ОписаниеСчета.Вставить("КодСчетаР", "");
	ОписаниеСчета.Вставить("ТипСчетаР", "");
	
	ОписаниеСчета.Вставить("КодСчетаРР", "");
	ОписаниеСчета.Вставить("ТипСчетаРР", "");
	
	Счет = Неопределено;
	
	Если ТипЗнч(СчетКодСчета) = Тип("Строка") Тогда
		ОтчетностьВБанкиСлужебныйПереопределяемый.УстановитьСчетУчетаПоКоду(СчетКодСчета, Счет);
	Иначе
		Счет = СчетКодСчета;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Счет) Тогда
		ОписаниеСчета.Вставить("КодСчета", Счет.Код);
		ОписаниеСчета.Вставить("НаименованиеСчета", Счет.Наименование);
		ОписаниеСчета.Вставить("ТипСчета", КодВидаСчета(Счет));
		
		Если ЗначениеЗаполнено(Счет.Родитель) Тогда
			ОписаниеСчета.Вставить("КодСчетаР", Счет.Родитель.Код);
			ОписаниеСчета.Вставить("ТипСчетаР", КодВидаСчета(Счет.Родитель));
			
			Если ЗначениеЗаполнено(Счет.Родитель.Родитель) Тогда
				ОписаниеСчета.Вставить("КодСчетаРР", Счет.Родитель.Родитель.Код);
				ОписаниеСчета.Вставить("ТипСчетаРР", КодВидаСчета(Счет.Родитель.Родитель));
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ОписаниеСчета;
	
КонецФункции

// Возвращает таблицу счетов для отчета.
//
// Параметры:
//   ВидОтчета - Строка - имя отчета, для которого надо заполнить список счетов.
//   ИмяФормы - Строка - имя формы отчета БухгалтерскаяОтчетностьВБанк, для которой заполняется список счетов.
//
// Возвращаемое значение:
//   ТаблицаЗначений - таблица с колонками:
//     * Включен - Булево - признак включения счета в отчет;
//     * Счет - ПланСчетовСсылка - ссылка на счет плана счетов, в котором ведется бухгалтерский учет;
//     * Наименование - Строка - наименование счета плана счетов, в котором ведется бухгалтерский учет.
//
Функция СчетаЗаполнения(ВидОтчета, ИмяФормы) Экспорт
	
	ТаблицаСчетов = Новый ТаблицаЗначений;
	ТаблицаСчетов.Колонки.Добавить("Включен", Новый ОписаниеТипов("Булево"));
	ТаблицаСчетов.Колонки.Добавить("Счет");
	ТаблицаСчетов.Колонки.Добавить("Наименование");
	
	ОтчетностьВБанкиСлужебныйПереопределяемый.ЗаполнитьТаблицуСчетовЗаполнения(ИмяФормы, ВидОтчета, ТаблицаСчетов);
	
	Возврат ТаблицаСчетов;
	
КонецФункции

// Возвращает таблицу с банками расчетных счетов организации.
// Параметры:
//   Организация - СправочникСсылка.Организация - организация, для которой нужно получить таблицу с банками.
//
// Возвращаемое значение:
//   ТаблицаЗначений - таблица с колонками:
//     * БИК  - Строка - БИК банка.
//     * Банк - ОпределяемыйТип.СправочникБанкиБРО - банк.
//
Функция БанкиРасчетныхСчетовОрганизации(Организация) Экспорт
	
	ТаблицаБанков = Новый ТаблицаЗначений;
	ТаблицаБанков.Колонки.Добавить("БИК");
	ТаблицаБанков.Колонки.Добавить("Банк");
	
	ОтчетностьВБанкиСлужебныйПереопределяемый.ЗаполнитьТаблицуБанковРасчетныхСчетовОрганизации(
		Организация, ТаблицаБанков);
	
	Возврат ТаблицаБанков;
	
КонецФункции

// Возвращает дерево счетов бухгалтерского учета.
//
// Возвращаемое значение:
//   ДеревоЗначений - дерево со счетами бухгалтерского учета.
//	 ВключатьЗабалансовые - Булево - Если установлен в значение Истина, то выгружаются в том числе и забалансовые счета.
//
Функция ДеревоСчетовБУ(ВключатьЗабалансовые = Ложь) Экспорт
	
	ДеревоСчетовБУ = Новый ДеревоЗначений;
	Если ВключатьЗабалансовые Тогда
		ОтчетностьВБанкиСлужебныйПереопределяемый.ЗаполнитьДеревоСчетовБУ(ДеревоСчетовБУ, ВключатьЗабалансовые);
	Иначе
		// Не передаем 2-ой параметр, чтобы не требовать обязательное изменение 
		// в переопределяемом модуле конфигураций-потребителей.
		ОтчетностьВБанкиСлужебныйПереопределяемый.ЗаполнитьДеревоСчетовБУ(ДеревоСчетовБУ);
	КонецЕсли;
	
	Возврат ДеревоСчетовБУ;
	
КонецФункции

// Возвращает ссылку на банк заемщика, используемый по умолчанию.
//
// Возвращаемое значение:
//   СправочникСсылка - ссылка на элемент справочника банков.
//
Функция БанкЗаемщикаПоУмолчанию() Экспорт
	
	БанкОрганизации = Неопределено;
	
	ОтчетностьВБанкиСлужебныйПереопределяемый.ЗаполнитьБанкПоУмолчанию(БанкОрганизации);
	
	Возврат БанкОрганизации;
	
КонецФункции

// Возвращает массив с перечнем разделов, заполняемых по сведениям информационной базы.
//
// Параметры:
//   ИмяФормы - Строка - имя формы отчета БухгалтерскаяОтчетностьВБанк, для которой заполняется перечень разделов.
//   ЗаполняемыеРазделы - Массив - массив, в который будут добавлены идентификаторы заполняемых разделов.
//
// Возвращаемое значение:
//   Массив - массив с идентификаторами заполняемых разделов.
//
Функция РазделыЗаполняемыеПоСведениямИБ(ИмяФормыОтчета) Экспорт
	
	ЗаполняемыеРазделы = Новый Массив;
	
	ОтчетностьВБанкиСлужебныйПереопределяемый.ЗаполнитьПереченьЗаполняемыхРазделов(ИмяФормыОтчета, ЗаполняемыеРазделы);
	
	Возврат ЗаполняемыеРазделы;
	
КонецФункции

// Возвращает описание типов для сущности с указанным названием.
//
// Параметры:
//   НазваниеСущности - Строка - название сущности, для которой требуется получить описание типов.
//
// Возвращаемое значение:
//   ОписаниеТипов - описание типов сущности.
//
Функция ТипыСущности(НазваниеСущности) Экспорт
	
	ОписаниеТиповСущности = Новый ОписаниеТипов;
	
	ОтчетностьВБанкиСлужебныйПереопределяемый.ЗаполнитьТипыСущности(НазваниеСущности, ОписаниеТиповСущности);
	
	Возврат ОписаниеТиповСущности;
	
КонецФункции

Функция ПредставлениеАнализаДенежныхСредствКасса(ШаблонПредставления, ДанныеОтчета, ПостфиксЕдИзм = "") Экспорт
	
	ПредставлениеОтчета = Новый ТабличныйДокумент;
	
	Если ШаблонПредставления.Области.Найти("Заголовок") <> Неопределено Тогда
		Секция_Заголовок = ШаблонПредставления.ПолучитьОбласть("Заголовок");
		ПредставлениеОтчета.Вывести(Секция_Заголовок);
		
		Секция_ПустаяСтрока = ШаблонПредставления.ПолучитьОбласть("ПустаяСтрока");
		ПредставлениеОтчета.Вывести(Секция_ПустаяСтрока);
		
	КонецЕсли;
	
	Если ШаблонПредставления.Области.Найти("ШапкаТаблицыКасса") <> Неопределено Тогда
		Секция_ШапкаТаблицы = ШаблонПредставления.ПолучитьОбласть("ШапкаТаблицыКасса");
	Иначе
		Секция_ШапкаТаблицы = ШаблонПредставления.ПолучитьОбласть("ШапкаТаблицы");
	КонецЕсли;
	ПредставлениеОтчета.Вывести(Секция_ШапкаТаблицы);
	
	ПредставлениеОтчета.НачатьАвтогруппировкуСтрок();
	
	УровеньСчета = ДанныеОтчета.Строки;
	Для Каждого СтрокаУровняСчета Из УровеньСчета Цикл
		Секция_СтрокаТаблицыСчет = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыСчет" + ПостфиксЕдИзм);
		
		Секция_СтрокаТаблицыСчет.Параметры.КодСчета = СтрокаУровняСчета.Счет.Код;
		Секция_СтрокаТаблицыСчет.Параметры.СНД = СтрокаУровняСчета.СНД;
		Секция_СтрокаТаблицыСчет.Параметры.СНК = СтрокаУровняСчета.СНК;
		
		ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыСчет, 1);
		
		ОборотыПоСчетуДт = 0;
		ОборотыПоСчетуКт = 0;
		
		УровеньПериода = СтрокаУровняСчета.Строки;
		
		Для Каждого СтрокаУровняПериода Из УровеньПериода Цикл
			Секция_СтрокаТаблицыПериод = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыПериод" + ПостфиксЕдИзм);
			
			Секция_СтрокаТаблицыПериод.Параметры.Период = Формат(СтрокаУровняПериода.Период, "ДФ='ММММ гггг ''г.'''");
			Секция_СтрокаТаблицыПериод.Параметры.СНД = СтрокаУровняПериода.СНД;
			Секция_СтрокаТаблицыПериод.Параметры.СНК = СтрокаУровняПериода.СНК;
			
			ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыПериод, 2);
			
			ОборотыПоПериодуДт = 0;
			ОборотыПоПериодуКт = 0;
			
			УровеньКорреспонденции = СтрокаУровняПериода.Строки;
			
			Для Каждого СтрокаУровняКорреспонденции Из УровеньКорреспонденции Цикл
				Если ЗначениеЗаполнено(СтрокаУровняКорреспонденции.КорСчет) Тогда
					Секция_СтрокаТаблицыКорСчет = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыКорСчет" + ПостфиксЕдИзм);
					
					Секция_СтрокаТаблицыКорСчет.Параметры.КодКорСчета = СтрокаУровняКорреспонденции.КорСчет.Код;
					Секция_СтрокаТаблицыКорСчет.Параметры.ДО = СтрокаУровняКорреспонденции.ДО;
					Секция_СтрокаТаблицыКорСчет.Параметры.КО = СтрокаУровняКорреспонденции.КО;
					
					ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыКорСчет, 3);
					
				Иначе
					// Сведения по счету без корреспонденции. Используются для вывода оборотов, так как в запросе
					// итоги по уровню счета задваиваются из-за объединения таблиц со счетами и с корреспонденцией.
					ОборотыПоПериодуДт = СтрокаУровняКорреспонденции.ДО;
					ОборотыПоПериодуКт = СтрокаУровняКорреспонденции.КО;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Секция_СтрокаТаблицыОбороты = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыОбороты" + ПостфиксЕдИзм);
			
			Секция_СтрокаТаблицыОбороты.Параметры.ДО = ОборотыПоПериодуДт;
			Секция_СтрокаТаблицыОбороты.Параметры.КО = ОборотыПоПериодуКт;
			
			ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыОбороты, 2);
			
			Секция_СтрокаТаблицыСальдоКонечное = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыСальдоКонечное" + ПостфиксЕдИзм);
			Секция_СтрокаТаблицыСальдоКонечное.Параметры.СКД = СтрокаУровняПериода.СКД;
			Секция_СтрокаТаблицыСальдоКонечное.Параметры.СКК = СтрокаУровняПериода.СКК;
			
			ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыСальдоКонечное, 2);
			
			ОборотыПоСчетуДт = ОборотыПоСчетуДт + ОборотыПоПериодуДт;
			ОборотыПоСчетуКт = ОборотыПоСчетуКт + ОборотыПоПериодуКт;
			
		КонецЦикла;
		
		Секция_СтрокаТаблицыОбороты = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыОбороты" + ПостфиксЕдИзм);
		
		Секция_СтрокаТаблицыОбороты.Параметры.ДО = ОборотыПоСчетуДт;
		Секция_СтрокаТаблицыОбороты.Параметры.КО = ОборотыПоСчетуКт;
		
		ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыОбороты, 1);
		
		Секция_СтрокаТаблицыСальдоКонечное = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыСальдоКонечное" + ПостфиксЕдИзм);
		Секция_СтрокаТаблицыСальдоКонечное.Параметры.СКД = СтрокаУровняСчета.СКД;
		Секция_СтрокаТаблицыСальдоКонечное.Параметры.СКК = СтрокаУровняСчета.СКК;
		
		ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыСальдоКонечное, 1);
		
	КонецЦикла;
	
	ПредставлениеОтчета.ЗакончитьАвтогруппировкуСтрок();
	
	Возврат ПредставлениеОтчета;
	
КонецФункции

Функция ПредставлениеАнализаДенежныхСредств(ШаблонПредставления, ДанныеОтчета, ПостфиксЕдИзм = "") Экспорт
	
	ПредставлениеОтчета = Новый ТабличныйДокумент;
	
	Если ШаблонПредставления.Области.Найти("Заголовок") <> Неопределено Тогда
		Секция_Заголовок = ШаблонПредставления.ПолучитьОбласть("Заголовок");
		ПредставлениеОтчета.Вывести(Секция_Заголовок);
		
		Секция_ПустаяСтрока = ШаблонПредставления.ПолучитьОбласть("ПустаяСтрока");
		ПредставлениеОтчета.Вывести(Секция_ПустаяСтрока);
		
	КонецЕсли;
	
	Секция_ШапкаТаблицы = ШаблонПредставления.ПолучитьОбласть("ШапкаТаблицы");
	ПредставлениеОтчета.Вывести(Секция_ШапкаТаблицы);
	
	ПредставлениеОтчета.НачатьАвтогруппировкуСтрок();
	
	УровеньСчета = ДанныеОтчета.Строки;
	Для Каждого СтрокаУровняСчета Из УровеньСчета Цикл
		Секция_СтрокаТаблицыСчет = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыСчет" + ПостфиксЕдИзм);
		
		Секция_СтрокаТаблицыСчет.Параметры.КодСчета = СтрокаУровняСчета.Счет.Код;
		Секция_СтрокаТаблицыСчет.Параметры.СНД = СтрокаУровняСчета.СНД;
		Секция_СтрокаТаблицыСчет.Параметры.СНК = СтрокаУровняСчета.СНК;
		
		ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыСчет, 1);
		
		ОборотыПоСчетуДт = 0;
		ОборотыПоСчетуКт = 0;
		
		УровеньБанковскогоСчета = СтрокаУровняСчета.Строки;
		
		Для Каждого СтрокаУровняБанковскогоСчета Из УровеньБанковскогоСчета Цикл
			Секция_СтрокаТаблицыБанковскийСчет = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыБанковскийСчет" + ПостфиксЕдИзм);
			
			Секция_СтрокаТаблицыБанковскийСчет.Параметры.БанковскийСчет = СтрокаУровняБанковскогоСчета.БанковскийСчет;
			Секция_СтрокаТаблицыБанковскийСчет.Параметры.СНД = СтрокаУровняБанковскогоСчета.СНД;
			Секция_СтрокаТаблицыБанковскийСчет.Параметры.СНК = СтрокаУровняБанковскогоСчета.СНК;
			
			ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыБанковскийСчет, 2);
			
			УровеньПериода = СтрокаУровняБанковскогоСчета.Строки;
			
			ОборотыПоБанковскомуСчетуДт = 0;
			ОборотыПоБанковскомуСчетуКт = 0;
			
			Для Каждого СтрокаУровняПериода Из УровеньПериода Цикл
				Секция_СтрокаТаблицыПериод = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыПериод" + ПостфиксЕдИзм);
				
				Секция_СтрокаТаблицыПериод.Параметры.Период = Формат(СтрокаУровняПериода.Период, "ДФ='ММММ гггг ''г.'''");
				Секция_СтрокаТаблицыПериод.Параметры.СНД = СтрокаУровняПериода.СНД;
				Секция_СтрокаТаблицыПериод.Параметры.СНК = СтрокаУровняПериода.СНК;
				
				ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыПериод, 3);
				
				ОборотыПоПериодуДт = 0;
				ОборотыПоПериодуКт = 0;
				
				УровеньКорреспонденции = СтрокаУровняПериода.Строки;
				
				Для Каждого СтрокаУровняКорреспонденции Из УровеньКорреспонденции Цикл
					Если ЗначениеЗаполнено(СтрокаУровняКорреспонденции.КорСчет) Тогда
						Секция_СтрокаТаблицыКорСчет = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыКорСчет" + ПостфиксЕдИзм);
						
						Секция_СтрокаТаблицыКорСчет.Параметры.КодКорСчета = СтрокаУровняКорреспонденции.КорСчет.Код;
						Секция_СтрокаТаблицыКорСчет.Параметры.ДО = СтрокаУровняКорреспонденции.ДО;
						Секция_СтрокаТаблицыКорСчет.Параметры.КО = СтрокаУровняКорреспонденции.КО;
						
						ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыКорСчет, 4);
						
					Иначе
						// Сведения по счету без корреспонденции. Используются для вывода оборотов, так как в запросе
						// итоги по уровню счета задваиваются из-за объединения таблиц со счетами и с корреспонденцией.
						ОборотыПоПериодуДт = СтрокаУровняКорреспонденции.ДО;
						ОборотыПоПериодуКт = СтрокаУровняКорреспонденции.КО;
						
					КонецЕсли;
					
				КонецЦикла;
				
				Секция_СтрокаТаблицыОбороты = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыОбороты" + ПостфиксЕдИзм);
				
				Секция_СтрокаТаблицыОбороты.Параметры.ДО = ОборотыПоПериодуДт;
				Секция_СтрокаТаблицыОбороты.Параметры.КО = ОборотыПоПериодуКт;
				
				ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыОбороты, 3);
				
				Секция_СтрокаТаблицыСальдоКонечное = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыСальдоКонечное" + ПостфиксЕдИзм);
				Секция_СтрокаТаблицыСальдоКонечное.Параметры.СКД = СтрокаУровняПериода.СКД;
				Секция_СтрокаТаблицыСальдоКонечное.Параметры.СКК = СтрокаУровняПериода.СКК;
				
				ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыСальдоКонечное, 3);
				
				ОборотыПоБанковскомуСчетуДт = ОборотыПоБанковскомуСчетуДт + ОборотыПоПериодуДт;
				ОборотыПоБанковскомуСчетуКт = ОборотыПоБанковскомуСчетуКт + ОборотыПоПериодуКт;
				
			КонецЦикла;
			
			Секция_СтрокаТаблицыОбороты = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыОбороты" + ПостфиксЕдИзм);
			
			Секция_СтрокаТаблицыОбороты.Параметры.ДО = ОборотыПоБанковскомуСчетуДт;
			Секция_СтрокаТаблицыОбороты.Параметры.КО = ОборотыПоБанковскомуСчетуКт;
			
			ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыОбороты, 2);
			
			Секция_СтрокаТаблицыСальдоКонечное = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыСальдоКонечное" + ПостфиксЕдИзм);
			Секция_СтрокаТаблицыСальдоКонечное.Параметры.СКД = СтрокаУровняБанковскогоСчета.СКД;
			Секция_СтрокаТаблицыСальдоКонечное.Параметры.СКК = СтрокаУровняБанковскогоСчета.СКК;
			
			ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыСальдоКонечное, 2);
			
			ОборотыПоСчетуДт = ОборотыПоСчетуДт + ОборотыПоБанковскомуСчетуДт;
			ОборотыПоСчетуКт = ОборотыПоСчетуКт + ОборотыПоБанковскомуСчетуКт;
			
		КонецЦикла;
		
		Секция_СтрокаТаблицыОбороты = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыОбороты" + ПостфиксЕдИзм);
		
		Секция_СтрокаТаблицыОбороты.Параметры.ДО = ОборотыПоСчетуДт;
		Секция_СтрокаТаблицыОбороты.Параметры.КО = ОборотыПоСчетуКт;
		
		ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыОбороты, 1);
		
		Секция_СтрокаТаблицыСальдоКонечное = ШаблонПредставления.ПолучитьОбласть("СтрокаТаблицыСальдоКонечное" + ПостфиксЕдИзм);
		Секция_СтрокаТаблицыСальдоКонечное.Параметры.СКД = СтрокаУровняСчета.СКД;
		Секция_СтрокаТаблицыСальдоКонечное.Параметры.СКК = СтрокаУровняСчета.СКК;
		
		ПредставлениеОтчета.Вывести(Секция_СтрокаТаблицыСальдоКонечное, 1);
		
	КонецЦикла;
	
	ПредставлениеОтчета.ЗакончитьАвтогруппировкуСтрок();
	
	Возврат ПредставлениеОтчета;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КодЯзыкаИнтерфейсаКонфигурации()

	Язык = ТекущийЯзык();
	Если Язык = Неопределено Тогда
		// Для пользователя информационной базы не указан язык.
		Возврат КодОсновногоЯзыкаИнтерфейсаКонфигурации();
	КонецЕсли;

	КодЯзыкаВМетаданных = ?(ТипЗнч(Язык) = Тип("Строка"), Язык, Язык.КодЯзыка);
	Возврат КодЯзыкаВМетаданных;

КонецФункции

Функция КодОсновногоЯзыкаИнтерфейсаКонфигурации()

	КодЯзыкаВМетаданных = Метаданные.ОсновнойЯзык.КодЯзыка;
	
	Возврат КодЯзыкаВМетаданных;

КонецФункции

Функция СоединениеССервером(АдресСервера, Таймаут)
	
	Перем ЗащищенноеСоединение;
	
	Адрес = "";
	Протокол = "";
	
	ОпределитьПараметрыСайта(АдресСервера, ЗащищенноеСоединение, Адрес, Протокол);
	Прокси = СформироватьПрокси(Протокол);
	
	Соединение = Новый HTTPСоединение(Адрес, , , ,Прокси, Таймаут, ЗащищенноеСоединение);
	
	Возврат Соединение;
	
КонецФункции

Функция СформироватьПрокси(Протокол)
	
	// НастройкаПроксиСервера - Соответствие:
	//  ИспользоватьПрокси - использовать ли прокси-сервер;
	//  НеИспользоватьПроксиДляЛокальныхАдресов - использовать ли прокси-сервер для локальных адресов;
	//  ИспользоватьСистемныеНастройки - использовать ли системные настройки прокси-сервера;
	//  Сервер       - адрес прокси-сервера;
	//  Порт         - порт прокси-сервера;
	//  Пользователь - имя пользователя для авторизации на прокси-сервере;
	//  Пароль       - пароль пользователя.
	НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
	Если НастройкаПроксиСервера <> Неопределено Тогда
		ИспользоватьПрокси = НастройкаПроксиСервера.Получить("ИспользоватьПрокси");
		ИспользоватьСистемныеНастройки = НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки");
		Если ИспользоватьПрокси Тогда
			Если ИспользоватьСистемныеНастройки Тогда
				// Системные настройки прокси-сервера.
				Прокси = Новый ИнтернетПрокси(Истина);
			Иначе
				// Ручные настройки прокси-сервера.
				Прокси = Новый ИнтернетПрокси;
				Прокси.Установить(Протокол, НастройкаПроксиСервера["Сервер"], НастройкаПроксиСервера["Порт"],
					НастройкаПроксиСервера["Пользователь"], НастройкаПроксиСервера["Пароль"]);
				Прокси.НеИспользоватьПроксиДляЛокальныхАдресов = НастройкаПроксиСервера["НеИспользоватьПроксиДляЛокальныхАдресов"];
			КонецЕсли;
		Иначе
			// Не использовать прокси-сервер.
			Прокси = Новый ИнтернетПрокси(Ложь);
		КонецЕсли;
	Иначе
		Прокси = Неопределено;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

Процедура ОпределитьПараметрыСайта(Знач АдресСайта, ЗащищенноеСоединение, Адрес, Протокол)
	
	АдресСайта = СокрЛП(АдресСайта);
	
	АдресСайта = СтрЗаменить(АдресСайта, "\", "/");
	АдресСайта = СтрЗаменить(АдресСайта, " ", "");
	
	Если НРег(Лев(АдресСайта, 7)) = "http://" Тогда
		Протокол = "http";
		Адрес = Сред(АдресСайта,8);
		ЗащищенноеСоединение = Неопределено;
	ИначеЕсли НРег(Лев(АдресСайта, 8)) = "https://" Тогда
		Протокол =  "https";
		Адрес = Сред(АдресСайта,9);
		
		СертификатыУдостоверяющихЦентров = Неопределено;
		Если НЕ ОбщегоНазначения.ЭтоLinuxСервер() И НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			// Ошибка фреша при работе с веб сервисами. Не работает проверка доверенных сертификатов при установке соединения.
			СертификатыУдостоверяющихЦентров = Новый СертификатыУдостоверяющихЦентровWindows;
		КонецЕсли;
		
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение( , СертификатыУдостоверяющихЦентров);
		
	КонецЕсли;
	
КонецПроцедуры

Функция РасшифровкаКодаСостоянияHTTP(КодСостояния)
	
	СоответствиеКодов = Новый Соответствие;
	СоответствиеКодов.Вставить(400, Нстр("ru = 'Сервер обнаружил в запросе клиента синтаксическую ошибку.'"));
	СоответствиеКодов.Вставить(401, Нстр("ru = 'Неверные данные аутентификации.'"));
	СоответствиеКодов.Вставить(403, Нстр("ru = 'У клиента нет доступа к ресурсу.'"));
	СоответствиеКодов.Вставить(404, Нстр("ru = 'На сервере нет ресурса по указанному URI.'"));
	СоответствиеКодов.Вставить(405, Нстр("ru = 'Указанный клиентом метод нельзя применить к текущему ресурсу.'"));
	СоответствиеКодов.Вставить(406, Нстр("ru = 'Запрошенный URI не может удовлетворить переданным в заголовке характеристикам.'"));
	СоответствиеКодов.Вставить(407, Нстр("ru = 'Для доступа к серверу требуется аутентификация для прокси-сервера.'"));
	СоответствиеКодов.Вставить(408, Нстр("ru = 'Время ожидания сервером передачи от клиента истекло.'"));
	СоответствиеКодов.Вставить(409, Нстр("ru = 'Запрос не может быть выполнен из-за конфликтного обращения к ресурсу.'"));
	СоответствиеКодов.Вставить(410, Нстр("ru = 'Ресурс был удалён и теперь недоступен.'"));
	СоответствиеКодов.Вставить(411, Нстр("ru = 'Не указан объем передаемых данных в заголовке.'"));
	СоответствиеКодов.Вставить(412, Нстр("ru = 'Ни одно из условных полей заголовка запроса не было выполнено.'"));
	СоответствиеКодов.Вставить(413, Нстр("ru = 'Сервер отказался обработать запрос по причине слишком большого размера тела запроса.'"));
	СоответствиеКодов.Вставить(414, Нстр("ru = 'Сервер не может обработать запрос из-за слишком длинного указанного URL.'"));
	СоответствиеКодов.Вставить(415, Нстр("ru = 'Сервер отказывается работать с указанным типом данных при данном методе.'"));
	СоответствиеКодов.Вставить(422, Нстр("ru = 'Имеется логическая ошибка, из-за которой невозможно произвести операцию.'"));
	СоответствиеКодов.Вставить(423, Нстр("ru = 'Целевой ресурс из запроса заблокирован от применения к нему указанного метода.'"));
	СоответствиеКодов.Вставить(426, Нстр("ru = 'Клиенту на необходимость обновить протокол.'"));
	СоответствиеКодов.Вставить(429, Нстр("ru = 'Клиент попытался отправить слишком много запросов за короткое время.'"));
	СоответствиеКодов.Вставить(431, Нстр("ru = 'Превышена допустимая длина заголовков.'"));
	СоответствиеКодов.Вставить(434, Нстр("ru = 'Запрашиваемый адрес недоступен.'"));
	СоответствиеКодов.Вставить(449, Нстр("ru = 'Поступило недостаточно информации.'"));
	СоответствиеКодов.Вставить(451, Нстр("ru = 'Доступ к ресурсу закрыт по юридическим причинам.'"));
	
	СоответствиеКодов.Вставить(500, Нстр("ru = 'Внутренняя ошибка сервера.'"));
	СоответствиеКодов.Вставить(501, Нстр("ru = 'Сервер не поддерживает возможностей, необходимых для обработки запроса.'"));
	СоответствиеКодов.Вставить(502, Нстр("ru = 'Сервер, выступая в роли шлюза или прокси-сервера, получил недействительное ответное сообщение от вышестоящего сервера.'"));
	СоответствиеКодов.Вставить(503, Нстр("ru = 'Сервер временно не имеет возможности обрабатывать запросы по техническим причинам.'"));
	СоответствиеКодов.Вставить(504, Нстр("ru = 'Сервер в роли шлюза или прокси-сервера не дождался ответа от вышестоящего сервера для завершения текущего запроса.'"));
	СоответствиеКодов.Вставить(505, Нстр("ru = 'Сервер не поддерживает указанную в запросе версию протокола HTTP.'"));
	СоответствиеКодов.Вставить(507, Нстр("ru = 'Не хватает места для выполнения текущего запроса.'"));
	СоответствиеКодов.Вставить(510, Нстр("ru = 'На сервере отсутствует расширение, которое желает использовать клиент.'"));
	СоответствиеКодов.Вставить(511, Нстр("ru = 'Необходимо авторизоваться в сети провайдера.'"));
	
	Возврат СоответствиеКодов.Получить(КодСостояния);
	
КонецФункции

Процедура ДобавитьПараметр(ЗаписьJSON, НазваниеПараметра, ЗначениеПараметра)
	
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	ЗаписьJSON.ЗаписатьИмяСвойства("key");
	ЗаписьJSON.ЗаписатьЗначение(НазваниеПараметра);
	ЗаписьJSON.ЗаписатьИмяСвойства("value");
	ЗаписьJSON.ЗаписатьЗначение(ЗначениеПараметра);
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	
КонецПроцедуры

Функция КодВидаСчета(Счет)
	
	КодВидаСчета = "АП";
	
	Если Счет.Вид = ВидСчета.Активный Тогда
		КодВидаСчета = "А";
	ИначеЕсли Счет.Вид = ВидСчета.Пассивный Тогда
		КодВидаСчета = "П";
	КонецЕсли;
	
	Возврат КодВидаСчета;
	
КонецФункции

#КонецОбласти