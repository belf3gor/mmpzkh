#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru='Получение текущего тарифа'");
	ФоновоеЗаданиеПолучениеОписанияТарифов = ДлительныеОперации.ВыполнитьВФоне("Обработки.ОплатаСервиса.ПолучитьОписаниеТарифовВФоне",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
	ОткрыватьФормуОплаты = Параметры.ОткрыватьФормуОплаты;
	ЗаголовокСсылкиВозвратаКВладельцу = Параметры.ЗаголовокСсылкиВозвратаКВладельцу;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультатПолученияОписанияТарифов", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗаданиеПолучениеОписанияТарифов, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПолеHTMLДокументаПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если ДанныеСобытия.href <> Неопределено Тогда
		
		Если СтрНайти(ВРег(ДанныеСобытия.href), "TARIF") = 0 Тогда
			СтандартнаяОбработка = Истина;
			Возврат;
		КонецЕсли; 
		
		СтандартнаяОбработка = Ложь;
		
		Тариф = СокрЛП(СтрЗаменить(ДанныеСобытия.href, "Tarif:", ""));
		Тариф = СокрЛП(СтрЗаменить(ДанныеСобытия.href, "tarif:", ""));
		
		Если ОткрыватьФормуОплаты Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ВыбранныйТариф", Тариф);
			ПараметрыФормы.Вставить("ЗаголовокСсылкиВозвратаКВладельцу", ЗаголовокСсылкиВозвратаКВладельцу);
			ОткрытьФорму("Обработка.ОплатаСервиса.Форма.Оплата", ПараметрыФормы, ВладелецФормы,
				Новый УникальныйИдентификатор,,,, РежимОткрытияОкнаФормы.Независимый);
			Закрыть();
		Иначе
			Закрыть(Тариф);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	ПолученаСтраницаСТарифами = НЕ ПустаяСтрока(Форма.СтраницаСТарифами);
	
	Элементы = Форма.Элементы;
	
	Элементы.ПолеHTMLДокумента.Видимость = ПолученаСтраницаСТарифами;
	Элементы.ГруппаОжидание.Видимость = НЕ ПолученаСтраницаСТарифами;
	Элементы.ГруппаОшибкаСвязи.Видимость = Форма.Ошибка;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатПолученияОписанияТарифов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Статус = "Выполнено" Тогда
		
		СтраницаСТарифами = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Ошибка = Ложь;
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		Ошибка = Истина;
		ЗаписатьОшибкуВЖурналРегистрации(Результат.ПодробноеПредставлениеОшибки);
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьОшибкуВЖурналРегистрации(Знач ОписаниеОшибки)
	
	Событие = НСтр("ru='Оплата сервиса.Ошибка'");
	Уровень = УровеньЖурналаРегистрации.Ошибка;
	ОбъектМетаданных = Метаданные.Обработки.ОплатаСервиса;
	
	ЗаписьЖурналаРегистрации(Событие, Уровень, ОбъектМетаданных,, ОписаниеОшибки);
	
КонецПроцедуры

#КонецОбласти
