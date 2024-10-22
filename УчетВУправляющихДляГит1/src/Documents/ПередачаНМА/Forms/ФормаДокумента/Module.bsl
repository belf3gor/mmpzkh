// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Перем ПроверкаКонтрагентовПараметрыОбработчикаОжидания Экспорт;
&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	УчетНДС.ПрименитьПраваДоступаСчетаФактуры(
		СчетФактура,
		Элементы.СчетФактураПросмотр,
		Элементы.СчетФактураРедактирование);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереДокумент(ЭтотОбъект, Параметры);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОткрытииДокумент(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ВыборПорядкаУчетаРасчетов" Тогда
		ОбработкаВыбораПорядокУчетаРасчетовНаСервере(ВыбранноеЗначение);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Запись_СчетФактураВыданный"
		И ТипЗнч(Параметр) = Тип("Структура") И Параметр.Свойство("ДокументыОснования") И Параметр.ДокументыОснования.Найти(Объект.Ссылка) <> Неопределено Тогда
		ЗаполнитьРеквизитыПроСчетФактуру(ЭтаФорма, Параметр.РеквизитыСФ);
		УправлениеФормой(ЭтаФорма);
	Иначе
		ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "ПроведениеПередачаНМА";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередЗаписьюНаСервереДокумент(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ИспользуетсяПланированиеПлатежей Тогда
		СрокиОплатыДокументов.ОбновитьСрокОплаты(Объект.Ссылка, СрокОплаты, АвторасчетСрокаОплаты);
		ПараметрыЗаписи.Вставить("СрокОплаты", СрокОплаты);
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Если ПараметрыЗаписи.Свойство("ВыписатьСчетФактуру") 
		И ПараметрыЗаписи.ВыписатьСчетФактуру Тогда 
		
		РеквизитыСФ = УчетНДСВызовСервера.СоздатьСчетФактуруВыданныйНаОсновании(ТекущийОбъект.Ссылка, Неопределено, УникальныйИдентификатор);
		
		Если Не УчетНДСБП.НужноОжидатьОкончаниеАктуализации(РеквизитыСФ, ПараметрыЗаписи) Тогда
			ЗаполнитьРеквизитыПроСчетФактуру(ЭтаФорма, РеквизитыСФ);
			УправлениеФормой(ЭтаФорма);
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьСостояниеДокумента();
	
	ПараметрыЗаписи.Вставить("СрокОплаты", СрокОплаты);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УчетНДСКлиент.ОжидатьОкончаниеАктуализации(ЭтотОбъект, ПараметрыЗаписи);
	
	Оповестить("Запись_ПередачаНМА", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента, Объект.ВалютаДокумента, ВалютаРегламентированногоУчета);
	
	ТребуетсяПерерасчитатьСрокОплаты = 
		ИспользуетсяПланированиеПлатежей И АвторасчетСрокаОплаты И (НачалоДня(Объект.Дата) <> НачалоДня(ТекущаяДатаДокумента));
	
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера ИЛИ ТребуетсяПерерасчитатьСрокОплаты Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Объект.Дата);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	УстановитьФункциональныеОпцииФормы();
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		КонтрагентПриИзмененииНаСервере();
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		
		ДоговорКонтрагентаПриИзмененииНаСервере();
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПорядокУчетаРасчетовНажатие(Элемент, СтандартнаяОбработка)

	Если НЕ ТолькоПросмотр Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;

	СтандартнаяОбработка = Ложь;

	АдресХранилищаЗачетАвансов = ПоместитьЗачетАвансовВоВременноеХранилищеНаСервере();
	
	ТипыДокументов        = "Метаданные.Документы.ПередачаНМА.ТабличныеЧасти.ЗачетАвансов.Реквизиты.ДокументАванса.Тип";
	РежимОтбораДокументов = ПредопределенноеЗначение("Перечисление.РежимОтбораДокументов.ПоОстаткам");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТолькоПросмотр",                 ТолькоПросмотр);
	ПараметрыФормы.Вставить("Дата",                           Объект.Дата);
	ПараметрыФормы.Вставить("ДоговорКонтрагента",             Объект.ДоговорКонтрагента);
	ПараметрыФормы.Вставить("Контрагент",                     Объект.Контрагент);
	ПараметрыФормы.Вставить("Организация",                    Объект.Организация);
	ПараметрыФормы.Вставить("ОстаткиОбороты",                 "Кт");
	ПараметрыФормы.Вставить("ТипыДокументов",                 ТипыДокументов);
	ПараметрыФормы.Вставить("РежимОтбораДокументов",          РежимОтбораДокументов);
	ПараметрыФормы.Вставить("АдресХранилищаЗачетАвансов",     АдресХранилищаЗачетАвансов);
	ПараметрыФормы.Вставить("СпособЗачетаАвансов",            Объект.СпособЗачетаАвансов);
	ПараметрыФормы.Вставить("СчетУчетаРасчетовСКонтрагентом", Объект.СчетУчетаРасчетовСКонтрагентом);
	ПараметрыФормы.Вставить("СчетУчетаРасчетовПоАвансам",     Объект.СчетУчетаРасчетовПоАвансам);
	ПараметрыФормы.Вставить("ВсегдаОтображатьСчетаУчета",     Истина);
	ПараметрыФормы.Вставить("СрокОплаты",                     СрокОплаты);
	ПараметрыФормы.Вставить("ИспользуетсяСрокОплаты",         ИспользуетсяПланированиеПлатежей);

	ОткрытьФорму("ОбщаяФорма.ВыборПорядкаУчетаРасчетов", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ЦеныИВалютаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьИзмененияПоКнопкеЦеныИВалюты();

КонецПроцедуры

&НаКлиенте
Процедура НематериальныйАктивПриИзменении(Элемент)
	
	Если НЕ ПлательщикНДС Тогда
		Объект.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)

	Объект.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
		Объект.Сумма, Объект.СуммаВключаетНДС,
		УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(Объект.СтавкаНДС));
	Объект.СуммаДокумента = ?(Объект.СуммаВключаетНДС, Объект.Сумма, Объект.Сумма + Объект.СуммаНДС);

КонецПроцедуры

&НаКлиенте
Процедура СтавкаНДСПриИзменении(Элемент)

	СуммаБезНДС     = ?(Объект.СуммаВключаетНДС, Объект.Сумма - Объект.СуммаНДС, Объект.Сумма);
	Объект.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
		Объект.Сумма, Объект.СуммаВключаетНДС,
		УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(Объект.СтавкаНДС));
	Объект.Сумма          = ?(Объект.СуммаВключаетНДС, СуммаБезНДС + Объект.СуммаНДС, СуммаБезНДС);
	Объект.СуммаДокумента = ?(Объект.СуммаВключаетНДС, Объект.Сумма, Объект.Сумма + Объект.СуммаНДС);
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СуммаНДСПриИзменении(Элемент)

	СуммаБезНДС           = ?(Объект.СуммаВключаетНДС, Объект.Сумма - Объект.СуммаНДС, Объект.Сумма);
	Объект.Сумма          = ?(Объект.СуммаВключаетНДС, СуммаБезНДС + Объект.СуммаНДС, СуммаБезНДС);
	Объект.СуммаДокумента = ?(Объект.СуммаВключаетНДС, Объект.Сумма, Объект.Сумма + Объект.СуммаНДС);
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СчетДоходовПриИзменении(Элемент)
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСчета(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьСчетФактураНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БухгалтерскийУчетКлиентПереопределяемый.ОткрытьСчетФактуру(ЭтаФорма, СчетФактура, "СчетФактураВыданный");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыписатьСчетФактуру(Команда)
	
	РеквизитыСФ = УчетНДСКлиент.СоздатьСчетФактуруВыданный(ЭтаФорма);
	Если РеквизитыСФ = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРеквизитыПроСчетФактуру(ЭтаФорма, РеквизитыСФ);
	УправлениеФормой(ЭтаФорма);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элементы.НадписьСчетФактура);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКонтрагентов(Команда)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПроверитьКонтрагентовВДокументеПоКнопке(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// ПорядокУчетаРасчетов

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ПорядокУчетаРасчетов");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"СчетаРасчетовЗаполнены", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненныйРеквизит);

КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	УстановитьСостояниеДокумента();
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ДоговорУказан = ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
	
	Если ДоговорУказан Тогда
		РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Объект.ДоговорКонтрагента, "РасчетыВУсловныхЕдиницах, ВалютаВзаиморасчетов");
		ВалютаВзаиморасчетов = РеквизитыДоговора.ВалютаВзаиморасчетов;
	Иначе
		ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета;
		
		Если ЗначениеЗаполнено(Объект.Контрагент)
			и НЕ ЗначениеЗаполнено(Объект.Ссылка) 
			и НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			КонтрагентОбработатьИзменениеНаСервере();
		КонецЕсли;
		
	КонецЕсли;	
	
	ТекущаяДатаДокумента = Объект.Дата;
	
	ЗаполнитьРеквизитыПроСчетФактуру(ЭтаФорма);
	
	УчетВзаиморасчетов.УстановитьПорядокУчетаРасчетов(ЭтаФорма, Истина);
	
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоШапки(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ПлательщикНДС                        = УчетнаяПолитика.ПлательщикНДС(Объект.Организация, Объект.Дата);
	ЕстьВалютныйУчет                     = БухгалтерскийУчетПереопределяемый.ИспользоватьВалютныйУчет();
	ИспользуетсяПланированиеПлатежей     = ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПлатежейОтПокупателей");
	ВестиУчетПоДоговорам                 = ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам");
	ИспользоватьОднуНоменклатурнуюГруппу = БухгалтерскийУчетВызовСервераПовтИсп.ИспользоватьОднуНоменклатурнуюГруппу();

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	// Доступность взаимосвязанных полей
	Элементы.ДоговорКонтрагента.Доступность       = ЗначениеЗаполнено(Объект.Организация) И ЗначениеЗаполнено(Объект.Контрагент);
	Элементы.ПодразделениеОрганизации.Доступность = ЗначениеЗаполнено(Объект.Организация);
	
	ДоступностьПорядокУчетаРасчетов = (Не Форма.ВестиУчетПоДоговорам И ЗначениеЗаполнено(Объект.Контрагент)) ИЛИ ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
	Элементы.ПорядокУчетаРасчетов.Доступность = ДоступностьПорядокУчетаРасчетов;
	Элементы.ПорядокУчетаРасчетов.Гиперссылка = ДоступностьПорядокУчетаРасчетов;
	
	Элементы.СчетУчетаНДСПоРеализации.АвтоОтметкаНезаполненного = Объект.СуммаНДС <> 0;
	Элементы.СчетУчетаНДСПоРеализации.ОтметкаНезаполненного     = Объект.СуммаНДС <> 0;
	
	Элементы.СуммаНДС.Доступность = Не Объект.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС")
		И Не Объект.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС0");
	
	// Счет-фактура
	УчетНДСКлиентСервер.НастроитьПоляСчетаФактуры(
		Элементы.СчетФактураКнопка,
		Элементы.СчетФактураСсылка,
		Элементы.НадписьСчетФактура,
		Объект.ДокументБезНДС,
		Истина,
		Форма.СчетФактура);
	
	Элементы.СтавкаНДС.Видимость                = Не Объект.ДокументБезНДС;
	Элементы.СуммаНДС.Видимость                 = Не Объект.ДокументБезНДС;
	Элементы.СчетУчетаНДСПоРеализации.Видимость = Не Объект.ДокументБезНДС;
	
	СформироватьНадписьЦеныИВалюта(Форма);
	
КонецПроцедуры

// Обслуживание счета-фактуры:

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьРеквизитыПроСчетФактуру(Форма, РеквизитыСФ = Неопределено)

	УчетНДСКлиентСервер.ЗаполнитьРеквизитыФормыПроСчетФактуруВыданный(
		Форма,
		РеквизитыСФ,
		Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработатьВыпискуСчетаФактуры(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Результат.Вставить("ФоновоеВыполнение", Истина);
	КонецЕсли;
	РеквизитыСФ = УчетНДСКлиент.ОбработатьВыпискуСчетаФактуры(ЭтотОбъект, Результат, ДополнительныеПараметры);
	
	Если РеквизитыСФ = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРеквизитыПроСчетФактуру(ЭтотОбъект, РеквизитыСФ);
	УправлениеФормой(ЭтотОбъект);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элементы.НадписьСчетФактура);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

// Обслуживание цен / валют / налогов:

&НаКлиенте
Процедура ОбработатьИзмененияПоКнопкеЦеныИВалюты()

	// Формирование структуры параметров для заполнения формы "Цены и Валюта".
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ВалютаДокумента"     , Объект.ВалютаДокумента);
	СтруктураПараметров.Вставить("Курс"                , Объект.КурсВзаиморасчетов);
	СтруктураПараметров.Вставить("Кратность"           , Объект.КратностьВзаиморасчетов);
	СтруктураПараметров.Вставить("СуммаВключаетНДС"    , Объект.СуммаВключаетНДС);
	СтруктураПараметров.Вставить("ДокументБезНДС",       Объект.ДокументБезНДС);
	СтруктураПараметров.Вставить("Контрагент"          , Объект.Контрагент);
	СтруктураПараметров.Вставить("Договор"             , Объект.ДоговорКонтрагента);
	СтруктураПараметров.Вставить("Организация"         , Объект.Организация);
	СтруктураПараметров.Вставить("ДатаДокумента"       , Объект.Дата);
	СтруктураПараметров.Вставить("ТолькоПросмотр"      , ТолькоПросмотр);
	
	ДополнительныеПараметры = Новый Структура;
	
	Если ЕстьВалютныйУчет И ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета Тогда 
		ОткрыватьИзМеню = Ложь;
	Иначе
		ОткрыватьИзМеню = Истина;
		ДополнительныеПараметры.Вставить("СтруктураПараметровКоманды", СтруктураПараметров);
	КонецЕсли;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьИзмененияПоКнопкеЦеныИВалютыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Если ОткрыватьИзМеню Тогда
		
		СписокКоманд = Новый СписокЗначений;
		
		Если Не ПлательщикНДС Тогда
			СписокКоманд.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.ДокументБезНДС"));
		КонецЕсли;
		СписокКоманд.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.НДССверху"));
		СписокКоманд.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.НДСВСумме"));
		
		ПоказатьВыборИзМеню(ОповещениеОЗакрытии, СписокКоманд, Элементы.ЦеныИВалюта);		
	Иначе
		ОткрытьФорму("ОбщаяФорма.ФормаЦеныИВалюта", СтруктураПараметров,,,,,ОповещениеОЗакрытии);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзмененияПоКнопкеЦеныИВалютыЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.Свойство("СтруктураПараметровКоманды") Тогда
		
		СтруктураЦеныИВалюта = ДополнительныеПараметры.СтруктураПараметровКоманды;
		
		СуммаВключаетНДСДоИзменения = СтруктураЦеныИВалюта.СуммаВключаетНДС;
		Если РезультатЗакрытия = Неопределено Тогда 
			Возврат;
		ИначеЕсли РезультатЗакрытия.Значение = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.ДокументБезНДС") Тогда
			СтруктураЦеныИВалюта.ДокументБезНДС 	= Истина;
		ИначеЕсли РезультатЗакрытия.Значение = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.НДСВСумме") Тогда
			СтруктураЦеныИВалюта.ДокументБезНДС 	= Ложь;
			СтруктураЦеныИВалюта.СуммаВключаетНДС 	= Истина;
		Иначе
			СтруктураЦеныИВалюта.ДокументБезНДС 	= Ложь;
			СтруктураЦеныИВалюта.СуммаВключаетНДС 	= Ложь;
		КонецЕсли;
		
		СтруктураЦеныИВалюта.Вставить("ПерезаполнитьЦены",    Ложь);
		СтруктураЦеныИВалюта.Вставить("ПересчитатьЦены",      Ложь);
		СтруктураЦеныИВалюта.Вставить("ПересчитатьНДС",       СуммаВключаетНДСДоИзменения <> СтруктураЦеныИВалюта.СуммаВключаетНДС
			ИЛИ Объект.ДокументБезНДС <> СтруктураЦеныИВалюта.ДокументБезНДС);
		СтруктураЦеныИВалюта.Вставить("БылиВнесеныИзменения", СуммаВключаетНДСДоИзменения <> СтруктураЦеныИВалюта.СуммаВключаетНДС
			ИЛИ Объект.ДокументБезНДС <> СтруктураЦеныИВалюта.ДокументБезНДС);
			
	Иначе
		СтруктураЦеныИВалюта = РезультатЗакрытия;
	КонецЕсли;
	
	Если ТипЗнч(СтруктураЦеныИВалюта) = Тип("Структура") И СтруктураЦеныИВалюта.БылиВнесеныИзменения Тогда

		ВалютаДоИзменения    = Объект.ВалютаДокумента;
		КурсДоИзменения    	 = Объект.КурсВзаиморасчетов;
		КратностьДоИзменения = Объект.КратностьВзаиморасчетов;
		
		Объект.ВалютаДокумента 			= СтруктураЦеныИВалюта.ВалютаДокумента;
		Объект.КурсВзаиморасчетов 		= СтруктураЦеныИВалюта.Курс;
		Объект.КратностьВзаиморасчетов 	= СтруктураЦеныИВалюта.Кратность;
		Объект.СуммаВключаетНДС 		= СтруктураЦеныИВалюта.СуммаВключаетНДС;
		Объект.ДокументБезНДС		   	= СтруктураЦеныИВалюта.ДокументБезНДС;

		Модифицированность = Истина;
		
		Если СтруктураЦеныИВалюта.ПересчитатьЦены ИЛИ СтруктураЦеныИВалюта.ПересчитатьНДС Тогда
			ЗаполнитьРассчитатьСуммы(ВалютаДоИзменения, КурсДоИзменения, КратностьДоИзменения, СтруктураЦеныИВалюта.ПересчитатьЦены, СтруктураЦеныИВалюта.ПересчитатьНДС);
		КонецЕсли;
		
		СформироватьНадписьЦеныИВалюта(ЭтаФорма);

	КонецЕсли;
		 	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРассчитатьСуммы(Знач ВалютаДоИзменения, КурсДоИзменения, КратностьДоИзменения, ПересчитатьЦены = Ложь, ПересчитатьНДС = Ложь)

	Если ПересчитатьЦены Тогда
		Если КурсДоИзменения <> 0 И КратностьДоИзменения <> 0 Тогда
			СтруктураКурса = Новый Структура("Курс, Кратность", КурсДоИзменения, КратностьДоИзменения);
		Иначе
			СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДоИзменения, Объект.Дата);
		КонецЕсли;
	КонецЕсли;

	УправлениеФормой(ЭтаФорма);
	РассчитатьСуммы(ВалютаДоИзменения, СтруктураКурса, ПересчитатьЦены, ПересчитатьНДС);

КонецПроцедуры

&НаСервере
Процедура РассчитатьСуммы(ВалютаПередИзменением, СтруктураКурса, ПересчитатьЦены, ПересчитатьНДС)

	Если ПересчитатьЦены Тогда
		Объект.Сумма = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
			Объект.Сумма,
			ВалютаПередИзменением, Объект.ВалютаДокумента, 
			СтруктураКурса.Курс, Объект.КурсВзаиморасчетов,
			СтруктураКурса.Кратность, Объект.КратностьВзаиморасчетов);
	КонецЕсли;
		
	ЦенаВключаетНДС = ?(ПересчитатьНДС, НЕ Объект.СуммаВключаетНДС, Объект.СуммаВключаетНДС);

	Если Объект.ДокументБезНДС Тогда
		Объект.СтавкаНДС = Перечисления.СтавкиНДС.БезНДС;
	КонецЕсли;
		
	Объект.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
		Объект.Сумма, Объект.СуммаВключаетНДС, 
		УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(Объект.СтавкаНДС));

КонецПроцедуры

// Серверная обработка изменения реквизитов:

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	ДатаОбработатьИзменение();
	УправлениеФормой(ЭтаФорма);
	УчетВзаиморасчетов.УстановитьПорядокУчетаРасчетов(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ДатаОбработатьИзменение()
	
	УстановитьФункциональныеОпцииФормы();
	
	Если ПлательщикНДС Тогда 
		Объект.ДокументБезНДС = Ложь;
	КонецЕсли;
	
	Если (Объект.ВалютаДокумента <> ВалютаРегламентированногоУчета) Тогда
		СтруктураКурсаДокумента        = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.ВалютаДокумента, Объект.Дата);
		Объект.КурсВзаиморасчетов      = СтруктураКурсаДокумента.Курс;
		Объект.КратностьВзаиморасчетов = СтруктураКурсаДокумента.Кратность;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ОрганизацияОбработатьИзменение();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияОбработатьИзменение()

	УстановитьФункциональныеОпцииФормы();
	
	Если ПлательщикНДС Тогда 
		Объект.ДокументБезНДС = Ложь;
	КонецЕсли;

	ПодразделениеПоУмолчанию = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновноеПодразделениеОрганизации");
	Если БухгалтерскийУчетПереопределяемый.ПодразделениеПринадлежитОрганизации(ПодразделениеПоУмолчанию, Объект.Организация) Тогда
		Объект.ПодразделениеОрганизации = ПодразделениеПоУмолчанию;
	КонецЕсли;
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииОрганизации(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));

	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		КонтрагентОбработатьИзменениеНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()

	КонтрагентОбработатьИзменениеНаСервере();
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура КонтрагентОбработатьИзменениеНаСервере()

	РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
		Объект.ДоговорКонтрагента, Объект.Контрагент, Объект.Организация, 
		БухгалтерскийУчетПереопределяемый.ПолучитьМассивВидовДоговоров(, Истина));

	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		ДоговорКонтрагентаПриИзмененииНаСервере();
	ИначеЕсли НЕ ВестиУчетПоДоговорам Тогда
		УстановитьСчетаУчетаРасчетовСпособЗачетаАвансов();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ДоговорКонтрагентаПриИзмененииНаСервере()

	ДоговорКонтрагентаОбработатьИзменение();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ДоговорКонтрагентаОбработатьИзменение()

	ВалютаДоИзменения	 = Объект.ВалютаДокумента;
	КурсДоИзменения   	 = Объект.КурсВзаиморасчетов;
	КратностьДоИзменения = Объект.КратностьВзаиморасчетов;

	РеквизитыДоговора = БухгалтерскийУчетПереопределяемый.ПолучитьРеквизитыДоговораКонтрагента(
		Объект.ДоговорКонтрагента);

	Объект.ВалютаДокумента         = РеквизитыДоговора.ВалютаВзаиморасчетов;
	СтруктураКурсаДокумента        = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.ВалютаДокумента, Объект.Дата);
	Объект.КурсВзаиморасчетов      = СтруктураКурсаДокумента.Курс;
	Объект.КратностьВзаиморасчетов = СтруктураКурсаДокумента.Кратность;
	
	ВалютаВзаиморасчетов 	=  РеквизитыДоговора.ВалютаВзаиморасчетов;

	ПересчитатьЦены = Объект.ВалютаДокумента <> ВалютаДоИзменения
		ИЛИ Объект.КурсВзаиморасчетов <> КурсДоИзменения;
	ПересчитатьНДС = Ложь;
	
	ЗаполнитьРассчитатьСуммы(ВалютаДоИзменения, КурсДоИзменения, КратностьДоИзменения, ПересчитатьЦены, ПересчитатьНДС);
	
	УстановитьСчетаУчетаРасчетовСпособЗачетаАвансов();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПорядокУчетаРасчетовНаСервере(ВыбранноеЗначение)

	УчетВзаиморасчетов.ОбработкаВыбораПорядокУчетаРасчетов(ЭтаФорма, ВыбранноеЗначение);
	УчетВзаиморасчетов.УстановитьПорядокУчетаРасчетов(ЭтаФорма, Истина);

КонецПроцедуры

&НаСервере
Функция ПоместитьЗачетАвансовВоВременноеХранилищеНаСервере()

	Возврат ПоместитьВоВременноеХранилище(Объект.ЗачетАвансов.Выгрузить(), УникальныйИдентификатор);

КонецФункции

&НаСервере
Процедура УстановитьСчетаУчетаРасчетовСпособЗачетаАвансов()
	
	Документы.ПередачаНМА.ЗаполнитьСчетаУчетаРасчетов(Объект);
	
	Объект.СпособЗачетаАвансов = Перечисления.СпособыЗачетаАвансов.Автоматически;
	Объект.ЗачетАвансов.Очистить();
	УчетВзаиморасчетов.УстановитьПорядокУчетаРасчетов(ЭтаФорма);

КонецПроцедуры

// Внешний вид, содержание надписей и т.п.

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьНадписьЦеныИВалюта(Форма)
	
	Объект = Форма.Объект;
	СтруктураНадписи = Новый Структура(
		"ВалютаДокумента, Курс, Кратность, СуммаВключаетНДС, ДокументБезНДС, ВалютаРегламентированногоУчета",
		Объект.ВалютаДокумента,
		Объект.КурсВзаиморасчетов,
		Объект.КратностьВзаиморасчетов,
		Объект.СуммаВключаетНДС,
		Объект.ДокументБезНДС,
		Форма.ВалютаРегламентированногоУчета);
	Форма.ЦеныИВалюта = ОбщегоНазначенияБПКлиентСервер.СформироватьНадписьЦеныИВалюта(СтруктураНадписи);

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыУстановкиСвойствСубконто(Форма)
	
	Результат = БухгалтерскийУчетКлиентСервер.НовыеПараметрыУстановкиСвойствСубконто();
	
	Результат.ПоляФормы.Субконто1   = "Субконто1";
	Результат.ПоляОбъекта.Субконто1 = "Субконто";
	Результат.ПоляОбъекта.СчетУчета = "СчетДоходов";
	
	Результат.ДопРеквизиты.Вставить("Организация", Форма.Объект.Организация);

	Возврат Результат;

КонецФункции

#Область ПроверкаКонтрагентов

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПроверкиКонтрагентов()
	ПроверкаКонтрагентовКлиент.ОбработатьРезультатПроверкиКонтрагентовВДокументе(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаСервере
Процедура ОтобразитьРезультатПроверкиКонтрагента() Экспорт
	ПроверкаКонтрагентов.ОтобразитьРезультатПроверкиКонтрагентаВДокументе(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаСервере
Процедура ПроверитьКонтрагентовФоновоеЗадание(ПараметрыФоновогоЗадания) Экспорт	
	ПроверкаКонтрагентов.ПроверитьКонтрагентовВДокументеФоновоеЗадание(ЭтотОбъект, ПараметрыФоновогоЗадания);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

#КонецОбласти

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
