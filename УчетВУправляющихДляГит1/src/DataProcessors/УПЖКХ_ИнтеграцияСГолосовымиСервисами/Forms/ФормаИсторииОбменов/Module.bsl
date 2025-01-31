
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Обработчик события "ПриАктивизацииСтроки" элемента "ТаблицаЖурналаОбмена".
//
Процедура ТаблицаЖурналаОбменаПриАктивизацииСтроки(Элемент)
	
	// Обработчик используется только в режиме отладки.
	
	ИспользуетсяРежимОтладки = УПЖКХ_ВебИнтеграцияВзаимодействиеСБазойДанных.ИспользуетсяРежимОтладки();
	
	Если ИспользуетсяРежимОтладки Тогда
		
		ТекущийВидОбмена = Элемент.ТекущиеДанные.ВидОбмена;
		
		Если ВидОбменаЯвляетсяВыгрузкойНаСервис(ТекущийВидОбмена) Тогда
			
			Элементы.КнопкаОтладкаОтправитьФайлПовторно.Видимость = Истина;
			Элементы.КнопкаОтладкаЗагрузитьФайлПовторно.Видимость = Ложь;
			
		Иначе
			
			Элементы.КнопкаОтладкаОтправитьФайлПовторно.Видимость = Ложь;
			Элементы.КнопкаОтладкаЗагрузитьФайлПовторно.Видимость = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД

#Область ОбработчикиКоманд

&НаКлиенте
// Обновляет журнал обмена.
//
Процедура КомандаОбновитьЖурналОбмена(Команда)
	
	Элементы.ТаблицаЖурналаОбмена.Обновить();
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИОНАЛ ОТЛАДКИ

#Область КомандыОтладки

&НаКлиенте
// Процедура - обработчик команды "КомандаОтладкаОтправитьФайлПовторно".
//
Процедура КомандаОтладкаОтправитьФайлПовторно(Команда)
	
	НачатьЗамерВремениВыполнения();
	ВыполнитьПовторнуюОтправкуФайлаНаСайт(ПолучитьСтруктуруОтбораТекущейЗаписиЖурналаОбмена());
	ОстановитьЗамерВремениВыполнения();
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик команды "КомандаОтладкаЗагрузитьФайлПовторно".
//
Процедура КомандаОтладкаЗагрузитьФайлПовторно(Команда)
	
	НачатьЗамерВремениВыполнения();
	ВыполнитьПовторнуюЗагрузкуФайлаВБазу(ПолучитьСтруктуруОтбораТекущейЗаписиЖурналаОбмена());
	ОстановитьЗамерВремениВыполнения();
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииПовторногоИспользованияФайловОбмена

&НаСервере
// Выполняет повторную отправку файла на сервис.
//
Процедура ВыполнитьПовторнуюОтправкуФайлаНаСайт(СтруктураОтбора)
	
	УПЖКХ_ИнтеграцияСГолосовымиСервисамиВзаимодействиеССервером.ОбменСГолосовымиСервисами(Перечисления.УПЖКХ_ВидыОбменаСГолосовымиСервисами.ПовторнаяВыгрузкаДанных, СтруктураОтбора);
	
КонецПроцедуры

&НаСервере
// Выполняет повторную загрузку сохраненного файла в базу.
//
Процедура ВыполнитьПовторнуюЗагрузкуФайлаВБазу(СтруктураОтбора)
	
	УПЖКХ_ИнтеграцияСГолосовымиСервисамиВзаимодействиеССервером.ОбменСГолосовымиСервисами(Перечисления.УПЖКХ_ВидыОбменаСГолосовымиСервисами.ПовторнаяЗагрузкаПоказанийИзФайла, СтруктураОтбора);
	
КонецПроцедуры

&НаКлиенте
// Формирует структуру отбора записи из журнала обмена.
//
Функция ПолучитьСтруктуруОтбораТекущейЗаписиЖурналаОбмена()
	
	СтруктураОтбора = Новый Структура("ДатаОбмена, ВидОбмена");
	
	ТекущаяСтрокаЖурнала = Элементы.ТаблицаЖурналаОбмена.ТекущиеДанные;
	ЗаполнитьЗначенияСвойств(СтруктураОтбора, ТекущаяСтрокаЖурнала);
	
	Возврат СтруктураОтбора;
	
КонецФункции

&НаСервере
// Определяет, является ли указанный вид обмена данными с сайтом выгрузкой данных на сайт.
//
Функция ВидОбменаЯвляетсяВыгрузкойНаСервис(ТекущийВидОбмена)
	
	Возврат ТекущийВидОбмена = Перечисления.УПЖКХ_ВидыОбменаСГолосовымиСервисами.ПовторнаяВыгрузкаДанных
		ИЛИ ТекущийВидОбмена = Перечисления.УПЖКХ_ВидыОбменаСГолосовымиСервисами.ВыгрузкаДанных;
	
КонецФункции

#КонецОбласти

#Область ФунцкионалЗамераВремениВыполнения

&НаКлиенте
// Запускает замер времени выполнения.
//
Процедура НачатьЗамерВремениВыполнения()
	
	УПЖКХ_МногопоточнаяОбработкаДанных.НачатьЗамерВремениВыполнения(ЗамерыВремениВыполнения_Таймер);
	
КонецПроцедуры

&НаКлиенте
// Завершает замер времени выполнения.
//
Процедура ОстановитьЗамерВремениВыполнения()
	
	УПЖКХ_МногопоточнаяОбработкаДанных.ОстановитьЗамерВремениВыполнения(ЗамерыВремениВыполнения_Таймер);
	
КонецПроцедуры

#КонецОбласти
