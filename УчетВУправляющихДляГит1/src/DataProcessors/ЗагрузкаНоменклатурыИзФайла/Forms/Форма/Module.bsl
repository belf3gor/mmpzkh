
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	АдресФайла = Параметры.АдресФайла;
	РасширениеФайла = Параметры.РасширениеФайла;
	
	Если Не ЗначениеЗаполнено(АдресФайла) Или Не ЭтоАдресВременногоХранилища(АдресФайла) Тогда
		ТекстИсключения = НСтр("ru = 'Не выбран файл для загрузки.
			|Откройте обработку из формы списка номенклатуры с помощью команды ""Загрузить"".'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	// Установка значений реквизитов для новой номенклатуры по умолчанию
	НоменклатурнаяГруппа = ?(ЗначениеЗаполнено(НоменклатурнаяГруппа), НоменклатурнаяГруппа,
		БухгалтерскийУчетВызовСервераПовтИсп.ОсновнаяНоменклатурнаяГруппа());
	ЕдиницаИзмерения     = ?(ЗначениеЗаполнено(ЕдиницаИзмерения), ЕдиницаИзмерения,
		Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("796")); // единица измерения по умолчанию - штука
	СтавкаНДС            = ?(ЗначениеЗаполнено(СтавкаНДС), СтавкаНДС, УчетНДСКлиентСервер.СтавкаНДСПоУмолчанию(ТекущаяДата()));
	ВидНоменклатуры      = ?(ЗначениеЗаполнено(ВидНоменклатуры), ВидНоменклатуры, Справочники.ВидыНоменклатуры.НайтиСоздатьЭлементыТовар());
	ДатаУстановкиЦен     = ТекущаяДатаСеанса();
	
	ОписаниеКолонок.Загрузить(Обработки.ЗагрузкаНоменклатурыИзФайла.ОписаниеЗагружаемыхКолонок());
	
	ИзменитьШаг("Шаг1");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТабличнаяЧастьИзменена = Ложь;
	ПодключитьОбработчикОжидания("Подключаемый_ПодготовитьТабличныйДокумент", 0.1, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ОтборТаблицы = 0;
	Элементы.Товары.ОтборСтрок = Новый ФиксированнаяСтруктура("Статус", Неопределено);
	Для Каждого СтрокаТаблицы Из Объект.Товары Цикл
		
		Если ЕстьКолонкаЕдиницаИзмерения Тогда
			
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.ЕдиницаИзмерения) Тогда
				
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", "Единица");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Товары", СтрокаТаблицы.НомерСтроки, "ЕдиницаИзмерения"),, Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЕстьКолонкаСтавкаНДС Тогда
			
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.СтавкаНДС) Тогда
				
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", "% НДС");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Товары", СтрокаТаблицы.НомерСтроки, "СтавкаНДС"),, Отказ);
			
			КонецЕсли;
			
		КонецЕсли;
				
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Номенклатура) И ПустаяСтрока(СтрокаТаблицы.Наименование) Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", "Номенклатура");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Товары", СтрокаТаблицы.НомерСтроки, "Номенклатура"),, Отказ);
			
		КонецЕсли;
		
		Если СтрокаТаблицы.Статус = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.СтатусДубль() Тогда // обнаружены дубли
			
			ТекстСообщения = НСтр("ru = 'Найдено несколько позиций номенклатуры с совпадающими реквизитами. Двойным кликом выберите одну из списка.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Товары", СтрокаТаблицы.НомерСтроки, "НомерСтроки"),, Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Таблица.Номенклатура,
	               |	Таблица.НомерСтроки
	               |ПОМЕСТИТЬ Таблица
	               |ИЗ
	               |	&Таблица КАК Таблица
	               |ГДЕ
	               |	Таблица.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Таблица.Номенклатура,
	               |	МАКСИМУМ(Таблица.НомерСтроки) КАК НомерСтрокиМакс,
	               |	ПРЕДСТАВЛЕНИЕ(Таблица.Номенклатура) КАК НоменклатураПредставление,
	               |	СУММА(1) КАК Количество,
	               |	МИНИМУМ(Таблица.НомерСтроки) КАК НомерСтрокиМин
	               |ПОМЕСТИТЬ ТаблицаОбработанная
	               |ИЗ
	               |	Таблица КАК Таблица
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Таблица.Номенклатура
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТаблицаОбработанная.НоменклатураПредставление,
	               |	ТаблицаОбработанная.Количество,
	               |	ТаблицаОбработанная.НомерСтрокиМакс,
	               |	ТаблицаОбработанная.НомерСтрокиМин
	               |ИЗ
	               |	ТаблицаОбработанная КАК ТаблицаОбработанная
	               |ГДЕ
	               |	ТаблицаОбработанная.Количество > 1";
	Запрос.УстановитьПараметр("Таблица", Объект.Товары.Выгрузить());
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ШаблонСообщения = НСтр("ru = 'Строка с номенклатурой ""%1"" уже существует в строке %2.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(ШаблонСообщения, Выборка.НоменклатураПредставление, Выборка.НомерСтрокиМин),,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Товары", Выборка.НомерСтрокиМакс, "Номенклатура"),, Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ЗагрузкаНоменклатурыИзФайла.Форма.ФормаВыбораНоменклатуры" Тогда
		
		ТекДанные = Элементы.Товары.ТекущиеДанные;
		Если ТекДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ТекДанные.Номенклатура = ВыбранноеЗначение;
		ТекДанные.Статус = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.СтатусНайденный();
		ЗаполнитьЗначенияСвойств(ТекДанные, ПолучитьДанныеНоменклатуры(ТекДанные.Номенклатура));
		ИзменитьТекстПереключателяОтбора();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипЦенПриИзменении(Элемент)
	
	Валюта = ?(ЗначениеЗаполнено(ТипЦен), ПолучитьВалютуИзТипаЦенСервер(ТипЦен), Неопределено);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьСсылкиУстановкиРеквизитовНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияФормыУстановкиЗначенийРеквизитов", ЭтотОбъект);
	
	ЗначенияРеквизитов = Новый Структура;
	ЗначенияРеквизитов.Вставить("Родитель", Родитель);
	ЗначенияРеквизитов.Вставить("ВидНоменклатуры", ВидНоменклатуры);
	ЗначенияРеквизитов.Вставить("НоменклатурнаяГруппа", НоменклатурнаяГруппа);
	ЗначенияРеквизитов.Вставить("ЕдиницаИзмерения", ЕдиницаИзмерения);
	ЗначенияРеквизитов.Вставить("СтавкаНДС", СтавкаНДС);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЕстьКолонкаЕдиницаИзмерения", ЕстьКолонкаЕдиницаИзмерения);
	ПараметрыФормы.Вставить("ЕстьКолонкаСтавкаНДС", ЕстьКолонкаСтавкаНДС);
	ПараметрыФормы.Вставить("ЗначенияРеквизитов", ЗначенияРеквизитов);
	
	ОткрытьФорму("ОбщаяФорма.ФормаУстановкиЗначенийРеквизитовНоменклатуры", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыУстановкиЗначенийРеквизитов(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено ИЛИ РезультатЗакрытия = КодВозвратаДиалога.Отмена Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РезультатЗакрытия);
	ЗаголовокСсылкиУстановкиРеквизитов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТаблицыПриИзменении(Элемент)
	
	ЗначениеОтбора = 0;
	Если ОтборТаблицы = 0 Тогда
		
		ЗначениеОтбора = Неопределено; // показываем все
		
	ИначеЕсли ОтборТаблицы = 1 Тогда
		
		ЗначениеОтбора = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.СтатусНайденный(); // показываем все найденные
		
	ИначеЕсли ОтборТаблицы = 2 Тогда
		
		ЗначениеОтбора = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.СтатусНовый(); // показываем новые
		
	Иначе
		
		ЗначениеОтбора = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.СтатусДубль(); // показываем дубли
		
	КонецЕсли;
	
	Элементы.Товары.ОтборСтрок = Новый ФиксированнаяСтруктура("Статус", ЗначениеОтбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличногоДокумента

&НаКлиенте
Процедура ДанныеФайлаВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если Область.Верх = 1 И Область.Лево <= ДанныеФайла.ШиринаТаблицы Тогда
		
		ДопПараметрОповещения = Новый Структура("ТекущаяОбласть", Область);
		ОписаниеОповещения = Новый ОписаниеОповещения("ДанныеФайлаВыборЗавершение", ЭтотОбъект, ДопПараметрОповещения);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ОписаниеКолонок", ОписаниеКолонокВоВременномХранилище());
		ОткрытьФорму("ОбщаяФорма.ВыборКолонокПриЗагрузкеИзФайла", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеФайлаВыборЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Или РезультатЗакрытия = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ТекстНезаполненногоЗаголовка = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.ТекстЗаголовкаНесопоставленнойКолонки();
	ВыбранаКолонкаСЦеной = СтрНайти(РезультатЗакрытия.Представление, "Цена") > 0;
	Для НомерКолонки = 1 По ДанныеФайла.ШиринаТаблицы Цикл
		
		Область = ДанныеФайла.Область(1, НомерКолонки);
		Если Область.ПараметрРасшифровки = РезультатЗакрытия.Идентификатор
			Или (ВыбранаКолонкаСЦеной И СтрНайти(Область.Текст, НСтр("ru = 'Цена'")) > 0) Тогда
			Область.Текст = ТекстНезаполненногоЗаголовка;
			Область.ПараметрРасшифровки = "";
			Область.ЦветТекста = ОбщегоНазначенияКлиентПовтИсп.ЦветСтиля("НезаполненныйРеквизит");
		КонецЕсли;
		
	КонецЦикла;
	
	Если ВыбранаКолонкаСЦеной Тогда
		СведенияОТипеЦен = ТипИВалютаЦеныПоИдентификатору(РезультатЗакрытия.Идентификатор);
		ТипЦен = СведенияОТипеЦен.ТипЦен;
		Валюта = СведенияОТипеЦен.Валюта;
	КонецЕсли;
	
	ДополнительныеПараметры.ТекущаяОбласть.Текст      = РезультатЗакрытия.Представление;
	ДополнительныеПараметры.ТекущаяОбласть.ЦветТекста = ОбщегоНазначенияКлиентПовтИсп.ЦветСтиля("ЦветГиперссылки");
	ДополнительныеПараметры.ТекущаяОбласть.ПараметрРасшифровки = РезультатЗакрытия.Идентификатор;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧасти

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	
	ТабличнаяЧастьИзменена = Истина;
	ИзменитьТекстПереключателяОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекДанные.Номенклатура) Тогда
		
		ЗаполнитьЗначенияСвойств(ТекДанные, ПолучитьДанныеНоменклатуры(ТекДанные.Номенклатура));
		ТекДанные.Статус = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.СтатусНайденный();
		ИзменитьТекстПереключателяОтбора();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекДанные.Статус = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.СтатусНовый() Тогда // будет создана новая номенклатура
		
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений;
		ТекстПодбора = НСтр("ru = 'Создать: '") + ТекДанные.Наименование 
			+ ?(ПустаяСтрока(ТекДанные.Артикул), "", ", " + ТекДанные.Артикул)
			+ ?(ЕстьКолонкаЕдиницаИзмерения, 
			?(ПустаяСтрока(ТекДанные.ЕдиницаИзмерения), "", ", " + ТекДанные.ЕдиницаИзмерения), ", " + ЕдиницаИзмерения);
		ДанныеВыбора.Добавить(ТекстПодбора);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") И СтрНайти(ВыбранноеЗначение, НСтр("ru = 'Создать:'")) > 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		ТекДанные = Элементы.Товары.ТекущиеДанные;
		
		ДанныеЗаполнения = Новый Структура;
		ДанныеЗаполнения.Вставить("НаименованиеПолное",		 ТекДанные.НаименованиеПолное);
		ДанныеЗаполнения.Вставить("Артикул",				 ТекДанные.Артикул);
		ДанныеЗаполнения.Вставить("ВидНоменклатуры",		 ВидНоменклатуры);
		ДанныеЗаполнения.Вставить("Родитель",				 Родитель);
		ДанныеЗаполнения.Вставить("НоменклатурнаяГруппа",	 НоменклатурнаяГруппа);
		ДанныеЗаполнения.Вставить("СтавкаНДС",				 ?(ЕстьКолонкаСтавкаНДС, ТекДанные.СтавкаНДС, СтавкаНДС));
		ДанныеЗаполнения.Вставить("ЕдиницаИзмерения",		 ?(ЕстьКолонкаЕдиницаИзмерения, ТекДанные.ЕдиницаИзмерения, ЕдиницаИзмерения));
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ПараметрыФормы.Вставить("ТекстЗаполнения", ТекДанные.Наименование);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ДанныеЗаполнения);
		
		ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", ПараметрыФормы, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекДанные.Статус = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.СтатусДубль()
		И (Элемент.ТекущийЭлемент.Имя = "ТоварыНоменклатура" ИЛИ Элемент.ТекущийЭлемент.Имя = "ТоварыКартинка") Тогда
		
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ОтборДублей", ТекДанные.СписокНоменклатуры);
		ОткрытьФорму("Обработка.ЗагрузкаНоменклатурыИзФайла.Форма.ФормаВыбораНоменклатуры", ПараметрыФормы, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УдалитьСтроку(Команда)
	
	Верх = ДанныеФайла.ТекущаяОбласть.Верх;
	Низ  = ДанныеФайла.ТекущаяОбласть.Низ;
	Лево = ДанныеФайла.ТекущаяОбласть.Лево;
	
	Если Верх = 1 И Низ = 1 Тогда
		
		Возврат; // выделена первая строка (строка заголовка)
		
	КонецЕсли;
	
	УдалитьСтрокиНаСервере(Верх, Низ);
	Элементы.ДанныеФайла.ТекущаяОбласть = ДанныеФайла.Область(Верх, Лево);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьКолонку(Команда)
	
	Лево  = ДанныеФайла.ТекущаяОбласть.Лево;
	Право = ДанныеФайла.ТекущаяОбласть.Право;
	Верх  = ДанныеФайла.ТекущаяОбласть.Верх;
	
	УдалитьКолонкиНаСервере(Лево, Право);
	Элементы.ДанныеФайла.ТекущаяОбласть = ДанныеФайла.Область(Верх, Лево);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЛишнее(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьЛишнееПослеЗакрытияВопроса", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Найти и удалить строки и колонки, не содержащие информацию для загрузки?'");
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	ОчиститьСообщения();
	
	ЗаголовкиЗаполнены = ЗагрузкаДанныхИзВнешнихФайловКлиент.ЗаполненыВсеЗаголовкиКолонок(
		ДанныеФайла, "ДанныеФайла", ОписаниеКолонок);
	
	Если Не ЗаголовкиЗаполнены Тогда
		Возврат;
	КонецЕсли;
	
	ОтборТаблицы = 0;
	Элементы.Товары.ОтборСтрок = Неопределено;
	
	ДлительнаяОперация = ПодготовитьТаблицуТоваровСервер();
	Если ДлительнаяОперация.Статус = "Ошибка" Тогда
		ВызватьИсключение ДлительнаяОперация.КраткоеПредставлениеОшибки;
	Иначе
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		Обработчик = Новый ОписаниеОповещения("ПодготовитьТаблицуДанныхДляЗагрузкиЗавершение", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Если ТабличнаяЧастьИзменена Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВопросаОПереходеНаПервыйШаг", ЭтотОбъект);
		ТекстВопроса = НСтр(
			"ru = 'Все изменения, произведенные вами в таблице, будут потеряны.
				  |
				  |Вернуться на предыдущий шаг?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
		ТабличнаяЧастьИзменена = Ложь;
		
	Иначе
		
		ИзменитьШаг("Шаг1");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	ДлительнаяОперация = ЗагрузитьНаСервере();
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат; // найдены незаполненные обязательные реквизиты
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Ошибка" Тогда
		ВызватьИсключение ДлительнаяОперация.КраткоеПредставлениеОшибки;
	Иначе
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		Обработчик = Новый ОписаниеОповещения("ЗагрузкаДанныхИзФайлаЗавершение", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеФормой

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ТоварыЕдиницаИзмерения.Видимость = Форма.ЕстьКолонкаЕдиницаИзмерения;
	Элементы.ТоварыСтавкаНДС.Видимость = Форма.ЕстьКолонкаСтавкаНДС;
	
	Элементы.Валюта.Видимость = ЗначениеЗаполнено(Форма.ТипЦен) И Не ЗначениеЗаполнено(Форма.Валюта);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьШаг(ТекущийШаг)
	
	Элементы.ГруппаШаг1.Видимость = (ТекущийШаг = "Шаг1");
	Элементы.ГруппаШаг2.Видимость = (ТекущийШаг = "Шаг2");
	Элементы.Далее.КнопкаПоУмолчанию = (ТекущийШаг = "Шаг1");
	Элементы.Загрузить.КнопкаПоУмолчанию = (ТекущийШаг = "Шаг2");
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Серый текст для новой номенклатуры
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыНоменклатура");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Товары.Номенклатура", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Товары.Статус", ВидСравненияКомпоновкиДанных.Равно, ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.СтатусНовый());
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноСерый);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Объект.Товары.Представление"));
	
	// Красный текст для дублей
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыНоменклатура");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Товары.Номенклатура", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Товары.Статус", ВидСравненияКомпоновкиДанных.Равно, ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.СтатусДубль());
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Кирпичный);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Объект.Товары.Представление"));
	
	// Устанавливаем отметку незаполненного, если не заполнены номенклатура и наименование
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыНоменклатура");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Товары.Номенклатура", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Товары.Статус", ВидСравненияКомпоновкиДанных.Равно, ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.СтатусНайденный());
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	// Блокируем для редактирования ставку ндс и единицу измерения, если номенклатура заполнена
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыЕдиницаИзмерения");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыСтавкаНДС");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Товары.Номенклатура", ВидСравненияКомпоновкиДанных.Заполнено);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьТекстПереключателяОтбора()
	
	Статистика = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.СтатистикаСтатусовСтрокТаблицы(Объект.Товары);
	
	СписокВыбора = Элементы.ОтборТаблицы.СписокВыбора;
	СписокВыбора[0].Представление = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.ТекстСКоличеством(НСтр("ru = 'Все'"), Статистика.Всего);
	СписокВыбора[1].Представление = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.ТекстСКоличеством(НСтр("ru = 'Найденные'"), Статистика.Найденные);
	СписокВыбора[2].Представление = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.ТекстСКоличеством(НСтр("ru = 'Новые'"), Статистика.Новые);
	СписокВыбора[3].Представление = ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.ТекстСКоличеством(НСтр("ru = 'Дубли'"), Статистика.Дубли);
	
КонецПроцедуры

&НаСервере
Процедура ЗаголовокСсылкиУстановкиРеквизитов()
	
	СписокРеквизитов = "Родитель,ВидНоменклатуры,НоменклатурнаяГруппа"
		+ ?(ЕстьКолонкаЕдиницаИзмерения, "", ",ЕдиницаИзмерения") + ?(ЕстьКолонкаСтавкаНДС, "", ",СтавкаНДС");
	МассивРеквизитов = СтрРазделить(СписокРеквизитов, ",", Ложь);
	МассивЗначений = Новый Массив;
	Для Каждого ЭлементМассива Из МассивРеквизитов Цикл
		
		ЗначениеРеквизитаСтр = Строка(ЭтотОбъект[ЭлементМассива]);
		Если Не ПустаяСтрока(ЗначениеРеквизитаСтр) Тогда
			
			Если ЭлементМассива = "СтавкаНДС" Тогда
				
				МассивЗначений.Добавить("НДС " + Строка(ЗначениеРеквизитаСтр));
				
			Иначе
			
				МассивЗначений.Добавить(Строка(ЗначениеРеквизитаСтр));
			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	ЗаголовокСсылки = НСтр("ru = 'Реквизиты новой номенклатуры: '");
	ПерваяИтерация = Истина;
	Для Каждого ЭлементМассива Из МассивЗначений Цикл
		
		ЗаголовокСсылки = ЗаголовокСсылки + ?(ПерваяИтерация, "", ", ") + ЭлементМассива;
		ПерваяИтерация = Ложь;
		
	КонецЦикла;
	НадписьСсылкиУстановкиРеквизитов = ЗаголовокСсылки;

КонецПроцедуры

#КонецОбласти

#Область ПодготовкаТабличногоДокумента

&НаКлиенте
Процедура Подключаемый_ПодготовитьТабличныйДокумент()
	
	ДлительнаяОперация = ПодготовитьТабличныйДокументСервер(АдресФайла, РасширениеФайла, УникальныйИдентификатор, ОписаниеКолонок);
	
	Если ДлительнаяОперация.Статус = "Ошибка" Тогда
		ВызватьИсключение ДлительнаяОперация.КраткоеПредставлениеОшибки;
	Иначе
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		Обработчик = Новый ОписаниеОповещения("ПодготовитьТабличныйДокументЗавершение", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодготовитьТабличныйДокументСервер(Знач АдресФайла, Знач РасширениеФайла, Знач ИдентификаторФормы, Знач ОписаниеКолонок)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайла);
	ХранилищеДанных = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9));
	УдалитьИзВременногоХранилища(АдресФайла);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("РасширениеФайла", РасширениеФайла);
	ПараметрыЗадания.Вставить("ХранилищеДанныхФайла", ХранилищеДанных);
	ПараметрыЗадания.Вставить("ОписаниеКолонок", ОписаниеКолонок.Выгрузить());
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Подготовка табличного документа к загрузке номенклатуры.'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.ЗагрузкаНоменклатурыИзФайла.ОбработатьДанныеИзФайла",
		ПараметрыЗадания, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ПодготовитьТабличныйДокументЗавершение(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		ЗаполнитьТабличныйДокументСервер(ДлительнаяОперация.АдресРезультата);
	ИначеЕсли ДлительнаяОперация.Статус = "Ошибка" Тогда
		ВызватьИсключение ДлительнаяОперация.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабличныйДокументСервер(АдресРезультата)
	
	ЗагруженныеДанные = ПолучитьИзВременногоХранилища(АдресРезультата);
	ДанныеФайла = ЗагруженныеДанные.ДанныеФайла.Получить();
	ТипЦен = ЗагруженныеДанные.ТипЦен;
	Валюта = ЗагруженныеДанные.Валюта;
	УдалитьИзВременногоХранилища(АдресРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область УдалениеЛишнихДанных

&НаСервере
Процедура УдалитьСтрокиНаСервере(Верх, Низ)
	
	Если Верх = 1 Тогда
		Верх = 2; // чтобы не удалить заголовки колонок
	КонецЕсли;
	
	Область = ДанныеФайла.Область(Верх,, Низ);
	ДанныеФайла.УдалитьОбласть(Область, ТипСмещенияТабличногоДокумента.ПоВертикали);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьКолонкиНаСервере(Лево, Право)
	
	Область = ДанныеФайла.Область(, Лево,, Право);
	ДанныеФайла.УдалитьОбласть(Область, ТипСмещенияТабличногоДокумента.ПоГоризонтали);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЛишнееПослеЗакрытияВопроса(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ДанныеФайла, "Ожидание");
	
	ОчиститьСообщения();
	
	ДлительнаяОперация = УдалитьЛишнееСервер();
	Если ДлительнаяОперация.Статус = "Ошибка" Тогда
		ВызватьИсключение ДлительнаяОперация.КраткоеПредставлениеОшибки;
	Иначе
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		
		Обработчик = Новый ОписаниеОповещения("УдалитьЛишнееЗавершение", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УдалитьЛишнееСервер()
	
	ПараметрыЗадания = Новый Структура;
	ХранилищеДанных = Новый ХранилищеЗначения(ДанныеФайла, Новый СжатиеДанных(9));
	ПараметрыЗадания.Вставить("ХранилищеДанных", ХранилищеДанных);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Удаление незначимых строк табличного документа.'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.ЗагрузкаНоменклатурыИзФайла.УдалитьВсеНенужныеСтрокиТаблицы",
		ПараметрыЗадания, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура УдалитьЛишнееЗавершение(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		НайденыНенужныеСтроки = Ложь;
		ОбработатьРезультатУдаленияЛишнихСтрок(ДлительнаяОперация.АдресРезультата, НайденыНенужныеСтроки);
		Если НЕ НайденыНенужныеСтроки Тогда
			
			ТекстСообщения = НСтр("ru = 'Строк и колонок, не содержащих информацию для загрузки, не обнаружено.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			
		Иначе
			
			ТекстСообщения = НСтр("ru = 'Удаление завершено.'");
			ТекстПояснения = НСтр("ru = 'Удаление незначимых данных завершено.'");
			ПоказатьОповещениеПользователя(ТекстСообщения,, ТекстПояснения);
			
		КонецЕсли;
	ИначеЕсли ДлительнаяОперация.Статус = "Ошибка" Тогда
		ВызватьИсключение ДлительнаяОперация.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультатУдаленияЛишнихСтрок(АдресРезультата, НайденыНенужныеСтроки)
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	НайденыНенужныеСтроки = Результат.НайденыНенужныеСтроки;
	Если НайденыНенужныеСтроки Тогда
		ДанныеФайла = Результат.ХранилищеДанных.Получить();
	КонецЕсли;
	
	ЗагрузкаДанныхИзВнешнихФайловКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ДанныеФайла, "НеИспользовать");
	
КонецПроцедуры

#КонецОбласти

#Область ПодготовкаТаблицыДанныхДляЗагрузки

&НаСервере
Функция ПодготовитьТаблицуТоваровСервер()
	
	ПараметрыЗадания = Новый Структура;
	ХранилищеДанных = Новый ХранилищеЗначения(ДанныеФайла, Новый СжатиеДанных(9));
	ПараметрыЗадания.Вставить("ХранилищеДанных", ХранилищеДанных);
	ПараметрыЗадания.Вставить("СтавкаНДС", СтавкаНДС);
	ПараметрыЗадания.Вставить("ЕдиницаИзмерения", ЕдиницаИзмерения);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Подготовка таблицы товаров при загрузке номенклатуры.'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.ЗагрузкаНоменклатурыИзФайла.ПолучитьТаблицуДанныхТоваров",
		ПараметрыЗадания, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ПодготовитьТаблицуДанныхДляЗагрузкиЗавершение(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		ЗаполнитьТаблицуТоваров(ДлительнаяОперация.АдресРезультата);
	ИначеЕсли ДлительнаяОперация.Статус = "Ошибка" Тогда
		ВызватьИсключение ДлительнаяОперация.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТоваров(АдресРезультата)
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	ЕстьКолонкаЕдиницаИзмерения = Результат.ЕстьКолонкаЕдиницаИзмерения;
	ЕстьКолонкаСтавкаНДС = Результат.ЕстьКолонкаСтавкаНДС;
	
	Объект.Товары.Загрузить(Результат.Товары);
	
	ИзменитьШаг("Шаг2");
	
	ЗаголовокСсылкиУстановкиРеквизитов();
	ИзменитьТекстПереключателяОтбора();
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаДанныхИзФайла

&НаСервере
Функция ЗагрузитьНаСервере()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Товары", Объект.Товары.Выгрузить());
	ПараметрыЗадания.Вставить("ЕстьКолонкаЕдиницаИзмерения", ЕстьКолонкаЕдиницаИзмерения);
	ПараметрыЗадания.Вставить("ЕстьКолонкаСтавкаНДС", ЕстьКолонкаСтавкаНДС);
	ПараметрыЗадания.Вставить("Валюта", Валюта);
	ПараметрыЗадания.Вставить("СтавкаНДС", СтавкаНДС);
	ПараметрыЗадания.Вставить("НоменклатурнаяГруппа", НоменклатурнаяГруппа);
	ПараметрыЗадания.Вставить("ЕдиницаИзмерения", ЕдиницаИзмерения);
	ПараметрыЗадания.Вставить("Родитель", Родитель);
	ПараметрыЗадания.Вставить("ВидНоменклатуры", ВидНоменклатуры);
	ПараметрыЗадания.Вставить("ТипЦен", ТипЦен);
	ПараметрыЗадания.Вставить("ДатаУстановкиЦен", ДатаУстановкиЦен);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка данных файла.'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.ЗагрузкаНоменклатурыИзФайла.ЗагрузитьДанныеФайла",
		ПараметрыЗадания, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ЗагрузкаДанныхИзФайлаЗавершение(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		Ошибки = ОшибкиПослеЗагрузки(ДлительнаяОперация.АдресРезультата);
		Если Ошибки <> Неопределено Тогда
			
			ТекстПредупреждения = НСтр("ru = 'При загрузке данных произошли ошибки.'");
			ПоказатьПредупреждение(, ТекстПредупреждения);
			ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
			
		Иначе
			
			ПоказатьОповещениеПользователя(НСтр("ru = 'Загрузка номенклатуры и цен произведена.'"));
			ОповеститьОбИзменении(Тип("СправочникСсылка.Номенклатура"));
			Закрыть();
			
		КонецЕсли;
	ИначеЕсли ДлительнаяОперация.Статус = "Ошибка" Тогда
		ВызватьИсключение ДлительнаяОперация.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОшибкиПослеЗагрузки(АдресРезультата)
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	Возврат Результат.Ошибки;
	
КонецФункции

#КонецОбласти

#Область ПрочиеСлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВопросаОПереходеНаПервыйШаг(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ТабличнаяЧастьИзменена = Ложь;
		ИзменитьШаг("Шаг1");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВалютуИзТипаЦенСервер(Знач ТипЦен)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТипЦен, "ВалютаЦены");
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатуры(Знач Номенклатура)
	
	ДанныеНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, "ЕдиницаИзмерения, ВидСтавкиНДС");
	СтавкаНДС = Перечисления.СтавкиНДС.СтавкаНДС(ДанныеНоменклатуры.ВидСтавкиНДС, ТекущаяДатаСеанса());
	ДанныеНоменклатуры.Вставить("СтавкаНДС", СтавкаНДС);
	
	Возврат ДанныеНоменклатуры;
	
КонецФункции

&НаСервере
Функция ОписаниеКолонокВоВременномХранилище()
	Возврат ПоместитьВоВременноеХранилище(ОписаниеКолонок.Выгрузить());
КонецФункции

&НаСервереБезКонтекста
Функция ТипИВалютаЦеныПоИдентификатору(ИдентификаторТипаЦен)
	
	Возврат Обработки.ЗагрузкаНоменклатурыИзФайла.ТипИВалютаЦеныПоИдентификатору(ИдентификаторТипаЦен);
	
КонецФункции

#КонецОбласти

#КонецОбласти
