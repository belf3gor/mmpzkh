
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда	

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Проведение

// Получает данные по проживающему.
//
// Параметры:
//  Объект       - проживающий.
//  ЛицевойСчет  - лицевой счет.
//
// Возвращаемое значение:
//  Структура с данными.
//
Функция ПолучитьДанныеИзРегистра(Объект, ЛицевойСчет, Дата) Экспорт
	
	СтруктураДанных = Новый Структура("Жилец,
									  |Собственник,
									  |ВладелецЕдинственногоЖилья,
									  |ДополнительнаяПлощадь,
									  |ДоляСобственностиЧислитель,
									  |ДоляСобственностиЗнаменатель,
									  |ОснованиеПолученияВСобственность,
									  |ВидДокументаСобственности,
									  |НомерДокументаСобственности,
									  |ДатаДокументаСобственности");
	
	ЗапросДанных  = Новый Запрос;
	ЗапросДанных.УстановитьПараметр("ТекущаяДата",  Новый Граница(Дата, ВидГраницы.Исключая));
	ЗапросДанных.УстановитьПараметр("Помещение", ЛицевойСчет.Адрес);
	
	Если Объект = Неопределено Тогда
		ЗапросДанных.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УПЖКХ_Жильцы.Ссылка КАК Жилец,
		|	УПЖКХ_Жильцы.ФизЛицо
		|ПОМЕСТИТЬ втЖильцыЛС
		|ИЗ
		|	Справочник.УПЖКХ_Жильцы КАК УПЖКХ_Жильцы
		|ГДЕ
		|	НЕ УПЖКХ_Жильцы.ПометкаУдаления
		|	И УПЖКХ_Жильцы.Владелец = &ЛицевойСчет
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	втЖильцыЛС.Жилец,
		|	ЕСТЬNULL(УПЖКХ_СобственникиПомещенийСрезПоследних.Действует, ЛОЖЬ) КАК Собственник,
		|	ЕСТЬNULL(УПЖКХ_СобственникиПомещенийСрезПоследних.ДоляСобственникаЧислитель, 0) КАК ДоляСобственностиЧислитель,
		|	ЕСТЬNULL(УПЖКХ_СобственникиПомещенийСрезПоследних.ДоляСобственникаЗнаменатель, 0) КАК ДоляСобственностиЗнаменатель,
		|	ЕСТЬNULL(КВП_СведенияОЖильцахСрезПоследних.ВладелецЕдинственногоЖилья, ЛОЖЬ) КАК ВладелецЕдинственногоЖилья,
		|	ЕСТЬNULL(КВП_СведенияОЖильцахСрезПоследних.ДополнительнаяПлощадь, 0) КАК ДополнительнаяПлощадь,
		|	ЕСТЬNULL(УПЖКХ_СобственникиПомещенийСрезПоследних.ОснованиеПолученияВСобственность, ЗНАЧЕНИЕ(Справочник.УПЖКХ_ОснованияПолученияВСобственностьПомещений.ПустаяСсылка)) КАК ОснованиеПолученияВСобственность,
		|	ЕСТЬNULL(УПЖКХ_СобственникиПомещенийСрезПоследних.ВидДокумента, ЗНАЧЕНИЕ(Справочник.УПЖКХ_ДокументыНаПравоСобственности.ПустаяСсылка)) КАК ВидДокументаСобственности,
		|	ЕСТЬNULL(УПЖКХ_СобственникиПомещенийСрезПоследних.НомерДокумента, """") КАК НомерДокументаСобственности,
		|	ЕСТЬNULL(УПЖКХ_СобственникиПомещенийСрезПоследних.ДатаДокумента, ДАТАВРЕМЯ(1, 1, 1, 1, 1, 1)) КАК ДатаДокументаСобственности
		|ИЗ
		|	втЖильцыЛС КАК втЖильцыЛС
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КВП_СведенияОЖильцах.СрезПоследних(
		|				&ТекущаяДата,
		|				Объект В
		|					(ВЫБРАТЬ
		|						втЖильцыЛС.Жилец
		|					ИЗ
		|						втЖильцыЛС КАК втЖильцыЛС)) КАК КВП_СведенияОЖильцахСрезПоследних
		|		ПО втЖильцыЛС.Жилец = КВП_СведенияОЖильцахСрезПоследних.Объект
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УПЖКХ_СобственникиПомещений.СрезПоследних(
		|				&ТекущаяДата,
		|				Помещение = &Помещение
		|					И Собственник В
		|						(ВЫБРАТЬ
		|							втЖильцыЛС.ФизЛицо
		|						ИЗ
		|							втЖильцыЛС КАК втЖильцыЛС)) КАК УПЖКХ_СобственникиПомещенийСрезПоследних
		|		ПО втЖильцыЛС.ФизЛицо = УПЖКХ_СобственникиПомещенийСрезПоследних.Собственник";
		
		ЗапросДанных.УстановитьПараметр("ЛицевойСчет", ЛицевойСчет);
		
	Иначе
		ЗапросДанных.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЕСТЬNULL(КВП_СведенияОЖильцахСрезПоследних.ВладелецЕдинственногоЖилья, ЛОЖЬ) КАК ВладелецЕдинственногоЖилья,
		|	ЕСТЬNULL(КВП_СведенияОЖильцахСрезПоследних.ДополнительнаяПлощадь, 0) КАК ДополнительнаяПлощадь,
		|	ЕСТЬNULL(УПЖКХ_СобственникиПомещенийСрезПоследних.Действует, ЛОЖЬ) КАК Собственник,
		|	ЕСТЬNULL(УПЖКХ_СобственникиПомещенийСрезПоследних.ДоляСобственникаЧислитель, 0) КАК ДоляСобственностиЧислитель,
		|	ЕСТЬNULL(УПЖКХ_СобственникиПомещенийСрезПоследних.ДоляСобственникаЗнаменатель, 0) КАК ДоляСобственностиЗнаменатель,
		|	ЕСТЬNULL(УПЖКХ_СобственникиПомещенийСрезПоследних.ОснованиеПолученияВСобственность, ЗНАЧЕНИЕ(Справочник.УПЖКХ_ОснованияПолученияВСобственностьПомещений.ПустаяСсылка)) КАК ОснованиеПолученияВСобственность,
		|	ЕСТЬNULL(УПЖКХ_СобственникиПомещенийСрезПоследних.ВидДокумента, ЗНАЧЕНИЕ(Справочник.УПЖКХ_ДокументыНаПравоСобственности.ПустаяСсылка)) КАК ВидДокументаСобственности,
		|	ЕСТЬNULL(УПЖКХ_СобственникиПомещенийСрезПоследних.НомерДокумента, """") КАК НомерДокументаСобственности,
		|	ЕСТЬNULL(УПЖКХ_СобственникиПомещенийСрезПоследних.ДатаДокумента, ДАТАВРЕМЯ(1, 1, 1, 1, 1, 1)) КАК ДатаДокументаСобственности
		|ИЗ
		|	РегистрСведений.КВП_СведенияОЖильцах.СрезПоследних(&ТекущаяДата, Объект = &Объект) КАК КВП_СведенияОЖильцахСрезПоследних
		|		ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.УПЖКХ_СобственникиПомещений.СрезПоследних(
		|				&ТекущаяДата,
		|				Собственник = &ФизЛицо
		|					И Помещение = &Помещение) КАК УПЖКХ_СобственникиПомещенийСрезПоследних
		|		ПО КВП_СведенияОЖильцахСрезПоследних.Объект.ФизЛицо = УПЖКХ_СобственникиПомещенийСрезПоследних.Собственник
		|			И КВП_СведенияОЖильцахСрезПоследних.ЛицевойСчет.Адрес = УПЖКХ_СобственникиПомещенийСрезПоследних.Помещение";
		
		ЗапросДанных.УстановитьПараметр("Объект",    Объект);
		ЗапросДанных.УстановитьПараметр("ФизЛицо",   Объект.ФизЛицо);
		
	КонецЕсли;
	
	РезультатЗапроса = ЗапросДанных.Выполнить();
	
	Если РезультатЗапроса.Пустой() И НЕ Объект = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Объект = Неопределено Тогда
		ТаблицаДанных = РезультатЗапроса.Выгрузить();
	Иначе
		ВыборкаЗапроса  = РезультатЗапроса.Выбрать();
		Пока ВыборкаЗапроса.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(СтруктураДанных, ВыборкаЗапроса);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ?(Объект = Неопределено, ТаблицаДанных, СтруктураДанных);
	
КонецФункции

// Функция возвращает параметры проведения.
Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка,
	|	Реквизиты.Номер,
	|	Реквизиты.Дата,
	|	Реквизиты.ЛицевойСчет,
	|	Реквизиты.Контрагент,
	|	Реквизиты.Ответственный,
	|	Реквизиты.КоличествоПроживающих,
	|	Реквизиты.КоличествоЗарегистрированных,
	|	Реквизиты.ОтветственныйСобственник,
	|	Реквизиты.ВладелецКонтрагент,
	|	Реквизиты.ЛицевойСчет.Адрес КАК Помещение,
	|	Реквизиты.ЛицевойСчет.Адрес.ВидПомещения.ТипПомещения КАК ТипПомещения,
	|	Реквизиты.ВидОперации,
	|	Реквизиты.ВидИзменения,
	|	Реквизиты.ДокументОснование,
	|	Реквизиты.ОтветственныйСобственник.ФизЛицо КАК ФизЛицоОтветственногоСобственника
	|ИЗ
	|	Документ.КВП_ИзменениеЛицевогоСчета КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Реквизиты = Новый Структура("Ссылка,Номер,Дата,ЛицевойСчет,Контрагент,
								|ДокументОснование,Ответственный,КоличествоПроживающих,КоличествоЗарегистрированных,
								|ОтветственныйСобственник,ВладелецКонтрагент,Помещение,ТипПомещения,
								|ВидОперации,ВидИзменения");
	
	ЗаполнитьЗначенияСвойств(Реквизиты, Выборка);
	
	ПараметрыПроведения.Вставить("Реквизиты", Реквизиты);
	
	// Подготовим таблицу лицевых счетов.
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка,
	|	Реквизиты.Проживающий,
	|	Реквизиты.Проживающий.ФизЛицо КАК ФизЛицо,
	|	Реквизиты.Собственник,
	|	Реквизиты.Проживает,
	|	Реквизиты.Зарегистрирован,
	|	Реквизиты.ВладелецЕдинственногоЖилья,
	|	Реквизиты.ДополнительнаяПлощадь,
	|	Реквизиты.ДоляСобственностиЧислитель,
	|	Реквизиты.ДоляСобственностиЗнаменатель,
	|	Реквизиты.ДатаРегистрации,
	|	Реквизиты.ДатаЗаселения,
	|	Реквизиты.СтепеньРодства,
	|	Реквизиты.НомерСтроки,
	|	Реквизиты.ДатаОтменыИзменения,
	|	Реквизиты.СтатусЖильцаКакСобственника,
	|	Реквизиты.ДанныеПоЖильцуОПроживанииИлиСобственностиУжеБылиВведеныРанее,
	|	Реквизиты.ДатаВыбытия,
	|	Реквизиты.ОснованиеПолученияВСобственность,
	|	Реквизиты.ВидДокументаСобственности,
	|	Реквизиты.НомерДокументаСобственности,
	|	Реквизиты.ДатаДокументаСобственности
	|ИЗ
	|	Документ.КВП_ИзменениеЛицевогоСчета.Главная КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	
	ТаблицаЛицевыхСчетов = Запрос.Выполнить().Выгрузить();
	
	ПараметрыПроведения.Вставить("ТаблицаЛицевыхСчетов", ТаблицаЛицевыхСчетов);
	
	Возврат ПараметрыПроведения;
	
КонецФункции

#КонецОбласти

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//  КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли