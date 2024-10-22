#Область ПрограммныйИнтерфейс

Процедура УстановитьНачальныеСвойстваСубконтоШапки(Форма, Объект, ПараметрыУстановки) Экспорт
	
	УстановитьСвойстваСубконтоШапки(Форма, Объект, ПараметрыУстановки);
	
	ДанныеОбъекта = ДанныеУстановкиПараметровСубконто(Объект, ПараметрыУстановки);
	
	УстановитьПараметрыВыбораСубконто(Форма, Объект, ПараметрыУстановки, ДанныеОбъекта);
	
КонецПроцедуры

Процедура УстановитьНачальныеСвойстваСубконтоТаблицы(Таблица, ПараметрыУстановки) Экспорт
	
	Для каждого СтрокаТаблицы Из Таблица Цикл
		
		УстановитьДоступностьСубконтоСтроки(СтрокаТаблицы, ПараметрыУстановки);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьНачальныеСвойстваСубконтоСтроки(Форма, СтрокаТаблицы, ПараметрыУстановки) Экспорт
	
	УстановитьСвойстваСубконтоСтроки(Форма, СтрокаТаблицы, ПараметрыУстановки);
	
	ДанныеОбъекта = ДанныеУстановкиПараметровСубконто(СтрокаТаблицы, ПараметрыУстановки);
	
	УстановитьПараметрыВыбораСубконто(Форма, СтрокаТаблицы, ПараметрыУстановки, ДанныеОбъекта);
	
КонецПроцедуры

Процедура УстановитьСвойстваСубконтоШапкиПриИзмененииСчета(Форма, Объект, ПараметрыУстановки) Экспорт
	
	УстановитьСвойстваСубконтоШапки(Форма, Объект, ПараметрыУстановки);
	
	ДанныеОбъекта = ДанныеУстановкиПараметровСубконто(Объект, ПараметрыУстановки);
	
	УстановитьПараметрыВыбораСубконто(Форма, Объект, ПараметрыУстановки, ДанныеОбъекта);
	
	УстановитьЗначенияСубконтоПоУмолчанию(Объект, ПараметрыУстановки);
	
КонецПроцедуры

Процедура УстановитьСвойстваСубконтоСтрокиПриИзмененииСчета(Форма, СтрокаТаблицы, ПараметрыУстановки) Экспорт
	
	УстановитьДоступностьСубконтоСтроки(СтрокаТаблицы, ПараметрыУстановки);
	
	УстановитьСвойстваСубконтоСтроки(Форма, СтрокаТаблицы, ПараметрыУстановки);
	
	ДанныеОбъекта = ДанныеУстановкиПараметровСубконто(СтрокаТаблицы, ПараметрыУстановки);
	
	УстановитьПараметрыВыбораСубконто(Форма, СтрокаТаблицы, ПараметрыУстановки, ДанныеОбъекта);
	
	УстановитьЗначенияСубконтоПоУмолчанию(СтрокаТаблицы, ПараметрыУстановки);
	
КонецПроцедуры

Процедура УстановитьСвойстваСубконтоШапкиПриИзмененииСубконто(Форма, Объект, НомерСубконто, ПараметрыУстановки) Экспорт
	
	ДанныеОбъекта = ДанныеУстановкиПараметровСубконто(Объект, ПараметрыУстановки);
	
	УстановитьПараметрыВыбораСубконто(Форма, Объект, ПараметрыУстановки, ДанныеОбъекта);
	
	ОчиститьСубконтоПриИзмененииСубконто(Объект, НомерСубконто, ПараметрыУстановки, ДанныеОбъекта);
	
КонецПроцедуры

Процедура УстановитьСвойстваСубконтоСтрокиПриИзмененииСубконто(Форма, СтрокаТаблицы, НомерСубконто, ПараметрыУстановки) Экспорт
	
	ДанныеОбъекта = ДанныеУстановкиПараметровСубконто(СтрокаТаблицы, ПараметрыУстановки);
	
	УстановитьПараметрыВыбораСубконто(Форма, СтрокаТаблицы, ПараметрыУстановки, ДанныеОбъекта);
	
	ОчиститьСубконтоПриИзмененииСубконто(СтрокаТаблицы, НомерСубконто, ПараметрыУстановки, ДанныеОбъекта);
	
КонецПроцедуры

Процедура УстановитьСвойстваСубконтоШапкиПриИзмененииОрганизации(Форма, Объект, ПараметрыУстановки) Экспорт
	
	ОчиститьСубконтоПриИзмененииОрганизации(Объект, ПараметрыУстановки);
	
	ДанныеОбъекта = ДанныеУстановкиПараметровСубконто(Объект, ПараметрыУстановки);
	
	УстановитьПараметрыВыбораСубконто(Форма, Объект, ПараметрыУстановки, ДанныеОбъекта);
	
	УстановитьЗначенияСубконтоПоУмолчанию(Объект, ПараметрыУстановки);
	
КонецПроцедуры

Процедура УстановитьСвойстваСубконтоТаблицыПриИзмененииОрганизации(Таблица, ПараметрыУстановки) Экспорт
	
	Для каждого СтрокаТаблицы Из Таблица Цикл
		
		ОчиститьСубконтоПриИзмененииОрганизации(СтрокаТаблицы, ПараметрыУстановки);
		
		УстановитьЗначенияСубконтоПоУмолчанию(СтрокаТаблицы, ПараметрыУстановки);
		
	КонецЦикла;
	
КонецПроцедуры

Функция НовыеПараметрыУстановкиСвойствСубконто() Экспорт
	
	Результат = Новый Структура;
	
	ПоляФормы = Новый Структура;
	ПоляФормы.Вставить("Субконто1");
	ПоляФормы.Вставить("Субконто2");
	ПоляФормы.Вставить("Субконто3");
	ПоляФормы.Вставить("Подразделение");
	Результат.Вставить("ПоляФормы", ПоляФормы);
	
	ПоляОбъекта = Новый Структура;
	ПоляОбъекта.Вставить("СчетУчета", "СчетУчета");
	ПоляОбъекта.Вставить("Субконто1");
	ПоляОбъекта.Вставить("Субконто2");
	ПоляОбъекта.Вставить("Субконто3");
	ПоляОбъекта.Вставить("Подразделение");
	Результат.Вставить("ПоляОбъекта", ПоляОбъекта);
	
	ДопРеквизиты = Новый Структура;
	Результат.Вставить("ДопРеквизиты", ДопРеквизиты);
	
	Результат.Вставить("ЗначенияПоУмолчанию", Новый Соответствие); // См. также ПредопределенныеЗначенияСубконтоПоУмолчанию()
	
	Результат.Вставить("СкрыватьСубконто", Истина);
	
	Возврат Результат;
	
КонецФункции

Функция ПараметрыУстановкиСвойствСубконтоПоШаблону(СубконтоФормы, ПодразделениеФормы, СубконтоОбъекта, ПодразделениеОбъекта, СчетУчетаОбъекта) Экспорт
	
	Результат = НовыеПараметрыУстановкиСвойствСубконто();
	
	Если НЕ ПустаяСтрока(СубконтоФормы) Тогда
		Для Индекс = 1 По 3 Цикл
			Результат.ПоляФормы["Субконто" + Индекс] = СубконтоФормы + Индекс;
		КонецЦикла;
	КонецЕсли;
	Если НЕ ПустаяСтрока(ПодразделениеФормы) Тогда
		Результат.ПоляФормы.Подразделение = ПодразделениеФормы;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(СубконтоОбъекта) Тогда
		Для Индекс = 1 По 3 Цикл
			Результат.ПоляОбъекта["Субконто" + Индекс] = СубконтоОбъекта + Индекс;
		КонецЦикла;
	КонецЕсли;
	Если НЕ ПустаяСтрока(ПодразделениеОбъекта) Тогда
		Результат.ПоляОбъекта.Подразделение = ПодразделениеОбъекта;
	КонецЕсли;
	Если НЕ ПустаяСтрока(СчетУчетаОбъекта) Тогда
		Результат.ПоляОбъекта.СчетУчета = СчетУчетаОбъекта;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ДанныеУстановкиПараметровСубконто(Объект, ПараметрыУстановки) Экспорт
	
	Результат = Новый Структура;
	
	ПоляОбъекта  = ПараметрыУстановки.ПоляОбъекта;
	ДопРеквизиты = ПараметрыУстановки.ДопРеквизиты;
	
	ОписаниеТиповДоговора = БухгалтерскийУчетКлиентСерверПереопределяемый.ПолучитьОписаниеТиповДоговора();
	
	Для Индекс = 1 По 3 Цикл
		Если НЕ ЗначениеЗаполнено(ПоляОбъекта["Субконто" + Индекс]) Тогда
			Продолжить;
		КонецЕсли;
		ЗначениеСубконто = Объект[ПоляОбъекта["Субконто" + Индекс]];
		ТипСубконто = ТипЗнч(ЗначениеСубконто);
		Если ТипСубконто= Тип("СправочникСсылка.Контрагенты") Тогда
			Результат.Вставить("Контрагент", ЗначениеСубконто);
		ИначеЕсли ОписаниеТиповДоговора.СодержитТип(ТипСубконто) Тогда
			Результат.Вставить("ДоговорКонтрагента", ЗначениеСубконто);
		ИначеЕсли ТипСубконто = Тип("СправочникСсылка.Номенклатура") Тогда
			Результат.Вставить("Номенклатура", ЗначениеСубконто);
		ИначеЕсли ТипСубконто = Тип("СправочникСсылка.Склады") Тогда
			Результат.Вставить("Склад", ЗначениеСубконто);
		КонецЕсли;
	КонецЦикла;
	Результат.Вставить("СчетУчета", Объект[ПоляОбъекта.СчетУчета]);
	
	Если ПоляОбъекта.Свойство("Организация") Тогда
		Результат.Вставить("Организация", Объект[ПоляОбъекта.Организация]);
	КонецЕсли;
	
	Для каждого ДопРеквизит Из ДопРеквизиты Цикл
		Результат.Вставить(ДопРеквизит.Ключ, ДопРеквизит.Значение);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Процедура установки типа и видимости субконто в зависимости от выбранного счета
//
// Параметры:
//	Счет			 - <План счетов> - Счет, для которого необходимо настроить тип и видимость субконто
//	Форма			 - <Управляемая форма> - Форма, которая содержит ПоляФормы и ЗаголовкиПолей
//	ПоляФормы		 - <Структура> - Ключи, которой Субконто1, Субконто2, Субконто3, 
//									 а значения имена соответствующих полей на форме (поля субконто)
//	ЗаголовкиПолей	 - <Структура> ИЛИ <Неопределено> - Ключи, которой Субконто1, Субконто2, Субконто3
//									 а значения имена соответствующих полей на форме (заголовки субконто)
//	ЭтоТаблица		 - <Булево>		 - Признак того, где выполняется настройка субконто. 
//	СкрыватьСубконто - <Булево>		 - Признак того, нужно ли для этой формы дополнительно скрывать субконто, влияет на выполнении функции НужноСкрытьСубконто
//
Процедура ПриВыбореСчета(Счет, Форма, ПоляФормы, ЗаголовкиПолей = Неопределено, ЭтоТаблица = Ложь, СкрыватьСубконто = Истина) Экспорт
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	
	Для Индекс = 1 По 3 Цикл
		ТипЗначенияСубконто = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
		Если Индекс <= ДанныеСчета.КоличествоСубконто И НЕ НужноСкрытьСубконто(СкрыватьСубконто, ТипЗначенияСубконто) Тогда
			Если ЭтоТаблица Тогда
				Если ПоляФормы.Свойство("Субконто" + Индекс) Тогда
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ОграничениеТипа = ТипЗначенияСубконто;
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ПодсказкаВвода  = ДанныеСчета["ВидСубконто" + Индекс + "Наименование"];
				КонецЕсли;
			Иначе
				Если ЗаголовкиПолей <> Неопределено И ЗаголовкиПолей.Свойство("Субконто" + Индекс) Тогда
					// Заголовок может быть не выведен на форму
					ЭлементФормыЗаголовок = Форма.Элементы.Найти(ЗаголовкиПолей["Субконто" + Индекс]);
					Если ЭлементФормыЗаголовок <> Неопределено Тогда
						ЭлементФормыЗаголовок.Видимость = Истина;
					КонецЕсли;
					Форма[ЗаголовкиПолей["Субконто" + Индекс]] = ДанныеСчета["ВидСубконто" + Индекс + "Наименование"] + ":";
				КонецЕсли;
				Если ПоляФормы.Свойство("Субконто" + Индекс) Тогда
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].Видимость       = Истина;
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ОграничениеТипа = ТипЗначенияСубконто;
				КонецЕсли;
			КонецЕсли;
		Иначе 
			// Ничего делать не надо, т.к. не доступные поля будут скрыты
			Если Не ЭтоТаблица Тогда
				Если ЗаголовкиПолей <> Неопределено И ЗаголовкиПолей.Свойство("Субконто" + Индекс) Тогда
					// Заголовок может быть не выведен на форму
					ЭлементФормыЗаголовок = Форма.Элементы.Найти(ЗаголовкиПолей["Субконто" + Индекс]);
					Если ЭлементФормыЗаголовок <> Неопределено Тогда
						ЭлементФормыЗаголовок.Видимость	 = Ложь;
					КонецЕсли;
					Форма[ЗаголовкиПолей["Субконто" + Индекс]] = "";
				КонецЕсли;
				Если ПоляФормы.Свойство("Субконто" + Индекс) Тогда
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].Видимость       = Ложь;
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ОграничениеТипа = Новый ОписаниеТипов("Неопределено");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЭтоТаблица Тогда
		Если ЗаголовкиПолей <> Неопределено И ЗаголовкиПолей.Свойство("Подразделение") Тогда
			Форма[ЗаголовкиПолей["Подразделение"]] = ?(ДанныеСчета.УчетПоПодразделениям, НСтр("ru = 'Подразделение'") + ":", "");
		КонецЕсли;
		Если ПоляФормы.Свойство("Подразделение") Тогда
			
			ДоступностьПодразделения = ДанныеСчета.УчетПоПодразделениям;
			Если ПоляФормы.Свойство("ДоступностьПодразделения") Тогда
				ДоступностьПодразделения = ДоступностьПодразделения ИЛИ ПоляФормы.ДоступностьПодразделения;
			КонецЕсли;
			
			Форма.Элементы[ПоляФормы["Подразделение"]].Доступность = ДоступностьПодразделения;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура установки типа, значения и доступности субконто в зависимости от выбранного счета
//
// Параметры:
//	Счет			 - <План счетов> - Счет, для которого необходимо настроить тип и видимость субконто
//	Объект			 - <Управляемая форма> ИЛИ <Строка табличной части> - Объект, который содержит ПоляФормы
//	ПоляОбъекта		 - <Структура> - Ключи, которой Субконто1, Субконто2, Субконто3, 
//									 а значения имена соответствующих полей на форме (поля субконто)
//	ЗначенияСубконто - <Соответствие> ИЛИ <Неопределено> - Значения субконто, где ключ Вид субконто, а значение - значение для подстановки
//	СкрыватьСубконто - <Булево>		 - Признак того, нужно ли для этой формы дополнительно скрывать субконто, влияет на выполнении функции СкрытьСубконто
//
Процедура ПриИзмененииСчета(Счет, Объект, ПоляОбъекта, ЭтоТаблица = Ложь, ЗначенияСубконто = Неопределено, СкрыватьСубконто = Истина) Экспорт
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	Для Индекс = 1 По 3 Цикл
		Если ПоляОбъекта.Свойство("Субконто" + Индекс) Тогда
			Если Индекс <= ДанныеСчета.КоличествоСубконто Тогда
				ТипЗначенияСубконто = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
				ЗначениеСубконто = ТипЗначенияСубконто.ПривестиЗначение(Объект[ПоляОбъекта["Субконто" + Индекс]]);
				ЗначениеСубконтоПоУмолчанию = ?(ЗначенияСубконто = Неопределено, ЗначенияСубконто, ЗначенияСубконто.Получить(ДанныеСчета["ВидСубконто" + Индекс]));
				Если ЗначениеЗаполнено(ЗначениеСубконто) ИЛИ (НЕ ЗначениеЗаполнено(ЗначениеСубконтоПоУмолчанию)) Тогда
					Объект[ПоляОбъекта["Субконто" + Индекс]] = ЗначениеСубконто;
				Иначе
					Объект[ПоляОбъекта["Субконто" + Индекс]] = ЗначениеСубконтоПоУмолчанию;
				КонецЕсли;
			Иначе 
				Объект[ПоляОбъекта["Субконто" + Индекс]] = Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ЭтоТаблица Тогда
		УстановитьДоступностьСубконто(Счет, Объект, ПоляОбъекта, СкрыватьСубконто);
	КонецЕсли;
	
	Если ПоляОбъекта.Свойство("Подразделение") Тогда
		Если ДанныеСчета.УчетПоПодразделениям Тогда
			ПодразделениеПоУмолчанию = Неопределено;
			ПоляОбъекта.Свойство("ПодразделениеПоУмолчанию", ПодразделениеПоУмолчанию);
			НовоеПодразделение = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьПодразделениеПриИзмененииСчета(
				Объект[ПоляОбъекта.Подразделение],
				ПоляОбъекта.Организация,
				ПодразделениеПоУмолчанию);
			
			Если НовоеПодразделение <> Объект[ПоляОбъекта.Подразделение] Тогда
				Объект[ПоляОбъекта.Подразделение] = НовоеПодразделение;
			КонецЕсли;
			
			Если ЭтоТаблица Тогда
				Объект[ПоляОбъекта["Подразделение"] + "Доступность"] = Истина;
			КонецЕсли;
		Иначе
			Объект[ПоляОбъекта.Подразделение] = Неопределено;
			Если ЭтоТаблица Тогда
				Объект[ПоляОбъекта["Подразделение"] + "Доступность"] = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура установки доступности субконто в зависимости от выбранного счета
//	Счет			 - <План счетов> - Счет, для которого необходимо настроить тип и видимость субконто
//	Объект			 - <Управляемая форма> ИЛИ <Строка табличной части> - Объект, который содержит ПоляФормы
//	ПоляОбъекта		 - <Структура> - Ключи, которой Субконто1, Субконто2, Субконто3, 
//									 а значения имена соответствующих полей на форме (поля субконто)
//	СкрыватьСубконто - <Булево>		 - Признак того, нужно ли для этой формы дополнительно скрывать субконто, влияет на выполнении функции НужноСкрытьСубконто
//
Процедура УстановитьДоступностьСубконто(Счет, Объект, ПоляОбъекта, СкрыватьСубконто = Истина) Экспорт
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	
	Для Индекс = 1 По 3 Цикл
		Если ПоляОбъекта.Свойство("Субконто" + Индекс) Тогда
			ТипЗначенияСубконто = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
			Если НужноСкрытьСубконто(СкрыватьСубконто, ТипЗначенияСубконто) Тогда
				Объект[ПоляОбъекта["Субконто" + Индекс] + "Доступность"] = Ложь;
			Иначе
				Объект[ПоляОбъекта["Субконто" + Индекс] + "Доступность"] = (Индекс <= ДанныеСчета.КоличествоСубконто);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ПоляОбъекта.Свойство("Подразделение") Тогда
		Объект[ПоляОбъекта["Подразделение"] + "Доступность"] = ДанныеСчета.УчетПоПодразделениям;
	КонецЕсли;
	
	Если ПоляОбъекта.Свойство("Валютный") Тогда
		Объект[ПоляОбъекта["Валютный"] + "Доступность"] = ДанныеСчета.Валютный;
	КонецЕсли;
	
	Если ПоляОбъекта.Свойство("Количественный") Тогда
		Объект[ПоляОбъекта["Количественный"] + "Доступность"] = ДанныеСчета.Количественный;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, Объект, ШаблонИмяПоляОбъекта, ШаблонИмяЭлементаФормы, СписокПараметров) Экспорт
	
	ВидыПараметров = Новый Соответствие;
	ВидыПараметров.Вставить(БухгалтерскийУчетКлиентСерверПереопределяемый.ТипЗначенияБанковскогоСчетаОрганизации(), "БанковскийСчет");
	ВидыПараметров.Вставить(БухгалтерскийУчетКлиентСерверПереопределяемый.ТипПодразделения(), "Подразделение");
	Для каждого ТипДоговора Из БухгалтерскийУчетКлиентСерверПереопределяемый.ПолучитьОписаниеТиповДоговора().Типы() Цикл
		ВидыПараметров.Вставить(ТипДоговора, "Договор");
	КонецЦикла;
	ВидыПараметров.Вставить(Тип("СправочникСсылка.РегистрацииВНалоговомОргане"), "РегистрацияВИФНС");
	ВидыПараметров.Вставить(Тип("СправочникСсылка.Субконто"), "Субконто");
	ВидыПараметров.Вставить(Тип("ПеречислениеСсылка.ВидыПлатежейВГосБюджет"), "ВидыПлатежейВГосБюджет");
	
	ОчищатьСвязанныеСубконто = Ложь;
	ТипыСвязанныхСубконто    = Неопределено;
	Если ТипЗнч(Форма.ТекущийЭлемент) = Тип("ТаблицаФормы") Тогда
		ТекущийЭлемент = Форма.ТекущийЭлемент.ТекущийЭлемент;
	Иначе
		ТекущийЭлемент = Форма.ТекущийЭлемент;
	КонецЕсли;
	ИмяТекущегоЭлемента = ?(ТипЗнч(ТекущийЭлемент) = Тип("ПолеФормы"), ТекущийЭлемент.Имя, "");
	
	Для Индекс = 1 По 3 Цикл
		ИмяЭлементаФормы = СтрЗаменить(ШаблонИмяЭлементаФормы, "%Индекс%", Индекс);
		ИмяПоляОбъекта   = СтрЗаменить(ШаблонИмяПоляОбъекта  , "%Индекс%", Индекс);
		ТипПоляОбъекта   = ТипЗнч(Объект[ИмяПоляОбъекта]);
		
		ВидПараметра = ВидыПараметров[ТипПоляОбъекта];
		
		Если ВидПараметра <> Неопределено Тогда
			
			МассивПараметров = Новый Массив();
			Если ВидПараметра = "Договор" Тогда
				Если СписокПараметров.Свойство("Организация") Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Организация", СписокПараметров.Организация));
				КонецЕсли;
				Если СписокПараметров.Свойство("Контрагент") Тогда
					ИмяКонтрагента = БухгалтерскийУчетКлиентСерверПереопределяемый.ПолучитьИмяРеквизитаКонтрагентДоговора();
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор." + ИмяКонтрагента, СписокПараметров.Контрагент));
				КонецЕсли;
			ИначеЕсли ВидПараметра = "БанковскийСчет" Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Организация));
			ИначеЕсли ВидПараметра = "РегистрацияВИФНС" Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", 
					ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(СписокПараметров.Организация)));
			ИначеЕсли ВидПараметра = "Субконто"
				И СписокПараметров.Свойство("СчетУчета") Тогда
				СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СписокПараметров.СчетУчета);
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СвойстваСчета["ВидСубконто" + Индекс]));
			ИначеЕсли ВидПараметра = "Подразделение" Тогда
				ИмяРеквизитаОрганизация = БухгалтерскийУчетКлиентСерверПереопределяемый.ИмяРеквизитаОрганизацияПодразделения();
				Если ЗначениеЗаполнено(ИмяРеквизитаОрганизация) Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор." + ИмяРеквизитаОрганизация, СписокПараметров.Организация));
				КонецЕсли;
			ИначеЕсли ВидПараметра = "ВидыПлатежейВГосБюджет"
				И СписокПараметров.Свойство("СчетУчета") Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.СчетУчета", СписокПараметров.СчетУчета));
			КонецЕсли;
			
			Если МассивПараметров.Количество() > 0 Тогда
				ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
				Форма.Элементы[ИмяЭлементаФормы].ПараметрыВыбора = ПараметрыВыбора;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ОчищатьСвязанныеСубконто 
			И ЗначениеЗаполнено(Объект[ИмяПоляОбъекта]) Тогда
			
			Если ТипыСвязанныхСубконто = Неопределено Тогда
				ВсеТипыСвязанныхСубконто = БухгалтерскийУчетВызовСервераПовтИсп.ВсеТипыСвязанныхСубконто();
				ТипыСвязанныхСубконто    = Новый ОписаниеТипов(Новый Массив);
				Для каждого Параметр Из СписокПараметров Цикл
					Если ВсеТипыСвязанныхСубконто[Параметр.Ключ] <> Неопределено Тогда
						ТипыСвязанныхСубконто = Новый ОписаниеТипов(ТипыСвязанныхСубконто, 
							ВсеТипыСвязанныхСубконто[Параметр.Ключ].Типы());
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если ТипыСвязанныхСубконто.СодержитТип(ТипПоляОбъекта) Тогда
				Объект[ИмяПоляОбъекта] = Новый (ТипПоляОбъекта);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ИмяТекущегоЭлемента = ИмяЭлементаФормы Тогда
			ОчищатьСвязанныеСубконто = Истина; // Очищаются только субконто с номером больше текущего
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура изменяет параметры выбора для ПоляВвода управляемой формы:
//
// Параметры:
//	ЭлементФормыСчет - ПолеВвода управляемой формы, для которого изменяется параметр выбора 
//  МассивСчетов                 - <Массив> ИЛИ <Неопределено> - счета, которыми нужно ограничить список. 
//	                                   Если не заполнено - ограничения не будет
//  ОтборПоПризнакуВалютный      - <Булево> ИЛИ <Неопределено> - Значение для установки соответствующего параметра выбора. 
//                                     Если неопределено, параметр выбора не устанавливается.
//  ОтборПоПризнакуЗабалансовый   - <Булево> ИЛИ <Неопределено> - Значение для установки соответствующего параметра выбора. 
//                                     Если неопределено, параметр выбора не устанавливается.
//  ОтборПоПризнакуСчетГруппа    - <Булево> ИЛИ <Неопределено> - Значение для установки соответствующего параметра выбора. 
//                                     Если неопределено, параметр выбора не устанавливается.
//
//
Процедура ИзменитьПараметрыВыбораСчета(ЭлементФормыСчет, МассивСчетов, ОтборПоПризнакуВалютный = Неопределено, ОтборПоПризнакуЗабалансовый = Неопределено, ОтборПоПризнакуСчетГруппа = Ложь) Экспорт
	
	МассивОтборов = Новый Массив;
	Если ОтборПоПризнакуСчетГруппа <> Неопределено Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.ЗапретитьИспользоватьВПроводках", ОтборПоПризнакуСчетГруппа));
	КонецЕсли;
	
	Если ОтборПоПризнакуВалютный <> Неопределено Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.Валютный", ОтборПоПризнакуВалютный));
	КонецЕсли;
	
	Если ОтборПоПризнакуЗабалансовый <> Неопределено Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.Забалансовый", ОтборПоПризнакуЗабалансовый));
	КонецЕсли;
	
	Если МассивСчетов <> Неопределено И МассивСчетов.Количество() > 0 Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(МассивСчетов)));
	КонецЕсли;
	
	ПараметрыВыбора = Новый ФиксированныйМассив(МассивОтборов);
	ЭлементФормыСчет.ПараметрыВыбора = ПараметрыВыбора;
	
КонецПроцедуры

Функция ТипСумма() Экспорт
	
	Возврат Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, РазрядностьДробнойЧастиСумм()));
	
КонецФункции

Функция РазрядностьДробнойЧастиСумм() Экспорт
	
	Возврат 2;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьДоступностьСубконтоСтроки(СтрокаТаблицы, ПараметрыУстановки)
	
	ПоляОбъекта  = ПараметрыУстановки.ПоляОбъекта;
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы[ПоляОбъекта.СчетУчета]);
	
	Для Индекс = 1 По 3 Цикл
		Если ЗначениеЗаполнено(ПоляОбъекта["Субконто" + Индекс]) Тогда
			ТипЗначенияСубконто = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
			СтрокаТаблицы[ПоляОбъекта["Субконто" + Индекс] + "Доступность"] = ДанныеСчета.КоличествоСубконто >= Индекс
				И НЕ НужноСкрытьСубконто(ПараметрыУстановки.СкрыватьСубконто, ТипЗначенияСубконто);
		КонецЕсли;
	КонецЦикла;
	
	Если ПоляОбъекта.Свойство("ПодразделениеДоступность") Тогда
		СтрокаТаблицы[ПоляОбъекта.ПодразделениеДоступность] = ДанныеСчета.УчетПоПодразделениям;
	ИначеЕсли ЗначениеЗаполнено(ПоляОбъекта.Подразделение) Тогда
		СтрокаТаблицы[ПоляОбъекта.Подразделение + "Доступность"] = ДанныеСчета.УчетПоПодразделениям;
	КонецЕсли;
	
	Если ПоляОбъекта.Свойство("Валютный")
		И ЗначениеЗаполнено(ПоляОбъекта.Валютный) Тогда
		СтрокаТаблицы[ПоляОбъекта.Валютный] = ДанныеСчета.Валютный;
	КонецЕсли;
	
	Если ПоляОбъекта.Свойство("Количественный")
		И ЗначениеЗаполнено(ПоляОбъекта.Количественный) Тогда
		СтрокаТаблицы[ПоляОбъекта.Количественный] = ДанныеСчета.Количественный;
	КонецЕсли;
	
	Если ПоляОбъекта.Свойство("НалоговыйУчет")
		И ЗначениеЗаполнено(ПоляОбъекта.НалоговыйУчет) Тогда
		СтрокаТаблицы[ПоляОбъекта.НалоговыйУчет] = ДанныеСчета.НалоговыйУчет;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьПараметрыВыбораСубконто(Форма, Объект, ПараметрыУстановки, ДанныеОбъекта)
	
	Элементы = Форма.Элементы;
	
	ПоляОбъекта = ПараметрыУстановки.ПоляОбъекта;
	ПоляФормы   = ПараметрыУстановки.ПоляФормы;
	
	ВидыПараметров = Новый Соответствие;
	ВидыПараметров.Вставить(
		БухгалтерскийУчетКлиентСерверПереопределяемый.ТипЗначенияБанковскогоСчетаОрганизации(), "БанковскийСчет");
	ВидыПараметров.Вставить(БухгалтерскийУчетКлиентСерверПереопределяемый.ТипПодразделения(), "Подразделение");
	Для каждого ТипДоговора Из БухгалтерскийУчетКлиентСерверПереопределяемый.ПолучитьОписаниеТиповДоговора().Типы() Цикл
		ВидыПараметров.Вставить(ТипДоговора, "Договор");
	КонецЦикла;
	ВидыПараметров.Вставить(Тип("СправочникСсылка.РегистрацииВНалоговомОргане"), "РегистрацияВИФНС");
	ВидыПараметров.Вставить(Тип("СправочникСсылка.Субконто"), "Субконто");
	ВидыПараметров.Вставить(Тип("ПеречислениеСсылка.ВидыПлатежейВГосБюджет"), "ВидыПлатежейВГосБюджет");
	
	Для Индекс = 1 По 3 Цикл
		Если НЕ ЗначениеЗаполнено(ПоляФормы["Субконто" + Индекс])
			ИЛИ НЕ ЗначениеЗаполнено(ПоляОбъекта["Субконто" + Индекс]) Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементФормыСубконто = Элементы.Найти(ПоляФормы["Субконто" + Индекс]);
		Если ЭлементФормыСубконто = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ТипСубконто   = ТипЗнч(Объект[ПоляОбъекта["Субконто" + Индекс]]);
		ВидПараметров = ВидыПараметров[ТипСубконто];
		Если ВидПараметров <> Неопределено Тогда
			
			МассивПараметров = Новый Массив();
			Если ВидПараметров = "Договор" Тогда
				Если ДанныеОбъекта.Свойство("Организация") Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Организация", ДанныеОбъекта.Организация));
				КонецЕсли;
				Если ДанныеОбъекта.Свойство("Контрагент") Тогда
					ИмяКонтрагента = БухгалтерскийУчетКлиентСерверПереопределяемый.ПолучитьИмяРеквизитаКонтрагентДоговора();
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор." + ИмяКонтрагента, ДанныеОбъекта.Контрагент));
				КонецЕсли;
			ИначеЕсли ВидПараметров = "БанковскийСчет" Тогда
				Если ДанныеОбъекта.Свойство("Организация") Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", ДанныеОбъекта.Организация));
				КонецЕсли;
			ИначеЕсли ВидПараметров = "РегистрацияВИФНС" Тогда
				Если ДанныеОбъекта.Свойство("Организация") Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец",
						ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(ДанныеОбъекта.Организация)));
				КонецЕсли;
			ИначеЕсли ВидПараметров = "Субконто" И ДанныеОбъекта.Свойство("СчетУчета") Тогда
				СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(ДанныеОбъекта.СчетУчета);
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СвойстваСчета["ВидСубконто" + Индекс]));
			ИначеЕсли ВидПараметров = "Подразделение" Тогда
				Если ДанныеОбъекта.Свойство("Организация") Тогда
					ИмяРеквизитаОрганизация = БухгалтерскийУчетКлиентСерверПереопределяемый.ИмяРеквизитаОрганизацияПодразделения();
					Если ЗначениеЗаполнено(ИмяРеквизитаОрганизация) Тогда
						МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор." + ИмяРеквизитаОрганизация, ДанныеОбъекта.Организация));
					КонецЕсли;
				КонецЕсли;
			ИначеЕсли ВидПараметров = "ВидыПлатежейВГосБюджет"
				И ДанныеОбъекта.Свойство("СчетУчета") Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.СчетУчета", ДанныеОбъекта.СчетУчета));
			КонецЕсли;
			
			Если МассивПараметров.Количество() > 0 Тогда
				ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
				ЭлементФормыСубконто.ПараметрыВыбора = ПараметрыВыбора;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьСубконтоПриИзмененииСубконто(Объект, НомерСубконто, ПараметрыУстановки, ДанныеОбъекта)
	
	ПоляОбъекта  = ПараметрыУстановки.ПоляОбъекта;
	
	ВсеТипыСвязанныхСубконто = БухгалтерскийУчетВызовСервераПовтИсп.ВсеТипыСвязанныхСубконто();
	ТипыСубконтоДляОчистки   = Новый ОписаниеТипов(Новый Массив);
	Для каждого СвойствоОбъекта Из ДанныеОбъекта Цикл
		СвязанныеТипы = ВсеТипыСвязанныхСубконто[СвойствоОбъекта.Ключ];
		Если СвязанныеТипы <> Неопределено Тогда
			ТипыСубконтоДляОчистки = Новый ОписаниеТипов(ТипыСубконтоДляОчистки, СвязанныеТипы.Типы());
		КонецЕсли;
	КонецЦикла;
	
	Для Индекс = НомерСубконто + 1 По 3 Цикл
		
		Если НЕ ЗначениеЗаполнено(ПоляОбъекта["Субконто" + Индекс]) Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяСубконто = ПоляОбъекта["Субконто" + Индекс];
		ТипСубконто = ТипЗнч(Объект[ИмяСубконто]);
		
		Если ЗначениеЗаполнено(Объект[ИмяСубконто])
			И ТипыСубконтоДляОчистки.СодержитТип(ТипСубконто) Тогда
			Объект[ИмяСубконто] = Новый (ТипСубконто);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьСубконтоПриИзмененииОрганизации(Объект, ПараметрыУстановки)
	
	ВсеТипыСвязанныхСубконто   = БухгалтерскийУчетВызовСервераПовтИсп.ВсеТипыСвязанныхСубконто();
	ТипыСвязанныеСОрганизацией = ВсеТипыСвязанныхСубконто["Организация"];
	
	ПоляОбъекта = ПараметрыУстановки.ПоляОбъекта;
	
	Для каждого ПолеОбъекта Из ПоляОбъекта Цикл
		ИмяПоля = ПолеОбъекта.Значение;
		Если ЗначениеЗаполнено(ИмяПоля)
			И ЗначениеЗаполнено(Объект[ИмяПоля]) Тогда
			ТипПоля = ТипЗнч(Объект[ИмяПоля]);
			Если ТипыСвязанныеСОрганизацией.СодержитТип(ТипПоля) Тогда
				Объект[ИмяПоля] = Новый (ТипПоля);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьСвойстваСубконтоШапки(Форма, Объект, ПараметрыУстановки)
	
	Элементы = Форма.Элементы;
	
	ПоляОбъекта = ПараметрыУстановки.ПоляОбъекта;
	ПоляФормы   = ПараметрыУстановки.ПоляФормы;
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Объект[ПоляОбъекта.СчетУчета]);
	
	Для Индекс = 1 По 3 Цикл
		Если НЕ ЗначениеЗаполнено(ПоляФормы["Субконто" + Индекс]) Тогда
			Продолжить;
		КонецЕсли;
		ПолеСубконто = Элементы.Найти(ПоляФормы["Субконто" + Индекс]);
		Если ПолеСубконто <> Неопределено Тогда
			ПоказатьСубконто = ДанныеСчета.КоличествоСубконто >= Индекс
				И НЕ НужноСкрытьСубконто(ПараметрыУстановки.СкрыватьСубконто, ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"]);
			ПолеСубконто.Видимость = ПоказатьСубконто;
			Если ПоказатьСубконто Тогда
				ПолеСубконто.Заголовок = ДанныеСчета["ВидСубконто" + Индекс + "Наименование"];
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ПоляФормы.Подразделение) Тогда
		ПолеПодразделение = Элементы.Найти(ПоляФормы.Подразделение);
		Если ПолеПодразделение <> Неопределено Тогда
			Если ПоляОбъекта.Свойство("ПодразделениеДоступность") Тогда
				Объект[ПоляОбъекта["ПодразделениеДоступность"]] = ДанныеСчета.УчетПоПодразделениям;
			КонецЕсли;
			ПолеПодразделение.Доступность = ДанныеСчета.УчетПоПодразделениям
				ИЛИ ПоляОбъекта.Свойство("УчетПоПодразделениям") И Объект[ПоляОбъекта["УчетПоПодразделениям"]];
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьСвойстваСубконтоСтроки(Форма, СтрокаТаблицы, ПараметрыУстановки)
	
	Элементы = Форма.Элементы;
	
	ПоляОбъекта = ПараметрыУстановки.ПоляОбъекта;
	ПоляФормы   = ПараметрыУстановки.ПоляФормы;
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы[ПоляОбъекта.СчетУчета]);
	
	Для Индекс = 1 По ДанныеСчета.КоличествоСубконто Цикл
		Если ЗначениеЗаполнено(ПоляФормы["Субконто" + Индекс]) Тогда
			ПолеСубконто = Элементы[ПоляФормы["Субконто" + Индекс]];
			ПолеСубконто.ПодсказкаВвода = ДанныеСчета["ВидСубконто" + Индекс + "Наименование"];
			ПолеСубконто.ОграничениеТипа = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПредопределенныеЗначенияСубконтоПоУмолчанию()
	
	ЗначенияПоУмолчанию = Новый Соответствие;
	
	ЗначенияПоУмолчанию.Вставить(
		ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы"),
		БухгалтерскийУчетВызовСервераПовтИсп.ОсновнаяНоменклатурнаяГруппа());
		
	ЗначенияПоУмолчанию.Вставить(
		ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ПрочиеДоходыИРасходы"),
		ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ПрочиеДоходыИРасходы.ПрочиеВнереализационныеДоходыРасходы"));
		
	Возврат ЗначенияПоУмолчанию;
	
КонецФункции

Процедура УстановитьЗначенияСубконтоПоУмолчанию(Объект, ПараметрыУстановки)
	
	ПоляОбъекта  = ПараметрыУстановки.ПоляОбъекта;
	ДопРеквизиты = ПараметрыУстановки.ДопРеквизиты;
	
	ЗначенияПоУмолчанию = ПредопределенныеЗначенияСубконтоПоУмолчанию();
	Для Каждого КлючИЗначение Из ПараметрыУстановки.ЗначенияПоУмолчанию Цикл
		ЗначенияПоУмолчанию.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Объект[ПоляОбъекта.СчетУчета]);
	
	Для Индекс = 1 По 3 Цикл
		
		ИмяПоля = ПоляОбъекта["Субконто" + Индекс];
		Если НЕ ЗначениеЗаполнено(ИмяПоля) 
			ИЛИ ЗначениеЗаполнено(Объект[ИмяПоля]) Тогда
			Продолжить;
		КонецЕсли;
		
		ТипСубконто = ТипЗнч(Объект[ИмяПоля]);
		ЗначениеПоУмолчанию = ЗначенияПоУмолчанию[ДанныеСчета["ВидСубконто" + Индекс]];
		Если ЗначениеЗаполнено(ЗначениеПоУмолчанию) Тогда
			Объект[ИмяПоля] = ЗначениеПоУмолчанию;
		КонецЕсли; 
	КонецЦикла;
	
	ИмяПоля = ПоляОбъекта.Подразделение;
	Если ЗначениеЗаполнено(ИмяПоля) Тогда
		
		УчетПоПодразделениям = ДанныеСчета.УчетПоПодразделениям
			ИЛИ ПоляОбъекта.Свойство("УчетПоПодразделениям") И Объект[ПоляОбъекта["УчетПоПодразделениям"]];
		
		Если УчетПоПодразделениям И НЕ ЗначениеЗаполнено(Объект[ИмяПоля]) Тогда
			Если ДопРеквизиты.Свойство("ПодразделениеПоУмолчанию") Тогда
				ЗначениеПоУмолчанию = ДопРеквизиты.ПодразделениеПоУмолчанию;
			ИначеЕсли ДопРеквизиты.Свойство("Организация") Тогда
				ЗначениеПоУмолчанию = ОбщегоНазначенияБПВызовСервераПовтИсп.ПодразделениеПоУмолчанию(ДопРеквизиты.Организация);
			Иначе
				ЗначениеПоУмолчанию = Неопределено;
			КонецЕсли;
			Если ЗначениеЗаполнено(ЗначениеПоУмолчанию) Тогда
				Объект[ИмяПоля] = ЗначениеПоУмолчанию;
			КонецЕсли; 
		ИначеЕсли НЕ УчетПоПодразделениям И ЗначениеЗаполнено(Объект[ИмяПоля]) Тогда
			Объект[ИмяПоля] = Неопределено;
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

// Функция определяет, нужно ли скрывать данное субконто
//
// Параметры:
//	СкрыватьСубконто - Булево - - Признак того, нужно ли для этой формы дополнительно скрывать субконто
//	ТипЗначенияСубконто - Описание типов 
//
Функция НужноСкрытьСубконто(СкрыватьСубконто, ТипЗначенияСубконто)
	
	Если СкрыватьСубконто Тогда
		Возврат ТипЗначенияСубконто = Новый ОписаниеТипов("СправочникСсылка.НоменклатурныеГруппы") И
			БухгалтерскийУчетВызовСервераПовтИсп.ИспользоватьОднуНоменклатурнуюГруппу();
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
