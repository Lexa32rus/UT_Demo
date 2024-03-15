#Область СлужебныйПрограммныйИнтерфейс

// Выгрузить данные доверенности в строку XML.
// 
// Параметры:
//  СправочникСсылка - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций
// 
// Возвращаемое значение:
//  См. МашиночитаемыеДоверенности.ВыгрузитьXML
Функция ВыгрузитьXML(Знач СправочникСсылка) Экспорт
	
	Возврат МашиночитаемыеДоверенности.ВыгрузитьXML(СправочникСсылка);
	
КонецФункции

// См. Справочники.МашиночитаемыеДоверенностиОрганизаций.ЗагрузитьЭлементИзФайлаОбмена
// Загружает элемент справочника из файла обмена.
// 
// Параметры:
//  ДанныеДляПроверки - см. МашиночитаемыеДоверенностиКлиентСервер.НовыеДанныеДляПроверкиМЧД;
//  ТребуетсяПроверкаМЧДНаКлиенте - Булево - Флаг устанавливается в Истина, 
//                                             если отсутствует возможность проверить подпись МЧД на сервере 
//                                             (в настройках установлена проверка подписи на клиенте) 
//                                             и необходимо выполнить проверку на клиенте.
//  ОбновлятьСуществующий - Булево - Если Истина, то будет обновлен существующий элемент, если он найден.
//  ЭтоДоверенностьКонтрагента - Булево - Истина, если вызывается из формы справочника МашиночитаемыеДоверенностиКонтрагентов
//  ДополнительныеСведения - Неопределено, Структура - Если переданы, то будут заполнены в элементе справочника.
// 
// Возвращаемое значение:
//  Структура - Результат загрузки:
//   * Выполнено - Булево - Признак успешности выполнения загрузки.
//   * Ссылка - Неопределено, СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций - Ссылка на элемент справочника.
//   * Ошибка - Строка - Текст ошибки, если не удалось загрузить элемент.
//
Функция ЗагрузитьМЧД(Знач ДанныеДляПроверки, ТребуетсяПроверкаМЧДНаКлиенте, Знач ОбновлятьСуществующий = Ложь,
	Знач ЭтоДоверенностьКонтрагента = Ложь, Знач ДополнительныеСведения = Неопределено) Экспорт
	
	Если ЭтоДоверенностьКонтрагента Тогда
		Возврат Справочники.МашиночитаемыеДоверенностиКонтрагентов.ЗагрузитьЭлементИзФайлаОбмена(
			ДанныеДляПроверки, ТребуетсяПроверкаМЧДНаКлиенте, ОбновлятьСуществующий, ДополнительныеСведения);
	КонецЕсли;
	
	Возврат Справочники.МашиночитаемыеДоверенностиОрганизаций.ЗагрузитьЭлементИзФайлаОбмена(
		ДанныеДляПроверки, ТребуетсяПроверкаМЧДНаКлиенте, ОбновлятьСуществующий, ДополнительныеСведения);
			
КонецФункции

// См. МашиночитаемыеДоверенности.ВыгрузитьЗаявлениеНаОтменуМЧД
Функция ВыгрузитьЗаявлениеНаОтменуМЧД(Знач НомерДоверенности, Знач ПричинаОтмены) Экспорт
	
	Возврат МашиночитаемыеДоверенности.ВыгрузитьЗаявлениеНаОтменуМЧД(НомерДоверенности, ПричинаОтмены);
	
КонецФункции

// См. МашиночитаемыеДоверенности.ПолучитьНомерМЧД
Функция ПолучитьНомерМЧД(Знач ТокенДоступа = "") Экспорт
	
	Возврат МашиночитаемыеДоверенности.ПолучитьНомерМЧД(ТокенДоступа);
	
КонецФункции

// Регистрирует МЧД на сервере МЧД.
// 
// Параметры:
//  СсылкаНаДоверенность - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций
//  ДанныеВыгрузки - ДвоичныеДанные - Данные выгрузки
//  ДанныеПодписи - ДвоичныеДанные - Данные подписи
//  ТокенДоступа - Строка - Токен доступа
//  НомерДоверенности - Строка - Номер доверенности
// 
// Возвращаемое значение:
//  См. МашиночитаемыеДоверенности.ЗарегистрироватьМЧД
Функция ЗарегистрироватьМЧД(Знач СсылкаНаДоверенность, ДанныеВыгрузки, Знач ДанныеПодписи, Знач ТокенДоступа = "",
	Знач НомерДоверенности = "") Экспорт
	
	ИмяФайлаВыгрузки = Справочники.МашиночитаемыеДоверенностиОрганизаций.ПолучитьИмяФайлаМЧД(СсылкаНаДоверенность);
	Возврат МашиночитаемыеДоверенности.ЗарегистрироватьМЧД(ИмяФайлаВыгрузки, ДанныеВыгрузки, ДанныеПодписи,
		ТокенДоступа, НомерДоверенности, СсылкаНаДоверенность);
	
КонецФункции

// См. МашиночитаемыеДоверенности.ПолучитьСтатусТранзакцииМЧД
Функция ПолучитьСтатусТранзакцииМЧД(Знач ИдентификаторТранзакции,
	Знач ТокенДоступа = "", Знач НомерДоверенности = "") Экспорт
	
	Возврат МашиночитаемыеДоверенности.ПолучитьСтатусТранзакцииМЧД(ИдентификаторТранзакции, ТокенДоступа,
		НомерДоверенности);
	
КонецФункции

// См. МашиночитаемыеДоверенности.ПолучитьСведенияДоверенностиНаСервереМЧД
Функция ПолучитьСведенияДоверенностиНаСервереМЧД(Знач НомерДоверенности,
	Знач ИННДоверителя, Знач ТокенДоступа = "") Экспорт
	
	Возврат МашиночитаемыеДоверенности.ПолучитьСведенияДоверенностиНаСервереМЧД(
		НомерДоверенности, ИННДоверителя, ТокенДоступа);
	
КонецФункции

// См. МашиночитаемыеДоверенности.ПолучитьЧастичныеДанныеДоверенностиНаСервереМЧД
Функция ПолучитьЧастичныеДанныеДоверенностиНаСервереМЧД(Знач НомерДоверенности, Знач ТокенДоступа = "") Экспорт
	
	Возврат МашиночитаемыеДоверенности.ПолучитьЧастичныеДанныеДоверенностиНаСервереМЧД(НомерДоверенности, ТокенДоступа);
	
КонецФункции

// См. МашиночитаемыеДоверенности.ПолучитьПолныеДанныеДоверенностиНаСервереМЧД
Функция ПолучитьПолныеДанныеДоверенностиНаСервереМЧД(Знач НомерДоверенности,
	Знач ИННДоверителя, Знач ТокенДоступа = "") Экспорт
	
	Возврат МашиночитаемыеДоверенности.ПолучитьПолныеДанныеДоверенностиНаСервереМЧД(НомерДоверенности, ИННДоверителя,
		ТокенДоступа);
	
КонецФункции

// См. МашиночитаемыеДоверенности.ОтменитьМЧД
Функция ОтменитьМЧД(Знач ИмяФайлаВыгрузки, Знач ДанныеВыгрузки, Знач ДанныеПодписи, Знач ТокенДоступа = "",
	Знач НомерДоверенности = "", Знач СсылкаНаДоверенность = Неопределено) Экспорт
	
	Возврат МашиночитаемыеДоверенности.ОтменитьМЧД(ИмяФайлаВыгрузки, ДанныеВыгрузки, ДанныеПодписи, ТокенДоступа,
		НомерДоверенности, СсылкаНаДоверенность);
	
КонецФункции

// См. МашиночитаемыеДоверенности.ПолучитьНомераДоверенностей
Функция ПолучитьНомераДоверенностей(Знач Доверенности) Экспорт
	
	Возврат МашиночитаемыеДоверенности.ПолучитьНомераДоверенностей(Доверенности);
	
КонецФункции

// См. МашиночитаемыеДоверенности.НачатьЗагрузкуСведенийМЧД
Функция НачатьЗагрузкуСведенийМЧД(Знач СтруктураПараметров) Экспорт
	
	Возврат МашиночитаемыеДоверенности.НачатьЗагрузкуСведенийМЧД(СтруктураПараметров);
	
КонецФункции

// См. Справочники.МашиночитаемыеДоверенностиКонтрагентов.ЗагрузитьМЧДИзФайла
Функция ЗагрузитьМЧДКонтрагентаИзФайла(Знач ДанныеФайла) Экспорт
	
	Возврат Справочники.МашиночитаемыеДоверенностиКонтрагентов.ЗагрузитьМЧДИзФайла(ДанныеФайла);
	
КонецФункции

// См. Справочники.МашиночитаемыеДоверенностиОрганизаций.ЗагрузитьМЧДИзФайла
Функция ЗагрузитьМЧДОрганизацииИзФайла(Знач ДанныеФайла) Экспорт
	
	Возврат Справочники.МашиночитаемыеДоверенностиОрганизаций.ЗагрузитьМЧДИзФайла(ДанныеФайла);
	
КонецФункции

// См. МашиночитаемыеДоверенности.ОтразитьРезультатПроверкиМЧД
Процедура ОтразитьРезультатПроверкиМЧД(Знач МЧД, Знач Верна, Знач ТекстОшибки) Экспорт
	
	МашиночитаемыеДоверенности.ОтразитьРезультатПроверкиМЧД(МЧД, Верна, ТекстОшибки);
	
КонецПроцедуры

// См. МашиночитаемыеДоверенности.ДанныеФайлаДоверенностиИПодписи
Функция ДанныеФайлаДоверенностиИПодписи(Знач МЧД) Экспорт
	
	Возврат МашиночитаемыеДоверенности.ДанныеФайлаДоверенностиИПодписи(МЧД);
	
КонецФункции

// См. МашиночитаемыеДоверенности.ВыполнитьДействияПослеПодписания
Процедура ВыполнитьДействияПослеПодписания(Знач Доверенность, Знач ДанныеВыгрузки,
	Знач СвойстваПодписи, ТребуетсяПроверкаМЧДНаКлиенте = Ложь) Экспорт
	
	МашиночитаемыеДоверенности.ВыполнитьДействияПослеПодписания(Доверенность, ДанныеВыгрузки,
		СвойстваПодписи, ТребуетсяПроверкаМЧДНаКлиенте);
	
КонецПроцедуры

// Определяет является ли субъект сертификата физическим лицом.
// 
// Параметры:
//  Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
// 
// Возвращаемое значение:
//  Булево
Функция ЭтоСертификатФизическогоЛица(Сертификат) Экспорт 
	
	ДвоичныеДанные = КриптографияБЭД.ДвоичныеДанныеСертификата(Сертификат);
	СертификатКриптографии = Новый СертификатКриптографии(ДвоичныеДанные);	
	СвойстваСубъекта = КриптографияБЭД.СвойстваСубъектаСертификата(СертификатКриптографии);
	СвойстваИздателя = КриптографияБЭД.СвойстваИздателяСертификата(СертификатКриптографии);
	
	Возврат МашиночитаемыеДоверенностиКлиентСервер.ЭтоСертификатФизическогоЛица(СвойстваСубъекта, СвойстваИздателя);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. МашиночитаемыеДоверенности.РезультатПроверкиДоверенности
Функция РезультатПроверкиДоверенности(ДанныеДоверенности, РезультатПроверкиПодписи, КонтекстДиагностики) Экспорт
	
	Возврат МашиночитаемыеДоверенности.РезультатПроверкиДоверенности(ДанныеДоверенности, РезультатПроверкиПодписи,
		КонтекстДиагностики);
	
КонецФункции

#КонецОбласти