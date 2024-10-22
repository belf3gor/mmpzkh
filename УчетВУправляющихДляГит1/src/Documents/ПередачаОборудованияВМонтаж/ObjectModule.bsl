#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено
			И ТипДанныхЗаполнения <> Тип("Структура") 
			И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	// Специфические для конкретного документа действия
	СчетаУчета = БухгалтерскийУчетПереопределяемый.СчетаУчетаОбъектовСтроительства(Организация, ОбъектСтроительства);

	Если НЕ ЗначениеЗаполнено(СчетУчетаОбъектаСтроительства) Тогда
		СчетУчетаОбъектаСтроительства = СчетаУчета.СчетУчета;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ,РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ПередачаОборудованияВМонтаж.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ

	// Таблица списанных товаров
	ТаблицаСписанныеТовары = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ПараметрыПроведения.СписаниеТоваровТаблицаТовары,
		ПараметрыПроведения.СписаниеТоваровРеквизиты, Отказ);

	// Дополнение таблиц содержанием проводки
	Документы.ПередачаОборудованияВМонтаж.ДобавитьКолонкуСодержание(ТаблицаСписанныеТовары, Ссылка);

	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ

	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ТаблицаСписанныеТовары,
		ПараметрыПроведения.СписаниеТоваровРеквизиты, Движения, Отказ);
		
	УчетНДС.СформироватьДвиженияСписаниеТоваровПрочее(
		ПараметрыПроведения.ТоварыНДС, ТаблицаСписанныеТовары,
		ПараметрыПроведения.РеквизитыНДС, Движения, Отказ);
		
	// Регистрация в последовательности
	РаботаСПоследовательностями.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(ЭтотОбъект, Отказ, , ТаблицаСписанныеТовары);
	
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если ПроверяемыеРеквизиты.Найти("Склад") = Неопределено Тогда
		ПроверяемыеРеквизиты.Добавить("Склад");
	КонецЕсли;
	
	РаздельныйУчетНДСНаСчете19 = УчетнаяПолитика.РаздельныйУчетНДСНаСчете19(Организация, Дата);
	Если НЕ РаздельныйУчетНДСНаСчете19 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СпособУчетаНДС");
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
