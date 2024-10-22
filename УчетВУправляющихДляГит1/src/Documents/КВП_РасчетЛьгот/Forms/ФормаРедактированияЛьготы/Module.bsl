
#Область ОбщиеПроцедурыИФункции

&НаСервере
// Функция помещения данных расшифровки в хранилище.
Функция ПоместитьТаблицуРасшифровкиВХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаЛьгот.Выгрузить(), Новый УникальныйИдентификатор);
	
КонецФункции

&НаСервере
// Процедура устанавливает точность для поля ввода "Количество" табличного поля "ОбъектыУчета"
// в соответствии с выбранной пользователем точностью в настройках программы.
Процедура УстановитьТочностьОбъемовНачислений()
	Элементы.ТаблицаЛьготКоличество.Формат = "ЧДЦ=" + Строка(Константы.УПЖКХ_ТочностьОбъемаНачислений.Получить()) + "";
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АдресХранилищаРасшифровкиСтроки") Тогда
		ТаблицаЛьгот.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресХранилищаРасшифровкиСтроки));
		ИтогоКоличество = ТаблицаЛьгот.Итог("Количество");
		ИтогоНачислено  = ТаблицаЛьгот.Итог("Начислено");
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	УстановитьТочностьОбъемовНачислений();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Обработчик события "ПриОкончанииРедактирования" поля "ТаблицаЛьгот".
Процедура ТаблицаЛьготПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ИтогоКоличество = ТаблицаЛьгот.Итог("Количество");
	ИтогоНачислено  = ТаблицаЛьгот.Итог("Начислено");
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "ПослеУдаления" поля "ТаблицаЛьгот".
Процедура ТаблицаЛьготПослеУдаления(Элемент)
	
	ИтогоКоличество = ТаблицаЛьгот.Итог("Количество");
	ИтогоНачислено  = ТаблицаЛьгот.Итог("Начислено");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Обработчик команды "КомандаОК".
Процедура КомандаОК(Команда)
	
	АдресХранилищаРасшифровкиСтроки = ПоместитьТаблицуРасшифровкиВХранилище();
	
	Если Не АдресХранилищаРасшифровкиСтроки = Неопределено Тогда
		Закрыть(АдресХранилищаРасшифровкиСтроки);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти