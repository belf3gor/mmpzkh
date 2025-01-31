
#Область СлужебныеПроцедурыИФункции

// Функция предназначена для выбора доступной организации
// для указания её в новой записи регистра сведений "Настройки формирования платежного документа".
Функция СформироватьСписокДоступныхОрганизацийИВыбратьОдну() Экспорт
	
	ВыбраннаяОрганизация = Неопределено;
	
	СписокОрганизацийБезЭлементов = ПолучитьСписокОрганизацийБезЭлементов();
	Если СписокОрганизацийБезЭлементов.Количество() = 0 Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке("Настройки формирования платежного документа уже заданы для всех организаций!");
		Отказ = Истина;
	ИначеЕсли СписокОрганизацийБезЭлементов.Количество() = 1 Тогда
		ВыбраннаяОрганизация = СписокОрганизацийБезЭлементов[0].Значение;
	Иначе
		//// 2. Открываем форму выбор справочника "Организации" с отбором по организациям, полученным в п.1.
		ФормаВыбора = ПолучитьФорму("Справочник.Организации.Форма.ФормаВыбора");
		
		УПЖКХ_ТиповыеМетодыКлиентСервер.УстановитьЭлементОтбора(ФормаВыбора.Список.КомпоновщикНастроек.Настройки.Отбор, "Ссылка", СписокОрганизацийБезЭлементов,
																ВидСравненияКомпоновкиДанных.ВСписке, , Истина,
																РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		
		ФормаВыбора.Элементы.Список.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.ГруппыИЭлементы;
		
		ВыбранноеЗначение = ФормаВыбора.ОткрытьМодально();
		
	КонецЕсли;
	
	Возврат ВыбраннаяОрганизация;
	
КонецФункции // СформироватьСписокДоступныхОрганизацийИВыбратьОдну()

// Предназначена для получения списка организаций, для которых в базе не созданы 
// элементы справочника "УПЖКХ_НастройкиУчетаКапремонта".
Функция ПолучитьСписокОрганизацийБезЭлементов()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УПЖКХ_НастройкиФормированияПлатежногоДокумента.Организация
	|ПОМЕСТИТЬ втОрганизацииСЗаписями
	|ИЗ
	|	РегистрСведений.УПЖКХ_НастройкиФормированияПлатежногоДокумента КАК УПЖКХ_НастройкиФормированияПлатежногоДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.Ссылка В
	|				(ВЫБРАТЬ
	|					втОрганизацииСЗаписями.Организация
	|				ИЗ
	|					втОрганизацииСЗаписями КАК втОрганизацииСЗаписями)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	СписокОрганизаций = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
		СписокОрганизаций.Добавить(Выборка.Организация);
	КонецЦикла;
	
	Возврат СписокОрганизаций;
	
КонецФункции // ПолучитьСписокОрганизацийБезЭлементов()

// Функция формирует список параметров для текста дополнительного реквизита "Наименование платежа (назначение)" QR-штрихкода.
//
Функция ПолучитьСписокПараметровДляТекстаНаименованиеПлатежаНазначение() Экспорт
	
	СписокПараметров = Новый СписокЗначений;
	СписокПараметров.Добавить("ПериодОплатыМесяцСтрокойГод", "[ПериодОплатыМесяцСтрокойГод] – параметр будет заменен на период формирования квитанции в формате Февраль 2018.");
	СписокПараметров.Добавить("ПериодОплатыМесяцЧисломГод",  "[ПериодОплатыМесяцЧисломГод] – параметр будет заменен на период формирования квитанции в формате «02.2018».");
	
	Возврат СписокПараметров;
	
КонецФункции

#КонецОбласти