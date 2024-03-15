#Область ПрограммныйИнтерфейс

//Выделяет из переданного массива штрихкодов упаковок элементы, в составе которых (на любом уровне вложенности, 
//   в т.ч. частично) находится продукция требуемого вида.
//
//Параметры:
//   ШтрихкодыДляПроверки - Массив - проверяемые элементы типа СправочникСсылка.ШтрихкодыУпаковокТоваров.
//   ВидыПродукции - Массив, ПеречислениеСсылка.ВидыПродукцииИС, Неопределено - Вид отбираемой продукции.
Процедура ВыделитьШтрихкодыСодержащиеВидыПродукции(ШтрихкодыУпаковок, ВидыПродукцииИС) Экспорт
	
	//++ НЕ ГОСИС
	ШтрихкодыУпаковок = ИнтеграцияИСУТ.ШтрихкодыСодержащиеВидыПродукции(ШтрихкодыУпаковок, ВидыПродукцииИС);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Заполняет соответствие штрихкодов данными: Номенклатура, Храктеристика, МаркируемаяПродукция, Коэффициент.
// 
// Параметры:
//  Штрихкоды            - Соответствие - Список штрихкодов.
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке.
Процедура ЗаполнитьИнформациюПоШтрихкодам(Штрихкоды, КэшированныеЗначения) Экспорт
	
	//++ НЕ ГОСИС
	СписокШтрихкодов = Новый Массив;
	Для Каждого КлючЗначение Из Штрихкоды Цикл
		СписокШтрихкодов.Добавить(КлючЗначение.Ключ);
	КонецЦикла;
	
	Если КэшированныеЗначения = Неопределено Тогда
		КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	КонецЕсли;
	
	РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьДанныеПоШтрихкодам(КэшированныеЗначения, СписокШтрихкодов);
	
	Для Каждого КлючЗначение Из КэшированныеЗначения.Штрихкоды Цикл
		Если Штрихкоды[КлючЗначение.Ключ] <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Штрихкоды[КлючЗначение.Ключ], КлючЗначение.Значение);
		КонецЕсли;
	КонецЦикла;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

//В процедуре нужно реализовать подготовку данных для дальнейшей обработки штрихкодов.
//
//Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма документа, в которой происходит обработка,
//   ДанныеШтрихкодов - Массив - полученные штрихкоды,
//   ПараметрыЗаполнения - (см. ИнтеграцияИС.ПараметрыЗаполненияТабличнойЧастиТовары).
//   СтруктураДействий - Структура - подготовленные данные.
//
Процедура ПодготовитьДанныеДляОбработкиШтрихкодов(Форма, ДанныеШтрихкодов, ПараметрыЗаполнения, СтруктураДействий) Экспорт
	
	//++ НЕ ГОСИС
	
	СтруктураДействийСДобавленнымиСтроками = Новый Структура;
	СтруктураДействийСИзмененнымиСтроками  = Новый Структура;
	
	Если ПараметрыЗаполнения.ЗаполнитьКодТНВЭД Тогда
		СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьКодТНВЭД");
	КонецЕсли;
		
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц Тогда
		
		СтруктураДействийСДобавленнымиСтроками.Вставить("ПересчитатьКоличествоЕдиниц");
		СтруктураДействийСИзмененнымиСтроками.Вставить("ПересчитатьКоличествоЕдиниц");
		
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		
		СтруктураДействийСДобавленнымиСтроками.Вставить("ПересчитатьСумму");
		СтруктураДействийСИзмененнымиСтроками.Вставить("ПересчитатьСумму");
		
	КонецЕсли;
	
	СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьПризнакЕдиницаИзмерения",
		Новый Структура("Номенклатура", "ЕдиницаИзмерения"));
	
	Если ШтрихкодированиеИС.ПрисутствуетАлкогольнаяПродукция(ПараметрыЗаполнения.ВидыПродукцииИС) Тогда
		
		ПараметрыЗаполненияНоменклатурыЕГАИС = Новый Структура;
		ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ЗаполнитьФлагАлкогольнаяПродукция", Ложь);
		ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ИмяКолонки", "АлкогольнаяПродукция");
		СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьНоменклатуруЕГАИС", ПараметрыЗаполненияНоменклатурыЕГАИС);
		
		Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
			СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьИндексАкцизнойМарки");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ШтрихкодированиеИС.ПрисутствуетПродукцияИСМП(ПараметрыЗаполнения.ВидыПродукцииИС)
		Или ШтрихкодированиеИС.ПрисутствуетТабачнаяПродукция(ПараметрыЗаполнения.ВидыПродукцииИС) Тогда
		
		Если ПараметрыЗаполнения.ЗаполнитьGTIN Тогда
			СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьGTINВСтроке",
			
			Новый Структура("ДобавлятьЛидирующиеНули", Истина));
		КонецЕсли;
		
	КонецЕсли;
	
	СтруктураДействий = ШтрихкодированиеНоменклатурыКлиентСервер.ПараметрыОбработкиШтрихкодов();
	
	СтруктураДействий.Штрихкоды                              = ДанныеШтрихкодов;
	СтруктураДействий.СтруктураДействийСДобавленнымиСтроками = СтруктураДействийСДобавленнымиСтроками;
	СтруктураДействий.СтруктураДействийСИзмененнымиСтроками  = СтруктураДействийСИзмененнымиСтроками;
	СтруктураДействий.ТолькоТовары                           = Истина;
	СтруктураДействий.ШтрихкодыВТЧ                           = ПараметрыЗаполнения.ШтрихкодыВТЧ;
	СтруктураДействий.МаркируемаяПродукцияВТЧ                = ПараметрыЗаполнения.МаркируемаяПродукцияВТЧ;
	
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// В процедуре нужно реализовать обработку штрихкодов.
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма для которой будут обработаны введенные штрихкоды.
//   ДанныеДляОбработки - Структура - структура параметров обработки штрихкодов.
//                                    и заполняется данными из формы.
//   КэшированныеЗначения - Структура - кэш формы.
Процедура ОбработатьШтрихкоды(Форма, ДанныеДляОбработки, КэшированныеЗначения) Экспорт
	
	//++ НЕ ГОСИС
	ШтрихкодированиеНоменклатурыСервер.ОбработатьШтрихкоды(Форма, Форма.Объект, ДанныеДляОбработки, КэшированныеЗначения);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// В процедуре требуется реализовать алгоритм обработки полученных штрихкодов из ТСД.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа, в которой происходит обработка,
//  ДанныеДляОбработки - Структура - подготовленные ранее данные для обработки,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
Процедура ОбработатьДанныеИзТСД(Форма, ДанныеДляОбработки, КэшированныеЗначения) Экспорт
	
	//++ НЕ ГОСИС
	ШтрихкодированиеНоменклатурыСервер.ОбработатьШтрихкоды(
		Форма, Форма.Объект,
		ДанныеДляОбработки, КэшированныеЗначения);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// В процедуре необходимо реализовать заполнение таблицы ДанныеПоEAN на основании заполненной колонки ШтрихкодEAN.
//   Ожидаемое поведение:
//    Если для строки информации по штрихкоду выставляется флаг "ТребуетсяОбработкаШтрихкода", строка информации должна
//    быть уникальной для этого штрихкода.
//
// Параметры:
//  ДанныеПоШтрихкодамEAN - ТаблицаЗначений - передается с обязательной колонкой ШтрихкодEAN, возвращает:
//   * Номенклатура - ОпределяемыйТип.Номенклатура - Номенклатура.
//   * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - Характеристика.
//   * Серия - ОпределяемыйТип.СерияНоменклатуры - Серия.
//   * Упаковка - ОпределяемыйТип.Упаковка - Упаковка.
//   * ШтрихкодEAN - Строка - Штрихкод.
//   * ПредставлениеНоменклатуры - Строка - Представление номенклатуры.
//   * ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции ИС.
//   * ВидУпаковкиИС - ПеречислениеСсылка.ВидыУпаковокИС - вид упаковки (из коэффициента регистра ОписаниеGTINИС)
//   * МаркируемаяПродукция - Булево - Истина, если продукция является маркируемой.
//   * Количество - Число - количество товара в весовом штрихкоде EAN или коэффициенте упаковки
//   * ТребуетсяОбработкаШтрихкода - Булево - Истина если штрихкод не следует обрабатывать библиотекой
//   * ДанныеШтрихкода - Структура,Неопределено - Результат получения данных по штрихкоду (для обработки вне библиотеки)
//
Процедура ПриЗаполненииИнформацииПоШтрихкодамEAN(ДанныеПоШтрихкодамEAN) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияИСУТ.ЗаполнитьДанныеПоШтрихкодамEAN(ДанныеПоШтрихкодамEAN);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// В процедуре необходимо реализовать заполнение таблицы "ОстаткиМаркируемойПродукции" (по данным информационной базы).
//   На основании данных таблицы будет происходить контроль остатков, если в параметрах сканирования свойство
//   "ОперацияКонтроляАкцизныхМарок" будет заполнено значением "Продажа" или "Возврат", а прочий контроль выключен
//     (сейчас это продажа продукции ИС МП с выключенным контролем статусов).
// Первая операция контролю не подлежит (ранее не участвовавший в товародвижении КМ можно и продать, и вернуть).
// Отсутствие переопределения соответствует отсутствию контроля.
// 
// Параметры:
//  ОстаткиМаркируемойПродукции - См. ШтрихкодированиеИС.ИнициализацияТаблицыПроверкиОстатков.
//  ПараметрыСканирования - См. ШтрихкодированиеИС.ПараметрыСканирования.
Процедура ПриОпределенииОстатковМаркируемойПродукции(ОстаткиМаркируемойПродукции, ПараметрыСканирования) Экспорт
	
	//++ НЕ ГОСИС
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаркируемаяПродукция.ШтрихкодУпаковки КАК ШтрихкодУпаковки,
	|	МаркируемаяПродукция.Доступно         КАК Доступно
	|ПОМЕСТИТЬ ВТМаркируемаяПродукция
	|ИЗ
	|	&МаркируемаяПродукция КАК МаркируемаяПродукция
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ШтрихкодУпаковки
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЧекККМАкцизныеМарки.АкцизнаяМарка КАК ШтрихкодУпаковки,
	|	-1                                КАК Доступно
	|ПОМЕСТИТЬ ДанныеДокументов
	|ИЗ
	|	ВТМаркируемаяПродукция КАК ВТМаркируемаяПродукция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекККМ.АкцизныеМарки КАК ЧекККМАкцизныеМарки
	|		ПО ВТМаркируемаяПродукция.ШтрихкодУпаковки = ЧекККМАкцизныеМарки.АкцизнаяМарка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах
	|		ПО ОтчетОРозничныхПродажах.КассоваяСмена = ЧекККМАкцизныеМарки.Ссылка.КассоваяСмена
	|ГДЕ
	|	ЧекККМАкцизныеМарки.Ссылка.Организация = &Организация
	|	И ЧекККМАкцизныеМарки.Ссылка.Проведен
	|	И ЧекККМАкцизныеМарки.Ссылка <> &ЭтаСсылка
	|	И ЧекККМАкцизныеМарки.АкцизнаяМарка <> ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка)
	|	И ОтчетОРозничныхПродажах.Ссылка ЕСТЬ NULL
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОтчетОРозничныхПродажахАкцизныеМарки.АкцизнаяМарка,
	|	-1
	|ИЗ
	|	ВТМаркируемаяПродукция КАК ВТМаркируемаяПродукция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетОРозничныхПродажах.АкцизныеМарки КАК ОтчетОРозничныхПродажахАкцизныеМарки
	|		ПО ВТМаркируемаяПродукция.ШтрихкодУпаковки = ОтчетОРозничныхПродажахАкцизныеМарки.АкцизнаяМарка
	|ГДЕ
	|	ОтчетОРозничныхПродажахАкцизныеМарки.Ссылка.Организация = &Организация
	|	И ОтчетОРозничныхПродажахАкцизныеМарки.Ссылка.Проведен
	|	И ОтчетОРозничныхПродажахАкцизныеМарки.АкцизнаяМарка <> ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВозвратТоваровОтКлиентаШтрихкодыУпаковок.ШтрихкодУпаковки,
	|	1
	|ИЗ
	|	ВТМаркируемаяПродукция КАК ВТМаркируемаяПродукция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратТоваровОтКлиента.ШтрихкодыУпаковок КАК
	|			ВозвратТоваровОтКлиентаШтрихкодыУпаковок
	|		ПО ВТМаркируемаяПродукция.ШтрихкодУпаковки = ВозвратТоваровОтКлиентаШтрихкодыУпаковок.ШтрихкодУпаковки
	|ГДЕ
	|	ВозвратТоваровОтКлиентаШтрихкодыУпаковок.Ссылка.Организация = &Организация
	|	И ВозвратТоваровОтКлиентаШтрихкодыУпаковок.Ссылка <> &ЭтаСсылка
	|	И ВозвратТоваровОтКлиентаШтрихкодыУпаковок.Ссылка.Проведен
	|	И ВозвратТоваровОтКлиентаШтрихкодыУпаковок.ШтрихкодУпаковки <> ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЧекККМВозвратАкцизныеМарки.АкцизнаяМарка,
	|	1
	|ИЗ
	|	ВТМаркируемаяПродукция КАК ВТМаркируемаяПродукция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекККМВозврат.АкцизныеМарки КАК
	|			ЧекККМВозвратАкцизныеМарки
	|		ПО ВТМаркируемаяПродукция.ШтрихкодУпаковки = ЧекККМВозвратАкцизныеМарки.АкцизнаяМарка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах
	|		ПО ОтчетОРозничныхПродажах.КассоваяСмена = ЧекККМВозвратАкцизныеМарки.Ссылка.КассоваяСмена
	|ГДЕ
	|	ЧекККМВозвратАкцизныеМарки.Ссылка.Организация = &Организация
	|	И ЧекККМВозвратАкцизныеМарки.Ссылка.Проведен
	|	И ЧекККМВозвратАкцизныеМарки.Ссылка <> &ЭтаСсылка
	|	И ЧекККМВозвратАкцизныеМарки.АкцизнаяМарка <> ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка)
	|   И ОтчетОРозничныхПродажах.Ссылка ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТМаркируемаяПродукция.ШтрихкодУпаковки,
	|	ВТМаркируемаяПродукция.Доступно
	|ИЗ
	|	ВТМаркируемаяПродукция КАК ВТМаркируемаяПродукция
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокументов.ШтрихкодУпаковки КАК ШтрихкодУпаковки,
	|	СУММА(ДанныеДокументов.Доступно)  КАК Доступно
	|ИЗ
	|	ДанныеДокументов КАК ДанныеДокументов
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокументов.ШтрихкодУпаковки";
	
	Запрос.УстановитьПараметр("Организация",          ПараметрыСканирования.Организация);
	Запрос.УстановитьПараметр("ЭтаСсылка",            ПараметрыСканирования.СсылкаНаОбъект);
	Запрос.УстановитьПараметр("МаркируемаяПродукция", ОстаткиМаркируемойПродукции);
	
	ОстаткиМаркируемойПродукции = Запрос.Выполнить().Выгрузить();
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// В процедуре необходимо реализовать заполнение колонки таблицы значений штрихкодами, соответствующми номенклатуре и характеристике.
//
// Параметры:
//  ДанныеПоШтрихкодам - ТаблицаЗначений - содержит колонки:
//   * Номенклатура   - ОпределяемыйТип.Номенклатура               - входящий.
//   * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - входящий.
//   * Штрихкод       - Строка                                     - исходящий.
//  ИмяКолонкиЗаполнения - Строка - Имя колонки таблицы значений, которую требуется заполнить значением штрихкода.
Процедура ЗаполнитьШтрихкоды(ДанныеПоШтрихкодам, ИмяКолонкиЗаполнения = "Штрихкод") Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияИСУТ.ЗаполнитьДанныеПоШтрихкодам(ДанныеПоШтрихкодам, ИмяКолонкиЗаполнения);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// В процедуре нужно реализовать заполнение массива ШтрихкодыУпаковок из данных документа.
// 
// Параметры:
//  Документ - ДокументСсылка - проверяемый документ.
//  ШтрихкодыУпаковок - Массив - Список штрихкодов.
Процедура ЗаполнитьШтрихкодыУпаковокДокумента(Документ, ШтрихкодыУпаковок) Экспорт
	
	//++ НЕ ГОСИС
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки") Тогда
		ШтрихкодыУпаковок = Документ.ШтрихкодыУпаковокФактЭДО.ВыгрузитьКолонку("ЗначениеШтрихкода");
	Иначе	
		ШтрихкодыУпаковок = Документ.ШтрихкодыУпаковок.ВыгрузитьКолонку("ЗначениеШтрихкода");
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// В процедуре нужно реализовать заполнение таблицы данных данными документа основания.
// 
// Параметры:
//  ПараметрыСканирования - См. ШтрихкодированиеИС.ПараметрыСканирования.
//  ТаблицаДанных - ТаблицаЗначений - Данные из документа основания.
Процедура СформироватьДанныеДокументаОснования(ПараметрыСканирования, ТаблицаДанных) Экспорт
	
	//++ НЕ ГОСИС
	ИнтеграцияИСУТ.СформироватьДанныеДокументаОснования(ПараметрыСканирования, ТаблицаДанных);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// В процедуре необходимо реализовать обработку данных штрихкода для общей формы. результат обработки штрихкода следует
// вернуть в параметре РезультатОбработки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Общая форма.
//  ДанныеШтрихкода - См. ШтрихкодированиеИС.ИнициализироватьДанныеШтрихкода.
//  ПараметрыСканирования - См. ШтрихкодированиеИС.ПараметрыСканирования.
//  ВложенныеШтрихкоды - (См. ШтрихкодированиеИС.ИнициализироватьДанныеШтрихкода).
//  РезультатОбработки - (См. ШтрихкодированиеИС.ИнициализироватьРезультатОбработкиШтрихкода).
Процедура ОбработатьДанныеШтрихкодаДляОбщейФормы(Форма, ДанныеШтрихкода, ПараметрыСканирования, ВложенныеШтрихкоды, РезультатОбработки) Экспорт
	
	//++ НЕ ГОСИС
	РезультатОбработки = ИнтеграцияИСУТ.ОбработатьДанныеШтрихкодаДляОбщейФормы(Форма, ДанныеШтрихкода, ПараметрыСканирования, ВложенныеШтрихкоды);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// В этой процедуре при необходимости следует реализовать дополнительные проверки на ошибки данных по штрихкодам.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма, для которой выполняется обработка штрихкодов.
//  ДанныеПоШтрихкодам - (См. ШтрихкодированиеИС.ИнициализацияДанныхПоШтрихкодам). 
//  ПараметрыСканирования - См. ШтрихкодированиеИС.ПараметрыСканирования.
//  ЕстьОшибки - Булево - Истина, если выявлена ошибка.
Процедура ПриПроверкеДанныхПоШтрихкодам(ДанныеПоШтрихкодам, ПараметрыСканирования, ЕстьОшибки) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В данной процедуре требуется переопределить текст запроса, определяющий свойства маркируемой продукции.
//   Номенклатура для запроса лежит во временной таблице с именем по-умолчанию "ДанныеШтрихкодовУпаковок" 
//   Ожидаемые колонки временной таблицы "ДанныеШтрихкодовУпаковок":
//    * Номенклатура   - ОпределяемыйТип.Номенклатура.
//    * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры.
//   Ожидаемые действия:
//   * Создание временной таблицы "СвойстваМаркируемойПродукции" с колонками:
//     ** Номенклатура         - ОпределяемыйТип.Номенклатура - из источника.
//     ** Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - из источника.
//     ** МаркируемаяПродукция - Булево - признак маркируемой продукции.
//     ** ВидПродукции         - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции.
//   * Поле "Номенклатура" желательно индексировать.
// Параметры:
//  ТекстЗапросаСвойстваМаркируемойПродукции - Строка - Переопределяемый текст запроса.
//  ТаблицаИсточник - Строка - имя временной таблицы запроса-источника данных.
Процедура ПриОпределенииТекстаЗапросаСвойствМаркируемойПродукции(ТекстЗапросаСвойстваМаркируемойПродукции, ТаблицаИсточник) Экспорт
	
	//++ НЕ ГОСИС
	ЕстьЕГАИС = ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийПоАлкогольнойПродукции");
	ВидыПродукцииИСМП = ИнтеграцияИСМПКлиентСерверПовтИсп.УчитываемыеВидыМаркируемойПродукции();
	УсловияМаркируемаяПродукция = Новый Массив;
	УсловияМаркируемаяПродукцияИСМП = Новый Массив;
	УсловияМаркируемаяПродукция.Добавить("
	|ЛОЖЬ");
	УсловияВидПродукции = Новый Массив;
	УсловияВидПродукции.Добавить("ВЫБОР
	|		КОГДА ДанныеШтрихкодовУпаковок.Номенклатура = НЕОПРЕДЕЛЕНО
	|			ТОГДА НЕОПРЕДЕЛЕНО");
	Если ЕстьЕГАИС Тогда
		УсловияМаркируемаяПродукция.Добавить("
		|(ЕСТЬNULL(ДанныеШтрихкодовУпаковок.Номенклатура.ВидАлкогольнойПродукции.Маркируемый, ЛОЖЬ)
		|И НЕ ЕСТЬNULL(ДанныеШтрихкодовУпаковок.Номенклатура.АлкогольнаяПродукцияВоВскрытойТаре, ЛОЖЬ))");
		УсловияВидПродукции.Добавить("
		|		КОГДА ДанныеШтрихкодовУпаковок.Номенклатура.ОсобенностьУчета = ЗНАЧЕНИЕ(Перечисление.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция)
		|			И НЕ ДанныеШтрихкодовУпаковок.Номенклатура.АлкогольнаяПродукцияВоВскрытойТаре
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.Алкогольная)")
	КонецЕсли;
	Для Каждого ВидПродукцииИСМП Из ВидыПродукцииИСМП Цикл
		ИмяВидаПродукции = СтрШаблон("ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.%1)",
			XMLСтрока(ВидПродукцииИСМП));
		ИмяОсобенностиУчета = СтрШаблон("ЗНАЧЕНИЕ(Перечисление.ОсобенностиУчетаНоменклатуры.%1)",
			XMLСтрока(ИнтеграцияИСУТКлиентСервер.ОсобенностьУчетаПоВидуПродукции(ВидПродукцииИСМП)));
		УсловияМаркируемаяПродукцияИСМП.Добавить("
		|"+ИмяОсобенностиУчета);
		УсловияВидПродукции.Добавить(СтрШаблон("
		|		КОГДА ДанныеШтрихкодовУпаковок.Номенклатура.ОсобенностьУчета = %1
		|			ТОГДА %2",
			ИмяОсобенностиУчета, ИмяВидаПродукции));
	КонецЦикла;
	
	Если УсловияМаркируемаяПродукцияИСМП.Количество() Тогда
		УсловияМаркируемаяПродукцияИСМП = 
			"ДанныеШтрихкодовУпаковок.Номенклатура.ОсобенностьУчета В ("
			+ СтрСоединить(УсловияМаркируемаяПродукцияИСМП, ",")
			+")";
		УсловияМаркируемаяПродукция.Добавить(УсловияМаркируемаяПродукцияИСМП);
	КонецЕсли;
	УсловияМаркируемаяПродукция = СтрСоединить(УсловияМаркируемаяПродукция, " ИЛИ ");
	
	УсловияВидПродукции.Добавить("
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ");
	УсловияВидПродукции = СтрСоединить(УсловияВидПродукции);
	
	ШаблонЗапросаСвойстваМаркируемойПродукции = "
	|ВЫБРАТЬ
	|	ДанныеШтрихкодовУпаковок.Номенклатура КАК Номенклатура,
	|	МАКСИМУМ(%1) КАК МаркируемаяПродукция,
	|	%2 КАК ВидПродукции
	|ПОМЕСТИТЬ СвойстваМаркируемойПродукции
	|ИЗ
	|	Таблица КАК ДанныеШтрихкодовУпаковок
	|	ЛЕВОЕ Соединение Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО СправочникНоменклатура.Ссылка = ДанныеШтрихкодовУпаковок.Номенклатура
	|СГРУППИРОВАТЬ ПО
	|	ДанныеШтрихкодовУпаковок.Номенклатура,
	|	%2
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура";
	
	ТекстЗапросаСвойстваМаркируемойПродукции = СтрШаблон(
		ШаблонЗапросаСвойстваМаркируемойПродукции, УсловияМаркируемаяПродукция, УсловияВидПродукции);
	ТекстЗапросаСвойстваМаркируемойПродукции = СтрЗаменить(ТекстЗапросаСвойстваМаркируемойПродукции, "Таблица", ТаблицаИсточник);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// В данной процедуре требуется переопределить сочетание клавиш для команды "Добавить без маркировки" в форме сканирования.
// 
// Параметры:
//  СочетаниеКлавиш - СочетаниеКлавиш - По умолчанию "Ctr + Z".
Процедура ПриОпределенииСочетанияКлавишДобавитьБезМаркировкиВФормеСканирования(СочетаниеКлавиш) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В случае учета серий в данной процедуре необходимо реализовать заполнение таблицы значений "ДанныеТаблицыТовары", 
//   содержащей (как минимум, без учета необходимости учета специфики в прикладных документах) колонки: 
//     "Номенклатура", "Характеристика", "Серия", "Количество".
// Если заданы параметры сканирования, таблицу необходимо положить во временное хранилище, адрес хранилища
//     - в ПараметрыСканирования.ДанныеТаблицыТовары. Иначе просто заполнить ДанныеТаблицыТовары по шаблону.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма, для которой происходит обработка штрихкодов.
//  ДанныеТаблицыТовары - См. ШтрихкодированиеИС.ИнициализицияТаблицыДанныхДокумента.
//  ПараметрыСканирования - См. ШтрихкодированиеИСКлиент.ПараметрыСканирования.
//  СтандартнаяОбработка - Булево - признак дальнейшей стандартной обработки события.
Процедура ПриФормированииДанныхТабличнойЧастиТовары(Форма, ДанныеТаблицыТовары, ПараметрыСканирования, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Заполнение данных по штрихкодам упаковок, сохраненных в прикладном документе.
// Используется для заполнения данными частичного выбытия по штрихкодам упаковок.
// 	
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма, для которой происходит обработка штрихкодов.
//  ДанныеПоШтрихкодамУпаковок - Соответствие из КлючИЗначение:
//                               * Ключ     - СправочникСсылка.ШтрихкодыУпаковокТоваров - Штрихкод упаковки.
//                               * Значение - см. ШтрихкодированиеИС.НоваяСтруктураДанныхШтрихкодаУпаковкиДанныхДокумента.
//  ПараметрыСканирования - См. ШтрихкодированиеИСКлиент.ПараметрыСканирования.
Процедура ПриФормированииДанныхПоШтрихкодамУпаковокДокумента(Форма, ДанныеПоШтрихкодамУпаковок, ПараметрыСканирования) Экспорт
	
	//++ НЕ ГОСИС
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект") Тогда
		Возврат;
	КонецЕсли;
		
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект, "АкцизныеМарки")
		И Форма.Объект.АкцизныеМарки.Количество() > 0
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект.АкцизныеМарки[0], "ЧастичноеВыбытиеКоличество") Тогда
		
		Для Каждого СтрокаТаблицы Из Форма.Объект.АкцизныеМарки Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.ЧастичноеВыбытиеКоличество) Тогда
				Продолжить;
			КонецЕсли;
			
			ДанныеСтроки = ШтрихкодированиеИС.НовыйЭлементДополненияВложенныхШтрихкодовУпаковокЧастичноеВыбытие();
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрокаТаблицы);
			ДанныеСтроки.Количество = СтрокаТаблицы.ЧастичноеВыбытиеКоличество;
			
			ДанныеПоШтрихкодамУпаковок.Вставить(
				СтрокаТаблицы.АкцизнаяМарка,
				ДанныеСтроки);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект, "ШтрихкодыУпаковок")
		И Форма.Объект.ШтрихкодыУпаковок.Количество() > 0
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект.ШтрихкодыУпаковок[0], "ЧастичноеВыбытиеКоличество") Тогда
		
		Для Каждого СтрокаТаблицы Из Форма.Объект.ШтрихкодыУпаковок Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.ЧастичноеВыбытиеКоличество) Тогда
				Продолжить;
			КонецЕсли;
			
			ДанныеСтроки = ШтрихкодированиеИС.НовыйЭлементДополненияВложенныхШтрихкодовУпаковокЧастичноеВыбытие();
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрокаТаблицы);
			ДанныеСтроки.Количество = СтрокаТаблицы.ЧастичноеВыбытиеКоличество;
			
			ДанныеПоШтрихкодамУпаковок.Вставить(
				СтрокаТаблицы.ШтрихкодУпаковки,
				ДанныеСтроки);
			
		КонецЦикла;
		
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// В данной процедуре необходимо определить модуль для обработки данных штрихкода. Если модуль не будет определен оббработка
// будет выполнена в модуле менеджера. Процедура, в которой будует выполнена обработка должна называться "ОбработатьДанныеШтрихкода"
// с параметрами: "Форма", "ДанныеШтрихкода", "ПараметрыСканирования", "ВложенныеШтрихкоды".
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма объекта.
// 	МодульДляОбработки - Произвольный - Модуль, в котором будет выполнена обработка.
// 	СтандартнаяОбработка - Булево - Если требуется переопределеить модуль для обработки - требуется установить флаг в Ложь.
Процедура ОпределитьМодульДляОбработкиДанныхШтрихкода(Форма, МодульДляОбработки, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры


#КонецОбласти