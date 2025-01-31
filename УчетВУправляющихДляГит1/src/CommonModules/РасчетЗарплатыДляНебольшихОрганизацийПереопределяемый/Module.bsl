////////////////////////////////////////////////////////////////////////////////
// РасчетЗарплатыДляНебольшихОрганизацийПереопределяемый: 
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает текст сообщения, которое будет показано пользователю при приближении 
// количества работающих сотрудников к количеству при котором расчет зарплаты для небольших организаций становится
// невозможен.
// В текст сообщения подставляются следующие параметры:
//		%1	- максимально допустимое количество работающих сотрудников
//		%2	- краткое наименование организации
//		%3	- текущее количество работающих сотрудников.
//
// Возвращаемое значение:
//		Строка
//
Функция ТекстСообщенияОПриближенииКМаксимальноДопустимомуКоличествуРаботающихСотрудников() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийБухгалтерскийУчет") Тогда
		Возврат НСтр("ru='Учет больничных, отпусков и исполнительных документов работников доступен,
						  |когда количество работающих сотрудников в каждой организации не превышает %1.
						  |Сейчас в организации %2 уже работает %3.'");
	Иначе
		Возврат НСтр("ru='Учет больничных, отпусков и исполнительных документов работников доступен,
						  |когда количество работающих сотрудников не превышает %1.
						  |Сейчас в организации %2 уже работает %3.'");
	КонецЕсли;
	
КонецФункции

// Возвращает текст сообщения, которое будет показано пользователю при попытке создать документ,
// когда отключен режим расчета зарплаты для небольших организаций.
// В текст сообщения подставляются следующие параметры:
//		%1	- представление документа, как оно задано в конфигураторе.
//
// Возвращаемое значение:
//		Строка
//
Функция ТекстСообщенияОНевозможностиСоздаватьДокументыПриОтключеннойНастройке() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийБухгалтерскийУчет") Тогда
		Возврат НСтр("ru='Создавать документ ""%1"" можно при включенном режиме учета больничных, отпусков и исполнительных документов работников.
						 |Этот режим доступен, когда количество работающих сотрудников в каждой организации не превышает %2'");
	Иначе
		Возврат НСтр("ru='Создавать документ ""%1"" можно при включенном режиме учета больничных, отпусков и исполнительных документов работников.
						 |Этот режим доступен, когда количество работающих сотрудников не превышает %2'");
	КонецЕсли;
	
КонецФункции

// Возвращает текст сообщения, которое будет показано пользователю при попытке создать документ,
// когда отключен режим расчета зарплаты для небольших организаций.
// В текст сообщения подставляются следующие параметры:
//		%1	- максимально допустимое количество работающих сотрудников
//		%2	- представление документа, как оно задано в конфигураторе.
//
// Возвращаемое значение:
//		Строка
//
Функция ТекстСообщенияОНевозможностиСоздаватьДокументыПриПревышенииМаксимальноДопустимогоКоличестваРаботающихСотрудников() Экспорт
	
	Возврат НСтр("ru='Количество работающих сотрудников превышает %1, нельзя создавать документы ""%2""'");
	
КонецФункции

// Возвращает текст сообщения о превышении максимально допустимого количества работающих сотрудников.
//
// Возвращаемое значение:
//		Строка
//
Функция ТекстСообщенияОПревышенииМаксимальноДопустимогоКоличестваРаботающихСотрудников() Экспорт
	
	Возврат НСтр("ru='Учет больничных, отпусков и исполнительных документов работников отключен.
		|Количество работающих сотрудников превысило %1.'");
	
КонецФункции

// Определяет номер картинки-состояния документа (проведен, не проведен, помечен на удаление).
//
// Параметры:
//		Объект		- ДанныеФормыСтруктура - элемент формы, содержащий документ
//		Состояние	- Неопределено
//
Процедура СостояниеДокумента(Объект, Состояние) Экспорт
	
	Состояние = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

#КонецОбласти
