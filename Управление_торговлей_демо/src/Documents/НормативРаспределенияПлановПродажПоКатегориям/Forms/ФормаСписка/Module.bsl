#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
	
		Возврат;
	
	КонецЕсли;
	
	
	Элементы.ОтборОтветственный.ИсторияВыбораПриВводе = ИсторияВыбораПриВводе.НеИспользовать;
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.ОтборОтветственный.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.НормативРаспределенияПлановПродажПоКатегориям));
		
	УстановитьДоступность(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, СтандартнаяОбработка, Отказ);
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);


	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ТоварнаяКатегория  = Настройки.Получить("ТоварнаяКатегория");
	Если ЗначениеЗаполнено(ТоварнаяКатегория) Тогда
		Реквизит = Настройки.Получить("Реквизит");
	Иначе
		Реквизит = Неопределено;
	КонецЕсли; 
	
	Ответственный = Настройки.Получить("Ответственный");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ТоварнаяКатегория",  ТоварнаяКатегория, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ТоварнаяКатегория));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Реквизит",  Реквизит, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Реквизит));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ответственный",  Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
	УстановитьДоступность(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборТоварнаяКатегорияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ТоварнаяКатегория",  ТоварнаяКатегория, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ТоварнаяКатегория));
	
	УстановитьДоступность(ЭтаФорма);
	
	Если ЗначениеЗаполнено(ТоварнаяКатегория) Тогда
	
		ЗаполнитьСписокРеквизитов();
		
	Иначе
		
		Реквизит = Неопределено;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Реквизит",  Реквизит, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Реквизит));
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборРеквизитПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Реквизит",  Реквизит, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Реквизит));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ответственный",  Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
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

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура БлокировкуНормативаПоРеквизиту(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Операция", ПредопределенноеЗначение("Перечисление.ОперацииНормативовРаспределения.БлокировкаНорматива"));
	ЗначенияЗаполнения.Вставить("ТоварнаяКатегория", ТоварнаяКатегория);
	ЗначенияЗаполнения.Вставить("Реквизит", Реквизит);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.НормативРаспределенияПлановПродажПоКатегориям.ФормаОбъекта", ПараметрыФормы, ЭтаФорма); 
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступность(Форма)

	Если ЗначениеЗаполнено(Форма.ТоварнаяКатегория) Тогда
	
		Форма.Элементы.ОтборРеквизит.Доступность = Истина;
	
	Иначе
	
		Форма.Элементы.ОтборРеквизит.Доступность = Ложь;
	
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРеквизитов()

	СтруктураРеквизитов = Документы.НормативРаспределенияПлановПродажПоКатегориям.ПолучитьРеквизитыДляНормативов();
	
	Элементы.ОтборРеквизит.СписокВыбора.Очистить();
	Для каждого КлючЗначение Из СтруктураРеквизитов Цикл
		Элементы.ОтборРеквизит.СписокВыбора.Добавить(КлючЗначение.Ключ, КлючЗначение.Значение.Представление);
	КонецЦикла; 
	
	СписокДопРеквизитов = Документы.НормативРаспределенияПлановПродажПоКатегориям.ПолучитьДополнительныеРеквизитыДляНормативов(ТоварнаяКатегория);
	
	Для каждого ЭлементСписка Из СписокДопРеквизитов Цикл
		Элементы.ОтборРеквизит.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;

КонецПроцедуры 

#КонецОбласти
