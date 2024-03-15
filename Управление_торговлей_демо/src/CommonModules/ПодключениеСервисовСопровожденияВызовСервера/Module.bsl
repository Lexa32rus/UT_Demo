///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ПодключениеСервисовСопровожденияВызовСервера.
//
// Серверный процедуры и функции для вызова с клиента при подключении тестовых периодов:
//  - обработка результатов подключения;
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Создает регламентное задание "ПодключениеТестовыхПериодов" и
// записывает информацию в регистр сведений "ИдентификаторыЗапросовНаПодключение".
//
// Параметры:
//  СервисСопровождения           - Справочник.ИдентификаторыСервисовСопровождения - сервис,
//                                для которого необходимо проверить состояние запроса
//                                на подключение;
//  ИдентификаторЗапроса          - Строка - идентификатор запроса по которому будет
//                                произведена проверка;
//  ИдентификаторТестовогоПериода - Строка - уникальный идентификатор тестового периода;
//  НаименованиеТестовогоПериода  - Строка - наименование подключаемого тестового периода.
//
Процедура СоздатьРегламентноеЗаданиеПроверкиПодключения(
		Знач СервисСопровождения,
		Знач ИдентификаторЗапроса,
		Знач ИдентификаторТестовогоПериода,
		Знач НаименованиеТестовогоПериода) Экспорт
	
	ПодключениеСервисовСопровождения.СоздатьРегламентноеЗаданиеПроверкиПодключения(
		СервисСопровождения,
		ИдентификаторЗапроса,
		ИдентификаторТестовогоПериода,
		НаименованиеТестовогоПериода);
	
КонецПроцедуры

// Получает информацию о тестовых периодах, предварительно обновляя кэш тестовых периодов,
// если данные устарели.
//
// Параметры:
//  Идентификатор  - Строка - идентификатор сервиса в системе Портал 1С:ИТС.
//
// Возвращаемое значение - см. ПодключениеСервисовСопровождения.ТестовыеПериодыСервисаСопровождения.
//
Функция ТестовыеПериодыСервисаСопровождения(Знач Идентификатор) Экспорт
	
	Возврат ПодключениеСервисовСопровождения.ТестовыеПериодыСервисаСопровождения(Идентификатор);
	
КонецФункции

// Удаляет обработанные идентификаторы запросов.
//
// Параметры:
//  СервисСопровождения  - Справочник.ИдентификаторыСервисовСопровождения - сервис,
//                         для которого необходимо удалить запросы на подключение;
//  ИдентификаторЗапроса - Строка - идентификатор запроса, который уже обработан.
//
Процедура УдалитьИнформациюОЗапросеНаПодключение(
		Знач СервисСопровождения,
		Знач ИдентификаторЗапроса) Экспорт
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	ПодключениеСервисовСопровождения.УдалитьИнформациюОЗапросеНаПодключение(
		СервисСопровождения,
		ИдентификаторЗапроса);
	
КонецПроцедуры

// Формирует массив данных для вывода оповещений.
//
// Возвращаемое значение - см. ПодключениеСервисовСопровождения.ДанныеОповещенийОбОбработкеЗапросов.
//
Функция ДанныеОповещенийОбОбработкеЗапросов() Экспорт
	
	Возврат ПодключениеСервисовСопровождения.ДанныеОповещенийОбОбработкеЗапросов();
	
КонецФункции

#КонецОбласти