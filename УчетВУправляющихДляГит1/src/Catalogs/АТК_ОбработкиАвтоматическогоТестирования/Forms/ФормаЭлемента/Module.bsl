
#Область СлужебныеПроцедурыИФункции

///////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
// Управление внешним видом формы.
//
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Если ПустаяСтрока(Форма.АдресДанныхОбработки) Тогда
		Элементы.СтатусОбработки.Картинка = БиблиотекаКартинок.Документ;
	Иначе
		Элементы.СтатусОбработки.Картинка = БиблиотекаКартинок.Обработка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
// Функция подключает внешнюю обработку для последующего открытия ее формы.
//
Функция ПодключитьОбработкуНаСервере(АдресВХранилище)
	
	Возврат ВнешниеОбработки.Подключить(АдресВХранилище, , Истина);
	
КонецФункции

&НаСервереБезКонтекста
// Функция возвращает регистрационные данные обработки.
//
Функция ПолучитьРегистрационныеДанныеОбработки(АдресВХранилище)
	
	РегистрационныеДанные = Неопределено;
	
	// Подключение внешней обработки на сервере.
	ИмяОбработки = ПодключитьОбработкуНаСервере(АдресВХранилище);
	
	Попытка
		// Создание обработки и чтение регистрационных данных.
		ОбработкаОбъект = ВнешниеОбработки.Создать(ИмяОбработки);
		РегистрационныеДанные = ОбработкаОбъект.СведенияОбАвтоматическомТестированииКонфигурации();
	Исключение
	КонецПопытки;
	
	Возврат РегистрационныеДанные;
	
КонецФункции

&НаСервере
// Процедура получает результат выполнения обработки из временного хранилища
// и проверяет его корректность.
Функция ПроверитьРезультатВыполненияОбработкиНаСервере(АдресХранилищаРезультата)
	
	РезультатПроверки = Ложь;
	
	РезультатыТестирования = ПолучитьИзВременногоХранилища(АдресХранилищаРезультата);
	Если ТипЗнч(РезультатыТестирования) = Тип("ТаблицаЗначений") Тогда
		РезультатПроверки = Истина;
	КонецЕсли;
	
	Возврат РезультатПроверки;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийФормы

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
// Обработчик события "ПриЧтенииНаСервере" формы.
//
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	АдресДанныхОбработки = ПоместитьВоВременноеХранилище(
			ТекущийОбъект.ДанныеОбработки.Получить(),
			УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установим признак использования обработки по умолчанию.
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Использование = 1;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПередЗаписью" формы.
//
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПустаяСтрока(АдресДанныхОбработки) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю("Для записи элемента необходимо загрузить обработку!");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Обработчик события "ПередЗаписьюНаСервере" формы.
//
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ДвоичныеДанныеОбработки = ПолучитьИзВременногоХранилища(АдресДанныхОбработки);
		ТекущийОбъект.ДанныеОбработки = Новый ХранилищеЗначения(ДвоичныеДанныеОбработки, Новый СжатиеДанных(9));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
// Обработчик команды "ЗагрузитьИзФайла".
//
Процедура ЗагрузитьИзФайла(Команда)
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Успех", Ложь);
	ПараметрыРегистрации.Вставить("АдресДанныхОбработки", АдресДанныхОбработки);
	Обработчик = Новый ОписаниеОповещения("ОбновлениеИзФайлаПослеВыбораФайла", ЭтотОбъект, ПараметрыРегистрации);
	
	ПараметрыДиалога = Новый Структура("Режим, Фильтр, ИндексФильтра, Заголовок");
	ПараметрыДиалога.ИндексФильтра = 0;
	ПараметрыДиалога.Режим         = РежимДиалогаВыбораФайла.Открытие;
	ПараметрыДиалога.Фильтр        = НСтр("ru = 'Внешние обработки (*.epf)|*.epf'");
	ПараметрыДиалога.Заголовок     = НСтр("ru = 'Выберите файл внешней обработки сценария тестирования'");
	
	АТК_ОбщегоНазначенияКлиент.ПоказатьПомещениеФайла(Обработчик, УникальныйИдентификатор, "", ПараметрыДиалога);
	
КонецПроцедуры

&НаКлиенте
// Обработка выбранного файла и его загрузка в двоичные данные.
//
Процедура ОбновлениеИзФайлаПослеВыбораФайла(ПомещенныеФайлы, ПараметрыРегистрации) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Или ПомещенныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеФайла = ПомещенныеФайлы[0];
	
	// Чтение регистрационных данных обработки.
	РегистрационныеДанные = ПолучитьРегистрационныеДанныеОбработки(ОписаниеФайла.Хранение);
	Если ТипЗнч(РегистрационныеДанные) = Тип("Структура") Тогда
		
		// Получение регистрационных данных.
		РегистрационныеДанные.Свойство("Наименование",          Объект.Наименование);
		РегистрационныеДанные.Свойство("ОписаниеОбработки",     Объект.ОписаниеОбработки);
		РегистрационныеДанные.Свойство("НаименованиеПрограммы", Объект.НаименованиеПрограммы);
		РегистрационныеДанные.Свойство("ВерсияПрограммы",       Объект.ВерсияПрограммы);
		
		// Запись адреса данных обработки в хранилище.
		АдресДанныхОбработки = ОписаниеФайла.Хранение;
		
		Модифицированность = Истина;
		
		УправлениеФормой(ЭтаФорма);
		
	Иначе
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю("Обработка не загружена, возникла ошибка при чтении регистрационных данных обработки!");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик команды "ВыгрузитьВФайл".
//
Процедура ВыгрузитьВФайл(Команда)
	
	ПараметрыВыгрузки = Новый Структура;
	ПараметрыВыгрузки.Вставить("ИмяФайла",             ПодключитьОбработкуНаСервере(АдресДанныхОбработки));
	ПараметрыВыгрузки.Вставить("АдресДанныхОбработки", АдресДанныхОбработки);
	АТК_ОбщегоНазначенияКлиент.ВыгрузитьВФайл(ПараметрыВыгрузки);
	
КонецПроцедуры

&НаКлиенте
// Обработчик команды "ПроверитьОбработку".
//
Процедура ПроверитьОбработку(Команда)
	
	Если Модифицированность Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю("Перед проверкой необходимо записать элемент!");
		Возврат;
	КонецЕсли;
	
	// Подключение внешней обработки на сервере.
	ИмяОбработки = ПодключитьОбработкуНаСервере(АдресДанныхОбработки);
	
	// Открытие формы обработки на клиенте и запуск тестирования.
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьРезультатВыполненияОбработки", ЭтотОбъект);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЗапуститьТестированиеПриОткрытии", Истина);
	
	ОткрытьФорму("ВнешняяОбработка."+ ИмяОбработки +".Форма", СтруктураПараметров, ЭтаФорма,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
// Обработчик окончания проверки обработки.
//
Процедура ОбработатьРезультатВыполненияОбработки(АдресХранилищаРезультата, ДопПараметры) Экспорт
	
	Если Не АдресХранилищаРезультата = Неопределено Тогда
		РезультатПроверки = ПроверитьРезультатВыполненияОбработкиНаСервере(АдресХранилищаРезультата);
		Если РезультатПроверки = Истина Тогда
			ПоказатьПредупреждение(, "Проверка выполнена успешно.");
		Иначе
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю("При проверке обработки возникли ошибки!");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
