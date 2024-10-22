&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	УникальныйИдентификаторРодителя = Параметры.УникальныйИдентификаторРодителя;
	
	ИнициализироватьТаблицу(Параметры.Сканы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПередЗакрытием_Завершение", 
		ЭтотОбъект);
	
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
		ОписаниеОповещения, 
		Отказ, 
		ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаВложенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ТаблицаВложений.ТекущиеДанные <> Неопределено Тогда 
		
		Если Поле.Имя = "ТаблицаВложенийПредставление" Тогда 
			
			СтандартнаяОбработка = Ложь;
			ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(
				Элементы.ТаблицаВложений.ТекущиеДанные.Значение.АдресДанных, 
				Элементы.ТаблицаВложений.ТекущиеДанные.Значение.Имя);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
		
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ТаблицаВложенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда = Неопределено)
	
	Если НЕ ПроверкаПройдена() Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	// Обратное преобразование таблицы в список значений
	Результат = Новый СписокЗначений;
	Для каждого СтрокаТаблицы Из ТаблицаВложений Цикл
		Результат.Добавить(СтрокаТаблицы.Значение, СтрокаТаблицы.Представление, СтрокаТаблицы.Пометка);
	КонецЦикла; 
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Функция ПроверкаПройдена()
	
	// Количество сканов, отмеченных флажками
	
	КоличествоВложений = 0;
	Для каждого Скан Из ТаблицаВложений Цикл
		Если Скан.Пометка Тогда
			КоличествоВложений = КоличествоВложений + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если КоличествоВложений = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для сохранения добавьте хотя бы один скан'"));
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВыбратьВсех(Команда)
	
	Для каждого СтрокаВложений Из ТаблицаВложений Цикл
		СтрокаВложений.Пометка = Истина;
	КонецЦикла;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВсех(Команда)
	
	Для каждого СтрокаВложений Из ТаблицаВложений Цикл
		СтрокаВложений.Пометка = Ложь;
	КонецЦикла;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСДиска(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыбратьИДобавитьВложения_Завершение", 
		ЭтотОбъект);
	
	КонтекстЭДОКлиент.ЗагрузитьСканСДискаВОтчетНаТребование(ОписаниеОповещения, УникальныйИдентификаторРодителя);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьТаблицу(Сканы)
	
	Если Сканы <> Неопределено Тогда
		Для каждого Скан Из Сканы Цикл
			
			Значение = Скан.Значение;
			ДобавитьСтрокуТаблицы(
				Значение.Имя, 
				Значение.Размер, 
				Значение.АдресДанных, 
				Скан.Пометка);
				
		КонецЦикла; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИДобавитьВложения_Завершение(РезультатВыбораФайлов, ВходящийКонтекст) Экспорт
	
	ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами = РезультатВыбораФайлов.ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами;
	ДополнительныеПараметрыВыбораФайлов = РезультатВыбораФайлов.ДополнительныеПараметры;
	
	Если ПоддерживаетсяИспользованиеРасширенияРаботыСФайлами Тогда
		
		ДобавитьВложенияПослеВыбораФайлов(
			ДополнительныеПараметрыВыбораФайлов.МассивПолныхИменВыбранныхФайлов, 
			Неопределено);
			
	Иначе
		
		ДобавитьВложенияБезРасширенияРаботыСФайлами(
			ДополнительныеПараметрыВыбораФайлов.ФайлыБылиВыбраны, 
			ДополнительныеПараметрыВыбораФайлов.АдресДанных, 
			ДополнительныеПараметрыВыбораФайлов.ВыбранноеИмяФайла, 
			Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВложенияПослеВыбораФайлов(МассивПолныхИменВыбранныхФайлов, ДополнительныеПараметры) Экспорт
	
	Если МассивПолныхИменВыбранныхФайлов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьВложенияПослеПолученияСвойствФайлов", ЭтотОбъект);
	КонтекстЭДОКлиент.ПолучитьСвойстваФайлов(ОписаниеОповещения, МассивПолныхИменВыбранныхФайлов);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ДобавитьВложенияПослеПолученияСвойствФайлов(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат.Выполнено Тогда
		Возврат;	
	КонецЕсли;
	
	ПомещаемыеФайлы = Новый Массив;
	Для Каждого СвойстваФайла Из Результат.СвойстваФайлов Цикл 
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(СвойстваФайла.ПолноеИмя); 
		ПомещаемыеФайлы.Добавить(ОписаниеФайла);
	КонецЦикла;
	
	ДополнительныеПараметры = Новый Структура("МассивФайлов", Результат.СвойстваФайлов);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьВложенияПослеПомещенияФайлов", ЭтотОбъект, ДополнительныеПараметры); 
	НачатьПомещениеФайлов(ОписаниеОповещения, ПомещаемыеФайлы, , Ложь, УникальныйИдентификаторРодителя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВложенияПослеПомещенияФайлов(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	МассивФайлов = ДополнительныеПараметры.МассивФайлов;
	
	Для каждого СвойстваФайла Из МассивФайлов Цикл
		Для каждого ОписаниеПереданногоФайла Из ПомещенныеФайлы Цикл
			Если ОписаниеПереданногоФайла.Имя = СвойстваФайла.ПолноеИмя Тогда
				
				ДобавитьВТаблицуСЗаменой(СвойстваФайла.Имя, СвойстваФайла.Размер, ОписаниеПереданногоФайла.Хранение);
				
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла; 
		
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВложенияБезРасширенияРаботыСФайлами(ФайлыБылиВыбраны, АдресДанных, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если ФайлыБылиВыбраны Тогда
		
		// составляем массив с объектами Файл
		МассивФайлов = Новый Массив;

		Файл = КонтекстЭДОКлиент.СвойстваФайла(АдресДанных, ВыбранноеИмяФайла);
		
		ДобавитьВТаблицуСЗаменой(Файл.Имя, Файл.Размер, АдресДанных);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВТаблицуСЗаменой(Имя, Размер, АдресДанных) Экспорт
	
	ЕстьТакоеВложение = Ложь;
	Для каждого Вложение Из ТаблицаВложений Цикл
		Если Вложение.Значение.Имя = Имя И Вложение.Значение.Размер = Размер Тогда 
			ЕстьТакоеВложение = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЕстьТакоеВложение Тогда
		ДобавитьСтрокуТаблицы(Имя, Размер, АдресДанных);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуТаблицы(Имя, Размер, АдресДанных, Пометка = Истина)
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя",         Имя);
	Свойства.Вставить("Размер",      Размер);
	Свойства.Вставить("АдресДанных", АдресДанных);

	НоваяСтрока = ТаблицаВложений.Добавить();
	НоваяСтрока.Значение      = Свойства;
	НоваяСтрока.Представление = Свойства.Имя;
	НоваяСтрока.Пометка       = Пометка;
	НоваяСтрока.Размер        = ПредставлениеРазмераФайла(Свойства.Размер, 2);
	
КонецПроцедуры

Функция ПредставлениеРазмераФайла(РазмерВБайтах, Разрядность = 0) Экспорт
	
	Размер = 0;
	РазмерВКилобайтах = Окр(РазмерВБайтах / 1024, Разрядность);
	Если РазмерВБайтах = 0 Тогда
		Шаблон = НСтр("ru = '%1 Б'");
	ИначеЕсли РазмерВКилобайтах < 1000 Тогда
		Размер =  Окр(РазмерВКилобайтах, 0);
		Шаблон = НСтр("ru = '%1 КБ'");
	Иначе
		Размер = Окр(РазмерВКилобайтах / 1024, Разрядность);
		Шаблон = НСтр("ru = '%1 МБ'");
	КонецЕсли;
	
	Возврат СтрШаблон(Шаблон, Размер);
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Сохранить();
	
КонецПроцедуры

#КонецОбласти