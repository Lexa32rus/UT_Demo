
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СтруктураПараметрыОтбора") Тогда
		
		Если Параметры.СтруктураПараметрыОтбора.Свойство("Статус") Тогда
			
			НовыйЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			НовыйЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Статус");
			НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			НовыйЭлементОтбора.ПравоеЗначение = Параметры.СтруктураПараметрыОтбора.Статус;
			НовыйЭлементОтбора.Использование = Истина;
			
		КонецЕсли;
		
		Если Параметры.СтруктураПараметрыОтбора.Свойство("ФискальноеУстройство") Тогда
			
			НовыйЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			НовыйЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ФискальноеУстройство");
			НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			НовыйЭлементОтбора.ПравоеЗначение = Параметры.СтруктураПараметрыОтбора.ФискальноеУстройство;
			НовыйЭлементОтбора.Использование = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.Свойство("СтруктураРезультата") Тогда
		СтруктураРезультата = Параметры.СтруктураРезультата;
	Иначе
		СтруктураРезультата = Неопределено;
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
			АвтоЗаголовок = Ложь;
			Заголовок = Параметры.Заголовок;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьВыбор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	ОбработатьВыбор();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьВыбор()
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураРезультата = Неопределено Тогда
		
		ОповеститьОВыборе(Элементы.Список.ТекущиеДанные.Ссылка);
		
	Иначе
		
		СтруктураВозврата = Новый Структура();
		
		Для Каждого КлючИЗначение Из СтруктураРезультата Цикл
			СтруктураВозврата.Вставить(КлючИЗначение.Ключ, Элементы.Список.ТекущиеДанные[КлючИЗначение.Значение]);
		КонецЦикла;
		
		Закрыть(СтруктураВозврата);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
