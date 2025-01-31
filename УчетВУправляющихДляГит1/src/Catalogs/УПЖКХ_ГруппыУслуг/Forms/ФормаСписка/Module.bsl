
#Область ПрочиеПроцедурыИФункции

&НаКлиенте
// Обновляет данные списка групп услуг.
Процедура ОбновитьДанныеСпискаГрупп()
	
	ТекущийВидГрупп = Элементы.Дерево.ТекущаяСтрока;
	
	// Установка отбора списка групп по текущему виду групп.
	УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Родитель", ТекущийВидГрупп);
	
	// Обновление заголовка списка групп.
	Элементы.ГруппаГруппыУслуг.Заголовок = "Группы услуг вида """ + ?(ТекущийВидГрупп = Неопределено, "<не определен>", ТекущийВидГрупп) + """";
	
КонецПроцедуры

&НаКлиенте
// Процедура открывает форму нового вида групп.
Процедура ОткрытьФормуНовогоВидаГрупп()
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Родитель", ПредопределенноеЗначение("Справочник.УПЖКХ_ГруппыУслуг.ПустаяСсылка"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ПараметрыФормы.Вставить("ЭтоГруппа",          Истина);
	
	ОткрытьФорму("Справочник.УПЖКХ_ГруппыУслуг.ФормаГруппы", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ОбщиеМеханизмыИКоманды
	ОТР_ПодключаемыеОбщиеМеханизмыИКоманды.ПриСозданииНаСервере(ЭтаФорма, Элементы.СписокКоманднаяПанель);
	// Конец ОбщиеМеханизмыИКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Обработчик события "ПриАктивизацииСтроки" поля "Дерево".
Процедура ДеревоПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьДанныеСпискаГрупп", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПередНачаломДобавления" поля "Дерево".
Процедура ДеревоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	// Создание нового вида групп выполняется индивидуально.
	Отказ = Истина;
	ОткрытьФормуНовогоВидаГрупп();
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПередНачаломДобавления" таблицы "Список".
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	// Проверим, выполняется ли создание элемента на первом уровне.
	ТекущийВидГрупп = Элементы.Дерево.ТекущаяСтрока;
	Если ТекущийВидГрупп = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru='Для создания группы услуг необходимо определить вид групп услуг!'"));
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Обработчик команды "СоздатьВидГруппУслуг".
Процедура СоздатьВидГруппУслуг(Команда)
	
	ОткрытьФормуНовогоВидаГрупп();
	
КонецПроцедуры

// ЧастоЗадаваемыеВопросы
&НаКлиенте
// Подключаемый обработчик команды перехода к часто задаваемым вопросам.
Процедура Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда)
	
	ОТР_ЧастоЗадаваемыеВопросыКлиент.Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда);
	
КонецПроцедуры
// Конец ЧастоЗадаваемыеВопросы

#КонецОбласти
