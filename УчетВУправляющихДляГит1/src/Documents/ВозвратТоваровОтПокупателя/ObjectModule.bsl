#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
//

// Процедура выполняет заполнение возвратной тары по документу основанию.
// При заполнении копируется состав документа.
//
// Параметры:
//  ДокументОснование - ссылка на документ основание.
//
Процедура ЗаполнитьВозвратнуюТаруПоОснованию(ДокументОснование) Экспорт
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Ссылка.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	Док.Ссылка.ВалютаДокумента,
	|	ВЫБОР
	|		КОГДА Док.Ссылка.ВалютаДокумента = Док.Ссылка.ДоговорКонтрагента.ВалютаВзаиморасчетов
	|			ТОГДА Док.Ссылка.КурсВзаиморасчетов
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК КурсДокумента,
	|	ВЫБОР
	|		КОГДА Док.Ссылка.ВалютаДокумента = Док.Ссылка.ДоговорКонтрагента.ВалютаВзаиморасчетов
	|			ТОГДА Док.Ссылка.КратностьВзаиморасчетов
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК КратностьДокумента,
	|	Док.СчетУчета,
	|	Док.Номенклатура,
	|	Док.Количество,
	|	Док.Цена
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.ВозвратнаяТара КАК Док
	|ГДЕ
	|	Док.Ссылка = &ДокументОснование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаВозвратнойТары = ВозвратнаяТара.Добавить();
		
		СтрокаВозвратнойТары.Номенклатура = Выборка.Номенклатура;
		СтрокаВозвратнойТары.Количество   = Выборка.Количество;
		СтрокаВозвратнойТары.СчетУчета    = Выборка.СчетУчета;
		
		// Пересчитаем цену в валюту взаиморасчетов (в документах договоры могут отличаться).
		СтрокаВозвратнойТары.Цена = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(Выборка.Цена,
			Выборка.ВалютаДокумента, ВалютаДокумента,
			Выборка.КурсДокумента, ЗаполнениеДокументов.КурсДокумента(ЭтотОбъект, ВалютаРегламентированногоУчета),
			Выборка.КратностьДокумента, ЗаполнениеДокументов.КратностьДокумента(ЭтотОбъект, ВалютаРегламентированногоУчета));
		
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаВозвратнойТары);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(ДокументОснование, ДанныеЗаполнения)
	
	ОснованиеРеализацияТоваров = ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваровУслуг");
	Если ОснованиеРеализацияТоваров 
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ВидОперации") = Перечисления.ВидыОперацийРеализацияТоваров.ОтгрузкаБезПереходаПраваСобственности
		И НЕ Документы.РеализацияТоваровУслуг.ЕстьРеализацияПоДокументуОтгрузки(ДокументОснование) Тогда
		// Нельзя заполнять на основании документа отгрузки без перехода права, если на его основании не введена реализация
		ВызватьИсключение НСтр("ru='Возврат товаров от покупателя возможен только после оформления документа ""Реализация отгруженных товаров"".'");
	КонецЕсли;
	
	Если ОснованиеРеализацияТоваров ИЛИ ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ОтчетОРозничныхПродажах") Тогда
		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, ДокументОснование);
		Сделка = ДокументОснование;
		
		Если ДокументОснование.Проведен Тогда
			// Скопируем табличные части из документа основания.
			
			ОснованиеЗаполнения = ?(ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("РозничнаяПродажа"), ДанныеЗаполнения.РозничнаяПродажа, ДокументОснование);
			
			ТоварыПоДаннымОснования = Документы.ВозвратТоваровОтПокупателя.ТоварыПоДаннымОснования(ЭтотОбъект, ОснованиеЗаполнения);
			Если ТоварыПоДаннымОснования.Количество() > 0 Тогда
				Товары.Загрузить(ТоварыПоДаннымОснования);
			КонецЕсли;
			
			Если ОснованиеРеализацияТоваров Тогда
				ВозратнаяТараПоДаннымРеализации = Документы.ВозвратТоваровОтПокупателя.ВозратнаяТараПоДаннымРеализации(ЭтотОбъект, ДокументОснование);
				Если ВозратнаяТараПоДаннымРеализации.Количество() > 0 Тогда
					ВозвратнаяТара.Загрузить(ВозратнаяТараПоДаннымРеализации);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ОснованиеРеализацияТоваров И ДокументОснование.ВидОперации = Перечисления.ВидыОперацийРеализацияТоваров.Оборудование Тогда
			ВидОперации = Перечисления.ВидыОперацийВозвратТоваровОтПокупателя.Оборудование;
		Иначе
			ВидОперации = Перечисления.ВидыОперацийВозвратТоваровОтПокупателя.ПродажаКомиссия;
		КонецЕсли;
		
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьРеквизитыУчетаНДС() Экспорт
	
	Если ПокупателемВыставляетсяСчетФактураНаВозврат
			И (?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()) <= '20060101'
			ИЛИ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорКонтрагента, "ВидДоговора")
				= Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером) Тогда
		ПокупателемВыставляетсяСчетФактураНаВозврат = Ложь;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ
//

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено Тогда

		Если ТипДанныхЗаполнения <> Тип("Структура")
			И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
			ДокументОснование = ДанныеЗаполнения;
		ИначеЕсли ТипДанныхЗаполнения = Тип("Структура")
			И ДанныеЗаполнения.Свойство("Основание")
			И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Основание.Метаданные()) Тогда
			ДокументОснование = ДанныеЗаполнения.Основание;
		КонецЕсли;

		Если ДокументОснование <> Неопределено Тогда
			ЗаполнитьПоДокументуОснованию(ДокументОснование, ДанныеЗаполнения);
		Иначе
			СуммаВключаетНДС = Истина;
		КонецЕсли;
		
	Иначе
		СуммаВключаетНДС = Истина;
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения, Истина);
	
	ПокупателюВыставляетсяКорректировочныйСчетФактура = Истина;
	ОтразитьВКнигеПокупок = Истина;
	
	УстановитьРеквизитыУчетаНДС();

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
	СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(
	ВалютаДокумента, Дата);
	
	КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
	КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
	
	ПокупателюВыставляетсяКорректировочныйСчетФактура = НЕ ПокупателемВыставляетсяСчетФактураНаВозврат;
	ОтразитьВКнигеПокупок = Истина;
	
	Если ОбъектКопирования.ЕстьМаркируемаяПродукцияГИСМ Тогда
		Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "КиЗ_ГИСМ");
	КонецЕсли;
	
	Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "ИсправляемыйДокумент");
	Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "КоличествоПослеИзменения");
	Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "СуммаПослеИзменения");
	Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "СуммаНДСПослеИзменения");

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ПлательщикНДФЛ				= УчетнаяПолитика.ПлательщикНДФЛ(Организация, Дата);
	СпособОценкиТоваровВРознице	= УчетнаяПолитика.СпособОценкиТоваровВРознице(Организация, Дата);
	РаздельныйУчетНДСНаСчете19 	= УчетнаяПолитика.РаздельныйУчетНДСНаСчете19(Организация, Дата);
	ПрименяетсяУСНДоходыМинусРасходы = УчетнаяПолитика.ПрименяетсяУСНДоходыМинусРасходы(Организация, Дата);
	ВестиУчетПоДоговорам        = ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам");
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если ПроверяемыеРеквизиты.Найти("Склад") = Неопределено Тогда
		ПроверяемыеРеквизиты.Добавить("Склад");
	КонецЕсли;
	
	Если ВестиУчетПоДоговорам Тогда
		ВидДоговора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорКонтрагента, "ВидДоговора");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ДоговораКонтрагента");
		ВидДоговора = РаботаСДоговорамиКонтрагентовБП.ВидДоговораПоОбъекту(ЭтотОбъект);
	КонецЕсли;
	
	УказанДокументРеализации = ЗначениеЗаполнено(Сделка)
		И (ТипЗнч(Сделка) <> Тип("ДокументСсылка.ДокументРасчетовСКонтрагентом"))
		И (ТипЗнч(Сделка) <> Тип("ДокументСсылка.ОтражениеНачисленияНДС"));

	// ПРОВЕРКА ЗАПОЛНЕНИЯ РЕКВИЗИТОВ ШАПКИ

	Если НЕ ДеятельностьНаПатенте Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Патент");
	КонецЕсли;
	
	Если УказанДокументРеализации 
		И ТипЗнч(Сделка) = Тип("ДокументСсылка.РеализацияТоваровУслуг") 
		И ПравоДоступа("Чтение", Метаданные.Документы.РеализацияТоваровУслуг)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сделка, "ВидОперации") = Перечисления.ВидыОперацийРеализацияТоваров.ОтгрузкаБезПереходаПраваСобственности
		И НЕ Документы.РеализацияТоваровУслуг.ЕстьРеализацияПоДокументуОтгрузки(Сделка) Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Для документа %1 не отражена операция ""Реализация отгруженного товара""'"),
				Сделка);
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Корректность",
				НСтр("ru = 'Сделка'"),,, ТекстСообщения);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,
				"Сделка", "Объект", Отказ);
				
	КонецЕсли; 
	
	// Корректность договора контрагента:
	Если ВестиУчетПоДоговорам И ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ТекстСообщения = "";
		Если НЕ УчетВзаиморасчетов.ПроверитьВозможностьПроведенияВРеглУчете(ЭтотОбъект, ДоговорКонтрагента, ТекстСообщения) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Корректность",
				НСтр("ru = 'Договор'"),,, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,
				"ДоговорКонтрагента", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если ПокупателемВыставляетсяСчетФактураНаВозврат
		И НЕ (ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем
		И Товары.Найти(Перечисления.СтавкиНДС.НДС0, "СтавкаНДС") <> Неопределено) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Сделка");
	КонецЕсли;


	// Корректность склада - нельзя возвращать в НТТ
	Если ЗначениеЗаполнено(Склад) Тогда
		ТекстСообщения = НСтр("ru='При учете в продажных ценах нельзя возвращать товар в неавтоматизированную торговую точку.'");
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ТипСклада")
				= Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка И 
			СпособОценкиТоваровВРознице = Перечисления.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Корректность",
				НСтр("ru = 'Склад'"),,, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,
				"Склад", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;
	
	// ПРОВЕРКА ТАБЛИЧНОЙ ЧАСТИ ТОВАРЫ
	
	Если НЕ ПрименяетсяУСНДоходыМинусРасходы ИЛИ УказанДокументРеализации Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ОтражениеВУСН");
	КонецЕсли; 
	
	Если ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ПереданныеСчетУчета");
		Если УказанДокументРеализации Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Товары.Себестоимость");
		КонецЕсли;
	ИначеЕсли ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Сумма");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Себестоимость");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетДоходов");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СпособУчетаНДС");
	КонецЕсли;
	
	Если Дата >= '20190101' Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СпособУчетаНДС");
	КонецЕсли;
	
	// Исключаем из проверки те реквизиты табличных частей, обязательность которых
	//	зависит от значений других рекивизитов в строках табличных частей:
	МассивНепроверяемыхРеквизитов.Добавить("Товары.СуммаНДС");

	ИмяСписка = НСтр("ru = 'Товары'");
	Для каждого СтрокаТаблицы Из Товары Цикл

		Префикс = "Товары[" + Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";

		// Проверка НДС
		Если ВидДоговора <> Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером Тогда
			
			Если Не УказанДокументРеализации Тогда
				
				СвойстваСчетаУчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.СчетУчета);
				Если СвойстваСчетаУчета.Забалансовый Тогда
					ТекстСообщения = НСтр("ru='Нельзя возвращать комиссионный товар, если не указан документ отгрузки.'");
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Корректность",
							НСтр("ru = 'Счет учета'") , СтрокаТаблицы.НомерСтроки, ИмяСписка, ТекстСообщения);
					Поле = Префикс + "СчетУчета";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);	
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Проверка табличной части "Возвратная тара"

	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВозвратнуюТару") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВозвратнаяТара.Номенклатура");
		МассивНепроверяемыхРеквизитов.Добавить("ВозвратнаяТара.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("ВозвратнаяТара.Сумма");
	КонецЕсли;

	// Этот реквизит проверяется в документе с помощью специального, нетипового механизма. Проверка размещена после СчетаУчетаВДокументах.ПроверитьЗаполнение
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Субконто");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если Не СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты) Тогда
		
		Если ПлательщикНДФЛ И НЕ ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером Тогда
			
			УчетДоходовИРасходовПредпринимателя.ПроверитьЗаполнениеСубконтоНоменклатурныеГруппы(
				ЭтотОбъект, "СчетДоходов", "Субконто", НСтр("ru = 'Субконто'"), "Товары", НСтр("ru = 'Товары'"), Отказ);
			
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВозвратнуюТару")
		И ВозвратнаяТара.Количество() > 0 Тогда
		ВозвратнаяТара.Очистить();
	КонецЕсли;
	
	УказанаПартия = ЗначениеЗаполнено(Сделка) 
		И ТипЗнч(Сделка) <> Тип("ДокументСсылка.ДокументРасчетовСКонтрагентом")
		И ТипЗнч(Сделка) <> Тип("ДокументСсылка.ОтражениеНачисленияНДС");
		
	Если УказанаПартия И Товары.Итог("Себестоимость") > 0 Тогда
		Для каждого СтрокаТаблицы Из Товары Цикл
			Если СтрокаТаблицы.Себестоимость <> 0 Тогда
				СтрокаТаблицы.Себестоимость = 0;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если УказанаПартия И ПравоДоступа("Чтение", Сделка.Метаданные()) Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,
			ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Сделка, "ДеятельностьНаПатенте, Патент, ДеятельностьНаТорговомСборе"));
	КонецЕсли;
	
	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПокупателюВыставляетсяКорректировочныйСчетФактура 
		И ЗначениеЗаполнено(Сделка) 
		И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ДанныеОбъекта = Новый Структура("Дата, Ссылка, Сделка");
		ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
		
		Документы.ВозвратТоваровОтПокупателя.ЗаполнитьПоказателиПоСделке(Товары, ДанныеОбъекта);
	КонецЕсли; 
	
	РаботаСДоговорамиКонтрагентовБП.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Товары");

	// В этом случае очистим в табличных частях поля НомерГТД и СтранаПроисхождения.
	Если ВидОперации = Перечисления.ВидыОперацийВозвратТоваровОтПокупателя.Оборудование Тогда
		Для каждого СтрокаТаблицы Из ЭтотОбъект.Товары Цикл
			Если ЗначениеЗаполнено(СтрокаТаблицы.НомерГТД)Тогда
				СтрокаТаблицы.НомерГТД = Неопределено;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТаблицы.СтранаПроисхождения)Тогда
				СтрокаТаблицы.СтранаПроисхождения = Неопределено;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	// Установка параметров учета НДС
	УстановитьРеквизитыУчетаНДС();

	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("ПометкаУдаления", ЭтотОбъект, "СчетФактураВыданный");
	Если НЕ ПокупателюВыставляетсяКорректировочныйСчетФактура Тогда
		ПараметрыДействия.СостояниеФлага = Истина;
	КонецЕсли;
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);
	
	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("ПометкаУдаления", ЭтотОбъект, "СчетФактураПолученный");
	Если НЕ ПокупателемВыставляетсяСчетФактураНаВозврат Тогда
		ПараметрыДействия.СостояниеФлага = Истина;
	КонецЕсли;
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);
	
	Документы.КорректировкаПоступления.ОбновитьРеквизитыСвязанныхДокументовКорректировки(ЭтотОбъект, Отказ);
	Документы.КорректировкаРеализации.ОбновитьРеквизитыСвязанныхДокументовКорректировки(ЭтотОбъект, Отказ);
	
	ИнтеграцияГИСМБП.УстановитьПризнакЕстьМаркируемаяПродукцияГИСМ(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
	
		Если ПокупателюВыставляетсяКорректировочныйСчетФактура Тогда
			УчетНДСПереопределяемый.ПроверитьСоответствиеРеквизитовСчетаФактурыВыданного(ЭтотОбъект);
		ИначеЕсли ПокупателемВыставляетсяСчетФактураНаВозврат Тогда 
			УчетНДСПереопределяемый.СинхронизироватьРеквизитыСчетаФактурыПолученного(ЭтотОбъект);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ВозвратТоваровОтПокупателя.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// Алгоритмы формирования проводок этого документа рассчитывают суммы проводок налогового учета
	Движения.Хозрасчетный.ДополнительныеСвойства.Вставить("СуммыНалоговогоУчетаЗаполнены", Истина);
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	ТаблицаСписанныеТоварыОтПокупателя = УчетТоваров.ПодготовитьТаблицуВозвращенныеСписанныеТовары(
		ПараметрыПроведения.СписаниеТоваровТаблицаТовары, ПараметрыПроведения.СписаниеТоваровСчетаУчета,
		ПараметрыПроведения.СписаниеТоваровСписокНоменклатуры, ПараметрыПроведения.СписаниеТоваровРеквизиты, Отказ);
	
	// Таблица товаров, возвращенных от комиссионера
	ТаблицаСписанныеТоварыОтКомиссионера =  УчетТоваров.ПодготовитьТаблицуСписанныеТовары(
		ПараметрыПроведения.СписаниеТоваровТаблицаТоварыОтКомиссионера,
		ПараметрыПроведения.СписаниеТоваровРеквизиты, Отказ);
	
	// Таблица товаров для общего случая, т.к. возврат от комиссионера определяется
	// по виду договора из шапки документа, то фактически заполненной является только
	// одна таблица.
	// Структура обеих таблиц одинакова - см. УчетТоваров.ПолучитьПустуюТаблицуСписанныеТовары
	Если ТаблицаСписанныеТоварыОтКомиссионера.Количество() > 0 Тогда
		ТаблицаСписанныеТовары = ТаблицаСписанныеТоварыОтКомиссионера;
	Иначе
		ТаблицаСписанныеТовары = ТаблицаСписанныеТоварыОтПокупателя;
	КонецЕсли;
	
	// Таблица взаиморасчетов с учетом зачета авансов
	ТаблицаВзаиморасчеты = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ЗачетАвансовТаблицаДокумента, ПараметрыПроведения.ЗачетАвансовТаблицаАвансов,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Отказ);
	
	// Таблицы выручки от реализации: собственных товаров и услуг и отдельно комиссионных
	ТаблицыРеализация = УчетДоходовРасходов.ПодготовитьТаблицыВыручкиОтРеализации(
		ПараметрыПроведения.РеализацияТаблицаДокумента, ТаблицаВзаиморасчеты, ТаблицаСписанныеТовары,
		ПараметрыПроведения.РеализацияРеквизиты, Отказ);
		
	ТаблицаСобственныеТоварыУслуги = ТаблицыРеализация.СобственныеТоварыУслуги;
	ТаблицаТоварыУслугиКомитентов = ТаблицыРеализация.ТоварыУслугиКомитентов;
	ТаблицаРеализованныеТоварыКомитентов = ТаблицыРеализация.РеализованныеТоварыКомитентов;
	
	СобственныеТоварыУслугиНДС = ?(ТаблицыРеализация.СобственныеТоварыУслуги <> Неопределено,
		ТаблицыРеализация.СобственныеТоварыУслуги.Скопировать(), Неопределено);
	
	СуммаСторноРасходов = 0;
	СуммаСторноНДС      = 0;
	СуммаПризнанияНДС   = 0;
	ТаблицаРасходовДляУСН = Документы.ВозвратТоваровОтПокупателя.ПодготовитьТаблицыДляУСН(
		ПараметрыПроведения.УСНТаблицаРасходов,
		ТаблицаСписанныеТовары,
		ТаблицаВзаиморасчеты,
		ПараметрыПроведения.УСНРеквизитыСделки,
		ПараметрыПроведения.Реквизиты,
		СуммаСторноРасходов, // Рассчитывается и возвращается
		СуммаСторноНДС, // Рассчитывается и возвращается
		СуммаПризнанияНДС, // Рассчитывается и возвращается
		Отказ);
		
	// Учет доходов и расходов ИП
	ТаблицаВыручкиОтРеализацииИП = Документы.ВозвратТоваровОтПокупателя.ПодготовитьТаблицуВыручкиОтРеализацииИП(
		ПараметрыПроведения.РеализацияТаблицаДокумента, ПараметрыПроведения.Реквизиты);
	
	ТаблицыВозвратаТоваровИП = УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицыВозвратаМПЗОтПокупателя(
		ТаблицаВыручкиОтРеализацииИП, ТаблицаСписанныеТовары, ТаблицаВзаиморасчеты, ПараметрыПроведения.Реквизиты);
		
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	//Движения регистра "Рублевые суммы документов в валюте", тут, т.к. суммы нужны до СТОРНО
	УчетНДСБП.СформироватьДвиженияРублевыеСуммыДокументовВВалюте(ТаблицаСобственныеТоварыУслуги, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетНДСБП.СформироватьДвиженияРублевыеСуммыДокументовВВалютеБезНДС(ПараметрыПроведения.ПоступлениеТары, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетНДСБП.СформироватьДвиженияРублевыеСуммыДокументовВВалюте(ТаблицаТоварыУслугиКомитентов, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	Документы.ВозвратТоваровОтПокупателя.ПроставитьСторноТаблиц(ТаблицаСписанныеТовары,
		ТаблицыРеализация.СобственныеТоварыУслуги, ТаблицыРеализация.ТоварыУслугиКомитентов,
		ТаблицыРеализация.РеализованныеТоварыКомитентов, ПараметрыПроведения.Реквизиты);
		
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	

	// Сторнируем ранее отгруженные товары:
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ТаблицаСписанныеТовары,
		ПараметрыПроведения.СписаниеТоваровРеквизиты, Движения, Отказ);
	
	// Поступление тары:
	УчетТоваров.СформироватьДвиженияПоступлениеТары(ПараметрыПроведения.ПоступлениеТары,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияВозвратРеализации(ТаблицыРеализация.СобственныеТоварыУслуги,
		ТаблицыРеализация.ТоварыУслугиКомитентов, ТаблицыРеализация.РеализованныеТоварыКомитентов,
		ПараметрыПроведения.РеализацияРеквизиты, Движения, Отказ);
		
	Реквизиты = ПараметрыПроведения.Реквизиты[0];
	НалоговыйУчет.СкорректироватьПроводкиВозвратТоваровПрибылиУбыткиПрошлыхЛет(
		Движения.Хозрасчетный,
		Реквизиты.ДатаОтгрузки,
		Реквизиты.Период,
		Реквизиты.Организация);
		
	Документы.ВозвратТоваровОтПокупателя.СформироватьДвиженияЗачетАвансаПоВозвратуОтПокупателя(ТаблицаВзаиморасчеты,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);
	
	УчетВзаиморасчетов.СформироватьДвиженияЗачетАвансов(ТаблицаВзаиморасчеты,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);
		
	// Учет НДС
	СобственныеТоварыУслугиНДС = УчетНДСРаздельный.ПодготовитьТаблицуСобственныеТоварыУслугиНДС(
		СобственныеТоварыУслугиНДС, ПараметрыПроведения.ТоварыНДС);
	
	УчетНДС.СформироватьДвиженияВозвратТоваровОтПокупателя(СобственныеТоварыУслугиНДС,
		ТаблицаСписанныеТовары, ПараметрыПроведения.ТоварыСГТД, ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Учет НДС по возвращенным от комиссионера товарам
	СписанныеПартииНДС = Новый ТаблицаЗначений;
	УчетНДСБП.СформироватьДвиженияПеремещениеТоваров(ПараметрыПроведения.КомиссионныеТоварыНДС,
		ТаблицаСписанныеТоварыОтКомиссионера, ПараметрыПроведения.Реквизиты, СписанныеПартииНДС, Движения, Отказ);

	// Переоценка валютных остатков:
	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(
		ТаблицаПереоценка, ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетУСН.СформироватьДвиженияПереоценкаВалютныхОстатков(
		ТаблицаПереоценка, ПараметрыПроведения.Реквизиты, Движения, Отказ);

	// УСН
	УчетУСН.ПоступлениеРасходовУСН(ПараметрыПроведения.УСНТаблицаРасходов, 
		ПараметрыПроведения.УСНРеквизиты, СуммаСторноРасходов, Движения, Отказ);
		
	Если НЕ Отказ И Движения.РасходыПриУСН.Количество()>0 Тогда
		Движения.РасходыПриУСН.Записать(Истина);
		Движения.РасходыПриУСН.Записывать = Ложь;
	КонецЕсли; 
	
	Документы.ВозвратТоваровОтПокупателя.СформироватьДвиженияПоРегистрамУСН(
		ЭтотОбъект,
		ТаблицаРасходовДляУСН,
		ТаблицаСписанныеТовары,
		ТаблицаВзаиморасчеты,
		ПараметрыПроведения.Реквизиты,
		СуммаСторноРасходов,
		СуммаСторноНДС,
		СуммаПризнанияНДС,
		Движения, Отказ);
	
	// Учет доходов и расходов ИП
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияВозвратМПЗОтПокупателя(
		ТаблицыВозвратаТоваровИП.СписокМПЗ, ТаблицыВозвратаТоваровИП.СписокМПЗОтгруженные,
		ТаблицыВозвратаТоваровИП.СписокДоходов, ПараметрыПроведения.Реквизиты, Движения, Отказ);

	// Отложенные расчеты с контрагентами.
	УчетВзаиморасчетовОтложенноеПроведение.ЗарегистрироватьОтложенныеРасчетыСКонтрагентами(
		ЭтотОбъект, Отказ, ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение);
		
	// Регистрация в последовательности
	Документы.ВозвратТоваровОтПокупателя.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(
		ЭтотОбъект, ПараметрыПроведения, ТаблицаСписанныеТовары, Отказ);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
		
	Движения.Записать();
	
	ВидСчетФактуры = ?(ПокупателюВыставляетсяКорректировочныйСчетФактура, "СчетФактураВыданный", "СчетФактураПолученный");
	
	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("Проведен", ЭтотОбъект, ВидСчетФактуры);
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

	ВидСчетФактуры = ?(ПокупателюВыставляетсяКорректировочныйСчетФактура, "СчетФактураВыданный", "СчетФактураПолученный");
	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("Проведен", ЭтотОбъект, ВидСчетФактуры);
	ПараметрыДействия.СостояниеФлага = Ложь;
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);

	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецЕсли