
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	УточнитьСписокХозяйственныхОпераций();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриЧтенииСозданииНаСервере();
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Используется для автоматического обновления формы платежного календаря
	Оповестить("Запись_РаспоряжениеНаПеремещениеДенежныхСредств", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	ХозяйственнаяОперацияПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ХозяйственнаяОперацияПриИзмененииСервер()
	
	ЗаполнитьРеквизитыДокументаПоХозяйственнойОперации();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КассаПриИзменении(Элемент)
	
	СтруктураРеквизитов = ПолучитьРеквизитыКассы(Объект.Касса);
	
	Если НЕ ФинансыКлиент.НеобходимПересчетВВалюту(Объект, Объект.Валюта, СтруктураРеквизитов.Валюта) Тогда
		
		КассаПриИзмененииСервер(СтруктураРеквизитов, Ложь);
	Иначе
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пересчитать суммы в документе в валюту %1?'"),
			СтруктураРеквизитов.Валюта);
		
		КнопкиДиалогаВопрос = Новый СписокЗначений;
		КнопкиДиалогаВопрос.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Пересчитать'"));
		КнопкиДиалогаВопрос.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отменить'"));
		
		ОписаниеОповещения = Новый ОписаниеОповещения("РазрешенПересчетВВалютуКасса", ЭтотОбъект, Новый Структура("СтруктураРеквизитов", СтруктураРеквизитов));
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, КнопкиДиалогаВопрос);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешенПересчетВВалютуКасса(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ТекущаяВалюта = Объект.Валюта;
		КассаПриИзмененииСервер(ДополнительныеПараметры.СтруктураРеквизитов, Истина);
		ЦенообразованиеКлиент.ОповеститьОбОкончанииПересчетаСуммВВалюту(ТекущаяВалюта, Объект.Валюта);
	Иначе
		
		Объект.Касса = ТекущаяКасса;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КассаПриИзмененииСервер(СтруктураРеквизитов, ПересчитыватьСуммы)
	
	ТекущаяКасса = Объект.Касса;
	
	Если ЗначениеЗаполнено(Объект.Касса) Тогда
		Объект.Организация = СтруктураРеквизитов.Организация;
	КонецЕсли;
	
	ТекущаяВалюта = Объект.Валюта;
	Объект.Валюта = СтруктураРеквизитов.Валюта;
	
	Если ПересчитыватьСуммы Тогда
		ПересчетСуммДокументаВВалюту(ТекущаяВалюта);
	КонецЕсли;
	
	Объект.БанковскийСчетПолучатель = Справочники.БанковскиеСчетаОрганизаций.ПустаяСсылка();
	Объект.КассаПолучатель          = Справочники.Кассы.ПустаяСсылка();
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	
	СтруктураРеквизитов = ПолучитьРеквизитыБанковскогоСчета(Объект.БанковскийСчет);
	
	Если Не ФинансыКлиент.НеобходимПересчетВВалюту(Объект, Объект.Валюта, СтруктураРеквизитов.Валюта) Тогда
		
		БанковскийСчетПриИзмененииСервер(СтруктураРеквизитов, Ложь);
	Иначе
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пересчитать суммы в документе в валюту %1?'"),
			СтруктураРеквизитов.Валюта);
		
		КнопкиДиалогаВопрос = Новый СписокЗначений;
		КнопкиДиалогаВопрос.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Пересчитать'"));
		КнопкиДиалогаВопрос.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отменить'"));
		
		ОписаниеОповещения = Новый ОписаниеОповещения("РазрешенПересчетВВалютуСчет", ЭтотОбъект, Новый Структура("СтруктураРеквизитов", СтруктураРеквизитов));
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, КнопкиДиалогаВопрос);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешенПересчетВВалютуСчет(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ТекущаяВалюта = Объект.Валюта;
		БанковскийСчетПриИзмененииСервер(ДополнительныеПараметры.СтруктураРеквизитов, Истина);
		ЦенообразованиеКлиент.ОповеститьОбОкончанииПересчетаСуммВВалюту(ТекущаяВалюта, Объект.Валюта);
	Иначе
		
		Объект.БанковскийСчет = ТекущийБанковскийСчет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура БанковскийСчетПриИзмененииСервер(СтруктураРеквизитов, ПересчитыватьСуммы)
	
	ТекущийБанковскийСчет = Объект.БанковскийСчет;
	
	//++ Локализация


	//-- Локализация
	
	Если ЗначениеЗаполнено(Объект.БанковскийСчет) Тогда
		Объект.Организация = СтруктураРеквизитов.Организация;
	КонецЕсли;
	
	ТекущаяВалюта = Объект.Валюта;
	Объект.Валюта = СтруктураРеквизитов.Валюта;
	
	Если ПересчитыватьСуммы Тогда
		ПересчетСуммДокументаВВалюту(ТекущаяВалюта);
	КонецЕсли;
	
	Объект.БанковскийСчетПолучатель = Справочники.БанковскиеСчетаОрганизаций.ПустаяСсылка();
	Объект.КассаПолучатель          = Справочники.Кассы.ПустаяСсылка();
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы("Статус");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
	//++ Локализация


	//-- Локализация
	
КонецПроцедуры

&НаСервере
Процедура УточнитьСписокХозяйственныхОпераций()
	
	ИспользоватьНесколькоРасчетныхСчетов = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");
	ИспользоватьНесколькоКасс            = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	
	Если Не ИспользоватьНесколькоРасчетныхСчетов Тогда
		СписокВыбораХозяйственныхОпераций = Элементы.ХозяйственнаяОперация.СписокВыбора;
		НайденныйЭлемент = СписокВыбораХозяйственныхОпераций.НайтиПоЗначению(
			Перечисления.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет);
		Если НайденныйЭлемент <> Неопределено Тогда
			СписокВыбораХозяйственныхОпераций.Удалить(НайденныйЭлемент);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ИспользоватьНесколькоКасс Тогда
		СписокВыбораХозяйственныхОпераций = Элементы.ХозяйственнаяОперация.СписокВыбора;
		НайденныйЭлемент = СписокВыбораХозяйственныхОпераций.НайтиПоЗначению(
			Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу);
		Если НайденныйЭлемент <> Неопределено Тогда
			СписокВыбораХозяйственныхОпераций.Удалить(НайденныйЭлемент);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ДенежныеСредстваСервер.УправлениеЭлементамиФормыПриЧтенииСозданииНаСервере(ЭтотОбъект);
	
	ТекущаяКасса = Объект.Касса;
	ТекущийБанковскийСчет = Объект.БанковскийСчет;
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыДокументаПоХозяйственнойОперации()
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк Тогда
		
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияКассыОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация  = Объект.Организация;
		СтруктураПараметров.Касса        = Объект.Касса;
		
		Объект.Касса = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию(СтруктураПараметров);
		Объект.Валюта = Справочники.Кассы.ПолучитьРеквизитыКассы(Объект.Касса).Валюта;
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СнятиеНаличныхДенежныхСредств Тогда
		
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация      = Объект.Организация;
		СтруктураПараметров.БанковскийСчет   = Объект.БанковскийСчет;
		
		Объект.БанковскийСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
		Объект.Валюта = Справочники.БанковскиеСчетаОрганизаций.ПолучитьРеквизитыБанковскогоСчетаОрганизации(Объект.БанковскийСчет).Валюта;
	КонецЕсли;
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СнятиеНаличныхДенежныхСредств Тогда
		
		ОрганизацияПолучатель = Объект.Организация;
		
		КассаПолучатель = Справочники.Кассы.ПолучитьКассуПоУмолчанию(
			ОрганизацияПолучатель,
			Объект.Валюта);
		Если ЗначениеЗаполнено(КассаПолучатель) Тогда
			Объект.КассаПолучатель = КассаПолучатель;
		КонецЕсли;
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк Тогда
		
		ОрганизацияПолучатель = Объект.Организация;
		
		БанковскийСчетПолучатель = Справочники.БанковскиеСчетаОрганизаций.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(
			ОрганизацияПолучатель,
			Объект.Валюта);
		Если ЗначениеЗаполнено(БанковскийСчетПолучатель) Тогда
			Объект.БанковскийСчетПолучатель = БанковскийСчетПолучатель;
		КонецЕсли;
	КонецЕсли;
	
	//++ Локализация


	//-- Локализация
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыКассы(Касса)
	
	Возврат Справочники.Кассы.ПолучитьРеквизитыКассы(Касса);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыБанковскогоСчета(БанковскийСчет)
	
	Возврат Справочники.БанковскиеСчетаОрганизаций.ПолучитьРеквизитыБанковскогоСчетаОрганизации(БанковскийСчет);
	
КонецФункции

&НаСервере
Процедура ПересчетСуммДокументаВВалюту(ТекущаяВалюта)
	
	ДенежныеСредстваСервер.ПересчетСуммДокументаВВалюту(
		Объект,
		ТекущаяВалюта,
		Объект.Валюта);
	
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
	РеквизитыФормы.Вставить("Модифицированность");
	
	ЗаполнитьЗначенияСвойств(РеквизитыФормы, Форма);
	
	Возврат РеквизитыФормы;
	
КонецФункции

#КонецОбласти

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура ПодтверждающиеДокументыФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	//++ Локализация


	//-- Локализация
	Возврат;
	
КонецПроцедуры

#КонецОбласти

//++ Локализация
#Область Локализация

#Область Локализация_ПодключаемыеОбработчикиСобытийФормы

&НаСервере
Процедура Подключаемый_ПриСозданииНаСервереЛокализация(Отказ, СтандартнаяОбработка)
	
	ПриСозданииНаСервере(Отказ, СтандартнаяОбработка);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервереЛокализация();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ПриЧтенииНаСервереЛокализация(ТекущийОбъект)
	
	ПриЧтенииНаСервере(ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервереЛокализация();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаОповещенияЛокализация(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл"
			И Параметр.Свойство("ВладелецФайла")
			И Параметр.ВладелецФайла = ВыбранныйВладелецФайла
			И Параметр.ЭтоНовый
			И ДобавляетсяФайлПодтверждающегоДокумента Тогда
			
		Элементы.ПодтверждающиеДокументы.ТекущиеДанные.Файл = Источник[0];
		ДобавляетсяФайлПодтверждающегоДокумента = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодтверждающиеДокументы

&НаКлиенте
Процедура ПодтверждающиеДокументыФайлНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ДополнительныеПараметрыВыбораВладельца = Новый Структура("Действие", Результат.Значение);
		Если ЗначениеЗаполнено(Объект.ДоговорСЗаказчиком) Тогда
			ВыборВладельцаФайлаЗавершение(Новый Структура("Значение", Объект.ДоговорСЗаказчиком), ДополнительныеПараметрыВыбораВладельца);
		Иначе
			Если Результат.Значение = "ДобавлениеФайлаСДиска" Тогда
				ПоказатьПредупреждение(, НСтр("ru='В документе не указан договор с заказчиком. Добавление файла невозможно.'"));
			ИначеЕсли Результат.Значение = "ВыборИзПрисоединенныхФайлов" Тогда
				ПоказатьПредупреждение(, НСтр("ru='В документе не указан договор с заказчиком. Выбор файла невозможен.'"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборВладельцаФайлаЗавершение(Результат, ДополнительныеПараметры)
	
	Если Результат <> Неопределено Тогда
		ВыбранныйВладелецФайла = Результат.Значение;
		Если ДополнительныеПараметры.Действие = "ДобавлениеФайлаСДиска" Тогда
			ИдентификаторФайла = Новый УникальныйИдентификатор;
			ДобавляетсяФайлПодтверждающегоДокумента = Истина;
			РаботаСФайламиКлиент.ДобавитьФайлы(ВыбранныйВладелецФайла, ИдентификаторФайла);
		ИначеЕсли ДополнительныеПараметры.Действие = "ВыборИзПрисоединенныхФайлов" Тогда
			РаботаСФайламиКлиент.ОткрытьФормуВыбораФайлов(ВыбранныйВладелецФайла, Элементы.ПодтверждающиеДокументыФайл);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЛокализацияСлужебные

&НаСервере
Процедура ПриЧтенииСозданииНаСервереЛокализация()
	
	ДенежныеСредстваСерверЛокализация.УправлениеЭлементамиФормыПриЧтенииСозданииНаСервере(ЭтотОбъект);
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти

#Область Инициализация

#Если НаСервере Тогда

Если Не ПодключеныОбработчикиЛокализация И ПолучитьФункциональнуюОпцию("ПоддержкаПлатежейРФ") Тогда
	
	ПодключеныОбработчикиЛокализация = Истина;
	
	ПодключаемыеОбработчикиСобытийФормы = Новый Массив;
	ПодключаемыеОбработчикиСобытийФормы.Добавить("ПриСозданииНаСервере");
	ПодключаемыеОбработчикиСобытийФормы.Добавить("ПриЧтенииНаСервере");
	ПодключаемыеОбработчикиСобытийФормы.Добавить("ОбработкаОповещения");
	
	Для каждого Обработчик Из ПодключаемыеОбработчикиСобытийФормы Цикл
		УстановитьДействие(Обработчик, "Подключаемый_" + Обработчик + "Локализация");
	КонецЦикла;
	
КонецЕсли;

#КонецЕсли

#КонецОбласти
//-- Локализация
