#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Вызывается из длительной операции по подготовке данных для формы проверки и подбора табачной продукции.
// 
// Параметры:
//	Параметры - Структура - содержит следующие значения:
// 		* ПроверкаНеПоДокументу            - Булево - признак получения данных не по ссылке на документ
// 		* ПроверяемыйДокумент              - ДокументСсылка - ссылка на документ, из формы которого открыта форма проверки и подбора
// 		* НачальныйСтатусПроверки          - ПеречислениеСсылка.СтатусыПроверкиНаличияПродукцииИС - статус наличия продукции, используемый при подготовке данных
// 		* ДетализацияСтруктурыХранения     - ПеречислениеСсылка.ДетализацияСтруктурыХраненияТабачнойПродукцииМОТП - значение детализации из формы проверки
// 		* РедактированиеФормыНедоступно    - Булево - признак запрета редактирования формы подбора
// 		* РежимПодбораСуществующихУпаковок - Булево - признак работы со штрихкодами упаковок, имеющимися в информационной базе
// 		* КонтролироватьСканируемуюПродукциюПоДокументуОснованию - Булево - признак необходимости контроля наличия табачной продукции по основанию проверяемого документа
//	АдресРезультата - Строка - адрес временного хранилища, в которое будут помещены результаты выполнения
// Возвращаемое значение:
//
Процедура ЗагрузитьДанныеДокументаДлительнаяОперация(Параметры, АдресРезультата) Экспорт
	
	ОписаниеЗамера = ОценкаПроизводительности.НачатьЗамерДлительнойОперации(
		"Обработка.ПроверкаИПодборАлкогольнойПродукцииЕГАИС.МодульМенеджера.ЗагрузитьДанныеДокументаДлительнаяОперация");
	
	ДанныеДокумента = Новый Структура();
	ДанныеДокумента.Вставить("ДеревоМаркированнойПродукции",             ДеревоМаркированнойПродукции());
	ДанныеДокумента.Вставить("АлкогольнаяПродукцияКОпределениюСправок2", АлкогольнаяПродукцияКОпределениюСправок2());
	ДанныеДокумента.Вставить("ПулНеизвестныхАкцизныхМарок",              ПулНеизвестныхАкцизныхМарок());
	ДанныеДокумента.Вставить("ТаблицаНеМаркируемойПродукции",            ТаблицаНеМаркируемойПродукции());
	ДанныеДокумента.Вставить("Справки2СопоставленнаяНоменклатура",       Справки2СопоставленнаяНоменклатура());
	ДанныеДокумента.Вставить("ТаблицаШтрихкодовНеМаркируемойПродукции",  ТаблицаШтрихкодовНеМаркируемойПродукции());
	ДанныеДокумента.Вставить("УпаковкиДокумента",                        Новый СписокЗначений());
	ДанныеДокумента.Вставить("ДобавленныеУпаковки",                      Новый СписокЗначений());
	ДанныеДокумента.Вставить("ДоступныеДляПроверкиУпаковки",             Новый СписокЗначений());
	ДанныеДокумента.Вставить("НачальныйСтатусПроверки",                  Параметры.НачальныйСтатусПроверки);
	ДанныеДокумента.Вставить("ДетализацияСтруктурыХранения",             Параметры.ДетализацияСтруктурыХранения);
	ДанныеДокумента.Вставить("РедактированиеФормыНедоступно",            Параметры.РедактированиеФормыНедоступно);
	ДанныеДокумента.Вставить("РежимПодбораСуществующихУпаковок",         Параметры.РежимПодбораСуществующихУпаковок);
	ДанныеДокумента.Вставить("КонтролироватьСканируемуюПродукциюПоДокументуОснованию", Параметры.КонтролироватьСканируемуюПродукциюПоДокументуОснованию);
	
	СохраненнаяДетализацияСтруктурыХранения = Неопределено;
	СохраненныеНастройки = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("Обработка.ПроверкаИПодборАлкогольнойПродукцииЕГАИС.Форма.ПроверкаИПодбор", "");
	
	Если ТипЗнч(СохраненныеНастройки) = Тип("Структура")
		И СохраненныеНастройки.Свойство("ДетализацияСтруктурыХранения") Тогда
		СохраненнаяДетализацияСтруктурыХранения = СохраненныеНастройки.ДетализацияСтруктурыХранения;
	КонецЕсли;
		
	ДанныеДокумента.Вставить("СохраненнаяДетализацияСтруктурыХранения", СохраненнаяДетализацияСтруктурыХранения);
	ДанныеДокумента.Вставить("СтрокаБутылкиБезКоробки", Неопределено);
	
	Если Параметры.ПроверкаНеПоДокументу Тогда
			
		ПроверяемыеДанные = Параметры.ПроверяемыеДанные;
		
		Если ТипЗнч(ПроверяемыеДанные) = Тип("Структура") Тогда
			ЗаполнитьДеревоКОпределениюСправок2(ПроверяемыеДанные.ТаблицаАлкогольнойПродукцииКОпределениюСправок2, ДанныеДокумента);
			ЗагрузитьДеревоМаркированнойПродукции(ПроверяемыеДанные.ДеревоУпаковок, ДанныеДокумента);
		Иначе
			ДобавленнаяСтрокаБутылкиБезКоробки(ДанныеДокумента);
		КонецЕсли;
	
	ИначеЕсли ТипЗнч(Параметры.ПроверяемыйДокумент) = Тип("ДокументСсылка.ТТНВходящаяЕГАИС") Тогда
	
		ИнтеграцияЕГАИСПереопределяемый.ЗаполнитьТаблицуШтрихкодовНеМаркируемойПродукцииТТН_ЕГАИС(
			Параметры.ПроверяемыйДокумент, ДанныеДокумента.ТаблицаШтрихкодовНеМаркируемойПродукции);
		
		ИнтеграцияЕГАИСПереопределяемый.ЗаполнитьТаблицуСопоставленныхСправок2ТТН_ЕГАИС(
			Параметры.ПроверяемыйДокумент, ДанныеДокумента.Справки2СопоставленнаяНоменклатура);
		
		ДанныеПроверяемогоДокумента = Документы.ТТНВходящаяЕГАИС.ВходящееДеревоУпаковок(Параметры.ПроверяемыйДокумент);
		
		ЗагрузитьДеревоМаркированнойПродукции(ДанныеПроверяемогоДокумента.ДеревоУпаковок, ДанныеДокумента);
		ЗаполнитьТаблицуПартионнойПродукции(ДанныеПроверяемогоДокумента.ТоварыБезАкцизныхМарок, ДанныеДокумента);
		ЗаполнитьПулНеизвестныхАкцизныхМарок(ДанныеДокумента);
	
	ИначеЕсли ТипЗнч(Параметры.ПроверяемыйДокумент) = Тип("ДокументСсылка.АктПостановкиНаБалансЕГАИС")
		Или ТипЗнч(Параметры.ПроверяемыйДокумент) = Тип("ДокументСсылка.АктСписанияЕГАИС")
		Или ТипЗнч(Параметры.ПроверяемыйДокумент) = Тип("ДокументСсылка.ЧекЕГАИС")
		Или ТипЗнч(Параметры.ПроверяемыйДокумент) = Тип("ДокументСсылка.ЧекЕГАИСВозврат")
		Или (ТипЗнч(Параметры.ПроверяемыйДокумент) = Тип("ДокументСсылка.ТТНИсходящаяЕГАИС") 
			И Параметры.РежимПодбораСуществующихУпаковок) Тогда
		
		МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Параметры.ПроверяемыйДокумент);
		ТаблицаКОпределениюСправок2 = МенеджерДокумента.ТаблицаАлкогольнойПродукцииКОпределениюСправок2(Параметры.ПроверяемыйДокумент);
		ДанныеПроверяемогоДокумента = ШтрихкодированиеЕГАИС.ВложенныеШтрихкодыУпаковокПоДокументу(
			Параметры.ПроверяемыйДокумент, Не Параметры.РедактированиеФормыНедоступно);

		ЗаполнитьДеревоКОпределениюСправок2(ТаблицаКОпределениюСправок2, ДанныеДокумента);
		ЗагрузитьДеревоМаркированнойПродукции(ДанныеПроверяемогоДокумента.ДеревоУпаковок, ДанныеДокумента);
		
	ИначеЕсли ТипЗнч(Параметры.ПроверяемыйДокумент) = Тип("ДокументСсылка.ТТНИсходящаяЕГАИС") Тогда
		
		ТаблицаКОпределениюСправок2 = Документы.ТТНИсходящаяЕГАИС.ТаблицаАлкогольнойПродукцииКОпределениюСправок2(Параметры.ПроверяемыйДокумент);
		ЗаполнитьДеревоКОпределениюСправок2(ТаблицаКОпределениюСправок2, ДанныеДокумента);
		
		ПроверяемыеДанные = Параметры.ПроверяемыеДанные;
		
		Если ТипЗнч(ПроверяемыеДанные) = Тип("Структура") Тогда
			ЗаполнитьДеревоКОпределениюСправок2(ПроверяемыеДанные.ТаблицаАлкогольнойПродукцииКОпределениюСправок2, ДанныеДокумента);
			ЗагрузитьДеревоМаркированнойПродукции(ПроверяемыеДанные.ДеревоУпаковок, ДанныеДокумента);
		Иначе
			ДобавленнаяСтрокаБутылкиБезКоробки(ДанныеДокумента);
		КонецЕсли;
		
	КонецЕсли;
	
	КоличествоДанных = КоличествоСтрокДереваЗначений(ДанныеДокумента.ДеревоМаркированнойПродукции)
		+ КоличествоСтрокДереваЗначений(ДанныеДокумента.АлкогольнаяПродукцияКОпределениюСправок2)
		+ ДанныеДокумента.ПулНеизвестныхАкцизныхМарок.Количество()
		+ ДанныеДокумента.ТаблицаНеМаркируемойПродукции.Количество()
		+ ДанныеДокумента.Справки2СопоставленнаяНоменклатура.Количество()
		+ ДанныеДокумента.ТаблицаШтрихкодовНеМаркируемойПродукции.Количество();
	
	ОценкаПроизводительности.ЗакончитьЗамерДлительнойОперации(ОписаниеЗамера, КоличествоДанных);
	
	ПоместитьВоВременноеХранилище(ДанныеДокумента, АдресРезультата);
	
КонецПроцедуры

// Фоновая операция по фиксации результатов проверки и подбора в документе, 
// 
// Параметры:
// Параметры - Структура - содержит следующие значения:
//  ПроверкаНеПоДокументу        - Булево - признак того, что проверка и подбор была вызвана из произвольной формы.
//  ПроверяемыйДокумент          - ДокументСсылка - документ, для которого выполнялась проверка и подбор.
//  ДанныеПроверкиИПодбора       - Структруа      - содержит слепок состояния проверки и подбора, если предусмотрено его хранение по окончании результатов проверки.
//  ДеревоМаркируемойПродукции   - ДеревоЗначений - содержит результаты проверки и подбора с иерархией упаковок.
//  ТаблицаНеМаркируемойПродукции - ТаблицаЗначений - содержит информацию о подобранной продукции сгруппированную до номенклатуры, характеристики, серии.
// АдресРезультата - Строка - адрес временного хранилища, в которое будут помещены результаты выполнения
// Возвращаемое значение:
//
Процедура ЗафиксироватьРезультатПроверкиИПодбора(Параметры, АдресРезультата) Экспорт
	
	ОписаниеЗамера = ОценкаПроизводительности.НачатьЗамерДлительнойОперации(
		"Обработка.ПроверкаИПодборАлкогольнойПродукцииЕГАИС.МодульМенеджера.ЗафиксироватьРезультатПроверкиИПодбора");
	
	ДеревоМаркируемойПродукции = Параметры.ДеревоМаркируемойПродукции;
	ДеревоМаркируемойПродукции.Колонки.Добавить("ШтрихкодУпаковки", Новый ОписаниеТипов("СправочникСсылка.ШтрихкодыУпаковокТоваров"));
	
	Если Параметры.ПроверкаНеПоДокументу Тогда
		Грузополучатель = Неопределено;
	ИначеЕсли ТипЗнч(Параметры.ПроверяемыйДокумент) = Тип("ДокументСсылка.ТТНВходящаяЕГАИС") Тогда
		Грузополучатель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ПроверяемыйДокумент, "Грузополучатель");
	Иначе
		Грузополучатель = Неопределено;
	КонецЕсли;
		
	НачатьТранзакцию();
	
	Попытка
		
		ШтрихкодыУпаковок = ШтрихкодированиеИС.ШтрихкодыУпаковок(
			ИнтеграцияЕГАИС.ЗначенияШтрихкодовИзДереваУпаковок(ДеревоМаркируемойПродукции));
		
		Справочники.ШтрихкодыУпаковокТоваров.СоздатьШтрихкодыУпаковок(ДеревоМаркируемойПродукции,
			ШтрихкодыУпаковок,, Грузополучатель);
		
		ЗафиксироватьТранзакцию();
	
		ПоместитьВоВременноеХранилище(Параметры, АдресРезультата);
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'Не удалось сохранить результаты сканирования и проверки по причине: %1'",
				ОбщегоНазначения.КодОсновногоЯзыка()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ИнтеграцияЕГАИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки);
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Не удалось сохранить результаты сканирования и проверки по причине: %1'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		ВызватьИсключение;
		
	КонецПопытки;
		
	Если ТипЗнч(ШтрихкодыУпаковок) = Тип("ТаблицаЗначений") Тогда
		КоличествоДанных = ШтрихкодыУпаковок.Количество();
	Иначе
		КоличествоДанных = 0;
	КонецЕсли;
		
	ОценкаПроизводительности.ЗакончитьЗамерДлительнойОперации(ОписаниеЗамера, КоличествоДанных);
		
КонецПроцедуры

// Возвращает детализацию переданной иерархической структуры упаковок табачной продукции.
// 
// Параметры:
//	* ДеревоУпаковок - ДеревоЗначений, ДанныеФормыКоллекция - иерархическая структура упаковок табачной продукции.
// Возвращаемое значение:
//	* ДетализацияСтруктурыДерева - ПеречислениеСсылка.ДетализацияСтруктурыХраненияТабачнойПродукцииМОТП - расчитаная детализация структуры упаковок
//
Функция ДетализацияСтруктурыХраненияДерева(ДеревоУпаковок) Экспорт

	ДетализацияСтруктурыХраненияДерева = Перечисления.ДетализацияСтруктурыХраненияАлкогольнойПродукции.Бутылки;
	
	Для Каждого СтрокаДерева Из ДеревоУпаковок.Строки Цикл
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(СтрокаДерева.ТипУпаковки) Тогда
			
			ДетализацияСтруктурыХраненияДерева = Перечисления.ДетализацияСтруктурыХраненияАлкогольнойПродукции.КоробаСБутылками;
			
			Для Каждого ПодчиненнаяСтрока Из СтрокаДерева.Строки Цикл
				
				Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ПодчиненнаяСтрока.ТипУпаковки) Тогда
					
					ДетализацияСтруктурыХраненияДерева = Перечисления.ДетализацияСтруктурыХраненияАлкогольнойПродукции.Полная;
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ДетализацияСтруктурыХраненияДерева = Перечисления.ДетализацияСтруктурыХраненияАлкогольнойПродукции.Полная Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДетализацияСтруктурыХраненияДерева;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДеревоКОпределениюСправок2(ТаблицаКОпределениюСправок2, ДанныеДокумента)

	Для Каждого СтрокаТаблицы Из ТаблицаКОпределениюСправок2 Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.АлкогольнаяПродукция)
			И Не ЗначениеЗаполнено(СтрокаТаблицы.Номенклатура) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		НоваяСтрока = ДанныеДокумента.АлкогольнаяПродукцияКОпределениюСправок2.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		ПроверкаИПодборПродукцииЕГАИСКлиентСервер.УстановитьИндексКартинкиСостояниеПодбораАкцизныхМарок(НоваяСтрока);
		
	КонецЦикла;

КонецПроцедуры

Процедура ЗагрузитьДеревоМаркированнойПродукции(ДеревоПоДаннымДокумента, ДанныеДокумента)
	
	ДетализацияСтруктурыХраненияДанныхДокумента = ДетализацияСтруктурыХраненияДерева(ДеревоПоДаннымДокумента);
	
	Если ДанныеДокумента.СохраненнаяДетализацияСтруктурыХранения <> Неопределено Тогда
		Если ДеревоПоДаннымДокумента.Строки.Количество() = 0 Тогда
			ДанныеДокумента.ДетализацияСтруктурыХранения = ДанныеДокумента.СохраненнаяДетализацияСтруктурыХранения;
		ИначеЕсли ДетализацияСтруктурыХраненияДанныхДокумента = Перечисления.ДетализацияСтруктурыХраненияАлкогольнойПродукции.Полная
			ИЛИ ДетализацияСтруктурыХраненияДанныхДокумента = Перечисления.ДетализацияСтруктурыХраненияАлкогольнойПродукции.КоробаСБутылками Тогда
			ДанныеДокумента.ДетализацияСтруктурыХранения = ДетализацияСтруктурыХраненияДанныхДокумента;
		Иначе
			ДанныеДокумента.ДетализацияСтруктурыХранения = ДанныеДокумента.СохраненнаяДетализацияСтруктурыХранения;
		КонецЕсли;
	Иначе
		ДанныеДокумента.ДетализацияСтруктурыХранения = ДетализацияСтруктурыХраненияДанныхДокумента;
	КонецЕсли;
	
	КоллекцияСтрокПриемника = ДанныеДокумента.ДеревоМаркированнойПродукции.Строки;
	
	Для каждого СтрокаПоДаннымДокумента Из ДеревоПоДаннымДокумента.Строки Цикл
		ДобавитьСтрокуДереваМаркированнойПродукцииПриЗагрузке(СтрокаПоДаннымДокумента, КоллекцияСтрокПриемника, ДанныеДокумента);
	КонецЦикла;
	
	Если ДанныеДокумента.СтрокаБутылкиБезКоробки = Неопределено
		И ДанныеДокумента.ДетализацияСтруктурыХранения <> Перечисления.ДетализацияСтруктурыХраненияАлкогольнойПродукции.Бутылки Тогда
		ДобавленнаяСтрокаБутылкиБезКоробки(ДанныеДокумента);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьСтрокуДереваМаркированнойПродукцииПриЗагрузке(СтрокаИсточника, КоллекцияСтрокПриемника, ДанныеДокумента)
	
	Если СтрокаИсточника.ТипУпаковки = Перечисления.ПрочиеЗоныПересчетаАлкогольнойПродукции.БутылкиБезКоробки Тогда
		
		Если ДанныеДокумента.ДетализацияСтруктурыХранения <> Перечисления.ДетализацияСтруктурыХраненияАлкогольнойПродукции.Бутылки Тогда
			
			НоваяСтрока = ДанныеДокумента.СтрокаБутылкиБезКоробки;
			
			Если НоваяСтрока = Неопределено Тогда
				НоваяСтрока = ДобавленнаяСтрокаБутылкиБезКоробки(ДанныеДокумента);
			КонецЕсли;
			
		Иначе
			
			Для Каждого ПодчиненнаяСтрокаИсточника Из СтрокаИсточника.Строки Цикл
		
				ДобавитьСтрокуДереваМаркированнойПродукцииПриЗагрузке(ПодчиненнаяСтрокаИсточника, КоллекцияСтрокПриемника, ДанныеДокумента);
		
			КонецЦикла;
			
			Возврат;
			
		КонецЕсли;
		
	ИначеЕсли СтрокаИсточника.Родитель = Неопределено
		И СтрокаИсточника.ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар
		И ДанныеДокумента.ДетализацияСтруктурыХранения <> Перечисления.ДетализацияСтруктурыХраненияАлкогольнойПродукции.Бутылки Тогда
		
		СтрокаБутылкиБезУпаковки = ДанныеДокумента.СтрокаБутылкиБезКоробки;
		
		Если СтрокаБутылкиБезУпаковки = Неопределено Тогда
			СтрокаБутылкиБезУпаковки = ДобавленнаяСтрокаБутылкиБезКоробки(ДанныеДокумента);
		КонецЕсли;
		
		НоваяСтрока = СтрокаБутылкиБезУпаковки.Строки.Добавить();
		НоваяСтрока.СтатусПроверки = ДанныеДокумента.НачальныйСтатусПроверки;
		
	Иначе
		
		НоваяСтрока = КоллекцияСтрокПриемника.Добавить();
		НоваяСтрока.СтатусПроверки = ДанныеДокумента.НачальныйСтатусПроверки;
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаИсточника);
	
	Если НоваяСтрока.ТипУпаковки = Перечисления.ТипыУпаковок.ПустаяСсылка() Тогда
		НоваяСтрока.ТипУпаковки = Перечисления.ТипыУпаковок.МонотоварнаяУпаковка;
	КонецЕсли;
	
	ПроверкаИПодборПродукцииЕГАИСКлиентСервер.УстановитьДоступностьУпаковкиДляПроверки(НоваяСтрока, ДанныеДокумента.ДоступныеДляПроверкиУпаковки);
	ПроверкаИПодборПродукцииЕГАИСКлиентСервер.СформироватьПредставлениеДляСтрокиДереваМаркированнойПродукции(НоваяСтрока);
	
	Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(НоваяСтрока.ТипУпаковки) Тогда
		ДанныеДокумента.УпаковкиДокумента.Добавить(НоваяСтрока.Штрихкод);
	КонецЕсли;

	КоллекцияСтрокДобавленнойСтроки = НоваяСтрока.Строки;
	
	Для Каждого ПодчиненнаяСтрокаИсточника Из СтрокаИсточника.Строки Цикл
		
		ДобавитьСтрокуДереваМаркированнойПродукцииПриЗагрузке(ПодчиненнаяСтрокаИсточника, КоллекцияСтрокДобавленнойСтроки, ДанныеДокумента);
		
	КонецЦикла;

КонецПроцедуры

Процедура ЗаполнитьТаблицуПартионнойПродукции(ДанныеПартионнойПродукции, ДанныеДокумента)
	
	Для Каждого СтрокаТаблицы Из ДанныеПартионнойПродукции Цикл
		
		НоваяСтрока = ДанныеДокумента.ТаблицаНеМаркируемойПродукции.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		НоваяСтрока.КоличествоПоДокументу = СтрокаТаблицы.Количество;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПулНеизвестныхАкцизныхМарок(ДанныеДокумента)

	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеПартионнойПродукции.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ДанныеПартионнойПродукции.Справка2 КАК Справка2,
	|	ДанныеПартионнойПродукции.КоличествоПоДокументу КАК Количество,
	|	ДанныеПартионнойПродукции.КоличествоФактическое КАК КоличествоФактическое
	|ПОМЕСТИТЬ ДанныеПартионнойПродукции
	|ИЗ
	|	&ДанныеПартионнойПродукции КАК ДанныеПартионнойПродукции
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеПартионнойПродукции.АлкогольнаяПродукция               КАК АлкогольнаяПродукция,
	|	ДанныеПартионнойПродукции.Справка2                           КАК Справка2,
	|	ЕСТЬNULL(ДанныеПартионнойПродукции.Справка2.Поштучная, ЛОЖЬ) КАК Поштучная,
	|	СУММА(ДанныеПартионнойПродукции.Количество)                  КАК Количество
	|ИЗ
	|	ДанныеПартионнойПродукции КАК ДанныеПартионнойПродукции
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассификаторАлкогольнойПродукцииЕГАИС КАК КлассификаторАлкогольнойПродукцииЕГАИС
	|		ПО ДанныеПартионнойПродукции.АлкогольнаяПродукция = КлассификаторАлкогольнойПродукцииЕГАИС.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции
	|		ПО КлассификаторАлкогольнойПродукцииЕГАИС.ВидПродукции = ВидыАлкогольнойПродукции.Ссылка
	|ГДЕ
	|	ВидыАлкогольнойПродукции.Маркируемый
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеПартионнойПродукции.АлкогольнаяПродукция,
	|	ДанныеПартионнойПродукции.Справка2,
	|	ЕСТЬNULL(ДанныеПартионнойПродукции.Справка2.Поштучная, ЛОЖЬ)";
	
	Запрос.УстановитьПараметр("ДанныеПартионнойПродукции", ДанныеДокумента.ТаблицаНеМаркируемойПродукции);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ДанныеДокумента.ПулНеизвестныхАкцизныхМарок.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры

Функция ДобавленнаяСтрокаБутылкиБезКоробки(ДанныеДокумента)
	
	НоваяСтрока = ДанныеДокумента.ДеревоМаркированнойПродукции.Строки.Вставить(0);
	
	ПроверкаИПодборПродукцииЕГАИСКлиентСервер.ЗаполнитьСтрокуБутылкиБезКоробки(НоваяСтрока);
	
	ДанныеДокумента.СтрокаБутылкиБезКоробки = НоваяСтрока;
	
	Возврат НоваяСтрока;

КонецФункции

Функция ДеревоМаркированнойПродукции()
	
	ДеревоМаркированнойПродукции = Новый ДеревоЗначений();
	ДеревоМаркированнойПродукции.Колонки.Добавить("СтатусПроверки",                      Новый ОписаниеТипов("ПеречислениеСсылка.СтатусыПроверкиНаличияПродукцииИС"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ПредставлениеПроверкиПодчиненных",    Новый ОписаниеТипов("Строка"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ТипУпаковки", Новый ОписаниеТипов("ПеречислениеСсылка.ПрочиеЗоныПересчетаАлкогольнойПродукции, ПеречислениеСсылка.ТипыУпаковок"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("КоличествоПодчиненныхУпаковок",       Новый ОписаниеТипов("Число"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("КоличествоПодчиненныхВНаличии",       Новый ОписаниеТипов("Число"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("КоличествоПодчиненныхОтсутствует",    Новый ОписаниеТипов("Число"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("Штрихкод",                            Новый ОписаниеТипов("Строка"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ВсяУпаковкаПроверена",                Новый ОписаниеТипов("Булево"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ИндексКартинкиШтрихкод",              Новый ОписаниеТипов("Число"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ИндексКартинкиСтатусПроверки",        Новый ОписаниеТипов("Число"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ТребуетсяПеремаркировка",             Новый ОписаниеТипов("Булево"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("АлкогольнаяПродукция",                Новый ОписаниеТипов("СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("Справка2",                            Новый ОписаниеТипов("СправочникСсылка.Справки2ЕГАИС"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("Представление",                       Новый ОписаниеТипов("Строка"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ПредставлениеСодержимоеУпаковки",     Новый ОписаниеТипов("Строка"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("КоличествоПодчиненныхОтложено",       Новый ОписаниеТипов("Число"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("КоличествоПодчиненныхБутылок",        Новый ОписаниеТипов("Число"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("НомерСтикераОтложено",                Новый ОписаниеТипов("Строка"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("НеСодержитсяВДанныхДокумента",        Новый ОписаниеТипов("Булево"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("НеСоответствуетОтбору",               Новый ОписаниеТипов("Булево"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ИдетПроверкаДаннойУпаковки",          Новый ОписаниеТипов("Булево"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("КоличествоПодчиненныхНеЧислилось",    Новый ОписаниеТипов("Число"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("КоличествоПодчиненныхНеПроверялось",  Новый ОписаниеТипов("Число"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("КоличествоПодчиненныхВсего",          Новый ОписаниеТипов("Число"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ХешСумма",                            Новый ОписаниеТипов("Строка"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("Номенклатура",                        Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	ДеревоМаркированнойПродукции.Колонки.Добавить("Характеристика",                      Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);	
	ДеревоМаркированнойПродукции.Колонки.Добавить("Серия",                               Метаданные.ОпределяемыеТипы.СерияНоменклатуры.Тип);	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ИдентификаторСтроки",                 Новый ОписаниеТипов("Строка"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ВУпаковкеРазныеСерии",                Новый ОписаниеТипов("Булево"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ВУпаковкеРазнаяНоменклатура",         Новый ОписаниеТипов("Булево"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ВУпаковкеРазныеХарактеристики",       Новый ОписаниеТипов("Булево"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ВУпаковкеРазнаяАлкогольнаяПродукция", Новый ОписаниеТипов("Булево"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ВУпаковкеРазныеСправки2",             Новый ОписаниеТипов("Строка"));	
	ДеревоМаркированнойПродукции.Колонки.Добавить("ВсеСправки2Указаны",                  Новый ОписаниеТипов("Число"));	
	
	Возврат ДеревоМаркированнойПродукции;
	
КонецФункции

Функция АлкогольнаяПродукцияКОпределениюСправок2()
	
	АлкогольнаяПродукцияКОпределениюСправок2 = Новый ДеревоЗначений();
	АлкогольнаяПродукцияКОпределениюСправок2.Колонки.Добавить("Номенклатура",           Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	АлкогольнаяПродукцияКОпределениюСправок2.Колонки.Добавить("Характеристика",         Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	АлкогольнаяПродукцияКОпределениюСправок2.Колонки.Добавить("Серия",                  Метаданные.ОпределяемыеТипы.СерияНоменклатуры.Тип);
	АлкогольнаяПродукцияКОпределениюСправок2.Колонки.Добавить("АлкогольнаяПродукция",   Новый ОписаниеТипов("СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС"));	
	АлкогольнаяПродукцияКОпределениюСправок2.Колонки.Добавить("Справка2",               Новый ОписаниеТипов("СправочникСсылка.Справки2ЕГАИС"));	
	АлкогольнаяПродукцияКОпределениюСправок2.Колонки.Добавить("Количество",             Новый ОписаниеТипов("Число"));
	АлкогольнаяПродукцияКОпределениюСправок2.Колонки.Добавить("КоличествоРаспределено", Новый ОписаниеТипов("Число"));
	АлкогольнаяПродукцияКОпределениюСправок2.Колонки.Добавить("Маркируемая",            Новый ОписаниеТипов("Булево"));
	АлкогольнаяПродукцияКОпределениюСправок2.Колонки.Добавить("ИндексАкцизнойМарки",    Новый ОписаниеТипов("Число"));
	
	Возврат АлкогольнаяПродукцияКОпределениюСправок2;
	
КонецФункции

Функция ПулНеизвестныхАкцизныхМарок()

	ПулНеизвестныхАкцизныхМарок = Новый ТаблицаЗначений();
	ПулНеизвестныхАкцизныхМарок.Колонки.Добавить("АлкогольнаяПродукция", Новый ОписаниеТипов("СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС"));	
	ПулНеизвестныхАкцизныхМарок.Колонки.Добавить("Справка2",             Новый ОписаниеТипов("СправочникСсылка.Справки2ЕГАИС"));	
	ПулНеизвестныхАкцизныхМарок.Колонки.Добавить("Количество",           Новый ОписаниеТипов("Число"));
	ПулНеизвестныхАкцизныхМарок.Колонки.Добавить("Поштучная",            Новый ОписаниеТипов("Булево"));
	
	Возврат ПулНеизвестныхАкцизныхМарок;
	
КонецФункции

Функция ТаблицаНеМаркируемойПродукции()

	ТаблицаНеМаркируемойПродукции = Новый ТаблицаЗначений();
	ТаблицаНеМаркируемойПродукции.Колонки.Добавить("АлкогольнаяПродукция",  Новый ОписаниеТипов("СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС"));	
	ТаблицаНеМаркируемойПродукции.Колонки.Добавить("Справка2",              Новый ОписаниеТипов("СправочникСсылка.Справки2ЕГАИС"));	
	ТаблицаНеМаркируемойПродукции.Колонки.Добавить("КоличествоПоДокументу", Новый ОписаниеТипов("Число"));
	ТаблицаНеМаркируемойПродукции.Колонки.Добавить("КоличествоФактическое", Новый ОписаниеТипов("Число"));
	
	Возврат ТаблицаНеМаркируемойПродукции;
	
КонецФункции

Функция Справки2СопоставленнаяНоменклатура()

	Справки2СопоставленнаяНоменклатура = Новый ТаблицаЗначений();
	Справки2СопоставленнаяНоменклатура.Колонки.Добавить("Справка2",       Новый ОписаниеТипов("СправочникСсылка.Справки2ЕГАИС"));	
	Справки2СопоставленнаяНоменклатура.Колонки.Добавить("Номенклатура",   Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	Справки2СопоставленнаяНоменклатура.Колонки.Добавить("Характеристика", Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	
	Возврат Справки2СопоставленнаяНоменклатура;
	
КонецФункции

Функция ТаблицаШтрихкодовНеМаркируемойПродукции()

	ТаблицаШтрихкодовНеМаркируемойПродукции = Новый ТаблицаЗначений();
	ТаблицаШтрихкодовНеМаркируемойПродукции.Колонки.Добавить("Штрихкод",             Новый ОписаниеТипов("Строка"));	
	ТаблицаШтрихкодовНеМаркируемойПродукции.Колонки.Добавить("АлкогольнаяПродукция", Новый ОписаниеТипов("СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС"));	
	ТаблицаШтрихкодовНеМаркируемойПродукции.Колонки.Добавить("Коэффициент",          Новый ОписаниеТипов("Число"));	
	
	Возврат ТаблицаШтрихкодовНеМаркируемойПродукции;
	
КонецФункции

Функция КоличествоСтрокДереваЗначений(ДеревоЗначений)
	
	СтрокиДерева    = ДеревоЗначений.Строки;
	КоличествоСтрок = СтрокиДерева.Количество();
	
	Для Каждого ПодчиненнаяСтрока Из СтрокиДерева Цикл
		КоличествоСтрок = КоличествоСтрок + КоличествоСтрокДереваЗначений(ПодчиненнаяСтрока);
	КонецЦикла;
	
	Возврат КоличествоСтрок;
	
КонецФункции

#КонецОбласти

#КонецЕсли	