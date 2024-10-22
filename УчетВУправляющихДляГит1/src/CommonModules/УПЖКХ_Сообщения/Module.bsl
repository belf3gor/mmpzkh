
// Содержит в себе сообщения, формируемые в модулях конфигурации "ЖКХ".
// Необходим для возможности перевода сообщений на другой язык.
//
// Изменения в модуле разрешены.

#Область СлужебныеПроцедурыИФункции

// Сообщение "Не обнаружен ключ защиты...".
//
// Возвращаемое значение:
//  Строка
//
Функция НеОбнаруженКлючЗащиты(Наименование) Экспорт
	
	Возврат НСтр("ru = 'Не обнаружен ключ защиты. Функционал ПП """ + Наименование + """ не будет доступен.'");
	
КонецФункции // НеОбнаруженКлючЗащиты()

// Сообщение "Возможные причины и способы устранения ошибки...".
//
// Возвращаемое значение:
//  Строка
//
Функция ВозможныеПричиныИСпособыУстраненияОшибки(Адрес) Экспорт
	
	Возврат НСтр("ru = 'Возможные причины и способы устранения ошибки вы можете посмотреть по ссылке: " + Адрес + "'");
	
КонецФункции // ВозможныеПричиныИСпособыУстраненияОшибки()

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Сообщение "Изменился номер версии ЖКХ".
//
// Возвращаемое значение:
//  Строка
//
Функция ИзменилсяНомерВерсииЖКХ() Экспорт
	
	Возврат НСтр("ru = 'Изменился номер версии ЖКХ. Будет выполнено обновление информационной базы.'");
	
КонецФункции // ИзменилсяНомерВерсииЖКХ()

// Сообщение "Недостаточно прав для выполнения обновления".
//
// Возвращаемое значение:
//  Строка
//
Функция НедостаточноПравДляВыполненияОбновления() Экспорт
	
	Возврат НСтр("ru = 'Недостаточно прав для выполнения обновления ЖКХ. Работа системы будет завершена.'");
	
КонецФункции // НедостаточноПравДляВыполненияОбновления()

// Сообщение "Не удалось установить монопольный режим".
//
// Возвращаемое значение:
//  Строка
//
Функция НеУдалосьУстановитьМонопольныйРежим() Экспорт
	
	Возврат НСтр("ru = 'Не удалось установить монопольный режим. Работа системы будет завершена.'");
	
КонецФункции // НеУдалосьУстановитьМонопольныйРежим()

// Вопрос "Не выполнено обновление информационной базы ЖКХ".
//
// Возвращаемое значение:
//  Строка
//
Функция НеВыполненоОбновлениеЖКХ() Экспорт
	
	Возврат НСтр("ru = 'Не выполнено обновление информационной базы ЖКХ! Завершить работу системы?'");
	
КонецФункции // НеВыполненоОбновлениеЖКХ()

// Сообщение "Обновление информационной базы ЖКХ выполнено успешно.".
//
// Возвращаемое значение:
//  Строка
//
Функция ОбновлениеЖКХВыполнено() Экспорт
	
	Возврат НСтр("ru = 'Обновление информационной базы ЖКХ выполнено успешно.'");
	
КонецФункции // ОбновлениеЖКХВыполнено()

#КонецОбласти
