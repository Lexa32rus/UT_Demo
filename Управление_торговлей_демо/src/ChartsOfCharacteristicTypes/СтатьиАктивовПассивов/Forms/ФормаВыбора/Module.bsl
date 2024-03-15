
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	УстановитьПараметрыДинамическогоСписка();
	
	Заголовок = НСтр("ru='Статьи активов и пассивов'");
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("АктивПассив")
		И ЗначениеЗаполнено(Параметры.Отбор.АктивПассив) Тогда
		
		АктивностьСтатьи = Параметры.Отбор.АктивПассив;
		
		Актив = Перечисления.ВидыСтатейУправленческогоБаланса.Актив;
		Пассив = Перечисления.ВидыСтатейУправленческогоБаланса.Пассив;
		СтатьиАктивов = НСтр("ru='Статьи активов'");
		СтатьиПассивов = НСтр("ru='Статьи пассивов'");
		
		Если АктивностьСтатьи = Актив Тогда
			Заголовок = СтатьиАктивов;
			
		ИначеЕсли АктивностьСтатьи = Пассив Тогда
			Заголовок = СтатьиПассивов;
			
		ИначеЕсли ТипЗнч(АктивностьСтатьи) = Тип("Массив") Тогда
			Если АктивностьСтатьи.Найти(Актив) <> Неопределено Тогда
				Заголовок = СтатьиАктивов;
			ИначеЕсли АктивностьСтатьи.Найти(Пассив) <> Неопределено Тогда
				Заголовок = СтатьиПассивов;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = Список.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ФормаКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

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

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыДинамическогоСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Ссылка",
		ПланыВидовХарактеристик.СтатьиАктивовПассивов.ЗаблокированныеСтатьиАктивовПассивов(),
		ВидСравненияКомпоновкиДанных.НеВСписке);
	
КонецПроцедуры

#КонецОбласти


