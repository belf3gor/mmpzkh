
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
// Обработчик события "ПередНачаломИзменения" элемента формы "Список"
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Если Не Элемент.ТекущиеДанные = Неопределено Тогда
		Отказ = УПЖКХ_ОбщегоНазначенияСервер.ПолучитьЗначениеРеквизита(Элемент.ТекущаяСтрока, "Предопределенный");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 
