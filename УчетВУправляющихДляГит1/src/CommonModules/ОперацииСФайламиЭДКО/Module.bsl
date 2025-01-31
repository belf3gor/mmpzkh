#Область ПрограммныйИнтерфейс

Функция СоздатьВременныйКаталог() Экспорт
	
	ИмяКаталога = КаталогВременныхФайлов();
	РазделительПутиОС = ПолучитьРазделительПути();
	Если Прав(ИмяКаталога, 1) <> РазделительПутиОС Тогда
		ИмяКаталога = ИмяКаталога + РазделительПутиОС;
	КонецЕсли;
	
	ИмяКаталога = ИмяКаталога + Строка(Новый УникальныйИдентификатор) + РазделительПутиОС;
	СоздатьКаталог(ИмяКаталога);
	
	Возврат ИмяКаталога;
	
КонецФункции

Процедура УдалитьВременныйФайл(ИмяФайла) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ИмяФайла) Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		УдалитьФайлы(ИмяФайла);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти