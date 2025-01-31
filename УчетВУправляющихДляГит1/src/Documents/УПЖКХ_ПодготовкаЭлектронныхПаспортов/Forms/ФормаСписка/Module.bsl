
//////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтборПериодСбораДанных = ТекущаяДата();
	
	// ОбщиеМеханизмыИКоманды
	ОТР_ПодключаемыеОбщиеМеханизмыИКоманды.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ОбщиеМеханизмыИКоманды
	
	// Реклама
	ОТР_РекламаКлиентСервер.ПриСозданииНаСервере(ЭтаФорма);
	// Конец Реклама
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

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
// Обработчик события "ПриИзменении" поля отбора периода.
//
Процедура ОтборПериодСбораДанныхСтрокаПриИзменении(Элемент)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "ОтборПериодСбораДанных", "ОтборПериодСбораДанныхСтрока", 
														Модифицированность);
	
	УстановитьОтборЭлектронныхПаспортов();
	
КонецПроцедуры // ОтборПериодСбораДанныхСтрокаПриИзменении()

&НаКлиенте
// Обработчик события "НачалоВыбораИз" поля отбора периода.
//
Процедура ОтборПериодСбораДанныхСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОповещениеЗавершения = Новый ОписаниеОповещения("ОтборПериодСбораДанныхСтрокаНачалоВыбораЗавершение", ЭтаФорма);
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "ОтборПериодСбораДанных", "ОтборПериодСбораДанныхСтрока", , ОповещениеЗавершения);
	
КонецПроцедуры // ОтборПериодСбораДанныхСтрокаНачалоВыбора()

&НаКлиенте
// Обработчик события "Регулирование" поля отбора периода.
//
Процедура ОтборПериодСбораДанныхСтрокаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "ОтборПериодСбораДанных", "ОтборПериодСбораДанныхСтрока", Направление,
														Модифицированность);
	
	УстановитьОтборЭлектронныхПаспортов();
	
КонецПроцедуры // ОтборПериодСбораДанныхСтрокаПриИзменении()

&НаКлиенте
// Обработчик события "АвтоПодбор" поля отбора периода.
//
Процедура ОтборПериодСбораДанныхСтрокаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
	УстановитьОтборЭлектронныхПаспортов();
	
КонецПроцедуры // ОтборПериодСбораДанныхСтрокаАвтоПодбор()

&НаКлиенте
// Обработчик события "ОкончаниеВводаТекста" поля отбора периода.
//
Процедура ОтборПериодСбораДанныхСтрокаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
	УстановитьОтборЭлектронныхПаспортов();
	
КонецПроцедуры // ОтборПериодСбораДанныхСтрокаОкончаниеВводаТекста()

&НаКлиенте
// Обработчик события "ПриИзменении" поля отбора организации.
//
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	УстановитьОтборЭлектронныхПаспортов();
	
КонецПроцедуры // ОтборОрганизацияПриИзменении()

&НаКлиенте
// Обработчик события "ПриИзменении" поля отбора вида здания.
//
Процедура ОтборВидЗданияПриИзменении(Элемент)
	
	УстановитьОтборЭлектронныхПаспортов();
	
КонецПроцедуры // ОтборВидЗданияПриИзменении()

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД

#Область ОбработчикиКомандФормы

&НаКлиенте
// Обработчик команды "СформироватьПаспорта".
//
Процедура СформироватьПаспорта(Команда)
	
	СформироватьЭлектронныеПаспорта();
	
КонецПроцедуры // СформироватьПаспорта()

&НаКлиенте
// Обработчик команды "СформироватьПаспорта".
//
Процедура ОткрытьФормуНастроек(Команда)
	
	ОткрытьФорму("РегистрСведений.УПЖКХ_НастройкиЭлектронныхПаспортов.ФормаСписка");
	
КонецПроцедуры // ОткрытьФормуНастроек()

&НаКлиенте
// Формирует паспорта и помещает их в архив.
//
Процедура СформироватьПаспортаИПоместитьВАрхив(Команда)
	
	СформироватьЭлектронныеПаспорта(Истина);
	
КонецПроцедуры // СформироватьПаспортаИПоместитьВАрхив()

&НаКлиенте
// Отправляет электронные паспорта на сайт.
//
Процедура ОтправитьНаСайт(Команда)
	
	МассивДокументов = Элементы.Список.ВыделенныеСтроки;
	
	СформироватьТаблицуНастроекНаСервере(МассивДокументов);
	
	Если ТаблицаПаролей.Количество() = 0 Тогда
		ВыполнитьВыгрузкуДанныхНаСервере();
	Иначе
		ЗапроситьПаролиДоступаНаСайтНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры // ОтправитьНаСайт()

// ЧастоЗадаваемыеВопросы
&НаКлиенте
// Подключаемый обработчик команды перехода к часто задаваемым вопросам.
Процедура Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда)
	
	ОТР_ЧастоЗадаваемыеВопросыКлиент.Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда);
	
КонецПроцедуры
// Конец ЧастоЗадаваемыеВопросы

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЧИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область ПрочиеПроцедурыИФункции

&НаКлиенте
// Устанавливает отбор документов в соответствии с настройками отбора, указанными на форме.
//
Процедура УстановитьОтборЭлектронныхПаспортов()
	
	Список.Отбор.Элементы.Очистить();
	
	Если Не ОтборОрганизация = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка") Тогда
        Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
        Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
        Отбор.ПравоеЗначение = ОтборОрганизация;
        Отбор.Использование = Истина;
        Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
	КонецЕсли;
	
	Если Не ОтборВидЗдания = ПредопределенноеЗначение("Перечисление.УПЖКХ_ВидыЗданий.ПустаяСсылка") Тогда
        Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
        Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
        Отбор.ПравоеЗначение = ОтборВидЗдания;
        Отбор.Использование = Истина;
        Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидЗдания");
	КонецЕсли;
	
	Если Не ПустаяСтрока(ОтборПериодСбораДанныхСтрока) Тогда
        Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
        Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
        Отбор.ПравоеЗначение = ОтборПериодСбораДанныхСтрока;
        Отбор.Использование = Истина;
        Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПериодСбораДанныхСтрокой");
	КонецЕсли;
	
КонецПроцедуры // УстановитьОтборЭлектронныхПаспортов()

&НаКлиенте
// Обработчик оповещения о закрытии формы выбора периода.
Процедура ОтборПериодСбораДанныхСтрокаНачалоВыбораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	УстановитьОтборЭлектронныхПаспортов();
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ВЫГРУЗКИ НА САЙТ

#Область ПроцедурыВыгрузкиНаСайт

&НаСервере
// Формирует таблицу настроек.
//
Процедура СформироватьТаблицуНастроекНаСервере(МассивДокументов)
	
	ТаблицаНастроек          = УПЖКХ_РаскрытиеИнформацииСервер.ПолучитьТаблицуНастроекОтправкиПаспортовНаСайт(МассивДокументов);
	ТаблицаНастроекХранилище = Новый ХранилищеЗначения(ТаблицаНастроек);
	
	СтрокиПаролей = ТаблицаНастроек.НайтиСтроки(Новый Структура("ХранитьПароль, МожноОтправитьНаСайт", Ложь, Истина));
	
	ТаблицаПаролей.Очистить();
	
	Для Каждого СтрокаПароля ИЗ СтрокиПаролей Цикл
		НоваяСтрока = ТаблицаПаролей.Добавить();
		НоваяСтрока.Организация             = СтрокаПароля.Организация;
		НоваяСтрока.НаименованиеОрганизации = СтрокаПароля.НаименованиеОрганизации;
	КонецЦикла;
	
КонецПроцедуры // СформироватьТаблицуНастроекНаСервере()

&НаКлиенте
// Запрашивает пароли доступа на сайт.
//
Процедура ЗапроситьПаролиДоступаНаСайтНаКлиенте(Счетчик = 0)
	
	ПолучитьПарольДоступаНаСайт(Счетчик);
	
КонецПроцедуры // ЗапроситьПаролиДоступаНаСайт()

&НаКлиенте
// Получает пароль доступа на сайт.
//
Процедура ПолучитьПарольДоступаНаСайт(Счетчик)
	
	ТекущаяСтрока = ТаблицаПаролей.Получить(Счетчик);
	
	ДополнительныеПараметры = Новый Структура("ТекущаяСтрока, Счетчик", ТекущаяСтрока, Счетчик);
	
	ФормаВводаПароля = ПолучитьФорму("ОбщаяФорма.УПЖКХ_ВебИнтеграцияВводПароля");
	ФормаВводаПароля.ОписаниеОповещенияОЗакрытии   = Новый ОписаниеОповещения("ПолучитьПарольДоступа", ЭтаФорма, ДополнительныеПараметры);
	ФормаВводаПароля.Заголовок                     = "Введите пароль доступа к сайту для " + ТекущаяСтрока.НаименованиеОрганизации;
	ФормаВводаПароля.ВладелецФормы                 = ЭтаФорма;
	ФормаВводаПароля.ЗакрыватьПриЗакрытииВладельца = Истина;
	ФормаВводаПароля.РежимОткрытияОкна             = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ФормаВводаПароля.Открыть();
	
КонецПроцедуры // ПолучитьПарольДоступаНаСайт()

&НаКлиенте
// Открывает форму для ввода пароля.
//
Функция ПолучитьПарольДоступа(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.ТекущаяСтрока.Пароль = РезультатЗакрытия;
	
	Если ДополнительныеПараметры.Счетчик = ТаблицаПаролей.Количество() - 1 Тогда
		ВыполнитьВыгрузкуДанныхНаСервере();
	Иначе
		ПолучитьПарольДоступаНаСайт(ДополнительныеПараметры.Счетчик + 1);
	КонецЕсли;
	
КонецФункции // ПолучитьПарольДоступа()

&НаСервере
// Выполняет выгрузку данных.
//
Процедура ВыполнитьВыгрузкуДанныхНаСервере()
	
	ТаблицаНастроек = ТаблицаНастроекХранилище.Получить();
	
	Если Не ТаблицаНастроек.Количество() = 0 Тогда
		Для Каждого СтрокаПароля ИЗ ТаблицаПаролей Цикл
			СтрокиТекПароля = ТаблицаНастроек.НайтиСтроки(Новый Структура("Организация", СтрокаПароля.Организация));
			
			Для Каждого СтрокаТекПароля ИЗ СтрокиТекПароля Цикл
				СтрокаТекПароля.Пароль = СтрокаПароля.Пароль;
			КонецЦикла;
		КонецЦикла;
		
		УПЖКХ_ВебИнтеграцияОбщегоНазначения.ВыполнитьВыгрузкуЭлектронныхПаспортовПоТаблицеНастроек(ТаблицаНастроек);
		
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьВыгрузкуДанныхНаСервере()

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ЭЛЕКТРОННЫХ ПАСПОРТОВ

#Область ПроцедурыФормированияЭлектронныхПаспортов

&НаКлиенте
// Вызывает процедуру формирования паспортов.
//
// Параметры:
//  ПодписьИОтправка - Булево - признак того, что паспорта надо подписать и отправить в орган мест. самоуправ
//  ПомещениеВАрхив - Булево - признак того, что паспорта надо поместить в архив.
//
Процедура СформироватьЭлектронныеПаспорта(ПомещениеВАрхив = Ложь)
	
	МассивДокументов = Элементы.Список.ВыделенныеСтроки;
	
	// Формирование паспортов
	Если Не МассивДокументов.Количество() = 0 Тогда
		СчетчикСформированныхДокументов = 0;
		
		СформироватьXMLФайлыНаСервере(МассивДокументов, ПомещениеВАрхив, СчетчикСформированныхДокументов);
		
		Если СчетчикСформированныхДокументов = 0 Тогда
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю("Электронные паспорта не сформированы");
		Иначе
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю("Сформированы электронные паспорта для " + СчетчикСформированныхДокументов + " зданий.");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // СформироватьЭлектронныеПаспорта()

&НаСервере
// Формирует электронные паспорта.
//
// Параметры:
//  МассивДокументов - Массив - масси документов, для которых надо сформировать электронные паспорта
//  ПодписьИОтправка - Булево - факт того, что электронные паспорта надо подписывать и отправлять по почте
//  ПомещениеВАрхив - Булево - факт того, что электронные паспорта надо помещать в архив
//  СчетчикСформированныхДокументов - Число - счетчик документов, для которых удалось сформировать электронные паспорта
//  СчетчикОтправленныхДокументов - Число - счетчик электронных паспортов, которые удалось отправить почтой.
//
Процедура СформироватьXMLФайлыНаСервере(МассивДокументов, ПомещениеВАрхив, СчетчикСформированныхДокументов)
	
	УПЖКХ_РаскрытиеИнформацииСервер.СформироватьXMLФайлы(МассивДокументов, ПомещениеВАрхив, СчетчикСформированныхДокументов);
	
КонецПроцедуры // СформироватьXMLФайлыНаСервере()

#КонецОбласти

