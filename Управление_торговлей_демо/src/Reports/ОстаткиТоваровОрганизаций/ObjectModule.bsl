#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("Документ", Параметры.ПараметрКоманды);
		ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = Строка(Параметры.ПараметрКоманды);
		Параметры.КлючНазначенияИспользования = Строка(Параметры.ПараметрКоманды);
		
		ТипПараметра = ТипЗнч(Параметры.ПараметрКоманды);
		Если ТипПараметра = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями")
			Или ТипПараметра = Тип("ДокументСсылка.ОтчетОРозничныхПродажах")
			Или ТипПараметра = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями")
			Или ТипПараметра = Тип("ДокументСсылка.ПередачаТоваровХранителю")
			Или ТипПараметра = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			
			Параметры.КлючВарианта = "ОстаткиТоваровДляПродажи";
			
		Иначе
			Параметры.КлючВарианта = "ОстаткиТоваровДляДокумента";
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
 	УстановитьПривилегированныйРежим(Истина);
		
	ТаблицаВСтроке = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ТаблицаВСтроке").Значение;
	ДляПомощникаОформленияСкладскихАктов = ЗначениеЗаполнено(ТаблицаВСтроке);
	
	Документ = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Документ").Значение;
	Если Не ЗначениеЗаполнено(Документ) И НЕ ДляПомощникаОформленияСкладскихАктов Тогда
		Возврат;
	КонецЕсли;
	
	Если ДляПомощникаОформленияСкладскихАктов Тогда
		Склад = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Склад").Значение;
		
		ДокументОбъект = Новый Структура();
		ДокументОбъект.Вставить("Дата", ТекущаяДатаСеанса());
		ДокументОбъект.Вставить("Склад", Склад);
		ДокументОбъект.Вставить("Организация", Неопределено);
		ДокументОбъект.Вставить("Ссылка", Неопределено);
		ДокументОбъект.Вставить("Проведен", Ложь);
		ДокументОбъект.Вставить("ДополнительныеСвойства", Новый Структура());
		
		ТаблицаТоваровИзСтроки = ЗначениеИзСтрокиВнутр(ТаблицаВСтроке);
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.Серия,
		|	Товары.Назначение,
		|	Товары.Количество,
		|	Товары.КоличествоКОприходованию,
		|	Товары.КоличествоКСписанию
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&ТаблицаТоваров КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Аналитика.КлючАналитики КАК АналитикаУчетаНоменклатуры,
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.Серия,
		|	Товары.Назначение,
		|	&Склад КАК Склад,
		|
		|	НЕОПРЕДЕЛЕНО КАК ВладелецТовара,
		|	НЕОПРЕДЕЛЕНО КАК Соглашение,
		|	НЕОПРЕДЕЛЕНО КАК НалогообложениеНДС,
		|
		|	Товары.Количество,
		|	Товары.КоличествоКОприходованию КАК КоличествоКОприходованию,
		|	Товары.КоличествоКСписанию КАК КоличествоКСписанию
		|
		|ПОМЕСТИТЬ ТаблицаТоваровИАналитикиМод
		|ИЗ
		|	Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
		|		ПО Товары.Номенклатура = Аналитика.Номенклатура
		|			И Товары.Характеристика = Аналитика.Характеристика
		|			И Товары.Серия = Аналитика.Серия
		|			И ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)  = Аналитика.Назначение
		|			И (Аналитика.МестоХранения = &Склад)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	АналитикаУчетаНоменклатуры
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НЕОПРЕДЕЛЕНО КАК Организация
		|ПОМЕСТИТЬ ВыбранныеОрганизации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Таблица.АналитикаУчетаНоменклатуры,
		|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка) КАК НомерГТД,
		|	Таблица.Номенклатура
		|ПОМЕСТИТЬ ТаблицаТоваров
		|ИЗ
		|	ТаблицаТоваровИАналитикиМод КАК Таблица
		|;
		|/////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ Товары
		|");
		
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("Склад", ДокументОбъект.Склад);
		Запрос.УстановитьПараметр("ТаблицаТоваров", ТаблицаТоваровИзСтроки);
		
		Запрос.Выполнить();
		
		// организация не известна, формируются все доступные виды запасов.
		ПараметрыЗаполненияВидовЗапасов = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
		ПараметрыЗаполненияВидовЗапасов.ИмяПоляОрганизация = "Организация";
		ПараметрыЗаполненияВидовЗапасов.ПодбиратьВидыЗапасовПоИнтеркампани = Ложь; // в отборе видов запасов уже передается массив по всем организациям.
		
		Отборы = ПараметрыЗаполненияВидовЗапасов.ОтборыВидовЗапасов;
		Отборы.Организация = Справочники.Организации.ДоступныеОрганизации(Истина);
		
		ЗапасыСервер.ПодготовитьДанныеДляОтчета(ДокументОбъект, МенеджерВременныхТаблиц, ПараметрыЗаполненияВидовЗапасов);
		
		ДокументОбъект.Дата = КонецМесяца(ДокументОбъект.Дата);
		
	Иначе
			
		ДокументОбъект = Документ.ПолучитьОбъект();
		
		ДокументОбъект.ЗаполнитьАналитикиУчетаНоменклатуры();
		МенеджерВременныхТаблиц = ДокументОбъект.ВременныеТаблицыДанныхДокумента();
		ДокументОбъект.СформироватьВременнуюТаблицуТоваровИАналитики(МенеджерВременныхТаблиц);
		
		ПараметрыЗаполненияВидовЗапасов = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
		ПараметрыЗаполненияВидовЗапасов.ИмяПоляОрганизация = "Организация";
		ПараметрыЗаполненияВидовЗапасов.ПодбиратьВидыЗапасовПоИнтеркампани = Истина;
		
		Отборы = ПараметрыЗаполненияВидовЗапасов.ОтборыВидовЗапасов;
		Отборы.Организация = ДокументОбъект[ПараметрыЗаполненияВидовЗапасов.ИмяПоляОрганизация];
		
		ЗапасыСервер.ПодготовитьДанныеДляОтчета(ДокументОбъект, МенеджерВременныхТаблиц, ПараметрыЗаполненияВидовЗапасов);
	
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("Организация", ДокументОбъект[ПараметрыЗаполненияВидовЗапасов.ИмяПоляОрганизация]);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	&Организация КАК Организация
		|ПОМЕСТИТЬ ВыбранныеОрганизации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.АналитикаУчетаНоменклатуры,
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.Серия,
		|	Товары.Назначение,
		|	Товары.Склад,
		|
		|	НЕОПРЕДЕЛЕНО КАК ВладелецТовара,
		|	НЕОПРЕДЕЛЕНО КАК Соглашение,
		|	Товары.НалогообложениеНДС КАК НалогообложениеНДС,
		|
		|	Товары.Количество,
		|	0 КАК КоличествоКОприходованию,
		|	0 КАК КоличествоКСписанию
		|ПОМЕСТИТЬ ТаблицаТоваровИАналитикиМод
		|ИЗ
		|	ТаблицаТоваровИАналитики КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|";
		Запрос.Выполнить();
	КонецЕсли;
	
	ТипДокумента = ТипЗнч(Документ);
	Если ТипДокумента = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями")
		ИЛИ ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями") Тогда
		Реквизиты = Документы.ПередачаТоваровМеждуОрганизациями.РеквизитыДокумента(Документ);
		Владелец = Реквизиты.Организация;
	Иначе
	КонецЕсли;
	
	ДатаОстатков = КонецМесяца(ДокументОбъект.Дата);
	
	ЗапасыСервер.СформироватьВТТаблицаОстатков("ТоварыОрганизаций", ДокументОбъект, МенеджерВременныхТаблиц, ПараметрыЗаполненияВидовЗапасов, Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Организации.Ссылка КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС) КАК НалогообложениеНДС
	|ПОМЕСТИТЬ НалогообложениеОрганизаций
	|ИЗ
	|	РегистрСведений.НастройкиСистемыНалогообложения.СрезПоследних(&Дата,) КАК Настройка
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|	ПО Настройка.Организация = Организации.ГоловнаяОрганизация
	|ГДЕ
	|	Настройка.ПрименяетсяУСН
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВыбранныеОрганизации.Организация,
	|	ТаблицаТоваров.НалогообложениеНДС,
	|	(ВЫБОР КОГДА ТаблицаТоваров.АналитикаУчетаНоменклатуры <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка) ТОГДА
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры
	|	ИНАЧЕ
	|		ЕСТЬNULL(Аналитика.КлючАналитики, ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка))
	|	КОНЕЦ) КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ТаблицаТоваров.Серия,
	|	ТаблицаТоваров.Склад,
	|	СУММА(ТаблицаТоваров.Количество) КАК Количество,
	|	СУММА(ТаблицаТоваров.КоличествоКОприходованию) КАК КоличествоКОприходованию,
	|	СУММА(ТаблицаТоваров.КоличествоКСписанию) КАК КоличествоКСписанию,
	|
	|	ТаблицаТоваров.Назначение,
	|	ТаблицаТоваров.ВладелецТовара,
	|	ТаблицаТоваров.Соглашение
	|
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	ВыбранныеОрганизации КАК ВыбранныеОрганизации
	|	ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаТоваровИАналитикиМод КАК ТаблицаТоваров
	|		ПО ИСТИНА
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|		ПО Аналитика.Номенклатура = ТаблицаТоваров.Номенклатура
	|		И Аналитика.Характеристика = ТаблицаТоваров.Характеристика
	|		И Аналитика.Серия = ТаблицаТоваров.Серия
	|		И Аналитика.МестоХранения = ТаблицаТоваров.Склад
	|		И Аналитика.Назначение = ТаблицаТоваров.Назначение
	|
	|СГРУППИРОВАТЬ ПО
	|	ВыбранныеОрганизации.Организация,
	|	ТаблицаТоваров.НалогообложениеНДС,
	|	(ВЫБОР КОГДА ТаблицаТоваров.АналитикаУчетаНоменклатуры <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка) ТОГДА
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры
	|	ИНАЧЕ
	|		ЕСТЬNULL(Аналитика.КлючАналитики, ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка))
	|	КОНЕЦ),
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ТаблицаТоваров.Серия,
	|	ТаблицаТоваров.Склад,
	|	ТаблицаТоваров.Назначение,
	|	ТаблицаТоваров.ВладелецТовара,
	|	ТаблицаТоваров.Соглашение
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Организация КАК ДляОрганизации,
	|	ТаблицаТоваров.Организация КАК Организация,
	|	ТаблицаТоваров.НалогообложениеНДС,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ТаблицаТоваров.Серия,
	|	ТаблицаТоваров.Склад,
	|	ТаблицаТоваров.Количество,
	|	ТаблицаТоваров.КоличествоКОприходованию,
	|	ТаблицаТоваров.КоличествоКСписанию,
	|
	|	ТаблицаТоваров.Назначение,
	|	ТаблицаТоваров.ВладелецТовара,
	|	ТаблицаТоваров.Соглашение
	|ИЗ
	|	Товары КАК ТаблицаТоваров
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Организация КАК ДляОрганизации,
	|	ТаблицаОстатков.Организация КАК Организация,
	|	ТаблицаОстатков.АналитикаУчетаНоменклатуры,
	|	Ключи.Номенклатура,
	|	Ключи.Характеристика,
	|	Ключи.Серия,
	|	Ключи.МестоХранения КАК Склад,
	|	ТаблицаОстатков.ВидЗапасов КАК ВидЗапасов,
	|
	|	ТаблицаОстатков.НомерГТД КАК НомерГТД,
	|	ТаблицаОстатков.НомерГТД.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ТаблицаОстатков.ДатаПоступления КАК ДатаПоступления,
	|	ТаблицаОстатков.КоличествоОстаток,
	|	ВЫБОР КОГДА НЕ ДоступныеВидыЗапасовДляОрганизаций.ВидЗапасов ЕСТЬ NULL ТОГДА
	|		ВЫБОР КОГДА &ЗапретитьОперацииСТоварамиБезНомеровГТД
	|			И Ключи.Номенклатура.ВестиУчетПоГТД
	|			И ТаблицаОстатков.НомерГТД = ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)
	|		ТОГДА
	|			0
	|		ИНАЧЕ
	|			ТаблицаОстатков.КоличествоОстаток
	|		КОНЕЦ
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК ДоступныйОстаток,
	|
	|	ВЫБОР КОГДА НЕ ДоступныеВидыЗапасовДляОрганизаций.ВидЗапасов ЕСТЬ NULL ТОГДА
	|		ВЫБОР КОГДА &ЗапретитьОперацииСТоварамиБезНомеровГТД
	|			И Ключи.Номенклатура.ВестиУчетПоГТД
	|			И ТаблицаОстатков.НомерГТД = ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)
	|		ТОГДА
	|			0
	|		ИНАЧЕ
	|			ВЫБОР КОГДА ДоступныеВидыЗапасовДляОрганизаций.ВидЗапасов.Организация = ТаблицаТоваров.Организация
	|					ИЛИ ТаблицаТоваров.Организация = НЕОПРЕДЕЛЕНО
	|				ТОГДА ТаблицаОстатков.КоличествоОстаток
	|				ИНАЧЕ 0
	|			КОНЕЦ
	|		КОНЕЦ
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК ДоступныйОстатокБезИнтеркампани,
	|
	|	НЕОПРЕДЕЛЕНО КАК Подразделение,
	|	НЕОПРЕДЕЛЕНО КАК Менеджер,
	|	НЕОПРЕДЕЛЕНО КАК Сделка,
	|
	|	ТаблицаОстатков.ВидЗапасов.Соглашение КАК Соглашение,
	|	ТаблицаОстатков.ВидЗапасов.ВладелецТовара КАК ВладелецТовара,
	|	ТаблицаОстатков.ВидЗапасов.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ТаблицаОстатков.ВидЗапасов.Договор КАК Договор,
	|
	|	ВЫБОР КОГДА НЕ ДоступныеВидыЗапасовДляОрганизаций.ВидЗапасов ЕСТЬ NULL 
	|		И НЕ ТаблицаТоваров.Назначение ЕСТЬ NULL ТОГДА
	|		ВЫБОР КОГДА &ЗапретитьОперацииСТоварамиБезНомеровГТД
	|			И Ключи.Номенклатура.ВестиУчетПоГТД
	|			И ТаблицаОстатков.НомерГТД = ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)
	|		ТОГДА
	|			ЛОЖЬ
	|		ИНАЧЕ
	|			ИСТИНА
	|		КОНЕЦ
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК ДоступенДляДокумента,
	|
	|	ВЫБОР КОГДА НЕ ДоступныеВидыЗапасовДляОрганизаций.ВидЗапасов ЕСТЬ NULL
	|		ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЕстьСоединениеСДоступныеВидыЗапасовДляОрганизаций
	|ИЗ
	|	ТаблицаОстатков КАК ТаблицаОстатков
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.КлючиАналитикиУчетаНоменклатуры КАК Ключи
	|	ПО
	|		ТаблицаОстатков.АналитикаУчетаНоменклатуры = Ключи.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Товары КАК ТаблицаТоваров
	|	ПО  
	|		ТаблицаОстатков.АналитикаУчетаНоменклатуры = ТаблицаТоваров.АналитикаУчетаНоменклатуры
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ДоступныеВидыЗапасов КАК ДоступныеВидыЗапасовДляОрганизаций
	|	ПО ТаблицаОстатков.ВидЗапасов = ДоступныеВидыЗапасовДляОрганизаций.ВидЗапасов
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		НалогообложениеОрганизаций КАК НалогообложениеОрганизаций
	|	ПО
	|		ТаблицаОстатков.Организация = НалогообложениеОрганизаций.Организация
	|ГДЕ
	|	ТаблицаОстатков.КоличествоОстаток > 0
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|");
	Запрос.УстановитьПараметр("Дата", ДокументОбъект.Дата);
	Запрос.УстановитьПараметр("ЗапретитьОперацииСТоварамиБезНомеровГТД", ПолучитьФункциональнуюОпцию("ЗапретитьОформлениеОперацийСИмпортнымиТоварамиБезНомеровГТД"));
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// МассивРезультатов[0] - НалогообложениеОрганизаций
	// МассивРезультатов[1] - Товары.
	ТаблицаТоваров = МассивРезультатов[2].Выгрузить();
	ТаблицаОстатков = МассивРезультатов[3].Выгрузить();
	
	ВнешниеНаборыДанных = Новый Структура("ТаблицаТоваров, ТаблицаОстатков",
		ТаблицаТоваров,
		ТаблицаОстатков);
	
	ПараметрНаДату = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НаДату");
	Если ПараметрНаДату <> Неопределено Тогда
		ПараметрПользовательскойНастройки = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ПараметрНаДату.ИдентификаторПользовательскойНастройки);
		Если ПараметрПользовательскойНастройки <> Неопределено Тогда
			ПараметрПользовательскойНастройки.Значение = ДатаОстатков;
		Иначе
			ПараметрНаДату.Значение = ДатаОстатков;
		КонецЕсли;
	КонецЕсли;
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(ПолучитьЗаголовкиПолей(ДатаОстатков), МакетКомпоновки);
	 	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ТаблицаВСтроке = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ТаблицаВСтроке").Значение;	
 	Если ЭтоАдресВременногоХранилища(ТаблицаВСтроке) Тогда
		МассивНепроверяемыхРеквизитов = Новый Массив;
		МассивНепроверяемыхРеквизитов.Добавить("Документ");		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьЗаголовкиПолей(ДатаКонтроля)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Движения.Период
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций КАК Движения
	|УПОРЯДОЧИТЬ ПО
	|	Движения.Период УБЫВ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ДатаАктуальности = Выборка.Период;
	Иначе
		ДатаАктуальности = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ЗаголовкиПолей = Новый Соответствие;
	ЗаголовкиПолей.Вставить("1", Формат(ДатаАктуальности, "ДЛФ=Д"));
	
	Возврат ЗаголовкиПолей;
	
КонецФункции

#КонецОбласти

#КонецЕсли
