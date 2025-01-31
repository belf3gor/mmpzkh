&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ВидыРасходовОсновнаяСистемаНалогообложения = Справочники.СтатьиЗатрат.ВидыРасходовТолькоОсновнаяСистемаНалогообложения();
	ИспользуютсяСпециальныеНалоговыеРежимы     = НалоговыйУчет.ИспользуютсяСпециальныеНалоговыеРежимы();
	
	НастроитьДоступностьВидовДеятельности(ЭтаФорма, Объект.ВидРасходовНУ);
	
	ТаблицаПредопределнных = Справочники.СтатьиЗатрат.ПолучитьТаблицуПредопределенныхЗначений();
		
	ТекущееНазначение = ТаблицаПредопределнных.Найти(Объект.ИмяПредопределенныхДанных, "Имя");
	Если НЕ ТекущееНазначение = НЕОПРЕДЕЛЕНО Тогда
		ЭтаФорма.ИспользованиеПоУмолчанию = ТекущееНазначение.Текст;
		ЭтаФорма.Элементы.ИспользованиеПоУмолчанию.Доступность = ТекущееНазначение.Доступность;
	КонецЕсли;
	                                                             
	Элементы.ИспользованиеПоУмолчанию.СписокВыбора.Очистить();
	Для Каждого ПредопределенныйЭлемент Из ТаблицаПредопределнных Цикл
		Если ПредопределенныйЭлемент.Доступность Тогда
			Элементы.ИспользованиеПоУмолчанию.СписокВыбора.Добавить(ПредопределенныйЭлемент.Текст);
		КонецЕсли;
	КонецЦикла;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидРасходовНУПриИзменении(Элемент)
	
	НастроитьДоступностьВидовДеятельности(ЭтаФорма, Объект.ВидРасходовНУ);
	ОбеспечитьСоответствиеВидаДеятельностиВидуРасходов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбеспечитьСоответствиеВидаДеятельностиВидуРасходов()
	
	Если ВидРасходовПрименяетсяДляСпециальныхНалоговыхРежимов(ЭтаФорма, Объект.ВидРасходовНУ) Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ВидДеятельностиДляНалоговогоУчетаЗатрат = ПредопределенноеЗначение("Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения") 
		Или Объект.ВидДеятельностиДляНалоговогоУчетаЗатрат = ПредопределенноеЗначение("Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.РаспределяемыеЗатраты") Тогда
		
		Объект.ВидДеятельностиДляНалоговогоУчетаЗатрат = ПредопределенноеЗначение("Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения");
		
		ТекстИнформации = НСтр("ru = 'Статьи затрат с видом ""%1"" следует использовать 
		|только для учета затрат по видам деятельности с основной системой налогообложения.
		|Назначение использования статьи затрат изменено.'");
		ТекстИнформации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстИнформации, Объект.ВидРасходовНУ);
		
		ПоказатьПредупреждение(,ТекстИнформации);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьДоступностьВидовДеятельности(Форма, ВидРасходовНУ)
	
	Элементы = Форма.Элементы;
	
	ДоступныСпециальныеНалоговыеРежимы = ВидРасходовПрименяетсяДляСпециальныхНалоговыхРежимов(Форма, ВидРасходовНУ);
	
	Элементы.ОсобыйПорядокНалогообложения.Доступность = ДоступныСпециальныеНалоговыеРежимы;
	Элементы.РазныеВидыДеятельности.Доступность       = ДоступныСпециальныеНалоговыеРежимы;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВидРасходовПрименяетсяДляСпециальныхНалоговыхРежимов(Форма, ВидРасходовНУ)
	
	Если Не Форма.ИспользуютсяСпециальныеНалоговыеРежимы Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Форма.ВидыРасходовОсновнаяСистемаНалогообложения.Найти(ВидРасходовНУ) = Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

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

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ИспользованиеПоУмолчанию) ИЛИ Объект.Предопределенный Тогда
		ОбработатьИмяПредопределенныхДанных(Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИмяПредопределенныхДанных(Отказ)
	
	ТаблицаПредопределнных = Справочники.СтатьиЗатрат.ПолучитьТаблицуПредопределенныхЗначений();
	
	Если НЕ ЗначениеЗаполнено(ИспользованиеПоУмолчанию) Тогда
		Объект.ИмяПредопределенныхДанных = "";
		Возврат;
	КонецЕсли;
	
	ТекущееНазначение = ТаблицаПредопределнных.Найти(ЭтаФорма.ИспользованиеПоУмолчанию, "Текст");
	Если НЕ ТекущееНазначение = НЕОПРЕДЕЛЕНО Тогда
		НовыйПредопределенный = ТекущееНазначение.Имя;
		СтарыйПредопределенный = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.СтатьиЗатрат." + НовыйПредопределенный);
		
		Если ЗначениеЗаполнено(СтарыйПредопределенный) И СтарыйПредопределенный <> Объект.Ссылка Тогда
			СтарыйОбъект = СтарыйПредопределенный.ПолучитьОбъект();
			Попытка
				СтарыйОбъект.Заблокировать();
			Исключение
				ТекстСообщения = НСтр("ru = 'Не удалось заблокировать объект'") + " '" + СтарыйОбъект + "'!
				|"+ ОписаниеОшибки();
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, СтарыйПредопределенный, , , Отказ);
				Возврат;
			КонецПопытки;
			СтарыйОбъект.ИмяПредопределенныхДанных = "";
			СтарыйОбъект.Записать();                                 			
			СтарыйОбъект.Разблокировать();			
		КонецЕсли;
		Объект.ИмяПредопределенныхДанных = НовыйПредопределенный;
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// ВидРасходовНУ

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ВидРасходовНУ");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ВидДеятельностиДляНалоговогоУчетаЗатрат", 
		ВидСравненияКомпоновкиДанных.Равно, 
		Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти
