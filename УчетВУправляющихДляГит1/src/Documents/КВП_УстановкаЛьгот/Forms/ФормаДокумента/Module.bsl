
#Область ВспомогательныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
// Устанавливает видимость элементов формы.
//
// Параметры
//  нет
//
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	ИспользоватьСписокДокументовОснований = Форма.мИспользоватьФункционалВыгрузкиВГЦЖС;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.КВП_ВидыОперацийУстановкиЛьгот.ПрекращениеЛьготы") Тогда
		
		Элементы.СписокЛьготВидДокумента.Видимость           = Ложь;
		Элементы.СписокЛьготСерияДокумента.Видимость         = Ложь;
		Элементы.СписокЛьготНомерДокумента.Видимость         = Ложь;
		Элементы.СписокЛьготДатаВыдачиДокумента.Видимость    = Ложь;
		Элементы.СписокЛьготДатаОкончанияДокумента.Видимость = Ложь;
		Элементы.СписокЛьготКемВыдан.Видимость               = Ложь;
		Элементы.СписокЛьготДатаНачала.Заголовок    = "Прекратить с";
		Элементы.СписокЛьготДатаОкончания.Заголовок = "Прекратить по";
		
		ИспользоватьСписокДокументовОснований = Ложь;
		
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.КВП_ВидыОперацийУстановкиЛьгот.УстановкаЛьготы") Тогда
		
		Элементы.СписокЛьготВидДокумента.Видимость           = Истина;
		Элементы.СписокЛьготСерияДокумента.Видимость         = Истина;
		Элементы.СписокЛьготНомерДокумента.Видимость         = Истина;
		Элементы.СписокЛьготДатаВыдачиДокумента.Видимость    = Истина;
		Элементы.СписокЛьготДатаОкончанияДокумента.Видимость = Истина;
		Элементы.СписокЛьготКемВыдан.Видимость               = Истина;
		Элементы.СписокЛьготДатаНачала.Заголовок    = "Установить с";
		Элементы.СписокЛьготДатаОкончания.Заголовок = "Установить по";
		
	КонецЕсли;
	
	// Настройка с количеством документов-оснований доступна, если используется 
	// функционал выгрузки в ГЦЖС, либо если количество документов-оснований 
	// каким-либо образом приняло значение, большее 1.
	Элементы.ГруппаКоличествоДокументовОснований.Видимость = 
		ИспользоватьСписокДокументовОснований ИЛИ Форма.КоличествоДокументовОснований > 1;
	
	// Колонки табличной части, соответствующие комплекту дополнительного 
	// документа-основания, видны только когда используется функционал выгрузки 
	// в ГЦЖС и количество документов-оснований принимает соответствующее значение.
	Элементы.СписокЛьготВидДокумента2.Видимость           = 
		ИспользоватьСписокДокументовОснований И Форма.КоличествоДокументовОснований > 1;
	Элементы.СписокЛьготСерияДокумента2.Видимость         = 
		ИспользоватьСписокДокументовОснований И Форма.КоличествоДокументовОснований > 1;
	Элементы.СписокЛьготНомерДокумента2.Видимость         = 
		ИспользоватьСписокДокументовОснований И Форма.КоличествоДокументовОснований > 1;
	Элементы.СписокЛьготДатаВыдачиДокумента2.Видимость    = 
		ИспользоватьСписокДокументовОснований И Форма.КоличествоДокументовОснований > 1;
	Элементы.СписокЛьготДатаОкончанияДокумента2.Видимость = 
		ИспользоватьСписокДокументовОснований И Форма.КоличествоДокументовОснований > 1;
	Элементы.СписокЛьготКемВыдан2.Видимость               = 
		ИспользоватьСписокДокументовОснований И Форма.КоличествоДокументовОснований > 1;
	
	Элементы.СписокЛьготВидДокумента3.Видимость           = 
		ИспользоватьСписокДокументовОснований И Форма.КоличествоДокументовОснований > 2;
	Элементы.СписокЛьготСерияДокумента3.Видимость         = 
		ИспользоватьСписокДокументовОснований И Форма.КоличествоДокументовОснований > 2;
	Элементы.СписокЛьготНомерДокумента3.Видимость         = 
		ИспользоватьСписокДокументовОснований И Форма.КоличествоДокументовОснований > 2;
	Элементы.СписокЛьготДатаВыдачиДокумента3.Видимость    = 
		ИспользоватьСписокДокументовОснований И Форма.КоличествоДокументовОснований > 2;
	Элементы.СписокЛьготДатаОкончанияДокумента3.Видимость = 
		ИспользоватьСписокДокументовОснований И Форма.КоличествоДокументовОснований > 2;
	Элементы.СписокЛьготКемВыдан3.Видимость               = 
		ИспользоватьСписокДокументовОснований И Форма.КоличествоДокументовОснований > 2;
	
КонецПроцедуры // УстановитьВидимость()

&НаСервере
// Определяет, указан ли документ-основание с указанным номером в какой-либо 
// строке табличной части документа. Считается, что документ указан, если 
// заполнен хоть один реквизит.
//
// Параметры:
//  НомерДокумента - Число - номер документа-основания (1, 2, 3).
//
// Возвращаемое значение:
//  Булево - заполнены ли реквизиты документа-основания.
//
Функция УказанДокументОснование(НомерДокумента)
	
	ЕстьДокументОснование = Ложь;
	Для Каждого ТекСтрока Из Объект.СписокЛьгот Цикл
		Если ЗначениеЗаполнено(ТекСтрока["ВидДокумента"           + НомерДокумента])
		 ИЛИ ЗначениеЗаполнено(ТекСтрока["СерияДокумента"         + НомерДокумента])
		 ИЛИ ЗначениеЗаполнено(ТекСтрока["НомерДокумента"         + НомерДокумента])
		 ИЛИ ЗначениеЗаполнено(ТекСтрока["ДатаВыдачиДокумента"    + НомерДокумента])
		 ИЛИ ЗначениеЗаполнено(ТекСтрока["ДатаОкончанияДокумента" + НомерДокумента])
		 ИЛИ ЗначениеЗаполнено(ТекСтрока["КемВыдан"               + НомерДокумента]) Тогда
			ЕстьДокументОснование = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЕстьДокументОснование;
	
КонецФункции // УказанДокументОснование()

#КонецОбласти 

#Область РаботаСПроцедурамиИФункциямиМодуляОбъекта

&НаСервере
// Процедура заполнения табличной части.
Процедура ЗаполнитьТабличнуюЧастьНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект", Тип("ДокументОбъект.КВП_УстановкаЛьгот"));
	ДокументОбъект.ЗаполнитьТабличнуюЧасть();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события "ПриЧтенииНаСервере" формы.
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УПЖКХ_ТиповыеМетодыСервер.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	УПЖКХ_ТиповыеМетодыСервер.УстановитьСостояниеДокумента(ЭтотОбъект);
	
КонецПроцедуры

// Процедура-обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	УПЖКХ_ТиповыеМетодыСервер.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УПЖКХ_ЗаполнениеДокументовСервер.ЗаполнитьШапкуДокумента(Объект,
																 УПЖКХ_ТиповыеМетодыКлиентСервер.ТекущийПользователь());
		УПЖКХ_ТиповыеМетодыСервер.УстановитьСостояниеДокумента(ЭтотОбъект);
	КонецЕсли;
	
	Если УказанДокументОснование(3) Тогда
		КоличествоДокументовОснований = 3;
	ИначеЕсли УказанДокументОснование(2) Тогда
		КоличествоДокументовОснований = 2;
	Иначе
		КоличествоДокументовОснований = 1;
	КонецЕсли;
	
	мИспользоватьФункционалВыгрузкиВГЦЖС = Константы.УПЖКХ_ИспользоватьФункционалВыгрузкиВГЦЖС.Получить();
	
	УправлениеФормой(ЭтаФорма);
	
	// Установить доступность формы с учетом ключа СЛК.
	СЗК_МодульЗащитыКлиентСервер.УстановитьДоступностьФормыДляРедактирования(ЭтаФорма);
	
	// ОбщиеМеханизмыИКоманды
	ОТР_ПодключаемыеОбщиеМеханизмыИКоманды.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ОбщиеМеханизмыИКоманды
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
// Процедура-обработчик события "ПослеЗаписиНаСервере" формы.
//
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УПЖКХ_ТиповыеМетодыСервер.УстановитьСостояниеДокумента(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Обработчик события "ПриИзменении" поля "Дата".
Процедура ДатаПриИзменении(Элемент)
	
	УПЖКХ_РаботаСДиалогамиКлиентСервер.ПроверитьНомерДокумента(Объект, Объект.Дата);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ОбработкаВыбора" поля "Объект".
Процедура ОбъектОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Объект.Объект.Пустая() Тогда
		Объект.СписокЛьгот.Очистить();
		Возврат;
	КонецЕсли;
	
	Если Не Объект.СписокЛьгот.Количество() = 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыОбработчикаОтветаНаВопрос = Новый Структура("ВыбранноеЗначение", ВыбранноеЗначение);
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбъектПриИзмененииЗавершение", ЭтотОбъект, ПараметрыОбработчикаОтветаНаВопрос),
					   "Таблица льгот будет очищена. Продолжить?",
					   РежимДиалогаВопрос.ДаНет, ,
					   КодВозвратаДиалога.Да);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" поля "Объект".
Процедура ОбъектПриИзменении(Элемент)
	
	ОбъектПриИзмененииФрагмент();
	
КонецПроцедуры // ОбъектПриИзменении()

&НаКлиенте
// Обработчик результата вопроса, вызванного в процедуре "ОбъектПриИзменении()".
Процедура ОбъектПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Объект = ДополнительныеПараметры.ВыбранноеЗначение;
	Объект.СписокЛьгот.Очистить();
	
	ОбъектПриИзмененииФрагмент();
	
КонецПроцедуры // ОбъектПриИзмененииЗавершение()

&НаКлиенте
// Продожение процедуры "ОбъектПриИзменении()".
Процедура ОбъектПриИзмененииФрагмент()
	
	ЗаполнитьТабличнуюЧастьНаСервере();
	
КонецПроцедуры // ОбъектПриИзмененииФрагмент()

&НаКлиенте
// Обработчик события "ПриИзменении" поля "КоличествоДокументовОснований".
Процедура КоличествоДокументовОснованийПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "Регулирование" поля "КоличествоДокументовОснований".
Процедура КоличествоДокументовОснованийРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Если КоличествоДокументовОснований = 3 И Направление = 1
	 Или КоличествоДокументовОснований = 1 И Направление = -1 Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Если Направление = -1 И КоличествоДокументовОснований > 1 Тогда
		Если УказанДокументОснование(КоличествоДокументовОснований) Тогда
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке(
				"Указан документ №" + КоличествоДокументовОснований + ", уменьшение количества документов невозможно!");
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "Регулирование" поля "КоличествоДокументовОснований".
Процедура СписокЛьготПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если Объект.Объект.Пустая() Тогда
		
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("Перед заполнением табличной части необходимо заполнить поле ""Объект"".");
		
	Иначе
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		НоваяСтрока = Объект.СписокЛьгот.Добавить();
		
		Если Копирование Тогда
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
			НоваяСтрока.Проживающий = ПредопределенноеЗначение("Справочник.УПЖКХ_Жильцы.ПустаяСсылка");
		Иначе
			НоваяСтрока.ДатаНачала = ?(ЗначениеЗаполнено(Объект.Дата),
										Объект.Дата, УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьРабочуюДату());
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" поля "ВидОперации".
Процедура ВидОперацииПриИзменении(Элемент)
	
	Если Объект.СписокЛьгот.Количество() > 0 Тогда
	
		ПоказатьВопрос(Новый ОписаниеОповещения("ВидОперацииПриИзмененииЗавершение", ЭтотОбъект),
					   "Перед сменой операции табличная часть будет очищена. Продолжить?",
					   РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры // ВидОперацииПриИзменении()

&НаКлиенте
// ОБработчи результата вопроса, вызванного в процедуре "ВидОперацииПриИзменении()".
Процедура ВидОперацииПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	УправлениеФормой(ЭтаФорма);
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	Объект.СписокЛьгот.Очистить();
	
КонецПроцедуры // ВидОперацииПриИзмененииЗавершение()

#КонецОбласти 

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	
	УПЖКХ_ТиповыеМетодыСервер.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ЧастоЗадаваемыеВопросы
&НаКлиенте
// Подключаемый обработчик команды перехода к часто задаваемым вопросам.
Процедура Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда)
	
	ОТР_ЧастоЗадаваемыеВопросыКлиент.Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда);
	
КонецПроцедуры
// Конец ЧастоЗадаваемыеВопросы

// СхемыУчета
&НаКлиенте
// Подключаемый обработчик команды перехода к схеме учета.
Процедура Подключаемый_ОткрытьСхемуУчета(Команда)
	
	ОТР_СхемыУчетаКлиент.Подключаемый_ОткрытьСхемуУчета(ЭтаФорма.ИмяФормы);
	
КонецПроцедуры
// Конец СхемыУчета

#КонецОбласти
