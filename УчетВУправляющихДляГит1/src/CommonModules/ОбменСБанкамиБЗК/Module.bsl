
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// ЭлектронноеВзаимодействие.ОбменСБанками

// См. ОбменСБанкамиПереопределяемый.ПолучитьАктуальныеВидыЭД
Процедура ПолучитьАктуальныеВидыЭД(Массив) Экспорт
	ОбменСБанкамиПоЗарплатнымПроектам.ЗаполнитьАктуальныеВидыЭД(Массив);
КонецПроцедуры

// См. ОбменСБанкамиПереопределяемый.ЗаполнитьПараметрыЭДПоИсточнику
Процедура ЗаполнитьПараметрыЭДПоИсточнику(Источник, ПараметрыЭД) Экспорт
	ОбменСБанкамиПоЗарплатнымПроектам.ЗаполнитьПараметрыЭДПоИсточнику(Источник, ПараметрыЭД);
КонецПроцедуры

// См. ОбменСБанкамиПереопределяемый.ПодготовитьСтруктуруОбъектовКомандЭДО
Процедура ПодготовитьСтруктуруОбъектовКомандЭДО(СоставКомандЭДО) Экспорт
	ОбменСБанкамиПоЗарплатнымПроектам.ПодготовитьСтруктуруОбъектовКомандЭДО(СоставКомандЭДО);
КонецПроцедуры

// См. ОбменСБанкамиПереопределяемый.ПроверитьИспользованиеТестовогоРежима
Процедура ПроверитьИспользованиеТестовогоРежима(ИспользуетсяТестовыйРежим) Экспорт
	Если СтрНайти(ВРег(Константы.ЗаголовокСистемы.Получить()), ВРег("DirectBank")) > 0 Тогда
		ИспользуетсяТестовыйРежим = Истина;
	КонецЕсли;
КонецПроцедуры

// См. ОбменСБанкамиПереопределяемый.ПриФормированииXMLФайла
Процедура ПриФормированииXMLФайла(ОбъектДляВыгрузки, ИмяФайла, АдресФайла) Экспорт
	ОбменСБанкамиПоЗарплатнымПроектам.ПриФормированииXMLФайла(ОбъектДляВыгрузки, ИмяФайла, АдресФайла);
КонецПроцедуры

// См. ОбменСБанкамиПереопределяемый.ЗаполнитьТабличныйДокумент
Процедура ЗаполнитьТабличныйДокумент(Знач ИмяФайла, ТабличныйДокумент) Экспорт
	ОбменСБанкамиПоЗарплатнымПроектам.ЗаполнитьТабличныйДокументПоПрямомуОбменуСБанками(ИмяФайла, ТабличныйДокумент);
КонецПроцедуры

// См. ОбменСБанкамиПереопределяемый.ПриПолученииXMLФайла
Процедура ПриПолученииXMLФайла(АдресДанныхФайла, ИмяФайла, ОбъектВладелец, ДанныеОповещения) Экспорт
	ОбменСБанкамиПоЗарплатнымПроектам.ПриПолученииXMLФайла(АдресДанныхФайла, ИмяФайла, ОбъектВладелец, ДанныеОповещения);
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСБанками

#КонецОбласти

#КонецОбласти


