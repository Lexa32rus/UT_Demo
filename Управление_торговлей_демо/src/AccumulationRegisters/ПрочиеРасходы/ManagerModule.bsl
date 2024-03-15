#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет показатели регистра.
//
//
// Параметры:
//  Свойства - Структура - содержащая ключи СвойстваПоказателей, СвойстваРесурсов.
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя показателя.
//                 Значение - структура свойств показателя.
//
Функция Показатели(Свойства) Экспорт

	Показатели = Новый Соответствие;
	
	СвойстваПоказателей = Свойства.СвойстваПоказателей;
	СвойстваРесурсов = Свойства.СвойстваРесурсов;
	
	МассивРесурсов = Новый Массив;
    МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "Сумма", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаРегл", "ВалютаРегл"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.Сумма, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "Сумма", "ВалютаУпр"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаУпрСНДС, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	Возврат Показатели;
	
КонецФункции

// Возвращает текст запроса с типовой структурой временной таблицы "ВтИсходныеПрочиеРасходы".
//
// Параметры:
//  ДополнительныеПоля	 - Строка	 - Список дополнительный полей.
// 
// Возвращаемое значение:
//  Строка - Текст запроса формирования временной таблицы ВтИсходныеПрочиеРасходы.
//
Функция ТекстОписаниеВтИсходныеПрочиеРасходы(ДополнительныеПоля = "") Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ ПЕРВЫЕ 0
	|	Строки.Период,
	|	Строки.ВидДвижения,
	|	Строки.Организация,
	|	Строки.Подразделение,
	|	Строки.СтатьяРасходов,
	|	Строки.АналитикаРасходов,
	|	Строки.НаправлениеДеятельности,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК ВидДеятельностиНДС,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаБезНДС,
	|	0 КАК СуммаБезНДСУпр,
	|	0 КАК СуммаСНДСРегл,
	|	0 КАК СуммаБезНДСРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|	Строки.ХозяйственнаяОперация,
	|	Строки.АналитикаУчетаНоменклатуры,
	|	
	|	Строки.ИдентификаторФинЗаписи         КАК ИдентификаторФинЗаписи,
	|	Строки.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации
	|	
	|	,&ДополнительныеПоля
	|
	|ПОМЕСТИТЬ ВтИсходныеПрочиеРасходы
	|ИЗ
	|	РегистрНакопления.ПрочиеРасходы КАК Строки
	|";
	
	ДобавитьДополнительныеПоляВТекстЗапроса(ДополнительныеПоля, ТекстЗапроса);
	
	Возврат ТекстЗапроса
	
КонецФункции

// Формирует текст запроса для формирования временной таблицы "ВтПрочиеРасходы".
//
// Параметры:
//  ДополнительныеПоля	 - Строка	 - Список дополнительный полей.
//  ВозможныРазныеПериодыВДвижениях - Булево - определяет где хранятся параметры партионного учета, в параметрах запроса или во временной таблице ВТПараметрыПартионногоУчетаДляПроведения
// 
// Возвращаемое значение:
//  Строка - Текст запроса формирования временной таблицы ВтПрочиеРасходы.
//
Функция ТекстЗапросаТаблицаВтПрочиеРасходы(ДополнительныеПоля = "", ВозможныРазныеПериодыВДвижениях = Ложь) Экспорт
	
	// Условия для заполнения ресурсов регистра аналогичны условиям в функции ТекстСписанияРасходовНаВыбытиеТоваровРегистрПрочиеРасходы() общего модуля ПартионныйУчет22
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Строки.Период КАК Период,
	|	Строки.ВидДвижения КАК ВидДвижения,
	|	Строки.Организация КАК Организация,
	|	Строки.Подразделение КАК Подразделение,
	|	Строки.СтатьяРасходов КАК СтатьяРасходов,
	|	Строки.АналитикаРасходов КАК АналитикаРасходов,
	|	(ВЫБОР
	|		КОГДА ЕСТЬNULL(НаправленияДеятельности.УчетЗатрат, ЛОЖЬ)
	|			ТОГДА Строки.НаправлениеДеятельности
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КОНЕЦ) КАК НаправлениеДеятельности,
	|
	|	Строки.СуммаСНДС КАК Сумма,
	|	(ВЫБОР
	|		КОГДА НЕ Статья.ВариантРаспределенияРасходовУпр В (
	|				ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы),
	|				ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПрочиеАктивы))
	|			ТОГДА Строки.СуммаБезНДС
	|		ИНАЧЕ 0 КОНЕЦ) КАК СуммаБезНДС,
	|	(ВЫБОР
	|		КОГДА НЕ &УправленческийУчетОрганизаций И НЕ &ЭтоВводОстатковВНА_2_4
	|			ТОГДА 0
	|		КОГДА Строки.ВидДеятельностиНДС В (
	|					ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС),
	|					ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД),
	|					ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаПоПатенту)
	|					)
	|				И Статья.ВариантРаздельногоУчетаНДС = ЗНАЧЕНИЕ(Перечисление.ВариантыРаздельногоУчетаНДС.ИзДокумента)
	|			ТОГДА Строки.СуммаБезНДСУпр + (Строки.СуммаСНДС - Строки.СуммаБезНДС)
	|		ИНАЧЕ Строки.СуммаБезНДСУпр КОНЕЦ) КАК СуммаУпр,
	// Если изменяется условие расчета поля, то внести изменения в ПеренестиДанныеРегистраПартииПрочихРасходовВРегистрПрочиеРасходы()
	|	(ВЫБОР 
	|		КОГДА НЕ &ИспользоватьУчетПрочихДоходовРасходовРегл ТОГДА 0
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПрочиеАктивы)
	|			ТОГДА 0
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|				И НЕ &ИспользуетсяУправлениеВНА_2_4
	|			ТОГДА 0
	|		КОГДА Строки.ВидДеятельностиНДС В (
	|					ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС),
	|					ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД),
	|					ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаПоПатенту)
	|					)
	|				И Статья.ВариантРаздельногоУчетаНДС = ЗНАЧЕНИЕ(Перечисление.ВариантыРаздельногоУчетаНДС.ИзДокумента)
	|			ТОГДА Строки.СуммаСНДСРегл
	|		ИНАЧЕ Строки.СуммаБезНДСРегл КОНЕЦ) КАК СуммаРегл,
	|
	|	(ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрочихДоходовРасходовРегл ТОГДА 0
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПрочиеАктивы)
	|			ТОГДА 0
	|		КОГДА Статья.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|				И НЕ &ИспользуетсяУправлениеВНА_2_4
	|			ТОГДА 0
	|		КОГДА НЕ Статья.ПринятиеКналоговомуУчету И (Строки.СуммаСНДСРегл <> 0 ИЛИ Строки.ВременнаяРазница <> 0) ТОГДА
	|			(ВЫБОР КОГДА Строки.ВидДеятельностиНДС В (
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаПоПатенту)
	|				)
	|				И Статья.ВариантРаздельногоУчетаНДС = ЗНАЧЕНИЕ(Перечисление.ВариантыРаздельногоУчетаНДС.ИзДокумента)
	|			ТОГДА Строки.СуммаСНДСРегл
	|			ИНАЧЕ Строки.СуммаБезНДСРегл КОНЕЦ)
	|			- Строки.ВременнаяРазница
	|		ИНАЧЕ Строки.ПостояннаяРазница КОНЕЦ) КАК ПостояннаяРазница,
	|	(ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрочихДоходовРасходовРегл ТОГДА 0
	|		ИНАЧЕ Строки.ВременнаяРазница КОНЕЦ) КАК ВременнаяРазница,
	|	Строки.ХозяйственнаяОперация,
	|	Строки.АналитикаУчетаНоменклатуры,
	|
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Справочник.Организации)
	|		 И Строки.АналитикаРасходов <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА Строки.АналитикаРасходов
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.АктВыполненныхРабот)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.АктВыполненныхРабот).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ВводОстатков)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ВводОстатков).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ВводОстатковПрочиеРасходы)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ВводОстатковПрочиеРасходы).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ЗаказКлиента)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ЗаказКлиента).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ЗаказНаПеремещение)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ЗаказНаПеремещение).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ЗаказНаСборку)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ЗаказНаСборку).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ЗаказПоставщику)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ЗаказПоставщику).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ЗаявкаНаВозвратТоваровОтКлиента)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ЗаявкаНаВозвратТоваровОтКлиента).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ПередачаТоваровМеждуОрганизациями)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ПередачаТоваровМеждуОрганизациями).ОрганизацияПолучатель
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ПеремещениеТоваров)
	|		 И ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ПеремещениеТоваров).ХозяйственнаяОперация
	|				= ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПеремещениеТоваровМеждуФилиалами)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ПеремещениеТоваров).ОрганизацияПолучатель
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ПеремещениеТоваров)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ПеремещениеТоваров).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.ПриобретениеТоваровУслуг)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.ПриобретениеТоваровУслуг).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.РеализацияТоваровУслуг)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.РеализацияТоваровУслуг).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.РеализацияУслугПрочихАктивов)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.РеализацияУслугПрочихАктивов).Организация
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.АналитикаРасходов) = ТИП(Документ.СборкаТоваров)
	|			ТОГДА ВЫРАЗИТЬ(Строки.АналитикаРасходов КАК Документ.СборкаТоваров).Организация
	|		ИНАЧЕ Строки.Организация
	|	КОНЕЦ КАК ОрганизацияПолучатель,
	|	Строки.ИдентификаторФинЗаписи         КАК ИдентификаторФинЗаписи,
	|	Строки.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации
	|
	|	,&ДополнительныеПоля
	|
	|ПОМЕСТИТЬ ВтПрочиеРасходы
	|ИЗ
	|	ВтИсходныеПрочиеРасходы КАК Строки
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ПланВидовХарактеристик.СтатьиРасходов КАК Статья
	|	ПО
	|		Статья.Ссылка = Строки.СтатьяРасходов
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НаправленияДеятельности КАК НаправленияДеятельности
	|		ПО НаправленияДеятельности.Ссылка = Строки.НаправлениеДеятельности
	|	ЛЕВОЕ СОЕДИНЕНИЕ Константы КАК ТаблицаКонстанты ПО ИСТИНА
	|ГДЕ
	|	&ИспользоватьУчетПрочихДоходовРасходов
	|";
	
	ТекстСоединения = "ЛЕВОЕ СОЕДИНЕНИЕ Константы КАК ТаблицаКонстанты ПО ИСТИНА";
	
	Если НЕ ВозможныРазныеПериодыВДвижениях Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ТекстСоединения, "");
		
	Иначе
		
		// Параметры партионного учета хранятся не в параметрах запроса, а в одноименных полях временной таблицы ВТПараметрыПартионногоУчетаДляПроведения.
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ТекстСоединения,
			"ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПараметрыПартионногоУчетаДляПроведения КАК ПараметрыПартионногоУчета
			|	ПО ПараметрыПартионногоУчета.Период = НАЧАЛОПЕРИОДА(Строки.Период, МЕСЯЦ)");
		
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить("ИспользоватьУчетПрочихДоходовРасходовРегл");
		МассивПараметров.Добавить("ИспользоватьУчетПрочихДоходовРасходов");
		МассивПараметров.Добавить("УправленческийУчетОрганизаций");
		МассивПараметров.Добавить("ЭтоВводОстатковВНА_2_4");
		МассивПараметров.Добавить("ИспользуетсяУправлениеВНА_2_4");
		
		Для Каждого ТекущийПараметр Из МассивПараметров Цикл
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&" + ТекущийПараметр, "ПараметрыПартионногоУчета." + ТекущийПараметр);
		КонецЦикла;
		
	КонецЕсли;
	
	ДобавитьДополнительныеПоляВТекстЗапроса(ДополнительныеПоля, ТекстЗапроса);
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Формирует текст запроса для формирования движений по регистру "Прочие расходы".
//
// Параметры:
//  ДополнительныеПоля	 - Строка	 - Список дополнительный полей.
// 
// Возвращаемое значение:
//  Строка - Текст запроса формирования движений в регистре ПрочиеРасходы.
//
Функция ТекстЗапросаТаблицаПрочиеРасходы(ДополнительныеПоля = "") Экспорт
	
	ТекстЗапроса = "
	// Формирование таблицы для записи в регистр "ПрочиеРасходы".
	|ВЫБРАТЬ
	|	Строки.Период КАК Период,
	|	Строки.ВидДвижения КАК ВидДвижения,
	|	Строки.Организация КАК Организация,
	|	Строки.Подразделение КАК Подразделение,
	|	Строки.СтатьяРасходов КАК СтатьяРасходов,
	|	Строки.АналитикаРасходов КАК АналитикаРасходов,
	|	ВЫБОР 
	|		КОГДА ЕСТЬNULL(НД.УчетЗатрат, ЛОЖЬ) ТОГДА
	|			Строки.НаправлениеДеятельности
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
	|	КОНЕЦ КАК НаправлениеДеятельности,
	|
	|	Строки.Сумма КАК Сумма,
	|	Строки.СуммаБезНДС КАК СуммаБезНДС,
	|	Строки.СуммаУпр КАК СуммаУпр,
	|
	|	Строки.СуммаРегл КАК СуммаРегл,
	|	Строки.ПостояннаяРазница КАК ПостояннаяРазница,
	|	Строки.ВременнаяРазница КАК ВременнаяРазница,
	|
	|	Строки.ХозяйственнаяОперация,
	|	Строки.АналитикаУчетаНоменклатуры,
	|
	|	Строки.ИдентификаторФинЗаписи КАК ИдентификаторФинЗаписи,
	|	Строки.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации
	|
	|	,&ДополнительныеПоля
	|
	|ИЗ
	|	ВтПрочиеРасходы КАК Строки
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НаправленияДеятельности КАК НД
	|		ПО НД.Ссылка = Строки.НаправлениеДеятельности
	|ГДЕ
	|	(Строки.Сумма <> 0 ИЛИ Строки.СуммаБезНДС <> 0 ИЛИ Строки.СуммаУпр <> 0
	|	ИЛИ Строки.СуммаРегл <> 0 ИЛИ Строки.ПостояннаяРазница <> 0 ИЛИ Строки.ВременнаяРазница <> 0)
	|
	// Сторнирование расходов в упр. учете у организации - источника.
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ
	|	Строки.Период КАК Период,
	|	Строки.ВидДвижения КАК ВидДвижения,
	|	Строки.Организация КАК Организация,
	|	Строки.Подразделение КАК Подразделение,
	|	Строки.СтатьяРасходов КАК СтатьяРасходов,
	|	Строки.АналитикаРасходов КАК АналитикаРасходов,
	|	ВЫБОР 
	|		КОГДА ЕСТЬNULL(НД.УчетЗатрат, ЛОЖЬ) ТОГДА
	|			Строки.НаправлениеДеятельности
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
	|	КОНЕЦ КАК НаправлениеДеятельности,
	|	-Строки.Сумма КАК Сумма,
	|	-Строки.СуммаБезНДС КАК СуммаБезНДС,
	|	-Строки.СуммаУпр КАК СуммаУпр,
	|	0 КАК СуммаРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СторнированиеРасходовУУ) КАК ХозяйственнаяОперация,
	|	Строки.АналитикаУчетаНоменклатуры,
	|
	|	&ИдентификаторНеиспользуемойФинЗаписи КАК ИдентификаторФинЗаписи,
	|	Строки.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации
	|
	|	,&ДополнительныеПоля
	|
	|ИЗ
	|	ВтПрочиеРасходы КАК Строки
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НаправленияДеятельности КАК НД
	|		ПО НД.Ссылка = Строки.НаправлениеДеятельности
	|ГДЕ
	|	Строки.ОрганизацияПолучатель <> Строки.Организация
	|	И Строки.ОрганизацияПолучатель <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|	И (Строки.Сумма <> 0 ИЛИ Строки.СуммаБезНДС <> 0 ИЛИ Строки.СуммаУпр <> 0)
	|
	// Регистрация расходов в упр. учете у организации - получателя.
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ
	|	Строки.Период КАК Период,
	|	Строки.ВидДвижения КАК ВидДвижения,
	|	Строки.ОрганизацияПолучатель КАК Организация,
	|	Строки.Подразделение КАК Подразделение,
	|	Строки.СтатьяРасходов КАК СтатьяРасходов,
	|	Строки.АналитикаРасходов КАК АналитикаРасходов,
	|	ВЫБОР 
	|		КОГДА ЕСТЬNULL(НД.УчетЗатрат, ЛОЖЬ) ТОГДА
	|			Строки.НаправлениеДеятельности
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
	|	КОНЕЦ КАК НаправлениеДеятельности,
	|	Строки.Сумма КАК Сумма,
	|	Строки.СуммаБезНДС КАК СуммаБезНДС,
	|	0 КАК СуммаУпр,
	|	0 КАК СуммаРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РегистрацияРасходовУУ) КАК ХозяйственнаяОперация,
	|	Строки.АналитикаУчетаНоменклатуры,
	|
	|	&ИдентификаторНеиспользуемойФинЗаписи КАК ИдентификаторФинЗаписи,
	|	Строки.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации
	|
	|	,&ДополнительныеПоля
	|
	|ИЗ
	|	ВтПрочиеРасходы КАК Строки
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НаправленияДеятельности КАК НД
	|		ПО НД.Ссылка = Строки.НаправлениеДеятельности
	|ГДЕ
	|	Строки.ОрганизацияПолучатель <> Строки.Организация
	|	И Строки.ОрганизацияПолучатель <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|	И (Строки.Сумма <> 0 ИЛИ Строки.СуммаБезНДС <> 0 ИЛИ Строки.СуммаУпр <> 0)
	|";
	
	ДобавитьДополнительныеПоляВТекстЗапроса(ДополнительныеПоля, ТекстЗапроса);
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Собирает структуру из текстов запросов для дальнейшей проверки даты запрета.
// 
// Параметры:
// 	Запрос - Запрос - Запрос по проверке даты запрета, можно установить параметры
// Возвращаемое значение:
// 	Структура - см. ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов
Функция ТекстЗапросаКонтрольДатыЗапрета(Запрос) Экспорт
	ИмяРегистра = Метаданные.РегистрыНакопления.ПрочиеРасходы.Имя;
	ИмяТаблицыИзменений = "ТаблицаИзмененийПрочиеРасходы"; 
	СтруктураТекстовЗапросов = ПроведениеДокументов.ШаблонТекстЗапросаКонтрольДатыЗапрета(Запрос, 
		ИмяРегистра, 
		ИмяТаблицыИзменений, 
		"ФинансовыйКонтур");
	Возврат СтруктураТекстовЗапросов

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область ОбработкаПереходаСРегистраПартииПрочихРасходовНаРегистрПрочиеРасходы

// Процедура конвертирует записи регистра ПартииПрочихРасходов по статьям расходов, распределяемые на себестоимость
// товаров, в регистр ПрочиеРасходы.
// 
// Параметры:
// 	Регистратор - ДокументСсылка.ПриобретениеТоваровУслуг - документ-регистратор
// 	Набор - РегистрНакопленияНаборЗаписей.ПартииПрочихРасходов - набор записей регистра для обработки
// 	ВыборкаЗаписей - ВыборкаИзРезультатаЗапроса - записи набора с рассчитанными дополнительными полями
// 
// Возвращаемое значение:
// 	РегистрНакопленияНаборЗаписей.ПрочиеРасходы - набор записей нового регистра
//
Функция ПеренестиДанныеРегистраПартииПрочихРасходовВРегистрПрочиеРасходы(Регистратор, Набор, ВыборкаЗаписей) Экспорт
	
	НаборПрочиеРасходы = РегистрыНакопления.ПрочиеРасходы.СоздатьНаборЗаписей();
	НаборПрочиеРасходы.ОбменДанными.Загрузка = Истина;
	НаборПрочиеРасходы.Отбор.Регистратор.Установить(Регистратор);
	НаборПрочиеРасходы.Прочитать();
	
	НомераСтрокНабора = Набор.ВыгрузитьКолонку("НомерСтроки");
	
	Пока ВыборкаЗаписей.Следующий() Цикл
		
		Если Не ВыборкаЗаписей.ПереноситьЗаписьВПрочиеРасходыРегл
			И Не ВыборкаЗаписей.ПереноситьЗаписьВПрочиеРасходыУпр Тогда
			Продолжить
		КонецЕсли;
		
		ЗаписьПрочиеРасходы = НаборПрочиеРасходы.Добавить();
		ЗаполнитьЗначенияСвойств(ЗаписьПрочиеРасходы, ВыборкаЗаписей);

		Если ВыборкаЗаписей.ПереноситьЗаписьВПрочиеРасходыРегл Тогда
			
			Если (ВыборкаЗаписей.ВидДеятельностиНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС
				Или ВыборкаЗаписей.ВидДеятельностиНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД)
				И ВыборкаЗаписей.ВариантРаздельногоУчетаНДС = Перечисления.ВариантыРаздельногоУчетаНДС.ИзДокумента Тогда
				ЗаписьПрочиеРасходы.СуммаРегл = ВыборкаЗаписей.СтоимостьРегл + ВыборкаЗаписей.НДСРегл;
			Иначе
				ЗаписьПрочиеРасходы.СуммаРегл = ВыборкаЗаписей.СтоимостьРегл;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ВыборкаЗаписей.ПереноситьЗаписьВПрочиеРасходыУпр Тогда
			
			Если ВыборкаЗаписей.СтатьяРасходов = ПланыВидовХарактеристик.СтатьиРасходов.НДСНалоговогоАгента
			 И ВыборкаЗаписей.Стоимость = 0 Тогда
			 	ЗаписьПрочиеРасходы.Сумма = ?(ВыборкаЗаписей.НДСУпр <> 0, ВыборкаЗаписей.НДСУпр, ВыборкаЗаписей.НДСРегл);
			Иначе
				ЗаписьПрочиеРасходы.Сумма = ВыборкаЗаписей.Стоимость;
			КонецЕсли;
			ЗаписьПрочиеРасходы.СуммаБезНДС = ВыборкаЗаписей.СтоимостьБезНДС;
			
			Если (ВыборкаЗаписей.ВидДеятельностиНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС
				Или ВыборкаЗаписей.ВидДеятельностиНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД)
				И ВыборкаЗаписей.ВариантРаздельногоУчетаНДС = Перечисления.ВариантыРаздельногоУчетаНДС.ИзДокумента Тогда
				ЗаписьПрочиеРасходы.СуммаУпр = ВыборкаЗаписей.Стоимость;
			Иначе
				ЗаписьПрочиеРасходы.СуммаУпр = ВыборкаЗаписей.СтоимостьБезНДС;
			КонецЕсли;
			
		КонецЕсли;

		Если ЗаписьПрочиеРасходы.Сумма = 0
			И ЗаписьПрочиеРасходы.СуммаБезНДС = 0
			И ЗаписьПрочиеРасходы.СуммаРегл = 0
			И ЗаписьПрочиеРасходы.СуммаУпр = 0
			И ЗаписьПрочиеРасходы.ПостояннаяРазница = 0
			И ЗаписьПрочиеРасходы.ВременнаяРазница = 0 Тогда
			НаборПрочиеРасходы.Удалить(ЗаписьПрочиеРасходы);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НаборПрочиеРасходы;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьДополнительныеПоляВТекстЗапроса(ДополнительныеПоля, ТекстЗапроса)

	Если НЕ ЗначениеЗаполнено(ДополнительныеПоля) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ",&ДополнительныеПоля", "");
		Возврат;
	КонецЕсли; 
	
	ТекстДополнительныеПоля = "";
	
	СписокПолей = СтрРазделить(ДополнительныеПоля, ",");
	Для каждого ИмяПоля Из СписокПолей Цикл
		ТекстДополнительныеПоля = ТекстДополнительныеПоля + "
		|	,Строки." + ИмяПоля;
	КонецЦикла; 
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ",&ДополнительныеПоля", ТекстДополнительныеПоля); 

КонецПроцедуры

#КонецОбласти

#КонецЕсли
