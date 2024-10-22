#Область ОпределениеВидовОпераций

Функция УплатаНалогаЗаТретьихЛиц(Объект) Экспорт
	
	Возврат Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалогаЗаТретьихЛиц;
	
КонецФункции

Функция ПереводНаДругойСчет(Объект) Экспорт
	
	Возврат Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПереводНаДругойСчет;
	
КонецФункции

#КонецОбласти

#Область ПроверкаПлатежныхРеквизитовГосударственныхОрганов

Процедура ЗаполнитьСведенияОГосударственномОрганеИзПараметров(Форма, Параметры) Экспорт
	
	Объект = Форма.Объект;
	
	Если Параметры.ЗначенияЗаполнения.Свойство("КодБК")
		И Параметры.ЗначенияЗаполнения.Свойство("КодНалоговогоОргана")
		И НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		
		ВидГосударственногоОргана = Справочники.Контрагенты.ВидГосударственногоОрганаПоКБК(Параметры.ЗначенияЗаполнения.КодБК);
		Если ЗначениеЗаполнено(ВидГосударственногоОргана)
			И ВидГосударственногоОргана <> Перечисления.ВидыГосударственныхОрганов.Прочий Тогда
			
			ПолучательПлатежа = Документы.ПлатежноеПоручение.ПолучательДляПлатежаГосударственномуОргану(
				ВидГосударственногоОргана, Параметры.ЗначенияЗаполнения.КодНалоговогоОргана);
			
			УстановитьПолучателяПлатежаИРасчетныйСчет(Форма, ПолучательПлатежа.Контрагент, ПолучательПлатежа.БанковскийСчет);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверитьПлатежныеРеквизитыВФоне(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	Если ТребуетсяПроверитьПлатежныеРеквизиты(Форма) Тогда
		
		ПараметрыЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(Форма.УникальныйИдентификатор);
		ПараметрыЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Проверка платежных реквизитов в документе'");
		ПараметрыЗапуска.ОжидатьЗавершение = 0;
		
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("Контрагент", Объект.Контрагент);
		ПараметрыВыполнения.Вставить("ПлатежныеРеквизиты", ПлатежныеРеквизиты(Форма));
		
		Результат = ДлительныеОперации.ВыполнитьВФоне("ДанныеГосударственныхОрганов.ПроверитьПлатежныеРеквизитыКонтрагентаВФоне",
			ПараметрыВыполнения,
			ПараметрыЗапуска);
		
		Если Результат.Статус = "Ошибка" Тогда
			УстановитьСостояниеКонтрагентаОшибка(Форма);
		ИначеЕсли Результат.Статус = "Выполнено" Тогда
			УстановитьСостояниеКонтрагента(Форма, Результат);
			Возврат Неопределено;
		Иначе
			УстановитьСостояниеКонтрагентаПроверяется(Форма);
			Возврат Результат;
		КонецЕсли;
		
	Иначе
		
		УстановитьСостояниеКонтрагентаНеТребуетсяПроверка(Форма);
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

Функция ПлатежныеРеквизиты(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	ПлатежныеРеквизиты = Новый Структура();
	ПлатежныеРеквизиты.Вставить("ПолучательПлатежа", Объект.ТекстПолучателя);
	ПлатежныеРеквизиты.Вставить("ИНН", Объект.ИННПолучателя);
	ПлатежныеРеквизиты.Вставить("КПП", Объект.КПППолучателя);
	
	РеквизитыРасчетногоСчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.СчетКонтрагента, "НомерСчета, Банк");
	ПлатежныеРеквизиты.Вставить("РасчетныйСчет", РеквизитыРасчетногоСчета.НомерСчета);
	Если ЗначениеЗаполнено(РеквизитыРасчетногоСчета.Банк) Тогда
		РеквизитыБанка = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РеквизитыРасчетногоСчета.Банк, "Код");
		ПлатежныеРеквизиты.Вставить("БИК", РеквизитыБанка.Код);
	Иначе
		ПлатежныеРеквизиты.Вставить("БИК", "");
	КонецЕсли;
	
	Возврат ПлатежныеРеквизиты;
	
КонецФункции

Процедура УстановитьПолучателяПлатежаИРасчетныйСчет(Форма, ПолучательПлатежа, БанковскийСчет)
	
	Форма.Объект.Контрагент      = ПолучательПлатежа;
	Форма.Объект.СчетКонтрагента = БанковскийСчет;
	
КонецПроцедуры

Функция ТребуетсяПроверитьПлатежныеРеквизиты(Форма)
	
	Объект = Форма.Объект;
	
	Если ТипЗнч(Объект.Контрагент) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВидНалога = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Налог, "ВидНалога");
	
	НужноВыполнятьПроверку =
			ЗначениеЗаполнено(Объект.Контрагент)
			И ЗначениеЗаполнено(Объект.СчетКонтрагента)
			И (Объект.Дата + 86400 * 10 > ТекущаяДатаСеанса())
			И Объект.ПеречислениеВБюджет
			И Форма.Состояние <> Перечисления.СостоянияБанковскихДокументов.Оплачено
			И ВидыНалоговСОтключеннойПроверкойПлатежныхРеквизитов().Найти(ВидНалога) = Неопределено;
	
	Если НужноВыполнятьПроверку Тогда
		
		РеквизитыКонтрагента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Контрагент,
			"ГосударственныйОрган, ВидГосударственногоОргана, КодГосударственногоОргана");
		Если РеквизитыКонтрагента.ГосударственныйОрган
			И ЗначениеЗаполнено(РеквизитыКонтрагента.ВидГосударственногоОргана)
			И РеквизитыКонтрагента.ВидГосударственногоОргана <> Перечисления.ВидыГосударственныхОрганов.Прочий
			И ЗначениеЗаполнено(РеквизитыКонтрагента.КодГосударственногоОргана) Тогда
			
			Возврат Истина;
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ВидыНалоговСОтключеннойПроверкойПлатежныхРеквизитов()
	
	МассивВидовНалогов = Новый Массив;
	// НПД уплачивается по ОКТМО и в казначество региона ведения деятельности, но по ИНН и КПП налоговой по месту жительства.
	МассивВидовНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрофессиональныйДоход);
	
	Возврат МассивВидовНалогов;
	
КонецФункции

Процедура УстановитьСостояниеКонтрагента(Форма, Результат) Экспорт
	
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаСчетКонтрагентаПроверка.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
	
	РеквизитыНеверны = Ложь;
	
	Подстроки = Новый Массив;
	
	Если Результат <> Неопределено Тогда
		
		//Задание выполнено
		
		Если ЗначениеЗаполнено(Результат.АдресРезультата)
			И ЭтоАдресВременногоХранилища(Результат.АдресРезультата) Тогда
			
			РезультатРаботыФоновогоЗадания = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
			
			Если РезультатРаботыФоновогоЗадания <> Неопределено
				И РезультатРаботыФоновогоЗадания.Свойство("РезультатПроверки") Тогда
				
				Подстроки.Добавить(РезультатРаботыФоновогоЗадания.РезультатПроверки);
				Подстроки.Добавить(Символы.ПС);
				
				Если РезультатРаботыФоновогоЗадания.Свойство("ТребуетсяАутентификация")
					И РезультатРаботыФоновогоЗадания.ТребуетсяАутентификация = Истина Тогда
					
					СсылкаНаПодключениеКИТС = Новый ФорматированнаяСтрока(НСтр("ru = 'Подключиться'")
						,,,, "e1cib/app/Обработка.ИнтернетПоддержкаПользователей.Форма.ОбщаяАвторизация");
					Подстроки.Добавить(СсылкаНаПодключениеКИТС);
					
				КонецЕсли;
				
				Если РезультатРаботыФоновогоЗадания.Свойство("Сервис1СКонтрагентНеПодключен")
					И РезультатРаботыФоновогоЗадания.Сервис1СКонтрагентНеПодключен = Истина Тогда
					
					Ссылка1СКонтрагент = Новый ФорматированнаяСтрока(НСтр("ru = 'Подробная информация'")
						,,,, "https://portal.1c.ru/applications/3");
					Подстроки.Добавить(Ссылка1СКонтрагент);
					
				КонецЕсли;
				
				
				Если РезультатРаботыФоновогоЗадания.Свойство("ПлатежныеРеквизитыНайдены")
					И РезультатРаботыФоновогоЗадания.ПлатежныеРеквизитыНайдены Тогда
					
					Если РезультатРаботыФоновогоЗадания.Свойство("ПлатежныеРеквизитыАктуальны") Тогда
						Если РезультатРаботыФоновогоЗадания.ПлатежныеРеквизитыАктуальны = Ложь Тогда
							КрасныйЦвет = Новый Цвет(251, 212, 212);
							Элементы.ГруппаСчетКонтрагентаПроверка.ЦветФона = КрасныйЦвет;
							Если Не Форма.ТолькоПросмотр Тогда
								СсылкаНаПодробнее = Новый ФорматированнаяСтрока(НСтр("ru = 'Исправить'")
									,,,, "e1cib/app/Документ.ПлатежноеПоручение.Форма.ФормаПроверкиПлатежныхРеквизитов");
								Подстроки.Добавить(СсылкаНаПодробнее);
							КонецЕсли;
							
							РеквизитыНеверны = Истина;
							
							Форма.РезультатПроверкиСчетаКонтрагента = РезультатПроверкиСчетаКонтрагентаОшибка(Форма);
							
						Иначе
							ЗеленыйЦвет = Новый Цвет(215, 240, 199);
							Элементы.ГруппаСчетКонтрагентаПроверка.ЦветФона = ЗеленыйЦвет;
						КонецЕсли;
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
		
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаСчетКонтрагентаОшибкаПроверки.Видимость = РеквизитыНеверны;
	
	Элементы.СчетКонтрагента.РасширеннаяПодсказка.Заголовок = Новый ФорматированнаяСтрока(Подстроки);
	
КонецПроцедуры

Процедура УстановитьСостояниеКонтрагентаОшибка(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаСчетКонтрагентаОшибкаПроверки.Видимость = Ложь;
	
	Элементы.ГруппаСчетКонтрагентаПроверка.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
	
	Подстроки = Новый Массив;
	Подстроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'При проверке платежных реквизитов возникла ошибка.
														|Подробности в журнале регистрации.'")));
	
	Элементы.СчетКонтрагента.РасширеннаяПодсказка.Заголовок = Новый ФорматированнаяСтрока(Подстроки);
	
КонецПроцедуры

Процедура УстановитьСостояниеКонтрагентаПроверяется(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаСчетКонтрагентаОшибкаПроверки.Видимость = Ложь;
	
	Элементы.ГруппаСчетКонтрагентаПроверка.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
	
	Подстроки = Новый Массив;
	Подстроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Выполняется проверка платежных реквизитов'")));
	Подстроки.Добавить(Символы.ПС);
	
	Элементы.СчетКонтрагента.РасширеннаяПодсказка.Заголовок = Новый ФорматированнаяСтрока(Подстроки);
	
КонецПроцедуры

Процедура УстановитьСостояниеКонтрагентаНеТребуетсяПроверка(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаСчетКонтрагентаОшибкаПроверки.Видимость = Ложь;
	
	Элементы.ГруппаСчетКонтрагентаПроверка.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
	
	Подстроки = Новый Массив;
	Подстроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Для платежных поручений на уплату налогов и взносов
															|есть возможность проверить актуальность платежных реквизитов
															|государственных органов.
															|Проверка выполняется для неоплаченных платежных поручений,
															|созданных не более 10 дней назад.'")));
	
	Элементы.СчетКонтрагента.РасширеннаяПодсказка.Заголовок = Новый ФорматированнаяСтрока(Подстроки);
	
КонецПроцедуры

Функция РезультатПроверкиСчетаКонтрагентаОшибка(Форма)
	
	Подстроки = Новый Массив;
	
	Подстроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Возможно, платежные реквизиты уплаты налога указаны неверно'"),
		, ЦветаСтиля.ПоясняющийПроблемуТекст));
	Если Не Форма.ТолькоПросмотр Тогда
		Подстроки.Добавить("  ");
		Подстроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Исправить'")
			,,,, "e1cib/app/Документ.ПлатежноеПоручение.Форма.ФормаПроверкиПлатежныхРеквизитов"));
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(Подстроки);
	
КонецФункции

#КонецОбласти

#Область ПроверкаПлатежейВБюджет

Процедура НайтиОшибкиПлатежаВБюджет(Форма, ПредыдущаяДата = '0001-01-01') Экспорт
	
	Объект = Форма.Объект;
	
	Форма.АдресОшибок = ""; // Устанавливает реквизит формы
	
	Если НЕ Объект.ПеречислениеВБюджет Тогда
		Возврат;
	КонецЕсли;
	
	Если ПлатежиВБюджетКлиентСервер.ДействуетПриказ107н(ПредыдущаяДата) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПлатежиВБюджетКлиентСервер.ДействуетПриказ107н(Объект.Дата) Тогда
		Возврат;
	КонецЕсли;
	
	Ошибки = Документы.ПлатежноеПоручение.ПроверитьЗаполнениеРеквизитовДляПеречисленияВБюджет(Объект, Ложь);
	Если Ошибки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Форма.ПоместитьВоВременноеХранилище(Ошибки, Форма.УникальныйИдентификатор);
	
КонецПроцедуры

Функция ПроверитьРеквизитыПередЗаписью(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	Результат = Новый Структура;
	Результат.Вставить("ПредупредитьОбОшибках",        Ложь);
	Результат.Вставить("ПредупредитьДублиУИН",         Ложь);
	Результат.Вставить("ПредупредитьУИНСодержитБуквы", Ложь);
	Результат.Вставить("ИнформацияДублиУИН",           "");
	Результат.Вставить("ИнформацияУИНСодержитБуквы",   "");
	
	// Проверяем все, кроме УИН и выводим перечень ошибок
	Ошибки = Документы.ПлатежноеПоручение.ПроверитьЗаполнениеРеквизитовДляПеречисленияВБюджет(
		Объект, Истина, Ложь, НЕ Форма.СчетПоГосконтракту,
		Форма.КонтекстПлатежногоДокумента);
	
	// Проверяем дубли УИН
	ДублиУИН = ПлатежиВБюджет.ПроверитьДублиУИН(Объект.ИдентификаторПлатежа, Объект.Ссылка);
	
	// Проверяем, что после начала действия формата ГИС ГМП версии 1.16.1, в УИН не в формате 1.15 (с буквами)
	УИНСодержитБуквы = НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Объект.ИдентификаторПлатежа);
	
	Если Ошибки.Количество() > 0 Тогда
		
		// Информацию о дублях УИН выводим среди других ошибок
		Для каждого Ошибка Из ДублиУИН Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Ошибка.Описание, Объект.Ссылка);
		КонецЦикла;
		
		Результат.ПредупредитьОбОшибках = Истина;
		
	ИначеЕсли ДублиУИН.Количество() > 0 Тогда
		
		// Информацию о дублях УИН выводим отдельно
		Результат.ПредупредитьДублиУИН = Истина;
		
		ТекстыСообщений = Новый Массив;
		Для каждого ОписаниеОшибки Из ДублиУИН Цикл
			ТекстыСообщений.Добавить(ОписаниеОшибки.Описание);
		КонецЦикла;
		
		Результат.ИнформацияДублиУИН = СтрСоединить(ТекстыСообщений, Символы.ПС);
		
	ИначеЕсли УИНСодержитБуквы Тогда
		
		Результат.ПредупредитьУИНСодержитБуквы = Истина;
		
		Результат.ИнформацияУИНСодержитБуквы = НСтр("ru = 'Уникальный идентификатор начисления содержит буквы.
			|С 1 октября 2015 г. идентификатор должен содержать только цифры.
			|Буквы допускаются при оплате по старым идентификаторам.'");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИсточникДанныхКонтекстаПлатежногоДокумента(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	ИсточникДанныхКонтекста = Новый Структура;
	ИсточникДанныхКонтекста.Вставить("Период",                      Объект.Дата);
	Если Месяц(Объект.Дата) = Месяц(Форма.ПредыдущаяДата)
		И ПлатежиВБюджетКлиентСервер.РеквизитЗаполнен(Объект.ПоказательПериода) Тогда
		
		ПоказателиПериода = ПлатежиВБюджетКлиентСервер.РазобратьНалоговыйПериод(Объект.ПоказательПериода);
		ВидНалога = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Налог, "ВидНалога");
		
		Если ПлатежиВБюджетКлиентСерверПереопределяемый.ЭтоНалогУСН(ВидНалога) Тогда
			ИсточникДанныхКонтекста.Вставить("ПериодПлатежа",
				УчетУСН.НалоговыйПериодПоДаннымПлатежногоДокумента(ПоказателиПериода, Объект.Дата, Объект.Организация));
		Иначе
			ИсточникДанныхКонтекста.Вставить("ПериодПлатежа", ПоказателиПериода.Дата);
		КонецЕсли;
	КонецЕсли;
	ИсточникДанныхКонтекста.Вставить("Организация",                 Объект.Организация);
	ИсточникДанныхКонтекста.Вставить("Налогоплательщик",            Объект.Налогоплательщик);
	ИсточникДанныхКонтекста.Вставить("КПППлательщика",              Объект.КПППлательщика);
	ИсточникДанныхКонтекста.Вставить("Получатель",                  Объект.Контрагент);
	ИсточникДанныхКонтекста.Вставить("СчетПолучателя",              Объект.СчетКонтрагента);
	ИсточникДанныхКонтекста.Вставить("Налог",                       Объект.Налог);
	ИсточникДанныхКонтекста.Вставить("ВидНалоговогоОбязательства",  Объект.ВидНалоговогоОбязательства);
	ИсточникДанныхКонтекста.Вставить("РегистрацияВНалоговомОргане", Неопределено);
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалогаЗаТретьихЛиц Тогда
		ИсточникДанныхКонтекста.Вставить("КодБК", Объект.КодБК);
	КонецЕсли;
	
	Возврат ИсточникДанныхКонтекста;
	
КонецФункции

#КонецОбласти

#Область УстановкаПараметровВыбора

Процедура УстановитьОграничениеТипаКонтрагента(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	МассивПараметрыВыбора = Новый Массив;
	МассивПараметрыВыбора.Добавить(Новый ПараметрВыбора("ОткрытИзПлатежки", Истина));
	МассивПараметрыВыбора.Добавить(Новый ПараметрВыбора("СоздаватьНовогоПоИНН", Истина));
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ВозвратПокупателю
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ОплатаПоставщику
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеЗП
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалогаЗаТретьихЛиц
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПрочееСписание
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПрочиеРасчетыСКонтрагентами
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.РасчетыПоКредитамИЗаймам
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ВозвратЗайма
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ВозвратКредита
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ВыдачаЗаймаКонтрагенту Тогда
		Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ВыдачаЗаймаРаботнику
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеЗаработнойПлатыРаботнику
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеДепонентов
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ЛичныеСредстваПредпринимателя
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеПодотчетномуЛицу
		ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеСотрудникуПоДоговоруПодряда Тогда
		Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеДивидендов Тогда
		Если Форма.КонтрагентЮрФизЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо Тогда
			НовыйПараметр = Новый ПараметрВыбора("Отбор.ЮридическоеФизическоеЛицо",
				ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо"));
			МассивПараметрыВыбора.Добавить(НовыйПараметр);
			Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
		Иначе
			МассивПараметрыВыбора.Очистить();
			Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
		КонецЕсли;
	Иначе
		Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов("Неопределено");
	КонецЕсли;
	
	Объект.Контрагент = Элементы.Контрагент.ОграничениеТипа.ПривестиЗначение(Объект.Контрагент);
	Элементы.Контрагент.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметрыВыбора);
	
КонецПроцедуры

Процедура УстановитьПараметрыВыбораБанковскихСчетов(Форма) Экспорт
	
	ВладелецСчетаКонтрагента = ВладелецСчетаКонтрагента(Форма);
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	ЭтоИнтерфейсИнтеграцииСБанком = ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком();
	
	Элементы = Форма.Элементы;
	
	НовыйМассивПараметров = Новый Массив;
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", ВалютаРегламентированногоУчета));
	Если ЭтоИнтерфейсИнтеграцииСБанком Тогда
		НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка",
			Справочники.НастройкиИнтеграцииСБанками.БанковскиеСчетаОрганизацииВРежимеИнтеграции(Форма.Объект.Организация)));
	КонецЕсли;
	
	Элементы.СчетОрганизации.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);
	Если Элементы.Найти("СчетОрганизацииИнтеграцияСБанком") <> Неопределено Тогда
		Элементы.СчетОрганизацииИнтеграцияСБанком.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);
	КонецЕсли;
	
	НовыйМассивПараметров = Новый Массив();
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", ВалютаРегламентированногоУчета));
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", ВладелецСчетаКонтрагента));
	Элементы.СчетКонтрагента.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);
	
КонецПроцедуры

Функция ВладелецСчетаКонтрагента(Форма)
	
	Объект = Форма.Объект;
	Если Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПереводНаДругойСчет Тогда
		Возврат Объект.Организация;
	Иначе
		Возврат ?(Форма.ПеречислениеФизическомуЛицу И НЕ Форма.ПеречислениеНаЛичныйСчет, Объект.Банк, Объект.Контрагент);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ПравилоУплатыНалогов

Процедура ЗаполнитьПравилоУплатыНалоговИзПараметровФормы(Форма, Параметры) Экспорт
	
	// При создании платежки из списка задач бухгалтера заполняем правило и период события
	Если Параметры.Свойство("ПериодСобытия") Тогда
		
		Если ТипЗнч(Параметры.Правило) = Тип("СправочникСсылка.ПравилаПредставленияОтчетовУплатыНалогов")
			ИЛИ ТипЗнч(Параметры.Правило) = Тип("СправочникСсылка.Патенты") Тогда
			Форма.ПравилоУплатыНалогов            = Параметры.Правило;
			Форма.ПериодСобытияКалендаря          = Параметры.ПериодСобытия;
		Иначе
			Форма.ПравилоРегулярногоПлатежа       = Параметры.Правило;
			Форма.ПериодСобытияРегулярногоПлатежа = Параметры.ПериодСобытия;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеРеквизитовОбъекта

Процедура УстановитьСчетКонтагентаПоГосконтракту(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		РеквизитыСчетаОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Объект.СчетОрганизации, "ГосударственныйКонтракт, ВалютаДенежныхСредств");
		СчетКонтрагента = Справочники.БанковскиеСчета.БанковскийСчетПоГосОбронЗаказу(
			Объект.Контрагент,
			РеквизитыСчетаОрганизации.ГосударственныйКонтракт,
			РеквизитыСчетаОрганизации.ВалютаДенежныхСредств);
		Если ЗначениеЗаполнено(СчетКонтрагента) Тогда
			Объект.СчетКонтрагента = СчетКонтрагента;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ИдентификаторГосконтактаПоСчету(ОтдельныйСчет) Экспорт
	
	Идентификатор = "";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ОтдельныйСчет);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	БанковскиеСчета.ГосударственныйКонтракт.Код КАК Идентификатор
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Идентификатор = Выборка.Идентификатор;
	КонецЕсли;
	
	Возврат Идентификатор;
	
КонецФункции

Процедура ПроверитьИзменитьКПППлательщика(Форма) Экспорт
	
	Если Форма.ОрганизацияЮрФизЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
		Возврат;
	КонецЕсли;
	
	Объект = Форма.Объект;
	
	Если НЕ ЗначениеЗаполнено(Объект.Налог) ИЛИ ПлатежиВБюджетКлиентСервер.ПлатежАдминистрируетсяНалоговымиОрганами(Объект.КодБК) Тогда
		Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
			СведенияОКонтрагенте = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Контрагент, "ГосударственныйОрган, ВидГосударственногоОргана");
			Если СведенияОКонтрагенте.ГосударственныйОрган 
				И СведенияОКонтрагенте.ВидГосударственногоОргана = Перечисления.ВидыГосударственныхОрганов.НалоговыйОрган Тогда
				
				РегистрацияВНалоговомОргане = Справочники.РегистрацииВНалоговомОргане.НайтиРегистрациюВНалоговомОргане(Объект.Организация, Объект.Контрагент);
				Если ЗначениеЗаполнено(РегистрацияВНалоговомОргане) Тогда
					Объект.КПППлательщика = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегистрацияВНалоговомОргане, "КПП");
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПерезаполнитьСтатьюДДС(Форма) Экспорт
	
	Объект = Форма.Объект;
	КонтекстОперации = Объект.ВидОперации;
	Если Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога
		И (Объект.ВидНалоговогоОбязательства = Перечисления.ВидыПлатежейВГосБюджет.Налог 
			ИЛИ Объект.ВидНалоговогоОбязательства = Перечисления.ВидыПлатежейВГосБюджет.НалогАкт
			ИЛИ Объект.ВидНалоговогоОбязательства = Перечисления.ВидыПлатежейВГосБюджет.НалогСам) Тогда
			
		ВидНалога = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Налог, "ВидНалога");
		Если ВидНалога = Перечисления.ВидыНалогов.НалогНаПрибыль_РегиональныйБюджет
			ИЛИ ВидНалога = Перечисления.ВидыНалогов.НалогНаПрибыль_ФедеральныйБюджет Тогда
			КонтекстОперации = "НалогНаПрибыль";
		КонецЕсли;
		
	КонецЕсли;
	
	Объект.СтатьяДвиженияДенежныхСредств = УчетДенежныхСредствБП.СтатьяДДСПоУмолчанию(КонтекстОперации);
	
КонецПроцедуры

Процедура ПроверитьИзменитьНастройкуПлатежаВБюджет(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	// Ничего не делаем, если на документ помечен на удаление.
	Если Объект.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	// Проверку производим только:
	//  - для вида операции "Уплата налога";
	//  - Налог заполнен;
	//  - это не предопределенный налог "ПрочиеНалогиИСборы", по которому могут отражать множество "прочих" налогов (и поэтому нет смысла запоминать его настройки);
	//  - это уплата налога (взноса), т.к. все остальные виды платежа являются "единичными" и требуют ручной обработки.
	
	Если Объект.ВидОперации <> Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога
		ИЛИ НЕ ЗначениеЗаполнено(Объект.Налог)
		ИЛИ Объект.Налог = Справочники.ВидыНалоговИПлатежейВБюджет.ПрочиеНалогиИСборы
		ИЛИ Объект.ВидНалоговогоОбязательства <> Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
		Возврат;
	КонецЕсли;
	
	РегистрацияВНалоговомОргане = Документы.ПлатежноеПоручение.РегистрацияВНалоговомОрганеПоДаннымПлатежногоПоручения(
		Объект.Организация, Объект.Контрагент, Объект.КПППлательщика);
	
	РеквизитыОбъекта = ПлатежиВБюджетНастройки.РеквизитыПлатежногоДокумента();
	ЗаполнитьЗначенияСвойств(РеквизитыОбъекта, Объект);
	РеквизитыОбъекта.КодТерритории = Объект.КодОКАТО;
	
	ПоказателиПериода = ПлатежиВБюджетПереопределяемый.ПоказателиПериода();
	
	Если Форма.КонтекстПлатежногоДокумента = Неопределено Тогда
		Форма.КонтекстПлатежногоДокумента = Документы.ПлатежноеПоручение.КонтекстПлатежногоДокумента(Объект);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ПоказателиПериода, Форма.КонтекстПлатежногоДокумента);
	РеквизитыОбъекта.Вставить("ПоказателиПериода", ПоказателиПериода);
	
	РеквизитыВБюджетПоУмолчанию = Документы.ПлатежноеПоручение.РеквизитыПлатежногоПорученияВБюджетПоУмолчанию(
		Объект.Дата,
		Объект.Организация,
		Объект.ПеречислениеВБюджет,
		Объект.Налог,
		Объект.ВидНалоговогоОбязательства,
		Форма.КонтекстПлатежногоДокумента,
		РегистрацияВНалоговомОргане);
	
	НастройкиТребующиеИзменения = ПлатежиВБюджетНастройки.ПроверитьНастройкуПлатежаВБюджет(
		РеквизитыОбъекта, РеквизитыВБюджетПоУмолчанию, РегистрацияВНалоговомОргане);
	Если ПлатежиВБюджетНастройки.НастройкиИзменились(НастройкиТребующиеИзменения.ИзмененныеНастройки) Тогда
		ПлатежиВБюджетНастройки.СоздатьИзменитьНастройкуПлатежаВБюджет(
			РеквизитыОбъекта, НастройкиТребующиеИзменения, РеквизитыВБюджетПоУмолчанию);
	КонецЕсли;
	
КонецПроцедуры

Функция АвтоЗначенияРеквизитов(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	ПереводМеждуСчетами = ПереводНаДругойСчет(Объект);
	УплатаНалогаЗаТретьихЛиц = УплатаНалогаЗаТретьихЛиц(Объект);
	
	АвтоЗначенияРеквизитов = УчетДенежныхСредствБП.СформироватьАвтоЗначенияРеквизитовПлательщикаПолучателя(
		?(УплатаНалогаЗаТретьихЛиц, Объект.Налогоплательщик, Объект.Организация),
		Объект.СчетОрганизации,
		?(ПереводМеждуСчетами, Объект.Организация, ?(Форма.ПеречислениеФизическомуЛицу И НЕ Форма.ПеречислениеНаЛичныйСчет, Объект.Банк, Объект.Контрагент)),
		Объект.СчетКонтрагента,
		Объект.ПеречислениеВБюджет,
		Объект.Дата);
	
	Возврат АвтоЗначенияРеквизитов;
	
КонецФункции

Процедура ЗаполнитьРеквизитыПолучателяПоАвтоЗначениямРеквизитов(Форма, АвтоЗначенияРеквизитов, ИзменениеКонтрагента) Экспорт
	
	Объект = Форма.Объект;
	
	Если ИзменениеКонтрагента ИЛИ ПустаяСтрока(Объект.КПППолучателя) <> ПустаяСтрока(АвтоЗначенияРеквизитов.КПППолучателя) Тогда
		ЗаполнитьЗначенияСвойств(Объект, АвтоЗначенияРеквизитов, "ТекстПолучателя, ИННПолучателя, КПППолучателя", "");
	Иначе
		ЗаполнитьЗначенияСвойств(Объект, АвтоЗначенияРеквизитов, "ТекстПолучателя");
	КонецЕсли;
	
	ПлатежноеПоручениеФормы.ЗаполнитьРеквизитыСчетаПолучателя(Форма);
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПлательщикаПоАвтоЗначениямРеквизитов(Форма, АвтоЗначенияРеквизитов, ИзменениеОрганизации) Экспорт
	
	Объект = Форма.Объект;
	
	Если ИзменениеОрганизации ИЛИ ПустаяСтрока(Объект.КПППлательщика) <> ПустаяСтрока(АвтоЗначенияРеквизитов.КПППлательщика) Тогда
		ЗаполнитьЗначенияСвойств(Объект, АвтоЗначенияРеквизитов, "ТекстПлательщика, ИННПлательщика, КПППлательщика", "");
	Иначе
		ЗаполнитьЗначенияСвойств(Объект, АвтоЗначенияРеквизитов, "ТекстПлательщика");
	КонецЕсли;
	
	Форма.НадписьРеквизитыПлательщика = ПлатежноеПоручениеФормыКлиентСервер.УстановитьНадписьРеквизитыПлательщика(Форма);
	
	Если Объект.ПеречислениеВБюджет
		И НЕ УплатаНалогаЗаТретьихЛиц(Объект)
		И ИзменениеОрганизации Тогда
		
		СтруктураРеквизитов = Документы.ПлатежноеПоручение.РеквизитыПлатежногоПорученияВБюджетПоУмолчанию(
			Объект.Дата,
			Объект.Организация,
			Объект.ПеречислениеВБюджет,
			Объект.Налог,
			Объект.ВидНалоговогоОбязательства,
			,
			,
			Объект.СчетКонтрагента);
		
		Объект.СтатусСоставителя = СтруктураРеквизитов.СтатусСоставителя;
		Форма.НадписьРеквизитыПлатежейВБюджет = ПлатежноеПоручениеФормыКлиентСервер.НадписьРеквизитыПлатежейВБюджет(Форма);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыСчетаПолучателя(Форма) Экспорт

	Объект = Форма.Объект;
	
	Если ЗначениеЗаполнено(Объект.СчетКонтрагента) Тогда
		РеквизитыБанка = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.СчетКонтрагента, "Банк.Код,Банк.Страна");
		Форма.СчетПолучателяБИКБанка = РеквизитыБанка.БанкКод;
		Форма.СчетПолучателяВБанкеРФ = РеквизитыБанка.БанкСтрана = Справочники.СтраныМира.Россия;
	Иначе
		Форма.СчетПолучателяБИКБанка = "";
		Форма.СчетПолучателяВБанкеРФ = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Функция РеквизитыГосударственногоОрганаПоКППОрганизации(Организация, КППОрганизации) Экспорт
	
	РегистрацияВНалоговомОргане = Справочники.РегистрацииВНалоговомОргане.НайтиПоКПП(Организация, КППОрганизации);
	Если ЗначениеЗаполнено(РегистрацияВНалоговомОргане) Тогда
		Возврат ДанныеГосударственныхОрганов.ГосударственныйОрган(
			Перечисления.ВидыГосударственныхОрганов.НалоговыйОрган, РегистрацияВНалоговомОргане.Код);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Процедура УстановитьРеквизитыДляПлатежаВБюджет(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	Объект.СтавкаНДС = Перечисления.СтавкиНДС.ПустаяСсылка();
	Объект.СуммаНДС  = 0;
	Если Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога Тогда
		Объект.ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОпределитьЮрФизЛицо(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		Форма.ОрганизацияЮрФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Организация, "ЮридическоеФизическоеЛицо");
		Форма.СчетПоГосконтракту   = ЗначениеЗаполнено(Объект.СчетОрганизации) И
			ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СчетОрганизации, "ГосударственныйКонтракт"));
	Иначе
		Форма.ОрганизацияЮрФизЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
		Форма.СчетПоГосконтракту   = Ложь;
	КонецЕсли;
	
	Если УчетДенежныхСредствКлиентСервер.РасчетыСФизическимиЛицами(Объект.ВидОперации)
		ИЛИ ТипЗнч(Объект.Контрагент) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Форма.КонтрагентЮрФизЛицо  = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПереводНаДругойСчет Тогда
		Форма.КонтрагентЮрФизЛицо  = Форма.ОрганизацияЮрФизЛицо;
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеДивидендов Тогда
		Если ТипЗнч(Объект.Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
			Форма.КонтрагентЮрФизЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
		Иначе
			Форма.КонтрагентЮрФизЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Форма.КонтрагентЮрФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Контрагент, "ЮридическоеФизическоеЛицо");
	Иначе
		Форма.КонтрагентЮрФизЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СостояниеДокумента

Процедура УстановитьСостояниеДокумента(Форма) Экспорт
	
	Форма.СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Форма.Объект);
	
КонецПроцедуры

Процедура НастройкаДиректБанк(ЕстьНастройкаДиректБанк, Знач Организация, Знач БанковскийСчет, СписокВыбора) Экспорт
	
	Банк = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БанковскийСчет, "Банк");
	
	ЕстьНастройкаДиректБанк = ОбменСБанками.НастройкаОбмена(Организация, Банк) <> Неопределено;
	
	СписокВыбора.Добавить(Перечисления.СостоянияБанковскихДокументов.Подготовлено);
	СписокВыбора.Добавить(Перечисления.СостоянияБанковскихДокументов.Отправлено);
	СписокВыбора.Добавить(Перечисления.СостоянияБанковскихДокументов.Оплачено);
	СписокВыбора.Добавить(Перечисления.СостоянияБанковскихДокументов.Отклонено);
	Если ЕстьНастройкаДиректБанк Тогда
		
		СписокВыбора.Добавить(Перечисления.СостоянияБанковскихДокументов.НаПодписи);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПодготовкаФормы

Процедура ОтобразитьПредупреждениеОЗаполненииРеквизитовСчета(Форма) Экспорт
	
	Форма.Элементы.ПредупреждениеОЗаполненииРеквизитовСчета.Видимость = ПроверкаРеквизитовОрганизацииКлиентСервер.ПоказатьПредупреждениеОРеквизитахСчета(Форма, Форма.Объект.Организация);
	
КонецПроцедуры

Процедура УстановитьФункциональныеОпцииФормы(Форма) Экспорт
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(Форма);
	
КонецПроцедуры

#КонецОбласти
