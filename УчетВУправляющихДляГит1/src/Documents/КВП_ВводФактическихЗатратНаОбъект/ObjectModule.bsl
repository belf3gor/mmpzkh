
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем мУдалятьДвижения Экспорт;                      // Хранит признак новый ли это документ.
Перем ВестиУчетНачисленийПоДобровольномуСтрахованию; // Хранит признак учета начислений по добровольному страхованию.
Перем УслугаДобровольногоСтрахования;                // Хранит ссылку на услугу добровольного страхования.

#Область ПроцедурыИФункцииДляРаботыСТабличнымиЧастями

// Процедура заполняет табличную часть "Объекты учета" по данным документа-основания.
//
Процедура ЗаполнитьТабличнуюЧастьОбъектыУчета(Основание) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Основание);
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.КВП_РаспределениеМатериалов") Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КВП_РаспределениеМатериаловТаблицаРаспределения.Объект КАК ОбъектУчета,
		|	СУММА(КВП_РаспределениеМатериаловТаблицаРаспределения.Количество) КАК Количество,
		|	СУММА(ЕСТЬNULL(КВП_РаспределениеМатериаловТаблицаРаспределения.Сумма, 0)) КАК Сумма,
		|	КВП_Услуги.Ссылка КАК Услуга
		|ИЗ
		|	Документ.КВП_РаспределениеМатериалов.ТаблицаРаспределения КАК КВП_РаспределениеМатериаловТаблицаРаспределения
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КВП_Услуги КАК КВП_Услуги
		|		ПО КВП_РаспределениеМатериаловТаблицаРаспределения.Номенклатура = КВП_Услуги.Услуга
		|ГДЕ
		|	КВП_РаспределениеМатериаловТаблицаРаспределения.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	КВП_РаспределениеМатериаловТаблицаРаспределения.Объект,
		|	КВП_Услуги.Ссылка";
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.КВП_РаспределениеУслугСтороннихОрганизаций") Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Основание);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КВП_РаспределениеУслугСтороннихОрганизацийТаблицаРаспределения.Объект КАК ОбъектУчета,
		|	СУММА(КВП_РаспределениеУслугСтороннихОрганизацийТаблицаРаспределения.Количество) КАК Количество,
		|	СУММА(КВП_РаспределениеУслугСтороннихОрганизацийТаблицаРаспределения.Сумма) КАК Сумма,
		|	КВП_Услуги.Ссылка КАК Услуга
		|ИЗ
		|	Документ.КВП_РаспределениеУслугСтороннихОрганизаций.ТаблицаРаспределения КАК КВП_РаспределениеУслугСтороннихОрганизацийТаблицаРаспределения
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КВП_Услуги КАК КВП_Услуги
		|		ПО КВП_РаспределениеУслугСтороннихОрганизацийТаблицаРаспределения.Номенклатура = КВП_Услуги.Услуга
		|ГДЕ
		|	КВП_РаспределениеУслугСтороннихОрганизацийТаблицаРаспределения.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	КВП_Услуги.Ссылка,
		|	КВП_РаспределениеУслугСтороннихОрганизацийТаблицаРаспределения.Объект";
		
	КонецЕсли;
	
	тмОбъектыУчета = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаОбъектаУчета Из тмОбъектыУчета Цикл
		СтрокаТЧ                     = ОбъектыУчета.Добавить();
		СтрокаТЧ.ОбъектУчета         = СтрокаОбъектаУчета.ОбъектУчета;
		СтрокаТЧ.Услуга              = СтрокаОбъектаУчета.Услуга;
		СтрокаТЧ.СпособРаспределения = "поровну";
		СтрокаТЧ.Сумма               = СтрокаОбъектаУчета.Сумма;
		СтрокаТЧ.Количество          = СтрокаОбъектаУчета.Количество;
	КонецЦикла;
	
	ОбъектыУчета.Свернуть("ОбъектУчета, Услуга, СпособРаспределения", "Сумма, Количество");
	ТаблицаРаспределения.Свернуть("ОбъектУчета, ЛицевойСчет, Услуга, СпособРаспределения", "Сумма");
	
КонецПроцедуры // ЗаполнитьТабличнуюЧастьОбъектыУчета()

#КонецОбласти 

#Область ПроцедурыИФункцииДляОбеспеченияПроведенияДокумента

// Проверяет правильность заполнения документа.
//
// Параметры:
//  СтруктураШапкиДокумента - структура, содержащая реквизиты шапки
//                 документа и результаты запроса по шапке
//  Отказ        - Булево - флаг отказа в проведении
//  Заголовок    - Строка - заголовок сообщения об ошибке.
//
Процедура ПроверитьНаличиеЗакрытыхЛицевыхСчетов(Отказ, Заголовок, ТаблицаЛицевыхСчетов)
	
	// Проверка лицевого счета на действие.
	Если Не Отказ Тогда
		
		ТаблицаЛС = ТаблицаЛицевыхСчетов.Скопировать( ,"ЛицевойСчет, НомерСтроки");
		ТаблицаЛС.Колонки.ЛицевойСчет.Имя = "Объект";
		ТаблицаЛС.Колонки.Добавить("ДатаПроверки", Новый ОписаниеТипов("Дата"));
		ТаблицаЛС.ЗаполнитьЗначения(Дата, "ДатаПроверки");
		
		УПЖКХ_РаботаСЛицевымиСчетами.ПроверитьТаблицуНаНаличиеЗакрытыхЛицевыхСчетов(ТаблицаЛС);
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьНаличиеЗакрытыхЛицевыхСчетов()

// Предназначена для проверки заполнения доп. параметра распределения в табличных частях документа.
//
Процедура ПроверкаЗаполненияТипаРаспределенияВТЧДокумента(Отказ)
	
	Для каждого СтрокаТаблицы Из ОбъектыУчета Цикл
		СтрокаНачалаСообщенияОбОшибке = "Строка номер "+ СокрЛП(СтрокаТаблицы.НомерСтроки) +
		                               " табличной части ""Объекты учета"": ";
		
		Если (СтрокаТаблицы.СпособРаспределения = "пропорционально площади"
		 ИЛИ СтрокаТаблицы.СпособРаспределения  = "пропорционально количеству жильцов"
		 ИЛИ СтрокаТаблицы.СпособРаспределения  = "пропорционально объему потребления услуги")
		 И НЕ ЗначениеЗаполнено(СтрокаТаблицы.ТипРаспределения) Тогда
			СтрокаСообщения = "Не заполнено значение реквизита ""Доп. параметр распределения"".";
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщения, Отказ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ПроверкаЗаполненияТипаРаспределенияВТЧДокумента

// Проверяет правильность заполнения колонок "Количество" и "Сумма" табличной части "ТаблицаРаспределения".
//
Процедура ПроверитьЗаполнениеТаблицыРаспределения(Отказ)
	
	Для каждого ТекСтрока из ТаблицаРаспределения Цикл
		
		// Проверка заполнения колонок "Количество" и "Сумма".
		КоличествоНеЗаполнено = ТекСтрока.Количество = 0;
		СуммаНеЗаполнена      = ТекСтрока.Сумма      = 0;
		
		// Если одна из колонок не заполнена, то выводим сообщение об отказе от проведения.
		Если НЕ (КоличествоНеЗаполнено = СуммаНеЗаполнена) Тогда
			
			СтрокаСообщения = "Строка номер " + СокрЛП(ТекСтрока.НомерСтроки) +
			                  " табличной части ""Таблица распределения"": Не заполнено значение реквизита """ +
			                  ?(КоличествоНеЗаполнено, "Количество", "Сумма") + """.";
			
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке(СтрокаСообщения, Отказ);
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ПроверитьЗаполнениеТаблицыРаспределения()

// Формирует движения документа.
Процедура ДвижениеПоРегистрам(ТаблицаЛицевыхСчетов)
	
	ТаблицаДвижений = УПЖКХ_ВзаиморасчетыПоЛицевымСчетам.КВП_СформироватьТаблицуДвижений();
	
	// Выполнен частичный отказ от договоров в оперативном учете ЖКХ. Для тех, кто использует новый механизм отражения
	// начислений в регл. учете договор в проводках не заполняется. Для тех, кто использует старый механизм договор
	// по-прежнему заполняется в проводках.
	ЗаполнятьДоговорВПроводках = Не УПЖКХ_ПараметрыУчетаСервер.ИспользоватьНовыйМеханизмОтраженияНачисленийВРеглУчете(Дата);
	
	Для Каждого ТекСтрокаРаспределения Из ТаблицаЛицевыхСчетов Цикл
		
		// Если колонки "Количество" и "Сумма" не заполнены, то проводки не создаем.
		Если ТекСтрокаРаспределения.Количество = 0 И ТекСтрокаРаспределения.Сумма = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		// Для информации:
		// Тариф теперь не рассчитывается при проведении, а всегда берется из табличной части.
		// При распределении затрат тариф или рассчитывается исходя из суммы и объема,
		// или подставляется действующий тариф по услуге (в зависимости от варианта распределения затрат).
		// В случае необходимости может быть изменен пользователем непосредственно в табличной части.
		
		// Начисления по добровольному страхованию отражаем в отдельном регистре - "Начисления по добровольному страхованию".
		// В стандартные регистры начисления данные пока не записываем.
		Если ВестиУчетНачисленийПоДобровольномуСтрахованию И ТекСтрокаРаспределения.Услуга = УслугаДобровольногоСтрахования Тогда
			
			Движение                 = Движения.УПЖКХ_НачисленияПоДобровольномуСтрахованию.Добавить();
			Движение.Период          = Дата;
			Движение.Организация     = Организация;
			Движение.ЛицевойСчет     = ТекСтрокаРаспределения.ЛицевойСчет;
			Движение.Услуга          = УслугаДобровольногоСтрахования;
			Движение.МесяцНачисления = КонецМесяца(ДобавитьМесяц(Дата, 2));
			Движение.Тариф           = ТекСтрокаРаспределения.Тариф;
			Движение.Количество      = ТекСтрокаРаспределения.Количество;
			Движение.СуммаНачисления = ТекСтрокаРаспределения.Сумма;
			
		Иначе
		
			Движение                             = ТаблицаДвижений.Добавить();
			Движение.Период                      = Дата;
			Движение.Организация                 = Организация;
			Движение.ЛицевойСчет                 = ТекСтрокаРаспределения.ЛицевойСчет;
			Движение.Услуга                      = ТекСтрокаРаспределения.Услуга;
			Движение.РазделУчета                 = Перечисления.УПЖКХ_РазделыУчета.НачислениеУслуг;
			Движение.ВидНачисленияНаЛицевыеСчета = Перечисления.УПЖКХ_ВидыНачислений.ФактическиеЗатраты;
			Движение.ВидТарифа                   = Перечисления.КВП_ВидыТарифов.Общий;
			Движение.Тариф                       = ТекСтрокаРаспределения.Тариф;
			Движение.Количество                  = ТекСтрокаРаспределения.Количество;
			Движение.СуммаНачисления             = ТекСтрокаРаспределения.Сумма;
			Движение.ДнейНачислено               = День(КонецМесяца(Дата));
			Движение.Начало                      = НачалоМесяца(Дата);
			Движение.Окончание                   = КонецМесяца(Дата);
			
		КонецЕсли;
		
		Если ЗаполнятьДоговорВПроводках Тогда
			Движение.Договор = УПЖКХ_ОбщегоНазначенияСервер.ПолучитьСведенияДляВзаиморасчетовПоЛицевомуСчету(ТекСтрокаРаспределения.ЛицевойСчет,
																											Организация, Дата, "Договор");
		КонецЕсли;
		
	КонецЦикла;
	
	УПЖКХ_ВзаиморасчетыПоЛицевымСчетам.СформироватьДвиженияПоВзаиморасчетам(ЭтотОбъект, Новый Структура("Приход", ТаблицаДвижений));
	
	// Движения для отражения начислений в регл. учете.
	СформироватьДвиженияДляОтраженияНачисленийВРеглУчете(ЭтотОбъект);
	
КонецПроцедуры // ДвижениеПоРегистрам()

// Проверяет: были ли уже начисления по добровольному страхованию.
Процедура ПроверитьНачислениеДобровольногоСтрахования(Отказ)
	
	Если Не ВестиУчетНачисленийПоДобровольномуСтрахованию Тогда
		Возврат;
	КонецЕсли;
	
	СтрокиСтрахования  = ТаблицаРаспределения.НайтиСтроки(Новый Структура("Услуга", УслугаДобровольногоСтрахования));
	ТаблицаСтрахования = ТаблицаРаспределения.Выгрузить(СтрокиСтрахования);
	
	СписокЛицевыхСчетов = ТаблицаСтрахования.ВыгрузитьКолонку("ЛицевойСчет");
	
	Документы.КВП_НачислениеУслуг.ПроверитьНаличиеНачисленийПоДобровольномуСтрахованию(Ссылка, Дата, Организация, СписокЛицевыхСчетов, Отказ);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийДокумента

// Обработчик события проверки заполнения
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверкаЗаполненияТипаРаспределенияВТЧДокумента(Отказ);
	ПроверитьЗаполнениеТаблицыРаспределения(Отказ);
	ПроверитьНачислениеДобровольногоСтрахования(Отказ);
	
КонецПроцедуры

// Обработчик события "ПередЗаписью" документа.
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	мУдалятьДвижения = НЕ ЭтоНовый();
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах.
	СуммаДокумента = КВП_ПолучитьСуммуДокументаНачисленияОплаты(ЭтотОбъект, "ТаблицаРаспределения", "Сумма");
	
КонецПроцедуры // ПередЗаписью()

// Процедура проведения документа.
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = УПЖКХ_ТиповыеМетодыВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
	
	Если мУдалятьДвижения Тогда
		УПЖКХ_ТиповыеМетодыВызовСервера.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, Ложь, Ложь);
	КонецЕсли;
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении,
	// по данным шапки документа.
	ПараметрыПроведения = Документы.КВП_ВводФактическихЗатратНаОбъект.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаЛицевыхСчетов = ПараметрыПроведения.ТаблицаЛицевыхСчетов;
	
	ПроверитьНаличиеЗакрытыхЛицевыхСчетов(Отказ, Заголовок, ТаблицаЛицевыхСчетов);
	
	Если Не Отказ Тогда
		ДвижениеПоРегистрам(ТаблицаЛицевыхСчетов);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

// Отменяет движения документа по регистрам.
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	УПЖКХ_ТиповыеМетодыВызовСервера.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, Ложь, Ложь);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если НЕ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.КВП_РаспределениеМатериалов") 
		И НЕ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.КВП_РаспределениеУслугСтороннихОрганизаций") Тогда
		Возврат;
	КонецЕсли;
	
	Организация = ДанныеЗаполнения.Организация;
	ВидОперации = Перечисления.КВП_ВидыОперацийВводаФактическихЗатратНаОбъект.ВводДанныхНаЗдание;
	ЗаполнитьТабличнуюЧастьОбъектыУчета(ДанныеЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

#КонецОбласти 

#Область ИнициализацияПеременныхМодуля

НастройкиУчетДобровольногоСтрахования         = УПЖКХ_ПараметрыУчетаСервер.ПолучитьНастройкиУчетаНачисленийПоДобровольномуСтрахованию();
ВестиУчетНачисленийПоДобровольномуСтрахованию = НастройкиУчетДобровольногоСтрахования.ВестиУчетНачисленийПоДобровольномуСтрахованию;
УслугаДобровольногоСтрахования                = НастройкиУчетДобровольногоСтрахования.УслугаДобровольногоСтрахования;

#КонецОбласти

#КонецЕсли