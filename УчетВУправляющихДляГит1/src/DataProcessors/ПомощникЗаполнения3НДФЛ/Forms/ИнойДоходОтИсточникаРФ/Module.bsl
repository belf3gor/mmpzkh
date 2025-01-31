// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Перем ОтключитьЗаполнениеПоИНН;
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресКлючейПоказателей = Параметры.АдресКлючейПоказателей;
	
	КодыВидовДоходовРФ = Отчеты.РегламентированныйОтчет3НДФЛ.КодыВидовДоходовРФ(Параметры.Декларация3НДФЛВыбраннаяФорма);
	
	Если Параметры.Вид = Перечисления.ИсточникиДоходовФизическихЛиц.Дивиденды Тогда
		ВидДохода = "Дивиденды";
		Заголовок = НСтр("ru = 'Дивиденды от источника в РФ'");
	Иначе
		ВидДохода = "ПрочийДоход";
		Заголовок = НСтр("ru = 'Прочие доходы от источника в РФ'");
		
		Если Отчеты.РегламентированныйОтчет3НДФЛ.МожноНеУказыватьНаименованиеИсточникаДохода(Параметры.Декларация3НДФЛВыбраннаяФорма) Тогда
			Элементы.ВидКонтрагента.СписокВыбора.Добавить(Перечисления.ЮридическоеФизическоеЛицо.ПустаяСсылка(), НСтр("ru = 'Неизвестен'"));
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнениеРеквизитовПлашкой = Истина;
	
	Если Параметры.Свойство("СтруктураДоходовВычетов")
		И ЗначениеЗаполнено(Параметры.СтруктураДоходовВычетов) Тогда
		
		Параметры.СтруктураДоходовВычетов.Свойство("СтавкаНалога", СтавкаНалога);
		Параметры.СтруктураДоходовВычетов.Свойство("СуммаДохода", СуммаДохода);
		Параметры.СтруктураДоходовВычетов.Свойство("СуммаНалога", СуммаНалога);
		Параметры.СтруктураДоходовВычетов.Свойство("СуммаНалогаУдержанная", СуммаНалогаУдержанная);
		Параметры.СтруктураДоходовВычетов.Свойство("ВидКонтрагента", ВидКонтрагента);
		Параметры.СтруктураДоходовВычетов.Свойство("НаименованиеОперации", НаименованиеОперации);
		Параметры.СтруктураДоходовВычетов.Свойство("Наименование", Наименование);
		Параметры.СтруктураДоходовВычетов.Свойство("ФИО", ФИО);
		Параметры.СтруктураДоходовВычетов.Свойство("ИНН", ИНН);
		Параметры.СтруктураДоходовВычетов.Свойство("КПП", КПП);
		Параметры.СтруктураДоходовВычетов.Свойство("ОКТМО", ОКТМО);
		
		Если ЕстьКлючПоказателя("СуммаОблагаемогоДоходаРФ", АдресКлючейПоказателей) Тогда
			Параметры.СтруктураДоходовВычетов.Свойство("СуммаДоходаОблагаемая", СуммаДоходаОблагаемая);
		Иначе
			СуммаДоходаОблагаемая = СуммаДохода;
		КонецЕсли;
		
		ЗаполнениеРеквизитовПлашкой = НЕ ЗначениеЗаполнено(СуммаДохода);
		
	Иначе
		
		НалоговыеСтавки = Отчеты.РегламентированныйОтчет3НДФЛ.НалоговыеСтавки(Параметры.Декларация3НДФЛВыбраннаяФорма);
		Если ВидДохода = "Дивиденды" Тогда
			СтавкаНалога = НалоговыеСтавки.Дивиденды;
			ВидКонтрагента = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
		Иначе
			СтавкаНалога = НалоговыеСтавки.ПоУмолчанию;
			ВидКонтрагента = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
		КонецЕсли;
		
	КонецЕсли;
	
	ПомощникЗаполнения3НДФЛ.ИсточникДоходовПриСозданииНаСервере(ЭтотОбъект, ЗначениеЗаполнено(ВидКонтрагента));
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидКонтрагента = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо Тогда
		ПроверяемыеРеквизиты.Добавить("ИНН");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВидКонтрагента) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаименованиеОперации");
	КонецЕсли;
	
	ПомощникЗаполнения3НДФЛ.ПроверитьЗаполнениеРеквизитовИсточникаДоходов(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОрганизацииФормыДляОтчетности.ПроверитьКодПоОКТМОНаФорме(ОКТМО, "ОКТМО", Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидКонтрагентаПриИзменении(Элемент)
	
	// Очистим реквизиты, которые зависят от вида контрагента.
	Наименование = "";
	ФИО = "";
	ИНН = "";
	КПП = "";
	ОКТМО = "";
	
	ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Истина, Истина);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	ИНН = СокрЛП(ИНН);
	ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КПППриИзменении(Элемент)
	
	КПП = СокрЛП(КПП);
	ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Ложь, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПоискаИНННаименованиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ПолеПоискаИНННаименование)
		И НЕ ЗначениеЗаполнено(ИНН) 
		И НЕ ЗначениеЗаполнено(Наименование) Тогда
		
		ПомощникЗаполнения3НДФЛКлиент.ЗаполнитьРеквизитыПоДаннымЕГР(ПолеПоискаИНННаименование, ОповещениеПослеЗаполненияПоИНН());
		ОтключитьЗаполнениеПоИНН = Истина;
		ПодключитьОбработчикОжидания("Подключаемый_ВключитьЗаполнениеПоИНН", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтавкаНалогаПриИзменении(Элемент)
	
	ПриИзмененииСуммыДоходаОблагаемой();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаДоходаПриИзменении(Элемент)
	
	СуммаДоходаОблагаемая = СуммаДохода;
	ПриИзмененииСуммыДоходаОблагаемой();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаДоходаОблагаемаяПриИзменении(Элемент)
	
	ПриИзмененииСуммыДоходаОблагаемой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("Вид", ?(ВидДохода = "Дивиденды",
		ПредопределенноеЗначение("Перечисление.ИсточникиДоходовФизическихЛиц.Дивиденды"),
		ПредопределенноеЗначение("Перечисление.ИсточникиДоходовФизическихЛиц.ИнойДоходОтИсточникаРФ")));
	
	СтруктураРезультата.Вставить("КодВидаДохода", ?(ВидДохода = "Дивиденды", 
		КодыВидовДоходовРФ.Дивиденды,
		КодыВидовДоходовРФ.ИнойДоходОтИсточникаРФ));
	
	СтруктураРезультата.Вставить("Информация", ?(ВидДохода = "Дивиденды",
		НСтр("ru = 'Дивиденды от источника в РФ'"),
		НСтр("ru = 'Прочие доходы от источника в РФ'")));
	
	СтруктураРезультата.Вставить("СтавкаНалога", СтавкаНалога);
	СтруктураРезультата.Вставить("СуммаДохода", СуммаДохода);
	СтруктураРезультата.Вставить("СуммаДоходаОблагаемая", СуммаДоходаОблагаемая);
	СтруктураРезультата.Вставить("СуммаНалога", СуммаНалога);
	СтруктураРезультата.Вставить("СуммаНалогаУдержанная", СуммаНалогаУдержанная);
	СтруктураРезультата.Вставить("ВидКонтрагента", ВидКонтрагента);
	СтруктураРезультата.Вставить("НаименованиеОперации", НаименованиеОперации);
	СтруктураРезультата.Вставить("Наименование", Наименование);
	СтруктураРезультата.Вставить("ФИО", ФИО);
	СтруктураРезультата.Вставить("ИНН", ИНН);
	СтруктураРезультата.Вставить("КПП", КПП);
	СтруктураРезультата.Вставить("ОКТМО", ОКТМО);
	
	Если ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо") Тогда
		НаименованиеИсточникаДохода = ФИО;
	ИначеЕсли ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо") Тогда
		НаименованиеИсточникаДохода = Наименование;
	Иначе
		НаименованиеИсточникаДохода = НаименованиеОперации;
	КонецЕсли;
	
	СтруктураРезультата.Вставить("НаименованиеИсточникаДохода", НаименованиеИсточникаДохода);
	
	Закрыть(СтруктураРезультата);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьПоИНН(Команда)
	
	Если НЕ ЗначениеЗаполнено(ИНН) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Поле ""ИНН"" не заполнено'"));
		ТекущийЭлемент = Элементы.ИНН;
		Возврат;
	ИначеЕсли НЕ ОшибокПоИННнет Тогда
		ПоказатьПредупреждение(, Строка(РезультатПроверкиИНН));
		ТекущийЭлемент = Элементы.ИНН;
		Возврат;
	КонецЕсли;
	
	ПомощникЗаполнения3НДФЛКлиент.ВыполнитьЗаполнениеРеквизитовПоИНН(ИНН, ОповещениеПослеЗаполненияПоИНН());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоДаннымЕГР(Команда)
	
	Если ОтключитьЗаполнениеПоИНН <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПомощникЗаполнения3НДФЛКлиент.ЗаполнитьРеквизитыПоДаннымЕГР(ПолеПоискаИНННаименование, ОповещениеПослеЗаполненияПоИНН());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоНаименованию(Команда)
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Поле ""Наименование"" не заполнено'"));
		ТекущийЭлемент = Элементы.Наименование;
		Возврат;
	Иначе
		ПомощникЗаполнения3НДФЛКлиент.ВыполнитьЗаполнениеРеквизитовПоНаименованию(Наименование, ОповещениеПослеЗаполненияПоИНН());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьКлючСохраненияПоложенияОкна(Форма)
	
	ПрефиксКлючаСохранения = "ПрочиеДоходы";
	Если Форма.ВидДохода = "Дивиденды" Тогда
		ПрефиксКлючаСохранения = "ДивидендыРФ";
	КонецЕсли;
	
	ПомощникЗаполнения3НДФЛКлиентСервер.УстановитьКлючСохраненияПоложенияОкна(Форма, ПрефиксКлючаСохранения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСуммыДоходаОблагаемой()
	
	СуммаНалога = Окр(СуммаДоходаОблагаемая * СтавкаНалога / 100, 0);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	ВидДоходаДивиденды = (Форма.ВидДохода = "Дивиденды");
	ВидДоходаПрочие    = Не ВидДоходаДивиденды;
	
	Элементы.ДекорацияОписаниеДивиденды.Видимость = ВидДоходаДивиденды;
	Элементы.ДекорацияОписаниеПрочее.Видимость = ВидДоходаПрочие;
	Элементы.ВидКонтрагента.Видимость = ВидДоходаПрочие;
	Элементы.СтавкаНалога.Видимость = ВидДоходаПрочие;
	
	Элементы.Наименование.Заголовок = ?(ВидДоходаДивиденды, НСтр("ru = 'Источник дохода'"), НСтр("ru = 'Наименование'"));
	Элементы.НаименованиеОперации.Видимость = Не ЗначениеЗаполнено(Форма.ВидКонтрагента);
	
	ПомощникЗаполнения3НДФЛКлиентСервер.УстановитьВидимостьПолейКонтрагента(Форма, ЗначениеЗаполнено(Форма.ВидКонтрагента));
	
	Элементы.ИНН.ОтметкаНезаполненного = Ложь;
	Элементы.ИНН.АвтоОтметкаНезаполненного =
		(Форма.ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо"));
	
	Если ЕстьКлючПоказателя("СуммаОблагаемогоДоходаРФ", Форма.АдресКлючейПоказателей) Тогда
		Элементы.СуммаДоходаОблагаемая.Видимость = Истина;
		Элементы.СуммаНалога.Видимость = Истина;
		Элементы.ДекорацияОписаниеДивиденды.Заголовок = НСтр("ru = 'Декларируется, если при выплате дивидендов налоговый агент не удержал налог в полном объеме. Налоговую базу и сумму налога можно определить по данным справки 2-НДФЛ. Вычеты к таким доходам не применяются.'");
		Элементы.ДекорацияОписаниеПрочее.Заголовок = НСтр("ru = 'Декларируется, если при выплате дохода налоговый агент не удержал налог в полном объеме. Налоговую базу и сумму налога можно определить по данным справки 2-НДФЛ.'");
	Иначе
		Элементы.СуммаДоходаОблагаемая.Видимость = Ложь;
		Элементы.СуммаНалога.Видимость = Ложь;
		Элементы.ДекорацияОписаниеДивиденды.Заголовок = НСтр("ru = 'Декларируется, если при выплате дивидендов налоговый агент не удержал налог в полном объеме. Удержанную сумму налога можно определить по данным справки 2-НДФЛ. Вычеты к таким доходам не применяются.'");
		Элементы.ДекорацияОписаниеПрочее.Заголовок = НСтр("ru = 'Декларируется, если при выплате дохода налоговый агент не удержал налог в полном объеме. Удержанную сумму налога можно определить по данным справки 2-НДФЛ.'");
	КонецЕсли;
	
	УстановитьКлючСохраненияПоложенияОкна(Форма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьКлючПоказателя(Знач ИмяКлюча, Знач АдресКлючейПоказателей)
	
	Возврат Отчеты.РегламентированныйОтчет3НДФЛ.ЕстьКлючПоказателя(ИмяКлюча, АдресКлючейПоказателей);
	
КонецФункции

#Область ЗаполнениеРеквизитовКонтрагента

&НаКлиенте
Функция ОповещениеПослеЗаполненияПоИНН()
	
	Возврат Новый ОписаниеОповещения("ПослеЗаполненияПоИНН", ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ПослеЗаполненияПоИНН(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Результат);
		ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Истина, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВключитьЗаполнениеПоИНН()
	
	ОтключитьЗаполнениеПоИНН = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти