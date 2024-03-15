
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	Организация = Параметры.Организация;
	ЗаполнитьДокументыРеализации(Параметры.АдресТаблицыРеализацийКомиссионныхТоваров);
	
	СписокТипов = Новый Массив;
	Для каждого ТипДокумента Из ДокументыРеализации Цикл
		СписокТипов.Добавить(ТипЗнч(ТипДокумента.Ссылка));
	КонецЦикла;
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов(СписокТипов);
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ДокументыРеализацииКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОформленныеСчетаФактуры = Новый Соответствие();
	
	Для каждого Строка Из ДокументыРеализации Цикл
		Если ЗначениеЗаполнено(Строка.СчетФактура) Тогда
			ОформленныеСчетаФактуры.Вставить(Строка.Ссылка, Строка.СчетФактура);
		КонецЕсли;
	КонецЦикла;
	
	ОповеститьОВыборе(ОформленныеСчетаФактуры);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДокументыРеализации

&НаКлиенте
Процедура ДокументыРеализацииПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ДокументыРеализацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущийЭлемент.Имя = "ДокументыРеализацииДокументРеализации" Тогда
		ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.Ссылка);
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "ДокументыРеализацииСчетФактура"
			И ЗначениеЗаполнено(Элемент.ТекущиеДанные.СчетФактура) Тогда
		ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.СчетФактура);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОформитьСчетаФактуры(Команда)
	
	ОформитьСчетаФактурыСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДокументыРеализацииСчетФактура.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДокументыРеализации.СчетФактура");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<отсутствует>'"));

	//

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументыРеализации(АдресДокументовРеализации)

	ТаблицаДокументов = ПолучитьИзВременногоХранилища(АдресДокументовРеализации);
		
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДокументыРеализации.Ссылка КАК Ссылка,
	|	ДокументыРеализации.Дата КАК Дата,
	|	ДокументыРеализации.Сумма КАК Сумма,
	|	ДокументыРеализации.Валюта КАК Валюта,
	|	ДокументыРеализации.Партнер КАК Партнер,
	|	ДокументыРеализации.Контрагент КАК Контрагент
	|
	|ПОМЕСТИТЬ втДокументыРеализации
	|ИЗ
	|	&ТаблицаДокументов КАК ДокументыРеализации
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументыРеализации.Ссылка КАК Ссылка,
	|	ДокументыРеализации.Дата КАК Дата,
	|	ДокументыРеализации.Сумма КАК Сумма,
	|	ДокументыРеализации.Валюта КАК Валюта,
	|	ДокументыРеализации.Партнер КАК Партнер,
	|	ДокументыРеализации.Контрагент КАК Контрагент
	|
	|ИЗ
	|	втДокументыРеализации КАК ДокументыРеализации
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.СчетФактураВыданный.ДокументыОснования КАК ДанныеСчетаФактуры
	|	ПО
	|		ДокументыРеализации.Ссылка = ДанныеСчетаФактуры.ДокументОснование
	|		И НЕ ДанныеСчетаФактуры.Ссылка.ПометкаУдаления
	|
	|ГДЕ
	|	ДанныеСчетаФактуры.Ссылка ЕСТЬ NULL
	|		И ДокументыРеализации.Контрагент.ЮрФизЛицо <> ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументыРеализации.Дата
	|");
	Запрос.УстановитьПараметр("ТаблицаДокументов", ТаблицаДокументов);
	
	ДокументыРеализации.Загрузить(Запрос.Выполнить().Выгрузить()); 
	
КонецПроцедуры

&НаСервере
Процедура ОформитьСчетаФактурыСервер()
	
	Для Каждого ИндексСтроки Из Элементы.ДокументыРеализации.ВыделенныеСтроки Цикл
		
		СтрокаТаблицы = ДокументыРеализации.НайтиПоИдентификатору(ИндексСтроки);
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.СчетФактура) Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеСчетаФактуры = Новый Структура;
		ДанныеСчетаФактуры.Вставить("ДокументОснование", СтрокаТаблицы.Ссылка);
		ДанныеСчетаФактуры.Вставить("Организация", Организация);
		ДанныеСчетаФактуры.Вставить("Дата", СтрокаТаблицы.Дата);
		
		ДокументОбъект = Документы.СчетФактураВыданный.СоздатьДокумент();
		ДокументОбъект.Заполнить(ДанныеСчетаФактуры);
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		СтрокаТаблицы.СчетФактура = ДокументОбъект.Ссылка;
		
	КонецЦикла;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.ДокументыРеализации);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.ДокументыРеализации, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.ДокументыРеализации);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти