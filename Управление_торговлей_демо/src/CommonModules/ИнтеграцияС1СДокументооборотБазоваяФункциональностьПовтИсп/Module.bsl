////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Документооборотом"
// Модуль ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп, сервер, повт. использование
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Получает доступность функционала версии web-сервиса Документооборота.
//
// Параметры:
//   ВерсияСервиса - Строка - версия web-сервиса Документооборота, содержащая требуемый функционал.
//   Оптимистично - Булево - признак необходимости вернуть Истина, если версия сервиса пока неизвестна.
//
// Возвращаемое значение:
//   Булево - Истина, если web-сервис Документооборота указанной версии доступен.
//
Функция ДоступенФункционалВерсииСервиса(ВерсияСервиса = "", Оптимистично = Ложь) Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса(
		ВерсияСервиса,
		Оптимистично);
	
КонецФункции

// Возвращает идентификатор текущей базы данных, если он есть. Если нет, создает его и возвращает.
//
// Возвращаемое значение:
//   Строка
//
Функция ИдентификаторБазыДанных() Экспорт
	
	ЭтотУзел = ПланыОбмена.ИнтеграцияС1СДокументооборотомПереопределяемый.ЭтотУзел();
	Если СтрДлина(ЭтотУзел.Наименование) <> 36 Тогда
		ЭтотУзелОбъект = ЭтотУзел.ПолучитьОбъект();
		ЭтотУзелОбъект.Заблокировать();
		ЭтотУзелОбъект.Наименование = Строка(Новый УникальныйИдентификатор);
		ЭтотУзелОбъект.Код = 0;
		ЭтотУзелОбъект.ОбменДанными.Загрузка = Истина;
		ЭтотУзелОбъект.Записать();
	КонецЕсли;
	
	Возврат ЭтотУзел.Наименование;
	
КонецФункции

// Создает прокси веб-сервиса Документооборота. В случае ошибки при создании вызывается исключение.
//
// Возвращаемое значение:
//   WSПрокси - Прокси веб-сервиса
//
Функция ПолучитьПрокси() Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьПрокси();
	
КонецФункции

// Формирует таблицу соответствия типов XDTO и типов объектов информационной базы
//
// Возвращаемое значение:
//   ТаблицаЗначений - таблица с колонками:
//     * ИмяТипаXDTO - Строка - имя типа XDTO.
//     * ТипОбъектаИС - Тип - тип объекта ИС.
//     * ИмяТипаИС - Строка - полное имя типа объекта ИС.
//
Функция СоответствиеТипов() Экспорт
	
	Настройки = ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ИспользоватьИнтеграцию();
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("ИмяТипаXDTO", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("ТипОбъектаИС", Новый ОписаниеТипов("Тип"));
	
	// Поддерживаемые справочники.
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДобавитьСтрокуСоответствияТипов(Таблица,
		"DMCurrency", Тип("СправочникСсылка.Валюты"));
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДобавитьСтрокуСоответствияТипов(Таблица,
		"DMBank", Тип("СправочникСсылка.КлассификаторБанков"));
	
	Если Настройки.ИспользоватьИнтеграциюДО2 Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДобавитьСтрокуСоответствияТипов(Таблица,
			"DMUser", Тип("СправочникСсылка.Пользователи"));
	ИначеЕсли Настройки.ИспользоватьИнтеграциюДО3 Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДобавитьСтрокуСоответствияТипов(Таблица,
			"DMEmployee", Тип("СправочникСсылка.Пользователи"));
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ДополнитьСоответствиеТипов(Таблица);
	
	Таблица.Колонки.Добавить("ИмяТипаИС", Новый ОписаниеТипов("Строка"));
	
	Для Каждого Строка Из Таблица Цикл
		Строка.ИмяТипаИС = ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ИмяОбъектаМетаданныхПоТипу(
			Строка.ТипОбъектаИС);
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

// Получает текущего пользователя 1С:Документооборота.
//
// Возвращаемое значение:
//   ОбъектXDTO - Объект XDTO типа DMUser или Неопределено.
//
Функция ТекущийПользовательДокументооборота() Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотБазоваяФункциональность.ТекущийПользовательДокументооборота();
	
КонецФункции

// Возвращает массив типов объектов ИС, поддерживающих бесшовную интеграцию.
//
// Возвращаемое значение:
//   Массив из Тип
//
Функция ТипыОбъектовПоддерживающихИнтеграцию() Экспорт
	
	Типы = Новый Массив;
	
	Типы = Метаданные.ОпределяемыеТипы.ИнтеграцияС1СДокументооборотВсеСсылкиПереопределяемый.Тип.Типы();
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.
		ПриОпределенииТиповОбъектовПоддерживающихИнтеграцию(Типы);
	
	Возврат Типы;
	
КонецФункции

// Возвращает узел Документооборота. В случае отсутствия узел будет создан.
//
// Возвращаемое значение:
//   ПланОбменаСсылка.ИнтеграцияС1СДокументооборотомПереопределяемый
//
Функция УзелДокументооборота() Экспорт
	
	ЭтотУзел = ПланыОбмена.ИнтеграцияС1СДокументооборотомПереопределяемый.ЭтотУзел();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИнтеграцияС1СДокументооборотомПереопределяемый.Ссылка,
		|	ИнтеграцияС1СДокументооборотомПереопределяемый.Наименование
		|ИЗ
		|	ПланОбмена.ИнтеграцияС1СДокументооборотомПереопределяемый КАК ИнтеграцияС1СДокументооборотомПереопределяемый
		|ГДЕ
		|	ИнтеграцияС1СДокументооборотомПереопределяемый.Ссылка <> &ЭтотУзел";
		
	Запрос.УстановитьПараметр("ЭтотУзел", ЭтотУзел);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Узел1СДокументооборота = ПланыОбмена.ИнтеграцияС1СДокументооборотомПереопределяемый.СоздатьУзел();
		Узел1СДокументооборота.Наименование = НСтр("ru='1С:Документооборот'");
		Узел1СДокументооборота.Код = 1;
		Узел1СДокументооборота.Записать();
		Узел = Узел1СДокументооборота.Ссылка;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Узел = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Узел;
	
КонецФункции

#КонецОбласти