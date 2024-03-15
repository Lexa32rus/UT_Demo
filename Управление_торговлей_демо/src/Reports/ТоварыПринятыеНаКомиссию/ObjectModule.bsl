#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - см. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Если ЭтаФорма.Параметры.Свойство("ПараметрКоманды") Тогда
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("ОтчетКомитенту", ЭтаФорма.Параметры.ПараметрКоманды);
	КонецЕсли;
	
	Параметры = ЭтаФорма.ФормаПараметры;
	
	Если Параметры.Свойство("Отбор")
	   И Параметры.Отбор.Свойство("ОтчетКомитенту") Тогда
	   
		Если ТипЗнч(Параметры.Отбор.ОтчетКомитенту) = Тип("ДокументСсылка.ОтчетКомитенту") Тогда
			Реквизиты = Документы.ОтчетКомитенту.РеквизитыДокумента(Параметры.Отбор.ОтчетКомитенту);
			
		ИначеЕсли ТипЗнч(Параметры.Отбор.ОтчетКомитенту) = Тип("ДокументСсылка.ОтчетКомитентуОСписании") Тогда
			Реквизиты = Документы.ОтчетКомитентуОСписании.РеквизитыДокумента(Параметры.Отбор.ОтчетКомитенту);
			
		Иначе
			Реквизиты = Неопределено;
			
		КонецЕсли;
		
		Если Реквизиты <> Неопределено Тогда
			Если ЗначениеЗаполнено(Реквизиты.Партнер) Тогда	
				Параметры.Отбор.Вставить("Комитент", Реквизиты.Партнер);
			КонецЕсли;
			Если ЗначениеЗаполнено(Реквизиты.Организация) Тогда
				Параметры.Отбор.Вставить("Организация", Реквизиты.Организация);
			КонецЕсли;
			Период = Новый СтандартныйПериод;
			Период.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод;
			Период.ДатаНачала = Реквизиты.НачалоПериода;
			период.ДатаОкончания = Реквизиты.КонецПериода;
			Параметры.Отбор.Вставить("Период", Период);
		КонецЕсли;
		Параметры.Отбор.Удалить("ОтчетКомитенту");
	КонецЕсли;
	

КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//
// Параметры:
//	Контекст							- Произвольный								- параметры контекста, в котором используется отчет.
//	КлючСхемы							- Строка									- идентификатор текущей схемы компоновщика настроек.
//	КлючВарианта						- Строка									- имя предопределенного или уникальный идентификатор пользовательского
//																						варианта отчета.
//										- Неопределено 								- вызов для варианта расшифровки или без контекста.
//	НовыеНастройкиКД					- НастройкиКомпоновкиДанных					- настройки варианта отчета, которые будут загружены
//																						в компоновщик настроек после его инициализации.
//										- Неопределено 								- настройки варианта не надо загружать (уже загружены ранее).
//	НовыеПользовательскиеНастройкиКД	- ПользовательскиеНастройкиКомпоновкиДанных - пользовательские настройки, которые будут загружены в компоновщик
//																						настроек после его инициализации.
//										- Неопределено 								- пользовательские настройки не надо загружать (уже загружены ранее).
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючСхемы = КлючВарианта Тогда
		Возврат;
	КонецЕсли;
	
	Если НовыеНастройкиКД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КлючСхемы		= КлючВарианта;
	ЗаголовкиПолей	= ПараметризуемыеЗаголовкиПолей();
	
	КомпоновкаДанныхСервер.УстановитьЗаголовкиВыбранныхПолей(НовыеНастройкиКД.Выбор.Элементы, ЗаголовкиПолей);
	
	Если ТипЗнч(НовыеПользовательскиеНастройкиКД) <> Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторНастройки = НовыеНастройкиКД.Выбор.ИдентификаторПользовательскойНастройки;
	
	Если ЗначениеЗаполнено(ИдентификаторНастройки) Тогда
		НайденныйЭлементНастройки = НовыеПользовательскиеНастройкиКД.Элементы.Найти(ИдентификаторНастройки);
		
		Если НайденныйЭлементНастройки <> Неопределено Тогда 
			КомпоновкаДанныхСервер.УстановитьЗаголовкиВыбранныхПолей(НайденныйЭлементНастройки.Элементы, ЗаголовкиПолей);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;

	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	СхемаКомпоновкиДанныхНаборыДанныхРасчетыСКомитентами = СхемаКомпоновкиДанных.НаборыДанных.РасчетыСКомитентами; // НаборДанныхОбъединениеСхемыКомпоновкиДанных
	
	
	ТекстЗапроса = СхемаКомпоновкиДанныхНаборыДанныхРасчетыСКомитентами.Элементы.ТоварыОрганизаций.Запрос;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаВесНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("АналитикаНоменклатуры.Номенклатура.ЕдиницаИзмерения",
																							"АналитикаНоменклатуры.Номенклатура"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаОбъемНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("АналитикаНоменклатуры.Номенклатура.ЕдиницаИзмерения",
																							"АналитикаНоменклатуры.Номенклатура"));
	СхемаКомпоновкиДанныхНаборыДанныхРасчетыСКомитентами.Элементы.ТоварыОрганизаций.Запрос = ТекстЗапроса;	

	ТекстЗапроса = СхемаКомпоновкиДанныхНаборыДанныхРасчетыСКомитентами.Элементы.ТоварыКОформлениюОтчетовКомитенту.Запрос;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаВесНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("АналитикаНоменклатуры.Номенклатура.ЕдиницаИзмерения",
																							"АналитикаНоменклатуры.Номенклатура"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаОбъемНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("АналитикаНоменклатуры.Номенклатура.ЕдиницаИзмерения",
																							"АналитикаНоменклатуры.Номенклатура"));
	СхемаКомпоновкиДанныхНаборыДанныхРасчетыСКомитентами.Элементы.ТоварыКОформлениюОтчетовКомитенту.Запрос = ТекстЗапроса;	
	
	ТекстЗапроса = СхемаКомпоновкиДанныхНаборыДанныхРасчетыСКомитентами.Элементы.ТоварыОрганизацийДвижения.Запрос;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаВесНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("АналитикаНоменклатуры.Номенклатура.ЕдиницаИзмерения",
																							"АналитикаНоменклатуры.Номенклатура"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаОбъемНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("АналитикаНоменклатуры.Номенклатура.ЕдиницаИзмерения",
																							"АналитикаНоменклатуры.Номенклатура"));
	СхемаКомпоновкиДанныхНаборыДанныхРасчетыСКомитентами.Элементы.ТоварыОрганизацийДвижения.Запрос = ТекстЗапроса;	
	
	ТекстЗапроса = СхемаКомпоновкиДанныхНаборыДанныхРасчетыСКомитентами.Элементы.ЗаказыПоставщикам.Запрос;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаВесНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("ЗаказыПоставщикам.Номенклатура.ЕдиницаИзмерения",
																							"ЗаказыПоставщикам.Номенклатура"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаОбъемНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("ЗаказыПоставщикам.Номенклатура.ЕдиницаИзмерения",
																							"ЗаказыПоставщикам.Номенклатура"));
	СхемаКомпоновкиДанныхНаборыДанныхРасчетыСКомитентами.Элементы.ЗаказыПоставщикам.Запрос = ТекстЗапроса;	
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(ПараметризуемыеЗаголовкиПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	ФиксНастройкаПериода = ФиксированнаяНастройкаПараметра("Период");
	Если ФиксНастройкаПериода.Использование = Истина Тогда
		
		ПользНастройкаПериода = ПользовательскаяНастройкаПараметра("Период");
		ПользНастройкаПериода.Использование = Истина;
		ПользНастройкаПериодаЗначение = ПользНастройкаПериода.Значение; // СтандартныйПериод
		ФиксНастройкаПериодаЗначение  = ФиксНастройкаПериода.Значение;  // СтандартныйПериод
		ПользНастройкаПериодаЗначение.ДатаНачала    = ФиксНастройкаПериодаЗначение.ДатаНачала;
		ПользНастройкаПериодаЗначение.ДатаОкончания = ФиксНастройкаПериодаЗначение.ДатаОкончания;
		
		ФиксНастройкаПериода.Использование = Ложь;
		
	КонецЕсли;
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
	
КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	
	ВспомогательныеПараметры = Новый Массив;
	
	ВспомогательныеПараметры.Добавить("КоличественныеИтогиПоЕдИзм");
	
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	
	Возврат ВспомогательныеПараметры;

КонецФункции

Функция ФиксированнаяНастройкаПараметра(ИмяПараметра)

	ПараметрДанных = КомпоновщикНастроек.ФиксированныеНастройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	
	Возврат ПараметрДанных;

КонецФункции

Функция ПользовательскаяНастройкаПараметра(ИмяПараметра)

	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	Если ПараметрДанных <> Неопределено Тогда
		ПараметрПользовательскойНастройки = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ПараметрДанных.ИдентификаторПользовательскойНастройки);
		Если ПараметрПользовательскойНастройки <> Неопределено Тогда
			Возврат ПараметрПользовательскойНастройки;
		Иначе
			Возврат ПараметрДанных;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;

КонецФункции

Функция ПараметризуемыеЗаголовкиПолей()
	
	Возврат КомпоновкаДанныхСервер.СоответствиеЗаголовковПолейЕдиницИзмерений(КомпоновщикНастроек);
	
КонецФункции

#КонецОбласти

#КонецЕсли