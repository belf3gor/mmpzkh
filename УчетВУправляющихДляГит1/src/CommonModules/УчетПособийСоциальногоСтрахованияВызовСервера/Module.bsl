
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание файла реестра прямых выплат.
//
// Параметры:
//   СсылкаРеестра - ДокументСсылка.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий - Реестр ПВСО.
//   УникальныйИдентификатор - УникальныйИдентификатор, Неопределено - Уникальный идентификатор формы,
//       к которому следует привязать временное хранилище файла.
//
// Возвращаемое значние:
//   Структура - Описание файла.
//
Функция ФайлРеестраПрямыхВыплат(СсылкаРеестра, УникальныйИдентификатор) Экспорт
	Возврат Документы.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ФайлРеестра(СсылкаРеестра, УникальныйИдентификатор)
КонецФункции

#КонецОбласти


