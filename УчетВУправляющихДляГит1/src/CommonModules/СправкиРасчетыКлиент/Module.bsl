#Область ПрограммныйИнтерфейс

// Формирует (выводит пользователю) преднастроенную справку-расчет с данными за месяц.
//
// Параметры:
//  ИмяОтчета	 - Строка - Имя формируемого отчета.
//  Месяц		 - Дата - Любая дата, относящаяся к месяцу, за который нужно сформировать отчет.
//  Организация	 - СправочникСсылка.Организации - Организация, по которой нужно сформировать отчет.
//  ВидРегламентнойОперации 
//               - ПеречислениеСсылка.ВидыРегламентныхОпераций - Вид регламентной операции, с которой связана команда,
//                 открывающая отчет.
//  Владелец     - УправляемаяФорма, ГруппаФормы, ТаблицаФормы, ПолеФормы, КнопкаФормы - Владелец открываемой формы.
//
Процедура СформироватьОтчетПоРезультатамМесяца(ИмяОтчета, Месяц, Организация, ВидРегламентнойОперации, Владелец) Экспорт
	
	ИмяФормы = "Отчет." + ИмяОтчета + ".Форма";
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СформироватьПриОткрытии",     Истина);
	// Текущие настройки не используются, так как определяются не предыдущим опытом использования отчета,
	// а контекстом, из которого он вызван (параметрами, переданными ниже).
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "РегламентнаяОперация");
	
	// Контекст использования
	ПараметрыФормы.Вставить("Организация",             Организация);
	ПараметрыФормы.Вставить("НачалоПериода",           НачалоМесяца(Месяц));
	ПараметрыФормы.Вставить("КонецПериода",            КонецМесяца(Месяц));
	Если ЗначениеЗаполнено(ВидРегламентнойОперации) Тогда
		ПараметрыФормы.Вставить("ВидРегламентнойОперации", ВидРегламентнойОперации);
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормы, ПараметрыФормы, Владелец, Истина);
	// Поиск формы по ключу уникальности не выполняется,
	// так как после открытия формы пользователь может поменять реквизиты контекста - 
	// то есть, для него эта форма уже не будет как-либо связана с регламентной операцией
	// и ее переформирование может оказаться неожиданным.
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытийФормы // включая события элементов формы и обработчики команд

Процедура НачатьВыборПериода(Форма, СтандартнаяОбработка, ОбработчикНастроитьЭлементИнформацияНалоговыйПериод) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ПериодНачатьВыбор(Форма, ОбработчикНастроитьЭлементИнформацияНалоговыйПериод);
	
КонецПроцедуры

Процедура НачатьВыборИнтервала(Форма, ОбработчикВыбора) Экспорт
	
	// По аналогии с ПериодНачатьВыбор, однако используется другая форма и обработка выбора реализована непосредственно в форме
	
	БазовыеРеквизиты = СправкиРасчетыКлиентСервер.БазовыеРеквизиты(Форма);
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("НачалоПериода",    БазовыеРеквизиты.НачалоПериода);
	ПараметрыВыбора.Вставить("КонецПериода",     БазовыеРеквизиты.КонецПериода);
	ПараметрыВыбора.Вставить("ОграничениеСнизу", Форма.ДатаРегистрацииОрганизации);
	ПараметрыВыбора.Вставить("Кратность",        ПредопределенноеЗначение("Перечисление.Периодичность.Месяц"));
	
	ОткрытьФорму(
		"ОбщаяФорма.ВыборСтандартногоПериода",
		ПараметрыВыбора,
		Форма,
		, // Уникальность
		, // Окно
		, // НавигационнаяСсылка
		ОбработчикВыбора);
	
КонецПроцедуры

Процедура УстановитьТекущийПериод(Форма, СтандартнаяОбработка, ОбработчикНастроитьЭлементИнформацияНалоговыйПериод) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ИзменениеПериодаМесяц(Форма, ТекущаяДата(), ОбработчикНастроитьЭлементИнформацияНалоговыйПериод);
	
КонецПроцедуры

Процедура СНачалаГодаПриИзменении(Форма, ОбработчикНастроитьЭлементИнформацияНалоговыйПериод) Экспорт
	
	СправкиРасчетыКлиентСервер.ОтметитьОтчетНеАктуальный(Форма);
	
	НастроитьПериодМесяц(Форма, ОбработчикНастроитьЭлементИнформацияНалоговыйПериод);
	
КонецПроцедуры

Функция НастроитьПериодИнтервал(Форма, ЦелыйИнтервал = Неопределено) Экспорт
	
	// возвращаемое значение определяет,
	// требуется ли передача управления на сервер и вызов СправкиРасчеты.НастроитьЭлементИнформацияНалоговыйПериод()
			
	// Определим начало периода отчета.
	ИнформацияНалоговыйПериод = СправкиРасчетыКлиентСервер.ОпределитьПериодОтчета(Форма, ЦелыйИнтервал);
	
	// Отобразим информацию о налоговом периоде
	УдалосьНастроитьНаКлиенте = ИнформированиеНалоговыйПериодКлиент.НастроитьЭлементИнформацияНалоговыйПериод(
		Форма.Элементы,
		ИнформацияНалоговыйПериод);
		
	Если УдалосьНастроитьНаКлиенте Тогда
		Возврат Неопределено;
	Иначе
		Возврат ИнформацияНалоговыйПериод;
		// требуется передача управления на сервер и вызов ИнформированиеНалоговыйПериод.НастроитьЭлементИнформирования
	КонецЕсли;
	
КонецФункции

// Вызывается из обработчика ПередЗакрытием.
//
Процедура ПередСохранениемНастроек(Форма) Экспорт
	
	ОтчетВызванИзКонтекста = ЗначениеЗаполнено(Форма.КлючНазначенияИспользования); // См. СформироватьОтчетПоРезультатамМесяца
	БухгалтерскиеОтчетыКлиент.ПередСохранениемНастроек(Форма, ОтчетВызванИзКонтекста);
		
КонецПроцедуры

#КонецОбласти

#Область ДлительныеОперации

// Для использования с актуальной версией API БСП.

Процедура НачатьОжиданиеФормированияОтчетаПриОткрытии(Форма, ОповещениеЗакончитьФормированиеОтчета) Экспорт
	
	// При инициализации формы могло быть запущено фоновое задание, информация о котором записана в реквизит формы
	// - см. СправкиРасчеты.ИнициализироватьФорму.
	НачатьОжиданиеФормированияОтчета(Форма, Форма.ДлительнаяОперацияПриОткрытии, ОповещениеЗакончитьФормированиеОтчета);
	
КонецПроцедуры

// Начинает ожидание формирования отчета.
//
// Параметры:
//  Форма								  - УправляемаяФорма - форма отчета.
//  ДлительнаяОперация					  - Структура    - результат запуска не завершенной длительной операции, см. ДлительныеОперации.ВыполнитьВФоне.
//                                        - Неопределено - длительная операция уже завершена, ожидание не требуется.
//  ОповещениеЗавершитьФормированиеОтчета - ОписаниеОповещения - описание оповещения в форме отчета,
//                                          передающего управление на сервер для вызова СправкиРасчеты.ЗавершитьФормированиеОтчета.
//
Процедура НачатьОжиданиеФормированияОтчета(Форма, ДлительнаяОперация, ОповещениеЗавершитьФормированиеОтчета) Экспорт
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Форма.Элементы.Результат, "ФормированиеОтчета");
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ЗакончитьОжиданиеФормированияОтчета",
		ЭтотОбъект,
		ОповещениеЗавершитьФормированиеОтчета);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
	// См. далее ЗакончитьОжиданиеФормированияОтчета
	
КонецПроцедуры

Процедура ЗакончитьОжиданиеФормированияОтчета(РезультатОжидания, ОповещениеЗавершитьФормированиеОтчета) Экспорт // обработчик оповещения
	
	Форма = ОповещениеЗавершитьФормированиеОтчета.Модуль;
	
	Если Не СправкиРасчетыКлиентСервер.ЗавершитьФормированиеОтчета(Форма, РезультатОжидания) Тогда
		// по каким-то причинам показывать нечего; это обработано на клиенте
		Возврат;
	КонецЕсли;
	
	// Для оптимизации клиент-серверного взаимодействия, если есть данные для отображения,
	// то действия с ними выполняем в контекстном серверном вызове.
	// Обработчик оповещения передает управление на сервер и вызывает там СправкиРасчеты.ЗавершитьФормированиеОтчета().
	ВыполнитьОбработкуОповещения(ОповещениеЗавершитьФормированиеОтчета, РезультатОжидания.АдресРезультата);
	
	// См. далее СправкиРасчеты.ЗавершитьФормированиеОтчета().
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область НалоговыйПериод

Процедура ПериодНачатьВыбор(Форма, ОбработчикНастроитьЭлементИнформацияНалоговыйПериод)
	
	БазовыеРеквизиты = СправкиРасчетыКлиентСервер.БазовыеРеквизиты(Форма);
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("НачалоПериода",    БазовыеРеквизиты.НачалоПериода);
	ПараметрыВыбора.Вставить("КонецПериода",     БазовыеРеквизиты.КонецПериода);
	ПараметрыВыбора.Вставить("ВидПериода",       СправкиРасчетыКлиентСервер.ВидПериодаМесяц());
	ПараметрыВыбора.Вставить("ОграничениеСнизу", Форма.ДатаРегистрацииОрганизации);
	
	ПараметрыОбработчика = ПараметрыОбработчикаВыборПериода(
		Форма,
		ОбработчикНастроитьЭлементИнформацияНалоговыйПериод);
	
	ОткрытьФорму(
		"ОбщаяФорма.ВыборСтандартногоПериодаМесяц",
		ПараметрыВыбора,
		Форма,
		, // Уникальность
		, // Окно
		, // НавигационнаяСсылка
		Новый ОписаниеОповещения("ВыборПериода", СправкиРасчетыКлиент, ПараметрыОбработчика));
	
	// См. далее ВыборПериода()
	
КонецПроцедуры

Процедура ВыборПериода(РезультатВыбора, ПараметрыОбработчика) Экспорт // Обработчик оповещения
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Фактически, результат выбора периода - это одна дата. Обработаем ее.
	ИзменениеПериодаМесяц(
		ПараметрыОбработчика.Форма,
		РезультатВыбора.КонецПериода,
		ПараметрыОбработчика.ОбработчикНастроитьЭлементИнформацияНалоговыйПериод);
	
КонецПроцедуры

Функция ПараметрыОбработчикаВыборПериода(Форма, ОбработчикНастроитьЭлементИнформацияНалоговыйПериод)
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Форма", Форма);
	ПараметрыОбработчика.Вставить(
		"ОбработчикНастроитьЭлементИнформацияНалоговыйПериод",
		ОбработчикНастроитьЭлементИнформацияНалоговыйПериод);
		
	Возврат ПараметрыОбработчика;
	
КонецФункции

Процедура ИзменениеПериодаМесяц(Форма, Период, ОбработчикНастроитьЭлементИнформацияНалоговыйПериод)
	
	СправкиРасчетыКлиентСервер.ОтметитьОтчетНеАктуальный(Форма);
	
	БазовыеРеквизиты = СправкиРасчетыКлиентСервер.БазовыеРеквизиты(Форма);
	БазовыеРеквизиты.КонецПериода = КонецМесяца(Период);
	
	СправкиРасчетыКлиентСервер.НастроитьДиалогВыбораПериода(Форма);
	
	// Настроим период, определяемый двумя датами.
	НастроитьПериодМесяц(Форма, ОбработчикНастроитьЭлементИнформацияНалоговыйПериод);
	
КонецПроцедуры

Процедура НастроитьПериодМесяц(Форма, ОбработчикНастроитьЭлементИнформацияНалоговыйПериод)
	
	ИнформацияНалоговыйПериодДляПередачиНаСервер = НастроитьПериодИнтервал(Форма);
	
	Если ИнформацияНалоговыйПериодДляПередачиНаСервер = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	// передает управление на сервер и вызывает там СправкиРасчеты.НастроитьЭлементИнформацияНалоговыйПериод()
	ВыполнитьОбработкуОповещения(ОбработчикНастроитьЭлементИнформацияНалоговыйПериод, ИнформацияНалоговыйПериодДляПередачиНаСервер);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
