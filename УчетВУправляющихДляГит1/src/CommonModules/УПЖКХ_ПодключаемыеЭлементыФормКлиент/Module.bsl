
////////////////////////////////////////////////////////////////////////////////
// ГИПЕРССЫЛКА С СУММОЙ ЗАДОЛЖЕННОСТИ ПО Л/С

#Область ГиперссылкаССуммойЗадолженностиПоЛС

// Процедура открывает отчет КВП_КарточкаРасчетов.
//
Процедура ЗадолженностьОбработкаНавигационнойСсылки(СтруктураОткрытия) Экспорт
	
	ОткрытьФорму("Отчет.КВП_КарточкаРасчетов.Форма.ФормаОтчета", СтруктураОткрытия,, Ложь);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ГИПЕРССЫЛКА НАСТРОЕК УПРОЩЕННОЙ АДС

#Область ГиперссылкаНастроекУпрощеннойАДС

// Настройки упрощенной АДСОбработка навигационной ссылки
//
// Параметры:
//  Элемент				 - ЭлементФормы	 - Элемент формы
//  НавигационнаяСсылка	 - Строка		 - Содержимое ссылки
//  СтандартнаяОбработка - Булево		 - Признак стандартной обработки
//
Процедура НастройкиУпрощеннойАДСОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если Лев(НавигационнаяСсылка, 14) = "ИДОрганизации:" Тогда
		
		ИДОрганизации = СтрЗаменить(НавигационнаяСсылка, "ИДОрганизации:", "");
		
		Организация = УПЖКХ_ОбщегоНазначенияСервер.ПолучитьСсылкуНаЭлементСправочникаПоСтрокеУИД("Организации", ИДОрганизации);
		
		ОткрытьФорму("РегистрСведений.УПЖКХ_НастройкиУпрощеннойАДС.ФормаЗаписи", Новый Структура("ЗначенияЗаполнения", Новый Структура("Организация",Организация)));
		
	Иначе
		
		Попытка
			ПерейтиПоНавигационнойСсылке(НавигационнаяСсылка);
		Исключение
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("Ошибка перехода по ссылке. Возможно, запись настроек по данной организации была удалена.");
		КонецПопытки
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
