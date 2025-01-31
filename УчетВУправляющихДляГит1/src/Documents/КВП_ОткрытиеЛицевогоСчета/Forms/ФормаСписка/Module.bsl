
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Обработчик события "ПередНачаломДобавления" поля "Список".
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если Копирование И Не Элемент.ТекущиеДанные = Неопределено Тогда
		
		Адрес = УПЖКХ_ОбщегоНазначенияСервер.ПолучитьЗначениеРеквизита(Элемент.ТекущиеДанные.ЛицевойСчет, "Адрес");
		Здание = УПЖКХ_ОбщегоНазначенияСервер.ПолучитьЗначениеРеквизита(Адрес, "Владелец");
		
		СтруктураДанных = Новый Структура;
		СтруктураДанных.Вставить("ШаблонЛС", Элемент.ТекущиеДанные.ЛицевойСчет);
		СтруктураДанных.Вставить("Здание",   Здание);
		
	Иначе
		СтруктураДанных = Неопределено;
	КонецЕсли;
	
	УПЖКХ_РаботаСЛицевымиСчетамиКлиент.ОткрытиеЛицевогоСчета(СтруктураДанных);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Обработчик команды "ОткрытьЛС".
Процедура ОткрытьЛС(Команда)
	
	УПЖКХ_РаботаСЛицевымиСчетамиКлиент.ОткрытиеЛицевогоСчета();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	
	УПЖКХ_ТиповыеМетодыСервер.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
	
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

#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	УПЖКХ_ТиповыеМетодыСервер.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ОбщиеМеханизмыИКоманды
	ОТР_ПодключаемыеОбщиеМеханизмыИКоманды.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ОбщиеМеханизмыИКоманды
	
КонецПроцедуры

#КонецОбласти