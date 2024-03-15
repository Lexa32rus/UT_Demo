
#Область ПрограммныйИнтерфейс

// Заполняет структуру параметров карты. 
//
// Возвращаемое значение:
//  Структура.
Функция ПараметрыКарты() Экспорт;
	
	Результат = Новый Структура();
	
	Результат.Вставить("ОтПоследнейОперации");
	Результат.Вставить("НомерКарты");    // Строка - Маскированный номер карты.
	Результат.Вставить("ХешНомерКарты"); // Строка - PAN карты хешированном по алгоритму SHA256 виде. 
	Результат.Вставить("ТипКарты");      // Строка - Тип карты (VISA,MasterCard).
	Результат.Вставить("СвояКарта");     // Булево - Карта банка которые предоставляет услуги эквайринга.
	
	Возврат Результат;
	
КонецФункции

// Заполняет структуру получение параметров карты.
//
// Возвращаемое значение:
//  Структура.
//
Функция ПараметрыПолучениеПараметровКарты() Экспорт;
	
	Результат = Новый Структура();
	Результат.Вставить("ОтПоследнейОперации", Ложь);
	Возврат Результат;
	
КонецФункции

// Заполняет структуру параметров выполнения эквайринговой операции.
//
// Возвращаемое значение:
//  Структура.
//
Функция ПараметрыВыполненияЭквайринговойОперации() Экспорт;
	
	Результат = Новый Структура();
	Результат.Вставить("ТипТранзакции"); // Строка,Обязательно - Тип транзакции.
	Результат.Вставить("СуммаОперации", 0); // Число,Обязательно - Сумма операции.
	Результат.Вставить("СуммаНаличных", 0); // Число,Необязательно - Сумма выдаваемых наличных.
	Результат.Вставить("НомерМерчанта"); // Целое,Необязательно - Номер мерчанта доступного для данного эквайрингового терминала.
	Результат.Вставить("НомерКарты");    // Строка,Необязательно - Маскированный номер карты.
	Результат.Вставить("НомерЧека");     // Строка,Необязательно - Номер чека.
	Результат.Вставить("НомерЧекаЭТ");   // Строка,Необязательно - Номер чека эквайрингового терминала.
	Результат.Вставить("СсылочныйНомер"); // Строка,Необязательно - Уникальный код транзакции RRN.
	Результат.Вставить("КодАвторизации"); // Строка,Необязательно - Код авторизации транзакции.
	Результат.Вставить("ТекстСлипЧека");  // Строка,Необязательно - Текст квитанции, сформированный Эквайринговым ПО.
	// Параметры выполнения эквайринговой операции c электронным сертификатом.
	Результат.Вставить("СуммаЭлектронногоСертификата", 0); // Число,Обязательно - Сумма операции за счет электронных сертификатов.
	Результат.Вставить("СуммаСобственныхСредств"    , 0); // Число,Обязательно - Сумма операции за счет собственных средств по карте.
	Результат.Вставить("ИдентификаторКорзины");  // Строка,Необязательно - Передается Basket ID – Уникальный идентификатор операции в ФЭС НСПК.
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает текст слип-чека по умолчанию  
//
// Параметры:
//  ПараметрыСлипЧека - Структура - Параметры слип чека
// 
// Возвращаемое значение:
//  Строка - Текст слип чека
//
Функция ТекстСлипЧекаПоУмолчанию(ПараметрыСлипЧека) Экспорт
	
	Если ПараметрыСлипЧека.Результат Тогда
		Текст = НСтр("ru = 'ПЛАТЕЖНАЯ ОПЕРАЦИЯ'") + Символы.ПС;
		Текст = Текст + СтрШаблон(НСтр("ru = 'Код авторизации: %1'"), ПараметрыСлипЧека.КодАвторизации) + Символы.ПС;
		Текст = Текст + СтрШаблон(НСтр("ru = 'Номер карты: %1'"),     ПараметрыСлипЧека.НомерКарты)     + Символы.ПС;
		Текст = Текст + СтрШаблон(НСтр("ru = 'Номер чека ЭТ: %1'"),   ПараметрыСлипЧека.НомерЧекаЭТ)    + Символы.ПС;
		Текст = Текст + СтрШаблон(НСтр("ru = 'Ссылочный номер: %1'"), ПараметрыСлипЧека.СсылочныйНомер) + Символы.ПС;
		Если ПараметрыСлипЧека.Свойство("СуммаОперации") Тогда
			Текст = Текст + СтрШаблон(НСтр("ru = 'Сумма: %1'"), ПараметрыСлипЧека.СуммаОперации);
		КонецЕсли;
	Иначе
		Текст = НСтр("ru = 'ОПЕРАЦИЯ ОТКЛОНЕНА'") + Символы.ПС;  
		Текст = Текст + ПараметрыСлипЧека.ОписаниеОшибки;
	КонецЕсли;
	
	Возврат Текст;    
	
КонецФункции

#КонецОбласти

