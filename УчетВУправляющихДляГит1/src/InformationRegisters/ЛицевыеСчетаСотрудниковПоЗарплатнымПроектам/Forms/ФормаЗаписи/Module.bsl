#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустой() Тогда
		
		Если Не Параметры.ЗначениеКопирования.Пустой() Тогда
			Запись.ФизическоеЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
			Запись.НомерЛицевогоСчета = "";
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Запись.Организация)
			И ЗначениеЗаполнено(Запись.ЗарплатныйПроект) Тогда
			Запись.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.ЗарплатныйПроект, "Организация");
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Запись.Организация) Тогда
			Запись.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Запись.ДатаОткрытияЛицевогоСчета) Тогда
			Запись.ДатаОткрытияЛицевогоСчета = ТекущаяДатаСеанса();
		КонецЕсли;
		
		УстановитьДоступностьЭлементовФормы(ЭтотОбъект, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьДоступностьЭлементовФормы(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьДоступностьЭлементовФормы(ЭтотОбъект, Истина);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	
	ОчиститьДокументОснование();
	УстановитьДоступностьЭлементовФормы(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОчиститьДокументОснование();
	УстановитьДоступностьЭлементовФормы(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатныйПроектПриИзменении(Элемент)
	
	ОчиститьДокументОснование();
	УстановитьДоступностьЭлементовФормы(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура НомерЛицевогоСчетаПриИзменении(Элемент)
	
	ОчиститьДокументОснование();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормы(Форма, ТолькоПросмотрЗаполненных)
	
	Элементы = Форма.Элементы;
	Запись = Форма.Запись;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ФизическоеЛицо",
		"ТолькоПросмотр",
		ТолькоПросмотрЗаполненных И ЗначениеЗаполнено(Запись.ФизическоеЛицо));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Организация",
		"ТолькоПросмотр",
		ТолькоПросмотрЗаполненных И ЗначениеЗаполнено(Запись.Организация));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ЗарплатныйПроект",
		"ТолькоПросмотр",
		ТолькоПросмотрЗаполненных И ЗначениеЗаполнено(Запись.ЗарплатныйПроект)
			Или Не ЗначениеЗаполнено(Запись.Организация));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"НомерЛицевогоСчета",
		"ТолькоПросмотр",
		Не ЗначениеЗаполнено(Запись.ЗарплатныйПроект)
			Или Не ЗначениеЗаполнено(Запись.ФизическоеЛицо));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДатаОткрытияЛицевогоСчета",
		"ТолькоПросмотр",
		Не ЗначениеЗаполнено(Запись.ЗарплатныйПроект)
			Или Не ЗначениеЗаполнено(Запись.ФизическоеЛицо));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДокументОснование",
		"Видимость",
		ЗначениеЗаполнено(Запись.ДокументОснование));
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьДокументОснование()
	
	Запись.ДокументОснование = Неопределено;
	
КонецПроцедуры

#КонецОбласти

