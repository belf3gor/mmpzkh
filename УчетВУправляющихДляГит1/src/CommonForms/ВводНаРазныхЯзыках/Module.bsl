///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбъектМетаданных = Параметры.Ссылка.Метаданные();
	Реквизит = ОбъектМетаданных.Реквизиты.Найти(Параметры.ИмяРеквизита);
	Если Реквизит = Неопределено Тогда
		Для каждого СтандартныйРеквизит Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
			Если СтрСравнить(СтандартныйРеквизит.Имя, Параметры.ИмяРеквизита) = 0 Тогда
				Реквизит = СтандартныйРеквизит;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Реквизит = Неопределено Тогда
		ШаблонОшибки = НСтр("ru='При открытии формы ВводНаРазныхЯзыках в параметре ИмяРеквизита указан не существующий реквизит %1'");
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки, Параметры.ИмяРеквизита);
	КонецЕсли;
	
	Если Реквизит.МногострочныйРежим Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "МногострочныйРежим");
	КонецЕсли;
	
	Для Каждого ЯзыкКонфигурации Из Метаданные.Языки Цикл
		НоваяСтрока = Языки.Добавить();
		НоваяСтрока.КодЯзыка = ЯзыкКонфигурации.КодЯзыка;
		НоваяСтрока.Имя = "_" + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
		НоваяСтрока.Представление = ЯзыкКонфигурации.Представление();
	КонецЦикла;
	
	СформироватьПоляВводаНаРазныхЯзыках(Реквизит.МногострочныйРежим, Параметры.ТолькоПросмотр);
	
	Если Не ПустаяСтрока(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
	Иначе
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 на разных языках'"), Реквизит.Представление());
	КонецЕсли;
	
	ОсновнойЯзык = Метаданные.ОсновнойЯзык.КодЯзыка;
	
	ОписаниеЯзыка = ОписаниеЯзыка(ТекущийЯзык().КодЯзыка);
	Если ОписаниеЯзыка <> Неопределено Тогда
		ЭтотОбъект[ОписаниеЯзыка.Имя] = Параметры.ТекущиеЗначение;
	КонецЕсли;
	
	Для каждого Представление Из Параметры.Представления Цикл
		
		ОписаниеЯзыка = ОписаниеЯзыка(Представление.КодЯзыка);
		Если ОписаниеЯзыка <> Неопределено Тогда
			Если СтрСравнить(ОписаниеЯзыка.КодЯзыка, ТекущийЯзык().КодЯзыка) = 0 Тогда
				ЭтотОбъект[ОписаниеЯзыка.Имя] = ?(ЗначениеЗаполнено(Параметры.ТекущиеЗначение), Параметры.ТекущиеЗначение, Представление[Параметры.ИмяРеквизита]);
			Иначе
				ЭтотОбъект[ОписаниеЯзыка.Имя] = Представление[Параметры.ИмяРеквизита];
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Результат = Новый Структура("ОсновнойЯзык", ОсновнойЯзык);
	Результат.Вставить("ЗначенияНаРазныхЯзыках", Новый Массив);
	Для каждого Язык Из Языки Цикл
		
		Если Язык.КодЯзыка = ТекущийЯзык() Тогда
			Результат.Вставить("СтрокаНаТекущемЯзыке", ЭтотОбъект[Язык.Имя]);
		КонецЕсли;
		
		Если ТекущийЯзык() = ОсновнойЯзык И Язык.КодЯзыка = ОсновнойЯзык Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.ЗначенияНаРазныхЯзыках.Добавить(Новый Структура("КодЯзыка, ЗначениеРеквизита", Язык.КодЯзыка, ЭтотОбъект[Язык.Имя]));
	КонецЦикла;
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьПоляВводаНаРазныхЯзыках(МногострочныйРежим, ТолькоПросмотр)
	
	Добавлять = Новый Массив;
	ТипСтрока = Новый ОписаниеТипов("Строка");
	Для Каждого ЯзыкКонфигурации Из Языки Цикл
		Добавлять.Добавить(Новый РеквизитФормы(ЯзыкКонфигурации.Имя, ТипСтрока,, ЯзыкКонфигурации.Представление));
	КонецЦикла;
	
	ИзменитьРеквизиты(Добавлять);
	РодительЭлементов = Элементы.ГруппаЯзыки;
	
	Для Каждого ЯзыкКонфигурации Из Языки Цикл
		
		Если СтрСравнить(ЯзыкКонфигурации.КодЯзыка, ТекущийЯзык().КодЯзыка) = 0 И РодительЭлементов.ПодчиненныеЭлементы.Количество() > 0 Тогда
			Элемент = Элементы.Вставить(ЯзыкКонфигурации.Имя, Тип("ПолеФормы"), РодительЭлементов, РодительЭлементов.ПодчиненныеЭлементы.Получить(0));
			ТекущийЭлемент = Элемент;
		Иначе
			Элемент = Элементы.Добавить(ЯзыкКонфигурации.Имя, Тип("ПолеФормы"), РодительЭлементов);
		КонецЕсли;
		
		Элемент.ПутьКДанным        = ЯзыкКонфигурации.Имя;
		Элемент.Вид                = ВидПоляФормы.ПолеВвода;
		Элемент.Ширина             = 40;
		Элемент.МногострочныйРежим = МногострочныйРежим;
		Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элемент.ТолькоПросмотр     = ТолькоПросмотр;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ОписаниеЯзыка(КодЯзыка)
	
	Отбор = Новый Структура("КодЯзыка", КодЯзыка);
	НайденныеЭлементы = Языки.НайтиСтроки(Отбор);
	Если НайденныеЭлементы.Количество() > 0 Тогда
		Возврат НайденныеЭлементы[0];
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции


#КонецОбласти