#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Ценник") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"Ценник", "Ценник", 
			СформироватьПечатнуюФорму(МассивОбъектов, ПараметрыПечати, ОбъектыПечати));
	КонецЕсли;
		
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Этикетка") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"Этикетка", "Этикетка", 
			СформироватьПечатнуюФорму(МассивОбъектов, ПараметрыПечати, ОбъектыПечати));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция СформироватьПечатнуюФорму(МассивОбъектов, ПараметрыПечати, ОбъектыПечати)
	Перем СодержимоеXMLФайла, СообщениеОбОшибке;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПечатьЭтикеток";
	АвтоМасштаб = ТабличныйДокумент.АвтоМасштаб;
	
	ТабличныйДокумент.АвтоМасштаб = Ложь;
	
	ПервыйМакет = Истина;
	
	Разрешение = ПараметрыПечати.Разрешение;
	
	Если МенеджерОборудованияВызовСервера.ПолучитьОписаниеМакета(ПараметрыПечати.XMLОписаниеМакета, СообщениеОбОшибке, СодержимоеXMLФайла) Тогда
		
		ШиринаЭтикетки = СодержимоеXMLФайла.Ширина;
		ВысотаЭтикетки = СодержимоеXMLФайла.Высота;
		
		Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная,1); 
		
		ТаблицаНоменклатуры = НоменклатураДляПечатиЦенников(МассивОбъектов);
		СписокНоменклатуры  = ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаНоменклатуры,"НоменклатураСсылка", Истина);
		
		ДанныеЭтикеток = ДанныеДляПечатиЭтикеток(ТаблицаНоменклатуры, ПараметрыПечати.АдресХранилищаСКД, ПараметрыПечати.XMLОписаниеМакета, ПараметрыПечати.ТипЦен);
		
		Для каждого ДанныеЭтикетки Из ДанныеЭтикеток.ДанныеДляПечатиЭтикеток Цикл
			
			МакетЭтикетки = ЗаполнитьТабличныйДокумент(Разрешение, ДанныеЭтикетки).ПолучитьОбласть(1, 1, ВысотаЭтикетки+1, ШиринаЭтикетки+1);
			
			МакетЭтикетки.Область().АвтоВысотаСтроки = Ложь;
			МакетЭтикетки.Область().ВысотаСтроки =  Разрешение.ОдинМиллиметрВысоты;
			МакетЭтикетки.Область().ШиринаКолонки = Разрешение.ОдинМиллиметрШирины;
			
			МакетЭтикетки.Область(2,2,ВысотаЭтикетки, ШиринаЭтикетки).Обвести(Линия, Линия, Линия, Линия);
			
			Для Счетчик = 1 По ПараметрыПечати.Количество * ДанныеЭтикетки.Количество Цикл
				
				Попытка
					МожноПрисоединить = ТабличныйДокумент.ПроверитьПрисоединение(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(МакетЭтикетки));
				Исключение
					// Если принтер не установлен печатаем все в столбец
					МожноПрисоединить = Ложь;
				КонецПопытки;
				
				Если МожноПрисоединить Тогда
					ТабличныйДокумент.Присоединить(МакетЭтикетки);
				Иначе
					
					МожноВывести = ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(МакетЭтикетки), Ложь);
					
					Если НЕ МожноВывести И НЕ ПервыйМакет Тогда 
						ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					КонецЕсли;
					
					ПервыйМакет = Ложь;
					
					ТабличныйДокумент.Вывести(МакетЭтикетки);
					
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 1, ОбъектыПечати, МассивОбъектов[0]);
		
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
	КонецЕсли;
	
	ТабличныйДокумент.АвтоМасштаб = АвтоМасштаб;
	
	Возврат ТабличныйДокумент;
КонецФункции

Функция ДанныеДляПечатиЭтикеток(СписокНоменклатуры, АдресХранилищаСКД, XMLОписаниеМакета, ТипЦен) Экспорт
	Перем СодержимоеXMLФайла, СообщениеОбОшибке, ЗначениеРеквизита;
	
	РезультатВыполнения = Новый Структура;
	РезультатВыполнения.Вставить("Успешно", Истина);
	РезультатВыполнения.Вставить("СообщениеОбОшибке");
	РезультатВыполнения.Вставить("ДанныеДляПечатиЭтикеток", Новый Массив);
	
	Если НЕ ЗначениеЗаполнено(АдресХранилищаСКД) ИЛИ НЕ ЗначениеЗаполнено(XMLОписаниеМакета) Тогда
		РезультатВыполнения.Вставить("Успешно", Ложь);
		РезультатВыполнения.Вставить("СообщениеОбОшибке", НСтр("ru = 'Необходимо настроить шаблон этикетки.'"));
		Возврат РезультатВыполнения;
	КонецЕсли; 
	
	Если НЕ МенеджерОборудованияВызовСервера.ПолучитьОписаниеМакета(XMLОписаниеМакета, СообщениеОбОшибке, СодержимоеXMLФайла) Тогда
		РезультатВыполнения.Вставить("Успешно", Ложь);
		РезультатВыполнения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
		Возврат РезультатВыполнения;
	КонецЕсли; 
	
	СписокПолейМакета = Обработки.ПечатьЭтикеток.СписокПолейМакета(СодержимоеXMLФайла);
	
	РезультатВыполненияЗапроса = ПолучитьРезультатВыполненияЗапроса(АдресХранилищаСКД, СписокНоменклатуры, СписокПолейМакета, ТипЦен);
	
	Если РезультатВыполненияЗапроса.Количество() = 0 Тогда
		РезультатВыполнения.Вставить("Успешно", Ложь);
		РезультатВыполнения.Вставить("СообщениеОбОшибке", НСТр("ru = 'Не удалось получить данные для печати этикетки.'"));
		Возврат РезультатВыполнения;
	КонецЕсли; 
	
	Для каждого ЭлементНоменклатуры Из СписокНоменклатуры Цикл
		ДанныеЭтикетки = НовыйДанныеЭтикетки();
		ДанныеЭтикетки.Количество = ЭлементНоменклатуры.Количество;
		Для каждого ПолеМакета Из СписокПолейМакета Цикл
			Если ПолеМакета.Тип = "UserData" Тогда
				Продолжить;
			КонецЕсли;
			
			Реквизиты = РезультатВыполненияЗапроса[ЭлементНоменклатуры.НоменклатураСсылка];
			
			ЗначенияПолей = Новый Структура;
			ЗначенияПолей.Вставить("ИмяПоля",          ПолеМакета.Наименование);
			ЗначенияПолей.Вставить("ОписаниеПоля",     ПолеМакета);
			
			КлючЗначенияРеквизита = "_"+СтрЗаменить(ПолеМакета.Наименование, "-", "");
			
			Если НЕ (ПолеМакета.Тип = "Barcode" ИЛИ ПолеМакета.ТипЗаполнения = "Parameter")
				ИЛИ НЕ ЗначениеЗаполнено(ПолеМакета.Значение) 
				ИЛИ НЕ Реквизиты.Свойство(КлючЗначенияРеквизита, ЗначениеРеквизита) Тогда
				
				ЗначениеРеквизита = "";
			КонецЕсли; 
			
			Если ПолеМакета.Тип = "Barcode" Тогда
				Если НЕ ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
					ЗначенияПолей.Вставить("Значение", РегистрыСведений.ШтрихкодыНоменклатуры.СформироватьШтрихкодEAN13(ЭлементНоменклатуры.НоменклатураСсылка));
				Иначе
					ЗначенияПолей.Вставить("Значение", ЗначениеРеквизита);
				КонецЕсли;
			ИначеЕсли ПолеМакета.ТипЗаполнения = "Parameter" Тогда
				Если ТипЗнч(ЗначениеРеквизита) = Тип("ХранилищеЗначения") Тогда
					ЗначениеРеквизита = ЗначениеРеквизита.Получить();
					
					Если ТипЗнч(ЗначениеРеквизита) = Тип("ДвоичныеДанные") Тогда
						ЗначениеРеквизита = Base64Строка(ЗначениеРеквизита);
					Иначе
						ЗначениеРеквизита = Строка(ЗначениеРеквизита);
					КонецЕсли;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
					ЗначенияПолей.Вставить("Значение", ?(ЗначениеЗаполнено(ПолеМакета.Формат), Формат(ЗначениеРеквизита, ПолеМакета.Формат), ЗначениеРеквизита));
				Иначе
					Если ЗначениеЗаполнено(ПолеМакета.ЗначениеПоУмолчанию) Тогда
						ЗначенияПолей.Вставить("Значение", ?(ЗначениеЗаполнено(ПолеМакета.Формат), Формат(ПолеМакета.ЗначениеПоУмолчанию, ПолеМакета.Формат), ПолеМакета.ЗначениеПоУмолчанию));
					Иначе
						ЗначенияПолей.Вставить("Значение", ?(ЗначениеЗаполнено(ПолеМакета.Формат), Формат("", ПолеМакета.Формат), ""));
					КонецЕсли;
				КонецЕсли;
			Иначе
				ЗначенияПолей.Вставить("Значение", ПолеМакета.Значение);
			КонецЕсли;
			
			ДанныеЭтикетки.Поля.Добавить(ЗначенияПолей);
		КонецЦикла;
		РезультатВыполнения.ДанныеДляПечатиЭтикеток.Добавить(ДанныеЭтикетки);
	КонецЦикла;
	
	Возврат РезультатВыполнения;
КонецФункции 

Функция НовыйДанныеЭтикетки()

	ДанныеЭтикетки = Новый Структура;
	ДанныеЭтикетки.Вставить("Количество", 1);
	ДанныеЭтикетки.Вставить("Поля", Новый Массив);
	
	Возврат ДанныеЭтикетки;

КонецФункции 

Функция ПараметрыШтрихкода(Штрихкод, ТипКодаСтрокой) 
	ПараметрыШтрихкода = Новый Структура;
	
	Если ТипКодаСтрокой = "EAN8" Тогда
		ПараметрыШтрихкода.Вставить("ТипКода", 0);
	ИначеЕсли ТипКодаСтрокой = "EAN13" Тогда
		ПараметрыШтрихкода.Вставить("ТипКода", 1);
		// Если код содержит контрольный символ, обязательно указываем.
		ПараметрыШтрихкода.Вставить("СодержитКС", СтрДлина(Штрихкод) = 13);
	ИначеЕсли ТипКодаСтрокой = "EAN128" Тогда
		ПараметрыШтрихкода.Вставить("ТипКода", 2);
	ИначеЕсли ТипКодаСтрокой = "CODE39" Тогда
		ПараметрыШтрихкода.Вставить("ТипКода", 3);
	ИначеЕсли ТипКодаСтрокой = "CODE128" Тогда
		ПараметрыШтрихкода.Вставить("ТипКода", 4);
	ИначеЕсли ТипКодаСтрокой = "ITF14" Тогда
		ПараметрыШтрихкода.Вставить("ТипКода", 11);
	ИначеЕсли ТипКодаСтрокой = "QR" Тогда
		ПараметрыШтрихкода.Вставить("ТипКода", 16);
	ИначеЕсли ТипКодаСтрокой = "EAN13Addon2" Тогда
		ПараметрыШтрихкода.Вставить("ТипКода", 14);
	ИначеЕсли ТипКодаСтрокой = "EAN13Addon5" Тогда
		ПараметрыШтрихкода.Вставить("ТипКода", 15);
	КонецЕсли;
	
	Возврат ПараметрыШтрихкода;
КонецФункции

Функция ЗаполнитьТабличныйДокумент(Разрешение, ДанныеЭтикетки) Экспорт
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Если ДанныеЭтикетки.Количество()>0 Тогда
		ЗначенияПолей = Новый Структура;
		
		Для Каждого Поле Из ДанныеЭтикетки.Поля Цикл
			
			ИмяПоля      = "П"+СтрЗаменить(Поле.ИмяПоля, "-", "");
			ОписаниеПоля = Поле.ОписаниеПоля;
			ЗначениеПоля = Поле.Значение;
			
			Если ОписаниеПоля.Тип = "UserData" Тогда
				Продолжить;
			КонецЕсли;
			
			ОбластьТабличногоДокумента = СохранитьОформлениеПоля(ИмяПоля, ОписаниеПоля, ТабличныйДокумент);
			
			Если ОписаниеПоля.Тип = "Barcode" Тогда
				ШиринаОбласти = (ОписаниеПоля.Право - ОписаниеПоля.Лево)/Разрешение.КоличествоМиллиметровВПикселеШирина;
				ВысотаОбласти = (ОписаниеПоля.Низ - ОписаниеПоля.Верх)/Разрешение.КоличествоМиллиметровВПикселеВысота;
				
				ПараметрыШтрихкода = Новый Структура;
				ПараметрыШтрихкода.Вставить("Ширина",          ШиринаОбласти);
				ПараметрыШтрихкода.Вставить("Высота",          ВысотаОбласти);
				ПараметрыШтрихкода.Вставить("Штрихкод",        ЗначениеПоля);
				// Значение по умолчанию переопределяется функцией ПараметрыШтрихкода()
				ПараметрыШтрихкода.Вставить("ТипКода",         99);
				
				ЗаполнитьЗначенияСвойств(ПараметрыШтрихкода, ПараметрыШтрихкода(ЗначениеПоля, ОписаниеПоля.ТипШтрихкода));
				
				ПараметрыШтрихкода.Вставить("ОтображатьТекст", ОписаниеПоля.ПодписьШтрихкода = "true");
				Если ОписаниеПоля.ПодписьШтрихкода = "true" И ЗначениеЗаполнено(ОписаниеПоля.РазмерШрифтаПодписи) Тогда
					ПараметрыШтрихкода.Вставить("РазмерШрифта" , ОписаниеПоля.РазмерШрифтаПодписи);
				КонецЕсли; 
				Если ЗначениеЗаполнено(ОписаниеПоля.Ориентация) Тогда
					ПараметрыШтрихкода.Вставить("УголПоворота" , ОписаниеПоля.Ориентация);// Одно из следующих значений: 0, 90, 180, 270.
				Иначе
					ПараметрыШтрихкода.Вставить("УголПоворота" , 0);
				КонецЕсли; 
				ПараметрыШтрихкода.Вставить("ПрозрачныйФон", Истина);
				
				Если ОписаниеПоля.Свойство("УровеньКоррекцииQR") Тогда
					ПараметрыШтрихкода.Вставить("УровеньКоррекцииQR", ОписаниеПоля.УровеньКоррекцииQR);
				Иначе
					ПараметрыШтрихкода.Вставить("УровеньКоррекцииQR", 0);
				КонецЕсли;
				
				ОбластьТабличногоДокумента.Картинка = МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);
			ИначеЕсли ОписаниеПоля.Тип = "Image" Тогда 
				ДвоичныеДанные = Base64Значение(ОписаниеПоля.Значение);
				
				ОбластьТабличногоДокумента.Картинка = Новый Картинка(ДвоичныеДанные, Истина);
			ИначеЕсли ОписаниеПоля.ТипЗаполнения = "Parameter" Тогда
				Если ТипЗнч(ЗначениеПоля) = Тип("ХранилищеЗначения") Тогда
					ЗначениеПоля = ЗначениеПоля.Получить();
					
					Если ТипЗнч(ЗначениеПоля) = Тип("ДвоичныеДанные") Тогда
						ЗначениеПоля = Base64Строка(ЗначениеПоля);
					Иначе
						ЗначениеПоля = Строка(ЗначениеПоля);
					КонецЕсли;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(ЗначениеПоля) Тогда
					ЗначенияПолей.Вставить(ИмяПоля, ?(ЗначениеЗаполнено(ОписаниеПоля.Формат), Формат(ЗначениеПоля, ОписаниеПоля.Формат), ЗначениеПоля));
				Иначе
					Если ЗначениеЗаполнено(ОписаниеПоля.ЗначениеПоУмолчанию) Тогда
						ЗначенияПолей.Вставить(ИмяПоля, ?(ЗначениеЗаполнено(ОписаниеПоля.Формат), Формат(ОписаниеПоля.ЗначениеПоУмолчанию, ОписаниеПоля.Формат), ОписаниеПоля.ЗначениеПоУмолчанию));
					Иначе
						ЗначенияПолей.Вставить(ИмяПоля, ?(ЗначениеЗаполнено(ОписаниеПоля.Формат), Формат("", ОписаниеПоля.Формат), ""));
					КонецЕсли;
				КонецЕсли;
			Иначе
				ЗначенияПолей.Вставить(ИмяПоля, ОписаниеПоля.Значение);
			КонецЕсли;
		КонецЦикла;
		
		ТабличныйДокумент.Параметры.Заполнить(ЗначенияПолей);
	КонецЕсли;
	
	Возврат ТабличныйДокумент;
КонецФункции

Функция СохранитьОформлениеПоля(ИмяПоля, ОписаниеПоля, ТабличныйДокумент) Экспорт
	
	Если ОписаниеПоля.Тип = "Text" ИЛИ  ОписаниеПоля.Тип = "Image" Тогда
		
		Область = ТабличныйДокумент.Область(ОписаниеПоля.Верх+1,ОписаниеПоля.Лево+1, ОписаниеПоля.Низ+1, ОписаниеПоля.Право+1);
		Область.Объединить();
		
		Область.Имя = ИмяПоля;
		
		Если ОписаниеПоля.ТипЗаполнения = "Constant" Тогда
			Область.Заполнение=ТипЗаполненияОбластиТабличногоДокумента.Текст;
			Область.Текст = ОписаниеПоля.Значение;
		Иначе
			Область.Заполнение=ТипЗаполненияОбластиТабличногоДокумента.Параметр;
			Область.Параметр = ИмяПоля;
		КонецЕсли;
		
		Если ОписаниеПоля.Многострочность Тогда
			Область.РазмещениеТекста=ТипРазмещенияТекстаТабличногоДокумента.Переносить;
		Иначе
			Область.РазмещениеТекста=ТипРазмещенияТекстаТабличногоДокумента.Обрезать;
		КонецЕсли;
		
		Область.ОриентацияТекста = ОписаниеПоля.Ориентация;
		
		Если ОписаниеПоля.ПоложениеПоГоризонтали = "Left" Тогда
			Область.ГоризонтальноеПоложение=ГоризонтальноеПоложение.Лево;
		ИначеЕсли ОписаниеПоля.ПоложениеПоГоризонтали = "Center" Тогда
			Область.ГоризонтальноеПоложение=ГоризонтальноеПоложение.Центр;
		ИначеЕсли ОписаниеПоля.ПоложениеПоГоризонтали = "Right" Тогда
			Область.ГоризонтальноеПоложение=ГоризонтальноеПоложение.Право;
		Иначе
			Область.ГоризонтальноеПоложение=ГоризонтальноеПоложение.Лево;
		КонецЕсли;
		
		Если ОписаниеПоля.ПоложениеПоВертикали = "Top" Тогда
			Область.ВертикальноеПоложение=ВертикальноеПоложение.Верх;
		ИначеЕсли ОписаниеПоля.ПоложениеПоВертикали = "Center" Тогда
			Область.ВертикальноеПоложение=ВертикальноеПоложение.Центр;
		ИначеЕсли ОписаниеПоля.ПоложениеПоВертикали = "Bottom" Тогда
			Область.ВертикальноеПоложение=ВертикальноеПоложение.Низ;
		Иначе
			Область.ВертикальноеПоложение=ВертикальноеПоложение.Верх;
		КонецЕсли;
		
		Область.Шрифт = Новый Шрифт(ОписаниеПоля.ИмяШрифта,ОписаниеПоля.РазмерШрифта, ОписаниеПоля.Жирный, ОписаниеПоля.Наклонный, ОписаниеПоля.Подчеркивание, ОписаниеПоля.Зачеркивание);
		
		Если ОписаниеПоля.ТипРамки = "Solid" Тогда
			ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.Сплошная;
		ИначеЕсли ОписаниеПоля.ТипРамки = "Double" Тогда
			ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.Двойная;
		ИначеЕсли ОписаниеПоля.ТипРамки = "Dotted" Тогда
			ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.Точечная;
		ИначеЕсли ОписаниеПоля.ТипРамки = "Dashed" Тогда
			ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.БольшойПунктир;
		Иначе
			ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.НетЛинии;
		КонецЕсли;
		
		Рамка = Новый Линия(ТипЛинии, ОписаниеПоля.ТолщинаРамки);
		
		Если ОписаниеПоля.РамкаСлева Тогда
			Область.ГраницаСлева=Рамка;
		Иначе
			Область.ГраницаСлева=Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, 0);
		КонецЕсли;
		
		Если ОписаниеПоля.РамкаСправа Тогда
			Область.ГраницаСправа=Рамка;
		Иначе
			Область.ГраницаСправа=Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, 0);
		КонецЕсли;
		
		Если ОписаниеПоля.РамкаСверху Тогда
			Область.ГраницаСверху=Рамка;
		Иначе
			Область.ГраницаСверху=Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, 0);
		КонецЕсли;
		
		Если ОписаниеПоля.РамкаСнизу Тогда
			Область.ГраницаСнизу=Рамка;
		Иначе
			Область.ГраницаСнизу=Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, 0);
		КонецЕсли;
		
	ИначеЕсли ОписаниеПоля.Тип = "Barcode" Тогда
		РасположениеКартинки = ТабличныйДокумент.Область(ОписаниеПоля.Верх + 1, ОписаниеПоля.Лево + 1, ОписаниеПоля.Низ+1, ОписаниеПоля.Право+1);
		
		Область = ТабличныйДокумент.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
		
		Область.Расположить(РасположениеКартинки);
		Область.РазмерКартинки = РазмерКартинки.Пропорционально;
		Область.ГраницаСлева   = ОписаниеПоля.РамкаСлева;
		Область.ГраницаСправа  = ОписаниеПоля.РамкаСправа;
		Область.ГраницаСверху  = ОписаниеПоля.РамкаСверху;
		Область.ГраницаСнизу   = ОписаниеПоля.РамкаСнизу;
		
	КонецЕсли;
	
	Возврат Область;
КонецФункции

Функция ПолеДоступно(Структура, ПолноеИмяПоля, ИмяПоля = Неопределено)
	ИмяПоля = ?(ИмяПоля = Неопределено, ПолноеИмяПоля, ИмяПоля);
	
	ПоложениеТочки = Найти(ИмяПоля, ".");
	Если Структура.Элементы.Найти(ПолноеИмяПоля) <> Неопределено Тогда
		Возврат Истина;
	ИначеЕсли ПоложениеТочки > 0 Тогда
		// Возможно поле находится на уровень ниже
		Родитель = Лев(ПолноеИмяПоля, (СтрДлина(ПолноеИмяПоля) - СтрДлина(ИмяПоля)) + ПоложениеТочки - 1);
		ЭлементСписка = Структура.Элементы.Найти(Родитель);
		Если ЭлементСписка <> Неопределено Тогда
			Возврат ПолеДоступно(ЭлементСписка, ПолноеИмяПоля, Сред(ИмяПоля, ПоложениеТочки +1));
		Иначе
			Возврат Ложь;
		КонецЕсли; 
	Иначе
		Возврат Ложь;
	КонецЕсли; 
КонецФункции

Функция СведенияОбОрганизациях(ТаблицаОрганизации)
	ТаблицаСведений = Новый ТаблицаЗначений;
	ТаблицаСведений.Колонки.Добавить("Организация");
	ТаблицаСведений.Колонки.Добавить("ДатаПолученияДанных");
	ТаблицаСведений.Колонки.Добавить("СокращенноеНаименование");
	ТаблицаСведений.Колонки.Добавить("ПолноеНаименование");
	ТаблицаСведений.Колонки.Добавить("НаименованиеДляПечатныхФорм");
	
	ОбщегоНазначенияКлиентСервер.ЗаполнитьКоллекциюСвойств(ТаблицаОрганизации, ТаблицаСведений);
	
	Для каждого СтрокаТаблицы Из ТаблицаСведений Цикл
		НаименованияНаДату = Справочники.Организации.НаименованияНаДату(СтрокаТаблицы.Организация, СтрокаТаблицы.ДатаПолученияДанных);
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, НаименованияНаДату);
	КонецЦикла;
	
	Возврат ТаблицаСведений;
КонецФункции
 

Функция ПолучитьРезультатВыполненияЗапроса(АдресХранилищаСКД, ТаблицаНоменклатура, СписокПолей, ТипЦен)
	СКД = ПолучитьИзВременногоХранилища(АдресХранилищаСКД);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД));
	Компоновщик.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
	
	Настройки = Компоновщик.Настройки;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Настройки, "ТипЦен", ТипЦен);
	
	ПсевдонимыПолей = Новый Соответствие;
	Для каждого Поле Из СписокПолей Цикл
		Если ЗначениеЗаполнено(Поле.Значение) Тогда
			Если ПолеДоступно(Настройки.Структура[0].Выбор.ДоступныеПоляВыбора, Поле.Значение) Тогда
				НаименованиеПоля = "_"+СтрЗаменить(Поле.Наименование, "-", "");
				ПсевдонимыПолей.Вставить(НаименованиеПоля, "");
				
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Настройки.Структура[0].Выбор, Поле.Значение, НаименованиеПоля);
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаОрганизации = ТаблицаНоменклатура.Скопировать(,"Организация, ДатаПолученияДанных");
	ТаблицаОрганизации.Свернуть("Организация, ДатаПолученияДанных");
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТаблицаНоменклатура", ТаблицаНоменклатура);
	ВнешниеНаборыДанных.Вставить("ТаблицаОрганизации",  СведенияОбОрганизациях(ТаблицаОрганизации));
	
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	ПКД = Новый ПроцессорКомпоновкиДанных;
	ПКД.Инициализировать(КомпоновщикМакета.Выполнить(СКД, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений")), ВнешниеНаборыДанных);
	
	ТаблицаРезультата = Новый ТаблицаЗначений;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаРезультата);
	ПроцессорВывода.Вывести(ПКД);
	
	Для каждого Колонка Из ТаблицаРезультата.Колонки Цикл
		Если ПсевдонимыПолей[Колонка.Заголовок] <> Неопределено Тогда
			ПсевдонимыПолей.Вставить(Колонка.Заголовок, Колонка.Имя);
		КонецЕсли; 
	КонецЦикла; 
	
	Соотвествие = Новый Соответствие;
	Для каждого Строка Из ТаблицаРезультата Цикл
		СтруктураРезультата = Новый Структура;
		Для каждого ОписаниеПоля Из ПсевдонимыПолей Цикл
			Если ЗначениеЗаполнено(ОписаниеПоля.Значение) Тогда
				СтруктураРезультата.Вставить(ОписаниеПоля.Ключ, Строка[ОписаниеПоля.Значение]);
			КонецЕсли; 
		КонецЦикла; 
		
		Соотвествие.Вставить(Строка.НоменклатураСсылка, СтруктураРезультата);
	КонецЦикла; 

	Возврат Соотвествие;
КонецФункции

Функция НоменклатураДляПечатиЦенников(СписокОбъектов) Экспорт
	Запрос = Новый Запрос;
	
	ЧастиЗапроса = Новый Массив;
	
	Для каждого СписокОбъектовПоТипу Из ОбщегоНазначенияБП.РазложитьСписокПоТипамОбъектов(СписокОбъектов) Цикл
		Если СписокОбъектовПоТипу.Ключ = Метаданные.Справочники.Номенклатура Тогда
			
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	&ТекущаяОрганизация КАК Организация,
			|	&РабочаяДата КАК ДатаПолученияДанных,
			|	Номенклатура.Ссылка КАК НоменклатураСсылка,
			|	&ВалютаРегламентированногоУчета КАК Валюта,
			|	1 КАК Количество
			|ИЗ
			|	Справочник.Номенклатура КАК Номенклатура
			|ГДЕ
			|	Номенклатура.Ссылка В(&СписокОбъектов)";
		ИначеЕсли СписокОбъектовПоТипу.Ключ = Метаданные.Документы.УстановкаЦенНоменклатуры Тогда 
			
			ТекстЗапроса = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	&ТекущаяОрганизация КАК Организация,
			|	УстановкаЦенНоменклатурыТовары.Ссылка.Дата КАК ДатаПолученияДанных,
			|	УстановкаЦенНоменклатурыТовары.Номенклатура КАК НоменклатураСсылка,
			|	УстановкаЦенНоменклатурыТовары.Валюта КАК Валюта,
			|	1 КАК Количество
			|ИЗ
			|	Документ.УстановкаЦенНоменклатуры.Товары КАК УстановкаЦенНоменклатурыТовары
			|ГДЕ
			|	УстановкаЦенНоменклатурыТовары.Ссылка В(&СписокОбъектов)";
		ИначеЕсли СписокОбъектовПоТипу.Ключ = Метаданные.Документы.ПоступлениеТоваровУслуг Тогда 
			
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	ПоступлениеТоваровУслугТовары.Ссылка.Организация КАК Организация,
			|	ПоступлениеТоваровУслугТовары.Ссылка.Дата КАК ДатаПолученияДанных,
			|	ПоступлениеТоваровУслугТовары.Номенклатура КАК НоменклатураСсылка,
			|	ПоступлениеТоваровУслугТовары.Ссылка.ВалютаДокумента КАК Валюта,
			|	СУММА(ПоступлениеТоваровУслугТовары.Количество) КАК Количество
			|ИЗ
			|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
			|ГДЕ
			|	ПоступлениеТоваровУслугТовары.Ссылка В(&СписокОбъектов)
			|
			|СГРУППИРОВАТЬ ПО
			|	ПоступлениеТоваровУслугТовары.Ссылка.Организация,
			|	ПоступлениеТоваровУслугТовары.Ссылка.Дата,
			|	ПоступлениеТоваровУслугТовары.Номенклатура,
			|	ПоступлениеТоваровУслугТовары.Ссылка.ВалютаДокумента";
		Иначе
			Продолжить;
		КонецЕсли;
		
		ИмяПеременной = "СписокОбъектов"+Формат(ЧастиЗапроса.Количество(), "ЧГ=0");
		
		Запрос.УстановитьПараметр(ИмяПеременной, СписокОбъектовПоТипу.Значение);
		ЧастиЗапроса.Добавить(СтрЗаменить(ТекстЗапроса, "СписокОбъектов", ИмяПеременной));
	КонецЦикла; 
	
	Если ЧастиЗапроса.Количество() = 0 Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли; 
	
	Запрос.УстановитьПараметр("РабочаяДата",                    ОбщегоНазначения.ТекущаяДатаПользователя());
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	Запрос.УстановитьПараметр("ТекущаяОрганизация",             Справочники.Организации.ОрганизацияПоУмолчанию());
	
	Запрос.Текст = СтрСоединить(ЧастиЗапроса, Символы.ПС+"ОБЪЕДИНИТЬ"+Символы.ПС);
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции 

Функция НовыйОписаниеПоля()
	Результат = Новый Структура;
	
	Результат.Вставить("Наименование",           "");
	Результат.Вставить("Представление",          "");
	Результат.Вставить("Тип",                    "");
	Результат.Вставить("ТипЗаполнения");
	Результат.Вставить("ЗначениеПоУмолчанию");
	Результат.Вставить("Значение");
	Результат.Вставить("Верх",                   0);
	Результат.Вставить("Лево",                   0);
	Результат.Вставить("Низ",                    0);
	Результат.Вставить("Право",                  0);
	Результат.Вставить("Ориентация");
	Результат.Вставить("ИмяШрифта");
	Результат.Вставить("РазмерШрифта");
	Результат.Вставить("Жирный",                 Ложь);
	Результат.Вставить("Наклонный",              Ложь);
	Результат.Вставить("Подчеркивание",          Ложь);
	Результат.Вставить("Зачеркивание",           Ложь);
	Результат.Вставить("РамкаСлева",             Ложь);
	Результат.Вставить("РамкаСверху",            Ложь);
	Результат.Вставить("РамкаСправа",            Ложь);
	Результат.Вставить("РамкаСнизу",             Ложь);
	Результат.Вставить("ТипРамки");
	Результат.Вставить("ТолщинаРамки");
	Результат.Вставить("ТипШтрихкода");
	Результат.Вставить("РазмерШрифтаПодписи");
	Результат.Вставить("ПодписьШтрихкода");
	Результат.Вставить("КонтрольныйСимвол");
	Результат.Вставить("ПоложениеПоГоризонтали", "Left");
	Результат.Вставить("ПоложениеПоВертикали",   "Top");
	Результат.Вставить("Многострочность",        Ложь);
	Результат.Вставить("Формат");
	
	Возврат Результат;
КонецФункции 

Функция СписокПолейМакета(СодержимоеXMLФайла) Экспорт
	ОписаниеПолей = Новый Массив;
	
	Для Каждого ОписаниеПоляXML Из СодержимоеXMLФайла.Поля Цикл
		ОписаниеПоля = НовыйОписаниеПоля();
		
		ЗаполнитьЗначенияСвойств(ОписаниеПоля, ОписаниеПоляXML);
		
		ОписаниеПолей.Добавить(ОписаниеПоля);
	КонецЦикла;
	
	Возврат ОписаниеПолей;
КонецФункции 

#КонецОбласти 


#КонецЕсли