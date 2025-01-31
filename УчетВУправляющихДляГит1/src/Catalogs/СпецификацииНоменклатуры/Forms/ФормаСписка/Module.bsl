#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.СпецификацииНоменклатуры);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	Если Не Параметры.Отбор.Свойство("Владелец") Тогда
		Элементы.СписокОсновная.Видимость               = Ложь;
		Элементы.ФормаИспользоватьКакОсновную.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКакОсновную(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСообщения = Новый Структура;
	ПараметрыСообщения.Вставить("ОсновнаяСпецификация", Элементы.Список.ТекущиеДанные.Ссылка);
	ПараметрыСообщения.Вставить("Номенклатура",         Элементы.Список.ТекущиеДанные.Владелец);
	Модифицированность = Ложь;
	Оповестить("НазначенаПоКнопкеОсновнаяСпецификацияВСпискеСпецификаций", ПараметрыСообщения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЗаданОтборПоВладельцу(Список.Отбор.Элементы) Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуСпецификации(Ложь, Ложь, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Группа Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗаданОтборПоВладельцу(Список.Отбор.Элементы) Тогда
		Отказ = Истина;
		ОткрытьФормуСпецификации(Истина, Копирование, Элемент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ЗаданОтборПоВладельцу(Элементы)
	
	ПолеВладелец = Новый ПолеКомпоновкиДанных("Владелец");
	
	Для Каждого СтрокаОтбора Из Элементы Цикл
		Если СтрокаОтбора.ЛевоеЗначение = ПолеВладелец И ПодходитДляЗначенияЗаполнения(СтрокаОтбора) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Функция ПодходитДляЗначенияЗаполнения(СтрокаОтбора)
	Возврат СтрокаОтбора.Использование
		И СтрокаОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно
		И ТипЗнч(СтрокаОтбора.ЛевоеЗначение) = Тип("ПолеКомпоновкиДанных") 
		И ТипЗнч(СтрокаОтбора.ПравоеЗначение) <> Тип("ПолеКомпоновкиДанных");
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуСпецификации(ДобавлениеНового, Копирование, Элемент)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("СписокСОтборомПоВладельцу", Истина);
	
	Если Копирование Тогда
		ПараметрыОткрытия.Вставить("ЗначениеКопирования", Элемент.ТекущаяСтрока);
	КонецЕсли;
	
	Если ДобавлениеНового Тогда
		
		Отбор = Новый Структура;
		
		Для Каждого СтрокаОтбора Из Список.Отбор.Элементы Цикл
			
			Если ПодходитДляЗначенияЗаполнения(СтрокаОтбора) Тогда
				
				Отбор.Вставить(Строка(СтрокаОтбора.ЛевоеЗначение), СтрокаОтбора.ПравоеЗначение);
				
			КонецЕсли;
			
		КонецЦикла;
		
		ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", Отбор);
		
	Иначе
		ПараметрыОткрытия.Вставить("Ключ", Элемент.ТекущаяСтрока);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.СпецификацииНоменклатуры.ФормаОбъекта", ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти
