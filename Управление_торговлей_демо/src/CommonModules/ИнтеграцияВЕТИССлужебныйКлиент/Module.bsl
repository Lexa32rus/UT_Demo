
#Область ПрограммныйИнтерфейс

// Только для внутреннего использования.
// Вызывается из: ПослеЗавершенияОбмена
Процедура ОткрытьРезультатВыполненияОбмена(ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.Изменения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.РезультатВыполненияОбменаВЕТИС", ДополнительныеПараметры);
	
КонецПроцедуры

// Только для внутреннего использования.
// Вызывается из: ОповещениеПослеЗавершенииОбмена
Процедура ПослеЗавершенияОбмена(Изменения, ДополнительныеПараметры) Экспорт
	
	СоответствиеДокументыОснования        = Новый Соответствие;
	СоответствиеДокументыСтатусы          = Новый Соответствие;
	СоответствиеИзмененныеДокументы       = Новый Соответствие;
	СоответствиеОшибкиСервисаПоДокументам = Новый Соответствие;
	
	ПараметрыСостоянияОбмена = Новый Структура;
	ПараметрыСостоянияОбмена.Вставить("ИзмененныеВСД",                     Новый Массив);
	ПараметрыСостоянияОбмена.Вставить("ИзмененныеЗаписиСкладскогоЖурнала", Новый Массив);
	ПараметрыСостоянияОбмена.Вставить("ЕстьОшибкиСервисаПриПолученииСписковВСД" ,                     Ложь);
	ПараметрыСостоянияОбмена.Вставить("ЕстьОшибкиСервисаПриПолученииСписковЗаписейСкладскогоЖурнала", Ложь);
	ПараметрыСостоянияОбмена.Вставить("ЕстьОшибкиСервисаПриОформленииДокументов",                     Ложь);
	ПараметрыСостоянияОбмена.Вставить("Документ");
	ПараметрыСостоянияОбмена.Вставить("ДокументТекстОшибки");
	
	Если ДополнительныеПараметры.Свойство("ОрганизацииВЕТИС") Тогда
		ПараметрыСостоянияОбмена.Вставить("ОрганизацииВЕТИС", ДополнительныеПараметры.ОрганизацииВЕТИС);
	КонецЕсли;
	
	ОбновитьСписокЗаписейСкладскогоЖурнала = Ложь;
	ОбновитьСписокВСД                      = Ложь;
	
	Для Каждого ЭлементДанных Из Изменения Цикл
		
		Если ЗначениеЗаполнено(ЭлементДанных.ТекстОшибки) Тогда
			
			Если ДополнительныеПараметры.ОповещениеПриЗавершении = Неопределено Тогда
				
				Если ЭлементДанных.ЕстьОшибкиСервиса
					И (ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросЗаписейСкладскогоЖурнала")
					Или ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросИзмененныхЗаписейСкладскогоЖурнала")) Тогда
					ПараметрыСостоянияОбмена.ЕстьОшибкиСервисаПриПолученииСписковЗаписейСкладскогоЖурнала = Истина;
				ИначеЕсли ЭлементДанных.ЕстьОшибкиСервиса
					И (ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросВсехВСД")
					Или ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросИзмененныхВСД")) Тогда
					ПараметрыСостоянияОбмена.ЕстьОшибкиСервисаПриПолученииСписковВСД = Истина;
				ИначеЕсли ЭлементДанных.ЕстьОшибкиСервиса Тогда
					Если ЭлементДанных.ДокументОснование <> Неопределено Тогда
						СоответствиеОшибкиСервисаПоДокументам.Вставить(ЭлементДанных.ДокументОснование, ЭлементДанных.ТекстОшибки);
					ИначеЕсли ЭлементДанных.Объект <> Неопределено Тогда
						СоответствиеОшибкиСервисаПоДокументам.Вставить(ЭлементДанных.Объект, ЭлементДанных.ТекстОшибки);
					КонецЕсли;
					ПараметрыСостоянияОбмена.ЕстьОшибкиСервисаПриОформленииДокументов = Истина;
				Иначе
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ЭлементДанных.ТекстОшибки);
				КонецЕсли;
				
			Иначе
				СообщитьПользователюБезДублированияВФорму(ДополнительныеПараметры, ЭлементДанных.ТекстОшибки);
			КонецЕсли;
			
		Иначе
			
			Если (Не ОбновитьСписокЗаписейСкладскогоЖурнала Или Не ОбновитьСписокВСД)
				И (ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросОформленияВходящейПартии")
				Или ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросОформленияПроизводственнойПартии")
				Или ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросОформленияТранспортнойПартии")) Тогда
				
				ОбновитьСписокЗаписейСкладскогоЖурнала = Истина;
				ОбновитьСписокВСД                      = Истина;
				
			КонецЕсли;
			
			Если Не ОбновитьСписокЗаписейСкладскогоЖурнала
				И (ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросЗаписиСкладскогоЖурнала")
				Или ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросЗаписейСкладскогоЖурнала")
				Или ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросИзмененныхЗаписейСкладскогоЖурнала")
				Или ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросОбъединенияЗаписейСкладскогоЖурнала")
				Или ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросОформленияРезультатовИнвентаризации")) Тогда
				
				ОбновитьСписокЗаписейСкладскогоЖурнала = Истина;
				
				Если ТипЗнч(ЭлементДанных.Объект) = Тип("Массив") Тогда
					ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
						ПараметрыСостоянияОбмена.ИзмененныеЗаписиСкладскогоЖурнала, ЭлементДанных.Объект);
				ИначеЕсли ТипЗнч(ЭлементДанных.Объект) = Тип("СправочникСсылка.ЗаписиСкладскогоЖурналаВЕТИС") Тогда
					ПараметрыСостоянияОбмена.ИзмененныеЗаписиСкладскогоЖурнала.Добавить(ЭлементДанных.Объект);
				КонецЕсли;
				
			КонецЕсли;
			
			Если ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросВСД")
				Или ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросВсехВСД")
				Или ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросИзмененныхВСД") Тогда
				
				ОбновитьСписокВСД = Истина;
				
				Если ТипЗнч(ЭлементДанных.Объект) = Тип("Массив") Тогда
					ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
						ПараметрыСостоянияОбмена.ИзмененныеВСД, ЭлементДанных.Объект);
				ИначеЕсли ТипЗнч(ЭлементДанных.Объект) = Тип("СправочникСсылка.ВетеринарноСопроводительныйДокументВЕТИС") Тогда
					ПараметрыСостоянияОбмена.ИзмененныеВСД.Добавить(ЭлементДанных.Объект);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		СоответствиеДокументыОснования.Вставить(ЭлементДанных.Объект, ЭлементДанных.ДокументОснование);
		СоответствиеДокументыСтатусы.Вставить(ЭлементДанных.Объект, ЭлементДанных.НовыйСтатус);
		Если ЭлементДанных.ОбъектИзменен Тогда
			СоответствиеИзмененныеДокументы.Вставить(ЭлементДанных.Объект, Истина);
		КонецЕсли;
		
	КонецЦикла;
	
	Если СоответствиеОшибкиСервисаПоДокументам.Количество() = 1 Тогда
		Для Каждого КлючИЗначение Из СоответствиеОшибкиСервисаПоДокументам Цикл
			ПараметрыСостоянияОбмена.Документ            = КлючИЗначение.Ключ;
			ПараметрыСостоянияОбмена.ДокументТекстОшибки = КлючИЗначение.Значение;
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из СоответствиеДокументыОснования Цикл
		
		ОбъектИзменен = СоответствиеИзмененныеДокументы.Получить(КлючИЗначение.Ключ);
		Если ОбъектИзменен = Неопределено Тогда
			ОбъектИзменен = Ложь;
		КонецЕсли;
		
		ПараметрОповещения = Новый Структура;
		ПараметрОповещения.Вставить("Ссылка",        КлючИЗначение.Ключ);
		ПараметрОповещения.Вставить("Основание",     КлючИЗначение.Значение);
		ПараметрОповещения.Вставить("ОбъектИзменен", ОбъектИзменен);
		
		Оповестить(ИнтеграцияИСКлиентСервер.ИмяСобытияИзмененоСостояние(ИнтеграцияВЕТИСКлиентСервер.ИмяПодсистемы()), ПараметрОповещения);
		
	КонецЦикла;
	
	Если ОбновитьСписокВСД Тогда
		Оповестить("ОбновитьСписок_ВетеринарноСопроводительныйДокументВЕТИС");
	КонецЕсли;
	Если ОбновитьСписокЗаписейСкладскогоЖурнала Тогда
		Оповестить("ОбновитьСписок_ЗаписиСкладскогоЖурналаВЕТИС");
		Оповестить("ОбновитьСписок_ОстаткиПродукцииВЕТИС");
	КонецЕсли;
	
	Если ТипЗнч(ДополнительныеПараметры.Контекст) = Тип("ТаблицаФормы") Тогда
		
		// Выполнено действие из динамического списка
		ТекстСообщения = СтрШаблон(
			НСтр("ru='Для %1 из %2 выделенных в списке документов выполнено действие: %3'"),
			СоответствиеДокументыСтатусы.Количество(),
			ДополнительныеПараметры.Контекст.ВыделенныеСтроки.Количество(),
			ДополнительныеПараметры.ДальнейшееДействие);
			
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Выполнено действие'"),,
			ТекстСообщения,
			БиблиотекаКартинок.Информация32);
		
	ИначеЕсли ЗначениеЗаполнено(ДополнительныеПараметры.Контекст) Тогда
		
		// Выполнено действие из формы документа
		Для Каждого КлючИЗначение Из СоответствиеДокументыСтатусы Цикл
			
			Если КлючИЗначение.Значение = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru='Для документа %1 изменен статус ВетИС: %2.'"),
				КлючИЗначение.Ключ,
				КлючИЗначение.Значение);
			
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Выполнено действие'"),
				ПолучитьНавигационнуюСсылку(КлючИЗначение.Ключ),
				ТекстСообщения,
				БиблиотекаКартинок.Информация32);
			
		КонецЦикла;
		
	Иначе
		
		// Выполнен обмен с ВЕТИС
		ДополнительныеПараметрыОповещения = Новый Структура;
		ДополнительныеПараметрыОповещения.Вставить("СоответствиеДокументыОснования", СоответствиеДокументыОснования);
		ДополнительныеПараметрыОповещения.Вставить("СоответствиеДокументыСтатусы",   СоответствиеДокументыСтатусы);
		ДополнительныеПараметрыОповещения.Вставить("Изменения",                      Изменения);
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Изменено объектов: %1'"), СоответствиеДокументыСтатусы.Количество());
		
		ПоказатьОповещениеПользователя(
			НСтр("ru='Выполнен обмен с ВетИС'"),
			Новый ОписаниеОповещения("ОткрытьРезультатВыполненияОбмена", ИнтеграцияВЕТИССлужебныйКлиент, ДополнительныеПараметрыОповещения),
			ТекстСообщения,
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Изменения);
	ИначеЕсли ПараметрыСостоянияОбмена.ЕстьОшибкиСервисаПриПолученииСписковВСД
		Или ПараметрыСостоянияОбмена.ЕстьОшибкиСервисаПриПолученииСписковЗаписейСкладскогоЖурнала
		Или ПараметрыСостоянияОбмена.ЕстьОшибкиСервисаПриОформленииДокументов Тогда
		
		ВладелецФормы = Неопределено;
		Если ДополнительныеПараметры <> Неопределено
			И ДополнительныеПараметры.Свойство("Форма") Тогда
			ВладелецФормы = ДополнительныеПараметры.Форма;
		КонецЕсли;
		
		ОткрытьФорму(
			"Обработка.ПанельОбменВЕТИС.Форма.СостоянияОбмена", ПараметрыСостоянияОбмена, ВладелецФормы);
		
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования.
// Вызывается из: ОповещениеПослеЗавершенииОбмена
Процедура ПослеЗавершенияДлительнойОперации(Результат, ДополнительныеПараметрыДлительнойОперации) Экспорт
	
	Если Результат = Неопределено Тогда // отменено пользователем
		Возврат;
	КонецЕсли;
	
	Если Результат.Сообщения <> Неопределено Тогда
		Для каждого СообщениеПользователю Из Результат.Сообщения Цикл
			СообщениеПользователю.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		РезультатОбмена = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		
		Форма                   = ДополнительныеПараметрыДлительнойОперации.Форма;
		ОповещениеПриЗавершении = ДополнительныеПараметрыДлительнойОперации.ОповещениеПриЗавершении;
		
		Если РезультатОбмена.Ожидать <> Неопределено Тогда
			
			Форма.АдресРезультатаОбменаВоВременномХранилище = РезультатОбмена.АдресВоВременномХранилище;
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ВыполнитьОбменОбработкаОжидания", РезультатОбмена.Ожидать, Истина);
			
		Иначе
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("Форма",                   Форма);
			ДополнительныеПараметры.Вставить("Контекст",                Неопределено);
			ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ОрганизацииВЕТИС") Тогда
				ДополнительныеПараметры.Вставить("ОрганизацииВЕТИС", Форма.ОрганизацииВЕТИС);
			Иначе
				ДополнительныеПараметры.Вставить("ОрганизацииВЕТИС", Неопределено);
			КонецЕсли;
			
			ИнтеграцияВЕТИССлужебныйКлиент.ПослеЗавершенияОбмена(
				РезультатОбмена.Изменения,
				ДополнительныеПараметры);
			
		КонецЕсли;
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ПодробноеПредставлениеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытий

Процедура ПослеЗавершенияВыбораОрганизацийВЕТИС(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ДополнительныеПараметры.Форма,
		Результат,
		ДополнительныеПараметры.ОповещениеПриЗавершении = Неопределено,
		ДополнительныеПараметры.Префикс,
		ДополнительныеПараметры.Префиксы,
		ДополнительныеПараметры.ПрефиксыСписков);
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Результат);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьРедактированиеПериода(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВходящийОбъект = ДополнительныеПараметры.ВходящийОбъект;
	СоответствиеРеквизитов = ДополнительныеПараметры.СоответствиеРеквизитов;
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда 
		Результат.Свойство("НачалоПериода",             ВходящийОбъект[СоответствиеРеквизитов.НачалоПериода]);
		Результат.Свойство("КонецПериода",              ВходящийОбъект[СоответствиеРеквизитов.КонецПериода]);
		Результат.Свойство("ПредставлениеПериода",      ВходящийОбъект[СоответствиеРеквизитов.ПредставлениеПериода]);
		Результат.Свойство("ТочностьЗаполненияПериода", ВходящийОбъект[СоответствиеРеквизитов.ТочностьЗаполненияПериода]);
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Результат);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыАктаОНесоответствии(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыАктаОНесоответствииИзменены = Ложь;
	Для Каждого КлючИЗначение Из Результат Цикл
		РеквизитыАктаОНесоответствииИзменены = РеквизитыАктаОНесоответствииИзменены ИЛИ
		(КлючИЗначение.Значение <> ДополнительныеПараметры.Форма.Объект[КлючИЗначение.Ключ]);
	КонецЦикла;
	
	Если РеквизитыАктаОНесоответствииИзменены Тогда
		ЗаполнитьЗначенияСвойств(ДополнительныеПараметры.Форма.Объект,Результат);
		ДополнительныеПараметры.Форма.Модифицированность = Истина;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Результат);
	КонецЕсли;
	
КонецПроцедуры

// Для исключения дублирования выводимой информации в элементы формы и контекст формы/приложения
//
Процедура СообщитьПользователюБезДублированияВФорму(ДополнительныеПараметры, ТекстСообщения)

	ВладелецФормы = Неопределено;
	Если ДополнительныеПараметры <> Неопределено
		И ДополнительныеПараметры.Свойство("Форма") Тогда
		ВладелецФормы = ДополнительныеПараметры.Форма;
	КонецЕсли;

	Если ВладелецФормы <> Неопределено Тогда

		// Перечислены формы с использованием метода:
		// ИнтеграцияВЕТИСКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);

		ИменаФормИсключений = Новый Массив;
		ИменаФормИсключений.Добавить("Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Форма.Аннулирование");
		ИменаФормИсключений.Добавить("Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Форма.ВетеринарныеМероприятия");
		ИменаФормИсключений.Добавить("Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Форма.ЗапросВСД");
		ИменаФормИсключений.Добавить("Справочник.ЗаписиСкладскогоЖурналаВЕТИС.Форма.ВетеринарныеМероприятия");
		ИменаФормИсключений.Добавить("Справочник.ПродукцияВЕТИС.Форма.ПомощникСоздания");
		ИменаФормИсключений.Добавить("Справочник.ХозяйствующиеСубъектыВЕТИС.Форма.ИзменениеСвязиПредприятияХозяйствующегоСубъекта");
		ИменаФормИсключений.Добавить("Справочник.ХозяйствующиеСубъектыВЕТИС.Форма.ФормаСинхронизацияПользователей");

		ИменаФормИсключений.Добавить("Обработка.КлассификаторыВЕТИС.Форма.СозданиеХозяйствующегоСубъектаИПредприятия");

		ИменаФормИсключений.Добавить("РегистрСведений.НастройкиПодключенияВЕТИС.Форма.ФормаЗаписи");
		ИменаФормИсключений.Добавить("РегистрСведений.НастройкиПодключенияВЕТИС.Форма.ФормаУдалениеСвязи");
		ИменаФормИсключений.Добавить("РегистрСведений.ПраваДоступаПользователейВЕТИС.Форма.ФормаНазначениеПрав");
		ИменаФормИсключений.Добавить("РегистрСведений.ПраваДоступаПользователейВЕТИС.Форма.ФормаУдалениеСвязи");
		ИменаФормИсключений.Добавить("РегистрСведений.СинхронизацияКлассификаторовВЕТИС.Форма.ФормаСписка");

		Если ИменаФормИсключений.Найти(ВладелецФормы.ИмяФормы) <> Неопределено Тогда
			Возврат;
		КонецЕсли;

	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);

КонецПроцедуры

#КонецОбласти

#КонецОбласти


