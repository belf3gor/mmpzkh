
#Область ОбработчикиСобытий

&НаКлиенте
// Обработчик команды.
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	//ФормаВыбора = ПолучитьФорму("Справочник.Организации.ФормаВыбора");
	//
	//// Перееопределим массив объектов для печати, добавив
	//// в него выбранную организацию.
	//
	//ПараметрОрганизация = ФормаВыбора.ОткрытьМодально();
	//МассивПараметрКоманды = Новый Массив;
	//МассивПараметрКоманды.Добавить(ПараметрОрганизация);
	//
	//Для Каждого ТекЭлемент Из ПараметрКоманды Цикл
	//	МассивПараметрКоманды.Добавить(ТекЭлемент);
	//КонецЦикла;
	//
	//ПараметрКоманды = МассивПараметрКоманды;
	
	УПЖКХ_ТиповыеМетодыКлиент.ВыполнитьКомандуПечати("Справочник.КВП_ЛицевыеСчета",
														 "ПамяткаДоступа",
														 ПараметрКоманды,
														 ПараметрыВыполненияКоманды,
														 УПЖКХ_ТиповыеМетодыКлиент.ПолучитьЗаголовокПечатнойФормы(ПараметрКоманды));
	
КонецПроцедуры

#КонецОбласти