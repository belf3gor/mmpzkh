////////////////////////////////////////////////////////////////////////////////
// Работа с номенклатурой.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ДанныеВыбораНоменклатуры(Параметры, ОкончаниеВводаТекста = Ложь) Экспорт
	
	ДанныеВыбора = Справочники.Номенклатура.ПолучитьДанныеВыбора(Параметры);
	
	Если ДанныеВыбора.Количество() = 0 
		И ЕстьВидыНоменклатуры()
		И БухгалтерскийУчетВызовСервераПовтИсп.ИспользоватьОднуНоменклатурнуюГруппу()
		И Параметры.Свойство("ВидыНоменклатуры") Тогда
	
		Если Параметры.Отбор.Свойство("Услуга") И Параметры.Отбор.Услуга Тогда
			ОсновнойВидНоменклатуры = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнойВидНоменклатурыУслуга");
		Иначе
			ОсновнойВидНоменклатуры = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнойВидНоменклатуры");
		КонецЕсли;
		
		ШрифтКоманды    = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста);
		ШрифтПодСтроки  = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина);
		ЦветПодстроки   = Новый Цвет(0, 175, 0);
		
		Если ЗначениеЗаполнено(ОсновнойВидНоменклатуры) Тогда
			
			Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОсновнойВидНоменклатуры, "Наименование");
			
			Представление = Новый ФорматированнаяСтрока(
				Новый ФорматированнаяСтрока(СтрШаблон(НСтр("ru='Создать: %1'"), Наименование) + " """, ШрифтКоманды),
				Новый ФорматированнаяСтрока(СокрЛП(Параметры.СтрокаПоиска), ШрифтПодСтроки, ЦветПодстроки),
				Новый ФорматированнаяСтрока("""", ШрифтКоманды)
				);
				
			ДанныеВыбора.Добавить(ОсновнойВидНоменклатуры, Представление);
			
		КонецЕсли;
		
		ВидыНоменклатурыДляВыбора = РаботаСНоменклатуройПовтИсп.ВидыНоменклатурыДляВыбора(
			ОсновнойВидНоменклатуры, Параметры.ВидыНоменклатуры);
			
		Для Каждого ВидНоменклатуры Из ВидыНоменклатурыДляВыбора Цикл
			
			Представление = Новый ФорматированнаяСтрока(
				Новый ФорматированнаяСтрока(СтрШаблон(НСтр("ru='Создать: %1'"), ВидНоменклатуры.Представление) + " """, ШрифтКоманды),
				Новый ФорматированнаяСтрока(СокрЛП(Параметры.СтрокаПоиска), ШрифтПодСтроки, ЦветПодстроки),
				Новый ФорматированнаяСтрока("""", ШрифтКоманды)
				);
				
			ДанныеВыбора.Добавить(ВидНоменклатуры.Значение, Представление);
			
		КонецЦикла;
			
		Если ОкончаниеВводаТекста Тогда
			// Добавляем вторую строку, чтобы в этом режиме не срабатывал автовыбор единственной строки.
			ДанныеВыбора.Добавить(""); 
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДанныеВыбора;
	
КонецФункции

Функция СоздатьНоменклатуруБыстро(Знач ВидНоменклатуры, Знач ПараметрыСоздания) Экспорт
	
	НовыйОбъект = Справочники.Номенклатура.СоздатьЭлемент();
	
	Если ПараметрыСоздания.Свойство("ЗначенияЗаполнения") Тогда
		НовыйОбъект.Заполнить(ПараметрыСоздания.ЗначенияЗаполнения);
	КонецЕсли;
	
	НовыйОбъект.ВидНоменклатуры = ВидНоменклатуры;
	НовыйОбъект.Наименование = ПараметрыСоздания.ДополнительныеПараметрыСоздания.Наименование;
	НовыйОбъект.НаименованиеПолное = НовыйОбъект.Наименование;
	
	Услуга = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидНоменклатуры, "Услуга");
	НовыйОбъект.Услуга = Услуга;
	Если НЕ Услуга Тогда
		НовыйОбъект.ЕдиницаИзмерения = Справочники.КлассификаторЕдиницИзмерения.ПолучитьЕдиницуИзмеренияПоУмолчанию();
	КонецЕсли;
	
	НовыйОбъект.НоменклатурнаяГруппа = БухгалтерскийУчетВызовСервераПовтИсп.ОсновнаяНоменклатурнаяГруппа();
	
	Попытка
		НовыйОбъект.Записать();
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат НовыйОбъект.Ссылка;
	
КонецФункции

Функция ЕстьВидыНоменклатуры()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыНоменклатуры.Ссылка
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры";
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции

// Функция возвращает ответ, нужно ли предлагать включить периодичность.
// 
// Параметры:
//    Номенклатура - Справочник.Номенклатура.
//    Содержание - Строка - Содержание услуги, которое ввел пользователь.
//    ПериодичностьУслуги - Перечисление.Периодичность.
//    Дата - Дата - Дата документа.
//
// Возвращаемое значение:
//    Булево
//
Функция ПредложитьВключитьПериодичностьУслуги(Знач Номенклатура, Знач Содержание, Знач ПериодичностьУслуги, Знач Дата) Экспорт

	// Предлагаем включить периодичность в случае, если:
	// 1. Периодичность не задана в номенклатуре.
	// 2. Автоматически подготовленное содержание услуги соответствует содержанию, которое ввел пользователь.
	
	РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Номенклатура, "ПериодичностьУслуги, Наименование, НаименованиеПолное");
	
	Если ЗначениеЗаполнено(РеквизитыНоменклатуры.ПериодичностьУслуги) Тогда
		// Периодичность задана - не предлагаем.
		Возврат Ложь;
	КонецЕсли;
	
	НаименованиеНоменклатуры = ?(ПустаяСтрока(РеквизитыНоменклатуры.НаименованиеПолное), 
		РеквизитыНоменклатуры.Наименование,
		РеквизитыНоменклатуры.НаименованиеПолное);
		
	Если НЕ ЗначениеЗаполнено(НаименованиеНоменклатуры) Тогда
		// Если наименование не заполнено, то не будем предлагать.
		Возврат Ложь;
	КонецЕсли;
	
	// Сравним содержание услуги пользователя и автоматически подготовленное содержание.
	АвтоматическоеСодержание = НРег(РаботаСНоменклатуройКлиентСервер.СодержаниеУслуги(
		НаименованиеНоменклатуры,
		ПериодичностьУслуги,
		Дата,
		Ложь)); // Исключим год из автоматически подготовленного содержания, для смягчения поиска.
		
	АвтоматическоеСодержание = СокрЛП(АвтоматическоеСодержание);
	Содержание               = СокрЛП(НРег(Содержание));
	
	Если НЕ СтрНачинаетсяС(Содержание, АвтоматическоеСодержание) Тогда
		// Текст не совпадает - не предлагаем.
		Возврат Ложь;
	КонецЕсли;
	
	// Исключим случаи, когда не совпадает оставшаяся часть наименования.
	// Считаем, что в оставшейся части может быть информация о годе.
	// Так как вариантов написания года много, считаем что любые два слова - это обозначение года. Например, "2017 г."
	ОставшаясяСтрока = Сред(Содержание, СтрДлина(АвтоматическоеСодержание) + 1);
	МассивСлов = СтрРазделить(ОставшаясяСтрока, " ", Ложь);
	Если МассивСлов.Количество() > 2 Тогда
		// В оставшейся строке больше 2х слов - не предлагаем.
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

#КонецОбласти