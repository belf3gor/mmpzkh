#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
    	Возврат;
    КонецЕсли;
	
	ОтображатьРазделыДокументыТоварыКонтрагенты = (Значение 
		ИЛИ Константы.ИспользоватьДокументыРеализации.Получить())
		И Константы.ИнтерфейсТаксиПростой.Получить();
	Константы.ОтображатьРазделыДокументыТоварыКонтрагенты.Установить(ОтображатьРазделыДокументыТоварыКонтрагенты);
	
	ИспользоватьДокументыПоступленияИП = Значение
		И Константы.ВестиУчетИндивидуальногоПредпринимателя.Получить();
	Константы.ИспользоватьДокументыПоступленияИП.Установить(ИспользоватьДокументыПоступленияИП);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
