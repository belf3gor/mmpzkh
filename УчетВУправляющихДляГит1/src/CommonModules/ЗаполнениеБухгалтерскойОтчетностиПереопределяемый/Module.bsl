////////////////////////////////////////////////////////////////////////////////
// ЗАПОЛНЕНИЕ БУХГАЛТЕРСКОЙ ОТЧЕТНОСТИ.
// Модуль содержит переопределяемые процедуры и функции.
// Предназначен для заполнения регламентированного отчета
// "Бухгалтерская отчетность организаций" и финансовой отчетности в банки.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ЗаполнениеБухгалтерскойОтчетностиПоказатели

// Возвращает признак учета расходов по элементам затрат организацией в течении указанного периода.
//
// Параметры:
//   НачалоПериодаОтчета - Дата - дата начала периода, за который проводится проверка вида учета расходов;
//   КонецПериодаОтчета - Дата - дата конца периода, за который проводится проверка вида учета расходов;
//   Организация - СправочникСсылка.Организация - организация, для которой нужно получить признак.
//
// Возвращаемое значение:
//   Булево - Истина, если в течении проверяемого периода организация вела учет расходов
//     по элементам затрат.
//
// Пример реализации:
//   Возврат ЭлементыЗатратНастройкаПараметровУчета.РасходыУчитываютсяПоЭлементамЗатрат(
//     НачалоПериодаОтчета, КонецПериодаОтчета, Организация);
//
Функция РасходыУчитываютсяПоЭлементамЗатрат(НачалоПериодаОтчета, КонецПериодаОтчета, Организация) Экспорт
	
	Возврат ЭлементыЗатратНастройкаПараметровУчета.РасходыУчитываютсяПоЭлементамЗатрат(
		НачалоПериодаОтчета, КонецПериодаОтчета, Организация);
	
КонецФункции

#КонецОбласти

#КонецОбласти
