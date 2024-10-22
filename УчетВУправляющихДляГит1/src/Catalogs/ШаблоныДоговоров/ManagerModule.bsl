#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру с пустым значением полей, которая сохраняется 
// в реквизите Шаблон как ХранилищеЗначения.
//
Функция ПустаяСтруктураШаблонаДоговора() Экспорт

	Вложения = Новый Структура();

	Результат = Новый Структура();
	Результат.Вставить("ТекстHTML", "");
	Результат.Вставить("Вложения", 	Вложения);
	
	Возврат Результат;

КонецФункции

// Возвращает данные шаблона из хранилища.
//
Функция ДанныеШаблонаДоговора(ШаблонДоговора) Экспорт

	Результат = Неопределено;
	
	Если ЗначениеЗаполнено(ШаблонДоговора) Тогда
		ШаблонХранилище = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ШаблонДоговора, "ШаблонХранилище");
		Если ТипЗнч(ШаблонХранилище) = Тип("ХранилищеЗначения") Тогда
			Результат = ШаблонХранилище.Получить();
		КонецЕсли;
	КонецЕсли;

	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Результат = ПустаяСтруктураШаблонаДоговора();
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Процедура заполняет элементы справочника при обновлении ИБ
//
Процедура ЗаполнениеТиповыхШаблоновДоговоровОтложено(Параметры) Экспорт

	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда // В подчиненных узлах РИБ не выполняется, чтобы не было дублей
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;

	ТиповыеМакеты = Новый Структура;
	МетаданныеМакеты = Метаданные.Справочники.ШаблоныДоговоров.Макеты;
	Для Каждого МетаМакета Из МетаданныеМакеты Цикл
		Если Лев(МетаМакета.Имя, 7) = "Договор" Тогда
			ТиповыеМакеты.Вставить(МетаМакета.Имя, МетаМакета);
		КонецЕсли;
	КонецЦикла;

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ШаблоныДоговоров.ИмяМакета
	|ИЗ
	|	Справочник.ШаблоныДоговоров КАК ШаблоныДоговоров
	|ГДЕ
	|	ШаблоныДоговоров.ИмяМакета <> """"
	|	И НЕ ШаблоныДоговоров.ЭтоГруппа";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		Если ТиповыеМакеты.Свойство(Выборка.ИмяМакета) Тогда
			// Второй раз не добавляем
			ТиповыеМакеты.Удалить(Выборка.ИмяМакета);
		КонецЕсли;
	
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из ТиповыеМакеты Цикл

		Попытка
		
			ШаблонОбъект = Справочники.ШаблоныДоговоров.СоздатьЭлемент();
			ШаблонОбъект.Наименование 	= КлючИЗначение.Значение.Синоним;
			ШаблонОбъект.ИмяМакета		= КлючИЗначение.Ключ;
			
			Макет = Справочники.ШаблоныДоговоров.ПолучитьМакет(КлючИЗначение.Ключ);
			
			ДанныеШаблона = ПустаяСтруктураШаблонаДоговора();
			ДанныеШаблона.ТекстHTML = Макет.ПолучитьТекст();
			ШаблонОбъект.ШаблонХранилище = Новый ХранилищеЗначения(ДанныеШаблона, Новый СжатиеДанных(9));
			
			ШаблонОбъект.Записать();
			
		Исключение

			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось создать шаблон договора: %1 по причине:
					|%2'"),
					КлючИЗначение.Ключ, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.ШаблоныДоговоров, ТекстСообщения);
		
		КонецПопытки;
		
	КонецЦикла;

	Параметры.ОбработкаЗавершена = Истина;

КонецПроцедуры

// Устарела. Процедура обновляет элементы справочника при обновлении ИБ.
// См. ОбновлениеТиповыхШаблоновДоговоров_3_0_44_Отложено()
//
Процедура ОбновлениеТиповыхШаблоновДоговоров_3_0_38_Отложено(Параметры) Экспорт

	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

// Процедура обновляет элементы справочника при обновлении ИБ
//
Процедура ОбновлениеТиповыхШаблоновДоговоров_3_0_44_Отложено(Параметры) Экспорт

	// Заполним таблицу с количеством символов в предыдущей версии типовых шаблонов.
	// Считаем, что если число символов в тексте HTML шаблона не изменилось, 
	// то пользователи шаблон вручную не редактировали, и его можно обновить из макета.
	
	ТаблицаШаблонов = ПустаяТаблицаШаблоновДляОбновления();

	НоваяСтрока = ТаблицаШаблонов.Добавить();
	НоваяСтрока.ИмяМакета 						= "ДоговорПоставки";
	НоваяСтрока.ПредыдущееКоличествоСимволов 	= 17011;
	
	НоваяСтрока = ТаблицаШаблонов.Добавить();
	НоваяСтрока.ИмяМакета 						= "ДоговорПоставки";
	НоваяСтрока.ПредыдущееКоличествоСимволов 	= 20097;

	НоваяСтрока = ТаблицаШаблонов.Добавить();
	НоваяСтрока.ИмяМакета 						= "ДоговорПоставки";
	НоваяСтрока.ПредыдущееКоличествоСимволов 	= 20098;
	
	НоваяСтрока = ТаблицаШаблонов.Добавить();
	НоваяСтрока.ИмяМакета 						= "ДоговорОказанияУслуг";
	НоваяСтрока.ПредыдущееКоличествоСимволов 	= 10431;

	НоваяСтрока = ТаблицаШаблонов.Добавить();
	НоваяСтрока.ИмяМакета 						= "ДоговорОказанияУслуг";
	НоваяСтрока.ПредыдущееКоличествоСимволов 	= 12093;

	НоваяСтрока = ТаблицаШаблонов.Добавить();
	НоваяСтрока.ИмяМакета 						= "ДоговорОказанияУслуг";
	НоваяСтрока.ПредыдущееКоличествоСимволов 	= 12094;
	
	НоваяСтрока = ТаблицаШаблонов.Добавить();
	НоваяСтрока.ИмяМакета 						= "ДоговорОказанияУслуг";
	НоваяСтрока.ПредыдущееКоличествоСимволов 	= 12206;
	
	НоваяСтрока = ТаблицаШаблонов.Добавить();
	НоваяСтрока.ИмяМакета 						= "ДоговорОказанияУслуг";
	НоваяСтрока.ПредыдущееКоличествоСимволов 	= 12207;

	НоваяСтрока = ТаблицаШаблонов.Добавить();
	НоваяСтрока.ИмяМакета 						= "ДоговорПодряда";
	НоваяСтрока.ПредыдущееКоличествоСимволов 	= 12687;

	НоваяСтрока = ТаблицаШаблонов.Добавить();
	НоваяСтрока.ИмяМакета 						= "ДоговорПодряда";
	НоваяСтрока.ПредыдущееКоличествоСимволов 	= 14626;

	НоваяСтрока = ТаблицаШаблонов.Добавить();
	НоваяСтрока.ИмяМакета 						= "ДоговорПодряда";
	НоваяСтрока.ПредыдущееКоличествоСимволов 	= 14627;
	
	НоваяСтрока = ТаблицаШаблонов.Добавить();
	НоваяСтрока.ИмяМакета 						= "ДоговорПодряда";
	НоваяСтрока.ПредыдущееКоличествоСимволов 	= 14643;
	
	НоваяСтрока = ТаблицаШаблонов.Добавить();
	НоваяСтрока.ИмяМакета 						= "ДоговорПодряда";
	НоваяСтрока.ПредыдущееКоличествоСимволов 	= 14644;
	
	ОбновлениеТиповыхШаблоновДоговоровОтложено(ТаблицаШаблонов, Параметры);

КонецПроцедуры

Функция ПустаяТаблицаШаблоновДляОбновления()
	
	ТаблицаШаблоны = Новый ТаблицаЗначений;
	ТаблицаШаблоны.Колонки.Добавить("ИмяМакета", ОбщегоНазначения.ОписаниеТипаСтрока(50));
	ТаблицаШаблоны.Колонки.Добавить("ПредыдущееКоличествоСимволов", ОбщегоНазначения.ОписаниеТипаЧисло(10));
	ТаблицаШаблоны.Колонки.Добавить("НовыйТекстHTML", ОбщегоНазначения.ОписаниеТипаСтрока(0));
	
	ТаблицаШаблоны.Индексы.Добавить("ИмяМакета");
	
	Возврат ТаблицаШаблоны;

КонецФункции

// Процедура обновляет элементы справочника при обновлении ИБ
//
Процедура ОбновлениеТиповыхШаблоновДоговоровОтложено(ТаблицаШаблонов, Параметры)

	// Считаем, что если число символов в тексте HTML шаблона не изменилось, 
	// то пользователи шаблон вручную не редактировали, и его можно обновить из макета.
	
	// Получим новый текст макета
	Для Каждого СтрокаТаблицыШаблонов Из ТаблицаШаблонов Цикл
		Макет = Справочники.ШаблоныДоговоров.ПолучитьМакет(СтрокаТаблицыШаблонов.ИмяМакета);
		СтрокаТаблицыШаблонов.НовыйТекстHTML = Макет.ПолучитьТекст();
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ШаблоныДоговоров.Ссылка,
	|	ШаблоныДоговоров.ИмяМакета,
	|	ШаблоныДоговоров.Наименование
	|ИЗ
	|	Справочник.ШаблоныДоговоров КАК ШаблоныДоговоров
	|ГДЕ
	|	ШаблоныДоговоров.ИмяМакета <> """"
	|	И НЕ ШаблоныДоговоров.ЭтоГруппа";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СтруктураПоиска = Новый Структура("ИмяМакета");
	
	Пока Выборка.Следующий() Цикл

		СтруктураПоиска.ИмяМакета = Выборка.ИмяМакета;
		НайденныеСтрокиШаблона = ТаблицаШаблонов.НайтиСтроки(СтруктураПоиска);
		Если НайденныеСтрокиШаблона.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;

		НачатьТранзакцию();
		Попытка
		
			// Блокируем объект от изменения другими сеансами.
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.ШаблоныДоговоров");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			Блокировка.Заблокировать();
		
			ШаблонОбъект = Выборка.Ссылка.ПолучитьОбъект();

			// Если объект ранее был удален или обработан другими сеансами, пропускаем его.
			Если ШаблонОбъект = Неопределено Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ДанныеШаблона = ШаблонОбъект.ШаблонХранилище.Получить();
			
			СтрокаТаблицыШаблонов = Неопределено;
			ТекущееКоличествоСимволов = СтрДлина(ДанныеШаблона.ТекстHTML);
			Для Каждого НайденнаяСтрока Из НайденныеСтрокиШаблона Цикл
				Если ТекущееКоличествоСимволов = НайденнаяСтрока.ПредыдущееКоличествоСимволов Тогда
					СтрокаТаблицыШаблонов = НайденнаяСтрока;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если ДанныеШаблона.Вложения.Количество() = 0 И СтрокаТаблицыШаблонов <> Неопределено Тогда
				
				ДанныеШаблона.ТекстHTML = СтрокаТаблицыШаблонов.НовыйТекстHTML;
				ШаблонОбъект.ШаблонХранилище = Новый ХранилищеЗначения(ДанныеШаблона, Новый СжатиеДанных(9));

				// Запись обработанного объекта.
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ШаблонОбъект);
				
				ЗафиксироватьТранзакцию();

			Иначе
				ОтменитьТранзакцию();
			КонецЕсли;

		Исключение
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ОтменитьТранзакцию();

			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обновить текст шаблона договора: %1 по причине:
					|%2'"),
					Выборка.Наименование, ТекстОшибки);
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.ШаблоныДоговоров, ТекстСообщения);

		КонецПопытки;
		
	КонецЦикла;

	Параметры.ОбработкаЗавершена = Истина;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы <> "ФормаЭлемента"
		И ВидФормы <> "ФормаОбъекта" Тогда
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		// Для существующего элемента справочника открываем форму редактирования.
		ВыбраннаяФорма = "ФормаРедактированияШаблона";
		Возврат;
	КонецЕсли;

	ИмяМакета = Неопределено; 
	ЭтоКопирование = Ложь;

	// Если элемент копируется, то имя макета получаем из копируемого элемента.
	Если Параметры.Свойство("ЗначениеКопирования")
		И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ЭтоКопирование = Истина;
	КонецЕсли;

	Если НЕ ЭтоКопирование  Тогда
		Если Параметры.Свойство("ЗначенияЗаполнения") 
			И ТипЗнч(Параметры.ЗначенияЗаполнения) = Тип("Структура") Тогда
			Если Параметры.ЗначенияЗаполнения.Свойство("ИмяМакета") Тогда
				ИмяМакета	= Параметры.ЗначенияЗаполнения.ИмяМакета;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	Если ЭтоКопирование ИЛИ ЗначениеЗаполнено(ИмяМакета) Тогда
		ВыбраннаяФорма = "ФормаРедактированияШаблона";
	Иначе
		ВыбраннаяФорма = "ФормаЭлемента";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
