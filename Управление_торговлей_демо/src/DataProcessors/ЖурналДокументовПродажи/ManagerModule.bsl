#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт

КонецПроцедуры

// Добавляет команду создания объекта.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  
// Возвращаемое значение:
// 	СтрокаТаблицыЗначений, Неопределено - 
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Обработки.ЖурналДокументовПродажи) Тогда
		
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.ОбщиеМодули.ПродажиКлиент.ПолноеИмя();
		КомандаСоздатьНаОсновании.Обработчик = "СформироватьКомплектДокументовВызов";
		КомандаСоздатьНаОсновании.ДополнительныеПараметры = Новый ФиксированнаяСтруктура("СписокРаспоряжений", Новый Массив);
		КомандаСоздатьНаОсновании.Представление =  НСтр("ru='Комплект документов'");
		КомандаСоздатьНаОсновании.Картинка = БиблиотекаКартинок.ОформитьПродажу;
		КомандаСоздатьНаОсновании.Порядок = 0;
		КомандаСоздатьНаОсновании.Важность = "Важное";
		КомандаСоздатьНаОсновании.МножественныйВыбор = Истина;
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
// 	Команды - см. ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту.Команды
Процедура ПриОпределенииКомандПодключенныхКОбъекту(Команды) Экспорт
	
	МассивКомандОтчетов = Команды.НайтиСтроки(Новый Структура("Вид", "Отчеты"));
	МассивКомандПечати = Команды.НайтиСтроки(Новый Структура("Вид", "Печать"));
	
	МенеджерОтклоненияОтУсловийПродаж = Метаданные.Отчеты.ОтклоненияОтУсловийПродаж.ПолноеИмя();
	МенеджерСостояниеРасчетовСКлиентами = Метаданные.Отчеты.СостояниеРасчетовСКлиентами.ПолноеИмя();
	МенеджерКарточкаРасчетовСКлиентами = Метаданные.Отчеты.КарточкаРасчетовСКлиентами.ПолноеИмя();
	МенеджерКарточкаРасчетовПоПереданнойВозвратнойТаре = Метаданные.Отчеты.КарточкаРасчетовПоПереданнойВозвратнойТаре.ПолноеИмя();
	МенеджерАнализЦенПоставщиков = Метаданные.Отчеты.АнализЦенПоставщиков.ПолноеИмя();
	
	Для каждого ТекКоманда Из МассивКомандОтчетов Цикл
		Если ТекКоманда.Менеджер = МенеджерОтклоненияОтУсловийПродаж Тогда
			ТекКоманда.Важность = "Обычное"
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерСостояниеРасчетовСКлиентами Тогда
			ТекКоманда.Важность = "Обычное";
			ТекКоманда.Порядок = 1;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерКарточкаРасчетовСКлиентами Тогда
			ТекКоманда.Важность = "Обычное";
			ТекКоманда.Порядок = 2;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерКарточкаРасчетовПоПереданнойВозвратнойТаре Тогда
			ТекКоманда.Порядок = 3;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерАнализЦенПоставщиков Тогда
			ТекКоманда.Важность = "СмТакже";
			ТекКоманда.Порядок = 2;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекКоманда Из МассивКомандПечати Цикл
		ТекКоманда.ВидимостьВФормах = "СписокДокументов";
	КонецЦикла;
	
КонецПроцедуры

Функция ИмяФормыСпискаОформляемыхНакладных()
	
	Возврат "Обработка.ЖурналДокументовПродажи.Форма.КОформлениюНакладных";
	
КонецФункции

Функция ИмяФормыРабочееМестоКОформлению()
	
	Возврат "Обработка.ЖурналДокументовПродажи.Форма.КОформлениюНакладныхВозвратов";
	
КонецФункции

#Область ФормированиеГиперссылкиВЖурналеДокументовПродажи

// Возвращает текст гиперссылки перехода из журнала документов в рабочее место оформления накладных.
//
// Параметры:
//	Параметры - Структура - параметры формирования текста гиперссылки.
//
// Возвращаемое значение:
//	ФорматированнаяСтрока, Неопределено - текст гиперссылки перехода в рабочее место оформления отчетов по комиссии.
//
Функция СформироватьГиперссылкуКОформлению(Параметры) Экспорт
	
	МассивСтрок = Новый Массив;
	
	// Накладные
	
	Организация = Параметры.Организация;
	Склад       = Параметры.Склад;
	
	ИспользоватьРасширенныеВозможностиЗаказаКлиента = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента");
	ИспользоватьОрдернуюСхемуПриОтгрузке = ПолучитьФункциональнуюОпцию("ИспользоватьОрдернуюСхемуПриОтгрузке");
	
	ИспользоватьРасширенныеВозможностиЗаказаКлиента = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента");
	
	ПоказыватьЗаказы = (ИспользоватьРасширенныеВозможностиЗаказаКлиента
						И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ЗаказыКлиентов)
						И ПравоДоступа("Чтение", Метаданные.Документы.ЗаказКлиента)
						И ПравоДоступа("Чтение", Метаданные.Документы.ЗаявкаНаВозвратТоваровОтКлиента)
						И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКОтгрузке))
						И (ПравоДоступа("Добавление", Метаданные.Документы.ПередачаТоваровХранителю)
						ИЛИ ПравоДоступа("Добавление", Метаданные.Документы.АктВыполненныхРабот)
						ИЛИ ПравоДоступа("Добавление", Метаданные.Документы.РеализацияТоваровУслуг));
	
	
	Если ПоказыватьЗаказы Тогда
		
		ТекстГиперссылки = НСтр("ru = 'Накладные'");
		
		Если ЕстьЗаказыКОформлению(Организация, Склад) Тогда
			Гиперссылка = Новый ФорматированнаяСтрока(ТекстГиперссылки, , , , ИмяФормыСпискаОформляемыхНакладных());
		Иначе
			Гиперссылка = Новый ФорматированнаяСтрока(ТекстГиперссылки, , ЦветаСтиля.НезаполненноеПолеТаблицы, ,
				ИмяФормыСпискаОформляемыхНакладных());
		КонецЕсли;
		
		ДобавитьГиперссылкуВСписок(Гиперссылка, МассивСтрок);
		
	КонецЕсли;
	
	// Возвраты
	
	ПоказыватьНакладные = (ИспользоватьРасширенныеВозможностиЗаказаКлиента 
		ИЛИ ИспользоватьОрдернуюСхемуПриОтгрузке)
		И ПравоДоступа("Чтение", Метаданные.Документы.ВозвратТоваровОтКлиента)
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ЗаявкиНаВозвратТоваровОтКлиентов);
	
	ПоказыватьРаспоряженияНаПриемку = ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению);
		
	ПоказыватьНакладные = ПоказыватьНакладные
		Или (ПолучитьФункциональнуюОпцию("ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи")
			И ПравоДоступа("Чтение", Метаданные.Документы.ПоступлениеТоваровОтХранителя)
			И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению));
	
	Если ПоказыватьНакладные
			И ПоказыватьРаспоряженияНаПриемку Тогда
		
		ТекстГиперссылки = НСтр("ru = 'Возвраты'");
		
		Если ЕстьРаспоряженияНаПриемкуПоВозврату(Организация, Склад)
				Или ЕстьРаспоряженияНаПриемкуПоПоступлениямОтХранителя(Организация, Склад)
				Тогда
			Гиперссылка = Новый ФорматированнаяСтрока(ТекстГиперссылки,
				,
				,
				,
				ИмяФормыРабочееМестоКОформлению());
		Иначе
			Гиперссылка = Новый ФорматированнаяСтрока(ТекстГиперссылки,
				,
				ЦветаСтиля.НезаполненноеПолеТаблицы,
				,
				ИмяФормыРабочееМестоКОформлению());
		КонецЕсли;
		
		ДобавитьГиперссылкуВСписок(Гиперссылка, МассивСтрок);
		
	КонецЕсли;
	
	Если МассивСтрок.Количество() > 0 Тогда
		Возврат Новый ФорматированнаяСтрока(МассивСтрок);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Процедура СформироватьГиперссылкуКОформлениюФоновоеЗадание(Параметры, АдресХранилища) Экспорт
	
	Результат = Новый Структура("КОформлению, СмТакжеВРаботе");
	Результат.КОформлению = ОбщегоНазначенияУТ.СформироватьГиперссылкуКОформлению(Параметры[0], Параметры[1]);
	
	МассивМенеджеровРасчетаСмТакжеВРаботе = Новый Массив();
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Документ.ЗаказКлиента");
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Документ.ЗаявкаНаВозвратТоваровОтКлиента");
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Документ.ДоверенностьВыданная");
	
	ДополнитьМассивМенеджеровРасчетаСмТакжеВРаботеЛокализация(МассивМенеджеровРасчетаСмТакжеВРаботе);
	
	Результат.СмТакжеВРаботе = ОбщегоНазначенияУТ.СформироватьГиперссылкуСмТакжеВРаботе(МассивМенеджеровРасчетаСмТакжеВРаботе, Параметры[1]);
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры

Процедура ДобавитьГиперссылкуВСписок(Гиперссылка, МассивСтрок)
	
	Если ЗначениеЗаполнено(Гиперссылка) Тогда
		Если МассивСтрок.Количество() > 0 Тогда
			МассивСтрок.Добавить("; ");
		КонецЕсли;
		МассивСтрок.Добавить(Гиперссылка);
	КонецЕсли;

КонецПроцедуры

Функция ЕстьРаспоряженияНаПриемкуПоВозврату(Организация, Склад)
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ОстаткиРегистра.ДокументПоступления
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению.Остатки(,
	|		(ДокументПоступления ССЫЛКА Документ.ЗаявкаНаВозвратТоваровОтКлиента
	|			ИЛИ ДокументПоступления ССЫЛКА Документ.ВозвратТоваровОтКлиента)
	|		И &УсловиеОтбораПоСкладу
	|		И &УсловиеОтбораПоОрганизации
	|		) КАК ОстаткиРегистра
	|ГДЕ
	|	ОстаткиРегистра.КОформлениюОрдеровОстаток <> 0
	|	ИЛИ ОстаткиРегистра.КОформлениюПоступленийПоОрдерамОстаток <> 0
	|	ИЛИ ОстаткиРегистра.КОформлениюНакладныхПоРаспоряжениюОстаток <> 0
	|	И (НЕ ОстаткиРегистра.ДокументПоступления ССЫЛКА Документ.ЗаявкаНаВозвратТоваровОтКлиента
	|		ИЛИ (ОстаткиРегистра.ДокументПоступления ССЫЛКА Документ.ЗаявкаНаВозвратТоваровОтКлиента
	|			И ВЫРАЗИТЬ(ОстаткиРегистра.ДокументПоступления КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).ХозяйственнаяОперация <> 
	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОтХранителя)))";
	
	Если ЗначениеЗаполнено(Склад) Тогда
		ОтборПоСкладу = "И Склад = &Склад";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеОтбораПоСкладу", ОтборПоСкладу);
	Иначе	
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеОтбораПоСкладу", "");
	КонецЕсли;
	Если ЗначениеЗаполнено(Организация) Тогда
		ОтборПоОрганизации = 
		"И (ВЫРАЗИТЬ(ДокументПоступления КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).Организация = &Организация
		|	ИЛИ ВЫРАЗИТЬ(ДокументПоступления КАК Документ.ВозвратТоваровОтКлиента).Организация = &Организация)";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеОтбораПоОрганизации", ОтборПоОрганизации);
	Иначе	
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеОтбораПоОрганизации", "");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ЕстьРаспоряженияНаПриемкуПоПоступлениямОтХранителя(Организация, Склад)
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ОстаткиРегистра.ДокументПоступления
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению.Остатки(,
	|		(ДокументПоступления ССЫЛКА Документ.ЗаявкаНаВозвратТоваровОтКлиента
	|			ИЛИ ДокументПоступления ССЫЛКА Документ.ПоступлениеТоваровОтХранителя)
	|		И &УсловиеОтбораПоСкладу
	|		И &УсловиеОтбораПоОрганизации
	|		) КАК ОстаткиРегистра
	|ГДЕ
	|	ОстаткиРегистра.КОформлениюОрдеровОстаток <> 0
	|	ИЛИ ОстаткиРегистра.КОформлениюПоступленийПоОрдерамОстаток <> 0
	|	ИЛИ ОстаткиРегистра.КОформлениюНакладныхПоРаспоряжениюОстаток <> 0
	|	И (НЕ ОстаткиРегистра.ДокументПоступления ССЫЛКА Документ.ЗаявкаНаВозвратТоваровОтКлиента
	|		ИЛИ (ОстаткиРегистра.ДокументПоступления ССЫЛКА Документ.ЗаявкаНаВозвратТоваровОтКлиента
	|			И ВЫРАЗИТЬ(ОстаткиРегистра.ДокументПоступления КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).ХозяйственнаяОперация = 
	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОтХранителя)))";
	
	Если ЗначениеЗаполнено(Склад) Тогда
		ОтборПоСкладу = "И Склад = &Склад";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеОтбораПоСкладу", ОтборПоСкладу);
	Иначе	
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеОтбораПоСкладу", "");
	КонецЕсли;
	Если ЗначениеЗаполнено(Организация) Тогда
		ОтборПоОрганизации = 
		"И (ВЫРАЗИТЬ(ДокументПоступления КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).Организация = &Организация
		|	ИЛИ ВЫРАЗИТЬ(ДокументПоступления КАК Документ.ПоступлениеТоваровОтХранителя).Организация = &Организация)";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеОтбораПоОрганизации", ОтборПоОрганизации);
	Иначе	
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеОтбораПоОрганизации", "");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

// Возвращает признак необходимости оформления накладные продаж по складу организации.
//
// Параметры;
//	Организация - СправочникСсылка.Организации - организация, для которой проверяется наличие накладных.
//	Склад       - СправочникСсылка.Склады      - склад,  для которого проверяется наличие накладных.
//
// ВозвращаемоеЗначение:
//	Булево - Истина, необходимо оформить накладные продаж по складу организации.
//
Функция ЕстьЗаказыКОформлению(Организация = Неопределено, Склад = Неопределено)
	
	Если Не ПравоДоступа("Чтение", Метаданные.Документы.ЗаказКлиента) Тогда
		Возврат Ложь;
	КонецЕсли;	
		
	ТекстЗапроса = ТекстЗапросаЗаказыКОформлению(Организация, Склад);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад",       Склад);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

// Возвращает текст запроса, который используется для получения данных об оформляемых накладных по продажам.
//
// Параметры;
//	Организация - СправочникСсылка.Организации - организация, по которой требуется оформить накладные.
//	Склад       - СправочникСсылка.Склады      - склад, по которому требуется оформить накладные.
//
// ВозвращаемоеЗначение:
//	Строка - текст запроса, который используется для получения данных об оформляемых накладных по продажам.
//
Функция ТекстЗапросаЗаказыКОформлению(Организация = Неопределено, Склад = Неопределено)
	
	ИспользуютсяПередачиНаХранение = ПолучитьФункциональнуюОпцию("ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи");
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ИСТИНА КАК ПолеВыборки
	|ГДЕ
	|	(ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА КАК ПолеВыборки
	|		ИЗ
	|			РегистрНакопления.ТоварыКОтгрузке.Остатки(, (Склад = &Склад
	|				ИЛИ &Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|				И ДокументОтгрузки ССЫЛКА Документ.РеализацияТоваровУслуг
	|				И &УсловиеОтбораПоДокументуПередачи
	|			) КАК ТоварыКОтгрузке
	|		ГДЕ
	|			(ТоварыКОтгрузке.КОтгрузкеОстаток - ТоварыКОтгрузке.СобраноОстаток > 0
	|				ИЛИ ТоварыКОтгрузке.КОформлениюОстаток > 0)
	|			И ТоварыКОтгрузке.Склад.ИспользоватьОрдернуюСхемуПриОтгрузке
	|			И ТоварыКОтгрузке.Склад.ДатаНачалаОрдернойСхемыПриОтгрузке <= &ТекущаяДата
	|			И &УсловиеОтбораОрганизацияТоварыКОтгрузке)
	|	ИЛИ ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА КАК ПолеВыборки
	|		ИЗ
	|			РегистрНакопления.ТоварыКОтгрузке.Остатки(, (Склад = &Склад
	|				ИЛИ &Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|				И ДокументОтгрузки В
	|					(ВЫБРАТЬ
	|						РаспоряженияНаОформление.Ссылка
	|					ИЗ
	|						Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК РаспоряженияНаОформление
	|					ГДЕ
	|						ИСТИНА
	|						И &УсловиеОтбораПоВозврату
	|						И &УсловиеОтбораОрганизацияЗаявкиНаВозврат
	|					)
	|			) КАК ТоварыКОтгрузке
	|		ГДЕ
	|			(ТоварыКОтгрузке.КОтгрузкеОстаток - ТоварыКОтгрузке.СобраноОстаток > 0
	|				ИЛИ ТоварыКОтгрузке.КОформлениюОстаток > 0)
	|			И ТоварыКОтгрузке.Склад.ИспользоватьОрдернуюСхемуПриОтгрузке
	|			И ТоварыКОтгрузке.Склад.ДатаНачалаОрдернойСхемыПриОтгрузке <= &ТекущаяДата
	|			И &УсловиеОтбораОрганизацияТоварыКОтгрузке)
	|	ИЛИ ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА КАК ПолеВыборки
	|		ИЗ
	|			РегистрНакопления.ТоварыКОтгрузке.Остатки(, (Склад = &Склад
	|				ИЛИ &Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|				И ДокументОтгрузки В
	|					(ВЫБРАТЬ
	|						РаспоряженияНаОформление.Ссылка
	|					ИЗ
	|						Документ.ЗаказКлиента КАК РаспоряженияНаОформление
	|					ГДЕ
	|						ИСТИНА
	|						И &УсловиеОтбораПоПередаче
	|						И &УсловиеОтбораОрганизацияЗаказыКлиентов
	|					)
	|			) КАК ТоварыКОтгрузке
	|		ГДЕ
	|			(ТоварыКОтгрузке.КОтгрузкеОстаток - ТоварыКОтгрузке.СобраноОстаток > 0
	|				ИЛИ ТоварыКОтгрузке.КОформлениюОстаток > 0)
	|			И ТоварыКОтгрузке.Склад.ИспользоватьОрдернуюСхемуПриОтгрузке
	|			И ТоварыКОтгрузке.Склад.ДатаНачалаОрдернойСхемыПриОтгрузке <= &ТекущаяДата)
	|	ИЛИ ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрНакопления.ЗаказыКлиентов.Остатки(, (Склад = &Склад
	|				ИЛИ &Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|				И ЗаказКлиента В
	|					(ВЫБРАТЬ
	|						РаспоряженияНаОформление.Ссылка КАК Ссылка
	|					ИЗ
	|						Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК РаспоряженияНаОформление
	|					ГДЕ
	|						ИСТИНА
	|						И &УсловиеОтбораПоВозврату
	|						И &УсловиеОтбораОрганизацияЗаявкиНаВозврат
	|					)
	|			) КАК ЗаказыКлиентов
	|		ГДЕ
	|			ЗаказыКлиентов.КОформлениюОстаток > 0)
	|	ИЛИ ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрНакопления.ЗаказыКлиентов.Остатки(, (Склад = &Склад
	|				ИЛИ &Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|				И ЗаказКлиента В
	|					(ВЫБРАТЬ
	|						РаспоряженияНаОформление.Ссылка КАК Ссылка
	|					ИЗ
	|						Документ.ЗаказКлиента КАК РаспоряженияНаОформление
	|					ГДЕ
	|						ИСТИНА
	|						И &УсловиеОтбораПоПередаче
	|						И &УсловиеОтбораОрганизацияЗаказыКлиентов
	|					)
	|			) КАК ЗаказыКлиентов
	|		ГДЕ
	|			ЗаказыКлиентов.КОформлениюОстаток > 0))";
	
	Если Не ИспользуютсяПередачиНаХранение Тогда
		
		УсловиеОтбора = "И РаспоряженияНаОформление.ХозяйственнаяОперация <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи)";
		ТекстЗапроса  = СтрЗаменить(ТекстЗапроса, "И &УсловиеОтбораПоПередаче", УсловиеОтбора);
		
		УсловиеОтбора = "И РаспоряженияНаОформление.ХозяйственнаяОперация <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОтХранителя)";
		ТекстЗапроса  = СтрЗаменить(ТекстЗапроса, "И &УсловиеОтбораПоВозврату", УсловиеОтбора);
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеОтбораПоДокументуПередачи", "");
		
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеОтбораПоПередаче", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеОтбораПоВозврату", "");
		
		УсловиеОтбора = "ИЛИ ДокументОтгрузки ССЫЛКА Документ.ПередачаТоваровХранителю";
		ТекстЗапроса  = СтрЗаменить(ТекстЗапроса, "И &УсловиеОтбораПоДокументуПередачи", УсловиеОтбора);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		УсловиеОтбора = "
		|		И ВЫРАЗИТЬ(РаспоряженияНаОформление.Ссылка КАК Документ.ЗаказКлиента).Организация = &Организация";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"И &УсловиеОтбораОрганизацияЗаказыКлиентов", УсловиеОтбора);
		
		УсловиеОтбора = "
		|		И ВЫРАЗИТЬ(РаспоряженияНаОформление.Ссылка КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).Организация = &Организация";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"И &УсловиеОтбораОрганизацияЗаявкиНаВозврат", УсловиеОтбора);
		
		УсловиеОтбора = "
		|		ВЫБОР
		|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.РеализацияТоваровУслуг
		|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.РеализацияТоваровУслуг).Организация
		|			&УсловиеОтбораПоОрганизацииПередачи
		|		КОНЕЦ = &Организация";
		
		Если Не ИспользуютсяПередачиНаХранение Тогда
			УсловиеОтбора = СтрЗаменить(УсловиеОтбора, "&УсловиеОтбораПоОрганизацииПередачи", "");
		Иначе
			УсловиеОтбораПоОрганизацииПередачи = "
			|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ПередачаТоваровХранителю
			|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ПередачаТоваровХранителю).Организация";
			УсловиеОтбора = СтрЗаменить(УсловиеОтбора, "&УсловиеОтбораПоОрганизацииПередачи", УсловиеОтбораПоОрганизацииПередачи);
		КонецЕсли;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&УсловиеОтбораОрганизацияТоварыКОтгрузке", УсловиеОтбора);
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"И &УсловиеОтбораОрганизацияЗаказыКлиентов", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"И &УсловиеОтбораОрганизацияТоварыКОтгрузке", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"И &УсловиеОтбораОрганизацияЗаявкиНаВозврат", "");
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область Локализация

Процедура ДополнитьМассивМенеджеровРасчетаСмТакжеВРаботеЛокализация(МассивМенеджеровРасчетаСмТакжеВРаботе)
	
	//++ Локализация
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Документ.ТранспортнаяНакладная");
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Обработка.ЖурналДокументовНДС");
	//-- Локализация
	
	Возврат;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
