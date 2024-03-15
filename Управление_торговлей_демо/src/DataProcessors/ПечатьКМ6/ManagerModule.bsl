#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КМ6") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "КМ6", НСтр("ru = 'Отчет за смену'", ОбщегоНазначения.КодОсновногоЯзыка()), СформироватьПечатнуюФормуКМ6(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		ПараметрыВывода.Вставить("ЗаголовокФормы", НСтр("ru = 'Справка отчет кассира-операциониста (КМ-6)'", ОбщегоНазначения.КодОсновногоЯзыка()));
	КонецЕсли;
	
КонецПроцедуры

// Функция формирует табличный документ обложки кассовой книги
//
Функция СформироватьПечатнуюФормуКМ6(СтруктураТипов, ОбъектыПечати, ПараметрыПечати)
	
	Замер = ОценкаПроизводительности.НачатьЗамерДлительнойОперации(
		"Обработка.ПечатьКМ6.МодульМенеджера.СформироватьПечатнуюФормуКМ6");

	КоличествоОбработанныхДанных = 0;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КМ6";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		Если НЕ (СтруктураОбъектов.Ключ = "Документ.ОтчетОРозничныхПродажах"
			ИЛИ СтруктураОбъектов.Ключ = "Документ.ОтчетОРозничныхВозвратах") Тогда
			
			Для Каждого Документ Из СтруктураОбъектов.Значение Цикл
				
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для документа %1 печать Справки отчета кассира-операциониста (КМ-6) не требуется.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					Документ.Ссылка);
				
				ОбщегоНазначения.СообщитьПользователю(
					Текст,
					Документ.Ссылка);
				
			КонецЦикла;
			
			Продолжить;
		КонецЕсли;
		
		КоличествоОбработанныхДанных = КоличествоОбработанныхДанных + 1;
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыКМ6(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументКМ6(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати);
		
	КонецЦикла;
	
	ОценкаПроизводительности.ЗакончитьЗамерДлительнойОперации(Замер, КоличествоОбработанныхДанных);
	
	Возврат ТабличныйДокумент;
		
КонецФункции

Процедура ЗаполнитьТабличныйДокументКМ6(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьКМ6.ПФ_MXL_КМ6_ru");
	Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
	
	
	Выборка = ДанныеДляПечати.РезультатЗапроса.Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СведенияОПокупателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Выборка.Организация, Выборка.ДатаДокумента);
		ОтветственныйПредставление = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Выборка.Ответственный, Выборка.ДатаДокумента);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.ОрганизацияПредставление = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны, КодПоОКПО");
		ОбластьМакета.Параметры.ДатаДокумента            = Выборка.ДатаДокумента;
		ОбластьМакета.Параметры.ОрганизацияПоОКПО        = СведенияОПокупателе.КодПоОКПО;
		ОбластьМакета.Параметры.ОрганизацияИНН           = СведенияОПокупателе.ИНН;
		ОбластьМакета.Параметры.СерийныйНомер            = Выборка.СерийныйНомер;
		ОбластьМакета.Параметры.РегистрационныйНомер     = Выборка.РегистрационныйНомер;
		ОбластьМакета.Параметры.ККМПредставление         = Выборка.ККМПредставление;
		ОбластьМакета.Параметры.ПрограммаУчета           = "1С:Предприятие 8";
		ОбластьМакета.Параметры.НомерДокумента           = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Строка(Выборка.НомерДокумента), Ложь, Истина);
		ОбластьМакета.Параметры.Ответственный            = ОтветственныйПредставление;
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, Выборка.Ссылка);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		
		Если Выборка.ТипКассы = Перечисления.ТипыКассККМ.ФискальныйРегистратор И ЗначениеЗаполнено(Выборка.КассоваяСмена) Тогда
			СуммаПродаж  = Выборка.СуммаПродаж + ?(НЕ Выборка.ЦенаВключаетНДС, Выборка.СуммаПродажНДС, 0);
			СуммаВозврат = Выборка.СуммаВозвратов + ?(НЕ Выборка.ЦенаВключаетНДС, Выборка.СуммаВозвратовНДС, 0);
		Иначе
			Сумма = Выборка.СуммаПродажОтчет + ?(НЕ Выборка.ЦенаВключаетНДС, Выборка.СуммаПродажОтчетНДС, 0);
			Если Сумма >= 0 Тогда
				СуммаПродаж  = Сумма;
				СуммаВозврат = 0;
			Иначе
				СуммаПродаж  = 0;
				СуммаВозврат = -Сумма;
			КонецЕсли;
		КонецЕсли;
		
		ОбластьМакета.Параметры.Итого        = СуммаПродаж;
		ОбластьМакета.Параметры.ИтогоВозврат = СуммаВозврат;
		ОбластьМакета.Параметры.НомерСекции  = 1; // Продажи
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета.Параметры.Итого        = Выборка.СуммаПродажПодарочныхСертификатов;
		ОбластьМакета.Параметры.ИтогоВозврат = Выборка.СуммаВозвратовПодарочныхСертификатов;
		ОбластьМакета.Параметры.НомерСекции  = 2; // Авансы
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Итог");
		
		ОбластьМакета.Параметры.Итого        = СуммаПродаж + Выборка.СуммаПродажПодарочныхСертификатов;
		ОбластьМакета.Параметры.ИтогоВозврат = СуммаВозврат + Выборка.СуммаВозвратовПодарочныхСертификатов;
		
		Если ЗначениеЗаполнено(СуммаПродаж) Тогда
			ОбластьМакета.Параметры.СуммаВыручкиПрописью = РаботаСКурсамиВалютУТ.СформироватьСуммуПрописью(
				  СуммаПродаж
				- СуммаВозврат
				+ Выборка.СуммаПродажПодарочныхСертификатов
				- Выборка.СуммаВозвратовПодарочныхСертификатов, Выборка.Валюта);
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Оборот");
		ОбластьМакета.Параметры.ФИОРуководителя       = Выборка.Руководитель;
		ОбластьМакета.Параметры.Ответственный         = ОтветственныйПредставление;
		ОбластьМакета.Параметры.ФИОКассираОрганизации = Выборка.ГлавныйБухгалтер;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
