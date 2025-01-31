
//////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область Форма

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Организация = УПЖКХ_ТиповыеМетодыВызовСервера.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	
	ВосстановитьНастройкиНаСервере();
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
// Обработчик события "ПриОткрытии" формы.
//
Процедура ПриОткрытии(Отказ)
	
	ОбновитьПериод();
	
КонецПроцедуры // ПриОткрытии()

&НаКлиенте
// Обработчик события "ПередЗакрытием" формы.
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СохранитьНастройкиНаСервере();
	
КонецПроцедуры // ПередЗакрытием()

////////////////////////
// Сохраняемые настройки

&НаСервере
// Процедура восстановления настроек.
//
Процедура ВосстановитьНастройкиНаСервере()
	
	СтруктураПараметров = УПЖКХ_ТиповыеМетодыВызовСервера.ХранилищеОбщихНастроекЗагрузить("ПараметрыВыгрузки_КалининградскаяОбласть", "ПараметрыВыгрузки");
	Если ТипЗнч(СтруктураПараметров) = Тип("Структура") Тогда
		
		// Файл загрузки.
		врИмяФайлаЗагрузки = Неопределено;
		Если СтруктураПараметров.Свойство("ИмяФайлаЗагрузки", врИмяФайлаЗагрузки) Тогда
			Объект.ИмяФайлаЗагрузки = врИмяФайлаЗагрузки;
		КонецЕсли;
		
		// Каталог выгрузки.
		врИмяКаталогаВыгрузки = Неопределено;
		Если СтруктураПараметров.Свойство("ИмяКаталогаВыгрузки", врИмяКаталогаВыгрузки) Тогда
			Объект.ИмяКаталогаВыгрузки = врИмяКаталогаВыгрузки;
		КонецЕсли;
		
		// Наименование организации.
		врНаименованиеОрганизации = Неопределено;
		Если СтруктураПараметров.Свойство("НаименованиеОрганизации", врНаименованиеОрганизации) Тогда
			НаименованиеОрганизации = врНаименованиеОрганизации;
		КонецЕсли;
		
		// Код Организации.
		врКодОрганизации = Неопределено;
		Если СтруктураПараметров.Свойство("КодОрганизации", врКодОрганизации) Тогда
			КодОрганизации = врКодОрганизации;
		КонецЕсли;
		
		// Таблица настройки услуг.
		врТаблицаНастройкиУслуг = Неопределено;
		Если СтруктураПараметров.Свойство("КалининградскаяОбласть_НастройкаУслуг", врТаблицаНастройкиУслуг) Тогда
			Если ТипЗнч(врТаблицаНастройкиУслуг) = Тип("ТаблицаЗначений") Тогда
				Объект.КалининградскаяОбласть_НастройкаУслуг.Загрузить(врТаблицаНастройкиУслуг);
			КонецЕсли;
		КонецЕсли;
		
		// Таблица организаций.
		врТаблицаОрганизаций = Неопределено;
		Если СтруктураПараметров.Свойство("КалининградскаяОбласть_ТаблицаОрганизаций", врТаблицаОрганизаций) Тогда
			Если ТипЗнч(врТаблицаОрганизаций) = Тип("ТаблицаЗначений") Тогда
				Объект.КалининградскаяОбласть_ТаблицаОрганизаций.Загрузить(врТаблицаОрганизаций);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ВосстановитьНастройкиНаСервере()

&НаСервере
// Процедура сохранения настроек.
//
Процедура СохранитьНастройкиНаСервере()
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИмяФайлаЗагрузки",                          Объект.ИмяФайлаЗагрузки);
	СтруктураПараметров.Вставить("ИмяКаталогаВыгрузки",                       Объект.ИмяКаталогаВыгрузки);
	СтруктураПараметров.Вставить("НаименованиеОрганизации",                   НаименованиеОрганизации);
	СтруктураПараметров.Вставить("КодОрганизации",                            КодОрганизации);
	СтруктураПараметров.Вставить("КалининградскаяОбласть_НастройкаУслуг",     Объект.КалининградскаяОбласть_НастройкаУслуг.Выгрузить());
	СтруктураПараметров.Вставить("КалининградскаяОбласть_ТаблицаОрганизаций", Объект.КалининградскаяОбласть_ТаблицаОрганизаций.Выгрузить());
	
	УПЖКХ_ТиповыеМетодыВызовСервера.ХранилищеОбщихНастроекСохранить("ПараметрыВыгрузки_КалининградскаяОбласть", "ПараметрыВыгрузки", СтруктураПараметров);
	
КонецПроцедуры // СохранитьНастройкиНаСервере()

#КонецОбласти

//////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

#Область ПериодСтрокой

&НаКлиенте
// Изменяет период на форме выгрузки.
//
// Параметры:
//  Период - Дата - устанавливаемый период.
//
Процедура ОбновитьПериод(Период = Неопределено)
	
	Объект.Период = ?(Период = Неопределено, УПЖКХ_ТиповыеМетодыВызовСервера.ПолучитьЗначениеПоУмолчанию("РабочаяДата"), КонецМесяца(Период));
	
	Если Объект.Период = '00010101' Тогда
		Объект.Период = ТекущаяДата();
	КонецЕсли;
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.Период", "ПериодСтрокой");
	
КонецПроцедуры // ОбновитьПериод()

&НаКлиенте
// Обработчик события "ПриИзменении" поля "ПериодСтрокой".
//
Процедура ПериодСтрокойПриИзменении(Элемент)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.Период", "ПериодСтрокой", Модифицированность);
	
КонецПроцедуры // ПериодСтрокойПриИзменении()

&НаКлиенте
// Обработчик события "НачалоВыбора" поля "ПериодСтрокой".
//
Процедура ПериодСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.Период", "ПериодСтрокой");
	
КонецПроцедуры // ПериодСтрокойНачалоВыбора()

&НаКлиенте
// Обработчик события "Регулирование" поля "ПериодСтрокой".
//
Процедура ПериодСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.Период", "ПериодСтрокой", Направление, Модифицированность);
	
КонецПроцедуры // ПериодСтрокойРегулирование()

&НаКлиенте
// Обработчик события "АвтоПодбор" поля "ПериодСтрокой".
//
Процедура ПериодСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры // ПериодСтрокойАвтоПодбор()

&НаКлиенте
// Обработчик события "ОкончаниеВводаТекста" поля "ПериодСтрокой".
//
Процедура ПериодСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры // ПериодСтрокойОкончаниеВводаТекста()

#КонецОбласти

#Область ФайлЗагрузки

&НаКлиенте
// Обработчик события "НачалоВыбора" поля "ИмяФайлаЗагрузки".
//
Процедура ИмяФайлаЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогВыбораФайла                    = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Заголовок          = "Выберите файл";
	ДиалогВыбораФайла.Каталог            = Объект.ИмяФайлаЗагрузки;
	ДиалогВыбораФайла.ПолноеИмяФайла     = "";
	ДиалогВыбораФайла.Фильтр             = "Файл данных (*.dbf)|*.dbf"; 
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	
	ДиалогВыбораФайла.Показать(Новый ОписаниеОповещения("ИмяФайлаЗагрузкиНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("ДиалогВыбораФайла", ДиалогВыбораФайла)));
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаЗагрузкиНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	ДиалогВыбораФайла = ДополнительныеПараметры.ДиалогВыбораФайла;
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		
		Файл = Новый Файл(ДиалогВыбораФайла.ПолноеИмяФайла);
		
		ИмяФайла = Файл.ИмяБезРасширения;
		Если СтрДлина(ИмяФайла) <= 8 Тогда
			Объект.ИмяФайлаЗагрузки = ДиалогВыбораФайла.ПолноеИмяФайла;
		Иначе
			ПоказатьПредупреждение(,"Длина файла загрузки не может быть больше 8 символов. Переименуйте выбираемый файл!");
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ИмяФайлаВыгрузкиНачалоВыбора()

&НаКлиенте
// Обработчик события "Открытие" поля "ИмяФайлаЗагрузки".
//
Процедура ИмяФайлаЗагрузкиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Файл = Новый Файл(Объект.ИмяФайлаЗагрузки);
	
	Файл.НачатьПроверкуСуществования(Новый ОписаниеОповещения("ИмяФайлаЗагрузкиОткрытиеЗавершение1", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаЗагрузкиОткрытиеЗавершение1(Существует, ДополнительныеПараметры) Экспорт
	
	Если НЕ Существует Тогда
		Возврат;
	КонецЕсли;
	
	Файл = Новый Файл(Объект.ИмяФайлаЗагрузки);
	
	Файл.НачатьПроверкуЭтоФайл(Новый ОписаниеОповещения("ИмяФайлаЗагрузкиОткрытиеЗавершение1Завершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаЗагрузкиОткрытиеЗавершение1Завершение(ЭтоФайл, ДополнительныеПараметры1) Экспорт
	
	Если ЭтоФайл Тогда
		НачатьЗапускПриложения(Новый ОписаниеОповещения("ИмяФайлаЗагрузкиОткрытиеЗавершение", ЭтотОбъект), Объект.ИмяФайлаЗагрузки);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаЗагрузкиОткрытиеЗавершение(КодВозврата, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры // ИмяФайлаЗагрузкиОткрытие()

#КонецОбласти

//////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

#Область КомандаНастройка

&НаКлиенте
// Обработчик команды "КомандаНастройка".
//
Процедура КомандаНастройка(Команда)
	
	АдресНастроекВХранилище = ПоместитьНастройкиВХранилище();
	
	// Передаем вид разреза выгрузки и заполняемые настройки в параметры открытия формы настроек.
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ВыгрузкаВРазрезеУслуг",   Объект.ВыгрузкаВРазрезеУслуг);
	ПараметрыОткрытияФормы.Вставить("АдресНастроекВХранилище", АдресНастроекВХранилище);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаНастройкаЗавершение", ЭтаФорма);
	ОткрытьФорму("Обработка.УПЖКХ_ВыгрузкиВОрганыСоцЗащиты.Форма.КалиниградскаяОбласть_Настройка", ПараметрыОткрытияФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры // КомандаНастройка()

&НаКлиенте
// Обработчик результата опроса команды "КомандаНастройка".
//
Процедура КомандаНастройкаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ПолучитьНастройкиИзХранилища(Результат);
	КонецЕсли;
	
КонецПроцедуры // КомандаНастройкаЗавершение()

////////////////////////
// Работа с временным хранилищем

&НаСервере
// Помещает данные во временное хранилище для передачи их в форму настройки.
//
// Возвращаемое значение:
//  Строка - адрес настроек в хранилище.
//
Функция ПоместитьНастройкиВХранилище()
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("КалининградскаяОбласть_НастройкаУслуг",     Объект.КалининградскаяОбласть_НастройкаУслуг.Выгрузить());
	СтруктураНастроек.Вставить("КалининградскаяОбласть_ТаблицаОрганизаций", Объект.КалининградскаяОбласть_ТаблицаОрганизаций.Выгрузить());
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураНастроек, Новый УникальныйИдентификатор);
	
КонецФункции // ПоместитьДанныеВХранилище()

&НаСервере
// Помещает таблицу услуг во временное хранилище.
//
Функция ПолучитьНастройкиИзХранилища(АдресУслугВХранилище)
	
	СтруктураНастроек = ПолучитьИзВременногоХранилища(АдресУслугВХранилище);
	
	Если ТипЗнч(СтруктураНастроек) = Тип("Структура") Тогда
		
		// Таблица настройки услуг.
		врТаблицаНастройкиУслуг = Неопределено;
		Если СтруктураНастроек.Свойство("КалининградскаяОбласть_НастройкаУслуг", врТаблицаНастройкиУслуг) Тогда
			Если ТипЗнч(врТаблицаНастройкиУслуг) = Тип("ТаблицаЗначений") Тогда
				Объект.КалининградскаяОбласть_НастройкаУслуг.Загрузить(врТаблицаНастройкиУслуг);
			КонецЕсли;
		КонецЕсли;
		
		// Таблица организаций.
		врТаблицаОрганизаций = Неопределено;
		Если СтруктураНастроек.Свойство("КалининградскаяОбласть_ТаблицаОрганизаций", врТаблицаОрганизаций) Тогда
			Если ТипЗнч(врТаблицаОрганизаций) = Тип("ТаблицаЗначений") Тогда
				Объект.КалининградскаяОбласть_ТаблицаОрганизаций.Загрузить(врТаблицаОрганизаций);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции // ПолучитьНастройкиИзХранилища()

#КонецОбласти

#Область КомандаСправочнаяИнформация

&НаКлиенте
// Обработчик команды "КомандаСправочнаяИнформация".
//
Процедура КомандаСправочнаяИнформация(Команда)
	
	ОткрытьСправкуФормы();
	
КонецПроцедуры // КомандаСправочнаяИнформация()

#КонецОбласти

#Область КомандаЗагрузить

&НаКлиенте
// Обработчик команды "КомандаЗагрузить".
//
Процедура КомандаЗагрузить(Команда)
	
	ТекстОшибки = СформироватьТекстОшибкиЗаполненияРеквизитовФормы();
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке(ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Если Объект.КалининградскаяОбласть_ТаблицаВыгрузки.Количество() > 0 Тогда
		
		Оповещение = Новый ОписаниеОповещения("КомандаЗагрузитьВопрос", ЭтотОбъект);
		
		ТекстВопроса = "Перед загрузкой табличная часть будет очищена. Загрузить?";
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		КомандаЗагрузитьПродолжение();
	КонецЕсли;
	
КонецПроцедуры // КомандаЗагрузить()

&НаКлиенте
// Обработчик результата опроса команды "КомандаЗагрузить".
//
Процедура КомандаЗагрузитьВопрос(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Объект.КалининградскаяОбласть_ТаблицаВыгрузки.Очистить();
		
		КомандаЗагрузитьПродолжение();
		
	КонецЕсли;
	
КонецПроцедуры // КомандаЗагрузитьВопрос()

&НаКлиенте
// Отправка dbf-файла на сервер.
//
Процедура КомандаЗагрузитьПродолжение()
	
	// Помещаем загружаемый файл во временное хранилище.
	Оповещение = Новый ОписаниеОповещения("ОбработатьПомещениеФайла", ЭтотОбъект);
	НачатьПомещениеФайла(Оповещение, , Объект.ИмяФайлаЗагрузки, Ложь, УникальныйИдентификатор);
	
КонецПроцедуры // КомандаЗагрузитьПродолжение()

&НаКлиенте
// Обработчик результата помещения файла во временное хранилище.
//
Процедура ОбработатьПомещениеФайла(Результат, АдресФайлаВХранилище, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		// Загружаем данные из dbf на сервере.
		КомандаЗагрузитьПродолжениеНаСервере(АдресФайлаВХранилище);
		
	КонецЕсли;
	
КонецПроцедуры // ОбработатьПомещениеФайла()

&НаСервере
// Загрузка таблицы услуг в ОСЗН из dbf-файла.
//
Процедура КомандаЗагрузитьПродолжениеНаСервере(АдресФайлаВХранилище)
	
	// Получаем dbf из временного хранилища.
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаВХранилище);
	
	// Для чтения *.dbf файла в кодировке DOS (OEM).
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("dbf");
	
	Файл = Новый Файл(ИмяВременногоФайла);
	КороткоеИмяВременногоФайла = СтрЗаменить(Файл.ПолноеИмя, Файл.ИмяБезРасширения, "upload");
	
	// Записываем dbf в файл с указанным именем.
	ДвоичныеДанные.Записать(КороткоеИмяВременногоФайла);
	
	// Заполнение таблицы данных из файла.
	ФайлДБФ = Новый XBase;
	ФайлДБФ.Кодировка = КодировкаXBase.OEM;
	
	ФайлДБФ.ОткрытьФайл(КороткоеИмяВременногоФайла, , Истина);
	
	Если Не ФайлДБФ.Открыта() Тогда
		Текст = "ru = ""Не удалось открыть указанный файл!"";"
			  + " en = ""Can't open this file!""";
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке(НСтр(Текст));
		Возврат;
	КонецЕсли;
	
	ТаблицаДанныхИзФайла = Новый ТаблицаЗначений;
	
	// Сопоставление типов колонок из файла в табличной части.
	Для Каждого Поле Из ФайлДБФ.Поля Цикл
		Если Поле.Тип = "S" Тогда
			ТаблицаДанныхИзФайла.Колонки.Добавить(Поле.Имя, УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьОписаниеТиповСтроки(Поле.Длина));
		ИначеЕсли Поле.Тип = "N" Тогда
			ТаблицаДанныхИзФайла.Колонки.Добавить(Поле.Имя, УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьОписаниеТиповЧисла(Поле.Длина, Поле.Точность));
		ИначеЕсли Поле.Тип = "D" Тогда
			ТаблицаДанныхИзФайла.Колонки.Добавить(Поле.Имя, УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьОписаниеТиповДаты(ЧастиДаты.Дата));
		КонецЕсли;
	КонецЦикла;
	
	// Запись данных из файла в таблицу значений "ТаблицаДанныхИзФайла".
	Пока Не ФайлДБФ.ВКонце() Цикл
		
		НоваяЗапись = ТаблицаДанныхИзФайла.Добавить();
		Для Каждого Колонка Из ТаблицаДанныхИзФайла.Колонки Цикл
			НоваяЗапись[Колонка.Имя] = ?(Строка(Колонка.ТипЗначения) = "Строка", СокрЛП(ФайлДБФ[Колонка.Имя]), ФайлДБФ[Колонка.Имя]);
		КонецЦикла;
		
		ФайлДБФ.Следующая();
		
	КонецЦикла;
	
	СписокВидовУслуг  = ПодготовитьСписокВидовУслугНачислений();
	СписокОрганизаций = ПодготовитьСписокОрганизаций();
	
	ДеревоНачислений = ПолучитьДеревоНачислений(ТаблицаДанныхИзФайла, СписокВидовУслуг, СписокОрганизаций);
	
	ДатаВыгрузки = Формат(НачалоМесяца(Объект.Период), "ДФ=dd.MM.yyyy");
	
	Для Каждого ЛицевойСчет Из ДеревоНачислений.Строки Цикл
		
		Для Каждого ВидУслугиВЖКХ Из ЛицевойСчет.Строки Цикл
			
			Для Каждого ТекУслуга Из ВидУслугиВЖКХ.Строки Цикл
				
				НоваяСтрока = Объект.КалининградскаяОбласть_ТаблицаВыгрузки.Добавить();
				
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекУслуга);
				НоваяСтрока.DAT     = ДатаВыгрузки;
				НоваяСтрока.KOD_ORG = КодОрганизации;
				НоваяСтрока.N_ORG   = НаименованиеОрганизации;
				
				Если ТекУслуга.Идентифицирован Тогда
					//Если ЗначениеЗаполнено(ТекУслуга.Услуга) Тогда
					//НоваяСтрока.N_USL = СокрЛП(ТекУслуга.Услуга.Наименование);
					Если ЗначениеЗаполнено(ТекУслуга.NAC) Тогда
						НоваяСтрока.PRIM = 0;
					Иначе
						НоваяСтрока.PRIM = 1;
					КонецЕсли;
					//Иначе
					//	НоваяСтрока.PRIM = 1;
					//КонецЕсли;
				Иначе
					НоваяСтрока.PRIM = 4;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Очищаем временное хранилище.
	УдалитьИзВременногоХранилища(АдресФайлаВХранилище);
	
КонецПроцедуры // КомандаЗагрузитьНаСервере()

&НаКлиенте
// Проверяет наличие достаточных данных для начало выполнения процесса поиска информации в базе.
//
Функция СформироватьТекстОшибкиЗаполненияРеквизитовФормы()
	
	ТекстОшибки = "";
	
	Если НЕ ЗначениеЗаполнено(Объект.Период) Тогда
		ТекстОшибки = "Не заполнено значение поля ""Период""!";
	КонецЕсли;
	
	//Если НЕ ЗначениеЗаполнено(Организация) Тогда
	//	ТекстОшибки = ?(Не ПустаяСтрока(ТекстОшибки), ТекстОшибки + Символы.ПС, ТекстОшибки) + "Не заполнено значение поля ""Организация""!";
	//КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(КодОрганизации) Тогда
		ТекстОшибки = ?(Не ПустаяСтрока(ТекстОшибки), ТекстОшибки + Символы.ПС, ТекстОшибки) + "Не заполнено значение поля ""Код организации""!";
	КонецЕсли;
	
	Если Объект.КалининградскаяОбласть_НастройкаУслуг.Количество() = 0 Тогда
		ТекстОшибки = ?(Не ПустаяСтрока(ТекстОшибки), ТекстОшибки + Символы.ПС, ТекстОшибки) + "Не заполнена таблица соответствия услуг!";
	Иначе
		Для Каждого ТекУслуга Из Объект.КалининградскаяОбласть_НастройкаУслуг Цикл
			Если НЕ ЗначениеЗаполнено(ТекУслуга.КодУслугиВОСЗН) Тогда
				ТекстОшибки = ?(Не ПустаяСтрока(ТекстОшибки), ТекстОшибки + Символы.ПС, ТекстОшибки) + "В строке №" + ТекУслуга.НомерСтроки + " не заполнено значение кода услуги в ОСЗН!";
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(ТекУслуга.ВидУслугиВЖКХ) Тогда
				ТекстОшибки = ?(Не ПустаяСтрока(ТекстОшибки), ТекстОшибки + Символы.ПС, ТекстОшибки) + "В строке №" + ТекУслуга.НомерСтроки + " не заполнено значение вида услуги в ЖКХ!";
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Объект.КалининградскаяОбласть_ТаблицаОрганизаций.Количество() = 0 Тогда
		ТекстОшибки = ?(Не ПустаяСтрока(ТекстОшибки), ТекстОшибки + Символы.ПС, ТекстОшибки) + "Не заполнена таблица организаций!";
	Иначе
		Для Каждого ТекОрганизация Из Объект.КалининградскаяОбласть_ТаблицаОрганизаций Цикл
			Если НЕ ЗначениеЗаполнено(ТекОрганизация.Организация) Тогда
				ТекстОшибки = ?(Не ПустаяСтрока(ТекстОшибки), ТекстОшибки + Символы.ПС, ТекстОшибки) + "В строке №" + ТекОрганизация.НомерСтроки + " не заполнено значение Организации!";
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
		
	Возврат ТекстОшибки;
	
КонецФункции // СформироватьТекстОшибкиЗаполненияРеквизитовФормы()

&НаСервере
// Функция предназначена для получения данных о начислениях в отченом периоде.
//
Функция ПолучитьДеревоНачислений(ТаблицаДанныхИзФайла, СписокВидовУслуг, СписокОрганизаций)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаДанныхИзФайла.SCH,
	|	ТаблицаДанныхИзФайла.KOD_ORG,
	|	ТаблицаДанныхИзФайла.N_ORG,
	|	ТаблицаДанныхИзФайла.KLADR,
	|	ТаблицаДанныхИзФайла.RAI,
	|	ТаблицаДанныхИзФайла.Kladr_Name,
	|	ТаблицаДанныхИзФайла.Street_Nam,
	|	ТаблицаДанныхИзФайла.Ndom,
	|	ТаблицаДанныхИзФайла.Nkorp,
	|	ТаблицаДанныхИзФайла.Nkw,
	|	ТаблицаДанныхИзФайла.KOD_USL,
	|	ТаблицаДанныхИзФайла.N_USL,
	|	ТаблицаДанныхИзФайла.Tarif,
	|	ТаблицаДанныхИзФайла.Ras,
	|	ТаблицаДанныхИзФайла.NAC,
	|	ТаблицаДанныхИзФайла.DAT,
	|	ТаблицаДанныхИзФайла.DOLG,
	|	ТаблицаДанныхИзФайла.PRIM,
	|	ТаблицаДанныхИзФайла.Nd,
	|	ТаблицаДанныхИзФайла.Srok,
	|	ТаблицаДанныхИзФайла.Datd
	|ПОМЕСТИТЬ втДанныхИзФайла
	|ИЗ
	|	&ТаблицаДанныхИзФайла КАК ТаблицаДанныхИзФайла
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоответствиеУслуг.ВидУслугиВЖКХ,
	|	СоответствиеУслуг.КодУслугиВОСЗН
	|ПОМЕСТИТЬ втВидовУслуг
	|ИЗ
	|	&ТаблицаВидовУслуг КАК СоответствиеУслуг
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КВП_ЛицевыеСчетаСрезПоследних.Объект КАК Помещение,
	|	КВП_ЛицевыеСчетаСрезПоследних.ЛицевойСчет,
	|	КВП_ЛицевыеСчетаСрезПоследних.ЛицевойСчет.Идентификатор КАК Идентификатор
	|ПОМЕСТИТЬ втОткрытыеЛС
	|ИЗ
	|	РегистрСведений.КВП_ЛицевыеСчета.СрезПоследних(&ДатаКон, ) КАК КВП_ЛицевыеСчетаСрезПоследних
	|ГДЕ
	|	КВП_ЛицевыеСчетаСрезПоследних.Действует
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втОткрытыеЛС.Помещение,
	|	втОткрытыеЛС.ЛицевойСчет,
	|	втДанныхИзФайла.SCH
	|ПОМЕСТИТЬ втНайденныеЛС
	|ИЗ
	|	втДанныхИзФайла КАК втДанныхИзФайла
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втОткрытыеЛС КАК втОткрытыеЛС
	|		ПО втДанныхИзФайла.SCH = втОткрытыеЛС.Идентификатор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанныхИзФайла.SCH,
	|	втДанныхИзФайла.KOD_ORG,
	|	втДанныхИзФайла.N_ORG,
	|	втДанныхИзФайла.KLADR,
	|	втДанныхИзФайла.RAI,
	|	втДанныхИзФайла.Kladr_Name,
	|	втДанныхИзФайла.Street_Nam,
	|	втДанныхИзФайла.Ndom,
	|	втДанныхИзФайла.Nkorp,
	|	втДанныхИзФайла.Nkw,
	|	втДанныхИзФайла.KOD_USL,
	|	втДанныхИзФайла.N_USL,
	|	втДанныхИзФайла.Tarif,
	|	втДанныхИзФайла.Ras,
	|	втДанныхИзФайла.NAC,
	|	втДанныхИзФайла.DAT,
	|	втДанныхИзФайла.DOLG,
	|	втДанныхИзФайла.PRIM,
	|	втДанныхИзФайла.Nd,
	|	втДанныхИзФайла.Srok,
	|	втДанныхИзФайла.Datd,
	|	ВЫБОР
	|		КОГДА НЕ ЕСТЬNULL(втНайденныеЛС.ЛицевойСчет, 0) = 0
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Идентифицирован
	|ПОМЕСТИТЬ втДанныхИзФайла1
	|ИЗ
	|	втДанныхИзФайла КАК втДанныхИзФайла
	|		ЛЕВОЕ СОЕДИНЕНИЕ втНайденныеЛС КАК втНайденныеЛС
	|		ПО втДанныхИзФайла.SCH = втНайденныеЛС.SCH
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ втДанныхИзФайла
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНайденныеЛС.Помещение,
	|	втНайденныеЛС.ЛицевойСчет,
	|	втНайденныеЛС.SCH,
	|	втВидовУслуг.ВидУслугиВЖКХ,
	|	втВидовУслуг.КодУслугиВОСЗН
	|ПОМЕСТИТЬ втЛСсВидамиУслуг
	|ИЗ
	|	втНайденныеЛС КАК втНайденныеЛС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втВидовУслуг КАК втВидовУслуг
	|		ПО (ИСТИНА)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втЛСсВидамиУслуг.Помещение,
	|	втЛСсВидамиУслуг.ЛицевойСчет,
	|	втЛСсВидамиУслуг.SCH,
	|	втЛСсВидамиУслуг.ВидУслугиВЖКХ,
	|	КВП_НазначенныеНачисленияСрезПоследних.Услуга,
	|	втЛСсВидамиУслуг.КодУслугиВОСЗН,
	|	КВП_ВзаиморасчетыПоЛицевымСчетамОстатки.СуммаНачисленияОстаток КАК DOLG
	|ПОМЕСТИТЬ втНазначенныхУслуг
	|ИЗ
	|	втЛСсВидамиУслуг КАК втЛСсВидамиУслуг
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КВП_НазначенныеНачисления.СрезПоследних(
	|				&ДатаКон,
	|				Организация В (&СписокОрганизаций)
	|					И Услуга.ВидУслуги В (&СписокВидовУслуг)) КАК КВП_НазначенныеНачисленияСрезПоследних
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.КВП_ВзаиморасчетыПоЛицевымСчетам.Остатки(
	|					&ДатаНач,
	|					Организация В (&СписокОрганизаций)
	|						И Услуга.ВидУслуги В (&СписокВидовУслуг)) КАК КВП_ВзаиморасчетыПоЛицевымСчетамОстатки
	|			ПО КВП_НазначенныеНачисленияСрезПоследних.Объект = КВП_ВзаиморасчетыПоЛицевымСчетамОстатки.ЛицевойСчет
	|				И КВП_НазначенныеНачисленияСрезПоследних.Услуга = КВП_ВзаиморасчетыПоЛицевымСчетамОстатки.Услуга
	|		ПО втЛСсВидамиУслуг.ЛицевойСчет = КВП_НазначенныеНачисленияСрезПоследних.Объект
	|			И втЛСсВидамиУслуг.ВидУслугиВЖКХ = КВП_НазначенныеНачисленияСрезПоследних.Услуга.ВидУслуги
	|ГДЕ
	|	КВП_НазначенныеНачисленияСрезПоследних.Действует
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНазначенныхУслуг.Помещение,
	|	втНазначенныхУслуг.ЛицевойСчет,
	|	втНазначенныхУслуг.SCH,
	|	втНазначенныхУслуг.ВидУслугиВЖКХ,
	|	МАКСИМУМ(ЕСТЬNULL(УПЖКХ_НачисленияОбороты.Тариф, 0)) КАК Тариф,
	|	СУММА(ЕСТЬNULL(УПЖКХ_НачисленияОбороты.Количество, 0)) КАК ОбъемПотребления,
	|	СУММА(ЕСТЬNULL(УПЖКХ_НачисленияОбороты.СуммаНачисленияОборот, 0)) КАК Начислено,
	|	втНазначенныхУслуг.КодУслугиВОСЗН,
	|	СУММА(втНазначенныхУслуг.DOLG) КАК DOLG
	|ПОМЕСТИТЬ втНачислений
	|ИЗ
	|	втНазначенныхУслуг КАК втНазначенныхУслуг
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.УПЖКХ_Начисления.Обороты(
	|				&ДатаНач,
	|				&ДатаКон,
	|				Месяц,
	|				Организация В (&СписокОрганизаций)
	|					И ВидНачисления В (ЗНАЧЕНИЕ(Перечисление.УПЖКХ_ВидыНачислений.Начисление), ЗНАЧЕНИЕ(Перечисление.УПЖКХ_ВидыНачислений.НачислениеПоИПУ), ЗНАЧЕНИЕ(Перечисление.УПЖКХ_ВидыНачислений.НачислениеПриОтсутствииПоказанийИПУПоНормативу), ЗНАЧЕНИЕ(Перечисление.УПЖКХ_ВидыНачислений.НачислениеПриОтсутствииДействующегоИПУПоНормативу), ЗНАЧЕНИЕ(Перечисление.УПЖКХ_ВидыНачислений.НачислениеПриОтсутствииДействующегоИПУПоНормативуЗаСчетПовышающегоКоэффициента), ЗНАЧЕНИЕ(Перечисление.УПЖКХ_ВидыНачислений.НачислениеПриОтсутствииПоказанийИПУПоСреднему), ЗНАЧЕНИЕ(Перечисление.УПЖКХ_ВидыНачислений.НачислениеПриОтсутствииДействующегоИПУПоСреднему), ЗНАЧЕНИЕ(Перечисление.УПЖКХ_ВидыНачислений.НачислениеПоОПУ))
	|					И РазделУчета В (ЗНАЧЕНИЕ(Перечисление.УПЖКХ_РазделыУчета.НачислениеУслуг), ЗНАЧЕНИЕ(Перечисление.УПЖКХ_РазделыУчета.НачислениеПоПУ))
	|					И Услуга.ВидУслуги В (&СписокВидовУслуг)) КАК УПЖКХ_НачисленияОбороты
	|		ПО втНазначенныхУслуг.ЛицевойСчет = УПЖКХ_НачисленияОбороты.ЛицевойСчет
	|			И втНазначенныхУслуг.Услуга = УПЖКХ_НачисленияОбороты.Услуга
	|
	|СГРУППИРОВАТЬ ПО
	|	втНазначенныхУслуг.ЛицевойСчет,
	|	втНазначенныхУслуг.SCH,
	|	втНазначенныхУслуг.Помещение,
	|	втНазначенныхУслуг.ВидУслугиВЖКХ,
	|	втНазначенныхУслуг.КодУслугиВОСЗН
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанныхИзФайла1.SCH КАК SCH,
	|	втДанныхИзФайла1.KLADR,
	|	втДанныхИзФайла1.RAI,
	|	втДанныхИзФайла1.Kladr_Name,
	|	втДанныхИзФайла1.Street_Nam,
	|	втДанныхИзФайла1.Ndom,
	|	втДанныхИзФайла1.Nkorp,
	|	втДанныхИзФайла1.Nkw,
	|	ЕСТЬNULL(втНачислений.Тариф, втДанныхИзФайла1.Tarif) КАК Tarif,
	|	ЕСТЬNULL(втНачислений.ОбъемПотребления, втДанныхИзФайла1.Ras) КАК Ras,
	|	ЕСТЬNULL(втНачислений.Начислено, втДанныхИзФайла1.NAC) КАК NAC,
	|	втДанныхИзФайла1.Nd,
	|	втДанныхИзФайла1.Srok,
	|	втДанныхИзФайла1.Datd,
	|	ЕСТЬNULL(втНачислений.ВидУслугиВЖКХ, """") КАК N_USL,
	|	втДанныхИзФайла1.Идентифицирован,
	|	втНачислений.КодУслугиВОСЗН КАК KOD_USL,
	|	втНачислений.DOLG
	|ИЗ
	|	втДанныхИзФайла1 КАК втДанныхИзФайла1
	|		ЛЕВОЕ СОЕДИНЕНИЕ втНачислений КАК втНачислений
	|		ПО втДанныхИзФайла1.SCH = втНачислений.SCH
	|
	|УПОРЯДОЧИТЬ ПО
	|	SCH,
	|	N_USL
	|ИТОГИ ПО
	|	SCH,
	|	втНачислений.ВидУслугиВЖКХ";
	
	Запрос.УстановитьПараметр("ДатаНач",              НачалоМесяца(Объект.Период));
	Запрос.УстановитьПараметр("ДатаКон",              КонецМесяца(Объект.Период));
	Запрос.УстановитьПараметр("СписокОрганизаций",    СписокОрганизаций);
	Запрос.УстановитьПараметр("СписокВидовУслуг",     СписокВидовУслуг);
	Запрос.УстановитьПараметр("ТаблицаДанныхИзФайла", ТаблицаДанныхИзФайла);
	Запрос.УстановитьПараметр("ТаблицаВидовУслуг",    Объект.КалининградскаяОбласть_НастройкаУслуг.Выгрузить());
	
	Результат = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Возврат Результат;
	
КонецФункции // ПолучитьТаблицуНачислений()

&НаСервере
// Функция предназначена для получения списка  видов услуг, 
// по которым будет произведен начислений в отчетном периоде по отчетным лицевым счетам.
Функция ПодготовитьСписокВидовУслугНачислений()
	
	врМассив = Объект.КалининградскаяОбласть_НастройкаУслуг.Выгрузить().ВыгрузитьКолонку("ВидУслугиВЖКХ");
	
	СписокУслуг = Новый СписокЗначений;
	СписокУслуг.ЗагрузитьЗначения(врМассив);
	
	Возврат СписокУслуг;
	
КонецФункции // ПодготовитьСписокУслугНачислений()

&НаСервере
// Функция предназначена для получения списка организаций,
// по которым будет произведены поиск данных о начислениях.
Функция ПодготовитьСписокОрганизаций()
	
	врМассив = Объект.КалининградскаяОбласть_ТаблицаОрганизаций.Выгрузить().ВыгрузитьКолонку("Организация");
	
	СписокОрганизаций = Новый СписокЗначений;
	СписокОрганизаций.ЗагрузитьЗначения(врМассив);
	
	Возврат СписокОрганизаций;
	
КонецФункции // ПодготовитьСписокОрганизаций()

#КонецОбласти

#Область КомандаВыгрузить

&НаКлиенте
// Обработчик команды "КомандаВыгрузить".
//
Процедура КомандаВыгрузить(Команда)
	
	Если Объект.КалининградскаяОбласть_ТаблицаВыгрузки.Количество() = 0 Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("Таблица не заполнена!");
		Возврат;
	КонецЕсли;
	
	ФайлДляСохранения = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	
	ФайлДляСохранения.Заголовок                   = "Сохранение файла";
	ФайлДляСохранения.ПроверятьСуществованиеФайла = Истина;
	ФайлДляСохранения.ПолноеИмяФайла              = "";
	ФайлДляСохранения.Фильтр                      = "Файл данных (*.dbf)|*.dbf";
	ФайлДляСохранения.Расширение                  = "dbf";
	
	ФайлДляСохранения.Показать(Новый ОписаниеОповещения("КомандаВыгрузитьЗавершение", ЭтотОбъект, Новый Структура("ФайлДляСохранения", ФайлДляСохранения)));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыгрузитьЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	ФайлДляСохранения = ДополнительныеПараметры.ФайлДляСохранения;
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПолноеИмяФайла = ФайлДляСохранения.ПолноеИмяФайла;
	
	Если ПустаяСтрока(ПолноеИмяФайла) Тогда
		Возврат;
	КонецЕсли;
	
	АдресФайлаВыгрузки = ЗаполнитьПолучитьАдресФайлаВыгрузки(УникальныйИдентификатор);
	
	//ФайлДляСохранения.ПолноеИмяФайла
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаВыгрузитьЗавершениеФрагмент", ЭтаФорма, Новый Структура("ПолноеИмяФайла", ПолноеИмяФайла));
	
	ПолучаемыеФайлы = Новый Массив;
	ПолучаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(, АдресФайлаВыгрузки));
	
	НачатьПолучениеФайлов(ОписаниеОповещения, ПолучаемыеФайлы, ФайлДляСохранения.ПолноеИмяФайла, Ложь);
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю("Выгрузка в файл """ + ФайлДляСохранения.ПолноеИмяФайла + """ завершена!");

КонецПроцедуры // КомандаВыгрузить()

&НаКлиенте
Процедура КомандаВыгрузитьЗавершениеФрагмент(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьПолучитьАдресФайлаВыгрузки(АдресХранилища)
	
	ФайлВыгрузки = Новый XBase;
	ФайлВыгрузки.Кодировка = КодировкаXBase.OEM;
	ФайлВыгрузки.Поля.Добавить("SCH",        "S", "20");
	ФайлВыгрузки.Поля.Добавить("KOD_ORG",    "N", "5");
	ФайлВыгрузки.Поля.Добавить("N_ORG",      "S", "20");
	ФайлВыгрузки.Поля.Добавить("KLADR",      "S", "20");
	ФайлВыгрузки.Поля.Добавить("RAI",        "S", "2");
	ФайлВыгрузки.Поля.Добавить("Kladr_Name", "S", "30");
	ФайлВыгрузки.Поля.Добавить("Street_Nam", "S", "40");
	ФайлВыгрузки.Поля.Добавить("Ndom",       "S", "10");
	ФайлВыгрузки.Поля.Добавить("Nkorp",      "S", "3");
	ФайлВыгрузки.Поля.Добавить("Nkw",        "S", "5");
	ФайлВыгрузки.Поля.Добавить("KOD_USL",    "S", "5");
	ФайлВыгрузки.Поля.Добавить("N_USL",      "S", "50");
	ФайлВыгрузки.Поля.Добавить("Tarif",      "N", "10", "2");
	ФайлВыгрузки.Поля.Добавить("Ras",        "N", "10", "2");
	ФайлВыгрузки.Поля.Добавить("NAC",        "N", "10", "2");
	ФайлВыгрузки.Поля.Добавить("DAT",        "S", "10");
	ФайлВыгрузки.Поля.Добавить("DOLG",       "N", "10", "2");
	ФайлВыгрузки.Поля.Добавить("PRIM",       "N", "2");
	ФайлВыгрузки.Поля.Добавить("Nd",         "S", "20");
	ФайлВыгрузки.Поля.Добавить("Srok",       "N", "2");
	ФайлВыгрузки.Поля.Добавить("Datd",       "D");
	
	ИмяФайла = ПолучитьИмяВременногоФайла(".dbf");
	
	Файл = Новый Файл(ИмяФайла);
	
	ИмяФайла = Файл.Путь + Прав(Файл.Имя, 11);
	
	ФайлВыгрузки.СоздатьФайл(ИмяФайла);
	ФайлВыгрузки.АвтоСохранение = Истина;
	
	// Запись данных из табличной части в файл выгрузки.
	Для Каждого Строка Из Объект.КалининградскаяОбласть_ТаблицаВыгрузки Цикл
		ФайлВыгрузки.Добавить();
		ЗаполнитьЗначенияСвойств(ФайлВыгрузки, Строка);
	КонецЦикла;
	
	ФайлВыгрузки.ЗакрытьФайл();
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
	
	Возврат ПоместитьВоВременноеХранилище(ДвоичныеДанные, АдресХранилища);
	
КонецФункции

#КонецОбласти



















