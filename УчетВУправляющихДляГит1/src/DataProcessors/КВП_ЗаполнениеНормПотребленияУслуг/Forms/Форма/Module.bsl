
//////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ УПРАВЛЕНИЯ КНОПКАМИ ЗАПОЛНЕНИЯ

#Область УправлениеКнопкамиЗаполнения

&НаСервере
// Процедура добавляет кнопки в подменю "Заполнить" и "Подбор".
Процедура УстановитьВидимостьКнопокЗаполнения()
	
	Элементы.КнопкаЗаполнитьЛицевыеСчета.Видимость = Объект.НормаНаЛицевойСчет;
	Элементы.КнопкаЗаполнитьПодъезды.Видимость     = Объект.НормаНаЛицевойСчет;
	
	Элементы.КнопкаПодборЛицевыеСчета.Видимость = Объект.НормаНаЛицевойСчет;
	Элементы.КнопкаПодборПодъезды.Видимость     = Объект.НормаНаЛицевойСчет;
	
КонецПроцедуры // ДобавитьКнопкиУстановкиНормыНаЛС()

#КонецОбласти

//////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область ВспомогательныеПроцедурыИФункции

&НаСервере
// Функция проверяет, есть ли лицевые счета или подъезды в списке объектов.
Функция ЕстьЛицевыеСчетаПодъездыВОбъектах()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Объекты.Объект
	|ПОМЕСТИТЬ Объекты
	|ИЗ
	|	&Объекты КАК Объекты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Объекты.Объект
	|ПОМЕСТИТЬ СпПодъездыЛС
	|ИЗ
	|	Объекты КАК Объекты
	|ГДЕ
	|	(Объекты.Объект ССЫЛКА Справочник.КВП_Подъезды
	|			ИЛИ Объекты.Объект ССЫЛКА Справочник.КВП_ЛицевыеСчета)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Объекты.Объект
	|ИЗ
	|	СпПодъездыЛС КАК Объекты";
	
	Запрос.УстановитьПараметр("Объекты", Объект.Объекты.Выгрузить());
	СписокОбъектов = Запрос.Выполнить().Выгрузить();
	
	Возврат (СписокОбъектов.Количество() > 0);
	
КонецФункции

&НаСервере
// Функция удаляет лицевые счета и подъезды из списка объектов.
Процедура ОчиститьЛицевыеСчетаПодъезды()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Объекты.Объект
	|ПОМЕСТИТЬ Объекты
	|ИЗ
	|	&Объекты КАК Объекты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Объекты.Объект
	|ПОМЕСТИТЬ СпПодъездыЛС
	|ИЗ
	|	Объекты КАК Объекты
	|ГДЕ
	|	(Объекты.Объект ССЫЛКА Справочник.КВП_Подъезды
	|			ИЛИ Объекты.Объект ССЫЛКА Справочник.КВП_ЛицевыеСчета)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Объекты.Объект
	|ИЗ
	|	СпПодъездыЛС КАК Объекты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Объекты.Объект
	|ИЗ
	|	Объекты КАК Объекты
	|ГДЕ
	|	НЕ Объекты.Объект В
	|				(ВЫБРАТЬ
	|					ПодъездыЛС.Объект
	|				ИЗ
	|					СпПодъездыЛС КАК ПодъездыЛС)";
	
	Запрос.УстановитьПараметр("Объекты", Объект.Объекты.Выгрузить());
	
	Объект.Объекты.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
// Процедура удаляет выбранные для установки нормы объекты.
Процедура ПроверитьИУдалитьВыбранныеОбъектыИНормы()
	
	ОчищатьОбъекты = Ложь;
	
	Если Не Объект.НормаНаЛицевойСчет 
	   И ЕстьЛицевыеСчетаПодъездыВОбъектах() Тогда
		
		ТекстВопроса = "Выбранные лицевые счета и подъезды будут удалены. Продолжить?";
		ДопПараметры = Новый Структура("ОчищатьОбъекты", ОчищатьОбъекты);
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбработатьРезультатВопросаУдалитьЛицевыеСчетаИПодъезды", ЭтаФорма, ДопПараметры),
					   ТекстВопроса,
					   РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	ПроверитьИУдалитьВыбранныеОбъектыИНормыПродолжение(ОчищатьОбъекты);
	
КонецПроцедуры // ПроверитьИУдалитьВыбранныеОбъектыИНормы()

&НаКлиенте
// Обработчик результата вопроса, вызванного в процедуре "ПроверитьИУдалитьВыбранныеОбъектыИНормы()".
Процедура ОбработатьРезультатВопросаУдалитьЛицевыеСчетаИПодъезды(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОчищатьОбъекты = (РезультатВопроса = КодВозвратаДиалога.Да);
	
	Если НЕ ОчищатьОбъекты Тогда
		Объект.НормаНаЛицевойСчет = НЕ Объект.НормаНаЛицевойСчет;
		Возврат;
	Иначе
		ОчиститьЛицевыеСчетаПодъезды();
		УстановитьВидимостьКнопокЗаполнения();
	КонецЕсли;
	
	ПроверитьИУдалитьВыбранныеОбъектыИНормыПродолжение(ОчищатьОбъекты);
	
КонецПроцедуры // ОбработатьРезультатВопросаУдалитьЛицевыеСчетаИПодъезды()

&НаКлиенте
// Процедура-продолжение процедуры "ПроверитьИУдалитьВыбранныеОбъектыИНормы()".
Процедура ПроверитьИУдалитьВыбранныеОбъектыИНормыПродолжение(ОчищатьОбъекты)
	
	// Очистим нормы, не соответствующие настройке "НормаНаЛицевойСчет".
	МассивСтрокНекорректныхНорм = Новый Массив;
	Для Каждого ТекСтрока Из Объект.Услуги Цикл
		Если Не ТекСтрока.НормаПотребления.Пустая() 
		  И Не УПЖКХ_ОбщегоНазначенияСервер.ПолучитьЗначениеРеквизита(ТекСтрока.НормаПотребления, "НормаНаЛицевойСчет") = 
					Объект.НормаНаЛицевойСчет Тогда
			МассивСтрокНекорректныхНорм.Добавить(ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивСтрокНекорректныхНорм.Количество() > 0 Тогда
		
		Если ОчищатьОбъекты Тогда
			ЗаполнитьНормыПотребленияПустымиСсылками(МассивСтрокНекорректныхНорм);
		Иначе
			
			ТекстВопроса = "Выбранные нормы, не соответствующие типу "
						 + ?(Объект.НормаНаЛицевойСчет, """Лицевой счет""", """Здание / сооружение""")
						 + " будут очищены! Продолжить?";
			
			ДопПараметры = Новый Структура("МассивСтрокНекорректныхНорм", МассивСтрокНекорректныхНорм);
			ПоказатьВопрос(Новый ОписаниеОповещения("ОбработатьРезультатВопросаОчиститьНормыПотребления", ЭтаФорма, ДопПараметры),
						   ТекстВопроса,
						   РежимДиалогаВопрос.ДаНет);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьИУдалитьВыбранныеОбъектыИНормыПродолжение()

&НаКлиенте
// Обработчик результата вопроса, вызванного в процедуре "ПроверитьИУдалитьВыбранныеОбъектыИНормыПродолжение()".
Процедура ОбработатьРезультатВопросаОчиститьНормыПотребления(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьНормыПотребленияПустымиСсылками(ДополнительныеПараметры.МассивСтрокНекорректныхНорм);
	Иначе
		Объект.НормаНаЛицевойСчет = НЕ Объект.НормаНаЛицевойСчет;
	КонецЕсли;
	
КонецПроцедуры // ОбработатьРезультатВопросаОчиститьНормыПотребления()

&НаКлиенте
// Процедура заполняет нормы потребления пустыми ссылками.
Процедура ЗаполнитьНормыПотребленияПустымиСсылками(МассивСтрокНекорректныхНорм)
	
	ПустаяНорма = ПредопределенноеЗначение("Справочник.КВП_НормыПотребленияУслуг.ПустаяСсылка");
	Для Каждого ТекСтрокаОчистки Из МассивСтрокНекорректныхНорм Цикл
		ТекСтрокаОчистки.НормаПотребления = ПустаяНорма;
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьНормыПотребленияПустымиСсылками()

&НаСервере
// Процедура заполняет услуги на сервере.
Процедура ЗаполнитьУслугиНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КВП_Услуги.Ссылка КАК Услуга
	|ИЗ
	|	Справочник.КВП_Услуги КАК КВП_Услуги
	|ГДЕ
	|	НЕ КВП_Услуги.ПометкаУдаления
	|	И НЕ КВП_Услуги.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	КВП_Услуги.Наименование";
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Объект.Услуги.Загрузить(РезультатЗапроса);
	
КонецПроцедуры

&НаСервере
// Функция записывает нормы для объектов.
Функция ЗаписатьНормы()
	
	Если Объект.НормаНаЛицевойСчет Тогда
		СписокОбъектов = ПолучитьСписокЛицевыхСчетовНаСервере();
	Иначе
		СписокОбъектов = ПолучитьСписокЗданийНаСервере();
	КонецЕсли;
	
	Для Каждого ТекОбъект Из СписокОбъектов Цикл
		Для Каждого ТекУслуга Из Объект.Услуги Цикл
			Если НЕ ТекУслуга.НормаПотребления.Пустая()
			   И НЕ ТекУслуга.Услуга.Пустая() Тогда
				
				НаборЗаписей = РегистрыСведений.КВП_НормыПотребленияУслугЛС.СоздатьНаборЗаписей();
				
				НаборЗаписей.Отбор.Период.Установить(Объект.ДатаУстановки);
				НаборЗаписей.Отбор.ЛицевойСчет.Установить(ТекОбъект.Объект);
				НаборЗаписей.Отбор.Услуга.Установить(ТекУслуга.Услуга);
				
				НовЗапись = НаборЗаписей.Добавить();
				НовЗапись.Период           = Объект.ДатаУстановки;
				НовЗапись.ЛицевойСчет      = ТекОбъект.Объект;
				НовЗапись.Услуга           = ТекУслуга.Услуга;
				НовЗапись.НормаПотребления = ТекУслуга.НормаПотребления;
				
				НаборЗаписей.Записать(Истина);
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ЗначениеЗаполнено(СписокОбъектов) И ЗначениеЗаполнено(Объект.Услуги);
	
КонецФункции

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ РАБОТЫ С МЕТОДАМИ МОДУЛЯ ОБЪЕКТА

#Область РаботаСМетодамиМодуляОбработки

&НаСервере
// Процедура выполняет инициализацию реквизитов.
Процедура ИнициализацияРеквизитовНаСервере()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект", Тип("ОбработкаОбъект.КВП_ЗаполнениеНормПотребленияУслуг"));
	ОбработкаОбъект.ИнициализацияРеквизитов();
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
// Функция возвращает размер нормы на сервере.
Функция УстановитьРазмерНормыНаСервере(НормаПотребления)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект", Тип("ОбработкаОбъект.КВП_ЗаполнениеНормПотребленияУслуг"));
	
	Возврат УПЖКХ_РаботаСОбъектамиУчетаСервер.УстановитьРазмерНормы(НормаПотребления);
	
КонецФункции

&НаКлиенте
// Процедура вызывает обработку заполнения объектов по отбору.
Процедура ВызватьЗаполнениеОбъектовПоОтбору(ИмяОтбора)
	
	СтруктураПараметровОтбора = КВП_РаботаСДиалогами.ОпределитьПустуюСтруктуруПараметровОтбора();
	
	Если ИмяОтбора = "ОтборЛицевыхСчетов" Тогда
		СтруктураПараметровОтбора.Вставить("ТипОбъекта"           , "ЛицевыеСчета");
		СтруктураПараметровОтбора.Вставить("ТипЗначОбъекта"       , "ЛицевыеСчета");
	ИначеЕсли ИмяОтбора = "ОтборЗданий" Тогда
		СтруктураПараметровОтбора.Вставить("ТипОбъекта"           , "Здания");
		СтруктураПараметровОтбора.Вставить("ТипЗначОбъекта"       , "Здания");
	ИначеЕсли ИмяОтбора = "ОтборПодъездов" Тогда
		СтруктураПараметровОтбора.Вставить("ТипОбъекта"           , "Подъезды");
		СтруктураПараметровОтбора.Вставить("ТипЗначОбъекта"       , "Подъезды");
	КонецЕсли;
	
	СтруктураПараметровОтбора.Вставить("НачПериодЛС"              , Объект.ДатаУстановки);
	СтруктураПараметровОтбора.Вставить("КонПериодЛС"              , Объект.ДатаУстановки);
	
	ОткрытьФорму("Обработка.КВП_ЗаполнениеПолучателямиУслуг.Форма",
				 СтруктураПараметровОтбора,
				 ЭтаФорма,,,,
				 Новый ОписаниеОповещения("ОбработатьВыборОбъектов", ЭтаФорма),
				 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры // ВызватьЗаполнениеОбъектовПоОтбору()

&НаСервере
// Обработка выбора объектов, вызванного в процедуре "ВызватьЗаполнениеОбъектовПоОтбору()".
Процедура ОбработатьВыборОбъектов(СписокЗаполненных, ДополнительныеПараметры) Экспорт
	
	Если Не СписокЗаполненных = Неопределено Тогда
		
		Для Каждого ТекЭлемент Из СписокЗаполненных Цикл
			НоваяСтрока = Объект.Объекты.Добавить();
			НоваяСтрока.Объект = ТекЭлемент.Значение;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ОбработатьВыборОбъектов()

&НаСервере
// Функция возвращает список лицевых счетов на сервере.
Функция ПолучитьСписокЛицевыхСчетовНаСервере()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект", Тип("ОбработкаОбъект.КВП_ЗаполнениеНормПотребленияУслуг"));
	
	Возврат ОбработкаОбъект.ПолучитьСписокЛицевыхСчетов();
	
КонецФункции

&НаСервере
// Функция возвращает список лицевых счетов на сервере.
Функция ПолучитьСписокЗданийНаСервере()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект", Тип("ОбработкаОбъект.КВП_ЗаполнениеНормПотребленияУслуг"));
	
	Возврат ОбработкаОбъект.ПолучитьСписокЗданий();
	
КонецФункции

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("НормаНаЛицевойСчет", Объект.НормаНаЛицевойСчет);
	
	Если Объект.НормаНаЛицевойСчет Тогда
		НормаНаЛицевойСчет = 1;
	КонецЕсли;
	
	ИнициализацияРеквизитовНаСервере();
	
	УстановитьВидимостьКнопокЗаполнения();
	
	// ОбщиеМеханизмыИКоманды
	ОТР_ПодключаемыеОбщиеМеханизмыИКоманды.ПриСозданииНаСервере(ЭтаФорма, Элементы.КоманднаяПанель);
	// Конец ОбщиеМеханизмыИКоманды
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ОбработкаВыбора" формы.
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если Объект.Объекты.НайтиСтроки(Новый Структура("Объект", ВыбранноеЗначение)).Количество() = 0 Тогда
		НоваяСтрокаТЧ = Объект.Объекты.Добавить();
		НоваяСтрокаТЧ.Объект = ВыбранноеЗначение;
	Иначе
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("Объект уже добавлен в табличную часть.");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

//////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Обработчик события "ПриИзменении" табличной части "Услуги".
Процедура ДатаУстановкиПриИзменении(Элемент)
	
	Объект.ДатаУстановки = НачалоМесяца(Объект.ДатаУстановки);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПриИзменении" переключателя "НормаНаЛицевойСчет".
Процедура НормаНаЛицевойСчетПриИзменении(Элемент)
	
	Объект.НормаНаЛицевойСчет = (НормаНаЛицевойСчет = 1);
	
	УстановитьВидимостьКнопокЗаполнения();
	
	ПроверитьИУдалитьВыбранныеОбъектыИНормы();
	
	НормаНаЛицевойСчет = ?(Объект.НормаНаЛицевойСчет, 1, 0);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНЫХ ЧАСТЕЙ

#Область ОбработчикиСобытийТабличныхЧастей

&НаКлиенте
// Обработчик события "ПередОкончаниемРедактирования" табличной части "Услуги".
Процедура УслугиПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если Не ОтменаРедактирования И Не Элементы.Услуги.ТекущиеДанные = Неопределено Тогда
		Элементы.Услуги.ТекущиеДанные.Размер = УстановитьРазмерНормыНаСервере(Элементы.Услуги.ТекущиеДанные.НормаПотребления);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "НачалоВыбора" колонки "Объект" табличной части "Объекты".
Процедура ОбъектыОбъектНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ Объект.НормаНаЛицевойСчет Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ФормаВыбора = ПолучитьФорму("Справочник.КВП_Здания.ФормаВыбора", , Элемент);
		ФормаВыбора.Открыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "НачалоВыбора" колонки "Норма" табличной части "Услуги".
Процедура УслугиНормаПотребленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УслугаВладелец = Элементы.Услуги.ТекущиеДанные.Услуга;
	
	Если НормаНаЛицевойСчет = 1 Тогда
		НормаНаЛицевойСчетДляОтбора = Истина;
	Иначе
		НормаНаЛицевойСчетДляОтбора = Ложь;
	КонецЕсли;
	
	КВП_РаботаСДиалогамиКлиент.ВыбратьНормуПотребления(Элемент, СтандартнаяОбработка, УслугаВладелец, НормаНаЛицевойСчетДляОтбора);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД

#Область ОбработчикиКомандФормы

&НаКлиенте
// Обработчик команды "ЗаполнитьУслуги".
Процедура ЗаполнитьУслуги(Команда)
	
	ЗаполнитьУслугиНаСервере();
	
КонецПроцедуры

&НаКлиенте
// Обработчик команды "ОчиститьОбъекты".
Процедура ОчиститьОбъекты(Команда)
	
	Объект.Объекты.Очистить();
	
КонецПроцедуры

// ЧастоЗадаваемыеВопросы
&НаКлиенте
// Подключаемый обработчик команды перехода к часто задаваемым вопросам.
Процедура Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда)
	
	ОТР_ЧастоЗадаваемыеВопросыКлиент.Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда);
	
КонецПроцедуры
// Конец ЧастоЗадаваемыеВопросы

//////////////////////////////
// Управление подбором объектов

&НаКлиенте
// Обработчик команды "ПодборОбъектовЛицевыеСчета".
Процедура ПодборОбъектовЛицевыеСчета(Команда)
	
	ФормаЛС = ПолучитьФорму("Справочник.КВП_ЛицевыеСчета.ФормаВыбора", , ЭтотОбъект);
	ФормаЛС.ЗакрыватьПриВыборе = Ложь;
	ФормаЛС.Открыть();
	
КонецПроцедуры

&НаКлиенте
// Обработчик команды "ПодборОбъектовЗдания".
Процедура ПодборОбъектовЗдания(Команда)
	
	ФормаЗдание = ПолучитьФорму("Справочник.КВП_Здания.ФормаВыбора", , ЭтотОбъект);
	ФормаЗдание.ЗакрыватьПриВыборе = Ложь;
	ФормаЗдание.Открыть();
	
КонецПроцедуры

&НаКлиенте
// Обработчик команды "ПодборОбъектовПодъезды".
Процедура ПодборОбъектовПодъезды(Команда)
	
	ФормаПодъезд = ПолучитьФорму("Справочник.КВП_Подъезды.ФормаВыбора", , ЭтотОбъект);
	ФормаПодъезд.ЗакрыватьПриВыборе = Ложь;
	ФормаПодъезд.Открыть();
	
КонецПроцедуры

//////////////////////////////
// Управление заполнением объектов

&НаКлиенте
// Обработчик команды "ЗаполнитьОбъектыЛицевыеСчета".
Процедура ЗаполнитьОбъектыЛицевыеСчета(Команда)
	
	ВызватьЗаполнениеОбъектовПоОтбору("ОтборЛицевыхСчетов")
	
КонецПроцедуры

&НаКлиенте
// Обработчик команды "ЗаполнитьОбъектыЗдания".
Процедура ЗаполнитьОбъектыЗдания(Команда)
	
	ВызватьЗаполнениеОбъектовПоОтбору("ОтборЗданий");
	
КонецПроцедуры

&НаКлиенте
// Обработчик команды "ЗаполнитьОбъектыПодъезды".
Процедура ЗаполнитьОбъектыПодъезды(Команда)
	
	ВызватьЗаполнениеОбъектовПоОтбору("ОтборПодъездов");
	
КонецПроцедуры

&НаКлиенте
// Обработчик команды "УстановитьНормы".
Процедура УстановитьНормы(Команда)
	
	Если ЗаписатьНормы() Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("Установка норм произведена успешно.");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
