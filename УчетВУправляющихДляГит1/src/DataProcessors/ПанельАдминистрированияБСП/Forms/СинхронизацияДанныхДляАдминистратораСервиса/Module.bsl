&НаКлиенте
Перем ОбновитьИнтерфейс;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(Неопределено, Истина, Ложь) Тогда
		ВызватьИсключение НСтр("ru = 'Нет прав на администрирование обменов данными.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Настройки видимости при запуске
	Элементы.АвтономнаяРабота.Видимость = АвтономнаяРаботаСлужебный.АвтономнаяРаботаПоддерживается();
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура МониторСинхронизацииДанных(Команда)
	
	ОткрытьФорму("ОбщаяФорма.МониторСинхронизацииДанныхВМоделиСервиса",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиТранспортаОбмена(Команда)
	
	ОткрытьФорму("РегистрСведений.УдалитьНастройкиТранспортаОбмена.ФормаСписка",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиТранспортаОбменаОбластейДанных(Команда)
	
	ОткрытьФорму("РегистрСведений.НастройкиТранспортаОбменаОбластейДанных.ФормаСписка",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаДляОбменаДанными(Команда)
	
	ОткрытьФорму("РегистрСведений.ПравилаДляОбменаДанными.ФормаСписка",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСинхронизациюДанныхПриИзменении(Элемент)
	
	Если НаборКонстант.ИспользоватьСинхронизациюДанных = Ложь Тогда
		НаборКонстант.ИспользоватьАвтономнуюРаботуВМоделиСервиса = Ложь;
		НаборКонстант.ИспользоватьСинхронизациюДанныхВМоделиСервисаСЛокальнойПрограммой = Ложь;
		НаборКонстант.ИспользоватьСинхронизациюДанныхВМоделиСервисаСПриложениемВИнтернете = Ложь;
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАвтономнуюРаботуВМоделиСервисаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСинхронизациюДанныхВМоделиСервисаСПриложениемВИнтернетеПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСинхронизациюДанныхВМоделиСервисаСЛокальнойПрограммойПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтаФорма, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		СтандартныеПодсистемыКлиентСервер.РезультатВыполненияДобавитьОповещениеОткрытыхФорм(Результат, "Запись_НаборКонстант", Новый Структура, КонстантаИмя);
		// СтандартныеПодсистемы.ВариантыОтчетов
		ВариантыОтчетов.ДобавитьОповещениеПриИзмененииЗначенияКонстанты(Результат, КонстантаМенеджер);
		// Конец СтандартныеПодсистемы.ВариантыОтчетов
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСинхронизациюДанных" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.СинхронизацияДанныхПодчиненнаяГруппировка.Доступность           = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.ГруппаСинхронизацияДанныхМониторСинхронизацииДанных.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
	КонецЕсли;
	
КонецПроцедуры
