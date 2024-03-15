
#Область ПрограммныйИнтерфейс

#Область Проведение

// Формирует параметры для проведения документа по регистрам учетного механизма через общий механизм проведения.
//
// Параметры:
//  Документ - ДокументОбъект - записываемый документ
//  Свойства - См. ПроведениеДокументов.СвойстваДокумента
//
// Возвращаемое значение:
//  Структура - См. ПроведениеДокументов.ПараметрыУчетногоМеханизма
//
Функция ПараметрыДляПроведенияДокумента(Документ, Свойства) Экспорт
	
	Параметры = ПроведениеДокументов.ПараметрыУчетногоМеханизма();
	
	// Проведение
	Если Свойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыНакопления.ЗаказыНаВнутреннееПотребление);
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыНакопления.ЗаказыНаПеремещение);
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыНакопления.ЗаказыНаСборку);
		
	КонецЕсли;
	
	// Контроль
	Если Свойства.РежимЗаписи <> РежимЗаписиДокумента.Запись Тогда
		
		ТипДокумента = ТипЗнч(Документ);
		
		ИсправительныйДокумент = ИсправлениеДокументов.ЭтоИсправительныйДокумент(Документ);
		
		Если ТипДокумента = Тип("ДокументОбъект.ЗаказНаВнутреннееПотребление")
			Или Свойства.РежимЗаписи = РежимЗаписиДокумента.Проведение
				И ТипДокумента = Тип("ДокументОбъект.ВнутреннееПотребление")
			Или ИсправительныйДокумент  Тогда
			Параметры.КонтрольныеРегистрыИзменений.Добавить(Метаданные.РегистрыНакопления.ЗаказыНаВнутреннееПотребление);
		КонецЕсли;
		
		Если ТипДокумента = Тип("ДокументОбъект.ЗаказНаПеремещение")
			Или Свойства.РежимЗаписи = РежимЗаписиДокумента.Проведение
				И ТипДокумента = Тип("ДокументОбъект.ПеремещениеТоваров")
			Или ИсправительныйДокумент Тогда
			Параметры.КонтрольныеРегистрыИзменений.Добавить(Метаданные.РегистрыНакопления.ЗаказыНаПеремещение);
		КонецЕсли;
		
		Если ТипДокумента = Тип("ДокументОбъект.ЗаказНаСборку")
			Или Свойства.РежимЗаписи = РежимЗаписиДокумента.Проведение
				И ТипДокумента = Тип("ДокументОбъект.СборкаТоваров")
			Или ИсправительныйДокумент Тогда
			Параметры.КонтрольныеРегистрыИзменений.Добавить(Метаданные.РегистрыНакопления.ЗаказыНаСборку);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

// Возвращает тексты запросов для сторнирования движений при исправлении документов
// 
// Параметры:
// 	МетаданныеДокумента - ОбъектМетаданныхДокумент - Метаданные документа, который проводится.
// 
// Возвращаемое значение:
// 	Соответствие - Соответствие полного имени регистра тексту запроса сторнирования
//
Функция ТекстыЗапросовСторнирования(МетаданныеДокумента) Экспорт
	
	ДвиженияДокумента = МетаданныеДокумента.Движения;
	ТекстыЗапросов = Новый Соответствие();
	
	МетаданныеРегистра = Метаданные.РегистрыНакопления.ЗаказыНаВнутреннееПотребление;
	
	Если ДвиженияДокумента.Содержит(МетаданныеРегистра) Тогда
		ТекстыЗапросов.Вставить(МетаданныеРегистра.ПолноеИмя(),
			ПроведениеДокументов.ТекстСторнирующегоЗапроса(
				МетаданныеРегистра, МетаданныеДокумента));
	КонецЕсли;
	
	МетаданныеРегистра = Метаданные.РегистрыНакопления.ЗаказыНаПеремещение;
	Если ДвиженияДокумента.Содержит(МетаданныеРегистра) Тогда
		ТекстыЗапросов.Вставить(МетаданныеРегистра.ПолноеИмя(),
			ПроведениеДокументов.ТекстСторнирующегоЗапроса(
				МетаданныеРегистра, МетаданныеДокумента));
	КонецЕсли;
	
	МетаданныеРегистра = Метаданные.РегистрыНакопления.ЗаказыНаСборку;
	Если ДвиженияДокумента.Содержит(МетаданныеРегистра) Тогда
		ТекстыЗапросов.Вставить(МетаданныеРегистра.ПолноеИмя(),
			ПроведениеДокументов.ТекстСторнирующегоЗапроса(
				МетаданныеРегистра, МетаданныеДокумента));
	КонецЕсли;
	Возврат ТекстыЗапросов;
	
КонецФункции

// Процедура формирования движений по подчиненным регистрам внутреннего товародвижения.
//
// Параметры:
//	ТаблицыДляДвижений - Структура - таблицы данных документа
//	Движения - КоллекцияДвижений - коллекция наборов записей движений документа
//	Отказ - Булево - признак отказа от проведения документа.
//
Процедура ОтразитьДвижения(ТаблицыДляДвижений, Движения, Отказ) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "ЗаказыНаВнутреннееПотребление");
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "ЗаказыНаПеремещение");
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "ЗаказыНаСборку");
	
КонецПроцедуры

// Дополняет текст запроса механизма проверки даты запрета по таблице изменений.
// 
// Параметры:
// 	Запрос - Запрос - используется для установки параметров запроса.
// 
// Возвращаемое значение:
//	Соответствие - соответствие имен таблиц изменения регистров и текстов запросов.
//	
Функция ТекстыЗапросовКонтрольДатыЗапретаПоТаблицеИзменений(Запрос) Экспорт

	СоответствиеТекстовЗапросов = Новый Соответствие();
	Возврат СоответствиеТекстовЗапросов;
	
КонецФункции

// Формирует тексты запросов для контроля изменений записанных движений регистров.
//
// Параметры:
//  Запрос - Запрос - запрос, хранящий параметры используемые в списке запросов
//  ТекстыЗапроса - СписокЗначений - список текстов запросов и их имен.
//  Документ - ДокументОбъект - записываемый документ.
//
Процедура ИнициализироватьДанныеКонтроляИзменений(Запрос, ТекстыЗапроса, Документ) Экспорт
	
	#Область ЗаказыНаВнутреннееПотребление
	
	Если ПроведениеДокументов.ЕстьЗаписиВТаблице(Документ, "ДвиженияЗаказыНаВнутреннееПотреблениеИзменение") Тогда
		
		ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров =
			Константы.ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров.Получить();
		
		Если ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров = 0 Тогда
			
			ТекстЗапроса =
				"ВЫБРАТЬ
				|	ТаблицаОстатков.ЗаказНаВнутреннееПотребление  КАК Заказ,
				|	ТаблицаОстатков.Номенклатура                  КАК Номенклатура,
				|	ТаблицаОстатков.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
				|	ТаблицаОстатков.Характеристика                КАК Характеристика,
				|	ТаблицаОстатков.Серия                         КАК Серия,
				|	ТаблицаОстатков.Склад                         КАК Склад,
				|	ТаблицаОстатков.КОформлениюОстаток            КАК Количество
				|ИЗ
				|	РегистрНакопления.ЗаказыНаВнутреннееПотребление.Остатки(,
				|			(ЗаказНаВнутреннееПотребление, Номенклатура, Характеристика, Серия, Склад) В
				|				(ВЫБРАТЬ
				|					Таблица.ЗаказНаВнутреннееПотребление,
				|					Таблица.Номенклатура,
				|					Таблица.Характеристика,
				|					Таблица.Серия,
				|					Таблица.Склад
				|				ИЗ
				|					ДвиженияЗаказыНаВнутреннееПотреблениеИзменение КАК Таблица)
				|	) КАК ТаблицаОстатков
				|ГДЕ
				|	ТаблицаОстатков.КОформлениюОстаток < 0";
			
		Иначе
			
			ТекстЗапроса = 
				"ВЫБРАТЬ
				|	ЗаказыОстатки.ЗаказНаВнутреннееПотребление   КАК Заказ,
				|	ЗаказыОстатки.Номенклатура                   КАК Номенклатура,
				|	ЗаказыОстатки.Номенклатура.ЕдиницаИзмерения  КАК ЕдиницаИзмерения,
				|	ЗаказыОстатки.Характеристика                 КАК Характеристика,
				|	ЗаказыОстатки.Серия                          КАК Серия,
				|	ЗаказыОстатки.Склад                          КАК Склад,
				|	ЗаказыОстатки.КОформлениюОстаток             КАК Количество
				|ИЗ
				|	ВТЗаказыНаВнутреннееПотреблениеОстатки КАК ЗаказыОстатки
				|	ЛЕВОЕ СОЕДИНЕНИЕ
				|		ВТДопустимыеОтклоненияЗаказыНаВнутреннееПотребление КАК ДопустимыеОтклонения
				|		ПО
				|			ЗаказыОстатки.ЗаказНаВнутреннееПотребление = ДопустимыеОтклонения.ЗаказНаВнутреннееПотребление
				|			И ЗаказыОстатки.Номенклатура               = ДопустимыеОтклонения.Номенклатура
				|			И ЗаказыОстатки.Характеристика             = ДопустимыеОтклонения.Характеристика
				|			И ЗаказыОстатки.Склад                      = ДопустимыеОтклонения.Склад
				|			И ЗаказыОстатки.Серия                      = ДопустимыеОтклонения.Серия
				|ГДЕ
				|	ЗаказыОстатки.КОформлениюОстаток + ЕСТЬNULL(ДопустимыеОтклонения.ДопустимоеОтклонение,0) < 0";
			
		КонецЕсли;
		
		ТекстыЗапроса.Добавить(ТекстЗапроса, "ОшибкиЗаказыНаВнутреннееПотребление");
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ЗаказыНаПеремещение
	
	Если ПроведениеДокументов.ЕстьЗаписиВТаблице(Документ, "ДвиженияЗаказыНаПеремещениеИзменение") Тогда
		
		ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров =
			Константы.ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров.Получить();
		
		Если ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров = 0 Тогда
			
			ТекстЗапроса =
				"ВЫБРАТЬ
				|	ТаблицаОстатков.ЗаказНаПеремещение КАК Заказ,
				|	ТаблицаОстатков.Номенклатура       КАК Номенклатура,
				|	ТаблицаОстатков.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
				|	ТаблицаОстатков.Характеристика     КАК Характеристика,
				|	ТаблицаОстатков.Серия              КАК Серия,
				|	НЕОПРЕДЕЛЕНО                       КАК Склад,
				|	НЕОПРЕДЕЛЕНО                       КАК Подразделение,
				|	ТаблицаОстатков.КОформлениюОстаток КАК Количество
				|ИЗ
				|	РегистрНакопления.ЗаказыНаПеремещение.Остатки(,
				|			(ЗаказНаПеремещение, Номенклатура, Характеристика, Серия) В
				|				(ВЫБРАТЬ
				|					Таблица.ЗаказНаПеремещение,
				|					Таблица.Номенклатура,
				|					Таблица.Характеристика,
				|					Таблица.Серия
				|				ИЗ
				|					ДвиженияЗаказыНаПеремещениеИзменение КАК Таблица)
				|	) КАК ТаблицаОстатков
				|ГДЕ
				|	ТаблицаОстатков.КОформлениюОстаток < 0";
			
		Иначе
			
			ТекстЗапроса = 
				"ВЫБРАТЬ
				|	ЗаказыОстатки.ЗаказНаПеремещение             КАК Заказ,
				|	ЗаказыОстатки.Номенклатура                   КАК Номенклатура,
				|	ЗаказыОстатки.Номенклатура.ЕдиницаИзмерения  КАК ЕдиницаИзмерения,
				|	ЗаказыОстатки.Характеристика                 КАК Характеристика,
				|	ЗаказыОстатки.Серия                          КАК Серия,
				|	НЕОПРЕДЕЛЕНО                                 КАК Склад,
				|	НЕОПРЕДЕЛЕНО                                 КАК Подразделение,
				|	ЗаказыОстатки.КОформлениюОстаток             КАК Количество
				|ИЗ
				|	ВТЗаказыНаПеремещениеОстатки КАК ЗаказыОстатки
				|	ЛЕВОЕ СОЕДИНЕНИЕ
				|		ВТДопустимыеОтклоненияЗаказыНаПеремещение КАК ДопустимыеОтклонения
				|		ПО
				|			ЗаказыОстатки.ЗаказНаПеремещение = ДопустимыеОтклонения.ЗаказНаПеремещение
				|			И ЗаказыОстатки.Номенклатура     = ДопустимыеОтклонения.Номенклатура
				|			И ЗаказыОстатки.Характеристика   = ДопустимыеОтклонения.Характеристика
				|			И ЗаказыОстатки.Серия            = ДопустимыеОтклонения.Серия
				|ГДЕ
				|	ЗаказыОстатки.КОформлениюОстаток + ЕСТЬNULL(ДопустимыеОтклонения.ДопустимоеОтклонение,0) < 0";
			
		КонецЕсли;
		
		ТекстыЗапроса.Добавить(ТекстЗапроса, "ОшибкиЗаказыНаПеремещение");
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ЗаказыНаСборку
	
	Если ПроведениеДокументов.ЕстьЗаписиВТаблице(Документ, "ДвиженияЗаказыНаСборкуИзменение") Тогда
		
		ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров =
			Константы.ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров.Получить();
		
		Если ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров = 0 Тогда
			
			ТекстЗапроса =
				"ВЫБРАТЬ
				|	ТаблицаОстатков.ЗаказНаСборку      КАК ЗаказНаСборку,
				|	ТаблицаОстатков.Номенклатура       КАК Номенклатура,
				|	ТаблицаОстатков.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
				|	ТаблицаОстатков.Характеристика     КАК Характеристика,
				|	ТаблицаОстатков.Серия              КАК Серия,
				|	ТаблицаОстатков.ТипСборки          КАК ТипСборки,
				|	ТаблицаОстатков.КОформлениюОстаток КАК Количество
				|ИЗ
				|	РегистрНакопления.ЗаказыНаСборку.Остатки(,
				|			(ЗаказНаСборку, Номенклатура, Характеристика, Серия, ТипСборки) В
				|				(ВЫБРАТЬ
				|					Таблица.ЗаказНаСборку,
				|					Таблица.Номенклатура,
				|					Таблица.Характеристика,
				|					Таблица.Серия,
				|					Таблица.ТипСборки
				|				ИЗ
				|					ДвиженияЗаказыНаСборкуИзменение КАК Таблица)
				|	) КАК ТаблицаОстатков
				|ГДЕ
				|	ТаблицаОстатков.КОформлениюОстаток < 0";
			
		Иначе
			
			ТекстЗапроса = 
				"ВЫБРАТЬ
				|	ЗаказыОстатки.ЗаказНаСборку                  КАК ЗаказНаСборку,
				|	ЗаказыОстатки.Номенклатура                   КАК Номенклатура,
				|	ЗаказыОстатки.Номенклатура.ЕдиницаИзмерения  КАК ЕдиницаИзмерения,
				|	ЗаказыОстатки.Характеристика                 КАК Характеристика,
				|	ЗаказыОстатки.Серия                          КАК Серия,
				|	ЗаказыОстатки.ТипСборки                      КАК ТипСборки,
				|	ЗаказыОстатки.КОформлениюОстаток             КАК Количество
				|ИЗ
				|	ВТЗаказыНаСборкуОстатки КАК ЗаказыОстатки
				|	ЛЕВОЕ СОЕДИНЕНИЕ
				|		ВТДопустимыеОтклоненияЗаказыНаСборку КАК ДопустимыеОтклонения
				|		ПО
				|			ЗаказыОстатки.ЗаказНаСборку    = ДопустимыеОтклонения.ЗаказНаСборку
				|			И ЗаказыОстатки.Номенклатура   = ДопустимыеОтклонения.Номенклатура
				|			И ЗаказыОстатки.Характеристика = ДопустимыеОтклонения.Характеристика
				|			И ЗаказыОстатки.ТипСборки      = ДопустимыеОтклонения.ТипСборки
				|			И ЗаказыОстатки.Серия          = ДопустимыеОтклонения.Серия
				|ГДЕ
				|	ЗаказыОстатки.КОформлениюОстаток + ЕСТЬNULL(ДопустимыеОтклонения.ДопустимоеОтклонение,0) < 0";
			
		КонецЕсли;
		
		ТекстыЗапроса.Добавить(ТекстЗапроса, "ОшибкиЗаказыНаСборку");
		
	КонецЕсли;
	
	#КонецОбласти
	
КонецПроцедуры

// Выводит сообщения пользователю при наличии ошибок контроля изменений записанных движений регистров.
//
// Параметры:
//  РезультатыКонтроля - Структура - таблицы с результатами контроля изменений
//  Документ - ДокументОбъект - записываемый документ
//  Отказ - Булево - признак отказа от проведения документа.
//
Процедура СообщитьОРезультатахКонтроляИзменений(РезультатыКонтроля, Документ, Отказ) Экспорт
	
	#Область ЗаказыНаВнутреннееПотребление
	
	Если ПроведениеДокументов.ЕстьЗаписиВТаблице(Документ, "ДвиженияЗаказыНаВнутреннееПотреблениеИзменение") Тогда
		
		Если ТипЗнч(Документ) = Тип("ДокументОбъект.ВнутреннееПотребление") Тогда
			
			ШаблонСообщенияСоСкладом = НСтр("ru = 'Номенклатура %1, склад %2
				|Оформлено больше, чем указано в распоряжении, на %3 %4'");
			ШаблонСообщенияБезСклада = НСтр("ru = 'Номенклатура %1
				|Оформлено больше, чем указано в распоряжении, на %3 %4'");
			
		Иначе
			
			ШаблонСообщенияСоСкладом = НСтр("ru = 'Номенклатура %1, склад %2
				|Оформлено внутреннее потребление в количестве большем, чем указано в документе, на %3 %4'");
			ШаблонСообщенияБезСклада = НСтр("ru = 'Номенклатура %1
				|Оформлено внутреннее потребление в количестве большем, чем указано в документе, на %3 %4'");
			
		КонецЕсли;
		
		Для каждого СтрокаОшибки Из РезультатыКонтроля.ОшибкиЗаказыНаВнутреннееПотребление Цикл
			
			ПредставлениеНоменклатуры = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
				СтрокаОшибки.Номенклатура, СтрокаОшибки.Характеристика);
			
			Если ЗначениеЗаполнено(СтрокаОшибки.Склад) Тогда
 				ТекстСообщения = СтрШаблон(ШаблонСообщенияСоСкладом, ПредставлениеНоменклатуры, СтрокаОшибки.Склад,
					-СтрокаОшибки.Количество, СтрокаОшибки.ЕдиницаИзмерения);
			Иначе
 				ТекстСообщения = СтрШаблон(ШаблонСообщенияБезСклада, ПредставлениеНоменклатуры,,
					-СтрокаОшибки.Количество, СтрокаОшибки.ЕдиницаИзмерения);
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Документ,,, Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ЗаказыНаВнутреннееПотребление
	
	Если ПроведениеДокументов.ЕстьЗаписиВТаблице(Документ, "ДвиженияЗаказыНаПеремещениеИзменение") Тогда
		
		ШаблонСообщенияСоСкладомСПодразделением = НСтр("ru = 'Номенклатура %1, склад %2, подразделение %3
			|Оформлено больше, чем указано в распоряжении на оформление, на %4 %5'");
			
		ШаблонСообщенияСоСкладомБезПодразделения = НСтр("ru = 'Номенклатура %1, склад %2
			|Оформлено больше, чем указано в распоряжении на оформление, на %4 %5'");
			
		ШаблонСообщенияБезСкладаСПодразделением = НСтр("ru = 'Номенклатура %1, подразделение %3
			|Оформлено больше, чем указано в распоряжении на оформление, на %4 %5'");
			
		ШаблонСообщенияБезСкладаБезПодразделения = НСтр("ru = 'Номенклатура %1
			|Оформлено больше, чем указано в распоряжении на оформление, на %4 %5'");
		
		Для каждого СтрокаОшибки Из РезультатыКонтроля.ОшибкиЗаказыНаПеремещение Цикл
			
			ПредставлениеНоменклатуры = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
				СтрокаОшибки.Номенклатура, СтрокаОшибки.Характеристика);
			
			Если ЗначениеЗаполнено(СтрокаОшибки.Склад) И ЗначениеЗаполнено(СтрокаОшибки.Подразделение) Тогда
				ТекстСообщения = СтрШаблон(ШаблонСообщенияСоСкладомСПодразделением,
					ПредставлениеНоменклатуры, СтрокаОшибки.Склад, СтрокаОшибки.Подразделение,
					-СтрокаОшибки.Количество, СтрокаОшибки.ЕдиницаИзмерения);
			ИначеЕсли ЗначениеЗаполнено(СтрокаОшибки.Склад) И Не ЗначениеЗаполнено(СтрокаОшибки.Подразделение) Тогда
				ТекстСообщения = СтрШаблон(ШаблонСообщенияСоСкладомБезПодразделения,
					ПредставлениеНоменклатуры, СтрокаОшибки.Склад,,
					-СтрокаОшибки.Количество, СтрокаОшибки.ЕдиницаИзмерения);
			ИначеЕсли Не ЗначениеЗаполнено(СтрокаОшибки.Склад) И ЗначениеЗаполнено(СтрокаОшибки.Подразделение) Тогда
				ТекстСообщения = СтрШаблон(ШаблонСообщенияБезСкладаСПодразделением,
					ПредставлениеНоменклатуры,, СтрокаОшибки.Подразделение,
					-СтрокаОшибки.Количество, СтрокаОшибки.ЕдиницаИзмерения);
			Иначе
				ТекстСообщения = СтрШаблон(ШаблонСообщенияБезСкладаБезПодразделения, ПредставлениеНоменклатуры,,,
					-СтрокаОшибки.Количество, СтрокаОшибки.ЕдиницаИзмерения);
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Документ,,, Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ЗаказыЗаказыНаСборку
	
	Если ПроведениеДокументов.ЕстьЗаписиВТаблице(Документ, "ДвиженияЗаказыНаСборкуИзменение") Тогда
		
		ШаблонСообщения = НСтр("ru = 'Номенклатура %1
			|Оформлено больше, чем указано в распоряжении на оформление, на %2 %3'");
		
		Для каждого СтрокаОшибки Из РезультатыКонтроля.ОшибкиЗаказыНаСборку Цикл
			
			ПредставлениеНоменклатуры = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
				СтрокаОшибки.Номенклатура, СтрокаОшибки.Характеристика);
			
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПредставлениеНоменклатуры,
				-СтрокаОшибки.Количество, СтрокаОшибки.ЕдиницаИзмерения);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Документ,,, Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	#КонецОбласти
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти