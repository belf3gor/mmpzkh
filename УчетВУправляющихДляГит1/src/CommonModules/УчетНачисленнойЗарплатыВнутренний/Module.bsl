
#Область СлужебныйПрограммныйИнтерфейс

// Процедура предназначена для выполнения действия, сопряженных с регистрацией отработанного времени.
//
Процедура ПриРегистрацииОтработанногоВремени(Движения, ЗаписыватьДвижения = Ложь) Экспорт
	
КонецПроцедуры

Процедура ПриРегистрацииНачисленийУдержанийПоСотрудникам(Движения, Отказ, ДобавленныеСтрокиНачислений, ПорядокВыплаты, ПериодРегистрации) Экспорт
	
КонецПроцедуры

// См. УчетНачисленнойЗарплаты.ЗарегистрироватьНДФЛИКорректировкиВыплаты
//
Процедура ЗарегистрироватьНДФЛИКорректировкиВыплаты(ДанныеДляПроведения, Отказ, НДФЛПоСотрудникам, КорректировкиВыплатыПоСотрудникам, ЗаписыватьДвижения) Экспорт
	
	УчетНачисленнойЗарплатыБазовый.ЗарегистрироватьНДФЛИКорректировкиВыплаты(ДанныеДляПроведения, Отказ, НДФЛПоСотрудникам, КорректировкиВыплатыПоСотрудникам, ЗаписыватьДвижения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПравилаУчетаНачисленийСотрудников() Экспорт

	Возврат УчетНачисленнойЗарплатыБазовый.ПравилаУчетаНачисленийСотрудников();

КонецФункции 

Процедура СкорректироватьДатыНачисленийБезПериодаДействия(ТаблицаНачислений, ПериодРегистрации, ИмяПоляНачисления = "НачислениеУдержание") Экспорт
	
КонецПроцедуры

#Область ПроцедурыИФункцииРаботыСОтчетами

// Формирование отчета Анализ начислений и удержаний.
//
Процедура ПриКомпоновкеОтчетаАнализНачисленийИУдержаний(Отчет, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, НаАванс = Ложь) Экспорт
	УчетНачисленнойЗарплатыБазовый.ПриКомпоновкеОтчетаАнализНачисленийИУдержаний(Отчет, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, НаАванс)
КонецПроцедуры

Процедура ДобавитьПользовательскиеПоляДополнительныхНачисленийИУдержаний(ДополнительныеНачисленияИУдержания, НастройкиОтчета, КоличествоНачисленийУдержаний, ВидПолей, НаАванс) Экспорт
	
КонецПроцедуры

// Возвращает начисления в том порядке, в котором они должны быть выведены в отчете.
//
Функция ПорядокДополнительныхНачислений(Начисления, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки) Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ПорядокДополнительныхНачислений(Начисления, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки);
КонецФункции

// Возвращает удержания в том порядке, в котором они должны быть выведены в отчете.
//
Функция ПорядокДополнительныхУдержаний(Удержания, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки) Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ПорядокДополнительныхУдержаний(Удержания, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки);
КонецФункции

Функция ДополнительныеНачисленияОтчетаАнализНачисленийИУдержанийТ49() Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ДополнительныеНачисленияОтчетаАнализНачисленийИУдержанийТ49();
КонецФункции

Функция ДополнительныеУдержанияОтчетаАнализНачисленийИУдержанийТ49() Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ДополнительныеУдержанияОтчетаАнализНачисленийИУдержанийТ49();
КонецФункции

Процедура ЗаполнитьДополнительныеПоляОтчетаАнализНачисленийИУдержаний(ОтчетОбъект, ДополнительныеПоля) Экспорт
	
	УчетНачисленнойЗарплатыБазовый.ЗаполнитьДополнительныеПоляОтчетаАнализНачисленийИУдержаний(ОтчетОбъект, ДополнительныеПоля);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
