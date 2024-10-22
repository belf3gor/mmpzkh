
#Область ОписаниеПеременных

&НаКлиенте
Перем СоответствиеВидовИТипов;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоПросмотр = Не ОбменСКонтрагентамиСлужебныйВызовСервера.ЕстьПравоНастройкиОбмена();
	
	УстановитьУсловноеОформление();
	
	Элементы.ГруппаОжидание.Видимость = Ложь;
	
	Параметры.Свойство("Организация"              , Организация);
	Параметры.Свойство("Контрагент"               , Контрагент);
	Параметры.Свойство("ИдентификаторКонтрагента" , ИдентификаторКонтрагента);
	Параметры.Свойство("ИдентификаторОрганизации" , ИдентификаторОрганизации);
	
	СоздатьНовыйПоИдентификаторам = Неопределено;
	Создание = Неопределено;
	НеОпределятьТипНастройкиПриЧтении = Ложь;
	
	Если Параметры.Свойство("СоздатьНовыйПоИдентификаторам"  , СоздатьНовыйПоИдентификаторам) Тогда
		
		Элементы.Организация.ТолькоПросмотр = ЗначениеЗаполнено(Организация);
		
		Если СоздатьНовыйПоИдентификаторам Тогда
			ТипНастройки = 2;
		Иначе
			ТипНастройки = 1;
		КонецЕсли;
		
	ИначеЕсли Параметры.Свойство("Создание"  , Создание) Тогда
		
		Элементы.Организация.ТолькоПросмотр = Ложь;
		Элементы.Контрагент.ТолькоПросмотр = Ложь;
		ТипНастройки = 0;
		
	Иначе
		ОпределятьТипНастройкиПриЧтении = Истина;
	КонецЕсли;
	
	СоответствиеВидовИТипов = Новый Соответствие;
	ЗаполнитьПоШаблонуНаСервере("ПервоначальноеЗаполнение", СоответствиеВидовИТипов);
	АдресСоответствияВидовИТипов  = ПоместитьВоВременноеХранилище(СоответствиеВидовИТипов,УникальныйИдентификатор);
	
	Элементы.ГруппаОжиданиеУдаления.Видимость = Ложь;
	
	ЗагрузитьТекущиеНастройкиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЭтоАдресВременногоХранилища(АдресСоответствияВидовИТипов) Тогда
		СоответствиеВидовИТипов = ПолучитьИзВременногоХранилища(АдресСоответствияВидовИТипов);
	КонецЕсли;

	ВывестиПредставленияТиповДокументов();
	ОбновитьДоступностьИдентификаторов();
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ИдентификаторОрганизации) <> ЗначениеЗаполнено(ИдентификаторКонтрагента) Тогда
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Нужно либо указать оба идентификатора (для частной настрройки), либо не указывать ни одного (для частной)'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПриИзмененииОрганизации(Элемент)
	ЗагрузитьТекущиеНастройкиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	ЗагрузитьТекущиеНастройкиНаСервере()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВходящиеДокументы

&НаКлиенте
Процедура ВходящиеДокументыПредставлениеСпособаОбработкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекСтрока = Элементы.ВходящиеДокументы.ТекущиеДанные;
	
	Если ТекСтрока <> Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВходящиеДокументыТипДокументаПредставлениеНачалоВыбораЗавершить", ЭтотОбъект, ТекСтрока);
		Если ТекСтрока.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыЭД.ПрикладнойЭД") Тогда
			ВидЭлектронногоДокумента = ТекСтрока.ПрикладнойВидЭД;
		Иначе
			ВидЭлектронногоДокумента = ТекСтрока.ВидДокумента;
		КонецЕсли;
		ПоказатьВыборИзСписка(ОписаниеОповещения, СоответствиеВидовИТипов.Получить(ВидЭлектронногоДокумента),
			Элементы.ВходящиеДокументыПредставлениеСпособаОбработки);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВходящиеДокументыТипДокументаПредставлениеНачалоВыбораЗавершить(ВыбранныйЭлемент, ТекСтрока) Экспорт 
	Если ТипЗнч(ВыбранныйЭлемент) = Тип("ЭлементСпискаЗначений") Тогда
		ТекСтрока.СпособОбработки = ВыбранныйЭлемент.Значение;
		ТекСтрока.ПредставлениеСпособаОбработки = ВыбранныйЭлемент.Представление;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	
	ЗаполнитьПоШаблонуНаСервере(Сред(Команда.Имя,10), СоответствиеВидовИТипов);
	ВывестиПредставленияТиповДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	Если СохранитьНастройки() Тогда
		Модифицированность = Ложь;
		Заголовок = ПолучитьЗаголовокОкна();
		ПоказатьОповещениеПользователя(НСтр("ru = 'Сохранение:'"),, НСтр("ru = 'Настройки успешно сохранены'"), БиблиотекаКартинок.Успешно32);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если СохранитьНастройки() Тогда
		Модифицированность = Ложь;
		Заголовок = ПолучитьЗаголовокОкна();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	
	Описание = Новый ОписаниеОповещения("ПослеВопросаУдаленияНастройки", ЭтотОбъект);
	
	ТекстВопроса = НСтр("ru = 'Сейчас будет удалена настройка отражения в учете?
                         |Продолжить?'");
	
	ПоказатьВопрос(Описание, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДоступностьИдентификаторов()
	
	Элементы.ИдентификаторКонтрагента.ТолькоПросмотр = ТипНастройки = 1;
	Элементы.ИдентификаторОрганизации.ТолькоПросмотр = ТипНастройки = 1;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Включен расширенный режим>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ИзмененноеЗначениеРеквизитаЦвет);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиОтправки.РасширенныйРежим");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НастройкиОтправкиСпособОбмена");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоШаблонуНаСервере(Знач ИмяШаблона, СоответствиеВидовИТипов)
	
	ВходящиеДокументы.Загрузить(ОбменСКонтрагентамиСлужебный.ТаблицаПредопределенногоПрофиля(ИмяШаблона));
	ЗаполнитьСоответствиеВидовИТипов(СоответствиеВидовИТипов);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСоответствиеВидовИТипов(СоответствиеВидовИТипов)

	СоответствиеВидовИТипов.Очистить();
	Для Каждого СтрокаВидаЭД Из ВходящиеДокументы Цикл
		ВидЭД = СтрокаВидаЭД.ВидДокумента;
		Если ВидЭД = Перечисления.ВидыЭД.ПрикладнойЭД Тогда
			ВидЭД = СтрокаВидаЭД.ПрикладнойВидЭД;
		КонецЕсли;
		СписокВыбора = ОбменСКонтрагентамиСлужебный.СписокОперацийВидаЭД(ВидЭД, Истина,
			НСтр("ru = 'Автоматически'") + " - ");
		СоответствиеВидовИТипов.Вставить(ВидЭД, СписокВыбора);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиПредставленияТиповДокументов()
	
	Для Каждого СтрокаВидаЭД Из ВходящиеДокументы Цикл
		ВидЭД = СтрокаВидаЭД.ВидДокумента;
		Если ЗначениеЗаполнено(СтрокаВидаЭД.ПрикладнойВидЭД) Тогда
			ВидЭД = СтрокаВидаЭД.ПрикладнойВидЭД;
		КонецЕсли;
		СписокВыбора = СоответствиеВидовИТипов.Получить(ВидЭД);
		ЭлементСписка = СписокВыбора.НайтиПоЗначению(СтрокаВидаЭД.СпособОбработки);
		Если ЭлементСписка <> Неопределено Тогда
			СтрокаВидаЭД.ПредставлениеСпособаОбработки = ЭлементСписка.Представление;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТекущиеНастройкиНаСервере(НеПроверять = Истина)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиПолученияЭлектронныхДокументов.ВидДокумента КАК ВидДокумента,
		|	НастройкиПолученияЭлектронныхДокументов.ПрикладнойВидЭД КАК ПрикладнойВидЭД,
		|	НастройкиПолученияЭлектронныхДокументов.СпособОбработки КАК СпособОбработки,
		|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя КАК ИдентификаторОтправителя,
		|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя КАК ИдентификаторПолучателя
		|ИЗ
		|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
		|ГДЕ
		|	НастройкиПолученияЭлектронныхДокументов.Получатель = &Получатель
		|	И НастройкиПолученияЭлектронныхДокументов.Отправитель = &Отправитель
		|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя = &ИдентификаторОтправителя";
	
	Запрос.УстановитьПараметр("ИдентификаторОтправителя", ИдентификаторКонтрагента);
	Запрос.УстановитьПараметр("Отправитель", Контрагент);
	Запрос.УстановитьПараметр("Получатель", Организация);
	
	РезультатыЗапроса = Запрос.Выполнить();
	
	// Проверяем настройку на "Общую" для организации
	Если НеПроверять И РезультатыЗапроса.Пустой() Тогда
		Запрос.УстановитьПараметр("ИдентификаторОтправителя", "");
		ИдентификаторКонтрагента = "";
		РезультатыЗапроса = Запрос.Выполнить();
	КонецЕсли;

	Если РезультатыЗапроса.Пустой() Тогда
		Шаблон = НСтр("ru = '%1 (Создание)'");
		Заголовок = СтрШаблон(Шаблон, ПолучитьЗаголовокОкна());
	Иначе
		Если ОпределятьТипНастройкиПриЧтении Тогда
			ОпределитьТипСуществующейНастройки(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатыЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ИдентификаторОрганизации = ВыборкаДетальныеЗаписи.ИдентификаторПолучателя;
		
		Отбор = Новый Структура();
		Отбор.Вставить("ВидДокумента"    , ВыборкаДетальныеЗаписи.ВидДокумента   );
		Отбор.Вставить("ПрикладнойВидЭД" , ВыборкаДетальныеЗаписи.ПрикладнойВидЭД);
		
		НайденныеСтроки = ВходящиеДокументы.НайтиСтроки(Отбор);
		
		Для Каждого СтрокаТЧ Из НайденныеСтроки Цикл
			
			ЗаполнитьЗначенияСвойств(СтрокаТЧ, ВыборкаДетальныеЗаписи);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Идентификаторы = ОбменСКонтрагентамиСлужебный.ДоступныеИдентификаторыЭДО(Организация, Контрагент);
	
	Элементы.ИдентификаторОрганизации.РежимВыбораИзСписка = Идентификаторы.ИдентификаторыОтправителя.Количество() > 0;
	Элементы.ИдентификаторОрганизации.СписокВыбора.Очистить();
	Для Каждого СтрокаТЧ Из Идентификаторы.ИдентификаторыОтправителя Цикл
		Элементы.ИдентификаторОрганизации.СписокВыбора.Добавить(СтрокаТЧ.Значение, СтрокаТЧ.Представление);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ИдентификаторОрганизации) Тогда
		Значение = Элементы.ИдентификаторОрганизации.СписокВыбора.НайтиПоЗначению(ИдентификаторОрганизации);
		Если Значение = Неопределено Тогда 
			Элементы.ИдентификаторОрганизации.СписокВыбора.Добавить(ИдентификаторОрганизации);
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ИдентификаторКонтрагента.РежимВыбораИзСписка = Идентификаторы.ИдентификаторыПолучателя.Количество() > 0;
	Элементы.ИдентификаторКонтрагента.СписокВыбора.Очистить();
	Для Каждого СтрокаТЧ Из Идентификаторы.ИдентификаторыПолучателя Цикл
		Элементы.ИдентификаторКонтрагента.СписокВыбора.Добавить(СтрокаТЧ.Значение, СтрокаТЧ.Представление);
	КонецЦикла;

	Если ЗначениеЗаполнено(ИдентификаторКонтрагента) Тогда
		Значение = Элементы.ИдентификаторКонтрагента.СписокВыбора.НайтиПоЗначению(ИдентификаторКонтрагента);
		Если Значение = Неопределено Тогда 
			Элементы.ИдентификаторКонтрагента.СписокВыбора.Добавить(ИдентификаторКонтрагента);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОпределитьТипСуществующейНастройки(Форма)
	
	Если ЗначениеЗаполнено(Форма.ИдентификаторКонтрагента) И ЗначениеЗаполнено(Форма.ИдентификаторОрганизации) Тогда
		Форма.ТипНастройки = 2;
	Иначе 
		Форма.ТипНастройки = 1;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция СохранитьНастройки()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = СохранитьДанныеВРегистре(ВходящиеДокументы, Организация, Контрагент, ИдентификаторОрганизации, ИдентификаторКонтрагента);
	
	Если Результат Тогда
		ОпределятьТипНастройкиПриЧтении = Истина;
		ОпределитьТипСуществующейНастройки(ЭтотОбъект);
		ОбновитьДоступностьИдентификаторов();
		
		Оповестить("ОбновитьТекущиеДелаЭДО");
		ТекстЗаголовка = НСтр("ru = 'Успех'");
		ТекстСообщения = НСтр("ru = 'Настройки получения сохранены успешно'");
		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Функция СохранитьДанныеВРегистре(Знач ВходящиеДокументы, Знач Получатель,
	Знач Отправитель, Знач ИдентификаторПолучателя, Знач ИдентификаторОтправителя)
	
	НачатьТранзакцию();
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.НастройкиПолученияЭлектронныхДокументов");
		ЭлементБлокировкиДанных.УстановитьЗначение("Получатель"              , Получатель);
		ЭлементБлокировкиДанных.УстановитьЗначение("Отправитель"             , Отправитель);
		ЭлементБлокировкиДанных.УстановитьЗначение("ИдентификаторОтправителя", ИдентификаторОтправителя);
		ЭлементБлокировкиДанных.УстановитьЗначение("ИдентификаторПолучателя" , ИдентификаторПолучателя);
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		БлокировкаДанных.Заблокировать();
		
		Если ЗначениеЗаполнено(ИдентификаторОтправителя) Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	НастройкиПолученияЭлектронныхДокументов.СпособОбработки КАК СпособОбработки
			|ИЗ
			|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
			|ГДЕ
			|	НастройкиПолученияЭлектронныхДокументов.Получатель = &Получатель
			|	И НастройкиПолученияЭлектронныхДокументов.Отправитель = &Отправитель
			|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя = """"
			|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя = """"";
			
			Запрос.УстановитьПараметр("Отправитель", Отправитель);
			Запрос.УстановитьПараметр("Получатель", Получатель);
			
			Если Запрос.Выполнить().Пустой() Тогда
				
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Нельзя создать настройку получения по идентификаторам, без общей настойки по организации
					|Сначала добавьте настройку по организации'"));
				ОтменитьТранзакцию();
				Возврат Ложь;
				
			КонецЕсли;
		КонецЕсли;
		
		Ответ = Истина;
		
		ТаблицаВходящиеДокументы = ВходящиеДокументы.Выгрузить();
		
		ТаблицаВходящиеДокументы.Колонки.Добавить("Получатель");
		ТаблицаВходящиеДокументы.ЗаполнитьЗначения(Получатель, "Получатель");
		
		ТаблицаВходящиеДокументы.Колонки.Добавить("Отправитель");
		ТаблицаВходящиеДокументы.ЗаполнитьЗначения(Отправитель, "Отправитель");
		
		ТаблицаВходящиеДокументы.Колонки.Добавить("ИдентификаторПолучателя");
		ТаблицаВходящиеДокументы.ЗаполнитьЗначения(ИдентификаторПолучателя, "ИдентификаторПолучателя");
		
		ТаблицаВходящиеДокументы.Колонки.Добавить("ИдентификаторОтправителя");
		ТаблицаВходящиеДокументы.ЗаполнитьЗначения(ИдентификаторОтправителя, "ИдентификаторОтправителя");
		
		НаборЗаписей = РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Получатель.Установить(Получатель);
		НаборЗаписей.Отбор.Отправитель.Установить(Отправитель);
		НаборЗаписей.Отбор.ИдентификаторОтправителя.Установить(ИдентификаторОтправителя);
		НаборЗаписей.Отбор.ИдентификаторПолучателя.Установить(ИдентификаторПолучателя);
		НаборЗаписей.Загрузить(ТаблицаВходящиеДокументы);
		
		
		НаборЗаписей.Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ВидОперации = НСтр("ru = 'Сохранение настроек входящих документов'");
		ПодробныйТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КраткийТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		ЭлектронноеВзаимодействие.ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки, КраткийТекстОшибки, "ОбменСКонтрагентами");
		
		Ответ = Ложь;
		
	КонецПопытки;
	
	Возврат Ответ;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьЗаголовокОкна()

	Возврат НСтр("ru = 'Настройка отражения документов в учете'");

КонецФункции

&НаКлиенте
Процедура ПослеВопросаУдаленияНастройки(РезультатВопроса, ДополнительныеПараметры) Экспорт 
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("Организация"             , Организация);
	ПараметрыПроцедуры.Вставить("Контрагент"              , Контрагент);
	ПараметрыПроцедуры.Вставить("ИдентификаторКонтрагента", ИдентификаторКонтрагента);
	ПараметрыПроцедуры.Вставить("ИдентификаторОрганизации", ИдентификаторОрганизации);
	
	ДлительнаяОперация = НачатьУдалениеНастроекОтправкиНаСервере(УникальныйИдентификатор, ПараметрыПроцедуры);
	
	Если ДлительнаяОперация <> Неопределено Тогда
		
		ТолькоПросмотр = Истина;
		Элементы.ГруппаОжиданиеУдаления.Видимость = Истина;
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтаФорма);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		
		Описание = Новый ОписаниеОповещения("ПриЗавершенииУдаленияНастроекОтправки", ЭтаФорма);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Описание, ПараметрыОжидания);
		
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция НачатьУдалениеНастроекОтправкиНаСервере(Знач УникальныйИдентификатор, Знач ПараметрыПроцедуры)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Удаление настройки отправки электронных документов'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.УдалитьНастройкиОтраженияЭДО",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииУдаленияНастроекОтправки(Результат, ДополнительныеПараметры) Экспорт
	
	ТолькоПросмотр = Ложь;
	Элементы.ГруппаОжиданиеУдаления.Видимость = Ложь;

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		
		ТекстСообщения = НСтр("ru = 'Во время удаления настройки отражения в учете произошла ошибка.'");
		
		ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(НСтр("ru = 'Удаление настройки отражения в учет ЭДО'"),
			Результат.ПодробноеПредставлениеОшибки, ТекстСообщения);
			
		Возврат;
	КонецЕсли;
	
	Если ПолучитьИзВременногоХранилища(Результат.АдресРезультата) = Истина Тогда
		
		Оповестить("ОбновитьСостояниеЭД");
		Закрыть();
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Во время удаления настройки отражения в учет произошла ошибка.
                               |Подробнее см. в журнале регистрации.'");
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти


