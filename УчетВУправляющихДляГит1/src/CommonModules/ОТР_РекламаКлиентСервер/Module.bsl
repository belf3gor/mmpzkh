
// Модуль предназначен для обработки события "ПриСозданииНаСервере" формы, в которой необходимо вывести рекламу.
//
// Пример использования: в модуле формы, в котором необходимо вывести рекламу, размещается следующий код
// в обработчик события "ПриСозданииНаСервере" формы:
//
//// Реклама
//ОТР_РекламаКлиентСервер.ПриСозданииНаСервере(ЭтаФорма);
//// Конец Реклама
//

#Область СлужебныеПроцедурыИФункции

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
// Параметры:
//  Форма	 - УправляемаяФорма - форма.
//
Процедура ПриСозданииНаСервере(Форма) Экспорт
	
	ОТР_РекламаКлиентСерверПереопределяемый.ПриСозданииНаСервере(Форма);
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти