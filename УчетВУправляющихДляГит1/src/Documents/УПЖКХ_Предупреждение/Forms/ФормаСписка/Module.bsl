#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	УПЖКХ_ТиповыеМетодыСервер.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОтборОрганизация = УПЖКХ_ТиповыеМетодыВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
	
	// ОбщиеМеханизмыИКоманды
	ОТР_ПодключаемыеОбщиеМеханизмыИКоманды.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ОбщиеМеханизмыИКоманды
	
	// Реклама
	ОТР_РекламаКлиентСервер.ПриСозданииНаСервере(ЭтаФорма);
	// Конец Реклама
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#Область Реклама

&НаКлиенте
// Процедура - обработчик нажатия на картинку баннера.
Процедура Подключаемый_РекламаОткрытьСтраницуСайта(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОТР_РекламаКлиент.Подключаемый_РекламаОткрытьСтраницуСайта(ЭтаФорма);
	
КонецПроцедуры // Подключаемый_РекламаОткрытьСтраницуСайта()

&НаКлиенте
// Процедура - обработчик нажатия на картинку закрытия баннера.
Процедура Подключаемый_РекламаКартникаЗакрытияБаннераНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ОТР_РекламаКлиент.Подключаемый_РекламаКартникаЗакрытияБаннераНажатие(ЭтаФорма);
	
КонецПроцедуры // Подключаемый_РекламаОткрытьСтраницуСайта()

#КонецОбласти // Реклама

&НаКлиенте
// Обработчик события "ПриИзменении" поля "ОтборОрганизация".
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация",
																ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));
	
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

#КонецОбласти

#Область ОбработчикиКомандФормы

// ЧастоЗадаваемыеВопросы
&НаКлиенте
// Подключаемый обработчик команды перехода к часто задаваемым вопросам.
Процедура Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда)
	
	ОТР_ЧастоЗадаваемыеВопросыКлиент.Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда);
	
КонецПроцедуры
// Конец ЧастоЗадаваемыеВопросы

#КонецОбласти
