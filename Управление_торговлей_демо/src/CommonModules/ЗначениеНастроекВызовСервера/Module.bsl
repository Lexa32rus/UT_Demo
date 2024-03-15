
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает значение основной страны учета
// 
// Возвращаемое значение:
// 	СправочникСсылка.СтраныМира - 
Функция ОсновнаяСтрана() Экспорт
	
	Возврат Константы.ОсновнаяСтрана.Получить();
	
КонецФункции

// Возвращает страну регистрации организации. Если передана организация, то возвращает страну организации.
// Если организация не передана или пустая, то основную страну.
//
// Параметры:
//   Организация - СправочникСсылка.Организации - 
//
// Возвращаемое значение:
//   СправочникСсылка.СтраныМира - 
//
Функция СтранаРегистрацииОрганизации(Знач Организация = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат Константы.ОсновнаяСтрана.Получить();
	Иначе
		СтранаРегистрации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "СтранаРегистрации");
		Если ПолучитьФункциональнуюОпцию("ИспользоватьМногострановойУчет") Тогда
			Возврат СтранаРегистрации;
		ИначеЕсли ЗначениеЗаполнено(СтранаРегистрации) Тогда
			Возврат СтранаРегистрации;
		Иначе
			Возврат Константы.ОсновнаяСтрана.Получить();
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Возвращает валюту регламентированного учета, определенную для организации.
//
// Параметры:
//   Организация - СправочникСсылка.Организации - Организация, для которой надо получить валюту регламентированного учета.
//
// Возвращаемое значение:
//   СправочникСсылка.Валюты - 
//
Функция ВалютаРегламентированногоУчетаОрганизации(Знач Организация) Экспорт
	
	Возврат ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	
КонецФункции

#КонецОбласти