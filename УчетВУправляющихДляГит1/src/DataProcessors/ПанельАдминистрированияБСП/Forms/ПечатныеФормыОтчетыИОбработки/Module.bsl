///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Настройки видимости при запуске.
	Элементы.Расширения.Видимость = Не СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
		Элементы.ИспользоватьДополнительныеОтчетыИОбработки.Видимость = Не РазделениеВключено;
		Элементы.ОткрытьДополнительныеОтчетыИОбработки.Видимость      = Не РазделениеВключено
			// При работе в модели сервиса, если включено администратором сервиса.
			Или НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки;
	Иначе
		Элементы.ГруппаДополнительныеОтчетыИОбработки.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РассылкаОтчетов") Тогда
		МодульРассылкаОтчетов = ОбщегоНазначения.ОбщийМодуль("РассылкаОтчетов");
		Элементы.ОткрытьРассылкиОтчетов.Видимость = МодульРассылкаОтчетов.ПравоДобавления();
	Иначе
		Элементы.ГруппаРассылкиОтчетов.Видимость = Ложь;
	КонецЕсли;
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
	НастройкиПрограммыПереопределяемый.ПечатныеФормыОтчетыИОбработкиПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьДополнительныеОтчетыИОбработкиПриИзменении(Элемент)
	
	СтароеЗначение = НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки;
	
	Попытка
		
		Обработчик = Новый ОписаниеОповещения("ИспользоватьДополнительныеОтчетыИОбработкиПриИзмененииЗавершение", ЭтотОбъект, Элемент);
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
			ЗапросыНаИспользованиеВнешнихРесурсов = ЗапросыНаИспользованиеВнешнихРесурсовДополнительныхОтчетовИОбработок(СтароеЗначение);
			МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
			МодульРаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(ЗапросыНаИспользованиеВнешнихРесурсов, ЭтотОбъект, Обработчик);
		Иначе
			ВыполнитьОбработкуОповещения(Обработчик, КодВозвратаДиалога.ОК);
		КонецЕсли;
		
	Исключение
		
		НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки = СтароеЗначение;
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
	Если ЧастиИмени.Количество() <> 2 Тогда
		Возврат "";
	КонецЕсли;
	
	КонстантаИмя = ЧастиИмени[1];
	КонстантаМенеджер = Константы[КонстантаИмя];
	КонстантаЗначение = НаборКонстант[КонстантаИмя];
	
	Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
		КонстантаМенеджер.Установить(КонстантаЗначение);
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки" ИЛИ РеквизитПутьКДанным = ""
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		Элементы.ОткрытьДополнительныеОтчетыИОбработки.Доступность = НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапросыНаИспользованиеВнешнихРесурсовДополнительныхОтчетовИОбработок(Включение)
	
	МодульДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный = ОбщегоНазначения.ОбщийМодуль(
		"ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный");
	Возврат МодульДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ЗапросыРазрешенийДополнительныхОбработок(Включение);
	
КонецФункции

&НаКлиенте
Процедура ИспользоватьДополнительныеОтчетыИОбработкиПриИзмененииЗавершение(Ответ, Элемент) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.ОК Тогда
		НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки = Не НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки;
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
