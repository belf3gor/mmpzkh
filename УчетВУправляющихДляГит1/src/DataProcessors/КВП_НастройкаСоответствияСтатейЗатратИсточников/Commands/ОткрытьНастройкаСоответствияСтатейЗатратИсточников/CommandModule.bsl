
#Область ОбработчикиКоманды

&НаКлиенте
// Обработчик команды.
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Обработка.КВП_НастройкаСоответствияСтатейЗатратИсточников.Форма", ПараметрКоманды, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти