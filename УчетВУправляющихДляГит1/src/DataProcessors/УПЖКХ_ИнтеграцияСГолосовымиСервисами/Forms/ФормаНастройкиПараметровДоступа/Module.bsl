
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик "ПриСозданииНаСервере" формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры) = Тип("ДанныеФормыСтруктура")
	   И Параметры.Свойство("ПерсональныйURL")
	   И Параметры.Свойство("Логин")
	   И Параметры.Свойство("Пароль")
	   И Параметры.Свойство("АвтономныйРежимРаботы") Тогда
		ПерсональныйURL       = Параметры.ПерсональныйURL;
		Логин                 = Параметры.Логин;
		Пароль                = Параметры.Пароль;
		АвтономныйРежимРаботы = Параметры.АвтономныйРежимРаботы;
		
		Элементы.ГруппаЭлементыГоризонтальная.Видимость = НЕ ИспользуетсяАвтономныйРежимРаботы();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

#Область ОбработчикиКомандЭлементовФормы

&НаКлиенте
// Обработчик нажатия кнопки "СохранитьИЗакрыть".
//
Процедура КомандаСохранитьИЗакрыть(Команда)
	
	Если ИспользуетсяАвтономныйРежимРаботы() Тогда
		СохранитьНастройки();
		
		Закрыть();
	Иначе
		ЗапуститьФоновоеЗаданиеПроверкиПараметровДоступа();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Обработчик события "ПриИзменении" поля "ПерсональныйURL".
//
Процедура ПерсональныйURLПриИзменении(Элемент)
	
	ПараметрыДоступаМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" поля "Логин".
//
Процедура ЛогинПриИзменении(Элемент)
	
	ПараметрыДоступаМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" поля "Пароль".
//
Процедура ПарольПриИзменении(Элемент)
	
	ПараметрыДоступаМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" поля "АвтономныйРежимРаботы".
//
Процедура АвтономныйРежимРаботыПриИзменении(Элемент)
	
	ПараметрыДоступаМодифицированы = Истина;
	
	Элементы.ГруппаЭлементыГоризонтальная.Видимость = НЕ ИспользуетсяАвтономныйРежимРаботы();
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБРАБОТКИ ПАРАМЕТРОВ ДОСТУПА

#Область ПроцедурыИФункцииОбработкиПараметровДоступа

&НаСервере
// Сохраняет параметры доступа.
//
Процедура СохранитьНастройки()
	
	СтруктураНастроек = УПЖКХ_ИнтеграцияСГолосовымиСервисамиВзаимодействиеСБазойДанных.ПолучитьНастройкиИнтеграцииСГолосовымиСервисами();
	
	СтруктураНастроек.ПерсональныйURL = ПерсональныйURL;
	СтруктураНастроек.Логин           = Логин;
	СтруктураНастроек.Пароль          = Пароль;
	СтруктураНастроек.АвтономныйРежимРаботы = ИспользуетсяАвтономныйРежимРаботы();
	
	УПЖКХ_ИнтеграцияСГолосовымиСервисамиВзаимодействиеСБазойДанных.УстановитьНастройкиИнтеграцииCГолосовымиСервисами(СтруктураНастроек);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПРОВЕРКИ ПАРАМЕТРОВ ДОСТУПА

#Область ПроцедурыИФункцииСбораСтатистикиВФоновомРежиме

&НаСервере
// Выполняет проверку использования автономного режима работы.
//
Функция ИспользуетсяАвтономныйРежимРаботы()
	
	Возврат АвтономныйРежимРаботы = 1;
	
КонецФункции

&НаКлиенте
// Управляет запуском фонового задания проверки параметров доступа.
//
Процедура ЗапуститьФоновоеЗаданиеПроверкиПараметровДоступа()
	
	Если ПараметрыДоступаМодифицированы Тогда
		
		// Запускаем сбор статистики с сервиса.
		ЗапуститьФоновоеЗаданиеПроверкиПараметровДоступаНаСервере();
		
		// Запускаем обработчи ожидания, проверяющий результат фонового задания.
		ЭтаФорма.ПодключитьОбработчикОжидания("ПроверитьСостояниеПроверкиПараметровДоступа", 2);
		
		// Делаем недоступной кнопку сохранения и показываем анимацию ожидания.
		Элементы.ГруппаПроверкаВФоне.Видимость       = ВыполняетсяПроверкаПараметровДоступа;
		Элементы.КнопкаСохранитьИЗакрыть.Доступность = НЕ ВыполняетсяПроверкаПараметровДоступа;
		
	Иначе
		
		СохранитьНастройки();
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Запускает фоновое задание на сервере.
//
Процедура ЗапуститьФоновоеЗаданиеПроверкиПараметровДоступаНаСервере()
	
	// Подготавливаем адрес временного хранилища, куда будут переданы полученные результаты фонового задания.
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(Неопределено, ЭтаФорма.УникальныйИдентификатор);
	
	// Подготавливаем параметры фонового задания.
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(ПерсональныйURL);
	ПараметрыЗадания.Добавить(Логин);
	ПараметрыЗадания.Добавить(Пароль);
	ПараметрыЗадания.Добавить(Объект.СообщенияДляПользователя.Выгрузить());
	ПараметрыЗадания.Добавить(АдресВременногоХранилища);
	
	// Запускаем фоновое задание.
	ИдентификаторФоновогоЗаданияПроверкиПараметровДоступа = Новый УникальныйИдентификатор;
	
	ВыполнитьФоновоеЗаданиеПроверкиПараметровДоступаНаСервере(ПараметрыЗадания, ИдентификаторФоновогоЗаданияПроверкиПараметровДоступа);
	
КонецПроцедуры

&НаСервере
// Запускает фоновое задание, выполняющее сбор статистики с сервиса.
//
Процедура ВыполнитьФоновоеЗаданиеПроверкиПараметровДоступаНаСервере(ПараметрыЗадания, ИдентификаторЗадания)
	
	Если НЕ ВыполняетсяПроверкаПараметровДоступа Тогда
		
		ВыполняетсяПроверкаПараметровДоступа = Истина;
		
		ФоновыеЗадания.Выполнить("УПЖКХ_ИнтеграцияСГолосовымиСервисамиВзаимодействиеССервером.ПроверитьКорректностьПараметровДоступаВФоновомЗадании", ПараметрыЗадания, ИдентификаторЗадания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Проверка и расшифровка ответа, пришедшего с сервиса на запрос статистики.
//
Процедура ПроверитьСостояниеПроверкиПараметровДоступа()
	
	СтруктураРезультатаПроверкиПараметровДоступа = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	Если НЕ СтруктураРезультатаПроверкиПараметровДоступа = Неопределено Тогда
		
		ВыполненоУспешно = СтруктураРезультатаПроверкиПараметровДоступа.ВыполненоУспешно;
		
		ВыполняетсяПроверкаПараметровДоступа = Ложь;
		
		ЭтаФорма.ОтключитьОбработчикОжидания("ПроверитьСостояниеПроверкиПараметровДоступа");
		
		Если ВыполненоУспешно Тогда
			
			СохранитьНастройки();
			
			Закрыть();
			
		Иначе
			
			Элементы.ГруппаПроверкаВФоне.Видимость       = ВыполняетсяПроверкаПараметровДоступа;
			Элементы.КнопкаСохранитьИЗакрыть.Доступность = НЕ ВыполняетсяПроверкаПараметровДоступа;
			
			НовоеСообщение = Объект.СообщенияДляПользователя.Добавить();
			НовоеСообщение.ВидСообщения = ПредопределенноеЗначение("Перечисление.УПЖКХ_ВидыСообщений.СообщениеОбОшибке");
			НовоеСообщение.ТекстСообщения = "Не удалось выполнить пробное подключение с использованием указанных параметров доступа.
											|Пожалуйста, убедитесь, что указаны корректные параметры доступа.";
			
			УПЖКХ_РаботаССообщениямиКлиент.ВывестиСообщения(Объект.СообщенияДляПользователя);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
