#Область ПрограммныйИнтерфейс

// Открывает форму соответствующего вида заявления
//
// Параметры:
//  ВидЗаявления - ПеречислениеСсылка.ВидыУведомленийОСпецрежимахНалогообложения - вид заявления
//  ПараметрыФормы - Структура - параметры формы заявления
//   * Организация - СправочникСсылка.Организации
//  ВладелецФормы - Управляемая форма - владелец формы
//
Процедура ОткрытьФормуЗаявления(ВидЗаявления, ПараметрыФормы, ВладелецФормы = Неопределено) Экспорт
	
	ИмяФормыЗаявления = УчетПСНВызовСервера.ИмяФормыЗаявления(ВидЗаявления);
	Если ПустаяСтрока(ИмяФормыЗаявления) Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидЗаявления = ПредопределенноеЗначение(
			"Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОбУтратеПраваНаПатент") Тогда
		
		// При утрате права, спрашиваем у пользователя дату события
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИмяФормыЗаявления", ИмяФормыЗаявления);
		ДополнительныеПараметры.Вставить("ПараметрыФормы",    ПараметрыФормы);
		ДополнительныеПараметры.Вставить("ВладелецФормы",     ВладелецФормы);
		
		ОповещениеОВыборе = Новый ОписаниеОповещения("ВыборДатыУтратыПраваЗаявленияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ОткрытьФорму("Справочник.Патенты.Форма.ФормаВыборДатыУтратыПрава",,ВладелецФормы,,,,ОповещениеОВыборе);
		
	Иначе
		
		ОткрытьФорму(ИмяФормыЗаявления, ПараметрыФормы, ВладелецФормы);
		
	КонецЕсли;
	
КонецПроцедуры

// Дополнительная обработка перед заполнением заявления по кнопке Заполнить
//
// Параметры:
//   ПараметрыОтчета - Структура
//     * Организация - СправочникСсылка.Организации
//   ФормаОтчета - Управляемая форма - форма заявления
//   ОписаниеОповещения - ОписаниеОповещения - обратный вызов формы отчета
//
Процедура ПередЗаполнениемЗаявленияУтратаПраваНаПатент(ПараметрыОтчета, ФормаОтчета, ОписаниеОповещения) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);

	ОповещениеОВыборе = Новый ОписаниеОповещения("ПередЗаполнениемЗаявленияУтратаПраваПатентЗавершение",
		ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("Справочник.Патенты.Форма.ФормаВыборДатыУтратыПрава",,ФормаОтчета,,,,ОповещениеОВыборе);
	
КонецПроцедуры

// Дополнительная обработка перед заполнением заявления по кнопке Заполнить
//
// Параметры:
//   ПараметрыОтчета - Структура
//     * Организация - СправочникСсылка.Организации
//   ФормаОтчета - Управляемая форма - форма заявления
//   ОписаниеОповещения - ОписаниеОповещения - обратный вызов формы отчета
//
Процедура ПередЗаполнениемЗаявленияПрекращениеПатента(ПараметрыОтчета, ФормаОтчета, ОписаниеОповещения) Экспорт
	
	Перем Организация;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	
	ОповещениеОВыборе = Новый ОписаниеОповещения("ПередЗаполнениемЗаявленияПрекращениеПатентаЗавершение",
		ЭтотОбъект, ДополнительныеПараметры);
	
	Отбор = Новый Структура;
	
	ПараметрыФормыВыбора = Новый Структура;
	Если ПараметрыОтчета.Свойство("Организация", Организация) И ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Владелец", Организация);
	КонецЕсли;
	
	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
	
	ОткрытьФорму("Справочник.Патенты.ФормаВыбора", ПараметрыФормыВыбора, ФормаОтчета, , , , ОповещениеОВыборе);
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеНовогоПатента

Процедура ОбработатьВыборНовогоПатента(Элемент, ВыбранноеЗначение, Организация, Дата) Экспорт
	
	ИмяНовыйПатент = ИмяНовыйПатент();
	СписокВыбора = Элемент.СписокВыбора;
	
	ОткрытьФормуВыбораНовогоПатента(Элемент, ВыбранноеЗначение, Организация, Дата);
	
	Если ВыбранноеЗначение <> Неопределено И СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение)= Неопределено Тогда
		СписокВыбора.Добавить(ВыбранноеЗначение);
		
		ЭлементНовыйПатент = СписокВыбора.НайтиПоЗначению(ИмяНовыйПатент);
		Если ЭлементНовыйПатент <> Неопределено Тогда
			СписокВыбора.Сдвинуть(ЭлементНовыйПатент, 1);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьВыборНовогоПатентаИзКоллекции(СписокВыбора, РеквизитПатент, знач ВыбранноеЗначение, КоллекцияЗначений) Экспорт
	
	ИмяНовыйПатент = ИмяНовыйПатент();
	
	Если ВыбранноеЗначение <> Неопределено И СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение)= Неопределено Тогда
		
		НоваяКоллекция = Новый Соответствие;
		Для каждого КлючИЗначение Из КоллекцияЗначений Цикл
			НоваяКоллекция.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		
		НоваяКоллекция.Вставить(КоллекцияЗначений.Количество(), ВыбранноеЗначение);
		КоллекцияЗначений = Новый ФиксированноеСоответствие(НоваяКоллекция);
		
		Представление = СтрШаблон(НСтр("ru = 'Доход по патенту ""%1""'"), ВыбранноеЗначение);
		СписокВыбора.Добавить(Представление);
		РеквизитПатент = Представление;
		
		ЭлементНовыйПатент = СписокВыбора.НайтиПоЗначению(ИмяНовыйПатент);
		Если ЭлементНовыйПатент <> Неопределено Тогда
			СписокВыбора.Сдвинуть(ЭлементНовыйПатент, 1);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуВыбораНовогоПатента(ВладелецФормы, ВыбранноеЗначение, Организация, Дата) Экспорт
	
	Если ВыбранноеЗначение = ИмяНовыйПатент() Тогда
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Владелец", Организация);
		ЗначенияЗаполнения.Вставить("ДатаНачала",    НачалоГода(Дата));
		ЗначенияЗаполнения.Вставить("ДатаОкончания", КонецГода(Дата));
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СозданИзФормыДокумента", Истина);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Справочник.Патенты.ФормаОбъекта", ПараметрыФормы, ВладелецФормы);
		ВыбранноеЗначение = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьВСписокНовыйПатент(Список) Экспорт
	
	ИмяНовыйПатент = ИмяНовыйПатент();
	Если Список.НайтиПоЗначению(ИмяНовыйПатент) = Неопределено Тогда
		Список.Добавить(ИмяНовыйПатент, НСтр("ru = 'Создать патент ...'"));
	КонецЕсли;
	
КонецПроцедуры

Функция ИмяНовыйПатент()
	
	Возврат "НовыйПатент";
	
КонецФункции

Процедура ТекстНеобходимоЗаполнитьПатентОбработкаНавигационнойСсылки(ВладелецФормы, НавигационнаяСсылка, Организация, Дата, СтандартнаяОбработка, ОписаниеОповещения = Неопределено) Экспорт
	
	Если НавигационнаяСсылка = УчетПСНКлиентСервер.НавигационнаяСсылкаНеобходимоЗаполнитьПатент() Тогда
		
		ОткрытьФормуСозданияНовогоПатента(ВладелецФормы, Организация, Дата, СтандартнаяОбработка, ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуСозданияНовогоПатента(ВладелецФормы, Организация, Дата, СтандартнаяОбработка, ОписаниеОповещения = Неопределено) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если ОписаниеОповещения = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПатентЗаполнениеРеквизитовЗавершение", ВладелецФормы);
	КонецЕсли;
	
	ДанныеЗаполнения = Новый  Структура();
	ДанныеЗаполнения.Вставить("Владелец",      Организация);
	ДанныеЗаполнения.Вставить("ДатаНачала",    НачалоГода(Дата));
	ДанныеЗаполнения.Вставить("ДатаОкончания", КонецГода(Дата));
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("СозданИзФормыДокумента", Истина);
	ПараметрыФормы.Вставить("РежимВыбора",            Истина);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения",     ДанныеЗаполнения);
	
	ОткрытьФорму("Справочник.Патенты.ФормаОбъекта", ПараметрыФормы, ВладелецФормы, , , , ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыборДатыУтратыПраваЗаявленияЗавершение(ДатаУтратыПрава, ДополнительныеПараметры) Экспорт
	
	Если ДатаУтратыПрава = Неопределено Или ТипЗнч(ДатаУтратыПрава) <> Тип("Дата") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ДополнительныеПараметры.ПараметрыФормы);
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ДатаУтратыПрава", ДатаУтратыПрава);
	ПараметрыФормы.Вставить("ПараметрыЗаполнения", ПараметрыЗаполнения);
	
	ОткрытьФорму(
		ДополнительныеПараметры.ИмяФормыЗаявления,
		ПараметрыФормы,
		ДополнительныеПараметры.ВладелецФормы);
	
КонецПроцедуры

Процедура ПередЗаполнениемЗаявленияУтратаПраваПатентЗавершение(ДатаУтратыПрава, ДополнительныеПараметры) Экспорт
	
	Если ДатаУтратыПрава <> Неопределено Тогда
		ПараметрыЗаполнения = Новый Структура;
		ПараметрыЗаполнения.Вставить("ДатаУтратыПрава", ДатаУтратыПрава);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, ПараметрыЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаполнениемЗаявленияПрекращениеПатентаЗавершение(Патент, ДополнительныеПараметры) Экспорт
	
	Если Патент <> Неопределено Тогда
		ПараметрыЗаполнения = Новый Структура;
		ПараметрыЗаполнения.Вставить("Патент", Патент);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, ПараметрыЗаполнения);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

