
#Область КомандаДокумента

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВыполнитьКомандуПечати("Документ.КВП_СвидетельствоОРегистрацииПоМестуЖительства", "С_Р", ПараметрКоманды,
		ПараметрыВыполненияКоманды, УПЖКХ_ТиповыеМетодыКлиент.ПолучитьЗаголовокПечатнойФормы(ПараметрКоманды));
	
КонецПроцедуры

#КонецОбласти