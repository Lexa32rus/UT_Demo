#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТипОбъектаВыбора = Параметры.ТипОбъектаВыбора;
	
	Если ТипОбъектаВыбора = "DMDocument" Тогда
		Элементы.ГруппаСтраницыТипов.ТекущаяСтраница = Элементы.ГруппаДокументы;
		КлючСохраненияПоложенияОкна = "Документ";
		
	ИначеЕсли ТипОбъектаВыбора = "DMCorrespondent" Тогда
		Элементы.ГруппаСтраницыТипов.ТекущаяСтраница = Элементы.ГруппаКонтрагенты;
		КлючСохраненияПоложенияОкна = "Контрагент";
		
	ИначеЕсли ТипОбъектаВыбора = "DMMeeting" Тогда
		Элементы.ГруппаСтраницыТипов.ТекущаяСтраница = Элементы.ГруппаМероприятия;
		КлючСохраненияПоложенияОкна = "Мероприятие";
		
	КонецЕсли;
	Элементы.Папка.Видимость = (ТипОбъектаВыбора = "DMDocument");
	
	// В параметрах может быть предустановленный заголовок.
	Если ТипОбъектаВыбора = "DMDocument" Тогда
		Заголовок = НСтр("ru = 'Условия поиска документа предприятия'");
		
	ИначеЕсли ТипОбъектаВыбора = "DMCorrespondent" Тогда
		Заголовок = НСтр("ru = 'Условия поиска контрагента'");
		
	ИначеЕсли ТипОбъектаВыбора = "DMMeeting" Тогда
		Заголовок = НСтр("ru = 'Условия поиска мероприятия'");
		
	КонецЕсли;
	
	ИскатьСразу = Ложь;
	
	// В параметрах могут быть предустановленные условия.
	Если Параметры.Свойство("Отбор") И Параметры.Отбор <> Неопределено Тогда
		Для Каждого ПредустановленноеУсловие Из Параметры.Отбор Цикл
			
			ИмяРеквизитаXDTO = ПредустановленноеУсловие.Ключ;
			Если ИмяРеквизитаXDTO = "correspondent" Тогда
				ИмяРеквизитаФормы = "Контрагент";
				
			ИначеЕсли ИмяРеквизитаXDTO = "organization" Тогда
				ИмяРеквизитаФормы = "Организация";
				
			ИначеЕсли ИмяРеквизитаXDTO = "folder" Тогда
				ИмяРеквизитаФормы = "Папка";
				
			ИначеЕсли ИмяРеквизитаXDTO = "documentType" Тогда
				ИмяРеквизитаФормы = "ВидДокумента";
				
			ИначеЕсли ИмяРеквизитаXDTO = "type" Тогда
				ИмяРеквизитаФормы = "ВидМероприятия";
				
			ИначеЕсли ИмяРеквизитаXDTO = "name" Тогда
				ИмяРеквизитаФормы = "Наименование";
				
			ИначеЕсли ИмяРеквизитаXDTO = "sum" Тогда
				ИмяРеквизитаФормы = "Сумма";
				
			ИначеЕсли ИмяРеквизитаXDTO = "regNumber" Тогда
				ИмяРеквизитаФормы = "РегистрационныйНомер";
				
			ИначеЕсли ИмяРеквизитаXDTO = "startDate" Тогда
				ИмяРеквизитаФормы = "ДатаНачала";
				
			ИначеЕсли ИмяРеквизитаXDTO = "endDate" Тогда
				ИмяРеквизитаФормы = "ДатаОкончания";
				
			ИначеЕсли ИмяРеквизитаXDTO = "anyDate" Тогда
				ИмяРеквизитаФормы = "ЛюбаяДата";
				
			ИначеЕсли ИмяРеквизитаXDTO = "inn" Тогда
				ИмяРеквизитаФормы = "ИНН";
				
			ИначеЕсли ИмяРеквизитаXDTO = "kpp" Тогда
				ИмяРеквизитаФормы = "КПП";
				
			Иначе
				Продолжить;
				
			КонецЕсли;
			
			ОписаниеУсловия = ПредустановленноеУсловие.Значение;
			// примитивные типы могут передаваться сразу значением
			Если ТипЗнч(ОписаниеУсловия) = Тип("Структура") Тогда
				Если ИмяРеквизитаXDTO = "name" Тогда
					ЗначениеУсловия = ОписаниеУсловия.Значение;
					Если Лев(ЗначениеУсловия, 1) = "%" Тогда
						ЗначениеУсловия = Сред(ЗначениеУсловия, 2);
					КонецЕсли;
					Если Прав(ЗначениеУсловия, 1) = "%" Тогда
						ЗначениеУсловия = Лев(ЗначениеУсловия, СтрДлина(ЗначениеУсловия) - 1);
					КонецЕсли;
					ЭтотОбъект[ИмяРеквизитаФормы] = ЗначениеУсловия;
				Иначе
					ЭтотОбъект[ИмяРеквизитаФормы] = ОписаниеУсловия.Значение;
				КонецЕсли;
				Если ОписаниеУсловия.Свойство("ЗначениеID") И ЗначениеЗаполнено(ОписаниеУсловия.ЗначениеID) Тогда
					ЭтотОбъект[ИмяРеквизитаФормы + "ID"] = ОписаниеУсловия.ЗначениеID;
				КонецЕсли;
			Иначе
				ЭтотОбъект[ИмяРеквизитаФормы] = ОписаниеУсловия;
			КонецЕсли;
			
			ИскатьСразу = Истина;
			
		КонецЦикла;
	КонецЕсли;
	
	Если Параметры.Свойство("ИскатьСразу") Тогда
		ИскатьСразу = Параметры.ИскатьСразу;
	КонецЕсли;
	
	Если ИскатьСразу Тогда
		Обработки.ИнтеграцияС1СДокументооборот3.ВыполнитьПоискПоРеквизитам(
			ТипОбъектаВыбора,
			СтруктураОтбора(),
			АдресВоВременномХранилище,
			КоличествоРезультатов,
			ПредельноеКоличествоРезультатов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ИскатьСразу Или КоличествоРезультатов = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбработатьРезультатПоиска", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

///////////////////////////////////////////////////////////////////////////////////////////////////
// Начало выбора

&НаКлиенте
Процедура ВидДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборСсылочногоРеквизитаНачало("ВидДокумента", "DMDocumentType");
	
КонецПроцедуры

&НаКлиенте
Процедура ВидМероприятияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборСсылочногоРеквизитаНачало("ВидМероприятия", "DMMeetingType");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборСсылочногоРеквизитаНачало("Организация", "DMOrganization");
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборСсылочногоРеквизитаНачало("Контрагент", "DMCorrespondent");
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборСсылочногоРеквизитаНачало("Папка", "DMDocumentFolder");
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////
// Очистка

&НаКлиенте
Процедура ВидДокументаОчистка(Элемент, СтандартнаяОбработка)
	
	ЭтотОбъект[Элемент.Имя + "ID"] = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ВидМероприятияОчистка(Элемент, СтандартнаяОбработка)
	
	ЭтотОбъект[Элемент.Имя + "ID"] = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	ЭтотОбъект[Элемент.Имя + "ID"] = "";
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОчистка(Элемент, СтандартнаяОбработка)
	
	ЭтотОбъект[Элемент.Имя + "ID"] = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаОчистка(Элемент, СтандартнаяОбработка)
	
	ЭтотОбъект[Элемент.Имя + "ID"] = "";
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////
// Автоподбор

&НаКлиенте
Процедура ВидДокументаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMDocumentType", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидМероприятияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMMeetingType", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMDocumentFolder", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMOrganization", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMCorrespondent", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////
// Окончание ввода текста

&НаКлиенте
Процедура ВидДокументаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMDocumentType", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"ВидДокумента", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидМероприятияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMMeetingType", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"ВидМероприятия", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMDocumentFolder", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Папка", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMOrganization", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Организация", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMCorrespondent", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Контрагент", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////
// Обработка выбора

&НаКлиенте
Процедура ВидДокументаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"ВидДокумента", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидМероприятияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"ВидМероприятия", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Папка", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Организация", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Контрагент", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаКлиенте
Процедура ДекорацияРасширенныйПоискНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаВыбора", ТипОбъектаВыбора);
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора());
	ПараметрыФормы.Вставить("ИскатьСразу", Ложь);
	Закрыть();
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот3.Форма.ВыборОбъектаПоискомРасширенный",
		ПараметрыФормы,ЭтотОбъект,
		Новый УникальныйИдентификатор,,,
		ОписаниеОповещенияОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Искать(Команда)
	
	ВыполнитьПоискНаСервере(
		ТипОбъектаВыбора,
		АдресВоВременномХранилище,
		КоличествоРезультатов,
		ПредельноеКоличествоРезультатов);
	ОбработатьРезультатПоиска();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьРезультатПоиска()
	
	Если КоличествоРезультатов = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Заданные условия поиска не дали ни одного результата.'"));
		
	ИначеЕсли ПредельноеКоличествоРезультатов <> 0 Тогда
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(Истина, СтрШаблон(
			НСтр("ru = 'Да, показать первые %1'"),
				Формат(ПредельноеКоличествоРезультатов, "ЧГ=0")));
		Кнопки.Добавить(Ложь, НСтр("ru = 'Нет, уточнить условия'"));
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПоискЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения,
			НСтр("ru = 'Заданные условия поиска дали слишком много результатов. Показать результаты?'"),
			Кнопки);
		
	Иначе
		ПерейтиКРезультатамПоиска();
		
	КонецЕсли;
	
КонецПроцедуры

// Упаковывает параметры отбора в структуру, предназначенную для передачи в открываемые формы
//
&НаСервере
Функция СтруктураОтбора()
	
	Отбор = Новый Структура;
	Если ЗначениеЗаполнено(СокрЛП(Наименование)) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Наименование'"));
		Значение.Вставить("Значение", "%" + СокрЛП(Наименование) + "%");
		Значение.Вставить("ОператорСравнения", "LIKE");
		Значение.Вставить("ПредставлениеУсловия", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'содержит ""%1""'"), СокрЛП(Наименование)));
		Отбор.Вставить("name", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(ВидДокументаID) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Вид документа'"));
		Значение.Вставить("ЗначениеТип", "DMDocumentType");
		Значение.Вставить("Значение", ВидДокумента);
		Значение.Вставить("ЗначениеID", ВидДокументаID);
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("documentType", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(ВидМероприятияID) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Вид мероприятия'"));
		Значение.Вставить("ЗначениеТип", "DMMeetingType");
		Значение.Вставить("Значение", ВидМероприятия);
		Значение.Вставить("ЗначениеID", ВидМероприятияID);
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("type", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(Сумма) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Сумма'"));
		Значение.Вставить("Значение", Сумма);
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("sum", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(СокрЛП(РегистрационныйНомер)) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Рег. №'"));
		Значение.Вставить("Значение", СокрЛП(РегистрационныйНомер));
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("regNumber", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(ДатаНачала) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Дата начала'"));
		Значение.Вставить("Значение", ДатаНачала);
		Значение.Вставить("ОператорСравнения", ">=");
		Отбор.Вставить("startDate", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(ДатаОкончания) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Дата окончания'"));
		Значение.Вставить("Значение", ДатаОкончания);
		Значение.Вставить("ОператорСравнения", "<=");
		Отбор.Вставить("endDate", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(ЛюбаяДата) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Начиная с'"));
		Значение.Вставить("Значение", ЛюбаяДата);
		Значение.Вставить("ОператорСравнения", ">=");
		Отбор.Вставить("anyDate", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(ОрганизацияID) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Организация'"));
		Значение.Вставить("ЗначениеТип", "DMOrganization");
		Значение.Вставить("Значение", Организация);
		Значение.Вставить("ЗначениеID", ОрганизацияID);
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("organization", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(КонтрагентID) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Контрагент'"));
		Значение.Вставить("ЗначениеТип", "DMCorrespondent");
		Значение.Вставить("Значение", Контрагент);
		Значение.Вставить("ЗначениеID", КонтрагентID);
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("correspondent", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПапкаID) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'Папка'"));
		Значение.Вставить("ЗначениеТип", "DMDocumentFolder");
		Значение.Вставить("Значение", Папка);
		Значение.Вставить("ЗначениеID", ПапкаID);
		Значение.Вставить("ОператорСравнения", "IN HIERARCHY");
		Отбор.Вставить("folder", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(СокрЛП(ИНН)) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'ИНН'"));
		Значение.Вставить("Значение", СокрЛП(ИНН));
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("inn", Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(СокрЛП(КПП)) Тогда
		Значение = Новый Структура;
		Значение.Вставить("Представление", НСтр("ru = 'КПП'"));
		Значение.Вставить("Значение", СокрЛП(КПП));
		Значение.Вставить("ОператорСравнения", "=");
		Отбор.Вставить("kpp", Значение);
	КонецЕсли;
	
	Возврат Отбор;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПоискЗавершение(Результат, Параметры) Экспорт
	
	Если Результат Тогда
		ПерейтиКРезультатамПоиска();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКРезультатамПоиска()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаВыбора", ТипОбъектаВыбора);
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора());
	ПараметрыФормы.Вставить("АдресВоВременномХранилище", АдресВоВременномХранилище);
	Закрыть();
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот3.Форма.ВыборОбъектаПоискомРезультаты",
		ПараметрыФормы,ЭтотОбъект,
		Новый УникальныйИдентификатор,,,
		ОписаниеОповещенияОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискНаСервере(ТипОбъектаВыбора, АдресВоВременномХранилище, КоличествоРезультатов, ПредельноеКоличествоРезультатов)
	
	Обработки.ИнтеграцияС1СДокументооборот3.ВыполнитьПоискПоРеквизитам(
		ТипОбъектаВыбора,
		СтруктураОтбора(),
		АдресВоВременномХранилище,
		КоличествоРезультатов,
		ПредельноеКоличествоРезультатов);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборСсылочногоРеквизитаНачало(ИмяРеквизита, Тип)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборСсылочногоРеквизитаЗавершение",
		ЭтотОбъект, ИмяРеквизита);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаВыбора", Тип);
	
	Если ЗначениеЗаполнено(ЭтотОбъект[ИмяРеквизита + "ID"]) Тогда
		ПараметрыФормы.Вставить("ВыбранныйЭлемент", ЭтотОбъект[ИмяРеквизита + "ID"]);
	КонецЕсли;
	
	Если Тип = "DMDocument" Или Тип = "DMCorrespondent" Или Тип = "DMMeeting" Тогда
		// объектов ДО потенциально много, нужен выбор поиском
		Отбор = Новый Структура;
		Если Тип = "DMDocument" И ЗначениеЗаполнено(Элементы.НаименованиеДокумента.ТекстРедактирования) Тогда
			Отбор.Вставить("name", СокрЛП(Элементы.НаименованиеДокумента.ТекстРедактирования));
			ПараметрыФормы.Вставить("ИскатьСразу", Ложь);
			
		ИначеЕсли Тип = "DMCorrespondent" И ЗначениеЗаполнено(Элементы.Контрагент.ТекстРедактирования) Тогда
			Отбор.Вставить("name", СокрЛП(Элементы.Контрагент.ТекстРедактирования));
			ПараметрыФормы.Вставить("ИскатьСразу", Ложь);
			
		ИначеЕсли Тип = "DMMeeting" И ЗначениеЗаполнено(Элементы.НаименованиеМероприятия.ТекстРедактирования) Тогда
			Отбор.Вставить("name", СокрЛП(Элементы.НаименованиеМероприятия.ТекстРедактирования));
			ПараметрыФормы.Вставить("ИскатьСразу", Ложь);
			
		КонецЕсли;
		ПараметрыФормы.Вставить("Отбор", Отбор);
		
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот3.Форма.ВыборОбъектаПоиском",
			ПараметрыФормы,
			ЭтотОбъект,
			УникальныйИдентификатор,,,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	Иначе
		// обычный выбор из списка
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.ВыборИзСписка",
			ПараметрыФормы,
			ЭтотОбъект,
			Новый УникальныйИдентификатор,,,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборСсылочногоРеквизитаЗавершение(Результат, ИмяРеквизита) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЭтотОбъект[ИмяРеквизита] = Результат.РеквизитПредставление;
		ЭтотОбъект[ИмяРеквизита + "ID"] = Результат.РеквизитID;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти