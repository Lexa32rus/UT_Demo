#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет дерево платежей
//
// Параметры:
//    ПараметрыРасчета - Структура - Параметры для расчета, см. ПараметрыРасчетаКалендаря модуля формы.
//
Процедура РассчитатьДанныеКалендаря(ПараметрыРасчета) Экспорт
	
	Если ФильтрСчетовКалендаря = 2 Тогда
		Заявка = Неопределено;
		Если ПараметрыРасчета.Свойство("Заявка", Заявка) Тогда
			Если ЗначениеЗаполнено(Заявка) Тогда
				БанковскиеСчетаКассыЗаявки = Обработки.ПлатежныйКалендарь.БанковскиеСчетаКассыДоступныеДляЗаявки(Заявка, Истина);
				ОтборБанковскиеСчетаКассы.ЗагрузитьЗначения(БанковскиеСчетаКассыЗаявки);
				ОтборБанковскиеСчетаКассы.ЗаполнитьПометки(Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	МакетСКД = Неопределено;
	Если Не ПараметрыРасчета.ИзмененыРеквизиты Тогда
		Если ЭтоАдресВременногоХранилища(АдресХранилищаМакета) Тогда
			МакетСКД = ПолучитьИзВременногоХранилища(АдресХранилищаМакета);
		Иначе
			МакетСКДКеш = ХранилищеОбщихНастроек.Загрузить("Обработка.ПлатежныйКалендарь", "ДеревоПлатежей"); // ХранилищеЗначения
			Если МакетСКДКеш <> Неопределено Тогда
				МакетСКД = МакетСКДКеш.Получить();
				АдресХранилищаМакета = ПоместитьВоВременноеХранилище(МакетСКД, ПараметрыРасчета.ИдФормы);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	СоздатьНовыйМакет = Ложь;
	Если МакетСКД = Неопределено Тогда
		СоздатьНовыйМакет = Истина;
	Иначе // Проверка параметров
		КонечнаяДата = МакетСКД.ЗначенияПараметров.КонечнаяДата.Значение;
		ТекущаяДата = МакетСКД.ЗначенияПараметров.ТекущаяДата.Значение;
		ДнейВМакете = ДенежныеСредстваКлиентСервер.ДеньПлатежа(ТекущаяДата, КонечнаяДата);
		Если ДнейВМакете < ДнейПланирования Тогда
			СоздатьНовыйМакет = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если СоздатьНовыйМакет Тогда
		
		СКД = ПолучитьМакет("ДеревоПлатежей");
		
		Если ГруппироватьПоВалютам Тогда
			ВариантНастроек = СКД.ВариантыНастроек.ГруппировкаПоВалютам.Настройки;
		Иначе
			ВариантНастроек = СКД.НастройкиПоУмолчанию;
		КонецЕсли;
		
		ДополнитьКолонкиДней(СКД, ВариантНастроек);
		
		ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД);
		Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
		Компоновщик.Инициализировать(ИсточникДоступныхНастроек);
		Компоновщик.ЗагрузитьНастройки(ВариантНастроек);
		
		ЗаполнитьПараметрыКомпоновки(Компоновщик.Настройки.ПараметрыДанных);
		Компоновщик.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.Полное);
		
		МакетСКД = ФинансоваяОтчетностьСервер.ПодготовитьМакетКомпоновкиДляВыгрузкиСКД(СКД, Компоновщик);
		АдресХранилищаМакета = ПоместитьВоВременноеХранилище(МакетСКД, ПараметрыРасчета.ИдФормы);
		
		МакетСКДКеш = Новый ХранилищеЗначения(МакетСКД, Новый СжатиеДанных(5));
		ХранилищеОбщихНастроек.Сохранить("Обработка.ПлатежныйКалендарь", "ДеревоПлатежей", МакетСКДКеш);
	Иначе
		
		ЗаполнитьПараметрыМакета(МакетСКД.ЗначенияПараметров);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	РегистрыСведений.ГрафикПлатежей.РассчитатьГрафикПлатежейПоПоступлениямОтБанкаПоЭквайрингу();
	УстановитьПривилегированныйРежим(Ложь);
	
	ДеревоПлатежей = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКДПоМакету(МакетСКД,, Истина);
	
	Для каждого СтрокаДерева Из ДеревоПлатежей.Строки Цикл
		ДенежныеСредстваКлиентСервер.ПересчитатьПодчиненныеСтрокиДерева(СтрокаДерева, ДнейПланирования);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДополнитьКолонкиДней(СКД, Настройки)
	
	ШаблонВыраженияПоля = "
	|ВЫБОР КОГДА ДатаПлатежа = ДобавитьКДате(&ТекущаяДата, ""День"", %1 - 1) ТОГДА
	|	%2
	|ИНАЧЕ 0 КОНЕЦ";
	
	Для Инд = 0 По ДнейПланирования Цикл
		НовыйДень = ФинансоваяОтчетностьСервер.НовыйВычисляемыйРесурс(
			СКД,
			"День" + Строка(Инд),
			"1-1",
			"Сумма");
		ФинансоваяОтчетностьСервер.НовоеПолеВыбора(Настройки, НовыйДень.ПутьКДанным);
		
		ВыражениеПоля = СтрШаблон(ШаблонВыраженияПоля, Инд, "Оборот");
		НовыйДеньВалюта = ФинансоваяОтчетностьСервер.НовыйВычисляемыйРесурс(
			СКД,
			"День" + Строка(Инд) + "ВВалюте",
			ВыражениеПоля,
			"Сумма",
			"ЕСТЬNULL(СУММА(" + ВыражениеПоля + "), 0)");
		ФинансоваяОтчетностьСервер.НовоеПолеВыбора(Настройки, НовыйДеньВалюта.ПутьКДанным);
		
		ВыражениеПоля = СтрШаблон(ШаблонВыраженияПоля, Инд, "ОборотВОднойВалюте");
		НовыйДеньОднаВалюта = ФинансоваяОтчетностьСервер.НовыйВычисляемыйРесурс(
			СКД,
			"День" + Строка(Инд) + "ВОднойВалюте",
			ВыражениеПоля,
			"Сумма",
			"ЕСТЬNULL(СУММА(" + ВыражениеПоля + "), 0)");
		ФинансоваяОтчетностьСервер.НовоеПолеВыбора(Настройки, НовыйДеньОднаВалюта.ПутьКДанным);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыКомпоновки(ПараметрыДанных)
	
	ФинансоваяОтчетностьСервер.УстановитьПараметр(ПараметрыДанных, "ТекущаяДата", ПланироватьСДаты, Истина);
	ФинансоваяОтчетностьСервер.УстановитьПараметр(ПараметрыДанных, "ДнейПланирования", ДнейПланирования, Истина);
	ФинансоваяОтчетностьСервер.УстановитьПараметр(ПараметрыДанных, "КонечнаяДата",
		ДенежныеСредстваКлиентСервер.ДатаПлатежа(ПланироватьСДаты, ДнейПланирования + 1), Истина);
	
	ФинансоваяОтчетностьСервер.УстановитьПараметр(ПараметрыДанных, "ВалютаИтогов", ВалютаИтогов, Истина);
	
	Организации = Новый Массив;
	Для каждого ЭлементОтбора Из ОтборОрганизации Цикл
		Если ЭлементОтбора.Пометка Тогда
			Организации.Добавить(ЭлементОтбора.Значение);
		КонецЕсли;
	КонецЦикла;
	ФинансоваяОтчетностьСервер.УстановитьПараметр(ПараметрыДанных, "Организации", Организации, Истина);
	ФинансоваяОтчетностьСервер.УстановитьПараметр(ПараметрыДанных, "НеОтбиратьПоОрганизации", Не Организации.Количество(), Истина);
	
	ОбластиПланирования = ОбластиПланирования();
	ФинансоваяОтчетностьСервер.УстановитьПараметр(ПараметрыДанных, "ОбластиПланирования", ОбластиПланирования, Истина);
	ФинансоваяОтчетностьСервер.УстановитьПараметр(ПараметрыДанных, "НеОтбиратьПоОбластямПланирования", Не ОбластиПланирования.Количество(), Истина);
	
	БанковскиеСчетаКассы = Новый Массив;
	Если ФильтрСчетовКалендаря = 1 Или ФильтрСчетовКалендаря = 2 Тогда
		Для каждого ЭлементОтбора Из ОтборБанковскиеСчетаКассы Цикл
			Если ЭлементОтбора.Пометка Тогда
				Если ЭлементОтбора.Значение = "НераспределенныеПлатежи" Тогда
					БанковскиеСчетаКассы.Добавить(Неопределено);
				Иначе
					БанковскиеСчетаКассы.Добавить(ЭлементОтбора.Значение);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ФинансоваяОтчетностьСервер.УстановитьПараметр(ПараметрыДанных, "БанковскиеСчетаКассы", БанковскиеСчетаКассы, Истина);
	ФинансоваяОтчетностьСервер.УстановитьПараметр(ПараметрыДанных, "НеОтбиратьПоБанковскимСчетамКассам", Не БанковскиеСчетаКассы.Количество(), Истина);
	
	ФинансоваяОтчетностьСервер.УстановитьПараметр(ПараметрыДанных, "Валюты", ОтборВалюта, Истина);
	ФинансоваяОтчетностьСервер.УстановитьПараметр(ПараметрыДанных, "НеОтбиратьПоВалютам", Не ЗначениеЗаполнено(ОтборВалюта), Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыМакета(ПараметрыДанных)
	
	ПараметрыДанных.ТекущаяДата.Значение = ПланироватьСДаты;
	ПараметрыДанных.КонечнаяДата.Значение = ДенежныеСредстваКлиентСервер.ДатаПлатежа(ПланироватьСДаты, ДнейПланирования + 1);
	
	ПараметрыДанных.ВалютаИтогов.Значение = ВалютаИтогов;
	
	Организации = Новый Массив;
	Для каждого ЭлементОтбора Из ОтборОрганизации Цикл
		Если ЭлементОтбора.Пометка Тогда
			Организации.Добавить(ЭлементОтбора.Значение);
		КонецЕсли;
	КонецЦикла;
	ПараметрыДанных.Организации.Значение = Организации;
	ПараметрыДанных.НеОтбиратьПоОрганизации.Значение = Не Организации.Количество();
	
	ОбластиПланирования = ОбластиПланирования();
	ПараметрыДанных.ОбластиПланирования.Значение = ОбластиПланирования;
	ПараметрыДанных.НеОтбиратьПоОбластямПланирования.Значение = Не ОбластиПланирования.Количество();
	
	БанковскиеСчетаКассы = Новый Массив;
	Если ФильтрСчетовКалендаря = 1 Или ФильтрСчетовКалендаря = 2 Тогда
		Для каждого ЭлементОтбора Из ОтборБанковскиеСчетаКассы Цикл
			Если ЭлементОтбора.Пометка Тогда
				Если ЭлементОтбора.Значение = "НераспределенныеПлатежи" Тогда
					БанковскиеСчетаКассы.Добавить(Неопределено);
				Иначе
					БанковскиеСчетаКассы.Добавить(ЭлементОтбора.Значение);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ПараметрыДанных.БанковскиеСчетаКассы.Значение = БанковскиеСчетаКассы;
	ПараметрыДанных.НеОтбиратьПоБанковскимСчетамКассам.Значение = Не БанковскиеСчетаКассы.Количество();
	
	ПараметрыДанных.Валюты.Значение = ОтборВалюта;
	ПараметрыДанных.НеОтбиратьПоВалютам.Значение = Не ЗначениеЗаполнено(ОтборВалюта);
	
КонецПроцедуры

Функция ОбластиПланирования() Экспорт
	
	ОбластиПланирования = Новый Массив;
	
	ИспользоватьДоговорыКредитовИДепозитов = ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыКредитовИДепозитов");
	
	КредитыИлиЗаймыПолученныеВключать = (КредитыИлиЗаймыПолученные И ИспользоватьДоговорыКредитовИДепозитов
		Или Не КредитыИлиЗаймыПолученные И Не ИспользоватьДоговорыКредитовИДепозитов);
	ДепозитыВключать = (Депозиты И ИспользоватьДоговорыКредитовИДепозитов
		Или Не Депозиты И Не ИспользоватьДоговорыКредитовИДепозитов);
	ЗаймыВыданныеВключать = (ЗаймыВыданные И ИспользоватьДоговорыКредитовИДепозитов
		Или Не ЗаймыВыданные И Не ИспользоватьДоговорыКредитовИДепозитов);
	
	ЕстьОтборОбластей = Не (ЗаказыКлиентов И ЗаказыПоставщикам И ВозвратыКлиентам И ВозвратыОтПоставщиков И НесогласованныеЗаявки И ОжидаемыеПоступления
		И КредитыИлиЗаймыПолученныеВключать И ДепозитыВключать И ЗаймыВыданныеВключать);
		
	Если ЕстьОтборОбластей Тогда
		
		ОбластиПланирования.Добавить(Перечисления.ОбластиПланированияПлатежей.ЗаявкиНаРасходованиеДенежныхСредств);
		ОбластиПланирования.Добавить(Перечисления.ОбластиПланированияПлатежей.РаспоряженияНаПеремещениеДенежныхСредств);
		ОбластиПланирования.Добавить(Перечисления.ОбластиПланированияПлатежей.ДенежныеСредстваВПути);
		
		Если НесогласованныеЗаявки Тогда
			ОбластиПланирования.Добавить(Перечисления.ОбластиПланированияПлатежей.ЗаявкиНаРасходованиеДенежныхСредствНесогласованные);
			ОбластиПланирования.Добавить(Перечисления.ОбластиПланированияПлатежей.РаспоряженияНаПеремещениеДенежныхСредствНесогласованные);
		КонецЕсли;
		
		Если ОжидаемыеПоступления Тогда
			ОбластиПланирования.Добавить(Перечисления.ОбластиПланированияПлатежей.ОжидаемыеПоступления);
		КонецЕсли;
		
		Если ЗаказыКлиентов Тогда
			ОбластиПланирования.Добавить(Перечисления.ОбластиПланированияПлатежей.РасчетыСКлиентами);
		КонецЕсли;
		Если ЗаказыПоставщикам Тогда
			ОбластиПланирования.Добавить(Перечисления.ОбластиПланированияПлатежей.РасчетыСПоставщиками);
		КонецЕсли;
		Если ВозвратыКлиентам Тогда
			ОбластиПланирования.Добавить(Перечисления.ОбластиПланированияПлатежей.ВозвратыКлиентам);
		КонецЕсли;
		Если ВозвратыОтПоставщиков Тогда
			ОбластиПланирования.Добавить(Перечисления.ОбластиПланированияПлатежей.ВозвратыОтПоставщиков);
		КонецЕсли;
		
		Если КредитыИлиЗаймыПолученные Тогда
			ОбластиПланирования.Добавить(Перечисления.ОбластиПланированияПлатежей.КредитыИлиЗаймыПолученные);
		КонецЕсли;
		Если Депозиты Тогда
			ОбластиПланирования.Добавить(Перечисления.ОбластиПланированияПлатежей.Депозиты);
		КонецЕсли;
		Если ЗаймыВыданные Тогда
			ОбластиПланирования.Добавить(Перечисления.ОбластиПланированияПлатежей.ЗаймыВыданные);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ОбластиПланирования;
	
КонецФункции

#КонецОбласти

#КонецЕсли