#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СрокПредупрежденияОЗавершенииПодписки = Обработки.ОплатаСервиса.СрокПредупрежденияОЗавершенииПодписки();
	
	Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	
	УчетДенежныхСредствБП.УстановитьБанковскийСчет(БанковскийСчет, Организация, Константы.ВалютаРегламентированногоУчета.Получить());
	
	СпособОплаты = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ВРег("ОплатаСервиса"), ВРег("СпособОплаты"));
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеВыставленногоСчета = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища("ОплатаСервиса",
		"ИдентификаторСчетаПокупателю,ИдентификаторСчетаПоставщика,
		|НовыйТарифНаименование,НовыйТарифДополнительнаяИнформация,
		|НовыйТарифИдентификатор,ТекущийТарифИдентификатор,ТекущийТарифСрокДействия,
		|ПлатежнаяСсылка, Сообщение");
	УстановитьПривилегированныйРежим(Ложь);
	
	ИдентификаторСчетаПокупателю       = ДанныеВыставленногоСчета.ИдентификаторСчетаПокупателю;
	ИдентификаторСчетаПоставщика       = ДанныеВыставленногоСчета.ИдентификаторСчетаПоставщика;
	НовыйТарифНаименование             = ДанныеВыставленногоСчета.НовыйТарифНаименование;
	НовыйТарифДополнительнаяИнформация = ДанныеВыставленногоСчета.НовыйТарифДополнительнаяИнформация;
	НовыйТарифИдентификатор            = ДанныеВыставленногоСчета.НовыйТарифИдентификатор;
	ТекущийТарифИдентификатор          = ДанныеВыставленногоСчета.ТекущийТарифИдентификатор;
	ТекущийТарифСрокДействия           = ДанныеВыставленногоСчета.ТекущийТарифСрокДействия;
	ПлатежнаяСсылка                    = ДанныеВыставленногоСчета.ПлатежнаяСсылка;
	Сообщение                          = ДанныеВыставленногоСчета.Сообщение;
	
	СчетПоставщика = Обработки.ОплатаСервиса.НайтиСчетПоставщика(ИдентификаторСчетаПоставщика);
	
	РеквизитыДляОплаты = РеквизитыДляОплаты(СчетПоставщика);
	
	ФоновоеЗаданиеПолучениеТарифов = ФоновоеЗаданиеПолучениеТарифов(УникальныйИдентификатор);
	ФоновоеЗаданиеПолучениеТекущегоТарифа = ФоновоеЗаданиеПолучениеТекущегоТарифа(УникальныйИдентификатор);
	
	ВыбранныйТариф = Параметры.ВыбранныйТариф;
	
	Если ЗначениеЗаполнено(ВыбранныйТариф) Тогда
		НовыйТарифНаименование = ВыбранныйТариф;
		СохранитьДанныеВыставленногоСчета(ЭтотОбъект);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокСсылкиВозвратаКВладельцу) Тогда
		Элементы.Вернуться.Заголовок = Параметры.ЗаголовокСсылкиВозвратаКВладельцу;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.Вернуться.Видимость = ВладелецФормы <> Неопределено;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.Интервал = 1;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультатПолученияТарифов", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗаданиеПолучениеТарифов, ОповещениеОЗавершении, ПараметрыОжидания);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.Интервал = 1;
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВыполнятьОднократно", Истина);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультатПолученияТекущегоТарифа", ЭтотОбъект, ДополнительныеПараметры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗаданиеПолучениеТекущегоТарифа, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Организации" Тогда
		Если Источник = Организация Тогда
			БанковскийСчет = ОсновнойБанковскийСчетОрганизации(Организация);
			УправлениеФормой(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ПродлитьТариф(Команда)
	
	ОжиданиеОплатыВПлатежнойСистеме = Ложь;
	
	ИдентификаторСтроки = Число(СтрЗаменить(Команда.Имя, "ВариантПродления", ""));
	
	НовыйТариф = ВариантыПродления.НайтиПоИдентификатору(ИдентификаторСтроки);
	НовыйТарифНаименование             = НовыйТариф.Наименование;
	НовыйТарифДополнительнаяИнформация = ПредставлениеЦены(НовыйТариф.Цена);
	НовыйТарифИдентификатор            = НовыйТариф.Идентификатор;
	
	СохранитьДанныеВыставленногоСчета(ЭтотОбъект);
	
	НачатьВыставлениеСчета();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ОтменаНаСервере();
	
	Оповестить("ОплатаСервиса_Изменение");
	
КонецПроцедуры

&НаСервере
Процедура ОтменаНаСервере()
	
	ОжиданиеОплатыВПлатежнойСистеме = Ложь;
	
	ОтменитьСчетПоставщика(СчетПоставщика);
	
	ОчиститьИнформациюОВыставленномСчете();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РаспечататьСчет(Команда)
	
	ИдентификаторПечатнойФормы = "ПечатнаяФорма";
	НазваниеПечатнойФормы = НСтр("ru = 'Счет поставщика'");
	
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(ИдентификаторПечатнойФормы);
	ПечатнаяФорма = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, ИдентификаторПечатнойФормы);
	ПечатнаяФорма.СинонимМакета = НазваниеПечатнойФормы;
	ПечатнаяФорма.ТабличныйДокумент = ПолучитьПрисоединенныйТабличныйДокумент(СчетПоставщика);
	ПечатнаяФорма.ИмяФайлаПечатнойФормы = НазваниеПечатнойФормы;
	
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм);
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьБанковскийСчет(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", Организация);
	
	ФормаОрганизации = ПолучитьФорму("Справочник.Организации.ФормаОбъекта", ПараметрыФормы);
	
	// Чтобы обратить внимание пользователя на реквизиты основного банковского счета,
	// спозиционируемся в форме организации на поле НомерСчета.
	ЭлементНомерСчета = ФормаОрганизации.Элементы.Найти("Банк");
	Если ЭлементНомерСчета <> Неопределено Тогда
		ФормаОрганизации.ТекущийЭлемент = ЭлементНомерСчета;
	КонецЕсли;
	ФормаОрганизации.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспечататьПлатежноеПоручение(Команда)
	
	ПлатежноеПоручение = СоздатьПлатежноеПоручение(СчетПоставщика);
	
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(ПлатежноеПоручение);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ПлатежноеПоручение", "ПлатежноеПоручение", МассивОбъектов, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПлатежноеПоручениеВБанк(Команда)
	
	ПлатежноеПоручение = СоздатьПлатежноеПоручение(СчетПоставщика);
	
	СписокДокументов = Новый СписокЗначений;
	СписокДокументов.ЗагрузитьЗначения(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПлатежноеПоручение));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СписокДокументов", СписокДокументов);
	
	ОткрытьФорму("Обработка.КлиентБанк.Форма", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Вернуться(Команда)
	
	Попытка
		ОткрытьФорму(ВладелецФормы);
	Исключение
		ОткрытьФорму("Обработка.ПодготовкаНулевойОтчетности.Форма");
	КонецПопытки;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьПлатежнойКартой(Команда)
	
	ПерейтиПоНавигационнойСсылке(ПлатежнаяСсылка);
	
	ОжиданиеОплатыВПлатежнойСистеме = Истина;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СпособОплатыПриИзменении(Элемент)
	
	СохранитьВыбранныйСпособОплаты(СпособОплаты);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДругиеТарифыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуВыбораТарифа();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОПродленииПодпискиПояснениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьВыборТарифа" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуВыбораТарифа();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Продление = ЭтоПродление(Форма);
	
	ТарифНеОпределен = Форма.ТекущийТарифИдентификатор = ИдентификаторНеопределенногоТарифа();
	
	БанковскийСчетЗаполнен = НЕ Форма.БанковскийСчет.Пустая();
	ОжиданиеОплаты         = НЕ Форма.СчетПоставщика.Пустая();
	
	ПолученСписокТарифов = Форма.Тарифы.Количество() > 0;
	ПолученТекущийТариф  = ЗначениеЗаполнено(Форма.ТекущийТарифИдентификатор);
	ИдетПолучениеСчета   = ЗначениеЗаполнено(Форма.ИдентификаторЗаданияВыставлениеСчета);
	
	Ожидание = НЕ ПолученСписокТарифов
		ИЛИ НЕ ПолученТекущийТариф
		ИЛИ ИдетПолучениеСчета;
	
	ОжиданиеОплатыВПлатежнойСистеме = Форма.ОжиданиеОплатыВПлатежнойСистеме;
	
	ПодпискаЗаканчивается = РазностьДат(Форма.ТекущийТарифСрокДействия,
		ТекущаяДата()) <= Форма.СрокПредупрежденияОЗавершенииПодписки;
	
	Элементы = Форма.Элементы;
	
	Форма.Заголовок = ?(Ожидание И НЕ Форма.ОшибкаСвязи, НСтр("ru='Пожалуйста, подождите...'"), НСтр("ru='Оплата сервиса / Продление'"));
	
	Элементы.ГруппаОжидание.Видимость = Ожидание И НЕ Форма.ОшибкаСвязи;
	Элементы.ГруппаОсновное.Видимость = НЕ Ожидание;
	Элементы.ГруппаВозвратКВладельцу.Видимость = НЕ Элементы.ГруппаОжидание.Видимость;
	
	Элементы.ГруппаОшибкаСвязи.Видимость = Форма.ОшибкаСвязи;
	
	Элементы.ТекущийТарифДополнительнаяИнформация.Видимость = НЕ ТарифНеОпределен;
	Элементы.ДлительнаяОперация.Видимость                   = ТарифНеОпределен;
	
	Элементы.ГруппаПродлениеТарифа.Видимость = НЕ ОжиданиеОплаты;
	
	Элементы.ГруппаНовыйТарифКонтейнер.Видимость = ОжиданиеОплаты;
	Элементы.ГруппаОплата.Видимость              = ОжиданиеОплаты И НЕ ОжиданиеОплатыВПлатежнойСистеме;
	
	Элементы.ГруппаОжиданиеОплаты.Видимость = ОжиданиеОплатыВПлатежнойСистеме;
	
	Элементы.ДекорацияНовыйТариф.Видимость      = НЕ Продление;
	Элементы.ДекорацияПродлениеТарифа.Видимость = Продление;
	
	Форма.ТекущийТарифДополнительнаяИнформация = ?(Форма.ТекущийТарифСрокДействия = Дата(1,1,1),
		НСтр("ru='Бесплатно'"),
		СтрШаблон("До %1%2",
			Формат(Форма.ТекущийТарифСрокДействия, "ДЛФ=DD"),
			?(ПодпискаЗаканчивается,
				" (" + ОстатокДней(Форма.ТекущийТарифСрокДействия) + ")",
				"")));
	
	Форма.ИнформацияОПродленииПодписки = СтрШаблон(НСтр("ru='Подписка заканчивается: %1'"),
		ОстатокДней(Форма.ТекущийТарифСрокДействия));
		
	Форма.ИнформацияОПродленииПодпискиПояснение = ?(Элементы.ГруппаПродлениеТарифа.ПодчиненныеЭлементы.Количество() = 0,
		Новый ФорматированнаяСтрока(НСтр("ru='Рекомендуется перейти на '"),
			Новый ФорматированнаяСтрока(НСтр("ru='платный тариф'"),,,, "ОткрытьВыборТарифа")),
		НСтр("ru='Рекомендуется продлить подписку.'"));
	
	Элементы.ГруппаПродлениеПодписки.Видимость = НЕ Ожидание И НЕ ОжиданиеОплатыВПлатежнойСистеме И ПодпискаЗаканчивается;
	
	Элементы.Сообщение.Видимость = ЗначениеЗаполнено(Форма.Сообщение);
	
	ОплатаПлатежнойКартой  = Форма.СпособОплаты = "ОплатаПлатежнойКартой";
	ОплатаСРасчетногоСчета = Форма.СпособОплаты = "ОплатаСРасчетногоСчета";
	ОплатаСЛичногоСчета    = Форма.СпособОплаты = "ОплатаСЛичногоСчета";
	ОплатаНаличными        = Форма.СпособОплаты = "ОплатаНаличными";
	
	Элементы.РаспечататьСчет.Видимость = ОплатаСРасчетногоСчета ИЛИ ОплатаНаличными;
	
	Элементы.ЗаголовокОплата.Видимость   = НЕ Продление;
	Элементы.ИнформацияПоОплате.Видимость = НЕ Продление И НЕ ОплатаПлатежнойКартой;
	Элементы.ИнформацияПоОплатеКартой.Видимость = НЕ Продление И ОплатаПлатежнойКартой;
	
	Элементы.ЗаголовокПродление.Видимость    = Продление;
	Элементы.ИнформацияПоПродлению.Видимость = Продление И НЕ ОплатаПлатежнойКартой;
	Элементы.ИнформацияПоПродлениюКартой.Видимость = Продление И ОплатаПлатежнойКартой;
	
	Элементы.ОплатитьПлатежнойКартой.Видимость = ОплатаПлатежнойКартой;
	
	Элементы.РекомендацияПоОплатеСчета.Видимость            = ОплатаСРасчетногоСчета;
	Элементы.РекомендацияПоОплатеСРасчетногоСчета.Видимость = ОплатаСРасчетногоСчета;
	Элементы.РекомендацияПоОплатеНаличными.Видимость        = ОплатаНаличными;
	
	Элементы.РекомендацияПоУказаниюБанковскогоСчета.Видимость = ОплатаСРасчетногоСчета И НЕ БанковскийСчетЗаполнен;
	Элементы.УказатьБанковскийСчет.Видимость                  = ОплатаСРасчетногоСчета И НЕ БанковскийСчетЗаполнен;
	
	Элементы.РаспечататьПлатежноеПоручение.Видимость    = ОплатаСРасчетногоСчета И БанковскийСчетЗаполнен;
	Элементы.ОтправитьПлатежноеПоручениеВБанк.Видимость = ОплатаСРасчетногоСчета И БанковскийСчетЗаполнен;
	
	Элементы.РеквизитыДляОплаты.Видимость = ОплатаСЛичногоСчета;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораТарифа(РезультатВыбораТарифа, ВходящийКонтекст) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РезультатВыбораТарифа) Тогда
		Возврат;
	КонецЕсли;
	
	ОжиданиеОплатыВПлатежнойСистеме = Ложь;
	
	НовыйТарифНаименование = РезультатВыбораТарифа;
	
	НайденныеТарифы = Тарифы.НайтиСтроки(Новый Структура("Наименование", РезультатВыбораТарифа));
	
	Если НайденныеТарифы.Количество() > 0 Тогда
		НовыйТарифДополнительнаяИнформация = ПредставлениеЦены(НайденныеТарифы[0].Цена);
		НовыйТарифИдентификатор = НайденныеТарифы[0].Идентификатор;
	КонецЕсли;
	
	СохранитьДанныеВыставленногоСчета(ЭтотОбъект);
	
	НачатьВыставлениеСчета();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьВыставлениеСчета()
	
	ИдентификаторЗаданияВыставлениеСчета = Строка(Новый УникальныйИдентификатор);
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИдентификаторЗадания", ИдентификаторЗаданияВыставлениеСчета);
	ПараметрыПроцедуры.Вставить("Организация",          Организация);
	ПараметрыПроцедуры.Вставить("Тариф",                НовыйТарифНаименование);
	ПараметрыПроцедуры.Вставить("Продление",            ЭтоПродление(ЭтотОбъект));
	ФоновоеЗаданиеНачатьВыставлениеСчета = ФоновоеЗаданиеНачатьВыставлениеСчета(ПараметрыПроцедуры, УникальныйИдентификатор);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.Интервал = 1;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультатНачалаВыставленияСчета", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗаданиеНачатьВыставлениеСчета, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ФоновоеЗаданиеНачатьВыставлениеСчета(ПараметрыПроцедуры, УникальныйИдентификатор)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru='Начать выставление счета'");
	Возврат ДлительныеОперации.ВыполнитьВФоне("Обработки.ОплатаСервиса.НачатьВыставлениеСчетаВФоне",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультатНачалаВыставленияСчета(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		РезультатВыполнения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		
		Если РезультатВыполнения = "Ошибка" Тогда
			ИдентификаторЗаданияВыставлениеСчета = Неопределено;
			ОбработатьОшибкуСвязи();
		Иначе
			ОшибкаСвязи = Ложь;
			СчетчикОбращений = 0;
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыставлениеСчета", 1, Истина);
		КонецЕсли;
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		ЗаписатьОшибкуВЖурналРегистрации(Результат.ПодробноеПредставлениеОшибки);
		ИдентификаторЗаданияВыставлениеСчета = Неопределено;
		ОбработатьОшибкуСвязи();
		
	КонецЕсли;
	
	ФоновоеЗаданиеНачатьВыставлениеСчета = Неопределено;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыставлениеСчета()
	
	Если СчетчикОбращений >= 60 Тогда
		ЗаписатьОшибкуВЖурналРегистрации(НСтр("ru='Исчерпано допустимое число попыток получения результата из менеджера сервиса'"));
		ОбработатьОшибкуСвязи();
		ИдентификаторЗаданияВыставлениеСчета = Неопределено;
		УправлениеФормой(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИдентификаторЗадания", ИдентификаторЗаданияВыставлениеСчета);
	ПараметрыПроцедуры.Вставить("Организация",          Организация);
	ФоновоеЗаданиеПроверитьВыставлениеСчета = ФоновоеЗаданиеПроверитьВыставлениеСчета(ПараметрыПроцедуры, УникальныйИдентификатор);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.Интервал = 1;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультатПроверкиВыставленияСчета", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗаданиеПроверитьВыставлениеСчета, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ФоновоеЗаданиеПроверитьВыставлениеСчета(ПараметрыПроцедуры, УникальныйИдентификатор)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru='Проверить выставление счета'");
	Возврат ДлительныеОперации.ВыполнитьВФоне("Обработки.ОплатаСервиса.ПроверитьВыставлениеСчетаВФоне",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультатПроверкиВыставленияСчета(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		РезультатОбработки = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		
		Если РезультатОбработки = "Ошибка" Тогда
			
			ОбработатьОшибкуСвязи();
			ИдентификаторЗаданияВыставлениеСчета = Неопределено;
			
			НовыйТарифИдентификатор = Неопределено;
			НовыйТарифНаименование = Неопределено;
			НовыйТарифДополнительнаяИнформация = Неопределено;
			ПлатежнаяСсылка = Неопределено;
			Сообщение = Неопределено;
			
			СохранитьДанныеВыставленногоСчета(ЭтотОбъект);
			
		ИначеЕсли ТипЗнч(РезультатОбработки) = Тип("Структура") Тогда
			
			ОтменитьСчетПоставщика(СчетПоставщика);
			
			ИдентификаторСчетаПокупателю = РезультатОбработки.ИдентификаторСчетаПокупателю;
			ИдентификаторСчетаПоставщика = РезультатОбработки.ИдентификаторСчетаПоставщика;
			СчетПоставщика               = РезультатОбработки.Ссылка;
			ПлатежнаяСсылка              = РезультатОбработки.ПлатежнаяСсылка;
			Сообщение                    = РезультатОбработки.Сообщение;
			
			Если ЗначениеЗаполнено(ПлатежнаяСсылка) Тогда
				СпособОплаты = "ОплатаПлатежнойКартой";
			КонецЕсли;
			
			УстановитьСписокСпособовОплаты(ЭтотОбъект);
			
			СохранитьДанныеВыставленногоСчета(ЭтотОбъект);
			
			РеквизитыДляОплаты = РеквизитыДляОплаты(СчетПоставщика);
			
			ИдентификаторЗаданияВыставлениеСчета = Неопределено;
			
			ПодключитьОбработчикОжидания("Подключаемый_ПолучитьТекущийТариф", 1, Истина);
			
			Оповестить("ОплатаСервиса_Изменение");
			
		Иначе
			
			СчетчикОбращений = СчетчикОбращений + 1;
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыставлениеСчета", 1, Истина);
			
		КонецЕсли;
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		ОбработатьОшибкуСвязи();
		
		ЗаписатьОшибкуВЖурналРегистрации(Результат.ПодробноеПредставлениеОшибки);
		
		НовыйТарифИдентификатор = Неопределено;
		НовыйТарифНаименование = Неопределено;
		НовыйТарифДополнительнаяИнформация = Неопределено;
		
		СохранитьДанныеВыставленногоСчета(ЭтотОбъект);
		
	КонецЕсли;
	
	ФоновоеЗаданиеПроверитьВыставлениеСчета = Неопределено;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РеквизитыДляОплаты(Знач Ссылка)
	
	Результат = "";
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СчетНаОплатуПоставщика.СуммаДокумента КАК СуммаДокумента,
		|	СчетНаОплатуПоставщика.БанковскийСчетКонтрагента.НомерСчета КАК БанковскийСчетКонтрагентаНомерСчета,
		|	СчетНаОплатуПоставщика.БанковскийСчетКонтрагента.Банк.Код КАК БанковскийСчетКонтрагентаБанкКод,
		|	СчетНаОплатуПоставщика.БанковскийСчетКонтрагента.Банк.Наименование КАК БанковскийСчетКонтрагентаБанкНаименование,
		|	СчетНаОплатуПоставщика.Контрагент.ИНН КАК КонтрагентИНН,
		|	СчетНаОплатуПоставщика.Контрагент.НаименованиеПолное КАК КонтрагентНаименованиеПолное,
		|	СчетНаОплатуПоставщика.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
		|	СчетНаОплатуПоставщика.ДатаВходящегоДокумента КАК ДатаВходящегоДокумента,
		|	СчетНаОплатуПоставщика.Организация.НаименованиеСокращенное КАК ОрганизацияНаименованиеСокращенное
		|ИЗ
		|	Документ.СчетНаОплатуПоставщика КАК СчетНаОплатуПоставщика
		|ГДЕ
		|	СчетНаОплатуПоставщика.Ссылка = &Ссылка";
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
		
			Сумма             = Формат(Выборка.СуммаДокумента, "ЧГ=");
			РасчетныйСчет     = Выборка.БанковскийСчетКонтрагентаНомерСчета;
			БИК               = Выборка.БанковскийСчетКонтрагентаБанкКод;
			Банк              = Выборка.БанковскийСчетКонтрагентаБанкНаименование;
			ИНН               = Выборка.КонтрагентИНН;
			ПолучательПлатежа = Выборка.КонтрагентНаименованиеПолное;
			НазначениеПлатежа = СтрШаблон("Оплата по счету %1 от %2 %3",
			                  	Выборка.НомерВходящегоДокумента,
			                  	Формат(Выборка.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy"),
			                  	Выборка.ОрганизацияНаименованиеСокращенное);
			
			Шаблон = "             Сумма: %1
			         |    Расчетный счет: %2
			         |               БИК: %3
			         |              Банк: %4
			         |               ИНН: %5
			         |Получатель платежа: %6
			         |Назначение платежа: %7";
			
			Результат = СтрШаблон(Шаблон,
				Сумма,
				РасчетныйСчет,
				БИК,
				Банк,
				ИНН,
				ПолучательПлатежа,
				НазначениеПлатежа);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПрисоединенныйТабличныйДокумент(Ссылка)
	
	РасширениеТабличногоДокумента = "mxl";
	
	МассивПрисоединенныхФайлов = Новый Массив;
	ПрисоединенныеФайлы.ПолучитьПрикрепленныеФайлыКОбъекту(Ссылка, МассивПрисоединенныхФайлов);
	
	Для каждого ПрисоединенныйФайл Из МассивПрисоединенныхФайлов Цикл
		
		Если ПрисоединенныйФайл.Расширение = РасширениеТабличногоДокумента Тогда
			
			ДанныеТабличногоДокумента = ПрисоединенныеФайлы.ПолучитьДвоичныеДанныеФайла(ПрисоединенныйФайл);
			ИмяФайла = ПолучитьИмяВременногоФайла(РасширениеТабличногоДокумента);
			ДанныеТабличногоДокумента.Записать(ИмяФайла);
			ТабличныйДокумент = Новый ТабличныйДокумент;
			ТабличныйДокумент.Прочитать(ИмяФайла);
			
			ТабличныйДокумент.ТолькоПросмотр      = Истина;
			ТабличныйДокумент.АвтоМасштаб         = Истина;
			ТабличныйДокумент.ОриентацияСтраницы  = ОриентацияСтраницы.Портрет;
			ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
			ТабличныйДокумент.ОтображатьСетку     = Ложь;
			
			Возврат ТабличныйДокумент;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Новый ТабличныйДокумент;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура СохранитьДанныеВыставленногоСчета(Форма)
	
	СохранитьДанныеВыставленногоСчетаНаСервере(
		Новый Структура("НовыйТарифНаименование,НовыйТарифДополнительнаяИнформация,НовыйТарифИдентификатор,
			|ТекущийТарифИдентификатор,ТекущийТарифСрокДействия,
			|ИдентификаторСчетаПокупателю,ИдентификаторСчетаПоставщика,
			|ПлатежнаяСсылка,
			|Сообщение,
			|ОшибкаСвязи",
		Форма.НовыйТарифНаименование,
		Форма.НовыйТарифДополнительнаяИнформация,
		Форма.НовыйТарифИдентификатор,
		Форма.ТекущийТарифИдентификатор,
		Форма.ТекущийТарифСрокДействия,
		Форма.ИдентификаторСчетаПокупателю,
		Форма.ИдентификаторСчетаПоставщика,
		Форма.ПлатежнаяСсылка,
		Форма.Сообщение,
		Форма.ОшибкаСвязи));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьДанныеВыставленногоСчетаНаСервере(Знач ДанныеВыставленногоСчета)
	
	УстановитьПривилегированныйРежим(Истина);
	Для каждого Элемент Из ДанныеВыставленногоСчета Цикл
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище("ОплатаСервиса", Элемент.Значение, Элемент.Ключ);
	КонецЦикла;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьПлатежноеПоручение(Знач СчетПоставщика)
	
	Результат = Документы.ПлатежноеПоручение.НайтиПоРеквизиту("ДокументОснование", СчетПоставщика);
	
	Если Результат.Пустая() Тогда
		
		РеквизитыСчетаПоставщика = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СчетПоставщика,
			"НомерВходящегоДокумента,ДатаВходящегоДокумента");
		
		НомерИДатаСчета = РеквизитыСчетаПоставщика.НомерВходящегоДокумента
			+ " от "
			+ Формат(РеквизитыСчетаПоставщика.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy");
		
		НовоеПлатежноеПоручение = Документы.ПлатежноеПоручение.СоздатьДокумент();
		НовоеПлатежноеПоручение.Заполнить(СчетПоставщика);
		НовоеПлатежноеПоручение.НазначениеПлатежа = СтрЗаменить(НовоеПлатежноеПоручение.НазначениеПлатежа,
			НомерИДатаСчета,
			НомерИДатаСчета + " за право использования программного продукта.");
		
		НовоеПлатежноеПоручение.ДополнительныеСвойства.Вставить("НеПроверятьОграничения");
		НовоеПлатежноеПоручение.Записать(РежимЗаписиДокумента.Проведение);
		
		РегистрыСведений.ДокументыИнтеграцииСБанком.ОтправитьОповещениеОбИзмененииПоДокументамВФоне(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(НовоеПлатежноеПоручение.Ссылка));
		
		Результат = НовоеПлатежноеПоручение.Ссылка;
		
	КонецЕсли;
	
	// Актуализация даты платежного поручения
	Если Результат.Дата <> ТекущаяДатаСеанса() Тогда
		ПлатежноеПоручение = Результат.ПолучитьОбъект();
		ПлатежноеПоручение.Дата = ТекущаяДатаСеанса();
		ПлатежноеПоручение.ДополнительныеСвойства.Вставить("НеПроверятьОграничения");
		ПлатежноеПоручение.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьСчетПоставщика(Знач Ссылка)
	
	Если Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.СтатусыДокументов.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Документ.Установить(Ссылка);
	
	Запись = НаборЗаписей.Добавить();
	Запись.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Организация");
	Запись.Документ    = Ссылка;
	Запись.Статус      = Перечисления.СтатусОплатыСчета.Отменен;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьИнформациюОВыставленномСчете()
	
	ИдентификаторСчетаПокупателю       = Неопределено;
	ИдентификаторСчетаПоставщика       = Неопределено;
	НовыйТарифНаименование             = Неопределено;
	НовыйТарифДополнительнаяИнформация = Неопределено;
	НовыйТарифИдентификатор            = Неопределено;
	СчетПоставщика                     = Неопределено;
	
	СохранитьДанныеВыставленногоСчета(ЭтотОбъект);
	
	РеквизитыДляОплаты = РеквизитыДляОплаты(СчетПоставщика);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОсновнойБанковскийСчетОрганизации(Знач Организация)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ОсновнойБанковскийСчет");
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаписатьОшибкуВЖурналРегистрации(Знач ОписаниеОшибки)
	
	Событие = НСтр("ru='Оплата сервиса.Ошибка'");
	Уровень = УровеньЖурналаРегистрации.Ошибка;
	ОбъектМетаданных = Метаданные.Обработки.ОплатаСервиса;
	
	ЗаписьЖурналаРегистрации(Событие, Уровень, ОбъектМетаданных,, ОписаниеОшибки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьВыбранныйСпособОплаты(Знач СпособОплаты)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ВРег("ОплатаСервиса"), ВРег("СпособОплаты"), СпособОплаты);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСписокСпособовОплаты(Форма)
	
	СписокВыбора = Форма.Элементы.СпособОплаты.СписокВыбора;
	
	СписокВыбора.Очистить();
	
	Если (ЭтоПродление(Форма) ИЛИ ЭтоТестовыйТариф(Форма))
		И ЗначениеЗаполнено(Форма.ПлатежнаяСсылка) Тогда
		СписокВыбора.Добавить("ОплатаПлатежнойКартой", НСтр("ru='Платежной картой'"));
	КонецЕсли;
	
	СписокВыбора.Добавить("ОплатаСРасчетногоСчета", НСтр("ru='С расчетного счета'"));
	СписокВыбора.Добавить("ОплатаСЛичногоСчета", НСтр("ru='С личного счета через онлайн-банк'"));
	СписокВыбора.Добавить("ОплатаНаличными", НСтр("ru='Наличными в отделении банка'"));
	
	Если СписокВыбора.НайтиПоЗначению(Форма.СпособОплаты) = Неопределено Тогда
		Форма.СпособОплаты = СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОстатокДней(Период)
	
	ОстатокДней = РазностьДат(Период, ТекущаяДата());
	
	Если ОстатокДней < 1 Тогда
		Результат = НСтр("ru='сегодня последний день'");
	ИначеЕсли ОстатокДней < 2 Тогда
		Результат = НСтр("ru='завтра последний день'");
	Иначе
		ПараметрыПредметаИсчисления = "день,дня,дней,м,,,,,0";
		Результат = ?(Прав(ОстатокДней, 1) = "1", НСтр("ru='остался '"), НСтр("ru='осталось '")) +
			СтрЗаменить(ЧислоПрописью(ОстатокДней, "Л=ru_RU; НД=Ложь", ПараметрыПредметаИсчисления),
				ЧислоПрописью(ОстатокДней, "Л=ru_RU; НП=Ложь; НД=Ложь", ПараметрыПредметаИсчисления),
				ОстатокДней);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РазностьДат(Дата1, Дата2)
	
	Возврат (КонецДня(Дата1) - КонецДня(Дата2)) / 86400;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеЦены(Цена)
	
	Возврат СтрШаблон("%1 %2",
		Цена,
		Символ(8381));
	
КонецФункции

#Область Тарификация

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоПродление(Форма)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Наименование", Форма.НовыйТарифНаименование);
	НайденныеСтроки = Форма.ВариантыПродления.НайтиСтроки(ПараметрыОтбора);
	Возврат НайденныеСтроки.Количество() > 0;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоТестовыйТариф(Форма)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Идентификатор", Форма.ТекущийТарифИдентификатор);
	НайденныеСтроки = Форма.Тарифы.НайтиСтроки(ПараметрыОтбора);
	Возврат НайденныеСтроки.Количество() = 0;
	
КонецФункции

&НаСервереБезКонтекста
Функция ФоновоеЗаданиеПолучениеТарифов(Знач УникальныйИдентификатор)
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru='Получение списка тарифов'");
	Возврат ДлительныеОперации.ВыполнитьВФоне("Обработки.ОплатаСервиса.ПолучитьТарифыВФоне",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультатПолученияТарифов(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ОбработатьОшибкуСвязи();
	КонецЕсли;
	
	ОбработатьРезультатПолученияТарифовНаСервере(Результат, ДополнительныеПараметры);
	
	ОбработатьВыбранныйТариф();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультатПолученияТарифовНаСервере(Результат, ДополнительныеПараметры)
	
	Если Результат.Статус = "Выполнено" Тогда
		
		ДанныеXML = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		ПрочитатьТарифы(ДанныеXML);
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		ЗаписатьОшибкуВЖурналРегистрации(Результат.ПодробноеПредставлениеОшибки);
		
	КонецЕсли;
	
	СоздатьВариантыПродления();
	
	УстановитьСписокСпособовОплаты(ЭтотОбъект);
	
	ФоновоеЗаданиеПолучениеТарифов = Неопределено;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьТарифы(ДанныеXML)
	
	ТаблицаТарифов = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ДанныеXML).Данные;
	Тарифы.Загрузить(ТаблицаТарифов);
	
КонецПроцедуры

&НаСервере
Процедура СоздатьВариантыПродления()
	
	Префикс = "ВариантПродления";
	
	Для каждого Команда Из Команды Цикл
		Если Лев(Команда.Имя, 16) = Префикс Тогда
			Команды.Удалить(Команда);
		КонецЕсли;
	КонецЦикла;
	
	УдаляемыеЭлементы = Новый Массив;
	Для каждого Элемент Из Элементы.ГруппаПродлениеТарифа.ПодчиненныеЭлементы Цикл
		УдаляемыеЭлементы.Добавить(Элемент);
	КонецЦикла;
	
	Для каждого Элемент Из УдаляемыеЭлементы Цикл
		Элементы.Удалить(Элемент);
	КонецЦикла;
	
	СтруктураОтбора = Новый Структура("Идентификатор", ТекущийТарифИдентификатор);
	ВариантыПродленияТарифа = Тарифы.НайтиСтроки(СтруктураОтбора);
	
	Если ВариантыПродленияТарифа.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ВариантПродленияТарифа Из ВариантыПродленияТарифа Цикл
	
		ВариантПродления = ВариантыПродления.Добавить();
		ЗаполнитьЗначенияСвойств(ВариантПродления, ВариантПродленияТарифа);
		
		ИмяЭлемента = Префикс + ВариантПродления.ПолучитьИдентификатор();
		
		КомандаПродления = Команды.Добавить(ИмяЭлемента);
		КомандаПродления.Действие = "Подключаемый_ПродлитьТариф";
		КомандаПродления.Заголовок = СтрШаблон(НСтр("ru='Продлить за %1
			|на %2'"),
			ПредставлениеЦены(ВариантПродления.Цена),
			ВариантПродления.Период);
		
		КнопкаПродления = Элементы.Добавить(ИмяЭлемента,
			Тип("КнопкаФормы"),
			Элементы.ГруппаПродлениеТарифа);
		КнопкаПродления.ИмяКоманды = ИмяЭлемента;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолучитьТекущийТариф()
	
	ФоновоеЗаданиеПолучениеТекущегоТарифа = ФоновоеЗаданиеПолучениеТекущегоТарифа(УникальныйИдентификатор);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.Интервал = 1;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультатПолученияТекущегоТарифа", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗаданиеПолучениеТекущегоТарифа, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ФоновоеЗаданиеПолучениеТекущегоТарифа(УникальныйИдентификатор)
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru='Получение текущего тарифа'");
	Возврат ДлительныеОперации.ВыполнитьВФоне("Обработки.ОплатаСервиса.ПолучитьТекущийТарифВФоне",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультатПолученияТекущегоТарифа(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ФоновоеЗаданиеПолучениеТекущегоТарифа = Неопределено;
	
	ВыполнятьОднократно = Ложь;
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
	   И ДополнительныеПараметры.Свойство("ВыполнятьОднократно") Тогда
		ВыполнятьОднократно = ДополнительныеПараметры.ВыполнятьОднократно;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		РезультатВыполнения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		
		Если НЕ ЗначениеЗаполнено(РезультатВыполнения.Идентификатор) Тогда
			РезультатВыполнения.Идентификатор = ИдентификаторНеопределенногоТарифа();
		КонецЕсли;
		
		ТарифНеОпределен = РезультатВыполнения.Идентификатор = ИдентификаторНеопределенногоТарифа();
		Если ТарифНеОпределен Тогда
			Если ВыполнятьОднократно Тогда
				ЗаписатьОшибкуВЖурналРегистрации(НСтр("ru='Менеджер сервиса не передал текущий тариф'"));
				Ожидание = Ложь;
				ОбработатьОшибкуСвязи();
				УправлениеФормой(ЭтотОбъект);
			Иначе
				ПодключитьОбработчикОжидания("Подключаемый_ПолучитьТекущийТариф", 1, Истина);
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
		Если РезультатВыполнения.Идентификатор <> ТекущийТарифИдентификатор
		 ИЛИ РезультатВыполнения.СрокДействия <> ТекущийТарифСрокДействия Тогда
			
			ОбработатьИзменениеТарифаНаСервере(РезультатВыполнения);
			
			ОбработатьВыбранныйТариф();
			
		КонецЕсли;
		
		ВыбранНовыйТариф = НЕ ПустаяСтрока(НовыйТарифИдентификатор);
		
		Если ВыбранНовыйТариф Тогда
			ПодключитьОбработчикОжидания("Подключаемый_ПолучитьТекущийТариф", 1, Истина);
			Возврат;
		КонецЕсли;
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		ЗаписатьОшибкуВЖурналРегистрации(Результат.ПодробноеПредставлениеОшибки);
		ОбработатьОшибкуСвязи();
		
		УправлениеФормой(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеТарифаНаСервере(РезультатВыполнения)
	
	ВыбранНовыйТариф = НЕ ПустаяСтрока(НовыйТарифИдентификатор);
	
	Если ВыбранНовыйТариф Тогда
		ОчиститьИнформациюОВыставленномСчете();
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	ТекущийТарифИдентификатор = РезультатВыполнения.Идентификатор;
	ТекущийТарифСрокДействия = РезультатВыполнения.СрокДействия;
	
	СоздатьВариантыПродления();
	
	СохранитьДанныеВыставленногоСчета(ЭтотОбъект);
	
	ОжиданиеОплатыВПлатежнойСистеме = Ложь;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыбранныйТариф()
	
	Если НЕ ПустаяСтрока(ВыбранныйТариф)
		И Тарифы.Количество() > 0 
		И ЗначениеЗаполнено(ТекущийТарифИдентификатор) Тогда
		Тариф = ВыбранныйТариф;
		ВыбранныйТариф = Неопределено;
		ОбработкаВыбораТарифа(Тариф, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИдентификаторНеопределенногоТарифа()
	
	Возврат НСтр("ru='Получение информации о тарифе...'");
	
КонецФункции

&НаКлиенте
Процедура ОбработатьОшибкуСвязи()
	
	ОшибкаСвязи = Истина;
	СохранитьДанныеВыставленногоСчета(ЭтотОбъект);
	Оповестить("ОплатаСервиса_Изменение");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораТарифа()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораТарифа", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОткрыватьФормуОплаты", Ложь);
	
	ОткрытьФорму("Обработка.ОплатаСервиса.Форма.ВыборТарифа", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти