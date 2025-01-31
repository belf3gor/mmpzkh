&НаКлиенте
Перем ПараметрыОбработчикаОжидания; // Хранит параметры обработчика ожидания.

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

#Область ПроцедурыИФункцииОбщегоНазначения

&НаСервере
// Процедура добавляет дополнительное поле.
Процедура ДобавитьДополнительноеПоле(Поле, Заголовок)

	Если Отчет.ДополнительныеПоля.НайтиСтроки(Новый Структура("Поле", Поле)).Количество() = 0 Тогда
		НоваяСтрока = Отчет.ДополнительныеПоля.Добавить();
		НоваяСтрока.Представление = Заголовок;
		НоваяСтрока.Поле          = Поле;
		НоваяСтрока.Использование = Ложь;
	КонецЕсли;

КонецПроцедуры // ДобавитьДополнительноеПоле()

&НаСервере
// Процедура заполняет начальные настройки отчета.
//
Процедура ЗаполнитьДополнительныеПоля()
	
	ОбщаяПлощадьСпр = Справочники.УПЖКХ_ВидыПлощадей.ОбщаяПлощадь;
	ДобавитьДополнительноеПоле("П" + ОбщаяПлощадьСпр.Код, ОбщаяПлощадьСпр.Наименование);
	
	ДобавитьДополнительноеПоле("ДатаОткрытияЛС", "Дата открытия л/с");
	
	ДобавитьДополнительноеПоле("ДоляЛС", "Доля л/с");
	
	ДобавитьДополнительноеПоле("КоличествоЗарегистрированных", "Количество зарегистрированных");
	
КонецПроцедуры

&НаСервере
// Процедура добавляет поля в набор компоновки на сервере.
Процедура ДобавитьПоляВНаборКомпоновкиНаСервере()
	
	// Добавим поля с дополнительными свойствами в схему компоновки.
	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();
	Отчеты.КВП_ОтчетПоЛицевымСчетам.ДобавитьПоляВНаборКомпоновки(ПараметрыОтчета,
																	ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ЭтаФорма.СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(ПараметрыОтчета.СхемаКомпоновкиДанных, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
// Процедура вычисляет суммы ячеек на сервере.
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = УПЖКХ_ТиповыеМетодыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
// Подключаемый обработчик вычисления суммы ячеек.
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	УПЖКХ_ТиповыеМетодыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриОткрытии" формы.
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	ИБФайловая = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	Если ПодключитьОбработчикОжидания Тогда
		УПЖКХ_ТиповыеМетодыКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	УПЖКХ_ТиповыеМетодыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
	// Добавим дополнительные поля.
	Если Отчет.ДополнительныеПоля.Количество() = 0 Тогда
		ЗаполнитьДополнительныеПоля();
	КонецЕсли;
	
	// Добавим поля компоновки на сервере.
	ДобавитьПоляВНаборКомпоновкиНаСервере();
	
	// Сформируем отчет если необходимо формировать при открытии.
	Если СформироватьПриОткрытии Тогда
		СформироватьОтчет(Команды.СформироватьОтчет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПередЗакрытием" формы.
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриЗакрытии" формы.
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	УПЖКХ_ТиповыеМетодыКлиент.ПриЗакрытии(ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
// Процедура возникает при сохранении настроек на сервере.
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	УПЖКХ_ТиповыеМетодыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
// Процедура возникает при загрузке настроек на сервере.
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	УПЖКХ_ТиповыеМетодыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	УправлениеФормой(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Процедура возникает при загрузке варианта на сервере.
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	УПЖКХ_ТиповыеМетодыВызовСервера.УстановитьНастройкиПоУмолчанию(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
// Обработчик события "ПриИзменении" поля "Период".
Процедура ПериодНачалоПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" поля "Организация".
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

/////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ РЕЗУЛЬТАТА

#Область ОбработчикиСобытийПоляРезультата

&НаКлиенте
// Обработчик события "ОбработкаРасшифровки" поля "Результат".
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ОбработкаДополнительнойРасшифровки" поля "Результат".
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриАктивизацииОбласти" поля "Результат".
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОТБОРЫ

#Область ОбработчикиСобытийГруппыОтборы

&НаКлиенте
// Обработчик события "ПриИзменении" группы "Отборы".
Процедура ОтборыПриИзменении(Элемент)
	
	УПЖКХ_ТиповыеМетодыКлиент.ОтборыПриИзменении(ЭтаФорма, Элемент);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПередНачаломДобавления" группы "Отборы".
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	УПЖКХ_ТиповыеМетодыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПередНачаломИзменения" группы "Отборы".
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	УПЖКХ_ТиповыеМетодыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПравоеЗначениеНачалоВыбора" группы "Отборы".
Процедура ОтборыПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
	УПЖКХ_ТиповыеМетодыКлиент.ОтборыПравоеЗначениеНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора,
																СтандартнаяОбработка, СписокПараметров);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ДОПОЛНИТЕЛЬНЫЕ ПОЛЯ

#Область ОбработчикиСобытийГруппыДополнительныеПоля

&НаКлиенте
// Обработчик события "ПриИзменении" поля "РазмещениеДополнительныхПолей".
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" поля "ДополнительныеПоля".
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" поля "ПередНачаломДобавления".
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	УПЖКХ_ТиповыеМетодыКлиент.ДополнительныеПоляПередНачаломДобавления(ЭтаФорма, Элемент, Отказ,
																		Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" поля "ПередНачаломИзменения".
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	УПЖКХ_ТиповыеМетодыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОФОРМЛЕНИЕ

#Область ОбработчикиСобытийГруппыОформление

&НаКлиенте
// Обработчик события "ПриИзменении" поля "ВыводитьЗаголовок".
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" поля "ВыводитьПодвал".
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
// Обработчик команды "ДополнительныеПоляСнятьФлажки".
Процедура ДополнительныеПоляСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик команды "ДополнительныеПоляУстановитьФлажки".
Процедура ДополнительныеПоляУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

#Область ОбработчикиКомандФормы

&НаКлиенте
// Обработчик команды "СформироватьОтчет".
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда		
		УПЖКХ_ТиповыеМетодыКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик команды "ПанельНастроек".
Процедура ПанельНастроек(Команда)
	
	Элементы.ГруппаПанельНастроек.Видимость = Не Элементы.ГруппаПанельНастроек.Видимость;
	УПЖКХ_ТиповыеМетодыКлиентСервер.ИзменитьЗаголовокКнопкиПанельНастроек(
		Элементы.ПанельНастроек, Элементы.ГруппаПанельНастроек.Видимость);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
// Процедура проверяет, выполнено ли задание.
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат УПЖКХ_ТиповыеМетодыСервер.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
// Процедура готовит параметры на сервере.
Функция ПодготовитьПараметрыОтчетаНаСервере()
	
	ПараметрыОтчета = Новый Структура;
	
	ПараметрыОтчета.Вставить("Организация"                      , Отчет.Организация);
	ПараметрыОтчета.Вставить("Период"                           , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("Подразделение"                    , Отчет.Подразделение);
	ПараметрыОтчета.Вставить("ВключатьОбособленныеПодразделения", Отчет.ВключатьОбособленныеПодразделения);
	ПараметрыОтчета.Вставить("РежимРасшифровки"                 , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("ВыводитьПодвал"                   , ВыводитьПодвал);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления"                  , МакетОформления);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , 
																  УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	ПараметрыОтчета.Вставить("ДополнительныеПоля"               , Отчет.ДополнительныеПоля.Выгрузить());
	ПараметрыОтчета.Вставить("РаскрыватьУслуги"                 , Отчет.РаскрыватьУслуги);
	ПараметрыОтчета.Вставить("РазмещениеДополнительныхПолей"    , Отчет.РазмещениеДополнительныхПолей);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
// Процедура обновляет текст заголовка.
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = "Отчет по лицевым счетам на " + Формат(Отчет.НачалоПериода, "ДФ=dd.MM.yyyy") + " г.";
	
	Если ЗначениеЗаполнено(Отчет.Организация) Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " "
						+ УПЖКХ_ТиповыеМетодыВызовСервера.ПолучитьТекстОрганизация(Отчет.Организация,
																					Отчет.ВключатьОбособленныеПодразделения);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;
	
КонецПроцедуры

&НаКлиенте
// Функция получает запрещенные поля.
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Период");
	
	Если Режим = "Отбор" ИЛИ Режим = "Порядок" Тогда
		УПЖКХ_ТиповыеМетодыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
// Функция формирует отчет на сервере.
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИБФайловая = УПЖКХ_ТиповыеМетодыСервер.ИнформационнаяБазаФайловая();
	
	УПЖКХ_ТиповыеМетодыСервер.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();
	
	РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Ложь);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	Если ИБФайловая Тогда
		УПЖКХ_ТиповыеМетодыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		
		ПараметрыВыполнения = УПЖКХ_ТиповыеМетодыСервер.ПараметрыВыполненияВФоне(Неопределено);
		ПараметрыВыполнения.НаименованиеФоновогоЗадания = "Отчеты.КВП_ОтчетПоЛицевымСчетам.СформироватьОтчет";
		
		ПараметрыПроцедуры = Новый Массив;
		ПараметрыПроцедуры.Добавить(ПараметрыОтчета);
		ПараметрыПроцедуры.Добавить(АдресХранилища);
		
		Задание = УПЖКХ_ТиповыеМетодыСервер.ЗапуститьФоновоеЗаданиеСКонтекстомКлиента("УПЖКХ_ТиповыеМетодыВызовСервера.СформироватьОтчет",
																						ПараметрыВыполнения,
																						ПараметрыПроцедуры);
		
		Попытка
			Задание.ОжидатьЗавершения();
		Исключение
			// Специальная обработка не требуется, возможно исключение вызвано истечением времени ожидания.
		КонецПопытки;
		
		Статус = УПЖКХ_ТиповыеМетодыСервер.ОперацияВыполнена(Задание.УникальныйИдентификатор);
		
		Если Статус.Статус = "Выполнено" Тогда
			РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанныеНаСервере();
	КонецЕсли;
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.СкрыватьНастройкиПриФормированииОтчета(ЭтаФорма);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
// Управляет видимостью элементов формы.
Процедура УправлениеФормой(Форма)
	
	Отчет    = Форма.Отчет;
	Элементы = Форма.Элементы;
	
КонецПроцедуры

&НаСервере
// Процедура загружает подготовленные данные на сервере.
Процедура ЗагрузитьПодготовленныеДанныеНаСервере()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат         = РезультатВыполнения.Результат;
	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
КонецПроцедуры

&НаКлиенте
// Процедуры проверяет выполнение задания.
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанныеНаСервере();
			УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			УПЖКХ_ТиповыеМетодыКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,
				Истина);
		КонецЕсли;
	Исключение
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
// Функция возвращает параметры выбора значения отбора.
Функция ПолучитьПараметрыВыбораЗначенияОтбора()
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Организация", Отчет.Организация);
	
	Возврат СписокПараметров;
	
КонецФункции

#КонецОбласти