
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СвойстваФайла = ПолучитьСвойстваПрисоединенногоФайла(ПараметрКоманды);
	
	Если СвойстваФайла.ФайлРегистраУчетаПрисоединен Тогда
		
		Если СвойстваФайла.ПодписанЭП Тогда
			Если Тип(ПараметрыВыполненияКоманды.Источник) = Тип("УправляемаяФорма") Тогда
				УникальныйИдентификаторФормы = ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор;
			Иначе
				УникальныйИдентификаторФормы = Новый УникальныйИдентификатор;
			КонецЕсли;
			
			РаботаСФайламиКлиент.СохранитьВместеСЭП(
				СвойстваФайла.ПрисоединенныйФайл, УникальныйИдентификаторФормы);
		Иначе
			РаботаСФайламиКлиент.СохранитьФайлКак(СвойстваФайла.ДанныеФайла);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьСвойстваПрисоединенногоФайла(ДокументРегистр)
	
	Возврат Документы.РегистрУчета.ПолучитьСвойстваПрисоединенногоФайлаРегистра(ДокументРегистр, Истина);
	
КонецФункции

#КонецОбласти