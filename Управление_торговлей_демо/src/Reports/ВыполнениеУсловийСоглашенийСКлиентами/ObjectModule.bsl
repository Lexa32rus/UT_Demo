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
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета. Содержит в том числе:
//   	* Параметры - Структура - Структура параметров, содержит в том числе:
//   		** ОписаниеКоманды - Структура:
//   			*** ДополнительныеПараметры - Структура:
//   				**** ИмяКоманды - Строка
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
			И Параметры.Свойство("ОписаниеКоманды")
			И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда 
		
		Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "ВыполнениеУсловийСоглашенийСКлиентами" Тогда
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("Соглашение", Параметры.ПараметрКоманды);
		ИначеЕсли Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "ВыполнениеУсловийСоглашенийСКлиентамиПоПартнеру" Тогда
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("Партнер", Параметры.ПараметрКоманды);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрВалюта = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВалютаОтчета");
	
	Если ПараметрВалюта <> Неопределено И Не ПараметрВалюта.Использование Тогда
		ПараметрВалюта.Использование = Истина;
	КонецЕсли;
	
	ПараметрДатаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОтчета");
	
	Если ПараметрДатаОтчета <> Неопределено И Не ПараметрДатаОтчета.Использование Тогда
		ПараметрДатаОтчета.Использование = Истина;
	КонецЕсли;
	
	ПараметрСоглашение = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.ФиксированныеНастройки, "Соглашение");
	ПараметрПартнер    = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.ФиксированныеНастройки, "Партнер");

	Если ПараметрСоглашение <> Неопределено И ПараметрПартнер <> Неопределено И ПараметрВалюта <> Неопределено Тогда
		
		Запрос = Новый Запрос("
			|////////////////////////////////////////////////////////////////////////////////
			|// КУРСЫ ВАЛЮТ /////////////////////////////////////////////////////////////////
			|
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	КурсыВалютСрезПоследних.Валюта    КАК Валюта,
			|	КурсыВалютСрезПоследних.КурсЧислитель КАК КурсЧислитель,
			|	КурсыВалютСрезПоследних.КурсЗнаменатель КАК КурсЗнаменатель
			|ПОМЕСТИТЬ КурсыВалютСрезПоследних
			|ИЗ
			|	РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних({&ДатаОкончания}, БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалютСрезПоследних
			|ИНДЕКСИРОВАТЬ ПО
			|	Валюта
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|// РЕЗУЛЬТАТ ///////////////////////////////////////////////////////////////////
			|
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	СоглашениеСКлиентом.Дата                  КАК Дата,
			|	СоглашениеСКлиентом.Наименование          КАК Наименование,
			|	СоглашениеСКлиентом.Ссылка                КАК Соглашение,
			|	СоглашениеСКлиентом.Период                КАК Периодичность,
			|	СоглашениеСКлиентом.КоличествоПериодов    КАК КоличествоПериодов,
			|	СоглашениеСКлиентом.ДатаНачалаДействия    КАК ДатаНачалаДействия,
			|	СоглашениеСКлиентом.ДатаОкончанияДействия КАК ДатаОкончанияДействия,
			|	СоглашениеСКлиентом.Партнер               КАК Партнер,
			|ВЫБОР
			|	КОГДА
			|		&Валюта = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
			|		ИЛИ &Валюта = Неопределено
			|		ИЛИ &Валюта = СоглашениеСКлиентом.Валюта
			|	ТОГДА
			|		СоглашениеСКлиентом.СуммаДокумента
			|	ИНАЧЕ
			|		ВЫРАЗИТЬ(СоглашениеСКлиентом.СуммаДокумента *
			|			ВЫБОР
			|				КОГДА ЕСТЬNULL(КурсВалютыОтчетаСрезПоследних.КурсЗнаменатель, 0) > 0
			|					И ЕСТЬNULL(КурсВалютыОтчетаСрезПоследних.КурсЧислитель, 0) > 0
			|					И ЕСТЬNULL(КурсыВалютСрезПоследнихВалютаДокумента.КурсЗнаменатель, 0) > 0
			|					И ЕСТЬNULL(КурсыВалютСрезПоследнихВалютаДокумента.КурсЧислитель, 0) > 0
			|				ТОГДА
			|					(КурсыВалютСрезПоследнихВалютаДокумента.КурсЧислитель * КурсВалютыОтчетаСрезПоследних.КурсЗнаменатель)
			|					/ (КурсВалютыОтчетаСрезПоследних.КурсЧислитель * КурсыВалютСрезПоследнихВалютаДокумента.КурсЗнаменатель)
			|				ИНАЧЕ
			|					0
			|			КОНЕЦ КАК ЧИСЛО(31,2))
			|КОНЕЦ КАК СуммаСоглашения,
			|ВЫБОР
			|	КОГДА
			|		&Валюта = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
			|		ИЛИ &Валюта = Неопределено
			|	ТОГДА
			|		СоглашениеСКлиентом.Валюта
			|	ИНАЧЕ
			|		&Валюта
			|КОНЕЦ КАК Валюта,
			|ВЫБОР
			|	КОГДА
			|		СоглашениеСКлиентом.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСКлиентами.Действует)
			|	ТОГДА
			|		ЛОЖЬ
			|	ИНАЧЕ
			|		ИСТИНА
			|КОНЕЦ КАК ЕстьОшибкиСтатус,
			|НЕ СоглашениеСКлиентом.Регулярное КАК ЕстьОшибкиРегулярное,
			|СоглашениеСКлиентом.Типовое       КАК ЕстьОшибкиТиповое
			|ИЗ
			|	Справочник.СоглашенияСКлиентами КАК СоглашениеСКлиентом
			|
			|ЛЕВОЕ СОЕДИНЕНИЕ
			|	КурсыВалютСрезПоследних КАК КурсыВалютСрезПоследнихВалютаДокумента
			|ПО
			|	КурсыВалютСрезПоследнихВалютаДокумента.Валюта = СоглашениеСКлиентом.Валюта
			|
			|ЛЕВОЕ СОЕДИНЕНИЕ
			|	КурсыВалютСрезПоследних КАК КурсВалютыОтчетаСрезПоследних
			|ПО
			|	КурсВалютыОтчетаСрезПоследних.Валюта = &Валюта
			|");
			
		Если ЗначениеЗаполнено(ПараметрПартнер.Значение) Тогда
			
			Если ТипЗнч(ПараметрПартнер.Значение) = Тип("СписокЗначений") Тогда
			
				Запрос.Текст = Запрос.Текст +
					"ГДЕ
					|	СоглашениеСКлиентом.Партнер В (&Партнер)
					|	И СоглашениеСКлиентом.Регулярное
					|	И НЕ СоглашениеСКлиентом.ПометкаУдаления
					|	И СоглашениеСКлиентом.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСКлиентами.Действует)";
					
				Иначе
					
				Запрос.Текст = Запрос.Текст +
					"ГДЕ
					|	СоглашениеСКлиентом.Партнер = &Партнер
					|	И СоглашениеСКлиентом.Регулярное
					|	И НЕ СоглашениеСКлиентом.ПометкаУдаления
					|	И СоглашениеСКлиентом.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСКлиентами.Действует)";
					
				КонецЕсли;
				
			Запрос.УстановитьПараметр("Партнер", ПараметрПартнер.Значение);
				
		ИначеЕсли ЗначениеЗаполнено(ПараметрСоглашение.Значение) Тогда
				
			Запрос.Текст = Запрос.Текст +
				"ГДЕ
				|	СоглашениеСКлиентом.Ссылка В (&Соглашение)";
				
			Запрос.УстановитьПараметр("Соглашение", ПараметрСоглашение.Значение);
			
		Иначе
				
			Запрос.Текст = Запрос.Текст +
				"ГДЕ
				|	НЕ СоглашениеСКлиентом.Типовое
				|	И СоглашениеСКлиентом.Регулярное
				|	И НЕ СоглашениеСКлиентом.ПометкаУдаления
				|	И СоглашениеСКлиентом.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСКлиентами.Действует)
				|";
				
		КонецЕсли;
		
		Запрос.УстановитьПараметр("Валюта", ПараметрВалюта.Значение);
		Запрос.УстановитьПараметр("БазоваяВалюта", ЗначениеНастроекПовтИсп.БазоваяВалютаПоУмолчанию());
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		ТаблицаСоглашений = Новый ТаблицаЗначений();
		ТаблицаСоглашений.Колонки.Добавить("Наименование");
		ТаблицаСоглашений.Колонки.Добавить("Соглашение");
		ТаблицаСоглашений.Колонки.Добавить("Периодичность");
		ТаблицаСоглашений.Колонки.Добавить("СуммаСоглашения");
		ТаблицаСоглашений.Колонки.Добавить("ПериодНачало");
		ТаблицаСоглашений.Колонки.Добавить("ПериодОкончание");
		ТаблицаСоглашений.Колонки.Добавить("Партнер");
		ТаблицаСоглашений.Колонки.Добавить("Валюта");
		ТаблицаСоглашений.Колонки.Добавить("ДатаНачалаДействия");
		ТаблицаСоглашений.Колонки.Добавить("ДатаОкончанияДействия");
		ТаблицаСоглашений.Колонки.Добавить("Дата");
		
		Отказ = Ложь;
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ЕстьОшибкиСтатус Тогда
				
				ТекстОшибки = НСтр("ru='Соглашение с клиентом ""%Соглашение%"" должно быть в статусе ""Действует"".'");
					ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Соглашение);
					
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					,
					,
					,
					Отказ);
					
			КонецЕсли;
			
			Если Выборка.ЕстьОшибкиРегулярное Тогда
				
				ТекстОшибки = НСтр("ru='Соглашение с клиентом ""%Соглашение%"" должно быть регулярным.'");
					ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Соглашение);
					
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					,
					,
					,
					Отказ);
				
			КонецЕсли;
			
			Если Выборка.ЕстьОшибкиТиповое Тогда
				
				ТекстОшибки = НСтр("ru='Соглашение с клиентом %Соглашение% должно быть индивидуальным.'");
					ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Соглашение);
					
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					,
					,
					,
					Отказ);
					
			КонецЕсли;
			
			Если Не Отказ Тогда
			
				ПредыдущийПериод = Дата(1,1,1);
				ДатаНачалаБлижайшегоПериода = НачалоДня(ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуНачалаБлижайшегоПериода(Выборка.ДатаНачалаДействия, Выборка.Периодичность));
				
				Для ТекущийПериод = 0 По Выборка.КоличествоПериодов-1 Цикл
					
					НоваяСтрока = ТаблицаСоглашений.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);

					Если ТекущийПериод = 0 Тогда
						НоваяСтрока.ПериодНачало = НачалоДня(ДатаНачалаБлижайшегоПериода);
					Иначе
						НоваяСтрока.ПериодНачало = НачалоДня(ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(ДатаНачалаБлижайшегоПериода, Выборка.Периодичность, ТекущийПериод)+86400);
					КонецЕсли;
					
					НоваяСтрока.ПериодОкончание = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(ДатаНачалаБлижайшегоПериода, Выборка.Периодичность, ТекущийПериод+1);
					
				КонецЦикла;
				
			КонецЕсли;
		
		КонецЦикла;
		
		Если ТаблицаСоглашений.Количество() > 0 Тогда
				
			ПараметрДатаНачала    = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаНачала");
			ПараметрДатаОкончания = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОкончания");
			
			ТаблицаДат = ТаблицаСоглашений.Скопировать(,"ДатаНачалаДействия,ДатаОкончанияДействия");
			ТаблицаДат.Сортировать("ДатаНачалаДействия Возр");
			
			Если ПараметрДатаНачала <> Неопределено Тогда
				ПараметрДатаНачала.Значение = ТаблицаДат[0].ДатаНачалаДействия;
				ПараметрДатаНачала.Использование = Истина;
			КонецЕсли;
			
			ТаблицаДат.Сортировать("ДатаОкончанияДействия Убыв");
			
			Если ПараметрДатаОкончания <> Неопределено Тогда
				ПараметрДатаОкончания.Значение = Новый Граница(КонецДня(ТаблицаДат[0].ДатаОкончанияДействия), ВидГраницы.Включая);
				ПараметрДатаОкончания.Использование = Истина;
			КонецЕсли;
			
		КонецЕсли;
			
		ВнешниеНаборыДанных = Новый Структура();
		ВнешниеНаборыДанных.Вставить("Соглашения", ТаблицаСоглашений);
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);	
	
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки   = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
