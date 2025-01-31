#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Выбирает данные, необходимые для проверки.
//
// Параметры: 
//  Нет
//
// Возвращаемое значение:
//  Результат запроса к данным работников документа.
//
Функция СформироватьЗапросПоСотрудникамДляПроверки()
	
	ТаблицаСотрудники = Сотрудники.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ТЧСотрудники", Сотрудники);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сотрудники.НомерСтроки,
	|	Сотрудники.Сотрудник КАК ФизическоеЛицо,
	|	Сотрудники.ДатаПолученияСвидетельства,
	|	Сотрудники.СтраховойНомерПФРВСвидетельстве,
	|	Сотрудники.ФамилияВСвидетельстве,
	|	Сотрудники.ИмяВСвидетельстве,
	|	Сотрудники.ОтчествоВСвидетельстве,
	|	Сотрудники.Фамилия,
	|	Сотрудники.Имя,
	|	Сотрудники.Отчество,
	|	Сотрудники.Пол,
	|	Сотрудники.ДатаРождения,
	|	Сотрудники.МестоРождения,
	|	Сотрудники.ПолВСвидетельстве,
	|	Сотрудники.ДатаРожденияВСвидетельстве,
	|	Сотрудники.МестоРожденияВСвидетельстве,
	|	Сотрудники.Гражданство,
	|	Сотрудники.ПризнакОтменыОтчества,
	|	Сотрудники.ПризнакОтменыМестаРождения,
	|	Сотрудники.АдресРегистрации,
	|	Сотрудники.АдресФактический,
	|	Сотрудники.СерияДокумента,
	|	Сотрудники.ВидДокумента,
	|	Сотрудники.НомерДокумента,
	|	Сотрудники.ДатаВыдачи,
	|	Сотрудники.КемВыдан,
	|	Сотрудники.ОтметкаОПредставленииСведений
	|ПОМЕСТИТЬ ВТФизЛицаДокумента
	|ИЗ
	|	&ТЧСотрудники КАК Сотрудники
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудники.Сотрудник";
	Запрос.Выполнить();
	
	КадровыйУчет.СоздатьВТФизическиеЛицаРаботавшиеВОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, Организация, Дата, Дата);
	
 	Запрос.Текст =
	"ВЫБРАТЬ
	|	ФизЛицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ФизЛицаДокумента.ФизическоеЛицо КАК Сотрудник,
	|	ФизЛицаДокумента.ФизическоеЛицо.ФИО КАК СотрудникНаименование,
	|	ФизЛицаДокумента.АдресРегистрации КАК АдресРегистрации,
	|	ФизЛицаДокумента.АдресФактический КАК АдресФактический,
	|	ФизЛицаДокумента.ДатаРождения КАК ДатаРождения,
	|	ФизЛицаДокумента.ВидДокумента КАК ВидДокумента,
	|	ФизЛицаДокумента.СерияДокумента КАК СерияДокумента,
	|	ФизЛицаДокумента.НомерДокумента КАК НомерДокумента,
	|	ФизЛицаДокумента.ДатаВыдачи КАК ДатаВыдачи,
	|	ФизЛицаДокумента.КемВыдан КАК КемВыдан,
	|	ФизЛицаДокумента.ДатаПолученияСвидетельства КАК ДатаПолученияСвидетельства,
	|	ФизЛицаДокумента.СтраховойНомерПФРВСвидетельстве КАК СтраховойНомерПФРВСвидетельстве,
	|	ФизЛицаДокумента.ФамилияВСвидетельстве КАК ФамилияВСвидетельстве,
	|	ФизЛицаДокумента.ИмяВСвидетельстве КАК ИмяВСвидетельстве,
	|	ФизЛицаДокумента.ОтчествоВСвидетельстве КАК ОтчествоВСвидетельстве,
	|	ФизЛицаДокумента.Фамилия КАК Фамилия,
	|	ФизЛицаДокумента.Имя КАК Имя,
	|	ФизЛицаДокумента.Отчество КАК Отчество,
	|	ФизЛицаДокумента.Пол КАК Пол,
	|	ФизЛицаДокумента.МестоРождения КАК МестоРождения,
	|	ФизЛицаДокумента.Гражданство КАК Гражданство,
	|	ФизЛицаДокумента.ПризнакОтменыОтчества КАК ПризнакОтменыОтчества,
	|	ФизЛицаДокумента.ПризнакОтменыМестаРождения КАК ПризнакОтменыМестаРождения,
	|	ФизЛицаДокумента.ОтметкаОПредставленииСведений КАК ОтметкаОПредставленииСведений,
	|	ФизЛицаДокумента.ПолВСвидетельстве,
	|	ФизЛицаДокумента.ДатаРожденияВСвидетельстве,
	|	ФизЛицаДокумента.МестоРожденияВСвидетельстве,
	|	ВЫБОР
	|		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СотрудникРаботаетВОрганизации,
	|	ДублиСтрок.НомерСтроки КАК КонфликтующаяСтрока
	|ИЗ
	|	ВТФизЛицаДокумента КАК ФизЛицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизическиеЛицаРаботавшиеВОрганизации КАК АктуальныеСотрудники
	|		ПО ФизЛицаДокумента.ФизическоеЛицо = АктуальныеСотрудники.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизЛицаДокумента КАК ДублиСтрок
	|		ПО ФизЛицаДокумента.ФизическоеЛицо = ДублиСтрок.ФизическоеЛицо
	|			И ФизЛицаДокумента.НомерСтроки > ДублиСтрок.НомерСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФизЛицаДокумента.НомерСтроки";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ПроверитьДанныеДокумента(Отказ) Экспорт 
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	ПроверяемыеРеквизитыСотрудников = Новый Массив;
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.СтраховойНомерПФРВСвидетельстве");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.ФамилияВСвидетельстве");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.ИмяВСвидетельстве");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.ВидДокумента");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.НомерДокумента");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.ДатаВыдачи");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.ПолВСвидетельстве");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.ДатаРожденияВСвидетельстве");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.МестоРожденияВСвидетельстве");
	
	НеПроверяемыеРеквизиты = Новый Массив;
	
	ПерсонифицированныйУчет.ПроверитьДанныеОрганизации(ЭтотОбъект, Организация, Отказ);	

	ДанныеОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "Наименование, КодПоОКПО"); 
	
	ВыборкаСотрудникиДляПроверки = СформироватьЗапросПоСотрудникамДляПроверки().Выбрать();
	
	Если ВыборкаСотрудникиДляПроверки.Количество() > 200 Тогда
		ТекстОшибки = НСтр("ru = 'В документе должно быть не более 200 анкет (сотрудников).'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка,,,Отказ);
	КонецЕсли;
	
	Пока ВыборкаСотрудникиДляПроверки.Следующий() Цикл
		
		Если ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.Сотрудник) Тогда
			
			Если Не ВыборкаСотрудникиДляПроверки.СотрудникРаботаетВОрганизации Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %2 не работает в организации %3.'"), ВыборкаСотрудникиДляПроверки.НомерСтроки, ВыборкаСотрудникиДляПроверки.СотрудникНаименование, ДанныеОрганизации.Наименование);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			
			Если ВыборкаСотрудникиДляПроверки.КонфликтующаяСтрока <> Null Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Информация о сотруднике %2 была введена в документе ранее.'"), ВыборкаСотрудникиДляПроверки.НомерСтроки, ВыборкаСотрудникиДляПроверки.СотрудникНаименование);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			
			ФизическиеЛицаЗарплатаКадры.ПроверитьПерсональныеДанныеСотрудника(Ссылка, ВыборкаСотрудникиДляПроверки, ПроверяемыеРеквизитыСотрудников, НеПроверяемыеРеквизиты, Дата, Истина, Отказ);
			ПерсонифицированныйУчет.ПроверитьСоответствиеИзменившихсяДанныхДаннымСвидетельства(Ссылка, ВыборкаСотрудникиДляПроверки, Отказ);
			
			Если ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.ДатаРожденияВСвидетельстве) И ВыборкаСотрудникиДляПроверки.ДатаРождения = ВыборкаСотрудникиДляПроверки.ДатаРожденияВСвидетельстве Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %1: дата рождения в свидетельстве совпадает с датой рождения в изменившихся данных.'"), ВыборкаСотрудникиДляПроверки.СотрудникНаименование);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.ПолВСвидетельстве) И ВыборкаСотрудникиДляПроверки.Пол = ВыборкаСотрудникиДляПроверки.ПолВСвидетельстве Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %1: пол в свидетельстве совпадает с полом в изменившихся данных.'"), ВыборкаСотрудникиДляПроверки.СотрудникНаименование);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.МестоРожденияВСвидетельстве) И ВыборкаСотрудникиДляПроверки.МестоРождения = ВыборкаСотрудникиДляПроверки.МестоРожденияВСвидетельстве Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %1: место рождения в свидетельстве совпадает с местом рождения в изменившихся данных.'"), ВыборкаСотрудникиДляПроверки.СотрудникНаименование);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОкончаниеОтчетногоПериода() Экспорт
	
	Возврат КонецДня(Дата);
	
КонецФункции

#КонецОбласти

#КонецЕсли