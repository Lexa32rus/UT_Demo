#Область СлужебныйПрограммныйИнтерфейс

#Область РасчетХешСумм

// Пересчитывает хеш-суммы всех упаковок формы и проверяется необходимость перемаркировки.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма проверки и подбора маркируемой продукции.
//
Процедура ПересчитатьХешСуммыВсехУпаковок(Форма) Экспорт
	
	Если Не Форма.ПроверятьНеобходимостьПеремаркировки Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.ДетализацияСтруктурыХранения = Перечисления.ДетализацияСтруктурыХраненияИС.ПотребительскиеУпаковки Тогда
		Форма.КоличествоУпаковокКоторыеНеобходимоПеремаркировать = 0;
		ПроверкаИПодборПродукцииМОТПКлиентСервер.ОтобразитьИнформациюОНеобходимостиПеремаркировки(Форма);
		Возврат;
	КонецЕсли;
	
	ТаблицаХешСумм = ПроверкаИПодборПродукцииИС.ПустаяТаблицаХешСумм();
	
	Для Каждого СтрокаДерева Из Форма.ДеревоМаркированнойПродукции.ПолучитьЭлементы() Цикл
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(СтрокаДерева.ТипУпаковки)
			Или СтрокаДерева.ТипУпаковки = ПроверкаИПодборПродукцииИСМПКлиентСервер.ТипУпаковкиГрупповыеУпаковкиБезКоробки() Тогда
			ПроверкаИПодборПродукцииИС.РассчитатьХешСуммыУпаковки(СтрокаДерева, ТаблицаХешСумм, Истина);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаПеремаркировки = ПроверкаИПодборПродукцииИС.ТаблицаПеремаркировки(ТаблицаХешСумм);
	
	ПроверкаИПодборПродукцииМОТПКлиентСервер.ПроверитьНеобходимостьПеремаркировки(Форма, ТаблицаПеремаркировки, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область РасчетДопустимойДетализацииСтруктурыХраненияПоДокументу

// Возвращает допустимые детализации структуры хранения по документу, доступные при открытии формы проверки и подбора.
// Параметры:
//  ПоДокументу - Булево - делализация с учетом документа.
//  ПроверяемыйДокумент - ДокументСсылка - ссылка на проверяемый документ, для которого производится открытие формы.
//
// Возвращаемое значение:
//  Массив - массив из ПеречислениеСсылка.ДетализацияСтруктурыХраненияИС.
Функция ДопустимыеДетализацииСтруктурыХранения(ПоДокументу = Ложь, ПроверяемыйДокумент = Неопределено) Экспорт
	
	ВозможныеДетализации = Новый Массив;
	
	ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.Полная);
	
	Если ПоДокументу И ТипЗнч(ПроверяемыйДокумент) = Тип("ДокументСсылка.МаркировкаТоваровИСМП") Тогда
		Возврат ВозможныеДетализации;
	КонецЕсли;
	
	ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.ГрупповыеУпаковкиСПотребительскими);
	ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.ПотребительскиеУпаковки);
	ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.ПалетыСМонотоварнымиКоробами);
	ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.КоробаСГрупповымиУпаковками);
	
	Возврат ВозможныеДетализации;
	
КонецФункции

// Возвращает список допустимых детализаций по фактической детализации документа
// 
// Параметры:
//  ФактическаяДетализация - ПеречислениеСсылка.ДетализацияСтруктурыХраненияИС - Фактическая детализация.
// Возвращаемое значение:
//  Массив Из ПеречислениеСсылка.ДетализацияСтруктурыХраненияИС - Допустимые детализации
Функция ДетализацияТребуетЗапросаКСервису(ФактическаяДетализация) Экспорт
	
	ДетализацииТребующиеЗапросаКСервису = Новый Массив;
	
	Если ФактическаяДетализация = Перечисления.ДетализацияСтруктурыХраненияИС.ПалетыСМонотоварнымиКоробами Тогда
		ДетализацииТребующиеЗапросаКСервису.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.КоробаСГрупповымиУпаковками);
	КонецЕсли;
	
	Если ФактическаяДетализация = Перечисления.ДетализацияСтруктурыХраненияИС.ПалетыСМонотоварнымиКоробами
		Или ФактическаяДетализация = Перечисления.ДетализацияСтруктурыХраненияИС.КоробаСГрупповымиУпаковками Тогда
		ДетализацииТребующиеЗапросаКСервису.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.ГрупповыеУпаковки);
	КонецЕсли;
	
	Если ФактическаяДетализация = Перечисления.ДетализацияСтруктурыХраненияИС.ПалетыСМонотоварнымиКоробами
		Или ФактическаяДетализация = Перечисления.ДетализацияСтруктурыХраненияИС.КоробаСГрупповымиУпаковками
		Или ФактическаяДетализация = Перечисления.ДетализацияСтруктурыХраненияИС.ГрупповыеУпаковки Тогда
		ДетализацииТребующиеЗапросаКСервису.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.ГрупповыеУпаковкиСПотребительскими);
	КонецЕсли;
	
	Если ФактическаяДетализация = Перечисления.ДетализацияСтруктурыХраненияИС.ПалетыСМонотоварнымиКоробами
		Или ФактическаяДетализация = Перечисления.ДетализацияСтруктурыХраненияИС.КоробаСГрупповымиУпаковками
		Или ФактическаяДетализация = Перечисления.ДетализацияСтруктурыХраненияИС.ГрупповыеУпаковки
		Или ФактическаяДетализация = Перечисления.ДетализацияСтруктурыХраненияИС.ГрупповыеУпаковкиСПотребительскими Тогда
		ДетализацииТребующиеЗапросаКСервису.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.ПотребительскиеУпаковки);
	КонецЕсли;
	
	ДетализацииТребующиеЗапросаКСервису.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.Полная);
	
	Возврат ДетализацииТребующиеЗапросаКСервису;
	
КонецФункции

// Возвращает детализацию структуры хранения, рассчитанную по данным статистики по документу.
// 
// Параметры:
//  ДанныеШтрихкодовСписок - ТаблицаЗначений - таблица штрихкодов упаковок проверяемого документа. (См ШтрихкодированиеМОТП.ШтрихкодыУпаковокИзДокумента).
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
//  ПроверяемыйДокумент - ДокументСсылка - ссылка на проверяемый документ.
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид продукции.
//  Кэш - Неопределено, Соответствие - кэш.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ДетализацияСтруктурыХраненияИС - детализация структуры хранения.
Функция ДетализацияНаОснованииСтатистикиПоШтрихкодам(ДанныеШтрихкодовСписок, ПараметрыСканирования, ПроверяемыйДокумент, ВидПродукции, Кэш = Неопределено) Экспорт
	
	Если ТипЗнч(ПроверяемыйДокумент) = Тип("ДокументСсылка.МаркировкаТоваровИСМП") Тогда
		Возврат Перечисления.ДетализацияСтруктурыХраненияИС.Полная;
	КонецЕсли;
	
	КоличествоПалет           = 0;
	КоличествоКоробов         = 0;
	КоличествоГрупповых       = 0;
	КоличествоПотребительских = 0;
	
	Кэш = Новый Соответствие;
	
	ДоступнаКолонкаВидУпаковки        = Ложь;
	ПрямойДоступКЗначениюВидаУпаковки = Истина;
	ДоступнаКолонкаВидПродукции       = Ложь;
	Если ТипЗнч(ДанныеШтрихкодовСписок) = Тип("Соответствие") Тогда
		ИмяКолонкиШтрихкод                = "Ключ";
		ДоступнаКолонкаВидУпаковки        = Истина;
		ПрямойДоступКЗначениюВидаУпаковки = Ложь;
	ИначеЕсли ТипЗнч(ДанныеШтрихкодовСписок) = Тип("Массив")
		Или ТипЗнч(ДанныеШтрихкодовСписок) = Тип("ТаблицаЗначений") Тогда
		ИмяКолонкиШтрихкод         = "Штрихкод";
		ДоступнаКолонкаВидУпаковки = ДанныеШтрихкодовСписок.Количество() > 0
			И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеШтрихкодовСписок[0], "ВидУпаковки");
		ДоступнаКолонкаВидПродукции = ДанныеШтрихкодовСписок.Количество() > 0
			И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеШтрихкодовСписок[0], "ВидПродукции");
	КонецЕсли;
	
	Для Каждого ДанныеШтрихкода Из ДанныеШтрихкодовСписок Цикл
		
		КодМаркировки = ДанныеШтрихкода[ИмяКолонкиШтрихкод];
		
		Если Кэш[КодМаркировки] = Неопределено Тогда
			
			Если ДоступнаКолонкаВидПродукции И ЗначениеЗаполнено(ДанныеШтрихкода.ВидПродукции) Тогда
				ВидПродукции = ДанныеШтрихкода.ВидПродукции;
			КонецЕсли;
			
			ПримечаниеКРезультатуРазбора = Неопределено;
			ДанныеРазбора                = РазборКодаМаркировкиИССлужебный.РазобратьКодМаркировки(КодМаркировки, ВидПродукции, ПримечаниеКРезультатуРазбора);
			
			Кэш[КодМаркировки] = Новый Структура("ДанныеРазбора, ПримечаниеКРезультатуРазбора", ДанныеРазбора, ПримечаниеКРезультатуРазбора);
			
		Иначе
			
			Продолжить; // Групповая/Логистическая упаковки уже посчитаны
			
		КонецЕсли;
		
		Если ДанныеРазбора = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ДоступнаКолонкаВидУпаковки
			И Не ЗначениеЗаполнено(ДанныеРазбора.ВидУпаковки) Тогда
			Если ПрямойДоступКЗначениюВидаУпаковки Тогда
				ВидУпаковки = ДанныеШтрихкода.ВидУпаковки;
			Иначе
				ВидУпаковки = ДанныеШтрихкода.Значение.ВидУпаковки;
			КонецЕсли;
			Если ЗначениеЗаполнено(ВидУпаковки) Тогда
				ДанныеРазбора.ВидУпаковки = ВидУпаковки;
			КонецЕсли;
		КонецЕсли;
		
		Если ДанныеРазбора.ВидУпаковки = Перечисления.ВидыУпаковокИС.Логистическая Тогда
			Если ДанныеРазбора.СоставКодаМаркировки.Свойство("GTIN")
				И ЗначениеЗаполнено(ДанныеРазбора.СоставКодаМаркировки.GTIN) Тогда
				КоличествоКоробов = КоличествоКоробов + 1;
			Иначе
				КоличествоПалет = КоличествоПалет + 1;
			КонецЕсли;
		ИначеЕсли ДанныеРазбора.ВидУпаковки = Перечисления.ВидыУпаковокИС.Групповая
			Или ПроверкаИПодборПродукцииИСМПКлиентСервер.ВСтрокеНаборКакГрупповая(ДанныеРазбора, Ложь, ПараметрыСканирования) Тогда
			КоличествоГрупповых = КоличествоГрупповых + 1;
		ИначеЕсли ДанныеРазбора.ВидУпаковки = Перечисления.ВидыУпаковокИС.Потребительская
			Или ПроверкаИПодборПродукцииИСМПКлиентСервер.ВСтрокеНаборКакПотребительская(ДанныеРазбора, Ложь, ПараметрыСканирования) Тогда
			КоличествоПотребительских = КоличествоПотребительских + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	ВозможныеДетализации = Новый Массив;
	
	Если КоличествоПалет > 0 Тогда
		ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.ПалетыСМонотоварнымиКоробами);
	ИначеЕсли КоличествоКоробов >= 25 Тогда
		ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.ПалетыСМонотоварнымиКоробами);
	ИначеЕсли КоличествоКоробов >= 5 Тогда
		ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.КоробаСГрупповымиУпаковками);
	ИначеЕсли КоличествоГрупповых >= 250 Тогда
		ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.КоробаСГрупповымиУпаковками);
	Иначе
		
		Если ПараметрыСканирования.ЗапрашиватьДанныеНеизвестныхУпаковокИСМП Тогда
			ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.Полная);
			ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.ПалетыСМонотоварнымиКоробами);
			ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.КоробаСГрупповымиУпаковками);
			ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.ГрупповыеУпаковки);
			ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.ГрупповыеУпаковкиСПотребительскими);
			ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.ПотребительскиеУпаковки);
		Иначе
			
			// ГрупповыеУпаковки не поддерживаются в форме проверки
			
			Если КоличествоПотребительских > 0
				И КоличествоГрупповых = 0
				И КоличествоКоробов = 0
				И КоличествоПалет = 0 Тогда
				ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.ПотребительскиеУпаковки);
			КонецЕсли;
			
			Если КоличествоПалет = 0 Тогда
				ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.КоробаСГрупповымиУпаковками);
			КонецЕсли;
			
			ВозможныеДетализации.Добавить(Перечисления.ДетализацияСтруктурыХраненияИС.Полная);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыСканирования.ДетализацияСтруктурыХранения) Тогда
		Возврат ВозможныеДетализации[0];
	ИначеЕсли ВозможныеДетализации.Найти(ПараметрыСканирования.ДетализацияСтруктурыХранения) = Неопределено Тогда
		Возврат ВозможныеДетализации[0];
	ИначеЕсли ПараметрыСканирования.ДетализацияСтруктурыХранения = Перечисления.ДетализацияСтруктурыХраненияИС.ПалетыСМонотоварнымиКоробами
		Или ПараметрыСканирования.ДетализацияСтруктурыХранения = Перечисления.ДетализацияСтруктурыХраненияИС.КоробаСГрупповымиУпаковками Тогда
		Возврат Перечисления.ДетализацияСтруктурыХраненияИС.КоробаСГрупповымиУпаковками;
	КонецЕсли;
	
	Возврат ПараметрыСканирования.ДетализацияСтруктурыХранения;
	
КонецФункции

#КонецОбласти

Процедура ОпределитьВидыУпаковокПоДаннымИнформационнойБазы(ВидПродукции, Штрихкоды, КешДанныхРазбора, ДанныеРазбораШтрихкода) Экспорт
	
	Если Штрихкоды.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СписокEAN   = Новый Массив;
	СписокGTIN  = Новый Массив;
	EANШтрихкод = Новый Соответствие;
	
	Для Каждого Штрихкод Из Штрихкоды Цикл
		ДанныеРазбора = КешДанныхРазбора[Штрихкод].ДанныеРазбора;
		Если Неопределено = ДанныеРазбора
			Или ЗначениеЗаполнено(ДанныеРазбора.ВидУпаковки)
			Или Не ДанныеРазбора.СоставКодаМаркировки.Свойство("EAN")
			Или Не ЗначениеЗаполнено(ДанныеРазбора.СоставКодаМаркировки.EAN) Тогда
			Продолжить;
		КонецЕсли;
		EAN = ДанныеРазбора.СоставКодаМаркировки.EAN;
		Если EANШтрихкод[EAN] = Неопределено Тогда
			EANШтрихкод[EAN] = Новый Массив;
			СписокEAN.Добавить(EAN);
			СписокGTIN.Добавить(ДанныеРазбора.СоставКодаМаркировки.GTIN);
		КонецЕсли;
		EANШтрихкод[EAN].Добавить(Штрихкод);
	КонецЦикла;
	
	Если СписокEAN.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеПоШтрихкодамEAN = ШтрихкодированиеИС.ДанныеПоШтрихкодамEAN(СписокEAN);
	Для Каждого СтрокаТЧ Из ДанныеПоШтрихкодамEAN Цикл
		Если СтрокаТЧ.ВидПродукции <> ВидПродукции Тогда
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаТЧ.ВидУпаковкиИС) Тогда
			ВидУпаковки = СтрокаТЧ.ВидУпаковкиИС;
		Иначе
			Продолжить;
		КонецЕсли;
		Для Каждого Штрихкод Из EANШтрихкод[СтрокаТЧ.ШтрихкодEAN] Цикл
			ДанныеРазбораШтрихкода[Штрихкод].ВидУпаковки         = ВидУпаковки;
			КешДанныхРазбора[Штрихкод].ДанныеРазбора.ВидУпаковки = ВидУпаковки;
		КонецЦикла;
		ИндексЭлемента = СписокEAN.Найти(СтрокаТЧ.ШтрихкодEAN);
		СписокEAN.Удалить(ИндексЭлемента);
		СписокGTIN.Удалить(ИндексЭлемента);
	КонецЦикла;
	
	Если СписокEAN.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеПоGTIN = РегистрыСведений.ОписаниеGTINИС.ПолучитьОписание(СписокGTIN);
	НеизвестныхДанныхПоGTIN = СписокGTIN.Количество();
	Для ИндексЭлемента = 0 По СписокGTIN.ВГраница() Цикл
		GTIN         = СписокGTIN[ИндексЭлемента];
		ОписаниеGTIN = ДанныеПоGTIN[GTIN];
		Если ОписаниеGTIN = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ВидУпаковки = ОписаниеGTIN.ВидУпаковки;
		EAN         = СписокEAN[ИндексЭлемента];
		Для Каждого Штрихкод Из EANШтрихкод[EAN] Цикл
			ДанныеРазбораШтрихкода[Штрихкод].ВидУпаковки         = ВидУпаковки;
			КешДанныхРазбора[Штрихкод].ДанныеРазбора.ВидУпаковки = ВидУпаковки;
		КонецЦикла;
		НеизвестныхДанныхПоGTIN = НеизвестныхДанныхПоGTIN - 1;
	КонецЦикла;
	
	ШаблоныГрупповыхУпаковокИНаборов = Новый Соответствие;
	Для Каждого Шаблон Из ИнтеграцияИСМПКлиентСервер.ШаблоныГрупповыхУпаковок() Цикл
		ШаблоныГрупповыхУпаковокИНаборов.Вставить(Шаблон, Перечисления.ВидыУпаковокИС.Групповая);
	КонецЦикла;
	Для Каждого Шаблон Из ИнтеграцияИСМПКлиентСервер.ШаблоныНаборов() Цикл
		ШаблоныГрупповыхУпаковокИНаборов.Вставить(Шаблон, Перечисления.ВидыУпаковокИС.Набор);
	КонецЦикла;
	
	Если НеизвестныхДанныхПоGTIN > 0 Тогда 
		
		ДанныеПулаПоКодамМаркировки = РегистрыСведений.ПулКодовМаркировкиСУЗ.ДанныеКодовМаркировки(Штрихкоды);
		
		Для Каждого СтрокаПула Из ДанныеПулаПоКодамМаркировки Цикл
			
			Если СтрокаПула.СохраненоПриСканировании Тогда
				Продолжить;
			КонецЕсли;
			
			Штрихкод = СтрокаПула.КодМаркировки;
			
			ВидУпаковкиПоШаблону = ШаблоныГрупповыхУпаковокИНаборов[СтрокаПула.Шаблон];
			Если ЗначениеЗаполнено(ВидУпаковкиПоШаблону) Тогда
				ВидУпаковки = ВидУпаковкиПоШаблону;
			Иначе
				ВидУпаковки = Перечисления.ВидыУпаковокИС.Потребительская;
			КонецЕсли;
			
			ДанныеРазбораШтрихкода[Штрихкод].ВидУпаковки         = ВидУпаковки;
			КешДанныхРазбора[Штрихкод].ДанныеРазбора.ВидУпаковки = ВидУпаковки;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти