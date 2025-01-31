#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПолучитьДанныеСверкиВФоне(Параметры, АдресХранилища) Экспорт
	
	Результат = Новый Структура("ДанныеПоследнейСверки, ОплатыСоСтатусами");
	Результат.ДанныеПоследнейСверки = ДанныеПоследнейСверки(Параметры.Организация, Параметры.Год);
	Результат.ОплатыСоСтатусами = ДанныеОбОплатахНалоговСоСтатусами(Параметры.Организация, Параметры.Год);
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры

Процедура ОбработатьДанныеФНС(Ссылка, Данные) Экспорт
	
	ДанныеВыписки = РазобратьВыпискуОперацийВФорматеXML(Данные);
	ДанныеЗапросаИОН = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Организация, ДатаНачалаПериода");
	ЗаписатьДанныеФНСОбОплатахНалоговВРегистр(
		ДанныеЗапросаИОН.Организация,
		Год(ДанныеЗапросаИОН.ДатаНачалаПериода),
		ДанныеВыписки);
	
КонецПроцедуры

Функция ПоказательНеобходимостиПроверкиОплатНалогов(Организация, Дата) Экспорт

	ТаблицаДанных = ПерсонализированныеПредложенияСервисов.ТаблицаДанных();
	
	ТребуетсяПроверкаТекущегоГода = Ложь;
	ДанныеДокумента = ДанныеДокументаНеПрошедшегоСверку(Организация, Дата);
	Если ДанныеДокумента <> Неопределено И ЗначениеЗаполнено(ДанныеДокумента.ДатаОплаты) Тогда
		КоличествоДнейПослеОплаты = КоличествоРабочихДней(ДанныеДокумента.ДатаОплаты, Дата);
		ТребуетсяПроверкаТекущегоГода = (КоличествоДнейПослеОплаты > МаксимальноеКоличествоДнейДоОтраженияПлатежаВФНС());
	Иначе
		ТребуетсяПроверкаТекущегоГода = Ложь;
	КонецЕсли;
	
	// Прошлый год
	ТребуетсяПроверкаПрошлогоГода = Ложь;
	ПрошлыйГод = Год(Дата) - 1;
	Если ПрошлыйГод >= ГодНачалаРаботыСервисаПроверкиОплаты() Тогда
		
		ДатаПроверки = ДатаПоследнейПроверкиПрошлогоГода(Организация, Дата);
		
		// Если прошлый год проверяли спустя 10 дней после начала нового года, заново делать запрос выписки уже не имеет смысла.
		Если КоличествоРабочихДней(НачалоГода(Дата), ДатаПроверки) <= МаксимальноеКоличествоДнейДоОтраженияПлатежаВФНС() Тогда
			
			ДанныеДокумента = ДанныеДокументаНеПрошедшегоСверку(Организация, НачалоГода(Дата) - 1, Истина);
			Если ДанныеДокумента <> Неопределено И ЗначениеЗаполнено(ДанныеДокумента.ДатаОплаты) Тогда
				КоличествоДнейПослеОплаты = КоличествоРабочихДней(ДанныеДокумента.ДатаОплаты, Дата);
				ТребуетсяПроверкаТекущегоГода = (КоличествоДнейПослеОплаты > МаксимальноеКоличествоДнейДоОтраженияПлатежаВФНС());
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТребуетсяПроверкаТекущегоГода И ТребуетсяПроверкаПрошлогоГода Тогда
		ЗначениеПоказателя = ЗначениеТребуетсяПроверкаТекущегоИПрошлогоГодов();
	ИначеЕсли ТребуетсяПроверкаПрошлогоГода Тогда
		ЗначениеПоказателя = ЗначениеТребуетсяПроверкаПрошлогоГода()
	ИначеЕсли ТребуетсяПроверкаТекущегоГода Тогда
		ЗначениеПоказателя = ЗначениеТребуетсяПроверкаТекущегоГода();
	Иначе
		ЗначениеПоказателя = ЗначениеПроверкаНеТребуется();
	КонецЕсли;
	
	// Добавляем итог по разделу
	СтрокаДанных = ТаблицаДанных.Добавить();
	СтрокаДанных.Порядок            = 0;
	СтрокаДанных.ЗначениеПоказателя = ЗначениеПоказателя;
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ПоказатьБаннерПроверкаОплатыНалогов(Организация, ДатаЗакрытияБаннера, ЗначениеПоказателя) Экспорт
	
	Если ЗначениеПоказателя = ЗначениеПроверкаНеТребуется() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПоОрганизацииОтправленЗапросНаСверку(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекущаяДата = ОбщегоНазначения.ТекущаяДатаПользователя();
	
	//Если баннер был закрыт, покажем в следующем месяце.
	Если ЗначениеЗаполнено(ДатаЗакрытияБаннера) Тогда
		Возврат НачалоМесяца(ДатаЗакрытияБаннера) <> НачалоМесяца(ТекущаяДата);
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

#Область Печать

Функция ПечатьРасшифровкиСостоянияОплатыНалога(ДанныеОплаты) Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;
	Макет = Обработки.СверкаНалоговСФНС.ПолучитьМакет("СостояниеПлатежа");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СписаниеСРасчетногоСчета.Организация.НаименованиеСокращенное КАК Организация,
	|	СписаниеСРасчетногоСчета.Организация.ИНН КАК ОрганизацияИНН,
	|	СписаниеСРасчетногоСчета.Организация.КПП КАК ОрганизацияКПП,
	|	ВЫБОР
	|		КОГДА СписаниеСРасчетногоСчета.ДатаВходящегоДокумента = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА СписаниеСРасчетногоСчета.Дата
	|		ИНАЧЕ СписаниеСРасчетногоСчета.ДатаВходящегоДокумента
	|	КОНЕЦ КАК Дата,
	|	СписаниеСРасчетногоСчета.НомерВходящегоДокумента КАК Номер,
	|	СписаниеСРасчетногоСчета.СуммаДокумента КАК Сумма,
	|	СписаниеСРасчетногоСчета.Налог.КодБК КАК КБК,
	|	ВЫРАЗИТЬ(СписаниеСРасчетногоСчета.ДокументОснование КАК Документ.ПлатежноеПоручение).КодОКАТО КАК ОКТМО,
	|	ПРЕДСТАВЛЕНИЕ(СписаниеСРасчетногоСчета.Налог) КАК Налог,
	|	ПРЕДСТАВЛЕНИЕ(ВЫРАЗИТЬ(СписаниеСРасчетногоСчета.Контрагент КАК Справочник.Контрагенты)) КАК Получатель,
	|	ВЫРАЗИТЬ(СписаниеСРасчетногоСчета.Контрагент КАК Справочник.Контрагенты).ИНН КАК ПолучательИНН,
	|	ВЫРАЗИТЬ(СписаниеСРасчетногоСчета.Контрагент КАК Справочник.Контрагенты).КПП КАК ПолучательКПП,
	|	СписаниеСРасчетногоСчета.СчетКонтрагента.НомерСчета КАК РасчетныйСчет,
	|	ПРЕДСТАВЛЕНИЕ(СписаниеСРасчетногоСчета.СчетКонтрагента.Банк) КАК Банк,
	|	ВЫРАЗИТЬ(СписаниеСРасчетногоСчета.Контрагент КАК Справочник.Контрагенты) КАК Налоговая,
	|	СписаниеСРасчетногоСчета.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.СписаниеСРасчетногоСчета КАК СписаниеСРасчетногоСчета
	|ГДЕ
	|	СписаниеСРасчетногоСчета.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РасходныйКассовыйОрдер.Организация.НаименованиеСокращенное,
	|	РасходныйКассовыйОрдер.Организация.ИНН,
	|	РасходныйКассовыйОрдер.Организация.КПП,
	|	НАЧАЛОПЕРИОДА(РасходныйКассовыйОрдер.Дата, ДЕНЬ),
	|	РасходныйКассовыйОрдер.НомерВходящегоДокумента,
	|	РасходныйКассовыйОрдер.СуммаДокумента,
	|	РасходныйКассовыйОрдер.КодБК,
	|	РасходныйКассовыйОрдер.КодОКАТО,
	|	ПРЕДСТАВЛЕНИЕ(РасходныйКассовыйОрдер.Налог),
	|	ПРЕДСТАВЛЕНИЕ(ВЫРАЗИТЬ(РасходныйКассовыйОрдер.Контрагент КАК Справочник.Контрагенты)),
	|	ВЫРАЗИТЬ(РасходныйКассовыйОрдер.Контрагент КАК Справочник.Контрагенты).ИНН,
	|	ВЫРАЗИТЬ(РасходныйКассовыйОрдер.Контрагент КАК Справочник.Контрагенты).КПП,
	|	РасходныйКассовыйОрдер.СчетКонтрагента.НомерСчета,
	|	ПРЕДСТАВЛЕНИЕ(РасходныйКассовыйОрдер.СчетКонтрагента.Банк),
	|	ВЫРАЗИТЬ(РасходныйКассовыйОрдер.Контрагент КАК Справочник.Контрагенты),
	|	РасходныйКассовыйОрдер.Ссылка
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|ГДЕ
	|	РасходныйКассовыйОрдер.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДанныеОплаты.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		Возврат ТабДокумент;
	КонецЕсли;
	
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Шапка.Параметры.Заполнить(Выборка);
	ЕстьРасхожденияВКБК   = Ложь;
	ЕстьРасхожденияВОКТМО = Ложь;
	Если ДанныеОплаты.Состояние = Перечисления.СостоянияНалоговогоПлатежа.НеНайден Тогда
		
		Шапка.Параметры.Заголовок = НСтр("ru = 'Платеж не найден'");
		Шапка.Параметры.Пояснение = НСтр(
			"ru = 'В данных ФНС нет информации об этом платеже. Возможно, вы указали неверные данные получателя платежа
			|или ввели неправильный КБК или ОКТМО.'");
		
	Иначе // расхождения
		
		Шапка.Параметры.Заголовок = НСтр("ru = 'Расхождения с данными ФНС'");
		ТекстПояснения = "";
		Если КБКБезПодвидаДохода(ДанныеОплаты.КБК) <> КБКБезПодвидаДохода(ДанныеОплаты.КБКПоДаннымФНС) Тогда
			ЕстьРасхожденияВКБК = Истина;
			ТекстПояснения= НСтр("ru = 'КБК в документе списания отличается от КБК по данным ФНС.'");
		КонецЕсли;
		Если ДанныеОплаты.ОКТМО <> ДанныеОплаты.ОКТМОПоДаннымФНС Тогда
			ЕстьРасхожденияВОКТМО = Истина;
			ТекстПояснения = ТекстПояснения + ?(ЗначениеЗаполнено(ТекстПояснения), Символы.ПС, "")
				+ НСтр("ru = 'ОКТМО в документе списания отличается от ОКТМО по данным ФНС.'");
		КонецЕсли;
		ТекстПояснения = ТекстПояснения + Символы.ПС + НСтр("ru = 'Возможно, вы указали неверные данные.'");
		Шапка.Параметры.Пояснение = ТекстПояснения;
		
	КонецЕсли;
	Если ЗначениеЗаполнено(Выборка.ОрганизацияКПП) Тогда
		Шапка.Параметры.ОрганизацияИННКППЗаголовок = "ИНН/КПП:";
		Шапка.Параметры.ОрганизацияИННКПП = Выборка.ОрганизацияИНН + "/" + Выборка.ОрганизацияКПП;
	Иначе
		Шапка.Параметры.ОрганизацияИННКППЗаголовок = "ИНН:";
		Шапка.Параметры.ОрганизацияИННКПП = Выборка.ОрганизацияИНН;
	КонецЕсли;
	Шапка.Параметры.Период = ДанныеОплаты.Период;
	ТабДокумент.Вывести(Шапка);

	ОбластьКБК = Макет.ПолучитьОбласть("КБК");
	ОбластьКБК.Параметры.Заполнить(ДанныеОплаты);
	Если ЕстьРасхожденияВКБК Тогда
		ОбластьКБК.Параметры.КБКЗаголовок = НСтр("ru = 'КБК в документе:'");
		ОбластьКБК.Область("КБКВДокументе").ЦветТекста = ЦветаСтиля.ЦветОплатаНалогаНеОбнаружена;
	Иначе
		ОбластьКБК.Параметры.КБКЗаголовок = НСтр("ru = 'КБК:'");
	КонецЕсли;
	ТабДокумент.Вывести(ОбластьКБК);
	Если ДанныеОплаты.Состояние = Перечисления.СостоянияНалоговогоПлатежа.Расхождения
		И КБКБезПодвидаДохода(ДанныеОплаты.КБК) <> КБКБезПодвидаДохода(ДанныеОплаты.КБКПоДаннымФНС) Тогда
		
		ОбластьКБКПоДаннымФНС = Макет.ПолучитьОбласть("КБКПоДаннымФНС");
		ОбластьКБКПоДаннымФНС.Параметры.Заполнить(ДанныеОплаты);
		ТабДокумент.Вывести(ОбластьКБКПоДаннымФНС);
		
	КонецЕсли;
	
	ОбластьОКТМО = Макет.ПолучитьОбласть("ОКТМО");
	ОбластьОКТМО.Параметры.Заполнить(ДанныеОплаты);
	Если ЕстьРасхожденияВОКТМО Тогда
		ОбластьОКТМО.Параметры.ОКТМОЗаголовок = НСтр("ru = 'ОКТМО в документе:'");
		ОбластьОКТМО.Область("ОКТМОВДокументе").ЦветТекста = ЦветаСтиля.ЦветОплатаНалогаНеОбнаружена;
	Иначе
		ОбластьОКТМО.Параметры.ОКТМОЗаголовок = НСтр("ru = 'ОКТМО:'");
	КонецЕсли;
	ТабДокумент.Вывести(ОбластьОКТМО);
	Если ДанныеОплаты.Состояние = Перечисления.СостоянияНалоговогоПлатежа.Расхождения
		И ДанныеОплаты.ОКТМО <> ДанныеОплаты.ОКТМОПоДаннымФНС Тогда
		
		ОбластьОКТМОПоДаннымФНС = Макет.ПолучитьОбласть("ОКТМОПоДаннымФНС");
		ОбластьОКТМОПоДаннымФНС.Параметры.Заполнить(ДанныеОплаты);
		ТабДокумент.Вывести(ОбластьОКТМОПоДаннымФНС);
		
	КонецЕсли;
	
	// Получение адреса и телефона ИФНС.
	ВидыКИ = Новый Массив;
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента);
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента);
	
	ТаблицаКИ = УправлениеКонтактнойИнформациейБП.КонтактнаяИнформацияОбъектовНаДату(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Выборка.Налоговая),, ВидыКИ);
		
	АдресФНС   = ТаблицаКИ.Найти(Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента, "Вид");
	ТелефонФНС = ТаблицаКИ.Найти(Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента, "Вид");
	
	Подвал = Макет.ПолучитьОбласть("Подвал");
	Подвал.Параметры.Заполнить(Выборка);
	Подвал.Параметры.ПолучательИННКПП = ""+ Выборка.ПолучательИНН + "/" + Выборка.ПолучательКПП;
	Подвал.Параметры.АдресФНС   = ?(АдресФНС = Неопределено, "", АдресФНС.Представление);
	Подвал.Параметры.ТелефонФНС = ?(ТелефонФНС = Неопределено, "", ТелефонФНС.Представление);
	
	ТабДокумент.Вывести(Подвал);
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПечатьСпискаОплат(АдресХранилища, ТолькоПроблемные) Экспорт
	
	ДанныеОплат = ПолучитьИзВременногоХранилища(АдресХранилища);
	ТабДокумент = Новый ТабличныйДокумент;
	Макет = Обработки.СверкаНалоговСФНС.ПолучитьМакет("СписокПлатежей");
	ТабДокумент.Вывести(Макет.ПолучитьОбласть("Шапка"));
	ТабДокумент.Вывести(Макет.ПолучитьОбласть("ШапкаТаблицы"));
	
	Для Каждого Строка Из ДанныеОплат Цикл
		Если ТолькоПроблемные И Не Строка.ПроблемныйПлатеж Тогда
			Продолжить;
		КонецЕсли;
		СтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
		СтрокаТаблицы.Параметры.Заполнить(Строка);
		ОбластьСостояние = СтрокаТаблицы.Область("Состояние");
		Если Строка.Состояние = Перечисления.СостоянияНалоговогоПлатежа.Зачислен Тогда
			ОбластьСостояние.ЦветТекста = ЦветаСтиля.ЦветОплатаНалогаЗачислена;
		ИначеЕсли Строка.Состояние = Перечисления.СостоянияНалоговогоПлатежа.НеНайден
			Или Строка.Состояние = Перечисления.СостоянияНалоговогоПлатежа.Расхождения Тогда
			
			ОбластьСостояние.ЦветТекста = ЦветаСтиля.ЦветОплатаНалогаНеОбнаружена;
			
		КонецЕсли;
		ТабДокумент.Вывести(СтрокаТаблицы);
	КонецЦикла;
	
	Возврат ТабДокумент;

КонецФункции

#КонецОбласти

Функция ДанныеДокументаНеПрошедшегоСверку(Организация, Дата, НуженПоследнийДокумент = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписаниеСРасчетногоСчета.Ссылка КАК Ссылка,
	|	СписаниеСРасчетногоСчета.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА СписаниеСРасчетногоСчета.ДатаВходящегоДокумента = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА СписаниеСРасчетногоСчета.Дата
	|		ИНАЧЕ СписаниеСРасчетногоСчета.ДатаВходящегоДокумента
	|	КОНЕЦ КАК Дата,
	|	СписаниеСРасчетногоСчета.НомерВходящегоДокумента КАК Номер,
	|	СписаниеСРасчетногоСчета.СуммаДокумента КАК Сумма
	|ПОМЕСТИТЬ ВТОплатыНалогов
	|ИЗ
	|	Документ.СписаниеСРасчетногоСчета КАК СписаниеСРасчетногоСчета
	|ГДЕ
	|	СписаниеСРасчетногоСчета.Проведен
	|	И СписаниеСРасчетногоСчета.ВидОперации = &ВидОперацииСписанияДС
	|	И СписаниеСРасчетногоСчета.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И СписаниеСРасчетногоСчета.Организация = &Организация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РасходныйКассовыйОрдер.Ссылка,
	|	РасходныйКассовыйОрдер.Организация,
	|	НАЧАЛОПЕРИОДА(РасходныйКассовыйОрдер.Дата, ДЕНЬ),
	|	РасходныйКассовыйОрдер.НомерВходящегоДокумента,
	|	РасходныйКассовыйОрдер.СуммаДокумента
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|ГДЕ
	|	РасходныйКассовыйОрдер.Проведен
	|	И РасходныйКассовыйОрдер.ВидОперации = &ВидОперацииРКО
	|	И РасходныйКассовыйОрдер.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И РасходныйКассовыйОрдер.Организация = &Организация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Дата,
	|	Номер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВТОплатыНалогов.Дата КАК Дата,
	|	ВТОплатыНалогов.Ссылка КАК Ссылка
	|ИЗ
	|	ВТОплатыНалогов КАК ВТОплатыНалогов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияФНСОбОплатахНалогов КАК СведенияФНСОбОплатахНалогов
	|		ПО ВТОплатыНалогов.Организация = СведенияФНСОбОплатахНалогов.Организация
	|			И ВТОплатыНалогов.Дата = СведенияФНСОбОплатахНалогов.ДатаПлатежа
	|			И ВТОплатыНалогов.Номер = СведенияФНСОбОплатахНалогов.НомерПлатежа
	|			И ВТОплатыНалогов.Сумма = СведенияФНСОбОплатахНалогов.СуммаПлатежа
	|ГДЕ
	|	СведенияФНСОбОплатахНалогов.КБК ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТОплатыНалогов.Дата %1";
	
	Запрос.Текст = СтрШаблон(Запрос.Текст, ?(НуженПоследнийДокумент, "УБЫВ", ""));
	Запрос.УстановитьПараметр("Организация",           Организация);
	Запрос.УстановитьПараметр("НачалоПериода",         НачалоГода(Дата));
	Запрос.УстановитьПараметр("КонецПериода",          КонецГода(Дата));
	Запрос.УстановитьПараметр("ВидОперацииСписанияДС", Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога);
	Запрос.УстановитьПараметр("ВидОперацииРКО",        Перечисления.ВидыОперацийРКО.УплатаНалога);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Новый Структура;
		Результат.Вставить("ДатаОплаты", Выборка.Дата);
		Результат.Вставить("Ссылка",     Выборка.Ссылка);
		Возврат Результат;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ПараметрыОтправкиЗапроса(Организация, Год) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПерсонализированныеДанные.ЗначениеПоказателя КАК ЗначениеПоказателя
	|ИЗ
	|	РегистрСведений.ПерсонализированныеДанные КАК ПерсонализированныеДанные
	|ГДЕ
	|	ПерсонализированныеДанные.Раздел = ЗНАЧЕНИЕ(Перечисление.РазделыПерсонализированныхДанных.СервисПроверкаОплатыНалогов)
	|	И ПерсонализированныеДанные.Организация = &Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегистрацииВНалоговомОргане.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
	|ГДЕ
	|	РегистрацииВНалоговомОргане.Владелец = &Организация";
	Запрос.УстановитьПараметр("Организация", Организация);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ГодаДляОтправкиЗапросов = Новый Массив;
	Если ЗначениеЗаполнено(Год) Тогда
		ГодаДляОтправкиЗапросов.Добавить(Год);
	Иначе
		ТекущаяДата = ОбщегоНазначения.ТекущаяДатаПользователя();
		
		// Годы, за которые нужно выполнить запроса на сверку оплат
		Выборка = РезультатЗапроса[0].Выбрать();
		Если Выборка.Следующий() Тогда
			ЗначениеПоказателя = Выборка.ЗначениеПоказателя;
			Если ЗначениеПоказателя = ЗначениеТребуетсяПроверкаТекущегоИПрошлогоГодов() Тогда
				ГодаДляОтправкиЗапросов.Добавить(Год(ТекущаяДата) - 1);
				ГодаДляОтправкиЗапросов.Добавить(Год(ТекущаяДата));
			ИначеЕсли ЗначениеПоказателя = ЗначениеТребуетсяПроверкаПрошлогоГода() Тогда
				ГодаДляОтправкиЗапросов.Добавить(Год(ТекущаяДата) - 1);
			ИначеЕсли ЗначениеПоказателя = ЗначениеТребуетсяПроверкаТекущегоГода() Тогда
				ГодаДляОтправкиЗапросов.Добавить(Год(ТекущаяДата));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Налоговые органы, в которые нужно отправить запрос на сверку.
	СписокДанныхДляОтправкиЗапроса = Новый Массив;
	Выборка = РезультатЗапроса[1].Выбрать();
	Для Каждого Год Из ГодаДляОтправкиЗапросов Цикл
		Выборка.Сбросить();
		Пока Выборка.Следующий() Цикл
			СписокДанныхДляОтправкиЗапроса.Добавить(Новый Структура("Год, НалоговыйОрган", Год, Выборка.Ссылка));
		КонецЦикла;
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("Организация",                    Организация);
	Результат.Вставить("СписокДанныхДляОтправкиЗапроса", СписокДанныхДляОтправкиЗапроса);
	
	Возврат Результат;

КонецФункции

Функция ПоОрганизацииОтправленЗапросНаСверку(Организация, Год = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗапросыНаПроверкуОплатНалогов.Запрос КАК Запрос
	|ИЗ
	|	РегистрСведений.ЗапросыНаПроверкуОплатНалогов КАК ЗапросыНаПроверкуОплатНалогов
	|ГДЕ
	|	ЗапросыНаПроверкуОплатНалогов.Организация = &Организация
	|	И НЕ ЗапросыНаПроверкуОплатНалогов.ОтветОбработан
	|	И ВЫБОР
	|			КОГДА &Год = НЕОПРЕДЕЛЕНО
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЗапросыНаПроверкуОплатНалогов.Год = &Год
	|		КОНЕЦ
	|	И РАЗНОСТЬДАТ(ЗапросыНаПроверкуОплатНалогов.Дата, &ТекущаяДата, ДЕНЬ) <= &МаксимальноеКоличествоДнейОжиданияОтвета";
	Запрос.УстановитьПараметр("Организация",                              Организация);
	запрос.УстановитьПараметр("Год",                                      Год);
	запрос.УстановитьПараметр("МаксимальноеКоличествоДнейОжиданияОтвета", МаксимальноеКоличествоДнейОжиданияОтветаНаЗапрос());
	Запрос.УстановитьПараметр("ТекущаяДата",                              ОбщегоНазначения.ТекущаяДатаПользователя());
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

Функция ГодПоследнейПроверкиНеПрошедшейСверку(Организация) Экспорт
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат Год(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МАКСИМУМ(ЗапросыНаПроверкуОплатНалогов.Год) КАК Год
	|ИЗ
	|	РегистрСведений.ЗапросыНаПроверкуОплатНалогов КАК ЗапросыНаПроверкуОплатНалогов
	|ГДЕ
	|	ЗапросыНаПроверкуОплатНалогов.Организация = &Организация
	|	И ЗапросыНаПроверкуОплатНалогов.ОтветОбработан
	|	И НЕ ЗапросыНаПроверкуОплатНалогов.СверкаПройдена";
	Запрос.УстановитьПараметр("Организация", Организация);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ГодПоследнейПроверки = Выборка.Год;
	Если ЗначениеЗаполнено(ГодПоследнейПроверки) Тогда
		Возврат ГодПоследнейПроверки;
	Иначе
		Возврат Год(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РазборВыпискиОперацийВФорматеXML

Функция РазобратьВыпискуОперацийВФорматеXML(Данные)
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	ДвоичныеДанные = Данные.Получить();
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ИмяВременногоФайла);
	
	Фабрика = Новый ФабрикаXDTO;
	ВыпискаОперацийXDTO = Фабрика.ПрочитатьXML(ЧтениеXML);
	ЧтениеXML.Закрыть();
	
	УдалитьФайлы(ИмяВременногоФайла);
	
	// Данные налогового органа.
	ДанныеВыписки = СтруктураДляДанныхВыпискиОпераций();
	Документ = ВыпискаОперацийXDTO.Документ;
	ДанныеВыписки.НалоговыйОрганНаименование = Документ.Подписант.НаимНО;
	ДанныеВыписки.НалоговыйОрганКод          = Документ.Подписант.КодНО;
	
	// Данные организации (отправителя запроса).
	Отправитель = Документ.СвОтпр;
	Если СвойствоСуществует(Отправитель, "СвОтпрЮЛ") Тогда // это юр. лицо
		ДанныеВыписки.ОрганизацияНаименование = Отправитель.СвОтпрЮЛ.НаимОрг;
		ДанныеВыписки.ОрганизацияИНН          = Отправитель.СвОтпрЮЛ.ИННЮЛ;
		ДанныеВыписки.ОрганизацияКПП          = Отправитель.СвОтпрЮЛ.КПП;
	ИначеЕсли СвойствоСуществует(Отправитель, "СвОтпрФЛ") Тогда // это физ. лицо
		ФИО = Отправитель.СвОтпрФЛ;
		ДанныеВыписки.ОрганизацияНаименование = НСтр("ru = 'ИП'")
			+ " " + ФИО.Фамилия
			+ " " + Лев(ФИО.Имя, 1) + "."
			+ ?(ЗначениеЗаполнено(ФИО.Отчество), Лев(ФИО.Отчество, 1) + ".", "");
		ДанныеВыписки.ОрганизацияИНН = Отправитель.СвОтпрЮЛ.ИННФЛ;
	КонецЕсли;
	
	// Данные налогов
	СписокНалогов = Документ.ВыпОперРСБ;
	ДанныеНалогов = Новый Массив();
	Для Каждого Налог Из СписокНалогов Цикл
		ДанныеНалога = СтруктураДляДанныхНалога();
		ДанныеНалога.НалогНаименование            = Налог.НаимНалог;
		ДанныеНалога.НалогКБК                     = Налог.КБК;
		ДанныеНалога.НалогОКТМО                   = Налог.ОКТМО;
		ДанныеНалога.НалогСтатусНалогоплательщика = Налог.СвНП.СтатусНП;
		ДанныеНалога.НалогОперации                = ДанныеОбОплатахНалога(Налог);
		
		Если ДанныеНалога.НалогОперации.Количество() > 0 Тогда
			ДанныеНалогов.Добавить(ДанныеНалога);
		КонецЕсли;
	КонецЦикла;
	ДанныеВыписки.Налоги = ДанныеНалогов;
	
	Возврат ДанныеВыписки;
	
КонецФункции

// Отбираем только оплаты налогов
Функция ДанныеОбОплатахНалога(ДанныеПоНалогу)
	
	Операции = Новый Массив();
	
	Если Не СвойствоСуществует(ДанныеПоНалогу, "ЗапОперРСБ") Тогда
		Возврат Операции;
	КонецЕсли;
	
	СписокОпераций = ДанныеПоНалогу.ЗапОперРСБ;
	Для Каждого Операция Из СписокОпераций Цикл
		ДанныеОперации = СтруктураДляДанныхОперации();
		ДанныеОперации.ОперацияСрокОплаты   = СвойствоТипаДата(Операция, "СрокУплат");
		ДанныеОперации.ОперацияДатаЗаписи   = СвойствоТипаДата(Операция, "ДатаЗап");
		ДанныеОперации.ОперацияНаименование = СвойствоТипаСтрока(Операция, "НаимОперац");
		ДанныеОперации.ОперацияКод          = СвойствоТипаСтрока(Операция, "КодОперац");
		ДанныеОперации.ОперацияВидПлатежа   = СвойствоТипаСтрока(Операция, "ВидПлатеж");
		
		ДанныеДокумента = СвойствоТипаСтрока(Операция, "ДокОтч"); 
		Если ДанныеДокумента <> Неопределено Тогда
			ДанныеОперации.ОперацияДокумент                      = СвойствоТипаСтрока(ДанныеДокумента, "ВидДО");
			ДанныеОперации.ОперацияНомерДокумента                = СвойствоТипаСтрока(ДанныеДокумента, "НомДО");
			ДанныеОперации.ОперацияДатаДокумента                 = СвойствоТипаДата(ДанныеДокумента, "ДатаДО");
			ДанныеОперации.ОперацияДатаПредставленияДокументаВНО = СвойствоТипаДата(ДанныеДокумента, "ДатаПредстДО");
			ДанныеОперации.ОперацияПериодОтчетности              = СвойствоТипаСтрока(ДанныеДокумента, "ПризПериодОтч");
		КонецЕсли;
		
		СуммаОперации = СвойствоТипаСтрока(Операция, "Сумма");
		Если СуммаОперации <> Неопределено Тогда
			ДанныеОперации.ОперацияСумма = СвойствоТипаЧисло(СуммаОперации, "Кредит");
		КонецЕсли;
		
		Если ЭтоОплатаНалога(ДанныеОперации) Тогда
			Операции.Добавить(ДанныеОперации);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Операции;
	
КонецФункции

Функция СтруктураДляДанныхВыпискиОпераций()
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("НалоговыйОрганНаименование");
	СтруктураДанных.Вставить("НалоговыйОрганКод");
	СтруктураДанных.Вставить("ОрганизацияНаименование");
	СтруктураДанных.Вставить("ОрганизацияИНН");
	СтруктураДанных.Вставить("ОрганизацияКПП");
	СтруктураДанных.Вставить("Налоги");
	
	Возврат СтруктураДанных;
	
КонецФункции

Функция СтруктураДляДанныхНалога()
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("НалогНаименование");
	СтруктураДанных.Вставить("НалогКБК");
	СтруктураДанных.Вставить("НалогОКТМО");
	СтруктураДанных.Вставить("НалогСтатусНалогоплательщика");
	СтруктураДанных.Вставить("НалогОперации");
	
	Возврат СтруктураДанных;
	
КонецФункции

Функция СтруктураДляДанныхОперации()
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ОперацияДатаЗаписи");
	СтруктураДанных.Вставить("ОперацияСрокОплаты");
	СтруктураДанных.Вставить("ОперацияНаименование");
	СтруктураДанных.Вставить("ОперацияДокумент");
	СтруктураДанных.Вставить("ОперацияНомерДокумента");
	СтруктураДанных.Вставить("ОперацияДатаДокумента");
	СтруктураДанных.Вставить("ОперацияДатаПредставленияДокументаВНО"); // дата представления документа отчетности в налоговый орган
	СтруктураДанных.Вставить("ОперацияПериодОтчетности");
	СтруктураДанных.Вставить("ОперацияСумма");
	СтруктураДанных.Вставить("ОперацияВидПлатежа");
	СтруктураДанных.Вставить("ОперацияКод");
	
	Возврат СтруктураДанных;
	
КонецФункции

Функция СвойствоСуществует(ОбъектXDTO, ИмяСвойства)
	
	Возврат ОбъектXDTO.Свойства().Получить(ИмяСвойства) <> Неопределено
	
КонецФункции

Функция СвойствоТипаСтрока(ОбъектXDTO, ИмяСвойства)
	
	Если СвойствоСуществует(ОбъектXDTO, ИмяСвойства) Тогда
		Возврат ОбъектXDTO.Получить(ИмяСвойства);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция СвойствоТипаДата(ОбъектXDTO, ИмяСвойства)
	
	Возврат СтроковыеФункцииКлиентСервер.СтрокаВДату(СвойствоТипаСтрока(ОбъектXDTO, ИмяСвойства));
	
КонецФункции

Функция СвойствоТипаЧисло(ОбъектXDTO, ИмяСвойства)
	
	Возврат СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СвойствоТипаСтрока(ОбъектXDTO, ИмяСвойства));
	
КонецФункции

Функция ЭтоОплатаНалога(ДанныеОперации)
	
	Возврат (ВРег(ДанныеОперации.ОперацияНаименование) = "УПЛАЧЕНО");
	
КонецФункции

#КонецОбласти

#Область ЗаписьДанныхОбОплатахНалоговВРегистр

Процедура ЗаписатьДанныеФНСОбОплатахНалоговВРегистр(Организация, Год, ДанныеВыписки)
	
	ДанныеОбОплатах = ДанныеФНСОбОплатахНалогов(ДанныеВыписки);
	
	Набор = РегистрыСведений.СведенияФНСОбОплатахНалогов.СоздатьНаборЗаписей();
	Набор.Отбор.Организация.Установить(Организация);
	Набор.Отбор.Год.Установить(Год);
	Для Каждого Оплата Из ДанныеОбОплатах Цикл
		Запись = Набор.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, Оплата);
		Запись.Организация = Организация;
		Запись.Год         = Год;
	КонецЦикла;
	Набор.Записать(Истина);
	
КонецПроцедуры

Функция ДанныеФНСОбОплатахНалогов(ДанныеВыписки)
	
	ДанныеОбОплатах = Новый ТаблицаЗначений;
	ДанныеОбОплатах.Колонки.Добавить("ДатаПлатежа");
	ДанныеОбОплатах.Колонки.Добавить("НомерПлатежа");
	ДанныеОбОплатах.Колонки.Добавить("СуммаПлатежа");
	ДанныеОбОплатах.Колонки.Добавить("КБК");
	ДанныеОбОплатах.Колонки.Добавить("ОКТМО");
	
	Налоги = ДанныеВыписки.Налоги;
	Для Каждого Налог Из Налоги Цикл
		Для Каждого Операция Из Налог.НалогОперации Цикл
			СтрокаДанных = ДанныеОбОплатах.Добавить();
			СтрокаДанных.ДатаПлатежа  = Операция.ОперацияДатаДокумента;
			СтрокаДанных.НомерПлатежа = Операция.ОперацияНомерДокумента;
			СтрокаДанных.СуммаПлатежа = Операция.ОперацияСумма;
			СтрокаДанных.КБК          = Налог.НалогКБК;
			СтрокаДанных.ОКТМО        = Налог.НалогОКТМО;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ДанныеОбОплатах;
	
КонецФункции

#КонецОбласти

#Область СопоставлениеСДаннымиФНС

Функция ДанныеОбОплатахНалоговСоСтатусами(Организация, Год) Экспорт
	
	СопоставленныеДанные = СопоставитьОплатыСДаннымиФНС(Организация, Год);
	ДополнитьСопоставленныеДанныеОбОплатах(СопоставленныеДанные, Организация, Год);
	
	Возврат СопоставленныеДанные;
	
КонецФункции

Функция СопоставитьОплатыСДаннымиФНС(Организация, Год)
	
	НачалоПериода = НачалоГода(Дата(Год, 1, 1));
	КонецПериода  = КонецГода(Дата(Год, 1, 1));
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СписаниеСРасчетногоСчета.Ссылка КАК Ссылка,
	|	СписаниеСРасчетногоСчета.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА СписаниеСРасчетногоСчета.ДатаВходящегоДокумента = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА СписаниеСРасчетногоСчета.Дата
	|		ИНАЧЕ СписаниеСРасчетногоСчета.ДатаВходящегоДокумента
	|	КОНЕЦ КАК Дата,
	|	СписаниеСРасчетногоСчета.НомерВходящегоДокумента КАК Номер,
	|	СписаниеСРасчетногоСчета.НалоговыйПериод КАК НалоговыйПериод,
	|	СписаниеСРасчетногоСчета.СуммаДокумента КАК Сумма,
	|	СписаниеСРасчетногоСчета.Налог.КодБК КАК КБК,
	|	ВЫРАЗИТЬ(СписаниеСРасчетногоСчета.ДокументОснование КАК Документ.ПлатежноеПоручение).КодОКАТО КАК ОКТМО,
	|	ПРЕДСТАВЛЕНИЕ(СписаниеСРасчетногоСчета.Налог) КАК Налог,
	|	ВЫРАЗИТЬ(СписаниеСРасчетногоСчета.ДокументОснование КАК Документ.ПлатежноеПоручение).ПоказательПериода КАК ПоказательПериода
	|ПОМЕСТИТЬ ВТОплатыНалогов
	|ИЗ
	|	Документ.СписаниеСРасчетногоСчета КАК СписаниеСРасчетногоСчета
	|ГДЕ
	|	СписаниеСРасчетногоСчета.Проведен = ИСТИНА
	|	И СписаниеСРасчетногоСчета.ВидОперации = &ВидОперацииСписанияДС
	|	И ВЫБОР
	|			КОГДА &Организация В (НЕОПРЕДЕЛЕНО, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ СписаниеСРасчетногоСчета.Организация = &Организация
	|		КОНЕЦ
	|	И СписаниеСРасчетногоСчета.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РасходныйКассовыйОрдер.Ссылка,
	|	РасходныйКассовыйОрдер.Организация,
	|	НАЧАЛОПЕРИОДА(РасходныйКассовыйОрдер.Дата, ДЕНЬ),
	|	РасходныйКассовыйОрдер.НомерВходящегоДокумента,
	|	РасходныйКассовыйОрдер.НалоговыйПериод,
	|	РасходныйКассовыйОрдер.СуммаДокумента,
	|	РасходныйКассовыйОрдер.КодБК,
	|	РасходныйКассовыйОрдер.КодОКАТО,
	|	ПРЕДСТАВЛЕНИЕ(РасходныйКассовыйОрдер.Налог),
	|	РасходныйКассовыйОрдер.ПоказательПериода
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|ГДЕ
	|	РасходныйКассовыйОрдер.Проведен = ИСТИНА
	|	И РасходныйКассовыйОрдер.ВидОперации = &ВидОперацииРКО
	|	И ВЫБОР
	|			КОГДА &Организация В (НЕОПРЕДЕЛЕНО, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ РасходныйКассовыйОрдер.Организация = &Организация
	|		КОНЕЦ
	|	И РасходныйКассовыйОрдер.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Дата,
	|	Номер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТОплатыНалогов.Ссылка КАК Ссылка,
	|	ВТОплатыНалогов.Организация КАК Организация,
	|	ВТОплатыНалогов.Дата КАК Дата,
	|	ВТОплатыНалогов.Номер КАК Номер,
	|	ВТОплатыНалогов.НалоговыйПериод КАК НалоговыйПериод,
	|	ВТОплатыНалогов.Сумма КАК Сумма,
	|	ВТОплатыНалогов.КБК КАК КБК,
	|	ЕСТЬNULL(ВТОплатыНалогов.ОКТМО, """") КАК ОКТМО,
	|	ВТОплатыНалогов.Налог КАК Налог,
	|	ЕСТЬNULL(СведенияФНСОбОплатахНалогов.КБК, """") КАК КБКПоДаннымФНС,
	|	ЕСТЬNULL(СведенияФНСОбОплатахНалогов.ОКТМО, """") КАК ОКТМОПоДаннымФНС,
	|	ВЫБОР
	|		КОГДА СведенияФНСОбОплатахНалогов.КБК ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ПлатежОбнаружен,
	|	ЕСТЬNULL(ВТОплатыНалогов.ПоказательПериода, """") КАК ПоказательПериода
	|ИЗ
	|	ВТОплатыНалогов КАК ВТОплатыНалогов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияФНСОбОплатахНалогов КАК СведенияФНСОбОплатахНалогов
	|		ПО ВТОплатыНалогов.Организация = СведенияФНСОбОплатахНалогов.Организация
	|			И ВТОплатыНалогов.Дата = СведенияФНСОбОплатахНалогов.ДатаПлатежа
	|			И ВТОплатыНалогов.Номер = СведенияФНСОбОплатахНалогов.НомерПлатежа
	|			И ВТОплатыНалогов.Сумма = СведенияФНСОбОплатахНалогов.СуммаПлатежа";
	
	Запрос.УстановитьПараметр("Организация",           Организация);
	Запрос.УстановитьПараметр("НачалоПериода",         НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",          КонецПериода);
	Запрос.УстановитьПараметр("ВидОперацииСписанияДС", Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога);
	Запрос.УстановитьПараметр("ВидОперацииРКО",        Перечисления.ВидыОперацийРКО.УплатаНалога);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура ДополнитьСопоставленныеДанныеОбОплатах(СопоставленныеДанные, Организация, Год)
	
	ТекущаяДата = ОбщегоНазначения.ТекущаяДатаПользователя();
	ДатыСверокПоОрганизациям = ДатыСверокПоОрганизациям(Организация, Год);
	
	ПроизводственныйКалендарь = КалендарныеГрафики.ОсновнойПроизводственныйКалендарь();
	СопоставленныеДанные.Колонки.Добавить("Состояние");
	СопоставленныеДанные.Колонки.Добавить("Период");
	СопоставленныеДанные.Колонки.Добавить("ПроблемныйПлатеж");
	Для Каждого Строка Из СопоставленныеДанные Цикл
		
		Строка.Период = ПериодПлатежа(Строка);
		Если Не ЗначениеЗаполнено(Строка.ОКТМО) Тогда
			Строка.ОКТМО = ОКТМОПлатежа(Строка.Ссылка); // если платежное поручение введено на основании списания
		КонецЕсли;
		Строка.Состояние        = СостояниеПлатежа(Строка, ТекущаяДата, ПроизводственныйКалендарь, ДатыСверокПоОрганизациям);
		Строка.ПроблемныйПлатеж = ЭтоПроблемныйПлатеж(Строка.Состояние);
		
	КонецЦикла;
	
КонецПроцедуры

Функция СостояниеПлатежа(ДанныеНалога, ТекущаяДата, ПроизводственныйКалендарь, ДатыСверокПоОрганизациям)
	
	ДатаПоследнейСверки = ДатыСверокПоОрганизациям.Получить(ДанныеНалога.Организация);
	
	Если ДанныеНалога.ПлатежОбнаружен Тогда
		Если КБКБезПодвидаДохода(ДанныеНалога.КБК) = КБКБезПодвидаДохода(ДанныеНалога.КБКПоДаннымФНС)
			И ДанныеНалога.ОКТМО = ДанныеНалога.ОКТМОПоДаннымФНС Тогда
			
			Возврат Перечисления.СостоянияНалоговогоПлатежа.Зачислен;
			
		Иначе
			Возврат Перечисления.СостоянияНалоговогоПлатежа.Расхождения;
		КонецЕсли;
		
	// Если дата сверки меньше даты оплаты налога, статус оставляем пустым.
	ИначеЕсли ЗначениеЗаполнено(ДатаПоследнейСверки)
		И НачалоДня(ДанныеНалога.Дата) <= НачалоДня(ДатаПоследнейСверки) Тогда
		
		ДанныеКалендаря = РасчетЗарплатыБазовый.РазностьДатПроизводственныхКалендарейПоВидамДней(
			ПроизводственныйКалендарь,
			ДанныеНалога.Дата,
			ТекущаяДата);
			
		КоличествоРабочихДнейСМоментаПлатежа = ДанныеКалендаря.Получить(Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий);
			
		Если КоличествоРабочихДнейСМоментаПлатежа <= МаксимальноеКоличествоДнейДоОтраженияПлатежаВФНС() Тогда
			Возврат Перечисления.СостоянияНалоговогоПлатежа.ОжидаетсяЗачисление;
		Иначе
			Возврат Перечисления.СостоянияНалоговогоПлатежа.НеНайден;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

Функция ПериодПлатежа(ДанныеНалога)
	
	Если ЗначениеЗаполнено(ДанныеНалога.ПоказательПериода) И ДанныеНалога.ПоказательПериода <> "0" Тогда
		Возврат ПлатежиВБюджетКлиентСервер.ПредставлениеНалоговогоПериодаДляФормыСверкиНалогов(ДанныеНалога.ПоказательПериода);
	Иначе
		Шаблон = "%1 %2 г.";
		Возврат СтрШаблон(
			Шаблон, 
			Формат(ДанныеНалога.НалоговыйПериод, "ДФ=ММММ"),
			Формат(ДанныеНалога.НалоговыйПериод, "ДФ=гггг"));
	КонецЕсли;
	
КонецФункции

// Для проверки берем первые 13 цифр, с 14 разряда в КБК идет информация
// о назначении платежа (налог, пени, штраф) и коды операций.
Функция КБКБезПодвидаДохода(КБК)
	
	Возврат Лев(КБК, 13);
	
КонецФункции

Функция КоличествоРабочихДней(НачалоПериода, КонецПериода)
	
	ПроизводственныйКалендарь = КалендарныеГрафики.ОсновнойПроизводственныйКалендарь();
	
	ДанныеКалендаря = РасчетЗарплатыБазовый.РазностьДатПроизводственныхКалендарейПоВидамДней(
		ПроизводственныйКалендарь,
		НачалоПериода,
		КонецПериода);
		
	Возврат ДанныеКалендаря.Получить(Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий);
	
КонецФункции

Функция ЭтоПроблемныйПлатеж(СостояниеПлатежа)
	
	Возврат (СостояниеПлатежа = Перечисления.СостоянияНалоговогоПлатежа.НеНайден
			Или СостояниеПлатежа = Перечисления.СостоянияНалоговогоПлатежа.Расхождения);
	
КонецФункции

Функция ОКТМОПлатежа(Ссылка)

	Если ТипЗнч(Ссылка) <> Тип("ДокументСсылка.СписаниеСРасчетногоСчета") Тогда
		Возврат "";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ПлатежноеПоручение.КодОКАТО КАК ОКТМО
	|ИЗ
	|	Документ.ПлатежноеПоручение КАК ПлатежноеПоручение
	|ГДЕ
	|	ПлатежноеПоручение.ДокументОснование = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ОКТМО;
	Иначе
		Возврат "";
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область Баннеры

Функция ДатаПоследнейПроверкиПрошлогоГода(Организация, Дата)
	
	ПрошлыйГод = Год(Дата) - 1;
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗапросыНаПроверкуОплатНалогов.Дата КАК Дата
	|ИЗ
	|	РегистрСведений.ЗапросыНаПроверкуОплатНалогов КАК ЗапросыНаПроверкуОплатНалогов
	|ГДЕ
	|	ЗапросыНаПроверкуОплатНалогов.Организация = &Организация
	|	И ЗапросыНаПроверкуОплатНалогов.ОтветОбработан
	|	И ЗапросыНаПроверкуОплатНалогов.Год = &Год
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Год",         ПрошлыйГод);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Дата;
	Иначе // прошлый год не проверяли
		Возврат НачалоГода(НачалоГода(Дата) - 1); // дата начала прошлого года
	КонецЕсли;

КонецФункции

Функция ГодНачалаРаботыСервисаПроверкиОплаты()

	Возврат 2019;

КонецФункции

Функция ЗначениеПроверкаНеТребуется()

	Возврат 0;

КонецФункции

Функция ЗначениеТребуетсяПроверкаТекущегоГода()

	Возврат 1;

КонецФункции

Функция ЗначениеТребуетсяПроверкаПрошлогоГода()

	Возврат 2;

КонецФункции

Функция ЗначениеТребуетсяПроверкаТекущегоИПрошлогоГодов()

	Возврат 3;

КонецФункции

#КонецОбласти

Функция МаксимальноеКоличествоДнейДоОтраженияПлатежаВФНС()
	
	Возврат 10;
	
КонецФункции

Функция МаксимальноеКоличествоДнейОжиданияОтветаНаЗапрос()

	Возврат 3;

КонецФункции

Функция ДанныеПоследнейСверки(Организация, Год)
	
	Результат = Новый Структура("ЗапросОтправлен, Дата");
	Результат.ЗапросОтправлен = ПоОрганизацииОтправленЗапросНаСверку(Организация, Год);
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Результат.Дата = Неопределено;
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗапросыНаПроверкуОплатНалогов.Дата КАК Дата
	|ИЗ
	|	РегистрСведений.ЗапросыНаПроверкуОплатНалогов КАК ЗапросыНаПроверкуОплатНалогов
	|ГДЕ
	|	ЗапросыНаПроверкуОплатНалогов.Организация = &Организация
	|	И ЗапросыНаПроверкуОплатНалогов.ОтветОбработан
	|	И ЗапросыНаПроверкуОплатНалогов.Год = &Год
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Год",         Год);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат.Дата = Выборка.Дата;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция ДатыСверокПоОрганизациям(Организация, Год)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗапросыНаПроверкуОплатНалогов.Организация КАК Организация,
	|	МАКСИМУМ(ЗапросыНаПроверкуОплатНалогов.Дата) КАК Дата
	|ИЗ
	|	РегистрСведений.ЗапросыНаПроверкуОплатНалогов КАК ЗапросыНаПроверкуОплатНалогов
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &Организация В (НЕОПРЕДЕЛЕНО, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЗапросыНаПроверкуОплатНалогов.Организация = &Организация
	|		КОНЕЦ
	|	И ЗапросыНаПроверкуОплатНалогов.ОтветОбработан
	|	И ЗапросыНаПроверкуОплатНалогов.Год = &Год
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗапросыНаПроверкуОплатНалогов.Организация";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Год",         Год);
	Выборка = Запрос.Выполнить().Выбрать();
	ДатыСверок = Новый Соответствие;
	Если Выборка.Следующий() Тогда
		ДатыСверок.Вставить(Выборка.Организация, Выборка.Дата);
	КонецЕсли;
	
	Возврат ДатыСверок;

КонецФункции

#КонецОбласти

#КонецЕсли