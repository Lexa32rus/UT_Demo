////////////////////////////////////////////////////////////////////////////////////////
// СопоставлениеНоменклатурыКонтрагентовКлиентПереопределяемый: 
// механизм сопоставления номенклатуры контрагентов с номенклатурой информационной базы.
//
////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПереопределяемыеКоманды_НоменклатурыКонтрагентов

// Выполняет подключаемую переопределяемую команду для форм  справочника НоменклатураКонтрагентов.
//
// Параметры:
//  Форма   - ФормаКлиентскогоПриложения - форма, в которой расположена команда.
//  Команда - КомандаФормы               - команда формы.
//
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду_НоменклатурыКонтрагентов(Форма, Команда) Экспорт
	
	//++ НЕ ГОСИС
	НоменклатураПартнеровКлиент.Подключаемый_ВыполнитьПереопределяемуюКоманду_НоменклатурыКонтрагентов(Форма, Команда);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Выполняет подключаемую переопределяемую команду интеграции для форм справочника НоменклатураКонтрагентов.
//
// Параметры:
//  Форма    - ФормаКлиентскогоПриложения                 - форма, в которой расположена команда.
//  Команда  - КомандаФормы                               - команда формы.
//  Источник - ДанныеФормыСтруктура, ДанныеФормыКоллекция - данные, уточняющие параметр команды.
//
Процедура Подключаемый_ВыполнитьКомандуИнтеграции_НоменклатурыКонтрагентов(Форма, Команда, Источник) Экспорт
	
	//++ НЕ ГОСИС
	НоменклатураПартнеровКлиент.Подключаемый_ВыполнитьКомандуИнтеграции_НоменклатурыКонтрагентов(
		Форма, Команда, Источник);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#Область РаботаСФайлами

// См. РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов_НоменклатурыКонтрагентов(Форма, Команда) Экспорт

	//++ НЕ ГОСИС
	НоменклатураПартнеровКлиент.Подключаемый_КомандаПанелиПрисоединенныхФайлов_НоменклатурыКонтрагентов(
		Форма, Команда);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// См. РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания_НоменклатурыКонтрагентов(Форма,
																						Элемент,
																						ПараметрыПеретаскивания,
																						СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	НоменклатураПартнеровКлиент.Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания_НоменклатурыКонтрагентов(
		Форма, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// См. РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание_НоменклатурыКонтрагентов(Форма, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	НоменклатураПартнеровКлиент.Подключаемый_ПолеПредпросмотраПеретаскивание_НоменклатурыКонтрагентов(
		Форма, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// См. РаботаСФайламиКлиент.ПолеПредпросмотраНажатие
Процедура Подключаемый_ПолеПредпросмотраНажатие_НоменклатурыКонтрагентов(Форма, Элемент, СтандартнаяОбработка) Экспорт

	//++ НЕ ГОСИС
	НоменклатураПартнеровКлиент.Подключаемый_ПолеПредпросмотраНажатие_НоменклатурыКонтрагентов(
		Форма, Элемент, СтандартнаяОбработка);
	//-- НЕ ГОСИС 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий_ФормыНоменклатурыКонтрагентов

// Обработчик события "ПослеЗаписи" формы элемента справочника НоменклатураКонтрагентов.
//
// Параметры:
//  Форма           - ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
//  ПараметрыЗаписи - Структура                  - содержит параметры записи.
//
Процедура ПослеЗаписи_ФормаЭлементаНоменклатурыКонтрагентов(Форма, ПараметрыЗаписи) Экспорт
	
	//++ НЕ ГОСИС
	НоменклатураПартнеровКлиент.ПослеЗаписи_ФормаЭлементаНоменклатурыКонтрагентов(Форма, ПараметрыЗаписи);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Обработчик события "ПриОткрытии" формы элемента справочника НоменклатураКонтрагентов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
//  Отказ - Булево                     - признак отказа от создания формы.
//
Процедура ПриОткрытии_ФормаЭлементаНоменклатурыКонтрагентов(Форма, Отказ) Экспорт
	
	//++ НЕ ГОСИС
	НоменклатураПартнеровКлиент.ПриОткрытии_ФормаЭлементаНоменклатурыКонтрагентов(Форма, Отказ);
	//-- НЕ ГОСИС

КонецПроцедуры

// Обработчик события "ОбработкаОповещения" формы элемента справочника НоменклатураКонтрагентов.
// 
// Параметры:
//  Форма      - ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
//  ИмяСобытия - Строка                     - имя события обработки оповещения.
//  Параметр   - Произвольный               - параметр, переданный в сообщении
//  Источник   - Произвольный               - источник события, переданный в сообщении.
//
Процедура ОбработкаОповещения_ФормаЭлементаНоменклатурыКонтрагентов(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	//++ НЕ ГОСИС
	НоменклатураПартнеровКлиент.ОбработкаОповещения_ФормаЭлементаНоменклатурыКонтрагентов(Форма, ИмяСобытия, Параметр, Источник);
	//-- НЕ ГОСИС

КонецПроцедуры

#КонецОбласти

#Область РаботаСФормамиОбъектовИБ

//++ Локализация

// Выполняется при создании номенклатуры информационной базы по данным контрагента.
//
// Параметры:
//  НаборНоменклатурыКонтрагентов - Массив - номенклатура контрагентов, по которой нужно создать номенклатуру информационной базы.
//                                           См. СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НоваяНоменклатураКонтрагента.
//  ОповещениеОЗавершении - ОписаниеОповещения - 
//   оповещение, которое нужно выполнить после создания номенклатуры с результатом, представляющим массив структур со свойствами:
//   * НоменклатураКонтрагента - Структура - элемент из параметра НаборНоменклатурыКонтрагентов, для которого удалось создать номенклатуру.
//   * НоменклатураИБ - Структура - описание созданной номенклатуры. См. СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НоваяНоменклатураИнформационнойБазы.
//  СтандартнаяОбработка - Булево - если метод реализован, то необходимо установить значение Ложь.
//
Процедура ПриСозданииНоменклатурыПоДаннымКонтрагента(Знач НаборНоменклатурыКонтрагентов, Знач ОповещениеОЗавершении, СтандартнаяОбработка = Истина) Экспорт
	
	//++ НЕ ГОСИС
	НоменклатураПартнеровКлиент.ПриСозданииНоменклатурыПоДаннымКонтрагента(НаборНоменклатурыКонтрагентов, ОповещениеОЗавершении, СтандартнаяОбработка);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Открывает форму элемента номенклатуры информационной базы.
//
// Параметры:
//  Параметры - Структура - параметры формы.
//  Владелец - ФормаКлиентскогоПриложения - владелец формы.
//  Уникальность - Произвольный - ключ уникальности формы.
//  ОповещениеОЗакрытии - ОписаниеОповещения - описание оповещения о закрытии, с которым нужно открыть форму.
//
// Пример:
//  ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", Параметры, Владелец, Уникальность);
//
Процедура ОткрытьФормуНоменклатуры(Знач Параметры, Знач Владелец, Знач Уникальность, Знач ОповещениеОЗакрытии) Экспорт
	
	//++ НЕ ГОСИС
	НоменклатураПартнеровКлиент.ОткрытьФормуНоменклатуры(Параметры, Владелец, Уникальность, ОповещениеОЗакрытии);
	//-- НЕ ГОСИС
	
КонецПроцедуры

//-- Локализация

// Открывает форму выбора элемента номенклатуры информационной базы.
//
// Параметры:
//  Параметры - Структура - параметры формы.
//  Владелец - ФормаКлиентскогоПриложения - владелец формы.
//  Уникальность - Произвольный - ключ уникальности формы.
//
// Пример:
//  ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", Параметры, Владелец, Уникальность);
//
Процедура ОткрытьФормуВыбораНоменклатуры(Знач Параметры, Знач Владелец, Знач Уникальность) Экспорт
	
	//++ НЕ ГОСИС
	НоменклатураПартнеровКлиент.ОткрытьФормуВыбораНоменклатуры(Параметры, Владелец, Уникальность);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
