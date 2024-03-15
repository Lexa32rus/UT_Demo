#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Метаданные", "ОтправкаПолучениеДанныхВЕТИС");
		
		Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
		Если Задания.Количество() <> 1 Тогда
			ЗаписьЖурналаРегистрации(
				ИнтеграцияЕГАИСКлиентСервер.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегламентныеЗадания.ОтправкаПолучениеДанныхВЕТИС,,
				НСтр("ru='Не найдено регламентное задание: Отправка и получение данных ВетИС'"));
			Возврат;
		КонецЕсли;
		
		Задание = Задания[0];
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Использование", Значение);
		
		РегламентныеЗаданияСервер.ИзменитьЗадание(Задание.УникальныйИдентификатор, ПараметрыЗадания);
		
		Отбор = Новый Структура();
		Отбор.Вставить("Метаданные", "СверткаРегистраСоответствиеНоменклатурыВЕТИС");
		
		Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
		Если Задания.Количество() <> 1 Тогда
			ЗаписьЖурналаРегистрации(
				ИнтеграцияЕГАИСКлиентСервер.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегламентныеЗадания.СверткаРегистраСоответствиеНоменклатурыВЕТИС,,
				НСтр("ru='Не найдено регламентное задание: Свертка регистра Соответствие номенклатуры ВетИС'"));
			Возврат;
		КонецЕсли;
		
		Задание = Задания[0];
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Использование", Значение);
		
		РегламентныеЗаданияСервер.ИзменитьЗадание(Задание.УникальныйИдентификатор, ПараметрыЗадания);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли