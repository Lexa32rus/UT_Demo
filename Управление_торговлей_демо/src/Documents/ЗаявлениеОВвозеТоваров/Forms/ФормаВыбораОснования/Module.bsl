#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДокументыПоступления.Параметры.УстановитьЗначениеПараметра("Организация",	Параметры.Организация);
	ДокументыПоступления.Параметры.УстановитьЗначениеПараметра("Контрагент",	Параметры.Контрагент);
	ДокументыПоступления.Параметры.УстановитьЗначениеПараметра("Договор",		Параметры.Договор);
	ДокументыПоступления.Параметры.УстановитьЗначениеПараметра("МассивВыбранныхДокументов", Параметры.МассивВыбранныхДокументов);
	ДокументыПоступления.Параметры.УстановитьЗначениеПараметра("Ссылка",		Параметры.Ссылка);
	Если Параметры.Свойство("ТекущийДокумент") Тогда
		Элементы.ДокументыПоступления.ТекущаяСтрока = Параметры.ТекущийДокумент;
	КонецЕсли;

	УстановитьУсловноеОформление();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	 ОбработкаВыбораЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Уже выбранные документы отображаем серым цветом.
	ЭлементУО			= УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента 		= ЭлементУО.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных("ДокументыПоступления");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ДокументыПоступления.ДокументУжеВыбран", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

КонецПроцедуры

&НаКлиенте
Процедура ДокументыПоступленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбработкаВыбораЗначения();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораЗначения()
	
	МассивДокументов = Новый Массив;
	
	ТаблицаДокументов = Элементы.ДокументыПоступления;
	
	Для каждого ИндексСтроки Из ТаблицаДокументов.ВыделенныеСтроки Цикл
	
		СтрокаТаблицыВыбора = ТаблицаДокументов.ДанныеСтроки(ИндексСтроки);
		Если СтрокаТаблицыВыбора.ДокументУжеВыбран Тогда 
			ТекстПредупреждения = СтрЗаменить(НСтр("ru='Документ %Документ% уже выбран'"), "%Документ%", Строка(СтрокаТаблицыВыбора.Ссылка));
			ПоказатьПредупреждение( , ТекстПредупреждения);
			Возврат;
		КонецЕсли;
		
		МассивДокументов.Добавить(СтрокаТаблицыВыбора);
	
	КонецЦикла; 
	
	ОповеститьОВыборе(МассивДокументов);
	
КонецПроцедуры

#КонецОбласти