#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеОбособленногоПодразделения", НСтр("ru='Обособленное подразделение'"));
	
	ОткрытИзПлатежки = Параметры.Свойство("ОткрытИзПлатежки");
	
	ОтображатьСтатусыДокументов = ПолучитьФункциональнуюОпцию("ОтображатьДополнительныеКолонкиВСписках");
	Элементы.ЭДО.Видимость = ОтображатьСтатусыДокументов;
	Если ОтображатьСтатусыДокументов Тогда
		
		// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
		ПроверкаКонтрагентов.ПриСозданииНаСервереСписокКонтрагентов(Список);
		// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.Справочник.Контрагенты",
		"ФормаВыбора",
		НСтр("ru='Новости: Контрагент'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Если ОткрытИзПлатежки И Элемент.ТекущиеДанные.Вид <> "" Тогда
		Отказ = Истина;
		ПараметрыФормы = Новый Структура("Ключ", Элемент.ТекущаяСтрока);
		ПараметрыФормы.Вставить("ОткрытИзПлатежки"); 
		
		ЗначенияЗаполнения = Новый Структура();
		ДополнитьЗначенияЗаполненияОтборомПоГосоргану(ЗначенияЗаполнения);
		Если ЗначениеЗаполнено(ЗначенияЗаполнения) Тогда
			ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		КонецЕсли;
		
		ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если ОткрытИзПлатежки И НЕ Группа Тогда
		Отказ = Истина;
		
		ПараметрыФормы = Новый Структура("ОткрытИзПлатежки");
		ЗначенияЗаполнения = Новый Структура("Родитель", Родитель);
		ДополнитьЗначенияЗаполненияОтборомПоГосоргану(ЗначенияЗаполнения);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		Если Копирование И ЗначениеЗаполнено(Элемент.ТекущаяСтрока) Тогда
			ПараметрыФормы.Вставить("ЗначениеКопирования", Элемент.ТекущаяСтрока);
		КонецЕсли;
		
		ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДополнитьЗначенияЗаполненияОтборомПоГосоргану(ЗначенияЗаполнения)
	
	УстановленОтборПоГосоргану = УстановленОтборПоГосоргану();
	Если УстановленОтборПоГосоргану Тогда
		ЗначенияЗаполнения.Вставить("ГосударственныйОрган", Истина);
		ЗначенияЗаполнения.Вставить("ЮридическоеФизическоеЛицо", ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция УстановленОтборПоГосоргану()
	
	ПолеКомпоновкиГосорган = Новый ПолеКомпоновкиДанных("ГосударственныйОрган");
	
	УстановленОтборПоГосоргану = Ложь;
	
	Для Каждого ЭлементОтбора Из Список.Отбор.Элементы Цикл
		Если ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновкиГосорган
			И ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно
			И ЭлементОтбора.ПравоеЗначение = Истина Тогда
			УстановленОтборПоГосоргану = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат УстановленОтборПоГосоргану;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// ИНН некорректный
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ИНН");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ИННВведенКорректно", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветВыделенияКонтрагентаСОшибкой);

	// КПП некорректный
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "КПП");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.КППВведенКорректно", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветВыделенияКонтрагентаСОшибкой);

	Если Не ОтображатьСтатусыДокументов Тогда
		Возврат;
	КонецЕсли;
	
	// ИНН дублируется
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ИНН");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ИННВведенКорректно", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ЕстьДубли", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ПроверкаКонтрагентовКонтрагентНеСуществует", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветВыделенияКонтрагентаСОшибкой);
	
	// КПП дублируется
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "КПП");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.КППВведенКорректно", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ЕстьДубли", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ПроверкаКонтрагентовКонтрагентНеСуществует", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветВыделенияКонтрагентаСОшибкой);

	// Контрагента нет в реестре
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ИНН");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "КПП");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ПроверкаКонтрагентовКонтрагентНеСуществует", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ПроверкаКонтрагентовСостояние", ВидСравненияКомпоновкиДанных.НеРавно, Перечисления.СостоянияСуществованияКонтрагента.НеДействуетИлиИзмененКПП);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветКонтрагентаОтсутствущегоВРеестре);

	// Контрагент прекратил деятельность
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Список");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ПроверкаКонтрагентовКонтрагентНеСуществует", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ПроверкаКонтрагентовСостояние", ВидСравненияКомпоновкиДанных.Равно, Перечисления.СостоянияСуществованияКонтрагента.НеДействуетИлиИзмененКПП);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветКонтрагентаПрекратившегоДеятельность);

КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтаФорма,
		Команда
	);

КонецПроцедуры

#КонецОбласти