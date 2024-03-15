
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтатусыОтказа = Новый СписокЗначений;
	СтатусыОтказа.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.Отменен);
	СтатусыОтказа.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ОтмененПоставщиком);
	СтатусыОтказа.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ЗапросНаОтменуПроведенияКПередаче);
	СтатусыОтказа.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ЗапросНаОтменуПроведенияПереданВУТМ);
	СтатусыОтказа.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ЗапросНаОтменуПроведенияОбрабатываетсяЕГАИС);
	СтатусыОтказа.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.ЗапросНаОтменуПроведенияОшибка);
	СтатусыОтказа.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.АктОтказаКПередаче);
	СтатусыОтказа.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.АктОтказаПереданВУТМ);
	СтатусыОтказа.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.АктОтказаОбрабатываетсяЕГАИС);
	СтатусыОтказа.Добавить(Перечисления.СтатусыОбработкиТТНВходящейЕГАИС.АктОтказаОшибка);
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИСПереопределяемый.ИспользуетсяПеремещениеТоваров(ИспользуетсяПеремещениеТоваров);
	
	ПереопределитьТекстЗапросаСписка();
	
	ПустыеЗначенияДокументаОснования = Новый Массив;
	ПустыеЗначенияДокументаОснования.Добавить(Неопределено);
	Для Каждого ТипыДокументаПоступления Из Метаданные.ОпределяемыеТипы.ОснованиеТТНВходящаяЕГАИС.Тип.Типы() Цикл
		ПустыеЗначенияДокументаОснования.Добавить(Документы[Метаданные.НайтиПоТипу(ТипыДокументаПоступления).Имя].ПустаяСсылка());
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список,
		"ПустыеЗначенияДокументаОснования",
		ПустыеЗначенияДокументаОснования,
		Истина);
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Организация",           Организация,           СтруктураБыстрогоОтбора);
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "ТорговыйОбъект",        ТорговыйОбъект,        СтруктураБыстрогоОтбора);
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "СтатусЕГАИС",           СтатусЕГАИС,           СтруктураБыстрогоОтбора);
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "ОформлениеПоступления", ОформлениеПоступления, СтруктураБыстрогоОтбора);
	
	Если ИнтеграцияЕГАИСКлиентСервер.НеобходимОтборПоДальнейшемуДействиюЕГАИСПриСозданииНаСервере(ДальнейшееДействиеЕГАИС, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
	ИнтеграцияЕГАИС.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.ДальнейшееДействиеЕГАИС.СписокВыбора,
		ВсеТребующиеДействия(),
		ВсеТребующиеОжидания());
	
	Элементы.ТорговыйОбъект.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	Элементы.Организация.Видимость    = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	ИнтеграцияИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	ПравоДоступаИзменение = ПравоДоступа("Изменение", Метаданные.Документы.ТТНВходящаяЕГАИС) ИЛИ Пользователи.ЭтоПолноправныйПользователь();
	Элементы.СписокПодтвердитьПолучение.Доступность  = ПравоДоступаИзменение;
	Элементы.СписокОтказатьсяОтНакладной.Доступность = ПравоДоступаИзменение;
	
	СобственнаяОрганизацияЗначениеПоУмолчанию    = Неопределено;
	СобственныйТорговыйОбъектЗначениеПоУмолчанию = Неопределено;
	ИнтеграцияЕГАИСПереопределяемый.ЗначенияПоУмолчаниюНеСопоставленныхОбъектов(
		СобственнаяОрганизацияЗначениеПоУмолчанию,
		СобственныйТорговыйОбъектЗначениеПоУмолчанию);
	
	МассивТиповСобственнаяОрганизация = Новый Массив;
	МассивТиповСобственнаяОрганизация.Добавить(ТипЗнч(СобственнаяОрганизацияЗначениеПоУмолчанию));
	Элементы.Организация.ОграничениеТипа = Новый ОписаниеТипов(МассивТиповСобственнаяОрганизация);
	
	МассивТиповСобственныйТорговыйОбъект = Новый Массив;
	МассивТиповСобственныйТорговыйОбъект.Добавить(ТипЗнч(СобственныйТорговыйОбъектЗначениеПоУмолчанию));
	Элементы.ТорговыйОбъект.ОграничениеТипа = Новый ОписаниеТипов(МассивТиповСобственныйТорговыйОбъект);
	
	ИнтеграцияЕГАИС.УстановитьВидимостьКомандыВыполнитьОбмен(ЭтотОбъект, "СписокВыполнитьОбмен");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
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
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(СобытияФормИСКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = ИнтеграцияЕГАИСКлиент.ИмяСобытияЗаписиПоступленияТоваров()
		ИЛИ ИмяСобытия = "ИзменениеСостоянияЕГАИС" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	СобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если ИнтеграцияЕГАИСКлиентСервер.НеобходимОтборПоДальнейшемуДействиюЕГАИСПередЗагрузкойИзНастроек(ДальнейшееДействиеЕГАИС, СтруктураБыстрогоОтбора, Настройки) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "СтатусЕГАИС",
	                                                                       СтатусЕГАИС,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "ТорговыйОбъект",
	                                                                       ТорговыйОбъект,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "Организация",
	                                                                       Организация,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "ОформлениеПоступления",
	                                                                       ОформлениеПоступления,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);
	
	Настройки.Удалить("ОформлениеПоступления");
	Настройки.Удалить("ДальнейшееДействиеЕГАИС");
	Настройки.Удалить("СтатусЕГАИС");
	Настройки.Удалить("ТорговыйОбъект");
	Настройки.Удалить("Организация");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТорговыйОбъектПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ТорговыйОбъект",
		ТорговыйОбъект,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ТорговыйОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусЕГАИСПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"СтатусЕГАИС",
		СтатусЕГАИС,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(СтатусЕГАИС));
	
КонецПроцедуры

&НаКлиенте
Процедура ДальнейшееДействиеЕГАИСПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура ОформлениеПоступленияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"ОформлениеПоступления",
		ОформлениеПоступления,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ОформлениеПоступления));
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаЖурналЗакупкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ОткрытьЖурнал(ПараметрыЖурнала());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОформитьДокументПоступления(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтатусыОтказа.НайтиПоЗначению(ТекущаяСтрока.СтатусЕГАИС) <> Неопределено Тогда
		ПоказатьПредупреждениеПоступлениеНеТребуется();
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.ПоступлениеТоваров) Тогда
		
		Если Команда <> Неопределено Тогда
			ПоказатьПредупреждениеПоступлениеУжеОформлено();
		Иначе
			ПоказатьЗначение(, ТекущаяСтрока.ПоступлениеТоваров);
		КонецЕсли;
		
	ИначеЕсли СтатусыОтказа.НайтиПоЗначению(ТекущаяСтрока.СтатусЕГАИС) = Неопределено Тогда
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("СоздатьДокументПоступления", НСтр("ru = 'Оформить новое поступление'"),       Ложь);
		Кнопки.Добавить("ВыбратьДокументПоступления", НСтр("ru = 'Связать с имеющимся поступлением'"), Ложь);
		
		Если ИспользуетсяПеремещениеТоваров Тогда
			Кнопки.Добавить("ВыбратьДокументПеремещения", НСтр("ru = 'Связать с имеющимся перемещением'"), Ложь);
		КонецЕсли;
		
		Кнопки.Добавить("Отмена", НСтр("ru = 'Отмена'"), Ложь);
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбработатьОтветНаВопросОСвязыванииСПрикладнымДокументом",
				ЭтотОбъект,
				Новый Структура("ТТНСсылка", ТекущаяСтрока.Ссылка)),
				НСтр("ru='Оформить новый документ или связать с уже имеющимся?'"), 
				Кнопки);
	
	ИначеЕсли СтатусыОтказа.НайтиПоЗначению(ТекущаяСтрока.СтатусЕГАИС) <> Неопределено Тогда
		
		ПоказатьПредупреждениеПоступлениеНеТребуется();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставитьКлассификаторыЕГАИС(Команда)
	
	ОчиститьСообщения();
	
	ТоварноТранспортныеНакладные = Новый Массив;
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока);
		Если ДанныеСтроки <> Неопределено Тогда
			ТоварноТранспортныеНакладные.Добавить(ДанныеСтроки.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	ОткрытьФормуСопоставленияКлассификаторовЕГАИС(ТоварноТранспортныеНакладные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьПолучение(Команда)
	
	ОчиститьСообщения();
	
	ИнтеграцияЕГАИСКлиент.ПодготовитьСообщенияКПередаче(
		Элементы.Список,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПодтвердитеПолучение"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтказатьсяОтНакладной(Команда)
	
	ОчиститьСообщения();
	
	ИнтеграцияЕГАИСКлиент.ПодготовитьСообщенияКПередаче(
		Элементы.Список,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОткажитесьОтНакладной"));

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияЕГАИСКлиент.ВыполнитьОбмен(,,ЭтотОбъект.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура АрхивироватьДокументы(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Элементы.Список, ИнтеграцияЕГАИСКлиент);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда) Экспорт
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды() Экспорт
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда) Экспорт
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТоварноТранспортныеНакладные

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.СписокПоступлениеТоваров Тогда
		
		СтандартнаяОбработка = Ложь;
		КомандаОформитьДокументПоступления(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПоступлениеТоваров.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ПоступлениеТоваров");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СтатусЕГАИС");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ОтборЭлемента.ПравоеЗначение = СтатусыОтказа;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<требуется оформить>'"));
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПоступлениеТоваров.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ПоступлениеТоваров");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПоступлениеТоваров.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ПоступлениеТоваров");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СтатусЕГАИС");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СтатусыОтказа;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<не требуется>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
КонецПроцедуры

#Область ОтборДальнейшиеДействия

&НаСервереБезКонтекста
Функция ВсеТребующиеДействия()
	
	Возврат Документы.ТТНВходящаяЕГАИС.ВсеТребующиеДействия();
	
КонецФункции

&НаСервереБезКонтекста
Функция ВсеТребующиеОжидания()
	
	Возврат Документы.ТТНВходящаяЕГАИС.ВсеТребующиеОжидания();
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияЕГАИС.УстановитьОтборПоДальнейшемуДействию(Список,
	                                                     ДальнейшееДействиеЕГАИС,
	                                                     ВсеТребующиеДействия(),
	                                                     ВсеТребующиеОжидания());
	
КонецПроцедуры

#КонецОбласти

#Область ОформлениеПоступления

&НаКлиенте
Процедура ОбработатьОтветНаВопросОСвязыванииСПрикладнымДокументом(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "СоздатьДокументПоступления" Тогда
		
		СоздатьДокументПоступления(ДополнительныеПараметры.ТТНСсылка);
		
	ИначеЕсли Результат = "ВыбратьДокументПоступления" Тогда
		
		ВыбратьДокументПоступления(ДополнительныеПараметры.ТТНСсылка);
		
	ИначеЕсли Результат = "ВыбратьДокументПеремещения" Тогда
		
		ВыбратьДокументПеремещения(ДополнительныеПараметры.ТТНСсылка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОтветНаВопросОбОткрытииФормыСопоставленияКлассификаторовЕГАИС(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(ДополнительныеПараметры.ТТНСсылка);
	
	ОткрытьФормуСопоставленияКлассификаторовЕГАИС(МассивСсылок, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуСопоставленияКлассификаторовЕГАИС(ТоварноТранспортныеНакладные, ДополнительныеПараметры = Неопределено)
	
	Если ТоварноТранспортныеНакладные.Количество() = 0 Тогда
		ПоказатьПредупреждение(,ИнтеграцияИСКлиентСервер.ТекстКомандаНеМожетБытьВыполнена());
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ТоварноТранспортныеНакладные", ТоварноТранспортныеНакладные);
	
	СобытияФормЕГАИСКлиент.ОткрытьФормуСопоставленияКлассификаторовЕГАИС(
		ЭтотОбъект,
		Новый ОписаниеОповещения("ОбработатьРезультатСопоставленияКлассификаторовЕГАИС", ЭтотОбъект, ДополнительныеПараметры),
		ПараметрыОткрытияФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатСопоставленияКлассификаторовЕГАИС(Результат, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		Если ДополнительныеПараметры.Свойство("СоздатьДокументПоступления") Тогда
			СоздатьДокументПоступления(ДополнительныеПараметры.ТТНСсылка, Ложь);
		ИначеЕсли ДополнительныеПараметры.Свойство("ВыбратьДокументПоступления") Тогда
			ВыбратьДокументПоступления(ДополнительныеПараметры.ТТНСсылка, Ложь);
		КонецЕсли;
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументПоступления(ТТНСсылка, СопоставлятьКлассификаторы = Истина)
	
	РезультатПроверки = ИнтеграцияЕГАИСВызовСервера.ПроверитьСопоставлениеКлассификаторов(ТТНСсылка);
	Если Не РезультатПроверки.ЕстьНеСопоставленныеТовары
		И Не РезультатПроверки.ЕстьНеСопоставленныеОрганизации Тогда
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуСозданияДокументаПоступленияТоваровНаОснованииТТНЕГАИС(ТТНСсылка);
		
	Иначе
		
		Если Не СопоставлятьКлассификаторы Тогда
			Возврат;
		КонецЕсли;
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да,  НСтр("ru = 'Сопоставить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Отмена'"));
		
		ДополнительныеПараметры2 = Новый Структура;
		ДополнительныеПараметры2.Вставить("СоздатьДокументПоступления", Истина);
		ДополнительныеПараметры2.Вставить("ТТНСсылка", ТТНСсылка);
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ОбработатьОтветНаВопросОбОткрытииФормыСопоставленияКлассификаторовЕГАИС",
				ЭтотОбъект,
				ДополнительныеПараметры2),
			НСтр("ru='В документе найдены несопоставленные элементы классификаторов ЕГАИС.
			         |Сопоставить классификаторы?'"),
			Кнопки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьДокументПоступления(ТТНСсылка, СопоставлятьКлассификаторы = Истина)
	
	РезультатПроверки = ИнтеграцияЕГАИСВызовСервера.ПроверитьСопоставлениеКлассификаторов(ТТНСсылка);
	Если Не РезультатПроверки.ЕстьНеСопоставленныеТовары
		И Не РезультатПроверки.ЕстьНеСопоставленныеОрганизации Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ТТНСсылка", ТТНСсылка);
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуВыбораДокументаПоступлениеТоваровУслуг(
			ЭтотОбъект,
			Новый ОписаниеОповещения(
				"ОбработатьВыборДокументаПоступления",
				ЭтотОбъект,
				Новый Структура("ТТНСсылка", ТТНСсылка)),
			ТТНСсылка);
			
	Иначе
		
		Если Не СопоставлятьКлассификаторы Тогда
			Возврат;
		КонецЕсли;
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да,  НСтр("ru = 'Сопоставить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Отмена'"));
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ВыбратьДокументПоступления", Истина);
		ДополнительныеПараметры.Вставить("ТТНСсылка",                  ТТНСсылка);
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ОбработатьОтветНаВопросОбОткрытииФормыСопоставленияКлассификаторовЕГАИС",
				ЭтотОбъект,
				ДополнительныеПараметры),
			НСтр("ru='В документе найдены несопоставленные элементы классификаторов ЕГАИС.
			         |Сопоставить классификаторы?'"),
			Кнопки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьДокументПеремещения(ТТНСсылка, СопоставлятьКлассификаторы = Истина)
	
	РезультатПроверки = ИнтеграцияЕГАИСВызовСервера.ПроверитьСопоставлениеКлассификаторов(ТТНСсылка);
	Если Не РезультатПроверки.ЕстьНеСопоставленныеТовары
		И Не РезультатПроверки.ЕстьНеСопоставленныеОрганизации Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ТТНСсылка", ТТНСсылка);
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуВыбораДокументаПеремещениеТоваров(
			ЭтотОбъект,
			Новый ОписаниеОповещения(
				"ОбработатьВыборДокументаПоступления",
				ЭтотОбъект,
				Новый Структура("ТТНСсылка", ТТНСсылка)),
			ТТНСсылка);
			
	Иначе
		
		Если Не СопоставлятьКлассификаторы Тогда
			Возврат;
		КонецЕсли;
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да,  НСтр("ru = 'Сопоставить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Отмена'"));
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ВыбратьДокументПоступления", Истина);
		ДополнительныеПараметры.Вставить("ТТНСсылка",                  ТТНСсылка);
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ОбработатьОтветНаВопросОбОткрытииФормыСопоставленияКлассификаторовЕГАИС",
				ЭтотОбъект,
				ДополнительныеПараметры),
			НСтр("ru='В документе найдены несопоставленные элементы классификаторов ЕГАИС.
			         |Сопоставить классификаторы?'"),
			Кнопки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборДокументаПоступления(ВыбранныйДокумент, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(ВыбранныйДокумент) Тогда
		Возврат;
	КонецЕсли;
	
	Если ИнтеграцияЕГАИСВызовСервера.ЕстьРасхожденияМеждуДокументомПоступленияИТТНЕГАИС(ДополнительныеПараметры.ТТНСсылка, ВыбранныйДокумент) Тогда
		
		Контекст = Новый Структура;
		Контекст.Вставить("ТТНСсылка",           ДополнительныеПараметры.ТТНСсылка);
		Контекст.Вставить("ДокументПоступления", ВыбранныйДокумент);
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ОбработатьОтветНаВопросОРасхожденияхПослеВыбораДокументаПоступления",
				ЭтотОбъект,
				Контекст),
			НСтр("ru='В товарах выбранного документа есть алкогольная продукция, которой нет в документа ТТН ЕГАИС (входящая). Продолжить выбор?'"), 
			РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ИнтеграцияЕГАИСВызовСервера.ЗаписатьСвязьДокументаПоступленияИТТНЕГАИС(
			ДополнительныеПараметры.ТТНСсылка,
			ВыбранныйДокумент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОтветНаВопросОРасхожденияхПослеВыбораДокументаПоступления(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИСВызовСервера.ЗаписатьСвязьДокументаПоступленияИТТНЕГАИС(
		ДополнительныеПараметры.ТТНСсылка,
		ДополнительныеПараметры.ДокументПоступления);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПредупреждениеПоступлениеНеТребуется()
	
	ПоказатьПредупреждение(, НСтр("ru='Поступление товаров для данной ТТН ЕГАИС не требуется.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПредупреждениеПоступлениеУжеОформлено()
	
	ПоказатьПредупреждение(, НСтр("ru='Поступление товаров для данной ТТН ЕГАИС уже оформлено.'"));
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПриобретениеТоваровУслуг.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаказПоставщику.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	Если Не ШтрихкодированиеНоменклатурыКлиент.ШтрихкодыВалидны(Данные) Тогда
		Возврат;
	КонецЕсли;
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, Ссылка);
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Функция ПараметрыЖурнала()
	
	СтруктураБыстрогоОтбора = Новый Структура;
	СтруктураБыстрогоОтбора.Вставить("Организация",Организация);
	СтруктураБыстрогоОтбора.Вставить("Склад",ТорговыйОбъект);
	
	ПараметрыЖурнала = Новый Структура;
	ПараметрыЖурнала.Вставить("СтруктураБыстрогоОтбора",СтруктураБыстрогоОтбора);
	ПараметрыЖурнала.Вставить("ИмяРабочегоМеста","ЖурналДокументовЗакупки");
	ПараметрыЖурнала.Вставить("КлючНазначенияФормы","Накладные");
	ПараметрыЖурнала.Вставить("СинонимЖурнала",НСтр("ru = 'Документы закупки'"));
	
	Возврат ПараметрыЖурнала;
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура ПереопределитьТекстЗапросаСписка()
	
	ТекстЗапроса = "";
	ИнтеграцияЕГАИСПереопределяемый.ТекстЗапросаТТН(ТекстЗапроса);
	Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
