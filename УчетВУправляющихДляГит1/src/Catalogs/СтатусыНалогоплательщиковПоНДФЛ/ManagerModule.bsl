
#Область ОбработчикиСобытий
	
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	ЗарплатаКадрыВызовСервера.ПодготовитьДанныеВыбораКлассификаторовСПорядкомРеквизитаДопУпорядочивания(ДанныеВыбора, Параметры, СтандартнаяОбработка, "Справочник.СтатусыНалогоплательщиковПоНДФЛ");
КонецПроцедуры
	
#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

Процедура НачальноеЗаполнение() Экспорт
	
	ОписанияСтатусов = Новый Массив;
	// Строки не локализуются т.к. являются частью регламентированной формы, применяемой в РФ.
	Описание = ОписаниеСтатуса();
	Описание.Идентификатор = "Резидент";
	Описание.Наименование = "Резидент";
	Описание.КодФНС = "1";
	ОписанияСтатусов.Добавить(Описание);
		
	Описание = ОписаниеСтатуса();
	Описание.Идентификатор = "Нерезидент";
	Описание.Наименование = "Нерезидент";
	Описание.КодФНС = "2";
	ОписанияСтатусов.Добавить(Описание);
		
	Описание = ОписаниеСтатуса();
	Описание.Идентификатор = "ВысококвалифицированныйИностранныйСпециалист";
	Описание.Наименование = "Высококвалифицированный иностранный специалист";
	Описание.КодФНС = "3";
	ОписанияСтатусов.Добавить(Описание);
		
	Описание = ОписаниеСтатуса();
	Описание.Идентификатор = "ЧленЭкипажаСуднаПодФлагомРФ";
	Описание.Наименование = "Член экипажа судна, зарегистрированного в Российском международном реестре судов";
	Описание.КодФНС = "2";
	ОписанияСтатусов.Добавить(Описание);
		
	Описание = ОписаниеСтатуса();
	Описание.Идентификатор = "УчастникПрограммыПоПереселениюСоотечественников";
	Описание.Наименование = "Участник программы по переселению соотечественников";
	Описание.КодФНС = "2";
	ОписанияСтатусов.Добавить(Описание);
	
	Описание = ОписаниеСтатуса();
	Описание.Идентификатор = "Беженцы";
	Описание.Наименование = "Беженцы или получившие временное убежище на территории РФ";
	Описание.КодФНС = "2";
	ОписанияСтатусов.Добавить(Описание);
	
	Счетчик = 1;
	Для каждого ОписаниеСтатуса Из ОписанияСтатусов Цикл
		
		СтатусСсылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.СтатусыНалогоплательщиковПоНДФЛ." + ОписаниеСтатуса.Идентификатор);
		Если ЗначениеЗаполнено(СтатусСсылка) Тогда
			СтатусОбъект = СтатусСсылка.ПолучитьОбъект();
		Иначе
			СтатусОбъект = Справочники.СтатусыНалогоплательщиковПоНДФЛ.СоздатьЭлемент();
			СтатусОбъект.ИмяПредопределенныхДанных = ОписаниеСтатуса.Идентификатор;
		КонецЕсли;
		
		Если СтатусОбъект.РеквизитДопУпорядочивания <> Счетчик Тогда
		
			СтатусОбъект.Наименование = ОписаниеСтатуса.Наименование;
			СтатусОбъект.КодФНС = ОписаниеСтатуса.КодФНС;
			СтатусОбъект.РеквизитДопУпорядочивания = Счетчик;
			СтатусОбъект.ОбменДанными.Загрузка = Истина;
			СтатусОбъект.Записать();
			
		КонецЕсли;
		
		Счетчик = Счетчик + 1;
		
	КонецЦикла;
	
	ОписатьСтатусыНерезидентов2015(Истина);
	ПроставитьКоды_2015(Истина);
	
КонецПроцедуры

Процедура УточнитьНаименованияСтатусовНДФЛ() Экспорт
	
	Запрос = Новый Запрос;
	// Строки не локализуются т.к. являются частью регламентированной формы, применяемой в РФ.
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтатусыНалогоплательщиковПоНДФЛ.Ссылка,
	|	ВЫБОР
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.УчастникПрограммыПоПереселениюСоотечественников)
	|			ТОГДА ""Участник программы ПО переселению соотечественников""
	|		ИНАЧЕ ""Член экипажа судна, зарегистрированного В Российском международном реестре судов""
	|	КОНЕЦ КАК Наименование
	|ИЗ
	|	Справочник.СтатусыНалогоплательщиковПоНДФЛ КАК СтатусыНалогоплательщиковПоНДФЛ
	|ГДЕ
	|	СтатусыНалогоплательщиковПоНДФЛ.Ссылка В (ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.УчастникПрограммыПоПереселениюСоотечественников), ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.ЧленЭкипажаСуднаПодФлагомРФ))
	|	И СтатусыНалогоплательщиковПоНДФЛ.Наименование <> ВЫБОР
	|			КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.УчастникПрограммыПоПереселениюСоотечественников)
	|				ТОГДА ""Участник программы ПО переселению соотечественников""
	|			ИНАЧЕ ""Член экипажа судна, зарегистрированного В Российском международном реестре судов""
	|		КОНЕЦ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтатусОбъект = Выборка.Ссылка.ПолучитьОбъект();
		// Строка не локализуется т.к. является частью регламентированной формы, применяемой в РФ.
		СтатусОбъект.Наименование = Выборка.Наименование;
		СтатусОбъект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
		СтатусОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры	

Процедура ОписатьСтатусБеженца() Экспорт
	
	Если Не ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.СтатусыНалогоплательщиковПоНДФЛ.Беженцы, "КодФНС")) Тогда
		СтатусБеженца = Справочники.СтатусыНалогоплательщиковПоНДФЛ.Беженцы.ПолучитьОбъект();
		СтатусБеженца.КодФНС = "2";
		СтатусБеженца.РеквизитДопУпорядочивания = 6;
		СтатусБеженца.ОбменДанными.Загрузка = Истина;
		СтатусБеженца.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОписатьСтатусыНерезидентов2015(Переписывать = Ложь) Экспорт
	
	Если Переписывать Или Не ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.СтатусыНалогоплательщиковПоНДФЛ.ГражданинСтраныЕАЭС, "КодФНС")) Тогда
		СтатусБеженца = Справочники.СтатусыНалогоплательщиковПоНДФЛ.ГражданинСтраныЕАЭС.ПолучитьОбъект();
		СтатусБеженца.КодФНС = "2";
		СтатусБеженца.РеквизитДопУпорядочивания = 7;
		СтатусБеженца.ОбменДанными.Загрузка = Истина;
		СтатусБеженца.Записать();
	КонецЕсли;
	
	Если Переписывать Или Не ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.СтатусыНалогоплательщиковПоНДФЛ.НерезидентРаботающийНаОснованииПатента, "КодФНС")) Тогда
		СтатусБеженца = Справочники.СтатусыНалогоплательщиковПоНДФЛ.НерезидентРаботающийНаОснованииПатента.ПолучитьОбъект();
		СтатусБеженца.КодФНС = "2";
		СтатусБеженца.РеквизитДопУпорядочивания = 8;
		СтатусБеженца.ОбменДанными.Загрузка = Истина;
		СтатусБеженца.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроставитьКоды_2015(Переписывать = Ложь) Экспорт

	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СтатусыНалогоплательщиковПоНДФЛ.Ссылка,
	|	ВЫБОР
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.Резидент)
	|			ТОГДА ""1""
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.Нерезидент)
	|			ТОГДА ""2""
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.ГражданинСтраныЕАЭС)
	|			ТОГДА ""2""
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.ВысококвалифицированныйИностранныйСпециалист)
	|			ТОГДА ""3""
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.ЧленЭкипажаСуднаПодФлагомРФ)
	|			ТОГДА ""4""
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.УчастникПрограммыПоПереселениюСоотечественников)
	|			ТОГДА ""4""
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.Беженцы)
	|			ТОГДА ""5""
	|		КОГДА СтатусыНалогоплательщиковПоНДФЛ.Ссылка = ЗНАЧЕНИЕ(Справочник.СтатусыНалогоплательщиковПоНДФЛ.НерезидентРаботающийНаОснованииПатента)
	|			ТОГДА ""6""
	|		ИНАЧЕ ""2""
	|	КОНЕЦ КАК КодФНС_2015
	|ИЗ
	|	Справочник.СтатусыНалогоплательщиковПоНДФЛ КАК СтатусыНалогоплательщиковПоНДФЛ
	|ГДЕ
	|	&Условие";
	Если Переписывать Тогда
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("Условие", Истина);
	Иначе
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "&Условие", "СтатусыНалогоплательщиковПоНДФЛ.КодФНС_2015 = """"");
	КонецЕсли;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтатусОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СтатусОбъект.КодФНС_2015 = Выборка.КодФНС_2015;
		СтатусОбъект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
		СтатусОбъект.ОбменДанными.Загрузка = Истина;
		СтатусОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры


Функция ОписаниеСтатуса()
	
	Возврат Новый Структура("Идентификатор, Наименование, КодФНС");	
	
КонецФункции	

#КонецОбласти

#КонецЕсли
