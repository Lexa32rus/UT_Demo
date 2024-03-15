#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
		
		Параметры.НезависимыеРегистры.Добавить(Метаданные.РегистрыСведений.СчетаФактурыПоставщиковКПеревыставлениюКомитентам);
		
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

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

// Процедура формирования движений по регистру.
//
// Параметры:
//	ТаблицыДляДвижений - Структура - таблицы данных документа
//	Документ - ДокументСсылка - ссылка на документ
//	МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - менеджер временных таблиц документа
//	Отказ - Булево - признак отказа от проведения документа.
//
Процедура ЗаписатьДанные(ТаблицыДляДвижений, Документ, МенеджерВременныхТаблиц, Отказ) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = РегистрыСведений.СчетаФактурыПоставщиковКПеревыставлениюКомитентам.СоздатьНаборЗаписей();
	Набор.Отбор.ОтчетКомитентуОЗакупках.Установить(Документ);
	Набор.Загрузить(ТаблицыДляДвижений.ТаблицаСчетаФактурыПоставщиковКПеревыставлениюКомитентам);
	Набор.Записать();
	
	ОбновлениеИнформационнойБазыУТ.ОтметитьВыполнениеОбработкиИнтерактивно(Набор);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Записывает в регистр данные по переданному разделителю записи.
//
// Параметры:
//  ТаблицыДляДвижений		 - Структура - содержит по ключу ТаблицыДляДвижений структуру
//  	имеющую ключ ТаблицаРеестрДокументов (ТаблицаЗначений)
//  РазделительЗаписи		 - ОпределяемыйТип.РазделительЗаписиРеестраДокументов - измерение, по которому необходимо выполнить запись
//  ЗамещатьЗаписи			 - Булево - определяет режим замещения существующих записей разделителя. Истина - перед записью существующие
//		записи будут удалены. Ложь - записи будут дописаны к уже существующим в информационной базе записям.
//
Процедура ЗаписатьДанныеРазделителя(ТаблицыДляДвижений, РазделительЗаписи, ЗамещатьЗаписи = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = РегистрыСведений.СчетаФактурыПоставщиковКПеревыставлениюКомитентам.СоздатьНаборЗаписей();
	Набор.Отбор.РазделительЗаписи.Установить(РазделительЗаписи);
	Набор.Загрузить(ТаблицыДляДвижений.ТаблицаСчетаФактурыПоставщиковКПеревыставлениюКомитентам);
	Набор.Записать(ЗамещатьЗаписи);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

// Переформировывает распоряжения на регистрацию счетов-фактур от комитентов.
//
// Параметры:
//	 МассивДокументовОснований - Массив, содержащий ссылки на документы, по которым необходимо обновить записи регистра
//   ОтменяемыйДокумент - Ссылка на документ видов: ДокументСсылка.ОтчетКомитентуОЗакупках, ДокументСсылка.СчетФактураВыданный (Необязательный)
//
Процедура ОбновитьСостояние(МассивДокументовОснований, ОтменяемыйДокумент = Неопределено) Экспорт
	
	ОтменяемыйОтчет = Документы.ОтчетКомитентуОЗакупках.ПустаяСсылка();
	ОтменяемыйСФ = Документы.СчетФактураВыданный.ПустаяСсылка();
	
	Если ТипЗнч(ОтменяемыйДокумент) = Тип("ДокументСсылка.ОтчетКомитентуОЗакупках") Тогда
		ОтменяемыйОтчет = ОтменяемыйДокумент;
	ИначеЕсли ТипЗнч(ОтменяемыйДокумент) = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
		ОтменяемыйСФ = ОтменяемыйДокумент;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(МассивДокументовОснований, Неопределено);
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(МассивДокументовОснований, Документы.ОтчетКомитентуОЗакупках.ПустаяСсылка());
	
	МассивДокументовОснований = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивДокументовОснований);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.СчетФактураПолученный КАК СчетФактураПолученный,
	|	ВложенныйЗапрос.ОтчетКомитентуОЗакупках КАК ОтчетКомитентуОЗакупках,
	|	ВложенныйЗапрос.Комитент КАК Комитент,
	|	СУММА(ВложенныйЗапрос.Сумма) КАК СуммаСНДС,
	|	СУММА(ВложенныйЗапрос.СуммаНДС) КАК СуммаНДС,
	|	ВложенныйЗапрос.Валюта КАК Валюта,
	|	ВложенныйЗапрос.Организация КАК Организация,
	|	ВложенныйЗапрос.Поставщик КАК Поставщик,
	|	ВложенныйЗапрос.ДатаСчетаФактуры КАК ДатаСчетаФактуры,
	|	ВложенныйЗапрос.НомерСчетаФактуры КАК НомерСчетаФактуры
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОтчетКомитентуОЗакупкахТовары.СчетФактураПолученный КАК СчетФактураПолученный,
	|		ОтчетКомитентуОЗакупкахТовары.Ссылка КАК ОтчетКомитентуОЗакупках,
	|		ОтчетКомитентуОЗакупкахТовары.Ссылка.Контрагент КАК Комитент,
	|		ОтчетКомитентуОЗакупкахТовары.СуммаСНДС КАК Сумма,
	|		ОтчетКомитентуОЗакупкахТовары.СуммаНДС КАК СуммаНДС,
	|		ОтчетКомитентуОЗакупкахТовары.Количество КАК Количество,
	|		ОтчетКомитентуОЗакупкахТовары.ДокументПриобретения.Валюта КАК Валюта,
	|		ОтчетКомитентуОЗакупкахТовары.ДокументПриобретения.Организация КАК Организация,
	|		ОтчетКомитентуОЗакупкахТовары.ДокументПриобретения.Контрагент КАК Поставщик,
	|		ОтчетКомитентуОЗакупкахТовары.Номенклатура КАК Номенклатура,
	|		ОтчетКомитентуОЗакупкахТовары.Характеристика КАК Характеристика,
	|		ОтчетКомитентуОЗакупкахТовары.НомерГТД КАК НомерГТД,
	|		ОтчетКомитентуОЗакупкахТовары.СтавкаНДС КАК СтавкаНДС,
	|		ОтчетКомитентуОЗакупкахТовары.СчетФактураПолученный.ДатаСоставления КАК ДатаСчетаФактуры,
	|		ОтчетКомитентуОЗакупкахТовары.СчетФактураПолученный.Номер КАК НомерСчетаФактуры
	|	ИЗ
	|		Документ.ОтчетКомитентуОЗакупках.Товары КАК ОтчетКомитентуОЗакупкахТовары
	|	ГДЕ
	|		ОтчетКомитентуОЗакупкахТовары.Ссылка В(&СписокДокументовОснований)
	|		И НЕ ОтчетКомитентуОЗакупкахТовары.СчетФактураПолученный = ЗНАЧЕНИЕ(Документ.СчетФактураПолученный.ПустаяСсылка)
	|		И ОтчетКомитентуОЗакупкахТовары.Ссылка.Проведен
	|		И НЕ ОтчетКомитентуОЗакупкахТовары.Ссылка = &ОтменяемыйОтчет
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		СчетФактураВыданныйТовары.СчетФактураПолученныйОтПродавца,
	|		СчетФактураВыданныйДокументыОснования.ДокументОснование,
	|		СчетФактураВыданныйТовары.Ссылка.Контрагент,
	|		ВЫБОР
	|			КОГДА СчетФактураВыданныйТовары.Ссылка.Корректировочный
	|				ТОГДА СчетФактураВыданныйТовары.СуммаУменьшение - СчетФактураВыданныйТовары.СуммаУвеличение
	|			ИНАЧЕ -СчетФактураВыданныйТовары.Сумма
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА СчетФактураВыданныйТовары.Ссылка.Корректировочный
	|				ТОГДА СчетФактураВыданныйТовары.СуммаНДСУменьшение - СчетФактураВыданныйТовары.СуммаНДСУвеличение
	|			ИНАЧЕ -СчетФактураВыданныйТовары.СуммаНДС
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА СчетФактураВыданныйТовары.Ссылка.Корректировочный
	|				ТОГДА СчетФактураВыданныйТовары.КоличествоУменьшение - СчетФактураВыданныйТовары.КоличествоУвеличение
	|			ИНАЧЕ -СчетФактураВыданныйТовары.Количество
	|		КОНЕЦ,
	|		СчетФактураВыданныйТовары.Ссылка.Валюта,
	|		СчетФактураВыданныйТовары.Ссылка.Организация,
	|		СчетФактураВыданныйТовары.СчетФактураПолученныйОтПродавца.Контрагент,
	|		СчетФактураВыданныйТовары.Номенклатура,
	|		СчетФактураВыданныйТовары.Характеристика,
	|		СчетФактураВыданныйТовары.НомерГТД,
	|		СчетФактураВыданныйТовары.СтавкаНДС,
	|		СчетФактураВыданныйТовары.СчетФактураПолученныйОтПродавца.ДатаСоставления,
	|		СчетФактураВыданныйТовары.СчетФактураПолученныйОтПродавца.Номер
	|	ИЗ
	|		Документ.СчетФактураВыданный.Товары КАК СчетФактураВыданныйТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный.ДокументыОснования КАК СчетФактураВыданныйДокументыОснования
	|			ПО (СчетФактураВыданныйДокументыОснования.Ссылка = СчетФактураВыданныйТовары.Ссылка)
	|				И (СчетФактураВыданныйДокументыОснования.ДокументОснование В (&СписокДокументовОснований))
	|	ГДЕ
	|		СчетФактураВыданныйТовары.Ссылка.Проведен
	|		И НЕ СчетФактураВыданныйТовары.Ссылка = &СсылкаСФ) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.СчетФактураПолученный,
	|	ВложенныйЗапрос.ОтчетКомитентуОЗакупках,
	|	ВложенныйЗапрос.Комитент,
	|	ВложенныйЗапрос.Валюта,
	|	ВложенныйЗапрос.Организация,
	|	ВложенныйЗапрос.Поставщик,
	|	ВложенныйЗапрос.ДатаСчетаФактуры,
	|	ВложенныйЗапрос.НомерСчетаФактуры
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ВложенныйЗапрос.Сумма) <> 0
	|		ИЛИ СУММА(ВложенныйЗапрос.СуммаНДС) <> 0)";
	
	Запрос.УстановитьПараметр("СписокДокументовОснований", МассивДокументовОснований);
	Запрос.УстановитьПараметр("СсылкаСФ", ОтменяемыйСФ);
	Запрос.УстановитьПараметр("ОтменяемыйОтчет", ОтменяемыйОтчет);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Документ.ОтчетКомитентуОЗакупках");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	ТаблицаКлючейБлокировки = Новый ТаблицаЗначений;
	ТаблицаКлючейБлокировки.ЗагрузитьКолонку(МассивДокументовОснований, ТаблицаКлючейБлокировки.Колонки.Добавить("КлючБлокировки"));
	ЭлементБлокировки.ИсточникДанных = ТаблицаКлючейБлокировки;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "КлючБлокировки");
	
	
	ЗапросКлючейБлокировки = Новый Запрос();
	ЗапросКлючейБлокировки.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СчетФактураВыданныйДокументыОснования.Ссылка КАК КлючБлокировки
	|ИЗ
	|	Документ.СчетФактураВыданный.ДокументыОснования КАК СчетФактураВыданныйДокументыОснования
	|ГДЕ
	|	СчетФактураВыданныйДокументыОснования.ДокументОснование В(&СписокДокументовОснований)";
	ЗапросКлючейБлокировки.УстановитьПараметр("СписокДокументовОснований", МассивДокументовОснований); 
	
	ЭлементБлокировки = Блокировка.Добавить("Документ.СчетФактураВыданный");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки.ИсточникДанных = ЗапросКлючейБлокировки.Выполнить();
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "КлючБлокировки");
	
	Блокировка.Заблокировать();
	
	СчетаФактурыПоставщиковКРегистрации = Запрос.Выполнить().Выгрузить();
	СчетаФактурыПоставщиковКРегистрации.Индексы.Добавить("ОтчетКомитентуОЗакупках");
	
	Для каждого ДокументОснование Из МассивДокументовОснований Цикл
		
		НаборЗаписей = РегистрыСведений.СчетаФактурыПоставщиковКПеревыставлениюКомитентам.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ОтчетКомитентуОЗакупках.Установить(ДокументОснование);
		
		Отбор = Новый Структура("ОтчетКомитентуОЗакупках", ДокументОснование);
		Строки = СчетаФактурыПоставщиковКРегистрации.НайтиСтроки(Отбор);
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СчетаФактурыПоставщиковКПеревыставлениюКомитентам");
		ЭлементБлокировки.УстановитьЗначение("ОтчетКомитентуОЗакупках",	ДокументОснование);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Для каждого Строка Из Строки Цикл
			НоваяЗапись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, Строка);
		КонецЦикла;
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(СчетФактураПолученный.Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли