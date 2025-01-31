#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ЭтоЭлектронныйДокумент") Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
			Наименование = НомерСчета + ", " + Банк.Наименование;
			 // Необходимо для записи объекта если владелец ссылка нового контрагента
			ОбменДанными.Загрузка = Истина;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Владелец") Тогда
			
			Если ТипЗнч(ДанныеЗаполнения.Владелец) = Тип("СправочникСсылка.Организации")
				И НЕ ДанныеЗаполнения.Свойство("ПодразделениеОрганизации") Тогда
				
				ДанныеЗаполнения.Вставить("ПодразделениеОрганизации",
					БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновноеПодразделениеОрганизации"));
				
			КонецЕсли;
			
			Если НЕ ДанныеЗаполнения.Свойство("ВсегдаУказыватьКПП") Тогда
				
				Если ТипЗнч(ДанныеЗаполнения.Владелец) = Тип("СправочникСсылка.Организации") Тогда
					ЗначениеНастройки = ХранилищеОбщихНастроек.Загрузить("НастройкиПлатежныхПорученийТребований", "ВсегдаУказыватьКППОрганизации");
				ИначеЕсли ТипЗнч(ДанныеЗаполнения.Владелец) = Тип("СправочникСсылка.Контрагенты") Тогда
					ЗначениеНастройки = ХранилищеОбщихНастроек.Загрузить("НастройкиПлатежныхПорученийТребований", "ВсегдаУказыватьКППКонтрагента");
				Иначе
					ЗначениеНастройки = Неопределено;
				КонецЕсли;
				
				Если ЗначениеНастройки <> Неопределено Тогда
					ДанныеЗаполнения.Вставить("ВсегдаУказыватьКПП", ЗначениеНастройки);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Валютный") Тогда
			Если НЕ ДанныеЗаполнения.Валютный Тогда
				ДанныеЗаполнения.Вставить("ВалютаДенежныхСредств", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
			КонецЕсли;
		Иначе
			Если ДанныеЗаполнения.Свойство("ВалютаДенежныхСредств") Тогда
				Если ДанныеЗаполнения.ВалютаДенежныхСредств <> ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета() Тогда
					ДанныеЗаполнения.Вставить("Валютный", Истина);
				КонецЕсли;
			Иначе
				ДанныеЗаполнения.Вставить("ВалютаДенежныхСредств", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
			КонецЕсли;
		КонецЕсли;
		
		Если Не ДанныеЗаполнения.Свойство("Банк") Тогда
			РаботаСБанкамиБП.УстановитьБанк(ДанныеЗаполнения);
		КонецЕсли;
		
		Если Не ДанныеЗаполнения.Свойство("БанкДляРасчетов") Тогда
			РаботаСБанкамиБП.УстановитьБанкДляРасчетов(ДанныеЗаполнения);
		КонецЕсли;
		
		Если Не ДанныеЗаполнения.Свойство("Наименование") Тогда
			ПараметрыЗаполнения = Новый Структура("НомерСчета,Банк,ВалютаДенежныхСредств");
			ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, ЭтотОбъект);
			ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, ДанныеЗаполнения);
			НаименованиеБанка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыЗаполнения.Банк, "Наименование");
			НаименованиеПоУмолчанию = УчетДенежныхСредствКлиентСервер.НаименованиеБанковскогоСчетаПоУмолчанию(
				ПараметрыЗаполнения.НомерСчета,
				"" + НаименованиеБанка,
				"" + ПараметрыЗаполнения.ВалютаДенежныхСредств,
				Валютный);
			ДанныеЗаполнения.Вставить("Наименование", НаименованиеПоУмолчанию);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	// Данные действия должны происходить при Записи всегда
	Если НЕ ПометкаУдаления Тогда
		// Получаем напрямую, т.к. функция с повт.исп. может запомнить некорректное значение,
		// когда в процессе обмена константа была еще не заполнена
		ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
		Если ЗначениеЗаполнено(ВалютаРегламентированногоУчета) Тогда
			Валютный = ВалютаРегламентированногоУчета <> ВалютаДенежныхСредств;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		Если Валютный И ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком() Тогда
			ТекстСообщения = НСтр("ru = 'Банковские счета в валюте не поддерживаются в режиме интеграции с банком.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка,, "Объект", Отказ);
		КонецЕсли;
	Иначе
		Если ВалютаДенежныхСредств <> Ссылка.ВалютаДенежныхСредств И СуществуютСсылки() Тогда
			ТекстСообщения = НСтр("ru = 'Существуют документы, в которых выбран банковский счет %1. Реквизит ""Валюта счета"" не может быть изменен.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СокрЛП(Наименование));
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Корректность",
				НСтр("ru = 'Валюта счета'"),,, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка,
				"ВалютаДенежныхСредств", "Объект", Отказ);
		КонецЕсли;
		СвойстваВладельца = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, "ОсновнойБанковскийСчет, ПометкаУдаления");
		Если ПометкаУдаления И ТипЗнч(Владелец) = Тип("СправочникСсылка.Организации") И НЕ СвойстваВладельца.ПометкаУдаления Тогда
			Если НЕ Справочники.БанковскиеСчета.ИспользуетсяНесколькоБанковскихСчетовОрганизации(Владелец) Тогда
				ТекстСообщения = НСтр("ru = 'Нельзя удалить единственный банковский счет, т.к. он используется для автозаполнения документов.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка,, "Объект", Отказ);
			ИначеЕсли Справочники.НастройкиИнтеграцииСБанками.ИнтеграцияВключена(Ссылка)
				И СвойстваВладельца.ОсновнойБанковскийСчет = Ссылка Тогда
					СчетаИнтеграции = Справочники.НастройкиИнтеграцииСБанками.БанковскиеСчетаОрганизацииВРежимеИнтеграции(
						Владелец);
					Если СчетаИнтеграции.Количество() = 1 Тогда
						ТекстСообщения = НСтр("ru = 'Нельзя удалить единственный банковский счет у которого настроена интеграция с банком.'");
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка,, "Объект", Отказ);
					КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Владелец) Тогда
		ВладелецОрганизация = ТипЗнч(Владелец) = Тип("СправочникСсылка.Организации");
		Если ВладелецОрганизация Тогда
			Справочники.БанковскиеСчета.ПроверитьУстановитьЗначениеОпцииИспользоватьНесколькоБанковскихСчетовОрганизации(
				Владелец,
				ПометкаУдаления);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДатаЗакрытия) Или ПометкаУдаления Тогда
			СвойстваВладельца = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, "ОсновнойБанковскийСчет, ПометкаУдаления");
			Если Не СвойстваВладельца.ПометкаУдаления И СвойстваВладельца.ОсновнойБанковскийСчет = Ссылка Тогда
				Если Справочники.НастройкиИнтеграцииСБанками.ИнтеграцияВключена(Ссылка) Тогда
					СчетаИнтеграции = Справочники.НастройкиИнтеграцииСБанками.БанковскиеСчетаОрганизацииВРежимеИнтеграции(
						Владелец);
					Для Каждого СчетИнтеграции Из СчетаИнтеграции Цикл
						Если СчетИнтеграции <> Ссылка Тогда
							Справочники.БанковскиеСчета.УстановитьОсновнойБанковскийСчет(Владелец, СчетИнтеграции);
							Прервать;
						КонецЕсли;
					КонецЦикла;
				Иначе
					Справочники.БанковскиеСчета.УстановитьОсновнойБанковскийСчет(Владелец, Справочники.БанковскиеСчета.ПустаяСсылка());
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция проверяет, существуют ли движения по банковскому счету.
// Если есть - менять реквизит "Валюта счета" нельзя.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Истина - если есть движения, Ложь - если нет.
//
Функция СуществуютСсылки()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("БанковскийСчет", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Субконто КАК ХозрасчетныйСубконто
	|ГДЕ
	|	ХозрасчетныйСубконто.Вид = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.БанковскиеСчета)
	|	И ХозрасчетныйСубконто.Значение = &БанковскийСчет";
	
	СтатусВозврата = НЕ Запрос.Выполнить().Пустой();
	
	Возврат СтатусВозврата;
	
КонецФункции

#КонецОбласти

#КонецЕсли
