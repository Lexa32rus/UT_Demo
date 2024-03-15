#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Имена реквизитов, от значений которых зависят параметры указания серий
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую.
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	ИменаРеквизитов = "Склад,ВариантОформленияДокументов,ХозяйственнаяОперация,СтатусЗаказаКлиента,СтатусРеализацииТоваровУслуг,Дата";
	
	Возврат ИменаРеквизитов;
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе
//
// Параметры:
//  Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
//
// Возвращаемое значение:
//  Структура - Состав полей задается в функции ОбработкаТабличнойЧастиКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	ПараметрыСерийСклада = СкладыСервер.ИспользованиеСерийНаСкладе(Объект.Склад, Истина);
	
	Заказ = НоменклатураКлиентСервер.ПараметрыУказанияСерий();
	
	Заказ.ПолноеИмяОбъекта = "Обработка.ПомощникПродаж";
	Заказ.ИмяТЧСерии = "Товары";
	
	Если Объект.ВариантОформленияДокументов <> Перечисления.ВариантыОформленияДокументовПродажи.КоммерческоеПредложение
		И ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента") Тогда
		
		Заказ.ИспользоватьСерииНоменклатуры  = ПараметрыСерийСклада.ИспользоватьСерииНоменклатуры;
		Заказ.УчитыватьСебестоимостьПоСериям = ПараметрыСерийСклада.УчитыватьСебестоимостьПоСериям;
	Иначе
		Заказ.ИспользоватьСерииНоменклатуры  = Ложь;
		Заказ.УчитыватьСебестоимостьПоСериям = Ложь;
	КонецЕсли;
		
	Заказ.СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ОтгрузкаКлиенту);
	
	Заказ.ПоляСвязи.Добавить("ВариантОформления");
	Заказ.ПоляСвязи.Добавить("Склад");
	
	Заказ.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерий");
	Заказ.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерийНаСкладах");
	Заказ.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерийПереданныхТоваров");
	
	Заказ.ЭтоЗаказ = Истина;
	
	Заказ.ПланированиеОтгрузки = Истина;
	Заказ.РегистрироватьСерии = Ложь;
	
	Заказ.Дата = ТекущаяДатаСеанса();
	
	Реализация = НоменклатураКлиентСервер.ПараметрыУказанияСерий();
	
	Реализация.ПолноеИмяОбъекта = "Обработка.ПомощникПродаж";
	
	ПередачаТоваровНаХранение = Ложь;
	РеализацияПоРеглУчету = Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиентуРеглУчет;
	ПередачаТоваровНаХранение = Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи;
	
	Если Объект.ВариантОформленияДокументов <> Перечисления.ВариантыОформленияДокументовПродажи.КоммерческоеПредложение Тогда
		Реализация.УчитыватьСебестоимостьПоСериям = ПараметрыСерийСклада.УчитыватьСебестоимостьПоСериям;
		
		Если РеализацияПоРеглУчету Тогда
			Реализация.ИспользоватьСерииНоменклатуры  = ПараметрыСерийСклада.УчитыватьСебестоимостьПоСериям;
		Иначе
			Реализация.ИспользоватьСерииНоменклатуры  = ПараметрыСерийСклада.ИспользоватьСерииНоменклатуры;
		КонецЕсли;	
	Иначе
		Реализация.ИспользоватьСерииНоменклатуры  = Ложь;
		Реализация.УчитыватьСебестоимостьПоСериям = Ложь;
	КонецЕсли;
	
	Реализация.СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ОтгрузкаКлиенту);
	
	Реализация.ПоляСвязи.Добавить("ВариантОформления");
	Реализация.ПоляСвязи.Добавить("Склад");
	
	Реализация.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерий");
	Реализация.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерийНаСкладах");
	Реализация.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерийПереданныхТоваров");
	
	Реализация.ЭтоНакладная = Истина;
	
	Реализация.ТолькоСерииДляСебестоимости = РеализацияПоРеглУчету;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыРеализацийТоваровУслуг") Тогда
		СтатусРеализации = Объект.СтатусРеализацииТоваровУслуг;
	Иначе
		СтатусРеализации = Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено;
	КонецЕсли;
	
	Если ПередачаТоваровНаХранение Тогда
		Реализация.ПланированиеОтбора = Истина;
		Реализация.ФактОтбора         = Истина;
	Иначе
		Реализация.ПланированиеОтгрузки = СтатусРеализации = Перечисления.СтатусыРеализацийТоваровУслуг.КПредоплате;
		Реализация.ПланированиеОтбора = СтатусРеализации = Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено;
		Реализация.ФактОтбора = СтатусРеализации = Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено;
	КонецЕсли;
	
	Реализация.РегистрироватьСерии = НоменклатураКлиентСервер.НеобходимоРегистрироватьСерии(Реализация);
	
	Реализация.Дата = ТекущаяДатаСеанса();
	
	ПараметрыУказанияСерий = Новый Структура;
	ПараметрыУказанияСерий.Вставить("Реализация", Реализация);
	ПараметрыУказанияСерий.Вставить("Заказ", Заказ);
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//		ПараметрыУказанияСерий - Структура - состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий
//	Возвращаемое значение:
//		Строка - текст запроса.
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	Если ПараметрыУказанияСерий.ЭтоНакладная Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Товары.ВариантОформления,
		|	Товары.Склад,
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.Серия,
		|	Товары.Количество,
		|	Товары.СтатусУказанияСерий,
		|	Товары.СтатусУказанияСерийНаСкладах,
		|	Товары.СтатусУказанияСерийПереданныхТоваров,
		|	Товары.НомерСтроки
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&Товары КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Серии.ВариантОформления,
		|	Серии.Склад,
		|	Серии.Номенклатура,
		|	Серии.Характеристика,
		|	Серии.Количество
		|ПОМЕСТИТЬ Серии
		|ИЗ
		|	&Серии КАК Серии
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.ВариантОформления,
		|	Товары.Склад,
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	СУММА(Товары.Количество) КАК Количество,
		|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры КАК ВидНоменклатуры
		|ПОМЕСТИТЬ ТоварыДляЗапроса
		|ИЗ
		|	Товары КАК Товары
		|
		|СГРУППИРОВАТЬ ПО
		|	Товары.ВариантОформления,
		|	Товары.Склад,
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Серии.ВариантОформления,
		|	Серии.Склад,
		|	Серии.Номенклатура,
		|	Серии.Характеристика,
		|	СУММА(Серии.Количество) КАК Количество
		|ПОМЕСТИТЬ СерииДляЗапроса
		|ИЗ
		|	Серии КАК Серии
		|
		|СГРУППИРОВАТЬ ПО
		|	Серии.ВариантОформления,
		|	Серии.Склад,
		|	Серии.Номенклатура,
		|	Серии.Характеристика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.НомерСтроки КАК НомерСтроки,
		|	Товары.СтатусУказанияСерий КАК СтарыйСтатусУказанияСерий,
		|	Товары.СтатусУказанияСерийНаСкладах КАК СтарыйСтатусУказанияСерийНаСкладах,
		|	Товары.СтатусУказанияСерийПереданныхТоваров КАК СтарыйСтатусУказанияСерийПереданныхТоваров,
		|	ВЫБОР
		|		КОГДА Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.ЗаказКлиента)
		|			ТОГДА Товары.СтатусУказанияСерий
		|		КОГДА Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.КоммерческоеПредложение)
		|			ТОГДА 0
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL 
		|			ТОГДА 0
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
		|			ТОГДА ВЫБОР
		|					КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|						ТОГДА 14
		|					ИНАЧЕ 13
		|				КОНЕЦ
		|		КОГДА &ТолькоСерииДляСебестоимости
		|			ТОГДА 0
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтгрузки
		|			ТОГДА ВЫБОР
		|					КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|						ТОГДА 10
		|					ИНАЧЕ 9
		|				КОНЕЦ
		|		КОГДА Склады.ИспользоватьОрдернуюСхемуПриОтгрузке
		|				И &Дата >= Склады.ДатаНачалаОрдернойСхемыПриОтгрузке
		|			ТОГДА 0
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтбора
		|				И &ПланированиеОтбора
		|			ТОГДА ВЫБОР
		|					КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчетСерийПоFEFO
		|						ТОГДА ВЫБОР
		|								КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
		|										И ТоварыДляЗапроса.Количество > 0
		|									ТОГДА 6
		|								ИНАЧЕ 5
		|							КОНЕЦ
		|					ИНАЧЕ ВЫБОР
		|							КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
		|									И ТоварыДляЗапроса.Количество > 0
		|								ТОГДА 8
		|							ИНАЧЕ 7
		|						КОНЕЦ
		|				КОНЕЦ
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПоФактуОтбора
		|				И &ФактОтбора
		|				И ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузкеКлиенту
		|			ТОГДА ВЫБОР
		|					КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьОстаткиСерий
		|						ТОГДА ВЫБОР
		|								КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
		|										И ТоварыДляЗапроса.Количество > 0
		|									ТОГДА 4
		|								ИНАЧЕ 3
		|							КОНЕЦ
		|					ИНАЧЕ ВЫБОР
		|							КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
		|									И ТоварыДляЗапроса.Количество > 0
		|								ТОГДА 2
		|							ИНАЧЕ 1
		|						КОНЕЦ
		|				КОНЕЦ
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СтатусУказанияСерий,
		|	ВЫБОР
		|		КОГДА ТоварыДляЗапроса.ВидНоменклатуры.ПолитикаУчетаСерий ЕСТЬ NULL
		|				И НЕ &ИспользоватьПередачуНаОтветственноеХранение
		|			ТОГДА 0
		|		ИНАЧЕ
		|			ВЫБОР
		|				КОГДА ТоварыДляЗапроса.ВидНоменклатуры.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
		|					ТОГДА
		|						ВЫБОР
		|							КОГДА ТоварыДляЗапроса.ВидНоменклатуры.ПолитикаУчетаСерий.УчетСерийВПереданныхНаХранениеТоварах
		|								ТОГДА
		|									ВЫБОР
		|										КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|											ТОГДА 18
		|										ИНАЧЕ 17
		|									КОНЕЦ
		|								ИНАЧЕ 0
		|						КОНЕЦ
		|					ИНАЧЕ 0
		|			КОНЕЦ
		|	КОНЕЦ КАК СтатусУказанияСерийПереданныхТоваров
		|ПОМЕСТИТЬ Статусы
		|ИЗ
		|	Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыДляЗапроса КАК ТоварыДляЗапроса
		|			ЛЕВОЕ СОЕДИНЕНИЕ СерииДляЗапроса КАК СерииДляЗапроса
		|			ПО ТоварыДляЗапроса.Номенклатура = СерииДляЗапроса.Номенклатура
		|				И ТоварыДляЗапроса.Характеристика = СерииДляЗапроса.Характеристика
		|				И ТоварыДляЗапроса.Склад = СерииДляЗапроса.Склад
		|				И ТоварыДляЗапроса.ВариантОформления = СерииДляЗапроса.ВариантОформления
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
		|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
		|				ПО ПолитикиУчетаСерий.Склад = Склады.Ссылка
		|			ПО ПолитикиУчетаСерий.Склад = ТоварыДляЗапроса.Склад
		|				И ТоварыДляЗапроса.ВидНоменклатуры = ПолитикиУчетаСерий.Ссылка
		|		ПО Товары.Номенклатура = ТоварыДляЗапроса.Номенклатура
		|			И Товары.Характеристика = ТоварыДляЗапроса.Характеристика
		|			И Товары.Склад = ТоварыДляЗапроса.Склад
		|			И Товары.ВариантОформления = ТоварыДляЗапроса.ВариантОформления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Статусы.НомерСтроки КАК НомерСтроки,
		|	Статусы.СтатусУказанияСерий КАК СтатусУказанияСерийНаСкладах,
		|	Статусы.СтатусУказанияСерийПереданныхТоваров КАК СтатусУказанияСерийПереданныхТоваров,
		|	ВЫБОР
		|		КОГДА Статусы.СтатусУказанияСерий = 0
		|			ТОГДА Статусы.СтатусУказанияСерийПереданныхТоваров
		|		ИНАЧЕ Статусы.СтатусУказанияСерий
		|	КОНЕЦ КАК СтатусУказанияСерий
		|ИЗ
		|	Статусы КАК Статусы
		|ГДЕ
		|	ВЫБОР
		|		КОГДА Статусы.СтатусУказанияСерий = 0
		|			ТОГДА Статусы.СтатусУказанияСерийПереданныхТоваров
		|		ИНАЧЕ Статусы.СтатусУказанияСерий
		|	КОНЕЦ <> Статусы.СтарыйСтатусУказанияСерий
		|	ИЛИ Статусы.СтатусУказанияСерий <> Статусы.СтарыйСтатусУказанияСерийНаСкладах
		|	ИЛИ Статусы.СтатусУказанияСерийПереданныхТоваров <> Статусы.СтарыйСтатусУказанияСерийПереданныхТоваров
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	ИначеЕсли ПараметрыУказанияСерий.ЭтоЗаказ Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Товары.Склад,
		|	Товары.Номенклатура,
		|	Товары.Серия,
		|	Товары.Отменено,
		|	Товары.ВариантОбеспечения,
		|	Товары.Количество,
		|	Товары.СтатусУказанияСерий,
		|	Товары.СтатусУказанияСерийНаСкладах,
		|	Товары.СтатусУказанияСерийПереданныхТоваров,
		|	Товары.НомерСтроки,
		|	Товары.ВариантОформления
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&Товары КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.НомерСтроки КАК НомерСтроки,
		|	Товары.СтатусУказанияСерий КАК СтарыйСтатусУказанияСерий,
		|	Товары.СтатусУказанияСерийНаСкладах КАК СтарыйСтатусУказанияСерийНаСкладах,
		|	Товары.СтатусУказанияСерийПереданныхТоваров КАК СтарыйСтатусУказанияСерийПереданныхТоваров,
		|	ВЫБОР
		|		КОГДА Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.РеализацияТоваровУслуг)
		|				ИЛИ Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.ПередачаТоваровХранителю)
		|				ИЛИ Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.ЗаказКлиентаПередачаТоваровХранителю)
		|				ИЛИ Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.ЗаказКлиентаРеализацияТоваровУслуг)
		|			ТОГДА Товары.СтатусУказанияСерий
		|		КОГДА Товары.Отменено
		|				ИЛИ Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.КоммерческоеПредложение)
		|				ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL
		|				ИЛИ НЕ Товары.ВариантОбеспечения В(
		|						ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.СоСклада),
		|						ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить))
		|			ТОГДА 0
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
		|			ТОГДА ВЫБОР
		|					КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|						ТОГДА 14
		|					КОГДА Товары.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.СоСклада)
		|						ТОГДА 15
		|					ИНАЧЕ 13
		|				КОНЕЦ
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтгрузки
		|			ТОГДА ВЫБОР
		|					КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|						ТОГДА 10
		|					КОГДА Товары.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.СоСклада)
		|						ТОГДА 11
		|					ИНАЧЕ 9
		|				КОНЕЦ
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СтатусУказанияСерий,
		|	0 КАК СтатусУказанияСерийПереданныхТоваров
		|ПОМЕСТИТЬ Статусы
		|ИЗ
		|	Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
		|		ПО (ПолитикиУчетаСерий.Склад = Товары.Склад)
		|			И ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры = ПолитикиУчетаСерий.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Статусы.НомерСтроки КАК НомерСтроки,
		|	Статусы.СтатусУказанияСерий КАК СтатусУказанияСерийНаСкладах,
		|	Статусы.СтатусУказанияСерийПереданныхТоваров КАК СтатусУказанияСерийПереданныхТоваров,
		|	Статусы.СтатусУказанияСерий КАК СтатусУказанияСерий
		|ИЗ
		|	Статусы КАК Статусы
		|ГДЕ
		|	Статусы.СтатусУказанияСерий <> Статусы.СтарыйСтатусУказанияСерий
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Иначе
		ТекстИсключения = НСтр("ru = 'Ошибка определения текста запроса для заполнения статуса указания серий.'");
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	УсловиеЗапроса = "ЛОЖЬ";
	
	ИспользоватьПередачуНаОтветственноеХранение = ПолучитьФункциональнуюОпцию("ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи");
	УсловиеЗапроса = ?(ИспользоватьПередачуНаОтветственноеХранение,
						"(Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.ПередачаТоваровХранителю)
						|	ИЛИ Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.ЗаказКлиентаПередачаТоваровХранителю))",
						УсловиеЗапроса);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИспользоватьПередачуНаОтветственноеХранение", УсловиеЗапроса);
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает структуру параметров для заполнения налогообложения НДС продажи.
//
// Параметры:
//  Объект - ОбработкаОбъект.ПомощникПродаж - документ, по которому необходимо сформировать параметры.
//
// Возвращаемое значение:
//  Структура - Параметры заполнения, описание параметров см. УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСПродажи();
//
Функция ПараметрыЗаполненияНалогообложенияНДСПродажи(Объект) Экспорт
	
	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСПродажи();
	
	ПараметрыЗаполнения.Организация = Объект.Организация;
	ПараметрыЗаполнения.Дата = Объект.Дата;
	ПараметрыЗаполнения.Склад = Объект.Склад;
	ПараметрыЗаполнения.Договор = Объект.Договор;
	ПараметрыЗаполнения.НаправлениеДеятельности = Объект.НаправлениеДеятельности;
	ПараметрыЗаполнения.Подразделение = Объект.Подразделение;
	
	Если Объект.ВариантОформленияДокументов = Перечисления.ВариантыОформленияДокументовПродажи.КоммерческоеПредложение Или
		Объект.ВариантОформленияДокументов = Перечисления.ВариантыОформленияДокументовПродажи.ЗаказКлиента Тогда
		
		ПараметрыЗаполнения.ЭтоЗаказ = Истина;
		
	КонецЕсли;
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту Или
		Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности  Тогда
		
		ПараметрыЗаполнения.РеализацияТоваров = Истина;
		ПараметрыЗаполнения.РеализацияРаботУслуг = Истина;
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию Тогда
		
		ПараметрыЗаполнения.ПередачаНаКомиссию = Истина;
		
	КонецЕсли;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

// Возвращает параметры механизма взаиморасчетов.
//
// Параметры:
// 	ДанныеЗаполнения - ДокументОбъект, СправочникОбъект, ДокументСсылка, СправочникСсылка, Структура, ДанныеФормыСтруктура - Объект или коллекция для
//              расчета параметров взаиморасчетов.
//
// Возвращаемое значение:
// 	См. ВзаиморасчетыСервер.ПараметрыМеханизма
//
Функция ПараметрыВзаиморасчеты(ДанныеЗаполнения = Неопределено) Экспорт
	
	Если ОбщегоНазначения.ЗначениеСсылочногоТипа(ДанныеЗаполнения) Тогда
		СтруктураДанныеЗаполнения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ДанныеЗаполнения, 
			"ХозяйственнаяОперация,
			|ВариантОформленияДокументов");
		ХозяйственнаяОперация       = СтруктураДанныеЗаполнения.ХозяйственнаяОперация;
		ВариантОформленияДокументов = СтруктураДанныеЗаполнения.ВариантОформленияДокументов;
	ИначеЕсли ДанныеЗаполнения = Неопределено Тогда
		ХозяйственнаяОперация       = Неопределено;
		ВариантОформленияДокументов = Неопределено
	Иначе
		ХозяйственнаяОперация       = ДанныеЗаполнения.ХозяйственнаяОперация;
		ВариантОформленияДокументов = ДанныеЗаполнения.ВариантОформленияДокументов;
	КонецЕсли;
	
	СтруктураПараметров = ВзаиморасчетыСервер.ПараметрыМеханизма();
	
	СтруктураПараметров.ТипРасчетов                      = Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом;
	СтруктураПараметров.ИзменяетПланОплаты               = ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияКлиенту")
		ИЛИ ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности")
		ИЛИ ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияКлиентуРеглУчет")
		ИЛИ ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи");
	СтруктураПараметров.ИзменяетПланОтгрузкиПоставки     = ИСТИНА;
	
	Если ВариантОформленияДокументов = Перечисления.ВариантыОформленияДокументовПродажи.ЗаказКлиента Тогда
		СтруктураПараметров.ЭтоЗаказ                         = Истина;
		СтруктураПараметров.ЭтоПродажаЗакупка                = Ложь;
	ИначеЕсли ВариантОформленияДокументов = Перечисления.ВариантыОформленияДокументовПродажи.РеализацияТоваровУслуг Тогда
		СтруктураПараметров.ЭтоЗаказ                         = Ложь;
		СтруктураПараметров.ЭтоПродажаЗакупка                = Истина;
	ИначеЕсли ВариантОформленияДокументов = Перечисления.ВариантыОформленияДокументовПродажи.ЗаказКлиентаРеализацияТоваровУслуг Тогда
		СтруктураПараметров.ЭтоЗаказ                         = Истина;
		СтруктураПараметров.ЭтоПродажаЗакупка                = Истина;
	Иначе
		СтруктураПараметров.ИзменяетПланОплаты               = Ложь;
		СтруктураПараметров.ИзменяетПланОтгрузкиПоставки     = Ложь;
	КонецЕсли;
	
	СтруктураПараметров.ВалютаВзаиморасчетов             = "";
	СтруктураПараметров.СуммаВзаиморасчетов              = "";
	СтруктураПараметров.СуммаВзаиморасчетовПоТаре        = "";
	СтруктураПараметров.БанковскийСчетОрганизации		 = "Объект.БанковскийСчет";
	СтруктураПараметров.БанковскийСчетКонтрагента		 = "Объект.БанковскийСчетКонтрагента";
	
	СтруктураПараметров.КурсЧислитель                    = "";
	СтруктураПараметров.КурсЗнаменатель                  = "";
	СтруктураПараметров.ФормаОплаты                      = "Объект.ФормаОплаты";
	СтруктураПараметров.ГрафикОплаты                     = "Объект.ГрафикОплаты";
	СтруктураПараметров.ИсточникСуммТабличнаяЧасть       = Истина;

	СтруктураПараметров.ИдентификаторПлатежа			 = "";
	
	СтруктураПараметров.ПутьКДаннымТЧЭтапыОплаты         = "Объект.ЭтапыГрафикаОплаты";
	СтруктураПараметров.НадписьЭтапыОплаты               = "Форма.НадписьЭтапыОплаты";
	СтруктураПараметров.ДатаОтгрузки                     = "Объект.ДатаОтгрузки"; 
	
	СтруктураПараметров.ПутьКДаннымТЧ                    = "Объект.Товары";
	СтруктураПараметров.ИмяРеквизитаТЧЗаказ              = "";
	
	СтруктураПараметров.ПутьКДаннымТЧРасшифровкаПлатежа  = "";
	
	СтруктураПараметров.Менеджер                         = "Объект.Менеджер";
	
	СтруктураПараметров.ЭлементыФормы.НадписьЭтапы       = "ДекорацияЭтапыОплаты";
	
	СтруктураПараметров.ПутьКДаннымТЧЭтапыОплаты         = "Объект.ЭтапыГрафикаОплаты";
	СтруктураПараметров.СуммаДокументаФорма              = "Форма.СуммаВсего";
	СтруктураПараметров.СуммаЗалогаЗаТаруФорма           = "Форма.СуммаЗалогаЗаТару";
	
	Возврат СтруктураПараметров;
	
КонецФункции

// Формирует структуру параметров документа для встраивания документа в механимы обеспечения.
//
// Возвращаемое значение:
//  см. ОбеспечениеВДокументахСервер.ДоступныеОстаткиПараметрыВстраивания
//
Функция ДоступныеОстаткиПараметрыВстраивания() Экспорт
	
	ПараметрыВстраивания = ОбеспечениеВДокументахСервер.ДоступныеОстаткиПараметрыВстраивания();
	
	// Обновление колонки "Доступно".
	ПараметрыВстраивания.ИмяТаблицыФормы = "Товары";
	
	// Условное оформление.
	ЭлементыФормы = ПараметрыВстраивания.УсловноеОформление.ЭлементыФормы;
	ЭлементыФормы.ВариантОбеспечения = "ТоварыВариантОбеспечения";
	ЭлементыФормы.Доступно           = "ТоварыДоступно";
	ЭлементыФормы.Серия              = "ТоварыСерия";
	ЭлементыФормы.Обособленно        = "ТоварыОбособленно";
	ЭлементыФормы.Склад              = "ТоварыСклад";
	
	ПутиКДанным = ПараметрыВстраивания.УсловноеОформление.ПутиКДанным;
	ПутиКДанным.ПерераспределятьЗапасы = "Объект.Товары.ПерераспределятьЗапасы";
	ПутиКДанным.ЗапретРедактирования = "Объект.Товары.Отменено";
	ПутиКДанным.ТипНоменклатуры = "Объект.Товары.ТипНоменклатуры";
	
	// Выбор варианта обеспечения.
	Связи = ПараметрыВстраивания.СвязиПараметровВыбораВариантаОбеспечения;
	Связи.Доступно              = "Элементы.Товары.ТекущиеДанные.Доступно";
	Связи.КоличествоУпаковок    = "Элементы.Товары.ТекущиеДанные.КоличествоУпаковок";
	Связи.Количество            = "Элементы.Товары.ТекущиеДанные.Количество";
	Связи.ОтгружатьЕслиДоступно = "Элементы.Товары.ТекущиеДанные.ОтгружатьЕслиДоступно";
	Связи.Обособленно           = "Элементы.Товары.ТекущиеДанные.Обособленно";
	Связи.ТипНоменклатуры       = "Элементы.Товары.ТекущиеДанные.ТипНоменклатуры";
	Связи.Упаковка              = "Элементы.Товары.ТекущиеДанные.Упаковка";
	Связи.Номенклатура          = "Элементы.Товары.ТекущиеДанные.Номенклатура";
	Связи.ВариантОбеспечения    = "Элементы.Товары.ТекущиеДанные.ВариантОбеспечения";
	Связи.Склад                 = "Элементы.Товары.ТекущиеДанные.Склад";
	Связи.НесколькоСкладов      = "СкладГруппа";
	
	// Имя регистра оформления отгрузки.
	ПараметрыВстраивания.ИмяРегистраОформленияОтгрузки = "ЗаказыКлиентов";
	
	// Временная таблица данных документа.
	ПараметрыВстраивания.ИмяОбъекта = "Форма";
	ПараметрыВстраивания.ИмяТаблицы = "Форма.Объект.Товары";
	
	ПараметрыВстраивания.ОписаниеПолученияДанныхДокумента =
		"ВЫБРАТЬ
		|	ТабЧасть.Номенклатура КАК Номенклатура,
		|	ТабЧасть.Характеристика КАК Характеристика,
		|	Реквизиты.Подразделение КАК Подразделение,
		|	ТабЧасть.Склад КАК Склад,
		|	Реквизиты.Назначение КАК Назначение,
		|	Реквизиты.Ссылка КАК ЗаказНаОтгрузку,
		|	ТабЧасть.ВариантОбеспечения КАК ВариантОбеспечения,
		|	ТабЧасть.Обособленно КАК Обособленно,
		|	ТабЧасть.Количество КАК Количество,
		|	ТабЧасть.КоличествоУпаковок КАК КоличествоУпаковок,
		|	ТабЧасть.Упаковка КАК Упаковка,
		|	Реквизиты.СтатусЗаказаКлиента В(
		|			ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовКлиентов.КОбеспечению),
		|			ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовКлиентов.КОтгрузке),
		|			ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовКлиентов.Закрыт)
		|		) КАК ГотовКОбеспечению,
		|	Реквизиты.СтатусЗаказаКлиента В(
		|			ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовКлиентов.КОбеспечению),
		|			ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовКлиентов.КОтгрузке),
		|			ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовКлиентов.Закрыт)
		|		) КАК ГотовКОтгрузке,
		|	ВЫБОР КОГДА Реквизиты.НеОтгружатьЧастями ТОГДА
		|				Реквизиты.ДатаОтгрузки
		|			ИНАЧЕ
		|				ТабЧасть.ДатаОтгрузки
		|		КОНЕЦ КАК ЖелаемаяДатаОтгрузки,
		|	ТабЧасть.Серия КАК Серия,
		|	ТабЧасть.КодСтроки КАК КодСтроки,
		|	ТабЧасть.Отменено КАК Отменено,
		|	ТабЧасть.НомерСтроки КАК НомерСтроки,
		|	Реквизиты.Ссылка КАК Регистратор,
		|	Реквизиты.Дата КАК ДатаДокумента,
		|	Реквизиты.Склад КАК ГруппаСкладов,
		|	ЗНАЧЕНИЕ(Справочник.Приоритеты.ПустаяСсылка) КАК Приоритет,
		|	ВЫБОР КОГДА Реквизиты.НеОтгружатьЧастями ТОГДА
		|				Реквизиты.ДатаОтгрузки
		|			ИНАЧЕ
		|				НЕОПРЕДЕЛЕНО
		|		КОНЕЦ КАК ДатаОтгрузкиВсехСтрокОднойДатой
		|ПОМЕСТИТЬ ВременнаяТаблицаДанныхДокумента
		|ИЗ
		|	Форма.Объект.Товары КАК ТабЧасть
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ Форма.Объект КАК Реквизиты
		|		ПО ИСТИНА";
	
	// Шаблон сериализации данных формы.
	Товары = Новый Структура();
	Товары.Вставить("НомерСтроки",        Новый ОписаниеТипов("Число"));
	Товары.Вставить("Номенклатура",       Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Товары.Вставить("Характеристика",     Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	Товары.Вставить("Склад",              Новый ОписаниеТипов("СправочникСсылка.Склады"));
	Товары.Вставить("ВариантОбеспечения", Новый ОписаниеТипов("ПеречислениеСсылка.ВариантыОбеспечения"));
	Товары.Вставить("Обособленно",        Новый ОписаниеТипов("Булево"));
	Товары.Вставить("Количество",         Новый ОписаниеТипов("Число"));
	Товары.Вставить("КоличествоУпаковок", Новый ОписаниеТипов("Число"));
	Товары.Вставить("Упаковка",           Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
	Товары.Вставить("ДатаОтгрузки",       Новый ОписаниеТипов("Дата"));
	Товары.Вставить("Серия",              Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	Товары.Вставить("Отменено",           Новый ОписаниеТипов("Булево"));
	Товары.Вставить("КодСтроки",          Новый ОписаниеТипов("Число"));
	
	Объект = Новый Структура();
	Объект.Вставить("Подразделение",       Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия"));
	Объект.Вставить("Назначение",          Новый ОписаниеТипов("СправочникСсылка.Назначения"));
	Объект.Вставить("Ссылка",              Новый ОписаниеТипов("ДокументСсылка.ЗаказКлиента"));
	Объект.Вставить("СтатусЗаказаКлиента", Новый ОписаниеТипов("ПеречислениеСсылка.СтатусыЗаказовКлиентов"));
	Объект.Вставить("НеОтгружатьЧастями",  Новый ОписаниеТипов("Булево"));
	Объект.Вставить("ДатаОтгрузки",        Новый ОписаниеТипов("Дата"));
	Объект.Вставить("Дата",                Новый ОписаниеТипов("Дата"));
	Объект.Вставить("Склад",               Новый ОписаниеТипов("СправочникСсылка.Склады"));
	Объект.Вставить("Товары",              Товары);
	
	ПараметрыВстраивания.ШаблонСериализацииДанныхФормы.Вставить("Объект", Объект);
	
	Возврат ПараметрыВстраивания;
	
КонецФункции

#Область ОснованиеДляПечати

// Возвращает таблицу значений по умолчанию для реквизита "Основание"
//
// Параметры:
//	Объект - ДанныеФормыСтруктура, ОбработкаОбъект.ПомощникПродаж - Объект, по которму необходимо получить список выбора.
//
// Возвращаемое значение:
//	ТаблицаЗначений - Таблица значений с реквизитами оснований.
//
Функция ТаблицаОснованийДляПечати(Объект) Экспорт
	
	ЭтоПередачаНаКомиссию = (Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию);
	ЭтоПередачаНаХранение = 
		(Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи);
	
	ТаблицаОснований = Новый ТаблицаЗначений;
	ТаблицаОснований.Колонки.Добавить("Основание",      Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(300)));
	ТаблицаОснований.Колонки.Добавить("ОснованиеДата",  Новый ОписаниеТипов("Дата",,,,,Новый КвалификаторыДаты(ЧастиДаты.Дата))); 
	ТаблицаОснований.Колонки.Добавить("ОснованиеНомер", Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(128)));
	
	СтруктураОснования = СтруктураОснования(Объект, Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов);
	Если ЗначениеЗаполнено(СтруктураОснования.Основание) Тогда
		ДобавленнаяСтрока = ТаблицаОснований.Добавить();
		ЗаполнитьЗначенияСвойств(ДобавленнаяСтрока, СтруктураОснования);
		ДобавленнаяСтрока.Основание = СтруктураОснования.Основание
						+ ?(ЭтоПередачаНаКомиссию, ", " + НСтр("ru='передача на комиссию'"),
							?(ЭтоПередачаНаХранение, ", " + НСтр("ru='передача на хранение'"), ""));
	КонецЕсли;
	
	Если (ЭтоПередачаНаКомиссию
			Или ЭтоПередачаНаХранение)
		И ТаблицаОснований.Количество()=0 Тогда
		
		ДобавленнаяСтрока = ТаблицаОснований.Добавить();
		ДобавленнаяСтрока.Основание = ?(ЭтоПередачаНаКомиссию,
										НСтр("ru='Передача на комиссию'"),
										НСтр("ru='передача на хранение'"));
		
	КонецЕсли;
	
	Возврат ТаблицаОснований;
	
КонецФункции

// Возвращает текст основания по данными документа
//
// Параметры:
//	Объект - ДанныеФормыСтруктура, ОбработкаОбъект.ПомощникПродаж - Объект, по которму необходимо получить текст основания
//	ПорядокРасчетов - ПеречислениеСсылка.ПорядокРасчетов - порядок расчетов документа.
//
// Возвращаемое значение:
//	Структура - Структура с наименованием, датой и номером основания.
//
Функция СтруктураОснования(Объект, ПорядокРасчетов) Экспорт
	
	СтруктураОснование = Новый Структура("Основание, ОснованиеНомер, ОснованиеДата");
	
	Если ЗначениеЗаполнено(Объект.Договор)
		И ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДоговорыКонтрагентов.НаименованиеДляПечати КАК Основание,
		|	ДоговорыКонтрагентов.Дата                  КАК ОснованиеДата,
		|	ДоговорыКонтрагентов.Номер                 КАК ОснованиеНомер
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|ГДЕ
		|	ДоговорыКонтрагентов.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Объект.Договор);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			СтруктураОснование.Основание      = СокрЛП(Выборка.Основание);
			СтруктураОснование.ОснованиеДата  = Выборка.ОснованиеДата;
			СтруктураОснование.ОснованиеНомер = СокрЛП(Выборка.ОснованиеНомер);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтруктураОснование; // Возврат значения по умолчанию
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныйПрограммныйИнтерфейс

#КонецОбласти

#Область Прочее

Функция СуммыПоЗаказам(СсылкаОбъект) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Товары.СуммаСНДС           КАК Сумма,
	|	Товары.Номенклатура        КАК Номенклатура
	|ПОМЕСТИТЬ ВТТовары
	|ИЗ &Таблица КАК Товары
	|;
	|ВЫБРАТЬ 
	|	Неопределено                                     КАК Заказ,
	|	ДАТАВРЕМЯ(1,1,1)                                 КАК ДатаЗаказа,
	|	ДАТАВРЕМЯ(1,1,1)                                 КАК ДатаСогласования,
	|	Ложь                                             КАК СверхЗаказа,
	|	СУММА(ВложенныйЗапрос.СуммаПлатежа)              КАК СуммаПлатежа,
	|	0                                                КАК СуммаВзаиморасчетов,
	|	СУММА(ВложенныйЗапрос.СуммаЗалогаЗаТару)         КАК СуммаЗалогаЗаТару,
	|	0                                                КАК СуммаВзаиморасчетовПоТаре
	|ИЗ (ВЫБРАТЬ
	|		ВЫБОР
	|			КОГДА Товары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|					ИЛИ НЕ &ВернутьМногооборотнуюТару
	|				ТОГДА Товары.Сумма
	|			ИНАЧЕ 0 
	|		КОНЕЦ                             КАК СуммаПлатежа,
	|		ВЫБОР 
	|			КОГДА Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|				И &ТребуетсяЗалогЗаТару
	|				ТОГДА Товары.Сумма
	|			ИНАЧЕ 0 
	|		КОНЕЦ                            КАК СуммаЗалогаЗаТару
	|	ИЗ ВТТовары КАК Товары) КАК ВложенныйЗапрос
	|;";
	
	Запрос.УстановитьПараметр("ВернутьМногооборотнуюТару", СсылкаОбъект.ВернутьМногооборотнуюТару);
	Запрос.УстановитьПараметр("ТребуетсяЗалогЗаТару", СсылкаОбъект.ТребуетсяЗалогЗаТару);
	Запрос.УстановитьПараметр("Таблица", СсылкаОбъект.Товары);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
