#Область СлужебныйПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#Область ОбновлениеКонфигурации

// См. ЭлектронноеВзаимодействие.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	ЭлектронныеДокументыЭДО.ПриДобавленииОбработчиковОбновления(Обработчики);
	ИнтеграцияЭДО.ПриДобавленииОбработчиковОбновления(Обработчики);
	НастройкиЭДОСобытия.ПриДобавленииОбработчиковОбновления(Обработчики);
	СинхронизацияЭДОСобытия.ПриДобавленииОбработчиковОбновления(Обработчики);
	ПриглашенияЭДО.ПриДобавленииОбработчиковОбновления(Обработчики);
	СервисНастроекЭДО.ПриДобавленииОбработчиковОбновления(Обработчики);
	НастройкиВнутреннегоЭДО.ПриДобавленииОбработчиковОбновления(Обработчики);
	МашиночитаемыеДоверенности.ПриДобавленииОбработчиковОбновления(Обработчики);
	ИнтерфейсДокументовЭДО.ПриДобавленииОбработчиковОбновления(Обработчики);
	
КонецПроцедуры

// См. ЭлектронноеВзаимодействие.ПриДобавленииПереименованийОбъектовМетаданных.
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	МашиночитаемыеДоверенности.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	
КонецПроцедуры

#КонецОбласти

#Область ПоставляемыеДанные

// См. ПоставляемыеДанныеПереопределяемый.ПолучитьОбработчикиПоставляемыхДанных 
Процедура ПриРегистрацииОбработчиковПоставляемыхДанных(Обработчики) Экспорт
	
	ЭлектронныеДокументыЭДО.ПриРегистрацииОбработчиковПоставляемыхДанных(Обработчики);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаНеисправностей

// ЭлектронноеВзаимодействие.БазоваяФункциональность.ОбработкаНеисправностей

// См. ОбработкаНеисправностейБЭДСобытия.ПриИнициализацииКонтекстаДиагностики
Процедура ПриИнициализацииКонтекстаДиагностики(КонтекстДиагностики) Экспорт
	
	ОбменСКонтрагентамиИнтеграцияКлиентСерверСобытия.ПриИнициализацииКонтекстаДиагностики(КонтекстДиагностики);
	
КонецПроцедуры

// См. ОбработкаНеисправностейБЭДСобытия.ПриИнициализацииОшибки
Процедура ПриИнициализацииОшибки(Ошибка) Экспорт
	
	ОбменСКонтрагентамиИнтеграцияКлиентСерверСобытия.ПриИнициализацииОшибки(Ошибка);
	
КонецПроцедуры

// См. ОбработкаНеисправностейБЭДСобытия.ПриДобавленииОшибки
Процедура ПриДобавленииОшибки(КонтекстДиагностики, Ошибка) Экспорт
	
	ОбменСКонтрагентамиИнтеграцияКлиентСерверСобытия.ПриДобавленииОшибки(КонтекстДиагностики, Ошибка);
	
КонецПроцедуры

// См. ОбработкаНеисправностейБЭДСобытия.ПриФормированииФайлаСИнформациейДляТехподдержки
Процедура ПриФормированииФайлаСИнформациейДляТехподдержки(Текст, ТехническаяИнформация) Экспорт
	
	ДиагностикаЭДО.ПриФормированииФайлаСИнформациейДляТехподдержки(Текст, ТехническаяИнформация);
	
КонецПроцедуры

// См. ОбработкаНеисправностейБЭДСобытия.ПриФормированииФайловДляТехподдержки
Процедура ПриФормированииФайловДляТехподдержки(ФайлыДляТехподдержки, КонтекстДиагностики) Экспорт
	
	ДиагностикаЭДО.ПриФормированииФайловДляТехподдержки(ФайлыДляТехподдержки, КонтекстДиагностики);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.БазоваяФункциональность.ОбработкаНеисправностей

#КонецОбласти

#Область УправлениеПечатью

// см. УправлениеПечатьюПереопределяемый.ПриПечати
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ИнтерфейсДокументовЭДО.ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры

// см. УправлениеПечатьюПереопределяемый.ПечатьДокументовПриСозданииНаСервере
Процедура ПечатьДокументовПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт

	ИнтерфейсДокументовЭДО.ПечатьДокументовПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

// Формирование текстового представления рекламы по ЭДО.
//
// Параметры:
//  ДополнительнаяИнформация - Структура - с полями:
//   * Картинка - Картинка - картинка из библиотеки картинок;
//   * Текст - Строка - форматированный текст надписи с навигационными ссылками.
//  МассивСсылок - Массив - список ссылок на объекты.
//
// Возвращаемое значение:
//  Строка - возврат строки рекламы.
//
Процедура ПриВыводеНавигационнойСсылкиВФормеОбъектаИБ(ДополнительнаяИнформация, МассивСсылок) Экспорт
	
	ИнтеграцияЭДО.ПриВыводеНавигационнойСсылкиВФормеОбъектаИБ(ДополнительнаяИнформация, МассивСсылок);
	
КонецПроцедуры

#КонецОбласти

#Область Тарификация

// См. ТарификацияПереопределяемый.ПриФормированииСпискаУслуг
Процедура ПриФормированииСпискаУслуг(ПоставщикиУслуг) Экспорт
	
	ПоставщикПортал1СИТС = Неопределено;
	ИдентификаторПоставщикаУслугПортал1СИТС =
		ИнтеграцияБИПБЭДКлиентСервер.ИдентификаторПоставщикаУслугПортал1СИТС();
	Для Каждого ТекПоставщик Из ПоставщикиУслуг Цикл
		Если ТекПоставщик.Идентификатор = ИдентификаторПоставщикаУслугПортал1СИТС Тогда
			ПоставщикПортал1СИТС = ТекПоставщик;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПоставщикПортал1СИТС = Неопределено Тогда
		ПоставщикПортал1СИТС = Новый Структура;
		ПоставщикПортал1СИТС.Вставить("Идентификатор", ИдентификаторПоставщикаУслугПортал1СИТС);
		ПоставщикПортал1СИТС.Вставить("Наименование" , НСтр("ru = 'Портал 1С:ИТС'"));
		ПоставщикПортал1СИТС.Вставить("Услуги"       , Новый Массив);
		ПоставщикиУслуг.Добавить(ПоставщикПортал1СИТС);
	КонецЕсли;
	
	Услуги = ПоставщикПортал1СИТС.Услуги;
	
	// Оператор [] используется для исключения ошибки компиляции,
	// если не внедрена Библиотека "Технология сервиса".
	ТипУслугиБезлимитная = Перечисления["ТипыУслуг"]["Безлимитная"];
	
	НоваяУслуга = Новый Структура;
	НоваяУслуга.Вставить("Идентификатор", ИнтеграцияБИПБЭДКлиентСервер.ИдентификаторУслугиОбменаЭлектроннымиДокументами());
	НоваяУслуга.Вставить("Наименование" , НСтр("ru = 'Обмен электронными документами'"));
	НоваяУслуга.Вставить("ТипУслуги"    , ТипУслугиБезлимитная);
	Услуги.Добавить(НоваяУслуга);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступом

// См. ЭлектронноеВзаимодействие.ПриЗаполненииСписковСОграничениемДоступа
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	СинхронизацияЭДО.ПриЗаполненииСписковСОграничениемДоступа(Списки);
	ЭлектронныеДокументыЭДО.ПриЗаполненииСписковСОграничениемДоступа(Списки);
	НастройкиЭДО.ПриЗаполненииСписковСОграничениемДоступа(Списки);
	ИнтеграцияЭДО.ПриЗаполненииСписковСОграничениемДоступа(Списки);
	ИнтерфейсДокументовЭДО.ПриЗаполненииСписковСОграничениемДоступа(Списки);
	
КонецПроцедуры

// См. ЭлектронноеВзаимодействие.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	СинхронизацияЭДО.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание);
	ЭлектронныеДокументыЭДО.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание);
	НастройкиЭДО.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание);
	ИнтеграцияЭДО.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание);
	ИнтерфейсДокументовЭДО.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание);
	
КонецПроцедуры

#КонецОбласти

#Область ПрофилиБезопасности

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам
//
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	СинхронизацияЭДО.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений);
	
КонецПроцедуры

#КонецОбласти

#Область РегламентныеЗадания

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	СинхронизацияЭДО.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
		
КонецПроцедуры

#КонецОбласти

#Область ОчередьЗаданий

// См. ОчередьЗаданийПереопределяемый.ПриПолученииСпискаШаблонов 
Процедура ПриПолученииСпискаШаблонов(ШаблоныЗаданий) Экспорт
	
	СинхронизацияЭДО.ПриПолученииСпискаШаблонов(ШаблоныЗаданий);
	
КонецПроцедуры

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СинхронизацияЭДО.ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам);
	
КонецПроцедуры

#КонецОбласти

#Область ПрисоединенныеФайлы

// См. РаботаСФайламиПереопределяемый.ПриОпределенииНастроек.
//
Процедура ПриОпределенииНастроекФайлов(Настройки) Экспорт
	
	ЭлектронныеДокументыЭДО.ПриОпределенииНастроекФайлов(Настройки);

КонецПроцедуры

#КонецОбласти

#Область ЭлектронныеДокументы

Процедура ПриЗагрузкеНовогоДокументооборота(Документооборот, СостояниеЭДО, КонтекстДиагностики) Экспорт
	
	ЕстьКоммерческиеПредложения = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.КоммерческиеПредложения");
	
	Если ЕстьКоммерческиеПредложения Тогда
		МодульКоммерческиеПредложенияСлужебный = ОбщегоНазначения.ОбщийМодуль("КоммерческиеПредложенияСлужебный");
		МодульКоммерческиеПредложенияСлужебный.ПриЗагрузкеНовогоЭлектронногоДокумента(Документооборот,
			СостояниеЭДО, КонтекстДиагностики);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти