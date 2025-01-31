
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
	
	ОтборДата = Неопределено;
	РежимОтборПоДате = Неопределено;
	
	Если Параметры.Отбор.Свойство("Дата", ОтборДата) Тогда
		
		Если Параметры.Свойство("РежимОтбораПоДате", РежимОтборПоДате) Тогда
			
			Если РежимОтборПоДате = "ДоДаты" Тогда			
				ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(
					Список, "Дата", КонецДня(ОтборДата), ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);			
			ИначеЕсли РежимОтборПоДате = "СДаты" Тогда			
				ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(
					Список, "Дата", НачалоДня(ОтборДата), ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
			Иначе
				ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(
					Список, "Дата", КонецДня(ОтборДата), ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
				ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(
					Список, "Дата", НачалоДня(ОтборДата), ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
			КонецЕсли; 
			
		Иначе
			ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(
				Список, "Дата", КонецДня(ОтборДата), ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
			ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(
				Список, "Дата", НачалоДня(ОтборДата), ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
		КонецЕсли;
		
		Параметры.Отбор.Удалить("Дата");
		
	КонецЕсли;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.ВосстановлениеНДС);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	ТарификацияБП.РазместитьИнформациюОбОграниченииПоКоличествуОбъектов(ЭтотОбъект);
	
КонецПроцедуры //ПриСозданииНаСервере()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
	КонецЕсли;

КонецПроцедуры //ОбработкаОповещения()

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЧНОЙ ЧАСТИ Список

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)

	КлючеваяОперация = "СозданиеФормыВосстановлениеНДС";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)

	КлючеваяОперация = "ОткрытиеФормыВосстановлениеНДС";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);

КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

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

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти
