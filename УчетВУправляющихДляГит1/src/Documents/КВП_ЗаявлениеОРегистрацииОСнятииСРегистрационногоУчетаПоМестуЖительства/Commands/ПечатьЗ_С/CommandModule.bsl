
#Область КомандаДокумента

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВыполнитьКомандуПечати("Документ.КВП_ЗаявлениеОРегистрацииОСнятииСРегистрационногоУчетаПоМестуЖительства", "З_С", ПараметрКоманды,
		ПараметрыВыполненияКоманды, УПЖКХ_ТиповыеМетодыКлиент.ПолучитьЗаголовокПечатнойФормы(ПараметрКоманды));
	
КонецПроцедуры

#КонецОбласти