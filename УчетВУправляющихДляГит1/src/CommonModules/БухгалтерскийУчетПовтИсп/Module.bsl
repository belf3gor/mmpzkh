#Область СвойстваСчетов

Функция СчетУчетаКомиссионногоТовара(Счет) Экспорт
	
	Комиссионный = ТипЗнч(Счет) = Тип("ПланСчетовСсылка.Хозрасчетный")
		И Счет <> ПланыСчетов.Хозрасчетный.ПустаяСсылка()
		И Счет.ПринадлежитЭлементу(ПланыСчетов.Хозрасчетный.ТоварыПринятыеНаКомиссию);
	
	Возврат Комиссионный;
	
КонецФункции

Функция СчетВИерархии(Счет, Эталон) Экспорт

	Если ЗначениеЗаполнено(Счет) Тогда
		Возврат Счет = Эталон ИЛИ Счет.ПринадлежитЭлементу(Эталон);
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

Функция СчетаВИерархии(СчетГруппа) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СчетГруппа) Тогда
		Возврат Новый ФиксированныйМассив(Новый Массив);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СчетГруппа", СчетГруппа);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Счет
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&СчетГруппа)";
	Субсчета = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Счет");
	
	Возврат Новый ФиксированныйМассив(Субсчета);

КонецФункции

#КонецОбласти

#Область СчетаЕНВД

Функция СчетОтноситсяКДеятельностиЕНВД(Счет) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Рег.Счет
	|ИЗ
	|	РегистрСведений.СчетаДоходовИРасходовЕНВД КАК Рег
	|ГДЕ
	|	Рег.Счет = &Счет";
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции 

Функция СчетаВыручкиЕНВД() Экспорт

	Возврат БухгалтерскийУчетПереопределяемый.СчетаВыручкиЕНВД();

КонецФункции

Функция СчетаВыручкиНеЕНВД() Экспорт

	Возврат БухгалтерскийУчетПереопределяемый.СчетаВыручкиНеЕНВД();

КонецФункции

Функция СчетаРасходовЕНВД() Экспорт

	Возврат БухгалтерскийУчетПереопределяемый.СчетаРасходовЕНВД();

КонецФункции

Функция СчетаУчетаЕНВД() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СчетаДоходовИРасходовЕНВД.Счет
	|ИЗ
	|	РегистрСведений.СчетаДоходовИРасходовЕНВД КАК СчетаДоходовИРасходовЕНВД";
	
	ТаблицаСчетов = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаСчетов.ВыгрузитьКолонку("Счет");
	
КонецФункции

#КонецОбласти

#Область ФормированиеПроводок

// Функция предназначена для определения названия объекта
// учета по его счету учета. Название объекта выдается в родительном падеже
Функция НазваниеОбъектаПоСчетуУчета(СчетУчета) Экспорт
	
	Если БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ВложенияВоВнеоборотныеАктивы) Тогда
		
		Если БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ПриобретениеЗемельныхУчастков) Тогда
			
			Возврат "земельных участков";
			
		ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ПриобретениеОбъектовПриродопользования) Тогда
			
			Возврат "объектов природопользования";
			
		ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.СтроительствоОбъектовОсновныхСредств) Тогда
			
			Возврат "объектов строительства";
			
		ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ПриобретениеКомпонентовОсновныхСредств) Тогда
			
			Возврат "оборудования";
			
		ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ПриобретениеНематериальныхАктивов) Тогда
			
			Возврат "нематериальных активов";
			
		ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ВыполнениеНИОКР) Тогда
			
			Возврат "НИОКР";
			
		Иначе
			
			Возврат "внеоборотных активов";
			
		КонецЕсли;
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.Материалы) Тогда
		
		Если БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ИнвентарьИХозяйственныеПринадлежности) Тогда
			
			Возврат "инвентаря";
			
		ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.СпецодеждаВЭксплуатации) Тогда
			
			Возврат "спецодежды";
			
		ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.СпецоснасткаВЭксплуатации) Тогда
			
			Возврат "спецоснастки";
			
		Иначе
			
			Возврат "материалов";
			
		КонецЕсли;
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ОборудованиеКУстановке) Тогда
		
		Возврат "оборудования";
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ПроизводствоИзДавальческогоСырья) Тогда
		
		Возврат "продукции для давальца";
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.Полуфабрикаты) Тогда
		
		Возврат "полуфабрикатов";
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.Товары) Тогда
		
		Возврат "товаров";
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ТорговаяНаценка) Тогда
		
		Возврат "торговой наценки";
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ГотоваяПродукция) Тогда
		
		Возврат "продукции";
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ТоварыОтгруженные) Тогда
		
		Возврат "отгруженных товаров";
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ОСвОрганизации) Тогда
		
		Возврат "основных средств";
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.МЦвОрганизации) Тогда
		
		Возврат "материальных ценностей";
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.АрендованныеОсновныеСредства) Тогда
		
		Возврат "арендованных основных средств";
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ТМЦпринятыеНаОтветственноеХранение) Тогда
		
		Возврат "товаров (ответственное хранение)";
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.МатериалыПринятыеВПереработку_) Тогда
		
		Возврат "материалов в переработку";
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ТоварыПринятыеНаКомиссию) Тогда
		
		Возврат "товаров комитента";
		
	ИначеЕсли БухгалтерскийУчетПовтИсп.СчетВИерархии(СчетУчета, ПланыСчетов.Хозрасчетный.ОборудованиеПринятоеДляМонтажа) Тогда
		
		Возврат "оборудования для монтажа";
		
	Иначе
		
		Возврат "запасов";
		
	КонецЕсли;

КонецФункции

#КонецОбласти
