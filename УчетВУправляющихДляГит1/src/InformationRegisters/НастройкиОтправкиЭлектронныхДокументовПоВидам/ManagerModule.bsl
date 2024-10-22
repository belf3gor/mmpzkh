#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаЗаписи" Тогда
		Ключ = Неопределено;
		Если ЗначениеЗаполнено(Параметры) И Параметры.Свойство("Ключ", Ключ) Тогда
			МенеджерЗаписи = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Параметры.Ключ);
			
			МенеджерЗаписи.Прочитать();
			Если МенеджерЗаписи.Выбран() И МенеджерЗаписи.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.Интеркампани Тогда
				СтандартнаяОбработка = Ложь;
				Параметры.Вставить("Отправитель", МенеджерЗаписи.Отправитель);
				Параметры.Вставить("Получатель",  МенеджерЗаписи.Получатель);
				ВыбраннаяФорма = Метаданные.РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.Формы.НастройкиОтправкиДокументовИнтеркампани;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Формирует таблицу настроек отправки и заполняет ее данными по умолчанию
// 
// Возвращаемое значений:
//  Параметры - ТаблицаЗначений - таблица настроек.
//
Функция СоздатьНастройкиОтправкиДокументов() Экспорт
	
	ИсходящиеДокументы = Новый ТаблицаЗначений;
	
	ИсходящиеДокументы.Колонки.Добавить("ДокументУчета"                   , Типы().Строка);
	ИсходящиеДокументы.Колонки.Добавить("ДополнительныеНастройки"         , Типы().Строка);
	ИсходящиеДокументы.Колонки.Добавить("Приоритет"                       , Типы().Число);

	ИсходящиеДокументы.Колонки.Добавить("ВидДокумента"                    , Новый ОписаниеТипов("ПеречислениеСсылка.ВидыЭД"));
	ИсходящиеДокументы.Колонки.Добавить("ПрикладнойВидЭД"                 , Метаданные.ОпределяемыеТипы.ПрикладныеВидыЭлектронныхДокументов.Тип);
	ИсходящиеДокументы.Колонки.Добавить("ВерсияФормата"                   , Типы().Строка);
	ИсходящиеДокументы.Колонки.Добавить("СпособОбменаЭД"                  , Новый ОписаниеТипов("ПеречислениеСсылка.СпособыОбменаЭД"));
	ИсходящиеДокументы.Колонки.Добавить("ИдентификаторОтправителя"        , Типы().Строка);
	ИсходящиеДокументы.Колонки.Добавить("ИдентификаторПолучателя"         , Типы().Строка);
	ИсходящиеДокументы.Колонки.Добавить("МаршрутПодписания"               , Новый ОписаниеТипов("СправочникСсылка.МаршрутыПодписания"));
	ИсходящиеДокументы.Колонки.Добавить("ТребуетсяОтветнаяПодпись"        , Типы().Булево);
	ИсходящиеДокументы.Колонки.Добавить("ТребуетсяИзвещениеОПолучении"    , Типы().Булево);
	ИсходящиеДокументы.Колонки.Добавить("ВыгружатьДополнительныеСведения" , Типы().Булево);
	ИсходящиеДокументы.Колонки.Добавить("Формировать"                     , Типы().Булево);
	ИсходящиеДокументы.Колонки.Добавить("ИспользоватьЭП"                  , Типы().Булево);
	ИсходящиеДокументы.Колонки.Добавить("ВерсияФорматаУстановленаВручную" , Типы().Булево);
	ИсходящиеДокументы.Колонки.Добавить("ЗаполнениеКодаТовара"            , Типы().Строка);
	ИсходящиеДокументы.Колонки.Добавить("Отправитель"                     , Метаданные.ОпределяемыеТипы.Организация.Тип);
	ИсходящиеДокументы.Колонки.Добавить("Получатель"                      , Метаданные.ОпределяемыеТипы.УчастникЭДО.Тип);
	ИсходящиеДокументы.Колонки.Добавить("ДоговорКонтрагента"              , Метаданные.ОпределяемыеТипы.ДоговорСКонтрагентом.Тип);
	
	ВидыЭлектронныхДокументов = ОбменСКонтрагентамиСлужебный.ИспользуемыеВидыЭлектронныхДокументов(Перечисления.НаправленияЭД.Исходящий);
	
	Для Каждого ЗначениеПеречисления Из ВидыЭлектронныхДокументов Цикл
		
		НоваяСтрока = ИсходящиеДокументы.Добавить();
		
		ОбменСКонтрагентамиСлужебный.ЗаполнитьНастройкуПоВидуЭлектронногоДокумента(
				НоваяСтрока, ЗначениеПеречисления);
		
	КонецЦикла;
	
	ПрикладныеВидыЭлектронныхДокументов = ОбменСКонтрагентамиСлужебный.ПрикладныеВидыЭлектронныхДокументов();
	Для Каждого ПрикладнойВид Из ПрикладныеВидыЭлектронныхДокументов Цикл
		
		НоваяСтрока = ИсходящиеДокументы.Добавить();
		ОбменСКонтрагентамиСлужебный.ЗаполнитьНастройкуПоПрикладномуВидуЭлектронногоДокумента(
			НоваяСтрока, ПрикладнойВид);
		
		КонецЦикла;
		
	УстановитьВариантыЗаполненияПолейПоУмолчанию(ИсходящиеДокументы);
	
	Возврат ИсходящиеДокументы;
	
КонецФункции

// Удаляет настройки отправки ЭДО
// 
//  Параметры - СписокЗначений - параметры учетной записи для удаления
//  АдресРезультата - Строка - путь временного хранилища
//
Процедура УдалитьНастройкиОтправкиЭДО(Параметры, АдресРезультата) Экспорт
	
	Организация        = Неопределено;
	Контрагент         = Неопределено;
	ДоговорКонтрагента = Неопределено;
	Результат          = Истина;
	
	Параметры.Свойство("Организация"       , Организация);
	Параметры.Свойство("Контрагент"        , Контрагент);
	Параметры.Свойство("ДоговорКонтрагента", ДоговорКонтрагента);
	
	Если Не ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ДоговорКонтрагента = Метаданные.ОпределяемыеТипы.ДоговорСКонтрагентом.Тип.ПривестиЗначение();
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Отправитель.Установить(Организация);
	НаборЗаписей.Отбор.Получатель.Установить(Контрагент);
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		НаборЗаписей.Отбор.Договор.Установить(ДоговорКонтрагента);
	КонецЕсли;
	
	НаборЗаписейЗаполнениеДопПолей = РегистрыСведений.НастройкиЗаполненияДополнительныхПолей.СоздатьНаборЗаписей();
	НаборЗаписейЗаполнениеДопПолей.Отбор.Отправитель.Установить(Организация);
	НаборЗаписейЗаполнениеДопПолей.Отбор.Получатель.Установить(Контрагент);
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		НаборЗаписейЗаполнениеДопПолей.Отбор.Договор.Установить(ДоговорКонтрагента);
	КонецЕсли;

	НачатьТранзакцию();
	
	Попытка
		// Попытка удаления. Управляемую блокировку устанавливать нет необходимости.
		НаборЗаписей.Записать();
		НаборЗаписейЗаполнениеДопПолей.Записать();
		
		ИмяРеквизитаИННКонтрагента = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ИННКонтрагента");
		ИмяРеквизитаКППКонтрагента = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("КППКонтрагента");
		
		ПараметрыКонтрагента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Контрагент,
			ИмяРеквизитаИННКонтрагента + ", " + ИмяРеквизитаКППКонтрагента);
		
		Параметры = Новый Структура();
		Параметры.Вставить("Контрагент", Контрагент);
		Параметры.Вставить("ИНН", ПараметрыКонтрагента[ИмяРеквизитаИННКонтрагента]);
		Параметры.Вставить("КПП", ПараметрыКонтрагента[ИмяРеквизитаКППКонтрагента]);
		Параметры.Вставить("АдресХранилища", Неопределено);
		Параметры.Вставить("СохранятьРезультатСразуПослеПроверки", Истина);
		Параметры.Вставить("ПолучатьРезультатПроверкиВебСервисом", Истина);
		
		ОбменСКонтрагентамиСлужебный.ПроверитьКонтрагентаФоновоеЗадание(Параметры);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Информация = ИнформацияОбОшибке();
		
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Не удалось удалить настройки отправки по:
                                      |Организация: %1,
                                      |Контрагент: %2,
                                      |Договор контрагента: %3.'"), Организация, Контрагент, ДоговорКонтрагента);
		
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Удаление настроек отправки ЭДО'"), ПодробноеПредставлениеОшибки(Информация), ТекстОшибки);
		Результат = Ложь;
		
	КонецПопытки;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

// Удаляет настройки отправки интеркампани
// 
//  Параметры - СписокЗначений - параметры учетной записи для удаления
//  АдресРезультата - Строка - путь временного хранилища
//
Процедура УдалитьНастройкиИнтеркампани(Параметры, АдресРезультата) Экспорт
	
	Отправитель        = Неопределено;
	Получатель         = Неопределено;
	Результат          = Истина;
	
	Параметры.Свойство("Отправитель"       , Отправитель);
	Параметры.Свойство("Получатель"        , Получатель);
	
	НаборЗаписей = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Отправитель.Установить(Отправитель);
	НаборЗаписей.Отбор.Получатель.Установить(Получатель);
	
	НачатьТранзакцию();
	Попытка
		// Попытка удаления. Управляемую блокировку устанавливать нет необходимости.
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Информация = ИнформацияОбОшибке();
		
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Не удалось удалить настройки интеркампани по:
                                      |Отправитель: %1,
                                      |Получатель: %2.'"), Отправитель, Получатель);
		
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Удаление настроек интеркампани'"), ПодробноеПредставлениеОшибки(Информация), ТекстОшибки);
		Результат = Ложь;
		
	КонецПопытки;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

// Записывает обновленные настройки отправки в регистр
// 
//  Настройки - Структура - настройки обмена для записи
Процедура ЗаписатьОбновленныеНастройки(Настройки) Экспорт
	
	Менеджер = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьМенеджерЗаписи();
	Менеджер.Отправитель     = Настройки.Отправитель;
	Менеджер.Получатель      = Настройки.Получатель;
	Менеджер.Договор         = Настройки.Договор;
	Менеджер.ВидДокумента    = Настройки.ВидЭД;
	Менеджер.ПрикладнойВидЭД = Настройки.ПрикладнойВидЭД;
	Менеджер.Прочитать();
	Менеджер.ВерсияФормата                   = Настройки.ВерсияФормата;
	Менеджер.ИдентификаторОтправителя        = Настройки.ИдентификаторОрганизации;
	Менеджер.ИдентификаторПолучателя         = Настройки.ИдентификаторКонтрагента;
	Менеджер.МаршрутПодписания               = Настройки.МаршрутПодписания;
	Менеджер.ТребуетсяОтветнаяПодпись        = Настройки.ТребуетсяПодтверждение;
	Менеджер.ТребуетсяИзвещениеОПолучении    = Настройки.ТребуетсяИзвещение;
	Менеджер.ВыгружатьДополнительныеСведения = Настройки.ВыгружатьДополнительныеСведения;
	Менеджер.ВерсияФорматаУстановленаВручную = Настройки.ВерсияФорматаУстановленаВручную;
	Менеджер.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Типы получаемых данных.
// 
// Возвращаемое значение:
//  Структура - описание типов:
//   * Простой         - простой тип.
//   * Строка          - тип Строка.
//   * Число           - тип Число.
//   * Булево          - тип Булево.
//   * Структура       - тип Структура.
//   * Дата            - тип Дата.
//   * ТаблицаЗначений - тип ТаблицаЗначений.
//
Функция Типы()
	
	Результат = Новый Структура;
	Результат.Вставить("Простой",   Новый ОписаниеТипов("Строка, Булево, Число, Дата"));
	Результат.Вставить("Булево",    Новый ОписаниеТипов("Булево"));
	Результат.Вставить("Число",     Новый ОписаниеТипов("Число"));
	Результат.Вставить("Дата",      Новый ОписаниеТипов("Дата"));
	Результат.Вставить("Строка",    Новый ОписаниеТипов("Строка"));
	Результат.Вставить("Структура", Новый ОписаниеТипов("Структура"));
	Результат.Вставить("Массив",    Новый ОписаниеТипов("Массив"));
	Результат.Вставить("Таблица",   Новый ОписаниеТипов("ТаблицаЗначений"));
	
	Возврат Результат;
	
КонецФункции

Процедура УстановитьВариантыЗаполненияПолейПоУмолчанию(ИсходящиеДокументы)
	
	Для Каждого СтрокаТаблицы Из ИсходящиеДокументы Цикл
		ВариантыЗаполнения = ОбменСКонтрагентамиВнутренний.ВариантыЗаполненияПолейЭлектронныхДокументов(
			СтрокаТаблицы.ВидДокумента, СтрокаТаблицы.ВерсияФормата);
		
		ЗначениеСвойства = Неопределено;
		Если ВариантыЗаполнения.Свойство("ТоварКод", ЗначениеСвойства) Тогда
			СтрокаТаблицы.ЗаполнениеКодаТовара = ЗначениеСвойства[0].Значение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
