#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПрочитатьНастройку();
	
	Если ЗначениеЗаполнено(Настройка) Тогда
		
		// Уже можем начать работу с формой, так как описание закешировано в настройке
		Если ЗначениеЗаполнено(ДатаЗагрузки) Тогда
			ОтобразитьРазделДиалога(ЭтотОбъект, "Включено");
		Иначе
			ОтобразитьРазделДиалога(ЭтотОбъект, "ДействияВнешнейСистемы");
		КонецЕсли;
		
	Иначе
		
		// Не можем начать работу с формой, не запросив описание с сервиса
		ОписаниеМетода = ОписаниеМетодаПриСозданииФормы();
		ДлительнаяОперация = НачатьЗапросВнешнейСистемы(ОписаниеМетода, УникальныйИдентификатор);
		
		Ответ = ЗавершитьЗапросВнешнейСистемы(ДлительнаяОперация, ЭтотОбъект, ОписаниеМетода);
		Если Ответ.Получен Тогда
			ОтобразитьОтветВнешнейСистемыНаСервере(Ответ.Содержание, ОписаниеМетода.Имя);
		Иначе
			ДействиеПослеОткрытия = Ответ;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// Может потребоваться открыть блокирующую форму, поэтому действия выполняем после открытия
	ПодключитьОбработчикОжидания("Подключаемый_ПослеОткрытия", 0.1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПослеОткрытия()
	
	Если ДействиеПослеОткрытия <> Неопределено Тогда
		
		ОписаниеМетода = ОписаниеМетодаПриСозданииФормы();
		ОжидатьРезультатЗапросаВнешнейСистемы(ДействиеПослеОткрытия, ОписаниеМетода);
		
	ИначеЕсли ЗначениеЗаполнено(Настройка) Тогда
		
		Если Не ЗначениеЗаполнено(ДатаЗагрузки) Тогда
			// Возможно, к этому моменту пользователь активировал внешнюю систему
			ЗапроситьАктивностьВнешнейСистемы();
		Иначе
			// Убедимся, что данные о сервисе актуальны.
			ОписаниеМетода = ОписаниеМетода(
				"Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ОбновитьПоставляемоеОписаниеВнешнейСистемыВФоне",
				Новый Структура("Настройка", Настройка));
			ЗапроситьВнешнююСистему(ОписаниеМетода);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВключить(Команда)
	
	ПараметрыМетода = Новый Структура(
		"ИдентификаторСистемы",
		ОбменДаннымиСВнешнимиСистемамиБПКлиентСервер.ИдентификаторСистемыSmartway());
	
	ОписаниеМетода = ОписаниеМетода("Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ПодключитьВнешнююСистемуВФоне", ПараметрыМетода);
	ЗапроситьВнешнююСистему(ОписаниеМетода);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗагрузить(Команда)
	
	ОписаниеМетода = ОписаниеМетода(
		"Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗагрузитьВФоне",
		Новый Структура("Настройка", Настройка));
		
	ЗапроситьВнешнююСистему(ОписаниеМетода);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтключить(Команда)
	
	ОписаниеМетода = ОписаниеМетода(
		"Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗапроситьОтключение",
		Новый Структура("Настройка", Настройка));
		
	ЗапроситьВнешнююСистему(ОписаниеМетода);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПовторитьЗапросВнешнейСистемы(Команда)
	
	Если ОписаниеМетодаОшибочногоДействия = Неопределено Тогда
		ОписаниеМетодаОшибочногоДействия = ОписаниеМетодаПриСозданииФормы();
	КонецЕсли;
	ЗапроситьВнешнююСистему(ОписаниеМетодаОшибочногоДействия);
	
КонецПроцедуры

#КонецОбласти

#Область МетодыВнешнейСистемы 

// Работа с командами, отправляемыми внешней системе.
// Термин "команды" не используется в коде, чтобы не было путаницы с командами формы.
// 
// В то же время, методы внешней системы не обязательно соответствуют методам http-сервисов этой системы.
// Команды выполняются асинхронно, механизмом длительных операций.
// Поэтому, для сокращения количества имен, в качестве имен команд (методов) используются имена процедур-исполнителей длительных операций.

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеМетодаПриСозданииФормы()
	
	ПараметрыМетода = Новый Структура(
		"ИдентификаторСистемы",
		ОбменДаннымиСВнешнимиСистемамиБПКлиентСервер.ИдентификаторСистемыSmartway());
	
	Возврат ОписаниеМетода(
		"Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗапроситьПоставляемоеОписаниеВнешнейСистемы",
		ПараметрыМетода);
		
КонецФункции

&НаСервереБезКонтекста
Функция ПредставлениеМетодаВнешнейСистемы(ИмяМетода)
	
	Если ИмяМетода = "Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗапроситьПоставляемоеОписаниеВнешнейСистемы" Тогда
		
		Возврат НСтр("ru = 'Проверка доступа к внешним системам'");
		
	ИначеЕсли ИмяМетода = "Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ПодключитьВнешнююСистемуВФоне" Тогда
		
		Возврат НСтр("ru = 'Получение кода разрешения доступа к данным внешней системы'");
		
	ИначеЕсли ИмяМетода = "Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗагрузитьВФоне" Тогда
		
		Возврат НСтр("ru = 'Получение данных из внешней системы'");
		
	ИначеЕсли ИмяМетода = "Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗапроситьАктивностьВнешнейСистемы" Тогда
		
		Возврат НСтр("ru = 'Проверка активности внешней системы'");
		
	ИначеЕсли ИмяМетода = "Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗапроситьОтключение" Тогда
		
		Возврат НСтр("ru = 'Отключение внешней системы'");
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;
		
КонецФункции

&НаКлиенте
Процедура ОтобразитьОтветВнешнейСистемы(Ответ, ИмяМетода)
	
	Если ИмяМетода = "Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ПодключитьВнешнююСистемуВФоне" Тогда
		
		ОтобразитьПодключениеВнешнейСистемы(Ответ);
		ПодключитьОбработчикОжиданияАктивностиВнешнейСистемы();
		
	ИначеЕсли ИмяМетода = "Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗагрузитьВФоне" Тогда
		
		Если ЗначениеЗаполнено(Ответ.ДатаЗавершения) Тогда
			ДатаЗагрузки = Ответ.ДатаЗавершения;
		КонецЕсли;
		ОтобразитьАктивностьВнешнейСистемы();
		
	ИначеЕсли ИмяМетода = "Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗапроситьАктивностьВнешнейСистемы" Тогда
		
		Если Ответ = Истина Тогда
			ОтобразитьАктивностьВнешнейСистемы();
			ОбновитьИнтерфейс();
		Иначе
			ПодключитьОбработчикОжиданияАктивностиВнешнейСистемы();
			ОтобразитьРазделДиалога(ЭтотОбъект, "ДействияВнешнейСистемы");
		КонецЕсли;
		
	ИначеЕсли ИмяМетода = "Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ОбновитьПоставляемоеОписаниеВнешнейСистемыВФоне" Тогда
		
		Если Ответ = Истина Тогда
			ОтобразитьОписаниеВнешнейСистемы();
		КонецЕсли;
		
	ИначеЕсли ИмяМетода = "Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗапроситьОтключение" Тогда
		
		ОтобразитьРазделДиалога(ЭтотОбъект, "Отключено");
		Настройка = Неопределено;
		
	ИначеЕсли ИмяМетода = "Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗапроситьПоставляемоеОписаниеВнешнейСистемы" Тогда
		
		// требует контекстного вызова сервера
		ОтобразитьОтветВнешнейСистемыНаСервере(Ответ, ИмяМетода);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьОтветВнешнейСистемыНаСервере(Ответ, ИмяМетода)
	
	Если ИмяМетода = "Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗапроситьПоставляемоеОписаниеВнешнейСистемы" Тогда
		ОтобразитьОписаниеНовойВнешнейСистемы(Ответ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтображениеДлительнойОперацииМетода(ИмяМетода, Отображение)
	
	// У отдельных команд можно отобразить длительную операцию _локальным_ элементом формы.
	// Это можно делать сразу, не дожидаясь оценки операции как длительной.
	
	Если ИмяМетода = "Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗагрузитьВФоне" Тогда
		Если Отображение Тогда
			Элементы.Загрузить.Картинка = БиблиотекаКартинок.СинхронизацияДанныхДлительнаяОперация;
		Иначе
			Элементы.Загрузить.Картинка = БиблиотекаКартинок.СинхронизацияДанных;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВыполнятьСкрытно(ИмяМетода)
	
	Возврат ИмяМетода = "Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ОбновитьПоставляемоеОписаниеВнешнейСистемыВФоне";
	
КонецФункции

#Область ЗапросАктивностиВнешнейСистемы

&НаКлиенте
Процедура ЗапроситьАктивностьВнешнейСистемы() // используется как обработчик ожидания
	
	ОписаниеМетода = ОписаниеМетода(
		"Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ЗапроситьАктивностьВнешнейСистемы",
		Новый Структура("Настройка", Настройка));
	ЗапроситьВнешнююСистему(ОписаниеМетода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияАктивностиВнешнейСистемы()
	
	ПодключитьОбработчикОжидания("ЗапроситьАктивностьВнешнейСистемы", ИнтервалОбновленияАктивностиВнешнейСистемы(), Истина);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИнтервалОбновленияАктивностиВнешнейСистемы()
	
	Возврат 9;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область НастройкаФормы

&НаСервере
Процедура ПрочитатьНастройку()
	
	Настройка = Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ИспользуемаяНастройкаSmartway();
	
	Если Не ЗначениеЗаполнено(Настройка) Тогда
		Возврат;
	КонецЕсли;
	
	КодРазрешения = Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.КодРазрешения(Настройка);
	
	ДатаЗагрузки  = ДатаЗагрузки(Настройка);
	
	ОтобразитьОписаниеВнешнейСистемы();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДатаЗагрузки(Настройка)
	
	КрайнийСеанс = Справочники.СеансыЗагрузкиДанныхВнешнихСистем.КрайнийСеансЗагрузки(Настройка);
	Возврат Справочники.СеансыЗагрузкиДанныхВнешнихСистем.ЛокальнаяДатаЗагрузки(КрайнийСеанс);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОтобразитьРазделДиалога(Форма, ИмяОтображаемогоРаздела)
	
	РазделыДиалога = Новый Массив;
	РазделыДиалога.Добавить("ДлительныйЗапрос");
	РазделыДиалога.Добавить("Отключено");
	РазделыДиалога.Добавить("ДействияВнешнейСистемы");
	РазделыДиалога.Добавить("Включено");
	РазделыДиалога.Добавить("Ошибка");
	
	Для Каждого ИмяЭлемента Из РазделыДиалога Цикл
		Форма.Элементы[ИмяЭлемента].Видимость = (ИмяЭлемента = ИмяОтображаемогоРаздела);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьОписаниеВнешнейСистемы(ОписаниеВнешнейСистемы = Неопределено)
	
	// Выполняется контекстно, чтобы избежать отрисовки изменений частями
	
	Если ОписаниеВнешнейСистемы = Неопределено Тогда
		ОписаниеВнешнейСистемы = Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.ОписаниеСистемы(Настройка);
	КонецЕсли;
	
	// Используются декорации, так как они подстраиваются под размер контента
	Элементы.ОписаниеВнешнейСистемы.Видимость = Истина;
	Элементы.ОписаниеВнешнейСистемы.Заголовок = ОписаниеВнешнейСистемы.ОписаниеСистемы;
	
	// если текст объемный, то убираем ограничение на ширину поля для его вывода
	ВысотаТекста = СтрЧислоСтрок(Строка(ОписаниеВнешнейСистемы.ОписаниеСистемы));
	Элементы.ОписаниеВнешнейСистемы.АвтоМаксимальнаяШирина = (ВысотаТекста <= 5);

	Если ПустаяСтрока(ОписаниеВнешнейСистемы.ОписаниеЗагружаемыхДанных) Тогда
		ОписаниеЗагружаемыхДанных = НСтр("ru = 'данные'");
	Иначе
		ОписаниеЗагружаемыхДанных = ОписаниеВнешнейСистемы.ОписаниеЗагружаемыхДанных;
	КонецЕсли;
	
	ШаблонУказаний = НСтр("ru = 'Для получения данных скопируйте код и вставьте его в %1.
                           |После этого %2 будут загружаться автоматически'");
	
	Элементы.УказанияВнешняяСистема.Заголовок = СтрШаблон(
		ШаблонУказаний,
		ОписаниеВнешнейСистемы.НаименованиеСистемы,
		ОписаниеЗагружаемыхДанных);
		
	Элементы.СсылкаКодРазрешения.Видимость = Не ПустаяСтрока(ОписаниеВнешнейСистемы.АдресКодПодтверждения);
	Если Элементы.СсылкаКодРазрешения.Видимость Тогда
		
		ШаблонСсылки = НСтр("ru = 'Перейти в %1'");
		Ссылка = СтрШаблон(
			"<a href = ""%1"">%2</a>",
			ОписаниеВнешнейСистемы.АдресКодПодтверждения,
			ОписаниеВнешнейСистемы.НаименованиеСистемы);
			
		Элементы.СсылкаКодРазрешения.Заголовок = СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(СтрШаблон(ШаблонСсылки, Ссылка));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьОписаниеНовойВнешнейСистемы(Описание)
	
	ОтобразитьРазделДиалога(ЭтотОбъект, "Отключено");
	ОтобразитьОписаниеВнешнейСистемы(Описание);
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьПодключениеВнешнейСистемы(Ответ)
	
	Настройка     = Ответ;
	КодРазрешения = Справочники.НастройкиЗагрузкиДанныхВнешнихСистем.КодРазрешения(Настройка);
	ОтобразитьРазделДиалога(ЭтотОбъект, "ДействияВнешнейСистемы");
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьАктивностьВнешнейСистемы()
	
	ДатаЗагрузки = ДатаЗагрузки(Настройка);
	
	ОтобразитьРазделДиалога(ЭтотОбъект, "Включено");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МожноПродолжатьБезИнтернетПоддержки(Настройка)
	Возврат ЗначениеЗаполнено(Настройка);
КонецФункции

#КонецОбласти

#Область ОбщиеМетодыЗапросовВнешнейСистемы

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеМетода(Имя, Параметры = Неопределено)
	
	ОписаниеМетода = Новый Структура;
	ОписаниеМетода.Вставить("Имя",       Имя);
	ОписаниеМетода.Вставить("Параметры", Параметры);
	Возврат ОписаниеМетода;
	
КонецФункции

&НаКлиенте
Процедура ЗапроситьВнешнююСистему(ОписаниеМетода)
	
	УстановитьОтображениеДлительнойОперацииМетода(ОписаниеМетода.Имя, Истина);
	
	ДлительнаяОперация = НачатьЗапросВнешнейСистемы(ОписаниеМетода, УникальныйИдентификатор);
	
	ЗавершитьОжиданиеВнешнейСистемы(ДлительнаяОперация, ОписаниеМетода);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НачатьЗапросВнешнейСистемы(ОписаниеМетода, ИдентификаторФормы)
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = ПредставлениеМетодаВнешнейСистемы(ОписаниеМетода.Имя);
	ПараметрыВыполненияВФоне.КлючФоновогоЗадания         = Строка(ИдентификаторФормы);
	Если ВыполнятьСкрытно(ОписаниеМетода.Имя) Тогда
		ПараметрыВыполненияВФоне.ОжидатьЗавершение = 0;
	КонецЕсли;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ОписаниеМетода.Имя, ОписаниеМетода.Параметры, ПараметрыВыполненияВФоне);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗавершитьЗапросВнешнейСистемы(ДлительнаяОперация, Форма, ОписаниеМетода)
	
	Ответ = Новый Структура;
	Ответ.Вставить("Получен",            Ложь);
	Ответ.Вставить("Содержание",         Неопределено);
	Ответ.Вставить("ДлительнаяОперация", Неопределено);
	
	Если ДлительнаяОперация = Неопределено Тогда
		// Пользователь уже закрыл форму
		Возврат Ответ;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Выполняется" Тогда
		
		Ответ.ДлительнаяОперация = ДлительнаяОперация;
		
		Если Не МожноПродолжатьБезИнтернетПоддержки(Форма.Настройка) Тогда
			ОтобразитьРазделДиалога(Форма, "ДлительныйЗапрос");
		КонецЕсли;
		
		Возврат Ответ;
		
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус <> "Выполнено" Тогда
		
		Если ВыполнятьСкрытно(ОписаниеМетода.Имя) Тогда
			Возврат Ответ; // не показываем данные об ошибке
		КонецЕсли;
		
		// Ошибка
		Форма.ОписаниеМетодаОшибочногоДействия = ОписаниеМетода;
		Форма.Элементы.ПредставлениеОшибки.Заголовок = ДлительнаяОперация.КраткоеПредставлениеОшибки; // Используется декорация, так как она подстраивается под размер контента
		ОтобразитьРазделДиалога(Форма, "Ошибка");
		Возврат Ответ; // вся информация отображена на форме
		
	КонецЕсли;
	
	Ответ.Содержание = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
	
	Если Ответ.Содержание = "НетИнтернетПоддержки" Тогда
		Если Не МожноПродолжатьБезИнтернетПоддержки(Форма.Настройка) Тогда
			ОтобразитьРазделДиалога(Форма, "ДлительныйЗапрос");
		КонецЕсли;
		Возврат Ответ;
	ИначеЕсли Ответ.Содержание = "Отключено" Тогда
		ОтобразитьРазделДиалога(Форма, "Отключено");
		Форма.Настройка = Неопределено;
		Возврат Ответ;
	КонецЕсли;
	
	Ответ.Получен = Истина;
	Возврат Ответ;
	
КонецФункции

&НаКлиенте
Процедура ОжидатьРезультатЗапросаВнешнейСистемы(Ответ, ОписаниеМетода)
	
	// Ответ - результат ЗавершитьЗапросВнешнейСистемы
	
	Если Ответ.Содержание = "НетИнтернетПоддержки" Тогда
		
		// Попросим уточнить реквизиты и запустим повторно
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
			Новый ОписаниеОповещения("ПриПодключенииИнтернетПоддержки", ЭтотОбъект, ОписаниеМетода),
			ЭтотОбъект);
		Возврат;
		
	ИначеЕсли Ответ.ДлительнаяОперация <> Неопределено Тогда
		
		// Начинаем ожидание
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		
		ОбработчикОжидания = Новый ОписаниеОповещения("ЗавершитьОжиданиеВнешнейСистемы", ЭтотОбъект, ОписаниеМетода);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(Ответ.ДлительнаяОперация, ОбработчикОжидания, ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьОжиданиеВнешнейСистемы(ДлительнаяОперация, ОписаниеМетода) Экспорт // обработчик оповещения
	
	Ответ = ЗавершитьЗапросВнешнейСистемы(ДлительнаяОперация, ЭтотОбъект, ОписаниеМетода);
	
	Если Ответ.Получен Тогда
		УстановитьОтображениеДлительнойОперацииМетода(ОписаниеМетода.Имя, Ложь);
		ОтобразитьОтветВнешнейСистемы(Ответ.Содержание, ОписаниеМетода.Имя);
	Иначе
		ОжидатьРезультатЗапросаВнешнейСистемы(Ответ, ОписаниеМетода);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПодключенииИнтернетПоддержки(РезультатПодключения, ОписаниеМетода) Экспорт // Обработчик оповещения
	
	Если РезультатПодключения = Неопределено Тогда
		Если Не МожноПродолжатьБезИнтернетПоддержки(Настройка) Тогда
			// Без интернет-поддержки форму невозможно использовать
			Закрыть();
		Иначе
			УстановитьОтображениеДлительнойОперацииМетода(ОписаниеМетода.Имя, Ложь);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ЗапроситьВнешнююСистему(ОписаниеМетода);
	
КонецПроцедуры

#КонецОбласти
