#Область ОписаниеПеременных

&НаКлиенте
Перем ЗакрытиеРазрешено;

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УИДПользователяИБ = ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор;
	Исполнитель = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", Новый УникальныйИдентификатор(УИДПользователяИБ));
	
	ТипСкладскойЯчейкиПриемка  = Перечисления.ТипыСкладскихЯчеек.Приемка;
	ТипСкладскойЯчейкиОтгрузка = Перечисления.ТипыСкладскихЯчеек.Отгрузка;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИспользоватьПодключаемоеОборудование = Истина;
	ПодключитьОбработчикОжидания("МеханизмВнешнегоОборудования", 5, Истина);
	
	ПерейтиВРаздел(Элементы.ПриемкаМеню);
	СформироватьПредставлениеОтбораСклад();
	СформироватьПредставлениеОтбораПомещение();
	
	ОбновитьФормуСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	#Если МобильныйКлиент Тогда
		Если ЗавершениеРаботы Тогда
			ТекстПредупреждения = НСтр("ru = 'Закрыть приложение?'");
			Отказ = Истина;
		ИначеЕсли ЗакрытиеРазрешено=Неопределено Тогда
			Режим = РежимДиалогаВопрос.ДаНет;
			Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтотОбъект, Параметры);
			ПоказатьВопрос(Оповещение, НСтр("ru = 'Закрыть приложение?'"), Режим, 0);
			
			Отказ = Истина;
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура МенюПриемка(Команда)
	ПерейтиВРаздел(Элементы.ПриемкаМеню);
КонецПроцедуры

&НаКлиенте
Процедура МенюОтгрузка(Команда)
	ПерейтиВРаздел(Элементы.ОтгрузкаМеню);
КонецПроцедуры

&НаКлиенте
Процедура МенюПрочиеОперации(Команда)
	ПерейтиВРаздел(Элементы.ПрочиеОперацииМеню);
КонецПроцедуры

&НаКлиенте
Процедура МенюОтчеты(Команда)
	ПерейтиВРаздел(Элементы.ОтчетыМеню);
КонецПроцедуры

&НаКлиенте
Процедура МенюНастройки(Команда)
	ПерейтиВРаздел(Элементы.НастройкиМеню);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФорму(Команда)
	
	ОбновитьФормуСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспоряженияПриемка(Команда)
	
	Описание = Новый ОписаниеОповещения("ОбновитьФормуСервер", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.РаспоряженияНаПриемку",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура Приемка(Команда)
	
	Описание = Новый ОписаниеОповещения("ОбновитьФормуСервер", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ПараметрыФормы.Вставить("Исполнитель", Исполнитель);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СписокПриходныхОрдеров",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура Разместить(Команда)
	
	Описание = Новый ОписаниеОповещения("ОбновитьФормуСервер", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ПараметрыФормы.Вставить("ЗонаПриемки", ЗонаПриемки);
	ПараметрыФормы.Вставить("Исполнитель", Исполнитель);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.ТоварыКРазмещениюПоЯчейкам", ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданияНаРазмещение(Команда)
	
	Описание = Новый ОписаниеОповещения("ОбновитьФормуСервер", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ПараметрыФормы.Вставить("Исполнитель", Исполнитель);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СписокЗаданийНаРазмещение",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура РаспоряженияОтгрузка(Команда)
	
	Описание = Новый ОписаниеОповещения("ОбновитьФормуСервер", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.РаспоряженияНаОтгрузку",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура Отгрузка(Команда)
	
	Описание = Новый ОписаниеОповещения("ОбновитьФормуСервер", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ПараметрыФормы.Вставить("Исполнитель", Исполнитель);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СписокРасходныхОрдеров",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИзЯчеек(Команда)
	
	Описание = Новый ОписаниеОповещения("ОбновитьФормуСервер", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ПараметрыФормы.Вставить("Исполнитель", Исполнитель);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СписокЗаданийНаОтбор",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура Перемещение(Команда)
	Описание = Новый ОписаниеОповещения("ОбновитьФормуСервер", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ПараметрыФормы.Вставить("Исполнитель", Исполнитель);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СписокЗаданийНаПеремещение",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);

КонецПроцедуры

&НаКлиенте
Процедура Пересчет(Команда)
	Описание = Новый ОписаниеОповещения("ОбновитьФормуСервер", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ПараметрыФормы.Вставить("Исполнитель", Исполнитель);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СписокПересчетов",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
КонецПроцедуры

&НаКлиенте
Процедура БлокировкаЯчеек(Команда)
	
	Описание = Новый ОписаниеОповещения("ОбновитьФормуСервер", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СписокБлокировок",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискТовара(Команда)
	
	СтандартнаяОбработка = Ложь;
	
	Описание = Новый ОписаниеОповещения("РезультатПоискаНоменклатуры", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипПоиска", "ПоискНоменклатуры");
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СканированиеШтрихкода",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПоискаНоменклатуры(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Номенклатура", Результат.Номенклатура);
	ПараметрыФормы.Вставить("Характеристика", Результат.Характеристика);
	ПараметрыФормы.Вставить("Упаковка", Результат.Упаковка);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.ПоискПоТовару",ПараметрыФормы,
	ЭтаФорма,,,,,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура Выйти(Команда)
	ЗавершитьРаботуСистемы(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОтборыОткрытьСклад(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", Ложь);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", Истина);
		
	ОткрытьФорму(
		"Справочник.Склады.Форма.ФормаВыбора",
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыОткрытьПомещение(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", Ложь);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	
	Отбор = Новый Структура();
	Отбор.Вставить("Владелец", Склад);
	
	ПараметрыОткрытияФормы.Вставить("Отбор", Отбор);
		
	ОткрытьФорму(
		"Справочник.СкладскиеПомещения.Форма.ФормаВыбора",
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыОчиститьСклад(Команда)
	
	Склад     = Неопределено;
	Помещение = Неопределено;
	СформироватьПредставлениеОтбораСклад();
	СформироватьПредставлениеОтбораПомещение();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыОчиститьПомещение(Команда)

	Помещение = Неопределено;
	ЗонаПриемки  = Неопределено;
	ЗонаОтгрузки = Неопределено;
	СформироватьПредставлениеОтбораПомещение();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура МеханизмВнешнегоОборудования()
	
	// МеханизмВнешнегоОборудования
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(
	Новый ОписаниеОповещения("НачатьПодключениеОборудованиеПриОткрытииФормыЗавершение", ЭтотОбъект),
	ЭтотОбъект,
	"СканерШтрихкода");
	// Конец МеханизмВнешнегоОборудования
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьПодключениеОборудованиеПриОткрытииФормыЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт

	Если НЕ РезультатВыполнения.Результат Тогда
		
		ПриОшибкеПодключенияОборудованияНаСервере(РезультатВыполнения.ОписаниеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриОшибкеПодключенияОборудованияНаСервере(ОписаниеОшибки)
	
	СообщениеПользователю = Новый СообщениеПользователю;
	СообщениеПользователю.Текст = ОписаниеОшибки;
	СообщениеПользователю.Сообщить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФормуСервер(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОбновитьСчетчикиСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСчетчикиСервер()
	
	Если Элементы.Разделы.ТекущаяСтраница = Элементы.РазделПриемка Тогда
		СчетчикиРазделПриемка();
	ИначеЕсли Элементы.Разделы.ТекущаяСтраница = Элементы.РазделОтгрузка Тогда
		СчетчикиРазделОтгрузка();
	ИначеЕсли Элементы.Разделы.ТекущаяСтраница = Элементы.РазделПрочиеОперации Тогда
		СчетчикиРазделПрочиеОперации();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеОтбораСклад()
	
	ПредставленияОтборов = "";
	Если ЗначениеЗаполнено(Склад) Тогда
		ПредставленияОтборов = Склад;
		Элементы.КомандаОтборыОткрыть.ЦветТекста = WebЦвета.Черный;
		Элементы.КомандаОтборыОчистить.Видимость = Истина;
		Элементы.РамкаОтборыОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
	Иначе
		ПредставленияОтборов = НСтр("ru = 'Выбрать склад'");
		Элементы.КомандаОтборыОткрыть.ЦветТекста = WebЦвета.ТемноСерый;
		Элементы.КомандаОтборыОчистить.Видимость = Ложь;
		Элементы.РамкаОтборыОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюСерая;
	КонецЕсли;
	
	Элементы.КомандаОтборыОткрыть.Заголовок = ПредставленияОтборов;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеОтбораПомещение()
	
	ПредставленияОтборов = "";
	Если ЗначениеЗаполнено(Помещение) Тогда
		ПредставленияОтборов = Помещение;
		Элементы.КомандаОтборыОткрытьПомещение.ЦветТекста = WebЦвета.Черный;
		Элементы.КомандаОтборыОчиститьПомещение.Видимость = Истина;
		Элементы.РамкаОтборыОткрыть2.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
	Иначе
		ПредставленияОтборов = НСтр("ru = 'Выбрать помещение'");
		Элементы.КомандаОтборыОткрытьПомещение.ЦветТекста = WebЦвета.ТемноСерый;
		Элементы.КомандаОтборыОчиститьПомещение.Видимость = Ложь;
		Элементы.РамкаОтборыОткрыть2.Картинка = БиблиотекаКартинок.РамкаМенюСерая;
	КонецЕсли;
	
	Элементы.КомандаОтборыОткрытьПомещение.Заголовок = ПредставленияОтборов;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВРаздел(ЭлементМеню)
	
	// Изменение иконки меню
	Элементы.ПриемкаМеню.Картинка        = БиблиотекаКартинок.МРМКладовщикаПриемка;
	Элементы.ОтгрузкаМеню.Картинка       = БиблиотекаКартинок.МРМКладовщикаОтгрузкаСерая;
	Элементы.ПрочиеОперацииМеню.Картинка = БиблиотекаКартинок.МРМКладовщикаПрочиеОперации;
	Элементы.ОтчетыМеню.Картинка         = БиблиотекаКартинок.МРМКладовщикаОтчеты;
	Элементы.НастройкиМеню.Картинка      = БиблиотекаКартинок.МРМКладовщикаНастройки;
	
	// Подсветка меню
	Белый  = WebЦвета.Белый;
	Желтый = WebЦвета.СветлоЗолотистый;
	
	Элементы.ПриемкаМеню.ЦветФона        = Белый;
	Элементы.ОтгрузкаМеню.ЦветФона       = Белый;
	Элементы.ПрочиеОперацииМеню.ЦветФона = Белый;
	Элементы.ОтчетыМеню.ЦветФона         = Белый;
	Элементы.НастройкиМеню.ЦветФона      = Белый;
	
	Элементы.ГруппаПриемкаМеню.ЦветФона        = Белый;
	Элементы.ГруппаОтгрузкаМеню.ЦветФона       = Белый;
	Элементы.ГруппаПрочиеОперацииМеню.ЦветФона = Белый;
	Элементы.ГруппаОтчетыМеню.ЦветФона         = Белый;
	Элементы.ГруппаНастройкиМеню.ЦветФона      = Белый;
	
	Если ЭлементМеню = Элементы.ПриемкаМеню Тогда
		Элементы.Разделы.ТекущаяСтраница    = Элементы.РазделПриемка;
		ЭлементМеню.Картинка     = БиблиотекаКартинок.МРМКладовщикаПриемкаАктивная;
		Элементы.ГруппаПриемкаМеню.ЦветФона = Желтый;
		Элементы.ПриемкаМеню.ЦветФона       = Желтый;
	ИначеЕсли ЭлементМеню = Элементы.ОтгрузкаМеню Тогда
		Элементы.Разделы.ТекущаяСтраница     = Элементы.РазделОтгрузка;
		ЭлементМеню.Картинка     = БиблиотекаКартинок.МРМКладовщикаОтгрузкаАктивная;
		Элементы.ГруппаОтгрузкаМеню.ЦветФона = Желтый;
		Элементы.ОтгрузкаМеню.ЦветФона       = Желтый;
	ИначеЕсли ЭлементМеню = Элементы.ПрочиеОперацииМеню Тогда
		Элементы.Разделы.ТекущаяСтраница           = Элементы.РазделПрочиеОперации;
		ЭлементМеню.Картинка     = БиблиотекаКартинок.МРМКладовщикаПрочиеОперацииАктивная;
		Элементы.ГруппаПрочиеОперацииМеню.ЦветФона = Желтый;
		Элементы.ПрочиеОперацииМеню.ЦветФона       = Желтый;
	ИначеЕсли ЭлементМеню = Элементы.ОтчетыМеню Тогда
		Элементы.Разделы.ТекущаяСтраница   = Элементы.РазделОтчеты;
		ЭлементМеню.Картинка     = БиблиотекаКартинок.МРМКладовщикаОтчетыАктивная;
		Элементы.ГруппаОтчетыМеню.ЦветФона = Желтый;
		Элементы.ОтчетыМеню.ЦветФона       = Желтый;
	ИначеЕсли ЭлементМеню = Элементы.НастройкиМеню Тогда
		Элементы.Разделы.ТекущаяСтраница      = Элементы.РазделНастройки;
		ЭлементМеню.Картинка     = БиблиотекаКартинок.МРМКладовщикаНастройкиАктивная;
		Элементы.ГруппаНастройкиМеню.ЦветФона = Желтый;
		Элементы.НастройкиМеню.ЦветФона       = Желтый;
	КонецЕсли;
	
	ОбновитьФормуСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Склады.Форма.ФормаВыбора") Тогда
		
		Склад        = ВыбранноеЗначение;
		Помещение    = Неопределено;
		ЗонаПриемки  = Неопределено;
		ЗонаОтгрузки = Неопределено;
		СформироватьПредставлениеОтбораСклад();
		СформироватьПредставлениеОтбораПомещение();
		
	КонецЕсли;
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.СкладскиеПомещения.Форма.ФормаВыбора") Тогда
		
		Помещение    = ВыбранноеЗначение;
		ЗонаПриемки  = Неопределено;
		ЗонаОтгрузки = Неопределено;
		СформироватьПредставлениеОтбораПомещение();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СформироватьПредставлениеОтбораСклад();
	СформироватьПредставлениеОтбораПомещение(); 
	
	Элементы.ТекущийПользователь.Заголовок = Исполнитель;
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиВЯчейках(Команда)

	СтандартнаяОбработка = Ложь;
	
	Описание = Новый ОписаниеОповещения("РезультатПоискаЯчейки", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипПоиска", "ПоискЯчейки");
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СканированиеШтрихкода",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПоискаЯчейки(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ячейка", Результат);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.ПоискПоЯчейке",ПараметрыФормы,
	ЭтаФорма,,,,,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗакрытиеРазрешено = Истина;
		ЗавершитьРаботуСистемы(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СчетчикиРазделПриемка()
	
	// Распоряжения на приемку
	#Если НЕ МобильныйАвтономныйСервер Тогда
	СостояниеПоступления = Перечисления.СостоянияПоступленияТоваров.ОжидаетсяПриемка;
	Запрос = Обработки.МобильноеРабочееМестоКладовщика.РаспоряженияНаПриемку(Склад, ТекущаяДатаСеанса(), СостояниеПоступления);
	Таблица = Запрос.Выполнить().Выгрузить();
	Элементы.РаспоряженияПриемка1.Заголовок = Таблица.Количество();
	#Иначе
	Элементы.РаспоряженияПриемка1.Заголовок = 0;
	#КонецЕсли
	
	// Приходные ордера
	#Если НЕ МобильныйАвтономныйСервер Тогда
	Запрос = Обработки.МобильноеРабочееМестоКладовщика.СписокПриходныхОрдеров();
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Если ЗначениеЗаполнено(Помещение) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПомещение", "И ПриходныйОрдерНаТовары.Помещение = &Помещение");
		Запрос.УстановитьПараметр("Помещение", Помещение);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПомещение", "");
	КонецЕсли;
	
	МассивИсполнителей = Новый Массив;
	МассивИсполнителей.Добавить(Исполнитель);
	МассивИсполнителей.Добавить(Справочники.Пользователи.ПустаяСсылка());
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеИсполнитель", "И ПриходныйОрдерНаТовары.Исполнитель В(&Исполнитель)");
	Запрос.УстановитьПараметр("Исполнитель", МассивИсполнителей);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеСтатус", "И ПриходныйОрдерНаТовары.Статус = &Статус");
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыПриходныхОрдеров.КПоступлению);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Элементы.Приемка1.Заголовок = Таблица.Количество();
	#Иначе
	Элементы.Приемка1.Заголовок = 0;
	#КонецЕсли
	
	// Товары к размещению по ячейкам
	#Если НЕ МобильныйАвтономныйСервер Тогда
	Запрос = Обработки.МобильноеРабочееМестоКладовщика.ТоварыКРазмещениюПоЯчейкам();
	Запрос.УстановитьПараметр("ЗонаПриемки", ЗонаПриемки);
	Таблица = Запрос.Выполнить().Выгрузить();
	Элементы.Размещение1.Заголовок = Таблица.Количество();
	#Иначе
	Элементы.Размещение1.Заголовок = 0;
	#КонецЕсли
	
	// Список заданий на размещение
	#Если НЕ МобильныйАвтономныйСервер Тогда
	Запрос = Обработки.МобильноеРабочееМестоКладовщика.СписокЗаданийНаРазмещение();
	
	Запрос.УстановитьПараметр("ЗонаПриемки", ЗонаПриемки);
	
	МассивИсполнителей = Новый Массив;
	МассивИсполнителей.Добавить(Исполнитель);
	МассивИсполнителей.Добавить(Справочники.Пользователи.ПустаяСсылка());
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеИсполнитель", "И ДокументОтборРазмещениеТоваров.Исполнитель В(&Исполнитель)");
	Запрос.УстановитьПараметр("Исполнитель", МассивИсполнителей);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеСтатус", "И ДокументОтборРазмещениеТоваров.Статус = &Статус");
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыОтборовРазмещенийТоваров.Подготовлено);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Элементы.Размещение3.Заголовок = Таблица.Количество();
	#Иначе
	Элементы.Размещение3.Заголовок = 0;
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура СчетчикиРазделОтгрузка()
	
	// Распоряжения на отгрузку
	#Если НЕ МобильныйАвтономныйСервер Тогда
	Запрос = Обработки.МобильноеРабочееМестоКладовщика.СписокРаспоряженийНаОтгрузку(Склад);
	
	ДатаОтгрузки = ТекущаяДатаСеанса();
	
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ЗаданиеНаПеревозку", Документы.ЗаданиеНаПеревозку.ПустаяСсылка());
	Запрос.УстановитьПараметр("ДатаОтгрузки", ?(ЗначениеЗаполнено(ДатаОтгрузки), КонецДня(ДатаОтгрузки) + 1, ДатаОтгрузки));
	ОформлятьСначалаНакладные = Константы.ПорядокОформленияНакладныхРасходныхОрдеров.Получить() = Перечисления.ПорядокОформленияНакладныхРасходныхОрдеров.СначалаНакладные;
	Запрос.УстановитьПараметр("ОформлятьСначалаНакладные", ОформлятьСначалаНакладные);
	Запрос.УстановитьПараметр("ОтображениеДеталейОтгрузка", Ложь);
	
	Состояния = Новый Массив;
	Состояния.Добавить(Перечисления.СостоянияОтбораТоваров.ОжидаетсяОтбор);
	Запрос.УстановитьПараметр("Состояния", Состояния);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Элементы.РаспоряженияОтгрузка1.Заголовок = Таблица.Количество();
	#Иначе
	Элементы.РаспоряженияОтгрузка1.Заголовок = 0;
	#КонецЕсли
	
	// Расходные ордера
	#Если НЕ МобильныйАвтономныйСервер Тогда
	Запрос = Обработки.МобильноеРабочееМестоКладовщика.СписокРасходныхОрдеров();
	
	Запрос.УстановитьПараметр("Склад", Склад);
	ИспользоватьСтатусыРасходныхОрдеров = ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыРасходныхОрдеров", Новый Структура("Склад", Склад));
	
	Если ЗначениеЗаполнено(Помещение) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПомещение", "И РасходныйОрдерНаТовары.Помещение = &Помещение");
		Запрос.УстановитьПараметр("Помещение", Помещение);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПомещение", "");
	КонецЕсли;
	
	Если ИспользоватьСтатусыРасходныхОрдеров Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеСтатус", "И РасходныйОрдерНаТовары.Статус = &Статус");
		Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыРасходныхОрдеров.КОтбору);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеСтатус", "");
	КонецЕсли;
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Элементы.Отгрузка1.Заголовок = Таблица.Количество();
	#Иначе
	Элементы.Отгрузка1.Заголовок = 0;
	#КонецЕсли
	
	// Список заданий на отбор
	#Если НЕ МобильныйАвтономныйСервер Тогда
	Запрос = Обработки.МобильноеРабочееМестоКладовщика.СписокЗаданийНаОтбор();
	
	Запрос.УстановитьПараметр("ЗонаОтгрузки", ЗонаОтгрузки);
	
	МассивИсполнителей = Новый Массив;
	МассивИсполнителей.Добавить(Исполнитель);
	МассивИсполнителей.Добавить(Справочники.Пользователи.ПустаяСсылка());
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеИсполнитель", "И ДокументОтборРазмещениеТоваров.Исполнитель В (&Исполнитель)");
	Запрос.УстановитьПараметр("Исполнитель", МассивИсполнителей);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеСтатус", "И ДокументОтборРазмещениеТоваров.Статус = &Статус");
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыОтборовРазмещенийТоваров.Подготовлено);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Элементы.ОтборИзЯчеек1.Заголовок = Таблица.Количество();
	#Иначе
	Элементы.ОтборИзЯчеек1.Заголовок = 0;
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура СчетчикиРазделПрочиеОперации()
	
	// Список заданий на перемещение
	#Если НЕ МобильныйАвтономныйСервер Тогда
	Запрос = Обработки.МобильноеРабочееМестоКладовщика.СписокЗаданийНаПеремещение();
	
	МассивИсполнителей = Новый Массив;
	МассивИсполнителей.Добавить(Исполнитель);
	МассивИсполнителей.Добавить(Справочники.Пользователи.ПустаяСсылка());
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеИсполнитель", "И ДокументОтборРазмещениеТоваров.Исполнитель В (&Исполнитель)");
	Запрос.УстановитьПараметр("Исполнитель", МассивИсполнителей);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеСтатус", "И ДокументОтборРазмещениеТоваров.Статус = &Статус");
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыОтборовРазмещенийТоваров.Подготовлено);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Элементы.Перемещение1.Заголовок = Таблица.Количество();
	#Иначе
	Элементы.Перемещение1.Заголовок = 0;
	#КонецЕсли
	
	// Список пересчетов
	#Если НЕ МобильныйАвтономныйСервер Тогда
	Запрос = Обработки.МобильноеРабочееМестоКладовщика.СписокПересчетов();
	
	МассивИсполнителей = Новый Массив;
	МассивИсполнителей.Добавить(Исполнитель);
	МассивИсполнителей.Добавить(Справочники.Пользователи.ПустаяСсылка());
	
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеИсполнитель", "И ПересчетТоваров.Исполнитель В (&Исполнитель)");
	Запрос.УстановитьПараметр("Исполнитель", МассивИсполнителей);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеСтатус", "И ДокументОтборРазмещениеТоваров.Статус = &Статус");
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыПересчетовТоваров.ВнесениеРезультатов);
	
	Если ЗначениеЗаполнено(Помещение) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПомещение", "И ПересчетТоваров.Помещение = &Помещение");
		Запрос.УстановитьПараметр("Помещение", Помещение);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПомещение", "");
	КонецЕсли;
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Элементы.Пересчет1.Заголовок = Таблица.Количество();
	#Иначе
	Элементы.Пересчет1.Заголовок = 0;
	#КонецЕсли
	
	// Список блокировок
	#Если НЕ МобильныйАвтономныйСервер Тогда
	Запрос = Обработки.МобильноеРабочееМестоКладовщика.СписокБлокировок();
	
	Если НЕ Помещение.Пустая() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПомещение", "И БлокировкиСкладскихЯчеек.Ячейка.Помещение = &Помещение");
		Запрос.УстановитьПараметр("Помещение", Помещение);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПомещение", "");
	КонецЕсли;

	Запрос.УстановитьПараметр("Склад", Склад);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Элементы.БлокировкаЯчеек1.Заголовок = Таблица.Количество();
	#Иначе
	Элементы.БлокировкаЯчеек1.Заголовок = 0;
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

