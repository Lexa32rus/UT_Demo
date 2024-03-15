#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Ячейка      = Параметры.Ячейка;
	Склад       = Параметры.Склад;
	Помещение   = Параметры.Помещение;
	ТипОперации = Параметры.ТипОперации;
	
	ТоварыВЯчейке = Параметры.Товары;
	
	Для Каждого Строка Из ТоварыВЯчейке Цикл
		
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		Если ТипОперации = 1 Тогда
			НоваяСтрока.ЗаголовокФакт = "Размещено";
		Иначе
			НоваяСтрока.ЗаголовокФакт = "Отобрано";
		КонецЕсли;
		НоваяСтрока.Ячейка = Ячейка;
		
	КонецЦикла;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			
			// Преобразуем предварительно к ожидаемому формату
			Если Параметр[1] = Неопределено Тогда
				Штрихкод = Параметр[0];
			Иначе
				Штрихкод = Параметр[1][1];
			КонецЕсли;
			
			ЭтоЯчейка = Ложь;
			ЭтоТовар = Ложь;
			
			РезультатПоискаЯчейки = НайтиЯчейкуСервер(Склад, Помещение, Штрихкод);
			ШтрихкодЯчейки = ЗначениеЗаполнено(РезультатПоискаЯчейки.Ячейка);
			
			Если ШтрихкодЯчейки Тогда
				Если РезультатПоискаЯчейки.Ячейка = Ячейка Тогда
					ЗакрытьФорму();
					Возврат;
				Иначе
					СообщениеПользователю = Новый СообщениеПользователю;
					СообщениеПользователю.Текст = НСтр("ru='Для перехода к следующей ячейке закончите работу с текущей'");
					СообщениеПользователю.Сообщить();
					Возврат;
				КонецЕсли;
			КонецЕсли;
			
			ПараметрыКарточкаТовара = НайтиТоварСервер(Штрихкод);
			
			Если НЕ ЗначениеЗаполнено(ПараметрыКарточкаТовара.Номенклатура) Тогда
				
				ТекстОшибки = НСтр("ru='Не найдена номенклатура со штрихкодом: '") + Штрихкод;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
				
				Возврат;
			КонецЕсли;
			
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Номенклатура",   ПараметрыКарточкаТовара.Номенклатура);
			СтруктураПоиска.Вставить("Характеристика", ПараметрыКарточкаТовара.Характеристика);
			СтруктураПоиска.Вставить("Упаковка",       ПараметрыКарточкаТовара.Упаковка);
			
			РезультатПоиска = Товары.НайтиСтроки(СтруктураПоиска);
			Если РезультатПоиска.Количество() > 0 Тогда
				
				Описание = Новый ОписаниеОповещения("ПодтвердитьКоличество", ЭтаФорма);
				
				ПараметрыФормы = Новый Структура;
				ПараметрыФормы.Вставить("Номенклатура",   РезультатПоиска[0].Номенклатура);
				ПараметрыФормы.Вставить("Характеристика", РезультатПоиска[0].Характеристика);
				ПараметрыФормы.Вставить("Серия",          РезультатПоиска[0].Серия);
				ПараметрыФормы.Вставить("Назначение",     РезультатПоиска[0].Назначение);
				ПараметрыФормы.Вставить("Упаковка",       РезультатПоиска[0].Упаковка);
				ПараметрыФормы.Вставить("Количество",     ПараметрыКарточкаТовара.Количество);
				ПараметрыФормы.Вставить("НомерСтроки",    Товары.Индекс(Элементы.Товары.ТекущиеДанные));
				ПараметрыФормы.Вставить("Склад",          Склад);
				ПараметрыФормы.Вставить("Помещение",      Помещение);
				
				Если ТипОперации = 1 Тогда
					ПараметрыФормы.Вставить("Режим", "РазмещениеВЯчейку");
				Иначе
					ПараметрыФормы.Вставить("Режим", "ОтборИзЯчейки");
				КонецЕсли;
				
				Если РезультатПоиска[0].ЯчейкаЗамена.Пустая() Тогда
					ПараметрыФормы.Вставить("Ячейка", РезультатПоиска[0].Ячейка);
				Иначе
					ПараметрыФормы.Вставить("Ячейка", РезультатПоиска[0].ЯчейкаЗамена);
				КонецЕсли;
				
				ОткрытьФорму(
				"Обработка.МобильноеРабочееМестоКладовщика.Форма.КарточкаТовара",ПараметрыФормы,
				ЭтаФорма,,,,Описание,
				РежимОткрытияОкнаФормы.Независимый);
				
			Иначе
				СообщениеПользователю = Новый СообщениеПользователю;
				ТекстСообщения = НСтр("ru='Не требуется %1 номенклатуры %2 в упаковке %3'");
				Если ТипОперации = 1 Тогда
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", НСтр("ru='размещение'"));
				Иначе
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", НСтр("ru='отбор'"));
				КонецЕсли;
				
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%2", ПараметрыКарточкаТовара.Номенклатура);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%3", ПараметрыКарточкаТовара.Упаковка);
				
				СообщениеПользователю.Текст = ТекстСообщения;
				СообщениеПользователю.Сообщить();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Описание = Новый ОписаниеОповещения("ПодтвердитьКоличество", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Номенклатура", Элемент.ТекущиеДанные.Номенклатура);
	ПараметрыФормы.Вставить("Характеристика", Элемент.ТекущиеДанные.Характеристика);
	ПараметрыФормы.Вставить("Серия", Элемент.ТекущиеДанные.Серия);
	ПараметрыФормы.Вставить("Назначение", Элемент.ТекущиеДанные.Назначение);
	ПараметрыФормы.Вставить("Упаковка", Элемент.ТекущиеДанные.Упаковка);
	ПараметрыФормы.Вставить("Количество", Элемент.ТекущиеДанные.КоличествоУпаковок);
	Если ТипОперации = 1 Тогда
		ПараметрыФормы.Вставить("Режим", "РедактированиеРазмещениеПоЯчейкам");
	Иначе
		ПараметрыФормы.Вставить("Режим", "РедактированиеОтборИзЯчейки");
	КонецЕсли;
	ПараметрыФормы.Вставить("НомерСтроки", Товары.Индекс(Элементы.Товары.ТекущиеДанные));
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	Если Элемент.ТекущиеДанные.ЯчейкаЗамена.Пустая() Тогда
		ПараметрыФормы.Вставить("Ячейка", Элемент.ТекущиеДанные.Ячейка);
	Иначе
		ПараметрыФормы.Вставить("Ячейка", Элемент.ТекущиеДанные.ЯчейкаЗамена);
	КонецЕсли;
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.КарточкаТовара",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
	
КонецПроцедуры

&НаКлиенте
Процедура Подтвердить(Команда)
	
	ЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()
	
	МассивРазмещений = Новый Массив;
	
	Для Каждого Строка Из Товары Цикл
		
		Структура = СтруктураТоваров();
		
		ЗаполнитьЗначенияСвойств(Структура, Строка);
		Структура.Вставить("КоличествоУпаковок", Строка.КоличествоУпаковокРазмещено);
		
		МассивРазмещений.Добавить(Структура);
		
	КонецЦикла;
	
	РезультатСборки = Новый Структура;
	РезультатСборки.Вставить("Ячейка", Ячейка);
	РезультатСборки.Вставить("МассивРазмещений", МассивРазмещений);
	
	Закрыть(РезультатСборки);
	
КонецПроцедуры

&НаКлиенте
Процедура Блокировать(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ячейка", Ячейка);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.БлокировкаЯчейки",ПараметрыФормы,
	ЭтаФорма,,,,,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Если ТипОперации = 1 Тогда
		ОбновитьПодсказку();
		Элементы.Подтвердить.Заголовок = "Закончить размещение";
		ЭтаФорма.Заголовок = "Размещение в ячейку";
	Иначе
		ОбновитьПодсказку();
		Элементы.Подтвердить.Заголовок = "Закончить отбор";
		ЭтаФорма.Заголовок = "Отбор из ячейки";
	КонецЕсли;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ТоварыКоличествоУпаковокРазмещено");
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.КоличествоУпаковок");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ЭлементОтбора.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Товары.КоличествоУпаковокРазмещено");
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаПроблема);
	
КонецПроцедуры

&НаКлиенте
Функция СтруктураТоваров()
	
	Структура = Новый Структура;
	Структура.Вставить("Номенклатура","");
	Структура.Вставить("Характеристика","");
	Структура.Вставить("Серия","");
	Структура.Вставить("Назначение","");
	Структура.Вставить("Упаковка","");
	Структура.Вставить("КоличествоУпаковок","");
	Структура.Вставить("Ячейка","");
	Структура.Вставить("ЯчейкаЗамена","");
	
	Возврат Структура;
	
КонецФункции

&НаКлиенте
Процедура РезультатЗаменыЯчейки(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЯчейкаЗамена = Результат;
	Элементы.Ячейка.Видимость = Ложь;
	Элементы.ЯчейкаЗамена.Видимость = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПодсказку()
	
	Если ТипОперации = 1 Тогда
		Элементы.ЗаголовокПодсказка1.Заголовок = "Размещено строк";
	Иначе
		Элементы.ЗаголовокПодсказка1.Заголовок = "Отобрано строк";
	КонецЕсли;
	
	План = Товары.Количество();
	ОтработаноСтрокБезОшибок = 0;
	Для Каждого Строка Из Товары Цикл
		Если Строка.КоличествоУпаковок = Строка.КоличествоУпаковокРазмещено Тогда
			ОтработаноСтрокБезОшибок = ОтработаноСтрокБезОшибок + 1;
		КонецЕсли;
	КонецЦикла;
		
	Элементы.ЗаголовокПодсказкаФакт.Заголовок = ОтработаноСтрокБезОшибок;
	Элементы.ЗаголовокПодсказкаПлан.Заголовок = План;
	Элементы.ЗаголовокПодсказкаРазница.Заголовок = План - ОтработаноСтрокБезОшибок;
	
	
КонецПроцедуры

&НаСервере
Процедура ПодтвердитьКоличество(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Режим = "РедактированиеРазмещениеПоЯчейкам" ИЛИ Результат.Режим = "РедактированиеОтборИзЯчейки" Тогда
		
		Литерал = "НомерСтроки";
		НомерСтроки = Результат[Литерал];
		
		Товары[НомерСтроки].КоличествоУпаковокРазмещено = Результат.КоличествоУпаковок;
		Если Товары[НомерСтроки].Ячейка <> Результат.Ячейка Тогда
			Товары[НомерСтроки].ЯчейкаЗамена = Результат.Ячейка;
		КонецЕсли;
	Иначе
		
		КоэффициентУпаковки = Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Результат.Упаковка, Результат.Номенклатура);
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Номенклатура", Результат.Номенклатура);
		СтруктураПоиска.Вставить("Характеристика", Результат.Характеристика);
		СтруктураПоиска.Вставить("Серия", Результат.Серия);
		СтруктураПоиска.Вставить("Упаковка", Результат.Упаковка);
		СтруктураПоиска.Вставить("Назначение", Результат.Назначение);
		СтруктураПоиска.Вставить("Ячейка", Результат.Ячейка);
		
		РезультатПоиска = Товары.НайтиСтроки(СтруктураПоиска);
		Если РезультатПоиска.Количество() > 0 Тогда
			РезультатПоиска[0].КоличествоУпаковокРазмещено = РезультатПоиска[0].КоличествоУпаковокРазмещено + Результат.КоличествоУпаковок;
		ИначеЕсли Результат.КоличествоУпаковок > 0 Тогда
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Результат,,"КоличествоУпаковок");
			НоваяСтрока.КоличествоУпаковокРазмещено = Результат.КоличествоУпаковок;
		КонецЕсли;
		
	КонецЕсли;
	
	ОбновитьПодсказку();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиТоварСервер(Штрихкод)
	Возврат Обработки.МобильноеРабочееМестоКладовщика.НайтиТоварПоШК(Штрихкод);
КонецФункции

&НаСервереБезКонтекста
Функция НайтиЯчейкуСервер(Склад, Помещение, Штрихкод)
	Возврат Обработки.МобильноеРабочееМестоКладовщика.НайтиЯчейкуСервер(Склад, Помещение, Штрихкод);
КонецФункции

#КонецОбласти