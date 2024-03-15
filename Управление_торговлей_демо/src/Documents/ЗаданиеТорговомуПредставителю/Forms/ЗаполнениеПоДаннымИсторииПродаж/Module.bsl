#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ДетализацияПоНоменклатуре = Параметры.ДетализацияПоНоменклатуре;
	Партнер = Параметры.Партнер;
	Контрагент = Параметры.Контрагент;
	
	СформироватьНастройкиКомпоновщика();
	
	Период = "в среднем за день";
	
	Элементы.ДетализацияПоХарактеристикам.Видимость = ДетализацияПоНоменклатуре;

	Элементы.Период.СписокВыбора.Очистить();
	СформироватьСписокПериодов();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПериодОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СтруктураРезультата = Новый  Структура;
	СтруктураРезультата.Вставить("Период", Период);
	СтруктураРезультата.Вставить("НачалоПериода", ПериодАнализаИсторииПродаж.ДатаНачала);
	СтруктураРезультата.Вставить("КонецПериода", ПериодАнализаИсторииПродаж.ДатаОкончания);
	СтруктураРезультата.Вставить("Настройки", НастройкиКомпоновщика());
	СтруктураРезультата.Вставить("ДетализацияПоХарактеристикам", ДетализацияПоХарактеристикам);
	
	Закрыть(СтруктураРезультата);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодАнализаИсторииПродаж()
	
	ВыборПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыборПериода()

	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = ПериодАнализаИсторииПродаж;
	Диалог.Показать(Новый ОписаниеОповещения("ВыборПериодаЗавершение", ЭтотОбъект, Новый Структура("Диалог", Диалог)));

КонецПроцедуры

&НаКлиенте
Процедура ВыборПериодаЗавершение(Период1, ДополнительныеПараметры) Экспорт
    
    Диалог = ДополнительныеПараметры.Диалог;
        
    Если Период1 <> Неопределено Тогда 
        ПериодАнализаИсторииПродаж = Диалог.Период;		
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СформироватьСписокПериодов()

	Элементы.Период.СписокВыбора.Добавить("в среднем за день", НСтр("ru = 'в среднем за день'"));
    Элементы.Период.СписокВыбора.Добавить("в среднем за неделю", НСтр("ru = 'в среднем за неделю'"));
    Элементы.Период.СписокВыбора.Добавить("в среднем за месяц", НСтр("ru = 'в среднем за месяц'"));

КонецПроцедуры

&НаСервере
Процедура СформироватьНастройкиКомпоновщика()
	
	Если ДетализацияПоНоменклатуре Тогда
		СхемаКомпоновки = Документы.ЗаданиеТорговомуПредставителю.ПолучитьМакет("СхемаКомпоновкиДляАвтоматическогоЗаполненияПоИсторииПродаж");
	Иначе
		СхемаКомпоновки = Документы.ЗаданиеТорговомуПредставителю.ПолучитьМакет("СхемаКомпоновкиДляАвтоматическогоЗаполненияПоИсторииПродажПоСумме");
	КонецЕсли;	

	НастройкиКомпоновки = СхемаКомпоновки.НастройкиПоУмолчанию;
	
	Адрес = Новый УникальныйИдентификатор();
	URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновки, Адрес);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
	
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновки);
	ПартнерыИКонтрагенты.УдалитьЭлементИзНастроекОтборовОтчета(КомпоновщикНастроек, "Контрагент");
	УстановитьЗначенияЭлементовОтбора(КомпоновщикНастроек.Настройки.Отбор);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияЭлементовОтбора(Отбор)

	ПолеКомпоновкиПартнер = Новый ПолеКомпоновкиДанных("Партнер");
	ПолеКомпоновкиКонтрагент = Новый ПолеКомпоновкиДанных("Контрагент");
	
	Для Каждого ЭлементОтбора Из Отбор.Элементы Цикл
		
		Если ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновкиПартнер Тогда

            ЭлементОтбора.ПравоеЗначение = Партнер;
            ЭлементОтбора.Использование = ЗначениеЗаполнено(Партнер);

		ИначеЕсли ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновкиКонтрагент Тогда

            ЭлементОтбора.ПравоеЗначение = Контрагент;
            ЭлементОтбора.Использование = ЗначениеЗаполнено(Контрагент);

		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция НастройкиКомпоновщика()
	
	Возврат КомпоновщикНастроек.ПолучитьНастройки();
	
КонецФункции

#КонецОбласти
