#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьПредопределенныеЭлементы() Экспорт
	Макет = Справочники.ХранилищеШаблонов.ПолучитьМакет("ШаблоныЭтикеток");
	НомерСтроки = 1;
	
	ИмяПредопределенного = Макет.Область(НомерСтроки, 1, НомерСтроки, 1).Текст;
	
	Пока  ИмяПредопределенного <> "" Цикл
		
		ШаблонСсылка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ХранилищеШаблонов."+ИмяПредопределенного);
		Если ШаблонСсылка <> Неопределено Тогда
			ШаблонОбъект = ШаблонСсылка.ПолучитьОбъект();
			ШаблонОбъект.XMLОписаниеМакета = Макет.Область(НомерСтроки, 2, НомерСтроки, 2).Текст;
			ШаблонОбъект.РазмерМакета = Макет.Область(НомерСтроки, 3, НомерСтроки, 3).Текст;
			ШаблонОбъект.ПоляШаблона = "ПоляШаблонаНоменклатура";
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ШаблонОбъект);
		КонецЕсли; 
		
		НомерСтроки = НомерСтроки + 1;
		ИмяПредопределенного = Макет.Область(НомерСтроки, 1, НомерСтроки, 1).Текст;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 


#КонецЕсли
 