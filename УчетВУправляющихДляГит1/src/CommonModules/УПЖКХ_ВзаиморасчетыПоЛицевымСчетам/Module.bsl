
#Область СлужебныеПроцедурыИФункции

// Процедура заполняет таблицу движениями объекта.
//
// Параметры
//  СтруктураПараметров – Структура - параметры для формирования движений.
//  Приход              – Булево - движение отражает приход.
//
Процедура ЗаполнитьТаблицуДвиженийПоВзаиморасчетам(СтруктураПараметров, Приход)
	
	// Определим параметры движения.
	Знак        = ?(Приход, 1, -1);
	ВидДвижения = ?(Приход, ВидДвиженияНакопления.Приход, ВидДвиженияНакопления.Расход);
	
	// Заполним таблицу движений регистра "Взаиморасчеты по лицевым счетам".
	Если Приход Тогда
		
		// Если это приход, то просто записываем движения.
		
		Для Каждого СтрокаНачисления Из СтруктураПараметров.ТаблицаНачислений Цикл
			
			СуммаНачисления = Знак * СтрокаНачисления.СуммаНачисления;
			
			ДобавитьЗаписьРегистраВзаиморасчетыПоЛицевымСчетам(СтруктураПараметров.ТаблицаДвиженийВзаиморасчеты, ВидДвижения,
																СтрокаНачисления, СуммаНачисления, СтрокаНачисления.Договор);
			
			Если СтруктураПараметров.ФормироватьДвиженияВРегистреНачислений Тогда
				ДобавитьЗаписьРегистраНачисленияНаЛицевыеСчета(СтруктураПараметров.ТаблицаДвиженийНачисленияНаЛС, СтрокаНачисления,
																СуммаНачисления, СтрокаНачисления.Договор);
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		// Если это расход, то производим списание.
		
		// Выполнен частичный отказ от договоров в оперативном учете ЖКХ. Для тех, кто использует старый механизм
		// отражения начислений в регл. учете, договор заполняется в проводках, поэтому получим остатки начислений
		// в разрезе договоров и выполним их списание. Для тех, кто использует новый механизм отражения,
		// договор в проводках не заполняется, поэтому сразу записываем движения.
		Если Не УПЖКХ_ПараметрыУчетаСервер.ИспользоватьНовыйМеханизмОтраженияНачисленийВРеглУчете(СтруктураПараметров.Дата) Тогда
			
			// Получим остатки начислений в разрезе договоров.
			Запрос = Новый Запрос();
			Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ТаблицаИзмерений.Организация КАК Организация,
			|	ТаблицаИзмерений.ЛицевойСчет КАК ЛицевойСчет,
			|	ТаблицаИзмерений.Услуга КАК Услуга,
			|	ТаблицаИзмерений.МесяцНачисления КАК МесяцНачисления
			|ПОМЕСТИТЬ втТаблицаИзмерений
			|ИЗ
			|	&ТаблицаНачислений КАК ТаблицаИзмерений
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	КВП_ВзаиморасчетыПоЛицевымСчетамОстатки.Организация,
			|	КВП_ВзаиморасчетыПоЛицевымСчетамОстатки.ЛицевойСчет,
			|	КВП_ВзаиморасчетыПоЛицевымСчетамОстатки.Договор,
			|	КВП_ВзаиморасчетыПоЛицевымСчетамОстатки.Услуга,
			|	КВП_ВзаиморасчетыПоЛицевымСчетамОстатки.МесяцНачисления,
			|	КВП_ВзаиморасчетыПоЛицевымСчетамОстатки.СуммаНачисленияОстаток КАК СуммаОстатка
			|ИЗ
			|	РегистрНакопления.КВП_ВзаиморасчетыПоЛицевымСчетам.Остатки(
			|			&ДатаОстатков,
			|			Организация В
			|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
			|						ТаблицаИзмерений.Организация
			|					ИЗ
			|						втТаблицаИзмерений КАК ТаблицаИзмерений)
			|				И ЛицевойСчет В
			|					(ВЫБРАТЬ
			|						ТаблицаИзмерений.ЛицевойСчет
			|					ИЗ
			|						втТаблицаИзмерений КАК ТаблицаИзмерений)
			|				И Услуга В
			|					(ВЫБРАТЬ
			|						ТаблицаИзмерений.Услуга
			|					ИЗ
			|						втТаблицаИзмерений КАК ТаблицаИзмерений)
			|				И МесяцНачисления В
			|					(ВЫБРАТЬ
			|						ТаблицаИзмерений.МесяцНачисления
			|					ИЗ
			|						втТаблицаИзмерений КАК ТаблицаИзмерений)) КАК КВП_ВзаиморасчетыПоЛицевымСчетамОстатки";
			
			Запрос.УстановитьПараметр("ТаблицаНачислений", СтруктураПараметров.ТаблицаНачислений);
			Запрос.УстановитьПараметр("ДатаОстатков", СтруктураПараметров.Дата);
			
			ТаблицаОстатков = Запрос.Выполнить().Выгрузить();
			
			// Добавим индекс для поиска строк.
			ТаблицаОстатков.Индексы.Добавить("Организация,ЛицевойСчет,Услуга,МесяцНачисления");
			
			// Добавим записи в таблицу движений.
			Для Каждого СтрокаНачисления Из СтруктураПараметров.ТаблицаНачислений Цикл
				
				// Сумма для списания.
				СуммаДляСписания  = Знак * СтрокаНачисления.СуммаНачисления;
				ЗнакСуммыСписания = ?(СуммаДляСписания > 0, 1, -1);
				
				// Вид начисления для данного начисления.
				ВидНачисления = ?(СтрокаНачисления.РазделУчета = Перечисления.УПЖКХ_РазделыУчета.Пени,
								  Перечисления.КВП_ВидыНачисленияОстатки.Пени,
								  ?(СтрокаНачисления.РазделУчета = Перечисления.УПЖКХ_РазделыУчета.Рассрочка,
									Перечисления.КВП_ВидыНачисленияОстатки.Рассрочка,
									Перечисления.КВП_ВидыНачисленияОстатки.Начисление));
				
				// Строки остатков, откуда можно списывать.
				СтруктОтбор = Новый Структура();
				СтруктОтбор.Вставить("Организация",     СтрокаНачисления.Организация);
				СтруктОтбор.Вставить("ЛицевойСчет",     СтрокаНачисления.ЛицевойСчет);
				СтруктОтбор.Вставить("Услуга",          СтрокаНачисления.Услуга);
				СтруктОтбор.Вставить("МесяцНачисления", СтрокаНачисления.МесяцНачисления);
				СтрокиОстатков = ТаблицаОстатков.НайтиСтроки(СтруктОтбор);
				
				Для Каждого СтрокаОстатка Из СтрокиОстатков Цикл
					
					СуммаОстатка = СтрокаОстатка.СуммаОстатка;
					Если ЗнакСуммыСписания * СуммаОстатка < 0 Тогда
						// Если знак суммы остатка отличается от знака суммы для списания,
						// то с данного остатка ничего не списываем.
						Продолжить;
					КонецЕсли;
					
					// Определяем сумму возможного списания - минимум из сумм по модулю.
					ТекСуммаСписания = Мин(ЗнакСуммыСписания * СуммаДляСписания, ЗнакСуммыСписания * СуммаОстатка);
					
					// Заносим запись в таблицу движений.
					ДобавитьЗаписьРегистраВзаиморасчетыПоЛицевымСчетам(СтруктураПараметров.ТаблицаДвиженийВзаиморасчеты, ВидДвижения,
																		СтрокаНачисления, ЗнакСуммыСписания * ТекСуммаСписания, СтрокаОстатка.Договор);
					Если СтруктураПараметров.ФормироватьДвиженияВРегистреНачислений Тогда
						ДобавитьЗаписьРегистраНачисленияНаЛицевыеСчета(СтруктураПараметров.ТаблицаДвиженийНачисленияНаЛС, СтрокаНачисления,
																		Знак * ЗнакСуммыСписания * ТекСуммаСписания, СтрокаОстатка.Договор);
					КонецЕсли;
					
					// Уменьшим сумму для списания.
					СуммаДляСписания = СуммаДляСписания - ЗнакСуммыСписания * ТекСуммаСписания;
					
					// Если списали все, что нужно - заканчиваем с данным начислением.
					Если СуммаДляСписания = 0 Тогда
						Прервать;
					КонецЕсли;
					
				КонецЦикла;
				
				// Если списали не все, то списываем по основному договору.
				Если Не СуммаДляСписания = 0 Тогда
					Если ЗначениеЗаполнено(СтрокаНачисления.Договор) Тогда
						ОсновнойДоговор = СтрокаНачисления.Договор;
					ИначеЕсли СтруктураПараметров.РазрешитьЗаполнениеДоговора = Истина Тогда
						ОсновнойДоговор = 
							УПЖКХ_ОбщегоНазначенияСервер.ПолучитьСведенияДляВзаиморасчетовПоЛицевомуСчету(СтрокаНачисления.ЛицевойСчет, СтрокаНачисления.Организация,
																											СтрокаНачисления.Период, "Договор");
					Иначе
						ОсновнойДоговор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
					КонецЕсли;
					ДобавитьЗаписьРегистраВзаиморасчетыПоЛицевымСчетам(СтруктураПараметров.ТаблицаДвиженийВзаиморасчеты, ВидДвижения,
					                                         СтрокаНачисления, СуммаДляСписания, ОсновнойДоговор);
					Если СтруктураПараметров.ФормироватьДвиженияВРегистреНачислений Тогда
						ДобавитьЗаписьРегистраНачисленияНаЛицевыеСчета(СтруктураПараметров.ТаблицаДвиженийНачисленияНаЛС, СтрокаНачисления,
						                                               Знак * СуммаДляСписания, ОсновнойДоговор);
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе
			
			Для Каждого СтрокаНачисления Из СтруктураПараметров.ТаблицаНачислений Цикл
				
				СуммаДляСписания = Знак * СтрокаНачисления.СуммаНачисления;
				
				ДобавитьЗаписьРегистраВзаиморасчетыПоЛицевымСчетам(СтруктураПараметров.ТаблицаДвиженийВзаиморасчеты, ВидДвижения,
																	СтрокаНачисления, СуммаДляСписания, СтрокаНачисления.Договор);
				
				Если СтруктураПараметров.ФормироватьДвиженияВРегистреНачислений Тогда
					ДобавитьЗаписьРегистраНачисленияНаЛицевыеСчета(СтруктураПараметров.ТаблицаДвиженийНачисленияНаЛС, СтрокаНачисления,
																	Знак * СуммаДляСписания, СтрокаНачисления.Договор);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьТаблицуДвиженийПоВзаиморасчетам()

// Процедура, вызываемая из документов компоненты "Квартплата", формирует
// движения по регистрам "Взаиморасчеты по лицевым счетам" и "Начисления по лицевым счетам" и "Начисления".
//
// Параметры
//  ДокументОбъект – объект проводимого документа.
//  Таблицы начислений – структура, содержащая таблицу для вида движения Расход и таблицу
//                       с видом движения Приход.
//
Процедура СформироватьДвиженияПоВзаиморасчетам(ДокументОбъект, ТаблицыНачислений) Экспорт
	
	// Проверим лицензионный ключ.
	Если Не СЗК_МодульЗащиты.ЛицензионныйКлючКорректен() Тогда
		Возврат;
	КонецЕсли;
	
	///////////////////////////////////////////////////////////////////////////////
	// ПОДГОТОВКА ПАРАМЕТРОВ ДВИЖЕНИЙ
	
	// Подготовим таблицу для записи движений регистра "Взаиморасчеты по лицевым счетам".
	НаборДвиженийВзаиморасчеты = ДокументОбъект.Движения.КВП_ВзаиморасчетыПоЛицевымСчетам;
	ТаблицаДвиженийВзаиморасчеты = НаборДвиженийВзаиморасчеты.ВыгрузитьКолонки();
	
	ТипДокумента = ТипЗнч(ДокументОбъект.Ссылка);
	ФормироватьДвиженияВРегистреНачислений = (ТипДокумента = Тип("ДокументСсылка.КВП_ВводНачальногоСальдо")
										 ИЛИ ТипДокумента = Тип("ДокументСсылка.КВП_ВводФактическихЗатратНаОбъект")
										 ИЛИ ТипДокумента = Тип("ДокументСсылка.КВП_КорректировкаНачислений")
										 ИЛИ ТипДокумента = Тип("ДокументСсылка.КВП_НачислениеПени")
										 ИЛИ ТипДокумента = Тип("ДокументСсылка.КВП_НачислениеУслуг")
										 ИЛИ ТипДокумента = Тип("ДокументСсылка.КВП_РазовоеНачислениеУслуг")
										 ИЛИ ТипДокумента = Тип("ДокументСсылка.КВП_РасчетЛьгот")
										 ИЛИ ТипДокумента = Тип("ДокументСсылка.КВП_РегистрацияОплаты")
										 ИЛИ ТипДокумента = Тип("ДокументСсылка.УПЖКХ_НачислениеУслугВСтороннейПрограмме"));
	
	Если ФормироватьДвиженияВРегистреНачислений Тогда
		// Подготовим таблицу для записи движений регистра "Начисления".
		НаборДвиженийНачисленияНаЛС = ДокументОбъект.Движения.УПЖКХ_Начисления;
		ТаблицаДвиженийНачисленияНаЛС = НаборДвиженийНачисленияНаЛС.ВыгрузитьКолонки();
	КонецЕсли;
	
	///////////////////////////////////////////////////////////////////////////////
	// ЗАПОЛНЕНИЕ ТАБЛИЦЫ ДВИЖЕНИЙ
	
	ТаблицаНачисленийПриход = Неопределено;
	ТаблицаНачисленийРасход = Неопределено;
	ТаблицыНачислений.Свойство("Приход", ТаблицаНачисленийПриход);
	ТаблицыНачислений.Свойство("Расход", ТаблицаНачисленийРасход);
	
	// подготовка структуры параметров формирования движений
	СтуктураПараметров = Новый Структура;
	СтуктураПараметров.Вставить("Дата",                                   ДокументОбъект.Дата);
	СтуктураПараметров.Вставить("НаборДвиженийВзаиморасчеты",             НаборДвиженийВзаиморасчеты);
	СтуктураПараметров.Вставить("ТаблицаДвиженийВзаиморасчеты",           ТаблицаДвиженийВзаиморасчеты);
	СтуктураПараметров.Вставить("ФормироватьДвиженияВРегистреНачислений", ФормироватьДвиженияВРегистреНачислений);
	СтуктураПараметров.Вставить("НаборДвиженийНачисленияНаЛС",            НаборДвиженийНачисленияНаЛС);
	СтуктураПараметров.Вставить("ТаблицаДвиженийНачисленияНаЛС",          ТаблицаДвиженийНачисленияНаЛС);
	
	РазрешитьЗаполнениеДоговора = ТипДокумента = Тип("ДокументСсылка.КВП_РегистрацияОплаты");
	СтуктураПараметров.Вставить("РазрешитьЗаполнениеДоговора",            РазрешитьЗаполнениеДоговора);
	
	Если ТипЗнч(ТаблицаНачисленийПриход) = Тип("ТаблицаЗначений") И ТаблицаНачисленийПриход.Количество() > 0 Тогда
		СтуктураПараметров.Вставить("ТаблицаНачислений", ТаблицаНачисленийПриход);
		ЗаполнитьТаблицуДвиженийПоВзаиморасчетам(СтуктураПараметров, Истина);
	КонецЕсли;
	
	Если ТипЗнч(ТаблицаНачисленийРасход) = Тип("ТаблицаЗначений") И ТаблицаНачисленийРасход.Количество() > 0 Тогда
		СтуктураПараметров.Вставить("ТаблицаНачислений", ТаблицаНачисленийРасход);
		ЗаполнитьТаблицуДвиженийПоВзаиморасчетам(СтуктураПараметров, Ложь);
	КонецЕсли;
	
	///////////////////////////////////////////////////////////////////////////////
	// ЗАГРУЗКА ТАБЛИЦЫ ДВИЖЕНИЙ ДОКУМЕНТА
	
	// Загрузим движения документа.
	ТаблицаДвиженийВзаиморасчеты.ЗаполнитьЗначения(Истина, "Активность");
	ТаблицаДвиженийВзаиморасчеты.Свернуть("Активность, ВидДвижения, Период, Организация, ЛицевойСчет, Договор,
	                                      |МесяцНачисления, МесяцРассрочки, ВидНачисления, Услуга", "СуммаНачисления");
	ИсключитьЗаписиСНулевымиОборотами(ТаблицаДвиженийВзаиморасчеты);
	НаборДвиженийВзаиморасчеты.Загрузить(ТаблицаДвиженийВзаиморасчеты);
	
	Если ФормироватьДвиженияВРегистреНачислений Тогда
		ТаблицаДвиженийНачисленияНаЛС.ЗаполнитьЗначения(Истина, "Активность");
		ТаблицаДвиженийНачисленияНаЛС.Свернуть("Активность, Период, Организация, ЛицевойСчет, Договор, МесяцНачисления, МесяцРассрочки, РазделУчета, ВидНачисления, Услуга, СоставнаяУслуга, УслугаОснование,
		                                       |Тариф, ВидТарифа, Начало, Окончание, Тарифность, КоличествоУчетное, ИсточникОплаты, УровеньРаспределения, ОснованиеКорректировки, ТипНачисления, ДнейНачислено", "Количество, СуммаНачисления");
		НаборДвиженийНачисленияНаЛС.Загрузить(ТаблицаДвиженийНачисленияНаЛС);
	КонецЕсли;
	
КонецПроцедуры // СформироватьДвиженияПоВзаиморасчетам()

// Удаляет из таблицы движений строки, образовавшиеся в результате предоплаты рассрочки.
//
// Параметры:
//  ТаблицаДвижений - таблица с движениями.
//
Процедура ИсключитьЗаписиСНулевымиОборотами(ТаблицаДвижений)
	
	МассивСтрокУдаления = Новый Массив;
	
	Для Каждого СтрокаДвижений Из ТаблицаДвижений Цикл
		Если СтрокаДвижений.ВидНачисления = Перечисления.КВП_ВидыНачисленияОстатки.Рассрочка
		 И СтрокаДвижений.СуммаНачисления = 0 Тогда
		
		МассивСтрокУдаления.Добавить(СтрокаДвижений);
		
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаУдаления Из МассивСтрокУдаления Цикл
		ТаблицаДвижений.Удалить(СтрокаУдаления);
	КонецЦикла;
	
КонецПроцедуры // ИсключитьЗаписиСНулевымиОборотами()

// Добавляет запись в таблицу движений регистра "Начисления на лицевые счета".
//
// Параметры:
//  ТаблицаДвижений - таблица движений регистра.
//  СтрокаНачисления - строка начисления, из которой берутся данные.
//  СуммаНачисления - Число - сумма начисления.
//  Договор      - договор с контрагентом, по которому формируется движение.
//
Процедура ДобавитьЗаписьРегистраНачисленияНаЛицевыеСчета(ТаблицаДвижений, СтрокаНачисления, СуммаНачисления, Договор)
	
	НоваяСтрока = ТаблицаДвижений.Добавить();
	
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаНачисления, , "ВидНачисления");
	НоваяСтрока.ВидНачисления          = СтрокаНачисления.ВидНачисленияНаЛицевыеСчета;
	НоваяСтрока.ОснованиеКорректировки = СтрокаНачисления.ОснованиеПерерасчета;
	НоваяСтрока.Договор                = Договор;
	НоваяСтрока.СуммаНачисления        = СуммаНачисления;
	
КонецПроцедуры // ДобавитьЗаписьРегистраНачисленияНаЛицевыеСчета()

// Добавляет запись в таблицу движений регистра "Взаиморасчеты по лицевым счетам".
//
// Параметры:
//  ТаблицаДвижений - таблица движений регистра.
//  ВидДвижения  - вид движения для строки движения.
//  СтрокаНачисления - строка начисления, из которой берутся данные.
//  СуммаНачисления - Число - сумма начисления.
//  Договор      - договор с контрагентом, по которому формируется движение.
//
Процедура ДобавитьЗаписьРегистраВзаиморасчетыПоЛицевымСчетам(ТаблицаДвижений, 
															 ВидДвижения, 
															 СтрокаНачисления,
															 СуммаНачисления, 
															 Договор)
	
	НоваяСтрока = ТаблицаДвижений.Добавить();
	
	НоваяСтрока.Период           = СтрокаНачисления.Период;
	НоваяСтрока.ВидДвижения      = ВидДвижения;
	НоваяСтрока.Организация      = СтрокаНачисления.Организация;
	НоваяСтрока.ЛицевойСчет      = СтрокаНачисления.ЛицевойСчет;
	НоваяСтрока.ВидНачисления    = ?(СтрокаНачисления.РазделУчета = Перечисления.УПЖКХ_РазделыУчета.Пени,
	                                 Перечисления.КВП_ВидыНачисленияОстатки.Пени,
	                                 ?(СтрокаНачисления.РазделУчета = Перечисления.УПЖКХ_РазделыУчета.Рассрочка,
									  Перечисления.КВП_ВидыНачисленияОстатки.Рассрочка,
									  Перечисления.КВП_ВидыНачисленияОстатки.Начисление));
	НоваяСтрока.Услуга           = СтрокаНачисления.Услуга;
	НоваяСтрока.МесяцНачисления  = СтрокаНачисления.МесяцНачисления;
	НоваяСтрока.МесяцРассрочки   = СтрокаНачисления.МесяцРассрочки;
	НоваяСтрока.Договор          = Договор;
	НоваяСтрока.СуммаНачисления  = СуммаНачисления;
	
КонецПроцедуры // ДобавитьЗаписьРегистраВзаиморасчетыПоЛицевымСчетам()

// Возвращает пустую таблицу значений для последующего заполнения движений по регистрам
//  "Взаиморасчеты по лицевым счетам", "Начисления", "Поступление денежных средств по видам платежей".
//
// Параметры
//  Нет.
//
Функция КВП_СформироватьТаблицуДвижений() Экспорт
	
	ТаблицаДвижений = Новый ТаблицаЗначений;
	
	ТаблицаДвижений.Колонки.Добавить("Период",                      УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьОписаниеТиповДаты(ЧастиДаты.ДатаВремя));
	ТаблицаДвижений.Колонки.Добавить("Организация",                 Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаДвижений.Колонки.Добавить("ЛицевойСчет",                 Новый ОписаниеТипов("СправочникСсылка.КВП_ЛицевыеСчета"));
	ТаблицаДвижений.Колонки.Добавить("Договор",                     Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов"));
	ТаблицаДвижений.Колонки.Добавить("Услуга",                      Новый ОписаниеТипов("СправочникСсылка.КВП_Услуги"));
	ТаблицаДвижений.Колонки.Добавить("СоставнаяУслуга",             Новый ОписаниеТипов("СправочникСсылка.КВП_Услуги"));
	ТаблицаДвижений.Колонки.Добавить("УслугаОснование",             Новый ОписаниеТипов("СправочникСсылка.КВП_Услуги"));
	ТаблицаДвижений.Колонки.Добавить("ЛьготнаяКатегория",           Новый ОписаниеТипов("СправочникСсылка.КВП_ЛьготныеКатегории"));
	ТаблицаДвижений.Колонки.Добавить("МесяцНачисления",             УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьОписаниеТиповДаты(ЧастиДаты.Дата));
	ТаблицаДвижений.Колонки.Добавить("МесяцРассрочки",              УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьОписаниеТиповДаты(ЧастиДаты.Дата));
	ТаблицаДвижений.Колонки.Добавить("ИсточникОплаты",              Новый ОписаниеТипов("СправочникСсылка.КВП_ИсточникиОплат"));
	ТаблицаДвижений.Колонки.Добавить("РазделУчета",                 Новый ОписаниеТипов("ПеречислениеСсылка.УПЖКХ_РазделыУчета"));
	ТаблицаДвижений.Колонки.Добавить("ВидНачисленияНаЛицевыеСчета", Новый ОписаниеТипов("ПеречислениеСсылка.УПЖКХ_ВидыНачислений"));
	ТаблицаДвижений.Колонки.Добавить("ВидТарифа",                   Новый ОписаниеТипов("ПеречислениеСсылка.КВП_ВидыТарифов"));
	ТаблицаДвижений.Колонки.Добавить("Тариф",                       Метаданные.ОпределяемыеТипы.УПЖКХ_ТарифНачисления.Тип);
	ТаблицаДвижений.Колонки.Добавить("Количество",                  УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьОписаниеТиповЧисла(18, 6));
	ТаблицаДвижений.Колонки.Добавить("СуммаНачисления",             УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьОписаниеТиповЧисла(15, 2));
	ТаблицаДвижений.Колонки.Добавить("ДнейНачислено",               УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьОписаниеТиповЧисла(5));
	ТаблицаДвижений.Колонки.Добавить("Коллективный",                Новый ОписаниеТипов("Булево"));
	ТаблицаДвижений.Колонки.Добавить("Начало",                      УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьОписаниеТиповДаты(ЧастиДаты.Дата));
	ТаблицаДвижений.Колонки.Добавить("Окончание",                   УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьОписаниеТиповДаты(ЧастиДаты.Дата));
	ТаблицаДвижений.Колонки.Добавить("Тарифность",                  УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьОписаниеТиповЧисла(10, 0, ДопустимыйЗнак.Неотрицательный));
	
	// Учетный индивидуальный объем нужен для квитанций и платежных документов.
	// Примечание: для зависимых услуг поле не заполняется.
	ТаблицаДвижений.Колонки.Добавить("КоличествоУчетное",           УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьОписаниеТиповЧисла(18, 6));
	ТаблицаДвижений.Колонки.Добавить("УровеньРаспределения",        Новый ОписаниеТипов("Строка"));
	ТаблицаДвижений.Колонки.Добавить("ОснованиеПерерасчета",        Новый ОписаниеТипов("Строка"));
	ТаблицаДвижений.Колонки.Добавить("ВидПлатежа",                  Новый ОписаниеТипов("СправочникСсылка.КВП_ИсточникиОплат"));
	ТаблицаДвижений.Колонки.Добавить("ФактическаяОплата",           Новый ОписаниеТипов("Булево"));
	ТаблицаДвижений.Колонки.Добавить("СуммаПлатежа",                УПЖКХ_ТиповыеМетодыКлиентСервер.ПолучитьОписаниеТиповЧисла(15, 3));
	ТаблицаДвижений.Колонки.Добавить("ВидНачисления",               Новый ОписаниеТипов("ПеречислениеСсылка.КВП_ВидыНачисленияОстатки"));
	ТаблицаДвижений.Колонки.Добавить("ТипНачисления",               Новый ОписаниеТипов("ПеречислениеСсылка.УПЖКХ_ТипНачисления"));
	
	Возврат ТаблицаДвижений;
	
КонецФункции // КВП_СформироватьТаблицуДвижений()

// Процедура формирует движения по регистрам "Поступление денежных средств по видам платежей".
//
// Параметры:
//  ДокументОбъект     – объект проводимого документа.
//  Таблицы начислений – структура, содержащая таблицу движения.
//
Процедура СформироватьДвиженияПоПоступлениюДенежныхСредствПоВидамПлатежей(ДокументОбъект, ТаблицаОплат) Экспорт 
	
	// Проверим лицензионный ключ.
	Если Не СЗК_МодульЗащиты.ЛицензионныйКлючКорректен() Тогда
		Возврат;
	КонецЕсли;
	
	НаборДвижений = ДокументОбъект.Движения.КВП_ПоступлениеДенежныхСредствПоВидамПлатежей;
	ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
	
	Для Каждого СтрокаОплаты Из ТаблицаОплат Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаДвижений.Добавить(), СтрокаОплаты);
	КонецЦикла;
	
	ТаблицаДвижений.ЗаполнитьЗначения(Истина, "Активность");
	
	НаборДвижений.Загрузить(ТаблицаДвижений);
	
КонецПроцедуры // СформироватьДвиженияПоПоступлениюДенежныхСредствПоВидамПлатежей()

// Возвращает массив организаций, обслуживающих лицевой счет.
//
Функция ПолучитьМассивОрганизацийОбслуживающихЛицевойСчет(ЛицевойСчет) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КВП_ЛицевыеСчета.Ссылка КАК ЛицевойСчет
	|ПОМЕСТИТЬ втЛицевыеСчета
	|ИЗ
	|	Справочник.КВП_ЛицевыеСчета КАК КВП_ЛицевыеСчета
	|ГДЕ
	|	КВП_ЛицевыеСчета.Ссылка В ИЕРАРХИИ(&ЛицевойСчет)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	УПЖКХ_СведенияДляВзаиморасчетовПоЛССрезПоследних.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.УПЖКХ_СведенияДляВзаиморасчетовПоЛС.СрезПоследних(
	|			&ТекущаяДата,
	|			ЛицевойСчет В
	|				(ВЫБРАТЬ
	|					втЛицевыеСчета.ЛицевойСчет
	|				ИЗ
	|					втЛицевыеСчета КАК втЛицевыеСчета)) КАК УПЖКХ_СведенияДляВзаиморасчетовПоЛССрезПоследних";
	
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Запрос.УстановитьПараметр("ЛицевойСчет", ЛицевойСчет);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат.ВыгрузитьКолонку("Организация");
	
КонецФункции

#КонецОбласти