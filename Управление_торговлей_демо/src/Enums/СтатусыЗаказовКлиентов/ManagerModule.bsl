#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список выбора статуса, в зависимости от включенных опций
//
// Параметры:
//  ДанныеВыбора  - СписокЗначений - заполняемый список значений.
//  УстановленныйСтатус  - ПеречислениеСсылка.СтатусыЗаказовКлиентов - заполняемый список значений.
//
Процедура ЗаполнитьСписокВыбора(ДанныеВыбора, УстановленныйСтатус) Экспорт
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента") Тогда
		Возврат
	КонецЕсли;
	
	ДанныеВыбора.Очистить();
	
	ДанныеВыбора.Добавить(Перечисления.СтатусыЗаказовКлиентов.НеСогласован);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента") Тогда
		ДанныеВыбора.Добавить(Перечисления.СтатусыЗаказовКлиентов.КОбеспечению, НСтр("ru='В резерве'"));
		ДанныеВыбора.Добавить(Перечисления.СтатусыЗаказовКлиентов.КОтгрузке);
	Иначе
		ДанныеВыбора.Добавить(Перечисления.СтатусыЗаказовКлиентов.КОбеспечению, НСтр("ru='К выполнению'"));
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыКлиентовБезПолнойОплаты")
		ИЛИ ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыКлиентовБезПолнойОтгрузки") Тогда
		ДанныеВыбора.Добавить(Перечисления.СтатусыЗаказовКлиентов.Закрыт);
	КонецЕсли;
	
	Если ДанныеВыбора.НайтиПоЗначению(УстановленныйСтатус) = Неопределено Тогда
		
		ДанныеВыбора.Добавить(УстановленныйСтатус, УстановленныйСтатус);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	
	ДанныеВыбора.Добавить(Перечисления.СтатусыЗаказовКлиентов.НеСогласован);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента") Тогда
		ДанныеВыбора.Добавить(Перечисления.СтатусыЗаказовКлиентов.КОбеспечению, НСтр("ru='В резерве'"));
		ДанныеВыбора.Добавить(Перечисления.СтатусыЗаказовКлиентов.КОтгрузке);
	Иначе
		ДанныеВыбора.Добавить(Перечисления.СтатусыЗаказовКлиентов.КОбеспечению, НСтр("ru='К выполнению'"));
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыКлиентовБезПолнойОплаты")
		ИЛИ ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыКлиентовБезПолнойОтгрузки") Тогда
		ДанныеВыбора.Добавить(Перечисления.СтатусыЗаказовКлиентов.Закрыт);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
