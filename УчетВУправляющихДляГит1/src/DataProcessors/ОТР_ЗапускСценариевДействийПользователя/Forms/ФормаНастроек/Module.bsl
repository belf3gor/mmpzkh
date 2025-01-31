
////////////////////////////////////////////////////////////////////////////////
// FORM EVENT HANDLERS
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	Object.ScriptVariant = "ru";
	
	НастройкиЗапускаСценария = ОТР_ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("НастройкиЗапускаСценария");
	Если НастройкиЗапускаСценария <> Неопределено Тогда
		Если НастройкиЗапускаСценария.Свойство("ЗапускКлиента") Тогда
			Object.ЗапускатьКлиент = НастройкиЗапускаСценария.ЗапускКлиента;
		КонецЕсли;
		Если НастройкиЗапускаСценария.Свойство("ИсходныйТекст") Тогда
			SourceText =  НастройкиЗапускаСценария.ИсходныйТекст;
		КонецЕсли;
		Если НастройкиЗапускаСценария.Свойство("ПреобразованныйТекст") Тогда
			ПреобразованныйТекст = НастройкиЗапускаСценария.ПреобразованныйТекст;;
		КонецЕсли;
	КонецЕсли;
	
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, AttributesToCheck)


		If Not ValueIsFilled(SourceText.GetText()) Then

			Cancel = True;

			NewMessage = New UserMessage();
			NewMessage.Text = NStr("en = 'User action log is not specified.'; ru = 'Поле ""Журнал действий пользователя"" не заполнено.'");
			NewMessage.DataPath = "SourceText";
			NewMessage.Message();

		EndIf;

EndProcedure

////////////////////////////////////////////////////////////////////////////////
// Conversion procedures
&AtServer
Function ConvertAtServer(TextToConvert)
	
	ThisDataProcessor = FormAttributeToValue("Object");
	Return ThisDataProcessor.Convert(TextToConvert);
	
EndFunction

&AtClient
Procedure Convert(Command)
	
	СохранитьНастройки();
	
EndProcedure

&НаКлиенте
Процедура СохранитьНастройки()
	
	TextToConvert = "";
	TextToConvert = SourceText.GetText();
	
	Если ЗначениеЗаполнено(TextToConvert) Тогда
		ПреобразованныйТекст = ConvertAtServer(TextToConvert);
	Иначе
		ПреобразованныйТекст = "";
	КонецЕсли;
	
	НастройкиЗапускаСценария = Новый Структура;
	
	НастройкиЗапускаСценария.Вставить("ЗапускКлиента", Object.ЗапускатьКлиент);
	НастройкиЗапускаСценария.Вставить("ИсходныйТекст", SourceText);
	НастройкиЗапускаСценария.Вставить("ПреобразованныйТекст", ПреобразованныйТекст);
	
	
	ОТР_ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("НастройкиЗапускаСценария" , НастройкиЗапускаСценария);
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Запуск(Команда)
	
	ClearMessages();
	If Not ПроверитьЗаполнение() Then
		Return;
	EndIf;
	
	TextToConvert = "";
	TextToConvert = SourceText.GetText();
	ConversionResult = ConvertAtServer(TextToConvert);
	
	If Not ValueIsFilled(ConversionResult) Then
		Message(NStr("en = 'Cannot convert data'; ru = 'Не удалось выполнить преобразование текста сценария в программный код'"));
		Return;
	EndIf;
	
	ОТР_ЗапускСценариевДействийПользователяКлиент.ЗапуститьСистемуИВыполнитьСценарий(ConversionResult);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда 
		ТекстПредупреждения = "Измененные данные не были сохранены.";
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Отказ = Истина;
		ПоказатьВопрос( Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), "Настройки были изменены.Сохранить?", РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт 
	
	Модифицированность = Ложь;
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда 
		СохранитьНастройки();
		Закрыть(); 
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Закрыть(); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапускатьКлиентПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура SourceTextПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

