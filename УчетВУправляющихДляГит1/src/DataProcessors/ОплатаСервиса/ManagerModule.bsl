#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает Истина, если в информационной базе есть неоплаченный счет поставщика
// на оплату сервиса.
//
// Возвращаемое значение:
//  Булево - признак наличия выставленного счета на оплату сервиса
//
Функция ЕстьВыставленныйСчетНаОплатуСервиса() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	СохраненныеДанные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища("ОплатаСервиса",
		"ИдентификаторСчетаПоставщика, ОшибкаСвязи");
		ИдентификаторСчетаПоставщика = СохраненныеДанные.ИдентификаторСчетаПоставщика;
		ОшибкаСвязи = СохраненныеДанные.ОшибкаСвязи;
	УстановитьПривилегированныйРежим(Ложь);
	
	// Если при попытке выставить счет произошла ошибка связи,
	// считаем, что счет успешно выставлен, чтобы не блокировать работу пользователя.
	Если ОшибкаСвязи = Истина Тогда
		Возврат Истина;
	КонецЕсли;
	
	СчетПоставщика = НайтиСчетПоставщика(ИдентификаторСчетаПоставщика);
	
	Возврат НЕ СчетПоставщика.Пустая();
	
КонецФункции

// Возвращает ссылку на счет поставщика по уникальному идентификатору.
// Если счет по переданному идентификатору не найден, возвращается пустая ссылка.
//
// Параметры:
// - УникальныйИдентификатор - строка - уникальный идентификатор
//
// Возвращаемое значение:
//  СчетНаОплатуПоставщикаСсылка - ссылка на счет поставщика
//
Функция НайтиСчетПоставщика(УникальныйИдентификатор) Экспорт
	
	Если НЕ ЗначениеЗаполнено(УникальныйИдентификатор) Тогда
		Возврат Документы.СчетНаОплатуПоставщика.ПустаяСсылка();
	КонецЕсли;
	
	СчетПоставщика = Документы.СчетНаОплатуПоставщика.ПолучитьСсылку(УникальныйИдентификатор);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", СчетПоставщика);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК КоличествоСтрок
	|ИЗ
	|	Документ.СчетНаОплатуПоставщика.Товары КАК СчетНаОплатуПоставщикаТовары
	|ГДЕ
	|	СчетНаОплатуПоставщикаТовары.Ссылка = &Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	
	КоличествоСтрокВСчете = ?(Выборка.Следующий(), Выборка.КоличествоСтрок, 0);
	
	Если КоличествоСтрокВСчете > 0 Тогда
		Возврат СчетПоставщика;
	Иначе
		Возврат Документы.СчетНаОплатуПоставщика.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

// Возвращает остаток дней подписки, при котором должно выдаваться предупреждение
// о том, что подписка заканчивается
//
// Возвращаемое значение:
//  Число - максимальное количество дней подписки, при котором выдается предупреждение
//
Функция СрокПредупрежденияОЗавершенииПодписки() Экспорт
	
	Возврат 15; // дней
	
КонецФункции

// Проверяет доступность оплаты сервиса, выводит в интерфейс обработку оплаты.
//
Процедура НастроитьИнтерфейсОплатыСервиса(ДоступнаОплата) Экспорт
	
	НаборКонстант = Константы.СоздатьНабор("ИнтерфейсТакси, ИнтерфейсТаксиПростой");
	НаборКонстант.Прочитать();
	
	Если ДоступнаОплата Тогда
		Константы.ОплатаПолныйИнтерфейс.Установить(НаборКонстант.ИнтерфейсТакси);
		Константы.ОплатаПростойИнтерфейс.Установить(НаборКонстант.ИнтерфейсТаксиПростой);
	Иначе
		Константы.ОплатаПростойИнтерфейс.Установить(Ложь);
		Константы.ОплатаПолныйИнтерфейс.Установить(Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет наличие возможности оплаты сервиса
// 
// Возвращаемое значение:
//  Булево - Истина, если пользователь может оплатить сервис
//
Функция ДоступнаОплатаСервиса() Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ПолучитьФункциональнуюОпцию("ОплатаПолныйИнтерфейс")
		Или ПолучитьФункциональнуюОпцию("ОплатаПростойИнтерфейс");
	
КонецФункции

#КонецОбласти

#Область ВзаимодействиеССерверомВФоне

Процедура ПроверитьОкончаниеПодпискиВФоне(Параметры, АдресРезультата) Экспорт
	
	ТекущийТариф = ТарификацияБП.ТекущийТариф();
	
	Если НЕ ПустаяСтрока(ТекущийТариф.Идентификатор) Тогда
		ОстатокСрока = (КонецДня(ТекущийТариф.СрокДействия) - КонецДня(ТекущаяДата())) / 86400;
		ПодпискаЗавершается = ОстатокСрока <= СрокПредупрежденияОЗавершенииПодписки();
	Иначе
		ПодпискаЗавершается = Ложь;
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(ПодпискаЗавершается, АдресРезультата);
	
КонецПроцедуры

Процедура ПолучитьТарифыВФоне(Параметры, АдресРезультата) Экспорт
	
	Попытка
		
		Ссылка = ТарификацияБП.АдресТаблицыТарифов();
		
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(Ссылка);
		ЗащищенноеСоединение = ?(Нрег(СтруктураURI.Схема) = "https", Новый ЗащищенноеСоединениеOpenSSL, Неопределено);
		Соединение = Новый HTTPСоединение(СтруктураURI.ИмяСервера,,,,,, ЗащищенноеСоединение);
		Результат = Соединение.Получить(Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере)).ПолучитьТелоКакСтроку();
		
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
		
	Исключение
		ЗаписатьОшибкуВЖурналРегистрации(ОписаниеОшибки());
	КонецПопытки
	
КонецПроцедуры

Процедура ПолучитьТекущийТарифВФоне(Параметры, АдресРезультата) Экспорт
	
	Результат = ТарификацияБП.ТекущийТариф();
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ПолучитьОписаниеТарифовВФоне(Параметры, АдресРезультата) Экспорт
	
	Попытка
		
		Ссылка = ТарификацияБП.АдресСтраницыВыбораТарифов();
		
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(Ссылка);
		Соединение = Новый HTTPСоединение(СтруктураURI.ИмяСервера,,,,,, Новый ЗащищенноеСоединениеOpenSSL);
		Результат = Соединение.Получить(Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере)).ПолучитьТелоКакСтроку();
		
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
		
	Исключение
		ЗаписатьОшибкуВЖурналРегистрации(ОписаниеОшибки());
	КонецПопытки
	
КонецПроцедуры

Процедура НачатьВыставлениеСчетаВФоне(Параметры, АдресРезультата) Экспорт
	
	ИдентификаторЗадания = Параметры.ИдентификаторЗадания;
	Организация          = Параметры.Организация;
	Тариф                = Параметры.Тариф;
	Продление            = Параметры.Продление;
	
	АдресДанных = Справочники.Организации.СформироватьКарточкиОрганизацииВXML(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Организация))[0].АдресВоВременномХранилище;
	РеквизитыCML = Base64Строка(ПолучитьИзВременногоХранилища(АдресДанных));
	
	МассивДокументов = Новый Массив;
	МассивДокументов.Добавить(Организация);
	ТабличныйДокумент = Справочники.Организации.СформироватьРеквизитыОрганизации(МассивДокументов,
		Новый СписокЗначений, "Реквизиты");
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ТабличныйДокумент.Записать(ИмяВременногоФайла, ТипФайлаТабличногоДокумента.XLS);
	РеквизитыXLS = Base64Строка(Новый ДвоичныеДанные(ИмяВременногоФайла));
	УдалитьФайлы(ИмяВременногоФайла);
	
	ДанныеЗапроса = Новый Структура;
	ДанныеЗапроса.Вставить("id",               ИдентификаторЗадания);
	ДанныеЗапроса.Вставить("zone",             РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
	ДанныеЗапроса.Вставить("appName",          НаименованиеПриложения());
	ДанныеЗапроса.Вставить("tariff",           Тариф);
	ДанныеЗапроса.Вставить("renewal",          Продление);
	ДанныеЗапроса.Вставить("clientDetailsCML", РеквизитыCML);
	ДанныеЗапроса.Вставить("clientDetailsXLS", РеквизитыXLS);
	
	Попытка
		
		Ответ = ОтправитьДанныеВМенеджерСервиса(ИмяРесурсаМенеджераСервиса(), ДанныеЗапроса);
		
		Если Ответ.КодСостояния = 201 Тогда
			Результат = ИдентификаторЗадания;
		Иначе
			ЗаписатьОшибкуВЖурналРегистрации(СтрШаблон(НСтр("ru='Менеджер сервиса: %1 - %2'"),
				Ответ.КодСостояния,
				Ответ.ПолучитьТелоКакСтроку()));
			Результат = "Ошибка";
		КонецЕсли;
		
	Исключение
		
		ЗаписатьОшибкуВЖурналРегистрации(ОписаниеОшибки());
		Результат = "Ошибка";
		
	КонецПопытки;
		
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ПроверитьВыставлениеСчетаВФоне(Параметры, АдресРезультата) Экспорт
	
	ИдентификаторЗадания = Параметры.ИдентификаторЗадания;
	Организация          = Параметры.Организация;
	
	Попытка
		
		Результат = Неопределено;
		
		Ответ = ПолучитьДанныеИзМенеджераСервиса(ИмяРесурсаМенеджераСервиса() + ИдентификаторЗадания);
		
		Если Ответ.КодСостояния = 200 Тогда
			
			ОтветJSON = Ответ.ПолучитьТелоКакСтроку();
			
			ЧтениеJSON = Новый ЧтениеJSON;
			ЧтениеJSON.УстановитьСтроку(ОтветJSON);
			ДанныеОтвета = ПрочитатьJSON(ЧтениеJSON);
			ЧтениеJSON.Закрыть();
			
			Если НЕ ПустаяСтрока(ДанныеОтвета.status) Тогда
			
				КодСостоянияПрокси = Лев(ДанныеОтвета.status, 3);
				
				Если КодСостоянияПрокси = "200" Тогда // Получен ответ учетной системы.
					
					Если ДанныеОтвета.processingError Тогда
						
						ВызватьИсключение СтрШаблон(НСтр("ru='Учетная система: %1 - %2'"), ДанныеОтвета.processingErrorCode, ДанныеОтвета.processingStatus);
						
					Иначе
						
						Результат = Новый Структура("Ссылка, ИдентификаторСчетаПокупателю, ИдентификаторСчетаПоставщика, ПлатежнаяСсылка, Сообщение");
						
						Для каждого Файл из ДанныеОтвета.files Цикл
							
							МассивЧастейИмениФайла = СтрРазделить(Файл.name, ".");
							РасширениеФайла = МассивЧастейИмениФайла[МассивЧастейИмениФайла.ВГраница()];
							
							Если РасширениеФайла = "xml" Тогда
								
								УстановитьПривилегированныйРежим(Истина);
								ИмяФайла = РаботаВМоделиСервиса.ПолучитьФайлИзХранилищаМенеджераСервиса(Файл.id);
								УстановитьПривилегированныйРежим(Ложь);
								
								ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяФайла);
								АдресФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
								
								АдресаФайловXML = Новый Массив;
								АдресаФайловXML.Добавить(АдресФайла);
								ДанныеДокументов = Документы.СчетНаОплатуПокупателю.РазобратьСчетаНаОплатуПокупателюXML(АдресаФайловXML);
								
								РеквизитыКонтрагента = ДанныеДокументов[0].ДанныеДокумента.РеквизитыКонтрагента;
								Контрагент = Справочники.Контрагенты.СоздатьКонтрагента(РеквизитыКонтрагента);
								
								Товары     = ДанныеДокументов[0].ДанныеДокумента.Товары;
								НомерСчета = ДанныеДокументов[0].НомерСчета;
								ДатаСчета  = ДанныеДокументов[0].ДатаСчета;
								
								Результат.Ссылка = СоздатьСчетНаОплатуПоставщика(Организация, Контрагент, Товары, НомерСчета, ДатаСчета);
								Результат.ИдентификаторСчетаПокупателю = ДанныеДокументов[0].ДанныеДокумента.ИдентификаторДокумента;
								Результат.ИдентификаторСчетаПоставщика = Результат.Ссылка.УникальныйИдентификатор();
								
							КонецЕсли;
							
						КонецЦикла;
						
						Если Результат.Ссылка = Неопределено Тогда
							ВызватьИсключение НСтр("ru='Не обнаружен электронный счет на оплату (xml)'");
						КонецЕсли;
						
						Для каждого Файл из ДанныеОтвета.files Цикл
							
							ИдентификаторФайла = Файл.id;
							ИмяФайла = Файл.name;
							
							УстановитьПривилегированныйРежим(Истина);
							ИмяВременногоФайла = РаботаВМоделиСервиса.ПолучитьФайлИзХранилищаМенеджераСервиса(ИдентификаторФайла);
							УстановитьПривилегированныйРежим(Ложь);
							
							ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяВременногоФайла);
							АдресФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
							
							РасширениеФайла = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла);
							РасширениеБезТочки = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(РасширениеФайла);
							ИмяФайлаБезРасшрения = Лев(ИмяФайла, СтрДлина(ИмяФайла) - СтрДлина(РасширениеФайла));
							
							ПараметрыФайла = Новый Структура;
							ПараметрыФайла.Вставить("Автор", Пользователи.АвторизованныйПользователь());
							ПараметрыФайла.Вставить("ВладелецФайлов", Результат.Ссылка);
							ПараметрыФайла.Вставить("ИмяБезРасширения", ИмяФайлаБезРасшрения);
							ПараметрыФайла.Вставить("РасширениеБезТочки", РасширениеБезТочки);
							ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное");
							РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресФайла);
							
						КонецЦикла;
						
						Если ДанныеОтвета.Свойство("paymentLink") Тогда
							Результат.ПлатежнаяСсылка = ДанныеОтвета.paymentLink;
						КонецЕсли;
						
						Если ДанныеОтвета.Свойство("message") Тогда
							Результат.Сообщение = ДанныеОтвета.message;
						КонецЕсли;
						
					КонецЕсли;
					
				ИначеЕсли КодСостоянияПрокси = "201" Тогда
					
					// Запрос принят учетной системой, ожидание ответа.
					
				Иначе // Не удалось передать запрос.
					
					ВызватьИсключение НСтр("ru='Менеджер сервиса: '") + ДанныеОтвета.status;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		
		ЗаписатьОшибкуВЖурналРегистрации(ОписаниеОшибки());
		Результат = "Ошибка";
		
	КонецПопытки;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаВМоделиСервиса

Функция ПолучитьДанныеИзМенеджераСервиса(Ресурс)
	
	Адрес = ВнутреннийАдресМенеджераСервиса() + Ресурс;
	ДанныеСервера = ОбщегоНазначенияКлиентСервер.СтруктураURI(Адрес);
	
	Соединение = СоединениеСМенеджеромСервиса(ДанныеСервера);
	
	Запрос = Новый HTTPЗапрос(ДанныеСервера.ПутьНаСервере);
	
	Возврат Соединение.Получить(Запрос);
	
КонецФункции

Функция ОтправитьДанныеВМенеджерСервиса(Ресурс, СтруктураДанных)
	
	JSON = ПолучитьJSON(СтруктураДанных);
	
	Заголовки = Новый Соответствие; 
	Заголовки["Accept-Charset"] = "utf-8";
	Заголовки["Content-Type"] = "application/json";
	Заголовки["Content-Length"] = Формат(ПолучитьДвоичныеДанныеИзСтроки(JSON).Размер(), "ЧГ=");
	
	Адрес = ВнутреннийАдресМенеджераСервиса() + Ресурс;
	ДанныеСервера = ОбщегоНазначенияКлиентСервер.СтруктураURI(Адрес);
	
	Соединение = СоединениеСМенеджеромСервиса(ДанныеСервера);
	
	Запрос = Новый HTTPЗапрос(ДанныеСервера.ПутьНаСервере, Заголовки);
	Запрос.УстановитьТелоИзСтроки(JSON);
	
	Возврат Соединение.ОтправитьДляОбработки(Запрос);
	
КонецФункции

Функция СоединениеСМенеджеромСервиса(ДанныеСервера)
	
	ЗащищенноеСоединение = ?(Нрег(ДанныеСервера.Схема) = "https", Новый ЗащищенноеСоединениеOpenSSL, Неопределено);
	
	Соединение = Новый HTTPСоединение(ДанныеСервера.Хост,
		ДанныеСервера.Порт,
		РаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса(),
		РаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса(),,,
		ЗащищенноеСоединение);
	
	Возврат Соединение;
	
КонецФункции

Функция ИмяРесурсаМенеджераСервиса()
	
	Возврат "/hs/ui/bills/";
	
КонецФункции

Функция ПолучитьJSON(Значение)
	
	Если Значение = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку();
	
	Попытка
		ЗаписатьJSON(ЗаписьJSON, Значение);
	Исключение
		ЗаписьЖурналаРегистрации("Отладка.ЗаписьJSON", УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки());
		ВызватьИсключение;
	КонецПопытки;
		
	Результат = ЗаписьJSON.Закрыть();
	
	Возврат Результат;
	
КонецФункции

Функция ВнутреннийАдресМенеджераСервиса()
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = РаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НаименованиеПриложения()
	
	Результат = НСтр("ru='1С:Бухгалтерия'");
	
	Если НЕ ТарификацияБПВызовСервераПовтИсп.РазрешенУчетРегулярнойДеятельности() Тогда
		Результат = НСтр("ru='1С:Нулевка'");
	ИначеЕсли ОбщегоНазначенияБП.ЭтоВитринаБизнесСтарта() Тогда
		Результат = НСтр("ru='1С:БизнесСтарт'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаписатьОшибкуВЖурналРегистрации(ОписаниеОшибки)
	
	Событие = НСтр("ru='Оплата сервиса.Ошибка'");
	Уровень = УровеньЖурналаРегистрации.Ошибка;
	ОбъектМетаданных = Метаданные.Обработки.ОплатаСервиса;
	
	ЗаписьЖурналаРегистрации(Событие, Уровень, ОбъектМетаданных,, ОписаниеОшибки);
	
КонецПроцедуры

Функция СоздатьСчетНаОплатуПоставщика(Организация, Контрагент, Товары, НомерСчета, ДатаСчета)
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация", Организация);
	ДанныеЗаполнения.Вставить("Дата", ДатаСчета);
	ДанныеЗаполнения.Вставить("ДатаВходящегоДокумента", ДатаСчета);
	ДанныеЗаполнения.Вставить("НомерВходящегоДокумента", НомерСчета);
	ДанныеЗаполнения.Вставить("Контрагент", Контрагент);
	ДанныеЗаполнения.Вставить("БанковскийСчетКонтрагента", Контрагент.ОсновнойБанковскийСчет);
	
	НовыйСчет = Документы.СчетНаОплатуПоставщика.СоздатьДокумент();
	ЗаполнитьЗначенияСвойств(НовыйСчет, ДанныеЗаполнения);
	НовыйСчет.Заполнить(ДанныеЗаполнения);
	
	Для каждого Товар Из Товары Цикл
		НоваяСтрока = НовыйСчет.Товары.Добавить();
		НоваяСтрока.Содержание = Товар.Наименование;
		НоваяСтрока.Количество = Товар.Количество;
		НоваяСтрока.Цена       = Товар.Цена;
		НоваяСтрока.Сумма      = Товар.Сумма;
		НоваяСтрока.СуммаНДС   = Товар.СуммаНДС;
		НоваяСтрока.СтавкаНДС  = Товар.СтавкаНДС;
	КонецЦикла;
	
	НовыйСчет.ДополнительныеСвойства.Вставить("НеПроверятьОграничения");
	НовыйСчет.Записать();
	
	Возврат НовыйСчет.Ссылка;
	
КонецФункции

#КонецОбласти

#КонецЕсли
