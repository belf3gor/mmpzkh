#Область СлужебныеПроцедурыИФункции	

Процедура ПриЗаписиРегистраУчетаСтажаПФР(МенеджерВременныхТаблиц) Экспорт
	
КонецПроцедуры

Функция РесурсыУчетаСтажаПФР() Экспорт
	Ресурсы = Новый Массив;	
	Ресурсы.Добавить("ВидСтажаПФР");
	Ресурсы.Добавить("Организация");
	Ресурсы.Добавить("Подразделение");
	Ресурсы.Добавить("Должность");
	Ресурсы.Добавить("ВнутреннееСовместительство");
	
	Возврат Ресурсы;
КонецФункции	

Функция НоваяЗаписьНабораРегистраУчетаСтажаПФР(НаборЗаписей) Экспорт
	НоваяЗапись = НаборЗаписей.Добавить();
	
	НоваяЗапись.ИспользованиеРесурсаОрганизация = Перечисления.ЗначениеРесурсаРегистровСостоянийСотрудника.НеУстановлено;
	НоваяЗапись.ИспользованиеРесурсаПодразделение = Перечисления.ЗначениеРесурсаРегистровСостоянийСотрудника.НеУстановлено;
	НоваяЗапись.ИспользованиеРесурсаДолжность = Перечисления.ЗначениеРесурсаРегистровСостоянийСотрудника.НеУстановлено;
	НоваяЗапись.ИспользованиеРесурсаВнутреннееСовместительство = Перечисления.ЗначениеРесурсаРегистровСостоянийСотрудника.НеУстановлено;
	
	НоваяЗапись.ИспользованиеРесурсаВидСтажаПФР = Перечисления.ЗначениеРесурсаРегистровСостоянийСотрудника.НеУстановлено;
		
	НоваяЗапись.ДокументОснование = НаборЗаписей.Отбор.Регистратор.Значение;
	
	Возврат НоваяЗапись;
КонецФункции 

Функция ТекстДополнительныхПолейЗапросаВТДанныеУчетаСтажаПФР() Экспорт
	ТекстыПолейЗапроса = Новый Соответствие;
	
	ТекстПоля = "1";
	ТекстыПолейЗапроса.Вставить("КоличествоСтавок", ТекстПоля);
	
	ТекстПоля = "ЛОЖЬ";
	ТекстыПолейЗапроса.Вставить("НеполныйРабочийДень", ТекстПоля);
	
	ТекстПоля = "ЗНАЧЕНИЕ(Справочник.ОснованияДосрочногоНазначенияПенсии.ПустаяСсылка)";
	ТекстыПолейЗапроса.Вставить("ОснованиеДосрочногоНазначенияПенсии", ТекстПоля);
	
	ТекстПоля = "ЗНАЧЕНИЕ(Справочник.СпискиПрофессийДолжностейЛьготногоПенсионногоОбеспечения.ПустаяСсылка)";
	ТекстыПолейЗапроса.Вставить("КодПозицииСписка", ТекстПоля);
	
	ТекстПоля = "ЗНАЧЕНИЕ(Справочник.ТерриториальныеУсловияПФР.ПустаяСсылка)";
	ТекстыПолейЗапроса.Вставить("ТерриториальныеУсловия", ТекстПоля);
	
	ТекстПоля = "ЗНАЧЕНИЕ(Справочник.ТерриториальныеУсловияПФР.ПустаяСсылка)";
	ТекстыПолейЗапроса.Вставить("ТерриториальныеУсловияДополнительные", ТекстПоля);
		
	ТекстПоля = "ЛОЖЬ";
	ТекстыПолейЗапроса.Вставить("ЗарегистрированоЗначениеТерриториальныеУсловияДополнительные", ТекстПоля);	
	
	ТекстПоля = "ЗНАЧЕНИЕ(Справочник.ОсобыеУсловияТрудаПФР.ПустаяСсылка)";
	ТекстыПолейЗапроса.Вставить("ОсобыеУсловияТруда", ТекстПоля);
	
	ТекстПоля = "ЗНАЧЕНИЕ(Справочник.ОснованияИсчисляемогоСтраховогоСтажа.ПустаяСсылка)";
	ТекстыПолейЗапроса.Вставить("ОснованиеВыслугиЛет", ТекстПоля);
	
	ТекстПоля = "ЛОЖЬ";
	ТекстыПолейЗапроса.Вставить("ЗарегистрированоЗначениеТерриториальныеУсловия", ТекстПоля);

	ТекстПоля = "ЛОЖЬ";
	ТекстыПолейЗапроса.Вставить("ЗарегистрированоЗначениеОснованиеВыслугиЛет", ТекстПоля);

	ТекстПоля = "ЛОЖЬ";
	ТекстыПолейЗапроса.Вставить("ЗарегистрированоЗначениеОсобыеУсловияТруда", ТекстПоля);
	
	ТекстПоля = "ВЫБОР
				|		КОГДА ПериодыСтажаПФР.Подразделение <> ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
				|			ТОГДА ПериодыСтажаПФР.Подразделение
				|		ИНАЧЕ ПериодыСтажаПФР.Организация
				|	КОНЕЦ";
	ТекстыПолейЗапроса.Вставить("СтруктурнаяЕдиница", ТекстПоля);

	ТекстПоля = "ПериодыСтажаПФР.Должность";
	ТекстыПолейЗапроса.Вставить("Должность", ТекстПоля);

	ТекстПоля = "ПериодыСтажаПФР.Подразделение";
	ТекстыПолейЗапроса.Вставить("ВладелецДопТерриторий", ТекстПоля);
	
	Возврат ТекстыПолейЗапроса;	
КонецФункции

Процедура СоздатьВТСоответствиеВидовСтажаПараметрамИсчисления2014(МенеджерВременныхТаблиц) Экспорт
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтажаПФР2014.Декрет) КАК ВидСтажа,
	|	ЗНАЧЕНИЕ(Справочник.ПараметрыИсчисляемогоСтраховогоСтажа.ДЕКРЕТ) КАК ПараметрИсчисляемогоСтажа
	|ПОМЕСТИТЬ ВТСоответствиеВидовСтажаПараметрамИсчисления2014
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтажаПФР2014.ВременнаяНетрудоспособность),
	|	ЗНАЧЕНИЕ(Справочник.ПараметрыИсчисляемогоСтраховогоСтажа.ВРНЕТРУД)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтажаПФР2014.ДЛОТПУСК),
	|	ЗНАЧЕНИЕ(Справочник.ПараметрыИсчисляемогоСтраховогоСтажа.ДЛОТПУСК)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтажаПФР2014.ВключаетсяВСтажДляДосрочногоНазначенияПенсии),
	|	ЗНАЧЕНИЕ(Справочник.ПараметрыИсчисляемогоСтраховогоСтажа.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтажаПФР2014.ВключаетсяВСтраховойСтаж),
	|	ЗНАЧЕНИЕ(Справочник.ПараметрыИсчисляемогоСтраховогоСтажа.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтажаПФР2014.НЕОПЛ),
	|	ЗНАЧЕНИЕ(Справочник.ПараметрыИсчисляемогоСтраховогоСтажа.НЕОПЛ)";
	
	Запрос.Выполнить();
КонецПроцедуры	

Процедура СоздатьВТСоответствиеВидовСтажаПараметрамИсчисления2013(МенеджерВременныхТаблиц) Экспорт
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтажаПФР2014.Декрет) КАК ВидСтажа,
	|	ЗНАЧЕНИЕ(Справочник.ПараметрыИсчисляемогоСтраховогоСтажа.ДЕКРЕТ) КАК ПараметрИсчисляемогоСтажа
	|ПОМЕСТИТЬ ВТСоответствиеВидовСтажаПараметрамИсчисления2013
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтажаПФР2014.ВременнаяНетрудоспособность),
	|	ЗНАЧЕНИЕ(Справочник.ПараметрыИсчисляемогоСтраховогоСтажа.ВРНЕТРУД)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтажаПФР2014.ВключаетсяВСтажДляДосрочногоНазначенияПенсии),
	|	ЗНАЧЕНИЕ(Справочник.ПараметрыИсчисляемогоСтраховогоСтажа.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСтажаПФР2014.ВключаетсяВСтраховойСтаж),
	|	ЗНАЧЕНИЕ(Справочник.ПараметрыИсчисляемогоСтраховогоСтажа.ПустаяСсылка)";
	
	Запрос.Выполнить();	
КонецПроцедуры	

Процедура СоздатьВТТипыРегистраторовПриемаНаРаботу(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТИП(Документ.ПриемНаРаботу) КАК ТипРегистратора
		|ПОМЕСТИТЬ ВТТипыРегистраторовПриемаНаРаботу";
	Запрос.Выполнить();
	
КонецПроцедуры

#Область ОбработчикиОбновленияИБ
//

Процедура ЗаполнитьПервоначальныеДанныеУчета(ПараметрыОбновления = Неопределено) Экспорт
	ЗаполнитьПервоначальныеДанныеУчетаПоДокументам(ПараметрыОбновления);	
	УчетСтажаПФР.ЗаполнитьПервоначальныеДанныеВторичногоРегистра();
КонецПроцедуры	

Процедура ЗаполнитьПервоначальныеДанныеУчетаПоДокументам(ПараметрыОбновления = Неопределено) 
	ОписаниеРегистраторов = ОписаниеРегистраторовДляПервоначальногоЗаполненияУчета();
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
	Для Каждого МетаданныеДокумента Из ОписаниеРегистраторов Цикл
		ЗаполнитьПервоначальныеДанныеУчетаПоТипуДокумента(МетаданныеДокумента, ПараметрыОбновления);		
	КонецЦикла;	
КонецПроцедуры	

Функция ОписаниеРегистраторовДляПервоначальногоЗаполненияУчета()
	ОписаниеРегистраторов = Новый Массив;
	ОписаниеРегистраторов.Добавить(Метаданные.Документы.БольничныйЛист);
	ОписаниеРегистраторов.Добавить(Метаданные.Документы.КадровыйПеревод);
	ОписаниеРегистраторов.Добавить(Метаданные.Документы.Отпуск);
	ОписаниеРегистраторов.Добавить(Метаданные.Документы.ПриемНаРаботу);
	ОписаниеРегистраторов.Добавить(Метаданные.Документы.Увольнение);
	
	Возврат ОписаниеРегистраторов;	
КонецФункции	

Процедура ЗаполнитьПервоначальныеДанныеУчетаПоТипуДокумента(МетаданныеДокумента, ПараметрыОбновления = Неопределено)
	ИмяДокумента = МетаданныеДокумента.ПолноеИмя();
	
	ВыборкаРегистраторов = ВыборкаНеОтраженныхВУчетеРегистраторовБезПоддержкиИсправления(ИмяДокумента);	
	
	МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяДокумента);

	МассивСсылок = Новый Массив;
	СоответствиеИсправленныхДокументов = Новый Соответствие;
	
	Пока ВыборкаРегистраторов.Следующий() Цикл
		МассивСсылок.Добавить(ВыборкаРегистраторов.Ссылка);		
	КонецЦикла;	
	
	ДанныеДляРегистрацииВУчете = МенеджерДокумента.ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок);
	
	Для Каждого ДанныеДляРегистрацииПоДокументу Из ДанныеДляРегистрацииВУчете Цикл		
		Движения = Новый Структура;
		НаборЗаписей = РегистрыСведений.ПараметрыПериодовСтажаПФР.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(ДанныеДляРегистрацииПоДокументу.Ключ);
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		Движения.Вставить("ПараметрыПериодовСтажаПФР", НаборЗаписей);
		
		НачатьТранзакцию();
		
		УчетСтажаПФР.ЗарегистрироватьПериодыВУчетеСтажаПФР(Движения, ДанныеДляРегистрацииПоДокументу.Значение);
		Если Движения.ПараметрыПериодовСтажаПФР.Количество() > 0 Тогда
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
		КонецЕсли;
		Движения.ПараметрыПериодовСтажаПФР.Записать();
				
		ЗафиксироватьТранзакцию();	
	КонецЦикла;	
	
КонецПроцедуры	

Функция ВыборкаНеОтраженныхВУчетеРегистраторовБезПоддержкиИсправления(ИмяДокумента)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.Ссылка,
	|	NULL КАК ДокументИсправление,
	|	ЛОЖЬ КАК ЭтоИсправленныйДокумент
	|ИЗ
	|	#ДанныеДокумента КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыПериодовСтажаПФР КАК ПараметрыПериодовСтажаПФР
	|		ПО (ПараметрыПериодовСтажаПФР.Регистратор = ДанныеДокумента.Ссылка)
	|ГДЕ
	|	ДанныеДокумента.Проведен
	|	И ПараметрыПериодовСтажаПФР.Регистратор ЕСТЬ NULL ";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ДанныеДокумента", ИмяДокумента);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции	

#КонецОбласти	

#КонецОбласти	