
#Область ОбработчикиСобытийФормы

&НаСервере
// Обработчик события "ПриСозданииНаСервере" формы.
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установим значения по умолчанию для обязательных реквизитов.
	Если Объект.Организация.Пустая() Тогда
		Объект.Организация = УПЖКХ_ТиповыеМетодыВызовСервера.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.НачалоПериода) Тогда
		Объект.НачалоПериода = НачалоМесяца(ТекущаяДата());
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ОкончаниеПериода) Тогда
		Объект.ОкончаниеПериода = КонецМесяца(ТекущаяДата());
	КонецЕсли;
	
	// Если перечень уже был использован в планах, запрещаем редактировать его.
	Если Не Объект.Ссылка.Пустая() Тогда
		Если ПереченьИспользовалсяВПланах(Объект.Ссылка) Тогда
			ЭтаФорма.ТолькоПросмотр              = Истина;
			Элементы.ГруппаПериод.ТолькоПросмотр = Истина;
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю("Текущий перечень уже был использован в планах работ и услуг, поэтому его нельзя редактировать.");
		КонецЕсли;
	КонецЕсли;
	
	// ОбщиеМеханизмыИКоманды
	ОТР_ПодключаемыеОбщиеМеханизмыИКоманды.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ОбщиеМеханизмыИКоманды
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
// Обработчик события "ПриОткрытии" формы.
Процедура ПриОткрытии(Отказ)
	
	УПЖКХ_ТиповыеМетодыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.НачалоПериода",    "НачалоПериодаСтрокой");
	УПЖКХ_ТиповыеМетодыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ОкончаниеПериода", "ОкончаниеПериодаСтрокой");
	
	мНачалоПериода    = Объект.НачалоПериода;
	мОкончаниеПериода = Объект.ОкончаниеПериода;
	
КонецПроцедуры // ПриОткрытии()

&НаКлиенте
// Обработчик события формы "ПередЗаписью".
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.РаботыУслуги.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнен список работ/услуг!'");
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке(ТекстСообщения);
		
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		СсылкаНаПеречень = ПроверитьНаличиеПересекающихсяПеречнейРабот(Отказ);
		
		Если Отказ Тогда
			
			ТекстПредупреждения = "Не удалось записать перечень работ и услуг, т.к. для выбранного здания и организации "
								  + "уже существует перечень работ/услуг в указанном периоде. "
								  + "Для перехода к существующему перечню необходимо дважды кликнуть по соответствующему сообщению.";
			
			ПоказатьПредупреждение(, ТекстПредупреждения);
			
			ТекстСообщения = НСтр("ru = 'Для выбранного здания и организации уже существует перечень работ/услуг "
									   + """" + СсылкаНаПеречень + """ в указанном периоде!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, СсылкаНаПеречень);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ПроверитьНаличиеЗарегистрированногоДоговора(Отказ);
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

&НаСервере
// Обработчик события формы "ПередЗаписьюНаСервере".
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	КлючДанных = ТекущийОбъект.Ссылка;
	ПутьКДанным = "Объект";
	
	Для Каждого СтрокаТабличнойЧасти Из ТекущийОбъект.РаботыУслуги Цикл
		
		Поле = "РаботыУслуги[" + Строка(СтрокаТабличнойЧасти.НомерСтроки-1) + "]";
		
		Если (СтрокаТабличнойЧасти.Цена > 0 ИЛИ СтрокаТабличнойЧасти.Объем > 0)
		     И (СтрокаТабличнойЧасти.Цена = 0 ИЛИ СтрокаТабличнойЧасти.Объем = 0 ИЛИ СтрокаТабличнойЧасти.Количество = 0) Тогда
			
			Если СтрокаТабличнойЧасти.Цена = 0 Тогда
				ТекстСообщения = "В строке " + Строка(СтрокаТабличнойЧасти.НомерСтроки) + " не указана цена (должны быть указаны: цена, объем, количество).";
				УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю(ТекстСообщения,КлючДанных,Поле+".Цена",ПутьКДанным,Отказ);
			КонецЕсли;
			
			Если СтрокаТабличнойЧасти.Объем = 0 Тогда
				ТекстСообщения = "В строке " + Строка(СтрокаТабличнойЧасти.НомерСтроки) + " не указан объем (должны быть указаны: цена, объем, количество).";
				УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю(ТекстСообщения,КлючДанных,Поле+".Объем",ПутьКДанным,Отказ);
			КонецЕсли;
			
			Если СтрокаТабличнойЧасти.Количество = 0 Тогда
				ТекстСообщения = "В строке " + Строка(СтрокаТабличнойЧасти.НомерСтроки) + " не указано количество (должны быть указаны: цена, объем, количество).";
				УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю(ТекстСообщения,КлючДанных,Поле+".Количество",ПутьКДанным,Отказ);
			КонецЕсли;
			
			Продолжить;
			
		КонецЕсли;
		
		Если СтрокаТабличнойЧасти.Цена = 0 И СтрокаТабличнойЧасти.Объем = 0 И СтрокаТабличнойЧасти.Стоимость = 0 Тогда
			
			ТекстСообщения = "В строке " + Строка(СтрокаТабличнойЧасти.НомерСтроки) + " не указаны данные для выгрузки (должны быть указаны: или цена, объем, количество, или стоимость и, возможно, количество).";
			УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьПользователю(ТекстСообщения,КлючДанных,Поле+".Цена",ПутьКДанным,Отказ);
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы


#Область ОбработчикиСобытийЭлементаНачалоПериодаСтрокой

&НаКлиенте
// Процедура - обработчик события "ПриИзменении" поля ввода "НачалоПериодаСтрокой".
//
// Параметры:
//  Элемент 			- <ПолеВвода>
//        				- Поле ввода, с которым связано данное событие ("НачалоПериодаСтрокой").
//
Процедура НачалоПериодаСтрокойПриИзменении(Элемент)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.НачалоПериода", "НачалоПериодаСтрокой", Модифицированность);
	
	ОбновитьПараметрыПериодов();
	
КонецПроцедуры // НачалоПериодаСтрокойПриИзменении()

&НаКлиенте
// Процедура - обработчик события "НачалоВыбора" поля ввода "НачалоПериодаСтрокой".
// Параметры:
//  Элемент 			- <ПолеВвода>
//        				- Поле ввода, с которым связано данное событие ("НачалоПериодаСтрокой").
//  СтандартнаяОбработка - <Булево. >
//         				 - В данный параметр передается признак выполнения
//                         стандартной (системной) обработки события.
//
Процедура НачалоПериодаСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.НачалоПериода", "НачалоПериодаСтрокой", , Новый ОписаниеОповещения("ЗавершениеВыбораПериода", ЭтаФорма));
	
КонецПроцедуры // НачалоПериодаСтрокойНачалоВыбора()

&НаКлиенте
// Обработчик завершения выбора начала периода.
//
Процедура ЗавершениеВыбораПериода(Результат, ДопПараметры) Экспорт
	
	ОбновитьПараметрыПериодов();
	
КонецПроцедуры // ЗавершениеВыбораПериода()

&НаКлиенте
// Процедура - обработчик события "Регулирование" поля ввода "НачалоПериодаСтрокой".
// Параметры:
//  Элемент 			- <ПолеВвода>
//        				- Поле ввода, с которым связано данное событие ("НачалоПериодаСтрокой").
//  Направление			- <Число>
//        				- Позволяет определить, какая из кнопок регулирования была нажата.
//  СтандартнаяОбработка - <Булево. >
//         				 - В данный параметр передается признак выполнения
//                         стандартной (системной) обработки события.
//
Процедура НачалоПериодаСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.НачалоПериода", "НачалоПериодаСтрокой", Направление,
														Модифицированность);
	
	ОбновитьПараметрыПериодов();
	
КонецПроцедуры // НачалоПериодаСтрокойРегулирование()

&НаКлиенте
// Процедура - обработчик события "АвтоПодбор" поля ввода "НачалоПериодаСтрокой".
//
// Параметры:
//  Элемент 			- <ПолеВвода>
//        				- Поле ввода, с которым связано данное событие ("НачалоПериодаСтрокой").
//  Текст 				- <Строка>
//        				- Строка текста, введенная в поле ввода ("НачалоПериодаСтрокой").
//  ТекстАвтоПодбора 	- <Строка>
//          			- После завершения обработки события содержит текст 
//                         для размещения в поле ввода("НачалоПериодаСтрокой").
//  СтандартнаяОбработка - <Булево. >
//         				 - В данный параметр передается признак выполнения
//                         стандартной (системной) обработки события.
//
Процедура НачалоПериодаСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
	ОбновитьПараметрыПериодов();
	
КонецПроцедуры // НачалоПериодаСтрокойАвтоПодбор()

&НаКлиенте
// Процедура - обработчик события "ОкончаниеВводаТекста" поля ввода "НачалоПериодаСтрокой".
// Параметры:
//  Элемент 			- <ПолеВвода>
//        				- Поле ввода, с которым связано данное событие ("НачалоПериодаСтрокой").
//  Текст 				- <Строка>
//        				- Строка текста, введенная в поле ввода ("НачалоПериодаСтрокой").
//  Значение		 	- < СписокЗначений>
//          			- Параметр может содержать значение для размещения 
//						  в поле ввода или список значений для последующего
//                        выбора одного из них и размещения в поле ввода.
//  СтандартнаяОбработка - <Булево. >
//         				 - В данный параметр передается признак выполнения
//                         стандартной (системной) обработки события.
//
Процедура НачалоПериодаСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
	ОбновитьПараметрыПериодов();
	
КонецПроцедуры // НачалоПериодаСтрокойОкончаниеВводаТекста()

#КонецОбласти

#Область ОбработчикиСобытийЭлементаОкончаниеПериодаСтрокой

&НаКлиенте
// Процедура - обработчик события "ПриИзменении" поля ввода "ОкончаниеПериодаСтрокой".
//
// Параметры:
//  Элемент 			- <ПолеВвода>
//        				- Поле ввода, с которым связано данное событие ("ОкончаниеПериодаСтрокой").
//
Процедура ОкончаниеПериодаСтрокойПриИзменении(Элемент)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ОкончаниеПериода", "ОкончаниеПериодаСтрокой", Модифицированность);
	
	ОбновитьПараметрыПериодов();
	
КонецПроцедуры // ОкончаниеПериодаСтрокойПриИзменении()

&НаКлиенте
// Процедура - обработчик события "НачалоВыбора" поля ввода "ОкончаниеПериодаСтрокой".
// Параметры:
//  Элемент 			- <ПолеВвода>
//        				- Поле ввода, с которым связано данное событие ("ОкончаниеПериодаСтрокой").
//  СтандартнаяОбработка - <Булево. >
//         				 - В данный параметр передается признак выполнения
//                         стандартной (системной) обработки события.
//
Процедура ОкончаниеПериодаСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ОкончаниеПериода", "ОкончаниеПериодаСтрокой", , Новый ОписаниеОповещения("ЗавершениеВыбораПериода", ЭтаФорма));
	
КонецПроцедуры // ОкончаниеПериодаСтрокойНачалоВыбора()

&НаКлиенте
// Процедура - обработчик события "Регулирование" поля ввода "ОкончаниеПериодаСтрокой".
// Параметры:
//  Элемент 			- <ПолеВвода>
//        				- Поле ввода, с которым связано данное событие ("ОкончаниеПериодаСтрокой").
//  Направление			- <Число>
//        				- Позволяет определить, какая из кнопок регулирования была нажата.
//  СтандартнаяОбработка - <Булево. >
//         				 - В данный параметр передается признак выполнения
//                         стандартной (системной) обработки события.
//
Процедура ОкончаниеПериодаСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ОкончаниеПериода", "ОкончаниеПериодаСтрокой", Направление,
														Модифицированность);
	
	ОбновитьПараметрыПериодов();
	
КонецПроцедуры // ОкончаниеПериодаСтрокойРегулирование()

&НаКлиенте
// Процедура - обработчик события "АвтоПодбор" поля ввода "ОкончаниеПериодаСтрокой".
//
// Параметры:
//  Элемент 			- <ПолеВвода>
//        				- Поле ввода, с которым связано данное событие ("ОкончаниеПериодаСтрокой").
//  Текст 				- <Строка>
//        				- Строка текста, введенная в поле ввода ("ОкончаниеПериодаСтрокой").
//  ТекстАвтоПодбора 	- <Строка>
//          			- После завершения обработки события содержит текст 
//                         для размещения в поле ввода("НачалоПериодаСтрокой").
//  СтандартнаяОбработка - <Булево. >
//         				 - В данный параметр передается признак выполнения
//                         стандартной (системной) обработки события.
//
Процедура ОкончаниеПериодаСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
	ОбновитьПараметрыПериодов();
	
КонецПроцедуры // ОкончаниеПериодаСтрокойАвтоПодбор()

&НаКлиенте
// Процедура - обработчик события "ОкончаниеВводаТекста" поля ввода "ОкончаниеПериодаСтрокой".
// Параметры:
//  Элемент 			- <ПолеВвода>
//        				- Поле ввода, с которым связано данное событие ("ОкончаниеПериодаСтрокой").
//  Текст 				- <Строка>
//        				- Строка текста, введенная в поле ввода ("ОкончаниеПериодаСтрокой").
//  Значение		 	- < СписокЗначений>
//          			- Параметр может содержать значение для размещения 
//						  в поле ввода или список значений для последующего
//                        выбора одного из них и размещения в поле ввода.
//  СтандартнаяОбработка - <Булево. >
//         				 - В данный параметр передается признак выполнения
//                         стандартной (системной) обработки события.
//
Процедура ОкончаниеПериодаСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	УПЖКХ_ТиповыеМетодыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
	ОбновитьПараметрыПериодов();
	
КонецПроцедуры // ОкончаниеПериодаСтрокойОкончаниеВводаТекста()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧасти

&НаКлиенте
// Процедура-обработчик события "ПриИзменении" поля "Цена" таблицы "РаботыУслуги".
Процедура РаботыУслугиЦенаПриИзменении(Элемент)
	
	УстановитьОтображениеПлановыхПоказателей(Элемент);
	
КонецПроцедуры // РаботыУслугиЦенаПриИзменении()

&НаКлиенте
// Процедура-обработчик события "ПриИзменении" поля "Объем" таблицы "РаботыУслуги".
Процедура РаботыУслугиОбъемПриИзменении(Элемент)
	
	УстановитьОтображениеПлановыхПоказателей(Элемент);
	
КонецПроцедуры // РаботыУслугиОбъемПриИзменении()

&НаКлиенте
// Процедура-обработчик события "ПриИзменении" поля "Количество" таблицы "РаботыУслуги".
Процедура РаботыУслугиКоличествоПриИзменении(Элемент)
	
	УстановитьОтображениеПлановыхПоказателей(Элемент);
	
КонецПроцедуры // РаботыУслугиКоличествоПриИзменении()

&НаКлиенте
// Процедура-обработчик события "ПриИзменении" поля "Стоимость" таблицы "РаботыУслуги".
Процедура РаботыУслугиСтоимостьПриИзменении(Элемент)
	УстановитьОтображениеПлановыхПоказателей(Элемент);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// ЧастоЗадаваемыеВопросы
&НаКлиенте
// Подключаемый обработчик команды перехода к часто задаваемым вопросам.
Процедура Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда)
	
	ОТР_ЧастоЗадаваемыеВопросыКлиент.Подключаемый_ЧастоЗадаваемыеВопросыОткрытьСсылку(Команда);
	
КонецПроцедуры
// Конец ЧастоЗадаваемыеВопросы

#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

&НаКлиенте
// Процедура обновляет параметры периодов.
//
Процедура ОбновитьПараметрыПериодов()
	
	Объект.НачалоПериода    = НачалоМесяца(Объект.НачалоПериода);
	Объект.ОкончаниеПериода = КонецМесяца(Объект.ОкончаниеПериода);
	
	Если Объект.НачалоПериода > Объект.ОкончаниеПериода Тогда
		ПоказатьПредупреждение(, "Начало периода формирования перечня не может быть больше окончания периода!");
		Объект.НачалоПериода    = мНачалоПериода;
		Объект.ОкончаниеПериода = мОкончаниеПериода;
		УПЖКХ_ТиповыеМетодыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.НачалоПериода",    "НачалоПериодаСтрокой");
		УПЖКХ_ТиповыеМетодыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ОкончаниеПериода", "ОкончаниеПериодаСтрокой");
	Иначе
		мНачалоПериода    = Объект.НачалоПериода;
		мОкончаниеПериода = Объект.ОкончаниеПериода;
	КонецЕсли;
	
КонецПроцедуры // ОбновитьПараметрыПериодов()

&НаКлиенте
// Устанавливает отображение столбцов с плановыми показателями.
//
Процедура УстановитьОтображениеПлановыхПоказателей(Элемент)
	
	ТекущиеДанные = Элемент.Родитель.ТекущиеДанные;
	
	Если Элемент.Имя = "РаботыУслугиЦена" ИЛИ Элемент.Имя = "РаботыУслугиОбъем" Тогда
		
		ТекущиеДанные.Стоимость = 0;
		
	ИначеЕсли Элемент.Имя = "РаботыУслугиСтоимость" Тогда
		
		ТекущиеДанные.Цена = 0;
		ТекущиеДанные.Объем = 0;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Функция проверяет наличие других перечней работ/услуг для текущего здания и организации в текущем периоде,
// Т.е. перечни работ/услуг для одного здания и организации НЕ ДОЛЖНЫ пересекаться.
//
// Параметры:
//    Отказ - булево.
//      если периоды перечней пересекаются, то отменяем запись элемента справочника, устанавливая "Отказ" в "Истина".
// Возвращаемое значение:
//    СсылкаНаПеречень - ссылка на элемент справочника "Перечни работ/услуг"
//      требуется для того, чтобы при интерактивном двойном клике по сообщению перейти к элементу справочника.
//
Функция ПроверитьНаличиеПересекающихсяПеречнейРабот(Отказ)
	
	СсылкаНаПеречень = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УПЖКХ_ПеречниРаботИУслуг.Наименование,
	|	УПЖКХ_ПеречниРаботИУслуг.Ссылка
	|ИЗ
	|	Справочник.УПЖКХ_ПеречниРаботИУслуг КАК УПЖКХ_ПеречниРаботИУслуг
	|ГДЕ
	|	УПЖКХ_ПеречниРаботИУслуг.Здание = &Здание
	|	И УПЖКХ_ПеречниРаботИУслуг.Организация = &Организация
	|	И НЕ УПЖКХ_ПеречниРаботИУслуг.Ссылка = &Перечень
	|	И (УПЖКХ_ПеречниРаботИУслуг.НачалоПериода >= &НачалоПериода
	|				И УПЖКХ_ПеречниРаботИУслуг.НачалоПериода <= &ОкончаниеПериода
	|			ИЛИ УПЖКХ_ПеречниРаботИУслуг.ОкончаниеПериода >= &НачалоПериода
	|				И УПЖКХ_ПеречниРаботИУслуг.ОкончаниеПериода <= &ОкончаниеПериода)";
	Запрос.УстановитьПараметр("Здание",           Объект.Здание);
	Запрос.УстановитьПараметр("Организация",      Объект.Организация);
	Запрос.УстановитьПараметр("Перечень",         Объект.Ссылка);
	Запрос.УстановитьПараметр("НачалоПериода",    Объект.НачалоПериода);
	Запрос.УстановитьПараметр("ОкончаниеПериода", Объект.ОкончаниеПериода);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		СсылкаНаПеречень = Выборка.Ссылка;
		Отказ = Истина;
		
	КонецЕсли;
	
	Возврат СсылкаНаПеречень;
	
КонецФункции // ПроверитьНаличиеПересекающихсяПеречнейРабот()

&НаСервере
// Процедура проверяет наличие зарегистрированного договора управления домами,
// действующего в периоде формирования перечня работ/услуг.
// Параметры:
//    Отказ - булево.
//      если договор отсутствует, или действует НЕ в течение всего периода формирования перечня работ/услуг,
//      то отменяем запись элемента справочника, устанавливая "Отказ" в "Истина".
// 
Процедура ПроверитьНаличиеЗарегистрированногоДоговора(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УПЖКХ_СведенияОДоговорахУправленияДомамиСрезПервых.ДатаОперации КАК ДатаНачала
	|ИЗ
	|	РегистрСведений.УПЖКХ_СведенияОДоговорахУправленияДомами.СрезПервых(
	|			,
	|			Здание = &Здание
	|				И Организация = &Организация
	|				И Действует) КАК УПЖКХ_СведенияОДоговорахУправленияДомамиСрезПервых
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УПЖКХ_СведенияОДоговорахУправленияДомамиСрезПервых.ДатаОперации КАК ДатаОкончания
	|ИЗ
	|	РегистрСведений.УПЖКХ_СведенияОДоговорахУправленияДомами.СрезПоследних(
	|			,
	|			Здание = &Здание
	|				И Организация = &Организация
	|				И НЕ Действует) КАК УПЖКХ_СведенияОДоговорахУправленияДомамиСрезПервых";
	
	Запрос.УстановитьПараметр("Здание",           Объект.Здание);
	Запрос.УстановитьПараметр("Организация",      Объект.Организация);
	ПакетРезультат = Запрос.ВыполнитьПакет();
	
	ВыборкаНачалоПериода    = ПакетРезультат[0].Выбрать();
	ВыборкаОкончаниеПериода = ПакетРезультат[1].Выбрать();
	
	ТекстСообщения = НСтр("ru = 'Для выбранного здания и организации отсутствует договор управления домами, действующий в течение указанного периода!'");
	
	Если ВыборкаНачалоПериода.Следующий() И ВыборкаОкончаниеПериода.Следующий() Тогда
		// Если договор управления НЕ действует в течение всего периода формирования перечня работ/услуг,
		// то выводим сообщение об ошибке и отменяем запись элемента справочника.
		Если НЕ (ВыборкаНачалоПериода.ДатаНачала <= Объект.НачалоПериода И ВыборкаОкончаниеПериода.ДатаОкончания >= Объект.ОкончаниеПериода) Тогда
			Отказ = Истина;
		КонецЕсли;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		УПЖКХ_ТиповыеМетодыКлиентСервер.СообщитьОбОшибке(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьНаличиеЗарегистрированногоДоговора()

&НаСервереБезКонтекста
// Проверяет, был ли текущий перечень уже использован в планах работ и услуг.
Функция ПереченьИспользовалсяВПланах(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УПЖКХ_ПланыРаботУслуг.ПереченьРаботУслуг
	|ИЗ
	|	РегистрСведений.УПЖКХ_ПланыРаботУслуг КАК УПЖКХ_ПланыРаботУслуг
	|ГДЕ
	|	УПЖКХ_ПланыРаботУслуг.ПереченьРаботУслуг = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
