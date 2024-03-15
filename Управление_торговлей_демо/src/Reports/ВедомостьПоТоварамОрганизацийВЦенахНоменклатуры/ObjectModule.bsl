#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрВидЦены = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВидЦены");
	Если ПараметрВидЦены <> Неопределено Тогда
		Если Не ЗначениеЗаполнено(ПараметрВидЦены.Значение) Тогда
			Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен") Тогда
				КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидЦены", ЦенообразованиеВызовСервера.ВидЦеныПрайсЛист());
			КонецЕсли;
		Иначе
			ВалютаВидаЦены = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрВидЦены.Значение, "ВалютаЦены");
			
			КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВалютаВидаЦены", ВалютаВидаЦены);
		КонецЕсли;
	КонецЕсли;
	
	ДокументРезультат.Очистить();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		
	СхемаКомпоновкиДанных = Отчеты.ВедомостьПоТоварамОрганизацийВЦенахНоменклатуры.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	ПараметрВидЦены = СхемаКомпоновкиДанных.Параметры.Найти("ВидЦены");
	ПараметрВариантОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВариантОтчета");
	
	Если ПараметрВидЦены <> Неопределено И ПараметрВариантОтчета <> Неопределено Тогда
		Если ПараметрВариантОтчета.Значение = "ДвиженияТоваровПереданныхНаКомиссию25" Тогда
			ПараметрВидЦены.ЗапрещатьНезаполненныеЗначения = Ложь;
		Иначе
			ПараметрВидЦены.ЗапрещатьНезаполненныеЗначения = Истина;
		КонецЕсли;
	КонецЕсли;
	
	НаборДанных25 = СхемаКомпоновкиДанных.НаборыДанных.Найти("Запрос2_5");
	Если ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25() Тогда
		НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Найти("Запрос");
		НаборДанных.Запрос = НаборДанных25.Запрос;
	КонецЕсли;
	СхемаКомпоновкиДанных.НаборыДанных.Удалить(НаборДанных25);
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.Запрос.Запрос;

	Если ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда

		ТекстЗамены = 
		"ВЫБОР
		|		КОГДА ЦеныНоменклатурыА.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|				ИЛИ ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 0) = 0
		|			ТОГДА ЦеныНоменклатурыА.Цена
		|		ИНАЧЕ ЦеныНоменклатурыА.Цена / &ТекстЗапросаКоэффициентУпаковки1
		|	КОНЕЦ";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&АктуальнаяЦена", ТекстЗамены);
		
		ТекстЗамены = 
		"ВЫБОР
		|		КОГДА ЦеныНоменклатурыБ.Цена ЕСТЬ NULL 
		|			ТОГДА 0
		|		КОГДА ЦеныНоменклатурыБ.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|				ИЛИ ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 0) = 0
		|			ТОГДА ЦеныНоменклатурыБ.Цена
		|		ИНАЧЕ ЦеныНоменклатурыБ.Цена / &ТекстЗапросаКоэффициентУпаковки2
		|	КОНЕЦ";

		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&СтараяЦена", ТекстЗамены);
		
		ТекстЗамены = 
		"ВЫБОР
		|		КОГДА ЦеныНоменклатурыА.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|				ИЛИ ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 0) = 0
		|			ТОГДА ЦеныНоменклатурыА.Цена
		|		ИНАЧЕ ЦеныНоменклатурыА.Цена / &ТекстЗапросаКоэффициентУпаковки1
		|	КОНЕЦ - ВЫБОР
		|		КОГДА ЦеныНоменклатурыБ.Цена ЕСТЬ NULL 
		|			ТОГДА 0
		|		КОГДА ЦеныНоменклатурыБ.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|				ИЛИ ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 0) = 0
		|			ТОГДА ЦеныНоменклатурыБ.Цена
		|		ИНАЧЕ ЦеныНоменклатурыБ.Цена / &ТекстЗапросаКоэффициентУпаковки2
		|	КОНЕЦ";

		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Дельта", ТекстЗамены);
		
	Иначе
			
		ТекстЗамены = 
		"ЦеныНоменклатурыА.Цена";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&АктуальнаяЦена", ТекстЗамены);

		ТекстЗамены = 
		"ВЫБОР
		|		КОГДА
		|			ЦеныНоменклатурыБ.Цена ЕСТЬ NULL
		|		ТОГДА
		|			0
		|		ИНАЧЕ
		|			ЦеныНоменклатурыБ.Цена
		|	КОНЕЦ";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&СтараяЦена", ТекстЗамены);

		ТекстЗамены = 
		"ЦеныНоменклатурыА.Цена
		|		- ВЫБОР
		|			КОГДА
		|				ЦеныНоменклатурыБ.Цена ЕСТЬ NULL
		|			ТОГДА
		|				0
		|			ИНАЧЕ
		|				ЦеныНоменклатурыБ.Цена
		|		КОНЕЦ";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Дельта", ТекстЗамены);
		
	КонецЕсли;
	
	СхемаКомпоновкиДанных.НаборыДанных.Запрос.Запрос = ТекстЗапроса;	
	
	СхемаКомпоновкиДанных.НаборыДанных.Запрос.Запрос = СтрЗаменить(СхемаКомпоновкиДанных.НаборыДанных.Запрос.Запрос, "&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ЦеныНоменклатурыА.Упаковка",
			"ЦеныНоменклатурыА.Номенклатура"));
	СхемаКомпоновкиДанных.НаборыДанных.Запрос.Запрос = СтрЗаменить(СхемаКомпоновкиДанных.НаборыДанных.Запрос.Запрос, "&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ЦеныНоменклатурыБ.Упаковка",
			"ЦеныНоменклатурыБ.Номенклатура"));

	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных,
		КомпоновщикНастроек.ПолучитьНастройки(),
		ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	ПроцессорВывода.НачатьВывод();
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	ПроцессорВывода.ЗакончитьВывод();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
