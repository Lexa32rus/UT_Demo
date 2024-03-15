#Область ПрограммныйИнтерфейс

#Область Локализация

Процедура МодификацияРеквизитовФормы(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты) Экспорт
	
	ДобавитьОбщиеНастройкиВстраивания(Форма, ПараметрыИнтеграции);
	СобытияФормЕГАИСПереопределяемый.МодификацияРеквизитовФормы(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты);
	ДобавитьРеквизитыИнтеграцииЕГАИС(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты);
	
КонецПроцедуры

Процедура МодификацияЭлементовФормы(Форма) Экспорт
	
	СобытияФормИС.ВстроитьСтрокуИнтеграцииВДокументОснованиеПоПараметрам(Форма, "ЕГАИС.ДокументОснование");
	
КонецПроцедуры

Процедура ЗаполнениеРеквизитовФормы(Форма) Экспорт
	
	СобытияФормЕГАИСПереопределяемый.ЗаполнениеРеквизитовФормы(Форма);
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма) Экспорт
	
	СобытияФормЕГАИСПереопределяемый.ПослеЗаписиНаСервере(Форма);
	
КонецПроцедуры

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	СобытияФормЕГАИСПереопределяемый.ПриЧтенииНаСервере(Форма, ТекущийОбъект);
	
КонецПроцедуры

// Обработчик команды формы, требующей контекстного вызова сервера.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, из которой выполняется команда.
//   ПараметрыВызова - Структура - параметры вызова.
//   Источник - ТаблицаФормы, ДанныеФормыСтруктура - объект или список формы с полем "Ссылка".
//   Результат - Структура - результат выполнения команды.
//
Процедура ВыполнитьПереопределяемуюКоманду(Знач Форма, Знач ПараметрыВызова, Знач Источник, Результат) Экспорт
	
	СобытияФормЕГАИСПереопределяемый.ВыполнитьПереопределяемуюКоманду(Форма, ПараметрыВызова, Источник, Результат);
	
КонецПроцедуры

#Область СобытияЭлементовФорм

// Серверная переопределяемая процедура, вызываемая из обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Строка           - имя элемента-источника события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	СобытияФормЕГАИСПереопределяемый.ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ДокументыЕГАИС

// Устанавливает оформление колонок количества как целое число для упакованной алкогольной продукции
//
// Параметры:
//   Форма                      - ФормаКлиентскогоПриложения - источник вызова
//   ПолеНеупакованнаяПродукция - Строка           - путь к данным значения "Неупакованная продукция"
//   ПоляКоличество             - Строка           - путь к реквизитам количества (через запятую)
//
Процедура УстановитьУсловноеОформлениеПоляКоличество(Форма, ПолеНеупакованнаяПродукция, Знач ПоляКоличество) Экспорт
	
	ПоляКоличество = СтрРазделить(ПоляКоличество, ",", Ложь);
	
	ЭлементОформления = Форма.УсловноеОформление.Элементы.Добавить();
	
	ЭлементОформления.Использование = Истина;
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Формат", "ЧДЦ=0;");
	
	Для Каждого ПолеКОформлению Из ПоляКоличество Цикл
		ЭлементОформления.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(СокрЛП(ПолеКОформлению));
	КонецЦикла;
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПолеНеупакованнаяПродукция);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
КонецПроцедуры

// Устанавливает оформление колонок количества как целое число для упакованной алкогольной продукции. Для поля 
//    "Количество упаковок" выполняется дополнительная проверка (на совпадение с полем "Количество")
//
// Параметры:
//   Форма                      - ФормаКлиентскогоПриложения - источник вызова
//   ПолеНеупакованнаяПродукция - Строка           - путь к данным значения "Неупакованная продукция"
//   ПоляКоличество             - Строка           - путь к реквизитам количества (через запятую)
//
Процедура УстановитьУсловноеОформлениеПоляКоличествоСУчетомУпаковок(Форма, ПолеНеупакованнаяПродукция, Знач ПоляКоличество = "") Экспорт
	
	УстановитьУсловноеОформлениеПоляКоличество(Форма, ПолеНеупакованнаяПродукция, ПоляКоличество);
	
	ЭлементОформления = Форма.УсловноеОформление.Элементы.Добавить();
	
	ЭлементОформления.Использование = Истина;
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Формат", "ЧДЦ=0;");
	ЭлементОформления.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ТоварыКоличествоУпаковок");
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПолеНеупакованнаяПродукция);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.Товары.Количество");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.Товары.КоличествоУпаковок");
	
КонецПроцедуры

// Округляет вниз количество для упакованной алкогольной продукции до целого. Для поля 
//    "Количество упаковок" выполняется дополнительная проверка (на совпадение с полем "Количество")
// 
// Параметры:
//   ДанныеСтроки               - ДанныеФормыСтруктура - редактируемая строка
//   ПолеНеупакованнаяПродукция - Строка               - реквизит "Неупакованная продукция"
//   ПоляКоличество             - Строка               - реквизиты к округлению (через запятую)
//
Процедура ОкруглитьКоличествоДляУпакованнойПродукцииСУчетомУпаковок(ДанныеСтроки, ПолеНеупакованнаяПродукция, Знач ПоляКоличество) Экспорт
	
	Если НЕ ДанныеСтроки[ПолеНеупакованнаяПродукция] Тогда
		Если ДанныеСтроки.Количество = ДанныеСтроки.КоличествоУпаковок Тогда
			ДанныеСтроки.КоличествоУпаковок = Цел(ДанныеСтроки.КоличествоУпаковок);
		КонецЕсли;
	КонецЕсли;
	
	ОкруглитьКоличествоДляУпакованнойПродукции(ДанныеСтроки, ПолеНеупакованнаяПродукция, ПоляКоличество);
	
КонецПроцедуры

// Округляет вниз количество для упакованной алкогольной продукции до целого
// 
// Параметры:
//   ДанныеСтроки               - ДанныеФормыСтруктура - редактируемая строка
//   ПолеНеупакованнаяПродукция - Строка               - реквизит "Неупакованная продукция"
//   ПоляКоличество             - Строка               - реквизиты к округлению (через запятую)
//
Процедура ОкруглитьКоличествоДляУпакованнойПродукции(ДанныеСтроки, ПолеНеупакованнаяПродукция, Знач ПоляКоличество) Экспорт
	
	Если НЕ ДанныеСтроки[ПолеНеупакованнаяПродукция] Тогда
		ПоляКоличество = СтрРазделить(ПоляКоличество, ",", Ложь);
		Для Каждого ПолеКоличества Из ПоляКоличество Цикл
			ДанныеСтроки[ПолеКоличества] = Цел(ДанныеСтроки[ПолеКоличества]);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьОбщиеНастройкиВстраивания(Форма, ПараметрыИнтеграции)
	
	ОбщиеНастройки = СобытияФормИС.ОбщиеПараметрыИнтеграции("СобытияФормЕГАИС");
	ПараметрыИнтеграции.Вставить("ЕГАИС", ОбщиеНастройки);
	
КонецПроцедуры

// Встраивает реквизит - форматированную строку перехода к ЕГАИС в прикладные формы
// 
// Параметры:
//   Форма                - ФормаКлиентскогоПриложения - форма в которую происходит встраивание
//   ПараметрыИнтеграции  - Структура        - (См. ПараметрыИнтеграцииЕГАИС)
//   ДобавляемыеРеквизиты - Массив           - массив реквизитов формы к добавлению

Процедура ДобавитьРеквизитыИнтеграцииЕГАИС(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты)
	
	ПараметрыИнтеграцииЕГАИС = ПараметрыИнтеграцииЕГАИС(Форма);
	
	Если ЗначениеЗаполнено(ПараметрыИнтеграцииЕГАИС.ИмяРеквизитаФормы) Тогда
		ПараметрыИнтеграции.Вставить("ЕГАИС.ДокументОснование", ПараметрыИнтеграцииЕГАИС);
		Реквизит = Новый РеквизитФормы(
			ПараметрыИнтеграцииЕГАИС.ИмяРеквизитаФормы,
			Новый ОписаниеТипов("ФорматированнаяСтрока"),,
			ПараметрыИнтеграцииЕГАИС.Заголовок);
		ДобавляемыеРеквизиты.Добавить(Реквизит);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру, заполненную значениями по умолчанию, используемую для интеграции реквизитов ЕГАИС
//   в прикладные формы конфигурации - потребителя библиотеки ГосИС. Если передана форма - сразу заполняет ее
//   специфику в переопределяемом модуле.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения, Неопределено - форма для которой возвращаются параметры интеграции
//
// ВозвращаемоеЗначение:
//   Структура - (См. СобытияФормИС.ПараметрыИнтеграцииДляДокументаОснования).
//
Функция ПараметрыИнтеграцииЕГАИС(Форма = Неопределено)
	
	ПараметрыНадписи = СобытияФормИС.ПараметрыИнтеграцииДляДокументаОснования();
	ПараметрыНадписи.Вставить("Ключ",                       "ЗаполнениеТекстаДокументаЕГАИС");
	ПараметрыНадписи.Вставить("ИмяЭлементаФормы",           "ТекстДокументаЕГАИС");
	ПараметрыНадписи.Вставить("ИмяРеквизитаФормы",          "ТекстДокументаЕГАИС");
	
	Если НЕ(Форма = Неопределено) Тогда
		СобытияФормЕГАИСПереопределяемый.ПриОпределенииПараметровИнтеграцииЕГАИС(Форма, ПараметрыНадписи);
	КонецЕсли;
	
	Возврат ПараметрыНадписи;
	
КонецФункции

#КонецОбласти

