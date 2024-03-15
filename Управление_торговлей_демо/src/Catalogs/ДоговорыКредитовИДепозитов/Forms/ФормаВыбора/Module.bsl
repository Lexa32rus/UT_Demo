
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьНедоступныеОтборыИзПараметров(Параметры.Отбор);
		
	Если Параметры.Свойство("Партнер") Тогда
		
		СписокПартнеров = Новый СписокЗначений;
		ПартнерыИКонтрагенты.ЗаполнитьСписокПартнераСРодителями(Параметры.Партнер, СписокПартнеров);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Партнер",
			СписокПартнеров,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			Истина);
		
		Список.Параметры.УстановитьЗначениеПараметра("ПартнерПоУмолчанию", Параметры.Партнер);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"ПартнерПоУмолчанию",
			Параметры.Партнер,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина);
		
	Иначе
		
		Список.Параметры.УстановитьЗначениеПараметра("ПартнерПоУмолчанию", Справочники.Партнеры.ПустаяСсылка());
		
	КонецЕсли;
		
	Если Параметры.Свойство("Контрагент") Тогда
		
		СписокПартнеров = Новый СписокЗначений;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Контрагент",
			Параметры.Контрагент,
			ВидСравненияКомпоновкиДанных.Равно
			, 
			Истина);
		
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(ЭтотОбъект, "Партнер", НСтр("ru = 'Контрагент'"));
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Процедура устанавливает отборы, переданные в структуре. Отборы недоступны для изменения.
//
// Параметры:
//	СтруктураОтбора - Структура - Ключ: имя поля компоновки данных, Значение: значение отбора.
//
&НаСервере
Процедура УстановитьНедоступныеОтборыИзПараметров(СтруктураОтбора)
	
	Для Каждого ЭлементОтбора Из СтруктураОтбора Цикл
		
		Если ТипЗнч(ЭлементОтбора.Значение) = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов")
			ИЛИ ТипЗнч(ЭлементОтбора.Значение) = Тип("ПланВидовХарактеристикСсылка.СтатьиДоходов") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЭлементОтбора.Ключ = "Контрагент" И ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список,
				"Партнер",
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементОтбора.Значение, "Партнер"),
				ВидСравненияКомпоновкиДанных.Равно);
			
			Продолжить;
			
		КонецЕсли;

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			ЭлементОтбора.Ключ,
			ЭлементОтбора.Значение,
			ВидСравненияКомпоновкиДанных.Равно);
	КонецЦикла; 
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти
