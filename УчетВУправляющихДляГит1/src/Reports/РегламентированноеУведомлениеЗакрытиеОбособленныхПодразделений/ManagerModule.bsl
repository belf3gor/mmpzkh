#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Ложь;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеЗакрытиеОбособленныхПодразделений.Форма.Форма2014_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2014_1";
	Стр.ОписаниеФормы = "С-09-3-2/приказ ФНС от 09.06.2011 N ММВ-7-6/362@";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ПечатьСразу_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат СформироватьМакет_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2014_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2014_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Данные.Вставить("Организация", Объект.Организация);
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2014_1(Данные, УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция СформироватьМакет_Форма2014_1(Объект)
	ПечатнаяФорма = Новый ТабличныйДокумент;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УведомлениеОСпецрежимах_"+Объект.ВидУведомления.Метаданные().Имя;
	
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_MXL_Форма2014_1");
	ОбластьТитульный = МакетУведомления.ПолучитьОбласть("Титульный");
	ПараметрыМакета = ОбластьТитульный.Параметры;
	СтруктураПараметров = Объект.ДанныеУведомления.Получить();
	Титульный = СтруктураПараметров.Титульный[0];
	
	ОбластьТитульный = МакетУведомления.ПолучитьОбласть("Титульный");
	ОбластьПодвалТитульный = МакетУведомления.ПолучитьОбласть("ОбластьПодвалТитульный");
	ОбластьПустаяСтрока = МакетУведомления.ПолучитьОбласть("ОбластьПустаяСтрока");
	МассивДляПроверки = Новый Массив;
	МассивДляПроверки.Добавить(ОбластьПустаяСтрока);
	МассивДляПроверки.Добавить(ОбластьПодвалТитульный);
	
	ПараметрыМакета = ОбластьТитульный.Параметры;
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.П_ИНН, "ИНН_", ПараметрыМакета, 10);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.П_КПП, "КПП_", ПараметрыМакета, 9);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.КОД_НО, "КОД_НО_", ПараметрыМакета, 4);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.НАИМЕНОВАНИЕ_ОРГАНИЗАЦИИ, "ОрганизацияНазвание_", ПараметрыМакета, 160);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ОГРН, "ОГРН_", ПараметрыМакета, 13);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Титульный.КОЛИЧЕСТВО_ПОДРАЗДЕЛЕНИЙ, "Количество_Подразделений_", ПараметрыМакета, 4);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Титульный.КОЛИЧЕСТВО_СТРАНИЦ, "КоличествоСтраниц_", ПараметрыМакета, 4);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Титульный.ПРИЛОЖЕНО_ЛИСТОВ, "ПриложеноЛистов_", ПараметрыМакета, 3);
	ПараметрыМакета.ПризнакПодписанта = Титульный.ПРИЗНАК_НП_ПОДВАЛ;
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантФамилия, "ОргПодписантФамилия_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантИмя, "ОргПодписантИмя_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантОтчество, "ОргПодписантОтчество_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ИНН_ПОДПИСАНТА, "ИНН_ПОДПИСАНТ_", ПараметрыМакета, 12);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ТЕЛЕФОН, "Телефон_", ПараметрыМакета, 20);
	ПараметрыМакета.Email = Титульный.EMAIL_ПОДПИСАНТА;
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ, "ДокументПредставителя_", ПараметрыМакета, 40);
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Титульный.ДАТА_ПОДПИСИ, "ДатаПодписи_", ПараметрыМакета);
	
	ПечатнаяФорма.Вывести(ОбластьТитульный);
		
	Пока ПечатнаяФорма.ПроверитьВывод(МассивДляПроверки) Цикл 
		ПечатнаяФорма.Вывести(ОбластьПустаяСтрока);
	КонецЦикла;
	
	ПечатнаяФорма.Вывести(ОбластьПодвалТитульный);
	ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
	
	ОбластьПодвалДопЛист = МакетУведомления.ПолучитьОбласть("ОбластьПодвалДопЛист");
	МассивДляПроверки[1] = ОбластьПодвалДопЛист;
	
	Страница = 1;
	Для Каждого ДопЛист Из СтруктураПараметров.ДопЛисты Цикл 
		
		ОбластьДопЛист = МакетУведомления.ПолучитьОбласть("ОбластьДопЛист");
		ПараметрыМакета = ОбластьДопЛист.Параметры;
		Страница = Страница + 1;
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.П_ИНН, "ИНН_", ПараметрыМакета, 10);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.П_КПП, "КПП_", ПараметрыМакета, 9);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета("0000", "СТР_", ПараметрыМакета, 4);
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Страница, "СТР_", ПараметрыМакета, 4);
		ПараметрыМакета.ПризнакЗакрытия = ДопЛист.ПРИЗНАК_ЗАКРЫТИЯ;
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.КПП_ПОДРАЗДЕЛЕНИЯ, "КПППодр_", ПараметрыМакета, 9);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.НАМИНОВАНИЕ_ПОДРАЗДЕЛЕНИЯ, "ОрганизацияНазвание_", ПараметрыМакета, 160);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.ИНДЕКС, "Индекс_", ПараметрыМакета, 6);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.КОД_РЕГИОНА, "КодРегиона_", ПараметрыМакета, 2);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.РАЙОН, "Район_", ПараметрыМакета, 34);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.ГОРОД, "Город_", ПараметрыМакета, 34);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.НАСЕЛЕННЫЙ_ПУНКТ, "НаселенныйПункт_", ПараметрыМакета, 34);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.УЛИЦА, "Улица_", ПараметрыМакета, 34);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.ДОМ, "Дом_", ПараметрыМакета, 8);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.КОРПУС, "Корпус_", ПараметрыМакета, 8);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.КВАРТИРА, "Квартира_", ПараметрыМакета, 8);
		Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(ДопЛист.ДАТА_ВНЕСЕНИЯ_ИЗМЕНЕНИЙ, "ДатаСоздания_", ПараметрыМакета);
		
		ПечатнаяФорма.Вывести(ОбластьДопЛист);
				
			Пока ПечатнаяФорма.ПроверитьВывод(МассивДляПроверки) Цикл 
				ПечатнаяФорма.Вывести(ОбластьПустаяСтрока);
			КонецЦикла;
		
		ПечатнаяФорма.Вывести(ОбластьПодвалДопЛист);
		ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
		
	КонецЦикла;
	
	Возврат ПечатнаяФорма;
КонецФункции

Функция ПечатьСразу_Форма2014_1(Объект)
	
	ПечатнаяФорма = СформироватьМакет_Форма2014_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(СведенияОтправки)
	Префикс = "UT_SBZAKR";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Процедура Проверить_Форма2014_1(Данные, УникальныйИдентификатор)
	Титульный = Данные.Титульный[0];
	Ошибок = 0;
	
	Если Не ЗначениеЗаполнено(Титульный.КОЛИЧЕСТВО_ПОДРАЗДЕЛЕНИЙ) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указано количество подразделений на титульном листе", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если (Не ЗначениеЗаполнено(Титульный.ОГРН))
		Или (Не ЗначениеЗаполнено(Титульный.П_ИНН))
		Или (Не ЗначениеЗаполнено(Титульный.П_КПП))Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнен ИНН/КПП/ОГРН на титульном листе", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Страница = 0;
	Для Каждого ДопЛист Из Данные.ДопЛисты Цикл
		Страница = Страница + 1;
		
		Если Не ЗначениеЗаполнено(ДопЛист.ПРИЗНАК_ЗАКРЫТИЯ) Тогда 
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан признак ""филиал/представительство"" (доп. лист " + Страница + ")", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДопЛист.КПП_ПОДРАЗДЕЛЕНИЯ) Тогда 
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указано КПП подразделения (доп. лист " + Страница + ")", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДопЛист.ДАТА_ВНЕСЕНИЯ_ИЗМЕНЕНИЙ) Тогда 
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указана дата закрытия (доп. лист " + Страница + ")", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДопЛист.КОД_РЕГИОНА) Тогда 
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан адрес (доп. лист " + Страница + ")", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
		
		Если Ошибок > 3 Тогда
			ВызватьИсключение "";
		КонецЕсли;
	КонецЦикла;
	
	Если Ошибок > 0 Тогда
		ВызватьИсключение "";
	КонецЕсли;
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация));
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьОбщиеДанные(Объект, ОсновныеСведения);
	
	Данные = Объект.ДанныеУведомления.Получить();
	Титульный = Данные.Титульный[0];
	
	ОсновныеСведения.Вставить("ИННФЛ", Титульный.ИНН_ПОДПИСАНТА);
	ОсновныеСведения.Вставить("НаимДок", Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ);
	ОсновныеСведения.Вставить("ПрПодп", Титульный.ПРИЗНАК_НП_ПОДВАЛ);
	ОсновныеСведения.Вставить("Тлф", Титульный.ТЕЛЕФОН);
	ОсновныеСведения.Вставить("email", Титульный.EMAIL_ПОДПИСАНТА);
	ОсновныеСведения.Вставить("КолОП", Титульный.КОЛИЧЕСТВО_ПОДРАЗДЕЛЕНИЙ);
	ОсновныеСведения.Вставить("ОГРН", Титульный.ОГРН);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2014_1(ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""");
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""");
		КонецЕсли;
	КонецЕсли;
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2014_1");
	ЗаполнитьДанными_Форма2014_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ЗаполнитьДанными_Форма2014_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(Параметры, ДеревоВыгрузки);
	
	Данные = Объект.ДанныеУведомления.Получить();
	ДопЛисты = Данные.ДопЛисты;
	ПрСообщ = Данные.Титульный[0].ПРИЗНАК_СООБЩЕНИЯ;
	
	Узел_Документ = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(ДеревоВыгрузки, "Документ");
	Узел_СБЗАКР = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "СБЗАКР");
	Узел_СведОП = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_СБЗАКР, "СведОП");
	
	НомерДопЛиста = 0;
	Для Каждого ДопЛист Из ДопЛисты Цикл
		НомерДопЛиста = НомерДопЛиста + 1;
		НовыйУзел_СведОП = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Узел_СведОП);
		
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел_СведОП, "ПрСообщ", ДопЛист.ПРИЗНАК_ЗАКРЫТИЯ);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел_СведОП, "КПП", ДопЛист.КПП_ПОДРАЗДЕЛЕНИЯ);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел_СведОП, "НаимОП", ДопЛист.НАМИНОВАНИЕ_ПОДРАЗДЕЛЕНИЯ);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел_СведОП, "ДатаЗакр", Формат(ДопЛист.ДАТА_ВНЕСЕНИЯ_ИЗМЕНЕНИЙ, "ДФ=dd.MM.yyyy"));
		
		Узел_АдрОП = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(НовыйУзел_СведОП, "АдрОП");
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОП, "Индекс", ДопЛист.ИНДЕКС);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОП, "КодРегион", ДопЛист.КОД_РЕГИОНА);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОП, "Район", ДопЛист.РАЙОН);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОП, "Город", ДопЛист.ГОРОД);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОП, "НаселПункт", ДопЛист.НАСЕЛЕННЫЙ_ПУНКТ);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОП, "Улица", ДопЛист.УЛИЦА);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОП, "Дом", ДопЛист.ДОМ);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОП, "Корпус", ДопЛист.КОРПУС);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОП, "Кварт", ДопЛист.КВАРТИРА);
	КонецЦикла;
	
	РегламентированнаяОтчетность.УдалитьУзел(Узел_СведОП);
КонецПроцедуры

Функция ПроверитьДокументСВыводомВТаблицу_Форма2014_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	
	Титульный = Данные.Титульный[0];
	
	Если Не ЗначениеЗаполнено(Титульный.КОЛИЧЕСТВО_ПОДРАЗДЕЛЕНИЙ) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано количество подразделений на титульном листе", "Титульный", "КОЛИЧЕСТВО_ПОДРАЗДЕЛЕНИЙ", Титульный.UID));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.ОГРН) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ОГРН на титульном листе", "Титульный", "ОГРН", Титульный.UID));
	ИначеЕсли СтрДлина(СокрЛП(Титульный.ОГРН)) <> 13 Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульный.ОГРН)) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ОГРН на титульном листе", "Титульный", "ОГРН", Титульный.UID));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.П_ИНН) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ИНН на титульном листе", "Титульный", "П_ИНН", Титульный.UID));
	ИначеЕсли СтрДлина(СокрЛП(Титульный.П_ИНН)) <> 10 Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульный.П_ИНН)) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН на титульном листе", "Титульный", "П_ИНН", Титульный.UID));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.П_КПП) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан КПП на титульном листе", "Титульный", "П_КПП", Титульный.UID));
	ИначеЕсли СтрДлина(СокрЛП(Титульный.П_КПП)) <> 9 Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульный.П_КПП)) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан КПП на титульном листе", "Титульный", "П_КПП", Титульный.UID));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.ДАТА_ПОДПИСИ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата подписи", "Титульный", "ДАТА_ПОДПИСИ"));
	КонецЕсли;
	
	Для Каждого ДопЛист Из Данные.ДопЛисты Цикл
		Если Не ЗначениеЗаполнено(ДопЛист.ПРИЗНАК_ЗАКРЫТИЯ) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак ""филиал/представительство""", "ДопЛист", "ПРИЗНАК_ЗАКРЫТИЯ", ДопЛист.UID));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ДопЛист.КПП_ПОДРАЗДЕЛЕНИЯ) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано КПП подразделения", "ДопЛист", "КПП_ПОДРАЗДЕЛЕНИЯ", ДопЛист.UID));
		ИначеЕсли СтрДлина(СокрЛП(ДопЛист.КПП_ПОДРАЗДЕЛЕНИЯ)) <> 9 Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(ДопЛист.КПП_ПОДРАЗДЕЛЕНИЯ)) Тогда
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указано КПП подразделения", "ДопЛист", "КПП_ПОДРАЗДЕЛЕНИЯ", ДопЛист.UID));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ДопЛист.ДАТА_ВНЕСЕНИЯ_ИЗМЕНЕНИЙ) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата закрытия", "ДопЛист", "ДАТА_ВНЕСЕНИЯ_ИЗМЕНЕНИЙ", ДопЛист.UID));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ДопЛист.КОД_РЕГИОНА) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан адрес", "ДопЛист", "КОД_РЕГИОНА", ДопЛист.UID));
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТаблицаОшибок;
КонецФункции

#КонецОбласти
#КонецЕсли