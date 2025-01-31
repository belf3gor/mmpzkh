
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СтруктураДоходовВычетов") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.СтруктураДоходовВычетов);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если СуммаВычета = 0 И СуммаДохода = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Заполните хотя бы одно поле'"));
		Возврат;
	КонецЕсли;
	
	Если СуммаВычета > 400000 Тогда
		ТекстСообщения = НСтр("ru = 'Сумма вычета превышает 400 тыс. руб.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "СуммаВычета");
		Возврат;
	КонецЕсли;
	
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("Вид",         ПредопределенноеЗначение("Перечисление.ВычетыФизическихЛиц.Инвестиционный"));
	СтруктураОтвета.Вставить("Информация",  НСтр("ru = 'Инвестиционный вычет'"));
	СтруктураОтвета.Вставить("СуммаДохода", СуммаДохода);
	СтруктураОтвета.Вставить("СуммаВычета", СуммаВычета);
	
	Закрыть(СтруктураОтвета);
	
КонецПроцедуры

#КонецОбласти
