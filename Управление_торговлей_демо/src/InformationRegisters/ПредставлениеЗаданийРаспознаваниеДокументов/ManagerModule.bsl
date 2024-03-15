#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура Записать(ИдентификаторЗадания, ТекДата, ИменаФайлов, Источник) Экспорт
	
	ФайлыСтрокой = СтрСоединить(ИменаФайлов, ", ");
	
	Запись = РегистрыСведений.ПредставлениеЗаданийРаспознаваниеДокументов.СоздатьМенеджерЗаписи();
	Запись.ИдентификаторЗадания = ИдентификаторЗадания;
	Запись.ДатаЗагрузки = ТекДата;
	Запись.ВОбработке = ИменаФайлов.Количество();
	Запись.ФайлыСтрокой = ФайлыСтрокой;
	Запись.Источник = Источник;
	Запись.Представление = РаспознаваниеДокументов.СформироватьПредставлениеЗадания(
		Новый Структура("ДатаЗагрузки, ФайлыСтрокой, ВОбработке, Загружено, Ошибок", 
			ТекДата, ФайлыСтрокой, Запись.ВОбработке, 0, 0)
	);
	Запись.Записать();
	
КонецПроцедуры

Функция ИсточникПоИдентификатору(ИдентификаторЗадания) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПредставлениеЗаданийРаспознаваниеДокументов.Источник КАК Источник
		|ИЗ
		|	РегистрСведений.ПредставлениеЗаданийРаспознаваниеДокументов КАК ПредставлениеЗаданийРаспознаваниеДокументов
		|ГДЕ
		|	ПредставлениеЗаданийРаспознаваниеДокументов.ИдентификаторЗадания = &ИдентификаторЗадания";
	
	Запрос.УстановитьПараметр("ИдентификаторЗадания", ИдентификаторЗадания);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Перечисления.ИсточникиПолученияФайлов.ПустаяСсылка();
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Источник;
	
КонецФункции

#КонецОбласти

#КонецЕсли
