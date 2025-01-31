&НаКлиенте
Перем ПараметрыОбработчикаОжидания; // Хранит параметры обработчика ожидания.

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

#Область ПроцедурыИФункцииОбщегоНазначения

&НаСервере
// Процедура подготовки параметров учета.
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Дата",        Отчет.Дата);
	ПараметрыОтчета.Вставить("НомерФормы",  Отчет.НомерФормы);
	ПараметрыОтчета.Вставить("Организация", Отчет.Организация);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
// Процедура формирует отчет на сервере.
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИБФайловая = УПЖКХ_ТиповыеМетодыСервер.ИнформационнаяБазаФайловая();
	
	УПЖКХ_ТиповыеМетодыСервер.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Отчеты.КВП_ФормыТСЖ.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = УПЖКХ_ТиповыеМетодыСервер.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Отчеты.КВП_ФормыТСЖ.СформироватьОтчет", 
			ПараметрыОтчета, 
			УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
		
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
// Процедура загрузки подготовленных данных.
Процедура ЗагрузитьПодготовленныеДанные()
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
// Процедуры проверяет выполнение задания.
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
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

&НаСервереБезКонтекста
// Процедура проверяет, выполнено ли задание.
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат УПЖКХ_ТиповыеМетодыСервер.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
// Управляет видимостью элементов формы.
Процедура УправлениеФормой(Форма)

	Отчет    = Форма.Отчет;
	Элементы = Форма.Элементы;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
// Процедура обновляет текст заголовка.
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	Форма.Заголовок = Отчет.ПредставлениеФормы;
	
КонецПроцедуры

&НаСервере
// Устанавливает начальные настройки.
Процедура УстановитьНачальныеНастройки()
	
	Отчет.Дата = ТекущаяДатаСеанса();
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка настроек печати по умолчанию. Если настройки были изменены, они будут загружены при формировании отчета.
	Результат.АвтоМасштаб = Истина;
	
	УстановитьНачальныеНастройки();
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриОткрытии" формы.
Процедура ПриОткрытии(Отказ)
	
	ИнициализацияРеквизитов();
	
	Если Не ЗначениеЗаполнено(Отчет.НомерФормы) Тогда
		
		ЭлементФормы = Элементы.НомерФормы.СписокВыбора[0];
		
		Отчет.НомерФормы         = ЭлементФормы.Значение;
		Отчет.ПредставлениеФормы = ЭлементФормы.Представление;
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриЗакрытии" формы.
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	СохранениеРеквизитов();
	
	УПЖКХ_ТиповыеМетодыКлиент.ПриЗакрытии(ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
// Процедура возникает при сохранении настроек на сервере.
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	УПЖКХ_ТиповыеМетодыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки, Истина);
	
КонецПроцедуры

&НаСервере
// Процедура возникает при загрузке настроек на сервере.
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если Не ИспользоватьРучныеНастройки Тогда
		
		УПЖКХ_ТиповыеМетодыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки, Истина);
		
		ОбновитьТекстЗаголовка(ЭтаФорма);
		
		УправлениеФормой(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Загружает сохраненные параметры отчета.
//
Процедура ИнициализацияРеквизитов()
	
	СтруктураПараметров = УПЖКХ_ТиповыеМетодыВызовСервера.ХранилищеОбщихНастроекЗагрузить("ПараметрыОтчета_КВП_ФормыТСЖ");
	
	Если ТипЗнч(СтруктураПараметров) = Тип("Структура") Тогда
		СтруктураПараметров.Свойство("Организация", Отчет.Организация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Производит сохранение параметров отчета.
//
Процедура СохранениеРеквизитов()
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("Организация", Отчет.Организация);
	
	УПЖКХ_ТиповыеМетодыВызовСервера.ХранилищеОбщихНастроекСохранить("ПараметрыОтчета_КВП_ФормыТСЖ",,
																	СтруктураПараметров);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Обработчик события "ПриИзменении" поля "Организация".
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" поля "НомерФормы".
Процедура НомерПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	Отчет.ПредставлениеФормы = Элемент.ТекстРедактирования;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" поля "Дата".
Процедура ДатаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

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

#КонецОбласти