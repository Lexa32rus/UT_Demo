
#Область ПрограммныйИнтерфейс

// Процедура выводит сообщения пользователю, если заполнение на основании
// не было выполнено.
//
// Параметры:
//	Объект - ДанныеФорма - Текущий объект
//	Основание - ДокументСсылка - Ссылка на документ основание
//
Процедура ПроверитьЗаполнениеДокументаНаОсновании(Объект, Основание) Экспорт
	
	Если ЗначениеЗаполнено(Основание) И Объект.СуммаДокумента = 0 Тогда
		
		Текст = "";
		
		Если Не ПустаяСтрока(Текст) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(Текст, Основание),, "Объект.СуммаДокумента");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
