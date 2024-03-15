////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-сеть".
// ОбщийМодуль.БизнесСетьВызовСервера.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьУдалитьИзВременногоХранилища(Адрес) Экспорт
	
	Возврат БизнесСеть.ПолучитьУдалитьИзВременногоХранилища(Адрес);
	
КонецФункции

// Получение сведений об участнике сервиса.
//
// Параметры:
//   ПараметрыКоманды - Структура, СправочникСсылка.Контрагент, СправочникСсылка.Организация - ссылка на объект поиска.
//   Результат - Структура - возвращаемые данные.
//   Отказ - Булево - признак отказа выполнения.
//
Функция ПолучитьРеквизитыУчастника(ДополнительныеПараметры, Отказ, ЗапроситьКоличествоТорговыхПредложений = Ложь) Экспорт
		
	Результат = БизнесСеть.РеквизитыУчастника(ДополнительныеПараметры, Отказ);
		
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// Запрос количества торговых предложений участника.
	Если ЗапроситьКоличествоТорговыхПредложений И ЗначениеЗаполнено(Результат) И ТипЗнч(Результат) = Тип("Структура")
		И ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ТорговыеПредложения") Тогда
		
		ОбщийМодуль = ОбщегоНазначения.ОбщийМодуль("ТорговыеПредложенияСлужебный");
		ОтказКоличествоТорговыхПредложений = Ложь;
		КоличествоТорговыхПредложений = ОбщийМодуль.ПолучитьКоличествоТорговыхПредложений(ДополнительныеПараметры, 
			ОтказКоличествоТорговыхПредложений);
		Если Не ОтказКоличествоТорговыхПредложений И ТипЗнч(КоличествоТорговыхПредложений) = Тип("Число") Тогда
			Результат.Вставить("КоличествоТорговыхПредложений", КоличествоТорговыхПредложений);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Отправление приглашение контрагенту для регистрации в сервисе.
//
// Параметры:
//   Организация - СправочникСсылка - ссылка на объект организация.
//   Контрагент - СправочникСсылка - ссылка на объект контрагент.
//   ЭлектроннаяПочта - Строка - адрес электронной почты контрагента.
//   Результат - Структура - возвращаемые данные.
//   Отказ - Булево - признак отказа выполнения.
//
Функция ОтправитьПриглашениеКонтрагенту(Организация, Контрагент, ЭлектроннаяПочта, Отказ) Экспорт
	
	ПараметрыМетода = Новый Структура;
	ПараметрыМетода.Вставить("Организация",      Организация);
	ПараметрыМетода.Вставить("Контрагент",       Контрагент);
	ПараметрыМетода.Вставить("ЭлектроннаяПочта", ЭлектроннаяПочта);
	ПараметрыКоманды = БизнесСеть.ПараметрыКомандыОтправкаПриглашения(ПараметрыМетода, Отказ);
	Возврат БизнесСеть.ВыполнитьКомандуСервиса(ПараметрыКоманды, Отказ);
	
КонецФункции

// Удаление документов в сервисе.
//
// Параметры:
//   Организация              - ОпределяемыйТип.Организация - организация документа.
//   ИдентификаторыДокументов - Массив из Строка - массив с идентификаторами ГУИД удаляемых документов.
//   Результат                - Структура - возвращаемые данные.
//   Отказ                    - Булево - признак отказа выполнения.
//
Функция УдалитьДокументы(ПараметрыМетода, Отказ) Экспорт
	
	ПараметрыКоманды = БизнесСеть.ПараметрыКомандыУдалитьДокументы(ПараметрыМетода, Отказ);
	Возврат БизнесСеть.ВыполнитьКомандуСервиса(ПараметрыКоманды, Отказ);
	
КонецФункции

// Отключение организаций от сервиса.
// См. БизнесСеть.ОтключитьОрганизации.
//
Процедура ОтключитьОрганизации(СписокОрганизаций, Отказ) Экспорт
	
	БизнесСеть.ОтключитьОрганизации(СписокОрганизаций, Отказ);
	
КонецПроцедуры

// Получение данных электронного документа в сервисе.
//
Функция ПолучитьДанныеДокументаСервиса(Организация, МассивИдентификаторов, 
		ЭтоРежимЗагрузки, УникальныйИдентификатор, ЗагрузкаПредставления = Ложь, Отказ = Ложь) Экспорт
	
	ПараметрыМетода = Новый Структура;
	ПараметрыМетода.Вставить("ИдентификаторОрганизации", БизнесСеть.ИдентификаторОрганизации(Организация));
	ПараметрыМетода.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыМетода.Вставить("МассивСсылокНаОбъект", МассивИдентификаторов);
	ПараметрыМетода.Вставить("РежимВходящихДокументов", ЭтоРежимЗагрузки);
	ПараметрыМетода.Вставить("ВозвращатьДанные", Истина);
	
	ПараметрыКоманды = БизнесСеть.ПараметрыКомандыПолучитьДокументы(ПараметрыМетода, Отказ);
	Результат = БизнесСеть.ВыполнитьКомандуСервиса(ПараметрыКоманды, Отказ);
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат БизнесСеть.АдресаВременныхХранилищПолученныхДокументов(Результат, УникальныйИдентификатор, ЗагрузкаПредставления, Отказ);
	
КонецФункции

// Проверка возможности отправки документа.
//
// Параметры:
//  МассивСсылок - Массив из ДокументСсылка - ссылка на отправляемый документ.
//  Организация	 - ОпределяемыйТип.Организация - заполняется в функции, в случае если ИБ не зарегистрирована,
//                                               требуется для дальнейшей регистрации организации.
//  ТекстОшибки  - Строка - возвращаемый текст ошибки.
//  Отказ        - Булево - признак отказа.
// 
// Возвращаемое значение:
//  Булево - результат проверки.
//
Функция ВозможнаОтправкаДокумента(МассивСсылок, Организация, ТекстОшибки, Отказ) Экспорт
	
	ЭлектронноеВзаимодействиеПереопределяемый.ПроверитьГотовностьИсточников(МассивСсылок, Истина);
	
	Если МассивСсылок.Количество() = 0 Тогда
		Возврат Ложь;
	ИначеЕсли МассивСсылок.Количество() > 1 Тогда
		// Проверка совпадения отправителя и получателя в документах.
		БизнесСетьПереопределяемый.ВыполнитьКонтрольРеквизитовДокументов(МассивСсылок, ТекстОшибки, Отказ);
		Если Отказ Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Отклонить документы.
//
// Параметры:
//  ПараметрыВызова - Структура, Массив - данные для отклонения, для массива элементами является структура.
//    * Ссылка - ДокументСсылка - ссылка документа информационной базы.
//    * Идентификатор - Число - идентификатор документа сервиса.
//  Отказ			 - Булево - возвращает результат исполнения.
//
Функция ОтклонитьДокументы(Организация, ПараметрыВызова, Отказ) Экспорт 
	
	Если ТипЗнч(ПараметрыВызова) = Тип("Массив") Тогда
		МассивДанных = ПараметрыВызова;
	ИначеЕсли ТипЗнч(ПараметрыВызова) = Тип("Структура") Тогда
		МассивДанных = Новый Массив;
		МассивДанных.Добавить(ПараметрыВызова);
	Иначе
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Ошибка параметров команды отклонения'"),,,, Отказ);
	КонецЕсли;
	
	ПараметрыМетода = Новый Структура;
	
	ПараметрыМетода.Вставить("МассивДанных", МассивДанных);
	ПараметрыМетода.Вставить("Статус",       "Отклонен");
	ПараметрыМетода.Вставить("Организация",  Организация);
	
	ПараметрыКоманды = БизнесСеть.ПараметрыКомандыИзменитьСтатусыДокументов(ПараметрыМетода, Отказ);
	Возврат БизнесСеть.ВыполнитьКомандуСервиса(ПараметрыКоманды, Отказ);

КонецФункции

// Имя формы выбора метаданных.
//
// Параметры:
//  ИмяОпределяемогоТипа - Строка - наименование определяемого типа.
// 
// Возвращаемое значение:
//  Строка - имя формы выбора.
//
Функция ИмяФормыВыбораПоОпределяемомуТипу(ИмяОпределяемогоТипа) Экспорт
	
	ОпределяемыйТип = Метаданные.ОпределяемыеТипы.Найти(ИмяОпределяемогоТипа);
	Если ОпределяемыйТип <> Неопределено Тогда
		
		ИмяФормы = "";
		Тип = ОпределяемыйТип.Тип.Типы()[0];
		Менеджер = Метаданные.НайтиПоТипу(Тип);
		Если Справочники.ТипВсеСсылки().СодержитТип(Тип) Тогда
			ИмяФормы = "Справочник." + Менеджер.Имя + ".ФормаВыбора";
		ИначеЕсли Документы.ТипВсеСсылки().СодержитТип(Тип) Тогда
			ИмяФормы = "Документ." + Менеджер.Имя + ".ФормаВыбора";
		КонецЕсли;
		
		Возврат ИмяФормы;
	КонецЕсли;
	
КонецФункции

// Обновить подсказки формы в фоне.
//
// Параметры:
//  ДанныеКонтекста			 - Структура - свойства контекста формы,
//                             см. ТорговыеПредложенияКлиент.ДанныеКонтекстаДляПодсказки.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - идентификатор формы.
// 
// Возвращаемое значение:
//  Структура - параметры выполнения фонового задания, см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ОбновитьПодсказкуФормыВФоне(ДанныеКонтекста, УникальныйИдентификатор) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = '1С:Бизнес-сеть. Запрос подсказки торговых предложений'");
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.ДополнительныйРезультат = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("ТорговыеПредложения.ПолучитьПодсказкуПоКонтексту",
		ДанныеКонтекста, ПараметрыВыполнения);
	
КонецФункции

Функция ОтправкаУведомленияОбВыгрузкиДокумента(Знач УникальныйИдентификатор, Знач ДополнительныеПараметры) Экспорт
	
	НаименованиеЗадания = НСтр("ru = '1С:Бизнес-сеть. Отправка документов.'");
	ИмяПроцедуры        = "БизнесСеть.ОтправитьУведомлениеОбОтправке";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ДополнительныеПараметры, ПараметрыВыполнения);
	
КонецФункции

Функция ОрганизацияНеПодключенаТребуетсяПовторноеПодключение(Организация) Экспорт
	Возврат БизнесСеть.ОрганизацияНеПодключенаТребуетсяПовторноеПодключение(Организация);
КонецФункции

#Область QRКоды
	
Функция ОтправлениеИПолучениеQRКодовЧерезБизнесСетьВФоне(Знач УникальныйИдентификатор, Знач ДополнительныеПараметры) Экспорт
	
	НаименованиеЗадания = НСтр("ru = '1С:Бизнес-сеть. Отправка документов и получение QR-кодов.'");
	ИмяПроцедуры        = "БизнесСеть.ОтправитьДокументИПолучитьQRКодЧерезБизнесСеть";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ДополнительныеПараметры, ПараметрыВыполнения);
	
КонецФункции

Функция ПолучениеQRКодовПоДокументамВФоне(Знач УникальныйИдентификатор, Знач ДополнительныеПараметры) Экспорт
	
	НаименованиеЗадания = НСтр("ru = '1С:Бизнес-сеть. Получение QR-кодов по документам.'");
	ИмяПроцедуры        = "БизнесСеть.ПолучитьQRКодыПоДокументам";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ДополнительныеПараметры, ПараметрыВыполнения);
	
КонецФункции

Функция ПолучитьДанныеДокументаПоQRКодуВФоне(Знач УникальныйИдентификатор, Знач ДополнительныеПараметры) Экспорт
	
	НаименованиеЗадания = НСтр("ru = '1С:Бизнес-сеть. Получение документа по QR-коду.'");
	ИмяПроцедуры        = "БизнесСеть.ПолучитьДанныеДокументаПоQRКоду";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ДополнительныеПараметры, ПараметрыВыполнения);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТребуетсяПовторноеПодключениеОрганизации(Организация) Экспорт
	
	Возврат БизнесСеть.ТребуетсяПовторноеПодключениеОрганизации(Организация);
	
КонецФункции

Функция ОрганизацияПодключена(Организация) Экспорт
	
	Возврат БизнесСеть.ОрганизацияПодключена(Организация);
	
КонецФункции

// Возвращает описание длительной операции по обновлению количества новых документов в сервисе.
// См. функцию БизнесСетьКлиент.ОбновитьИнформациюОНовыхДокументахВСервисеАсинхронно.
//
Функция ОбновитьИнформациюОНовыхДокументахВСервисеАсинхронно(Знач ПараметрыОбновления) Экспорт
	
	Возврат БизнесСеть.ОбновитьИнформациюОНовыхДокументахВСервисеАсинхронно(ПараметрыОбновления);
	
КонецФункции

Функция ПодключитьОрганизациюКСервису(Организация, КодАктивации, УникальныйИдентификатор) Экспорт
	
	ПараметрыПоиска = Новый Структура;
	
	ПараметрыПоиска.Вставить("Организация",  Организация);
	ПараметрыПоиска.Вставить("КодАктивации", СокрЛП(КодАктивации));
	
	ПараметрыВыполнения                             = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Подключение организации к Бизнес-сети'");
	ПараметрыВыполнения.ОжидатьЗавершение           = 0;
	ПараметрыВыполнения.ЗапуститьВФоне              = Истина;
	
	ИмяПроцедуры = "БизнесСеть.ПодключитьОрганизациюПоКодуАктивацииВФоне";
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПоиска, ПараметрыВыполнения);
	
КонецФункции

Процедура ПроверитьПодключениеОрганизацийКБизнесСети(Знач СсылкиНаДокументы, НеЗарегистрированныеОрганизации, ДокументыНаОбработку, СписокДокументов = Неопределено) Экспорт
	
	Для Каждого СсылкаНаДокумент Из СсылкиНаДокументы Цикл
		
		РеквизитыДокумента = ОбменСКонтрагентамиИнтеграция.ОписаниеОснованияЭлектронногоДокумента(СсылкаНаДокумент);
		Организация = РеквизитыДокумента.Организация;
		
		// Проверка организации на подключение к сервису БС.
		ОрганизацияЗарегистрирована = БизнесСеть.ОрганизацияПодключена(Организация);
		
		Если Не ОрганизацияЗарегистрирована Тогда
			СписокОрганизаций = Новый Массив;
			СписокОрганизаций.Добавить(Организация);
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НеЗарегистрированныеОрганизации, СписокОрганизаций, Истина);
			Продолжить;
		КонецЕсли;
		
		ДанныеДокумента = БизнесСетьКлиентСервер.ДанныеДокументаДляПолученияQRКода(СсылкаНаДокумент, Организация);
		
		ДокументыНаОбработку.Добавить(ДанныеДокумента);
		
		Если СписокДокументов <> Неопределено Тогда
			СписокДокументов.Добавить(СсылкаНаДокумент);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти