
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура открывает форму редактирования адреса.
Процедура ОткрытьФормуРедактированияАдресаНаСервере()
	
	ИмяОбработки = "КВП_РедактированиеКонтактнойИнформации";
	
	Если НЕ Метаданные.Обработки.Найти(ИмяОбработки) = Неопределено Тогда
	
		ОбработкаРедактирования = Обработки[ИмяОбработки].Создать();
		ОбработкаРедактирования.РедактироватьЗапись(Объект.Адрес, Истина, ЭтаФорма, , Объект, ПредопределенноеЗначение("Перечисление.КВП_ВидыАдресов.ОВД"));
		
		ЗаполнитьДанныеАдресов();
		
	КонецЕсли;
	
КонецПроцедуры // ОткрытьФормуРедактированияАдресаНаСервере()

&НаСервере
// Процедура заполняет поля адреса последними данными из регистра сведений.
Процедура ЗаполнитьДанныеАдресов()
	
	Если Не Объект.Ссылка.Пустая() Тогда
		
		МодульОбщегоНазначения                = "ОбщегоНазначения";
		МодульУправлениеКонтактнойИнформацией = "УправлениеКонтактнойИнформацией";
		МодульКВП_РегистрационныйУчет         = "КВП_РегистрационныйУчет";
		
		Если НЕ Метаданные.ОбщиеМодули.Найти(МодульОбщегоНазначения) = Неопределено
		   И НЕ Метаданные.ОбщиеМодули.Найти(МодульУправлениеКонтактнойИнформацией) = Неопределено
		   И НЕ Метаданные.ОбщиеМодули.Найти(МодульКВП_РегистрационныйУчет) = Неопределено Тогда
			
			СтруктАдрес = Новый Структура;
			
			Выполнить("СтруктАдрес = ПолучитьАдрес(Объект.Ссылка, ПредопределенноеЗначение(""Перечисление.КВП_ВидыАдресов.ОВД""), ОбщегоНазначения.ПолучитьРабочуюДату())");
			Выполнить("Объект.Адрес = УправлениеКонтактнойИнформацией.ПолучитьПредставлениеАдресаПоСтруктуре(СтруктАдрес)");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьДанныеАдресов()

&НаСервереБезКонтекста
// Проверяет существование общего модуля в метаданных.
//
Функция ОбщийМодульСуществует(Имя)
	
	Возврат (Метаданные.ОбщиеМодули.Найти(Имя) <> Неопределено);
	
КонецФункции // ОбщийМодульСуществует()

&НаКлиентеНаСервереБезКонтекста
// Получает общий модуль по его имени в метаданных.
// 
// Процедура необходима во избежание ошибок обращения к процедурам общего модуля в конфигурациях, отличных от ЖКХ 3.0.
//
Функция ПолучитьОбщийМодульИзМетаданныхПоИмени(Имя)
	
	ОбъектОбщегоМодуля = Неопределено;
	Если ОбщийМодульСуществует(Имя) Тогда
		#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
		УстановитьБезопасныйРежим(Истина);
		#КонецЕсли
		ПолученныйМодуль = Вычислить(Имя);
		Если ТипЗнч(ПолученныйМодуль) = Тип("ОбщийМодуль") Тогда
			ОбъектОбщегоМодуля = ПолученныйМодуль;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ОбъектОбщегоМодуля;
	
КонецФункции // ПолучитьОбщийМодульИзМетаданныхПоИмени()

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик события "ПриЧтенииНаСервере" формы.
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЭтоНовыйМеханизмКИ = (Метаданные.Обработки.Найти("КВП_РедактированиеКонтактнойИнформации") = Неопределено);
	
	Если ЭтоНовыйМеханизмКИ Тогда
		
		ОбъектОбщегоМодуля = ПолучитьОбщийМодульИзМетаданныхПоИмени("УПЖКХ_ТиповыеМетодыСервер");
		
		Если Не ОбъектОбщегоМодуля = Неопределено Тогда
			// СтандартныеПодсистемы.КонтактнаяИнформация
			ОбъектОбщегоМодуля.КонтактнаяИнформацияПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
			// Конец СтандартныеПодсистемы.КонтактнаяИнформация
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		ЭтоНовыйМеханизмКИ = (Метаданные.Обработки.Найти("КВП_РедактированиеКонтактнойИнформации") = Неопределено);
	КонецЕсли;
	
	Если ЭтоНовыйМеханизмКИ Тогда
		Элементы.ПанельКонтактнаяИнформация.ТекущаяСтраница = Элементы.СтраницаКонтактнаяИнформация;
	Иначе
		Элементы.ПанельКонтактнаяИнформация.ТекущаяСтраница = Элементы.СтраницаКонтакты;
	КонецЕсли;
	
	Если ЭтоНовыйМеханизмКИ Тогда
		
		ОбъектОбщегоМодуля = ПолучитьОбщийМодульИзМетаданныхПоИмени("УПЖКХ_ТиповыеМетодыСервер");
		
		Если Не ОбъектОбщегоМодуля = Неопределено Тогда
			// Обработчик подсистемы "Контактная информация"
			ПараметрыРазмещенияКонтактнойИнформации = ОбъектОбщегоМодуля.ПараметрыКонтактнойИнформации();
			ПараметрыРазмещенияКонтактнойИнформации.ИмяЭлементаДляРазмещения = "ГруппаКонтактнаяИнформация";
			
			ОбъектОбщегоМодуля.КонтактнаяИнформацияПриСозданииНаСервере(ЭтаФорма, Объект, ПараметрыРазмещенияКонтактнойИнформации);
		КонецЕсли;
		
	КонецЕсли;
	
	// ОбщиеМеханизмыИКоманды
	ОТР_ПодключаемыеОбщиеМеханизмыИКоманды.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ОбщиеМеханизмыИКоманды
	
КонецПроцедуры

&НаСервере
// Обработчик события "ПередЗаписьюНаСервере" формы.
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЭтоНовыйМеханизмКИ Тогда
		
		ОбъектОбщегоМодуля = ПолучитьОбщийМодульИзМетаданныхПоИмени("УПЖКХ_ТиповыеМетодыСервер");
		
		Если Не ОбъектОбщегоМодуля = Неопределено Тогда
			// Обработчик подсистемы "Контактная информация"
			ОбъектОбщегоМодуля.КонтактнаяИнформацияПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Обработчик проверки заполнения формы на сервере.
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоНовыйМеханизмКИ Тогда
		
		ОбъектОбщегоМодуля = ПолучитьОбщийМодульИзМетаданныхПоИмени("УПЖКХ_ТиповыеМетодыСервер");
		
		Если Не ОбъектОбщегоМодуля = Неопределено Тогда
			// СтандартныеПодсистемы.КонтактнаяИнформация
			ОбъектОбщегоМодуля.КонтактнаяИнформацияОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Объект, Отказ);
			// Конец СтандартныеПодсистемы.КонтактнаяИнформация
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

#Область ОбработчикиКомандФормы

&НаКлиенте
// Обработчик команды "ИзменитьАдрес".
Процедура ИзменитьАдрес(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбработатьОтветПередИзменениемАдреса", ЭтотОбъект),
					   "Перед изменением адресных данных необходимо записать элемент. Записать?",
					   РежимДиалогаВопрос.ДаНет,,,
					   "Сохранить изменения");
	Иначе
		ОткрытьФормуРедактированияАдресаНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения о необходимости записи элемента.
Процедура ОбработатьОтветПередИзменениемАдреса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	Записать();
	
	ОткрытьФормуРедактированияАдресаНаСервере();
	
КонецПроцедуры

// ЧастоЗадаваемыеВопросы
&НаКлиенте
// Подключаемый обработчик команды перехода к часто задаваемым вопросам.
Процедура Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда)
	
	ОТР_ЧастоЗадаваемыеВопросыКлиент.Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда);
	
КонецПроцедуры
// Конец ЧастоЗадаваемыеВопросы

#КонецОбласти

#Область ПроцедурыПодсистемыКонтактнаяИнформация

&НаКлиенте
// Обработчик события ПриИзменении поля формы контактной информации.
//
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
	ОбъектОбщегоМодуля = ПолучитьОбщийМодульИзМетаданныхПоИмени("УПЖКХ_ТиповыеМетодыКлиент");
	Если Не ОбъектОбщегоМодуля = Неопределено Тогда
		ОбъектОбщегоМодуля.КонтактнаяИнформацияПриИзменении(ЭтаФорма, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события НачалоВыбора поля формы контактной информации.
//
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	
	ОбъектОбщегоМодуля = ПолучитьОбщийМодульИзМетаданныхПоИмени("УПЖКХ_ТиповыеМетодыКлиент");
	Если Не ОбъектОбщегоМодуля = Неопределено Тогда
		ОбъектОбщегоМодуля.КонтактнаяИнформацияНачалоВыбора(ЭтаФорма, Элемент, , СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события Очистка поля формы контактной информации.
//
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
	ОбъектОбщегоМодуля = ПолучитьОбщийМодульИзМетаданныхПоИмени("УПЖКХ_ТиповыеМетодыКлиент");
	Если Не ОбъектОбщегоМодуля = Неопределено Тогда
		ОбъектОбщегоМодуля.КонтактнаяИнформацияОчистка(ЭтаФорма, Элемент.Имя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик команды, связанной с контактной информации (написать письмо, открыть адрес, и т.п.).
//
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
	ОбъектОбщегоМодуля = ПолучитьОбщийМодульИзМетаданныхПоИмени("УПЖКХ_ТиповыеМетодыКлиент");
	Если Не ОбъектОбщегоМодуля = Неопределено Тогда
		ОбъектОбщегоМодуля.КонтактнаяИнформацияВыполнитьКоманду(ЭтаФорма, Команда.Имя);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Процедура обновляет данные контактной информации.
//
Функция Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
	
	ОбъектОбщегоМодуля = ПолучитьОбщийМодульИзМетаданныхПоИмени("УПЖКХ_ТиповыеМетодыСервер");
	
	Если Не ОбъектОбщегоМодуля = Неопределено Тогда
		Возврат ОбъектОбщегоМодуля.КонтактнаяИнформацияОбновитьКонтактнуюИнформацию(ЭтаФорма, Объект, Результат);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции // ОбновитьКонтактнуюИнформацию()

#КонецОбласти