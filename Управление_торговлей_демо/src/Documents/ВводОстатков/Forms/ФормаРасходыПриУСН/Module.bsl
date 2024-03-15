#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьЗаголовок();
	УстановитьВидимость();
	УстановитьОграниченияПоВыборуТипов();
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Поставщик", Истина));
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПередачиТоваровМеждуОрганизациями") Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("УстанавливатьОтборПоТипуПартнераКакИЛИ", Истина));
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.НашеПредприятие", Истина));
	КонецЕсли;
	Элементы.РасходыПриУСНПрочиеРасходыПартнер.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	Элементы.РасходыПриУСНМатериалыПартнер.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	Элементы.РасходыПриУСНТоварыПартнер.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатков.ПараметрыВыбораСтатейИАналитик(Объект.ХозяйственнаяОперация);
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ИсправлениеДокументов.ПриСозданииНаСервере(ЭтаФорма, Элементы.СтрокаИсправление);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИсправлениеДокументов.ПриЧтенииНаСервере(ЭтаФорма, Элементы.СтрокаИсправление);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатков.ПараметрыВыбораСтатейИАналитик(ТекущийОбъект.ХозяйственнаяОперация);
	ДоходыИРасходыСервер.ПриЧтенииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ХозяйственнаяОперация", Объект.ХозяйственнаяОперация);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИсправлениеДокументовКлиент.ПослеЗаписи(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьЗаголовок();
	ДоходыИРасходыСервер.ПослеЗаписиНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИсправлениеДокументовКлиент.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтрокаИсправлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ИсправлениеДокументовКлиент.СтрокаИсправлениеОбработкаНавигационныйСсылки(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьОграниченияПоВыборуТипов();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	УстановитьОграниченияПоВыборуТипов();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыРасходыПриУСНМатериалы

&НаКлиенте
Процедура РасходыПриУСНМатериалыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда
		
		Элемент.ТекущиеДанные.Контрагент = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасходыПриУСНМатериалыПартнерПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РасходыПриУСНМатериалы.ТекущиеДанные;
	ПартнерПриИзмененииСервер(ТекущиеДанные.Партнер, ТекущиеДанные.Контрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходыПриУСНМатериалыДокументВозникновенияРасходовПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Элемент.Родитель.ТекущиеДанные.Партия) Тогда
			Элемент.Родитель.ТекущиеДанные.Партия = Элемент.Родитель.ТекущиеДанные.ДокументВозникновенияРасходов;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РасходыПриУСНМатериалыПартияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Элемент.Родитель.ТекущиеДанные.ДокументВозникновенияРасходов) Тогда
		Элемент.Родитель.ТекущиеДанные.ДокументВозникновенияРасходов = Элемент.Родитель.ТекущиеДанные.Партия;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыРасходыПриУСНПрочие

&НаКлиенте
Процедура РасходыПриУСНПрочиеРасходыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда
		
		Элемент.ТекущиеДанные.Контрагент = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасходыПриУСНПрочиеРасходыВидРасходовОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура РасходыПриУСНПрочиеРасходыПартнерПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РасходыПриУСНПрочиеРасходы.ТекущиеДанные;
	ПартнерПриИзмененииСервер(ТекущиеДанные.Партнер, ТекущиеДанные.Контрагент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыРасходыПриУСНТовары

&НаКлиенте
Процедура РасходыПриУСНТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда
		Элемент.ТекущиеДанные.Контрагент = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасходыПриУСНТоварыПартнерПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РасходыПриУСНТовары.ТекущиеДанные;
	ПартнерПриИзмененииСервер(ТекущиеДанные.Партнер, ТекущиеДанные.Контрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходыПриУСНТоварыДокументВозникновенияРасходовПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Элемент.Родитель.ТекущиеДанные.Партия) Тогда
		Элемент.Родитель.ТекущиеДанные.Партия = Элемент.Родитель.ТекущиеДанные.ДокументВозникновенияРасходов;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасходыПриУСНТоварыПартияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Элемент.Родитель.ТекущиеДанные.ДокументВозникновенияРасходов) Тогда
		Элемент.Родитель.ТекущиеДанные.ДокументВозникновенияРасходов = Элемент.Родитель.ТекущиеДанные.Партия;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовок()
	
	АвтоЗаголовок = Ложь;
	Заголовок = Документы.ВводОстатков.ЗаголовокДокументаПоТипуОперации(Объект.Ссылка, Объект.Номер, Объект.Дата, Объект.ХозяйственнаяОперация);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковПрочихРасходовУСН Тогда
		Элементы.ГруппаРасходыПриУСНСтраницы.ТекущаяСтраница = Элементы.ГруппаРасходыПриУСНПрочиеРасходы;
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковРасходовУСНПоМатериалам Тогда
		Элементы.ГруппаРасходыПриУСНСтраницы.ТекущаяСтраница = Элементы.ГруппаРасходыПриУСНМатериалы;
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковРасходовУСНПоТоварам Тогда
		Элементы.ГруппаРасходыПриУСНСтраницы.ТекущаяСтраница = Элементы.ГруппаРасходыПриУСНТовары;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПартнерПриИзмененииСервер(Партнер, Контрагент)
	
	Если Партнер = Справочники.Партнеры.НашеПредприятие 
		И ТипЗнч(Контрагент) <> Тип("СправочникСсылка.Организации") Тогда
		Контрагент = Справочники.Организации.ПустаяСсылка();
	Иначе
		ПарезаполнятьКонтрагента = (ТипЗнч(Контрагент) <> Тип("СправочникСсылка.Контрагенты"));
		ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент, ПарезаполнятьКонтрагента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОграниченияПоВыборуТипов()
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Или Не ЗначениеЗаполнено(Объект.Дата) Тогда
		Возврат;
	КонецЕсли;
	
	ТипПервичногоДокумента = Новый ОписаниеТипов("ДокументСсылка.ПервичныйДокумент");
	Элементы.РасходыПриУСНПрочиеРасходыДокументВозникновенияРасходов.ОграничениеТипа = Новый ОписаниеТипов(ТипПервичногоДокумента);
	Элементы.РасходыПриУСНТоварыДокументВозникновенияРасходов.ОграничениеТипа = Новый ОписаниеТипов(ТипПервичногоДокумента);
	Элементы.РасходыПриУСНМатериалыДокументВозникновенияРасходов.ОграничениеТипа = Новый ОписаниеТипов(ТипПервичногоДокумента);
	Элементы.РасходыПриУСНТоварыПартия.ОграничениеТипа = Новый ОписаниеТипов(ТипПервичногоДокумента);
	Элементы.РасходыПриУСНМатериалыПартия.ОграничениеТипа = Новый ОписаниеТипов(ТипПервичногоДокумента);
	
	
КонецПроцедуры

#КонецОбласти