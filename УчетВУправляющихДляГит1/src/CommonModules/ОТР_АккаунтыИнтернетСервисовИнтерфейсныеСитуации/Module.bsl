// Функция будет анализировать текущее состояние аккаунта.
// Возврат Истина       - верификация пройдена, аккаунт подключен
// Возврат Ложь         - верификация не пройдена
// Возврат Неопределено - нет данных аккаунта
//
Функция ПроверитьСостояниеАккаунта() Экспорт
	
	СведенияОбОшибке = "";
	ДанныеАккаунта = ОТР_АккаунтыИнтернетСервисовСервер.ПолучитьПараметрыАккаунта();
	Если Не ДанныеАккаунта.Логин = "" И Не ДанныеАккаунта.Пароль = "" И Не ДанныеАккаунта.Email = "" Тогда
		Возврат ОТР_АккаунтыИнтернетСервисовСервер.ВыполнитьВерификациюПараметров(ДанныеАккаунта, СведенияОбОшибке);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Открывает форму входа при нажатии гиперссылки "ЛМБ_ВыполнитьПодключениеКАккаунту".
//
Процедура ОткрытьФормуПодключенияАккаунтаСервисов() Экспорт
	ОткрытьФорму("Обработка.ОТР_АккаунтыИнтернетСервисов.Форма.ВходНаСервис");
КонецПроцедуры
