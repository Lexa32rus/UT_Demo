#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ПередЗаписью(Отказ, Замещение)
		
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Расчеты.Регистратор               КАК Регистратор,
	|	Расчеты.Период                    КАК Период,
	|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	Расчеты.ЗаказПоставщику           КАК ЗаказПоставщику,
	|	Расчеты.РасчетныйДокумент         КАК РасчетныйДокумент,
	|	Расчеты.Валюта                    КАК Валюта,
	|
	|	Расчеты.Долг             КАК Долг,
	|	Расчеты.ДолгУпр          КАК ДолгУпр,
	|	Расчеты.ДолгРегл         КАК ДолгРегл,
	|	Расчеты.Предоплата       КАК Предоплата,
	|	Расчеты.ПредоплатаУпр    КАК ПредоплатаУпр,
	|	Расчеты.ПредоплатаРегл   КАК ПредоплатаРегл,
	|	Расчеты.ЗалогЗаТару      КАК ЗалогЗаТару,
	|	Расчеты.ЗалогЗаТаруРегл  КАК ЗалогЗаТаруРегл,
	|
	|	Расчеты.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|	Расчеты.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|ПОМЕСТИТЬ РасчетыСПоставщикамиПоДокументамИсходныеДвижения
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщикамиПоДокументам КАК Расчеты
	|ГДЕ
	|	Расчеты.Регистратор = &Регистратор
	|");

	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	МассивТекстовЗапроса = Новый Массив;
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Период                       КАК Период,
	|	Таблица.АналитикаУчетаПоПартнерам    КАК АналитикаУчетаПоПартнерам,
	|	Таблица.ЗаказПоставщику              КАК ЗаказПоставщику,
	|	Таблица.РасчетныйДокумент            КАК РасчетныйДокумент,
	|	Таблица.Регистратор                  КАК Регистратор
	|ПОМЕСТИТЬ РасчетыСПоставщикамиПоДокументамИзменения
	|ИЗ
	|	(ВЫБРАТЬ
	|		Расчеты.Регистратор               КАК Регистратор,
	|		Расчеты.Период                    КАК Период,
	|		Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|		Расчеты.ЗаказПоставщику           КАК ЗаказПоставщику,
	|		Расчеты.РасчетныйДокумент         КАК РасчетныйДокумент,
	|		Расчеты.Валюта                    КАК Валюта,
	|
	|		Расчеты.Долг             КАК Долг,
	|		Расчеты.ДолгУпр          КАК ДолгУпр,
	|		Расчеты.ДолгРегл         КАК ДолгРегл,
	|		Расчеты.Предоплата       КАК Предоплата,
	|		Расчеты.ПредоплатаУпр    КАК ПредоплатаУпр,
	|		Расчеты.ПредоплатаРегл   КАК ПредоплатаРегл,
	|		Расчеты.ЗалогЗаТару      КАК ЗалогЗаТару,
	|		Расчеты.ЗалогЗаТаруРегл  КАК ЗалогЗаТаруРегл,
	|
	|		Расчеты.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|		Расчеты.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|	ИЗ
	|		РасчетыСПоставщикамиПоДокументамИсходныеДвижения КАК Расчеты
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|		
	|	ВЫБРАТЬ
	|		Расчеты.Регистратор               КАК Регистратор,
	|		Расчеты.Период                    КАК Период,
	|		Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|		Расчеты.ЗаказПоставщику           КАК ЗаказПоставщику,
	|		Расчеты.РасчетныйДокумент         КАК РасчетныйДокумент,
	|		Расчеты.Валюта                    КАК Валюта,
	|
	|		-Расчеты.Долг             КАК Долг,
	|		-Расчеты.ДолгУпр          КАК ДолгУпр,
	|		-Расчеты.ДолгРегл         КАК ДолгРегл,
	|		-Расчеты.Предоплата       КАК Предоплата,
	|		-Расчеты.ПредоплатаУпр    КАК ПредоплатаУпр,
	|		-Расчеты.ПредоплатаРегл   КАК ПредоплатаРегл,
	|		-Расчеты.ЗалогЗаТару      КАК ЗалогЗаТару,
	|		-Расчеты.ЗалогЗаТаруРегл  КАК ЗалогЗаТаруРегл,
	|
	|		Расчеты.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|		Расчеты.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщикамиПоДокументам КАК Расчеты
	|	ГДЕ Расчеты.Регистратор = &Регистратор
	|) КАК Таблица
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.АналитикаУчетаПоПартнерам,
	|	Таблица.ЗаказПоставщику,
	|	Таблица.РасчетныйДокумент,
	|	Таблица.Валюта,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.СтатьяДвиженияДенежныхСредств
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Долг) <> 0 ИЛИ СУММА(Таблица.ДолгУпр) <> 0 ИЛИ СУММА(Таблица.ДолгРегл) <> 0
	|	ИЛИ СУММА(Таблица.Предоплата) <> 0 ИЛИ СУММА(Таблица.ПредоплатаУпр) <> 0 ИЛИ СУММА(Таблица.ПредоплатаРегл) <> 0
	|	ИЛИ СУММА(Таблица.ЗалогЗаТару) <> 0 ИЛИ СУММА(Таблица.ЗалогЗаТаруРегл) <> 0";
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК Месяц,
	|	Таблица.АналитикаУчетаПоПартнерам    КАК АналитикаУчетаПоПартнерам,
	|	Таблица.ЗаказПоставщику              КАК ОбъектРасчетов,
	|	Таблица.Регистратор                  КАК Документ
	|ПОМЕСТИТЬ РасчетыСПоставщикамиПоДокументамЗаданияКРасчетамСПоставщиками
	|ИЗ
	|	РасчетыСПоставщикамиПоДокументамИзменения КАК Таблица
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(Таблица.Регистратор) = ТИП(Документ.РасчетКурсовыхРазниц)";
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	
	Если Не ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НАЧАЛОПЕРИОДА(Изменения.Период, МЕСЯЦ)         КАК Период,
		|	Изменения.Регистратор                          КАК Документ,
		|	Изменения.АналитикаУчетаПоПартнерам.Контрагент КАК Контрагент
		|ИЗ
		|	РасчетыСПоставщикамиПоДокументамИзменения КАК Изменения
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НАЧАЛОПЕРИОДА(Изменения.Период, МЕСЯЦ)         КАК Период,
		|	Изменения.РасчетныйДокумент                    КАК Документ,
		|	Изменения.АналитикаУчетаПоПартнерам.Контрагент КАК Контрагент
		|ИЗ
		|	РасчетыСПоставщикамиПоДокументамИзменения КАК Изменения";
		
		МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	КонецЕсли;
		
	МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ РасчетыСПоставщикамиПоДокументамИсходныеДвижения");
	
	Запрос.Текст = СтрСоединить(МассивТекстовЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	
	Результат = Запрос.ВыполнитьПакет();
	
	Если Не ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		УчетНДСУП.ОтразитьВУчетеНДСИзменениеРасчетовСПоставщиками(Результат[2].Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли