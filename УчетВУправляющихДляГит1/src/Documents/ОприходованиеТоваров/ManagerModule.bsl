#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 7, 0);
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область СчетаУчета

Процедура УстановитьПравилаЗаполненияСчетовУчета(Правила) Экспорт
	
	СчетаУчетаВДокументах.ДобавитьПравилоЗаполнения(Правила, "Товары", "СчетУчета",    "ЗапасыКромеЗабалансовых");
	СчетаУчетаВДокументах.ДобавитьВПравилоИсточникДанныхРеквизитОбъекта(Правила, "Номенклатура", "Номенклатура");
	
	СчетаУчетаВДокументах.ДобавитьВПравилоОписаниеРеквизитаДокумента(Правила, "Дата");
	СчетаУчетаВДокументах.ДобавитьВПравилоОписаниеРеквизитаДокумента(Правила, "Организация");
	СчетаУчетаВДокументах.ДобавитьВПравилоОписаниеРеквизитаДокумента(Правила, "Склад");
	
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

// Устарела: Следует использовать ЗаполнитьПередЗаписью(), 
// ЗаполнитьПередОтображениемПользователю(), Заполнить(), 
// ЗаполнитьОбъектПриИзменении(), ЗаполнитьСтроки(),
// либо перед записью документа устанавливать дополнительное свойство 
// ЗаполнитьСчетаУчетаПередЗаписью
//
Процедура ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, ИмяТабличнойЧасти) Экспорт

	СчетаУчетаВДокументах.ЗаполнитьСчетаУчетаВТабличнойЧасти(
		Объект,
		ИмяТабличнойЧасти);

КонецПроцедуры

// Устарела: Следует использовать ЗаполнитьПередЗаписью(), 
// ЗаполнитьПередОтображениемПользователю(), Заполнить(), 
// ЗаполнитьОбъектПриИзменении(), ЗаполнитьСтроки(),
// либо перед записью документа устанавливать дополнительное свойство 
// ЗаполнитьСчетаУчетаПередЗаписью
//
// Заполняет счета учета номенклатуры в строке табличной части документа
//
// Параметры:
//  Объект                - ДокументОбъект или соответствующие данные формы
//  СтрокаТабличнойЧасти  - строка табличной части документа
//  ИмяТабличнойЧасти     - имя табличной части документа
//  СведенияОНоменклатуре - оставлен для совместимости; не используется
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(Объект, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СведенияОНоменклатуре = Неопределено) Экспорт

	СчетаУчетаВДокументах.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
		Объект,
		СтрокаТабличнойЧасти,
		ИмяТабличнойЧасти);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

Функция ТекстЗапросаДанныеДляОбновленияЦенДокументов() Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОприходованиеТоваровТовары.Номенклатура КАК Номенклатура,
	|	ОприходованиеТоваровТовары.Цена КАК Цена,
	|	&Валюта КАК Валюта,
	|	&СпособЗаполненияЦены,
	|	&ЦенаВключаетНДС
	|ПОМЕСТИТЬ ТаблицаНоменклатуры
	|ИЗ
	|	Документ.ОприходованиеТоваров.Товары КАК ОприходованиеТоваровТовары
	|ГДЕ
	|	ОприходованиеТоваровТовары.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Цена,
	|	Валюта";
	
	ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
	Возврат ТекстЗапроса;
	
КонецФункции

// ПОДГОТОВКА ПАРАМЕТРОВ ПРОВЕДЕНИЯ ДОКУМЕНТА

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.Склад.ТипСклада КАК ТипСклада
	|ИЗ
	|	Документ.ОприходованиеТоваров КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Если НЕ УчетнаяПолитика.Существует(Выборка.Организация, Выборка.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;
	
	ПлательщикНДС					 = УчетнаяПолитика.ПлательщикНДС(Выборка.Организация, Выборка.Период);
	ПрименяетсяУСН					 = УчетнаяПолитика.ПрименяетсяУСН(Выборка.Организация, Выборка.Период);
	ПрименяетсяУСНДоходыМинусРасходы = УчетнаяПолитика.ПрименяетсяУСНДоходыМинусРасходы(Выборка.Организация, Выборка.Период);
	ПлательщикНДФЛ					 = УчетнаяПолитика.ПлательщикНДФЛ(Выборка.Организация, Выборка.Период);
	ВестиУчетПоВидамДеятельностиИП	 = УчетнаяПолитика.ВестиУчетПоВидамДеятельностиИП(Выборка.Организация, Выборка.Период);
	ОсновнаяНоменклатурнаяГруппа	 = УчетнаяПолитика.ОсновнаяНоменклатурнаяГруппа(Выборка.Организация, Выборка.Период);
	СпособОценкиТоваровВРознице		 = УчетнаяПолитика.СпособОценкиТоваровВРознице(Выборка.Организация, Выборка.Период);
	
	Запрос.УстановитьПараметр("ПлательщикНДС",	                  ПлательщикНДС);
	Запрос.УстановитьПараметр("ПрименяетсяУСН",	                  ПрименяетсяУСН);
	Запрос.УстановитьПараметр("ПрименяетсяУСНДоходыМинусРасходы", ПрименяетсяУСНДоходыМинусРасходы);
	Запрос.УстановитьПараметр("ПлательщикНДФЛ",	                  ПлательщикНДФЛ);
	
	Запрос.УстановитьПараметр("ВестиУчетПоВидамДеятельностиИП",	ВестиУчетПоВидамДеятельностиИП);
	Запрос.УстановитьПараметр("ОсновнаяНоменклатурнаяГруппа",	ОсновнаяНоменклатурнаяГруппа);
	Запрос.УстановитьПараметр("СпособОценкиТоваровВРознице",	СпособОценкиТоваровВРознице);
	
	Запрос.УстановитьПараметр("СинонимТовары",	НСтр("ru = 'Товары'"));
	Запрос.УстановитьПараметр("ТипСклада",		Выборка.ТипСклада);
	
	Запрос.УстановитьПараметр("Счета10", БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.Материалы));
	Запрос.УстановитьПараметр("ВалютаРеглУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	
	ОтражатьВРасходахУСН = (Выборка.Период >= '20130101') И ПрименяетсяУСНДоходыМинусРасходы
							И Не (Выборка.ТипСклада = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка И СпособОценкиТоваровВРознице = Перечисления.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости);
	Запрос.УстановитьПараметр("ОтражатьВРасходахУСН", ОтражатьВРасходахУСН);						
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст	= ТекстЗапросаВременныеТаблицыДокумента(НомераТаблиц)
					+ ТекстЗапросаОприходованиеТоваров(НомераТаблиц)
					+ ТекстЗапросаОприходованиеТоваровТорговаяНаценка(НомераТаблиц)
					+ ТекстЗапросаОприходованиеТоваровНДС(НомераТаблиц)
					+ ТекстЗапросаОприходованиеТоваровУСН(НомераТаблиц)
					+ ТекстЗапросаКнигаУчетаДоходовИРасходовУСН(НомераТаблиц)
					+ ТекстЗапросаОприходованиеТоваровИП(НомераТаблиц)
					+ ТекстЗапросаРегистрацияОтложенныхРасчетовВПоследовательности(НомераТаблиц, ПараметрыПроведения, Выборка);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;

	Возврат ПараметрыПроведения;

КонецФункции 

Функция ТекстЗапросаВременныеТаблицыДокумента(НомераТаблиц)

	НомераТаблиц.Вставить("ВременнаяТаблицаТовары", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаТовары.Ссылка,
	|	ТаблицаТовары.НомерСтроки,
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Количество,
	|	ТаблицаТовары.Цена,
	|	ТаблицаТовары.Сумма,
	|	ТаблицаТовары.ЦенаВРознице,
	|	ТаблицаТовары.СуммаВРознице,
	|	ТаблицаТовары.СтавкаНДСВРознице,
	|	ТаблицаТовары.СчетУчета,
	|	ТаблицаТовары.СчетУчета.Забалансовый КАК СчетУчетаЗабалансовый,
	|	ТаблицаТовары.ОтражениеВУСН,
	|	ТаблицаТовары.СтранаПроисхождения,
	|	ТаблицаТовары.НомерГТД
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	Документ.ОприходованиеТоваров.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаОприходованиеТоваров(НомераТаблиц)

	НомераТаблиц.Вставить("ОприходованиеТоваровРеквизиты",		НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ОприходованиеТоваровТаблицаТовары",	НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение,
	|	Реквизиты.Склад КАК Склад,
	|	Реквизиты.ИнвентаризацияТоваровНаСкладе КАК ИнвентаризацияТоваровНаСкладе,
	|	Реквизиты.СтатьяПрочихДоходовРасходов КАК СтатьяПрочихДоходовРасходов
	|ИЗ
	|	Документ.ОприходованиеТоваров КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""Товары"" КАК ИмяСписка,
	|	&СинонимТовары КАК СинонимСписка,
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Количество КАК Количество,
	|	ТаблицаТовары.Сумма КАК Сумма,
	|	ТаблицаТовары.СтавкаНДСВРознице КАК СтавкаНДСВРознице,
	|	ТаблицаТовары.СчетУчета КАК СчетУчета
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаТовары.НомерСтроки";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаОприходованиеТоваровТорговаяНаценка(НомераТаблиц)

	НомераТаблиц.Вставить("ОприходованиеТоваровТорговаяНаценкаРеквизиты",		НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ОприходованиеТоваровТорговаяНаценкаТаблицаТовары",	НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение,
	|	Реквизиты.Склад КАК Склад,
	|	Реквизиты.Склад.ТипСклада КАК ТипСклада,
	|	Реквизиты.Склад.ТипЦенРозничнойТорговли КАК ТипЦенРозничнойТорговли
	|ИЗ
	|	Документ.ОприходованиеТоваров КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""Товары"" КАК ИмяСписка,
	|	&СинонимТовары КАК СинонимСписка,
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Количество КАК Количество,
	|	ТаблицаТовары.Сумма КАК СуммаБУ,
	|	ТаблицаТовары.ЦенаВРознице КАК ЦенаВРознице,
	|	ТаблицаТовары.СтавкаНДСВРознице КАК СтавкаНДСВРознице,
	|	ТаблицаТовары.СуммаВРознице КАК СуммаВРознице,
	|	НЕОПРЕДЕЛЕНО КАК СпособУчетаНДС,
	|	0 КАК СуммаНДСРуб,
	|	ТаблицаТовары.СчетУчета КАК СчетУчета
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	&СпособОценкиТоваровВРознице = ЗНАЧЕНИЕ(Перечисление.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости)
	|	И &ТипСклада <> ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.ОптовыйСклад)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаТовары.НомерСтроки";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаОприходованиеТоваровНДС(НомераТаблиц)

	НомераТаблиц.Вставить("РеквизитыНДС", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ТоварыНДС",    НомераТаблиц.Количество());
	НомераТаблиц.Вставить("НомераГТД",    НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.Склад КАК Склад,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение
	|ИЗ
	|	Документ.ОприходованиеТоваров КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.СчетУчета КАК СчетУчета,
	|	ТаблицаТовары.Количество КАК Количество
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	&ПлательщикНДС
	|	И НЕ ТаблицаТовары.СчетУчета.Забалансовый
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.СчетУчета КАК СчетУчета,
	|	ТаблицаТовары.НомерГТД КАК НомерГТД,
	|	ТаблицаТовары.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ТаблицаТовары.Количество КАК Количество
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.НомерГТД <> ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)
	|	И НЕ ТаблицаТовары.СчетУчета.Забалансовый
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаКнигаУчетаДоходовИРасходовУСН(НомераТаблиц)

	НомераТаблиц.Вставить("РеквизитыУСН", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Номер КАК Номер,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация,
	|	0 КАК СтрокаДокумента,
	|	СУММА(ТаблицаТовары.Сумма) КАК Графа4,
	|	ВЫБОР
	|		КОГДА Реквизиты.СтатьяПрочихДоходовРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения)
	|			ТОГДА 0
	|		ИНАЧЕ СУММА(ТаблицаТовары.Сумма)
	|	КОНЕЦ КАК Графа5,
	|	0 КАК Графа6,
	|	0 КАК Графа7,
	|	0 КАК НДС,
	|	НЕОПРЕДЕЛЕНО КАК НомерГТД,
	|	Реквизиты.ИнвентаризацияТоваровНаСкладе КАК ИнвентаризацияТоваровНаСкладе
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОприходованиеТоваров КАК Реквизиты
	|		ПО (Реквизиты.Ссылка = &Ссылка)
	|ГДЕ
	|	&ПрименяетсяУСН
	|
	|СГРУППИРОВАТЬ ПО
	|	Реквизиты.Ссылка,
	|	Реквизиты.Дата,
	|	Реквизиты.Организация,
	|	Реквизиты.ИнвентаризацияТоваровНаСкладе,
	|	Реквизиты.СтатьяПрочихДоходовРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаОприходованиеТоваровУСН(НомераТаблиц)

	НомераТаблиц.Вставить("РеквизитыПоступлениеРасходовУСН", НомераТаблиц.Количество());
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация,
	|	НЕОПРЕДЕЛЕНО КАК ДоговорКонтрагента,
	|	&ВалютаРеглУчета КАК Валюта,
	|	ЛОЖЬ КАК УчетАгентскогоНДС,
	|	ИСТИНА КАК ЭтоВозврат,
	|	ЛОЖЬ КАК РасходыПредпринимателя
	|ИЗ
	|	Документ.ОприходованиеТоваров КАК Реквизиты
	|ГДЕ
	|	&ОтражатьВРасходахУСН
	|	И Реквизиты.Ссылка = &Ссылка"
	+ ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
	НомераТаблиц.Вставить("УСНТаблицаРасходов", НомераТаблиц.Количество());
	ТекстЗапроса = ТекстЗапроса +
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыРасходовУСН.Номенклатура) КАК ВидРасхода,
	|	ЗНАЧЕНИЕ(Перечисление.СтатусыПартийУСН.Купленные) КАК СтатусыПартийУСН,
	|	ТаблицаТовары.СчетУчета,
	|	ТаблицаТовары.Ссылка КАК Партия,
	|	ТаблицаТовары.Номенклатура КАК ЭлементРасхода,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СчетУчета В (&Счета10)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЭтоТовар,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СчетУчета В (&Счета10)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоМатериал,
	|	ТаблицаТовары.ОтражениеВУСН,
	|	ТаблицаТовары.Количество,
	|	ТаблицаТовары.Сумма,
	|	0 КАК НДС
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	НЕ ТаблицаТовары.СчетУчетаЗабалансовый
	|	И &ОтражатьВРасходахУСН"
	;

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции // ТекстЗапросаОприходованиеТоваровУСН()

Функция ТекстЗапросаОприходованиеТоваровИП(НомераТаблиц)
	
	НомераТаблиц.Вставить("ОприходованиеТоваровИПРеквизиты", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ОприходованиеТоваровИПТаблица",   НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.Склад.ТипСклада КАК ТипСклада,
	|	Реквизиты.СтатьяПрочихДоходовРасходов КАК СтатьяДоходов,
	|	Реквизиты.СтатьяПрочихДоходовРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат КАК ВидДеятельностиДляНалоговогоУчетаЗатрат,
	|	ЕСТЬNULL(Реквизиты.СтатьяПрочихДоходовРасходов.ПринятиеКналоговомуУчету, ЛОЖЬ) КАК ПринятиеКналоговомуУчету
	|ИЗ
	|	Документ.ОприходованиеТоваров КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""Товары"" КАК ИмяСписка,
	|	&СинонимТовары КАК СинонимСписка,
	|	ТаблицаТовары.НомерСтроки,
	|	ТаблицаТовары.Номенклатура,
	|	ВЫБОР
	|		КОГДА НЕ &ВестиУчетПоВидамДеятельностиИП
	|			ТОГДА &ОсновнаяНоменклатурнаяГруппа
	|		ИНАЧЕ ТаблицаТовары.Номенклатура.НоменклатурнаяГруппа
	|	КОНЕЦ КАК НоменклатурнаяГруппа,
	|	ТаблицаТовары.Ссылка КАК Партия,
	|	ТаблицаТовары.Ссылка КАК ДокументОплаты,
	|	ТаблицаТовары.Количество КАК Количество,
	|	ТаблицаТовары.Сумма КАК Сумма,
	|	ТаблицаТовары.СчетУчета
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	&ПлательщикНДФЛ
	|	И НЕ(&СпособОценкиТоваровВРознице = ЗНАЧЕНИЕ(Перечисление.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости)
	|				И &ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.НеавтоматизированнаяТорговаяТочка))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаТовары.НомерСтроки";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
		
КонецФункции

Процедура ДобавитьКолонкуСодержание(ТаблицаЗначений) Экспорт

	Если ТаблицаЗначений.Колонки.Найти("Содержание") = Неопределено Тогда
		ТаблицаЗначений.Колонки.Добавить("Содержание", ОбщегоНазначения.ОписаниеТипаСтрока(150));
	КонецЕсли;

	Для каждого СтрокаТаблицы Из ТаблицаЗначений Цикл
		Содержание = "Оприходование излишков %1";
		Содержание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Содержание, 
			БухгалтерскийУчетПовтИсп.НазваниеОбъектаПоСчетуУчета(СтрокаТаблицы.СчетУчета));
		СтрокаТаблицы.Содержание = Содержание;
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьКолонкуСодержаниеУСН(ТаблицаЗначений) Экспорт

	Если ТаблицаЗначений.Колонки.Найти("Содержание") = Неопределено Тогда
		ТаблицаЗначений.Колонки.Добавить("Содержание", ОбщегоНазначения.ОписаниеТипаСтрока(300));
	КонецЕсли;

	Для каждого СтрокаТаблицы Из ТаблицаЗначений Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ИнвентаризацияТоваровНаСкладе) Тогда
			СтрокаТаблицы.Содержание = "Оприходованы излишки ТМЦ.";
		Иначе
			Содержание = "Оприходованы излишки, выявленные при проведении %1";
			Содержание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Содержание,
				ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(
					СтрокаТаблицы.ИнвентаризацияТоваровНаСкладе,
					"инвентаризации"));
			СтрокаТаблицы.Содержание = Содержание;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

// ОТЛОЖЕННОЕ ПРОВЕДЕНИЕ

Функция ТекстЗапросаРегистрацияОтложенныхРасчетовВПоследовательности(НомераТаблиц, ПараметрыПроведения, Реквизиты)

	Если НЕ ПроведениеСервер.ИспользуетсяОтложенноеПроведение(Реквизиты.Организация, Реквизиты.Период) Тогда
		ПараметрыПроведения.Вставить("ТаблицаРегистрации", Неопределено);
		Возврат "";
	КонецЕсли;
	
	НомераТаблиц.Вставить("ТаблицаРегистрации", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаТовары.СчетУчета,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК КорСчетСписания
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Накладная на оприходование товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Накладная";
	КомандаПечати.Представление = НСтр("ru = 'Накладная на оприходование товаров'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Реестр документов ""Оприходование товаров""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;

КонецПроцедуры

// Формирует и возвращает текст запроса для выборки данных,
// необходимых для формирования печатной формы
Функция ПолучитьТекстЗапросаДляФормированияПечатнойФормыНакладная()

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ОприходованиеТоваров.Ссылка,
	|	ОприходованиеТоваров.Номер,
	|	ОприходованиеТоваров.Дата,
	|	ОприходованиеТоваров.Организация,
	|	ОприходованиеТоваров.ПодразделениеОрганизации,
	|	ОприходованиеТоваров.СуммаДокумента,
	|	Константы.ВалютаРегламентированногоУчета КАК ВалютаДокумента,
	|	ОприходованиеТоваров.Товары.(
	|		НомерСтроки,
	|		Номенклатура,
	|		Номенклатура.НаименованиеПолное КАК Товар,
	|		ВЫБОР
	|			КОГДА &ДополнительнаяКолонкаПечатныхФормДокументов = ЗНАЧЕНИЕ(Перечисление.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул)
	|				ТОГДА ОприходованиеТоваров.Товары.Номенклатура.Артикул
	|			КОГДА &ДополнительнаяКолонкаПечатныхФормДокументов = ЗНАЧЕНИЕ(Перечисление.ДополнительнаяКолонкаПечатныхФормДокументов.Код)
	|				ТОГДА ОприходованиеТоваров.Товары.Номенклатура.Код
	|			КОГДА &ДополнительнаяКолонкаПечатныхФормДокументов = ЗНАЧЕНИЕ(Перечисление.ДополнительнаяКолонкаПечатныхФормДокументов.НеВыводить)
	|				ТОГДА """"
	|		КОНЕЦ КАК КодАртикул,
	|		КоличествоМест,
	|		Количество,
	|		ЕдиницаИзмерения.Представление КАК ЕдиницаИзмерения,
	|		Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаХранения,
	|		Цена,
	|		Сумма
	|	)
	|ИЗ
	|	Документ.ОприходованиеТоваров КАК ОприходованиеТоваров,
	|	Константы КАК Константы
	|ГДЕ
	|	ОприходованиеТоваров.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОприходованиеТоваров.Дата,
	|	ОприходованиеТоваров.Ссылка,
	|	ОприходованиеТоваров.Товары.НомерСтроки";

	Возврат ТекстЗапроса;

КонецФункции

// Функция формирует табличный документ с печатной формой накладной,
// разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьОприходованияТоваров(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ОприходованиеТоваров_Накладная";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОприходованиеТоваров.ПФ_MXL_Накладная");
	
	ДополнительнаяКолонкаПечатныхФормДокументов = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если НЕ ЗначениеЗаполнено(ДополнительнаяКолонкаПечатныхФормДокументов) Тогда
		ДополнительнаяКолонкаПечатныхФормДокументов = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.НеВыводить;
	КонецЕсли;
	ВыводитьКоды = ДополнительнаяКолонкаПечатныхФормДокументов <> Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.НеВыводить;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ДополнительнаяКолонкаПечатныхФормДокументов", ДополнительнаяКолонкаПечатныхФормДокументов);
	Запрос.Текст = ПолучитьТекстЗапросаДляФормированияПечатнойФормыНакладная();
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

		// Выводим шапку накладной

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Шапка, "Оприходование товаров");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		
		СведенияОбОрганизации    = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата);
		ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
		ОбластьМакета.Параметры.ПредставлениеПолучателя = ПредставлениеОрганизации;
		ОбластьМакета.Параметры.Получатель = Шапка.Организация;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Вывести табличную часть
		ВыборкаСтрокТовары = Шапка.Товары.Выбрать();
		
		ОбластьШапки = ?(ВыводитьКоды, "ШапкаСКодом", "ШапкаТаблицы");
		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьШапки);
		Если ДополнительнаяКолонкаПечатныхФормДокументов = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
			ОбластьМакета.Параметры.ИмяКодАртикул = "Артикул";
		ИначеЕсли ДополнительнаяКолонкаПечатныхФормДокументов = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
			ОбластьМакета.Параметры.ИмяКодАртикул = "Код";
		КонецЕсли;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьСтроки = ?(ВыводитьКоды,	"СтрокаСКодом", "Строка");
		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьСтроки);
		
		Пока ВыборкаСтрокТовары.Следующий() Цикл
			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		// Вывести Итого
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		ОбластьМакета.Параметры.Всего = ОбщегоНазначенияБПВызовСервера.ФорматСумм(Шапка.СуммаДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Вывести Сумму прописью
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		ОбластьМакета.Параметры.ИтоговаяСтрока = "Всего наименований " + ВыборкаСтрокТовары.Количество()
			+ ", на сумму " + ОбщегоНазначенияБПВызовСервера.ФорматСумм(Шапка.СуммаДокумента, Шапка.ВалютаДокумента);
		ОбластьМакета.Параметры.СуммаПрописью = ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(Шапка.СуммаДокумента, Шапка.ВалютаДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Вывести подписи
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
		                                               НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции // ПечатьОприходованияТоваров()

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Проверяем, нужно ли для макета Накладная формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Накладная", "Накладная на оприходование товаров",
			ПечатьОприходованияТоваров(МассивОбъектов, ОбъектыПечати), , "Документ.ОприходованиеТоваров.ПФ_MXL_Накладная");
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	

КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Склад");
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли