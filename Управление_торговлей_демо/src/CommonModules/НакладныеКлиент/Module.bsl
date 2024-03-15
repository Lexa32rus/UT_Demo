
////////////////////////////////////////////////////////////////////////////////
// Модуль "НакладныеКлиент" содержит процедуры и функции для
// поддержки заполнения накладных и функциональности форм документов
// и списков накладных.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует массив ссылок по выделенным строкам списка, исключая группировки,
// предупреждает пользователя об отсутствии выделенных строк.
//
// Параметры:
//  Список 			- ДинамическийСписок - список, выделенные строки которого содержат ссылки для дальнейшей обработки.
//  ТипНакладная	- ОписаниеТипов - описание типов, содержащее типы накладных, присутствующих в списке.
//  СвойстваЗаказов	- Строка - перечень свойств, которые нужно получить из списка.
//
// Возвращаемое значение:
//  Структура - содержит два массива "Заказы" и "Накладные", содержащие ссылки на выделенные строки списка.
//
Функция СсылкиВыделенныхСтрокСпискаПоВидам(Список, ТипНакладная, СвойстваЗаказов = "") Экспорт
	
	ВыделенныеСтроки = Список.ВыделенныеСтроки;
	ИдентификаторыСтрок = Новый Массив();
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Для оформления накладных необходимо выделить одну или несколько
		                                 |строк в списке распоряжений к оформлению.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
	Иначе
		
		Для Каждого Идентификатор Из Список.ВыделенныеСтроки Цикл
			
			Если ТипЗнч(Идентификатор) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				ИдентификаторыСтрок.Добавить(Идентификатор);
			КонецЕсли;
			
		КонецЦикла;
		
		Если ИдентификаторыСтрок.Количество() = 0 Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Выполнение команды для группировки строк не предусмотрено.'");
			ПоказатьПредупреждение(, ТекстПредупреждения);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДокументыПоВидам = Новый Структура;
	ДокументыПоВидам.Вставить("Заказы", Новый Массив);
	ДокументыПоВидам.Вставить("Накладные", Новый Массив);
	ДокументыПоВидам.Вставить("СоответствиеОрдера", 0);
	ДокументыПоВидам.Вставить("СостояниеНакладной", 0);
	ДокументыПоВидам.Вставить("СвойстваЗаказов", Новый Массив); // значения полей строки списка, если это строка - заказ
	ДокументыПоВидам.Вставить("Количество", ИдентификаторыСтрок.Количество());
	
	ЕстьНакладная = Ложь;
	Для Каждого Идентификатор Из ИдентификаторыСтрок Цикл
		
		СтрокаСписка = Список.ДанныеСтроки(Идентификатор);
		СоответствиеОрдераВСтрокеСписка = СтрокаСписка.СоответствиеОрдера;
		СостояниеНакладнойВСтрокеСписка = СтрокаСписка.СостояниеНакладной;
		
		Ссылка = СтрокаСписка.Ссылка;
		
		Если ТипНакладная.СодержитТип(ТипЗнч(Ссылка)) Тогда
			
			Если Не ЕстьНакладная Тогда
				ДокументыПоВидам.Накладные.Добавить(Ссылка);
				ДокументыПоВидам.СоответствиеОрдера = СоответствиеОрдераВСтрокеСписка;
				ЕстьНакладная = Истина;
			КонецЕсли;
			
		Иначе
			
			ДокументыПоВидам.Заказы.Добавить(Ссылка);
			ДокументыПоВидам.СоответствиеОрдера = Макс(ДокументыПоВидам.СоответствиеОрдера, СоответствиеОрдераВСтрокеСписка);
			ДокументыПоВидам.СостояниеНакладной = Макс(ДокументыПоВидам.СостояниеНакладной, СостояниеНакладнойВСтрокеСписка);
			
			Если СвойстваЗаказов <> "" Тогда
				ЗначенияСвойствЗаказа = Новый Структура(СвойстваЗаказов);
				ЗаполнитьЗначенияСвойств(ЗначенияСвойствЗаказа, СтрокаСписка);
				ДокументыПоВидам.СвойстваЗаказов.Добавить(ЗначенияСвойствЗаказа);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДокументыПоВидам;
	
КонецФункции

// Сообщает об ошибках создания накладной на основании заказов, если у заказов не совпадают реквизиты шапки.
// Параметры:
//  ТекстыОшибок - Массив, Строка - Массив текстов ошибок или текст одной ошибки.
//
Процедура СообщитьОбОшибкахЗаполненияВнутреннейНакладной(ТекстыОшибок) Экспорт
	
	ОчиститьСообщения();
	Если ТипЗнч(ТекстыОшибок) = Тип("Строка") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстыОшибок,,,,);
	Иначе
		
		Для Каждого ТекстОшибки Из ТекстыОшибок Цикл
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,,);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует список группировок по выделенным строкам списка распоряжений, исключая некорректные состояния,
// в которых содержится необходимая информация для оформления накладной по заказу.
//
// Параметры:
//  ДанныеРаспоряжений	 - ДанныеФормыКоллекция - реквизит на форме, содержащий данные списка распоряжений.
//  ИдентификаторыСтрок	 - Массив - идентификаторы строк в коллекции, которые нужно обработать.
//  ПоляГруппировки		 - Строка - имена полей в данных распоряжений по которым их необходимо сгруппировать.
//  СписокОшибок		 - Структура - список ошибок.
//  ПолеОшибки			 - Строка - значение, которое задается в свойстве Поле объекта СообщениеПользователю.
//  МетаданныеНакладных	 - ДанныеФормыКоллекция - таблица с полями:
//  												ХозяйственнаяОперация        - оформляемая хоз. операция
//  												КлючевыеПоляШапки            - ключевые реквизиты распоряжений по которым их можно группировать
//  												ПолноеИмяДокумента           - имя документа в метаданных
//  												ЗаголовокФормыПереоформления - заголовок для ОбщаяФорма.ПереоформлениеНакладныхПоРаспоряжениям.
//	ПоНоменклатуре 		 - Булево - признак режима формирования по номенклатуре (характеристике)
//
// Возвращаемое значение:
//  Массив - содержит необходимую информацию для оформления накладной
//
Функция ДанныеДляОформленияПоЗаказам(
			ДанныеРаспоряжений, 
			ИдентификаторыСтрок, 
			ПоляГруппировки, 
			СписокОшибок, 
			ПолеОшибки, 
			МетаданныеНакладных, 
			ПоНоменклатуре = Ложь) Экспорт
	
	ГруппировкиРаспоряжений = Новый Массив;
	
	Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
		
		Строка = ДанныеРаспоряжений.НайтиПоИдентификатору(ИдентификаторСтроки);
		ТекстОшибки = "";
		
		Если Строка.СостояниеНакладной = 0 Тогда
			ТекстОшибки = НСтр("ru = 'Для распоряжения %1 уже создана накладная.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Строка.Ссылка);
		ИначеЕсли Строка.СостояниеНакладной = 4 Тогда
			ТекстОшибки = НСтр("ru = 'Распоряжение %1 является накладной. Невозможно оформить накладную по накладной.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Строка.Ссылка);
		КонецЕсли;
		
		Если ПустаяСтрока(ТекстОшибки) Тогда
			
			Группировка = ПолучитьГруппировку(ГруппировкиРаспоряжений, Строка, ПоляГруппировки, МетаданныеНакладных, Ложь);
			Группировка.МассивЗаказов.Добавить(Строка.Ссылка);
			
			Если ПоНоменклатуре Тогда
				ДополнитьОтборПоТоварам(Группировка.ПоляЗаполнения, Строка.Ссылка, Строка.Номенклатура, Строка.Характеристика);
			КонецЕсли;	
			
		Иначе
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, ПолеОшибки, ТекстОшибки, Неопределено);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ГруппировкиРаспоряжений.Количество() = 0 И ИдентификаторыСтрок.Количество() > 1 Тогда
		
		ТекстОшибки = НСтр("ru = 'Не выбрано ни одного документа, который можно было бы оформить по заказам.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, ПолеОшибки, ТекстОшибки, Неопределено);
		
	КонецЕсли;
	
	Возврат ГруппировкиРаспоряжений;
	
КонецФункции

// Формирует список группировок по выделенным строкам списка распоряжений, исключая некорректные состояния,
// в которых содержится необходимая информация для оформления накладной по ордерам.
//
// Параметры:
//  ДанныеРаспоряжений	 - ДанныеФормыКоллекция - реквизит на форме, содержащий данные списка распоряжений.
//  ИдентификаторыСтрок	 - Массив - идентификаторы строк в коллекции, которые нужно обработать.
//  ПоляГруппировки		 - Строка - имена полей в данных распоряжений по которым их необходимо сгруппировать.
//  СписокОшибок		 - Структура - список ошибок.
//  ПолеОшибки			 - Строка - значение, которое задается в свойстве Поле объекта СообщениеПользователю.
//  МетаданныеНакладных	 - ДанныеФормыКоллекция - таблица с полями:
//  												ХозяйственнаяОперация        - оформляемая хоз. операция
//  												КлючевыеПоляШапки            - ключевые реквизиты распоряжений по которым их можно группировать
//  												ПолноеИмяДокумента           - имя документа в метаданных
//  												ЗаголовокФормыПереоформления - заголовок для ОбщаяФорма.ПереоформлениеНакладныхПоРаспоряжениям.
//	ПоНоменклатуре 		 - Булево - признак режима формирования по номенклатуре (характеристике)
//
// Возвращаемое значение:
//  Массив - содержит необходимую информацию для оформления накладной
//
Функция ДанныеДляОформленияПоОрдерам(
			ДанныеРаспоряжений, 
			ИдентификаторыСтрок, 
			ПоляГруппировки, 
			СписокОшибок, 
			ПолеОшибки, 
			МетаданныеНакладных, 
			ПоНоменклатуре = Ложь) Экспорт
	
	ГруппировкиРаспоряжений          = Новый Массив;
	ОдновременноОформляемыеНакладные = Новый Соответствие;
	ИдентификаторыЗначений           = Новый Соответствие;
	СтруктураПолейГруппировки        = Новый Структура(
		"Ссылка" + ?(ЗначениеЗаполнено(ПоляГруппировки), ",", "") + ПоляГруппировки);
	
	Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
		
		Строка = ДанныеРаспоряжений.НайтиПоИдентификатору(ИдентификаторСтроки);
		ТекстОшибки = "";
		
		Если Строка.НакладнаяНаОтгрузку И Строка.НакладнаяНаПриемку Тогда
			ПоОрдерам = НСтр("ru = 'по отгрузке (приемке)'");
		ИначеЕсли Строка.НакладнаяНаОтгрузку Тогда
			ПоОрдерам = НСтр("ru = 'по отгрузке'");
		ИначеЕсли Строка.НакладнаяНаПриемку Тогда
			ПоОрдерам = НСтр("ru = 'по приемке'");
		КонецЕсли;
		
		Если (Строка.СостояниеОрдераНаОтгрузку = 0 Или Не Строка.НакладнаяНаОтгрузку)
			И (Строка.СостояниеОрдераНаПриемку = 0 Или Не Строка.НакладнаяНаПриемку) Тогда
			ТекстОшибки = НСтр("ru = 'Для распоряжения %1 невозможно оформить накладную %2, т.к. ордера соответствуют накладным.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Строка.Ссылка, ПоОрдерам);
		ИначеЕсли (Строка.СостояниеОрдераНаОтгрузку = 1 Или Не Строка.НакладнаяНаОтгрузку)
			И (Строка.СостояниеОрдераНаПриемку = 1 Или Не Строка.НакладнаяНаПриемку) Тогда
			ТекстОшибки = НСтр("ru = 'Для распоряжения %1 невозможно оформить накладную %2, т.к. нет ни одного ордера.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Строка.Ссылка, ПоОрдерам);
		ИначеЕсли (Строка.СостояниеОрдераНаОтгрузку = 4 Или Не Строка.НакладнаяНаОтгрузку)
			И (Строка.СостояниеОрдераНаПриемку = 4 Или Не Строка.НакладнаяНаПриемку) Тогда
			ТекстОшибки = НСтр("ru = 'Для распоряжения %1 невозможно оформить накладную %2, т.к. ордера не используются.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Строка.Ссылка, ПоОрдерам);
		КонецЕсли;
		
		Если ПустаяСтрока(ТекстОшибки) Тогда
			Если Строка.СостояниеНакладной = 4 Тогда
				
				МассивКлючей = Новый Массив;
				Для каждого ЭлементСтруктуры Из СтруктураПолейГруппировки Цикл
					
					Идентификатор = ИдентификаторыЗначений.Получить(Строка[ЭлементСтруктуры.Ключ]);
					Если Идентификатор = Неопределено Тогда
						ИдентификаторыЗначений.Вставить(Строка[ЭлементСтруктуры.Ключ], Новый УникальныйИдентификатор);
						Идентификатор = ИдентификаторыЗначений.Получить(Строка[ЭлементСтруктуры.Ключ]);
					КонецЕсли;	
					
					МассивКлючей.Добавить(Идентификатор);
					
				КонецЦикла;	
				
				КлючДанных = СтрСоединить(МассивКлючей, "\");
				
				ДанныеОформляемыхНакладных = ОдновременноОформляемыеНакладные.Получить(КлючДанных);
				Если ДанныеОформляемыхНакладных = Неопределено Тогда
					ОдновременноОформляемыеНакладные.Вставить(КлючДанных, Новый Массив);
					ДанныеОформляемыхНакладных = ОдновременноОформляемыеНакладные.Получить(КлючДанных);
				КонецЕсли;
				
				ДанныеОформляемыхНакладных.Добавить(Строка);
				
			Иначе
				Группировка = ПолучитьГруппировку(ГруппировкиРаспоряжений, Строка, ПоляГруппировки, МетаданныеНакладных, Истина);
				Группировка.МассивЗаказов.Добавить(Строка.Ссылка);
				Группировка.ЕстьНакладные = Группировка.ЕстьНакладные Или (Строка.СостояниеНакладной <> 1);
				
				Если ПоНоменклатуре Тогда
					ДополнитьОтборПоТоварам(Группировка.ПоляЗаполнения, Строка.Ссылка, Строка.Номенклатура, Строка.Характеристика);
				КонецЕсли;	
				
			КонецЕсли;
		Иначе
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, ПолеОшибки, ТекстОшибки, Неопределено);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОдновременноОформляемыеНакладные.Количество() > 1 Или ЗначениеЗаполнено(ГруппировкиРаспоряжений) Тогда
		
		Для каждого ДанныеОформляемыхНакладных Из ОдновременноОформляемыеНакладные Цикл
			
			Строка = ДанныеОформляемыхНакладных.Значение[0];
				
			ТекстОшибки = НСтр("ru = 'Одновременное оформление %1 накладной %2 вместе с другими распоряжениями невозможно. Выберите накладную отдельно.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, ПоОрдерам, Строка.Ссылка);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, ПолеОшибки, ТекстОшибки, Неопределено);
				
		КонецЦикла;	
		
	ИначеЕсли ОдновременноОформляемыеНакладные.Количество() = 1 Тогда
		
		Для каждого ДанныеОформляемыхНакладных Из ОдновременноОформляемыеНакладные Цикл
			
			Для каждого Строка Из ДанныеОформляемыхНакладных.Значение Цикл
				
				Группировка = ПолучитьГруппировку(ГруппировкиРаспоряжений, Строка, ПоляГруппировки, МетаданныеНакладных, Истина);
				Группировка.МассивЗаказов.Добавить(Строка.Ссылка);
				Группировка.Вставить("ЭтоНакладная", Истина);
				
				Если ПоНоменклатуре Тогда
					ДополнитьОтборПоТоварам(Группировка.ПоляЗаполнения, Строка.Ссылка, Строка.Номенклатура, Строка.Характеристика);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;	
		
	КонецЕсли;
	
	Если ГруппировкиРаспоряжений.Количество() = 0 И ИдентификаторыСтрок.Количество() > 1 Тогда
		
		ТекстОшибки = НСтр("ru = 'Не выбрано ни одного документа, который можно было бы оформить по ордерам.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, ПолеОшибки, ТекстОшибки, Неопределено);
		
	КонецЕсли;
	
	Возврат ГруппировкиРаспоряжений;
	
КонецФункции

// Открывает форму оформления либо список уже оформленных документов.
//
// Параметры:
//  ПараметрыСозданныхДокументов - Структура - содержащая поля "ИмяФормы" и "Параметры".
//  Владелец					 - Форма - элемент формы - владелец открываемой формы.
//
Процедура ОткрытьФормуСозданныхДокументов(ПараметрыСозданныхДокументов, Владелец) Экспорт
	
	Если ПараметрыСозданныхДокументов = Неопределено Тогда
		
		Возврат;
		
	ИначеЕсли ПараметрыСозданныхДокументов.Свойство("КоличествоСозданныхДокументов") Тогда
		
		Если ПараметрыСозданныхДокументов.КоличествоСозданныхДокументов = 0 Тогда
			Возврат;
		КонецЕсли;
		
		ТекстОповещения = НСтр("ru = 'Создано документов: %1'");
		ТекстОповещения = СтрШаблон(ТекстОповещения, ПараметрыСозданныхДокументов.КоличествоСозданныхДокументов);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Создание документов'"),, ТекстОповещения);
		
	КонецЕсли;
		
	ОткрытьФорму(ПараметрыСозданныхДокументов.ИмяФормы, ПараметрыСозданныхДокументов.Параметры, Владелец);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьГруппировку(МассивГруппировок, Строка, ПоляГруппировки, МетаданныеНакладных, ПоОрдеру)
	
	Для каждого Группировка Из МассивГруппировок Цикл
		Если ОбщегоНазначенияУТКлиентСервер.СтруктурыРавны(Группировка.ПоляЗаполнения, Строка, ПоляГруппировки) Тогда
			Возврат Группировка;
		КонецЕсли;
	КонецЦикла;
	
	ПоляЗаполненияГруппировки = Новый Структура(ПоляГруппировки);
	Группировка = Новый Структура("МассивЗаказов,ПоляЗаполнения", Новый Массив, ПоляЗаполненияГруппировки);
	ЗаполнитьЗначенияСвойств(Группировка.ПоляЗаполнения, Строка);
	Группировка.ПоляЗаполнения.Вставить("ЗаполнятьПоОрдеру", ПоОрдеру);
	
	МетаданныеНакладной = МетаданныеНакладных.НайтиСтроки(Новый Структура("ХозяйственнаяОперация", Строка.ХозяйственнаяОперация))[0];
	Группировка.Вставить("КлючевыеПоляШапки", МетаданныеНакладной.КлючевыеПоляШапки);
	Группировка.Вставить("ИмяОформляемогоДокумента", СтрЗаменить(МетаданныеНакладной.ПолноеИмяДокумента, "Документ.", ""));
	Группировка.Вставить("Обработчик");
	МетаданныеНакладной.Свойство("Обработчик", Группировка.Обработчик);
	
	Если ПоОрдеру Тогда
		Группировка.Вставить("ЕстьНакладные", Ложь);
		Группировка.Вставить("ЭтоНакладная", Ложь);
		Группировка.Вставить("ЗаголовокФормыПереоформления", МетаданныеНакладной.ЗаголовокФормыПереоформления);
		Группировка.Вставить("Склад", Строка.Склад);
		Группировка.Вставить("НакладнаяНаОтгрузку", Строка.НакладнаяНаОтгрузку);
		Группировка.Вставить("НакладнаяНаПриемку", Строка.НакладнаяНаПриемку);
	КонецЕсли;
	
	МассивГруппировок.Добавить(Группировка);
	
	Возврат Группировка;
	
КонецФункции

Процедура ДополнитьОтборПоТоварам(СтруктураДополнения, Распоряжение, Номенклатура, Характеристика)
	
	ОтборПоТоварам = Неопределено;
	СтруктураДополнения.Свойство("ОтборПоТоварам", ОтборПоТоварам);
	Если ОтборПоТоварам = Неопределено Тогда
		ОтборПоТоварам = Новый Соответствие;	
	КонецЕсли;	
	
	ОтборПоТоварамЗаказа = ОтборПоТоварам.Получить(Распоряжение);
	Если ОтборПоТоварамЗаказа = Неопределено Тогда
		ОтборПоТоварам.Вставить(Распоряжение, Новый Структура);
		ОтборПоТоварамЗаказа = ОтборПоТоварам.Получить(Распоряжение);
	КонецЕсли;
	
	КлючДанных = "_" + СтрЗаменить(Номенклатура.УникальныйИдентификатор()   , "-" , "x")
			   + "_" + СтрЗаменить(Характеристика.УникальныйИдентификатор() , "-" , "x");
	
	Если Не ОтборПоТоварамЗаказа.Свойство(КлючДанных) Тогда
		
		СтруктураДанных = Новый Структура("Номенклатура, Характеристика", 
										   Номенклатура, 
										   Характеристика);
										   
		ОтборПоТоварамЗаказа.Вставить(КлючДанных, СтруктураДанных);
		
		СтруктураДополнения.Вставить("ОтборПоТоварам", ОтборПоТоварам);		
		
	КонецЕсли;			   
	
КонецПроцедуры	

#КонецОбласти
