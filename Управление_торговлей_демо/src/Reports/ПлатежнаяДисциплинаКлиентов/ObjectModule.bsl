#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ПериодОтчета, НачалоПериода, КонецПериода, ДанныеОтчета, ИспользуетсяОтборПоСегментуПартнеров;
	
#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ПользовательскиеНастройкиМодифицированы = Ложь;
	СтандартнаяОбработка = Ложь;
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	#Область АктуализацияВзаиморасчетов
	УстановитьПривилегированныйРежим(Истина);
	ПоляОтбора = РаспределениеВзаиморасчетовВызовСервера.ПоляОтбораПоУмолчанию();
	ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
	ИмяЗадания = РаспределениеВзаиморасчетовВызовСервера.ИмяФоновогоЗаданияРасчетовСКлиентами();
	РаспределениеВзаиморасчетовВызовСервера.ВосстановитьРасчетыПоОтборам(КомпоновщикНастроек, ПоляОтбора, ДопСвойства, ИмяЗадания);
	УстановитьПривилегированныйРежим(Ложь);
	#КонецОбласти
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
	// Подготовим и выведем отчет.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	НастройкиКомпоновкиДанных = КомпоновщикНастроек.ПолучитьНастройки();
		
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, ДанныеРасшифровки);
		
	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(СтруктураЗаголовковПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	
	ПериодОтчета = ОтчетыУТКлиентСервер.ГраницаРасчета(КомпоновщикНастроек, ПоляОтбора.Период);
	ТаблицаПлатежей = ПлатежиДляОтчета();
	
	ВнешниеНаборыДанных = Новый Структура("ТаблицаПлатежей", ТаблицаПлатежей);
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	#Область ПроверкаВзаиморасчетов
	РегистрыСведений.ЗаданияКРаспределениюРасчетовСКлиентами.ВывестиАктуальностьРасчета(ДокументРезультат, ДопСвойства);
	#КонецОбласти
	ПроцессорВывода.НачатьВывод();
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	ПроцессорВывода.ЗакончитьВывод();
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
	ОтчетПустой = ОтчетыСервер.ОтчетПустой(ЭтотОбъект, ПроцессорКомпоновки);
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", ОтчетПустой);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтруктураЗаголовковПолей()
	СтруктураЗаголовковПолей = Новый Структура;
	
	СтруктуруЗаголовковПолейЕдиницИзмерений = КомпоновкаДанныхСервер.ЗаголовкиПолейЕдиницИзмерений(КомпоновщикНастроек);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураЗаголовковПолей, СтруктуруЗаголовковПолейЕдиницИзмерений, Ложь);
	
	Возврат СтруктураЗаголовковПолей;
КонецФункции

Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	УстановитьПериодыОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
	ПараметрДанныеОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДанныеОтчета");
	ДанныеОтчета = ПараметрДанныеОтчета.Значение;
	
	ПараметрИспользуетсяОтборПоСегментуПартнеров = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ИспользуетсяОтборПоСегментуПартнеров");
	Если ПараметрИспользуетсяОтборПоСегментуПартнеров <> Неопределено Тогда
		Если ПараметрИспользуетсяОтборПоСегментуПартнеров.Использование Тогда
			ИспользуетсяОтборПоСегментуПартнеров = ПараметрИспользуетсяОтборПоСегментуПартнеров.Значение;
		Иначе
			ИспользуетсяОтборПоСегментуПартнеров = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	
КонецПроцедуры

Процедура УстановитьПериодыОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	
	НачалоПериода = Дата(1, 1, 1);
	КонецПериода = Дата(1, 1, 1);
	
	НастройкаПериод = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Период");
	Период = НастройкаПериод.Значение; // СтандартныйПериод
	
	Если ЗначениеЗаполнено(Период.ДатаНачала) Тогда
		НачалоПериода = Период.ДатаНачала;
	Иначе
		НачалоПериода = НачалоДня(ТекущаяДатаСеанса());
		Период.ДатаНачала = НачалоПериода;
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Период.ДатаОкончания) Тогда
		КонецПериода = Период.ДатаОкончания;
	Иначе
		КонецПериода = КонецДня(ТекущаяДатаСеанса());
		Период.ДатаОкончания = КонецПериода;
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция ПлатежиДляОтчета()
	
	ВременныеТаблицы = Новый МенеджерВременныхТаблиц;
	ВзаиморасчетыСервер.РассчитатьДатыПлатежаКлиента(ВременныеТаблицы, КонецПериода);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Сегменты.Партнер КАК Партнер,
	|	ИСТИНА КАК ИспользуетсяОтборПоСегментуПартнеров
	|ПОМЕСТИТЬ ОтборПоСегментуПартнеров
	|ИЗ
	|	РегистрСведений.ПартнерыСегмента КАК Сегменты
	|{ГДЕ
	|	Сегменты.Сегмент.* КАК СегментПартнеров,
	|	Сегменты.Партнер.* КАК Партнер}
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Партнер,
	|	ИспользуетсяОтборПоСегментуПартнеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Организация,
	|	КурсВалюты.Валюта КАК Валюта,
	|	ВЫБОР &ДанныеОтчета
	|		КОГДА 1
	|			ТОГДА ЕСТЬNULL(КурсВалюты.КурсЧислитель, 1) * ЕСТЬNULL(КурсВалютыУпр.КурсЗнаменатель, 1) / (ЕСТЬNULL(КурсВалюты.КурсЗнаменатель, 1) * ЕСТЬNULL(КурсВалютыУпр.КурсЧислитель, 1))
	|		ИНАЧЕ ЕСТЬNULL(КурсВалюты.КурсЧислитель, 1) / ЕСТЬNULL(КурсВалюты.КурсЗнаменатель, 1)
	|	КОНЕЦ КАК Коэффициент
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних({(&КонецПериода)}) КАК КурсВалюты
	|			ПО Организации.ВалютаРегламентированногоУчета = КурсВалюты.БазоваяВалюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних({(&КонецПериода)}, Валюта = &ВалютаУправленческогоУчета) КАК КурсВалютыУпр
	|			ПО Организации.ВалютаРегламентированногоУчета = КурсВалютыУпр.БазоваяВалюта
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Валюта
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаПлатежей.АналитикаУчетаПоПартнерам,
	|	ТаблицаПлатежей.Партнер,
	|	ТаблицаПлатежей.БизнесРегион,
	|	ТаблицаПлатежей.Организация,
	|	ТаблицаПлатежей.РасчетныйДокумент,
	|	ТаблицаПлатежей.ЗаказКлиента,
	|	ТаблицаПлатежей.Менеджер,
	|	ВЫБОР &ДанныеОтчета
	|		КОГДА 1
	|			ТОГДА &ВалютаУправленческогоУчета
	|		ИНАЧЕ ТаблицаПлатежей.Организация.ВалютаРегламентированногоУчета
	|	КОНЕЦ КАК Валюта,
	|	ТаблицаПлатежей.ДлительностьПросрочки,
	|	ТаблицаПлатежей.ДатаПлатежа,
	|	ТаблицаПлатежей.Регистратор,
	|	СУММА(ТаблицаПлатежей.СуммаПлатежа * КурсыВалютРасчетов.КурсЧислитель * КурсыВалютУчета.КурсЗнаменатель / (КурсыВалютРасчетов.КурсЗнаменатель * КурсыВалютУчета.КурсЧислитель)) КАК СуммаПлатежа,
	|	0 КАК ДолгКлиента,
	|	0 КАК ДолгКлиентаПросрочено
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаПлатежей.АналитикаУчетаПоПартнерам,
	|		ТаблицаПлатежей.Партнер КАК Партнер,
	|		ТаблицаПлатежей.БизнесРегион КАК БизнесРегион,
	|		ТаблицаПлатежей.Организация КАК Организация,
	|		ТаблицаПлатежей.РасчетныйДокумент КАК РасчетныйДокумент,
	|		ТаблицаПлатежей.ЗаказКлиента КАК ЗаказКлиента,
	|		ТаблицаПлатежей.Менеджер КАК Менеджер,
	|		ТаблицаПлатежей.Валюта КАК Валюта,
	|		ТаблицаПлатежей.ВалютаРасчета КАК ВалютаРасчета,
	|		ТаблицаПлатежей.ДлительностьПросрочки КАК ДлительностьПросрочки,
	|		ТаблицаПлатежей.ДатаПлатежа КАК ДатаПлатежа,
	|		ТаблицаПлатежей.СуммаПлатежа КАК СуммаПлатежа,
	|		ТаблицаПлатежей.Регистратор КАК Регистратор,
	|		МАКСИМУМ(КурсыВалютУчета.Период) КАК ДатаКурсаУчета,
	|		МАКСИМУМ(КурсыВалютРасчетов.Период) КАК ДатаКурсаРасчетов
	|	ИЗ
	|		(ВЫБРАТЬ
	|			АналитикаПоПартнерам.КлючАналитики КАК АналитикаУчетаПоПартнерам,
	|			АналитикаПоПартнерам.Партнер КАК Партнер,
	|			АналитикаПоПартнерам.Партнер.БизнесРегион КАК БизнесРегион,
	|			АналитикаПоПартнерам.Организация КАК Организация,
	|			ВЫБОР &ДанныеОтчета
	|				КОГДА 1
	|					ТОГДА &ВалютаУправленческогоУчета
	|				ИНАЧЕ АналитикаПоПартнерам.Организация.ВалютаРегламентированногоУчета
	|			КОНЕЦ КАК Валюта,
	|			РасчетыСКлиентамиПоДокументамОбороты.РасчетныйДокумент КАК РасчетныйДокумент,
	|			РасчетыСКлиентамиПоДокументамОбороты.ЗаказКлиента КАК ЗаказКлиента,
	|			РасчетыСКлиентамиПоДокументамОбороты.ЗаказКлиента.Менеджер КАК Менеджер,
	|			РасчетыСКлиентамиПоДокументамОбороты.Валюта КАК ВалютаРасчета,
	|			ВЫБОР
	|				КОГДА РАЗНОСТЬДАТ(ДатыПлатежейПоДокументам.ДатаПлатежа, РасчетыСКлиентамиПоДокументамОбороты.ПериодДень, ДЕНЬ) < 0
	|					ТОГДА 0
	|				ИНАЧЕ РАЗНОСТЬДАТ(ДатыПлатежейПоДокументам.ДатаПлатежа, РасчетыСКлиентамиПоДокументамОбороты.ПериодДень, ДЕНЬ)
	|			КОНЕЦ КАК ДлительностьПросрочки,
	|			ДатыПлатежейПоДокументам.ДатаПлатежа КАК ДатаПлатежа,
	|			ДатыПлатежейПоДокументам.Долг КАК СуммаПлатежа,
	|			РасчетыСКлиентамиПоДокументамОбороты.Регистратор КАК Регистратор
	|		ИЗ
	|			РегистрНакопления.РасчетыСКлиентамиПоДокументам.Обороты(, , Авто, {(АналитикаУчетаПоПартнерам.Партнер В
	|					(ВЫБРАТЬ
	|						ОтборПоСегментуПартнеров.Партнер
	|					ИЗ
	|						ОтборПоСегментуПартнеров
	|					ГДЕ
	|						ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|				) КАК РасчетыСКлиентамиПоДокументамОбороты
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаПоПартнерам
	|				ПО РасчетыСКлиентамиПоДокументамОбороты.АналитикаУчетаПоПартнерам = АналитикаПоПартнерам.КлючАналитики
	|
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКлиентамиПоДокументам КАК ДатыПлатежейПоДокументам
	|				ПО РасчетыСКлиентамиПоДокументамОбороты.АналитикаУчетаПоПартнерам = ДатыПлатежейПоДокументам.АналитикаУчетаПоПартнерам
	|					И РасчетыСКлиентамиПоДокументамОбороты.ЗаказКлиента = ДатыПлатежейПоДокументам.ЗаказКлиента
	|					И РасчетыСКлиентамиПоДокументамОбороты.РасчетныйДокумент = ДатыПлатежейПоДокументам.РасчетныйДокумент
	|					И РасчетыСКлиентамиПоДокументамОбороты.Валюта = ДатыПлатежейПоДокументам.Валюта
	|					И РасчетыСКлиентамиПоДокументамОбороты.Регистратор = ДатыПлатежейПоДокументам.Регистратор
	|		ГДЕ
	|			АналитикаПоПартнерам.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|			И (РасчетыСКлиентамиПоДокументамОбороты.Регистратор ССЫЛКА Документ.ПоступлениеБезналичныхДенежныхСредств
	|					ИЛИ РасчетыСКлиентамиПоДокументамОбороты.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	|					ИЛИ РасчетыСКлиентамиПоДокументамОбороты.Регистратор ССЫЛКА Документ.ОперацияПоПлатежнойКарте)
	|			И НЕ РасчетыСКлиентамиПоДокументамОбороты.РасчетныйДокумент ССЫЛКА Документ.КорректировкаЗадолженности
	|			И ДатыПлатежейПоДокументам.ДатаПлатежа <> ДАТАВРЕМЯ(1, 1, 1)
	|			И ДатыПлатежейПоДокументам.Долг > 0
	|			И ДатыПлатежейПоДокументам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|			И РасчетыСКлиентамиПоДокументамОбороты.Валюта <>
	|				ВЫБОР &ДанныеОтчета
	|					КОГДА 1
	|						ТОГДА &ВалютаУправленческогоУчета
	|					ИНАЧЕ АналитикаПоПартнерам.Организация.ВалютаРегламентированногоУчета
	|				КОНЕЦ
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			АналитикаПоПартнерам.КлючАналитики КАК АналитикаУчетаПоПартнерам,
	|			АналитикаПоПартнерам.Партнер,
	|			АналитикаПоПартнерам.Партнер.БизнесРегион,
	|			АналитикаПоПартнерам.Организация,
	|			ВЫБОР &ДанныеОтчета
	|				КОГДА 1
	|					ТОГДА &ВалютаУправленческогоУчета
	|				ИНАЧЕ АналитикаПоПартнерам.Организация.ВалютаРегламентированногоУчета
	|			КОНЕЦ,
	|			РасчетыСКлиентамиПоДокументамОстатки.РасчетныйДокумент,
	|			РасчетыСКлиентамиПоДокументамОстатки.ЗаказКлиента,
	|			РасчетыСКлиентамиПоДокументамОстатки.ЗаказКлиента.Менеджер,
	|			РасчетыСКлиентамиПоДокументамОстатки.Валюта,
	|			РАЗНОСТЬДАТ(Остатки.ДатаПлатежа, &КонецПериода, ДЕНЬ),
	|			&КонецПериода,
	|			РасчетыСКлиентамиПоДокументамОстатки.ДолгОстаток,
	|			NULL
	|		ИЗ
	|			РегистрНакопления.РасчетыСКлиентамиПоДокументам.Остатки(&КонецПериода, {(АналитикаУчетаПоПартнерам.Партнер В
	|					(ВЫБРАТЬ
	|						ОтборПоСегментуПартнеров.Партнер
	|					ИЗ
	|						ОтборПоСегментуПартнеров
	|					ГДЕ
	|						ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|			) КАК РасчетыСКлиентамиПоДокументамОстатки
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаПоПартнерам
	|				ПО РасчетыСКлиентамиПоДокументамОстатки.АналитикаУчетаПоПартнерам = АналитикаПоПартнерам.КлючАналитики
	|
	|				ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОстатковКлиентов КАК Остатки
	|				ПО РасчетыСКлиентамиПоДокументамОстатки.АналитикаУчетаПоПартнерам = Остатки.АналитикаУчетаПоПартнерам
	|					И РасчетыСКлиентамиПоДокументамОстатки.ЗаказКлиента = Остатки.ЗаказКлиента
	|					И РасчетыСКлиентамиПоДокументамОстатки.РасчетныйДокумент = Остатки.РасчетныйДокумент
	|					И РасчетыСКлиентамиПоДокументамОстатки.Валюта = Остатки.Валюта
	|					И Остатки.ДатаПлатежа < ДОБАВИТЬКДАТЕ(&КонецПериода, ДЕНЬ, -1)
	|					И Остатки.ДатаПлатежа >= &НачалоПериода
	|		ГДЕ
	|			АналитикаПоПартнерам.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|			И НЕ РасчетыСКлиентамиПоДокументамОстатки.РасчетныйДокумент ССЫЛКА Документ.КорректировкаЗадолженности
	|			И (Остатки.ДатаПлатежа <> ДАТАВРЕМЯ(1, 1, 1) ИЛИ Остатки.ЗаказКлиента ЕСТЬ NULL)
	|			И РасчетыСКлиентамиПоДокументамОстатки.ДолгОстаток > 0
	|			И РасчетыСКлиентамиПоДокументамОстатки.Валюта <>
	|				ВЫБОР &ДанныеОтчета
	|					КОГДА 1
	|						ТОГДА &ВалютаУправленческогоУчета
	|					ИНАЧЕ АналитикаПоПартнерам.Организация.ВалютаРегламентированногоУчета
	|				КОНЕЦ
	|		) КАК ТаблицаПлатежей
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют КАК КурсыВалютРасчетов
	|			ПО ТаблицаПлатежей.ДатаПлатежа >= КурсыВалютРасчетов.Период
	|				И ТаблицаПлатежей.ВалютаРасчета = КурсыВалютРасчетов.Валюта
	|				И ТаблицаПлатежей.Организация.ВалютаРегламентированногоУчета = КурсыВалютРасчетов.БазоваяВалюта
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют КАК КурсыВалютУчета
	|			ПО ТаблицаПлатежей.ДатаПлатежа >= КурсыВалютУчета.Период
	|				И ТаблицаПлатежей.Валюта = КурсыВалютРасчетов.Валюта
	|				И ТаблицаПлатежей.Организация.ВалютаРегламентированногоУчета = КурсыВалютУчета.БазоваяВалюта
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТаблицаПлатежей.АналитикаУчетаПоПартнерам,
	|		ТаблицаПлатежей.Партнер,
	|		ТаблицаПлатежей.БизнесРегион,
	|		ТаблицаПлатежей.Организация,
	|		ТаблицаПлатежей.РасчетныйДокумент,
	|		ТаблицаПлатежей.ЗаказКлиента,
	|		ТаблицаПлатежей.Менеджер,
	|		ТаблицаПлатежей.Валюта,
	|		ТаблицаПлатежей.ВалютаРасчета,
	|		ТаблицаПлатежей.ДлительностьПросрочки,
	|		ТаблицаПлатежей.ДатаПлатежа,
	|		ТаблицаПлатежей.СуммаПлатежа,
	|		ТаблицаПлатежей.Регистратор) КАК ТаблицаПлатежей
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют КАК КурсыВалютРасчетов
	|		ПО ТаблицаПлатежей.ДатаКурсаРасчетов = КурсыВалютРасчетов.Период
	|			И ТаблицаПлатежей.ВалютаРасчета = КурсыВалютРасчетов.Валюта
	|			И ТаблицаПлатежей.Организация.ВалютаРегламентированногоУчета = КурсыВалютРасчетов.БазоваяВалюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют КАК КурсыВалютУчета
	|		ПО ТаблицаПлатежей.ДатаКурсаУчета = КурсыВалютУчета.Период
	|			И ТаблицаПлатежей.Валюта = КурсыВалютРасчетов.Валюта
	|			И ТаблицаПлатежей.Организация.ВалютаРегламентированногоУчета = КурсыВалютУчета.БазоваяВалюта
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаПлатежей.АналитикаУчетаПоПартнерам,
	|	ТаблицаПлатежей.Партнер,
	|	ТаблицаПлатежей.БизнесРегион,
	|	ТаблицаПлатежей.Организация,
	|	ТаблицаПлатежей.РасчетныйДокумент,
	|	ТаблицаПлатежей.ЗаказКлиента,
	|	ТаблицаПлатежей.Менеджер,
	|	ТаблицаПлатежей.Валюта,
	|	ТаблицаПлатежей.ДлительностьПросрочки,
	|	ТаблицаПлатежей.ДатаПлатежа,
	|	ТаблицаПлатежей.Регистратор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АналитикаПоПартнерам.КлючАналитики КАК АналитикаУчетаПоПартнерам,
	|	АналитикаПоПартнерам.Партнер,
	|	АналитикаПоПартнерам.Партнер.БизнесРегион,
	|	АналитикаПоПартнерам.Организация,
	|	РасчетыСКлиентамиПоДокументамОбороты.РасчетныйДокумент,
	|	РасчетыСКлиентамиПоДокументамОбороты.ЗаказКлиента,
	|	РасчетыСКлиентамиПоДокументамОбороты.ЗаказКлиента.Менеджер,
	|	РасчетыСКлиентамиПоДокументамОбороты.Валюта,
	|	ВЫБОР
	|		КОГДА РАЗНОСТЬДАТ(ДатыПлатежейПоДокументам.ДатаПлатежа, РасчетыСКлиентамиПоДокументамОбороты.ПериодДень, ДЕНЬ) < 0
	|			ТОГДА 0
	|		ИНАЧЕ РАЗНОСТЬДАТ(ДатыПлатежейПоДокументам.ДатаПлатежа, РасчетыСКлиентамиПоДокументамОбороты.ПериодДень, ДЕНЬ)
	|	КОНЕЦ,
	|	ДатыПлатежейПоДокументам.ДатаПлатежа,
	|	РасчетыСКлиентамиПоДокументамОбороты.Регистратор,
	|	ДатыПлатежейПоДокументам.Долг,
	|	0 КАК ДолгКлиента,
	|	0 КАК ДолгКлиентаПросрочено
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоДокументам.Обороты(, , Авто, {(АналитикаУчетаПоПартнерам.Партнер В
	|			(ВЫБРАТЬ
	|				ОтборПоСегментуПартнеров.Партнер
	|			ИЗ
	|				ОтборПоСегментуПартнеров
	|			ГДЕ
	|				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|	) КАК РасчетыСКлиентамиПоДокументамОбороты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаПоПартнерам
	|		ПО РасчетыСКлиентамиПоДокументамОбороты.АналитикаУчетаПоПартнерам = АналитикаПоПартнерам.КлючАналитики
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКлиентамиПоДокументам КАК ДатыПлатежейПоДокументам
	|		ПО РасчетыСКлиентамиПоДокументамОбороты.АналитикаУчетаПоПартнерам = ДатыПлатежейПоДокументам.АналитикаУчетаПоПартнерам
	|			И РасчетыСКлиентамиПоДокументамОбороты.ЗаказКлиента = ДатыПлатежейПоДокументам.ЗаказКлиента
	|			И РасчетыСКлиентамиПоДокументамОбороты.РасчетныйДокумент = ДатыПлатежейПоДокументам.РасчетныйДокумент
	|			И РасчетыСКлиентамиПоДокументамОбороты.Валюта = ДатыПлатежейПоДокументам.Валюта
	|			И РасчетыСКлиентамиПоДокументамОбороты.Регистратор = ДатыПлатежейПоДокументам.Регистратор
	|ГДЕ
	|	АналитикаПоПартнерам.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	И (РасчетыСКлиентамиПоДокументамОбороты.Регистратор ССЫЛКА Документ.ПоступлениеБезналичныхДенежныхСредств
	|			ИЛИ РасчетыСКлиентамиПоДокументамОбороты.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	|			ИЛИ РасчетыСКлиентамиПоДокументамОбороты.Регистратор ССЫЛКА Документ.ОперацияПоПлатежнойКарте)
	|	И НЕ РасчетыСКлиентамиПоДокументамОбороты.РасчетныйДокумент ССЫЛКА Документ.КорректировкаЗадолженности
	|	И ДатыПлатежейПоДокументам.ДатаПлатежа <> ДАТАВРЕМЯ(1, 1, 1)
	|	И ДатыПлатежейПоДокументам.Долг > 0
	|	И ДатыПлатежейПоДокументам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	И РасчетыСКлиентамиПоДокументамОбороты.Валюта = 
	|			ВЫБОР &ДанныеОтчета
	|				КОГДА 1
	|					ТОГДА &ВалютаУправленческогоУчета
	|				ИНАЧЕ АналитикаПоПартнерам.Организация.ВалютаРегламентированногоУчета
	|			КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АналитикаПоПартнерам.КлючАналитики КАК АналитикаУчетаПоПартнерам,
	|	АналитикаПоПартнерам.Партнер,
	|	АналитикаПоПартнерам.Партнер.БизнесРегион,
	|	АналитикаПоПартнерам.Организация,
	|	РасчетыСКлиентамиПоДокументамОстатки.РасчетныйДокумент,
	|	РасчетыСКлиентамиПоДокументамОстатки.ЗаказКлиента,
	|	РасчетыСКлиентамиПоДокументамОстатки.ЗаказКлиента.Менеджер,
	|	РасчетыСКлиентамиПоДокументамОстатки.Валюта,
	|	РАЗНОСТЬДАТ(Остатки.ДатаПлатежа, &КонецПериода, ДЕНЬ),
	|	&КонецПериода,
	|	NULL,
	|	РасчетыСКлиентамиПоДокументамОстатки.ДолгОстаток,
	|	0 КАК ДолгКлиента,
	|	0 КАК ДолгКлиентаПросрочено
	|
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоДокументам.Остатки(&КонецПериода, {(АналитикаУчетаПоПартнерам.Партнер В
	|			(ВЫБРАТЬ
	|				ОтборПоСегментуПартнеров.Партнер
	|			ИЗ
	|				ОтборПоСегментуПартнеров
	|			ГДЕ
	|				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|	) КАК РасчетыСКлиентамиПоДокументамОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаПоПартнерам
	|		ПО РасчетыСКлиентамиПоДокументамОстатки.АналитикаУчетаПоПартнерам = АналитикаПоПартнерам.КлючАналитики
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОстатковКлиентов КАК Остатки
	|		ПО РасчетыСКлиентамиПоДокументамОстатки.АналитикаУчетаПоПартнерам = Остатки.АналитикаУчетаПоПартнерам
	|			И РасчетыСКлиентамиПоДокументамОстатки.ЗаказКлиента = Остатки.ЗаказКлиента
	|			И РасчетыСКлиентамиПоДокументамОстатки.РасчетныйДокумент = Остатки.РасчетныйДокумент
	|			И РасчетыСКлиентамиПоДокументамОстатки.Валюта = Остатки.Валюта
	|			И Остатки.ДатаПлатежа < ДОБАВИТЬКДАТЕ(&КонецПериода, ДЕНЬ, -1)
	|			И Остатки.ДатаПлатежа >= &НачалоПериода
	|ГДЕ
	|	АналитикаПоПартнерам.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	И НЕ РасчетыСКлиентамиПоДокументамОстатки.РасчетныйДокумент ССЫЛКА Документ.КорректировкаЗадолженности
	|	И РасчетыСКлиентамиПоДокументамОстатки.ДолгОстаток > 0
	|	И РасчетыСКлиентамиПоДокументамОстатки.Валюта = 
	|			ВЫБОР &ДанныеОтчета
	|				КОГДА 1
	|					ТОГДА &ВалютаУправленческогоУчета
	|				ИНАЧЕ АналитикаПоПартнерам.Организация.ВалютаРегламентированногоУчета
	|			КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АналитикаПоПартнерам.КлючАналитики КАК АналитикаУчетаПоПартнерам,
	|	АналитикаПоПартнерам.Партнер КАК Партнер,
	|	АналитикаПоПартнерам.Партнер.БизнесРегион КАК БизнесРегион,
	|	АналитикаПоПартнерам.Организация КАК Организация,
	|	РасчетыСКлиентамиПоДокументам.РасчетныйДокумент КАК РасчетныйДокумент,
	|	РасчетыСКлиентамиПоДокументам.ЗаказКлиента КАК ЗаказКлиента,
	|	РасчетыСКлиентамиПоДокументам.ЗаказКлиента.Менеджер КАК Менеджер,
	|	ВЫБОР &ДанныеОтчета
	|		КОГДА 1
	|			ТОГДА &ВалютаУправленческогоУчета
	|		ИНАЧЕ АналитикаПоПартнерам.Организация.ВалютаРегламентированногоУчета
	|	КОНЕЦ КАК Валюта,
	|	0,
	|	ЕСТЬNULL(Остатки.ДатаПлатежа, &КонецПериода) КАК ДатаПлатежа,
	|	NULL,
	|	0 КАК СуммаПлатежа,
	|	СУММА(Остатки.ДолгОстаток * КурсВалюты.Коэффициент) КАК ДолгКлиента,
	|	СУММА(ВЫБОР
	|			КОГДА ЕСТЬNULL(Остатки.ДатаПлатежа, ДАТАВРЕМЯ(1, 1, 1)) = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА 0
	|			ИНАЧЕ ВЫБОР
	|					КОГДА РАЗНОСТЬДАТ(ЕСТЬNULL(Остатки.ДатаПлатежа, &КонецПериода), &КонецПериода, ДЕНЬ) > 0
	|						ТОГДА Остатки.ДолгОстаток * КурсВалюты.Коэффициент
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|		КОНЕЦ) КАК ДолгКлиентаПросрочено
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоДокументам.Остатки(&КонецПериода, {(АналитикаУчетаПоПартнерам.Партнер В
	|			(ВЫБРАТЬ
	|				ОтборПоСегментуПартнеров.Партнер
	|			ИЗ
	|				ОтборПоСегментуПартнеров
	|			ГДЕ
	|				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|	) КАК РасчетыСКлиентамиПоДокументам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаПоПартнерам
	|		ПО РасчетыСКлиентамиПоДокументам.АналитикаУчетаПоПартнерам = АналитикаПоПартнерам.КлючАналитики
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсВалюты
	|		ПО РасчетыСКлиентамиПоДокументам.Валюта = КурсВалюты.Валюта
	|			И (КурсВалюты.Организация = АналитикаПоПартнерам.Организация)
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОстатковКлиентов КАК Остатки
	|		ПО РасчетыСКлиентамиПоДокументам.АналитикаУчетаПоПартнерам = Остатки.АналитикаУчетаПоПартнерам
	|			И РасчетыСКлиентамиПоДокументам.ЗаказКлиента = Остатки.ЗаказКлиента
	|			И РасчетыСКлиентамиПоДокументам.РасчетныйДокумент = Остатки.РасчетныйДокумент
	|			И РасчетыСКлиентамиПоДокументам.Валюта = Остатки.Валюта
	|ГДЕ
	|	АналитикаПоПартнерам.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|
	|СГРУППИРОВАТЬ ПО
	|	АналитикаПоПартнерам.КлючАналитики,
	|	АналитикаПоПартнерам.Партнер,
	|	АналитикаПоПартнерам.Партнер.БизнесРегион,
	|	АналитикаПоПартнерам.Организация,
	|	РасчетыСКлиентамиПоДокументам.РасчетныйДокумент,
	|	РасчетыСКлиентамиПоДокументам.Валюта,
	|	РасчетыСКлиентамиПоДокументам.ЗаказКлиента,
	|	РасчетыСКлиентамиПоДокументам.ЗаказКлиента.Менеджер,
	|	ЕСТЬNULL(Остатки.ДатаПлатежа, &КонецПериода)
	|");
	
	
	Запрос.МенеджерВременныхТаблиц = ВременныеТаблицы;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("ДанныеОтчета", ДанныеОтчета);
	Запрос.УстановитьПараметр("ИспользуетсяОтборПоСегментуПартнеров", ИспользуетсяОтборПоСегментуПартнеров);
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета", Константы.ВалютаУправленческогоУчета.Получить());
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли