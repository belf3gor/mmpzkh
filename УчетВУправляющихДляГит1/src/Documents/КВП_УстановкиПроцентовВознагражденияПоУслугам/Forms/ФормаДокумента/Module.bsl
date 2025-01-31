
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриЧтенииНаСервере" формы.
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УПЖКХ_ТиповыеМетодыСервер.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
// Процедура - обработчик события "ПриСозданииНаСервере" формы.
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	УПЖКХ_ТиповыеМетодыСервер.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Устанавливаем значение по умолчанию.
	Если Объект.Ссылка.Пустая() Тогда
		УПЖКХ_ЗаполнениеДокументовСервер.ЗаполнитьШапкуДокумента(Объект,
																	УПЖКХ_ТиповыеМетодыКлиентСервер.ТекущийПользователь());
	КонецЕсли;
	
	// Установить доступность формы с учетом ключа СЛК.
	СЗК_МодульЗащитыКлиентСервер.УстановитьДоступностьФормыДляРедактирования(ЭтаФорма);
	
	// ОбщиеМеханизмыИКоманды
	ОТР_ПодключаемыеОбщиеМеханизмыИКоманды.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ОбщиеМеханизмыИКоманды
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Обработчик события "ПриИзменении" поля "Дата".
Процедура ДатаПриИзменении(Элемент)
	
	УПЖКХ_РаботаСДиалогамиКлиентСервер.ПроверитьНомерДокумента(Объект, Объект.Дата);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийТабличнойЧастиУслуги

&НаКлиенте
// Обработчик события "ПриНачалеРедактирования" поля "Услуги".
Процедура УслугиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	СтрокаТабличнойЧасти = Элемент.ТекущиеДанные;
	Если НоваяСтрока И НЕ СтрокаТабличнойЧасти = Неопределено Тогда
		СтрокаТабличнойЧасти.СпособРасчета = ПредопределенноеЗначение(
												"Перечисление.КВП_СпособРасчетаВознагражденияСоСборов.Простой");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" поля "УслугиВидыУслуг".
Процедура УслугиВидыУслугПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ТекущиеДанные.ВидыУслуг = УПЖКХ_ОбщегоНазначенияСервер.ПолучитьЗначениеРеквизита(
										ТекущиеДанные.Услуга, "ВидУслуги") Тогда
		
		ТекущиеДанные.Услуга = ПредопределенноеЗначение("Справочник.КВП_Услуги.ПустаяСсылка");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "НачалоВыбора" поля "УслугиУслуга".
Процедура УслугиУслугаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ВидыУслуг) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("ВидУслуги", ТекущиеДанные.ВидыУслуг);
		
		ФормаВыбораУслуги = ПолучитьФорму("Справочник.КВП_Услуги.ФормаВыбора",
											Новый Структура("ЭтоГруппа, Отбор", Ложь, СтруктураОтбора), Элемент);
		
		ФормаВыбораУслуги.Элементы.Список.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Элементы;
		ФормаВыбораУслуги.Параметры.ОтображатьСписком = Истина;
		
		ФормаВыбораУслуги.Открыть();
		
	КонецЕсли;
	
КонецПроцедуры

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

#КонецОбласти 
