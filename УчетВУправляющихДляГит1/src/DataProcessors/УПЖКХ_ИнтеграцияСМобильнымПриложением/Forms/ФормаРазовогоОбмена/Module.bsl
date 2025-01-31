
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик "ПриСозданииНаСервере" формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициализацияРеквизитов();
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
// Обработчик "ОбработкаОповещения" формы.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ЭтаФорма.Активизировать();
	
	// Заполнение ТЧ.
	Если ИмяСобытия = "ПередачаТЗ" Тогда
		
		АдресВХранилище = Параметр;
		МассивЛС        = ПолучитьИзВременногоХранилища(АдресВХранилище);
		
		Для каждого ТекСтрока из МассивЛС Цикл
			
			НоваяСтрока = ЛицевыеСчета.Добавить();
			НоваяСтрока.ЛицевойСчет = ТекСтрока;
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБЩЕГО НАЗНАЧЕНИЯ

#Область ПроцедурыОбщегоНазначения

&НаСервере
// Инициализирует реквизиты.
//
Процедура ИнициализацияРеквизитов()
	
	// Настройки по умолчанию.
	ВидПериодаРазовогоОбмена    = 0;
	МесяцОбмена                 = ТекущаяДата();
	ВыгружатьСведенияПоЛС       = Истина;
	УказатьЛицевыеСчета         = Ложь;
	ЗагружатьПоказанияСчетчиков = Истина;
	ЗагружатьОплаты             = Истина;
	
	МесяцОбменаСтрока = Формат(МесяцОбмена, "ДФ='MMMM yyyy'");
	
	СтруктураНастроекОбмена = УПЖКХ_ИнтеграцияСМобильнымПриложениемВзаимодействиеСБазой.ПолучитьНастройкуАвтоматическогоОбменаСМобильнымПриложением();
	
	Если СтруктураНастроекОбмена.Свойство("НастройкаФормированияДанных") Тогда
		НастройкаФормированияДанных = СтруктураНастроекОбмена.НастройкаФормированияДанных;
	Иначе
		
		ВыгружатьСведенияПоЛС                         = Ложь;
		Элементы.ВидПериодаРазовогоОбмена.Доступность = Ложь;
		Элементы.ВыгружатьСведенияПоЛС.Доступность    = Ложь;
		
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю("Не выбрана настройка сбора данных. Функционал выгрузки данных по лицевым счетам в мобильное приложение не будет доступен.
															|Для указания настройки перейдите на форму ""Настроек обмена данными с мобильным приложением"".");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Устанавливает видимость элементов формы.
//
Процедура УстановитьВидимость()
	
	УправлениеВидимостьюКнопкиПодбораЛС();
	
	Если ВидПериодаРазовогоОбмена = 0 Тогда
		Элементы.МесяцОбменаСтрока.Видимость             = Ложь;
		Элементы.ЗагружатьПоказанияСчетчиков.Видимость   = Истина;
		Элементы.ЗагружатьОплаты.Видимость               = Истина;
		Элементы.НадписьОписаниеВыбранныйМесяц.Видимость = Ложь;
		Элементы.НадписьОписаниеТекущийМесяц.Видимость   = Истина;
	Иначе
		Элементы.МесяцОбменаСтрока.Видимость             = Истина;
		Элементы.ЗагружатьПоказанияСчетчиков.Видимость   = Ложь;
		Элементы.ЗагружатьОплаты.Видимость               = Ложь;
		Элементы.НадписьОписаниеВыбранныйМесяц.Видимость = Истина;
		Элементы.НадписьОписаниеТекущийМесяц.Видимость   = Ложь;
	КонецЕсли;
	
	Если ВыгружатьСведенияПоЛС Тогда
		Элементы.УказатьЛицевыеСчета.Видимость  = Истина;
		Если УказатьЛицевыеСчета = 0 Тогда
			Элементы.ТаблицаЛицевыхСчетов.Видимость = Ложь;
		Иначе
			Элементы.ТаблицаЛицевыхСчетов.Видимость = Истина;
		КонецЕсли;
	Иначе
		Элементы.УказатьЛицевыеСчета.Видимость  = Ложь;
		Элементы.ТаблицаЛицевыхСчетов.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Анализирует наличие формы подбора объектов в составе конфигурации.
// Если ее нет, не выводить соответствующую кнопку в командной панели таблицы.
//
Процедура УправлениеВидимостьюКнопкиПодбораЛС()
	
	Если НЕ Метаданные.ОбщиеФормы.Найти("УПЖКХ_ПодборОбъектов") = Неопределено Тогда
		ПутьКФормеПодбора = "ОбщаяФорма.УПЖКХ_ПодборОбъектов";
	ИначеЕсли НЕ Метаданные.Обработки.УПЖКХ_ИнтеграцияСМобильнымПриложением.Формы.Найти("ПодборОбъектов") = Неопределено Тогда
		ПутьКФормеПодбора = "Обработка.УПЖКХ_ИнтеграцияСМобильнымПриложением.Форма.ПодборОбъектов";
	Иначе
		ПутьКФормеПодбора = "";
	КонецЕсли;
	
	Если ПустаяСтрока(ПутьКФормеПодбора) Тогда
		Элементы.ТаблицаЛСКнопкаЗаполнитьСОтбором.Видимость = Ложь;
	Иначе
		Элементы.ТаблицаЛСКнопкаЗаполнитьСОтбором.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры // УправлениеВидимостьюКнопкиПодбораЛС()

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Обработчик события "ПриИзменении" поля "ВидПериодаРазовогоОбмена".
//
Процедура ВидПериодаРазовогоОбменаПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" флага "УказатьЛицевыеСчета".
//
Процедура УказатьЛицевыеСчетаПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" флага "ВыгружатьСведенияПоЛС".
//
Процедура ВыгружатьСведенияПоЛСПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
// Обработчик нажатия кнопки "ЗаполнитьСОтбором".
//
Процедура КомандаЗаполнитьСОтбором(Команда)
	
	Если ПустаяСтрока(ПутьКФормеПодбора) Тогда
		ОбработатьСообщенияОбОшибках("Форма подбора не найдена.");
		
		Возврат;
	КонецЕсли;
	
	Если ЛицевыеСчета.Количество() = 0 Тогда
		ОткрытьФорму(ПутьКФормеПодбора);
	Иначе
		ЗадатьВопросЕслиВТаблицеЛСЕстьДанные();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ОбработкаВыбора" колонки "ЛицевойСчет" таблицы лицевых счетов.
//
Процедура ТаблицаЛицевыхСчетовЛицевойСчетОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтрокиДубликаты = ЛицевыеСчета.НайтиСтроки(Новый Структура("ЛицевойСчет", ВыбранноеЗначение));
	
	Если НЕ СтрокиДубликаты.Количество() = 0 Тогда
		СтандартнаяОбработка = Ложь;
		ОбработатьСообщенияОбОшибках("Лицевой счет """ + Строка(ВыбранноеЗначение) + """ уже выбран.");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ "МЕСЯЦ ОБМЕНА"

#Область ОбработчикиСобытийПоляМесяцОбмена

&НаКлиенте
// Процедура - обработчик события "Регулирование" реквизита "МесяцОбменаСтрока".
//
Процедура МесяцОбменаСтрокаРегулирование(Элемент, Направление, СтандартнаяОбработка)

	МесяцОбмена       = ДобавитьМесяц(МесяцОбмена, Направление);
	МесяцОбменаСтрока = Формат(МесяцОбмена, "ДФ='MMMM yyyy'");
	
КонецПроцедуры // МесяцОбменаСтрокаРегулирование()

&НаКлиенте
// Процедура - обработчик события "ПриИзменении" реквизита "МесяцОбменаСтрока".
//
Процедура МесяцОбменаСтрокаПриИзменении(Элемент)
	
	УПЖКХ_РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПодобратьДатуПоТексту(МесяцОбменаСтрока, МесяцОбмена);
	МесяцОбменаСтрока = Формат(МесяцОбмена, "ДФ='MMMM yyyy'");
	
КонецПроцедуры // МесяцОбменаСтрокаПриИзменении()

&НаКлиенте
// Процедура - обработчик события "ОкончаниеВводаТекста" реквизита "МесяцОбменаСтрока".
//
Процедура МесяцОбменаСтрокаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	УПЖКХ_РаботаСДиалогамиКлиентСервер.ДатаКакМесяцОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры // МесяцОбменаСтрокаОкончаниеВводаТекста()

&НаКлиенте
// Процедура - обработчик события "АвтоПодбор" реквизита "МесяцОбменаСтрока".
//
Процедура МесяцОбменаСтрокаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	УПЖКХ_РаботаСДиалогамиКлиентСервер.ДатаКакМесяцАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры // МесяцОбменаСтрокаАвтоПодбор()

&НаКлиенте
// Процедура - обработчик события "НачалоВыбора" реквизита "МесяцОбменаСтрока".
//
Процедура МесяцОбменаСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	КВП_РаботаСДиалогами.ПериодРегистрацииНачалоВыбора(ЭтаФорма, "МесяцОбмена", "МесяцОбменаСтрока", 
														Элемент, СтандартнаяОбработка);
	
КонецПроцедуры // МесяцОбменаСтрокаНачалоВыбора()

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

#Область ОбработчикиКомандФормы

&НаКлиенте
// Обработчик нажатия кнопки "ВыполнитьОбмен".
//
Процедура КомандаВыполнитьОбмен(Команда)
	
	НачатьЗамерВремениВыполнения();
	МассивСообщений = ВыполнитьРазовыйОбменДанными();
	ОстановитьЗамерВремениВыполнения();
	
	Если МассивСообщений.Количество() = 0 Тогда
		ОбработатьСообщенияОбОшибках("Обмен выполнен успешно.");
		
		ЭтаФорма.ВладелецФормы.УстановитьВидимостьФормыОбменаДанными();
		ЭтаФорма.ВладелецФормы.ВыполнитьСборСтатистики();
	Иначе
		ОбработатьСообщенияОбОшибках(МассивСообщений);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// РАБОТА С ДИАЛОГАМИ

#Область РаботаСДиалогами

&НаКлиенте
// Функция проверяет, переданы ли параметры на сайт.
//
// Возвращаемое значение:
//  Булево.
//
Процедура ЗадатьВопросЕслиВТаблицеЛСЕстьДанные()
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьВопросОбОчисткеТаблицыЛСПриРазовомОбмене", ЭтаФорма);
	
	ПоказатьВопрос(Оповещение, "Перед заполнением табличная часть будет очищена." + Символы.ПС
				 + "Продолжить?", РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры // ЗадатьВопросЕслиНеВсеДанныеПереданы()

&НаКлиенте
// Обрабатывает результат вопроса об очистке таблицы л/с.
//
Процедура ОбработатьВопросОбОчисткеТаблицыЛСПриРазовомОбмене(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЛицевыеСчета.Очистить();
	Иначе
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму(ПутьКФормеПодбора);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОШИБОК

#Область ПроцедурыОбработкиОшибок

&НаКлиенте
// Обрабатывает сообщения об ошибках.
//
Процедура ОбработатьСообщенияОбОшибках(ОписаниеОшибок)
	
	Если ТипЗнч(ОписаниеОшибок) = Тип("Строка") Тогда
		
		ВывестиСообщениеОбОшибке(ОписаниеОшибок);
		
	ИначеЕсли ТипЗнч(ОписаниеОшибок) = Тип("Массив") Тогда
		
		Для каждого ТекСтрока из ОписаниеОшибок Цикл
			
			Если ТипЗнч(ТекСтрока) = Тип("Строка") Тогда
				
				ВывестиСообщениеОбОшибке(ТекСтрока);
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Выводит диалоговое окно предупреждения с описанием ошибки.
//
Процедура ВывестиСообщениеОбОшибке(ТекстСообщения)
	
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБМЕНА ДАННЫМИ

#Область ПроцедурыИФункцииОбменаДанными

&НаСервере
// Выполняет обмен данными с сервисом.
//
Функция ВыполнитьРазовыйОбменДанными()
	
	Возврат УПЖКХ_ИнтеграцияСМобильнымПриложениемВзаимодействиеССервером.ВыполнитьРазовыйОбменДанными(ПодготовитьСтруктуруПараметров());
	
КонецФункции

&НаСервере
// Подготавливает структуру параметров выгрузки.
//
Функция ПодготовитьСтруктуруПараметров()
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ВидПериодаРазовогоОбмена",    ВидПериодаРазовогоОбмена);
	СтруктураПараметров.Вставить("МесяцОбмена",                 МесяцОбмена);
	СтруктураПараметров.Вставить("ВыгружатьСведенияПоЛС",       ВыгружатьСведенияПоЛС);
	СтруктураПараметров.Вставить("УказатьЛицевыеСчета",         УказатьЛицевыеСчета);
	СтруктураПараметров.Вставить("ТаблицаЛицевыхСчетов",        ЛицевыеСчета.Выгрузить());
	СтруктураПараметров.Вставить("ЗагружатьПоказанияСчетчиков", ЗагружатьПоказанияСчетчиков);
	СтруктураПараметров.Вставить("ЗагружатьОплаты",             ЗагружатьОплаты);
	
	Возврат СтруктураПараметров;
	
КонецФункции

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИОНАЛ ОТЛАДКИ

#Область ФунцкионалОтладки

&НаКлиенте
// Запускает замер времени выполнения.
//
Процедура НачатьЗамерВремениВыполнения()
	
	УПЖКХ_МногопоточнаяОбработкаДанных.НачатьЗамерВремениВыполнения(ЗамерыВремениВыполнения_Таймер);
	
КонецПроцедуры

&НаКлиенте
// Завершает замер времени выполнения.
//
Процедура ОстановитьЗамерВремениВыполнения()
	
	УПЖКХ_МногопоточнаяОбработкаДанных.ОстановитьЗамерВремениВыполнения(ЗамерыВремениВыполнения_Таймер);
	
КонецПроцедуры

#КонецОбласти