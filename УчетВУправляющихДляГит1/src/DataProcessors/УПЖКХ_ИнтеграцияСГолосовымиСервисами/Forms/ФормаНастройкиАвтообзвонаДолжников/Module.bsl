
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик "ПриСозданииНаСервере" формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьСохраненныеНастройки();
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

#Область ОбработчикиКомандФормы

&НаКлиенте
// Обработчик нажатия кнопки "Закончить настройку расписания".
//
Процедура КомандаЗакрыть(Команда)
	
	СохранитьНастройки();
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ УПРАВЛЕНИЯ ФОРМОЙ

#Область ПроцедурыУправленияФормой

&НаСервере
// Получает и заполняет сохраненные настройки регламентных заданий.
//
Процедура ПолучитьСохраненныеНастройки()
	
	СохраненныеНастройки = УПЖКХ_ИнтеграцияСГолосовымиСервисамиВзаимодействиеСБазойДанных.ПолучитьНастройкиИнтеграцииСГолосовымиСервисами();
	
	МинимальнаяСуммаДолгаДляАвтообзвона                     = СохраненныеНастройки.МинимальнаяСуммаДолгаДляАвтообзвона;
	МинимальноеКоличествоМесяцевЗадолженностиДляАвтообзвона = СохраненныеНастройки.МинимальноеКоличествоМесяцевЗадолженностиДляАвтообзвона;
	
КонецПроцедуры

&НаСервере
// Получает и заполняет сохраненные настройки регламентных заданий.
//
Процедура СохранитьНастройки()
	
	СтруктураНастроек = Новый Структура("МинимальнаяСуммаДолгаДляАвтообзвона, МинимальноеКоличествоМесяцевЗадолженностиДляАвтообзвона",
										 МинимальнаяСуммаДолгаДляАвтообзвона, МинимальноеКоличествоМесяцевЗадолженностиДляАвтообзвона);
	
	УПЖКХ_ИнтеграцияСГолосовымиСервисамиВзаимодействиеСБазойДанных.УстановитьНастройкиИнтеграцииCГолосовымиСервисами(СтруктураНастроек);
	
КонецПроцедуры

#КонецОбласти
