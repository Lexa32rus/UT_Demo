#Область СлужебныйПрограммныйИнтерфейс

// Выполняет обработку штрихкода и возвращает результат этой обработки.
//
// Параметры:
//  ВходящиеДанные - Структура - Данные штрихкода.
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
//  КэшированныеЗначения - Структура - Содержит поля кэшируемых значений.
//  УникальныйИдентификатор - УникальныйИдентификатор - Идентификатор, по которому будут помещены данные по обработанным
//                                                      штрихкодам в хранилище.
// Возвращаемое значение:
//  Структура - (См. ШтрихкодированиеИС.ИнициализироватьРезультатОбработкиШтрихкода).
Функция ОбработатьШтрихкод(ВходящиеДанные, ПараметрыСканирования, КэшированныеЗначения, УникальныйИдентификатор) Экспорт
	
	ДанныеШтрихкода = ОбщегоНазначения.СкопироватьРекурсивно(ВходящиеДанные);
	ШтрихкодированиеИСКлиентСервер.ДекодироватьШтрихкодДанныхBase64(ДанныеШтрихкода, Истина);
	
	СписокДанныхШтрихкодов = Новый Массив;
	СписокДанныхШтрихкодов.Добавить(ДанныеШтрихкода);
	
	РезультатОбработкиШтрихкодов = ШтрихкодированиеИС.ОбработатьШтрихкоды(
		СписокДанныхШтрихкодов, ПараметрыСканирования, КэшированныеЗначения, УникальныйИдентификатор);
	
	// Если нашли в данных исходный штрихкод - возвращаем его.
	ДанныеШтрихкода = РезультатОбработкиШтрихкодов.РезультатыОбработки[СокрЛП(ДанныеШтрихкода.Штрихкод)];
	Если ДанныеШтрихкода <> Неопределено Тогда
		Возврат ДанныеШтрихкода;
	КонецЕсли;
	
	// Иначе - первый по списку.
	Для Каждого КлючЗНачение Из РезультатОбработкиШтрихкодов.РезультатыОбработки Цикл
		ДанныеШтрихкода = КлючЗНачение.Значение;
		Прервать;
	КонецЦикла;
	
	Возврат ДанныеШтрихкода;
	
КонецФункции

// Выполняет обработку штрихкода и возвращает результат этой обработки.
//
// Параметры:
//  ДанныеRFID - Структура - Данные RFID-меток.
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
//  КэшированныеЗначения - Структура - Содержит поля кэшируемых значений.
//  УникальныйИдентификатор - УникальныйИдентификатор - Идентификатор, по которому будут помещены данные по обработанным
//                                                      штрихкодам в хранилище.
// Возвращаемое значение:
//  Структура - (См. ШтрихкодированиеИС.ИнициализироватьРезультатОбработкиШтрихкода).
Функция ОбработатьДанныеRFID(ДанныеRFID, ПараметрыСканирования, КэшированныеЗначения, УникальныйИдентификатор) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Т.RFIDTID             КАК TID,
		|	Т.RFIDEPC             КАК EPC,
		|	Т.RFIDUser            КАК User,
		|	Т.EPCGTIN             КАК GTIN,
		|	Т.ЗначениеШтрихкода   КАК ЗначениеШтрихкода,
		|	Т.RFIDМеткаНеЧитаемая КАК RFIDМеткаНеЧитаемая
		|ИЗ
		|	РегистрСведений.ДанныеRFIDИСМП КАК Т
		|ГДЕ
		|	Т.RFIDTID В (&RFIDTID)");
	
	Запрос.Параметры.Вставить("RFIDTID", ДанныеRFID.TID);
	
	ВидПродукции = Неопределено;
	Если ПараметрыСканирования.ДопустимыеВидыПродукции.Количество() = 1 Тогда
		ВидПродукции = ПараметрыСканирования.ДопустимыеВидыПродукции[0];
	КонецЕсли;
	
	ВходящиеДанные = Новый Структура;
	ВходящиеДанные.Вставить("ВидПродукции", ВидПродукции);
	ВходящиеДанные.Вставить("ВидУпаковки",  Перечисления.ВидыУпаковокИС.Потребительская);
	ВходящиеДанные.Вставить("Штрихкод",     "");
	ВходящиеДанные.Вставить("Количество",   1);
	ВходящиеДанные.Вставить("ДанныеRFID",   ДанныеRFID);
	
	РезультатПроверки = ШтрихкодированиеИСКлиентСервер.ТребуетсяИндивидуализацияRFID(ДанныеRFID, ДанныеRFID.GTIN);
	Если РезультатПроверки.НужноЗаписатьМетку Тогда
		ВходящиеДанные.ДанныеRFID.GTIN = "";
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ВходящиеДанные.Штрихкод = Выборка.ЗначениеШтрихкода;
		
		Если ВходящиеДанные.ДанныеRFID.EPC <> Выборка.EPC
			Или ВходящиеДанные.ДанныеRFID.GTIN <> Выборка.GTIN Тогда
			// Рассинхронизация данных в RFID-метке и информационной базе.
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ОбработатьШтрихкод(
		ВходящиеДанные, ПараметрыСканирования, КэшированныеЗначения, УникальныйИдентификатор);
	
КонецФункции

// Выполняет обработку штрихкода и возвращает результат этой обработки.
//
// Параметры:
//  СырыеДанные - Массив Из Структура - Сырые данные со считывателя RFID-меток.
//
// Возвращаемое значение:
//  Структура:
//   * ДанныеRFID - См. ШтрихкодированиеИСКлиентСервер.ИнициализироватьДанныеRFID():
//   * ТекстОшибки - Строка - Текст ошибки
Функция ДанныеRFID(СырыеДанные) Экспорт
	
	КорректноСчитанныеRFID = Новый Массив;
	
	Для Каждого ЭлементДанных Из СырыеДанные Цикл
		
		// Если TID не считался, то нельзя считать чтение метки успешным
		Если ЗначениеЗаполнено(ЭлементДанных.TID) Тогда
			КорректноСчитанныеRFID.Добавить(ЭлементДанных);
		КонецЕсли;
		
	КонецЦикла;
	
	// От считывателя одна и та же метка могла приехать несколько раз
	// Поэтому сначала свернем приехавшие данные.
	ТаблицаRFID = ИнтеграцияИС.МассивВТаблицуЗначений(КорректноСчитанныеRFID);
	
	ИменаКолонок = Новый Массив;
	Для Каждого Колонка Из ТаблицаRFID.Колонки Цикл
		ИменаКолонок.Добавить(Колонка.Имя);
	КонецЦикла;
	
	ТаблицаRFID.Свернуть(СтрСоединить(ИменаКолонок,","));
	
	Результат = Новый Структура;
	Результат.Вставить("ДанныеRFID",  Неопределено);
	Результат.Вставить("ТекстОшибки", "");
	
	Если ТаблицаRFID.Количество() > 1 Тогда
		Результат.ТекстОшибки = НСтр("ru = 'Считалось сразу несколько RFID-метки.
		                                   |Оставьте в зоне действия считывателя только одну RFID-метку и повторите считывание.'");
		Возврат Результат;
	КонецЕсли;
	
	Результат.ДанныеRFID = ШтрихкодированиеИСКлиентСервер.ИнициализироватьДанныеRFID(
		ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаRFID[0]));
	
	Возврат Результат;
	
КонецФункции

// Добавляет серию в элемент справочника "ШтрихкодыУпаковок".
//
// Параметры:
//  РезультатОбработки - См. ШтрихкодированиеИС.ИнициализироватьРезультатОбработкиШтрихкода.
//  РезультатВыбора - См. ШтрихкодированиеИСКлиент.ИнициализацияСтруктурыДанныхСохраненногоВыбора.
// Возвращаемое значение:
// (См. ШтрихкодированиеИС.ИнициализироватьДанныеШтрихкода).
Функция ОбработатьДанныеШтрихкодаПослеВыбораСерии(РезультатОбработки, РезультатВыбора) Экспорт
	
	ДанныеШтрихкода = РезультатОбработки.ДанныеШтрихкода;
	ДанныеШтрихкода.Серия                   = РезультатВыбора.ДанныеВыбора.Серия;
	ДанныеШтрихкода.ДополнительныеПараметры = РезультатВыбора;
	ДанныеШтрихкода.ТребуетсяВыборСерии     = Ложь;
	
	Если ЗначениеЗаполнено(ДанныеШтрихкода.ШтрихкодУпаковки) Тогда
		
		НовыеРеквизиты = Новый Структура;
		НовыеРеквизиты.Вставить("Серия", РезультатВыбора.ДанныеВыбора.Серия);
		
		Справочники.ШтрихкодыУпаковокТоваров.ИзменитьШтрихкодУпаковки(
			ДанныеШтрихкода.ШтрихкодУпаковки, НовыеРеквизиты);
		
	КонецЕсли;
	
	Возврат ДанныеШтрихкода;
	
КонецФункции

// Возвращает вид продукции по коду GTIN.
//
// Параметры:
//  GTIN - Строка - Код формата GTIN.
// Возвращаемое значение:
//  ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции ИС.
Функция ВидПродукцииПоGTIN(GTIN) Экспорт

	ШтрихкодыEAN = Новый Массив;
	ШтрихкодEAN = ШтрихкодированиеИСКлиентСервер.ШтрихкодEANИзGTIN(GTIN);
	ШтрихкодыEAN.Добавить(ШтрихкодEAN);

	ДанныеПоШтрихкодам = ШтрихкодированиеИС.ДанныеПоШтрихкодамEAN(ШтрихкодыEAN);
	Если ДанныеПоШтрихкодам.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат ДанныеПоШтрихкодам[0].ВидПродукции;

КонецФункции

// Очищает отложенные коды маркировки в кеше маркируемой продукции
// 
// Параметры:
//  АдресКэшаМаркируемойПродукции - Строка - Адрес временного хранилища кеша маркируемой продукции
Процедура ОчиститьОтложенныеКодыМаркировки(АдресКэшаМаркируемойПродукции) Экспорт
	
	ШтрихкодированиеИС.ОчиститьОтложенныеКодыМаркировки(АдресКэшаМаркируемойПродукции);
	
КонецПроцедуры

// Очищает кеш маркируемой продукции
// 
// Параметры:
//  АдресКэшаМаркируемойПродукции - Строка - Адрес временного хранилища кеша маркируемой продукции
Процедура ОчиститьКэшМаркируемойПродукции(АдресКэшаМаркируемойПродукции) Экспорт
	
	ШтрихкодированиеИС.ОчиститьКэшМаркируемойПродукции(АдресКэшаМаркируемойПродукции);
	
КонецПроцедуры

// Получает данные для уточнения сведений у пользователя из кэша по адресу.
// 
// Параметры:
//  АдресВременногоХранилища - Строка - Адрес кэша обработки кодов маркировки.
// Возвращаемое значение:
//  Неопределено - Структура - 
Функция ДанныеДляУточненияСведенийПользователя(АдресВременногоХранилища) Экспорт
	
	Если Не ЭтоАдресВременногоХранилища(АдресВременногоХранилища) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеКэша = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	Возврат ДанныеКэша.ДанныеДляУточненияСведенийПользователя;
	
КонецФункции

Процедура ОбработатьУточнениеДанныхДляФормыПроверкиИПодбора(РезультатВыбора, РезультатОбработки, ПараметрыСканирования, КэшированныеЗначения) Экспорт
	
	ШтрихкодированиеИС.ОбработатьУточнениеДанныхДляФормыПроверкиИПодбора(РезультатВыбора, РезультатОбработки, ПараметрыСканирования, КэшированныеЗначения);
	
КонецПроцедуры

Процедура ОбработатьГрупповоеУточнениеДанных(СохраненныйВыбор, ОбновляемыеШтрихкодыУпаковок, ПараметрыСканирования) Экспорт
	
	ГрупповаяОбработкаШтрихкодовИС.ОбработатьУточнениеДанных(СохраненныйВыбор, ОбновляемыеШтрихкодыУпаковок, ПараметрыСканирования);
	
КонецПроцедуры

#КонецОбласти
