////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
//

#Область ПроцедурыИФункцииОбщегоНазначения

&НаСервере
// Создает набор записей в регистре сведений КВП_НастройкиЗагрузкиИзАС.
//
Процедура СоздатьНаборЗаписей()
	
	ЗагрузкаИзАС = Перечисления.КВП_ВидыНастроекЗагрузкиИзАС.ЗагрузкаИзСистемПриемаПлатежей;

	НаборЗаписей = РегистрыСведений.КВП_НастройкиЗагрузкиИзАС.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Организация.Установить(Объект.Организация);
	НаборЗаписей.Отбор.ВидОперации.Установить(ЗагрузкаИзАС);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Организация         = Объект.Организация;
	НоваяЗапись.ВидОперации         = ЗагрузкаИзАС;
	НоваяЗапись.ФорматФайлаЗагрузки = Настр_ФорматФайлаЗагрузки;
	НоваяЗапись.ИмяФайлаЗагрузки    = Настр_ИмяФайлаЗагрузки;
	НоваяЗапись.Контрагент          = Настр_Контрагент;
	НоваяЗапись.КорректировкаДолга  = Настр_КорректировкаДолга;
	НоваяЗапись.ДоговорКонтрагента  = Настр_ДоговорКонтрагента;
	
	НаборЗаписей.Записать();
	
	Объект.ФорматФайлаЗагрузки = Настр_ФорматФайлаЗагрузки;
	Объект.ИмяФайлаЗагрузки    = Настр_ИмяФайлаЗагрузки;
	Объект.Контрагент          = Настр_Контрагент;
	Объект.КорректировкаДолга  = Настр_КорректировкаДолга;
	Объект.ДоговорКонтрагента  = Настр_ДоговорКонтрагента;
	
	Объект.НастройкаЗаполнения.Загрузить(ДанныеФормыВЗначение(Настр_ТаблицаНастроекПриЗагрузке, Тип("ТаблицаЗначений")));
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЗагружатьИзКаталога", Объект.ЗагружатьИзКаталога);
	СтруктураПараметров.Вставить("СпособГруппировки",   Объект.СпособГруппировки);
	СтруктураПараметров.Вставить("Организация",         Объект.Организация);
	
	УПЖКХ_ТиповыеМетодыВызовСервера.ХранилищеОбщихНастроекСохранить("ПараметрыВыгрузки_КВП_ЗагрузкаРеестраПлатежейДоп",
																	, СтруктураПараметров);
	
	ЗаполнитьДанныеВХранилище();
	
КонецПроцедуры

&НаСервере
// Заполняет настройки загрузки файла.
//
Процедура ОбновитьРеквизиты()
	
	ЗначенияРеквизитов =
		УПЖКХ_ТиповыеМетодыВызовСервера.ХранилищеОбщихНастроекЗагрузить("КВП_ЗагрузкаРеестраПлатежей_Реквизиты");
		
	Если ТипЗнч(ЗначенияРеквизитов) = Тип("Структура") Тогда
		Если ЗначенияРеквизитов.Свойство("Организация") Тогда
			Объект.Организация = ЗначенияРеквизитов.Организация;
		КонецЕсли;
		
		Если ЗначенияРеквизитов.Свойство("ФорматФайлаЗагрузки") Тогда
			Объект.ФорматФайлаЗагрузки = ЗначенияРеквизитов.ФорматФайлаЗагрузки;
		КонецЕсли;
		
		Если ЗначенияРеквизитов.Свойство("ИмяФайлаЗагрузки") Тогда
			Объект.ИмяФайлаЗагрузки = ЗначенияРеквизитов.ИмяФайлаЗагрузки;
		КонецЕсли;
		
		Если ЗначенияРеквизитов.Свойство("Контрагент") Тогда
			Объект.Контрагент = ЗначенияРеквизитов.Контрагент;
		КонецЕсли;
		
		Если ЗначенияРеквизитов.Свойство("ДоговорКонтрагента") Тогда
			Объект.ДоговорКонтрагента = ЗначенияРеквизитов.ДоговорКонтрагента;
		КонецЕсли;
		
		Если ЗначенияРеквизитов.Свойство("КорректировкаДолга") Тогда
			Объект.КорректировкаДолга = ЗначенияРеквизитов.КорректировкаДолга;
		КонецЕсли;
		
		Если ЗначенияРеквизитов.Свойство("ЗагружатьИзКаталога") Тогда
			Объект.ЗагружатьИзКаталога = ЗначенияРеквизитов.ЗагружатьИзКаталога;
		КонецЕсли;
		
		Если ЗначенияРеквизитов.Свойство("СпособГруппировки") И ЗначенияРеквизитов.СпособГруппировки <> 0 Тогда 
			Объект.СпособГруппировки = ЗначенияРеквизитов.СпособГруппировки;
		Иначе
			Объект.СпособГруппировки = 1;
		КонецЕсли;
		
		Если ЗначенияРеквизитов.Свойство("НастройкаЗаполнения") Тогда
			Объект.НастройкаЗаполнения.Загрузить(ЗначенияРеквизитов.НастройкаЗаполнения);
		КонецЕсли;
		
	КонецЕсли;
	
	Настр_ФорматФайлаЗагрузки = Объект.ФорматФайлаЗагрузки;
	Настр_ИмяФайлаЗагрузки    = Объект.ИмяФайлаЗагрузки;
	Настр_Контрагент          = Объект.Контрагент;
	Настр_КорректировкаДолга  = Объект.КорректировкаДолга;
	Настр_ДоговорКонтрагента  = Объект.ДоговорКонтрагента;
	
	ТЗ = ДанныеФормыВЗначение(Настр_ТаблицаНастроекПриЗагрузке, Тип("ТаблицаЗначений"));
	
	ТЗ = Объект.НастройкаЗаполнения.Выгрузить();
	ЗначениеВДанныеФормы(ТЗ, Настр_ТаблицаНастроекПриЗагрузке); 
	
КонецПроцедуры  //ПролучитьДанные()

&НаКлиентеНаСервереБезКонтекста
// Устанавливает видимость элементов.
//
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Элементы.Настр_ИмяФайлаЗагрузки.Заголовок = ?(Объект.ЗагружатьИзКаталога, "Каталог загрузки", "Файл загрузки");
	
	Элементы.Настр_Контрагент.Видимость   = Форма.Настр_КорректировкаДолга;
	Элементы.ДоговорКонтрагента.Видимость = Форма.Настр_КорректировкаДолга;
	
КонецПроцедуры // УправлениеФормой()

&НаСервере
// Проверяет формат файла.
//
Процедура ПроверитьФорматФайла(Структура)
	
	Если Структура.ВыбранноеЗначение.ФорматФайла <> Структура.НачЗначениеФорматФайлаЗагрузки.ФорматФайла Тогда
		Настр_ИмяФайлаЗагрузки = "";
	КонецЕсли;

КонецПроцедуры	

&НаСервере
// Получает формат файла записи.
//
Функция ПолучитьФорматФайла()
	
	Возврат Настр_ФорматФайлаЗагрузки.ФорматФайла;	
	
КонецФункции

&НаСервере
// Сохраняет настройки загрузки реестра платежей.
//
Процедура ЗаполнитьДанныеВХранилище()

	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Организация", Объект.Организация);
	СтруктураРеквизитов.Вставить("ФорматФайлаЗагрузки", Объект.ФорматФайлаЗагрузки);
	СтруктураРеквизитов.Вставить("ИмяФайлаЗагрузки", Объект.ИмяФайлаЗагрузки);
	СтруктураРеквизитов.Вставить("Контрагент", Объект.Контрагент);
	СтруктураРеквизитов.Вставить("ДоговорКонтрагента", Объект.ДоговорКонтрагента);
	СтруктураРеквизитов.Вставить("КорректировкаДолга", Объект.КорректировкаДолга);
	СтруктураРеквизитов.Вставить("ЗагружатьИзКаталога", Объект.ЗагружатьИзКаталога);
	СтруктураРеквизитов.Вставить("СпособГруппировки", Объект.СпособГруппировки);
	СтруктураРеквизитов.Вставить("НастройкаЗаполнения", Объект.НастройкаЗаполнения.Выгрузить());
	
	УПЖКХ_ТиповыеМетодыВызовСервера.ХранилищеОбщихНастроекСохранить("КВП_ЗагрузкаРеестраПлатежей_Реквизиты",
																	, СтруктураРеквизитов);

КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьРеквизиты();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриОткрытии" формы.
//
Процедура ПриОткрытии(Отказ)
	
	// Влияет на оформление формы и на выбор файлов загрузки.
	#Если ВебКлиент Тогда
		ЭтоВебКлиент = Истина;
	#Иначе
		ЭтоВебКлиент = Ложь;
	#КонецЕсли
	
	Элементы.ГруппаЗагружатьИзКаталога.Видимость = Не ЭтоВебКлиент;
	
КонецПроцедуры

#КонецОбласти

/////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ
//

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Обработчик события "Нажатие" кнопки "ОК".
//
Процедура ОК(Команда)
	
	Если НЕ ЗначениеЗаполнено(Настр_ФорматФайлаЗагрузки) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("Не выбран формат файла загрузки.");
		Возврат;
	КонецЕсли;
	
	// Проверим, указан ли хотя бы один вид документа для формирования.
	НайденныеНастройки = Настр_ТаблицаНастроекПриЗагрузке.НайтиСтроки(Новый Структура("Пометка", Истина));
	Если НайденныеНастройки.Количество() = 0 Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("В настройках загрузки должен быть указан хотя бы один вид документов, создаваемых при загрузке реестра!");
		Возврат;
	КонецЕсли;
	
	// В настройках загрузки при установленном флаге "Корректировка долга" должен быть указан контрагент,
	// а также обязательно выбран вид документа "Регистрация оплаты" из создаваемых при загрузке реестра.
	Если Настр_КорректировкаДолга Тогда
		
		Если Настр_Контрагент.Пустая() Тогда
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("Не выбрана обслуживающая организация.");
			Возврат;
		КонецЕсли;
		
		РОДляФормирования = Настр_ТаблицаНастроекПриЗагрузке.НайтиСтроки(Новый Структура("Документ, Пометка", "Регистрация оплаты", Истина));
		Если РОДляФормирования.Количество() = 0 Тогда
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("При установленной настройке ""Корректировка долга"" среди видов документов, " +
															 "создаваемых при загрузке платежных документов, должен быть выбран вид документа ""Регистрация оплаты"".");
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	СоздатьНаборЗаписей();
	
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "НачалоВыбора" поля ввода Настр_ФорматФайлаЗагрузки.
//
Процедура Настр_ФорматФайлаЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ВидОперации",
							 ПредопределенноеЗначение("Перечисление.КВП_ВидыНастроекЗагрузкиИзАС.ЗагрузкаИзСистемПриемаПлатежей"));
	СтруктураПараметров.Вставить("Отбор", СтруктураОтбора);
	
	ОткрытьФорму("Справочник.КВП_НастройкиЗагрузкиВыгрузки.ФормаВыбора", СтруктураПараметров, ЭтаФорма,,,, Новый ОписаниеОповещения("ОбработатьВыборНастройкиВыгрузки", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
// Обработка оповещения о выборе настройки выгрузки.
Процедура ОбработатьВыборНастройкиВыгрузки(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	НачЗначениеФорматФайлаЗагрузки = Настр_ФорматФайлаЗагрузки;
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Структура = Новый Структура;
	
	Структура.Вставить("ВыбранноеЗначение", ВыбранноеЗначение);
	Структура.Вставить("НачЗначениеФорматФайлаЗагрузки", НачЗначениеФорматФайлаЗагрузки);
	
	Настр_ФорматФайлаЗагрузки = ВыбранноеЗначение;
	
	ПроверитьФорматФайла(Структура);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" элемента ЗагружатьИзКаталога.
//
Процедура ЗагружатьИзКаталогаПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	Настр_ИмяФайлаЗагрузки = "";
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события "ПриОкончанииРедактирования" табличной части "ТаблицаНастроек".
//
Процедура Настр_ТаблицаНастроекПриЗапускеПередОкончаниемРедактирования(Элемент, НоваяСтрока,
																	   ОтменаРедактирования, Отказ)
	
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	Если ТекущаяСтрока.Документ = "Регистрация оплаты" Тогда
		Если ТекущаяСтрока.Пометка Тогда
			Элементы.ГруппаРегистрацияОплаты.Видимость = Истина;
		Иначе
			Элементы.ГруппаРегистрацияОплаты.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события "ПередНачаломДобавления" табличной части "ТаблицаНастроек".
//
Процедура Настр_ТаблицаНастроекПриЗагрузкеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события "ПередУдалением" табличной части "ТаблицаНастроек".
//
Процедура Настр_ТаблицаНастроекПриЗагрузкеПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" колонки "Пометка" таблицы "Настр_ТаблицаНастроекПриЗагрузке".
//
Процедура Настр_ТаблицаНастроекПриЗагрузкеПометкаПриИзменении(Элемент)
	
	СтрокаТаблицыНастроек = Элемент.Родитель.ТекущиеДанные;
	
	Если СтрокаТаблицыНастроек.Документ = "Поступление на расчетный счет" Тогда
		Если СтрокаТаблицыНастроек.Пометка Тогда
			Настр_КорректировкаДолга = НЕ СтрокаТаблицыНастроек.Пометка;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "НачалоВыбора" элемента ФайлЗагрузки.
//
Процедура Настр_ИмяФайлаЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Настр_ФорматФайлаЗагрузки) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не выбран формат файла загрузки.";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	ФорматФайла = ПолучитьФорматФайла();
	
	ВыборФайла(ФорматФайла);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" элемента Настр_КорректировкаДолга.
//
Процедура Настр_КорректировкаДолгаПриИзменении(Элемент)
	
	Элементы.Настр_Контрагент.Видимость   = Настр_КорректировкаДолга;
	Элементы.ДоговорКонтрагента.Видимость = Настр_КорректировкаДолга;
	
	СтрокиНастройкиПРС = Настр_ТаблицаНастроекПриЗагрузке.НайтиСтроки(Новый Структура("Документ", "Поступление на расчетный счет"));
	
	Если СтрокиНастройкиПРС.Количество() > 0 Тогда
		СтрокаНастройки = СтрокиНастройкиПРС[0];
		Если Настр_КорректировкаДолга Тогда
			СтрокаНастройки.Пометка = НЕ Настр_КорректировкаДолга;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обрабатывает начало выбора договора контрагента.
//
Процедура ДоговорКонтрагентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Если контрагент не выбран, то при открытии формы выбора справочника "Договоры контрагентов" произойдет конфигураторская ошибка.
	Если Настр_Контрагент.Пустая() Тогда
		СтандартнаяОбработка = Ложь;
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю("Не выбран контрагент.");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Открывает диалог выбора файла
//
// Параметры:
//  Элемент                - Элемент управления, для которого выбираем файл.
// 
Процедура ВыборФайла(ФорматФайлаЗагрузки)
	
	Если Объект.ЗагружатьИзКаталога Тогда 
		ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ДиалогВыбораФайла.Заголовок = "Выберите каталог";
	Иначе
		
		ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		
		Если ФорматФайлаЗагрузки = "TXT" Тогда
			ДиалогВыбораФайла.Фильтр     = "Файл данных (*.txt)|*.txt";
			ДиалогВыбораФайла.Расширение = "txt";
		ИначеЕсли ФорматФайлаЗагрузки = "CSV" Тогда
			ДиалогВыбораФайла.Фильтр     = "Файл данных (*.csv)|*.csv";
			ДиалогВыбораФайла.Расширение = "csv";
		ИначеЕсли ФорматФайлаЗагрузки = "XLS" Тогда
			ДиалогВыбораФайла.Фильтр     = "Файл данных (*.xls)|*.xls|(*.xlsx)|*.xlsx";
			ДиалогВыбораФайла.Расширение = "xls";
		ИначеЕсли ФорматФайлаЗагрузки = "DBF" Тогда
			ДиалогВыбораФайла.Фильтр     = "Файл данных (*.dbf)|*.dbf";
			ДиалогВыбораФайла.Расширение = "dbf";
		ИначеЕсли ФорматФайлаЗагрузки = "XML" Тогда
			ДиалогВыбораФайла.Фильтр     = "Файл данных (*.xml)|*.xml";
			ДиалогВыбораФайла.Расширение = "xml";
		КонецЕсли;
		
		ДиалогВыбораФайла.Заголовок = "Выберите файл";
		
	КонецЕсли;
	
	ДиалогВыбораФайла.ПредварительныйПросмотр = Ложь;
	ДиалогВыбораФайла.ИндексФильтра           = 0;
	ДиалогВыбораФайла.ПолноеИмяФайла          = Настр_ИмяФайлаЗагрузки;
	
	Если ДиалогВыбораФайла.Выбрать() Тогда
		Если Объект.ЗагружатьИзКаталога Тогда 
			Настр_ИмяФайлаЗагрузки = ДиалогВыбораФайла.Каталог;
		Иначе
			Настр_ИмяФайлаЗагрузки = ДиалогВыбораФайла.ПолноеИмяФайла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры //ВыборФайла()

#КонецОбласти
