
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьТекстЗапросаСписка();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	УстановитьВидимость();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ОбеспечениеВДокументахКлиент.СписокПриИзменении(ЭтотОбъект, "Документ.ЗаказНаСборку");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура УстановитьСтатусЗакрыт(Команда)
	
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СтруктураЗакрытия = Новый Структура;
	СписокЗаказов = Новый СписокЗначений;
	СписокЗаказов.ЗагрузитьЗначения(ВыделенныеСсылки);
	СтруктураЗакрытия.Вставить("Заказы",                       СписокЗаказов);
	СтруктураЗакрытия.Вставить("ОтменитьНеотработанныеСтроки", Истина);
	СтруктураЗакрытия.Вставить("ЗакрыватьЗаказы",              Истина);
	
	ОткрытьФорму("Обработка.ПомощникЗакрытияЗаказов.Форма.ФормаЗакрытия", СтруктураЗакрытия,
					ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнению(Команда)
	
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""К выполнению"". Продолжить?'");

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКВыполнениюЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОбеспечению(Команда)
	
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""К обеспечению"". Продолжить?'");

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКОбеспечениюЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтгрузитьЗаказ(Команда)
	
	ОбеспечениеВДокументахКлиент.ВыполнитьДействиеВСпискеЗаказовРазныхТипов(
		"ДЕЙСТВИЕ_ОТГРУЗИТЬ",
		Элементы.Список,
		ПредопределенноеЗначение("Документ.ЗаказНаСборку.ПустаяСсылка"),
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РезервироватьЗаказ(Команда)
	
	ОбеспечениеВДокументахКлиент.ВыполнитьДействиеВСпискеЗаказовРазныхТипов(
		"ДЕЙСТВИЕ_РЕЗЕРВИРОВАТЬ",
		Элементы.Список,
		ПредопределенноеЗначение("Документ.ЗаказНаСборку.ПустаяСсылка"),
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КОбеспечениюЗаказ(Команда)
	
	ОбеспечениеВДокументахКлиент.ВыполнитьДействиеВСпискеЗаказовРазныхТипов(
		"ДЕЙСТВИЕ_КОБЕСПЕЧЕНИЮ",
		Элементы.Список,
		ПредопределенноеЗначение("Документ.ЗаказНаСборку.ПустаяСсылка"),
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РезервироватьПоМереПоступленияЗаказ(Команда)
	
	ОбеспечениеВДокументахКлиент.ВыполнитьДействиеВСпискеЗаказовРазныхТипов(
		"ДЕЙСТВИЕ_РЕЗЕРВИРОВАТЬПОМЕРЕПОСТУПЛЕНИЯ",
		Элементы.Список,
		ПредопределенноеЗначение("Документ.ЗаказНаСборку.ПустаяСсылка"),
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НеОбеспечиватьЗаказ(Команда)
	
	ОбеспечениеВДокументахКлиент.ВыполнитьДействиеВСпискеЗаказовРазныхТипов(
		"ДЕЙСТВИЕ_НЕОБЕСПЕЧИВАТЬ",
		Элементы.Список,
		ПредопределенноеЗначение("Документ.ЗаказНаСборку.ПустаяСсылка"),
		ЭтотОбъект);

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочие

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗакрытиеЗаказов" Тогда
		Элементы.Список.Обновить();
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнениюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        
        Возврат;
        
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСсылки, "КВыполнению");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСсылки.Количество(),
    НСтр("ru = 'К выполнению'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОбеспечениюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        
        Возврат;
        
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСсылки, "КОбеспечению");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСсылки.Количество(),
    НСтр("ru = 'К обеспечению'"));

КонецПроцедуры

#КонецОбласти

#Область УстановкаДействий

&НаКлиенте
Процедура ВыполнитьДействиеВСпискеЗаказовРазныхТиповЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		
		Возврат;
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		ПоказатьПредупреждение(, Результат.КраткоеПредставлениеОшибки);
		
	Иначе
		
		ЗаказыДляПроверкиЗаданияРаспределенияЗапасов.ЗагрузитьЗначения(ДополнительныеПараметры.Заказы);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗаданияРаспределенияЗапасовПоЗаказам", 1, Истина);
		РезультатВыполненияДействий = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		ОбеспечениеВДокументахКлиент.СообщитьОРезультатахВыполненияДействийВСпискеЗаказов(РезультатВыполненияДействий);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьТекстЗапросаСписка()
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ЗаполнитьЗначенияСвойств(СвойстваСписка, Список);
	
	Если ПравоДоступа("Чтение", Метаданные.РегистрыСведений.СостоянияВнутреннихЗаказов) Тогда
		
		СвойстваСписка.ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДокументЗаказНаСборку.Ссылка,
		|	ДокументЗаказНаСборку.ПометкаУдаления,
		|	ДокументЗаказНаСборку.Номер,
		|	ДокументЗаказНаСборку.Дата,
		|	ДокументЗаказНаСборку.Приоритет,
		|	ДокументЗаказНаСборку.Проведен,
		|	ДокументЗаказНаСборку.Организация,
		|	ДокументЗаказНаСборку.Склад,
		|	ДокументЗаказНаСборку.ДокументОснование,
		|	ДокументЗаказНаСборку.Ответственный,
		|	ДокументЗаказНаСборку.Статус,
		|	ДокументЗаказНаСборку.Номенклатура,
		|	ДокументЗаказНаСборку.Характеристика,
		|	ДокументЗаказНаСборку.Упаковка,
		|	ДокументЗаказНаСборку.КоличествоУпаковок,
		|	ДокументЗаказНаСборку.Количество,
		|	ДокументЗаказНаСборку.ХозяйственнаяОперация,
		|	ДокументЗаказНаСборку.Комментарий,
		|	ДокументЗаказНаСборку.НачалоСборкиРазборки,
		|	ДокументЗаказНаСборку.ОкончаниеСборкиРазборки,
		|	ДокументЗаказНаСборку.ЖелаемаяДатаПоступления,
		|	ДокументЗаказНаСборку.ДлительностьСборкиРазборки,
		|	ДокументЗаказНаСборку.МаксимальныйКодСтроки,
		|	ДокументЗаказНаСборку.ВариантКомплектации,
		|	ДокументЗаказНаСборку.Сделка,
		|	ДокументЗаказНаСборку.Подразделение,
		|	ДокументЗаказНаСборку.СтатусУказанияСерий,
		|	ДокументЗаказНаСборку.Назначение,
		|	ДокументЗаказНаСборку.НазначениеТовары,
		|	ДокументЗаказНаСборку.Серия,
		|	ДокументЗаказНаСборку.ВариантОбеспечения,
		|	ДокументЗаказНаСборку.КоличествоУпаковокОтменено,
		|	ДокументЗаказНаСборку.КоличествоОтменено,
		|	ДокументЗаказНаСборку.Товары,
		|	ДокументЗаказНаСборку.Серии,
		|	ДокументЗаказНаСборку.МоментВремени,
		|	ДокументЗаказНаСборку.Автор,
		|	ВЫБОР
		|		КОГДА НЕ ДокументЗаказНаСборку.Проведен
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.ПустаяСсылка)
		|		ИНАЧЕ ЕСТЬNULL(СостоянияВнутреннихЗаказов.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.Закрыт))
		|	КОНЕЦ КАК Состояние,
		|	ЕСТЬNULL(СостоянияВнутреннихЗаказов.ЕстьРасхожденияОрдерНакладная, ЛОЖЬ) КАК ЕстьРасхожденияОрдерНакладная,
		|	ВЫБОР КОГДА СостоянияВнутреннихЗаказов.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.ГотовКОтгрузке) ТОГДА
		|				СостоянияВнутреннихЗаказов.РезервПревышаетОстатки
		|			ИНАЧЕ
		| 				ЛОЖЬ
		|		КОНЕЦ КАК РезервПревышаетОстатки
		|ИЗ
		|	Документ.ЗаказНаСборку КАК ДокументЗаказНаСборку
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияВнутреннихЗаказов КАК СостоянияВнутреннихЗаказов
		|		ПО (СостоянияВнутреннихЗаказов.Заказ = ДокументЗаказНаСборку.Ссылка)";
		
	Иначе
		
		СвойстваСписка.ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДокументЗаказНаСборку.Ссылка,
		|	ДокументЗаказНаСборку.ПометкаУдаления,
		|	ДокументЗаказНаСборку.Номер,
		|	ДокументЗаказНаСборку.Дата,
		|	ДокументЗаказНаСборку.Приоритет,
		|	ДокументЗаказНаСборку.Проведен,
		|	ДокументЗаказНаСборку.Организация,
		|	ДокументЗаказНаСборку.Склад,
		|	ДокументЗаказНаСборку.ДокументОснование,
		|	ДокументЗаказНаСборку.Ответственный,
		|	ДокументЗаказНаСборку.Статус,
		|	ДокументЗаказНаСборку.Номенклатура,
		|	ДокументЗаказНаСборку.Характеристика,
		|	ДокументЗаказНаСборку.Упаковка,
		|	ДокументЗаказНаСборку.КоличествоУпаковок,
		|	ДокументЗаказНаСборку.Количество,
		|	ДокументЗаказНаСборку.ХозяйственнаяОперация,
		|	ДокументЗаказНаСборку.Комментарий,
		|	ДокументЗаказНаСборку.НачалоСборкиРазборки,
		|	ДокументЗаказНаСборку.ОкончаниеСборкиРазборки,
		|	ДокументЗаказНаСборку.ЖелаемаяДатаПоступления,
		|	ДокументЗаказНаСборку.ДлительностьСборкиРазборки,
		|	ДокументЗаказНаСборку.МаксимальныйКодСтроки,
		|	ДокументЗаказНаСборку.ВариантКомплектации,
		|	ДокументЗаказНаСборку.Сделка,
		|	ДокументЗаказНаСборку.Подразделение,
		|	ДокументЗаказНаСборку.СтатусУказанияСерий,
		|	ДокументЗаказНаСборку.Назначение,
		|	ДокументЗаказНаСборку.НазначениеТовары,
		|	ДокументЗаказНаСборку.Серия,
		|	ДокументЗаказНаСборку.ВариантОбеспечения,
		|	ДокументЗаказНаСборку.КоличествоУпаковокОтменено,
		|	ДокументЗаказНаСборку.КоличествоОтменено,
		|	ДокументЗаказНаСборку.Товары,
		|	ДокументЗаказНаСборку.Серии,
		|	ДокументЗаказНаСборку.Автор,
		|	ДокументЗаказНаСборку.МоментВремени
		|ИЗ
		|	Документ.ЗаказНаСборку КАК ДокументЗаказНаСборку";
		
	КонецЕсли;
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	ПравоДоступаДобавление = Документы.ЗаказНаСборку.ПравоДоступаДобавление();
	ПланированиеСборкиРазборки = ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеСборкиРазборки");
	РасширенноеОбеспечениеПотребностей = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенноеОбеспечениеПотребностей");
	
	Элементы.ФормаСписокГруппа.Видимость = ПравоДоступаДобавление
		И (ПланированиеСборкиРазборки Или РасширенноеОбеспечениеПотребностей);
	Если Элементы.ФормаСписокГруппа.Видимость Тогда
		Элементы.ФормаСписокСоздать.Видимость = Ложь;
	КонецЕсли;
	
	ИспользоватьСтатусы = ПравоДоступа("Изменение", Метаданные.Документы.ЗаказНаСборку);
	Элементы.ГруппаУстановитьСтатус.Видимость = ИспользоватьСтатусы;
	
	Если ИспользоватьСтатусы Тогда
		ИспользоватьСтатусЗакрыт = ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыНаСборкуБезПолнойОтгрузки");
		Элементы.УстановитьСтатусЗакрыт.Видимость = ИспользоватьСтатусЗакрыт;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗаданияРаспределенияЗапасовПоЗаказам()
	ОбеспечениеВДокументахКлиент.ПроверитьВыполнениеЗаданияРаспределенияЗапасовПоЗаказам(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

#КонецОбласти

#Область Производительность

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЗаказНаСборку.ФормаСписка.Элемент.Список.Выбор");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти