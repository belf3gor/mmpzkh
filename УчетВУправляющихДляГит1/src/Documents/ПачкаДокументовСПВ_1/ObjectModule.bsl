#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция СформироватьЗапросДляПроверкиЗаполнения()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ТаблицаЗаписиОСтаже", ЗаписиОСтаже);
	Запрос.УстановитьПараметр("ТаблицаСотрудники", Сотрудники);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаСотрудники.НомерСтроки,
	|	ТаблицаСотрудники.Сотрудник,
	|	ТаблицаСотрудники.Фамилия,
	|	ТаблицаСотрудники.Имя,
	|	ТаблицаСотрудники.Отчество,
	|	ТаблицаСотрудники.СтраховойНомерПФР,
	|	ТаблицаСотрудники.НачисленоСтраховая,
	|	ТаблицаСотрудники.УплаченоСтраховая,
	|	ТаблицаСотрудники.НачисленоНакопительная,
	|	ТаблицаСотрудники.УплаченоНакопительная
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	&ТаблицаСотрудники КАК ТаблицаСотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТСотрудники.Сотрудник,
	|	МИНИМУМ(ВТСотрудники.НомерСтроки) КАК НомерСтроки
	|ПОМЕСТИТЬ ВТСотрудникиНомераСтрок
	|ИЗ
	|	ВТСотрудники КАК ВТСотрудники
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТСотрудники.Сотрудник";
	
	Запрос.Выполнить();
	
	КадровыйУчет.СоздатьВТФизическиеЛицаРаботавшиеВОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, Организация, ОтчетныйПериод, ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СотрудникиДокумента.НомерСтроки,
	|	СотрудникиДокумента.Сотрудник КАК Сотрудник,
	|	СотрудникиДокумента.Фамилия,
	|	СотрудникиДокумента.Имя,
	|	СотрудникиДокумента.Отчество,
	|	СотрудникиДокумента.Сотрудник.Наименование КАК СотрудникНаименование,
	|	СотрудникиДокумента.СтраховойНомерПФР,
	|	МИНИМУМ(ДублиСтрок.НомерСтроки) КАК КонфликтующаяСтрока,
	|	ВЫБОР
	|		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СотрудникРаботаетВОрганизации,
	|	МИНИМУМ(ДублиСтрокСтраховыеНомера.НомерСтроки) КАК КонфликтующаяСтрокаСтраховойНомер,
	|	СотрудникиДокумента.НачисленоСтраховая,
	|	СотрудникиДокумента.УплаченоСтраховая,
	|	СотрудникиДокумента.НачисленоНакопительная,
	|	СотрудникиДокумента.УплаченоНакопительная,
	|	СотрудникиДокумента.Сотрудник.ДатаРождения КАК ДатаРождения
	|ПОМЕСТИТЬ ВТСотрудникиДокумента
	|ИЗ
	|	ВТСотрудники КАК СотрудникиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК ДублиСтрок
	|		ПО СотрудникиДокумента.НомерСтроки > ДублиСтрок.НомерСтроки
	|			И СотрудникиДокумента.Сотрудник = ДублиСтрок.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизическиеЛицаРаботавшиеВОрганизации КАК АктуальныеСотрудники
	|		ПО СотрудникиДокумента.Сотрудник = АктуальныеСотрудники.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК ДублиСтрокСтраховыеНомера
	|		ПО СотрудникиДокумента.НомерСтроки > ДублиСтрокСтраховыеНомера.НомерСтроки
	|			И СотрудникиДокумента.СтраховойНомерПФР = ДублиСтрокСтраховыеНомера.СтраховойНомерПФР
	|			И СотрудникиДокумента.Сотрудник <> ДублиСтрокСтраховыеНомера.Сотрудник
	|
	|СГРУППИРОВАТЬ ПО
	|	СотрудникиДокумента.НомерСтроки,
	|	СотрудникиДокумента.Сотрудник,
	|	СотрудникиДокумента.Фамилия,
	|	СотрудникиДокумента.Имя,
	|	СотрудникиДокумента.Отчество,
	|	СотрудникиДокумента.Сотрудник.Наименование,
	|	СотрудникиДокумента.СтраховойНомерПФР,
	|	ВЫБОР
	|		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	СотрудникиДокумента.НачисленоСтраховая,
	|	СотрудникиДокумента.УплаченоСтраховая,
	|	СотрудникиДокумента.НачисленоНакопительная,
	|	СотрудникиДокумента.УплаченоНакопительная,
	|	СотрудникиДокумента.Сотрудник.ДатаРождения
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗаписиОСтаже.Сотрудник,
	|	ТаблицаЗаписиОСтаже.НомерСтроки,
	|	ТаблицаЗаписиОСтаже.НомерОсновнойЗаписи,
	|	ТаблицаЗаписиОСтаже.НомерДополнительнойЗаписи,
	|	ТаблицаЗаписиОСтаже.ДатаНачалаПериода,
	|	ТаблицаЗаписиОСтаже.ДатаОкончанияПериода,
	|	ТаблицаЗаписиОСтаже.ТерриториальныеУсловия,
	|	ТаблицаЗаписиОСтаже.ПараметрТерриториальныхУсловий,
	|	ТаблицаЗаписиОСтаже.ОсобыеУсловияТруда,
	|	ТаблицаЗаписиОСтаже.КодПозицииСписка,
	|	ТаблицаЗаписиОСтаже.ОснованиеИсчисляемогоСтажа,
	|	ТаблицаЗаписиОСтаже.ПервыйПараметрИсчисляемогоСтажа,
	|	ТаблицаЗаписиОСтаже.ВторойПараметрИсчисляемогоСтажа,
	|	ТаблицаЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа,
	|	ТаблицаЗаписиОСтаже.ОснованиеВыслугиЛет,
	|	ТаблицаЗаписиОСтаже.ПервыйПараметрВыслугиЛет,
	|	ТаблицаЗаписиОСтаже.ВторойПараметрВыслугиЛет,
	|	ТаблицаЗаписиОСтаже.ТретийПараметрВыслугиЛет
	|ПОМЕСТИТЬ ВТТаблицаСтажа
	|ИЗ
	|	&ТаблицаЗаписиОСтаже КАК ТаблицаЗаписиОСтаже
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаписиОСтаже.Сотрудник,
	|	ЗаписиОСтаже.НомерСтроки,
	|	ЗаписиОСтаже.НомерОсновнойЗаписи,
	|	ЗаписиОСтаже.НомерДополнительнойЗаписи,
	|	ЗаписиОСтаже.ДатаНачалаПериода,
	|	ЗаписиОСтаже.ДатаОкончанияПериода,
	|	ЗаписиОСтаже.ТерриториальныеУсловия,
	|	ЗаписиОСтаже.ПараметрТерриториальныхУсловий,
	|	ЗаписиОСтаже.ОсобыеУсловияТруда,
	|	ЗаписиОСтаже.КодПозицииСписка,
	|	ЗаписиОСтаже.ОснованиеИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ПервыйПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ВторойПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ОснованиеВыслугиЛет,
	|	ЗаписиОСтаже.ПервыйПараметрВыслугиЛет,
	|	ЗаписиОСтаже.ВторойПараметрВыслугиЛет,
	|	ЗаписиОСтаже.ТретийПараметрВыслугиЛет,
	|	СотрудникиНомераСтрок.НомерСтроки КАК НомерСтрокиСотрудник
	|ПОМЕСТИТЬ ВТЗаписиОСтаже
	|ИЗ
	|	ВТТаблицаСтажа КАК ЗаписиОСтаже
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСотрудникиНомераСтрок КАК СотрудникиНомераСтрок
	|		ПО ЗаписиОСтаже.Сотрудник = СотрудникиНомераСтрок.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиДокумента.НомерСтроки КАК НомерСтрокиСотрудник,
	|	СотрудникиДокумента.Сотрудник КАК Сотрудник,
	|	СотрудникиДокумента.СотрудникНаименование,
	|	СотрудникиДокумента.СтраховойНомерПФР,
	|	СотрудникиДокумента.СотрудникРаботаетВОрганизации,
	|	СотрудникиДокумента.КонфликтующаяСтрока,
	|	СотрудникиДокумента.Фамилия,
	|	СотрудникиДокумента.Имя,
	|	СотрудникиДокумента.Отчество,
	|	СотрудникиДокумента.НачисленоСтраховая,
	|	СотрудникиДокумента.УплаченоСтраховая,
	|	СотрудникиДокумента.НачисленоНакопительная,
	|	СотрудникиДокумента.УплаченоНакопительная,
	|	СотрудникиДокумента.ДатаРождения КАК ДатаРождения,
	|	СотрудникиДокумента.КонфликтующаяСтрокаСтраховойНомер,
	|	"""" КАК АдресДляИнформирования
	|ИЗ
	|	ВТСотрудникиДокумента КАК СотрудникиДокумента
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтрокиСотрудник";
	
	Возврат Запрос;
	
КонецФункции

Процедура ПроверитьДанныеДокумента(Отказ = Ложь, НеПроверяемыеРеквизиты = Неопределено) Экспорт 
	Ошибки = Новый Массив;
	
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	ТекстОшибки = НСтр("ru = 'Форма СПВ-1 подается за периоды до 2014 г.'");

	Если ОтчетныйПериод >= '20140101' Тогда
		ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуЗаполненияЭлементаДокумента(Ошибки, Ссылка, ТекстОшибки, "ОтчетныйПериод", Отказ);
	КонецЕсли;

	ПерсонифицированныйУчет.ПроверитьДанныеОрганизации(ЭтотОбъект, Организация, Отказ);	
	
	ЗапросПоСтрокамДокумента = СформироватьЗапросДляПроверкиЗаполнения();
	ПерсонифицированныйУчет.ПроверитьЗаполнениеДанныхВзносахИСтаже(ЭтотОбъект, ЗапросПоСтрокамДокумента, Ошибки, Отказ, Истина, НеПроверяемыеРеквизиты);
	
	Если ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
		ПерсонифицированныйУчет.ПроверитьЗаписиОСтаже(ЗапросПоСтрокамДокумента.МенеджерВременныхТаблиц, Ссылка, ОтчетныйПериод, Отказ);		
	КонецЕсли;		
КонецПроцедуры

Функция ОкончаниеОтчетногоПериода() Экспорт
	
	Возврат ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод);
	
КонецФункции

#КонецОбласти

#КонецЕсли
