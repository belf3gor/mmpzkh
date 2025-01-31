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

#Область ПроцедурыИФункцииПечати

// Если член ТСЖ перестал быть собственником, надо предложить пользователю оформить выход из ТСЖ и из состава
// правления/ревизионной комиссии. Ищем список таких членов ТСЖ.
Функция ОпределитьНеобходимоЛиПредложитьВыходИзТСЖ(Дата, Здание, СписокСобственников) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КВП_ЧленыТСЖСрезПоследних.ЧленТСЖ КАК ЧленТСЖ,
	|	КВП_ЧленыТСЖСрезПоследних.Организация КАК Организация,
	|	ИСТИНА КАК ЯвляетсяЧленомТСЖ
	|ПОМЕСТИТЬ ЧленыТСЖ
	|ИЗ
	|	РегистрСведений.КВП_ЧленыТСЖ.СрезПоследних(&Дата, ЧленТСЖ В (&ЧленыТСЖ)) КАК КВП_ЧленыТСЖСрезПоследних
	|ГДЕ
	|	КВП_ЧленыТСЖСрезПоследних.Участие
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УПЖКХ_СоставПравленияТСЖИРевизионнойКомиссииСрезПоследних.ЧленТСЖ КАК ЧленТСЖ,
	|	УПЖКХ_СоставПравленияТСЖИРевизионнойКомиссииСрезПоследних.Организация КАК Организация,
	|	ИСТИНА КАК ЯвляетсяЧленомПравления
	|ПОМЕСТИТЬ ЧленыПравления
	|ИЗ
	|	РегистрСведений.УПЖКХ_СоставПравленияТСЖИРевизионнойКомиссии.СрезПоследних(&Дата, ЧленТСЖ В (&ЧленыТСЖ)) КАК УПЖКХ_СоставПравленияТСЖИРевизионнойКомиссииСрезПоследних
	|ГДЕ
	|	УПЖКХ_СоставПравленияТСЖИРевизионнойКомиссииСрезПоследних.ВходитВСостав
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ЧленыТСЖ.ЧленТСЖ, ЧленыПравления.ЧленТСЖ) КАК ЧленТСЖ,
	|	ЕСТЬNULL(ЧленыТСЖ.Организация, ЧленыПравления.Организация) КАК Организация,
	|	ЕСТЬNULL(ЧленыТСЖ.ЯвляетсяЧленомТСЖ, ЛОЖЬ) КАК ЯвляетсяЧленомТСЖ,
	|	ЕСТЬNULL(ЧленыПравления.ЯвляетсяЧленомПравления, ЛОЖЬ) КАК ЯвляетсяЧленомПравления
	|ИЗ
	|	ЧленыТСЖ КАК ЧленыТСЖ
	|		ПОЛНОЕ СОЕДИНЕНИЕ ЧленыПравления КАК ЧленыПравления
	|		ПО ЧленыТСЖ.ЧленТСЖ = ЧленыПравления.ЧленТСЖ
	|			И ЧленыТСЖ.Организация = ЧленыПравления.Организация";
	Запрос.УстановитьПараметр("Дата",     Дата);
	Запрос.УстановитьПараметр("ЧленыТСЖ", СписокСобственников);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли