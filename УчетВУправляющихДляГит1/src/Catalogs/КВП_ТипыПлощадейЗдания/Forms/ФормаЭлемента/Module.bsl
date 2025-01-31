
#Область ОбработчикиСобытийФормы

// Обработчик события формы "ПриОткрытии".
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДобавитьПредлагаемоеЗначениеИдентификатораВСписокВыбора();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовФормы

// Обработчик события "ПриИзменении" элемента формы наименование.
//
&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ОбновитьПредлагаемоеЗначениеИдентификатора();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обновляет предлагаемое значение идентификатора формулы.
//
&НаКлиенте
Процедура ОбновитьПредлагаемоеЗначениеИдентификатора()
	
	Если Не Элементы.ИдентификаторДляФормул.ТолькоПросмотр Тогда
		Объект.ИдентификаторДляФормул = УПЖКХ_ОбщегоНазначенияКлиентСервер.ПолучитьИдентификатор(Объект.Наименование);
	КонецЕсли;
	ДобавитьПредлагаемоеЗначениеИдентификатораВСписокВыбора();
	
КонецПроцедуры

// Добавляет предлагаемое значение идентификатора формулы.
//
&НаКлиенте
Процедура ДобавитьПредлагаемоеЗначениеИдентификатораВСписокВыбора()
	
	ИдентификаторДляФормул = УПЖКХ_ОбщегоНазначенияКлиентСервер.ПолучитьИдентификатор(Объект.Наименование);
	
	Элементы.ИдентификаторДляФормул.СписокВыбора[0].Значение = ИдентификаторДляФормул;
	Если Не ЗначениеЗаполнено(Объект.ИдентификаторДляФормул) Тогда
		Объект.ИдентификаторДляФормул = ИдентификаторДляФормул;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
