#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ДополнительныеСвойства.Свойство("НеЗаполнятьТабличнуюЧасть") Тогда
		Товары.Очистить();
		ШтрихкодыУпаковок.Очистить();
	КонецЕсли;
	
	ИнтеграцияИСМППереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	ЗаполнитьОбъектПоСтатистике();
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		Контрагент = ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("КонтрагентГосИС");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	НепроверяемыеРеквизиты.Добавить("ДатаВыводаИзОборота");
	НепроверяемыеРеквизиты.Добавить("ИдентификаторГосКонтракта");

	ОбязательныеРеквизиты = Новый Массив;
	Если Операция = Перечисления.ВидыОперацийИСМП.ОтгрузкаБезвозмезднаяПередача Тогда
		ОбязательныеРеквизиты.Добавить("ДатаВыводаИзОборота");
	ИначеЕсли Операция = Перечисления.ВидыОперацийИСМП.ОтгрузкаПриобретениеГосПредприятием Тогда
		
		Используется275ФЗ = Ложь;
		ИнтеграцияИСМППереопределяемый.ИспользуетсяПоддержкаПлатежейВСоответствииС275ФЗ(Используется275ФЗ);
		
		Если Используется275ФЗ Тогда
			ОбязательныеРеквизиты.Добавить("ИдентификаторГосКонтракта");
		Иначе
			Если Не ЗначениеЗаполнено(ИдентификаторГосКонтракта) Тогда
				ТекстСообщения = НСтр("ru = 'Не заполнен идентификатор гос. контракта.
				                            |Включите в настройках Поддержку платежей в соответствии с 275ФЗ
				                            |или измените вид операции документа.'");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Операция", , Отказ);
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ВидыОперацийИСМП.ОтгрузкаДляСобственныхНуждПокупателя Тогда
		ОбязательныеРеквизиты.Добавить("ДатаВыводаИзОборота");
	КонецЕсли;
	
	Если Не (Операция = Перечисления.ВидыОперацийИСМП.ОтгрузкаЕАЭССПризнаниемКИ
		Или Операция = Перечисления.ВидыОперацийИСМП.ОтгрузкаВЕАЭСПриОСУ) Тогда
		НепроверяемыеРеквизиты.Добавить("СтранаНазначения");
	КонецЕсли;
	
	Если Не ИнтеграцияИСМПСлужебныйКлиентСервер.ИспользованиеGLNКонтрагентаПриОтгрузкеТоваров(Операция, Истина) Тогда
		НепроверяемыеРеквизиты.Добавить("GLNКонтрагента");
	КонецЕсли;
	
	Если Операция <> Перечисления.ВидыОперацийИСМП.ОтгрузкаВЕАЭСПриОСУ Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.GTIN");
	КонецЕсли;
	
	НепроверяемыеРеквизиты.Добавить("Товары.ИдентификаторПроисхожденияВЕТИССтрокой");
	ИспользуетсяПодсистемаВетИС = ИнтеграцияИСМПВЕТИС.ИспользуетсяПодсистемаВетИС();
	Если Не (Операция = Перечисления.ВидыОперацийИСМП.ОтгрузкаВЕАЭСПриОСУ
		И ВидПродукции = Перечисления.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС) Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.ИдентификаторПроисхожденияВЕТИС");
	ИначеЕсли Не ИспользуетсяПодсистемаВетИС Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.ИдентификаторПроисхожденияВЕТИС");
		ШаблонСообщения = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""Товары""'");
		Для Каждого СтрокаТовары Из Товары Цикл
			Если Не ЗначениеЗаполнено(СтрокаТовары.ИдентификаторПроисхожденияВЕТИССтрокой) Тогда
				ТекстСообщения = СтрШаблон(ШаблонСообщения, НСтр("ru = 'Идентификатор ВСД'"), СтрокаТовары.НомерСтроки);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
							"Товары", СтрокаТовары.НомерСтроки, "ИдентификаторПроисхожденияВЕТИССтрокойНаФорме"),,
						Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	НепроверяемыеРеквизиты = ОбщегоНазначенияКлиентСервер.РазностьМассивов(НепроверяемыеРеквизиты, ОбязательныеРеквизиты);
	
	ИнтеграцияИСМППереопределяемый.ПриОпределенииОбработкиПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	Если Операция <> Перечисления.ВидыОперацийИСМП.ОтгрузкаВЕАЭСПриОСУ Тогда
		ИнтеграцияИСМПСлужебный.ПроверитьЗаполнениеШтрихкодовУпаковок(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЭтотОбъект.ДатаВыводаИзОборота) И ЭтотОбъект.ДатаВыводаИзОборота < ЭтотОбъект.ДатаПервичногоДокумента Тогда
		ТекстСообщения = НСтр("ru = 'Дата вывода из оборота не может быть меньше даты первичного документа'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДатаВыводаИзОборота", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияИСМП.ЗаписатьСтатусДокументаИСМППоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование   = Неопределено;
	ИдентификаторЗаявки = Неопределено;
	ИдентификаторЗаявкиНаОтгрузку = "";
	ШтрихкодыУпаковок.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьОбъектПоСтатистике()
	
	ДанныеСтатистики = ЗаполнениеОбъектовПоСтатистикеИСМП.ДанныеЗаполненияОтгрузкиТоваровИСМП(Организация);
	
	Для Каждого КлючИЗначение Из ДанныеСтатистики Цикл
		ЗаполнениеОбъектовПоСтатистикеИСМП.ЗаполнитьПустойРеквизит(ЭтотОбъект, ДанныеСтатистики, КлючИЗначение.Ключ);
	КонецЦикла;
	
	ЗаполнениеОбъектовПоСтатистикеИСМП.ЗаполнитьДанныеПоТоварамОтгрузкиТоваровИСМП(
		ЭтотОбъект.Товары,
		ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли