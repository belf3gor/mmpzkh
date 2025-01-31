
#Область ПроцедурыМодуля

#Область Механизм_Подключения_Внешней_Обработки

// Для внутреннего использования. Сведения для регистрации обработки.
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Вид",             "ДополнительнаяОбработка"); // Варианты: "ДополнительнаяОбработка", "ДополнительныйОтчет", 
																			 // "ЗаполнениеОбъекта", "Отчет", "ПечатнаяФорма", "СозданиеСвязанныхОбъектов" 
	
	ПараметрыРегистрации.Вставить("Наименование",    "Внешняя обработка: " + Метаданные().Синоним);
	ПараметрыРегистрации.Вставить("Версия",          "<Версия>");     // версия внешнего отчета.
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);           // если ИСТИНА, то выводится конфигураторская ошибка в типовой реализации,
																	  // связанная с ограничениями при использовании компоненты в механизмах внешних отчетов и обработок.
	ПараметрыРегистрации.Вставить("Информация",      "<Информация>");
	ПараметрыРегистрации.Вставить("ВерсияБСП",       "2.4.3.98");     // не ниже какой версии БСП подерживается обработка
	
	// Команды формирования отчета:
	ТаблицаКоманд = Новый ТаблицаЗначений;
	ТаблицаКоманд.Колонки.Добавить("Представление",         Новый ОписаниеТипов("Строка"));
	ТаблицаКоманд.Колонки.Добавить("Идентификатор",         Новый ОписаниеТипов("Строка"));
	ТаблицаКоманд.Колонки.Добавить("Использование",         Новый ОписаниеТипов("Строка"));
	ТаблицаКоманд.Колонки.Добавить("ПоказыватьОповещение",  Новый ОписаниеТипов("Булево"));
	ТаблицаКоманд.Колонки.Добавить("Модификатор",           Новый ОписаниеТипов("Строка"));
	
	ДобавитьКоманду(ТаблицаКоманд,
					"Открыть " + ПараметрыРегистрации.Наименование,
					"Открыть " + ПараметрыРегистрации.Наименование,
					"ОткрытиеФормы",	//Использование.  Варианты: "ОткрытиеФормы", "ВызовКлиентскогоМетода", "ВызовСерверногоМетода".
					Ложь,				//Показывать оповещение. Варианты Истина, Ложь.
					"");				//Модификатор.
	
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции // СведенияОВнешнейОбработке()

// Добавляет команды в таблицу.
Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")

	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление        = Представление;
	НоваяКоманда.Идентификатор        = Идентификатор;
	НоваяКоманда.Использование        = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор          = Модификатор;

КонецПроцедуры // ДобавитьКоманду()

#КонецОбласти // Механизм_Подключения_Дополнительного_Отчета

// Получает настройки загрузки файла из регистра сведений "КВП_НастройкиЗагрузкиИзАС".
//
// Параметры:
//  Нет
// 
Функция ПолучитьНастройкиЗагрузкиФайла(СсылкаОрганизация) Экспорт
	
	НастройкиЗагрузки = РегистрыСведений.КВП_НастройкиЗагрузкиИзАС.СоздатьМенеджерЗаписи();
	НастройкиЗагрузки.Организация = СсылкаОрганизация;
	НастройкиЗагрузки.ВидОперации = Перечисления.КВП_ВидыНастроекЗагрузкиИзАС.ЗагрузкаИзСистемСбораПоказанийПриборовУчета;
	НастройкиЗагрузки.Прочитать();
	
	Возврат НастройкиЗагрузки;
	
КонецФункции //ПолучитьНастройкиЗагрузкиФайла()

#КонецОбласти