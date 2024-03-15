/////////////////////////////////////////////////////////////////////////////
// Совместная работа подсистем ВетИС и ИСМП.
//   * Процедуры работы с внешним модулем ВетИС.
//   * Если подсистема ВетИС отсутствует, выставить СтандартнаяОбработка = Ложь во всех процедурах.
//

#Область ПрограммныйИнтерфейс

// Дополняет параметры сканирования для документа Маркировка товаров при необходимости передавать специфику ВетИС:
//   * Взводит флаг "ЗаполнятьДанныеВЕТИС".
//   * Определяет тип идентификатора происхождения ВетИС.
// 
// Параметры:
//   Операция              - ПеречислениеСсылка.ВидыОперацийИСМП - операция маркировки.
//   ПараметрыСканирования - См. ШтрихкодированиеИСКлиент.ПараметрыСканирования.
//   СтандартнаяОбработка  - Булево - признак библиотечной обработки
//
Процедура ДополнитьПараметрыСканированияМаркировкаТоваров(Операция, ПараметрыСканирования, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Настраивает имя полей/колонок "Идентификатор происхождения ВетИС" в интерфейсе
// 
// Параметры:
//  ИмяИдентификатора - Строка - Имя идентификатора
//
Процедура НастроитьИмяИдентификатораПроисхожденияВЕТИС(ИмяИдентификатора) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти