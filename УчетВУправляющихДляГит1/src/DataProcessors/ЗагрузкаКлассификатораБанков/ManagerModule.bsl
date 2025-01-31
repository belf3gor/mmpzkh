///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий.
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Зависимости) Экспорт
	Зависимость = Зависимости.Добавить();
	Зависимость.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЗагрузкаКлассификатораБанков;
	Зависимость.ДоступноВМоделиСервиса      = Ложь;
	Зависимость.ДоступноВПодчиненномУзлеРИБ = Ложь;
КонецПроцедуры

// Возвращает список разрешений для загрузки классификатора банков с сайта 1С.
//
// Параметры:
//  Разрешения - Массив - коллекция разрешений.
//
Процедура ДобавитьРазрешения(Разрешения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ИспользоватьАльтернативныйСервер = Константы.ИспользоватьАльтернативныйСерверДляЗагрузкиКлассификатораБанков.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Если ИспользоватьАльтернативныйСервер Тогда
		Протокол = "HTTP";
		Адрес = "cbrates.rbc.ru";
		Порт = Неопределено;
		Описание = НСтр("ru = 'Загрузка классификатора банков с сайта РБК.'");
		Разрешения.Добавить( 
			МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));
	Иначе
		Протокол = "HTTPS";
		Адрес = "bankregister.1c.ru";
		Порт = Неопределено;
		Описание = НСтр("ru = 'Загрузка классификатора банков с сайта 1С.'");
		Разрешения.Добавить( 
			МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриПолученииДанныхКлассификатора(Параметры, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Истина;
КонецПроцедуры

// Формирует, дополняет текст сообщения пользователю в случае, если загрузка данных классификатора проведена успешно.
// 
// Параметры:
//	ПараметрыЗагрузкиКлассификатора - Структура:
//	Загружено						- Число  - Количество новых записей классификатора.
//	Обновлено						- Число  - Количество обновленных записей классификатора.
//	ТекстСообщения					- Строка - тест сообщения о результатах загрузки.
//	ЗагрузкаВыполнена               - Булево - флаг успешного завершения загрузки данных классификатора.
//
Процедура ДополнитьТекстСообщения(ПараметрыЗагрузкиКлассификатора)
	
	ТекстСообщения = ПараметрыЗагрузкиКлассификатора.ТекстСообщения;
	Загружено = ПараметрыЗагрузкиКлассификатора.Загружено;
	Обновлено = ПараметрыЗагрузкиКлассификатора.Обновлено;
	
	Если ПустаяСтрока(ТекстСообщения) Тогда
		Если Загружено = 0 И Обновлено = 0 Тогда
			ТекстСообщения = НСтр("ru ='Загрузка завершена. Изменений в классификаторе нет.'");
		Иначе
			ТекстСообщения = НСтр("ru ='Загрузка классификатора банков РФ выполнена успешно.'");
		КонецЕсли;
	КонецЕсли;
	
	Если Загружено > 0 Тогда
		ТекстСообщения = ТекстСообщения + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru ='Загружено новых: %1.'"), Загружено);
	КонецЕсли;
	
	Если Обновлено > 0 Тогда
		ТекстСообщения = ТекстСообщения + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru ='Обновлено записей: %1.'"), Обновлено);
	КонецЕсли;
	
	ПараметрыЗагрузкиКлассификатора.ТекстСообщения = ТекстСообщения;
	
КонецПроцедуры

// Получает данные классификатора БИК РФ с сайта 1С или с диска ИТС.
// 
// Параметры:
//	ПараметрыЗагрузкиКлассификатора - Структура - содержит параметры:
//	 * ВариантЗагрузки					- Строка - "ИТС", "Интернет" или "Файл".
//   * АдресДанных                      - Строка - Если ВариантЗагрузки = "ИТС" или "Файл", то содержит 
//                                                 адрес временного хранилища с bnk.zip.
//	 * Загружено						- Число	 - Количество новых записей классификатора.
//	 * Обновлено						- Число	 - Количество обновленных записей классификатора.
//	 * ТекстСообщения					- Строка - Текст сообщения о результатах загрузки.
//	 * ЗагрузкаВыполнена                - Булево - Флаг успешного завершения загрузки данных классификатора.
//	 * АдресХранилища					- Строка - Адрес внутреннего хранилища.
//
Процедура ПолучитьДанные(ПараметрыЗагрузкиКлассификатора, АдресХранилища = "") Экспорт
	
	ТекущаяВерсияКлассификатора = ВерсияКлассификатора();
	
	ВременныйКаталог = ФайловаяСистема.СоздатьВременныйКаталог();
	
	ПараметрыПолученияФайлов = Новый Структура;
	ПараметрыПолученияФайлов.Вставить("ПутьКФайлу", "");
	ПараметрыПолученияФайлов.Вставить("ТекстСообщения", ПараметрыЗагрузкиКлассификатора.ТекстСообщения);
	ПараметрыПолученияФайлов.Вставить("ВременныйКаталог", ВременныйКаталог);
	ПараметрыПолученияФайлов.Вставить("ЕстьОбновлениеНаСервере", Истина);
	ПараметрыПолученияФайлов.Вставить("ВерсияКлассификатора", ТекущаяВерсияКлассификатора);
	
	Попытка
		Если ПараметрыЗагрузкиКлассификатора.ВариантЗагрузки = "Интернет" Тогда
			ПолучитьДанныеИзИнтернета(ПараметрыПолученияФайлов);
		Иначе // ИТС или Файл.
			ДанныеКлассификатора  = ПараметрыЗагрузкиКлассификатора.АдресДанных.Получить();
			ПараметрыПолученияФайлов.ПутьКФайлу = ВременныйКаталог + "\bnk.zip";
			ДанныеКлассификатора.Записать(ПараметрыПолученияФайлов.ПутьКФайлу);
		КонецЕсли;
		ПрочитатьИЗагрузитьДанные(ПараметрыЗагрузкиКлассификатора, ПараметрыПолученияФайлов, АдресХранилища);
		ФайловаяСистема.УдалитьВременныйКаталог(ВременныйКаталог);
	Исключение	
		ФайловаяСистема.УдалитьВременныйКаталог(ВременныйКаталог);
		ВызватьИсключение;
	КонецПопытки;	
	
КонецПроцедуры

Процедура ПрочитатьИЗагрузитьДанные(ПараметрыЗагрузкиКлассификатора, ПараметрыПолученияФайлов, АдресХранилища = "")
	
	Если Не ПустаяСтрока(ПараметрыПолученияФайлов.ТекстСообщения) Тогда
		ПараметрыЗагрузкиКлассификатора.ТекстСообщения = ПараметрыПолученияФайлов.ТекстСообщения;
		Если НЕ ПустаяСтрока(АдресХранилища) Тогда
			ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПолученияФайлов.ЕстьОбновлениеНаСервере Тогда
		Попытка
			ZIPФайл = Новый ЧтениеZipФайла(ПараметрыПолученияФайлов.ПутьКФайлу);
		Исключение
			ТекстСообщения = НСтр("ru = 'Возникли проблемы с файлом классификатора банков, полученным с сайта 1С.'");
			ТекстСообщения = ТекстСообщения + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
		Если Не ПустаяСтрока(ТекстСообщения) Тогда
			ПараметрыЗагрузкиКлассификатора.ТекстСообщения = ТекстСообщения;
			Если НЕ ПустаяСтрока(АдресХранилища) Тогда
				ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
		ВременныйКаталог = ПараметрыПолученияФайлов.ВременныйКаталог;
		Попытка
			ZIPФайл.ИзвлечьВсе(ВременныйКаталог);
		Исключение
			ТекстСообщения = НСтр("ru = 'Возникли проблемы с файлом классификатора банков, полученным с сайта 1С.'");
			ТекстСообщения = ТекстСообщения + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;	
		
		Если Не ПустаяСтрока(ТекстСообщения) Тогда
			ПараметрыЗагрузкиКлассификатора.ТекстСообщения = ТекстСообщения;
			Если НЕ ПустаяСтрока(АдресХранилища) Тогда
				ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
		ПутьКФайлуБИК = ИмяФайлаБИКСВИФТ(ВременныйКаталог);
		ФайлБИК = Новый Файл(ИмяФайлаБИКСВИФТ(ВременныйКаталог));
		Если Не ФайлБИК.Существует() Тогда
			ПутьКФайлуБИК = ИмяФайлаБИК(ВременныйКаталог);
		КонецЕсли;
		
		ФайлБИК = Новый Файл(ПутьКФайлуБИК);
		Если Не ФайлБИК.Существует() Тогда
			ТекстСообщения = НСтр("ru = 'Возникли проблемы с файлом классификатора банков, полученным с сайта 1С. 
										|Архив не содержит информацию - классификатор банков.'");
			ПараметрыЗагрузкиКлассификатора.ТекстСообщения = ТекстСообщения;
			Если НЕ ПустаяСтрока(АдресХранилища) Тогда
				ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
		ПутьКФайлуРегионов = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВременныйКаталог) + "reg.txt";
		ФайлРегионов = Новый Файл(ПутьКФайлуРегионов);
		Если Не ФайлРегионов.Существует() Тогда
			ТекстСообщения = НСтр("ru ='Возникли проблемы с файлом классификатора банков, полученным с сайта 1С. 
										|Архив не содержит информацию о регионах.'");
			ПараметрыЗагрузкиКлассификатора.ТекстСообщения = ТекстСообщения;
			Если НЕ ПустаяСтрока(АдресХранилища) Тогда
				ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
		ПутьКФайлуНедействующихБанков = ИмяФайлаНедействующихБанков(ВременныйКаталог);
		ФайлНедействующихБанков = Новый Файл(ПутьКФайлуНедействующихБанков);
		Если Не ФайлНедействующихБанков.Существует() Тогда
			ТекстСообщения = НСтр("ru ='Возникли проблемы с файлом классификатора банков, полученным с сайта 1С. 
										|Архив не содержит информацию о недействующих банках.'");
			ПараметрыЗагрузкиКлассификатора.ТекстСообщения = ТекстСообщения;
			Если НЕ ПустаяСтрока(АдресХранилища) Тогда
				ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
		ПараметрыЗагрузкиФайлов = Новый Структура;
		ПараметрыЗагрузкиФайлов.Вставить("ПутьКФайлуБИК", ПутьКФайлуБИК);
		ПараметрыЗагрузкиФайлов.Вставить("ПутьКФайлуРегионов", ПутьКФайлуРегионов);
		ПараметрыЗагрузкиФайлов.Вставить("ПутьКФайлуНедействующихБанков", ПутьКФайлуНедействующихБанков);
		ПараметрыЗагрузкиФайлов.Вставить("ВременныйКаталог", ВременныйКаталог);
		ПараметрыЗагрузкиФайлов.Вставить("Загружено", ПараметрыЗагрузкиКлассификатора.Загружено);
		ПараметрыЗагрузкиФайлов.Вставить("Обновлено", ПараметрыЗагрузкиКлассификатора.Обновлено);
		ПараметрыЗагрузкиФайлов.Вставить("СписокИзмененныхБанков", Новый СписокЗначений);
		ПараметрыЗагрузкиФайлов.Вставить("ТекстСообщения", ПараметрыЗагрузкиКлассификатора.ТекстСообщения);
		
		ЗагрузитьДанные(ПараметрыЗагрузкиФайлов);
		
		РаботаСБанкамиБП.ОбновитьБанкиИзКлассификатора(
				ПараметрыЗагрузкиФайлов["СписокИзмененныхБанков"], 0);
		
		Если Не ПустаяСтрока(ПараметрыЗагрузкиФайлов.ТекстСообщения) Тогда
			Если НЕ ПустаяСтрока(АдресХранилища) Тогда
				ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
		ПараметрыЗагрузкиКлассификатора.Загружено = ПараметрыЗагрузкиФайлов.Загружено;
		ПараметрыЗагрузкиКлассификатора.Обновлено = ПараметрыЗагрузкиФайлов.Обновлено;
		ПараметрыЗагрузкиКлассификатора.ТекстСообщения = ПараметрыЗагрузкиФайлов.ТекстСообщения;
		
		ПараметрыЗагрузкиКлассификатора.Вставить("СписокИзмененныхБанков", ПараметрыЗагрузкиФайлов["СписокИзмененныхБанков"]);
		
	КонецЕсли;
	
	УстановитьВерсиюКлассификатора(ПараметрыПолученияФайлов.ВерсияКлассификатора);
	
	ПараметрыЗагрузкиКлассификатора.ЗагрузкаВыполнена = Истина;
	ДополнитьТекстСообщения(ПараметрыЗагрузкиКлассификатора);
	
	Если НЕ ПустаяСтрока(АдресХранилища) Тогда
		ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
	КонецЕсли;

КонецПроцедуры	

Процедура ЗагрузитьКлассификаторБанков() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ЗагрузкаКлассификатораБанков);
	
	УровеньСобытия = УровеньЖурналаРегистрации.Информация;
	
	Если АвтономнаяРаботаСлужебный.ЭтоАвтономноеРабочееМесто() Тогда
		ЗаписьЖурналаРегистрации(ИмяСобытияВЖурналеРегистрации(), УровеньСобытия, , , НСтр("ru = 'Загрузка в подчиненном узле РИБ не предусмотрена'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыЗагрузкиКлассификатора = Новый Структура;
	ПараметрыЗагрузкиКлассификатора.Вставить("Загружено", 0);
	ПараметрыЗагрузкиКлассификатора.Вставить("Обновлено", 0);
	ПараметрыЗагрузкиКлассификатора.Вставить("СписокИзмененныхБанков", Новый СписокЗначений);
	ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", "");
	ПараметрыЗагрузкиКлассификатора.Вставить("ЗагрузкаВыполнена", Ложь);
	ПараметрыЗагрузкиКлассификатора.Вставить("ВариантЗагрузки", "Интернет");
	
	ПолучитьДанные(ПараметрыЗагрузкиКлассификатора);
	
	Если ПараметрыЗагрузкиКлассификатора.ЗагрузкаВыполнена Тогда
		Если ПустаяСтрока(ПараметрыЗагрузкиКлассификатора.ТекстСообщения) Тогда
			ДополнитьТекстСообщения(ПараметрыЗагрузкиКлассификатора);
		КонецЕсли;
	Иначе
		УровеньСобытия = УровеньЖурналаРегистрации.Ошибка;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(ИмяСобытияВЖурналеРегистрации(), УровеньСобытия, , , 
		ПараметрыЗагрузкиКлассификатора.ТекстСообщения);
	
КонецПроцедуры

Процедура ЗагрузитьДанные(ПараметрыЗагрузкиФайлов)
	
	Регионы = Регионы(ПараметрыЗагрузкиФайлов.ПутьКФайлуРегионов);
	
	ТекстБИК = Новый ЧтениеТекста(ПараметрыЗагрузкиФайлов.ПутьКФайлуБИК, "windows-1251");
	СтрокаТекстаБИК = ТекстБИК.ПрочитатьСтроку();
	
	ПараметрыЗагрузкиДанных = Новый Структура;
	ПараметрыЗагрузкиДанных.Вставить("Загружено", ПараметрыЗагрузкиФайлов.Загружено);
	ПараметрыЗагрузкиДанных.Вставить("Обновлено", ПараметрыЗагрузкиФайлов.Обновлено);
	ПараметрыЗагрузкиДанных.Вставить("СписокИзмененныхБанков", ПараметрыЗагрузкиФайлов["СписокИзмененныхБанков"]);
	
	Пока СтрокаТекстаБИК <> Неопределено Цикл
		
		Строка = СтрокаТекстаБИК;
	
		Если ПустаяСтрока(СокрЛП(Строка)) Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураБанк  = СведенияОБанке(Строка, Регионы);
		СтрокаТекстаБИК = ТекстБИК.ПрочитатьСтроку();
		
		Если ПустаяСтрока(СтруктураБанк) Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыЗагрузкиДанных.Вставить("СтруктураБанк", СтруктураБанк);
		ЗаписатьЭлементКлассификатораБанковРФ(ПараметрыЗагрузкиДанных);
		
	КонецЦикла;
	
	// Пометка недействующих банков.
	ДействующиеБанки = ДействующиеБанкиИзФайла(ПараметрыЗагрузкиФайлов.ПутьКФайлуБИК);
	НедействующиеБанки = НедействующиеБанкиИзФайла(ПараметрыЗагрузкиФайлов.ПутьКФайлуНедействующихБанков);
	КоличествоОтмеченных = ОтметитьНедействующиеБанки(ДействующиеБанки, НедействующиеБанки);
	ПараметрыЗагрузкиДанных.Обновлено = ПараметрыЗагрузкиДанных.Обновлено + КоличествоОтмеченных;
	
	ПараметрыЗагрузкиФайлов.Загружено = ПараметрыЗагрузкиДанных.Загружено;
	ПараметрыЗагрузкиФайлов.Обновлено = ПараметрыЗагрузкиДанных.Обновлено;
	ПараметрыЗагрузкиФайлов.Вставить("СписокИзмененныхБанков", ПараметрыЗагрузкиДанных["СписокИзмененныхБанков"]);
КонецПроцедуры 

Процедура ПолучитьДанныеИзИнтернета(ПараметрыПолученияФайлов)

	УстановитьПривилегированныйРежим(Истина);
	ИспользоватьАльтернативныйСервер = Константы.ИспользоватьАльтернативныйСерверДляЗагрузкиКлассификатораБанков.Получить();
	ПараметрыПолучения = ПараметрыАутентификацииНаСайте();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ИспользоватьАльтернативныйСервер Тогда
		ФайлНаВебСервере = "http://cbrates.rbc.ru/bnk/bnk.zip";
	Иначе
		ФайлНаВебСервере = "https://bankregister.1c.ru/bankregister/v1/bnk.zip";
	КонецЕсли;
	
	ВременныйФайл = ПараметрыПолученияФайлов.ВременныйКаталог+ "\bnk.zip";
	ПараметрыПолучения.Вставить("ПутьДляСохранения", ВременныйФайл);
	
	ДатаПоследнегоОбновления = ПараметрыПолученияФайлов.ВерсияКлассификатора;
	ПараметрыПолучения.Вставить("Заголовки", Новый Соответствие);
	ПараметрыПолучения.Заголовки.Вставить("If-Modified-Since", ДатаHTTP(ДатаПоследнегоОбновления));
	
	РезультатИзИнтернета = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(ФайлНаВебСервере, ПараметрыПолучения);
	
	Если РезультатИзИнтернета.Статус Тогда
		ПараметрыПолученияФайлов.ПутьКФайлу = РезультатИзИнтернета.Путь;
		ВерсияКлассификатора = РезультатИзИнтернета.Заголовки["Last-Modified"];
		Если ВерсияКлассификатора <> Неопределено Тогда
			ВерсияКлассификатора = ПрочитатьДатуHTTP(ВерсияКлассификатора);
			ПараметрыПолученияФайлов.ВерсияКлассификатора = ВерсияКлассификатора;
		КонецЕсли;
	Иначе
		Если РезультатИзИнтернета.КодСостояния = 304 Тогда
			ПараметрыПолученияФайлов.ЕстьОбновлениеНаСервере = Ложь;
		Иначе
			Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
				ДополнительноеСообщение = Символы.ПС
					+ НСтр("ru ='Возможно неточные или неправильные настройки подключения к Интернету.'");
			Иначе
				ДополнительноеСообщение = Символы.ПС
					+ НСтр("ru ='Возможно неточные или неправильные настройки подключения к Интернету на сервере 1С:Предприятие.'");
			КонецЕсли;
			СообщениеОбОшибке = РезультатИзИнтернета.СообщениеОбОшибке + ДополнительноеСообщение; 
			ПараметрыПолученияФайлов.ТекстСообщения = СообщениеОбОшибке;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПараметрыАутентификацииНаСайте()
	Результат = Новый Структура;
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		ДанныеАутентификации = МодульИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		Если ДанныеАутентификации <> Неопределено Тогда
			Результат.Вставить("Пользователь", ДанныеАутентификации.Логин);
			Результат.Вставить("Пароль", ДанныеАутентификации.Пароль);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Преобразует дату формата rfc1123-date в обычную универсальную дату.
// См. https://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html, п. 3.3.1.
Функция ПрочитатьДатуHTTP(ДатаHTTP)
	Месяцы = СтрРазделить("Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec", ",");
	ДатаВремя = СтрРазделить(ДатаHTTP, " ", Ложь);
	
	День = ДатаВремя[1];
	Месяц = Месяцы.Найти(ДатаВремя[2]) + 1;
	Год = ДатаВремя[3];
	Время = СтрРазделить(ДатаВремя[4], ":", Истина);
	Час = Время[0];
	Минута = Время[1];
	Секунда = Время[2];
	
	УниверсальноеВремя = Дата(Год, Месяц, День, Час, Минута, Секунда);
	Возврат УниверсальноеВремя;
КонецФункции

// Преобразует универсальную дату в дату формата rfc1123-date.
// См. https://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html, п. 3.3.1.
Функция ДатаHTTP(Знач Дата)
	ДниНедели = СтрРазделить("Mon,Tue,Wed,Thu,Fri,Sat,Sun", ",");
	Месяцы = СтрРазделить("Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec", ",");
	
	ШаблонДаты = "[ДеньНедели], [День] [Месяц] [Год] [Час]:[Минута]:[Секунда] GMT"; // АПК:1297 не локализуется
	
	ПараметрыДаты = Новый Структура;
	ПараметрыДаты.Вставить("ДеньНедели", ДниНедели[ДеньНедели(Дата)-1]);
	ПараметрыДаты.Вставить("День", Формат(День(Дата), "ЧЦ=2; ЧВН="));
	ПараметрыДаты.Вставить("Месяц", Месяцы[Месяц(Дата)-1]);
	ПараметрыДаты.Вставить("Год", Формат(Год(Дата), "ЧЦ=4; ЧВН=; ЧГ=0"));
	ПараметрыДаты.Вставить("Час", Формат(Час(Дата), "ЧЦ=2; ЧН=00; ЧВН="));
	ПараметрыДаты.Вставить("Минута", Формат(Минута(Дата), "ЧЦ=2; ЧН=00; ЧВН="));
	ПараметрыДаты.Вставить("Секунда", Формат(Секунда(Дата), "ЧЦ=2; ЧН=00; ЧВН="));
	
	ДатаHTTP = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонДаты, ПараметрыДаты);
	
	Возврат ДатаHTTP;
КонецФункции

Функция ОпределитьТипГородаПоКоду(КодТипа)
	
	Если КодТипа = "1" Тогда
		Возврат "Г.";       // ГОРОД
	ИначеЕсли КодТипа = "2" Тогда
		Возврат "П.";       // ПОСЕЛОК
	ИначеЕсли КодТипа = "3" Тогда
		Возврат "С.";       // СЕЛО
	ИначеЕсли КодТипа = "4" Тогда
		Возврат "ПГТ";     // ПОСЕЛОК ГОРОДСКОГО ТИПА
	ИначеЕсли КодТипа = "5" Тогда
		Возврат "СТ-ЦА";   // СТАНИЦА
	ИначеЕсли КодТипа = "6" Тогда
		Возврат "АУЛ";     // АУЛ
	ИначеЕсли КодТипа = "7" Тогда
		Возврат "РП";      // РАБОЧИЙ ПОСЕЛОК 
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Функция Регионы(ПутьКФайлуРегионов)
	
	СоответствиеРегионов = Новый Соответствие;
	РегионыТекстовыйДокумент = Новый ЧтениеТекста(ПутьКФайлуРегионов, "windows-1251");
	СтрокаРегионов = РегионыТекстовыйДокумент.ПрочитатьСтроку();
	
	Пока СтрокаРегионов <> Неопределено Цикл

		Строка  = СтрокаРегионов;
		СтрокаРегионов = РегионыТекстовыйДокумент.ПрочитатьСтроку();

		Если (Лев(Строка,2) = "//") Или (ПустаяСтрока(Строка)) Тогда
			Продолжить;
		КонецЕсли;
		
		МассивПодстрок = СтрРазделить(Строка, Символы.Таб);
		
		Если МассивПодстрок.Количество() < 2 Тогда
			Продолжить;
		КонецЕсли;	
		
		Символ1 = СокрЛП(МассивПодстрок[0]);
        Символ2 = СокрЛП(МассивПодстрок[1]);
        		 		
		// Дополним код региона до двух знаков.
		Если СтрДлина(Символ1) = 1 Тогда
			Символ1 = "0" + Символ1;
		КонецЕсли;
		
		СоответствиеРегионов.Вставить(Символ1, Символ2);
 	КонецЦикла;	
		
	Возврат СоответствиеРегионов;

КонецФункции

// Формирует структуру полей для банка.
// Параметры:
//	Строка  - Строка	   - Строка из текстового файла классификатора.
//	Регионы - Соответствие - Код региона и регион банка.
// Возвращаемое значение:
//	Банк - Структура - Реквизиты банка.
//
Функция СведенияОБанке(Знач Строка, Регионы)
	
	Результат = Новый Структура;
	
	СписокПолей = Новый Массив;
	СписокПолей.Добавить("ТипУчастникаРасчетов");
	СписокПолей.Добавить("ИмяНаселенногоПункта");
	СписокПолей.Добавить("ТипПункта");
	СписокПолей.Добавить("Наименование");
	СписокПолей.Добавить("ПризнакКода");
	СписокПолей.Добавить("БИК");
	СписокПолей.Добавить("КоррСчет");
	СписокПолей.Добавить("СВИФТБИК");
	СписокПолей.Добавить("ИНН");
	СписокПолей.Добавить("ОГРН");
	СписокПолей.Добавить("Адрес");
	СписокПолей.Добавить("Телефоны");
	СписокПолей.Добавить("МеждународноеНаименование");
	СписокПолей.Добавить("ГородМеждународный");
	СписокПолей.Добавить("АдресМеждународный");
	
	КоллекцияЗначений = СтрРазделить(Строка, Символы.Таб, Истина);
	Для Индекс = 0 По СписокПолей.Количество() - 1 Цикл;
		Значение = "";
		Если Индекс <= КоллекцияЗначений.ВГраница() Тогда
			Значение = СокрЛП(КоллекцияЗначений[Индекс]);
		КонецЕсли;
		Результат.Вставить(СписокПолей[Индекс], Значение);
	КонецЦикла;
	
	Если СтрДлина(Результат.БИК) <> 9 Тогда
		Возврат "";
	КонецЕсли;
	
	Результат.ТипПункта = ОпределитьТипГородаПоКоду(Результат.ТипПункта);
	Результат.Вставить("Город", СокрЛП(Результат.ТипПункта + " " + Результат.ИмяНаселенногоПункта));
	
	КодРегиона = Сред(Результат.БИК, 3, 2);
	Регион = Регионы[КодРегиона];
	Если Регион = Неопределено Тогда
		Регион = НСтр("ru = 'Другие территории'");
		КодРегиона = "";
	КонецЕсли;
	
	Результат.Вставить("КодРегиона", КодРегиона);
	Результат.Вставить("Регион", Регион);
	
	Возврат Результат;
	
КонецФункции

// Выполняет загрузку классификатора банков РФ из файла, полученного с сайта 1С.
Процедура ЗагрузитьДанныеИзФайла(ИмяФайла) Экспорт
	ПапкаСИзвлеченнымиФайлами = ИзвлечьФайлыИзАрхива(ИмяФайла);
	Если ФайлыКлассификатораПолучены(ПапкаСИзвлеченнымиФайлами) Тогда
		Параметры = Новый Структура;
		ФайлБИКСВИФТ = Новый Файл(ИмяФайлаБИКСВИФТ(ПапкаСИзвлеченнымиФайлами));
		Если ФайлБИКСВИФТ.Существует() Тогда
			Параметры.Вставить("ПутьКФайлуБИК", ИмяФайлаБИКСВИФТ(ПапкаСИзвлеченнымиФайлами));
		Иначе
			Параметры.Вставить("ПутьКФайлуБИК", ИмяФайлаБИК(ПапкаСИзвлеченнымиФайлами));
		КонецЕсли;
		Параметры.Вставить("ПутьКФайлуРегионов", ИмяФайлаРегионов(ПапкаСИзвлеченнымиФайлами));
		Параметры.Вставить("ПутьКФайлуНедействующихБанков", ИмяФайлаНедействующихБанков(ПапкаСИзвлеченнымиФайлами));
		Параметры.Вставить("Загружено", 0);
		Параметры.Вставить("Обновлено", 0);
		Параметры.Вставить("СписокИзмененныхБанков", Новый СписокЗначений);
		Параметры.Вставить("ТекстСообщения", "");
		Параметры.Вставить("ЗагрузкаВыполнена", Неопределено);
		
		ЗагрузитьДанные(Параметры);
		УстановитьВерсиюКлассификатора();
	КонецЕсли;
	
КонецПроцедуры
	

Функция ФайлыКлассификатораПолучены(ПапкаСФайлами)
	
	Результат = Истина;
	
	ИменаФайловДляПроверки = Новый Массив;
	ИменаФайловДляПроверки.Добавить(ИмяФайлаБИК(ПапкаСФайлами));
	ИменаФайловДляПроверки.Добавить(ИмяФайлаРегионов(ПапкаСФайлами));
	ИменаФайловДляПроверки.Добавить(ИмяФайлаНедействующихБанков(ПапкаСФайлами));
	
	Для Каждого ИмяФайла Из ИменаФайловДляПроверки Цикл
		Файл = Новый Файл(ИмяФайла);
		Если Не Файл.Существует() Тогда
			ЗаписатьОшибкуВЖурналРегистрации(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не найден файл %1'"), ИмяФайла));
			Результат = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ИзвлечьФайлыИзАрхива(ZipФайл)
	
	ВременнаяПапка = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ВременнаяПапка);
	
	Попытка
		ЧтениеZipФайла = Новый ЧтениеZipФайла(ZipФайл);
		ЧтениеZipФайла.ИзвлечьВсе(ВременнаяПапка);
	Исключение
		ЗаписатьОшибкуВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		УдалитьФайлы(ВременнаяПапка);
	КонецПопытки;
	
	Возврат ВременнаяПапка;
	
КонецФункции

Функция ИмяФайлаРегионов(ПапкаСФайламиКлассификатора)
	
	Возврат ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПапкаСФайламиКлассификатора) + "reg.txt";
	
КонецФункции

Функция ИмяФайлаБИК(ПапкаСФайламиКлассификатора)
	
	Возврат ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПапкаСФайламиКлассификатора) + "bnkseek.txt";
	
КонецФункции

Функция ИмяФайлаБИКСВИФТ(ПапкаСФайламиКлассификатора)
	
	Возврат ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПапкаСФайламиКлассификатора) + "bnkseek_swift.txt";
	
КонецФункции

Функция ИмяФайлаНедействующихБанков(ПапкаСФайламиКлассификатора)
	
	Возврат ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПапкаСФайламиКлассификатора) + "bnkdel.txt";
	
КонецФункции

Процедура ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки)
	
	ЗаписьЖурналаРегистрации(ИмяСобытияВЖурналеРегистрации(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
	
КонецПроцедуры

Функция ИмяСобытияВЖурналеРегистрации()
	УстановитьПривилегированныйРежим(Истина);
	ИспользоватьАльтернативныйСервер = Константы.ИспользоватьАльтернативныйСерверДляЗагрузкиКлассификатораБанков.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ИспользоватьАльтернативныйСервер Тогда
		Возврат НСтр("ru = 'Загрузка классификатора банков.РБК'", ОбщегоНазначения.КодОсновногоЯзыка());
	КонецЕсли;
	
	Возврат НСтр("ru = 'Загрузка классификатора банков.1С'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Функция НедействующиеБанкиИзФайла(ПутьКФайлу)
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("БИК", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(9)));
	Результат.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	Результат.Колонки.Добавить("ДатаЗакрытия", Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	
	ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлу, "windows-1251");
	
	Строка = ЧтениеТекста.ПрочитатьСтроку();
	Пока Строка <> Неопределено Цикл
		СведенияОБанке = СтрРазделить(Строка, Символы.Таб);
		Если СведенияОБанке.Количество() <> 8 Тогда
			Продолжить;
		КонецЕсли;
		Банк = Результат.Добавить();
		Банк.БИК = СведенияОБанке[6];
		Банк.Наименование = СведенияОБанке[4];
		Банк.ДатаЗакрытия = СведенияОБанке[1];
		
		Строка = ЧтениеТекста.ПрочитатьСтроку();
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ДействующиеБанкиИзФайла(ПутьКФайлу)
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("БИК", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(9)));
	Результат.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	
	ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлу, "windows-1251");
	
	Строка = ЧтениеТекста.ПрочитатьСтроку();
	Пока Строка <> Неопределено Цикл
		СведенияОБанке = СтрРазделить(Строка, Символы.Таб);
		Строка = ЧтениеТекста.ПрочитатьСтроку();
		
		Если СведенияОБанке.Количество() < 7 Тогда
			Продолжить;
		КонецЕсли;
		Банк = Результат.Добавить();
		Банк.БИК = СведенияОБанке[5];
		Банк.Наименование = СведенияОБанке[3];
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОтметитьНедействующиеБанки(ДействующиеБанки, НедействующиеБанки)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НедействующиеБанки.БИК КАК БИК
	|ПОМЕСТИТЬ НедействующиеБанки
	|ИЗ
	|	&НедействующиеБанки КАК НедействующиеБанки
	|ГДЕ
	|	НЕ НедействующиеБанки.БИК В (&БИК)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	БИК";
	Запрос.УстановитьПараметр("НедействующиеБанки", НедействующиеБанки);
	Запрос.УстановитьПараметр("БИК", ДействующиеБанки.ВыгрузитьКолонку("БИК"));
	Запрос.Выполнить();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторБанков.Ссылка
	|ИЗ
	|	НедействующиеБанки КАК НедействующиеБанки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК КлассификаторБанков
	|		ПО НедействующиеБанки.БИК = КлассификаторБанков.Код
	|ГДЕ
	|	КлассификаторБанков.ДеятельностьПрекращена = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	КлассификаторБанков.Ссылка";
	
	ВыборкаБанков = Запрос.Выполнить().Выбрать();
	Пока ВыборкаБанков.Следующий() Цикл
		БанкОбъект = ВыборкаБанков.Ссылка.ПолучитьОбъект();
		БанкОбъект.ДеятельностьПрекращена = Истина;
		БанкОбъект.Записать();
	КонецЦикла;
	
	Возврат ВыборкаБанков.Количество();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Запись обработанных данных

///  Записывает/перезаписывает в справочник КлассификаторБанков данные банка.
// Параметры:
//	ПараметрыЗагрузкиДанных - Структура:
//	СтруктураБанк			- Структура или СтрокаТаблицыЗначений - Данные банка.
//	Загружено				- Число								 - Количество новых записей классификатора.
//	Обновлено				- Число								 - Количество обновленных записей классификатора.
//
Процедура ЗаписатьЭлементКлассификатораБанковРФ(ПараметрыЗагрузкиДанных)
	
	ФлагНовый = Ложь;
	ФлагОбновленный = Ложь;
	Регион = "";
	
	СтруктураБанк = ПараметрыЗагрузкиДанных.СтруктураБанк;
	Загружено = ПараметрыЗагрузкиДанных.Загружено;
	Обновлено = ПараметрыЗагрузкиДанных.Обновлено;
	СписокИзмененныхБанков = ПараметрыЗагрузкиДанных["СписокИзмененныхБанков"];
	
	ТекущийРегион = Справочники.КлассификаторБанков.НайтиПоКоду(СтруктураБанк.КодРегиона);
	
	РегионНайден = Не ТекущийРегион.Пустая();
	
	Если РегионНайден Тогда
		Регион = ТекущийРегион.ПолучитьОбъект();
		Если Не ТекущийРегион.ЭтоГруппа Тогда 
			Регион.Код = "";
			Регион.Записать();
			РегионНайден = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Не РегионНайден Тогда
		Регион = Справочники.КлассификаторБанков.СоздатьГруппу();
	КонецЕсли;
	
	Если СокрЛП(Регион.Код) <> СокрЛП(СтруктураБанк.КодРегиона) Тогда
		Регион.Код = СокрЛП(СтруктураБанк.КодРегиона);
	КонецЕсли;
	
	Если СокрЛП(Регион.Наименование) <> СокрЛП(СтруктураБанк.Регион) Тогда
		Регион.Наименование = СокрЛП(СтруктураБанк.Регион);
	КонецЕсли;
	
	Если Регион.Модифицированность() Тогда
		Регион.Записать();
	КонецЕсли;
	
	ЗаписываемыйЭлементСправочникаКлассификаторБанков = 
		Справочники.КлассификаторБанков.НайтиПоКоду(СтруктураБанк.БИК);
	
	БанкНайден = Не ЗаписываемыйЭлементСправочникаКлассификаторБанков.Пустая();
	
	Если БанкНайден Тогда
		КлассификаторБанковОбъект = ЗаписываемыйЭлементСправочникаКлассификаторБанков.ПолучитьОбъект();
		Если КлассификаторБанковОбъект.ЭтоГруппа Тогда
			КлассификаторБанковОбъект.Код = "";
			КлассификаторБанковОбъект.Записать();
			БанкНайден = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Не БанкНайден Тогда
		КлассификаторБанковОбъект = Справочники.КлассификаторБанков.СоздатьЭлемент();
		ФлагНовый = Истина;
	КонецЕсли;
	
	Если КлассификаторБанковОбъект.ДеятельностьПрекращена Тогда
		КлассификаторБанковОбъект.ДеятельностьПрекращена = Ложь;
	КонецЕсли;
	
	Если КлассификаторБанковОбъект.Код <> СтруктураБанк.БИК Тогда
		КлассификаторБанковОбъект.Код = СтруктураБанк.БИК;
	КонецЕсли;
	
	Для Каждого Реквизит Из КлассификаторБанковОбъект.Метаданные().Реквизиты Цикл
		ИмяРеквизита = Реквизит.Имя;
		Если СтруктураБанк.Свойство(ИмяРеквизита) И ТипЗнч(КлассификаторБанковОбъект[ИмяРеквизита]) = Тип("Строка") Тогда
			ОбновитьЗначениеРеквизита(КлассификаторБанковОбъект, ИмяРеквизита, СтруктураБанк[ИмяРеквизита]);
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьЗначениеРеквизита(КлассификаторБанковОбъект, "Наименование", СтруктураБанк.Наименование);
	
	Если Не ПустаяСтрока(Регион) Тогда
		Если КлассификаторБанковОбъект.Родитель <> Регион.Ссылка Тогда
			КлассификаторБанковОбъект.Родитель = Регион.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Страна = "РФ";
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
			МодульРаботаСАдресамиКлиентСервер = ОбщегоНазначения.ОбщийМодуль("РаботаСАдресамиКлиентСервер");
			Страна = МодульРаботаСАдресамиКлиентСервер.ОсновнаяСтрана();
		КонецЕсли;
		ОбновитьЗначениеРеквизита(КлассификаторБанковОбъект, "Страна", Страна);
	КонецЕсли;
	
	Если КлассификаторБанковОбъект.Модифицированность() Тогда
		ФлагОбновленный = Истина;
		КлассификаторБанковОбъект.Записать();
		СписокИзмененныхБанков.Добавить(КлассификаторБанковОбъект.Ссылка);
	КонецЕсли;
	
	Если ФлагНовый Тогда
		Загружено = Загружено + 1;
		СписокИзмененныхБанков.Добавить(КлассификаторБанковОбъект.Ссылка);
	ИначеЕсли ФлагОбновленный Тогда
		Обновлено = Обновлено + 1;
	КонецЕсли;
	
	ПараметрыЗагрузкиДанных.Загружено = Загружено;
	ПараметрыЗагрузкиДанных.Обновлено = Обновлено;
	ПараметрыЗагрузкиДанных.Вставить("СписокИзмененныхБанков", СписокИзмененныхБанков);
	
КонецПроцедуры

Процедура ОбновитьЗначениеРеквизита(СправочникОбъект, ИмяРеквизита, Значение)
	Если СправочникОбъект[ИмяРеквизита] <> Значение Тогда
		Если ЗначениеЗаполнено(Значение) Тогда
			СправочникОбъект[ИмяРеквизита] = Значение;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции

// Определяет нужно ли обновление данных классификатора.
//
Функция КлассификаторАктуален() Экспорт
	ПоследнееОбновление = ДатаПоследнейЗагрузки();
	ДопустимаяПросрочка = 30*60*60*24;
	
	Если ТекущаяДатаСеанса() > ПоследнееОбновление + ДопустимаяПросрочка Тогда
		Возврат Ложь; // Пошла просрочка.
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

Функция АктуальностьКлассификатораБанков() Экспорт
	
	ПоследнееОбновление = ДатаПоследнейЗагрузки();
	ДопустимаяПросрочка = 60*60*24;
	
	Результат = Новый Структура;
	Результат.Вставить("КлассификаторУстарел", Ложь);
	Результат.Вставить("КлассификаторПросрочен", Ложь);
	Результат.Вставить("ВеличинаПросрочкиСтрокой", "");
	
	Если ТекущаяДатаСеанса() > ПоследнееОбновление + ДопустимаяПросрочка Тогда
		Результат.ВеличинаПросрочкиСтрокой = ОбщегоНазначения.ИнтервалВремениСтрокой(ПоследнееОбновление, ТекущаяДатаСеанса());
		
		ВеличинаПросрочки = (ТекущаяДатаСеанса() - ПоследнееОбновление);
		ДнейПросрочено = Цел(ВеличинаПросрочки/60/60/24);
		
		Результат.КлассификаторУстарел = ДнейПросрочено >= 1;
		Результат.КлассификаторПросрочен = ДнейПросрочено >= 7;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// См. ИнтернетПоддержкаПользователейПереопределяемый.ПриСохраненииДанныхАутентификацииПользователяИнтернетПоддержки.
Процедура ПриСохраненииДанныхАутентификацииПользователяИнтернетПоддержки(ДанныеПользователя) Экспорт
	УстановитьПараметрыРегламентногоЗадания(Новый Структура("Использование", Истина));
КонецПроцедуры

// См. ИнтернетПоддержкаПользователейПереопределяемый.ПриУдаленииДанныхАутентификацииПользователяИнтернетПоддержки.
Процедура ПриУдаленииДанныхАутентификацииПользователяИнтернетПоддержки() Экспорт
	УстановитьПараметрыРегламентногоЗадания(Новый Структура("Использование", Ложь));
КонецПроцедуры

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "2.4.1.1";
		Обработчик.Процедура = "Обработки.ЗагрузкаКлассификатораБанков.УстановитьРасписаниеРегламентногоЗадания";
		Обработчик.РежимВыполнения = "Оперативно";
		Обработчик.НачальноеЗаполнение = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьРасписаниеРегламентногоЗадания() Экспорт
	
	ГенераторСлучайныхЧисел = Новый ГенераторСлучайныхЧисел(ТекущаяУниверсальнаяДатаВМиллисекундах());
	Задержка = ГенераторСлучайныхЧисел.СлучайноеЧисло(0, 21600); // С 0 до 6 часов утра.
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ПериодПовтораДней = 1;
	Расписание.ПериодНедель = 1;
	Расписание.ВремяНачала = '00010101000000' + Задержка;
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание", Расписание);
	ПараметрыЗадания.Вставить("ИнтервалПовтораПриАварийномЗавершении", 600);
	ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 10);
	
	УстановитьПараметрыРегламентногоЗадания(ПараметрыЗадания);
	
КонецПроцедуры

Процедура УстановитьПараметрыРегламентногоЗадания(ИзменяемыеПараметры)
	РегламентныеЗаданияСервер.УстановитьПараметрыРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ЗагрузкаКлассификатораБанков, ИзменяемыеПараметры);
КонецПроцедуры

Функция ВерсияКлассификатора()
	Возврат СведенияОКлассификаторе().ДатаМодификации;
КонецФункции

Функция ДатаПоследнейЗагрузки()
	Возврат СведенияОКлассификаторе().ДатаЗагрузки;
КонецФункции

Функция СведенияОКлассификаторе()
	УстановитьПривилегированныйРежим(Истина);
	Результат = Константы.ВерсияКлассификатораБанков.Получить().Получить();
	УстановитьПривилегированныйРежим(Ложь);
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Результат = НовоеОписаниеКлассификатора();
	КонецЕсли;
	Возврат Результат;
КонецФункции

Процедура УстановитьВерсиюКлассификатора(Знач ВерсияКлассификатора = Неопределено)
	Если Не ЗначениеЗаполнено(ВерсияКлассификатора) Тогда
		ВерсияКлассификатора = ТекущаяУниверсальнаяДата();
	КонецЕсли;
	СведенияОКлассификаторе = НовоеОписаниеКлассификатора(ВерсияКлассификатора, ТекущаяДатаСеанса());
	УстановитьПривилегированныйРежим(Истина);
	Константы.ВерсияКлассификатораБанков.Установить(Новый ХранилищеЗначения(СведенияОКлассификаторе));
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Функция НовоеОписаниеКлассификатора(ДатаМодификации = '00010101', ДатаЗагрузки = '00010101')
	Результат = Новый Структура;
	Результат.Вставить("ДатаМодификации", ДатаМодификации);
	Результат.Вставить("ДатаЗагрузки", ДатаЗагрузки);
	Возврат Результат;
КонецФункции

#КонецОбласти

#КонецЕсли