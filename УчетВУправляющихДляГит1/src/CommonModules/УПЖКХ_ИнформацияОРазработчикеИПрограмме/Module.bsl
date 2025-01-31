
#Область ОбращениеВТехническуюПоддержку

// Возвращает адрес технической поддержки для отправки сообщения
//
Функция АдресТехническойПоддержки() Экспорт
	
	Возврат "otr@rarus.ru";
	
КонецФункции

#КонецОбласти

#Область КонтактнаяИнформацияСайтов

Функция АдресГлавнойСтраницыСайтаКомпании(МаркерИсточникаПерехода = "") Экспорт
	
	Возврат "https://otr-soft.ru/" + МаркерИсточникаПерехода;
	
КонецФункции

Функция АдресСтраницыСтарогоСайтаКомпании() Экспорт
	
	Возврат "https://vdgb-soft.ru";
	
КонецФункции

Функция АдресСтраницыМобильныеПриложения() Экспорт
	
	Возврат "https://otr-soft.ru/mobile_apps/";
	
КонецФункции

Функция АдресСтраницыСКонтактамиКомпании(МаркерИсточникаПерехода = "") Экспорт
	
	// Если маркер источника перехода передан в функцию, а значит выполняется открытие по гиперссылке,
	// то возвращаем короткий адрес страницы с КИ с подсктрокой маркера.
	// Иначе возвращаем полный адрес страницы с КИ.
	Если МаркерИсточникаПерехода = "" Тогда
		Возврат "https://vgkh.ru/contacts/";
	Иначе
		Возврат "https://vgkh.ru/" + МаркерИсточникаПерехода;
	КонецЕсли;
	
КонецФункции

Функция АдресСтраницыСРелизами(МаркерИсточникаПерехода = "") Экспорт
	
	Возврат "https://otr-soft.ru/" + МаркерИсточникаПерехода;
	
КонецФункции

Функция АдресСтраницыРазделаОбщиеВопросы() Экспорт
	
	Возврат "https://otr-soft.ru/faq/faq_common/";
	
КонецФункции

Функция АдресСтраницыРазделаЧастоЗадаваемыеВопросы(МаркерИсточникаПерехода = "") Экспорт
	
	Возврат "https://vgkh.ru/" + МаркерИсточникаПерехода;
	
КонецФункции

Функция АдресСтраницыЧастоЗадаваемыеВопросыПоВДГБ() Экспорт
	
	Возврат "https://vgkh.ru/faq/faq_tsj/";
	
КонецФункции

Функция АдресСтраницыСопровождениеПользователей() Экспорт
	
	Возврат "https://otr-soft.ru/soprovogdenie/";
	
КонецФункции

Функция АдресСтраницыРекомендацииПоИспользованиюКоличестваПотоков() Экспорт
	
	Возврат "https://vgkh.ru/faq/faq_tsj_3_0/рекомендации_по_использованию_количества_потоков/";
	
КонецФункции

Функция АдресСтраницыСервисЗагрузкиДанныхИзСистемСбораПоказанийСчетчиков() Экспорт
	
	Возврат "https://vgkh.ru/jsk/jkh/saures/";
	
КонецФункции

Функция АдресСпискаНормативныхАктовЖКХ() Экспорт
	
	Возврат "https://vgkh.ru/jsk/law/";
	
КонецФункции

Функция АдресСтраницыИнтеграциясОблакомКомпанииSaures() Экспорт
	
	Возврат "https://vgkh.ru/faq/faq_tsj_3_0/integraciya_saures/";
	
КонецФункции

#КонецОбласти

#Область КонтактнаяИнформацияНомераТелефонов

Функция НомерТелефонаДляМосквыИМосковскойОбласти() Экспорт
	
	Возврат "+ 7 (495) 777-25-43";
	
КонецФункции

Функция НомерТелефонаДляРегионов() Экспорт
	
	Возврат "+ 7 (836) 249-46-89";
	
КонецФункции

Функция НомерТелефонаДляWhatsAppViberTelegram() Экспорт
	
	Возврат "+7 927 889-63-69";
	
КонецФункции

Функция КонтактыДляОбратнойСвязиСтрокой() Экспорт
	
	КонтактнаяИнформация = Символы.ПС + "Тел. для Москвы и Московской Области: " + НомерТелефонаДляМосквыИМосковскойОбласти() + "." + Символы.ПС
									  + "Тел. для регионов: " + НомерТелефонаДляРегионов() + "." + Символы.ПС
									  + "Иные контактные данные можете найти на сайте: " + АдресСтраницыСКонтактамиКомпании() + ".";
	
	Возврат КонтактнаяИнформация;
	
КонецФункции

Функция КонтактыДляОбратнойСвязиHTML() Экспорт
	
	КонтактнаяИнформация = "Тел. для Москвы и Московской Области: " + НомерТелефонаДляМосквыИМосковскойОбласти() + ".<br>"
						 + "Тел. для регионов: " + НомерТелефонаДляРегионов() + ".<br>"
						 + "Skype: " + КонтактыSkypeДляОбратнойСвязи() + ".<br>"
						 + "Адрес технической поддержки: <A href='mailto:" + АдресТехническойПоддержки() + "'>" + АдресТехническойПоддержки() + "</A>.<br>"
						 + "Номер телефона для WhatsApp, Viber и Telegram: " + НомерТелефонаДляРегионов() + ".<br>"
						 + "Иные контактные данные можете найти на сайте: <A href='" + АдресСтраницыСКонтактамиКомпании() + "'>" + АдресСтраницыСКонтактамиКомпании() + "</A>.";
	
	Возврат КонтактнаяИнформация;
	
КонецФункции

#КонецОбласти

#Область КонтактнаяИнформацияSkype

Функция КонтактыSkypeДляОбратнойСвязи() Экспорт
	
	Возврат "vdgb_sale, vdgb_sale2, vdgb_sale4";
	
КонецФункции

#КонецОбласти

#Область ДанныеКонфигурации

Функция НаименованиеКонфигурации() Экспорт
	
	Возврат "УчетВУправляющихКомпанияхБазовая";
	
КонецФункции

#КонецОбласти