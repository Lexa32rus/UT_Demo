#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОрдерНаПеремещениеТоваров));
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ИнициализироватьДокумент();

	Для Каждого СтрокаТовары Из ОтгружаемыеТовары Цикл
		
		СтрокаТовары.Действие = Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.Отобрать;
		
	КонецЦикла;
	
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ДополнительныеСвойства.Свойство("ОтложенноеПроведение") Тогда
		Если Не Проведен
			И Статус <> Перечисления.СтатусыОрдеровНаПеремещение.КОтбору Тогда
			
			ТекстСообщения = НСтр("ru = 'Документ должен быть проведен сначала в статусе ""К отбору""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,ЭтотОбъект,"Статус","Объект",Отказ);
		КонецЕсли;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ИмяТЧ = "ОтгружаемыеТовары";
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ,ПараметрыПроверки);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОрдерНаПеремещениеТоваров),
												Отказ,
												МассивНепроверяемыхРеквизитов);	
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ИмяТЧ = "ОтгружаемыеТовары";
	ПараметрыПроверки.ПроверитьВозможностьОкругления = Ложь;
	ПараметрыПроверки.ПроверитьКомплектностьТоварныхМест = Истина;
	ПараметрыПроверки.УсловиеОтбораСтрокПроверкиКомплектности = "ОтгружаемыеТовары.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.НеОтгружать)";
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);

	ОтправительИспользоватьАдресноеХранение = СкладыСервер.ИспользоватьАдресноеХранение(Склад,ПомещениеОтправитель,ДатаОтгрузки);
	
	ПолучательИспользоватьАдресноеХранение = СкладыСервер.ИспользоватьАдресноеХранение(Склад,ПомещениеПолучатель,ДатаОтгрузки);
	
	Если Не ОтправительИспользоватьАдресноеХранение
		Или Статус = Перечисления.СтатусыОрдеровНаПеремещение.КОтбору Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗонаОтгрузки");
	КонецЕсли;
	
	Если Не ПолучательИспользоватьАдресноеХранение
		Или (ПолучательИспользоватьАдресноеХранение
		И Статус <> Перечисления.СтатусыОрдеровНаПеремещение.Принят) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗонаПриемки");
	КонецЕсли;
	
	Если (ОтправительИспользоватьАдресноеХранение
		Или ПолучательИспользоватьАдресноеХранение)
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ОтгружаемыеТовары.Упаковка");
		
		ТекстСообщения = НСтр("ru='В настройках программы не включено использование упаковок номенклатуры, 
		|поэтому нельзя оформить документ по складу с адресным хранением остатков. Обратитесь к администратору'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		
	ИначеЕсли Не((ОтправительИспользоватьАдресноеХранение
		И Статус <> Перечисления.СтатусыОрдеровНаПеремещение.КОтбору)
		Или (ПолучательИспользоватьАдресноеХранение
		И Статус = Перечисления.СтатусыОрдеровНаПеремещение.Принят))Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОтгружаемыеТовары.Упаковка");
	Иначе
		ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияУпаковок();
		ПараметрыПроверки.ИмяТЧ = "ОтгружаемыеТовары";
		
		ПараметрыПроверки.ОтборПроверяемыхСтрок.Вставить("Действие", Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.Отгрузить);
		НоменклатураСервер.ПроверитьЗаполнениеУпаковок(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ, ПараметрыПроверки);
		
		ПараметрыПроверки.ОтборПроверяемыхСтрок.Вставить("Действие", Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.НеОтгружать);
		НоменклатураСервер.ПроверитьЗаполнениеУпаковок(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ, ПараметрыПроверки);
		
		ПараметрыПроверкиУказанияМногооборотнойТары = МногооборотнаяТараСервер.ПараметрыПроверкиУказанияМногооборотнойТары();
		ПараметрыПроверкиУказанияМногооборотнойТары.ЕстьЯчейки = Ложь;
		ПараметрыПроверкиУказанияМногооборотнойТары.ИмяТЧ = "ОтгружаемыеТовары";
		ПараметрыПроверкиУказанияМногооборотнойТары.ОтборСтрок = Новый Структура("Действие", Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.Отгрузить);
		МногооборотнаяТараСервер.ПроверитьУказаниеМногооборотнойТары(ЭтотОбъект, ПараметрыПроверкиУказанияМногооборотнойТары, Отказ);
	КонецЕсли;
	
	Если Статус = Перечисления.СтатусыОрдеровНаПеремещение.Принят
		Или Статус = Перечисления.СтатусыОрдеровНаПеремещение.КОтгрузке Тогда
		НайденныеСтроки = ОтгружаемыеТовары.НайтиСтроки(Новый Структура("Действие", Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.Отобрать));
		
		ПредставлениеТЧ = Метаданные().ТабличныеЧасти.ОтгружаемыеТовары.Представление();
		
		Для Каждого СтрТабл Из НайденныеСтроки Цикл
			Отказ = Истина;
			
			ПутьКДанным = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОтгружаемыеТовары", СтрТабл.НомерСтроки, "Действие");
						
			ТекстСообщения = НСтр("ru = 'В строке %НомерСтроки% списка %ИмяТЧ% выбрано действие ""%Отобрать%"". Невозможно проведение документа в статусе %СтатусДокумента%. Необходимо выбрать действие: ""%НеОтгружать%"" или ""%Отгрузить%"".'");
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", СтрТабл.НомерСтроки);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяТЧ%", ПредставлениеТЧ);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Отобрать%", Строка(Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.Отобрать));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СтатусДокумента%", Строка(Статус));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НеОтгружать%", Строка(Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.НеОтгружать));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Отгрузить%", Строка(Перечисления.ДействияСоСтрокамиОрдеровНаОтгрузку.Отгрузить));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, ПутьКДанным);
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если ЗначениеЗаполнено(ПомещениеОтправитель)
		И ЗначениеЗаполнено(ПомещениеПолучатель)
		И ПомещениеОтправитель = ПомещениеПолучатель Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Одно и то же складское помещение не может являться отправителем и получателем одновременно.'"),
				ЭтотОбъект,
				"ПомещениеОтправитель",,Отказ);

	КонецЕсли;
	
	СкладыСервер.ПроверитьОрдерностьСклада(Склад, ДатаОтгрузки, "ПриОтраженииИзлишковНедостач", Отказ);
	СкладыСервер.ПроверитьОрдерностьСклада(Склад, ДатаОтгрузки, "ПриОтгрузке", Отказ);
	СкладыСервер.ПроверитьОрдерностьСклада(Склад, ДатаОтгрузки, "ПриПоступлении", Отказ);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	Если ЗначениеЗаполнено(Склад)
		И НЕ СкладыСервер.ИспользоватьСкладскиеПомещения(Склад,ДатаОтгрузки) Тогда
		
		ТекстСообщения = НСтр("ru='Не удалось создать ""Ордер на перемещение товаров"", поскольку на складе ""%Склад%"" на %ДатаОтгрузки% не используются складские помещения.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Склад%",Склад);
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%ДатаОтгрузки%",Формат(ДатаОтгрузки,"ДЛФ=D"));
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();
	Статус        = Метаданные().Реквизиты.Статус.ЗначениеЗаполнения;
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	Приоритет     = Справочники.Приоритеты.ПолучитьПриоритетПоУмолчанию(Приоритет);
	
	Если Не ЗначениеЗаполнено(ДатаОтгрузки) Тогда
		ДатаОтгрузки = ТекущаяДатаСеанса();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли