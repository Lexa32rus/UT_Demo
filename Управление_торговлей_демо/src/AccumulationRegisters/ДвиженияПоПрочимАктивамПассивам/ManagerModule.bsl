#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Собирает структуру из текстов запросов для дальнейшей проверки даты запрета.
// 
// Параметры:
// 	Запрос - Запрос - Запрос по проверке даты запрета, можно установить параметры
// Возвращаемое значение:
// 	Структура - см. ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов
Функция ТекстЗапросаКонтрольДатыЗапрета(Запрос) Экспорт
	ИмяРегистра = Метаданные.РегистрыНакопления.ДвиженияПоПрочимАктивамПассивам.Имя;
	ИмяТаблицыИзменений = "ТаблицаИзмененийДвиженияПоПрочимАктивамПассивам"; 
	СтруктураТекстовЗапросов = ПроведениеДокументов.ШаблонТекстЗапросаКонтрольДатыЗапрета(Запрос, 
		ИмяРегистра, 
		ИмяТаблицыИзменений, 
		"ФинансовыйКонтур");
	Возврат СтруктураТекстовЗапросов

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом


#КонецОбласти

#КонецОбласти

#КонецЕсли
