#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ФОРМИРОВАНИЕ ЗАГОЛОВКА ОТЧЕТА

#Область ФормированиеЗаголовкаОтчета

// Выводит шапку отчета.
//
// Возвращаемое значение:
//  ТабличныйДокумент - область с заголовком отчета.
//
Функция СформироватьЗаголовок(ПараметрыОтчета) Экспорт
	
	Макет = Отчеты.УПЖКХ_КарточкаДолжника.ПолучитьМакет("Макет");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьЗаголовок.Параметры.Заголовок = ЗаголовокОтчета(ПараметрыОтчета);
	
	Возврат ОбластьЗаголовок;

КонецФункции // СформироватьЗаголовок()

// Формирует заголовок отчета.
//
// Возвращаемое значение:
//  Строка - заголовок отчета
//
Функция ЗаголовокОтчета(ПараметрыОтчета) Экспорт
	
	ЗаголовокОтчета = "КАРТОЧКА ДОЛЖНИКА " + "за период с " + Формат(ПараметрыОтчета.ДатаНач, "ДФ='dd.MM.yyyy'")
	      + " по " + Формат(ПараметрыОтчета.ДатаКон, "ДФ='dd.MM.yyyy'")
	      + ?(ПараметрыОтчета.Организация.Пустая(), "", Символы.ПС + " по организации: " + ПараметрыОтчета.Организация.Наименование);
		  
	Возврат ЗаголовокОтчета;
	
КонецФункции // ЗаголовокОтчета()

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПОСТРОЕНИЕ ОТЧЕТА

#Область ПостроениеОтчета

// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//  ДокументРезультат - табличный документ, в который будет осуществлен вывод.
//  ПоказыватьЗаголовок - Булево - показывать ли заголовок.
//  ВысотаЗаголовка - Число - переменная, в которую запишется высота
//                 области заголовка.
//
Процедура СформироватьОтчет(ПараметрыОтчета, АдресХранилища) Экспорт
	
	ДокументРезультат = Новый ТабличныйДокумент;
	
	Макет = Отчеты.УПЖКХ_КарточкаДолжника.ПолучитьМакет("Макет");
	
	ОбластьЗаголовка = СформироватьЗаголовок(ПараметрыОтчета);
	ВысотаЗаголовка = ОбластьЗаголовка.ВысотаТаблицы;
	ДокументРезультат.Вывести(ОбластьЗаголовка, 1);
	
	Если ЗначениеЗаполнено(ВысотаЗаголовка) Тогда
		ДокументРезультат.Область("R1:R" + ВысотаЗаголовка).Видимость = Истина;
	КонецЕсли;
	
	ОбластьШапкаТаблицы    = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьДетали          = Макет.ПолучитьОбласть("Детали");
	ОбластьПодвал          = Макет.ПолучитьОбласть("Подвал");
	
	ДанныеПоЛС = СформироватьДанныеПоЛицевомуСчету(ПараметрыОтчета.Должник, ПараметрыОтчета.ДатаКон,, ПараметрыОтчета.Организация);
	// Вывод общих сведений о лицевом счете.
	ОбластьШапка1 = Макет.ПолучитьОбласть("Шапка1");
	ОбластьШапка1.Параметры.Заполнить(ДанныеПоЛС);
	Если НЕ ДанныеПоЛС = Неопределено Тогда
		ВидСобственности = ДанныеПоЛС.ТипСобственностиКвартиры;
		Если ВидСобственности = Перечисления.УПЖКХ_ВидыСобственности.Частная Тогда
			ВидСобственности = "" + ВидСобственности + ", " + ДанныеПоЛС.ПодвидЧастнойСобственности;
		КонецЕсли;
		ОбластьШапка1.Параметры.ТипСобственности = ВидСобственности;
	КонецЕсли;
	ДокументРезультат.Вывести(ОбластьШапка1);
	
	НачалоПериода = НачалоМесяца(ПараметрыОтчета.ДатаНач);
	КонецПериода  = КонецМесяца(ПараметрыОтчета.ДатаКон);
	
	Если НЕ ПараметрыОтчета.Свойство("ВариантОтбораУслуг") Тогда
		ПараметрыОтчета.Вставить("ВариантОтбораУслуг", "формировать отчет по всем услугам");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", ПараметрыОтчета.Организация);
	Запрос.УстановитьПараметр("ЛицевойСчет", ПараметрыОтчета.Должник);
	Запрос.УстановитьПараметр("ДатаНач",     НачалоПериода);
	Запрос.УстановитьПараметр("ДатаКон",     КонецПериода);
	Запрос.Текст = ПолучитьТекстЗапросаДляНачислений();
	
	Если ПараметрыОтчета.ВариантОтбораУслуг = "формировать отчет по всем услугам" Тогда
		УсловиеНаУслугу = "ИСТИНА";
	Иначе
		Если ПараметрыОтчета.ВариантОтбораУслуг = "формировать отчет по указанным услугам" Тогда
			УсловиеНаУслугу = "Услуга В ИЕРАРХИИ (&СписокУслуг)";
		ИначеЕсли ПараметрыОтчета.ВариантОтбораУслуг = "формировать отчет по услугам кап. ремонта" Тогда
			УсловиеНаУслугу = "Услуга В (&СписокУслуг)";
		ИначеЕсли ПараметрыОтчета.ВариантОтбораУслуг = "формировать отчет по услугам, отличным от кап. ремонта" Тогда
			УсловиеНаУслугу = "НЕ Услуга В (&СписокУслуг)";
		КонецЕсли;
		Запрос.УстановитьПараметр("СписокУслуг", ПараметрыОтчета.СписокУслуг);
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоУслугам", УсловиеНаУслугу);
	
	Результат = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ПервУровень = Результат.Строки[0];
	
	// вывод шапки таблицы начислений по месяцам.
	ОбластьШапка2 = Макет.ПолучитьОбласть("Шапка2");
	ОбластьШапка2.Параметры.ЗадолженностьНачалоМесяцНач = ПервУровень.Строки[0].Начислено;
	ДокументРезультат.Вывести(ОбластьШапка2);
	
	// вывод таблицы начислений по месяцам выбранного периода.
	ОбластьСтрокаТаблицы2 = Макет.ПолучитьОбласть("СтрокаТаблицы2");
	ТекПериод             = КонецМесяца(НачалоПериода);
	КонечноеСальдо        = ?(ПервУровень.Строки.Количество() = 0, 0, ПервУровень.Строки.Получить(0).Начислено);
	
	Пока НЕ ТекПериод > КонецПериода Цикл
		ОбластьСтрокаТаблицы2.Параметры.ТекМесяц = Формат(ТекПериод, "ДФ='ММММ гггг'");;
		ТекСтрока = ПервУровень.Строки.Найти(КонецМесяца(ТекПериод), "МесяцНачисления");
		Если ТекСтрока = Неопределено Тогда
			ОбластьСтрокаТаблицы2.Параметры.Начислено     = 0;
			ОбластьСтрокаТаблицы2.Параметры.Оплачено      = 0;
			ОбластьСтрокаТаблицы2.Параметры.Корректировка = 0;
			ОбластьСтрокаТаблицы2.Параметры.КонСальдо     = КонечноеСальдо;
		Иначе
			ОбластьСтрокаТаблицы2.Параметры.Начислено     = ТекСтрока.Начислено - ТекСтрока.Льготы;
			ОбластьСтрокаТаблицы2.Параметры.Оплачено      = ТекСтрока.Оплачено;
			ОбластьСтрокаТаблицы2.Параметры.Корректировка = ТекСтрока.Корректировка;
			
			КонечноеСальдо = КонечноеСальдо + ОбластьСтрокаТаблицы2.Параметры.Начислено - ОбластьСтрокаТаблицы2.Параметры.Оплачено;
			
			ОбластьСтрокаТаблицы2.Параметры.КонСальдо = КонечноеСальдо;
		КонецЕсли;
		ТекПериод = ДобавитьМесяц(ТекПериод, 1);
		ДокументРезультат.Вывести(ОбластьСтрокаТаблицы2);
	КонецЦикла;
	
	// вывод итогов таблицы начислений по месяцам.
	ОбластьПодвал2 = Макет.ПолучитьОбласть("Подвал2");
	
	ИтогоОплачено      = ПервУровень.Строки.Итог("Оплачено");
	ИтогоКорректировка = ПервУровень.Строки.Итог("Корректировка");
	
	// Итоговая сумма начислений за вычетом начального сальдо и льгот.
	ИтогоНачислено = (ПервУровень.Строки.Итог("Начислено") - ПервУровень.Строки[0].Начислено - ПервУровень.Строки.Итог("Льготы"));
	
	// Задолженность на конец месяца = итог начислений с начальным сальдо за вычетом оплат.
	ЗадолженностьНачалоМесяцКон = ИтогоНачислено + ПервУровень.Строки[0].Начислено - ИтогоОплачено;
	
	ОбластьПодвал2.Параметры.ИтогоНачислено              = ИтогоНачислено;
	ОбластьПодвал2.Параметры.ИтогоОплачено               = ИтогоОплачено;
	ОбластьПодвал2.Параметры.ИтогоКорректировка          = ИтогоКорректировка;
	ОбластьПодвал2.Параметры.ИтогоКонСальдо              = КонечноеСальдо;
	ОбластьПодвал2.Параметры.НачалоМесяцКон              = Формат(КонецМесяца(ПараметрыОтчета.ДатаКон), "ДЛФ=ДД");
	ОбластьПодвал2.Параметры.ЗадолженностьНачалоМесяцКон = ЗадолженностьНачалоМесяцКон;
	ДокументРезультат.Вывести(ОбластьПодвал2);
	
	// Шапка таблицы
	ДокументРезультат.Вывести(ОбластьШапкаТаблицы);
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ДатаНач",     НачалоДня(ПараметрыОтчета.ДатаНач));
	Запрос.УстановитьПараметр("ДатаКон",     КонецДня(ПараметрыОтчета.ДатаКон));
	Запрос.УстановитьПараметр("Должник",     ПараметрыОтчета.Должник);
	Запрос.УстановитьПараметр("Организация", ПараметрыОтчета.Организация);
	
	Запрос.Текст = ПолучитьТекстЗапроса(ПараметрыОтчета);
	
	Результат = Запрос.Выполнить();
	ТаблицаРезультат = Результат.Выгрузить();
	Если ТаблицаРезультат.Количество() = 0 Тогда
		ТаблицаРезультат.Добавить();
	КонецЕсли;
	
	// Таблица
	
	Для Каждого СтрокаТаблицы Из ТаблицаРезультат Цикл
		
		ОбластьДетали.Параметры.Заполнить(СтрокаТаблицы);
		ОбластьДетали.Параметры.Документ = СтрокаТаблицы.Документ;
		ДокументРезультат.Вывести(ОбластьДетали);
		
	КонецЦикла;
	
	// Подвал
	ДокументРезультат.Вывести(ОбластьПодвал);
	
	ДокументРезультат.ПовторятьПриПечатиСтроки = ДокументРезультат.Область(ВысотаЗаголовка + 1, , ВысотаЗаголовка + 2, );
	
	// Присвоим имя для сохранения параметров печати табличного документа
	ДокументРезультат.ИмяПараметровПечати = "УПЖКХ_КарточкаДолжника";
	
	// Автоматическое масштабирование.
	ДокументРезультат.АвтоМасштаб = Истина;
	
	ПоместитьВоВременноеХранилище(ДокументРезультат, АдресХранилища);
	
КонецПроцедуры // СформироватьОтчет()

// Формирует текст запроса.
Функция ПолучитьТекстЗапросаДляНачислений()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СУММА(ВЫБОР
	|			КОГДА НЕ УПЖКХ_НачисленияОбороты.ВидНачисления В (ЗНАЧЕНИЕ(Перечисление.УПЖКХ_ВидыНачислений.Оплата), ЗНАЧЕНИЕ(Перечисление.УПЖКХ_ВидыНачислений.ЗачетДолговИПереплат))
	|					И НЕ УПЖКХ_НачисленияОбороты.РазделУчета = ЗНАЧЕНИЕ(Перечисление.УПЖКХ_РазделыУчета.Льготы)
	|				ТОГДА ЕСТЬNULL(УПЖКХ_НачисленияОбороты.СуммаНачисленияОборот, 0)
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Начислено,
	|	СУММА(ВЫБОР
	|			КОГДА УПЖКХ_НачисленияОбороты.РазделУчета = ЗНАЧЕНИЕ(Перечисление.УПЖКХ_РазделыУчета.Льготы)
	|				ТОГДА ЕСТЬNULL(-УПЖКХ_НачисленияОбороты.СуммаНачисленияОборот, 0)
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Льготы,
	|	СУММА(ВЫБОР
	|			КОГДА УПЖКХ_НачисленияОбороты.ВидНачисления = ЗНАЧЕНИЕ(Перечисление.УПЖКХ_ВидыНачислений.Корректировка)
	|					ИЛИ УПЖКХ_НачисленияОбороты.ВидНачисления = ЗНАЧЕНИЕ(Перечисление.УПЖКХ_ВидыНачислений.ПерерасчетНачисления)
	|					ИЛИ УПЖКХ_НачисленияОбороты.ВидНачисления = ЗНАЧЕНИЕ(Перечисление.УПЖКХ_ВидыНачислений.КорректировкаПриОтсутствииПоказанийПоИПУ)
	|				ТОГДА ЕСТЬNULL(УПЖКХ_НачисленияОбороты.СуммаНачисленияОборот, 0)
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Корректировка,
	|	СУММА(ВЫБОР
	|			КОГДА УПЖКХ_НачисленияОбороты.ВидНачисления = ЗНАЧЕНИЕ(Перечисление.УПЖКХ_ВидыНачислений.Оплата)
	|				ТОГДА ЕСТЬNULL(-УПЖКХ_НачисленияОбороты.СуммаНачисленияОборот, 0)
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Оплачено,
	|	КОНЕЦПЕРИОДА(УПЖКХ_НачисленияОбороты.Период, МЕСЯЦ) КАК МесяцНачисления
	|ИЗ
	|	РегистрНакопления.УПЖКХ_Начисления.Обороты(
	|			&ДатаНач,
	|			&ДатаКон,
	|			Месяц,
	|			Организация = &Организация
	|				И ЛицевойСчет = &ЛицевойСчет
	|				И &ОтборПоУслугам) КАК УПЖКХ_НачисленияОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	КОНЕЦПЕРИОДА(УПЖКХ_НачисленияОбороты.Период, МЕСЯЦ)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(КВП_НачисленияНаЛицевыеСчетаОстатки.СуммаНачисленияОстаток), 0),
	|	0,
	|	0,
	|	0,
	|	ДОБАВИТЬКДАТЕ(&ДатаНач, МЕСЯЦ, -1)
	|ИЗ
	|	РегистрНакопления.КВП_ВзаиморасчетыПоЛицевымСчетам.Остатки(
	|			&ДатаНач,
	|			Организация = &Организация
	|				И ЛицевойСчет = &ЛицевойСчет
	|				И &ОтборПоУслугам) КАК КВП_НачисленияНаЛицевыеСчетаОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	МесяцНачисления
	|ИТОГИ
	|	СУММА(Начислено),
	|	СУММА(Льготы),
	|	СУММА(Корректировка),
	|	СУММА(Оплачено)
	|ПО
	|	ОБЩИЕ,
	|	МесяцНачисления";
	
	Возврат ТекстЗапроса;
	
КонецФункции // ПолучитьТекстЗапроса()

// Формирует и возвращает текст запроса
Функция ПолучитьТекстЗапроса(ПараметрыОтчета)

	Если ПараметрыОтчета.Организация.Пустая() Тогда
		УсловиеПоОрганизации = "ИСТИНА";
	Иначе
		УсловиеПоОрганизации = "Организация = &Организация";
	КонецЕсли;
	
	Если ПараметрыОтчета.Должник.Пустая() Тогда
		УсловиеПоДолжнику = "ИСТИНА";
	Иначе
		Если ПараметрыОтчета.Должник.ЭтоГруппа Тогда
			УсловиеПоДолжнику = "Должник В ИЕРАРХИИ (&Должник)";
		Иначе
			УсловиеПоДолжнику = "Должник = &Должник";
		КонецЕсли;
	КонецЕсли;

	ПостроительОтчета = Новый ПостроительОтчета();
	ТекстПорядка = ПолучитьТекстПорядкаПоПостроителюОтчета(ПостроительОтчета);
	ТекстПорядка = ?(ПустаяСтрока(ТекстПорядка), "", "УПОРЯДОЧИТЬ ПО " + ТекстПорядка);

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ИсторияРаботы.Период КАК Дата,
	|	ИсторияРаботы.Регистратор КАК Документ
	|ИЗ
	|	РегистрСведений.УПЖКХ_ИсторияРаботыСДолжниками КАК ИсторияРаботы
	|ГДЕ
	|	ИсторияРаботы.Период МЕЖДУ &ДатаНач И &ДатаКон 
	|	И " + УсловиеПоОрганизации + "
	|	И " + УсловиеПоДолжнику + "
	|" + ТекстПорядка + "
	|{УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Документ}
	|";
	
	Возврат ТекстЗапроса;

КонецФункции // ПолучитьТекстЗапроса()

#КонецОбласти

#КонецЕсли