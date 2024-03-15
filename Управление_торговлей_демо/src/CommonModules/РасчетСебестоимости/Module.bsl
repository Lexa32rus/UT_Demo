/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Механизм партионного учета версии 2.2
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Запуск расчета партий.
//
// Параметры:
//	ПараметрыЗапуска - Структура  - Содержит ключи:
//		Дата - Дата - период расчета
//		МассивОрганизаций - СправочникСсылка.Организации - рассчитывать только по указанной организации;
//			также будут пересчитаны партии по организациям, связанным по схеме Интеркампани с указанной
//					- Массив - массив организаций, по которым надо рассчитать партии, другие организации не рассчитываются
//		СхемаРасчета - ТаблицаЗначений - (см. РасчетСебестоимостиПрикладныеАлгоритмы.СхемаРасчетаПартий)
//			уже построенная схема расчета может быть получена из модуля ПартионныйУчет
//		МестоВызоваРасчета - Строка - откуда вызван расчет, для протокола
//		ВыполняетсяЗакрытиеМесяца - Булево - признак вызова расчета из механизма закрытия месяца
//	ПараметрыРасчета - Структура - параметры расчета, сформированные в вызывающем механизме.
//	ПараметрыОтладки - Структура - предназначена для переопределения одноименных свойств структуры ПараметрыРасчета.
//		Подробнее см. пояснения в коде РасчетСебестоимостиПрикладныеАлгоритмы.ИнициализироватьПараметрыРасчетаПартий() к параметру ПараметрыОтладки.
//
Процедура РассчитатьВсе(ПараметрыЗапуска, ПараметрыРасчета = Неопределено, ПараметрыОтладки = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВыполняетсяЗакрытиеМесяца = ПараметрыЗапуска.Свойство("ВыполняетсяЗакрытиеМесяца");
	ИдентификаторРасчета = Новый УникальныйИдентификатор;
	
	Если ПараметрыЗапуска.Свойство("АвтоматическоеТестирование") И ПараметрыЗапуска.АвтоматическоеТестирование Тогда
		АвтоматическоеТестирование = Истина; // вызывается при тестировании
	Иначе
		АвтоматическоеТестирование = Ложь;
	КонецЕсли;
	
	Если РасчетСебестоимостиЛокализация.РассчитатьВсе(ПараметрыЗапуска.Дата, ПараметрыЗапуска.МассивОрганизаций, ВыполняетсяЗакрытиеМесяца, АвтоматическоеТестирование) Тогда
		Возврат;
	КонецЕсли;
	
	// Инициализируем параметры отладки.
	РасчетСебестоимостиПрикладныеАлгоритмы.ИнициализироватьПараметрыОтладки(ПараметрыОтладки, ПараметрыЗапуска);
	
	// Проверим, закончено ли обновление ИБ
	РасчетСебестоимостиПрикладныеАлгоритмы.ПроверитьБлокировкуДанныхПриОбновленииИБ(Ложь, Истина, ПараметрыОтладки);
	
	#Область СхемаРасчета

	// Определим по каким периодам и организациям требуется перерасчет
	Если ПараметрыЗапуска.Свойство("СхемаРасчета") Тогда
		
		СхемаРасчета = ПараметрыЗапуска.СхемаРасчета;
		
		Если ПараметрыЗапуска.Свойство("ВременныеТаблицы") Тогда
			ВременныеТаблицы = ПараметрыЗапуска.ВременныеТаблицы;
		Иначе
			ВременныеТаблицы = РасчетСебестоимостиПрикладныеАлгоритмы.СформироватьВТЗаданияДоРасчета(-1, Неопределено);
		КонецЕсли;
		
		НомерЗаданияДоРасчета = РегистрыСведений.ЗаданияКРасчетуСебестоимости.ПолучитьНомерЗадания();
		
	Иначе
		
		НомерЗаданияДоРасчета = РасчетСебестоимостиПрикладныеАлгоритмы.УвеличитьНомерЗаданияКРасчетуСебестоимости();
		
		НачатьТранзакцию();
		
		Попытка
			
			ТолькоОднаОрганизация = ?(ПараметрыЗапуска.Свойство("ТолькоОднаОрганизация"), ПараметрыЗапуска.ТолькоОднаОрганизация, Ложь);
			
			// Определим по каким периодам и организациям требуется перерасчет.
			СхемаРасчета = РасчетСебестоимостиПрикладныеАлгоритмы.СхемаРасчетаПартий(
				ПараметрыЗапуска.Дата,
				ПараметрыЗапуска.МассивОрганизаций,
				НомерЗаданияДоРасчета,
				ТолькоОднаОрганизация);
				
			Если СхемаРасчета.Количество() > 0 Тогда
				ВременныеТаблицы = РасчетСебестоимостиПрикладныеАлгоритмы.СформироватьВТЗаданияДоРасчета(
					НомерЗаданияДоРасчета,
					СхемаРасчета[СхемаРасчета.Количество() - 1].Организации);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ВызватьИсключение ТекстОшибки;
		КонецПопытки;
		
	КонецЕсли;
	
	ВыполняетсяЗакрытиеМесяца = ПараметрыЗапуска.Свойство("ВыполняетсяЗакрытиеМесяца");
	
	ДатаПереходаНаПартионныйУчетВерсии22 = РасчетСебестоимостиПовтИсп.ДатаПереходаНаПартионныйУчетВерсии22();
	
	Если СхемаРасчета.Количество() > 0 И НачалоМесяца(СхемаРасчета[0].Дата) < ДатаПереходаНаПартионныйУчетВерсии22 Тогда
		
		// Некоторые периоды надо рассчитать в версии 2.1
		Для Каждого СтрокаСхемыРасчета Из СхемаРасчета Цикл
			Если КонецМесяца(СтрокаСхемыРасчета.Дата) + 1 = ДатаПереходаНаПартионныйУчетВерсии22 // последний месяц до перехода на ПУ 2.2
			 ИЛИ СтрокаСхемыРасчета = СхемаРасчета[СхемаРасчета.Количество() - 1] Тогда // последняя строка схемы расчета
				Прервать; // нашли строку схемы, по которую надо рассчитать партии в версии 2.1
			КонецЕсли;
		КонецЦикла;
		
		РасчетСебестоимостиЛокализация.РассчитатьВсе(СтрокаСхемыРасчета.Дата, СтрокаСхемыРасчета.Организации, ВыполняетсяЗакрытиеМесяца, АвтоматическоеТестирование);
		
		НомерЗаданияДоРасчета = РасчетСебестоимостиПрикладныеАлгоритмы.УвеличитьНомерЗаданияКРасчетуСебестоимости();
	
		НачатьТранзакцию();
		
		Попытка
			
			ТолькоОднаОрганизация = ?(ПараметрыЗапуска.Свойство("ТолькоОднаОрганизация"), ПараметрыЗапуска.ТолькоОднаОрганизация, Ложь);
			
			// Обновим схему расчета
			СхемаРасчета = РасчетСебестоимостиПрикладныеАлгоритмы.СхемаРасчетаПартий(
				ПараметрыЗапуска.Дата,
				ПараметрыЗапуска.МассивОрганизаций,
				НомерЗаданияДоРасчета,
				ТолькоОднаОрганизация);
			
			Если СхемаРасчета.Количество() > 0 Тогда
				ВременныеТаблицы = РасчетСебестоимостиПрикладныеАлгоритмы.СформироватьВТЗаданияДоРасчета(
					НомерЗаданияДоРасчета,
					СхемаРасчета[СхемаРасчета.Количество() - 1].Организации);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ВызватьИсключение ТекстОшибки;
		КонецПопытки;
		
	КонецЕсли;
	
	Если СхемаРасчета.Количество() = 0 Тогда
		// Расчет не требуется
		Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'За период ""%1"" по ""%2"" расчет партий версии 2.2 не требуется.'", ОбщегоНазначения.КодОсновногоЯзыка()),
			РасчетСебестоимостиПротоколРасчета.ПредставлениеПериодаРасчета(ПараметрыЗапуска.Дата),
			РасчетСебестоимостиПрикладныеАлгоритмы.ПредставлениеОрганизаций(ПараметрыЗапуска.МассивОрганизаций, ", ", Истина));
		ЗаписьЖурналаРегистрации(
			РасчетСебестоимостиПрикладныеАлгоритмы.ИмяСобытияЖурналаРегистрации(
				Новый Структура("ЗапущенРасчетПартий", Истина),
				НСтр("ru = 'Расчет не требуется'", ОбщегоНазначения.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Информация,,,
			Комментарий);
		Возврат;
	ИначеЕсли НачалоМесяца(СхемаРасчета[0].Дата) < ДатаПереходаНаПартионныйУчетВерсии22 Тогда
		// Расчет невозможен - по каким-то причинам не выполнен пересчет периодов в версии 2.1.
		Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'За период ""%1"" по ""%2"" расчет партий версии 2.2 невозможен - расчет партий версии 2.1 за предыдущие периоды выполнен с ошибками.'", ОбщегоНазначения.КодОсновногоЯзыка()),
			РасчетСебестоимостиПротоколРасчета.ПредставлениеПериодаРасчета(ПараметрыЗапуска.Дата),
			РасчетСебестоимостиПрикладныеАлгоритмы.ПредставлениеОрганизаций(ПараметрыЗапуска.МассивОрганизаций, ", ", Истина));
		ЗаписьЖурналаРегистрации(
			РасчетСебестоимостиПрикладныеАлгоритмы.ИмяСобытияЖурналаРегистрации(
				Новый Структура("ЗапущенРасчетПартий", Истина),
				НСтр("ru = 'Расчет невозможен'", ОбщегоНазначения.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Ошибка,,,
			Комментарий);
		Возврат;
	КонецЕсли;
	
	#КонецОбласти
	
	// Запомним состояние активности текущих итогов у обслуживаемых регистров
	СостояниеИтоговРегистров = РасчетСебестоимостиПрикладныеАлгоритмы.СостояниеИтоговРегистров();
	
	Для Каждого СтрокаСхемыРасчета Из СхемаРасчета Цикл
		
		Если РасчетСебестоимостиПовтИсп.ЗначенияТехнологическихПараметров().ОтключитьРасчетСебестоимостиВПрошлыхПериодах 
		 И НачалоМесяца(СтрокаСхемыРасчета.Дата) < НачалоМесяца(ПараметрыЗапуска.Дата) Тогда
			// Пропускаем периоды расчета, предшествующие текущему.
			Продолжить;
		КонецЕсли;
		
		Если НЕ ВыполняетсяЗакрытиеМесяца Тогда
			// Выполним операции механизма закрытия месяца, вызываемые до расчета этапа, если расчет вызван не в рамках закрытия месяца.
			// При закрытии месяца эти действия выполнит сам механизм закрытия месяца.
			Если НЕ РасчетСебестоимостиПрикладныеАлгоритмы.ВыполнитьОперацииЗакрытияМесяцаДляПодготовкиКРасчетуЭтапа(СтрокаСхемыРасчета, ИдентификаторРасчета) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		// Инициализируем параметры расчета
		ПараметрыЗапускаРасчетаПериода = ИнициализироватьПараметрыЗапускаРасчетаПериода(СтрокаСхемыРасчета,
			ПараметрыЗапуска.НачалоПериода, ПараметрыЗапуска.КонецПериода);
		
		ПараметрыЗапускаРасчетаПериода.Вставить("АвтоматическоеТестирование", АвтоматическоеТестирование);
		Если ПараметрыЗапуска.Свойство("МестоВызоваРасчета") Тогда
			ПараметрыЗапускаРасчетаПериода.Вставить("МестоВызоваРасчета", ПараметрыЗапуска.МестоВызоваРасчета);
		КонецЕсли;
		Если ПараметрыЗапуска.Свойство("РежимЗакрытияМесяца") Тогда
			Если НачалоМесяца(СтрокаСхемыРасчета.Дата) < НачалоМесяца(ПараметрыЗапуска.Дата) Тогда
				ПараметрыЗапускаРасчетаПериода.Вставить("РежимЗакрытияМесяца", Перечисления.РежимыЗакрытияМесяца.ОкончательноеЗакрытие);
			Иначе
				ПараметрыЗапускаРасчетаПериода.Вставить("РежимЗакрытияМесяца", ПараметрыЗапуска.РежимЗакрытияМесяца);
			КонецЕсли;
		Иначе
			ПараметрыЗапускаРасчетаПериода.Вставить("РежимЗакрытияМесяца", Перечисления.РежимыЗакрытияМесяца.ПустаяСсылка());
		КонецЕсли;
		
		ПараметрыЗапускаРасчетаПериода.Вставить("НомерЗаданияДоРасчета", НомерЗаданияДоРасчета);
		
		// Формирует временные таблицы:
		// - ВТУчетныеПолитикиОрганизаций (учетные политики рассчитываемых организаций)
		// - ВТУчетныеПолитикиПрошлогоПериода (аналогично, но за предыдущий месяц)
		// - ВТПравилаЗаполненияПоляТипЗаписи (правила проверки первичных записей регистра себестоимости)
		// - ВТОтборАналитикаПоПартнерам (ключи аналитики партнеров с рассчитываемыми организациями)
		// - ВТАналитикиУчетаПоПартнерамИзОтчетовДавальцам (ключи аналитики партнеров из документов "Отчет давальцу")
		// - ВТСтоимостьПартийТоваров (расширенный аналог регистра сведений СтоимостьТоваров с полями партий; пока пустая).
		РасчетСебестоимостиПрикладныеАлгоритмы.ИнициализироватьПараметрыРасчетаПартий(ПараметрыЗапускаРасчетаПериода, ПараметрыРасчета, ПараметрыОтладки);
		
		ПараметрыРасчета.Вставить("ИсходныеЗаданияКРасчетуСебестоимости", 	ВременныеТаблицы);
		ПараметрыРасчета.Вставить("ИдентификаторРасчетаДляЗакрытияМесяца", 	ИдентификаторРасчета);
		ПараметрыРасчета.Вставить("СохранитьСЛУ", Истина);
		ПараметрыРасчета.Вставить("КоличествоУзлов",     0);
		ПараметрыРасчета.Вставить("КоличествоУзловРегл", 0);
		Если ПараметрыЗапуска.Свойство("ТолькоОднаОрганизация") Тогда
			ПараметрыРасчета.Вставить("ТолькоОднаОрганизация", 	ПараметрыЗапуска.ТолькоОднаОрганизация);
		КонецЕсли;
		
		Если ПараметрыРасчета.ДокументыРасчетаСебестоимости.Количество() = 0 Тогда
			
			// По текущей строке схемы расчета не требуется выполнять расчет себестоимости.
			// Завершаем расчет периода
			РасчетСебестоимостиПрикладныеАлгоритмы.ЗаписатьСформированныеДвижения(
				ПараметрыРасчета,
				ПараметрыОтладки.ПротоколыРасчета);
			
			Если НЕ ВыполняетсяЗакрытиеМесяца Тогда
				// Выполним операции механизма закрытия месяца, вызываемые после расчета этапа, если расчет вызван не в рамках закрытия месяца.
				// При закрытии месяца эти действия выполнит сам механизм закрытия месяца.
				РасчетСебестоимостиПрикладныеАлгоритмы.ВыполнитьОперацииЗакрытияМесяцаДляЗавершенияРасчетаЭтапа(СтрокаСхемыРасчета, ИдентификаторРасчета);
			КонецЕсли;
			
			Продолжить;
			
		КонецЕсли;
		
		// Этап 0 - подготовка к расчету
		// - исправляет некорректные исходные данные
		// - выполняет проверку данных
		РасчетСебестоимостиПодготовкаДанных.ПодготовкаИсходныхДанныхКРасчету(ПараметрыРасчета);
		
		РасчетСебестоимостиПрикладныеАлгоритмы.ПроверитьКорректностьИсходныхДанныхДоРасчета(ПараметрыРасчета);
		

		// Этап 8
		// Формирует движения по регистрам:
		// - СебестоимостьТоваров
		РасчетСебестоимостиЗаполнениеПартий.ЗаполнениеПартийВРегистреСебестоимостьТоваров(ПараметрыРасчета);
		
		
		// Этап 8а
		// Формирует движения по регистрам:
		// - ВыручкаИСебестоимостьПродаж
		РасчетСебестоимостиЗаполнениеПартий.ЗаполнениеПартийВРегистреВыручкаИСебестоимостьПродаж(ПараметрыРасчета);
		
		
		// Этап расчета себестоимости

//		// - ВТСтоимостьПартийТоваров
		РасчетСебестоимостиКорректировкаСтоимости.КорректировкаСтоимостиВозвратовИсправленийПрошлыхПериодов(ПараметрыЗапуска, ПараметрыРасчета, ПараметрыОтладки);
		РасчетСебестоимостиЗаполнениеПартий.СторноДвиженийРасчетаПартийИсправленныхДокументов(ПараметрыРасчета);
		РасчетСебестоимостиПостатейныеЗатраты.РаспределитьОтклоненияВСтоимости(ПараметрыРасчета);
		РасчетСебестоимостиРешениеСЛУ.РасчетСебестоимости_РезервыПодОбесценениеЗапасов(ПараметрыРасчета);
		РасчетСебестоимостиРешениеСЛУ.РасчетСебестоимости_МатериальныеИТрудозатраты(ПараметрыРасчета);
		
		// Этап 10
		// Формирует движения по регистрам:
		// - СебестоимостьТоваров
		// - ПрочиеРасходы
		// - ПартииПрочихРасходов
		// - ДвиженияНоменклатураДоходыРасходы
		РасчетСебестоимостиПостатейныеЗатраты.ИнициализироватьТаблицуОВЗ(ПараметрыРасчета);
		РасчетСебестоимостиПостатейныеЗатраты.РаспределениеДопРасходовМеждуПартиямиИТоварами(ПараметрыРасчета);
		РасчетСебестоимостиРешениеСЛУ.РасчетСебестоимости_ДополнительныеРасходы(ПараметрыРасчета);
		РасчетСебестоимостиКорректировкаСтоимости.СкорректироватьСтоимостьДополнительныхРасходов(ПараметрыРасчета, Истина);
		
		// Этап 11. Распределение партий НДС в локализованной версии.
		РасчетСебестоимостиЛокализация.РаспределениеПартийНДС(ПараметрыРасчета, СтрокаСхемыРасчета, 1);
		
		// Формирует движения по регистрам:
		// - СебестоимостьТоваров
		// - ПрочиеРасходы
		РасчетСебестоимостиЛокализация.ВключитьИсключитьНДСВСтоимость(ПараметрыРасчета);
		
		// Этап расчета себестоимости:
		//   - для расчета доп расходов
		//   - для расчета упр. и регл. сумм с учетом включенного \ исключенного НДС
		// Заполняет временные таблицы:
		// - ВТСтоимостьПартийТоваров
		РасчетСебестоимостиРешениеСЛУ.РасчетСебестоимости_ВключениеИсключениеНДС(ПараметрыРасчета);
		
		
		// Этап 11.3. Распределение партий НДС в локализованной версии.
		РасчетСебестоимостиЛокализация.РаспределениеПартийНДС(ПараметрыРасчета, СтрокаСхемыРасчета, 2);
		
		
		// Этап исправления отрицательных остатков партий, возникших в результате исправления документов.
		// Формирует движения по регистрам:
		// - СтоимостьТоваров
		РасчетСебестоимостиЗаполнениеПартий.ПересортицаПартийТоваров(ПараметрыРасчета);
		
		РасчетСебестоимостиРешениеСЛУ.ПодготовкаДанныхДляСтоимостиТоваров(ПараметрыРасчета);
		
		// Этап 17 (расчет фактической себестоимости)
		// Формирует движения по регистрам:
		// - см. РасчетСебестоимости.ИсходящиеДанныеМеханизма()
		РасчетСебестоимостиКорректировкаСтоимости.СформироватьДвиженияПоРегистрам(ПараметрыЗапуска, ПараметрыРасчета, ПараметрыОтладки);
		
		// Этап 18
		// Списываем расходы на продажи
		// Формирует движения по регистрам:
		// - ВыручкаИСебестоимостьПродаж
		// - ПрочиеРасходы
		РасчетСебестоимостиПостатейныеЗатраты.РаспределениеПостатейныхРасходовНаПродажу(ПараметрыРасчета);
		РасчетСебестоимостиКорректировкаСтоимости.СформироватьДвиженияРасходыНаПродажу(ПараметрыРасчета);
		
		// Формирует движения по регистрам:
		// - ФинансовыйРезультаты
		// - ПрочиеАктивыПассивы
		// - Движения по регистрам управленческого баланса.
		РасчетСебестоимостиКорректировкаСтоимости.СформироватьДвиженияПоРегистрамФинансовыйРезультат(ПараметрыЗапуска, ПараметрыРасчета, ПараметрыОтладки);

		// Записываем сформированные движения и завершаем расчет периода
		РасчетСебестоимостиПрикладныеАлгоритмы.ЗаписатьСформированныеДвижения(
			ПараметрыРасчета,
			ПараметрыОтладки.ПротоколыРасчета);
		
		Если НЕ ВыполняетсяЗакрытиеМесяца Тогда
			// Выполним операции механизма закрытия месяца, вызываемые после расчета этапа, если расчет вызван не в рамках закрытия месяца.
			// При закрытии месяца эти действия выполнит сам механизм закрытия месяца.
			РасчетСебестоимостиПрикладныеАлгоритмы.ВыполнитьОперацииЗакрытияМесяцаДляЗавершенияРасчетаЭтапа(СтрокаСхемыРасчета, ИдентификаторРасчета);
		КонецЕсли;
		
	КонецЦикла;
	
	// Вернем признак активности текущих итогов в состояние, которое было до начала расчета.
	Если АвтоматическоеТестирование Тогда
		РасчетСебестоимостиПрикладныеАлгоритмы.ВернутьСостояниеИтоговРегистров(СостояниеИтоговРегистров);
	Иначе
		РасчетСебестоимостиПрикладныеАлгоритмы.ВернутьСостояниеИтоговРегистровФоновымЗаданием(СостояниеИтоговРегистров);
	КонецЕсли;
	
КонецПроцедуры

// Обновления стоимости товаров регламентным заданием.
//
// Параметры:
//	Период - Дата - период расчета
//	ПараметрыРасчета - Структура - параметры расчета, сформированные в вызывающем механизме.
//	ПараметрыОтладки - Структура - предназначена для переопределения одноименных свойств структуры ПараметрыРасчета.
//		Подробнее см. пояснения в коде РасчетСебестоимостиПрикладныеАлгоритмы.ИнициализироватьПараметрыРасчетаПартий() к параметру ПараметрыОтладки.
//
Процедура РассчитатьПредварительнуюСебестоимость(Период = Неопределено, ПараметрыРасчета = Неопределено, ПараметрыОтладки = Неопределено) Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.РасчетСебестоимости); // проверка возможности запуска задания
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если РасчетСебестоимостиЛокализация.ПредварительныйРасчетСебестоимости(Период) Тогда
		Возврат; // Выполнен локализованный расчет
	КонецЕсли;
	
	ИдентификаторРасчета = Новый УникальныйИдентификатор;
	
	Если НЕ ЗначениеЗаполнено(Период) Тогда
		Дата = ТекущаяДатаСеанса();
	Иначе
		Дата = Период;
	КонецЕсли;
	НачалоПериода = НачалоМесяца(Дата);
	КонецПериода  = КонецМесяца(Дата);
	
	// Инициализация параметров запуска
	МассивОрганизаций = РасчетСебестоимостиПрикладныеАлгоритмы.СвязиОрганизацийПоСхемеИнтеркампани(КонецПериода);
	
	ПараметрыЗапуска = Новый Структура();
	ПараметрыЗапуска.Вставить("Дата", 						  			  НачалоПериода);
	ПараметрыЗапуска.Вставить("МассивОрганизаций", 						  МассивОрганизаций);
	ПараметрыЗапуска.Вставить("ТолькоПредварительныйРасчетСебестоимости", Истина);
	ПараметрыЗапуска.Вставить("ЗапущеноРегламентнымЗаданием", 			  Истина);
	ПараметрыЗапуска.Вставить("ПредварительныйРасчет",					  Истина);
	ПараметрыЗапуска.Вставить("МестоВызоваРасчета", 					  "РасчетСебестоимости.РассчитатьПредварительнуюСебестоимость");
	
	// Инициализируем параметры отладки.
	РасчетСебестоимостиПрикладныеАлгоритмы.ИнициализироватьПараметрыОтладки(ПараметрыОтладки, ПараметрыЗапуска);
	
	// Инициализация параметров расчета
	РасчетСебестоимостиПрикладныеАлгоритмы.ИнициализироватьПараметрыРасчетаПартий(ПараметрыЗапуска, ПараметрыРасчета, ПараметрыОтладки);
	
	ПараметрыРасчета.Вставить("ИдентификаторРасчетаДляЗакрытияМесяца", ИдентификаторРасчета);
	
	
	РасчетСебестоимостиЗаполнениеПартий.ПодготовкаДанныхДляПредварительногоРасчетаСебестоимости(ПараметрыРасчета);
	
	РасчетСебестоимостиКорректировкаСтоимости.КорректировкаСтоимостиВозвратовИсправленийПрошлыхПериодов(ПараметрыЗапуска, ПараметрыРасчета, ПараметрыОтладки);
	РасчетСебестоимостиРешениеСЛУ.РасчетСебестоимости_РезервыПодОбесценениеЗапасов(ПараметрыРасчета);
	РасчетСебестоимостиРешениеСЛУ.РасчетСебестоимости_МатериальныеИТрудозатраты(ПараметрыРасчета);
	
	РасчетСебестоимостиПостатейныеЗатраты.РаспределениеДопРасходовМеждуПартиямиИТоварами(ПараметрыРасчета);
	РасчетСебестоимостиРешениеСЛУ.РасчетСебестоимости_ДополнительныеРасходы(ПараметрыРасчета);
	
	РасчетСебестоимостиРешениеСЛУ.ПодготовкаДанныхДляСтоимостиТоваров(ПараметрыРасчета);
	
	// Записываем сформированные движения и завершаем расчет периода
	ПараметрыРасчета.ЗапущенРасчетПартий = Ложь;
	ПараметрыРасчета.ПредварительныйРасчет = Истина;
	РасчетСебестоимостиПрикладныеАлгоритмы.ВыполняетсяМеханизмРасчетаСебестоимости(ПараметрыРасчета, Истина);
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаписатьСформированныеДвижения(
		ПараметрыРасчета,
		ПараметрыОтладки.ПротоколыРасчета);
		
КонецПроцедуры

// Обертка для запуска расчета - выполняет расчет в Попытке - Исключении
// Параметры аналогичны процедуре РассчитатьВсе().
//
// Возвращаемое значение:
//	Булево - признак успешного выполнения расчета.
//
Функция РассчитатьВсеВПопыткеИсключении(ПараметрыЗапуска, ПараметрыРасчета = Неопределено, ПараметрыОтладки = Неопределено) Экспорт
	
	Отказ = Ложь;
	
	Если НЕ ПараметрыЗапуска.Свойство("НачалоПериода") Тогда
		ПараметрыЗапуска.Вставить("НачалоПериода", НачалоМесяца(ПараметрыЗапуска.Дата));
		ПараметрыЗапуска.Вставить("КонецПериода", КонецМесяца(ПараметрыЗапуска.Дата));
	КонецЕсли;
	
	Попытка
		Если ПараметрыЗапуска.Свойство("РегламентноеЗадание") 
		 И ПараметрыЗапуска.РегламентноеЗадание Тогда
			РассчитатьПредварительнуюСебестоимость(ПараметрыЗапуска.Дата, ПараметрыРасчета, ПараметрыОтладки);
		Иначе
			РассчитатьВсе(ПараметрыЗапуска,	ПараметрыРасчета, ПараметрыОтладки);
		КонецЕсли;
	Исключение
		
		Если НЕ ЗначениеЗаполнено(ПараметрыРасчета) Тогда
			ПараметрыРасчета = РасчетСебестоимостиПрикладныеАлгоритмы.ИнициализироватьОсновныеПараметрыРасчета(
				ПараметрыЗапуска.НачалоПериода,
				ПараметрыЗапуска.КонецПериода,
				ПараметрыЗапуска.МассивОрганизаций,
				Истина,
				Истина);
		КонецЕсли;
		
		// Если расчет завершился аварийно, то надо сбросить признак выполнения расчета.
		Если ПараметрыРасчета.Свойство("ИдентификаторРасчетаДляЗакрытияМесяца") Тогда
			РегистрыСведений.ВыполнениеОперацийЗакрытияМесяца.УстановитьПризнакОкончанияРасчета(ПараметрыРасчета.ИдентификаторРасчетаДляЗакрытияМесяца);
		КонецЕсли;
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		РасчетСебестоимостиПрикладныеАлгоритмы.ОбработатьИсключениеВызоваРассчитатьВсе(
			ПараметрыРасчета,
			ИнформацияОбОшибке,
			Отказ);
		
	КонецПопытки;
	
	Возврат НЕ Отказ;
	
КонецФункции

// Запускает расчет в фоновом задании.
//
// Возвращаемое значение:
//	Булево - признак успешного запуска фонового задания.
//
Функция РассчитатьФоновымЗаданием(Период, Организация = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено
	 ИЛИ ФоновоеЗаданиеАктивно() Тогда
		Возврат Ложь; // расчет не запускался
	КонецЕсли;
	
	НаименованиеЗадания = НСтр("ru = 'Расчет партий и себестоимости'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	ПараметрыЗапуска = Новый Структура;
	ПараметрыЗапуска.Вставить("Дата", 					    Период);
	ПараметрыЗапуска.Вставить("МассивОрганизаций",  	    Организация);
	
	ПараметрыЭкспортнойПроцедуры = Новый Массив;
	ПараметрыЭкспортнойПроцедуры.Добавить(ПараметрыЗапуска);
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить("РасчетСебестоимости.РассчитатьВсеВПопыткеИсключении");
	ПараметрыЗадания.Добавить(ПараметрыЭкспортнойПроцедуры);
	
	Ключ = ИмяФоновогоЗадания();
	
	ФоновыеЗадания.Выполнить("ОбщегоНазначения.ВыполнитьМетодКонфигурации", ПараметрыЗадания, Ключ, НаименованиеЗадания);
	
	Возврат Истина; // расчет запущен
	
КонецФункции

// Возвращает имя фонового предопределенного задания расчета партий.
//
// Возвращаемое значение:
//	Строка - наименование фонового задания
//
Функция ИмяФоновогоЗадания() Экспорт
	Возврат "ПартионныйУчет";
КонецФункции

// Выполняет проверку на активное задание расчета партий.
//
// Возвращаемое значение:
//	Булево - признак активности фонового задания
//
Функция ФоновоеЗаданиеАктивно() Экспорт
	
	КлючЗадания = ИмяФоновогоЗадания();
	
	Отбор = Новый Структура();
	Отбор.Вставить("Ключ", КлючЗадания);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	
	АктивныеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	
	Если АктивныеЗадания.Количество() > 0 Тогда
		ФоновоеЗаданиеАктивно = Истина;
	Иначе
		ФоновоеЗаданиеАктивно = Ложь;
	КонецЕсли;
	
	Возврат ФоновоеЗаданиеАктивно;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Инициализация

// Инициализирует параметры запуска расчета периода.
//
Функция ИнициализироватьПараметрыЗапускаРасчетаПериода(СтрокаСхемыРасчета, НачалоПериода, КонецПериода)
	
	ПараметрыЗапускаРасчетаПериода = Новый Структура;
	ПараметрыЗапускаРасчетаПериода.Вставить("Дата", 			  СтрокаСхемыРасчета.Дата);
	Если КонецПериода <= СтрокаСхемыРасчета.Дата Тогда
		ПараметрыЗапускаРасчетаПериода.Вставить("НачалоПериода",  НачалоПериода);
		ПараметрыЗапускаРасчетаПериода.Вставить("КонецПериода",   КонецПериода);
	Иначе
		ПараметрыЗапускаРасчетаПериода.Вставить("НачалоПериода",  НачалоМесяца(СтрокаСхемыРасчета.Дата));
		ПараметрыЗапускаРасчетаПериода.Вставить("КонецПериода",   КонецМесяца(СтрокаСхемыРасчета.Дата));
	КонецЕсли;
	ПараметрыЗапускаРасчетаПериода.Вставить("МассивОрганизаций",  СтрокаСхемыРасчета.Организации);
	ПараметрыЗапускаРасчетаПериода.Вставить("ИзмененоДокументов", СтрокаСхемыРасчета.ИзмененоДокументов);
	
	Возврат ПараметрыЗапускаРасчетаПериода;
	
КонецФункции

#КонецОбласти

#Область УниверсальныеПроцедурыРаботыСДвижениями

// Для вызова из механизма партионного учета версии 2.2

// Добавляет новую строку в таблицу движений указанного регистра и заполняет служебные поля.
// Сделана экспортной для вызова из модуля универсальных механизмов расчетов.
//
// Возвращаемое значение:
//	СтрокаТаблицыЗначений - добавленная строка в таблицу движений.
//
Функция ДобавитьЗаписьВТаблицуДвижений(ПараметрыРасчета, ТаблицаПриемник, ДанныеДвижения,
			КопируемыеПоля = Неопределено, СлужебныеПоля = Неопределено) Экспорт
	
	Если ПараметрыРасчета.Движения.Свойство(ТаблицаПриемник) Тогда
		ОписаниеПриемника = ПараметрыРасчета.Движения[ТаблицаПриемник];
		ЭтоРегистрСебестоимости = (ОписаниеПриемника.ИмяРегистра = Метаданные.РегистрыНакопления.СебестоимостьТоваров.Имя);
	Иначе
		ОписаниеПриемника = ПараметрыРасчета.ВспомогательныеВременныеТаблицы[ТаблицаПриемник];
	КонецЕсли;
	
	// Добавим запись универсальной процедурой, а потом дозаполним поля, относящиеся только к расчету партий.
	Запись = РасчетСебестоимостиПрикладныеАлгоритмы.ДобавитьЗаписьВТаблицуДвижений(
		ПараметрыРасчета,
		ОписаниеПриемника,
		ДанныеДвижения,
		КопируемыеПоля);
	
	Если ОписаниеПриемника.ЭтоОписаниеРегистра И ОписаниеПриемника.ЕстьРасчетНеЗавершен И ЗначениеЗаполнено(СлужебныеПоля) Тогда
		
		// Поле РасчетНеЗавершен формируется в РасчетСебестоимостиПрикладныеАлгоритмы.КэшироватьРаспределенныеПартии().
		ЗаполнитьЗначенияСвойств(Запись, СлужебныеПоля);
		
	КонецЕсли;
	
	Если ОписаниеПриемника.ЭтоОписаниеРегистра И ЭтоРегистрСебестоимости И ПараметрыРасчета.ЗаполняютсяПартииВСебестоимости Тогда
		
		// Заполним поле РасчетПартий для записи регистра СебестоимостьТоваров:
		// - на этапе заполнения партий себестоимости дозаполняются поля первичных движений документов
		//   для таких движений признак РасчетПартий остается равным Ложь
		// - на этом же этапе также формируются новые записи, которые являются расчетными (не первичными);
		//	 признак расчетной партии определяется следующими условиями (по ИЛИ)
		// 		= тип записи движений не используется в макете регистра себестоимости (т.е. движение точно не может быть первичным)
		// 		= для записи явно указано, что она является расчетной (установлен признак ЭтоТочноРасчетноеДвижение).
		
		Запись.РасчетПартий =
			ДанныеДвижения.ЭтоТочноРасчетноеДвижение
			ИЛИ РасчетСебестоимостиПовтИсп.ЭтоТолькоРасчетныйТипЗаписи(Запись.ТипЗаписи);
		
	КонецЕсли;
	
	// Если регистратор не заполнен, то запомним информацию об ошибке
	Если ОписаниеПриемника.ЭтоОписаниеРегистра И НЕ ЗначениеЗаполнено(Запись.Регистратор) Тогда
		
		Если НЕ ЗначениеЗаполнено(ДанныеДвижения.Регистратор) Тогда
			// Ошибка в запросах - не заполнено обязательное поле Регистратор.
			ТекстДляПротокола = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не заполнено свойство Регистратор в данных для формирования движений по регистру ""%1""'", ОбщегоНазначения.КодОсновногоЯзыка()),
				ТаблицаПриемник);
		Иначе
			// Ошибка в метаданных - документ не является регистратором для данного регистра.
			ТекстДляПротокола = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Документ ""%1"" не может иметь движений по регистру ""%2""'", ОбщегоНазначения.КодОсновногоЯзыка()),
				СокрЛП(ДанныеДвижения.Регистратор),
				ТаблицаПриемник);
		КонецЕсли;
		
		РасчетСебестоимостиПротоколРасчета.ЗафиксироватьОшибкуРасчета(
			ПараметрыРасчета,
			Перечисления.ТипыОшибокПартионногоУчетаИСебестоимости.ОшибкаФормированияДвиженийПоРегистрам,
			ТекстДляПротокола);
		
		Если ОписаниеПриемника.ЕстьОрганизация Тогда
			ОрганизацияСПроблемой = ДанныеДвижения.Организация;
		ИначеЕсли ОписаниеПриемника.ЕстьАналитикаПартнеров Тогда
			ОрганизацияПоАналитикеПартнеров = ПараметрыРасчета.ОрганизацияПоАналитикеПартнеров; // Соответствие
			ОрганизацияСПроблемой = ОрганизацияПоАналитикеПартнеров.Получить(ДанныеДвижения.АналитикаУчетаПоПартнерам);
		Иначе
			ОрганизацияСПроблемой = Неопределено;
		КонецЕсли;
		
		РасчетСебестоимостиПрикладныеАлгоритмы.ЗарегистрироватьПроблемуВыполненияРасчета(
			ПараметрыРасчета,
			ОрганизацияСПроблемой,
			НСтр("ru = 'При формировании движений диагностированы ошибки'", ОбщегоНазначения.КодОсновногоЯзыка()),
			ТекстДляПротокола,
			ДанныеДвижения.Регистратор);
		
	КонецЕсли;
	
	Возврат Запись;
	
КонецФункции

Процедура ДополнитьОписаниеПолейДляФормированияДвижений(ПараметрыРасчета, ТаблицаОписанияПолей, ОписаниеПриемника, КопируемыеПоля) Экспорт
	
	Если ОписаниеПриемника.ЭтоОписаниеРегистра И ОписаниеПриемника.ЕстьРасчетНеЗавершен
	 И СтрНайти(НРег(КопируемыеПоля), НРег("РасчетНеЗавершен")) > 0 Тогда
		РасчетСебестоимостиПрикладныеАлгоритмы.ИзменитьПолеВОписанииПолейЗапроса(ТаблицаОписанияПолей, "РасчетНеЗавершен",
			"НЕ РасчетЗавершен");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УниверсальныеПроцедурыОписанияДанныхМеханизма

// Возвращает перечень объектов метаданных, на основании данных которых выполняется расчет партий.
// В перечень не включаются объекты, которые являются одновременно и исходящими данными механизмов расчета партий и себестоимости.
//
// Параметры:
//	ВходящиеДанные - Соответствие - уже инициализированное хранилище для описания входящих данных
//	ТолькоТребующиеПерерасчета - Булево - если установлен, то будет возвращен перечень только тех данных,
//		изменение которых влечет за собой необходимость перерасчета партий и себестоимости
//		При изменении этих данных должна создаваться запись в регистре сведений ЗаданияКРасчетуСебестоимости.
//
// Возвращаемое значение:
//	Соответствие - Ключ - ОбъектМетаданных.
//
Функция ВходящиеДанныеМеханизма(ВходящиеДанные = Неопределено, ТолькоТребующиеПерерасчета = Ложь) Экспорт
	
	Если ВходящиеДанные = Неопределено Тогда
		ВходящиеДанные = Новый Соответствие;
	КонецЕсли;
	
	Если ТолькоТребующиеПерерасчета Тогда
		Значение = Истина; // чтобы можно было проверить вхождение объекта метаданных в это соответствие
	Иначе
		Значение = Неопределено;
	КонецЕсли;
	
	Если НЕ ТолькоТребующиеПерерасчета Тогда 
		
		ВходящиеДанные.Вставить(Метаданные.Документы.ЗаказНаПеремещение, Значение);
		ВходящиеДанные.Вставить(Метаданные.Документы.ЗаказНаСборку, Значение);
		ВходящиеДанные.Вставить(Метаданные.Документы.ЗаказПоставщику, Значение);
		
		ВходящиеДанные.Вставить(Метаданные.Документы.ВнутреннееПотребление, Значение);
		ВходящиеДанные.Вставить(Метаданные.Документы.ПередачаТоваровМеждуОрганизациями, Значение);
		ВходящиеДанные.Вставить(Метаданные.Документы.ПриобретениеТоваровУслуг, Значение);
		ВходящиеДанные.Вставить(Метаданные.Документы.ПрочееОприходованиеТоваров, Значение);
		ВходящиеДанные.Вставить(Метаданные.Документы.ТаможеннаяДекларацияИмпорт, Значение);
		

		
		ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.АналитикаУчетаНоменклатуры, Значение);
		ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ЦеныНоменклатуры, Значение);
		
		
		ВходящиеДанные.Вставить(Метаданные.ПланыВидовХарактеристик.СтатьиАктивовПассивов, Значение);
		ВходящиеДанные.Вставить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов, Значение);
		
		ВходящиеДанные.Вставить(Метаданные.Справочники.ВидыЗапасов, Значение);
		ВходящиеДанные.Вставить(Метаданные.Справочники.КлючиАналитикиУчетаНоменклатуры, Значение);
		ВходящиеДанные.Вставить(Метаданные.Справочники.КлючиАналитикиУчетаПартий, Значение);
		ВходящиеДанные.Вставить(Метаданные.Справочники.Назначения, Значение);
		ВходящиеДанные.Вставить(Метаданные.Справочники.Номенклатура, Значение);
		ВходящиеДанные.Вставить(Метаданные.Справочники.Склады, Значение);
		ВходящиеДанные.Вставить(Метаданные.Справочники.СтруктураПредприятия, Значение);
		
		
	КонецЕсли;
	
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ЗаказыНаПеремещение, Значение);
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ЗаказыНаСборку, Значение);
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ЗаказыПоставщикам, Значение);
	
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ПартииПрочихРасходов, Значение);
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ПрочиеРасходы, Значение);
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.СебестоимостьТоваров, Значение);
	ВходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ТоварыОрганизаций, Значение);
	

	
	РасчетСебестоимостиЛокализация.ВходящиеДанныеМеханизма(ВходящиеДанные, ТолькоТребующиеПерерасчета);
	
	Возврат ВходящиеДанные;
	
КонецФункции

// Возвращает перечень регистров, обслуживаемых механизмом расчета партий.
//
// Возвращаемое значение:
//	Соответствие - Ключ - ОбъектМетаданных.
//
Функция ИсходящиеДанныеМеханизма(ИсходящиеДанные = Неопределено) Экспорт
	
	// Перечень метаданных регистров, по которым формируются движения по партиям.
	Если ИсходящиеДанные = Неопределено Тогда
		ИсходящиеДанные = Новый Соответствие;
	КонецЕсли;
	
	ИсходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ДвиженияНоменклатураДоходыРасходы,		Истина);
	ИсходящиеДанные.Вставить(Метаданные.РегистрыНакопления.МатериалыИРаботыВПроизводстве, 			Истина);
	ИсходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ПартииПрочихРасходов, 					Истина);
	ИсходящиеДанные.Вставить(Метаданные.РегистрыНакопления.СебестоимостьТоваров, 					Истина);
	ИсходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ВыручкаИСебестоимостьПродаж, 			Истина);
	ИсходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ПрочиеРасходы, 							Истина);
	ИсходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ПрочиеДоходы, 							Истина);
	ИсходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ПрочаяВыручка, 							Истина);
	ИсходящиеДанные.Вставить(Метаданные.РегистрыНакопления.ПрочиеАктивыПассивы,						Истина);
	
	РасчетСебестоимостиЛокализация.ИсходящиеДанныеМеханизма(ИсходящиеДанные);
	
	Возврат ИсходящиеДанные;
	
КонецФункции

// Возвращает название данного механизма и его номер версии.
//
// Возвращаемое значение:
//	Строка - версия механизма
//
Функция ТекущаяВерсияМеханизма() Экспорт
	Возврат НСтр("ru = 'Партионный учет, версия 2.2'", ОбщегоНазначения.КодОсновногоЯзыка());
КонецФункции

#КонецОбласти

#Область Тестирование

Функция ЭтапыСРаспределениемПартий() Экспорт
	
	СписокЭтапов = Новый СписокЗначений;
	
	РасчетСебестоимостиЗаполнениеПартий.ДополнитьЭтапыСРаспределениемПартий(СписокЭтапов);
	РасчетСебестоимостиПостатейныеЗатраты.ДополнитьЭтапыСРаспределениемПартий(СписокЭтапов);
	РасчетСебестоимостиЛокализация.ДополнитьЭтапыСРаспределениемПартий(СписокЭтапов);
	
	Возврат СписокЭтапов;
	
КонецФункции

Функция ЭтапыСТрансляциейПартий() Экспорт
	
	СписокЭтапов = Новый СписокЗначений;
	
	РасчетСебестоимостиЗаполнениеПартий.ДополнитьЭтапыСТрансляциейПартий(СписокЭтапов);
	РасчетСебестоимостиПостатейныеЗатраты.ДополнитьЭтапыСТрансляциейПартий(СписокЭтапов);
	РасчетСебестоимостиЛокализация.ДополнитьЭтапыСТрансляциейПартий(СписокЭтапов);
	РасчетСебестоимостиРешениеСЛУ.ДополнитьЭтапыСТрансляциейПартий(СписокЭтапов);
	
	Возврат СписокЭтапов;
	
КонецФункции

Функция ЭтапыСПодготовкойДанныхДляСледующихЭтапов() Экспорт
	
	СписокЭтапов = Новый СписокЗначений;
	
	РасчетСебестоимостиРешениеСЛУ.ДополнитьЭтапыСПодготовкойДанныхДляСледующихЭтапов(СписокЭтапов);
	
	Возврат СписокЭтапов;
	
КонецФункции

Функция ТекстЗапросаДляРасчетаЭтапа(ИмяЭтапа, ПараметрыРасчета = Неопределено) Экспорт
	
	ТекстЗапроса = "";
	РасчетСебестоимостиЗаполнениеПартий.ТекстЗапросаДляРасчетаЭтапа(ИмяЭтапа, ПараметрыРасчета, ТекстЗапроса);
	РасчетСебестоимостиПостатейныеЗатраты.ТекстЗапросаДляРасчетаЭтапа(ИмяЭтапа, ПараметрыРасчета, ТекстЗапроса);
	РасчетСебестоимостиРешениеСЛУ.ТекстЗапросаДляРасчетаЭтапа(ИмяЭтапа, ПараметрыРасчета, ТекстЗапроса);
	РасчетСебестоимостиЛокализация.ТекстЗапросаДляРасчетаЭтапа(ИмяЭтапа, ПараметрыРасчета, ТекстЗапроса);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти
