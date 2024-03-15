#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		
		БлокироватьДляИзменения = Истина;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.СвойстваДокумента.ЭтоНовый);
		Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Таблица.ЗаявкаНаРасходованиеДенежныхСредств КАК ЗаявкаНаРасходованиеДенежныхСредств,
		|	Таблица.БанковскийСчетКасса                 КАК БанковскийСчетКасса,
		|	Таблица.Получатель                          КАК Получатель,
		|	Таблица.Организация                         КАК Организация,
		|	ВЫБОР
		|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА Таблица.Сумма
		|		ИНАЧЕ -Таблица.Сумма
		|	КОНЕЦ                                       КАК СуммаПередЗаписью
		|ПОМЕСТИТЬ ДвиженияДенежныеСредстваКВыплатеПередЗаписью
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваКВыплате КАК Таблица
		|ГДЕ
		|	Таблица.Регистратор = &Регистратор
		|	И НЕ &ЭтоНовый
		|";
		
		Запрос.Выполнить();
	КонецЕсли;
	
	СФормироватьТаблицуОбъектовОплаты();
	РегистрыСведений.ГрафикПлатежей.УстановитьБлокировкиДанныхДляРасчетаГрафика(
		ДополнительныеСвойства.ТаблицаОбъектовОплаты, "РегистрНакопления.ДенежныеСредстваКВыплате", "ЗаявкаНаРасходованиеДенежныхСредств");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		
		// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
		// и помещается во временную таблицу "ДвиженияДенежныеСредстваКВыплатеИзменение".
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаИзменений.ЗаявкаНаРасходованиеДенежныхСредств КАК ЗаявкаНаРасходованиеДенежныхСредств,
		|	ТаблицаИзменений.БанковскийСчетКасса                 КАК БанковскийСчетКасса,
		|	ТаблицаИзменений.Получатель                          КАК Получатель,
		|	ТаблицаИзменений.Организация                         КАК Организация,
		|	СУММА(ТаблицаИзменений.СуммаИзменение)               КАК СуммаИзменение
		|
		|ПОМЕСТИТЬ ДвиженияДенежныеСредстваКВыплатеИзменение
		|ИЗ
		|	(ВЫБРАТЬ
		|		Таблица.ЗаявкаНаРасходованиеДенежныхСредств КАК ЗаявкаНаРасходованиеДенежныхСредств,
		|		Таблица.БанковскийСчетКасса                 КАК БанковскийСчетКасса,
		|		Таблица.Получатель                          КАК Получатель,
		|		Таблица.Организация                         КАК Организация,
		|		Таблица.СуммаПередЗаписью                   КАК СуммаИзменение
		|	ИЗ
		|		ДвиженияДенежныеСредстваКВыплатеПередЗаписью КАК Таблица
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		Таблица.ЗаявкаНаРасходованиеДенежныхСредств КАК ЗаявкаНаРасходованиеДенежныхСредств,
		|		Таблица.БанковскийСчетКасса                 КАК БанковскийСчетКасса,
		|		Таблица.Получатель                          КАК Получатель,
		|		Таблица.Организация                         КАК Организация,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА -Таблица.Сумма
		|			ИНАЧЕ Таблица.Сумма
		|		КОНЕЦ                                       КАК СуммаИзменение
		|	ИЗ
		|		РегистрНакопления.ДенежныеСредстваКВыплате КАК Таблица
		|	ГДЕ
		|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаИзменений.ЗаявкаНаРасходованиеДенежныхСредств,
		|	ТаблицаИзменений.БанковскийСчетКасса,
		|	ТаблицаИзменений.Получатель,
		|	ТаблицаИзменений.Организация
		|
		|ИМЕЮЩИЕ
		|	СУММА(ТаблицаИзменений.СуммаИзменение) <> 0
		|;
		|УНИЧТОЖИТЬ ДвиженияДенежныеСредстваКВыплатеПередЗаписью
		|";
		
		Результат = Запрос.ВыполнитьПакет();
		
		Выборка = Результат[0].Выбрать();
		ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(ДополнительныеСвойства,
			"ДвиженияДенежныеСредстваКВыплатеИзменение", Выборка.Следующий() И Выборка.Количество > 0);
		
	КонецЕсли;
	
	РегистрыСведений.ГрафикПлатежей.РассчитатьГрафикПлатежейПоДенежнымСредствамКВыплате(
		ДополнительныеСвойства.ТаблицаОбъектовОплаты.ВыгрузитьКолонку("ОбъектОплаты"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует таблицу заявок, которые были раньше в движениях и которые сейчас будут записаны.
//
Процедура СФормироватьТаблицуОбъектовОплаты()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.ЗаявкаНаРасходованиеДенежныхСредств КАК ОбъектОплаты
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваКВыплате КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|";
	
	ТаблицаОбъектовОплаты = Запрос.Выполнить().Выгрузить();
	
	ТаблицаНовыхОбъектовОплаты = Выгрузить(, "ЗаявкаНаРасходованиеДенежныхСредств");
	ТаблицаНовыхОбъектовОплаты.Свернуть("ЗаявкаНаРасходованиеДенежныхСредств");
	Для каждого Запись Из ТаблицаНовыхОбъектовОплаты Цикл
		Если ТаблицаОбъектовОплаты.Найти(Запись.ЗаявкаНаРасходованиеДенежныхСредств, "ОбъектОплаты") = Неопределено Тогда
			ТаблицаОбъектовОплаты.Добавить().ОбъектОплаты = Запись.ЗаявкаНаРасходованиеДенежныхСредств;
		КонецЕсли;
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("ТаблицаОбъектовОплаты", ТаблицаОбъектовОплаты);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли