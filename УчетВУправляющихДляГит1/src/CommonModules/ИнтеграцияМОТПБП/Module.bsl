
// Зполняет переданную таблицу данные из ТЧ документа.
// 
// Параметры:
// 	Документ - ДокументСсылка - Документ из ТЧ которого будет происходить заполнение.
// 	ТаблицаПродукции - ТаблицаЗначений - Таблица для заполнения данными из документа.
//
Процедура СформироватьТаблицуТабачнойПродукцииДокумента(Документ, ТаблицаПродукции) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Документ", Документ);
	
	ТипДокумента = ТипЗнч(Документ);
	Если ТипДокумента = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		Запрос.Текст = ТекстЗапросаТабачнойПродукцииПоступлениеТоваровУслуг();
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		Запрос.Текст = ТекстЗапросаТабачнойПродукцииРеализацияТоваровУслуг();
	Иначе
		ВызватьИсключение НСтр("ru = 'Формирование таблицы табачной продукции указанного документа не определено'");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ТаблицаПродукции.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТекстЗапросаТабачнойПродукцииПоступлениеТоваровУслуг()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Товары.Номенклатура                                  КАК Номенклатура,
	|	СУММА(Товары.Количество) КАК Количество
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг.Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
	|		И СправочникНоменклатура.ТабачнаяПродукция
	|ГДЕ
	|	Товары.Ссылка = &Документ
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТабачнойПродукцииРеализацияТоваровУслуг()
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	Товары.Номенклатура                                 КАК Номенклатура,
	|	СУММА(Товары.Количество) КАК Количество
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
	|		И СправочникНоменклатура.ТабачнаяПродукция
	|ГДЕ
	|	Товары.Ссылка = &Документ
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Отражает результаты проверки и подбора в документе, из которого была вызвана соотвествующая форма.
// 
// Параметры:
// 	ПараметрыОкончанияСканирования - Структура - (См. ПроверкаИПодборМОТП.ЗафиксироватьРезультатПроверкиИПодбора)
Процедура ОтразитьРезультатыСканированияВДокументе(ПараметрыОкончанияСканирования) Экспорт
	
	ТипПроверяемогоДокумента = ТипЗнч(ПараметрыОкончанияСканирования.ПроверяемыйДокумент);
	
	Если ТипПроверяемогоДокумента = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		
		ОтразитьРезультатыПроверкиИПодбораВДокументеПоступления(ПараметрыОкончанияСканирования);
		
	ИначеЕсли ТипПроверяемогоДокумента = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			
		ОтразитьРезультатыПроверкиИПодбораВИсходящемДокументе(ПараметрыОкончанияСканирования, ТипПроверяемогоДокумента);
		
	КонецЕсли;
	
КонецПроцедуры

// Переносит результат проверки и подбора табачной продукции во входящий документ.
//   Общая схема:
//    * Заполняет серии номенклатуры в документе, при необходимости создавая их,
//    * При использовании актов расхождений - создает акт, иначе
//    * Обновляет табличные части "Товары" и "Штрихкоды упаковок" актуальной табачной продукцией,
//    * Перезаписывает документ.
//
// Параметры:
//   ПараметрыОкончанияСканирования - Структура - (См. ПроверкаИПодборМОТП.ЗафиксироватьРезультатПроверкиИПодбора)
//
Процедура ОтразитьРезультатыПроверкиИПодбораВДокументеПоступления(ПараметрыОкончанияСканирования)
	
	ДокументОбъект = ПараметрыОкончанияСканирования.ПроверяемыйДокумент.ПолучитьОбъект();
	
	ДокументОбъект.ШтрихкодыУпаковок.Загрузить(ПараметрыОкончанияСканирования.ТаблицаШтрихкодовВерхнегоУровня);
	
	ОтразитьИзмененияТабличнойЧастиТовары(ДокументОбъект, ПараметрыОкончанияСканирования);
		
	Если ДокументОбъект.Проведен Тогда
		
		Попытка
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
		КонецПопытки;
		
	Иначе
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись)
	КонецЕсли;
		
КонецПроцедуры

// Переносит результат проверки и подбора табачной продукции в исходящий документ.
//   Общая схема:
//    * Обновляет табличную часть "Штрихкоды упаковок" актуальными штрихкодами упаковок табачной продукции,
//    * Обновляет табличную часть "Товары" (при наличии - также "Серии") актуальной табачной продукцией,
//    * Перезаписывает документ.
//   Недостача табачной продукции списывается с первых найденных товарных строк с тем же ключом
//     (номенклатура / характеристика / серия).
//   Излишки прибавляются к первой найденной строке с тем же ключом, а если ее нет в документе - строка добавляется
//     с параметрами заполнения по умолчанию для документа.
//
// Параметры:
//   ПараметрыОкончанияСканирования - Структура - (См. ПроверкаИПодборМОТП.ЗафиксироватьРезультатПроверкиИПодбора)
//   ТипОбъекта                     - Тип       - Тип проверяемого документа
//
Процедура ОтразитьРезультатыПроверкиИПодбораВИсходящемДокументе(ПараметрыОкончанияСканирования, ТипОбъекта)
	
	ДокументОбъект = ПараметрыОкончанияСканирования.ПроверяемыйДокумент.ПолучитьОбъект();
	
	ОтразитьИзмененияТабличнойЧастиШтрихкодыУпаковокРТиУ(ДокументОбъект, ПараметрыОкончанияСканирования.ТаблицаШтрихкодовВерхнегоУровня);
	
	ОтразитьИзмененияТабличнойЧастиТовары(ДокументОбъект, ПараметрыОкончанияСканирования);
		
	Если ДокументОбъект.Проведен Тогда
		
		Попытка
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
		КонецПопытки;
		
	Иначе
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись)
	КонецЕсли;
	
КонецПроцедуры

// Переносит таблицу штрихкодов верхнего уровня в документ
//   Удаляет из табличной части "ШтрихкодыУпаковок" документа отсутствующие табачные (содержащие внутри хотя бы 1 шт 
//   табачной продукции) штрихкоды верхнего уровня
//   Добавляет в табличную часть "ШтрихкодыУпаковок" документа отсутствующие там фактические штрихкоды
//   Не меняет прочие (например алкогольные) штрихкоды
// 
// Параметры:
//  ДокументОбъект                  - ДокументОбъект  - документ для изменения
//  ТаблицаШтрихкодовВерхнегоУровня - ТаблицаЗначений - таблица с колонкой "ШтрихкодУпаковки" (фактические)
Процедура ОтразитьИзмененияТабличнойЧастиШтрихкодыУпаковокРТиУ(ДокументОбъект, ТаблицаШтрихкодовВерхнегоУровня) Экспорт
	
	ШтрихкодыДляПроверки = ДокументОбъект.ШтрихкодыУпаковок.Выгрузить().ВыгрузитьКолонку("ШтрихкодУпаковки");
	Для Каждого ЭлементВНаличии Из ТаблицаШтрихкодовВерхнегоУровня Цикл
		ЭлементМассива = ШтрихкодыДляПроверки.Найти(ЭлементВНаличии.ШтрихкодУпаковки);
		Если ЭлементМассива<>Неопределено Тогда
			ШтрихкодыДляПроверки.Удалить(ЭлементМассива);
		Иначе
			ДокументОбъект.ШтрихкодыУпаковок.Добавить().ШтрихкодУпаковки = ЭлементВНаличии.ШтрихкодУпаковки;
		КонецЕсли;
	КонецЦикла;
	
	//ШтрихкодыСодержащиеТабачнуюПродукцию = ШтрихкодыСодержащиеТабачнуюПродукцию(ШтрихкодыДляПроверки);
	//Для Каждого ЭлементОтсутствует Из ШтрихкодыСодержащиеТабачнуюПродукцию Цикл
	Для Каждого ЭлементОтсутствует Из ШтрихкодыДляПроверки Цикл
		ДокументОбъект.ШтрихкодыУпаковок.Удалить(ДокументОбъект.ШтрихкодыУпаковок.Найти(ЭлементОтсутствует, "ШтрихкодУпаковки"));
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтразитьИзмененияТабличнойЧастиТовары(ДокументОбъект, ПараметрыСканирования)
	
	ТаблицаОтклонений = ПараметрыСканирования.ТаблицаПодобраннойПровереннойПродукции.СкопироватьКолонки();
	Для Каждого Отклонение Из ПараметрыСканирования.ТаблицаПодобраннойПровереннойПродукции Цикл
		Если Отклонение.Количество <> Отклонение.КоличествоПодобрано Тогда
			НоваяСтрока= ТаблицаОтклонений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Отклонение);
		КонецЕсли;
	КонецЦикла;
	
	Если ТаблицаОтклонений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТовары Из ДокументОбъект.Товары Цикл
		СтрокиОтклонений = ТаблицаОтклонений.НайтиСтроки(Новый Структура("Номенклатура", СтрокаТовары.Номенклатура));
		Если СтрокиОтклонений = Неопределено Тогда
			Продолжить;
		Иначе
			Для Каждого Отклонение Из СтрокиОтклонений Цикл
				НовоеКоличество         = Макс(СтрокаТовары.Количество - Отклонение.Количество + Отклонение.КоличествоПодобрано, 0);
				Отклонение.Количество   = Отклонение.Количество - СтрокаТовары.Количество + НовоеКоличество;
				СтрокаТовары.Количество = НовоеКоличество;
			КонецЦикла;
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТовары);
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТовары, ДокументОбъект.СуммаВключаетНДС);
		КонецЕсли;
	КонецЦикла
		
КонецПроцедуры

// Возвращает для передеанного документа таблицу его товаров, являющихся табачной продукцией.
// 
// Параметры:
//	* Контекст - УправляемаяФорма, ДокументСсылка - документ, табачную продукцию которого необходимо получить.
// ВозвращаемоеЗначение:
//	* ТаблицаТабачнойПродукции - ТаблицаЗначений - таблица табачной продукции документа с колонками:
//		** GTIN           - Строка - GTIN продукции
//		** Номенклатура   - ОпределяемыйТип.Номенклатура - номенклатура табачной продукции
//		** Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика номенклатура табачной продукции
//		** Серия          - ОпределяемыйТип.СерияНоменклатуры - серия номенклатура табачной продукции
//		** Количество     - Число - количество табачной продукции
//
Функция ТаблицаТабачнойПродукцииДокумента(Контекст) Экспорт
	
	ТаблицаТабачнойПродукции = ТаблицаТабачнойПродукции();
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ШтрихкодыНоменклатуры.Штрихкод, """") КАК GTIN,
	|	ПоступлениеТоваровУслугТовары.Номенклатура     КАК Номенклатура,
	|	""""                                           КАК Характеристика,
	|	""""                                           КАК Серия,
	|	ПоступлениеТоваровУслугТовары.Количество       КАК Количество
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ПоступлениеТоваровУслугТовары.Номенклатура = СправочникНоменклатура.Ссылка
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО ПоступлениеТоваровУслугТовары.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
	|ГДЕ
	|	ПоступлениеТоваровУслугТовары.Ссылка = &ДокументСсылка
	|	И СправочникНоменклатура.ТабачнаяПродукция
	|ИТОГИ ПО
	|	Номенклатура,
	|	Характеристика,
	|	GTIN
	|";
	
	Если ТипЗнч(Контекст) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		//ПоступлениеТоваровУслуг
	ИначеЕсли ТипЗнч(Контекст) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПоступлениеТоваровУслуг", "РеализацияТоваровУслуг");
	Иначе
		Возврат ТаблицаТабачнойПродукции;
	КонецЕсли;
	
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ДокументСсылка", Контекст);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаНоменклатура = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаНоменклатура.Следующий() Цикл
		ВыборкаХарактеристика = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаХарактеристика.Следующий() Цикл
			ПродукцияПоGTIN = ТаблицаТабачнойПродукции();
			ДлинаСтрокиGTIN = 0;
			
			ВыборкаGTIN = ВыборкаХарактеристика.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаGTIN.Следующий() Цикл
				Если ПродукцияПоGTIN.Количество() = 0 Тогда
					Выборка = ВыборкаGTIN.Выбрать();
					Пока Выборка.Следующий() Цикл
						ЗаполнитьЗначенияСвойств(ПродукцияПоGTIN.Добавить(), Выборка,, "GTIN");
					КонецЦикла;
				КонецЕсли;
				
				Если МенеджерОборудованияКлиентСервер.ПроверитьКорректностьGTIN(ВыборкаGTIN.GTIN)
					И СтрДлина(ВыборкаGTIN.GTIN) > ДлинаСтрокиGTIN Тогда
					ПродукцияПоGTIN.ЗаполнитьЗначения(ВыборкаGTIN.GTIN, "GTIN");
					ДлинаСтрокиGTIN = СтрДлина(ВыборкаGTIN.GTIN);
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого СтрокаПродукцииПоGTIN Из ПродукцияПоGTIN Цикл
				ЗаполнитьЗначенияСвойств(ТаблицаТабачнойПродукции.Добавить(), СтрокаПродукцииПоGTIN);
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ТаблицаТабачнойПродукции;
		
КонецФункции

Функция ТаблицаТабачнойПродукции()
	
	ТаблицаПродукции = Новый ТаблицаЗначений;
	ТаблицаПродукции.Колонки.Добавить("GTIN",           ОбщегоНазначения.ОписаниеТипаСтрока(100));
	ТаблицаПродукции.Колонки.Добавить("Номенклатура",   Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаПродукции.Колонки.Добавить("Характеристика", ОбщегоНазначения.ОписаниеТипаСтрока(100));
	ТаблицаПродукции.Колонки.Добавить("Серия",          ОбщегоНазначения.ОписаниеТипаСтрока(100));
	ТаблицаПродукции.Колонки.Добавить("Количество",     ОбщегоНазначения.ОписаниеТипаЧисло(15,3));
	
	Возврат ТаблицаПродукции;
	
КонецФункции

// Функция проверяет корректность GTIN.
// GTIN допускает в формате GTIN-8, GTIN-12, GTIN-13, GTIN-14 c контрольным символом.
//
// Параметры:
//  GTIN - Текстовая строка с GTIN(c контрольным символом). Может содержать числа от 0 до 9.
// 
// Возвращаемое значение:
//   - Булево  
//
Функция ПроверитьКорректностьGTIN(Знач GTIN) Экспорт
	
	Результат = (СтрДлина(GTIN) = 8) Или (СтрДлина(GTIN) = 12) Или (СтрДлина(GTIN) = 13) Или (СтрДлина(GTIN) = 14);
	Возврат Результат И РассчитатьКонтрольныйСимволGTIN(GTIN) = Прав(GTIN, 1);
	
КонецФункции

// Универсальная функция расчета контрольной цифры GTIN.
// GTIN допускает в формате GTIN-8, GTIN-12, GTIN-13, GTIN-14 c контрольным символом.
//
// Параметры:
//  GTIN - Текстовая строка с GTIN(c контрольным символом). Может содержать числа от 0 до 9.
// 
// Возвращаемое значение:
//   - Контрольный символ (число) рассчитанный по алгоритму для GTIN.
//
Функция РассчитатьКонтрольныйСимволGTIN(Знач GTIN) Экспорт
	
	Сумма = 0;
	ДлиннаGTIN = СтрДлина(GTIN);
	Коэффициент = ?(ДлиннаGTIN % 2 = 0, 3, 1); 
	
	Для Сч = 1 По ДлиннаGTIN - 1 Цикл
		ВремКодСимвола = КодСимвола(GTIN, Сч);
		Сумма  = Сумма + Коэффициент * (ВремКодСимвола - 48);
		Коэффициент = 4 - Коэффициент;
	КонецЦикла;
	Сумма = (10 - Сумма % 10) % 10;
	КонтрольныйСимвол = Символ(Сумма + 48);
	
	Возврат КонтрольныйСимвол;
	
КонецФункции
