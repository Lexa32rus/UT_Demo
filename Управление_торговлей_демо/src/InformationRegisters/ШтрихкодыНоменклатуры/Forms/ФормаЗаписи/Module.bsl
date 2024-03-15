#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.ЗначенияЗаполнения.Свойство("Штрихкод") Тогда
		Запись.Штрихкод = Параметры.ЗначенияЗаполнения.Штрихкод;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		ХарактеристикиИспользуются = Справочники.Номенклатура.ХарактеристикиИспользуются(Запись.Номенклатура);
		Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ШтрихкодыНоменклатуры", Запись.Номенклатура);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ШтрихкодыНоменклатуры.Штрихкод,
	|	ШтрихкодыНоменклатуры.Номенклатура,
	|	ШтрихкодыНоменклатуры.Характеристика,
	|	ШтрихкодыНоменклатуры.Упаковка,
	|	ШтрихкодыНоменклатуры.Номенклатура.Наименование КАК НоменклатураПредставление,
	|	ШтрихкодыНоменклатуры.Характеристика.Наименование КАК ХарактеристикаПредставление,
	|	ШтрихкодыНоменклатуры.Упаковка.Наименование КАК УпаковкаПредставление
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Штрихкод = &Штрихкод
	|";
	
	СтрокаШтрихкода = СокрП(Запись.Штрихкод);
	Запрос.УстановитьПараметр("Штрихкод", СтрокаШтрихкода);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() // Штрихкод уже записан в БД
		И Запись.ИсходныйКлючЗаписи.Штрихкод <> СтрокаШтрихкода Тогда
		
		ОписаниеОшибки = НСтр("ru='Такой штрихкод уже назначен для номенклатуры %Номенклатура%'");
		ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Номенклатура%", """" + Выборка.НоменклатураПредставление + """"
		                + ?(ЗначениеЗаполнено(Выборка.Характеристика), " " + НСтр("ru='с характеристикой'") + " """ + Выборка.ХарактеристикаПредставление + """", "")
		                + ?(ЗначениеЗаполнено(Выборка.Упаковка), " " + НСтр("ru='в упаковке'") + " """ + Выборка.УпаковкаПредставление + """", ""));
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки;
		Сообщение.Поле = "Запись.Штрихкод";
		Сообщение.Сообщить();
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ХарактеристикиИспользуются = Справочники.Номенклатура.ХарактеристикиИспользуются(Запись.Номенклатура);
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Запись.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу"      , Запись.Упаковка);

	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура", Запись.Номенклатура);
	СтруктураСтроки.Вставить("Характеристика", Запись.Характеристика);
	СтруктураСтроки.Вставить("Упаковка", Запись.Упаковка);
	СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(СтруктураСтроки, СтруктураДействий, КэшированныеЗначения);

	ЗаполнитьЗначенияСвойств(Запись, СтруктураСтроки);
	
	ХарактеристикиИспользуются = СтруктураСтроки.ХарактеристикиИспользуются;
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НовыйШтрихкод(Команда)
	
	ОчиститьСообщения();
	
	Если ЭтоВесовойТовар(Запись.Номенклатура, Запись.Упаковка) Тогда
		Запись.Штрихкод = СформироватьШтрихкодEAN13ВесовогоТовара();
	Иначе
		Запись.Штрихкод = СформироватьШтрихкодEAN13();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Модифицированность = Истина;
	
	Если ДанныеШтрихкодов.Количество() > 0 Тогда
		Запись.Штрихкод = ДанныеШтрихкодов[ДанныеШтрихкодов.Количество() - 1].Штрихкод;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервереБезКонтекста
Функция ЭтоВесовойТовар(Номенклатура, Упаковка)
	
	Если ЗначениеЗаполнено(Упаковка) Тогда
		
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Упаковка, "ТипИзмеряемойВеличины, ЕдиницаИзмерения");
		Если ЗначенияРеквизитов.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Упаковка Тогда
			ТипИзмеряемойВеличины = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				ЗначенияРеквизитов.ЕдиницаИзмерения, "ТипИзмеряемойВеличины");
		Иначе
			ТипИзмеряемойВеличины = ЗначенияРеквизитов.ТипИзмеряемойВеличины;
		КонецЕсли;
		
	Иначе
		ТипИзмеряемойВеличины = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Номенклатура, "ЕдиницаИзмерения.ТипИзмеряемойВеличины");
	КонецЕсли;
	
	Возврат ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Вес;
	
КонецФункции

&НаСервереБезКонтекста
Функция СформироватьШтрихкодEAN13()
	
	Возврат РегистрыСведений.ШтрихкодыНоменклатуры.СформироватьШтрихкодEAN13();
	
КонецФункции

&НаСервереБезКонтекста
Функция СформироватьШтрихкодEAN13ВесовогоТовара()
	
	Возврат РегистрыСведений.ШтрихкодыНоменклатуры.СформироватьШтрихкодВесовогоТовараEAN13();
	
КонецФункции

#КонецОбласти

#КонецОбласти
