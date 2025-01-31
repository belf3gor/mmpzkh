&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ПараметрыОбработчикаОжиданияАктуализации Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьНачальныеНастройки();
	
	РежимРасшифровки = Параметры.РежимРасшифровки;
	
	Если РежимРасшифровки Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	ПредставлениеПериода =
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	
	УправлениеФормой(ЭтаФорма);
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.Отчет.КнигаУчетаДоходовИРасходов",
		"ФормаОтчета",
		НСтр("ru='Новости: Книга доходов и расходов УСН'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если НЕ РежимРасшифровки Тогда
		БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки, Истина);
	КонецЕсли;
	
	ОбновитьНастройки();
	
	ПредставлениеПериода =
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
	Если РежимРасшифровки Тогда
		СформироватьОтчетНаКлиенте();
	КонецЕсли;
	
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
	
	БухгалтерскийУчетКлиентПереопределяемый.ОбработкаОповещенияАктуализации(ЭтотОбъект,
		Отчет.Организация,
		Отчет.КонецПериода,
		ИмяСобытия,
		Параметр,
		Источник);
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиПечатныхФорм

&НаКлиенте
Процедура НастройкиПечатныхФормПриАктивизацииСтроки(Элемент)
	УстановитьТекущуюСтраницу();
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПечатныхФормПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Функция ТекущаяНастройкаПечатнойФормы()
	Результат = Элементы.НастройкиПечатныхФорм.ТекущиеДанные;
	Если Результат = Неопределено И НастройкиПечатныхФорм.Количество() > 0 Тогда
		Результат = НастройкиПечатныхФорм[0];
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура УстановитьТекущуюСтраницу()
	
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	
	ТекущаяСтраница = Элементы.СтраницаПечатнаяФормаОбразец;
	ПечатнаяФормаДоступна = НастройкаПечатнойФормы <> Неопределено И ЭтотОбъект[НастройкаПечатнойФормы.ИмяРеквизита].ВысотаТаблицы > 0;
	Если ПечатнаяФормаДоступна Тогда
		ТекущаяСтраница = Элементы[НастройкаПечатнойФормы.ИмяСтраницы];
	КонецЕсли;
	Элементы.Страницы.ТекущаяСтраница = ТекущаяСтраница;
		
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеПериодаПриИзменении(Элемент)

	ПредставлениеПериода =
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода, МинимальныйПериод",
		Отчет.НачалоПериода, Отчет.КонецПериода, МинимальныйПериод);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаКварталНарастающимИтогом",
		ПараметрыВыбора,
		Элементы.ПредставлениеПериода,
		,
		,
		,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализацииАвтоматически(ЭтотОбъект);
	
	ОбновитьНастройки();
	
	УправлениеФормой(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УстановитьСостояниеТабличныхПолей("НеАктуальность", Элементы, НастройкиПечатныхФорм);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПечатиГраф4и6ПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		
		УстановитьСостояниеТабличныхПолей("НеАктуальность", Элементы, НастройкиПечатныхФорм, Ложь);

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПечатиНДСПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		
		УстановитьСостояниеТабличныхПолей("НеАктуальность", Элементы, НастройкиПечатныхФорм, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьРасшифровкиПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		
		УстановитьСостояниеТабличныхПолей("НеАктуальность", Элементы, НастройкиПечатныхФорм, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	ВыделенныеОбласти = ЭтаФорма[НастройкаПечатнойФормы.ИмяРеквизита].ВыделенныеОбласти;
	Если ТипЗнч(ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтаФорма,
		Команда
	);

КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчетНаКлиенте()
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		
		УстановитьСостояниеТабличныхПолей("ФормированиеОтчета", Элементы, НастройкиПечатныхФорм);

	ИначеЕсли НЕ РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		БухгалтерскийУчетКлиентПереопределяемый.ПослеФормированияОтчета(ЭтотОбъект);
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе
		СкрытьНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	СформироватьОтчетНаКлиенте();
	
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
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьВыполнениеАктуализацииОтчета(ЭтотОбъект,
		Отчет.Организация,
		Отчет.КонецПериода);

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
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьЗавершениеАктуализации(ЭтотОбъект,
		Отчет.Организация,
		Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ОткрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	СкрытьНастройки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = "Книга доходов и расходов"
					+ БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода,
																				 Отчет.КонецПериода);

	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета 
						+ " "
						+ БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Отчет.Организация);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ПояснениеРасширенныйНалоговыйПериод.Видимость = ОтчетЗаРасширенныйНалоговыйПериод(Форма);
	
	Элементы.ГруппаКоманднаяПанельОтчета.Видимость = НЕ Форма.НалоговыйПериодПропущен;
	Элементы.ГруппаПечатныеФормы.Видимость         = НЕ Форма.НалоговыйПериодПропущен;
	Элементы.НастройкиОтчета.Видимость             = НЕ Форма.НалоговыйПериодПропущен;
	
	Элементы.РежимПечатиНДС.Доступность = Форма.ПрименяетсяУСНДоходыМинусРасходы И НЕ Форма.РасходыНаНДСПоОплатеПоставщику;
	
	Элементы.НастройкиПечатныхФорм.Видимость = Форма.НастройкиПечатныхФорм.Количество() > 0;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНачальныеНастройки()
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		Отчет.Организация = Параметры.Организация;
	Иначе
		Отчет.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.НачалоПериода) И ЗначениеЗаполнено(Параметры.КонецПериода) Тогда
		Отчет.НачалоПериода = НачалоКвартала(Параметры.НачалоПериода);
		Отчет.КонецПериода  = КонецКвартала(Параметры.КонецПериода);
		// отчет может формироваться только за квартал, либо с начала года
		Если Отчет.НачалоПериода <> НачалоКвартала(Отчет.КонецПериода) Тогда
			Отчет.НачалоПериода = НачалоГода(Отчет.КонецПериода);
		КонецЕсли;
	Иначе
		ТекущаяДата = ОбщегоНазначения.ТекущаяДатаПользователя();
		Отчет.НачалоПериода = НачалоКвартала(ТекущаяДата);
		Отчет.КонецПериода  = КонецКвартала(ТекущаяДата);
	КонецЕсли;
	
	Отчет.РежимПечатиГраф4и6 = 3;
	Отчет.РежимПечатиНДС     = 2;
	
	ОбновитьНастройки();
	
	Элементы.НастройкиПечатныхФорм.Видимость = Ложь;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПечатнаяФормаОбразец, "НеАктуальность");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройки()
	
	Отчеты.КнигаУчетаДоходовИРасходов.ПолучитьНастройкиОтчета(ЭтотОбъект);
	
	ЗаполнитьСведенияОНалоговомПериоде();
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСведенияОНалоговомПериоде()
	
	Отчеты.КнигаУчетаДоходовИРасходов.ЗаполнитьСведенияОНалоговомПериоде(ЭтотОбъект);
	
	ПредставлениеПериода = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
			Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	
	Элементы.ПояснениеРасширенныйНалоговыйПериод.Заголовок = ПояснениеПереносНалоговогоПериода();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОтчетЗаРасширенныйНалоговыйПериод(Форма)
	
	Отчет = Форма.Отчет;
	
	Возврат Форма.НалоговыйПериодПропущен
		ИЛИ (Форма.НалоговыйПериодРасширен И Отчет.НачалоПериода = НачалоГода(Отчет.НачалоПериода));
	
КонецФункции

&НаСервере
Функция ПояснениеПереносНалоговогоПериода()
	
	Если НалоговыйПериодПропущен Тогда
		
		ГодОтчета = Год(Отчет.КонецПериода);
		
		ШаблонПодсказки = НСтр("ru = 'Книгу доходов и расходов за %1 год формировать не нужно. Период с даты регистрации %2 по %3 включается в отчет за %4 год.'");
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПодсказки,
			Формат(ГодОтчета, "ЧГ=0"),
			Формат(НачалоНалоговогоПериода, "ДФ=dd.MM.yyyy"),
			Формат(КонецГода(НачалоНалоговогоПериода), "ДФ=dd.MM.yyyy"),
			Формат(ГодОтчета + 1, "ЧГ=0"));
		
	ИначеЕсли НалоговыйПериодРасширен Тогда
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Период с даты регистрации %1 по %2 включается в отчет за %3'"),
				Формат(НачалоНалоговогоПериода, "ДФ=dd.MM.yyyy"),
				Формат(КонецГода(НачалоНалоговогоПериода), "ДФ=dd.MM.yyyy"),
				ПредставлениеПериода);
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере()
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	УстановитьСостояниеТабличныхПолей("НеИспользовать", Элементы, НастройкиПечатныхФорм);
	
	ПараметрыОтчета = Отчеты.КнигаУчетаДоходовИРасходов.ПодготовитьПараметрыОтчета(ЭтотОбъект);
	
	РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Отчеты.КнигаУчетаДоходовИРасходов.СформироватьОтчет",
		ПараметрыОтчета,
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
	
	ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	АдресХранилища       = РезультатВыполнения.АдресХранилища;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	// Очистить
	ДобавленныеРеквизитыФормы = Новый Массив;
	Для Каждого СтраницаОтчета из НастройкиПечатныхФорм Цикл
		ИмяРеквизита = СтраницаОтчета.ИмяРеквизита;
		ДобавленныеРеквизитыФормы.Добавить(ИмяРеквизита);
		Элементы.Удалить(Элементы["Страница" + ИмяРеквизита]);
	КонецЦикла;
	ИзменитьРеквизиты(, ДобавленныеРеквизитыФормы);	
	
	НастройкиПечатныхФорм.Очистить();
		
	Отчет.СписокСформированныхЛистов = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	// Создание реквизитов для табличных документов.
	НовыеРеквизитыФормы = Новый Массив;
	Для НомерПечатнойФормы = 1 По Отчет.СписокСформированныхЛистов.Количество() Цикл
		ИмяРеквизита = "ПечатнаяФорма" + Формат(НомерПечатнойФормы,"ЧГ=0");
		РеквизитФормы = Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("ТабличныйДокумент"),,Отчет.СписокСформированныхЛистов[НомерПечатнойФормы - 1].Представление);
		НовыеРеквизитыФормы.Добавить(РеквизитФормы);
	КонецЦикла;
	ИзменитьРеквизиты(НовыеРеквизитыФормы);
	
	// Создание страниц с табличными документами на форме.
	НомерПечатнойФормы = 0;
	ДобавленныеНастройкиПечатныхФорм = Новый Соответствие;
	Для Каждого РеквизитФормы Из НовыеРеквизитыФормы Цикл
		ОписаниеПечатнойФормы = Отчет.СписокСформированныхЛистов[НомерПечатнойФормы];
		
		// Таблица настроек печатных форм (начало).
		НоваяНастройкаПечатнойФормы = НастройкиПечатныхФорм.Добавить();
		НоваяНастройкаПечатнойФормы.Представление = ОписаниеПечатнойФормы.Представление;
		НоваяНастройкаПечатнойФормы.Печатать = Истина;
		НоваяНастройкаПечатнойФормы.Количество = 1;
		НоваяНастройкаПечатнойФормы.ИмяМакета = ОписаниеПечатнойФормы.Представление;
		НоваяНастройкаПечатнойФормы.ПозицияПоУмолчанию = НомерПечатнойФормы;
		НоваяНастройкаПечатнойФормы.Название = ОписаниеПечатнойФормы.Представление;
		НоваяНастройкаПечатнойФормы.ПутьКМакету = "";
		НоваяНастройкаПечатнойФормы.ИмяФайлаПечатнойФормы = ОбщегоНазначения.ЗначениеВСтрокуXML(ОписаниеПечатнойФормы.Представление);
		
		РанееДобавленнаяНастройкаПечатнойФормы = ДобавленныеНастройкиПечатныхФорм[ОписаниеПечатнойФормы.Представление];
		Если РанееДобавленнаяНастройкаПечатнойФормы = Неопределено Тогда
			// Копирование табличного документа в реквизит формы.
			ИмяРеквизита = РеквизитФормы.Имя;
			ЭтотОбъект[ИмяРеквизита] = ОписаниеПечатнойФормы.Значение;
			
			// Создание страниц для табличных документов.
			ИмяСтраницы = "Страница" + ИмяРеквизита;
			Страница = Элементы.Добавить(ИмяСтраницы, Тип("ГруппаФормы"), Элементы.Страницы);
			Страница.Вид = ВидГруппыФормы.Страница;
			Страница.Картинка = БиблиотекаКартинок.ТабличныйДокументВставитьРазрывСтраницы;
			Страница.Заголовок = ОписаниеПечатнойФормы.Представление;
			Страница.Подсказка = ОписаниеПечатнойФормы.Представление;
			Страница.Видимость = ЭтотОбъект[ИмяРеквизита].ВысотаТаблицы > 0;
			
			// Создание элементов под табличные документы.
			НовыйЭлемент = Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), Страница);
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеТабличногоДокумента;
			НовыйЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			НовыйЭлемент.ПутьКДанным = ИмяРеквизита;
			//НовыйЭлемент.Вывод = Истина;
			НовыйЭлемент.Редактирование = Не ОписаниеПечатнойФормы.Значение.ТолькоПросмотр;
			НовыйЭлемент.Защита = ОписаниеПечатнойФормы.Значение.Защита;
			НовыйЭлемент.УстановитьДействие("ПриАктивизацииОбласти", "РезультатПриАктивизацииОбласти");
			
			// Таблица настроек печатных форм (продолжение).
			НоваяНастройкаПечатнойФормы.ИмяСтраницы = ИмяСтраницы;
			НоваяНастройкаПечатнойФормы.ИмяРеквизита = ИмяРеквизита;
			
			ДобавленныеНастройкиПечатныхФорм.Вставить(НоваяНастройкаПечатнойФормы.ИмяМакета, НоваяНастройкаПечатнойФормы);
		Иначе
			НоваяНастройкаПечатнойФормы.ИмяСтраницы = РанееДобавленнаяНастройкаПечатнойФормы.ИмяСтраницы;
			НоваяНастройкаПечатнойФормы.ИмяРеквизита = РанееДобавленнаяНастройкаПечатнойФормы.ИмяРеквизита;
		КонецЕсли;
		
		НомерПечатнойФормы = НомерПечатнойФормы + 1;
	КонецЦикла;
	
	ИдентификаторЗадания = Неопределено;
	
	УстановитьСостояниеТабличныхПолей("НеИспользовать", Элементы, НастройкиПечатныхФорм);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТабличныеДокументыВоВременноеХранилище(НастройкиСохранения)
	Перем ЗаписьZipФайла, ИмяАрхива;
	
	Результат = Новый Массив;
	
	// подготовка архива
	Если НастройкиСохранения.УпаковатьВАрхив Тогда
		ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
		ЗаписьZipФайла = Новый ЗаписьZipФайла(ИмяАрхива);
	КонецЕсли;
	
	// подготовка временной папки
	ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременнойПапки);
	ИспользованныеИменаФайлов = Новый Соответствие;
	
	ВыбранныеФорматыСохранения = НастройкиСохранения.ФорматыСохранения;
	ТаблицаФорматов = УправлениеПечатью.НастройкиФорматовСохраненияТабличногоДокумента();
	
	ПрефиксИмени = НСтр("ru = 'КУДиР '") + Отчеты.КнигаУчетаДоходовИРасходов.ПолучитьПредставлениеПериода(КонецКвартала(Отчет.КонецПериода));
	ПрефиксИмени = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ПрефиксИмени);
	
	// сохранение печатных форм
	ОбработанныеПечатныеФормы = Новый Массив;
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		
		Если Не НастройкаПечатнойФормы.Печатать Тогда
			Продолжить;
		КонецЕсли;
		
		ПечатнаяФорма = ЭтотОбъект[НастройкаПечатнойФормы.ИмяРеквизита];
		Если ОбработанныеПечатныеФормы.Найти(ПечатнаяФорма) = Неопределено Тогда
			ОбработанныеПечатныеФормы.Добавить(ПечатнаяФорма);
		Иначе
			Продолжить;
		КонецЕсли;
		
		Если ПечатнаяФорма.ВысотаТаблицы = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ИмяФормата Из ВыбранныеФорматыСохранения Цикл
			ТипФайла = ТипФайлаТабличногоДокумента[ИмяФормата];
			НастройкиФормата = ТаблицаФорматов.НайтиСтроки(Новый Структура("ТипФайлаТабличногоДокумента", ТипФайла))[0];
			
			ИмяФайла = ПрефиксИмени + " " + НастройкаПечатнойФормы.ИмяМакета;
			ИмяФайла = ИмяФайла + "." + НастройкиФормата.Расширение;
			ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла);
			
			ПолноеИмяФайла =
				УникальноеИмяФайла(ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) + ИмяФайла);
			ПечатнаяФорма.Записать(ПолноеИмяФайла, ТипФайла);
			
			Если ТипФайла = ТипФайлаТабличногоДокумента.HTML Тогда
				ВставитьКартинкиВHTML(ПолноеИмяФайла);
			КонецЕсли;
			
			Если ЗаписьZipФайла <> Неопределено Тогда 
				ЗаписьZipФайла.Добавить(ПолноеИмяФайла);
			Иначе
				ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяФайла);
				ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
				ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ИмяФайла, ПутьВоВременномХранилище);
				Результат.Добавить(ОписаниеФайла);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Если архив подготовлен, записываем и помещаем его во временное хранилище.
	Если ЗаписьZipФайла <> Неопределено Тогда 
		ЗаписьZipФайла.Записать();
		ФайлАрхива = Новый Файл(ИмяАрхива);
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяАрхива);
		ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
		Если Прав(ПрефиксИмени, 1) = "." Тогда
			ИмяФайлаАрхива = ПрефиксИмени + "zip"
		Иначе
			ИмяФайлаАрхива = ПрефиксИмени + ".zip"
		КонецЕсли;
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ИмяФайлаАрхива, ПутьВоВременномХранилище);
		Результат.Добавить(ОписаниеФайла);
	КонецЕсли;
	
	УдалитьФайлы(ИмяВременнойПапки);
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция УникальноеИмяФайла(ИмяФайла)
	
	Файл = Новый Файл(ИмяФайла);
	ИмяБезРасширения = Файл.ИмяБезРасширения;
	Расширение = Файл.Расширение;
	Папка = Файл.Путь;
	
	Счетчик = 1;
	Пока Файл.Существует() Цикл
		Счетчик = Счетчик + 1;
		Файл = Новый Файл(Папка + ИмяБезРасширения + " (" + Счетчик + ")" + Расширение);
	КонецЦикла;
	
	Возврат Файл.ПолноеИмя;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСостояниеТабличныхПолей(Состояние, Элементы, НастройкиПечатныхФорм = Неопределено, УстановитьДляОбразца = Истина)
	
	Если УстановитьДляОбразца Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПечатнаяФормаОбразец, Состояние);
	КонецЕсли;
	
	Если НастройкиПечатныхФорм <> Неопределено Тогда
		Для Каждого РазделОтчета Из НастройкиПечатныхФорм Цикл
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы[РазделОтчета.ИмяРеквизита], Состояние);
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ВставитьКартинкиВHTML(ИмяФайлаHTML)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.Прочитать(ИмяФайлаHTML, КодировкаТекста.UTF8);
	ТекстHTML = ТекстовыйДокумент.ПолучитьТекст();
	
	ФайлHTML = Новый Файл(ИмяФайлаHTML);
	
	ИмяПапкиКартинок = ФайлHTML.ИмяБезРасширения + "_files";
	ПутьКПапкеКартинок = СтрЗаменить(ФайлHTML.ПолноеИмя, ФайлHTML.Имя, ИмяПапкиКартинок);
	
	// Ожидается, что в папке будут только картинки.
	ФайлыКартинок = НайтиФайлы(ПутьКПапкеКартинок, "*");
	
	Для Каждого ФайлКартинки Из ФайлыКартинок Цикл
		КартинкаТекстом = Base64Строка(Новый ДвоичныеДанные(ФайлКартинки.ПолноеИмя));
		КартинкаТекстом = "data:image/" + Сред(ФайлКартинки.Расширение,2) + ";base64," + Символы.ПС + КартинкаТекстом;
		
		ТекстHTML = СтрЗаменить(ТекстHTML, ИмяПапкиКартинок + "\" + ФайлКартинки.Имя, КартинкаТекстом);
	КонецЦикла;
		
	ТекстовыйДокумент.УстановитьТекст(ТекстHTML);
	ТекстовыйДокумент.Записать(ИмяФайлаHTML, КодировкаТекста.UTF8);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			
			УстановитьСостояниеТабличныхПолей("НеИспользовать", Элементы, НастройкиПечатныхФорм);
			
			БухгалтерскийУчетКлиентПереопределяемый.ПослеФормированияОтчета(ЭтотОбъект);
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		
		УстановитьСостояниеТабличныхПолей("НеИспользовать", Элементы, НастройкиПечатныхФорм);
		
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере(ИмяРеквизита)
	
	Результат = ЭтаФорма[ИмяРеквизита];
		
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	Результат = ЭтаФорма[НастройкаПечатнойФормы.ИмяРеквизита];
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере(НастройкаПечатнойФормы.ИмяРеквизита);
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ПредставлениеПериода =
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	
	ОбновитьНастройки();
	
	УправлениеФормой(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УстановитьСостояниеТабличныхПолей("НеАктуальность", Элементы, НастройкиПечатныхФорм);
	КонецЕсли;
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализацииАвтоматически(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройки()
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки()
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
КонецПроцедуры

&НаСервере
Функция ТабличныеДокументыДляПечати(ВыбранноеЗначение = Неопределено)
	
	Если ВыбранноеЗначение = Неопределено Тогда
		ВыбранноеЗначение = НастройкиПечатныхФорм;
	КонецЕсли;
	
	ТабличныеДокументы = Новый СписокЗначений;
	
	Для Каждого НастройкаПечатнойФормы Из ВыбранноеЗначение Цикл
		Если НастройкаПечатнойФормы.Печатать Тогда
			ПечатнаяФорма = ЭтотОбъект[НастройкаПечатнойФормы.ИмяРеквизита];
			ТабличныйДокумент = Новый ТабличныйДокумент;
			ТабличныйДокумент.Вывести(ПечатнаяФорма);
			ЗаполнитьЗначенияСвойств(ТабличныйДокумент, ПечатнаяФорма, "АвтоМасштаб,Вывод,ВысотаСтраницы,ДвусторонняяПечать,Защита,ИмяПринтера,КодЯзыкаМакета,КоличествоЭкземпляров,МасштабПечати,ОриентацияСтраницы,ПолеСверху,ПолеСлева,ПолеСнизу,ПолеСправа,РазборПоКопиям,РазмерКолонтитулаСверху,РазмерКолонтитулаСнизу,РазмерСтраницы,ТочностьПечати,ЧерноБелаяПечать,ШиринаСтраницы,ЭкземпляровНаСтранице");
			ТабличныйДокумент.КоличествоЭкземпляров = НастройкаПечатнойФормы.Количество;
			ТабличныеДокументы.Добавить(ТабличныйДокумент, НастройкаПечатнойФормы.Представление);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТабличныеДокументы;
КонецФункции

&НаКлиенте
Процедура Печать(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НастройкиПечатныхФорм", НастройкиПечатныхФорм);
	ОткрытьФорму("Отчет.КнигаУчетаДоходовИРасходов.Форма.ФормаВыбораРазделов", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОбъектыПечати", Новый СписокЗначений);
	ОткрытьФорму("ОбщаяФорма.СохранениеПечатнойФормы", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.СохранениеПечатнойФормы") Тогда
		
		Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение <> КодВозвратаДиалога.Отмена Тогда
			ФайлыВоВременномХранилище = ПоместитьТабличныеДокументыВоВременноеХранилище(ВыбранноеЗначение);
			СохранитьПечатныеФормы(ФайлыВоВременномХранилище, ВыбранноеЗначение.ПапкаДляСохранения);
		КонецЕсли;
		
	ИначеЕсли ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Отчет.КнигаУчетаДоходовИРасходов.Форма.ФормаВыбораРазделов") Тогда
		
		Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение <> КодВозвратаДиалога.Отмена Тогда
			ТабличныеДокументы = ТабличныеДокументыДляПечати(ВыбранноеЗначение);
			УправлениеПечатьюКлиент.РаспечататьТабличныеДокументы(ТабличныеДокументы, Новый СписокЗначений,
				ТабличныеДокументы.Количество() > 1);
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПечатныеФормы(СписокФайловВоВременномХранилище, Знач Папка = "")
	
	ПараметрыСохранения = Новый Структура("ПолучаемыеФайлы, Папка", СписокФайловВоВременномХранилище, Папка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьПечатныеФормыЗавершение", ЭтотОбъект, ПараметрыСохранения);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Функция СохранитьПечатныеФормыЗавершение(РасширениеПодключено, ПараметрыСохранения) Экспорт
	
	ПолучаемыеФайлы = ПараметрыСохранения.ПолучаемыеФайлы;
	
#Если ВебКлиент Тогда
	
	Если РасширениеПодключено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолучениеФайловПечатныхФормЗавершение", ЭтотОбъект);
		НачатьПолучениеФайлов(ОписаниеОповещения, ПолучаемыеФайлы);
	Иначе
		Для Каждого ФайлДляЗаписи Из ПолучаемыеФайлы Цикл
			ПолучитьФайл(ФайлДляЗаписи.Хранение, ФайлДляЗаписи.Имя);
		КонецЦикла;
	КонецЕсли;
	
#Иначе
	
	Папка = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПараметрыСохранения.Папка);
	
	Для Каждого ФайлДляЗаписи Из ПолучаемыеФайлы Цикл
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ФайлДляЗаписи.Хранение);
		ДвоичныеДанные.Записать(УникальноеИмяФайла(Папка + ФайлДляЗаписи.Имя));
	КонецЦикла;
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Сохранение успешно завершено'"));
	
#КонецЕсли
КонецФункции

&НаКлиенте
Процедура ПолучениеФайловПечатныхФормЗавершение(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПолученныеФайлы <> Неопределено Тогда
		ТекстОповещения = НСтр("ru = 'Сохранение успешно завершено'");
		ПоказатьОповещениеПользователя(ТекстОповещения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
