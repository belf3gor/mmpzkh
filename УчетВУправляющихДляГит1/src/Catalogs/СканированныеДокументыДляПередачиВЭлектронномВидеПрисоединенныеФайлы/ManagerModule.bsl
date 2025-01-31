#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые разрешается редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Возврат РаботаСФайлами.РеквизитыРедактируемыеВГрупповойОбработке();
	
КонецФункции

// Обработчик обновления БРО 1.1.5
// Заполняет данными из регистра сведений ФайлыДокументовРеализацииПолномочийНалоговыхОрганов
//
Процедура ВыполнитьНачальноеЗаполнение(Параметры) Экспорт
	
	Параметры.ОбработкаЗавершена = Истина;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФайлыДокументовРеализацииПолномочийНалоговыхОрганов.Документ КАК Документ,
		|	ФайлыДокументовРеализацииПолномочийНалоговыхОрганов.ИмяФайла КАК ИмяФайла,
		|	ФайлыДокументовРеализацииПолномочийНалоговыхОрганов.Данные,
		|	ФайлыДокументовРеализацииПолномочийНалоговыхОрганов.НомерСтраницы КАК НомерСтраницы
		|ИЗ
		|	РегистрСведений.ФайлыДокументовРеализацииПолномочийНалоговыхОрганов КАК ФайлыДокументовРеализацииПолномочийНалоговыхОрганов
		|ГДЕ
		|	ФайлыДокументовРеализацииПолномочийНалоговыхОрганов.Документ ССЫЛКА Справочник.СканированныеДокументыДляПередачиВЭлектронномВиде
		|	И ФайлыДокументовРеализацииПолномочийНалоговыхОрганов.Документ <> ЗНАЧЕНИЕ(Справочник.СканированныеДокументыДляПередачиВЭлектронномВиде.ПустаяСсылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтраницы
		|ИТОГИ ПО
		|	Документ";

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДокумент = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ВыборкаДокумент.Следующий() Цикл
		СканДокумент = ВыборкаДокумент.Документ;
		ВыборкаИмяФайла = ВыборкаДокумент.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		//все номера страниц будут проставлены автоматически после предварительного упорядочивания по уже введенным вручную значениям
		НомерСтраницы = 1;
		
		НачатьТранзакцию();
		Попытка
			Пока ВыборкаИмяФайла.Следующий() Цикл
				АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ВыборкаИмяФайла.Данные.Получить());
				
				//добавим файл
				
				ДополнительныеПараметры = Новый Структура();
				ДополнительныеПараметры.Вставить("ВладелецФайлов", 		СканДокумент);
				ДополнительныеПараметры.Вставить("ИмяБезРасширения", 	ВыборкаИмяФайла.ИмяФайла);
				ДополнительныеПараметры.Вставить("Автор", 				Неопределено);
				ДополнительныеПараметры.Вставить("РасширениеБезТочки", 	Неопределено);
				ДополнительныеПараметры.Вставить("ВремяИзмененияУниверсальное", Неопределено);
								
				ПрисоединенныйФайлСсылка = РаботаСФайлами.ДобавитьФайл(
					ДополнительныеПараметры,
					АдресВоВременномХранилище);
				
				//назначим номер страницы
				ПрисоединенныйФайлОбъект = ПрисоединенныйФайлСсылка.ПолучитьОбъект();
				ПрисоединенныйФайлОбъект.НомерСтраницы = НомерСтраницы;
				НомерСтраницы = НомерСтраницы + 1;
				ПрисоединенныйФайлОбъект.Записать();
			КонецЦикла;
			
			//все файлы записаны, удалим их в регистре сведений
			НаборЗаписей = РегистрыСведений.ФайлыДокументовРеализацииПолномочийНалоговыхОрганов.СоздатьНаборЗаписей(); 
			НаборЗаписей.Отбор.Документ.Установить(СканДокумент);
			НаборЗаписей.Записать();
			
			ЗафиксироватьТранзакцию();	
		Исключение
			ОтменитьТранзакцию();
			// Пишем в журнал
			ОписаниеОшибки = ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Заполнение справочника СканированныеДокументыДляПередачиВЭлектронномВидеПрисоединенныеФайлы'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Предупреждение, , , ОписаниеОшибки);
				
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
