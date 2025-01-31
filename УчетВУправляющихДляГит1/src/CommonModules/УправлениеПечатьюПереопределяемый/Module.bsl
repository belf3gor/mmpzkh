///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет объекты конфигурации, в модулях менеджеров которых размещена процедура ДобавитьКомандыПечати,
// формирующая список команд печати, предоставляемых этим объектом.
// Синтаксис процедуры ДобавитьКомандыПечати см. в документации к подсистеме.
//
// Параметры:
//  СписокОбъектов - Массив - менеджеры объектов с процедурой ДобавитьКомандыПечати.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить(Справочники.БанковскиеСчета);                                
	СписокОбъектов.Добавить(Справочники.ДоверенностиНалогоплательщика);
	СписокОбъектов.Добавить(Справочники.ДоговорыКонтрагентов);
	СписокОбъектов.Добавить(Справочники.Контрагенты);
	СписокОбъектов.Добавить(Справочники.КонтактныеЛица);
	СписокОбъектов.Добавить(Справочники.НематериальныеАктивы);
	СписокОбъектов.Добавить(Справочники.Номенклатура);
	СписокОбъектов.Добавить(Справочники.НоменклатурныеГруппы);
	СписокОбъектов.Добавить(Справочники.ОбъектыСтроительства);
	СписокОбъектов.Добавить(Справочники.Организации);
	СписокОбъектов.Добавить(Справочники.ОсновныеСредства);
	СписокОбъектов.Добавить(Справочники.ПодразделенияОрганизаций);
	СписокОбъектов.Добавить(Справочники.ПрочиеДоходыИРасходы);
	СписокОбъектов.Добавить(Справочники.Склады);
	СписокОбъектов.Добавить(Справочники.СтатьиЗатрат);
	СписокОбъектов.Добавить(Справочники.Субконто);
	СписокОбъектов.Добавить(Справочники.ТиповыеОперации);
	СписокОбъектов.Добавить(Документы.АвансовыйОтчет);
	СписокОбъектов.Добавить(Документы.АктОбОказанииПроизводственныхУслуг);
	СписокОбъектов.Добавить(Документы.АктПроверкиСтраховыхВзносов);
	СписокОбъектов.Добавить(Документы.АктСверкиВзаиморасчетов);
	СписокОбъектов.Добавить(Документы.ВводНачальныхОстатков);
	СписокОбъектов.Добавить(Документы.ВозвратМатериаловИзЭксплуатации);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровОтПокупателя);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровПоставщику);
	СписокОбъектов.Добавить(Документы.ВозвратОСОтАрендатора);
	СписокОбъектов.Добавить(Документы.ВосстановлениеНДС);
	СписокОбъектов.Добавить(Документы.ВосстановлениеНДСПоОбъектамНедвижимости);
	СписокОбъектов.Добавить(Документы.ВыдачаДенежныхДокументов);
	СписокОбъектов.Добавить(Документы.ВыкупПредметовЛизинга);
	СписокОбъектов.Добавить(Документы.ВыработкаМатериалов);
	СписокОбъектов.Добавить(Документы.ВыработкаНМА);
	СписокОбъектов.Добавить(Документы.ВыработкаОС);
	СписокОбъектов.Добавить(Документы.ВходящаяТранспортнаяОперацияВЕТИС);
	СписокОбъектов.Добавить(Документы.ИсходящаяТранспортнаяОперацияВЕТИС);
	СписокОбъектов.Добавить(Документы.ГТДИмпорт);
	СписокОбъектов.Добавить(Документы.Доверенность);
	СписокОбъектов.Добавить(Документы.ДокументРасчетовСКонтрагентом);
	СписокОбъектов.Добавить(Документы.ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде);
	СписокОбъектов.Добавить(Документы.ДопЛистКнигиПродажДляПередачиВЭлектронномВиде);
	СписокОбъектов.Добавить(Документы.ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде);
	СписокОбъектов.Добавить(Документы.ЗаписьКнигиУчетаДоходовИРасходовИП);
	СписокОбъектов.Добавить(Документы.ЗаписьКУДиР);
	СписокОбъектов.Добавить(Документы.ЗаявкаНаКредит);
	СписокОбъектов.Добавить(Документы.ЗаявлениеОВвозеТоваров);
	СписокОбъектов.Добавить(Документы.ЗапросСкладскогоЖурналаВЕТИС);
	СписокОбъектов.Добавить(Документы.ИзменениеГрафиковАмортизацииОС);
	СписокОбъектов.Добавить(Документы.ИзменениеПараметровНачисленияАмортизацииОС);
	СписокОбъектов.Добавить(Документы.ИзменениеСостоянияОС);
	СписокОбъектов.Добавить(Документы.ИзменениеСпециальногоКоэффициентаНМА);
	СписокОбъектов.Добавить(Документы.ИзменениеСпециальногоКоэффициентаОС);
	СписокОбъектов.Добавить(Документы.ИзменениеСпособовОтраженияРасходовПоАмортизацииНМА);
	СписокОбъектов.Добавить(Документы.ИзменениеСпособовОтраженияРасходовПоАмортизацииОС);
	СписокОбъектов.Добавить(Документы.ИзменениеОтраженияРасходовПоЛизинговымПлатежамОС);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияНЗП);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияОС);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияПродукцииВЕТИС);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияРасчетовСКонтрагентами);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияТоваровНаСкладе);
	СписокОбъектов.Добавить(Документы.КнигаПокупокДляПередачиВЭлектронномВиде);
	СписокОбъектов.Добавить(Документы.КнигаПродажДляПередачиВЭлектронномВиде);
	СписокОбъектов.Добавить(Документы.КомплектацияНоменклатуры);
	СписокОбъектов.Добавить(Документы.КорректировкаДолга);
	СписокОбъектов.Добавить(Документы.КорректировкаПоступления);
	СписокОбъектов.Добавить(Документы.КорректировкаРеализации);
	СписокОбъектов.Добавить(Документы.МодернизацияОС);
	СписокОбъектов.Добавить(Документы.НачислениеНДСпоСМРхозспособом);
	СписокОбъектов.Добавить(Документы.НачислениеПеней);
	СписокОбъектов.Добавить(Документы.ОказаниеУслуг);
	СписокОбъектов.Добавить(Документы.ОперацияБух);
	СписокОбъектов.Добавить(Документы.ОплатаПлатежнойКартой);
	СписокОбъектов.Добавить(Документы.ОприходованиеТоваров);
	СписокОбъектов.Добавить(Документы.ОтражениеЗарплатыВУчете);
	СписокОбъектов.Добавить(Документы.ОтражениеНачисленияНДС);
	СписокОбъектов.Добавить(Документы.ОтражениеНДСКВычету);
	СписокОбъектов.Добавить(Документы.ОтчетКомиссионераОПродажах);
	СписокОбъектов.Добавить(Документы.ОтчетКомитентуОПродажах);
	СписокОбъектов.Добавить(Документы.ОтчетОРозничныхПродажах);
	СписокОбъектов.Добавить(Документы.ОтчетОператораСистемыПлатон);
	СписокОбъектов.Добавить(Документы.ОтчетПроизводстваЗаСмену);
	СписокОбъектов.Добавить(Документы.ПередачаМатериаловВЭксплуатацию);
	СписокОбъектов.Добавить(Документы.ПередачаНМА);
	СписокОбъектов.Добавить(Документы.ПередачаОборудованияВМонтаж);
	СписокОбъектов.Добавить(Документы.ПередачаОС);
	СписокОбъектов.Добавить(Документы.ПередачаОСВАренду);
	СписокОбъектов.Добавить(Документы.ПередачаТоваров);
	СписокОбъектов.Добавить(Документы.ПеремещениеОС);
	СписокОбъектов.Добавить(Документы.ПеремещениеТоваров);
	СписокОбъектов.Добавить(Документы.ПереоценкаТоваровВРознице);
	СписокОбъектов.Добавить(Документы.ПлатежноеПоручение);
	СписокОбъектов.Добавить(Документы.ПлатежноеТребование);
	СписокОбъектов.Добавить(Документы.ПодготовкаКПередачеОС);
	СписокОбъектов.Добавить(Документы.ПодтверждениеНулевойСтавкиНДС);
	СписокОбъектов.Добавить(Документы.ПодтверждениеОплатыНДСВБюджет);
	СписокОбъектов.Добавить(Документы.ПоступлениеВЛизинг);
	СписокОбъектов.Добавить(Документы.ПоступлениеДенежныхДокументов);
	СписокОбъектов.Добавить(Документы.ПоступлениеДопРасходов);
	СписокОбъектов.Добавить(Документы.ПоступлениеИзПереработки);
	СписокОбъектов.Добавить(Документы.ПоступлениеНаРасчетныйСчет);
	СписокОбъектов.Добавить(Документы.ПоступлениеНМА);
	СписокОбъектов.Добавить(Документы.ПоступлениеТоваровУслуг);
	СписокОбъектов.Добавить(Документы.ПринятиеКУчетуНМА);
	СписокОбъектов.Добавить(Документы.ПринятиеКУчетуОС);
	СписокОбъектов.Добавить(Документы.ПриходныйКассовыйОрдер);
	СписокОбъектов.Добавить(Документы.ПроизводственнаяОперацияВЕТИС);
	СписокОбъектов.Добавить(Документы.РаспределениеНДС);
	СписокОбъектов.Добавить(Документы.РасходныйКассовыйОрдер);
	СписокОбъектов.Добавить(Документы.РасходыПредпринимателя);
	СписокОбъектов.Добавить(Документы.РеализацияОтгруженныхТоваров);
	СписокОбъектов.Добавить(Документы.РеализацияТоваровУслуг);
	СписокОбъектов.Добавить(Документы.РеализацияУслугПоПереработке);
	СписокОбъектов.Добавить(Документы.РегистрацияОплатыОсновныхСредствДляИП);
	СписокОбъектов.Добавить(Документы.РегистрацияОплатыОсновныхСредствДляУСН);
	СписокОбъектов.Добавить(Документы.РегистрацияСуммыУбыткаУСН);
	СписокОбъектов.Добавить(Документы.РозничнаяПродажа);
	СписокОбъектов.Добавить(Документы.СписаниеМатериаловИзЭксплуатации);
	СписокОбъектов.Добавить(Документы.СписаниеНДС);
	СписокОбъектов.Добавить(Документы.СписаниеНМА);
	СписокОбъектов.Добавить(Документы.СписаниеОС);
	СписокОбъектов.Добавить(Документы.СписаниеСРасчетногоСчета);
	СписокОбъектов.Добавить(Документы.СписаниеТоваров);
	СписокОбъектов.Добавить(Документы.СчетНаОплатуПокупателю);
	СписокОбъектов.Добавить(Документы.СчетНаОплатуПоставщика);
	СписокОбъектов.Добавить(Документы.СчетФактураВыданный);
	СписокОбъектов.Добавить(Документы.СчетФактураПолученный);
	СписокОбъектов.Добавить(Документы.ТребованиеНакладная);
	СписокОбъектов.Добавить(Документы.УстановкаПорядкаЗакрытияПодразделений);
	СписокОбъектов.Добавить(Документы.УстановкаЦенНоменклатуры);
	СписокОбъектов.Добавить(Документы.ФормированиеЗаписейКнигиПокупок);
	СписокОбъектов.Добавить(Документы.ФормированиеЗаписейКнигиПродаж);
	СписокОбъектов.Добавить(Документы.ФормированиеУставногоКапитала);
	СписокОбъектов.Добавить(Документы.ФормированиеЗаписейРаздела7ДекларацииНДС);
	СписокОбъектов.Добавить(Документы.ПередачаЗадолженностиНаФакторинг);
	СписокОбъектов.Добавить(Документы.НачислениеДивидендов);
	
	СписокОбъектов.Добавить(ЖурналыДокументов.Деньги);
	СписокОбъектов.Добавить(ЖурналыДокументов.ДенежныеДокументы);
	СписокОбъектов.Добавить(ЖурналыДокументов.ДокументыПоНМА);
	СписокОбъектов.Добавить(ЖурналыДокументов.ДокументыПоОС);
	СписокОбъектов.Добавить(ЖурналыДокументов.Документы);
	СписокОбъектов.Добавить(ЖурналыДокументов.ЖурналОпераций);
	СписокОбъектов.Добавить(ЖурналыДокументов.ПроизводственныеДокументы);
	СписокОбъектов.Добавить(ЖурналыДокументов.СкладскиеДокументы);
	СписокОбъектов.Добавить(ЖурналыДокументов.ВыплатаЗарплаты);
	
	СписокОбъектов.Добавить(ПланыСчетов.Хозрасчетный);
	
	УчетОбособленныхПодразделений.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);
	
	ЗарплатаКадры.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);
	
	РегламентированнаяОтчетность.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);
	
	ЭлектронноеВзаимодействие.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);
	
	// Квартплата +
	// Добавление в список объектов, подключенных к механизму внешних печатных форм,
	// объектов подсистемы ЖКХ.
	УПЖКХ_УправлениеПечатьюСервер.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);
	// Квартплата -
	
КонецПроцедуры

// Позволяет переопределить список команд печати в произвольной форме.
// Может использоваться для общих форм, у которых нет модуля менеджера для размещения в нем процедуры ДобавитьКомандыПечати,
// для случаев, когда штатных средств добавления команд в такие формы недостаточно. 
// Например, если в общих формах нужны специфические команды печати.
// Вызывается из функции УправлениеПечатью.КомандыПечатиФормы.
// 
// Параметры:
//  ИмяФормы             - Строка - полное имя формы, в которой добавляются команды печати;
//  КомандыПечати        - ТаблицаЗначений - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати;
//  СтандартнаяОбработка - Булево - при установке значения Ложь не будет автоматически заполняться коллекция КомандыПечати.
//
// Пример:
//  Если ИмяФормы = "ОбщаяФорма.ЖурналДокументов" Тогда
//    Если Пользователи.РолиДоступны("ПечатьСчетаНаОплатуНаПринтер") Тогда
//      КомандаПечати = КомандыПечати.Добавить();
//      КомандаПечати.Идентификатор = "Счет";
//      КомандаПечати.Представление = НСтр("ru = 'Счет на оплату (на принтер)'");
//      КомандаПечати.Картинка = БиблиотекаКартинок.ПечатьСразу;
//      КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
//      КомандаПечати.СразуНаПринтер = Истина;
//    КонецЕсли;
//  КонецЕсли;
//
Процедура ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Позволяет задать дополнительные настройки команд печати в журналах документов.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати.
//   * МенеджерКомандПечати     - МенеджерОбъекта - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Если установлено значение Ложь, то список команд печати журнала будет
//                                         заполнен вызовом метода ДобавитьКомандыПечати из модуля менеджера журнала.
//                                         Значение по умолчанию - Истина - метод ДобавитьКомандыПечати будет вызван из
//                                         модулей менеджеров документов, входящих в состав журнала.
//
// Пример:
//   Если НастройкиСписка.МенеджерКомандПечати = "ЖурналДокументов.СкладскиеДокументы" Тогда
//     НастройкиСписка.АвтоматическоеЗаполнение = Ложь;
//   КонецЕсли;
//
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
	Если НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.Деньги
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ДенежныеДокументы
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ДокументыПоНМА
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ДокументыПоОС
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ЖурналОпераций
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ПроизводственныеДокументы
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.СкладскиеДокументы
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.Документы 
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.РозничныеПродажи Тогда
		НастройкиСписка.АвтоматическоеЗаполнение = Ложь;
	КонецЕсли;
	
	ЗарплатаКадры.ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка);
	
КонецПроцедуры

// Позволяет выполнить постобработку печатных форм при их формировании.
// Например, можно вставить в колонтитул дату формирования печатной формы.
// Вызывается после завершения процедуры Печать менеджера печати объекта, имеет те же параметры.
//
// Параметры:
//  МассивОбъектов - Массив - список объектов, для которых была выполнена процедура Печать;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - содержит сформированные табличные документы и дополнительную информацию;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах, где
//                                   значение - Объект, представление - имя области с объектом в табличных документах;
//  ПараметрыВывода - Структура - параметры, связанные с выводом табличных документов:
//   * ПараметрыОтправки - Структура - для заполнения письма при отправке печатной формы по электронной почте.
//                    см. РаботаСПочтовымиСообщениямиКлиент.РаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма.
//
// Пример:
//   ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "АктРеализация");
//   Если ПечатнаяФорма <> Неопределено Тогда
//     ПечатнаяФорма.ТабличныйДокумент.ПолеСлева = 20;
//     ...
//
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет параметры отправки печатных форм при подготовке письма.
// Может использоваться, например, для подготовки текста письма.
//
// Параметры:
//  ПараметрыОтправки - Структура - коллекция параметров:
//   * Получатель - Массив - коллекция имен получателей;
//   * Тема - Строка - тема письма;
//   * Текст - Строка - текст письма;
//   * Вложения - Структура - коллекция вложений:
//    ** АдресВоВременномХранилище - Строка - адрес вложения во временном хранилище;
//    ** Представление - Строка - имя файла вложения.
//  ОбъектыПечати - Массив - коллекция объектов, по которым сформированы печатные формы.
//  ПараметрыВывода - Структура - параметр ПараметрыВывода в вызове процедуры Печать.
//  ПечатныеФормы - ТаблицаЗначений - коллекция табличных документов:
//   * Название - Строка - название печатной формы;
//   * ТабличныйДокумент - ТабличныйДокумент - печатная форма.
//
Процедура ПередОтправкойПоПочте(ПараметрыОтправки, ПараметрыВывода, ОбъектыПечати, ПечатныеФормы) Экспорт
	
	ПакетыЭД = Новый Массив;
	
	Если ПараметрыВывода.Свойство("ФормироватьЭД") И ПараметрыВывода.ФормироватьЭД Тогда
		Вложения = ПараметрыОтправки.Вложения;
		
		ПакетыЭД = ЭлектронноеВзаимодействиеБП.СериализоватьОбъекты(ОбъектыПечати);
		
		Для Каждого ПакетЭД Из ПакетыЭД Цикл
			Вложения.Добавить(ПакетЭД);
		КонецЦикла;
		
	КонецЕсли;
	
	ОтправкаПочтовыхСообщений.ЗаполнитьТемуПолучателяПисьма(ОбъектыПечати,
		ПечатныеФормы,
		ПараметрыОтправки,
		ПакетыЭД.Количество(),
		ПараметрыВывода);
	
КонецПроцедуры

// Определяет набор подписей и печатей для документов.
//
// Параметры:
//  Документы      - Массив    - коллекция ссылок на объекты печати;
//  ПодписиИПечати - Соответствие - коллекция объектов печати и комплектов подписей/печатей к ним:
//   * Ключ     - ЛюбаяСсылка - ссылка на объект печати;
//   * Значение - Структура   - комплект подписей и печатей:
//     ** Ключ     - Строка - идентификатор подписи или печати в макете печатной формы, 
//                            должен начинаться с "Подпись...", "Печать..." или "Факсимиле...",
//                            например, "ПодписьРуководителя", "ПечатьОрганизации";
//     ** Значение - Картинка - изображение подписи или печати.
//
Процедура ПриПолученииПодписейИПечатей(Документы, ПодписиИПечати) Экспорт
	
	
КонецПроцедуры

// Вызывается из обработчика ПриСозданииНаСервере формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Позволяет изменить внешний вид и поведение формы, например, разместить на ней дополнительные элементы:
// информационные надписи, кнопки, гиперссылки, различные настройки и т.п.
//
// При добавлении команд (кнопок) в качестве обработчика следует указывать имя "Подключаемый_ВыполнитьКоманду",
// а его реализацию размещать в УправлениеПечатьюПереопределяемый.ПечатьДокументовПриВыполненииКоманды (серверная часть),
// либо в УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовВыполнитьКоманду (клиентская часть).
//
// Для того, чтобы добавить свою команду на форму, необходимо сделать следующее.
// 1. Создать команду и кнопку в УправлениеПечатьюПереопределяемый.ПечатьДокументовПриСозданииНаСервере.
// 2. Реализовать клиентский обработчик команды в УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовВыполнитьКоманду.
// 3. (Опционально) Реализовать серверный обработчик команды в УправлениеПечатьюПереопределяемый.ПечатьДокументовПриВыполненииКоманды.
//
// При добавлении гиперссылок в качестве обработчика нажатия следует указывать имя "Подключаемый_ОбработкаНавигационнойСсылки",
// а его реализацию размещать в УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовОбработкаНавигационнойСсылки.
//
// При размещении элементов, значение которых должны запоминаться между открытиями формы печати,
// следует воспользоваться процедурами ПечатьДокументовПриЗагрузкеДанныхИзНастроекНаСервере и
// ПечатьДокументовПриСохраненииДанныхВНастройкахНаСервере.
//
// Параметры:
//  Форма                - УправляемаяФорма - форма ОбщаяФорма.ПечатьДокументов.
//  Отказ                - Булево - признак отказа от создания формы. Если установить
//                                  данному параметру значение Истина, то форма создана не будет.
//  СтандартнаяОбработка - Булево - в данный параметр передается признак выполнения стандартной (системной) обработки
//                                  события. Если установить данному параметру значение Ложь, 
//                                  стандартная обработка события производиться не будет.
// 
// Пример:
//  КомандаФормы = Форма.Команды.Добавить("МояКоманда");
//  КомандаФормы.Действие = "Подключаемый_ВыполнитьКоманду";
//  КомандаФормы.Заголовок = НСтр("ru = 'Моя команда'");
//  
//  КнопкаФормы = Форма.Элементы.Добавить(КомандаФормы.Имя, Тип("КнопкаФормы"), Форма.Элементы.КоманднаяПанельПраваяЧасть);
//  КнопкаФормы.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
//  КнопкаФормы.ИмяКоманды = КомандаФормы.Имя;
//
Процедура ПечатьДокументовПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	УправлениеПечатьюБП.ПечатьДокументовПриСозданииНаСервере(Форма);
	
КонецПроцедуры

// Вызывается из обработчика ПриЗагрузкеДанныхИзНастроекНаСервере формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Совместно с ПечатьДокументовПриСохраненииДанныхВНастройкахНаСервере позволяет реализовать загрузку и сохранение 
// настроек элементов управления, размещенных с помощью ПечатьДокументовПриСозданииНаСервере.
//
// Параметры:
//  Форма     - УправляемаяФорма - форма ОбщаяФорма.ПечатьДокументов.
//  Настройки - Соответствие     - значения реквизитов формы.
//
Процедура ПечатьДокументовПриЗагрузкеДанныхИзНастроекНаСервере(Форма, Настройки) Экспорт
	
КонецПроцедуры

// Вызывается из обработчика ПриСохраненииДанныхВНастройкахНаСервере формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Совместно с ПечатьДокументовПриЗагрузкеДанныхИзНастроекНаСервере позволяет реализовать загрузку и сохранение 
// настроек элементов управления, размещенных с помощью ПечатьДокументовПриСозданииНаСервере.
//
// Параметры:
//  Форма     - УправляемаяФорма - форма ОбщаяФорма.ПечатьДокументов.
//  Настройки - Соответствие     - значения реквизитов формы.
//
Процедура ПечатьДокументовПриСохраненииДанныхВНастройкахНаСервере(Форма, Настройки) Экспорт

КонецПроцедуры

// Вызывается из обработчика Подключаемый_ВыполнитьКоманду формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Позволяет реализовать серверную часть обработчика команды, которая добавлена в форму 
// с помощью ПечатьДокументовПриСозданииНаСервере.
//
// Параметры:
//  Форма                   - УправляемаяФорма - форма ОбщаяФорма.ПечатьДокументов.
//  ДополнительныеПараметры - Произвольный     - параметры, переданные из УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовВыполнитьКоманду.
//
// Пример:
//  Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") И ДополнительныеПараметры.ИмяКоманды = "МояКоманда" Тогда
//   ТабличныйДокумент = Новый ТабличныйДокумент;
//   ТабличныйДокумент.Область("R1C1").Текст = НСтр("ru = 'Пример использования серверного обработчика подключенной команды.'");
//  
//   ПечатнаяФорма = Форма[ДополнительныеПараметры.ИмяРеквизитаТабличногоДокумента];
//   ПечатнаяФорма.ВставитьОбласть(ТабличныйДокумент.Область("R1"), ПечатнаяФорма.Область("R1"), 
//    ТипСмещенияТабличногоДокумента.ПоГоризонтали)
//  КонецЕсли;
//
Процедура ПечатьДокументовПриВыполненииКоманды(Форма, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

#КонецОбласти
