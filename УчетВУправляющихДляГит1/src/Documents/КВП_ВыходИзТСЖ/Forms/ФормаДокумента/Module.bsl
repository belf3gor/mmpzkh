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

&НаКлиенте
// Обработчик события "ПриИзменении" поля "Организация".
Процедура ОрганизацияПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "Нажатие" ссылки "СсылкаПроверкаСоставаПравленияНажатие".
Процедура СсылкаПроверкаСоставаПравленияНажатие(Элемент)
	
	ФормаСписка = ПолучитьФорму("Документ.УПЖКХ_СоставПравленияТСЖИРевизионнойКомиссии.ФормаСписка", , ЭтотОбъект);
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьЭлементОтбора(ФормаСписка.Список.КомпоновщикНастроек.Настройки.Отбор, "Организация", Объект.Организация,
															ВидСравненияКомпоновкиДанных.Равно, , Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	
	ФормаСписка.Открыть();
	
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
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбработатьРезультатВопросаКомандаЗаполнить",
					   ЭтотОбъект),
					   "Перед заполнением табличная часть будет очищена. Продолжить?",
					   РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	КомандаЗаполнитьПродожение();
	
КонецПроцедуры // КомандаЗаполнить()

&НаКлиенте
// Процедура-обработчик результата вопроса, вызваного в процедуре-обработчике команды "КомандаЗаполнить()".
Процедура ОбработатьРезультатВопросаКомандаЗаполнить(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	КомандаЗаполнитьПродожение();

КонецПроцедуры // ОбработатьРезультатВопросаКомандаЗаполнить()

&НаКлиенте
// Процедура-продолжение процедуры-обработчика команды "КомандаЗаполнить()".
Процедура КомандаЗаполнитьПродожение()
	
	ЗаполнитьТабличнуюЧастьНаСервере();
	ОбновитьОтображениеДанных();

КонецПроцедуры // КомандаЗаполнитьПродожение()

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
	
	УстановитьВидимостьСсылкиПроверкиСоставаПравления(Элементы.СсылкаПроверкаСоставаПравления, Объект.Дата, Объект.Организация);
	
КонецПроцедуры // УстановитьВидимостьЭлементов()

&НаКлиентеНаСервереБезКонтекста
// Устанавливает видимость ссылки, по нажатию на которую открывается список соответствующих документов
// "Состав правления ТСЖ и ревизионной комиссии".
Процедура УстановитьВидимостьСсылкиПроверкиСоставаПравления(СсылкаПроверкаСоставаПравления, Дата, Организация)
	
	СсылкаПроверкаСоставаПравления.Видимость = ОпределитьЕстьЛиДокументыСоставаПравления(Дата, Организация);
	
КонецПроцедуры

&НаСервере
// Заполняет ТЧ
Процедура ЗаполнитьТабличнуюЧастьНаСервере()

	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьТабличнуюЧасть();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры // ЗаполнитьТабличнуюЧасть()

&НаСервереБезКонтекста
// Определяет: есть ли по текущим организации и зданию документы
Функция ОпределитьЕстьЛиДокументыСоставаПравления(Дата, Организация)
	
	Если Организация.Пустая() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УПЖКХ_СоставПравленияТСЖИРевизионнойКомиссииСрезПоследних.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрСведений.УПЖКХ_СоставПравленияТСЖИРевизионнойКомиссии.СрезПоследних(
	|			&Дата,
	|			Организация = &Организация) КАК УПЖКХ_СоставПравленияТСЖИРевизионнойКомиссииСрезПоследних";
	Запрос.УстановитьПараметр("Дата",        Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

#КонецОбласти 
