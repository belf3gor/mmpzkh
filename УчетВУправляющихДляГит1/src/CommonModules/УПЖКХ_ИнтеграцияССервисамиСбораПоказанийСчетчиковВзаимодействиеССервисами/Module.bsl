
#Область ПроцедурыИФункцииОбщегоНазначения

// Инициирует обмен данными с сервисом.
Процедура ОбменССервисомСбораПоказанийСчетчиков(НазваниеСистемыПроизводителейСчетчиков) Экспорт
	
	ТаблицаДанныхССервиса = ПолучитьТаблицуДанныхССервисаПроизводителейСчетчиков(НазваниеСистемыПроизводителейСчетчиков);
	
	СтрокиСДанными = ТаблицаДанныхССервиса.НайтиСтроки(Новый Структура("НеУдалосьПолучитьДанные", Ложь));
	
	Для Каждого СтрокаСДанными Из СтрокиСДанными Цикл
		ДанныеЗагружены  = Истина;
		ОписаниеПроблемы = "";
		УПЖКХ_ИнтеграцияССервисамиСбораПоказанийСчетчиковВзаимодействиеСБазойДанных.ЗагрузитьПоказанияВБазу(СтрокаСДанными.СтруктураСведений, СтрокаСДанными.НаименованиеОрганизации,
		ДанныеЗагружены, ОписаниеПроблемы);
		УПЖКХ_ИнтеграцияССервисамиСбораПоказанийСчетчиковВзаимодействиеСБазойДанных.ЗаписатьСведенияВЖурналОбмена(СтрокаСДанными, ДанныеЗагружены, ОписаниеПроблемы, НазваниеСистемыПроизводителейСчетчиков);
	КонецЦикла;
	
КонецПроцедуры

// Формирует таблицу с данными с сервиса.
Функция ПолучитьТаблицуДанныхССервисаПроизводителейСчетчиков(НазваниеСистемыПроизводителейСчетчиков)
	
	Таблица = УПЖКХ_ИнтеграцияССервисамиСбораПоказанийСчетчиковВзаимодействиеСБазойДанных.ПодготовитьТаблицуДанных();
	
	Для Каждого СтрокаОрганизации Из Таблица Цикл
		ОписаниеПроблемы = "";
		
		Если СтрокаОрганизации.ИННЗаполнен Тогда
			УПЖКХ_ВзаимодействиеССервисамиРарус.ПолучитьДанныеССервисаПроизводителейСчетчиков(СтрокаОрганизации, ОписаниеПроблемы, НазваниеСистемыПроизводителейСчетчиков);
			
		Иначе
			СтрокаОрганизации.НеУдалосьПолучитьДанные = Истина;
			
			ОписаниеПроблемы = "Не заполнен ИНН организации " + СтрокаОрганизации.НаименованиеОрганизации + ". Данные не загружены.";
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеПроблемы, СтрокаОрганизации.СсылкаНаОрганизацию);
		КонецЕсли;
		
		// Если не удалось получить данные с сервиса, сразу записываем соответствующую информацию в журнал обмена.
		// Далее не обрабатываем текущую строку.
		Если СтрокаОрганизации.НеУдалосьПолучитьДанные Тогда
			УПЖКХ_ИнтеграцияССервисамиСбораПоказанийСчетчиковВзаимодействиеСБазойДанных.ЗаписатьСведенияВЖурналОбмена(СтрокаОрганизации, Ложь, ОписаниеПроблемы, НазваниеСистемыПроизводителейСчетчиков);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

#КонецОбласти
