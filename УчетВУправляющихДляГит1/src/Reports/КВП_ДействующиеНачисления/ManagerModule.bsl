
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура формирует отчет.
Процедура СформироватьОтчет(ПараметрыОтчета, АдресХранилища) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	Макет = Отчеты.КВП_ДействующиеНачисления.ПолучитьМакет("Макет" + ?(ПараметрыОтчета.ГруппироватьПоОбъектам, "Объект", "Услуга"));
	
	ОбластьЗаголовка = Макет.ПолучитьОбласть("Заголовок");
	ОбластьЗаголовка.Параметры.Заголовок = ЗаголовокОтчета(ПараметрыОтчета);
	ТабличныйДокумент.Вывести(ОбластьЗаголовка);
	
	ВысотаЗаголовка = ОбластьЗаголовка.ВысотаТаблицы;
	
	ОбластьШапкаТаблицы   = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы  = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьПодвал         = Макет.ПолучитьОбласть("Подвал");
	
	// Шапка таблицы.
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Дата",   КонецДня(ПараметрыОтчета.ДатаПросмотра));
	Запрос.УстановитьПараметр("Объект", ПараметрыОтчета.ОбъектНачисления);
	
	СписокЗданий         = Новый СписокЗначений();
	ИмяОбъектаНачисления = ПараметрыОтчета.ОбъектНачисления.Метаданные().ПолноеИмя();
	
	// Если указанный объект - группа, то собираются все элементы по иерархии.
	ОбъектСписок = ПолучитьЭлементыСправочникаПоГруппе(ПараметрыОтчета.ОбъектНачисления);
	
	СписокЗданий = КВП_ПолучитьСписокЗданийПоЛицевымСчетам(ОбъектСписок);
	
	Запрос.УстановитьПараметр("СписокЗданий", СписокЗданий);
	
	Запрос.Текст = ПолучитьТекстЗапроса(ПараметрыОтчета);
	
	ТабличныйДокумент.НачатьАвтогруппировкуСтрок();
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		ОбластьДетали = Макет.ПолучитьОбласть("ДеталиУровень" + Выборка.Уровень());
		ОбластьДетали.Параметры.Заполнить(Выборка);
		ТабличныйДокумент.Вывести(ОбластьДетали, Выборка.Уровень());
	
	КонецЦикла;
	ТабличныйДокумент.ЗакончитьАвтогруппировкуСтрок();
	
	УровеньГруппировкиСтрок = Неопределено;
	Если Не ПараметрыОтчета.Свойство("УровеньГруппировки", УровеньГруппировкиСтрок) Тогда
		УровеньГруппировкиСтрок = 0;
	КонецЕсли;
	ТабличныйДокумент.ПоказатьУровеньГруппировокСтрок(УровеньГруппировкиСтрок);
	
	// Подвал таблицы
	ТабличныйДокумент.Вывести(ОбластьПодвалТаблицы);
	
	// Подвал
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
	// Зафиксируем заголовок отчета и колонки
	ТабличныйДокумент.ФиксацияСверху = ВысотаЗаголовка + 2;
	
	ТабличныйДокумент.ПовторятьПриПечатиСтроки = ТабличныйДокумент.Область(ВысотаЗаголовка + 2, , ВысотаЗаголовка + 2, );
	
	// Первую колонку не печатаем
	ТабличныйДокумент.ОбластьПечати = ТабличныйДокумент.Область(1, 2,
	                                  ТабличныйДокумент.ВысотаТаблицы, ТабличныйДокумент.ШиринаТаблицы);
	
	// Присвоим имя для сохранения параметров печати табличного документа
	ТабличныйДокумент.ИмяПараметровПечати = "ДействующиеНачисленияКВП";
	
	ПоместитьВоВременноеХранилище(ТабличныйДокумент, АдресХранилища);
	
КонецПроцедуры

// Возвращает текст запроса в зависимости от выбранного типа объектов.
Функция ПолучитьТекстЗапроса(ПараметрыОтчета)
	
	ФильтрПоОбъекту = ЗначениеЗаполнено(ПараметрыОтчета.ОбъектНачисления);
	
	Если ФильтрПоОбъекту Тогда
		Если ПараметрыОтчета.ОбъектНачисления.ЭтоГруппа Тогда
			ТекстУсловие = "Объект В ИЕРАРХИИ (&Объект)";
		Иначе
			ТекстУсловие = "Объект = &Объект";
		КонецЕсли;
	Иначе
		ТекстУсловие = "Объект ССЫЛКА Справочник.КВП_ЛицевыеСчета";
	КонецЕсли;
	
	ТекстУсловие = ТекстУсловие + " И ДатаИзменения <= &Дата";
	
	ТекстОтбора = "КВП_НазначенныеНачисленияСрезПоследних.Действует = ИСТИНА";
	
	ТекстИтогов = ?(ПараметрыОтчета.ГруппироватьПоОбъектам, "Объект", "Услуга");
	
	Если ПараметрыОтчета.ГруппироватьПоОбъектам Тогда
		ТекстУпорядочивания = "КВП_НазначенныеНачисленияСрезПоследних.Объект.Наименование,
		                      |КВП_НазначенныеНачисленияСрезПоследних.Услуга.Наименование";
	Иначе
		ТекстУпорядочивания = "КВП_НазначенныеНачисленияСрезПоследних.Услуга.Наименование,
							  |КВП_НазначенныеНачисленияСрезПоследних.Объект.Наименование";
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КВП_НазначенныеНачисленияСрезПоследних.Регистратор КАК ДокументНачисления,
	|	КВП_НазначенныеНачисленияСрезПоследних.Объект КАК Объект,
	|	КВП_НазначенныеНачисленияСрезПоследних.Услуга,
	|	КВП_НазначенныеНачисленияСрезПоследних.ДатаИзменения КАК ДатаНазначения,
	|	КВП_НазначенныеНачисленияСрезПоследних.Организация КАК Организация,
	|	КВП_ПоставщикиУслугСрезПоследних.Поставщик.НаименованиеПолное КАК ОбслуживающаяОрганизация,
	|	КВП_ПоставщикиУслугСрезПоследних.Поставщик КАК ОбслуживающаяОрганизацияСсылка
	|ИЗ
	|	РегистрСведений.КВП_НазначенныеНачисления.СрезПоследних(&Дата, " + ТекстУсловие + ") КАК КВП_НазначенныеНачисленияСрезПоследних
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УПЖКХ_ПоставщикиУслуг.СрезПоследних(&Дата, Объект В(&СписокЗданий)) КАК КВП_ПоставщикиУслугСрезПоследних
	|		ПО КВП_ПоставщикиУслугСрезПоследних.ВидУслуги = КВП_НазначенныеНачисленияСрезПоследних.Услуга.ВидУслуги
	|ГДЕ
	|	" + ТекстОтбора + "
	|{ГДЕ
	|	КВП_НазначенныеНачисленияСрезПоследних.Объект КАК Объект,
	|	КВП_НазначенныеНачисленияСрезПоследних.Услуга.*,
	|	КВП_НазначенныеНачисленияСрезПоследних.ДатаИзменения,
	|	КВП_ПоставщикиУслугСрезПоследних.Поставщик.*}
	|
	|УПОРЯДОЧИТЬ ПО
	|	" + ТекстУпорядочивания + "
	|{УПОРЯДОЧИТЬ ПО
	|	Объект,
	|	Услуга.*,
	|	ДатаНазначения,
	|	ОбслуживающаяОрганизация.*}
	|ИТОГИ ПО
	|	" + ТекстИтогов;

	Возврат ТекстЗапроса;

КонецФункции // ПолучитьТекстЗапроса()

// Формирует заголовок отчета.
//
// Возвращаемое значение:
//  Строка - заголовок отчета
//
Функция ЗаголовокОтчета(ПараметрыОтчета)
	
	ТекстЗаголовка = "Действующие начисления на дату " + Формат(ПараметрыОтчета.ДатаПросмотра, "ДФ=dd.MM.yyyy");
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.ОбъектНачисления) Тогда
		ТекстЗаголовка = ТекстЗаголовка + " по объекту " + Строка(ПараметрыОтчета.ОбъектНачисления);
	КонецЕсли;
	
	Возврат ТекстЗаголовка;
	
КонецФункции // ЗаголовокОтчета()

#КонецОбласти 

#КонецЕсли