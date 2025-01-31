
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьПараметрыСпискаЛС()
	
	СписокЛС.Параметры.УстановитьЗначениеПараметра("СписокВыбранныхЛС", ВыбранныеЛС.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЛСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЛицевойСчет = ВыбраннаяСтрока;
	
	Если Не УПЖКХ_ОбщегоНазначенияСервер.ПолучитьЗначениеРеквизита(ЛицевойСчет, "ЭтоГруппа") Тогда
	
		Если ВыбранныеЛС.НайтиПоЗначению(ЛицевойСчет) = Неопределено Тогда
			ВыбранныеЛС.Добавить(ЛицевойСчет);
		КонецЕсли;
		
		ОбновитьПараметрыСпискаЛС();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПередатьСписокЛС();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьПараметрыСпискаЛС();
	
	ЗакрыватьПриВыборе = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьСписокЛС()
	
	АдресВХранилище = ПоместитьСписокЛСВХранилище();
	
	Оповестить("ПередачаВыбранныхЛС", АдресВХранилище);
	
КонецПроцедуры // ПередатьСписокЛС()

&НаСервере
Функция ПоместитьСписокЛСВХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(ВыбранныеЛС.ВыгрузитьЗначения(), Новый УникальныйИдентификатор);
	
КонецФункции // ПоместитьСписокЛСВХранилище()

#КонецОбласти