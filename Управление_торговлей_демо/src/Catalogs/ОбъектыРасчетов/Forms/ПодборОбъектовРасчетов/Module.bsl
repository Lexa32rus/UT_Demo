
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОбновлениеИнформационнойБазы.ОтложенноеОбновлениеЗавершено() Тогда
		Текст = НСтр("ru = 'Список объектов расчетов может быть неполным или неточным, т.к. не завершен переход на новую версию.'");
		ОбщегоНазначения.СообщитьПользователю(Текст);
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	ОбъектСсылка         = Параметры.ОбъектСсылка;
	ТипРасчетов          = Параметры.ТипРасчетов;
	ВалютаВзаиморасчетов = Параметры.ВалютаВзаиморасчетов;
	Организация          = Параметры.Организация;
	Партнер              = Параметры.Партнер;
	Если ЗначениеЗаполнено(Партнер) Тогда
		Элементы.Партнер.Доступность = Ложь;
	КонецЕсли;
	Контрагент           = Параметры.Контрагент;
	Если ЗначениеЗаполнено(Контрагент) Тогда
		Элементы.Контрагент.Доступность = Ложь;
	КонецЕсли;
	ИдентификаторПлатежа = Параметры.ИдентификаторПлатежа;
	
	СуммаДокумента = Параметры.СуммаДокумента;
	ВалютаДокумента = Параметры.ВалютаДокумента;
	
	ДатаДокумента  = Параметры.ДатаДокумента;
	ОднаВалютаВзаиморасчетов = ?(Параметры.Свойство("ОднаВалютаВзаиморасчетов"),Параметры.ОднаВалютаВзаиморасчетов,Ложь);
	
	АдресПлатежейВХранилище = Параметры.АдресПлатежейВХранилище;
	ПартнерПрочиеОтношения = Параметры.ПартнерПрочиеОтношения;
	ПодборДебиторскойЗадолженности = Параметры.ПодборДебиторскойЗадолженности;
	ПодборТолькоБезусловнойЗадолженности = Параметры.ПодборТолькоБезусловнойЗадолженности;
	УчитыватьФилиалы = Параметры.УчитыватьФилиалы;
	
	Если Контрагент = Неопределено Тогда
		Контрагент = Справочники.Контрагенты.ПустаяСсылка();
	КонецЕсли;
	
	// ДополнительныеОтборы - это соответствие, поэтому для кэширования отборов в реквизите формы используется список значений
	Если Параметры.ДополнительныеОтборы <> Неопределено Тогда
		Для Каждого КлючИЗначение Из Параметры.ДополнительныеОтборы Цикл
			ПараметрДополнительныеОтборы.Добавить(КлючИЗначение.Значение, КлючИЗначение.Ключ);
		КонецЦикла;
	КонецЕсли;
	ПараметрДополнительныеОтборы.Добавить(Ложь, "ПометкаУдаления");
	ЗаполнитьТаблицуПоРасчетамСПартнерами();
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если СуммаДокумента = 0 Тогда 
		ПодбиратьНаСумму = Ложь;
	КонецЕсли;
	
	РассчитатьСуммуПлатежей();
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	ЗаполнитьТаблицуПоРасчетамСПартнерами();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ЗаполнитьТаблицуПоРасчетамСПартнерами();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОстатковРасчетовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьСуммуПлатежей();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОстатковРасчетовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ТаблицаОстатковРасчетовОбъектРасчетов" Тогда
		СтрокаТаблицы = Элементы.ТаблицаОстатковРасчетов.ТекущиеДанные;
		Если СтрокаТаблицы <> Неопределено И ЗначениеЗаполнено(СтрокаТаблицы.ОбъектРасчетов) Тогда
			ПоказатьЗначение(Неопределено, СтрокаТаблицы.ОбъектРасчетов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОстатковРасчетовВыбранПриИзменении(Элемент)
	
	РассчитатьПодборНаСумму();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()

	ПоместитьПлатежиВХранилище();
	Структура = Новый Структура("АдресПлатежейВХранилище", АдресПлатежейВХранилище);
	Структура.Вставить("ХозяйственнаяОперация", ?(ПодборДебиторскойЗадолженности, 
		ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.СписаниеДебиторскойЗадолженности"),
		ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.СписаниеКредиторскойЗадолженности")));
	Закрыть(Структура);
	
	ОповеститьОВыборе(Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПлатежиВыполнить()

	Для Каждого СтрокаТаблицы Из ТаблицаОстатковРасчетов Цикл
		СтрокаТаблицы.Выбран = Истина;
	КонецЦикла;
	РассчитатьСуммуПлатежей();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьПлатежиВыполнить()

	Для Каждого СтрокаТаблицы Из ТаблицаОстатковРасчетов Цикл
		СтрокаТаблицы.Выбран = Ложь
	КонецЦикла;
	РассчитатьСуммуПлатежей();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыделенныеПлатежи(Команда)
	
	МассивСтрок = Элементы.ТаблицаОстатковРасчетов.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаОстатковРасчетов.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Истина;
		КонецЕсли;
	КонецЦикла;
	РассчитатьСуммуПлатежей();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенныеПлатежи(Команда)
	
	МассивСтрок = Элементы.ТаблицаОстатковРасчетов.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаОстатковРасчетов.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Ложь;
		КонецЕсли;
	КонецЦикла;
	РассчитатьСуммуПлатежей();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаОстатковРасчетов.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаОстатковРасчетов.Выбран");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.RosyBrown);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаОстатковРасчетовИдентификаторПлатежа.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаОстатковРасчетов.ИдентификаторПлатежа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = СокрЛП(ИдентификаторПлатежа);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаОстатковРасчетов.ИдентификаторПлатежа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ЦветМорскойВолны);
	
КонецПроцедуры

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УстановитьВидимость()
	
	МассивЭлементов = Новый Массив;
	
	Если ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом Тогда
		Если ПодборДебиторскойЗадолженности Тогда
			МассивЭлементов.Добавить("ТаблицаОстатковРасчетовНашДолг");
			МассивЭлементов.Добавить("ТаблицаОстатковРасчетовВалютаВзаиморасчетовНашДолг");
		Иначе
			МассивЭлементов.Добавить("ТаблицаОстатковРасчетовДолгПартнера");
			МассивЭлементов.Добавить("ТаблицаОстатковРасчетовКОплате");
			МассивЭлементов.Добавить("ТаблицаОстатковРасчетовВалютаВзаиморасчетовДолгПартнера");
			МассивЭлементов.Добавить("ТаблицаОстатковРасчетовВалютаВзаиморасчетов");
		КонецЕсли;
	ИначеЕсли ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСПоставщиком Тогда
		Если НЕ ПодборДебиторскойЗадолженности Тогда
			МассивЭлементов.Добавить("ТаблицаОстатковРасчетовДолгПартнера");
			МассивЭлементов.Добавить("ТаблицаОстатковРасчетовВалютаВзаиморасчетовДолгПартнера");
		Иначе
			МассивЭлементов.Добавить("ТаблицаОстатковРасчетовНашДолг");
			МассивЭлементов.Добавить("ТаблицаОстатковРасчетовКОплате");
			МассивЭлементов.Добавить("ТаблицаОстатковРасчетовВалютаВзаиморасчетовНашДолг");
			МассивЭлементов.Добавить("ТаблицаОстатковРасчетовВалютаВзаиморасчетов");
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(
		Элементы, МассивЭлементов, "Видимость", Ложь);

	
	Если ТипЗнч(Контрагент) = Тип("СправочникСсылка.Организации") Тогда
		Заголовок = НСтр("ru = 'Подбор по расчетам между организациями'");
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
		ЭтотОбъект, "ТаблицаОстатковРасчетовДолгПартнера", НСтр("ru = 'Долг контрагента'"));
	
	ЕстьФилиалы = Справочники.Организации.ФилиалыСРасчетамиЧерезГоловнуюОрганизацию(Организация).Количество() > 0;
	Элементы.ТаблицаОстатковРасчетовОрганизация.Видимость = ЕстьФилиалы;
	
	Если СуммаДокумента = 0 Тогда
		Элементы.СуммаДокумента.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПоместитьПлатежиВХранилище()
	
	Платежи = ТаблицаОстатковРасчетов.Выгрузить(, "Выбран, Сумма, ОбъектРасчетов, ВалютаВзаиморасчетов, Партнер, Контрагент, Договор, Организация, ДолгПартнера, НашДолг, ТипРасчетов, СтатьяДвиженияДенежныхСредств");
	
	сч = 0;
	Пока сч < Платежи.Количество() Цикл
		Если Не Платежи[сч].Выбран Тогда
			Платежи.Удалить(сч);
		Иначе 
			сч = сч + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если Платежи.Итог("Сумма") < СуммаДокумента И СуммаДокумента > 0 Тогда
		СтрокаТаблицы = Платежи.Добавить();
		СтрокаТаблицы.Сумма = СуммаДокумента - Платежи.Итог("Сумма");
		Если ЗначениеЗаполнено(Партнер) Тогда
			СтрокаТаблицы.Партнер = Партнер;
		Иначе
			СтрокаТаблицы.Партнер = ДенежныеСредстваСервер.ПолучитьПартнераПоКонтрагенту(Контрагент);
		КонецЕсли;
		СтрокаТаблицы.ОбъектРасчетов = ОбъектыРасчетовСервер.ПолучитьОбъектРасчетовПоСсылке(ОбъектСсылка);
	КонецЕсли;
	
	ОплатаОтКлиента = (ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом);
	
	ТаблицаНДС = ДенежныеСредстваСервер.РасшифровкаПлатежаНДС(Организация, ДатаДокумента, ВалютаДокумента, Платежи.ВыгрузитьКолонку("ОбъектРасчетов"), ОплатаОтКлиента);
	ДенежныеСредстваСервер.ЗаполнитьНДСВРасшифровке(Платежи, ТаблицаНДС);
	
	Платежи.Колонки.Добавить("ОснованиеПлатежа");
	ОбъектыРасчетов = Платежи.ВыгрузитьКолонку("ОбъектРасчетов");
	Объекты = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ОбъектыРасчетов, "Объект");
	Для Каждого Стр Из Платежи Цикл
		Стр.ОснованиеПлатежа = Объекты[Стр.ОбъектРасчетов] 
	КонецЦикла;
	
	АдресПлатежейВХранилище = ПоместитьВоВременноеХранилище(Платежи, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПоРасчетамСПартнерами()
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("Дата", ДатаДокумента);
	Реквизиты.Вставить("Организация", Организация);
	Реквизиты.Вставить("СуммаДокумента", СуммаДокумента);
	Реквизиты.Вставить("Валюта", ВалютаДокумента);
	Реквизиты.Вставить("Контрагент", Контрагент);
	Реквизиты.Вставить("Партнер", Партнер);
	
	Если ЗначениеЗаполнено(ТипРасчетов) Тогда
		Реквизиты.Вставить("ТипРасчетов", ТипРасчетов);
	КонецЕсли;
	
	Реквизиты.Вставить("ПартнерПрочиеОтношения", ПартнерПрочиеОтношения);
	Реквизиты.Вставить("ПодборДебиторскойЗадолженности", ПодборДебиторскойЗадолженности);
	Реквизиты.Вставить("ПодборТолькоБезусловнойЗадолженности", ПодборТолькоБезусловнойЗадолженности);
	
	Реквизиты.Вставить("УчитыватьФилиалы", УчитыватьФилиалы);
	
	ДополнительныеОтборы = Новый Соответствие();
	Для Каждого ЭлементСписка Из ПараметрДополнительныеОтборы Цикл
		ДополнительныеОтборы.Вставить(ЭлементСписка.Представление, ЭлементСписка.Значение);
	КонецЦикла;
	
	ВзаиморасчетыСервер.ЗаполнитьТаблицуОстатковРасчетов(Реквизиты, АдресПлатежейВХранилище, ТаблицаОстатковРасчетов, ДополнительныеОтборы);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	КурсыВалютыРасчетов.Валюта КАК Валюта,
	|	КурсыВалют.КурсЧислитель * ЕСТЬNULL(КурсыВалютыРасчетов.КурсЗнаменатель,1) 
	|		/ (КурсыВалют.КурсЗнаменатель * ЕСТЬNULL(КурсыВалютыРасчетов.КурсЧислитель,1)) КАК Коэффициент
	|ИЗ
	|	РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалют
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалютыРасчетов
	|			ПО КурсыВалютыРасчетов.Валюта В (&ВалютыРасчетов)
	|ГДЕ КурсыВалют.Валюта = &ВалютаДокумента";
	Запрос.УстановитьПараметр("Дата",ДатаДокумента);
	Запрос.УстановитьПараметр("ВалютаДокумента",ВалютаДокумента);
	Запрос.УстановитьПараметр("ВалютыРасчетов",ТаблицаОстатковРасчетов.Выгрузить(,"ВалютаВзаиморасчетов").ВыгрузитьКолонку("ВалютаВзаиморасчетов"));
	Запрос.УстановитьПараметр("БазоваяВалюта", ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация));
	КоэффициентыПересчета.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуПлатежей()
	
	РассчитатьПодборНаСумму();
	
	СуммаПлатежей = 0;
	Для Каждого СтрокаТаблицы Из ТаблицаОстатковРасчетов Цикл
		
		Если СтрокаТаблицы.Выбран Тогда
			СуммаПлатежей = СуммаПлатежей + СтрокаТаблицы.Сумма;
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(ВалютаВзаиморасчетов) Тогда
		Если СуммаПлатежей = 0 Тогда
			Элементы.ТаблицаОстатковРасчетов.ОтборСтрок = Новый ФиксированнаяСтруктура();
		ИначеЕсли ОднаВалютаВзаиморасчетов Тогда
			ОтборСтрок = Новый ФиксированнаяСтруктура("ВалютаВзаиморасчетов", Элементы.ТаблицаОстатковРасчетов.ТекущиеДанные.ВалютаВзаиморасчетов);
			Элементы.ТаблицаОстатковРасчетов.ОтборСтрок = ОтборСтрок;
		КонецЕсли;
	Иначе
		ОтборСтрок = Новый ФиксированнаяСтруктура("ВалютаВзаиморасчетов", ВалютаВзаиморасчетов);
		Элементы.ТаблицаОстатковРасчетов.ОтборСтрок = ОтборСтрок;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	Если СуммаДокумента = 0 Тогда 
		Элементы.ПодбиратьНаСумму.Видимость = Ложь;
	Иначе
		ПредставлениеЛожь = НСтр("ru = 'без ограничения'");
		ПредставлениеИстина = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'на сумму %1 %2'"), СуммаДокумента, ВалютаДокумента);
		
		Элементы.ПодбиратьНаСумму.ФорматРедактирования = "БЛ='"+ПредставлениеЛожь+"'; БИ='"+ПредставлениеИстина+"'";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьПодборНаСумму()
	
	Если ПодбиратьНаСумму Тогда
		Если Элементы.ТаблицаОстатковРасчетов.ТекущаяСтрока <> Неопределено Тогда
			ТекущаяСтрока = ТаблицаОстатковРасчетов.НайтиПоИдентификатору(Элементы.ТаблицаОстатковРасчетов.ТекущаяСтрока);
		Иначе
			ВыбранныеСтроки = ТаблицаОстатковРасчетов.НайтиСтроки(Новый Структура("Выбран", Истина));
			Если ВыбранныеСтроки.Количество() = 0 Тогда
				Возврат;
			КонецЕсли;
			ТекущаяСтрока = ВыбранныеСтроки[ВыбранныеСтроки.Количество()-1]; // выбираем последнюю
		КонецЕсли;
		Выбрать = СуммаДокумента;
		Найдена = Ложь;
		Для Каждого Стр Из ТаблицаОстатковРасчетов Цикл
			
			Если Стр = ТекущаяСтрока Тогда
				Найдена = Истина;
				Если НЕ Стр.Выбран Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			Если НЕ Найдена Тогда
				Если Стр.Выбран Тогда
					Выбрать = Выбрать - Стр.Сумма;
				КонецЕсли;
				Продолжить;
			КонецЕсли;
			
			Если Стр.ВалютаВзаиморасчетов = ВалютаДокумента Тогда
				КОплате = Стр.КОплате;
			Иначе
				Для Каждого Строка Из КоэффициентыПересчета Цикл
					Если Строка.Валюта = Стр.ВалютаВзаиморасчетов Тогда
						КОплате = Стр.КОплате / Строка.Коэффициент;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
				
			Если Выбрать = 0 Тогда
				Стр.Выбран = Ложь;
			ИначеЕсли Выбрать < КОплате Тогда
				Стр.Сумма =Выбрать;
				Стр.Выбран = Истина;
				Выбрать = 0;
			ИначеЕсли КОплате > 0 Тогда
				Стр.Сумма = КОплате;
				Стр.Выбран = Истина;
				Выбрать = Выбрать - Стр.Сумма;
			КонецЕсли;
				
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
