#Область СубконтоВФорме
// Конструктор описания субконто, связанных со счетом затрат в конкретной форме документа.
// Используется в качестве параметра других процедур, функций этого модуля и СчетаУчетаВДокументахКлиент
// Параметры:
//  ИмяСчета - Строка - Имя реквизита, в котором хранится счет учета
// Возвращаемое значение:
//  Структура 
Функция НовыйОписаниеСубконтоЗатрат(ИмяСчета) Экспорт
	
	Описание = Новый Структура;
	Описание.Вставить("ИмяСчета", ИмяСчета);
	Описание.Вставить("ИмяПоляСубконто");
	Описание.Вставить("ИмяЗаголовкаСубконто");
	Описание.Вставить("ИмяПоляПодразделение");
	Описание.Вставить("ИмяЗаголовкаПодразделение");
	
	Возврат Описание;
	
КонецФункции

// Настраивает на форме свойства элементов, связанные с субконто счета затрат.
//
// Параметры:
//  Форма			 - УправляемаяФорма - форма, которую требуется настроить
//  ОписаниеСубконто - см. НовыйОписаниеСубконтоЗатрат()
Процедура НастроитьСубконтоЗатрат(Форма, ОписаниеСубконто) Экспорт
	
	Если Не СчетаУчетаВДокументахВызовСервераПовтИсп.ПользовательУправляетСчетамиУчета() Тогда
		Возврат;
	КонецЕсли;
	
	ПоляФормы      = Новый Структура;
	ЗаголовкиПолей = Новый Структура;
	
	Для НомерСубконто = 1 По 3 Цикл
		
		ПоляФормы.Вставить("Субконто" + НомерСубконто,      ОписаниеСубконто.ИмяПоляСубконто + НомерСубконто);
		
		
		ЗаголовкиПолей.Вставить("Субконто" + НомерСубконто, ОписаниеСубконто.ИмяЗаголовкаСубконто + НомерСубконто);
		
	КонецЦикла;
	
	Если ОписаниеСубконто.ИмяПоляПодразделение <> Неопределено Тогда
		ПоляФормы.Вставить("Подразделение",  ОписаниеСубконто.ИмяПоляПодразделение);
	КонецЕсли;
	
	Если ОписаниеСубконто.ИмяЗаголовкаПодразделение <> Неопределено Тогда
		ЗаголовкиПолей.Вставить("Подразделение", ОписаниеСубконто.ИмяЗаголовкаПодразделение);
	КонецЕсли;
	
	БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(Форма.Объект[ОписаниеСубконто.ИмяСчета], Форма, ПоляФормы, ЗаголовкиПолей);
	
	НастроитьПараметрыВыбораСубконтоЗатрат(Форма, ОписаниеСубконто.ИмяСчета, ОписаниеСубконто.ИмяПоляСубконто);
	
КонецПроцедуры

// Настраивает параметры выбора для полей формы, связанных с субконто затрат
//
// Параметры:
//  Форма			 - УправляемаяФорма - форма, которую требуется настроить
//  ИмяСчета		 - Строка - Имя реквизита, в котором хранится счет
//  ИмяПоляСубконто	 - Строка - Имя поля, которое нужно настроить
Процедура НастроитьПараметрыВыбораСубконтоЗатрат(Форма, ИмяСчета, ИмяПоляСубконто) Экспорт
	
	Если Не СчетаУчетаВДокументахВызовСервераПовтИсп.ПользовательУправляетСчетамиУчета() Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонПоляСубконто = ИмяПоляСубконто + "%Индекс%";
	
	ПараметрыВыбораСубконто = ПараметрыВыбораСубконтоЗатрат(Форма, ШаблонПоляСубконто, ИмяСчета);
	
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(
		Форма, 
		Форма.Объект, 
		ШаблонПоляСубконто, 
		ШаблонПоляСубконто, 
		ПараметрыВыбораСубконто);

КонецПроцедуры

// Описывает параметры выбора субконто для счетов затрат затрат
//
// Параметры:
//  Форма				 - УправляемаяФорма - форма, отображающая объект, данные которого учитываются в параметрах выбора
//  ШаблонИмяПоляОбъекта - Строка - Шаблон имени поля для субконто, в котором для номера субконто указывается "%Индекс%"
//  ИмяСчета			 - Строка - Имя реквизита объекта, значение которого - счет учета затрат
// Возвращаемое значение:
//  Структура - описывает параметры выбора в формате, приемлемом для БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто()
Функция ПараметрыВыбораСубконтоЗатрат(Форма, ШаблонИмяПоляОбъекта, ИмяСчета) Экспорт

	ПараметрыВыбора = Новый Структура;
	
	Объект = Форма.Объект;
	
	Для Индекс = 1 По 3 Цикл
		
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(Объект[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			ПараметрыВыбора.Вставить("Контрагент", Объект[ИмяПоля]);
		ИначеЕсли ТипЗнч(Объект[ИмяПоля]) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			ПараметрыВыбора.Вставить("ДоговорКонтрагента", Объект[ИмяПоля]);
		ИначеЕсли ТипЗнч(Объект[ИмяПоля]) = Тип("СправочникСсылка.Номенклатура") Тогда
			ПараметрыВыбора.Вставить("Номенклатура", Объект[ИмяПоля]);
		ИначеЕсли ТипЗнч(Объект[ИмяПоля]) = Тип("СправочникСсылка.Склады") Тогда
			ПараметрыВыбора.Вставить("Склад", Объект[ИмяПоля]);
		КонецЕсли;
		
	КонецЦикла;
	
	ПараметрыВыбора.Вставить("Организация", Объект.Организация);
	ПараметрыВыбора.Вставить("СчетУчета"  , Объект[ИмяСчета]);
	
	Возврат ПараметрыВыбора;

КонецФункции

#КонецОбласти

#Область ЗаполнениеВФорме

// Конструктор коллекции, которая описывает параметры (особенности) заполнения счетов учета при интерактивных изменениях в форме.
//
// Параметры:
//  ИмяДокумента			 - Строка - Имя документа
//  ПричиныИзменения		 - Массив, Строка - полные имена реквизитов, которые изменены пользователем
//  Объект					 - ДанныеФормыСтруктура - данные формы, отображающие документа
//  СтрокаСписка			 - ДанныеФормыЭлементКоллекции - данные формы, отображающие строку табличной части
//  КонтейнерОбъект			 - Структура - контейнер для передачи данных шапки объекта на сервер в ходе неконтекстного вызова
//  КонтейнерСтрокаСписка	 - Структура - контейнер для передачи данных строки табличной части на сервер в ходе неконтекстного вызова
// Возвращаемое значение:
//  Структура 
Функция НовыйПараметрыЗаполнения(ИмяДокумента, ПричиныИзменения, Объект, СтрокаСписка, КонтейнерОбъект, КонтейнерСтрокаСписка) Экспорт
	
	ПараметрыЗаполнения = Новый Структура;
	
	ПараметрыЗаполнения.Вставить("ИмяДокумента",     ИмяДокумента);
	ПараметрыЗаполнения.Вставить("ПричиныИзменения");
	ПараметрыЗаполнения.Вставить("КЗаполнению",      Новый Соответствие);
	
	ПараметрыЗаполнения.Вставить("Заполнять",        СчетаУчетаВДокументахВызовСервераПовтИсп.ПользовательУправляетСчетамиУчета());
	
	ПараметрыЗаполнения.Вставить("ДанныеФормы",      Новый Структура); // Данные, доступные на клиенте
	ПараметрыЗаполнения.ДанныеФормы.Вставить("Объект", Объект);
	ПараметрыЗаполнения.ДанныеФормы.Вставить("Строка", СтрокаСписка);
	
	ПараметрыЗаполнения.Вставить("НакапливатьИзмененияВФорме", Ложь);
	
	#Если Клиент Тогда
	// Контейнер служит для передачи на сервер нужных данных объекта
	Если ПараметрыЗаполнения.Заполнять Тогда
		
		ПараметрыЗаполнения.Вставить("Контейнер", Новый Структура);
		ПараметрыЗаполнения.Контейнер.Вставить("Объект");
		ПараметрыЗаполнения.Контейнер.Вставить("Строка");
		
	КонецЕсли;
	#КонецЕсли
	
	// Все элементы структуры добавлены; далее они заполняются.
	
	Если ТипЗнч(ПричиныИзменения) = Тип("Массив") Тогда
		ПараметрыЗаполнения.ПричиныИзменения = ПричиныИзменения;
	ИначеЕсли ТипЗнч(ПричиныИзменения) = Тип("Строка") Тогда
		ПараметрыЗаполнения.ПричиныИзменения = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПричиныИзменения, ",", Истина, Истина);
	Иначе
		ПараметрыЗаполнения.ПричиныИзменения = Новый Массив;
	КонецЕсли;
	
	Если ПараметрыЗаполнения.Свойство("Контейнер") Тогда
	
		Если КонтейнерОбъект = Неопределено Тогда
			ПараметрыЗаполнения.Контейнер.Объект = Новый Структура;
		Иначе
			ПараметрыЗаполнения.Контейнер.Объект = КонтейнерОбъект;
		КонецЕсли;
	
		Если КонтейнерСтрокаСписка = Неопределено Тогда
			ПараметрыЗаполнения.Контейнер.Строка = Новый Структура;
		Иначе
			ПараметрыЗаполнения.Контейнер.Строка = КонтейнерСтрокаСписка;
		КонецЕсли;
		
	КонецЕсли;

	Возврат ПараметрыЗаполнения;
	
КонецФункции

// Выполняет на клиенте часть или все действия, необходимые для заполнения счета
// - если счета отображаются в документах - дополняет параметры заполнения, указывает, что реквизит нужно заполнить
// - если счета не отображаются в документах - очищает реквизит, в котором хранится счет, с тем, чтобы он был заполнен перед записью
//
// Параметры:
//  ПараметрыЗаполнения	 - См. НовыйПараметрыЗаполнения()
//  ПолноеИмяРеквизита	 - Строка - полное имя заполняемого реквизита
Процедура НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, ПолноеИмяРеквизита) Экспорт
	
	ИмяРеквизитаДетально = ОбщегоНазначенияБПКлиентСервер.РазложитьПолноеИмяРеквизита(ПолноеИмяРеквизита);
	
	// Убедимся, что этот реквизит присутствует в форме
	Если ПустаяСтрока(ИмяРеквизитаДетально.ТабличнаяЧасть) Тогда
		Если Не ПараметрыЗаполнения.ДанныеФормы.Объект.Свойство(ИмяРеквизитаДетально.Реквизит) Тогда
			Возврат;
		КонецЕсли;
	ИначеЕсли ПараметрыЗаполнения.ДанныеФормы.Строка = Неопределено Тогда
		Если Не ПараметрыЗаполнения.ДанныеФормы.Объект.Свойство(ИмяРеквизитаДетально.ТабличнаяЧасть) Тогда
			Возврат;
		Иначе
			ТабличнаяЧасть = ПараметрыЗаполнения.ДанныеФормы.Объект[ИмяРеквизитаДетально.ТабличнаяЧасть];
			Если ТабличнаяЧасть.Количество() = 0 Тогда
				Возврат;
			ИначеЕсли Не ТабличнаяЧасть[0].Свойство(ИмяРеквизитаДетально.Реквизит) Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если Не ПараметрыЗаполнения.ДанныеФормы.Строка.Свойство(ИмяРеквизитаДетально.Реквизит) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ПараметрыЗаполнения.Заполнять Тогда
		// Сообщим, что нужно его заполнить
		ПараметрыЗаполнения.КЗаполнению.Вставить(ПолноеИмяРеквизита, Истина);
	Иначе
		// Очистим
		Если ПустаяСтрока(ИмяРеквизитаДетально.ТабличнаяЧасть) Тогда
			ОчиститьЗначениеРеквизита(ПараметрыЗаполнения.ДанныеФормы.Объект, ИмяРеквизитаДетально.Реквизит);
		ИначеЕсли ПараметрыЗаполнения.ДанныеФормы.Строка = Неопределено Тогда
			Для Каждого Строка Из ПараметрыЗаполнения.ДанныеФормы.Объект[ИмяРеквизитаДетально.ТабличнаяЧасть] Цикл
				ОчиститьЗначениеРеквизита(Строка, ИмяРеквизитаДетально.Реквизит);
			КонецЦикла;
		Иначе
			ОчиститьЗначениеРеквизита(ПараметрыЗаполнения.ДанныеФормы.Строка, ИмяРеквизитаДетально.Реквизит);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

Процедура ОчиститьЗначениеРеквизита(Элемент, ИмяРеквизита)
	
	Если ЗначениеЗаполнено(Элемент[ИмяРеквизита]) Тогда
		Элемент[ИмяРеквизита] = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// Выполняет на клиенте часть действий, необходимых для заполнения счета, если счета отображаются в документах.
// А именно, готовит для передачи на сервер данные, необходимые для заполнения - 
// помещает их в соответствующие свойства коллекции ПараметрыЗаполнения.
//
// Параметры:
//  ПараметрыЗаполнения	 - См. НовыйПараметрыЗаполнения()
//  ЭлементДанных		 - Строка - "Строка", если речь идет о строке табличной части, "Объект" - если о шапке
//  ИмяРеквизита		 - Строка - имя реквизита, данные из которого нужны для заполнения
Процедура ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, ЭлементДанных, ИмяРеквизита) Экспорт
	
	Если ПараметрыЗаполнения.ДанныеФормы[ЭлементДанных] = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПараметрыЗаполнения.ДанныеФормы[ЭлементДанных].Свойство(ИмяРеквизита) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаполнения.Контейнер[ЭлементДанных].Вставить(ИмяРеквизита, ПараметрыЗаполнения.ДанныеФормы[ЭлементДанных][ИмяРеквизита]);
	
КонецПроцедуры

// Используется для того, чтобы определить целесообразно ли сейчас заполнять счета
// или это действие можно отложить к концу стека вызовов.
//
// Параметры:
//  ПричинаИзменения - Строка - Полное имя реквизита, который изменен пользователем и может повлечь изменение счетов учета
//  ПричиныИзменения - Массив - содержит строки, полные имена реквизитов, которые изменены в рамках стека вызовов.
//                     Например, если пользователь изменил значение Организации и при обработке этого изменения был изменен ДоговорКонтрагента,
//                     то массив должен содержать строки "Организация", "ДоговорКонтрагента"
// Возвращаемое значение:
//  Булево - Истина, если функция вызвана для первой из причин изменения в стеке вызовов. Или, другими словами - в конце стека вызовов.
Функция МожноНачатьЗаполнениеСчетовУчета(ПричинаИзменения, ПричиныИзменения) Экспорт
	
	ИндексПричины = ПричиныИзменения.Найти(ПричинаИзменения);
	
	Если ИндексПричины = Неопределено Тогда
		ПричиныИзменения.Добавить(ПричинаИзменения);
		Возврат Истина;
	ИначеЕсли ИндексПричины > 0 Тогда
		// Изменение реквизита <ИмяРеквизита> - не первое в цепочке изменений.
		// Поэтому заполнять здесь ничего не будем: заполним, когда обойдем всю цепочку и вернемся по стеку к ее началу.
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Определяет перечень табличных частей, реквизиты которых содержатся в списке к заполнению.
//
// Параметры:
//  КЗаполнению	 - Соответствие - перечень полных имен реквизитов (содержит имя табличной части)
// Возвращаемое значение:
// Массив - имена табличных частей из КЗаполнению
Функция ТабличныеЧастиКЗаполнению(КЗаполнению) Экспорт
	
	ТабличныеЧасти = Новый Структура;
	Для Каждого ПолноеИмяРеквизита Из КЗаполнению Цикл
		ИмяРеквизитаДетально = ОбщегоНазначенияБПКлиентСервер.РазложитьПолноеИмяРеквизита(ПолноеИмяРеквизита.Ключ);
		Если Не ПустаяСтрока(ИмяРеквизитаДетально.ТабличнаяЧасть) Тогда
			ТабличныеЧасти.Вставить(ИмяРеквизитаДетально.ТабличнаяЧасть);
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Массив;
	Для Каждого КлючИЗначение Из ТабличныеЧасти Цикл
		Результат.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

#КонецОбласти
