#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КорНДС.Ссылка
	|ИЗ
	|	Документ.КорректировкаНалогообложенияНДСПартийТоваров КАК КорНДС
	|ГДЕ
	|	НЕ КорНДС.Ссылка = &Ссылка
	|	И КорНДС.Организация = &Организация
	|	И КорНДС.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И КорНДС.Проведен");
	
	Запрос.УстановитьПараметр("Ссылка",			Ссылка);
	Запрос.УстановитьПараметр("Организация",	Организация);
	Запрос.УстановитьПараметр("ДатаНачала",		НачалоКвартала(Дата));
	Запрос.УстановитьПараметр("ДатаОкончания",	КонецКвартала(Дата));
	
	Если Не Запрос.Выполнить().Пустой() Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'За %1 квартал по организации ""%2"" уже проведена корректировка налогообложения НДС. Проведение еще одной корректировки невозможно.'"),
			Формат(Дата, "ДФ=к"),
			Организация);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			Ссылка,
			"Дата",
			"Объект",
			Отказ);
		
	КонецЕсли;
	
	Если Не КонецМесяца(Дата) = КонецКвартала(Дата) Тогда
		
		ДатаС  = НачалоМесяца(КонецКвартала(Дата));
		ДатаПо = КонецКвартала(Дата);
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Документ может быть проведен только в последнем месяце отчетного периода по НДС (квартала), укажите дату документа в промежутке с %1 по %2'"),
			Формат(ДатаС,  "ДЛФ=DD"),
			Формат(ДатаПо, "ДЛФ=DD"));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			Ссылка,
			"Дата",
			"Объект",
			Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если ПеремещениеПодДеятельность.Пустая() Тогда
		ПеремещениеПодДеятельность = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ЗаполнитьВидыЗапасов(Отказ);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		
		ВидыЗапасов.Очистить();
		
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Если документ проводится при закрытии месяца, то задание к расчету себестоимости не формируется.
	ИмяСлужебногоДополнительногоСвойстваОбъекта = РасчетСебестоимостиПрикладныеАлгоритмы.ИмяСлужебногоДополнительногоСвойстваОбъекта();
	Если ДополнительныеСвойства.Свойство(ИмяСлужебногоДополнительногоСвойстваОбъекта) Тогда
		Движения.ТоварыОрганизаций.ДополнительныеСвойства.Вставить(ИмяСлужебногоДополнительногоСвойстваОбъекта);
		Движения.СебестоимостьТоваров.ДополнительныеСвойства.Вставить(ИмяСлужебногоДополнительногоСвойстваОбъекта);
	КонецЕсли;
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	Если ДополнительныеСвойства.Свойство("ПроводитьБезКонтроляОстатковТоваровОрганизаций") Тогда
		ПараметрыСеанса.ПроводитьБезКонтроляОстатковТоваровОрганизаций = ДополнительныеСвойства.ПроводитьБезКонтроляОстатковТоваровОрганизаций;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", "ПолучитьПередПодготовкой");
	
	// Если документ проводится при закрытии месяца, то задание к расчету себестоимости не формируется.
	ИмяСлужебногоДополнительногоСвойстваОбъекта = РасчетСебестоимостиПрикладныеАлгоритмы.ИмяСлужебногоДополнительногоСвойстваОбъекта();
	Если ДополнительныеСвойства.Свойство(ИмяСлужебногоДополнительногоСвойстваОбъекта) Тогда
		Движения.ТоварыОрганизаций.ДополнительныеСвойства.Вставить(ИмяСлужебногоДополнительногоСвойстваОбъекта);
		Движения.ПартииТоваровОрганизаций.ДополнительныеСвойства.Вставить(ИмяСлужебногоДополнительногоСвойстваОбъекта);
		Движения.ПартииРасходовНаСебестоимостьТоваров.ДополнительныеСвойства.Вставить(ИмяСлужебногоДополнительногоСвойстваОбъекта);
		Движения.СебестоимостьТоваров.ДополнительныеСвойства.Вставить(ИмяСлужебногоДополнительногоСвойстваОбъекта);
	КонецЕсли;
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьТаблицуТоваровКИзмененияНалогообложения(МенеджерВременныхТаблиц, Товары)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	тПартии.АналитикаУчетаНоменклатуры.Номенклатура					КАК Номенклатура,
	|	тПартии.АналитикаУчетаНоменклатуры.Характеристика				КАК Характеристика,
	|	тПартии.АналитикаУчетаНоменклатуры.Серия						КАК Серия,
	|	тПартии.АналитикаУчетаНоменклатуры.МестоХранения				КАК Склад,
	|	тПартии.Организация						КАК Организация,
	|	тПартии.АналитикаУчетаНоменклатуры		КАК АналитикаУчетаНоменклатуры,
	|	тПартии.ДокументПоступления				КАК ДокументПоступления,
	|	тПартии.ВидЗапасов						КАК ВидЗапасов,
	|	тПартии.АналитикаУчетаПартий			КАК АналитикаУчетаПартий,
	|	СУММА(тПартии.Количество)				КАК Количество,
	|	СУММА(тПартии.Стоимость)				КАК Стоимость,
	|	СУММА(тПартии.СтоимостьБезНДС)			КАК СтоимостьБезНДС,
	|	СУММА(тПартии.СтоимостьРегл)			КАК СтоимостьРегл,
	|	СУММА(тПартии.НДСРегл)					КАК НДСРегл,
	|	СУММА(тПартии.ПостояннаяРазница)		КАК ПостояннаяРазница,
	|	СУММА(тПартии.ВременнаяРазница)			КАК ВременнаяРазница
	|ПОМЕСТИТЬ ВтПартии
	|	
	|ИЗ (
	|	ВЫБРАТЬ
	|		Остатки.Организация						КАК Организация,
	|		Остатки.АналитикаУчетаНоменклатуры		КАК АналитикаУчетаНоменклатуры,
	|		Остатки.ДокументПоступления				КАК ДокументПоступления,
	|		Остатки.ВидЗапасов						КАК ВидЗапасов,
	|		Остатки.АналитикаУчетаПартий			КАК АналитикаУчетаПартий,
	|		Остатки.КоличествоОстаток				КАК Количество,
	|		Остатки.СтоимостьОстаток				КАК Стоимость,
	|		Остатки.СтоимостьБезНДСОстаток			КАК СтоимостьБезНДС,
	|		Остатки.СтоимостьРеглОстаток			КАК СтоимостьРегл,
	|		Остатки.НДСРеглОстаток					КАК НДСРегл,
	|		Остатки.ПостояннаяРазницаОстаток		КАК ПостояннаяРазница,
	|		Остатки.ВременнаяРазницаОстаток			КАК ВременнаяРазница
	|	ИЗ
	|		РегистрНакопления.ПартииТоваровОрганизаций.Остатки(
	|				&ГраницаКонецПериода,
	|				АналитикаУчетаПартий.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПоФактическомуИспользованию)
	|				И Организация = &Организация
	|		) КАК Остатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|			ПО Остатки.ДокументПоступления = ДанныеПервичныхДокументов.Документ
	|	ГДЕ
	|		ДанныеПервичныхДокументов.ДатаРегистратора МЕЖДУ &НачалоПериодаМинус3Года И &КонецПериодаМинус3Года	
	|		И Остатки.КоличествоОстаток > 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Остатки.Организация						КАК Организация,
	|		Остатки.АналитикаУчетаНоменклатуры		КАК АналитикаУчетаНоменклатуры,
	|		Остатки.ДокументПоступления				КАК ДокументПоступления,
	|		Остатки.ВидЗапасов						КАК ВидЗапасов,
	|		Остатки.АналитикаУчетаПартий			КАК АналитикаУчетаПартий,
	|		Остатки.КоличествоОстаток				КАК Количество,
	|		0										КАК Стоимость,
	|		Остатки.СтоимостьБезНДСОстаток			КАК СтоимостьБезНДС,
	|		0										КАК СтоимостьРегл,
	|		Остатки.НДСОстаток						КАК НДСРегл,
	|		0										КАК ПостояннаяРазница,
	|		0										КАК ВременнаяРазница
	|	ИЗ
	|		РегистрНакопления.ДетализацияПартийТоваровДляНДСиУСН.Остатки(
	|				&ГраницаКонецПериода,
	|				АналитикаУчетаПартий.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПоФактическомуИспользованию)
	|				И Организация = &Организация
	|		) КАК Остатки
	|	
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|		ПО Остатки.ДокументПоступления = ДанныеПервичныхДокументов.Документ
	|	ГДЕ
	|		&ПартионныйУчетВерсии22
	|		И ДанныеПервичныхДокументов.ДатаРегистратора МЕЖДУ &НачалоПериодаМинус3Года И &КонецПериодаМинус3Года
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Остатки.Организация						КАК Организация,
	|		Остатки.АналитикаУчетаНоменклатуры		КАК АналитикаУчетаНоменклатуры,
	|		Остатки.ДокументПоступления				КАК ДокументПоступления,
	|		Остатки.ВидЗапасов						КАК ВидЗапасов,
	|		Остатки.АналитикаУчетаПартий			КАК АналитикаУчетаПартий,
	|		Остатки.Количество						КАК Количество,
	|		Остатки.Стоимость						КАК Стоимость,
	|		Остатки.СтоимостьБезНДС					КАК СтоимостьБезНДС,
	|		Остатки.СтоимостьРегл					КАК СтоимостьРегл,
	|		Остатки.НДСРегл							КАК НДСРегл,
	|		Остатки.ПостояннаяРазница				КАК ПостояннаяРазница,
	|		Остатки.ВременнаяРазница				КАК ВременнаяРазница
	|	ИЗ
	|		РегистрНакопления.ПартииТоваровОрганизаций КАК Остатки
	|	ГДЕ
	|		Остатки.Регистратор = &Ссылка
	|		И Остатки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Остатки.Организация						КАК Организация,
	|		Остатки.АналитикаУчетаНоменклатуры		КАК АналитикаУчетаНоменклатуры,
	|		Остатки.ДокументПоступления				КАК ДокументПоступления,
	|		Остатки.ВидЗапасов						КАК ВидЗапасов,
	|		Остатки.АналитикаУчетаПартий			КАК АналитикаУчетаПартий,
	|		Остатки.Количество						КАК Количество,
	|		0										КАК Стоимость,
	|		Остатки.СтоимостьБезНДС					КАК СтоимостьБезНДС,
	|		0										КАК СтоимостьРегл,
	|		Остатки.НДС								КАК НДСРегл,
	|		0										КАК ПостояннаяРазница,
	|		0										КАК ВременнаяРазница
	|	ИЗ
	|		РегистрНакопления.ДетализацияПартийТоваровДляНДСиУСН КАК Остатки
	|	ГДЕ
	|		Остатки.Регистратор = &Ссылка
	|		И Остатки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|		И &ПартионныйУчетВерсии22
	|) КАК тПартии
	|
	|СГРУППИРОВАТЬ ПО
	|	тПартии.АналитикаУчетаНоменклатуры.Номенклатура,
	|	тПартии.АналитикаУчетаНоменклатуры.Характеристика,
	|	тПартии.АналитикаУчетаНоменклатуры.Серия,
	|	тПартии.АналитикаУчетаНоменклатуры.МестоХранения,
	|	тПартии.Организация,
	|	тПартии.АналитикаУчетаНоменклатуры,
	|	тПартии.ДокументПоступления,
	|	тПартии.ВидЗапасов,
	|	тПартии.АналитикаУчетаПартий
	|
	|ИМЕЮЩИЕ
	|	СУММА(тПартии.Количество) > 0
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Остатки.АналитикаУчетаНоменклатуры		КАК АналитикаУчетаНоменклатуры,
	|	Остатки.ВидЗапасов						КАК ВидЗапасов,
	|	Остатки.Склад							КАК Склад,
	|	СУММА(Остатки.Количество)				КАК Количество
	|ИЗ
	|	ВтПартии КАК Остатки
	|
	|СГРУППИРОВАТЬ ПО
	|	Остатки.Склад,
	|	Остатки.ВидЗапасов,
	|	Остатки.АналитикаУчетаНоменклатуры");
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	НачалоСледНалПериода = КонецМесяца(Дата) + 1;
	
	Запрос.УстановитьПараметр("Организация",		Организация);
	Запрос.УстановитьПараметр("Ссылка",				Ссылка);
	Запрос.УстановитьПараметр("ГраницаКонецПериода", 	 Новый Граница(КонецМесяца(Дата), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("НачалоПериодаМинус3Года", ДобавитьМесяц(НачалоСледНалПериода, -36));
	Запрос.УстановитьПараметр("КонецПериодаМинус3Года",  ДобавитьМесяц(КонецКвартала(НачалоСледНалПериода), -36));
	Запрос.УстановитьПараметр("ПартионныйУчетВерсии22",
		РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22(НачалоМесяца(Дата)));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НомПП = 1;
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Товары.Добавить();
		НоваяСтрока.НомерСтроки = НомПП;
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		НомПП = НомПП + 1;
		
	КонецЦикла;
	
КонецПроцедуры

#Область ВидыЗапасов

Процедура ВременныеТаблицыДанныхДокумента(МенеджерВременныхТаблиц) Экспорт
	
	Товары = ВидыЗапасов.ВыгрузитьКолонки();
	
	ЗаполнитьТаблицуТоваровКИзмененияНалогообложения(МенеджерВременныхТаблиц, Товары);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтправитель,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладПолучатель,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	&ПеремещениеПодДеятельность КАК НалогообложениеНДС,
	|	&ПеремещениеПодДеятельность КАК ПеремещениеПодДеятельность,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПеремещениеТоваров) КАК ХозяйственнаяОперация,
	|	ЛОЖЬ КАК ЕстьСделкиВТабличнойЧасти,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Менеджер,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ДокументПоступления КАК ДокументПоступления,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.ВидЗапасовПолучателя КАК ВидЗапасовПолучателя,
	|	ТаблицаВидыЗапасов.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаВидыЗапасов.КоличествоПоРНПТ
	|	КОНЕЦ КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.Стоимость КАК Стоимость,
	|	ТаблицаВидыЗапасов.СтоимостьБезНДС КАК СтоимостьБезНДС,
	|	ТаблицаВидыЗапасов.СтоимостьРегл КАК СтоимостьРегл,
	|	ТаблицаВидыЗапасов.НДСРегл КАК НДСРегл,
	|	ТаблицаВидыЗапасов.ПостояннаяРазница КАК ПостояннаяРазница,
	|	ТаблицаВидыЗапасов.ВременнаяРазница КАК ВременнаяРазница,
	|	ИСТИНА КАК ВидыЗапасовУказаныВручную
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.Склад КАК Склад
	|ПОМЕСТИТЬ ВтТаблицаТоваров
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ВЫБОР
	|		КОГДА Аналитика.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|			ТОГДА 0
	|		ИНАЧЕ 14
	|	КОНЕЦ КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.Склад КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка) КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	ВтТаблицаТоваров КАК ТаблицаТоваров
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаТоваров.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ДокументПоступления КАК ДокументПоступления,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.ВидЗапасовПолучателя КАК ВидЗапасовПолучателя,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.Стоимость КАК Стоимость,
	|	ТаблицаВидыЗапасов.СтоимостьБезНДС КАК СтоимостьБезНДС,
	|	ТаблицаВидыЗапасов.СтоимостьРегл КАК СтоимостьРегл,
	|	ТаблицаВидыЗапасов.НДСРегл КАК НДСРегл,
	|	ТаблицаВидыЗапасов.ПостояннаяРазница КАК ПостояннаяРазница,
	|	ТаблицаВидыЗапасов.ВременнаяРазница КАК ВременнаяРазница,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры";
	
	Запрос.УстановитьПараметр("Дата",						Дата);
	Запрос.УстановитьПараметр("Организация",				Организация);
	Запрос.УстановитьПараметр("ПеремещениеПодДеятельность",	ПеремещениеПодДеятельность);
	Запрос.УстановитьПараметр("ТаблицаТовары",				Товары);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов",			ВидыЗапасов);
	
	УчетПрослеживаемыхТоваровЛокализация.УстановитьПараметрыИспользованияУчетаПрослеживаемыхТоваров(Запрос);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ЗаполнитьВидЗапасовПолучателя()
			
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Запасы.НомерСтроки,
	|	Запасы.АналитикаУчетаНоменклатуры,
	|	Запасы.ВидЗапасов
	|ПОМЕСТИТЬ Запасы
	|ИЗ
	|	&ВидыЗапасов КАК Запасы
	|;
	|////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Запасы.НомерСтроки													КАК НомерСтроки,
	|	ВидыЗапасов.Ссылка													КАК ВидЗапасов,
	|	ВидыЗапасов.ТипЗапасов												КАК ТипЗапасов,
	|	ВидыЗапасов.ВладелецТовара											КАК ВладелецТовара,
	|	ВидыЗапасов.Контрагент												КАК Контрагент,
	|	ВидыЗапасов.Договор													КАК Договор,
	|	ВидыЗапасов.Соглашение												КАК Соглашение,
	|	ВидыЗапасов.Валюта													КАК Валюта,
	|	&ПеремещениеПодДеятельность											КАК НалогообложениеНДС,
	|	&НалогообложениеОрганизации											КАК НалогообложениеОрганизации,
	|	ВидыЗапасов.ГруппаФинансовогоУчета									КАК ГруппаФинансовогоУчета,
	|	ЛОЖЬ																КАК РеализацияЗапасовДругойОрганизации,
	|	НЕОПРЕДЕЛЕНО														КАК ВидЗапасовВладельца,
	|
	|	ВЫБОР КОГДА ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар) ТОГДА
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемНаКомиссию)
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика)
	|	КОНЕЦ 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	КАК ХозоперацияВидаЗапаса
	|ИЗ
	|	Запасы КАК Запасы
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК ВидыЗапасов
	|		ПО ВидыЗапасов.Ссылка = Запасы.ВидЗапасов
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитики
	|		ПО Аналитики.Ссылка = Запасы.АналитикаУчетаНоменклатуры
	|");
	
	ПараметрыУчетаПоОрганизации = УчетНДСУП.ПараметрыУчетаПоОрганизации(Организация, Дата);
	Запрос.УстановитьПараметр("ВидыЗапасов", ВидыЗапасов.Выгрузить(, "НомерСтроки, АналитикаУчетаНоменклатуры, ВидЗапасов"));
	Запрос.УстановитьПараметр("НалогообложениеОрганизации", ПараметрыУчетаПоОрганизации.ОсновноеНалогообложениеНДСПродажи);
	Запрос.УстановитьПараметр("ПеремещениеПодДеятельность", ПеремещениеПодДеятельность);
	
	ВидыЗапасовПолучателя = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ВидЗапасовПолучателя = Справочники.ВидыЗапасов.ВидЗапасовДокумента(
			Организация,
			Выборка.ХозоперацияВидаЗапаса,
			Выборка);
		
		ВидыЗапасовПолучателя.Вставить(Выборка.НомерСтроки, ВидЗапасовПолучателя);
		
	КонецЦикла;
	
	Для Каждого Запас Из ВидыЗапасов Цикл
		ВидЗапасовПолучателя = ВидыЗапасовПолучателя[Запас.НомерСтроки];
		Запас.ВидЗапасовПолучателя = ?(Неопределено = ВидЗапасовПолучателя, Запас.ВидЗапасов, ВидЗапасовПолучателя);
	КонецЦикла;
	
КонецПроцедуры

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Организация, ПеремещениеПодДеятельность";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Функция ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ (
	|	ВЫБРАТЬ
	|		ТаблицаПартий.АналитикаУчетаНоменклатуры		КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаПартий.ДокументПоступления				КАК ДокументПоступления,
	|		ТаблицаПартий.Количество						КАК Количество,
	|		ТаблицаПартий.Стоимость							КАК Стоимость,
	|		ТаблицаПартий.СтоимостьБезНДС					КАК СтоимостьБезНДС,
	|		ТаблицаПартий.СтоимостьРегл						КАК СтоимостьРегл,
	|		ТаблицаПартий.НДСРегл							КАК НДСРегл,
	|		ТаблицаПартий.ПостояннаяРазница					КАК ПостояннаяРазница,
	|		ТаблицаПартий.ВременнаяРазница					КАК ВременнаяРазница
	|	ИЗ
	|		ВтПартии КАК ТаблицаПартий
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаВидыЗапасов.ДокументПоступления			КАК ДокументПоступления,
	|		-ТаблицаВидыЗапасов.Количество					КАК Количество,
	|		-ТаблицаВидыЗапасов.Стоимость					КАК Стоимость,
	|		-ТаблицаВидыЗапасов.СтоимостьБезНДС				КАК СтоимостьБезНДС,
	|		-ТаблицаВидыЗапасов.СтоимостьРегл				КАК СтоимостьРегл,
	|		-ТаблицаВидыЗапасов.НДСРегл						КАК НДСРегл,
	|		-ТаблицаВидыЗапасов.ПостояннаяРазница			КАК ПостояннаяРазница,
	|		-ТаблицаВидыЗапасов.ВременнаяРазница			КАК ВременнаяРазница
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|	) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.ДокументПоступления,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТоваров.Количество)			<> 0
	|	ИЛИ СУММА(ТаблицаТоваров.Стоимость)			<> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СтоимостьБезНДС)	<> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СтоимостьРегл)		<> 0
	|	ИЛИ СУММА(ТаблицаТоваров.НДСРегл)			<> 0
	|	ИЛИ СУММА(ТаблицаТоваров.ПостояннаяРазница)	<> 0
	|	ИЛИ СУММА(ТаблицаТоваров.ВременнаяРазница)	<> 0
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапрос = Запрос.Выполнить();
	
	Возврат (Не РезультатЗапрос.Пустой());
	
КонецФункции

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц		= Новый МенеджерВременныхТаблиц;
	ПерезаполнитьВидыЗапасов	= ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	ВременныеТаблицыДанныхДокумента(МенеджерВременныхТаблиц);
	ДополнительныеСвойства.Вставить("ОкончаниеПериодаПомощникаИсправленияОстатков", КонецМесяца(Дата));
	
	Если Не Проведен
		Или ПерезаполнитьВидыЗапасов
		Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
		Или ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
		
		ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов(МенеджерВременныхТаблиц);
		
		// Выключим контроль остатков товаров организаций.
		ПроводитьБезКонтроляОстатковТоваровОрганизаций = ПараметрыСеанса.ПроводитьБезКонтроляОстатковТоваровОрганизаций;
		
		ДополнительныеСвойства.Вставить("ПроводитьБезКонтроляОстатковТоваровОрганизаций",
										ПроводитьБезКонтроляОстатковТоваровОрганизаций);
		
		Если Не ПроводитьБезКонтроляОстатковТоваровОрганизаций Тогда
			ПараметрыСеанса.ПроводитьБезКонтроляОстатковТоваровОрганизаций = Истина;
		КонецЕсли;
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект,
																МенеджерВременныхТаблиц,
																Отказ,
																ПараметрыЗаполнения);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД", "Количество, КоличествоПоРНПТ");
		
		Если Не Отказ Тогда
			ЗаполнитьВидЗапасовПолучателя();
			ЗаполнитьДопКолонкиВидовЗапасов(МенеджерВременныхТаблиц);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДопКолонкиВидовЗапасов(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Т.АналитикаУчетаНоменклатуры,
	|	Т.ДокументПоступления,
	|	Т.Склад,
	|	Т.ВидЗапасов,
	|	СУММА(Т.Количество)			КАК Количество,
	|	СУММА(Т.Стоимость)			КАК Стоимость,
	|	СУММА(Т.СтоимостьБезНДС)	КАК СтоимостьБезНДС,
	|	СУММА(Т.СтоимостьРегл)		КАК СтоимостьРегл,
	|	СУММА(Т.НДСРегл)			КАК НДСРегл,
	|	СУММА(Т.ПостояннаяРазница)	КАК ПостояннаяРазница,
	|	СУММА(Т.ВременнаяРазница)	КАК ВременнаяРазница
	|ИЗ
	|	ВтПартии КАК Т
	|	
	|СГРУППИРОВАТЬ ПО
	|	Т.АналитикаУчетаНоменклатуры,
	|	Т.ДокументПоступления,
	|	Т.Склад,
	|	Т.ВидЗапасов
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Выборка = Запрос.Выполнить().Выбрать();
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры, ВидЗапасов, Склад");
	Ресурсы = Новый Структура("Количество, Стоимость, СтоимостьБезНДС, СтоимостьРегл, НДСРегл, ПостояннаяРазница, ВременнаяРазница");
	
	Пока Выборка.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(Ресурсы, Выборка);
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, Выборка);
		
		ЗаполнитьСтрокуВидовЗапасов(Выборка, СтруктураПоиска, Ресурсы);
		
	КонецЦикла;
	
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(Новый Структура("Количество", 0));
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСтрокуВидовЗапасов(СтрокаТоваров, СтруктураПоиска, Ресурсы) 
	
	Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл
		
		Если СтрокаЗапасов.Количество = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		КоличествоПоСтроке = Мин(Ресурсы.Количество, СтрокаЗапасов.Количество);
		
		НоваяСтрока = ВидыЗапасов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТоваров, "ДокументПоступления");
		
		НоваяСтрока.Количество = КоличествоПоСтроке;
		НоваяСтрока.КоличествоПоРНПТ = КоличествоПоСтроке * СтрокаЗапасов.КоличествоПоРНПТ / СтрокаЗапасов.Количество;
		
		Если КоличествоПоСтроке = Ресурсы.Количество Тогда
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Ресурсы);
		ИначеЕсли Не Ресурсы.Количество = 0 Тогда
			
			Для Каждого Ресурс Из Ресурсы Цикл
				Если Ресурс.Ключ = "Количество" Тогда
					Продолжить;
				КонецЕсли;
				
				НоваяСтрока[Ресурс.Ключ] = Ресурс.Значение * КоличествоПоСтроке / Ресурсы.Количество;
			КонецЦикла;
			
		КонецЕсли;
		
		Для Каждого Ресурс Из Ресурсы Цикл
			Ресурсы[Ресурс.Ключ] = Ресурс.Значение - НоваяСтрока[Ресурс.Ключ];
		КонецЦикла;
		
		СтрокаЗапасов.Количество		= СтрокаЗапасов.Количество - НоваяСтрока.Количество;
		СтрокаЗапасов.КоличествоПоРНПТ	= СтрокаЗапасов.КоличествоПоРНПТ - НоваяСтрока.КоличествоПоРНПТ;
		
		Если Ресурсы.Количество = 0 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПараметрыЗаполненияВидовЗапасов(МенеджерВременныхТаблиц) Экспорт
	
	Если МенеджерВременныхТаблиц.Таблицы.Найти("ВТТаблицаТоваров") = Неопределено Тогда
		ВременныеТаблицыДанныхДокумента(МенеджерВременныхТаблиц);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаТоваров.ВидЗапасов.Организация КАК ДляОрганизации,
	|	ТаблицаТоваров.ВидЗапасов КАК ВидЗапасов
	|ПОМЕСТИТЬ ДоступныеВидыЗапасов
	|ИЗ
	|	ВтТаблицаТоваров КАК ТаблицаТоваров
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВидЗапасов";
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ПараметрыЗаполнения.ДоступныеВидыЗапасовУжеСформированы = Истина;
	ПараметрыЗаполнения.ПодбиратьВТЧТоварыПринятыеНаОтветственноеХранение = "Никогда";
	ПараметрыЗаполнения.ПриНехваткеТоваровОрганизацииЗаполнятьВидамиЗапасовПоУмолчанию = Истина;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции 

#КонецОбласти

#КонецОбласти

#КонецЕсли
