// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Новый элемент записи данных RFID.
// 
// Возвращаемое значение:
//  Структура - Новый элемент записи данных:
// * RFIDTID - Неопределено -
// * ШтрихкодУпаковки - Неопределено -
// * ЗначениеШтрихкода - Неопределено -
// * ХешСуммаЗначенияШтрихкода - Неопределено -
// * RFIDEPC - Неопределено -
// * RFIDUser - Неопределено -
// * EPCGTIN - Неопределено -
// * RFIDМеткаНеЧитаемая - Неопределено -
Функция НовыйЭлементЗаписиДанных() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("RFIDTID",                   Неопределено);
	ВозвращаемоеЗначение.Вставить("ЗначениеШтрихкода",         Неопределено);
	ВозвращаемоеЗначение.Вставить("RFIDEPC",                   Неопределено);
	ВозвращаемоеЗначение.Вставить("RFIDUser",                  Неопределено);
	ВозвращаемоеЗначение.Вставить("EPCGTIN",                   Неопределено);
	ВозвращаемоеЗначение.Вставить("RFIDМеткаНеЧитаемая",       Неопределено);
	ВозвращаемоеЗначение.Вставить("ХешСуммаЗначенияШтрихкода", Неопределено);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Записать данные RFID.
// 
// Параметры:
//  МассивДанныхRFID - Массив из см. НовыйЭлементЗаписиДанных
// 
// Возвращаемое значение:
//  Структура - Записать данные:
// * Успешно - Булево -
// * ТекстОшибки - Неопределено, Строка -
Функция ЗаписатьДанные(МассивДанныхRFID) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("Успешно",     Истина);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки", Неопределено);
	
	ДанныеДляЗаписи   = Новый Соответствие();
	ТаблицаБлокировки = Новый ТаблицаЗначений();
	ТаблицаБлокировки.Колонки.Добавить("RFIDTID", Метаданные.ОпределяемыеТипы.RFIDTID.Тип);
	
	Для Каждого ЭлементКоллекции Из МассивДанныхRFID Цикл
		Если Не ЗначениеЗаполнено(ЭлементКоллекции.RFIDTID) Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ТаблицаБлокировки.Добавить();
		НоваяСтрока.RFIDTID = ЭлементКоллекции.RFIDTID;
		ДанныеДляЗаписи.Вставить(ЭлементКоллекции.RFIDTID, ЭлементКоллекции);
		Если ЗначениеЗаполнено(ЭлементКоллекции.ЗначениеШтрихкода)
			И Не ЗначениеЗаполнено(ЭлементКоллекции.ХешСуммаЗначенияШтрихкода) Тогда
			ЭлементКоллекции.ХешСуммаЗначенияШтрихкода = Справочники.ШтрихкодыУпаковокТоваров.ХэшСуммаСтроки(ЭлементКоллекции.ЗначениеШтрихкода);
		КонецЕсли;
	КонецЦикла;
	
	Если ДанныеДляЗаписи.Количество() = 0 Тогда
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ДанныеRFIDИСМП");
	ЭлементБлокировки.ИсточникДанных = ТаблицаБлокировки;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных(
		Метаданные.РегистрыСведений.ДанныеRFIDИСМП.Измерения.RFIDTID.Имя,
		Метаданные.РегистрыСведений.ДанныеRFIDИСМП.Измерения.RFIDTID.Имя);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеRFIDИСМП.RFIDTID,
		|	ДанныеRFIDИСМП.ЗначениеШтрихкода,
		|	ДанныеRFIDИСМП.ХешСуммаЗначенияШтрихкода,
		|	ДанныеRFIDИСМП.RFIDEPC,
		|	ДанныеRFIDИСМП.RFIDUser,
		|	ДанныеRFIDИСМП.EPCGTIN,
		|	ДанныеRFIDИСМП.RFIDМеткаНеЧитаемая
		|ИЗ
		|	РегистрСведений.ДанныеRFIDИСМП КАК ДанныеRFIDИСМП
		|ГДЕ
		|	ДанныеRFIDИСМП.RFIDTID В (&RFIDTID)";
	
	Запрос.УстановитьПараметр("RFIDTID", ТаблицаБлокировки.ВыгрузитьКолонку("RFIDTID"));
	
	НаборДляЗаписиНовых = РегистрыСведений.ДанныеRFIDИСМП.СоздатьНаборЗаписей();
	СуществующиеЗаписи  = Новый Соответствие();
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка.Заблокировать();
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ТекущийЭлемент = ДанныеДляЗаписи[ВыборкаДетальныеЗаписи.RFIDTID];
			Для Каждого КлючИЗначение Из ТекущийЭлемент Цикл
				Если ТекущийЭлемент[КлючИЗначение.Ключ] = Неопределено Тогда
					ТекущийЭлемент[КлючИЗначение.Ключ] = ВыборкаДетальныеЗаписи[КлючИЗначение.Ключ];
				КонецЕсли;
			КонецЦикла;
			Если ЗначениеЗаполнено(ТекущийЭлемент.ХешСуммаЗначенияШтрихкода)
				И Не ЗначениеЗаполнено(ТекущийЭлемент.ЗначениеШтрихкода) Тогда
				ТекущийЭлемент.ХешСуммаЗначенияШтрихкода = "";
			КонецЕсли;
			СуществующиеЗаписи.Вставить(ВыборкаДетальныеЗаписи.RFIDTID, Истина);
		КонецЦикла;
		
		УстановитьПривилегированныйРежим(Истина);
		Для Каждого КлючИЗначение Из ДанныеДляЗаписи Цикл
			Если СуществующиеЗаписи[КлючИЗначение.Значение.RFIDTID] = Неопределено Тогда
				СтрокаНабора = НаборДляЗаписиНовых.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаНабора, КлючИЗначение.Значение);
			Иначе
				НаборДляЗаписи = РегистрыСведений.ДанныеRFIDИСМП.СоздатьНаборЗаписей();
				НаборДляЗаписи.Отбор.RFIDTID.Установить(КлючИЗначение.Значение.RFIDTID);
				СтрокаНабора = НаборДляЗаписи.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаНабора, КлючИЗначение.Значение);
				НаборДляЗаписи.Записать();
			КонецЕсли;
		КонецЦикла;
		
		Если НаборДляЗаписиНовых.Количество() Тогда
			НаборДляЗаписиНовых.Записать(Ложь);
		КонецЕсли;
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не удалось записать набор записей регистра сведений ДанныеRFIDИСМП ИС по причине: %1'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(
				НСтр("ru = 'ГосИС: Запись данных регистра ДанныеRFIDИСМП'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, Метаданные.РегистрыСведений.ДанныеRFIDИСМП, Неопределено,
			ТекстСообщения);
		
		ВозвращаемоеЗначение.Успешно     = Ложь;
		ВозвращаемоеЗначение.ТекстОшибки = ТекстСообщения;
		
	КонецПопытки;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Заполняет данные RFID в данных штрихкодов
// Параметры:
//  ДанныеКодовМаркировки - Массив Из СтрокаТаблицыЗначений: См. ШтрихкодированиеИС.ИнициализацияТаблицыДанныхКодовМаркировки
Процедура ЗаполнитьДанныеRFID(ДанныеКодовМаркировки) Экспорт
	
	Если ДанныеКодовМаркировки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИсходныеДанные = Новый ТаблицаЗначений;
	ИсходныеДанные.Колонки.Добавить("ЗначениеШтрихкода",      Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(200)));
	ИсходныеДанные.Колонки.Добавить("ХешСуммаКодаМаркировки", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(50)));
	
	Для Каждого СтрокаДанных Из ДанныеКодовМаркировки Цикл
		
		НоваяСтрока = ИсходныеДанные.Добавить();
		НоваяСтрока.ЗначениеШтрихкода      = СтрокаДанных.Штрихкод;
		НоваяСтрока.ХешСуммаКодаМаркировки = ИнтеграцияИС.ХешированиеДанныхSHA256(СтрокаДанных.Штрихкод);
		
	КонецЦикла;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ИсходныеДанные.ЗначениеШтрихкода      КАК ЗначениеШтрихкода,
	|	ИсходныеДанные.ХешСуммаКодаМаркировки КАК ХешСуммаКодаМаркировки
	|ПОМЕСТИТЬ ИсходныеДанные
	|ИЗ
	|	&ИсходныеДанные КАК ИсходныеДанные
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗначениеШтрихкода
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсходныеДанные.ЗначениеШтрихкода   КАК ЗначениеШтрихкода,
	|	ДанныеRFIDИСМП.RFIDTID             КАК TID,
	|	ДанныеRFIDИСМП.RFIDEPC             КАК EPC,
	|	ДанныеRFIDИСМП.RFIDUser            КАК User,
	|	ДанныеRFIDИСМП.EPCGTIN             КАК GTIN,
	|	ДанныеRFIDИСМП.RFIDМеткаНеЧитаемая КАК RFIDМеткаНеЧитаемая
	|ИЗ
	|	ИсходныеДанные КАК ИсходныеДанные
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеRFIDИСМП КАК ДанныеRFIDИСМП
	|		ПО ИсходныеДанные.ЗначениеШтрихкода      = ДанныеRFIDИСМП.ЗначениеШтрихкода
	|		 И ИсходныеДанные.ХешСуммаКодаМаркировки = ДанныеRFIDИСМП.ХешСуммаЗначенияШтрихкода
	|");
	
	Запрос.УстановитьПараметр("ИсходныеДанные", ИсходныеДанные);
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаДанныеRFID = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ТаблицаДанныеRFID.Индексы.Добавить("ЗначениеШтрихкода");
	
	Для Каждого СтрокаДанных Из ДанныеКодовМаркировки Цикл
		
		НайденнаяСтрока = ТаблицаДанныеRFID.Найти(СтрокаДанных.Штрихкод, "ЗначениеШтрихкода");
		Если НайденнаяСтрока = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеRFID = ШтрихкодированиеИСКлиентСервер.ИнициализироватьДанныеRFID();
		ДанныеRFID.TID                 = НайденнаяСтрока.TID;
		ДанныеRFID.RFIDМеткаНеЧитаемая = НайденнаяСтрока.RFIDМеткаНеЧитаемая;
		
		Если ЗначениеЗаполнено(НайденнаяСтрока.EPC) Тогда
			ДекодированныеДанныеSGTIN = МенеджерОборудованияКлиентСервер.ДекодированиеДанныхSGTIN(НайденнаяСтрока.EPC);
			ЗаполнитьЗначенияСвойств(ДанныеRFID, ДекодированныеДанныеSGTIN);
		КонецЕсли;
		
		СтрокаДанных.ДанныеRFID = ДанныеRFID;
		
		Если ЗначениеЗаполнено(ДанныеRFID.GTIN)
			И Не ЗначениеЗаполнено(СтрокаДанных.GTIN) Тогда
			СтрокаДанных.GTIN = ДанныеRFID.GTIN;
			СтрокаДанных.EAN  = РазборКодаМаркировкиИССлужебныйКлиентСерверПовтИсп.ШтрихкодEANИзGTIN(ДанныеRFID.GTIN);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
