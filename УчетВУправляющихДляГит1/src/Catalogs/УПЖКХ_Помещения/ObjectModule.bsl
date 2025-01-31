
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем мАктуаленСтроительныйАдрес Экспорт;  //Хранит флаг актуальность "Строительного" адреса.

#Область ЭкспортныеПроцедурыИФункции

// Можно ли записать элемент справочника.
//
// Возвращаемое значение:
//  Булево - есть ли ошибки.
//
Функция НельзяЗаписатьЭлемент() Экспорт

	Если Владелец.Этажей < Этаж Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("Номер этажа больше, чем всего этажей в доме!");
		Возврат Истина;
	КонецЕсли;

	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УПЖКХ_Помещения.Ссылка
	|ИЗ
	|	Справочник.УПЖКХ_Помещения КАК УПЖКХ_Помещения
	|ГДЕ
	|	УПЖКХ_Помещения.Владелец = &Владелец
	|	И УПЖКХ_Помещения.Родитель = &Родитель
	|	И УПЖКХ_Помещения.Код = &Код
	|	И УПЖКХ_Помещения.ВидПомещения.ТипПомещения = &ТипПомещения
	|	И УПЖКХ_Помещения.Суффикс = &Суффикс
	|	И УПЖКХ_Помещения.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Владелец",     Владелец);
	Запрос.УстановитьПараметр("Родитель",     Родитель);
	Запрос.УстановитьПараметр("Код",          Код);
	Запрос.УстановитьПараметр("Суффикс",      Суффикс);
	Запрос.УстановитьПараметр("Ссылка",       Ссылка);
	Запрос.УстановитьПараметр("ТипПомещения", ВидПомещения.ТипПомещения);
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Если Не Результат.Пустой() Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("В данном здании уже существует помещение с таким типом и номером!");
		Возврат Истина;
	КонецЕсли;
	
	Если Владелец.ЖилойДомБлокированнойЗастройки Тогда
		Если ПустаяСтрока(НомерБлока) Тогда
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("Для помещений зданий блокированной застройки обязательно заполнение номера блока!");
			Возврат Истина;
		КонецЕсли;
		
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УПЖКХ_Помещения.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.УПЖКХ_Помещения КАК УПЖКХ_Помещения
		|ГДЕ
		|	УПЖКХ_Помещения.Владелец = &Владелец
		|	И УПЖКХ_Помещения.Родитель = &Родитель
		|	И УПЖКХ_Помещения.ВидПомещения.ТипПомещения = &ТипПомещения
		|	И УПЖКХ_Помещения.НомерБлока = &НомерБлока
		|	И УПЖКХ_Помещения.Ссылка <> &Ссылка";
		Запрос.УстановитьПараметр("Владелец",     Владелец);
		Запрос.УстановитьПараметр("Родитель",     Родитель);
		Запрос.УстановитьПараметр("Ссылка",       Ссылка);
		Запрос.УстановитьПараметр("НомерБлока",   НомерБлока);
		Запрос.УстановитьПараметр("ТипПомещения", ВидПомещения.ТипПомещения);
		
		Результат = Запрос.Выполнить();
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Если Не Результат.Пустой() Тогда
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("В указанном блоке данного здания уже существует помещение с таким типом!");
			Возврат Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;

КонецФункции

// Формирует наименование квартиры по введенным реквизитам.
//
// Параметры:
//  Нет.
//
Процедура ОбновитьНаименованиеКвартиры() Экспорт
	
	ОбновитьАктуальностьСтроительногоАдреса();
	Если мАктуаленСтроительныйАдрес Тогда
	// «Секция № » + Подъезд.Секция + «Этаж » + Этаж +  «№ на площадке » + строительный номер. 
		Наименование = ?(ЗначениеЗаполнено(Подъезд), "Секция № " + Строка(Подъезд.Секция) + ", ", "") 
						+ ?(ЗначениеЗаполнено(Этаж), "Этаж " + Строка(Этаж) + ", ", "") 
						+ "№ на площадке " + СтроительныйНомер;
	Иначе
		
		Наименование = ?(ЗначениеЗаполнено(ВидПомещения.НаименованиеКраткое), ВидПомещения.НаименованиеКраткое + " ", "");
		
		Наименование = Наименование + Код + "" + Суффикс;
		
	КонецЕсли;
	
КонецПроцедуры // ОбновитьНаименованиеКвартиры()

// Процедура автоматического подбора номера квартиры для текущего владельца.
//
// Параметры:
//  Нет.
//
Процедура УстановитьНомерКвартиры() Экспорт
	
	// Получение списка квартир по зданию.
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УПЖКХ_Помещения.Код КАК Код
	|ИЗ
	|	Справочник.УПЖКХ_Помещения КАК УПЖКХ_Помещения
	|ГДЕ
	|	УПЖКХ_Помещения.Владелец = &Владелец
	|	И УПЖКХ_Помещения.ВидПомещения.ТипПомещения = &ТипПомещения
	|	И УПЖКХ_Помещения.Родитель = &Помещение
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код";
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Запрос.УстановитьПараметр("ТипПомещения", ВидПомещения.ТипПомещения);
	Запрос.УстановитьПараметр("Помещение", Родитель);
	
	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	
	// Нахождение минимального номера из помещений данного типа, 
	// не числящихся в данном здании.
	ОбновитьАктуальностьСтроительногоАдреса();
	Если мАктуаленСтроительныйАдрес Тогда
		НовыйНомер = 100000;
	Иначе
		НовыйНомер = 1;
	КонецЕсли;
	Для Каждого ТекСтрока Из ТаблицаРезультата Цикл
		Если ТекСтрока.Код > НовыйНомер Тогда
			Прервать;
		КонецЕсли;
		НовыйНомер = НовыйНомер + 1;
	КонецЦикла;
	
	// Установка найденного значения в качестве наименования.
	Код = НовыйНомер;
	
КонецПроцедуры // УстановитьНомерКвартиры()

// Вызывает заполнение переменной мАктуаленСтроительныйАдрес, если она не инициализирована.
//
// Параметры:
//  ПроверятьЗаполненность - Булево - нужно ли проверять заполненность переменной.
//
Процедура ОбновитьАктуальностьСтроительногоАдреса(ПроверятьЗаполненность = Истина) Экспорт
	
	Если Не ПроверятьЗаполненность Или мАктуаленСтроительныйАдрес = Неопределено Тогда
		УстановитьАктуальностьСтроительногоАдреса(ЭтоНовый());
	КонецЕсли;
	
КонецПроцедуры

// Заполняет переменную мАктуаленСтроительныйАдрес.
//
// Параметры:
//  БратьПоОбъекту - Булево - использовать ли владельца из объекта, если Ложь,
//                 владелец определяется по ссылке.
//
Процедура УстановитьАктуальностьСтроительногоАдреса(БратьПоОбъекту = Истина) Экспорт
	
	мАктуаленСтроительныйАдрес = Ложь;
	
	ТекВладелец = ?(БратьПоОбъекту, Владелец, Ссылка.Владелец);
	Если ЗначениеЗаполнено(ТекВладелец) Тогда
		СтрукАдресаВладельца = ПолучитьАдрес(ТекВладелец,
											 Перечисления.КВП_ВидыАдресов.Здание);
		мАктуаленСтроительныйАдрес = СтрукАдресаВладельца.Строительный;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСправочника

// Обработчик события "ПриКопировании" объекта.
Процедура ПриКопировании(ОбъектКопирования)

	ВидПомещения     = ОбъектКопирования.ВидПомещения;
	Суффикс          = ОбъектКопирования.Суффикс;
	Владелец         = ОбъектКопирования.Владелец;
	КоличествоКомнат = ОбъектКопирования.КоличествоКомнат;
	Этаж             = ОбъектКопирования.Этаж;
	Характеристика   = ОбъектКопирования.Характеристика;

КонецПроцедуры

// Обработчик события "ПередЗаписью" объекта.
// Отслеживает возможность перемещения элемента в иерархии справочника.
Процедура ПередЗаписью(Отказ)
	
	Если НЕ Родитель.Пустая() Тогда
		
		ТипыПомещений = Справочники.УПЖКХ_Помещения.ПолучитьДоступныеТипыПомещенияДляОбъекта(ЭтотОбъект);
		
		Если ТипыПомещений.НайтиПоЗначению(ВидПомещения.ТипПомещения) = Неопределено Тогда
				
				УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("Перемещение элемента в данный уровнь иерархии невозможно.");
				Отказ = Истина;
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнициализацияПеременных

мАктуаленСтроительныйАдрес = Неопределено;

#КонецОбласти

#КонецЕсли