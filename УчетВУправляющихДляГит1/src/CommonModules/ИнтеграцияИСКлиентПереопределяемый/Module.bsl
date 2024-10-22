
#Область СлужебныйПрограммныйИнтерфейс

#Область СерииНоменклатуры

// Процедура обновляет кеш ключевых реквизитов текущей строки товаров. По ключевым реквизитам осуществляется связь
//  между ТЧ серий и ТЧ товаров.
//
// Параметры:
// 
//  ТаблицаФормы - ТаблицаФормы - таблица, в которой отображается ТЧ с товарами.
//  КэшированныеЗначения - Структура - переменная модуля формы, в которой хранятся кешируемые значения.
//  ПараметрыУказанияСерий - УправляемаяФорма, Структура - 
//     управляемая форма содержащая структуру или непосредственно структура параметров указания серий.
//  Копирование - Булево - признак, что кешированная строка скопирована (параметр события ПриНачалеРедактирования).
Процедура ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий = "", Копирование = Ложь) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Процедура проверяет необходимость обновления статусов указания серий при окончании редактирования строки товаров.
//
// Параметры:
//  Обновить - Булево - (исходящий) - необходимость обновления статусов указания серий;
//  Форма   - УправляемаяФорма - форма-источник вызова;
//  Элемент - ТаблицаФормы	 - таблица формы, отображающая ТЧ товаров;
//  КэшированныеЗначения - Структура   - переменная модуля формы, в которой хранятся кешируемые значения;
//  ПараметрыУказанияСерий - Структура - параметры указания серий, возвращаемые соответствующей процедурой
//                                       модуля менеджера документа;
//  Удаление - Булево, Истина - признак, что проверка вызывается при удалении строки ТЧ.
//
Процедура УстановитьОбновитьСтатусыСерий(Обновить, Форма, Элемент, КэшированныеЗначения, ПараметрыУказанияСерий = "", Удаление) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Функция проверяет необходимость указания серий в строке, если возможно, открывает форму указания,
//  если форма указания не требует контекстного вызова сервера.
//
// Параметры:
//  Форма					 - УправляемаяФорма	 - форма документа, в которой инициировано указание серий;
//  ПараметрыУказанияСерий	 - Структура		 - параметры указания серий, возвращаемые соответствующей
//  		процедурой модуля менеджера документа;
//  Текст					 - Строка			 - текст, введенный в поле ввода (параметр событий ОкончаниеВводаТекста и АвтоПодборВводаТекста);
//  ТекущиеДанные			 - 					 - Структура или ДанныеФормыЭлементКоллекции	 - данные строки, в которой указывается серия,
//  					если значение не передано, то используются текущие данные табличного поля с
//  					именем ПараметрыУказанияСерий.ИмяТЧТовары;
//  ОпределятьРаспоряжение	 - Булево			 - признак необходимости определения распоряжения по значениям полей;
//  ВыдаватьСообщения		 - Булево			 - признак необходимости вывода пользователю информационного сообщения.
// 
// Возвращаемое значение:
//  Булево - нужен контекстный вызов.
//
Процедура ЗаполнитьДляУказанияСерийНуженСерверныйВызов(
	Нужен, Форма, ПараметрыУказанияСерий, Текст, ТекущиеДанные, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Нужен = Ложь;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
