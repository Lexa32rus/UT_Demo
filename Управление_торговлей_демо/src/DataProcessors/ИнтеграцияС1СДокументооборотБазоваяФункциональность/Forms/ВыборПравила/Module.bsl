#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПриСозданииНаСервереФормыВыбораПравила(
		ЭтотОбъект);
	
	Настройки = ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ИспользоватьИнтеграцию();
	ИмяТипаПравилаИнтеграцииС1СДокументооборотом3 = "СправочникСсылка.ПравилаИнтеграцииС1СДокументооборотом3";
	
	Если Настройки.ИспользоватьИнтеграциюДО3
			И Параметры.Правила.Количество() > 0
			И ТипЗнч(Параметры.Правила[0]) = Тип(ИмяТипаПравилаИнтеграцииС1СДокументооборотом3) Тогда
		// В параметры передан массив ссылок на правила
		РеквизитыПравил = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(
			Параметры.Правила,
			"Ссылка, Комментарий,
			|ТипОбъектаИС, ТипОбъектаДО,
			|ПредставлениеОбъектаИССКлючевымиПолями, ПредставлениеОбъектаДОСКлючевымиПолями");
		Для Каждого Правило Из РеквизитыПравил Цикл
			СтрокаПравила = Правила.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПравила, Правило.Значение);
			СтрокаПравила.ПредставлениеОбъектаИС = Правило.Значение.ПредставлениеОбъектаИССКлючевымиПолями;
			СтрокаПравила.ПредставлениеОбъектаДО = Правило.Значение.ПредставлениеОбъектаДОСКлючевымиПолями;
		КонецЦикла;
	Иначе
		// В параметры передан массив структур с реквизитами правил
		Для Каждого Правило Из Параметры.Правила Цикл
			СтрокаПравила = Правила.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПравила, Правило);
			СтрокаПравила.Комментарий = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				СтрокаПравила.Ссылка,
				"Комментарий");
		КонецЦикла;
	КонецЕсли;
	
	ЕстьКомментарии = Ложь;
	Для Каждого СтрокаПравила Из Правила Цикл
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПриОпределенииПредставленияВидаОбъектаПотребителя(
			СтрокаПравила.Ссылка,
			СтрокаПравила.ПредставлениеОбъектаИС);
		ЕстьКомментарии = ЕстьКомментарии Или ЗначениеЗаполнено(СтрокаПравила.Комментарий);
	КонецЦикла;
	
	Если Параметры.Свойство("СозданиеОбъектаИС") Тогда
		Элементы.ПравилаПредставлениеОбъектаДО.Видимость = Ложь;
		Элементы.ПравилаПредставлениеОбъектаИС.Видимость = Истина;
	КонецЕсли;
	
	Элементы.ПравилаКомментарий.Видимость = ЕстьКомментарии;
	Элементы.Правила.Шапка = ЕстьКомментарии;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьИЗакрыть()
	
	ТекущиеДанные = Элементы.Правила.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Ссылка", ТекущиеДанные.Ссылка);
	Результат.Вставить("ТипОбъектаДО", ТекущиеДанные.ТипОбъектаДО);
	Результат.Вставить("ТипОбъектаИС", ТекущиеДанные.ТипОбъектаИС);
	Результат.Вставить("ПредставлениеОбъектаДО", ТекущиеДанные.ПредставлениеОбъектаДО);
	Результат.Вставить("ПредставлениеОбъектаИС", ТекущиеДанные.ПредставлениеОбъектаИС);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти