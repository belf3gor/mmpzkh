#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

// Признак для передачи в счет-фактуру для того, чтобы не устанавливать статус повторно.
Перем УстановленСтатусДокумента;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	Иначе
		СуммаВключаетНДС = Ложь;
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения, Истина);
	
	Если ПустаяСтрока(Содержание) Тогда
		Содержание	= НСтр("ru = 'Доп. расходы'");
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
	НомерВходящегоДокумента = "";
	ДатаВходящегоДокумента  = '00010101';
	
	ЗачетАвансов.Очистить();
	
	СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(
	ВалютаДокумента, Дата);
	
	КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
	КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если УчетнаяПолитика.РаздельныйУчетНДСНаСчете19(Организация, Дата) Тогда
		НДСВключенВСтоимость = Ложь;
	КонецЕсли;
	
	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСДоговорамиКонтрагентовБП.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);
	
	СуммаДокумента = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);

	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("ПометкаУдаления", ЭтотОбъект, "СчетФактураПолученный");
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);

	Документы.КорректировкаПоступления.ОбновитьРеквизитыСвязанныхДокументовКорректировки(ЭтотОбъект, Отказ);
	
	Если НЕ УчетнаяПолитика.ПлательщикНДФЛ(Организация, Дата) Тогда
		Для каждого СтрокаТовары Из Товары Цикл
			Если ЗначениеЗаполнено(СтрокаТовары.СчетУчетаНУ) 
				И НЕ Документы.ПоступлениеДопРасходов.СвойстваСчетаНУ(СтрокаТовары.СчетУчетаНУ).СтатьяЗатратНУДоступность Тогда
				
				СтрокаТовары.СтатьяЗатратНУ = Неопределено;
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли; 

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьСтатусДокумента();
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
		УчетНДСПереопределяемый.СинхронизироватьРеквизитыСчетаФактурыПолученного(ЭтотОбъект, НЕ УстановленСтатусДокумента);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	РаздельныйУчетНДСНаСчете19 = УчетнаяПолитика.РаздельныйУчетНДСНаСчете19(Организация, Дата);

	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
	КонецЕсли;
	
	Если Товары.Итог("Сумма") <> 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Сумма");
	КонецЕсли;
	Если Сумма = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СпособРаспределения");
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНДС");
	КонецЕсли;

	ОтражатьВНалоговомУчете = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, Дата);

	// Проверка заполнения табличной части "Товары"
	Если СпособРаспределения = Перечисления.СпособыРаспределенияДопРасходов.ПоСумме Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СуммаТовара");
	КонецЕсли;

	
	// Табличная часть "Зачет авансов"
	Если СпособЗачетаАвансов <> Перечисления.СпособыЗачетаАвансов.ПоДокументу Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗачетАвансов");
	ИначеЕсли ЗачетАвансов.Количество() = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗачетАвансов");
	
		ТекстСообщения = НСтр("ru = 'Не введено ни одной строки с документом аванса!'");
		Поле = "ПорядокУчетаРасчетов";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , Поле, Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	РеквизитыЗаСсылками = Документы.ПоступлениеДопРасходов.РеквизитыЗаСсылками();
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, РеквизитыЗаСсылками);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ПоступлениеДопРасходов.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ (АНАЛИЗ ОСТАТКОВ И Т.П.)

	// Таблица взаиморасчетов
	ТаблицаВзаиморасчетов = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ЗачетАвансовТаблицаДокумента,
		ПараметрыПроведения.ЗачетАвансовТаблицаАвансов,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Отказ);

	// Распределение суммы доп.расхода:
	ДопРасходыТаблица = Документы.ПоступлениеДопРасходов.РаспределениеСуммыДопРасходов(
		ПараметрыПроведения.ДопРасходыРеквизиты,
		ПараметрыПроведения.ДопРасходыТаблица);
	ТаблицаРасходовУСН = Документы.ПоступлениеДопРасходов.РаспределениеСуммыДопРасходовУСН(
		ПараметрыПроведения.ДопРасходыРеквизиты,
		ПараметрыПроведения.ПоступлениеРасходовУСНТаблицаРасходов);

	СтруктураТаблицДокумента = Новый Структура;
	СтруктураТаблицДокумента.Вставить("ТаблицаТовары", ДопРасходыТаблица);
	
	// Таблицы документа с корректировкой сумм по курсу авансов
	СтруктураТаблицДокумента = УчетДоходовРасходов.ПодготовитьТаблицыПоступленияПоКурсуАвансов(
		СтруктураТаблицДокумента,
		ТаблицаВзаиморасчетов,
		ПараметрыПроведения.ЗачетАвансовРеквизиты);

	// Структура таблиц для отражения в налоговом учете УСН
	СтруктураТаблицУСН = Новый Структура("ТаблицаРасчетов", ТаблицаВзаиморасчетов);
	
	// Учет доходов и расходов ИП
	// Распределение суммы доп.расхода:
	ТаблицаРасходовИП = Документы.ПоступлениеДопРасходов.РаспределениеСуммыДопРасходов(
		ПараметрыПроведения.ПоступлениеМПЗИПРеквизиты,
		ПараметрыПроведения.ПоступлениеМПЗИПТаблицаТоваров,
		Истина);
	
	ТаблицаТоваровИП = УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицуПоступленияМПЗ(
		ТаблицаРасходовИП,
		ПараметрыПроведения.ПоступлениеМПЗИПРеквизиты);
		
	ТаблицаОстатковОСНМАИП = УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицуОстатковОСНМА(
		ТаблицаТоваровИП,
		ПараметрыПроведения.ПоступлениеМПЗИПРеквизиты);
		
	СтруктураТаблицМПЗ = Новый Структура("ТаблицаТоваров", ТаблицаТоваровИП);
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ

	// Зачет аванса
	УчетВзаиморасчетов.СформироватьДвиженияЗачетАвансов(
		ТаблицаВзаиморасчетов,
		ПараметрыПроведения.ЗачетАвансовРеквизиты,
		Движения, Отказ);

	// Увеличение стоимости товаров
	УчетТоваров.СформироватьДвиженияИзменениеСебестоимостиОстатковТоваров(
		СтруктураТаблицДокумента.ТаблицаТовары,
		ПараметрыПроведения.ДопРасходыРеквизиты, Движения, Отказ);
		
	// Учет НДС
	УчетНДС.СформироватьДвиженияПоступлениеДопРасходовОтПоставщика(
		СтруктураТаблицДокумента.ТаблицаТовары,
		ПараметрыПроведения.ДопРасходыРеквизиты,
		Движения, Отказ);
		
	УчетНДСРаздельный.СформироватьДвиженияПоступлениеДопРасходовОтПоставщика(
		СтруктураТаблицДокумента.ТаблицаТовары,
		ПараметрыПроведения.ДопРасходыРеквизиты,
		Движения, Отказ);
		
	//Регистр "Рублевые суммы документов в валюте"
	УчетНДСБП.СформироватьДвиженияРублевыеСуммыДокументовВВалютеПоступлениеСобственныхТоваровУслуг(СтруктураТаблицДокумента.ТаблицаТовары, 
		ПараметрыПроведения.ДопРасходыРеквизиты, Движения, Отказ);	

	// УСН
	СуммаСторноРасхода = 0;
	УчетУСН.ПоступлениеРасходовУСН(ТаблицаРасходовУСН, 
		ПараметрыПроведения.ПоступлениеРасходовУСНРеквизиты, СуммаСторноРасхода, Движения, Отказ);

	Если НЕ Отказ И Движения.РасходыПриУСН.Количество()>0 Тогда
		Движения.РасходыПриУСН.Записать(Истина);
		Движения.РасходыПриУСН.Записывать = Ложь;
	КонецЕсли; 
	
	НалоговыйУчетУСН.СформироватьДвиженияУСН(ЭтотОбъект, СтруктураТаблицУСН);
	
	// Учет доходов и расходов ИП
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияПоступлениеМПЗ(СтруктураТаблицМПЗ,
		ТаблицаВзаиморасчетов, ТаблицаОстатковОСНМАИП, ПараметрыПроведения.ПоступлениеМПЗИПРеквизиты, Движения, Отказ);
	
	// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.Реквизиты,
		Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(
		ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты,
		Движения, Отказ);
		
	УчетУСН.СформироватьДвиженияПереоценкаВалютныхОстатков(
		ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты,
		Движения, Отказ);

	// Отложенные расчеты с контрагентами.
	УчетВзаиморасчетовОтложенноеПроведение.ЗарегистрироватьОтложенныеРасчетыСКонтрагентами(
		ЭтотОбъект, Отказ, ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение);
		
	// Регистрация в последовательности
	РаботаСПоследовательностями.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(
		ЭтотОбъект, Отказ, ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение, ПараметрыПроведения.ТаблицаОприходованныеТовары);

	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
		
	Движения.Записать();
	
	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("Проведен", ЭтотОбъект, "СчетФактураПолученный");	
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ, НЕ УстановленСтатусДокумента);
		
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("Проведен", ЭтотОбъект, "СчетФактураПолученный");	
	ПараметрыДействия.СостояниеФлага = Ложь;
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);

	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения)

	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		ЗаполнитьПоПоступлению(ДанныеЗаполнения);
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьПоПоступлению(ДанныеЗаполнения) Экспорт

	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ДанныеЗаполнения);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Док.Ссылка КАК Ссылка,
	|	Док.Организация КАК Организация,
	|	Док.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|	Док.Склад КАК Склад,
	|	Док.Контрагент КАК Контрагент,
	|	Док.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	Док.ВалютаДокумента КАК ВалютаДокумента,
	|	Док.КурсВзаиморасчетов КАК КурсВзаиморасчетов,
	|	Док.КратностьВзаиморасчетов КАК КратностьВзаиморасчетов,
	|	Док.СуммаВключаетНДС КАК СуммаВключаетНДС,
	|	Док.СчетУчетаРасчетовСКонтрагентом КАК СчетУчетаРасчетовСКонтрагентом,
	|	Док.СчетУчетаРасчетовПоАвансам КАК СчетУчетаРасчетовПоАвансам,
	|	Док.СчетУчетаРасчетовПоТаре КАК СчетУчетаРасчетовПоТаре
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг КАК Док
	|ГДЕ
	|	Док.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	1 КАК НомерТабличнойЧасти,
	|	Док.НомерСтроки КАК НомерСтроки,
	|	Док.Номенклатура КАК Номенклатура,
	|	Док.Ссылка КАК Ссылка,
	|	Док.Сумма КАК Сумма,
	|	Док.СуммаНДС КАК СуммаНДС,
	|	Док.Количество КАК Количество,
	|	Док.СчетУчета КАК СчетУчета,
	|	Док.СчетУчетаНДС КАК СчетУчетаНДС,
	|	Док.СпособУчетаНДС КАК СпособУчетаНДС,
	|	Док.ОтражениеВУСН КАК ОтражениеВУСН
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг.Товары КАК Док
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный КАК СчетУчетаПоСтроке
	|		ПО Док.СчетУчета = СчетУчетаПоСтроке.Ссылка
	|ГДЕ
	|	Док.Ссылка = &ДокументОснование
	|	И НЕ ЕСТЬNULL(СчетУчетаПоСтроке.Забалансовый, ЛОЖЬ)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2,
	|	Док.НомерСтроки,
	|	Док.Номенклатура,
	|	Док.Ссылка,
	|	Док.Сумма,
	|	Док.СуммаНДС,
	|	Док.Количество,
	|	Док.СчетУчета,
	|	Док.СчетУчетаНДС,
	|	Док.СпособУчетаНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ОтражениеВУСН.НеПринимаются)
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг.Оборудование КАК Док
	|ГДЕ
	|	Док.Ссылка = &ДокументОснование
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерТабличнойЧасти,
	|	Док.НомерСтроки";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ВыборкаШапки = РезультатЗапроса[0].Выбрать();
	
	Если ВыборкаШапки.Следующий() Тогда
		
		Если ВалютаДокумента <> ВалютаРеглУчета Тогда
			КурсИКратность          = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
			КурсВзаиморасчетов      = КурсИКратность.Курс;
			КратностьВзаиморасчетов = КурсИКратность.Кратность;
		КонецЕсли;
		
		Если ДоговорКонтрагента = ВыборкаШапки.ДоговорКонтрагента Тогда
			СчетУчетаРасчетовСКонтрагентом 	= ВыборкаШапки.СчетУчетаРасчетовСКонтрагентом;
			СчетУчетаРасчетовПоАвансам 		= ВыборкаШапки.СчетУчетаРасчетовПоАвансам;
			Если НДСНеВыделять Тогда
				СтавкаНДС = Перечисления.СтавкиНДС.БезНДС;
			Иначе
				СтавкаНДС = Справочники.ДоговорыКонтрагентов.СтавкаНДСПоДоговору(Дата, ВыборкаШапки.ДоговорКонтрагента);
			КонецЕсли;
		КонецЕсли;
			
		Выборка = РезультатЗапроса[1].Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СтрокаТабличнойЧасти = Товары.Добавить();
			
			СтрокаТабличнойЧасти.Номенклатура   = Выборка.Номенклатура;
			СтрокаТабличнойЧасти.Количество     = Выборка.Количество;
			СтрокаТабличнойЧасти.ДокументПартии = ДанныеЗаполнения;
			СтрокаТабличнойЧасти.СуммаТовара    = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
				Выборка.Сумма + ?(НЕ ВыборкаШапки.СуммаВключаетНДС, Выборка.СуммаНДС, 0),
				ВыборкаШапки.ВалютаДокумента,
				ВалютаДокумента,
				ВыборкаШапки.КурсВзаиморасчетов,
				КурсВзаиморасчетов,
				ВыборкаШапки.КратностьВзаиморасчетов,
				КратностьВзаиморасчетов);
			
			СтрокаТабличнойЧасти.СчетУчета      = Выборка.СчетУчета;
			СтрокаТабличнойЧасти.СчетУчетаНУ    = Выборка.СчетУчета;
			СтрокаТабличнойЧасти.СпособУчетаНДС = Выборка.СпособУчетаНДС;
			СтрокаТабличнойЧасти.ОтражениеВУСН  = Выборка.ОтражениеВУСН;
		
		КонецЦикла;
		
	КонецЕсли; 

КонецПроцедуры

Процедура УстановитьСтатусДокумента()
	
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("СтатусДокумента")
		И УчетНДСПереопределяемый.НайтиПодчиненныйСчетФактуруПолученный(ЭтотОбъект.Ссылка) <> Неопределено Тогда
		// Записываем из списка документов. Движения по статусам сформирует счет-фактура.
		Возврат;
	КонецЕсли;
	
	Статусы = Новый Структура("СтатусДокумента, СтатусСчетаФактуры");
	ЗаполнитьЗначенияСвойств(Статусы, ДополнительныеСвойства);
	
	Если Статусы.СтатусСчетаФактуры = Неопределено Или ПометкаУдаления Тогда
		// При записи из формы не определили статус счета-фактуры. Рассчитаем его по реквизитам документа.
		Статусы.СтатусСчетаФактуры = СтатусСчетаФактурыПоУмолчанию();
	КонецЕсли;
	
	УстановленСтатусДокумента = Истина;
	РегистрыСведений.СтатусыДокументов.УстановитьСтатусыДокумента(ЭтотОбъект.Ссылка, Статусы.СтатусДокумента, , Статусы.СтатусСчетаФактуры);
	
КонецПроцедуры

Функция СтатусСчетаФактурыПоУмолчанию()
	
	Если НДСНеВыделять
		Или Не Справочники.ДоговорыКонтрагентов.ТребуетсяСчетФактураПолученный(ДоговорКонтрагента) Тогда
		Возврат Перечисления.СтатусыСчетаФактуры.НеТребуется;
	ИначеЕсли НЕ РаботаСДоговорамиКонтрагентовБП.ДокументСНДС(ЭтотОбъект.Ссылка) Тогда
		Возврат Перечисления.СтатусыСчетаФактуры.НеТребуется;
	КонецЕсли;
	
	Возврат Перечисления.СтатусыСчетаФактуры.Отсутствует;
	
КонецФункции

#КонецОбласти

#Область Инициализация

УстановленСтатусДокумента = Ложь;

#КонецОбласти

#КонецЕсли