#Область СлужебныйПрограммныйИнтерфейс

// Определяет доступность функциональности по оплате сервиса.
//
Функция ДоступнаОплатаСервиса() Экспорт
	
	Возврат (ПолучитьФункциональнуюОпцию("ОплатаПолныйИнтерфейс")
		ИЛИ ПолучитьФункциональнуюОпцию("ОплатаПростойИнтерфейс"))
		И ПравоДоступа("Просмотр", Метаданные.Обработки.ОплатаСервиса);
	
КонецФункции

#КонецОбласти
