#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Проведение

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура - коллекция элементов:
//     Таблица<ИмяРегистра> - ТаблицаЗначений - таблица данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, Документ);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ВводОстатковТекстЗапросаТаблицаНДСПредъявленный(Запрос, ТекстыЗапроса, Регистры);
	ВводОстатковТекстЗапросаТаблицаНДССостояниеРеализации0(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
	
	ВводОстатковЛокализация.ВводОстатковНДСПредъявленногоДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеДокументов.ДобавитьЗапросыСторноДвижений(Запрос, ТекстыЗапроса, Регистры, ПустаяСсылка().Метаданные());
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("УчетНДС");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	
	ВводОстатковЛокализация.ВводОстатковНДСПредъявленногоЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента);
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеНаОсновании

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	ИсправлениеДокументов.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, ПустаяСсылка().Метаданные());
	
	ВводОстатковЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);
	
КонецПроцедуры

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ВводОстатковЛокализация.ВводОстатковНДСПредъявленногоДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);
	
КонецПроцедуры

#КонецОбласти


#Область ДляВызоваИзДругихПодсистем

// Добавляет команду создания документа на основании.
//
// Параметры:
//  КомандыСоздатьНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Возврат СозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы.ВводОстатковНДСПредъявленного);
	
КонецФункции

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область ИнициализацияДокументаИПараметровДокумента

// Инициализация параметры регистрации счетов фактур полученных
//  Параметры:
//    ДанныеОбъекта - ДокументОбъект.ВводОстатков - Объект документа ввода остатков
//
//  Возвращаемое значение:
//    Структура - структура параметров, см. УчетНДСУПКлиентСервер.ПараметрыЗаполненияВидаДеятельностиНДС().
Функция ИнициализироватьПараметрыВидовДеятельностиНДС(ДанныеОбъекта) Экспорт
	
	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияВидаДеятельностиНДС();
	ПараметрыЗаполнения.Организация             = ДанныеОбъекта.Организация;
	ПараметрыЗаполнения.Дата                    = ДанныеОбъекта.Дата;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Ссылка");
	Поля.Добавить("Номер");
	Поля.Добавить("Дата");
	Поля.Добавить("ХозяйственнаяОперация");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Данные.Ссылка <> Неопределено Тогда
		Представление = 
			ВводОстатковВызовСервера.ЗаголовокДокументаВводОстатковПоХозяйственнойОперации(Данные.Ссылка, Данные.Номер, Данные.Дата, Данные.ХозяйственнаяОперация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	&ИдентификаторМетаданных КАК ТипСсылки,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	&Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК Партнер,
	|	НЕОПРЕДЕЛЕНО КАК МестоХранения,
	|	НЕОПРЕДЕЛЕНО КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО КАК Подразделение,
	|	&Период КАК ДатаДокументаИБ,
	|	&Ссылка КАК Ссылка,
	|	&Номер КАК НомерДокументаИБ,
	|	НЕОПРЕДЕЛЕНО КАК Статус,
	|	&Ответственный КАК Ответственный,
	|	ЛОЖЬ КАК ДополнительнаяЗапись,
	|	НЕОПРЕДЕЛЕНО КАК Дополнительно,
	|	&Комментарий КАК Комментарий,
	|	&Проведен КАК Проведен,
	|	&ПометкаУдаления КАК ПометкаУдаления,
	|	НЕОПРЕДЕЛЕНО КАК ДатаПервичногоДокумента,
	|	НЕОПРЕДЕЛЕНО КАК НомерПервичногоДокумента,
	|	СУММА(ЕСТЬNULL(ДанныеТабличнойЧастиНДСПредъявленный.СуммаБезНДС, 0) +
	|		ЕСТЬNULL(ДанныеТабличнойЧастиНДСПредъявленный.НДС, 0)) КАК Сумма,
	|	&Валюта КАК Валюта,
	|	НЕОПРЕДЕЛЕНО КАК Договор,
	|	НЕОПРЕДЕЛЕНО КАК НаправлениеДеятельности,
	|	&Исправление КАК СторноИсправление,
	|	&СторнируемыйДокумент КАК СторнируемыйДокумент,
	|	&ИсправляемыйДокумент КАК ИсправляемыйДокумент,
	|	&Период КАК ДатаОтраженияВУчете,
	|	НЕОПРЕДЕЛЕНО КАК Приоритет
	|ИЗ
	|	Документ.ВводОстатковНДСПредъявленного КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводОстатковНДСПредъявленного.НДСПредъявленный КАК ДанныеТабличнойЧастиНДСПредъявленный
	|		ПО ДанныеДокумента.Ссылка = ДанныеТабличнойЧастиНДСПредъявленный.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокумента.Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ВводОстатковНДСПредъявленного";
	
	ЗначенияПараметров = Новый Структура;
	ЗначенияПараметров.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Документы.ВводОстатковНДСПредъявленного));
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
			ТекстЗапроса, ПолноеИмяДокумента, СинонимТаблицыДокумента, Истина);
	Иначе
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
			ТекстЗапроса, ПолноеИмяДокумента, СинонимТаблицыДокумента);
	КонецЕсли;
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ТекстЗапроса = ТекстЗапроса;
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = "ВЫБРАТЬ
		|	ДанныеДокумента.Дата КАК Период,
		|	ДанныеДокумента.Номер КАК Номер,
		|	ДанныеДокумента.Ссылка КАК Ссылка,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Валюта КАК Валюта,
		|	ДанныеДокумента.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
		|	ДанныеДокумента.ВидДеятельностиНДС КАК ВидДеятельностиНДС,
		|	ДанныеДокумента.ОтражатьВОперативномУчете КАК ОтражатьВОперативномУчете,
		|	ДанныеДокумента.ОтражатьВБУиНУ КАК ОтражатьВБУиНУ,
		|	ДанныеДокумента.ОтражатьВУУ КАК ОтражатьВУУ,
		|	ВЫРАЗИТЬ(ДанныеДокумента.Комментарий КАК СТРОКА(100)) КАК Комментарий,
		|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
		|	ДанныеДокумента.Ответственный КАК Ответственный,
		|	ДанныеДокумента.Проведен КАК Проведен,
		|	ДанныеДокумента.Исправление КАК Исправление,
		|	ДанныеДокумента.СторнируемыйДокумент КАК СторнируемыйДокумент,
		|	ДанныеДокумента.ИсправляемыйДокумент КАК ИсправляемыйДокумент,
		|	НастройкиХозяйственныхОпераций.Ссылка КАК НастройкаХозяйственнойОперации,
		|	СУММА(ЕСТЬNULL(ДанныеТабличнойЧастиНДСПредъявленный.СуммаБезНДС, 0) + ЕСТЬNULL(ДанныеТабличнойЧастиНДСПредъявленный.НДС, 0)) КАК СуммаДокумента
		|ИЗ
		|	Документ.ВводОстатковНДСПредъявленного КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводОстатковНДСПредъявленного.НДСПредъявленный КАК ДанныеТабличнойЧастиНДСПредъявленный
		|		ПО ДанныеДокумента.Ссылка = ДанныеТабличнойЧастиНДСПредъявленный.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
		|		ПО ДанныеДокумента.ХозяйственнаяОперация = НастройкиХозяйственныхОпераций.ХозяйственнаяОперация
		|ГДЕ
		|	ДанныеДокумента.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Валюта,
		|	ДанныеДокумента.ХозяйственнаяОперация,
		|	ДанныеДокумента.ВидДеятельностиНДС,
		|	ДанныеДокумента.ОтражатьВОперативномУчете,
		|	ДанныеДокумента.ОтражатьВБУиНУ,
		|	ДанныеДокумента.ОтражатьВУУ,
		|	ВЫРАЗИТЬ(ДанныеДокумента.Комментарий КАК СТРОКА(100)),
		|	ДанныеДокумента.ПометкаУдаления,
		|	ДанныеДокумента.Ответственный,
		|	ДанныеДокумента.Исправление,
		|	ДанныеДокумента.СторнируемыйДокумент,
		|	ДанныеДокумента.ИсправляемыйДокумент,
		|	ДанныеДокумента.Проведен,
		|	НастройкиХозяйственныхОпераций.Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();

	Запрос.УстановитьПараметр("Период",                                Реквизиты.Период);
	Запрос.УстановитьПараметр("Номер",                                 Реквизиты.Номер);
	Запрос.УстановитьПараметр("Организация",                           Реквизиты.Организация);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",                 Реквизиты.ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ВидДеятельностиНДС",                    Реквизиты.ВидДеятельностиНДС);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета",        ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Реквизиты.Организация));
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета",            Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ОтражатьВОперативномУчете",             Реквизиты.ОтражатьВОперативномУчете);
	Запрос.УстановитьПараметр("ОтражатьВБУиНУ",                        Реквизиты.ОтражатьВБУиНУ);
	Запрос.УстановитьПараметр("ОтражатьВУУ",                           Реквизиты.ОтражатьВУУ);
	Запрос.УстановитьПараметр("Комментарий",                           Реквизиты.Комментарий);
	Запрос.УстановитьПараметр("Проведен",                              Реквизиты.Проведен);
	Запрос.УстановитьПараметр("Валюта",                                Реквизиты.Валюта);
	Запрос.УстановитьПараметр("ПометкаУдаления",                       Реквизиты.ПометкаУдаления);
	Запрос.УстановитьПараметр("СуммаДокумента",                        Реквизиты.СуммаДокумента);
	Запрос.УстановитьПараметр("Ответственный",                         Реквизиты.Ответственный);
	Запрос.УстановитьПараметр("Исправление",                           Реквизиты.Исправление);
	Запрос.УстановитьПараметр("СторнируемыйДокумент",                  Реквизиты.СторнируемыйДокумент);
	Запрос.УстановитьПараметр("ИсправляемыйДокумент",                  Реквизиты.ИсправляемыйДокумент);
	Запрос.УстановитьПараметр("НастройкаХозяйственнойОперации",        Реквизиты.НастройкаХозяйственнойОперации);
	Запрос.УстановитьПараметр("ИдентификаторМетаданных", 
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ." + Метаданные.Документы.ВводОстатковНДСПредъявленного.Имя));
		
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ВводОстатковТекстЗапросаТаблицаНДСПредъявленный(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НДСПредъявленный";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Запрос.УстановитьПараметр("ДатаНачалаУчетаНДСПоНаправлениямДеятельности", УчетНДСУП.НастройкиУчета().ДатаНачалаУчетаНДСПоНаправлениямДеятельности);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	Операция.Дата                    КАК Период,
	|	Операция.Организация             КАК Организация,
	|	ТаблицаНДС.ДокументПоступления   КАК СчетФактура,
	|	ТаблицаНДС.Контрагент            КАК Поставщик,
	|	Операция.ВидЦенностиНДС          КАК ВидЦенности,
	|	ТаблицаНДС.СтавкаНДС             КАК СтавкаНДС,
	|	Операция.ВидДеятельностиНДС      КАК ВидДеятельностиНДС,
	|	НЕОПРЕДЕЛЕНО                     КАК ИсправленныйСчетФактура,
	|	ВЫБОР 
	|		КОГДА ТаблицаНДС.ДокументРеализации = ЗНАЧЕНИЕ(Документ.ПервичныйДокумент.ПустаяСсылка)
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ТаблицаНДС.ДокументРеализации
	|	КОНЕЦ                            КАК РеализацияЭкспорт,
	|	ВЫБОР 
	|		КОГДА Операция.Дата >= &ДатаНачалаУчетаНДСПоНаправлениямДеятельности
	|			ТОГДА ТаблицаНДС.НаправлениеДеятельности
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
	|	КОНЕЦ                            КАК НаправлениеДеятельности,
	|	ТаблицаНДС.СуммаБезНДС           КАК СуммаБезНДС,
	|	ТаблицаНДС.НДС                   КАК НДС,
	|	ВЫБОР КОГДА &УправленческийУчетОрганизаций 
	|			ТОГДА ТаблицаНДС.НДСУпр
	|				ИНАЧЕ 0
	|		КОНЕЦ                        КАК НДСУпр,
	|	НЕОПРЕДЕЛЕНО                     КАК Событие,
	|	ЛОЖЬ                             КАК РегламентнаяОперация,
	|	ТаблицаНДС.ИдентификаторСтроки   КАК ИдентификаторФинЗаписи,
	|	&НастройкаХозяйственнойОперации  КАК НастройкаХозяйственнойОперации
	|ИЗ
	|	Документ.ВводОстатковНДСПредъявленного КАК Операция
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ВводОстатковНДСПредъявленного.НДСПредъявленный КАК ТаблицаНДС
	|	ПО
	|		Операция.Ссылка = ТаблицаНДС.Ссылка
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|	И Операция.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковНДСПоПриобретеннымЦенностям)
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ВводОстатковТекстЗапросаТаблицаНДССостояниеРеализации0(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НДССостояниеРеализации0";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаНДС.ДокументРеализации.Дата       КАК ДатаРеализации,
	|	Операция.Дата                            КАК Период,
	|	Операция.Организация                     КАК Организация,
	|	ТаблицаНДС.ДокументРеализации.Контрагент КАК Контрагент,
	|	ТаблицаНДС.ДокументРеализации            КАК ДокументРеализации,
	|	ЕСТЬNULL(НДССостояниеРеализации0.Состояние, 
	|		ЗНАЧЕНИЕ(Перечисление.НДССостоянияРеализация0.ОжидаетсяПодтверждение)) КАК Состояние,
	|	НДССостояниеРеализации0.ДатаПодтверждения                                  КАК ДатаПодтверждения,
	|	ВЫРАЗИТЬ(НДССостояниеРеализации0.Комментарий КАК СТРОКА(500))              КАК Комментарий
	|ИЗ
	|	Документ.ВводОстатковНДСПредъявленного КАК Операция
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ВводОстатковНДСПредъявленного.НДСПредъявленный КАК ТаблицаНДС
	|	ПО
	|		Операция.Ссылка = ТаблицаНДС.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|		РегистрСведений.НДССостояниеРеализации0 КАК НДССостояниеРеализации0
	|	ПО 
	|		ТаблицаНДС.ДокументРеализации = НДССостояниеРеализации0.ДокументРеализации
	|		И НДССостояниеРеализации0.Регистратор = &Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|		РегистрСведений.НДССостояниеРеализации0 КАК НДССостояниеРеализации0ДругойВводОстатков
	|	ПО 
	|		ТаблицаНДС.ДокументРеализации = НДССостояниеРеализации0.ДокументРеализации
	|		И НДССостояниеРеализации0.Регистратор <> &Ссылка
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|	И Операция.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковНДСПоПриобретеннымЦенностям)
	|	И Операция.ВидДеятельностиНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ЭкспортСырьевыхТоваровУслуг)
	|	И ТаблицаНДС.ДокументРеализации <> ЗНАЧЕНИЕ(Документ.ПервичныйДокумент.ПустаяСсылка)
	|	И НДССостояниеРеализации0ДругойВводОстатков.ДокументРеализации ЕСТЬ NULL 
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	ВводОстатковЛокализация.ВводОстатковНДСПредъявленногоДобавитьКомандыПечати(КомандыПечати);
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти

#КонецЕсли
