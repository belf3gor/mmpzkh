#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

// Формирует массив членов ТСЖ указанного здания.
Функция ПолучитьМассивЧленовТСЖ(Дата, Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	КВП_ЧленыТСЖСрезПоследних.ЧленТСЖ
	|ИЗ
	|	РегистрСведений.КВП_ЧленыТСЖ.СрезПоследних(
	|			&Дата,
	|			Организация = &Организация) КАК КВП_ЧленыТСЖСрезПоследних";
	Запрос.УстановитьПараметр("Дата",        Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ЧленТСЖ");
	
КонецФункции

#КонецОбласти

#КонецЕсли