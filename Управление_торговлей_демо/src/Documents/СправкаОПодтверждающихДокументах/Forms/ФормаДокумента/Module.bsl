
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
	Если Не ПереключательСписка Тогда
		ДокументОбъект = РеквизитФормыВЗначение("Объект");
		ДокументОбъект.ДополнительныеСвойства.Вставить("ПодтверждающиеДокументыБезРазбиения", Истина);
		
		Если Не ДокументОбъект.ПроверитьЗаполнение() Тогда
			Отказ = Истина;
		КонецЕсли;
		
		ПроверяемыеРеквизиты.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" Тогда
		ОбновитьНадписьФайлыДляПередачиВБанк();
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_СправкаОПодтверждающихДокументах", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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
Процедура ДоговорПриИзменении(Элемент)
	
	ДоговорПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ДоговорПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Договор) Тогда
		Объект.Контрагент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Договор, "Контрагент");
	Иначе
		Объект.Контрагент = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательСпискаПриИзменении(Элемент)
	
	Если Не ПереключательСписка Тогда
		Если Объект.ПодтверждающиеДокументы.Количество() = 0 Тогда
			НоваяСтрока = Объект.ПодтверждающиеДокументы.Добавить();
			Элементы.ПодтверждающиеДокументы.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		ИначеЕсли Объект.ПодтверждающиеДокументы.Количество() = 1 Тогда
			Если Элементы.ПодтверждающиеДокументы.ТекущаяСтрока = Неопределено Тогда
				Элементы.ПодтверждающиеДокументы.ТекущаяСтрока = Объект.ПодтверждающиеДокументы[0].ПолучитьИдентификатор();
			КонецЕсли;
		ИначеЕсли Объект.ПодтверждающиеДокументы.Количество() > 1 Тогда
			ОчиститьСообщения();
			ТекстСообщения = НСтр("ru = 'Переключение в режим без разбиения невозможно, если в списке подтверждающих документов введено более одной строки!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			ПереключательСписка = 1;
		КонецЕсли;
	КонецЕсли;
	
	Если ПереключательСписка Тогда
		Элементы.СтраницыПодтверждающиеДокументы.ТекущаяСтраница = Элементы.СтраницаСписком;
	Иначе
		Элементы.СтраницыПодтверждающиеДокументы.ТекущаяСтраница = Элементы.СтраницаБезРазбиения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьФайлыДляПередачиВБанкНажатие(Элемент)
	
	ДенежныеСредстваКлиентЛокализация.ОткрытьФормуСпискаФайловДляПередачиВБанк(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧасти

&НаКлиенте
Процедура ПодтверждающиеДокументыБезРазбиенияПодтверждающийДокументПриИзменении(Элемент)
	
	СтрокаТЧ = Объект.ПодтверждающиеДокументы[0];
	
	ПодтверждающийДокументЗаполнен = ЗначениеЗаполнено(СтрокаТЧ.ПодтверждающийДокумент);
	Если ПодтверждающийДокументЗаполнен Тогда
		СтрокаТЧ.НомерДокумента = Неопределено;
		СтрокаТЧ.ДатаДокумента = Неопределено;
		ПодтверждающиеДокументыБезРазбиенияПодтверждающийДокументПриИзмененииНаСервере();
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормы("ПодтверждающийДокументЗаполнен");
	
КонецПроцедуры

&НаСервере
Процедура ПодтверждающиеДокументыБезРазбиенияПодтверждающийДокументПриИзмененииНаСервере()
	
	СтрокаТЧ = Объект.ПодтверждающиеДокументы[0];
	
	Реквизиты = СтрокаТЧ.ПодтверждающийДокумент.Метаданные().Реквизиты;
	Если Реквизиты.Найти("СуммаДокумента") <> Неопределено И Реквизиты.Найти("Валюта") <> Неопределено Тогда
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			СтрокаТЧ.ПодтверждающийДокумент, Новый Структура("СуммаДокумента, ВалютаДокумента",, "Валюта"));
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, РеквизитыДокумента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждающиеДокументыБезРазбиенияКодВидаДокументаПриИзменении(Элемент)
	
	ЗначениеКода = Объект.ПодтверждающиеДокументы[0].КодВидаДокумента;
	
	Если ЗначениеЗаполнено(ЗначениеКода) Тогда
		Элементы.ПодтверждающиеДокументыБезРазбиенияКодВидаДокумента.Подсказка =
			Сред(СписокКодовВидаДокумента.НайтиПоЗначению(ЗначениеКода).Представление, СтрДлина(ЗначениеКода) + 4);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	 РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Объект);
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	НастройкиПолейФормы = Документы.СправкаОПодтверждающихДокументах.НастройкиПолейФормы();
	ЗначениеВРеквизитФормы(НастройкиПолейФормы, "НастройкиПолей");
	ЗависимостиПолейФормы = ДенежныеСредстваСервер.ЗависимостиПолейФормы(НастройкиПолейФормы);
	ЗначениеВРеквизитФормы(ЗависимостиПолейФормы, "ЗависимостиПолей");
	
	ОбновитьНадписьФайлыДляПередачиВБанк();
	
	ДенежныеСредстваСервер.ИнициализироватьТабличнуюЧасть(ЭтаФорма, "ПодтверждающиеДокументы", ПереключательСписка);
	
	Если ПереключательСписка Тогда
		Элементы.СтраницыПодтверждающиеДокументы.ТекущаяСтраница = Элементы.СтраницаСписком;
	Иначе
		Элементы.СтраницыПодтверждающиеДокументы.ТекущаяСтраница = Элементы.СтраницаБезРазбиения;
	КонецЕсли;
	
	ЗаполнитьСписокКодовВидаДокумента();
	Элементы.ПодтверждающиеДокументыБезРазбиенияКодВидаДокумента.СписокВыбора.Очистить();
	Элементы.ПодтверждающиеДокументыКодВидаДокумента.СписокВыбора.Очистить();
	Для каждого ЭлементСписка Из СписокКодовВидаДокумента Цикл
		Элементы.ПодтверждающиеДокументыБезРазбиенияКодВидаДокумента.СписокВыбора.Добавить(ЭлементСписка.Значение,
			?(СтрДлина(ЭлементСписка.Представление) > 100, Лев(ЭлементСписка.Представление, 100) + "...", ЭлементСписка.Представление));
		Элементы.ПодтверждающиеДокументыКодВидаДокумента.СписокВыбора.Добавить(ЭлементСписка.Значение,
			?(СтрДлина(ЭлементСписка.Представление) > 100, Лев(ЭлементСписка.Представление, 100) + "...", ЭлементСписка.Представление));
	КонецЦикла;
	
	Если Не ПереключательСписка
		И Объект.ПодтверждающиеДокументы.Количество() = 1 Тогда
		
		ПодтверждающийДокументЗаполнен = ЗначениеЗаполнено(Объект.ПодтверждающиеДокументы[0].ПодтверждающийДокумент);
		
		КодВидаДокумента = Объект.ПодтверждающиеДокументы[0].КодВидаДокумента;
		Если ЗначениеЗаполнено(КодВидаДокумента) Тогда
			Элементы.ПодтверждающиеДокументыБезРазбиенияКодВидаДокумента.Подсказка =
				Сред(СписокКодовВидаДокумента.НайтиПоЗначению(КодВидаДокумента).Представление, СтрДлина(КодВидаДокумента) + 4);
		КонецЕсли;
	КонецЕсли;
	
	СписокРеквизитов = Новый Массив;
	Для каждого Элемент Из Метаданные.Документы.СправкаОПодтверждающихДокументах.ТабличныеЧасти.ПодтверждающиеДокументы.Реквизиты Цикл
		СписокРеквизитов.Добавить(Элемент.Имя);
	КонецЦикла;
	РеквизитыТаблицыПодтверждающихДокументов = СтрСоединить(СписокРеквизитов, ",");
	
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКодовВидаДокумента()
	
	СписокКодовВидаДокумента.Очистить();
	СписокКодовВидаДокумента.Добавить("01_3", "01_3 - " + НСтр("ru = 'О вывозе с территории Российской Федерации товаров с оформлением декларации на товары или документов, указанных в подпункте 9.1.1 пункта 9.1 настоящей Инструкции, за исключением документов с кодом 03_3'"));
	СписокКодовВидаДокумента.Добавить("01_4", "01_4 - " + НСтр("ru = 'О ввозе на территорию Российской Федерации товаров с оформлением декларации на товары или документов, указанных в подпункте 9.1.1 пункта 9.1 настоящей Инструкции, за исключением документов с кодом 03_4'"));
	СписокКодовВидаДокумента.Добавить("02_3", "02_3 - " + НСтр("ru = 'Об отгрузке (передаче покупателю, перевозчику) товаров при их вывозе с территории Российской Федерации без оформления декларации на товары или документов, указанных в подпункте 9.1.1 пункта 9.1 настоящей Инструкции, за исключением документов с кодом 03_3'"));
	СписокКодовВидаДокумента.Добавить("02_4", "02_4 - " + НСтр("ru = 'О получении (передаче продавцом, перевозчиком) товаров при их ввозе на территорию Российской Федерации без оформления декларации на товары или документов, указанных в подпункте 9.1.1 пункта 9.1 настоящей Инструкции, за исключением документов с кодом 03_4'"));
	СписокКодовВидаДокумента.Добавить("03_3", "03_3 - " + НСтр("ru = 'О передаче резидентом товаров и оказании услуг нерезиденту по контрактам, указанным в подпункте 5.1.2 пункта 5.1 настоящей Инструкции'"));
	СписокКодовВидаДокумента.Добавить("03_4", "03_4 - " + НСтр("ru = 'О получении резидентом товаров и услуг от нерезидента по контрактам, указанным в подпункте 5.1.2 пункта 5.1настоящей Инструкции'"));
	СписокКодовВидаДокумента.Добавить("04_3", "04_3 - " + НСтр("ru = 'О выполненных резидентом работах, оказанных услугах, переданных информации и результатах интеллектуальной деятельности, в том числе исключительных прав на них, о переданном резидентом в аренду движимом и (или) недвижимом имуществе, за исключением документов с кодами 03_3 и 15_3'"));
	СписокКодовВидаДокумента.Добавить("04_4", "04_4 - " + НСтр("ru = 'О выполненных нерезидентом работах оказанных услугах, переданных информации и результатах интеллектуальной деятельности, в том числе исключительных прав на них, о переданном нерезидентом в аренду движимом и (или) недвижимом имуществе, за исключением документов с кодами 03_4 и 15_4'"));
	СписокКодовВидаДокумента.Добавить("05_3", "05_3 - " + НСтр("ru = 'О прощении резидентом долга(основной долг) нерезиденту по кредитному договору'"));
	СписокКодовВидаДокумента.Добавить("05_4", "05_4 - " + НСтр("ru = 'О прощении нерезидентом долга (основной долг) резиденту по кредитному договору'"));
	СписокКодовВидаДокумента.Добавить("06_3", "06_3 - " + НСтр("ru = 'О зачете встречных однородных требований, при котором обязательства нерезидента по возврату основного долга по кредитному договору прекращаются полностью или изменяются обязательства (снижается сумма основного долга)'"));
	СписокКодовВидаДокумента.Добавить("06_4", "06_4 - " + НСтр("ru = 'О зачете встречных однородных требований, при котором обязательства резидента по возврату основного долга по кредитному договору прекращаются полностью или изменяются обязательства (снижается сумма основного долга)'"));
	СписокКодовВидаДокумента.Добавить("07_3", "07_3 - " + НСтр("ru = 'Об уступке резидентом требования к должнику-нерезиденту по возврату основного долга по кредитному договору иному лицу - нерезиденту способом, отличным от расчетов'"));
	СписокКодовВидаДокумента.Добавить("07_4", "07_4 - " + НСтр("ru = 'Об уступке нерезидентом требования к должнику-резиденту по возврату основного долга по кредитному договору в пользу иного лица - резидента способом, отличным от расчетов'"));
	СписокКодовВидаДокумента.Добавить("08_3", "08_3 - " + НСтр("ru = 'О переводе нерезидентом своего долга по возврату основного долга по кредитному договору на иное лицо - резидента способом, отличным от расчетов'"));
	СписокКодовВидаДокумента.Добавить("08_4", "08_4 - " + НСтр("ru = 'О переводе резидентом своего долга по возврату основного долга по кредитному договору на иное лицо - нерезидента способом, отличным от расчетов'"));
	СписокКодовВидаДокумента.Добавить("09_3", "09_3 - " + НСтр("ru = 'О прекращении обязательств или об изменении (снижении суммы) обязательств нерезидента по кредитному договору в связи с новацией (заменой первоначального обязательства должника-нерезидента другим обязательством), за исключением новации, осуществляемой посредством передачи должником-нерезидентом резиденту векселя или иных ценных бумаг'"));
	СписокКодовВидаДокумента.Добавить("09_4", "09_4 - " + НСтр("ru = 'О прекращении обязательств или об изменении (снижении суммы) обязательств резидента по кредитному договору в связи с новацией (заменой первоначального обязательства должника-резидента другим обязательством), за исключением новации, осуществляемой посредством передачи должником-резидентом нерезиденту векселя или иных ценных бумаг'"));
	СписокКодовВидаДокумента.Добавить("10_3", "10_3 - " + НСтр("ru = 'О прекращении обязательств или об изменении (снижении суммы) обязательств нерезидента, связанных с оплатой товаров (работ, услуг, переданных информации и результатов интеллектуальной деятельности, в том числе исключительных прав на них, с арендой движимого и (или) недвижимого имущества ) по контракту или с возвратом нерезидентом основного долга по кредитному договору посредством передачи нерезидентом резиденту векселя или иных ценных бумаг'"));
	СписокКодовВидаДокумента.Добавить("10_4", "10_4 - " + НСтр("ru = 'О прекращении обязательств или об изменении (снижении суммы) обязательств резидента, связанных с оплатой товаров (работ, услуг, переданной информации и результатов интеллектуальной деятельности, в том числе исключительных прав на них, с арендой движимого и (или) недвижимого имущества) по контракту или с возвратом резидентом основного долга по кредитному договору посредством передачи резидентом нерезиденту векселя или иных ценных бумаг'"));
	СписокКодовВидаДокумента.Добавить("11_3", "11_3 - " + НСтр("ru = 'О полном или частичном исполнении обязательств по возврату основного долга нерезидента по кредитному договору иным лицом-резидентом'"));
	СписокКодовВидаДокумента.Добавить("11_4", "11_4 - " + НСтр("ru = 'О полном или частичном исполнении обязательств по возврату основного долга резидента по кредитному договору третьим лицом-нерезидентом'"));
	СписокКодовВидаДокумента.Добавить("12_3", "12_3 - " + НСтр("ru = 'Об изменении обязательств (увеличении задолженности по основному долгу) резидента перед нерезидентом по кредитному договору'"));
	СписокКодовВидаДокумента.Добавить("12_4", "12_4 - " + НСтр("ru = 'Об изменении обязательств (увеличении задолженности по основному долгу) нерезидента перед резидентом по кредитному договору'"));
	СписокКодовВидаДокумента.Добавить("13_3", "13_3 - " + НСтр("ru = 'Об иных способах исполнения (изменения, прекращения) обязательств нерезидента перед резидентом по контракту (кредитному договору), включая возврат нерезидентом ранее полученных товаров, за исключением иных кодов видов подтверждающих документов, указанных в настоящей таблице'"));
	СписокКодовВидаДокумента.Добавить("13_4", "13_4 - " + НСтр("ru = 'Об иных способах исполнения (изменения, прекращения) обязательств резидента перед нерезидентом по контракту (кредитному договору), включая возврат резидентом ранее полученных товаров, за исключением иных кодов видов подтверждающих документов, указанных в настоящей таблице'"));
	СписокКодовВидаДокумента.Добавить("15_3", "15_3 - " + НСтр("ru = 'О переданном резидентом в финансовую аренду (лизинг) имуществе'"));
	СписокКодовВидаДокумента.Добавить("15_4", "15_4 - " + НСтр("ru = 'О переданном нерезидентом в финансовую аренду (лизинг) имуществе'"));
	СписокКодовВидаДокумента.Добавить("16_3", "16_3 - " + НСтр("ru = 'Об удержании банками банковских комиссий за перевод денежных средств, причитающихся резиденту по контракту (кредитному договору), либо из сумм возвращаемых денежных средств, ранее переведенных нерезиденту по контракту (кредитному договору)'"));
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписьФайлыДляПередачиВБанк()
	
	Элементы.НадписьФайлыДляПередачиВБанк.Заголовок =
		ДенежныеСредстваСерверЛокализация.НадписьФайлыДляПередачиВБанк(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьЗависимыеЭлементыФормы(ИзмененныйРеквизит = "")
	
	ДенежныеСредстваКлиентСервер.НастроитьЭлементыФормы(ЭтаФорма, ИзмененныйРеквизит, РеквизитыФормы(ЭтаФорма));
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормыНаСервере(ИзмененныйРеквизит = "")
	
	ДенежныеСредстваКлиентСервер.НастроитьЭлементыФормы(ЭтаФорма, ИзмененныйРеквизит, РеквизитыФормы(ЭтаФорма));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РеквизитыФормы(Форма)
	
	РеквизитыФормы = Новый Структура;
	РеквизитыФормы.Вставить("ПодтверждающийДокументЗаполнен");
	
	ЗаполнитьЗначенияСвойств(РеквизитыФормы, Форма);
	
	Возврат РеквизитыФормы;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодтверждающиеДокументыНомерДокумента.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодтверждающиеДокументыДатаДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПодтверждающиеДокументы.ПодтверждающийДокумент");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

#КонецОбласти
