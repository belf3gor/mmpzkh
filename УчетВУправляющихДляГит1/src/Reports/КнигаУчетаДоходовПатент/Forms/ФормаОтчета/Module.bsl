&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ПараметрыОбработчикаОжиданияАктуализации Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Настройки по-умолчанию
	ОрганизацияПоУмолчанию = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	Отчет.Организация = ?(ОрганизацияПоУмолчанию.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо,
		ОрганизацияПоУмолчанию, Справочники.Организации.ПустаяСсылка());
	
	ЗаполнитьСписокВыбораПатентаНаСервере();
	
	Результат.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	Результат.АвтоМасштаб			= Истина;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки, Истина);
	
	Если НЕ ЗначениеЗаполнено(Отчет.Организация) Тогда
		ОрганизацияПоУмолчанию = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		Отчет.Организация = ?(ОрганизацияПоУмолчанию.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо,
			ОрганизацияПоУмолчанию, Справочники.Организации.ПустаяСсылка());
	КонецЕсли;
	
	ОрганизацияПриИзмененииНаСервере();
	
	ПатентПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы,
		ТекстПредупреждения, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	БухгалтерскийУчетКлиентПереопределяемый.ОбработкаОповещенияАктуализации(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализацииАвтоматически(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПатентПриИзменении(Элемент)
	
	ПатентПриИзмененииНаСервере();
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбораЛистаПриИзменении(Элемент)
	
	ПоказатьВыбранныйЛист();

КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
			
	ИначеЕсли НЕ РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда 
		БухгалтерскийУчетКлиентПереопределяемый.ПослеФормированияОтчета(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьАктуальность()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьАктуальность(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);

КонецПроцедуры

&НаКлиенте
Процедура Актуализировать(Команда)
	
	БухгалтерскийУчетКлиентПереопределяемый.Актуализировать(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеАктуализации()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьВыполнениеАктуализацииОтчета(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);

КонецПроцедуры

&НаКлиенте
Процедура ОтменитьАктуализацию(Команда)
	
	БухгалтерскийУчетКлиентПереопределяемый.ОтменитьАктуализацию(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстПриНеобходимостиАктуализацииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ПараметрыАктуализации = ЗакрытиеМесяцаКлиентСервер.НовыйПараметрыАктуализацииОтчета();
	ПараметрыАктуализации.Вставить("Организация",                       Отчет.Организация);
	ПараметрыАктуализации.Вставить("ДатаАктуальности",                  ДатаАктуальности);
	ПараметрыАктуализации.Вставить("ДатаОкончанияАктуализации",         Отчет.КонецПериода);

	ЗакрытиеМесяцаКлиент.ТекстПриНеобходимостиАктуализацииОбработкаНавигационнойСсылки(
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка,
		ЭтотОбъект,
		ПараметрыАктуализации);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеМесяцаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "СформироватьОтчет" Тогда
		
		БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализации(ЭтотОбъект);
		Активизировать();
		СформироватьОтчет("");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНажатие(Элемент)
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализации(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьЗавершениеАктуализации()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьЗавершениеАктуализации(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = НСтр("ru = 'Книга доходов по патенту'");
	
	Если ЗначениеЗаполнено(Отчет.Патент) Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + Отчет.Патент;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " "
			+ БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Отчет.Организация);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	ЗаполнитьСписокВыбораПатентаНаСервере();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ПатентПриИзмененииНаСервере()
	
	УстановитьПериодНаСервере();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораПатентаНаСервере()
	
	ВсеПатенты = Справочники.Патенты.ПатентыОрганизации(Отчет.Организация);
	Элементы.Патент.СписокВыбора.ЗагрузитьЗначения(ВсеПатенты);
	
	Если ВсеПатенты.Количество() = 1 Тогда
		Отчет.Патент = ВсеПатенты[0];
	Иначе
		Если ВсеПатенты.Найти(Отчет.Патент) = Неопределено Тогда
			Отчет.Патент = Справочники.Патенты.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПериодНаСервере();
	
КонецПроцедуры


&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Отчет    = Форма.Отчет;
	Элементы = Форма.Элементы;
	
	Элементы.Патент.Видимость = Не (ЗначениеЗаполнено(Отчет.Патент) И Элементы.Патент.СписокВыбора.Количество() = 1);
	
	ОбновитьТекстЗаголовка(Форма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодНаСервере()

	Если ЗначениеЗаполнено(Отчет.Патент) Тогда
		СвойстваПатента	= ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Отчет.Патент, "ДатаНачала, ДатаОкончания");
		Отчет.НачалоПериода	= НачалоДня(СвойстваПатента.ДатаНачала);
		Отчет.КонецПериода	= КонецДня(СвойстваПатента.ДатаОкончания);
	Иначе
		Отчет.НачалоПериода	= '00010101';
		Отчет.КонецПериода	= '00010101';
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура("Организация, Патент, НачалоПериода, КонецПериода, СписокСформированныхЛистов");
	ЗаполнитьЗначенияСвойств(ПараметрыОтчета, Отчет);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере()
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Отчеты.КнигаУчетаДоходовПатент.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Отчеты.КнигаУчетаДоходовПатент.СформироватьОтчет", 
			ПараметрыОтчета, 
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
		
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	Отчет.СписокСформированныхЛистов = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	ИндексСформированногоЛиста = ПолучитьИндексСформированногоЛиста(СписокВыбораЛиста, Отчет.СписокСформированныхЛистов);
	
	Элементы.СписокВыбораЛиста.СписокВыбора.Очистить();
	Если Отчет.СписокСформированныхЛистов.Количество() > 0 Тогда
		
		Для Каждого Лист Из Отчет.СписокСформированныхЛистов Цикл
			Элементы.СписокВыбораЛиста.СписокВыбора.Добавить(Лист.Представление);
		КонецЦикла; 
		
		СписокВыбораЛиста = Отчет.СписокСформированныхЛистов.Получить(
			?(ИндексСформированногоЛиста = Неопределено, 0, ИндексСформированногоЛиста)).Представление;
		
		Если Отчет.СписокСформированныхЛистов.Количество() <= 1 Тогда
			Элементы.СписокВыбораЛиста.Видимость = Ложь;
		Иначе
			Элементы.СписокВыбораЛиста.Видимость = Истина;
		КонецЕсли;
		
	КонецЕсли; 
	
	ПоказатьВыбранныйЛист();
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИндексСформированногоЛиста(ИмяЛиста, СписокСформированныхЛистов)
	
	Если ИмяЛиста = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	Для Каждого Лист Из СписокСформированныхЛистов Цикл
		Если Лист.Представление = ИмяЛиста Тогда
			Возврат СписокСформированныхЛистов.Индекс(Лист);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура ПоказатьВыбранныйЛист()
	
	Результат.Очистить();
	
	ИндексСформированногоЛиста = ПолучитьИндексСформированногоЛиста(СписокВыбораЛиста, Отчет.СписокСформированныхЛистов);
	
	Если ИндексСформированногоЛиста <> Неопределено Тогда
		СформированныйЛист = Отчет.СписокСформированныхЛистов.Получить(ИндексСформированногоЛиста).Значение;
		Результат.Вывести(СформированныйЛист);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
					
			БухгалтерскийУчетКлиентПереопределяемый.ПослеФормированияОтчета(ЭтотОбъект);
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

#КонецОбласти
