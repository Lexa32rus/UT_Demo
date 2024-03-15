
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.СвязьВидовИФорматовДокументовЭДО;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	Если ОбновлениеИнформационнойБазы.ЕстьЗаблокированныеПредыдущимиОчередямиДанные(
		Параметры.Очередь, "РегистрСведений.ФорматыЭлектронныхДокументов") Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	ОбработкаЗавершена = Ложь;
	
	НачатьТранзакцию();
	Попытка
		
		ДвоичныеДанныеКэша = РегистрыСведений.СвязьВидовИФорматовДокументовЭДО.ПолучитьМакет(
			"СвязьВидовИФорматовДокументовЭДО");
		
		ДанныеКэша = СервисНастроекЭДО.ОбработкаРезультатаСвязьТиповИФорматовЭД(ДвоичныеДанныеКэша);
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ИСТИНА КАК ТребуетсяЗагрузка
			|ИЗ
			|	РегистрСведений.СвязьВидовИФорматовДокументовЭДО КАК СвязьВидовИФорматовДокументовЭДО
			|ГДЕ
			|	СвязьВидовИФорматовДокументовЭДО.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовЭДО.ПустаяСсылка)";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			ДатаПоследнегоИзменения = ТекущаяДатаСеанса();
			ЭлектронныеДокументыЭДО.ОбновитьСвязьВидовИФорматовЭлектронныхДокументов(ДанныеКэша, ДатаПоследнегоИзменения);
		Иначе
			ЭлектронныеДокументыЭДО.ЗагрузитьСвязьВидовИФорматовЭлектронныхДокументов(ДанныеКэша);
		КонецЕсли;
		
		ОбработкаЗавершена = Истина;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстСообщения = НСтр("ru = 'Не удалось заполнить кеши связей видов и форматов электронных документов по причине:'") + Символы.ПС 
			+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,,, ТекстСообщения);
	КонецПопытки;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсиюНачальноеЗаполнение(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК ЕстьЗаписи
		|ИЗ
		|	РегистрСведений.СвязьВидовИФорматовДокументовЭДО КАК СвязьВидовИФорматовДокументовЭДО";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#КонецЕсли
