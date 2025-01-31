
#Область ПроцедурыИФункцииФормированияИОбработкиМеню

// Возвращает пустую структуру параметров отбора.
Функция ОпределитьПустуюСтруктуруПараметровОтбора() Экспорт
	
	СтруктураПараметровОтбора = Новый Структура();
	
	СтруктураПараметровОтбора.Вставить("ЗаголовокФормы"             , "");
	СтруктураПараметровОтбора.Вставить("ТипОбъекта"                 , "");
	СтруктураПараметровОтбора.Вставить("ТипЗначОбъекта"             , "");
	СтруктураПараметровОтбора.Вставить("ПриостановкаДействияУслуги" , Ложь);
	СтруктураПараметровОтбора.Вставить("ДатаНач"                    , Дата(1,1,1));
	СтруктураПараметровОтбора.Вставить("ДатаКон"                    , Дата(1,1,1));
	СтруктураПараметровОтбора.Вставить("НачПериодЛС"                , Дата(1,1,1));
	СтруктураПараметровОтбора.Вставить("КонПериодЛС"                , Дата(1,1,1));
	СтруктураПараметровОтбора.Вставить("Услуга"                     ,
																	  ПредопределенноеЗначение("Справочник.КВП_Услуги.ПустаяСсылка"));
	СтруктураПараметровОтбора.Вставить("Организация"                ,
																	  ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
	СтруктураПараметровОтбора.Вставить("ВладелецПарковочногоМеста"  ,
																	  ПредопределенноеЗначение("Справочник.КВП_Здания.ПустаяСсылка"));
	СтруктураПараметровОтбора.Вставить("ОбъектЛС"                   ,
																	  ПредопределенноеЗначение("Справочник.КВП_Здания.ПустаяСсылка"));
	СтруктураПараметровОтбора.Вставить("ЗданияКвартиры"             ,
																	  ПредопределенноеЗначение("Справочник.КВП_Здания.ПустаяСсылка"));
	
	Возврат СтруктураПараметровОтбора;

КонецФункции

#КонецОбласти

#Область ПроцедурыИФункцииПолученияМесяцаСтрокой

// Подбирает массив номеров месяцев, соответствующих переданной строке
// например, для строки "ма" это будут 3 и 5, для "а" - 4 и 8
// используется в ПодобратьДатуПоТексту.
//
// Параметры:
//  Текст - <Строка>
//        - введенный текст, для которой необходимо подобрать номера месяцев.
//
Функция СписокМесяцевПоСтроке(Текст)
	
	СписокМесяцев  = Новый СписокЗначений;
	Месяцы         = Новый Соответствие;
	МесяцыВозврата = Новый Массив;
	
	Для Счетчик = 1 По 12 Цикл
		Представление = Формат(Дата(2000, Счетчик, 1), "ДФ='ММММ'");
		СписокМесяцев.Добавить(Счетчик, Представление);
		Представление = Формат(Дата(2000, Счетчик, 1), "ДФ='МММ'");
		СписокМесяцев.Добавить(Счетчик, Представление);
	КонецЦикла;
	
	Для Каждого ЭлементСписка Из СписокМесяцев Цикл
		Если ВРег(Текст) = ВРег(Лев(ЭлементСписка.Представление, СтрДлина(Текст))) Тогда
			Месяцы[ЭлементСписка.Значение] = 0;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Элемент Из Месяцы Цикл
		МесяцыВозврата.Добавить(Элемент.Ключ);
	КонецЦикла;
	
	Возврат МесяцыВозврата;
	
КонецФункции // СписокМесяцевПоСтроке()

// Предназначена для реализации "произвольного" ввода даты-месяца
// подбирает по переданному тексту строку-представление даты или список таких строк
// в переданный параметр ДатаПоТексту возвращает подобранную по тексту дату.
//
// Параметры:
//  Текст        - <Строка>
//               - введенный текст, для которой необходимо подобрать строку или список 
//               - строк представление даты.
//  ДатаПоТексту - <ДатаПоТексту>
//               - подобранная по тексту дата.
//
Функция ДатаКакМесяцПодобратьДатуПоТексту(Текст, ДатаПоТексту = НеОпределено)
	
	СписокВозврата = Новый СписокЗначений;
	ТекущийГод = Год(УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьРабочуюДату());
	
	Если ПустаяСтрока(Текст) Тогда
		ДатаПоТексту = Дата(1, 1, 1);
		СписокВозврата.Добавить("");
		Возврат СписокВозврата;
	КонецЕсли;
	
	Если Найти(Текст, ".") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, ".");
	ИначеЕсли Найти(Текст, ",") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, ",");
	ИначеЕсли Найти(Текст, "-") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "-");
	ИначеЕсли Найти(Текст, "/") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "/");
	ИначеЕсли Найти(Текст, "\") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "\");
	Иначе
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, " ");
	КонецЕсли;
	
	Если Подстроки.Количество() = 1 Тогда
		
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Текст) Тогда
			МесяцЧислом = Число(Текст);
			Если МесяцЧислом >= 1 И МесяцЧислом <=12 Тогда
				ДатаПоТексту = Дата(ТекущийГод, МесяцЧислом, 1);
				Если СтрДлина(Текст) = 1 Тогда
					СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='М/гг'"));
				Иначе
					СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММ/гг'"));
				КонецЕсли;
			Иначе
				Возврат СписокВозврата;
			КонецЕсли;                
		Иначе
			СписокМесяцев = СписокМесяцевПоСтроке(Текст);
			Для Каждого Месяц Из СписокМесяцев Цикл
				ДатаПоТексту = Дата(ТекущийГод, Месяц, 1);
				СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММММ гггг'"));
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли Подстроки.Количество() = 2 Тогда
		
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Подстроки[1]) Тогда
			
			Если ПустаяСтрока(Подстроки[1]) Тогда
				ГодЧислом = 0;
				Подстроки[1] = "0";
				ТекстВозврата = Текст + "0";
			Иначе
				ГодЧислом = Число(Подстроки[1]);
				ТекстВозврата = "";
			КонецЕсли;
			
			Если ГодЧислом > 3000 Тогда
				Возврат СписокВозврата;
			КонецЕсли;
			
			Если СтрДлина(Подстроки[1]) <= 1 Тогда
				ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 3) + Подстроки[1]);
			ИначеЕсли СтрДлина(Подстроки[1]) = 2 Тогда
				ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 2) + Подстроки[1]);
			ИначеЕсли СтрДлина(Подстроки[1]) = 3 Тогда
				ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 1) + Подстроки[1]);
			ИначеЕсли СтрДлина(Подстроки[1]) = 4 Тогда
				ГодЧислом = Число(Подстроки[1]);
			КонецЕсли;                    
			
		Иначе
			
			Возврат СписокВозврата;
			
		КонецЕсли;                
		Если ЗначениеЗаполнено(Подстроки[0]) И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Подстроки[0]) Тогда
			
			МесяцЧислом = Число(Подстроки[0]);
			Если МесяцЧислом >= 1 И МесяцЧислом <= 12 Тогда
				ДатаПоТексту = Дата(ГодЧислом, МесяцЧислом, 1);
				СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММММ гггг'"));
			Иначе
				Возврат СписокВозврата;
			КонецЕсли;                
			
		Иначе
			
			СписокМесяцев = СписокМесяцевПоСтроке(Подстроки[0]);
			
			Если СписокМесяцев.Количество() = 1 Тогда
				ДатаПоТексту = Дата(ГодЧислом, СписокМесяцев[0], 1);
				СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММММ гггг'"));
			Иначе
				Для Каждого Месяц Из СписокМесяцев Цикл
					ДатаПоТексту = Дата(ГодЧислом, Месяц, 1);
					СписокВозврата.Добавить(Формат(Дата(ГодЧислом, Месяц, 1), "ДФ='ММММ гггг'"));
				КонецЦикла;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат СписокВозврата;
	
КонецФункции // ДатаКакМесяцПодобратьДатуПоТексту()

// Возвращает дату в виде строки формата "ММММ уууу".
// 
// Параметры:
//  ДатаНачалаМесяца - <Дата>
//                   - Дата, которую необходимо преобразовать в строку формата "ММММ уууу".
//
Функция ПолучитьПредставлениеМесяца(ДатаНачалаМесяца) Экспорт
	
	Возврат Формат(ДатаНачалаМесяца, "ДФ='MMMM yyyy'");
	
КонецФункции // ПолучитьПредставлениеМесяца()

// Обработка события "ПриОткрытии" поля ввода месяца строкой.
// 
// Параметры:
// Форма                      - <УправляемаяФорма>
//                            - Управляемая форма, с которым связано данное событие.
// ПутьРеквизита              - <Строка>
//                            - Путь к реквизиту формы.
// Отказ                      - <Булево>
//                            - Отказ от дальнейшего проведения.
// СтрокаТабличнойЧасти       - <Строка>
//                            - Строка табличной части формы.
//
Процедура ПериодРегистрацииПриОткрытии(Форма, ПутьРеквизита, ПутьРеквизитаПредставления,
										Отказ, СтрокаТабличнойЧасти = "ПустаяСтрока") Экспорт
	
	Если СтрокаТабличнойЧасти = "ПустаяСтрока" Тогда
		Данные = Форма;
	Иначе
		Если СтрокаТабличнойЧасти = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Данные = СтрокаТабличнойЧасти;
	КонецЕсли;
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Данные, ПутьРеквизита);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Данные, ПутьРеквизитаПредставления,
																ПолучитьПредставлениеМесяца(Значение));
	
КонецПроцедуры // ПериодРегистрацииПриОткрытии()

// Обработка события "ПриИзменении" поля ввода месяца строкой.
// 
// Параметры:
// Форма                      - <УправляемаяФорма>
//                            - Управляемая форма, с которым связано данное событие.
// ПутьРеквизита              - <Строка>
//                            - Путь к реквизиту формы.
// ПутьРеквизитаПредставления - <Строка>
//                            - Путь к реквизиту формы представления.
// Элемент                    - <ПолеВвода>
//                            - Поле ввода, с которым связано данное событие.
// СтрокаТабличнойЧасти       - <Строка>
//                            - Строка табличной части формы.
//
Процедура ПериодРегистрацииПриИзменении(Форма, ПутьРеквизита, ПутьРеквизитаПредставления,
										Элемент, СтрокаТабличнойЧасти = "ПустаяСтрока") Экспорт
	
	Если СтрокаТабличнойЧасти = "ПустаяСтрока" Тогда
		Данные = Форма;
	Иначе
		Если СтрокаТабличнойЧасти = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Данные = СтрокаТабличнойЧасти;
	КонецЕсли;
	
	ЗначениеПредставления = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Данные, ПутьРеквизитаПредставления);
	Значение              = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Данные, ПутьРеквизита);
	
	ДатаКакМесяцПодобратьДатуПоТексту(ЗначениеПредставления, Значение);
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Данные, ПутьРеквизитаПредставления,
																ПолучитьПредставлениеМесяца(Значение));
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Данные, ПутьРеквизита, Значение);
	
	Форма.Модифицированность = Истина;
	
КонецПроцедуры // ПериодРегистрацииПриИзменении()

// Обработка события "НачалоВыбора" поля ввода месяца строкой.
// 
// Параметры:
//  Форма                      - <УправляемаяФорма>
//                             - Управляемая форма, с которым связано данное событие.
//  ПутьРеквизита              - <Строка>
//                             - Путь к реквизиту формы.
//  ПутьРеквизитаПредставления - <Строка>
//                             - Путь к реквизиту формы представления.
//  Элемент                    - <ПолеВвода>
//                             - Поле ввода, с которым связано данное событие.
//  СтандартнаяОбработка       - <Булево>
//                             - В данный параметр передается признак выполнения
//                             - стандартной (системной) обработки события.
//  СтрокаТабличнойЧасти       - <Строка>
//                             - Строка табличной части формы.
//
Процедура ПериодРегистрацииНачалоВыбора(Форма, ПутьРеквизита, ПутьРеквизитаПредставления, Элемент,
										СтандартнаяОбработка, СтрокаТабличнойЧасти = "ПустаяСтрока", РежимВыбораПериода = "Месяц",
										ЗапрашиватьРежимВыбораПериодаУВладельца = Ложь) Экспорт
	
	Если СтрокаТабличнойЧасти = "ПустаяСтрока" Тогда
		Данные = Форма;
	Иначе
		Если СтрокаТабличнойЧасти = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Данные = СтрокаТабличнойЧасти;
	КонецЕсли;
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Данные, ПутьРеквизита);
	
	ПараметрыФормы = Новый Структура("Значение, РежимВыбораПериода, ЗапрашиватьРежимВыбораПериодаУВладельца",
									 Значение, РежимВыбораПериода, ЗапрашиватьРежимВыбораПериодаУВладельца);
	
	ДопПараметрыОповещения = Новый Структура("Форма, Данные, ПутьРеквизита, ПутьРеквизитаПредставления, Значение",
											 Форма, Данные, ПутьРеквизита, ПутьРеквизитаПредставления, Значение);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ПроцедураОписанияОповещенияОЗакрытии",
															ЭтотОбъект,
															ДопПараметрыОповещения);
	
	ОткрытьФорму("ОбщаяФорма.ВыборПериода",
				 ПараметрыФормы,
				 Форма,,,,
				 ОписаниеОповещенияОЗакрытии,
				 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры // ПериодРегистрацииНачалоВыбора()

// Обработчик выполнения описания оповещения.
Процедура ПроцедураОписанияОповещенияОЗакрытии(Результат, ДопПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ДопПараметры.Значение = Результат;
	КонецЕсли;
	
	Форма = ДопПараметры.Форма;
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(ДопПараметры.Данные, ДопПараметры.ПутьРеквизита, ДопПараметры.Значение);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(ДопПараметры.Данные, ДопПараметры.ПутьРеквизитаПредставления,
																ПолучитьПредставлениеМесяца(ДопПараметры.Значение));
	Форма.Модифицированность = Истина;
	
КонецПроцедуры // ПроцедураОписанияОповещенияОЗакрытии()

// Обработка события "Регулирование" поля ввода месяца строкой.
// 
// Параметры:
//  Форма                      - <УправляемаяФорма>
//                             - Управляемая форма, с которым связано данное событие.
//  ПутьРеквизита              - <Строка>
//                             - Путь к реквизиту формы.
//  ПутьРеквизитаПредставления - <Строка>
//                             - Путь к реквизиту формы представления.
//  Элемент                    - <ПолеВвода>
//                             - Поле ввода, с которым связано данное событие.
//  Направление                - <Число>
//                             - Указывается направление регулирования.
//  СтандартнаяОбработка       - <Булево>
//                             - В данный параметр передается признак выполнения
//                             - стандартной (системной) обработки события.
//  СтрокаТабличнойЧасти       - <Строка>
//                             - Строка табличной части формы.
//
Процедура ПериодРегистрацииРегулирование(Форма, ПутьРеквизита, ПутьРеквизитаПредставления, Элемент, Направление,
											СтандартнаяОбработка, СтрокаТабличнойЧасти = "ПустаяСтрока") Экспорт
	
	Если СтрокаТабличнойЧасти = "ПустаяСтрока" Тогда
		Данные = Форма;
	Иначе
		Если СтрокаТабличнойЧасти = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Данные = СтрокаТабличнойЧасти;
	КонецЕсли;
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Данные, ПутьРеквизита);
	Значение = ДобавитьМесяц(Значение, Направление);
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Данные, ПутьРеквизита, Значение);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Данные, ПутьРеквизитаПредставления,
																ПолучитьПредставлениеМесяца(Значение));
	
	Форма.Модифицированность = Истина;
	
КонецПроцедуры // ПериодРегистрацииРегулирование()

// Обработка события "АвтоПодборТекста" поля ввода месяца строкой.
// 
// Параметры:
//  Форма                      - <УправляемаяФорма>
//                             - Управляемая форма, с которым связано данное событие.
//  ПутьРеквизита              - <Строка>
//                             - Путь к реквизиту формы.
//  ПутьРеквизитаПредставления - <Строка>
//                             - Путь к реквизиту формы представления.
//  Элемент                    - <ПолеВвода>
//                             - Поле ввода, с которым связано данное событие.
//  Текст                      - <Строка>
//                             - Введенный текст.
//  Ожидание                   - <Число>
//                             - Время ожидания.
//  СтандартнаяОбработка       - <Булево>
//                             - В данный параметр передается признак выполнения
//                             - стандартной (системной) обработки события.
//  СтрокаТабличнойЧасти       - <Строка>
//                             - Строка табличной части формы.
//
Процедура ПериодРегистрацииАвтоПодборТекста(Форма, ПутьРеквизита, ПутьРеквизитаПредставления, Элемент, Текст,
											ДанныеВыбора, Ожидание, СтандартнаяОбработка, СтрокаТабличнойЧасти = "ПустаяСтрока") Экспорт
	
	ДанныеВыбора = ДатаКакМесяцПодобратьДатуПоТексту(Текст);
	
	Если ДанныеВыбора.Количество() = 1 Тогда
		ТекстАвтоПодбора = ДанныеВыбора[0].Значение;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры // ПериодРегистрацииАвтоПодборТекста()

// Обработка события "АвтоПодборТекста" поля ввода месяца строкой.
// 
// Параметры:
//  Форма                      - <УправляемаяФорма>
//                             - Управляемая форма, с которым связано данное событие.
//  ПутьРеквизита              - <Строка>
//                             - Путь к реквизиту формы.
//  ПутьРеквизитаПредставления - <Строка>
//                             - Путь к реквизиту формы представления.
//  Элемент                    - <ПолеВвода>
//                             - Поле ввода, с которым связано данное событие.
//  Текст                      - <Строка>
//                             - Введенный текст.
//  СтандартнаяОбработка       - <Булево>
//                             - В данный параметр передается признак выполнения
//                             - стандартной (системной) обработки события.
//  СтрокаТабличнойЧасти       - <Строка>
//                             - Строка табличной части формы.
//
Процедура ПериодРегистрацииОкончаниеВводаТекста(Форма, ПутьРеквизита, ПутьРеквизитаПредставления, Элемент, Текст,
												ДанныеВыбора, СтандартнаяОбработка, СтрокаТабличнойЧасти = "ПустаяСтрока") Экспорт
	
	Если Текст <> "" Тогда
		ДанныеВыбора = ДатаКакМесяцПодобратьДатуПоТексту(Текст);
		Если ДанныеВыбора.Количество() = 1 Тогда
			Значение = Текст;
		Иначе
			Значение = ДанныеВыбора;
		КонецЕсли;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ПериодРегистрацииОкончаниеВводаТекста()

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

// Формирует список колонок для которых необходимо получить данные в БД.
//
Функция ПолучитьСписокКолонокДляЗапроса(Таблица, Структура) Экспорт
	КолонкиДляЗапроса = Новый Структура;
	
	Если ТипЗнч(Таблица) = Тип("ТабличноеПоле") 
	 И ТипЗнч(Структура) = Тип("Структура") Тогда
		Для Каждого Колонка Из Таблица.Колонки Цикл
			Если Структура.Свойство(Колонка.Имя) И Колонка.Видимость Тогда
				КолонкиДляЗапроса.Вставить(Колонка.Имя);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат КолонкиДляЗапроса;
КонецФункции // ПолучитьСписокКолонокДляЗапроса()

// Проверяет наличие изменений в составе колонок для запроса.
//
Функция ИзменилсяСоставКолонок(СоставКолонокДо, СоставКолонокПосле) Экспорт
	
	ДлинаДо    = СоставКолонокДо.Количество();
	ДлинаПосле = СоставКолонокПосле.Количество();
	Сч = 0;
	Если ДлинаДо = ДлинаПосле Тогда
		Для Каждого Колонка Из СоставКолонокПосле Цикл
			Если НЕ СоставКолонокДо.Свойство(Колонка.Ключ) Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции // ИзменилсяСоставКолонок()

#КонецОбласти