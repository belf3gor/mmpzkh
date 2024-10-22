#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события "ПриСозданииНаСервере" формы.
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	УПЖКХ_ТиповыеМетодыСервер.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Устанавливаем значение по умолчанию.
	Если Объект.Ссылка.Пустая() Тогда
		УПЖКХ_ЗаполнениеДокументовСервер.ЗаполнитьШапкуДокумента(Объект, 
																	УПЖКХ_ТиповыеМетодыКлиентСервер.ТекущийПользователь());
		УПЖКХ_ТиповыеМетодыСервер.УстановитьСостояниеДокумента(ЭтотОбъект);
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
	// Установить доступность формы с учетом ключа СЛК.
	СЗК_МодульЗащитыКлиентСервер.УстановитьДоступностьФормыДляРедактирования(ЭтаФорма);
	
	// ОбщиеМеханизмыИКоманды
	ОТР_ПодключаемыеОбщиеМеханизмыИКоманды.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ОбщиеМеханизмыИКоманды
	
КонецПроцедуры

&НаСервере
// Процедура - обработчик события "ПриЧтенииНаСервере" формы.
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УПЖКХ_ТиповыеМетодыСервер.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	УПЖКХ_ТиповыеМетодыСервер.УстановитьСостояниеДокумента(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события "ПриОткрытии" формы.
Процедура ПриОткрытии(Отказ)
	
	мОтказУчетнаяПолитика = Ложь;
	мНастройкиУчетнойПолитикиТСЖ = УПЖКХ_ОбщегоНазначенияСервер.ПолучитьПараметрыУчетнойПолитикиЖКХ(Объект.Дата, 
																										Объект.Организация, мОтказУчетнаяПолитика);
	
	Если мОтказУчетнаяПолитика = Истина Тогда
		Возврат;
	КонецЕсли;
	
	УчитыватьВступительныеВзносыТСЖ = мНастройкиУчетнойПолитикиТСЖ["УчитыватьВступительныеВзносыТСЖ"];
	Элементы.ЧленыТСЖСуммаВступительногоВзноса.Видимость = УчитыватьВступительныеВзносыТСЖ;
	Элементы.ЧленыТСЖПКО.Видимость                       = УчитыватьВступительныеВзносыТСЖ;
	Элементы.ЧленыТСЖКомандаСформироватьПКО.Видимость    = УчитыватьВступительныеВзносыТСЖ;
	
КонецПроцедуры

&НаСервере
// Процедура - обработчик события "ПослеЗаписиНаСервере" формы.
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УПЖКХ_ТиповыеМетодыСервер.УстановитьСостояниеДокумента(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Обработчик события "ПриИзменении" поля "Дата".
Процедура ДатаПриИзменении(Элемент)
	
	УПЖКХ_РаботаСДиалогамиКлиентСервер.ПроверитьНомерДокумента(Объект, Объект.Дата);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
// Обработчик команды "КомандаЗаполнить".
Процедура КомандаЗаполнить(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Дата) Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("Не указана дата документа");
		Возврат;
	КонецЕсли;

	Если Объект.Организация.Пустая() Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("Не указана организация.");
		Возврат;
	КонецЕсли;
	
	// Вопрос о продолжении, если есть введенные данные.
	Если Не Объект.ЧленыТСЖ.Количество() = 0 Тогда
		ТекстВопроса = "Перед заполнением табличная часть будет очищена. Продолжить?";
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбработатьРезультатВопросаКомандаЗаполнить", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	КомандаЗаполнитьПродожение();
	
КонецПроцедуры // КомандаЗаполнить()

&НаКлиенте
// Процедура-обработчик результата вопроса, вызванного в процедуре "ОбработатьРезультатВопросаКомандаЗаполнить()".
Процедура ОбработатьРезультатВопросаКомандаЗаполнить(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	КомандаЗаполнитьПродожение();

КонецПроцедуры // ОбработатьРезультатВопросаКомандаЗаполнить()

&НаКлиенте
// Процедуре-продолжение процедуры-обработчика команды "КомандаЗаполнить()".
Процедура КомандаЗаполнитьПродожение()
	
	ЗаполнитьТабличнуюЧастьНаСервере();
	
	ОбновитьОтображениеДанных();
	
КонецПроцедуры // КомандаЗаполнитьПродожение()

&НаКлиенте
// Обработчик команды "КомандаСформироватьПКО".
Процедура КомандаСформироватьПКО(Команда)
	
	// Запись документа, чтобы избежать создания кучи ПКО для непроведенного документа
	Если Модифицированность Тогда
		ТекстВопроса = "Действие может быть выполнено только после записи документа. Записать?";
		ПоказатьВопрос(Новый ОписаниеОповещения("КомандаСформироватьПКОЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	КомандаСформироватьПКОПродолжение();
	
КонецПроцедуры // КомандаСформироватьПКО()

&НаКлиенте
// Процедура-обработчик результата вопроса, вызванного в процедуре-обработчике команды "КомандаСформироватьПКО()".
Процедура КомандаСформироватьПКОЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Или Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	КомандаСформироватьПКОПродолжение();
	
КонецПроцедуры // КомандаСформироватьПКОЗавершение()

&НаКлиенте
// Процедура-продолжение процедуры-обработчика команды "КомандаСформироватьПКО()".
Процедура КомандаСформироватьПКОПродолжение()
	
	СформироватьПКОНаСервере();
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

КонецПроцедуры // КомандаСформироватьПКОПродолжение()

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	
	УПЖКХ_ТиповыеМетодыСервер.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ЧастоЗадаваемыеВопросы
&НаКлиенте
// Подключаемый обработчик команды перехода к часто задаваемым вопросам.
Процедура Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда)
	
	ОТР_ЧастоЗадаваемыеВопросыКлиент.Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда);
	
КонецПроцедуры
// Конец ЧастоЗадаваемыеВопросы

#КонецОбласти

#Область ОбщиеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста 
// Устанавливает видимость элементов формы.
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
КонецПроцедуры // УстановитьВидимостьЭлементов()

&НаСервере
// Заполняет ТЧ
Процедура ЗаполнитьТабличнуюЧастьНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьТабличнуюЧасть();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры // ЗаполнитьТабличнуюЧасть()

&НаСервере
// Процедура формирует ПКО.
Процедура СформироватьПКОНаСервере()
	
	// Формирование ПКО
	ТаблицаКонтрагентов = Объект.ЧленыТСЖ.Выгрузить();
	ТаблицаКонтрагентов.Свернуть("Контрагент, ПКО", "СуммаВступительногоВзноса");
	
	Для Каждого ТекСтрока Из ТаблицаКонтрагентов Цикл
		
		Если ТекСтрока.СуммаВступительногоВзноса = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		// Если не хватает информации или не нужно формировать - не формируем
		Если ТекСтрока.Контрагент = Неопределено ИЛИ ТекСтрока.СуммаВступительногоВзноса = 0 ИЛИ ЗначениеЗаполнено(ТекСтрока.ПКО) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекПользователь = УПЖКХ_ТиповыеМетодыКлиентСервер.ТекущийПользователь();
		ОсновнойДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		УПЖКХ_ТиповыеМетодыСервер.УстановитьДоговорКонтрагента(ОсновнойДоговорКонтрагента, ТекСтрока.Контрагент, Объект.Организация);
		
		СчетаУчета = УПЖКХ_ТиповыеМетодыСервер.ПолучитьСчетаРасчетовСКонтрагентом(
																			Объект.Организация, 
																			ТекСтрока.Контрагент, 
																			ОсновнойДоговорКонтрагента);
		// Формирование ПКО для текущего контрагента
		ОбъектПКО = Документы.ПриходныйКассовыйОрдер.СоздатьДокумент();
		
		// Заполнение реквизитов ПКО
		ОбъектПКО.Организация        = Объект.Организация;
		ОбъектПКО.ВидОперации        = Перечисления.ВидыОперацийПКО.ПрочийПриход;
		ОбъектПКО.Дата               = Объект.Дата;
		ОбъектПКО.ВалютаДокумента    = Константы.ВалютаРегламентированногоУчета.Получить();
		ОбъектПКО.Контрагент         = ТекСтрока.Контрагент;
		ОбъектПКО.ДоговорКонтрагента = ОсновнойДоговорКонтрагента;
		ОбъектПКО.СубконтоКт1        = ТекСтрока.Контрагент;
		ОбъектПКО.СубконтоКт2        = ОсновнойДоговорКонтрагента;
		ОбъектПКО.СчетУчетаРасчетовСКонтрагентом = СчетаУчета.СчетРасчетовПокупателя;
		
		ОбъектПКО.Основание = Объект.Ссылка;
		ОбъектПКО.Ответственный = ТекПользователь;
		
		ОбъектПКО.СчетКасса = ПланыСчетов.Хозрасчетный.КассаОрганизации;
		
		// Заполнение ТЧ "Расшифровка платежей"
		ОбъектПКО.РасшифровкаПлатежа.Очистить();
		НоваяСтрока = ОбъектПКО.РасшифровкаПлатежа.Добавить();
		НоваяСтрока.СчетУчетаРасчетовСКонтрагентом = СчетаУчета.СчетРасчетовПокупателя;
		НоваяСтрока.СчетУчетаРасчетовПоАвансам     = СчетаУчета.СчетАвансовПокупателя;
		НоваяСтрока.ДоговорКонтрагента             = ОсновнойДоговорКонтрагента;
		НоваяСтрока.СуммаПлатежа                   = ТекСтрока.СуммаВступительногоВзноса;
		НоваяСтрока.СуммаВзаиморасчетов            = ТекСтрока.СуммаВступительногоВзноса;
		
		// Заполнение суммы документа
		ОбъектПКО.СуммаДокумента = ОбъектПКО.РасшифровкаПлатежа.Итог("СуммаПлатежа");
		
		// Занесение информации в КУДиР, исходя из настроек вкладки "ЖКХ" Учетной политики ЖКХ.
		НастройкиУчетнойПолитикиЖКХ = УПЖКХ_ОбщегоНазначенияСервер.ПолучитьПараметрыУчетнойПолитикиЖКХ(Объект.Дата, Объект.Организация);
		
		ПараметрыУСН = УчетУСН.СтруктураПараметровОбъектаДляУСН(ОбъектПКО);
		
		НалоговыйУчетУСН.ЗаполнитьОтражениеДокументаВУСН(ОбъектПКО, ПараметрыУСН);
		ОбъектПКО.Содержание_УСН = НалоговыйУчетУСН.СодержаниеОперацииДляКУДиР(ПараметрыУСН);
		
		Если НастройкиУчетнойПолитикиЖКХ.ОбнулятьДоходыВзносыПринимаемые Тогда
			ОбъектПКО.Графа5_УСН = 0;
		КонецЕсли;
		
		Попытка
			ОбъектПКО.Записать(РежимЗаписиДокумента.Проведение);
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("Сформирован документ " + ОбъектПКО);
			// Внесение данных о ПКО в таблицу Членов ТСЖ
			СтрокиКонтрагента = Объект.ЧленыТСЖ.НайтиСтроки(Новый Структура("Контрагент", ТекСтрока.Контрагент));
			Для каждого ТекСтрокаТСЖ из СтрокиКонтрагента Цикл
				Если НЕ ЗначениеЗаполнено(ТекСтрокаТСЖ.ПКО) Тогда
					ТекСтрокаТСЖ.ПКО = ОбъектПКО.Ссылка;
					Модифицированность = Истина;
				КонецЕсли;
			КонецЦикла;
		Исключение
			ТекстСообщения = ОписаниеОшибки();
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке(ТекстСообщения, , , , Ложь);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 
