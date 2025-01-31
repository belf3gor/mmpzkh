////////////////////////////////////////////////////////////////////////////////
// Клиентские и серверные процедуры и функции общего назначения
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Устанавливает значение свойства произвольного объекта, если такое свойство существует.
// При отсутствии свойства ничего не происходит.
//
// Параметры:
//  Объект      - Произвольный - объект, в котором нужно установить значение свойства;
//  ИмяСвойства - Строка       - имя реквизита или свойства;
//  Значение    - Произвольный - устанавливаемое значение.
//
Процедура УстановитьЗначениеСвойства(Объект, ИмяСвойства, Значение) Экспорт
	
	СтруктураСвойства = Новый Структура(ИмяСвойства, Значение);
	ЗаполнитьЗначенияСвойств(Объект, СтруктураСвойства);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции для работы с управляемыми формами.
//

// Устанавливает значение свойства элементов формы.
// Применяется в тех случаях, когда элемента формы может не быть на форме 
// из-за отсутствия прав у пользователя на объект, реквизит объекта или команду.
//
// Параметры:
//  ЭлементыФормы  - УправляемаяФорма, ВсеЭлементыФормы, ЭлементыФормы - коллекция элементов управляемой формы.
//  ИменаЭлементов - Строка, Массив - имя элемента формы.
//  ИмяСвойства    - Строка         - имя устанавливаемого свойства элементов формы.
//  Значение       - Произвольный   - новое значение элементов.
// 
Процедура УстановитьСвойствоЭлементовФормы(Знач ЭлементыФормы, Знач ИменаЭлементов, ИмяСвойства, Значение) Экспорт
	
	Если ТипЗнч(ЭлементыФормы) = Тип("УправляемаяФорма") Тогда
		ЭлементыФормы = ЭлементыФормы.Элементы;
	КонецЕсли;
	
	Если ТипЗнч(ИменаЭлементов) = Тип("Строка") Тогда
		ИменаЭлементов = СтроковыеФункцииБЗККлиентСервер.РазделитьИменаСвойств(ИменаЭлементов);
	КонецЕсли;	
	
	Для Каждого ИмяЭлемента Из ИменаЭлементов Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(ЭлементыФормы, ИмяЭлемента, ИмяСвойства, Значение);
	КонецЦикла;	
	
КонецПроцедуры 

// Задает обязательность заполнения поля формы.
// Устанавливает свойства АвтоОтметкаНезаполненного и ОтметкаНезаполненного поля формы. 
//
// Параметры:
//  Форма        - УправляемаяФорма - форма.
//  ИмяЭлемента  - Строка - Имя поля формы. Должно быть полем ввода (ВидПоляФормы.ПолеВвода).  
//  Обязательное - Булево - Признак обязательности поля, по умолчанию Истина.
//  ПутьКДанным  - Строка - Путь к данным поля ввода, например: "Объект.МесяцНачисления".
//                          Необязательный. Если не указан, то значение поля будет определено из свойств элемента.          
//
Процедура УстановитьОбязательностьПоляВводаФормы(Форма, ИмяЭлемента, Знач Обязательное = Истина, Знач ПутьКДанным = Неопределено) Экспорт
	
	ЭлементФормы = Форма.Элементы.Найти(ИмяЭлемента);
	Если ЭлементФормы = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ИмяПроцедуры = "ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаФормы";
	ИмяПараметра = "ИмяЭлемента";
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		ИмяПроцедуры,
		ИмяПараметра,
		ЭлементФормы,
		Новый ОписаниеТипов("ПолеФормы"));
		
	ОбщегоНазначенияКлиентСервер.Проверить(
		ЭлементФормы.Вид = ВидПоляФормы.ПолеВвода, 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение свойства ""Вид"" поля %3, переданного в параметре %2 в процедуру %1. Ожидается поле ввода.'"),
			ИмяПроцедуры, ИмяПараметра, ИмяЭлемента));
			
	Если Не Обязательное Тогда
		ЭлементФормы.АвтоОтметкаНезаполненного = Ложь;
		ЭлементФормы.ОтметкаНезаполненного     = Ложь;
	Иначе	
		ЭлементФормы.АвтоОтметкаНезаполненного = Истина;
		ЭлементФормы.ОтметкаНезаполненного     = Не ПоляВводаФормыЗаполнено(Форма, ЭлементФормы, ПутьКДанным);
	КонецЕсли;
	
КонецПроцедуры	

// Задает обязательность заполнения таблицы формы.
// Устанавливает свойства АвтоОтметкаНезаполненного и ОтметкаНезаполненного таблицы формы. 
//
// Параметры:
//  Форма        - УправляемаяФорма - форма.
//  ИмяЭлемента  - Строка - Имя таблицы формы.   
//  Обязательное - Булево - Признак обязательности поля, по умолчанию Истина.
//  ПутьКДанным  - Строка - Путь к данным таблицы, например: "Объект.МесяцНачисления".
//                          Необязательный. Если не указан, то значение поля будет определено из свойств элемента.          
//
Процедура УстановитьОбязательностьТаблицыФормы(Форма, ИмяЭлемента, Знач Обязательная = Истина, Знач ПутьКДанным = Неопределено) Экспорт
	
	ЭлементФормы = Форма.Элементы.Найти(ИмяЭлемента);
	Если ЭлементФормы = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьТаблицыФормы",
		"ИмяЭлемента",
		ЭлементФормы,
		Новый ОписаниеТипов("ТаблицаФормы"));
		
	Если Не Обязательная Тогда
		ЭлементФормы.АвтоОтметкаНезаполненного = Ложь;
		ЭлементФормы.ОтметкаНезаполненного     = Ложь;
	Иначе	
		ЭлементФормы.АвтоОтметкаНезаполненного = Истина;
		ЭлементФормы.ОтметкаНезаполненного     = Не ТаблицаФормыЗаполнена(Форма, ЭлементФормы, ПутьКДанным);
	КонецЕсли;
	
КонецПроцедуры	

// Задает обязательность заполнения поля ввода в таблице формы (колонки).
// Устанавливает свойство АвтоОтметкаНезаполненного поля таблицы формы. 
// (свойство ОтметкаНезаполненного в поле таблицы всегда устанавливается автоматически).
//
// Параметры:
//  Форма           - УправляемаяФорма - форма.
//  ИмяЭлемента     - Строка - имя поля формы. Должно быть полем ввода (ВидПоляФормы.ПолеВвода).  
//  Обязательное    - Булево - признак обязательности поля, по умолчанию Истина.
//  ПутьКДаннымПоля - Строка - путь к данным поля ввода, например: "Объект.МесяцНачисления".
//                    Необязательный. Если не указан, то значение поля будет определено из свойств элемента.          
//
Процедура УстановитьОбязательностьПоляВводаТаблицыФормы(Форма, ИмяЭлемента, Знач Обязательное = Истина) Экспорт
	
	ЭлементФормы = Форма.Элементы.Найти(ИмяЭлемента);
	Если ЭлементФормы = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ИмяПроцедуры = "ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаТаблицыФормы";
	ИмяПараметра = "ИмяЭлемента";
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		ИмяПроцедуры,
		ИмяПараметра,
		ЭлементФормы,
		Новый ОписаниеТипов("ПолеФормы"));
		
	ОбщегоНазначенияКлиентСервер.Проверить(
		ЭлементФормы.Вид = ВидПоляФормы.ПолеВвода, 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение свойства ""Вид"" поля %3, переданного в параметре %2 в процедуру %1. Ожидается поле ввода.'"),
			ИмяПроцедуры, ИмяПараметра, ИмяЭлемента));
			
	ЭлементФормы.АвтоОтметкаНезаполненного = Обязательное;
	Если Не Обязательное Тогда
		ЭлементФормы.ОтметкаНезаполненного = Ложь;
	КонецЕсли;	
			
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// Функции для вызова необязательных подсистем.

// Возвращает Истина, если "функциональная" подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// У "функциональной" подсистемы снят флажок "Включать в командный интерфейс".
//
// Параметры:
//  ПолноеИмяПодсистемы - Строка - полное имя объекта метаданных подсистема
//                        без слов "Подсистема." и с учетом регистра символов.
//                        Например: "СтандартныеПодсистемы.ВариантыОтчетов".
//
// Пример:
//  Если ОбщегоНазначенияБЗККлиентСервер.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Подработки") Тогда
//  	МодульПодработок = ОбщегоНазначенияБЗККлиентСервер.ОбщийМодуль("Подработки");
//  	МодульПодработок.<Имя метода>();
//  КонецЕсли;
//
// Возвращаемое значение:
//  Булево - Истина, если существует.
//
Функция ПодсистемаСуществует(ПолноеИмяПодсистемы) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ОбщегоНазначения.ПодсистемаСуществует(ПолноеИмяПодсистемы);
#Иначе
	Возврат ОбщегоНазначенияКлиент.ПодсистемаСуществует(ПолноеИмяПодсистемы);
#КонецЕсли

КонецФункции

// Возвращает ссылку на общий модуль по имени.
//
// Параметры:
//  Имя          - Строка - имя общего модуля, например:
//                 "Подработки",
//                 "ПодработкиКлиент".
//
// Возвращаемое значение:
//  ОбщийМодуль - общий модуль.
//
Функция ОбщийМодуль(Имя) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Модуль = ОбщегоНазначения.ОбщийМодуль(Имя);
#Иначе
	Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль(Имя);
#КонецЕсли
	
	Возврат Модуль;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции для работы с коллекциями 

// Возвращает соответствие, ключами которого являются элементы массива.
// В качестве значений для всех ключей будет установлено Истина.
//
// Параметры:
//	Массив - Массив - элементы которого нужно поместить в Соответствие.
//
// Возвращаемое значение:
//	Соответствие - соответствие, в ключи которого помещены элементы переданного массива.
//
Функция МассивВСоответствие(Массив) Экспорт
	Соответствие = Новый Соответствие;
	
	Для Каждого ЭлементМассива Из Массив Цикл
		Соответствие.Вставить(ЭлементМассива, Истина);
	КонецЦикла;	

	Возврат Соответствие;
КонецФункции	

// Возвращает элементы массива с <НачальныйИндекс> по <КонечныйИндекс>.
//
// Параметры:
//	Массив          - Массив - исходный массив, срез которого будет получен.
//	НачальныйИндекс - Число  - Индекс элемента, с которого начинается срез (включительно).
//                             Если параметр не указан, то выбираются элементы с начала массива.
//                             Если указано значение, меньшее нуля, то параметр принимает значение 0. 
//	КонечныйИндекс  - Число  - Индекс элемента, по который выполняется срез (включительно). 
//                             Если параметр не указан, то выбираются элементы до конца массива.
//                             Если указано значение, большее индекса конечного элемента, 
//                             то параметр принимает значение, равное индексу конечного элемента. 
//
// Возвращаемое значение:
//	Массив - элементы исходного массива в указанном диапазоне.
//
Функция СрезМассива(Массив, Знач НачальныйИндекс = 0, Знач КонечныйИндекс = Неопределено) Экспорт
	Срез = Новый Массив;
	
	НачальныйИндекс = МАКС(НачальныйИндекс, 0);
	Если КонечныйИндекс = Неопределено Тогда
		КонечныйИндекс = Массив.ВГраница();
	Иначе	
		КонечныйИндекс  = МИН(КонечныйИндекс, Массив.ВГраница());
	КонецЕсли;	
	
	Для Индекс = НачальныйИндекс По КонечныйИндекс Цикл
		Срез.Добавить(Массив[Индекс]);
	КонецЦикла;	
		
	Возврат Срез
КонецФункции	

// Очищает значения свойств структуры
//
// Параметры:
//  Структура - Структура - очищаемая структура.
//
Процедура ОчиститьЗначенияСтруктуры(Структура) Экспорт
	
	Для Каждого Свойство Из Структура Цикл
		Структура[Свойство.Ключ] = Неопределено; 
	КонецЦикла;
	
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПоляВводаФормыЗаполнено(Форма, ЭлементФормы, Знач ПутьКДанным = Неопределено)
	
	ЗначениеПоля = Неопределено;
	
	ПутьРеквизита = ПутьКДаннымЭлементаФормы(ЭлементФормы, ПутьКДанным);
	
	Если ЗначениеЗаполнено(ПутьРеквизита) Тогда
		ЗначениеПоля = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПутьРеквизита);
	Иначе
#Если Клиент Тогда
		// Попытка нужна для работы в толстом клиенте в файл-серверном варианте:
		// ТекстРедактирования доступен только в клиентском режиме исполнения, 
		// а определить его в толстом файл-сервере невозможно.
		Попытка
			ЗначениеПоля = ЭлементФормы.ТекстРедактирования;
		Исключение	
		КонецПопытки	
#КонецЕсли
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(ЗначениеПоля)
	
КонецФункции

Функция ТаблицаФормыЗаполнена(Форма, ЭлементФормы, Знач ПутьКДанным = Неопределено)
	
	КоличествоСтрок = Неопределено;
	
	ПутьРеквизита = ПутьКДаннымЭлементаФормы(ЭлементФормы, ПутьКДанным);
	
	Если ЗначениеЗаполнено(ПутьРеквизита) Тогда
		КоличествоСтрок = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПутьРеквизита).Количество();
	Иначе
#Если Клиент Тогда
		// Попытка нужна для работы в толстом клиенте в файл-серверном варианте:
		// ВыделенныеСтроки доступны только в клиентском режиме исполнения, 
		// а определить его в толстом файл-сервере невозможно.
		Попытка
			КоличествоСтрок = ЭлементФормы.ВыделенныеСтроки.Количество()
		Исключение	
		КонецПопытки	
#КонецЕсли
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(КоличествоСтрок)
	
КонецФункции

Функция ПутьКДаннымЭлементаФормы(ЭлементФормы, ПутьКДанным)
	ПутьКДаннымЭлементаФормы = Неопределено;
	Если ЗначениеЗаполнено(ПутьКДанным)	Тогда
		ПутьКДаннымЭлементаФормы = ПутьКДанным
	Иначе	
#Если Сервер Тогда
		// Попытка нужна для работы в толстом клиенте в файл-серверном варианте:
		// ПутьКДанным доступен только в серверном режиме исполнения, 
		// а определить его в толстом файл-сервере невозможно.
		Попытка
			ПутьКДаннымЭлементаФормы = ЭлементФормы.ПутьКДанным;
		Исключение	
		КонецПопытки	
#КонецЕсли
	КонецЕсли;	
	Возврат ПутьКДаннымЭлементаФормы
КонецФункции

#КонецОбласти