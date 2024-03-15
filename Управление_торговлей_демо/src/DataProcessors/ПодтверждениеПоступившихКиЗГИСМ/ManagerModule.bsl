#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получить текст условия по заявкам на выпуск ки З
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстУсловияПоЗаявкамНаВыпускКиЗ() Экспорт
	
	Возврат
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Состояния.ТекущаяЗаявкаНаВыпускКиЗ
	|ИЗ
	|	РегистрСведений.СтатусыЗаявокНаВыпускКиЗГИСМ КАК Состояния
	|ГДЕ
	|	Состояния.КПередачеПодтверждения";
	
КонецФункции

// Получить текст условия по уведомлениям о поступлении маркированных товаров ГИСМ
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстУсловияПоУведомлениямОПоступленииМаркированныхТоваровГИСМ() Экспорт
	
	Возврат
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Состояния.Документ
	|ИЗ
	|	РегистрСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ КАК Состояния
	|ГДЕ
	|	Состояния.КПередачеПодтверждения";
	
КонецФункции

#КонецОбласти

#КонецЕсли