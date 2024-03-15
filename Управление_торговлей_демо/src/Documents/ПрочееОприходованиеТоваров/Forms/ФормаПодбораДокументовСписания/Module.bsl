#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	Организация = Неопределено;
	Подразделение = Неопределено;
	Если Параметры.Свойство("Отбор") Тогда
		Параметры.Отбор.Свойство("Организация", Организация);
		Параметры.Отбор.Свойство("Подразделение", Подразделение);
		Элементы.ТекстОтбора.Видимость = Истина;
		ТекстОтбора = НСтр("ru = 'Организация: %1, Подразделение: %2'");
		ТекстОтбора = СтрЗаменить(ТекстОтбора, "%1", Строка(Организация));
		ТекстОтбора = СтрЗаменить(ТекстОтбора, "%2", Строка(Подразделение));
		
		Если Параметры.Отбор.Свойство("НаправлениеДеятельности", НаправлениеДеятельности)
			И Не ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
			
				Если ЗначениеЗаполнено(НаправлениеДеятельности) Тогда
					ТекстОтбора = ТекстОтбора + ", " + НСтр("ru = 'Направление деятельности: %1'");
					ТекстОтбора = СтрЗаменить(ТекстОтбора, "%1", Строка(НаправлениеДеятельности));
				Иначе
					ТекстОтбора = ТекстОтбора + ", " + НСтр("ru = 'Без указания направления деятельности'");
				КонецЕсли;
			
		КонецЕсли;
		
		Элементы.ТекстОтбора.Заголовок = ТекстОтбора;
		
	КонецЕсли;
	Элементы.СписокХарактеристика.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ВосстановитьНастройки();
	ЗаполнитьСписок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	СохранитьНастройкиИЗаполнитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	СохранитьНастройкиИЗаполнитьСписок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиТоварыИзДокументов(Команда)
	
	ПоместитьТоварыВХранилище();
	ОповеститьОВыборе(Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьДокументы(Команда)
	
	Для Каждого Строка Из Список Цикл
		Строка.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьДокументы(Команда)
	
	Для Каждого Строка Из Список Цикл
		Строка.Выбран = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыПериода   = Новый Структура("ДатаНачала, ДатаОкончания", "НачалоПериода", "КонецПериода");
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	
	ОбщегоНазначенияУТКлиент.РедактироватьПериод(
		ЭтаФорма, ПараметрыПериода, ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма,
																			"СписокХарактеристика",
																			"Список.ХарактеристикиИспользуются");
	
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, "СписокЕдиницаИзмерения", "Список.Упаковка");

КонецПроцедуры

&НаКлиенте
// Процедура получает результат выбора периода и заполняет список.
//
// Параметры:
//  РезультатВыбора - Структура - результат выбора периода
//  ДопПараметры - Структура - дополнительные параметры, передаваемые в процедуру.
//
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьТоварыВХранилище() 
	
	Товары = Список.Выгрузить(Новый Структура("Выбран", Истина), "Выбран, Номенклатура, Характеристика, СтатьяРасходов, АналитикаРасходов, СписаниеНаРасходы, Упаковка, ЕдиницаИзмерения, КоличествоУпаковок");
	
	АдресТоваровВХранилище = ПоместитьВоВременноеХранилище(Товары, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписок()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Т.Номенклатура,
	|	Т.Характеристика,
	|	ВЫБОР
	|		КОГДА СпрНоменклатура.ИспользованиеХарактеристик В (ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры), ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры), ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры))
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ВЫБОР
	|				КОГДА Т.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|					ТОГДА ЛОЖЬ
	|				ИНАЧЕ ИСТИНА
	|			КОНЕЦ
	|	КОНЕЦ КАК ХарактеристикиИспользуются,
	|	Т.СтатьяРасходов,
	|	Т.АналитикаРасходов,
	|	Док.Ответственный,
	|	Т.Ссылка КАК СписаниеНаРасходы,
	|	Док.Дата,
	|	Док.Склад,
	|	Т.Упаковка,
	|	Т.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(Т.КоличествоУпаковок) КАК КоличествоУпаковок
	|ИЗ
	|	Документ.ВнутреннееПотребление.Товары КАК Т
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВнутреннееПотребление КАК Док
	|		ПО Т.Ссылка = Док.Ссылка
	|			И (Док.Организация = НЕОПРЕДЕЛЕНО
	|				ИЛИ Док.Организация = &Организация)
	|			И (&Подразделение = НЕОПРЕДЕЛЕНО
	|				ИЛИ Док.Подразделение = &Подразделение)
	|			И Док.НаправлениеДеятельности = &НаправлениеДеятельности
	|			И (Док.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеТоваровПоТребованию))
	|			И (Док.Дата МЕЖДУ &НачалоПериода И &КонецПериода)
	|			И (Док.Проведен)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО Т.Номенклатура = СпрНоменклатура.Ссылка
	|ГДЕ
	|	НЕ Т.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.Номенклатура,
	|	Т.Характеристика,
	|	ВЫБОР
	|		КОГДА СпрНоменклатура.ИспользованиеХарактеристик В (ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры), ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры), ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры))
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ВЫБОР
	|				КОГДА Т.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|					ТОГДА ЛОЖЬ
	|				ИНАЧЕ ИСТИНА
	|			КОНЕЦ
	|	КОНЕЦ,
	|	Т.СтатьяРасходов,
	|	Т.АналитикаРасходов,
	|	Док.Ответственный,
	|	Т.Ссылка,
	|	Док.Дата,
	|	Док.Склад,
	|	Т.Упаковка,
	|	Т.Номенклатура.ЕдиницаИзмерения";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("НаправлениеДеятельности", НаправлениеДеятельности);
	Если НЕ ЗначениеЗаполнено(НачалоПериода) Тогда
		НачалоПериода = НачалоМесяца(НачалоМесяца(ТекущаяДатаСеанса()) - 1);
		Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Иначе
		Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(НачалоПериода));
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода = КонецМесяца(ТекущаяДатаСеанса());
		Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Иначе
		Запрос.УстановитьПараметр("КонецПериода", КонецДня(КонецПериода));
	КонецЕсли;
	Список.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()
	
	ЗначениеНастроек = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Документ.ВнутреннееПотребление", "ПодборДокументовСписания");
	
	НачалоПериода = '00010101';
	КонецПериода  = '00010101';
	Если ТипЗнч(ЗначениеНастроек) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ЗначениеНастроек);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиИЗаполнитьСписок()
	
	ИменаСохраняемыхРеквизитов = "НачалоПериода,КонецПериода";
	
	Настройки = Новый Структура(ИменаСохраняемыхРеквизитов);
	ЗаполнитьЗначенияСвойств(Настройки, ЭтаФорма);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Документ.ВнутреннееПотребление", "ПодборДокументовСписания", Настройки);
	
	ЗаполнитьСписок();
	
КонецПроцедуры

#КонецОбласти









