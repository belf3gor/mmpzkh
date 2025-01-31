
////////////////////////////////////////////////////////////////////////////////
//
// ИнтеграцияГИСМКлиент : переопределяемые серверные процедуры и функции подсистемы "Интеграция с ГИСМ".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Предоставляет возможность переопределить обработку заполнения документа "Заявка на выпуск КиЗ".
//
// Параметры:
//  ЗаявкаОбъект - ДокументОбъект.ЗаявкаНаВыпускКиЗ - документ, для которого выполняется заполнение.
//  ДанныеЗаполнения - Произвольный - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  ТекстЗаполнения - Строка,Неопределено - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  СтандартнаяОбработка - Булево - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполненияЗаявкиНаВыпускКиЗ(ЗаявкаОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Предоставляет возможность переопределить заполнение документа "Заявка на выпуск КиЗ".
//
// Параметры:
//  ЗаявкаОбъект         - ДокументОбъект.ЗаявкаНаВыпускКиЗ - документ, для которого выполняется заполнение.
//  ДанныеЗаполнения - Произвольный - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  ТекстЗаполнения - Строка - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  СтандартнаяОбработка - Булево - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//
Процедура ЗаполнитьЗаявкуНаВыпускКиЗНаОснованииДругогоДокумента(ЗаявкаОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт

	
КонецПроцедуры

// Предоставляет возможность переопределить обработку заполнения документа "Уведомление об отгрузке маркированных
// товаров ГИСМ".
//
// Параметры:
//  УведомлениеОбъект    - ДокументОбъект.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ - документ, для которого
//                                                                                        выполняется заполнение.
//  ДанныеЗаполнения - Произвольный - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  ТекстЗаполнения - Строка - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  СтандартнаяОбработка - Булево - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполненияУведомленияОбОтгрузкеГИСМ(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт

	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		
		ИнтеграцияГИСМБП.ЗаполнитьУведомлениеОбОтгрузкеГИСМНаОснованииРеализации(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
	
		ИнтеграцияГИСМБП.ЗаполнитьУведомлениеОбОтгрузкеГИСМНаОснованииВозвратаТоваровПоставщику(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

// Предоставляет возможность переопределить обработку заполнения документа "Уведомление о ввозе маркированных товаров из
// ЕАЭС".
//
// Параметры:
//  УведомлениеОбъект    - ДокументОбъект.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ - документ, для которого
//                                                                                          выполняется заполнение.
//  ДанныеЗаполнения - Произвольный - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  ТекстЗаполнения - Строка - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  СтандартнаяОбработка - Булево - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполненияУведомленияОВвозеИзЕАЭСГИСМ(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт

	ИнтеграцияГИСМБП.ЗаполнитьУведомлениеОВвозеИзЕАЭСГИСМНаОснованииПоступления(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

// Предоставляет возможность переопределить обработку заполнения документа "Уведомление об импорте маркированных товаров".
//
// Параметры:
//  УведомлениеОбъект    - ДокументОбъект.УведомлениеОбИмпортеМаркированныхТоваровГИСМ - документ, для которого
//                                                                                       выполняется заполнение.
//  ДанныеЗаполнения - Произвольный - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  ТекстЗаполнения - Строка - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  СтандартнаяОбработка - Булево - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполненияУведомленияОбИмпортеГИСМ(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	ИнтеграцияГИСМБП.ЗаполнитьУведомлениеОбИмпортеГИСМНаОснованииПоступления(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

// Предоставляет возможность переопределить обработку заполнения документа "Уведомление о списании КиЗ для маркировки".
//
// Параметры:
//  УведомлениеОбъект    - ДокументОбъект.УведомлениеОСписанииКиЗГИСМ - документ, для которого выполняется заполнение.
//  ДанныеЗаполнения - Произвольный - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  ТекстЗаполнения - Строка - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//  СтандартнаяОбработка - Булево - см. описание параметра в синтаксис-помощнике к обработчику ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполненияУведомленияОСписанииКиЗ(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	ИнтеграцияГИСМБП.ЗаполнитьУведомлениеОСписанииКиЗНаОснованииСписаниеТоваров(УведомлениеОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

// Предоставляет возможность переопределить обработку заполнения документа "Уведомление об импорте маркированных товаров".
//
// Параметры:
//  Объект - ДокументОбъект.УведомлениеОбИмпортеМаркированныхТоваровГИСМ - документ, для которого выполняется заполнение.
//  Отказ - Булево - Признак отказа.
//  ПроверяемыеРеквизиты - Массив - Проверяемые реквизиты.
//
Процедура УведомлениеОбИмпортеОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

// Возвращает структуру, содержащую ИНН, КПП, GLN организации.
//
// Параметры:
//  Организация - ОпределяемыйТип.Организация - Организация.
//  Подразделение - ОпределяемыйТип.Подразделение - Подразделение организации.
//  ИННКППGLNОрганизации - Структура - со свойствами:
//     ИНН  - Строка - ИНН контрагента.
//     КПП  - Строка - КПП контрагента.
//     GLN  - Строка - GLN контрагента.
//
Процедура ИННКППGLNОрганизации(Организация, Подразделение, ИННКППGLNОрганизации) Экспорт
	
	ИННКППGLNОрганизации = ИнтеграцияГИСМБП.ИННКППGLNОрганизации(Организация, Подразделение);
	
КонецПроцедуры

// Возвращает структуру через параметр Реквизиты, содержащую Страну,
// Регистрационный номер, наименование, признак физического лица, ИНН и КПП.
//
// Параметры:
//  Контрагент - ОпределяемыйТип.КонтрагентГосИС - Контрагент.
//  Реквизиты  - Структура - со свойствами:
//     Страна  - Строка - Страна регистрации контрагента.
//     РегистрационныйНомер  - Строка - Регистрационный номер контрагента.
//     Наименование  - Строка - Наименование контрагента.
//     НаименованиеПолное  - Строка - Полное наименование контрагента.
//     ЭтоФизическоеЛицо  - Булево - Признак физического лица.
//     ИНН  - Строка - ИНН контрагента.
//     КПП  - Строка - КПП контрагента.
//     ЮридическийАдрес - Строка - Юридический адрес контрагента.
//
Процедура РеквизитыКонтрагента(Контрагент, Реквизиты) Экспорт
	
	Реквизиты = ИнтеграцияГИСМБП.РеквизитыКонтрагента(Контрагент);
	
КонецПроцедуры

// Проверяет использование подразделений в информационной базе.
// 
// Параметры:
//  Использовать - Булево - Подразделения используются.
//
Процедура ИспользоватьПодразделения(Использовать) Экспорт
	
	Использовать = Ложь;
	
КонецПроцедуры

// Проверяет использование заявок на выпуск КиЗ.
// 
// Параметры:
//  Использовать - Булево - Заявки используются.
//
Процедура ИспользоватьЗаявкиНаВыпускКиЗ(Использовать) Экспорт
	
	Использовать = Ложь;
	
Конецпроцедуры

// Проверяет использование нескольких организаций в информационной базе.
// 
// Параметры:
//  Использовать - Булево - Несколько организаций используются.
//
Процедура ИспользоватьНесколькоОрганизаций(Использовать) Экспорт
	
	Использовать = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийБухгалтерскийУчет");
	
КонецПроцедуры

// Документ-основание является возвратом поставщику
//
// Параметры:
//  ДокументСсылка    - ДокументСсылка- Документ-основание.
//  РезультатПроверки - Булево - Основание является возвратом поставщику.
//
Процедура ДокументОснованиеВозвратПоставщику(ДокументСсылка, РезультатПроверки) Экспорт
	
	РезультатПроверки = ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ВозвратТоваровПоставщику");
	
КонецПроцедуры

// Получить организацию и подразделение документа.
//
// Параметры:
//  ДокументСсылка           - ДокументСсылка - Документ, подразделение и организацию которого необходимо получить.
//  ОрганизацияПодразделение - Исходящий параметр, структура со свойствами:
//    * Организация - ОпределяемыйТип.Организация - Организация документа.
//    * Подразделение - ОпределяемыйТип.Подразделение - Подразделение документа.
//
Процедура ОрганизацияПодразделениеДокумента(ДокументСсылка, ОрганизацияПодразделение) Экспорт
	
	ОрганизацияПодразделение = ИнтеграцияГИСМБП.ОрганизацияПодразделениеДокумента(ДокументСсылка);
	
КонецПроцедуры

// Позволяет определить получение валюты регламентированного учета.
//
// Параметры:
//  Валюта - СправочникСсылка.Валюты - Исходящий параметр, валюта регламентированного учета.
//
Процедура ВалютаРегламентированногоУчета(Валюта) Экспорт
	
	Валюта = ИнтеграцияГИСМБП.ВалютаРегламентированногоУчета();
	
КонецПроцедуры

// В данной функции необходимо реализовать запрос, который определяет поступившие КиЗ
// для документов "Заявка на выпуск КиЗ", "Уведомление о поступлении маркированной продукции".
//
// Параметры:
//  Объект - ДокументОбъект, ДанныеФормыСтруктура - Объект.
//  ЗапросРезультат - Запрос - Исходящий параметр, запрос для определения поступивших КиЗ.
//
Процедура ЗапросПоПоступившимКиЗ(Объект, ЗапросРезультат) Экспорт
	
	ЗапросРезультат = ИнтеграцияГИСМБП.ЗапросПоПоступившимКиЗ(Объект);
	
КонецПроцедуры

// Обновляет в табличной части документа "Заявкам на выпуск КиЗ" табличную часть "Заказанные КиЗ".
//
// Параметры:
//  Объект - ДокументОбъект, ДанныеФормыСтруктура - Объект.
//
Процедура ОбновитьКолонкиВыпущеноПолученоВТЧЗаказанныеКиЗ(Объект) Экспорт
	
	
КонецПроцедуры

// Получает данные по "Заявкам на выпуск КиЗ" для заполнения обработки "Подтверждение поступивших КиЗ".
//
// Параметры:
//  ДокументыКПодтверждению - Массив - Содержит документы "Заявка на выпуск КиЗ", для которых будет выполняться
//                                     подтверждение поступления.
//  ДанныеПоЗаявкам - Исходящий параметр, структура - со свойствами:
//     НомераКиЗКПодтверждению - ТаблицаЗначений - содержит данные по выпущенным КиЗ, их статусам и документам поступления.
//     ПроблемыДублиКиЗ        - ТаблицаЗначений - содержит информацию о дублирующихся в обрабатываемых документах
//                                                 номерах КиЗ.
//     ПроблемыСопоставления   - ТаблицаЗначений - содержит информацию о выпущенных киз, которые не удалось сопоставить
//                                                 заказанным КиЗ.
//
Процедура ДанныеПоЗаявкамНаВыпускКиЗ(ДокументыКПодтверждению, ДанныеПоЗаявкам) Экспорт
	
	
КонецПроцедуры

// Получает данные по "Заявкам на выпуск КиЗ" для заполнения обработки "Подтверждение поступивших КиЗ".
//
// Параметры:
//  ДокументыКПодтверждению - Массив - Содержит документы "Заявка на выпуск КиЗ", для которых будет выполняться
//                                     подтверждение поступления.
//  ДанныеПоЗаявкамКиЗ      - Исходящий параметр, структура - со свойствами:
//     НомераКиЗКПодтверждению - ТаблицаЗначений - содержит данные по ожидаемым маркированным товарам, их статусам и
//                                                 документам поступления.
//     ПроблемыДублиКиЗ        - ТаблицаЗначений - содержит информацию о дублирующихся в обрабатываемых документах
//                                                 номерах КиЗ ожидаемых товарах.
//     ПроблемыСопоставления   - Неопределено    - всегда устанавливается в Неопределено.
//
Процедура ДанныеПоУведомлениямОПоступлении(ДокументыКПодтверждению, ДанныеПоЗаявкамКиЗ) Экспорт
	
	ДанныеПоЗаявкамКиЗ = ИнтеграцияГИСМБП.ДанныеПоУведомлениямОПоступлении(ДокументыКПодтверждению);
	
КонецПроцедуры

// Формирует текст запроса для отчета "ПоступленияБезДокументовГИСМ"
//
// Параметры:
//  ИмяНабораДанных - Строка - определяет, по каким документу ГИСМ будут получаться данные. 
//     Если имя "КиЗ", то по "Заявкам на выпуск КиЗ", если "МаркированныеТовары", то по "Уведомлениям о поступлении
//     маркированной продукции"
//  ОтборОрганизация - ОпределяемыйТип.Организация - отбор по организации.
//  ОтборКонтрагент  - ОпределяемыйТип.Контрагенты - отбор по контрагентам.
//  ТекстЗапроса - Строка - исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаПоПроблемнымПоступлениям(ИмяНабораДанных, ОтборОрганизация, ОтборКонтрагент, ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаПоПроблемнымПоступлениям(ИмяНабораДанных, ОтборОрганизация, ОтборКонтрагент);
	
КонецПроцедуры

#Область ПодпискиНаСобытия

// Обработчик события перед записью, документов влияющих на расчет поступления КиЗ от эмитента.
//
// Параметры:
//  Источник         - ДокументОбъект - документ, влияющий на расчет.
//  Отказ - Булево - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//  РежимЗаписи  - РежимЗаписиДокумента - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//  РежимПроведения - РежимПроведенияДокумента - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью
//                                               документа.
//
Процедура ВлияющийНаСтатусПоступленияКиЗДокументПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	
КонецПроцедуры

// Обработчик события при проведении, документов влияющих на расчет поступления КиЗ от эмитента.
//
// Параметры:
//  Источник         - ДокументОбъект - документ, влияющий на расчет.
//  Отказ - Булево - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//  РежимПроведения - РежимПроведенияДокумента - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью
//                                               документа.
//
Процедура ВлияющийНаСтатусПоступленияКиЗДокументПриПроведении(Источник, Отказ, РежимПроведения) Экспорт
	
	
КонецПроцедуры

// Обработчик события при записи документа "Заявка на выпуск КиЗ" и его оснований для расчета статуса заявки.
//
// Параметры:
//  Источник         - ДокументОбъект - документ, влияющий на расчет.
//  Отказ - Булево - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//
Процедура РассчитатьСтатусЗаявкиНаВыпускКиЗ(Источник, Отказ) Экспорт
	
	
КонецПроцедуры

// Обработчик события при записи документа "Уведомления о поступлении маркированных товаров" для расчета статуса уведомления.
//
// Параметры:
//  Источник         - ДокументОбъект - документ, влияющий на расчет.
//  Отказ - Булево - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//
Процедура РассчитатьСтатусУведомленияОПоступлении(Источник, Отказ) Экспорт
	
	ИнтеграцияГИСМБП.РассчитатьСтатусУведомленияОПоступлении(Источник, Отказ);
	
КонецПроцедуры

// Обработчик события при записи документа "Уведомления о отгрузке маркированных товаров" и его оснований для расчета
// статуса уведомления.
//
// Параметры:
//  Источник         - ДокументОбъект - документ, влияющий на расчет.
//  Отказ - Булево - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//
Процедура РассчитатьСтатусУведомленияОбОтгрузке(Источник, Отказ) Экспорт
	
	ИнтеграцияГИСМБП.РассчитатьСтатусУведомленияОбОтгрузке(Источник, Отказ);
	
КонецПроцедуры

// Обработчик события при записи документов, влияющих на расчет состояний информирования ГИСМ для расчета статуса уведомлений.
//
// Параметры:
//  Источник         - ДокументОбъект - документ, влияющий на расчет.
//  Отказ - Булево - см. описание параметра в синтаксис-помощнике к обработчику ПередЗаписью документа.
//
Процедура РассчитатьСтатусИнформированияГИСМ(Источник, Отказ) Экспорт
	
	ИнтеграцияГИСМБП.РассчитатьСтатусИнформированияГИСМ(Источник, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполненияПредставленияТоваров

// Заполняет представление номенклатуры в документах уведомлениях по номерам КиЗ, указанным в документе основании.
//
// Параметры:
//  Основание  - ДокументСсылка - документ, являющийся основанием для уведомления.
//  НомераКиЗ  - ТабличнаяЧастьДокумента - ТЧ, которая содержит колонку НомерКиЗ.
//
Процедура ЗаполнитьПредставлениеТоваровУведомленияПоНомерамКиЗОснования(Основание, НомераКиЗ) Экспорт
	
	ИнтеграцияГИСМБП.ЗаполнитьПредставлениеТоваровУведомленияПоНомерамКиЗОснования(Основание, НомераКиЗ);
	
КонецПроцедуры

// Заполняет представление номенклатуры в документе "Уведомление о поступлении маркированной продукции" по номерам КиЗ,
// указанным в документе основании.
//
// Параметры:
//  НомераКиЗ  - ТабличнаяЧастьДокумента - ТЧ, которая содержит колонку НомерКиЗ.
//
Процедура ЗаполнитьПредставлениеТоваровУведомленияОПоступлении(НомераКиЗ) Экспорт
	
	ИнтеграцияГИСМБП.ЗаполнитьПредставлениеТоваровУведомленияОПоступлении(НомераКиЗ);
	
КонецПроцедуры

#КонецОбласти

#Область ЗаявкаНаВыпускКиЗ

// Проверяет корректность заказываемых КиЗ. В одном документе могут быть либо персонифицированные, либо
// неперсонифицированные КиЗ.
//
// Параметры:
//  Объект             - ДокументОбъект - документ, в котором выполняется проверка.
//  ИмяТабличнойЧасти  - Строка - имя табличной части, которая содержит заказываемые КиЗ.
//  Отказ              - Булево - устанавливается в Ложь, если проверка завершилась неудачей.
//
Процедура ПроверитьКорректностьПерсонифицованностиЗаказываемыхКиЗ(Объект, ИмяТабличнойЧасти, Отказ) Экспорт

	
КонецПроцедуры

// Проверяет указания характеристик в табличной части документа.
//
// Параметры:
//  Объект                         - ДокументОбъект - документ, в котором выполняется проверка.
//  МассивНепроверяемыхРеквизитов  - Массив - содержит реквизиты, для которых в метаданных установлен признак проверки,
//                                            но они исключаются из платформенной проверки.
//  ИмяТаблицы                     - Строка - имя табличной части, которая содержит заказываемые КиЗ.
//  Отказ                          - Булево - устанавливается в Ложь, если проверка завершилась неудачей.
//
Процедура ПроверитьЗаполнениеХарактеристик(Объект, МассивНепроверяемыхРеквизитов, ИмяТаблицы, Отказ) Экспорт
	
	
КонецПроцедуры

// Обрабатывает результат подбора заказываемых КиЗ в документе "Заявка на выпуск КиЗ".
//
// Параметры:
//  Форма              - УправляемаяФорма - форма, из которой был вызван подбор.
//  ВыбранноеЗначение  - Произвольный - результат, возвращенный обработкой подбора КиЗ.
//
Процедура ОбработкаПодбораЗаявкиНаВыпускКиЗ(Форма, ВыбранноеЗначение) Экспорт
	
	
КонецПроцедуры

// Предоставляет возможность заполнить служебные реквизиты в ТЧ документа "Заявка на выпуск КиЗ".
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма документа "Заявка на выпуск КиЗ".
//
Процедура ЗаполнитьСлужебныеРеквизитыТабличнойЧастиЗаявкиНаВыпускКиЗ(Форма) Экспорт
	
	
КонецПроцедуры

// Предоставляет возможность заполнить служебные реквизиты в ТЧ документа "Уведомление об импорте маркированных товаров".
//
// Параметры:
//  Форма - ТабличнаяЧасть - ТЧ "Товары "документа "Уведомление об импорте маркированных товаров".
//
Процедура ЗаполнитьСлужебныеРеквизитыТабличнойЧастиУведомлениеОбИмпорте(Товары) Экспорт
	
	





КонецПроцедуры

Процедура ОпределитьПолеОписанияНоменклатурыУведомленияОбИмпорте(Поле) Экспорт
	
	Поле = "Товары.НоменклатураОписание";
	
КонецПроцедуры

#КонецОбласти

#Область Панель1СМаркировка

// Проверяет наличие права чтения на документ и функциональную опцию использования,
// которым отражается факт розничных продаж.
//
// Параметры:
//   Доступен - Булево - Исходящий параметр, Истина, если право есть, Ложь в обратном случае.
//
Процедура ДоступенОтчетОРозничныхПродажах(Доступен) Экспорт
	
	Доступен = ИнтеграцияГИСМБП.ДоступенОтчетОРозничныхПродажах();
	
КонецПроцедуры

// Проверяет наличие права чтения на документ и функциональную опцию использования,
// которыми отражается факт возврата от розничного покупателя.
//
// Параметры:
//   Доступен - Булево - Исходящий параметр, Истина, если право есть, Ложь в обратном случае.
//
Процедура ДоступенВозвратТоваровОтРозничногоКлиента(Доступен) Экспорт
	
	Доступен = ИнтеграцияГИСМБП.ДоступенВозвратТоваровОтРозничногоКлиента();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов, которыми оформляется факт розничных продаж,
// требующих дальнейшего действия или ожидания для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаОтчетыОРозничныхПродажах(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаОтчетыОРозничныхПродажах();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов, которыми оформляется факт розничных продаж,
// требующих дальнейшего действия для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаОтчетыОРозничныхПродажахОтработайте(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаОтчетыОРозничныхПродажахОтработайте();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов, которыми оформляется факт розничных продаж,
// требующих ожидания для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаОтчетыОРозничныхПродажахОжидайте(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаОтчетыОРозничныхПродажахОжидайте();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов, которыми оформляется факт возврата от розничного покупателя,
// требующих дальнейшего действия для отображения в панели "1С - Маркировка".
///
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаВозвратыТоваровОтРозничныхКлиентов(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаВозвратыТоваровОтРозничныхКлиентов();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов, которыми оформляется факт возврата от розничного покупателя,
// требующих дальнейшего действия или ожидания для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаВозвратыТоваровОтРозничныхКлиентовОтработайте(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаВозвратыТоваровОтРозничныхКлиентовОтработайте();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов, которыми оформляется факт возврата от розничного покупателя,
// требующих ожидания для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаВозвратыТоваровОтРозничныхКлиентовОжидайте(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаВозвратыТоваровОтРозничныхКлиентовОжидайте();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов "Уведомление о списании КиЗ",
// требующих дальнейшего действия для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаУведомленияОСписанииКиЗГИСМ(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаУведомленияОСписанииКиЗГИСМ();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов "Уведомление о списании КиЗ",
// требующих дальнейшего действия "оформите" для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаУведомленияОСписанииКиЗГИСМОформите(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаУведомленияОСписанииКиЗГИСМОформите();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов "Уведомление о отгрузке маркированных товаров",
// требующих дальнейшего действия для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаУведомленияОбОтгрузке(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаУведомленияОбОтгрузке();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов "Уведомление о отгрузке маркированных товаров",
// требующих дальнейшего действия "оформите" для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаУведомленияОбОтгрузкеОформите(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаУведомленияОбОтгрузкеОформите();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов "Заявка на выпуск КиЗ",
// требующих дальнейшего действия для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаЗаявкиНаВыпускКиЗГИСМ(ТекстЗапроса)  Экспорт
	
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов "Заявка на выпуск КиЗ",
// требующих дальнейшего действия "оформите" для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаЗаявкиНаВыпускКиЗГИСМОформите(ТекстЗапроса)  Экспорт
	
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов "Уведомление о ввозе маркированных товаров из ЕАЭС",
// требующих дальнейшего действия для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаУведомленияОВвозеИзЕАЭС(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаУведомленияОВвозеИзЕАЭС();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов "Уведомление о ввозе маркированных товаров из ЕАЭС",
// требующих дальнейшего действия "оформите" для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаУведомленияОВвозеИзЕАЭСОформите(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаУведомленияОВвозеИзЕАЭСОформите();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов "Уведомление об импорте маркированных товаров",
// требующих дальнейшего действия для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаУведомленияОбИмпорте(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаУведомленияОбИмпорте();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов "Уведомление об импорте маркированных товаров",
// требующих дальнейшего действия "оформите" для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаУведомленияОбИмпортеОформите(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаУведомленияОбИмпортеОформите();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов ожидающих отправки "Отчеты о розничных продажах",
// требующих дальнейшего действия "оформите" для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаКоличествоОтчетовОРозничныхПродажахОжидающиеОтправки(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаКоличествоОтчетовОРозничныхПродажахОжидающиеОтправки();
	
КонецПроцедуры

// Формирует текст запроса, вычисляющий количество документов ожидающих отправки "Возвраты товаров от клиентов",
// требующих дальнейшего действия "оформите" для отображения в панели "1С - Маркировка".
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаКоличествоВозвратовОтРозничныхКлиентовОжидающиеОтправки(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаКоличествоВозвратовОтРозничныхКлиентовОжидающиеОтправки();
	
КонецПроцедуры

#КонецОбласти

#Область ЗапросыДинамическихСписковРаспоряжений

// Формирует текст запроса для динамического списка распоряжений уведомлений об импорте.
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОбИмпорте(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОбИмпорте();
	
КонецПроцедуры

// Формирует текст запроса для динамического списка распоряжений уведомлений о ввозе из ЕАЭС.
//
// Параметры:
//   ТекстЗапроса - Строка - Исходящий параметр, текст запроса.
//
Процедура ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОВвозеИзЕАЭС(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОВвозеИзЕАЭС();
	
КонецПроцедуры

// Формирует текст запроса для динамического списка распоряжений уведомлений о списании.
//
// Параметры:
//   ТекстЗапроса - Строка - текст запроса динамического списка.
//            Если пустой - то в динамическом списке остается библиотечный запрос.
//
Процедура ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОСписании(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОСписании();
	
КонецПроцедуры

// Формирует текст запроса для динамического списка распоряжений уведомлений об отгрузке.
//
// Параметры:
//   ТекстЗапроса - Строка - текст запроса динамического списка.
//            Если пустой - то в динамическом списке остается библиотечный запрос.
//
Процедура ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОбОтгрузке(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ИнтеграцияГИСМБП.ТекстЗапросаДинамическогоСпискаРаспоряженийУведомлениеОбОтгрузке();
	
КонецПроцедуры

// Формирует текст запроса для динамического списка заявок на выпуск КиЗ.
//
// Параметры:
//   ТекстЗапроса - Строка - текст запроса динамического списка.
//            Если пустой - то в динамическом списке остается библиотечный запрос.
//
Процедура ТекстЗапросаДинамическогоСпискаРаспоряженийЗаявкаНаВыпускКиЗ(ТекстЗапроса) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступом

// Формирует текст запроса ограничения доступа для RLS формата БСП 3.0
//
// Параметры:
//   Ограничение - Структура - См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
//   ИмяТаблицы - Строка - Полное имя объекта метаданных. Например "Документ.МаркировкаТоваровГИСМ".
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение, ИмяТаблицы) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
