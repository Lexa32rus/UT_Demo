
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		Если (Параметры.Свойство("Основание")
			И ЗначениеЗаполнено(Параметры.Основание))
			ИЛИ (Параметры.Свойство("Ключ") И Не ЗначениеЗаполнено(Параметры.Ключ)) Тогда
			
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаДокументаРМК";
			
		ИначеЕсли Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
			
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаДокумента";
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("ОборотныеРегистрыУправленческогоУчета");
	МеханизмыДокумента.Добавить("ПодарочныеСертификаты");
	МеханизмыДокумента.Добавить("УчетДенежныхСредств");
	МеханизмыДокумента.Добавить("УчетПрочихАктивовПассивов");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	
	РеализацияПодарочныхСертификатовЛокализация.ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента);
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура - коллекция элементов ТаблицаЗначений с данными для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Запрос			= Новый Запрос;
	ТекстыЗапроса	= Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		////////////////////////////////////////////////////////////////////////////
		// Создадим запрос инициализации движений
		
		ЗаполнитьПараметрыИнициализации(Запрос, Документ);
		
		////////////////////////////////////////////////////////////////////////////
		// Сформируем текст запроса
		
		ТекстЗапросаПодарочныеСертификаты(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаИсторияПодарочныхСертификатов(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДенежныеСредстваВКассахККМ(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРасчетыПоЭквайрингу(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДвиженияДенежныеСредстваКонтрагент(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
		
		// Исполнение запроса и выгрузка полученных таблиц для движений.
		РеализацияПодарочныхСертификатовЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Документы.ВозвратПодарочныхСертификатов.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Добавляет команду создания документа "Реализация подарочных сертификатов".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.РеализацияПодарочныхСертификатов) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РеализацияПодарочныхСертификатов.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.РеализацияПодарочныхСертификатов);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьПодарочныеСертификаты";
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияПодарочныхСертификатов.Дата         КАК Дата,
	|	РеализацияПодарочныхСертификатов.Организация  КАК Организация,
	|	РеализацияПодарочныхСертификатов.Валюта       КАК Валюта,
	|	РеализацияПодарочныхСертификатов.Статус       КАК Статус,
	|	РеализацияПодарочныхСертификатов.НалогообложениеНДС КАК НалогообложениеНДС,
	|	РеализацияПодарочныхСертификатов.КассаККМ.Подразделение КАК Подразделение,
	|	РеализацияПодарочныхСертификатов.Номер КАК Номер,
	|	РеализацияПодарочныхСертификатов.Комментарий КАК Комментарий,
	|	РеализацияПодарочныхСертификатов.Проведен КАК Проведен,
	|	РеализацияПодарочныхСертификатов.ПометкаУдаления КАК ПометкаУдаления,
	|	РеализацияПодарочныхСертификатов.СуммаДокумента КАК СуммаДокумента,
	|	РеализацияПодарочныхСертификатов.Кассир КАК Кассир,
	|	РеализацияПодарочныхСертификатов.Партнер КАК Партнер
	|ИЗ
	|	Документ.РеализацияПодарочныхСертификатов КАК РеализацияПодарочныхСертификатов
	|ГДЕ
	|	РеализацияПодарочныхСертификатов.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Ссылка",                			ДокументСсылка);
	Запрос.УстановитьПараметр("Период",                			Реквизиты.Дата);
	Запрос.УстановитьПараметр("Валюта",                			Реквизиты.Валюта);
	Запрос.УстановитьПараметр("Организация",           			Реквизиты.Организация);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", 			Перечисления.ХозяйственныеОперации.РеализацияВРозницу);
	Запрос.УстановитьПараметр("СтатьяДвиженияДенежныхСредств", 	Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеОплатыОтКлиента);
	Запрос.УстановитьПараметр("ЧекПробит",             			Реквизиты.Статус = Перечисления.СтатусыЧековККМ.Пробит);
	Запрос.УстановитьПараметр("НастройкаХозяйственнойОперации",	Справочники.НастройкиХозяйственныхОпераций.РеализацияВРозницу);
	Запрос.УстановитьПараметр("НалогообложениеНДС",				Реквизиты.НалогообложениеНДС);
	Запрос.УстановитьПараметр("Подразделение",					Реквизиты.Подразделение);
	Запрос.УстановитьПараметр("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.РеализацияПодарочныхСертификатов"));
	Запрос.УстановитьПараметр("Номер", Реквизиты.Номер);
	Запрос.УстановитьПараметр("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	Запрос.УстановитьПараметр("Комментарий", Реквизиты.Комментарий);
	Запрос.УстановитьПараметр("Проведен", Реквизиты.Проведен);
	Запрос.УстановитьПараметр("ПометкаУдаления", Реквизиты.ПометкаУдаления);
	Запрос.УстановитьПараметр("ХозОперацияДляРеестра", Перечисления.ХозяйственныеОперации.РеализацияПодарочныхСертификатов);
	Запрос.УстановитьПараметр("СуммаДокумента", Реквизиты.СуммаДокумента);
	Запрос.УстановитьПараметр("Кассир", Реквизиты.Кассир);
	Запрос.УстановитьПараметр("Партнер", Реквизиты.Партнер);
	
КонецПроцедуры

Процедура УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос)
	
	Если Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуУпр")
		И Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуРегл") Тогда
		Возврат;
	КонецЕсли;
	
	Коэффициенты = РаботаСКурсамивалютУТ.ПолучитьКоэффициентыПересчетаВалюты(Запрос.Параметры.Валюта,
	                                                                         Запрос.Параметры.Валюта,
	                                                                         Запрос.Параметры.Период,
	                                                                         Запрос.Параметры.Организация);
	
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУпр",  Коэффициенты.КоэффициентПересчетаВВалютуУпр);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуРегл", Коэффициенты.КоэффициентПересчетаВВалютуРегл);
	
КонецПроцедуры

Функция ТекстЗапросаПодарочныеСертификаты(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПодарочныеСертификаты";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Период                                                 КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)                  КАК ВидДвижения,
	|	ТабличнаяЧасть.ПодарочныйСертификат                     КАК ПодарочныйСертификат,
	|	ТабличнаяЧасть.ПодарочныйСертификат.Владелец.Номинал    КАК Сумма,
	|	ТабличнаяЧасть.Сумма * &КоэффициентПересчетаВВалютуРегл КАК СуммаРегл,
	|	ТабличнаяЧасть.ИдентификаторСтроки						КАК ИдентификаторФинЗаписи,
	|	ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.РеализацияПодарочныхСертификатов) КАК НастройкаХозяйственнойОперации
	|ИЗ
	|	Документ.РеализацияПодарочныхСертификатов.ПодарочныеСертификаты КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Ссылка
	|	И &ЧекПробит";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаИсторияПодарочныхСертификатов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ИсторияПодарочныхСертификатов";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Период                                                          КАК Период,
	|	ТабличнаяЧасть.ПодарочныйСертификат                              КАК ПодарочныйСертификат,
	|	ЗНАЧЕНИЕ(Перечисление.СтатусыПодарочныхСертификатов.Активирован) КАК Статус
	|ИЗ
	|	Документ.РеализацияПодарочныхСертификатов.ПодарочныеСертификаты КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Ссылка
	|	И &ЧекПробит";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтТаблицаСуммаПлатежнымиКартами(Запрос, ТекстыЗапроса) Экспорт
	
	ИмяРегистра = "ВтТаблицаСуммаПлатежнымиКартами";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СУММА(ТабличнаяЧасть.Сумма) КАК Сумма
	|ПОМЕСТИТЬ ВтТаблицаСуммаПлатежнымиКартами
	|ИЗ
	|	Документ.РеализацияПодарочныхСертификатов.ОплатаПлатежнымиКартами КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДенежныеСредстваВКассахККМ(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваВКассахККМ";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 

	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтТаблицаСуммаПлатежнымиКартами", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаСуммаПлатежнымиКартами(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ДанныеДокумента.КассаККМ.Владелец КАК Организация,
	|	ДанныеДокумента.КассаККМ КАК КассаККМ,
	|	ДанныеДокумента.СуммаДокумента - ЕСТЬNULL(ТаблицаСуммаПлатежнымиКартами.Сумма, 0) КАК Сумма,
	|	ВЫРАЗИТЬ((ДанныеДокумента.СуммаДокумента - ЕСТЬNULL(ТаблицаСуммаПлатежнымиКартами.Сумма, 0)) * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(31,2)) КАК СуммаРегл,
	|	ВЫРАЗИТЬ((ДанныеДокумента.СуммаДокумента - ЕСТЬNULL(ТаблицаСуммаПлатежнымиКартами.Сумма, 0)) * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2)) КАК СуммаУпр,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента) КАК ХозяйственнаяОперация,
	|	&СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	ДанныеДокумента.ИдентификаторДокумента КАК ИдентификаторФинЗаписи,
	|	ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.ПоступлениеОплатыОтКлиента) КАК НастройкаХозяйственнойОперации
	|ИЗ
	|	Документ.РеализацияПодарочныхСертификатов КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтТаблицаСуммаПлатежнымиКартами КАК ТаблицаСуммаПлатежнымиКартами
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ДанныеДокумента.СуммаДокумента - ЕСТЬNULL(ТаблицаСуммаПлатежнымиКартами.Сумма, 0) <> 0
	|	И ДанныеДокумента.Ссылка = &Ссылка
	|	И &ЧекПробит";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРасчетыПоЭквайрингу(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РасчетыПоЭквайрингу";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаПлатежей.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствПоЭквайрингу.ПоступлениеПоПлатежнойКарте) КАК ТипДенежныхСредств,
	|	&Организация                                   КАК Организация,
	|	&Валюта                                        КАК Валюта,
	|	ТаблицаПлатежей.ЭквайринговыйТерминал          КАК ЭквайринговыйТерминал,
	|	ТаблицаПлатежей.ЭквайринговыйТерминал.Владелец КАК Договор,
	|	ТаблицаПлатежей.КодАвторизации                 КАК КодАвторизации,
	|	ТаблицаПлатежей.НомерПлатежнойКарты            КАК НомерПлатежнойКарты,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиентаПоПлатежнойКарте) КАК ХозяйственнаяОперация,
	|	&СтатьяДвиженияДенежныхСредств                 КАК СтатьяДвиженияДенежныхСредств,
	|	&Период                                        КАК ДатаПлатежа,
	|	ТаблицаПлатежей.Сумма                          КАК Сумма
	|ИЗ
	|	Документ.РеализацияПодарочныхСертификатов.ОплатаПлатежнымиКартами КАК ТаблицаПлатежей
	|
	|ГДЕ
	|	&ЧекПробит
	|	И ТаблицаПлатежей.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваВПути";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаПлатежей.НомерСтроки                                                          КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)                                               КАК ВидДвижения,
	|	&Период                                                                              КАК Период,
	|
	|	&Организация                                                                         КАК Организация,
	|	ТаблицаПлатежей.ЭквайринговыйТерминал.Владелец.БанковскийСчет                        КАК Получатель,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПоступлениеОтБанкаПоЭквайрингу)   КАК ВидПереводаДенежныхСредств,
	|	ТаблицаПлатежей.ЭквайринговыйТерминал.Владелец.Контрагент                            КАК Контрагент,
	|	ТаблицаПлатежей.ЭквайринговыйТерминал.Владелец                                       КАК Договор,
	|	НЕОПРЕДЕЛЕНО                                                                         КАК ПлатежныйДокумент,
	|	&Валюта                                                                              КАК Валюта,
	|
	|	ТаблицаПлатежей.Сумма                                                                КАК Сумма,
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2))    КАК СуммаУпр,
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(31,2))   КАК СуммаРегл,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиентаПоПлатежнойКарте) КАК ХозяйственнаяОперация,
	|	&СтатьяДвиженияДенежныхСредств                                                       КАК СтатьяДвиженияДенежныхСредств,
	|	ТаблицаПлатежей.ИдентификаторСтроки КАК ИдентификаторФинЗаписи,
	|	ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.ПоступлениеОплатыОтКлиентаПоПлатежнойКарте) КАК НастройкаХозяйственнойОперации
	|ИЗ
	|	Документ.РеализацияПодарочныхСертификатов.ОплатаПлатежнымиКартами КАК ТаблицаПлатежей
	|
	|ГДЕ
	|	&ЧекПробит
	|	И ТаблицаПлатежей.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияДенежныеСредстваКонтрагент(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияДенежныеСредстваКонтрагент";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ИнициализироватьВтДвиженияДенежныеСредстваКонтрагент(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Таблица.Период,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.Организация,
	|	Таблица.Подразделение,
	|
	|	Таблица.ДенежныеСредства,
	|	Таблица.НаправлениеДеятельностиДС,
	|	Таблица.ТипДенежныхСредств,
	|	Таблица.ВалютаПлатежа,
	|	Таблица.СтатьяДвиженияДенежныхСредств,
	|
	|	Таблица.Партнер,
	|	Таблица.Контрагент,
	|	Таблица.НаправлениеДеятельностиДС КАК НаправлениеДеятельностиКонтрагента,
	|	Таблица.Договор,
	|	Таблица.ОбъектРасчетов,
	|
	|	Таблица.СуммаОплаты,
	|	Таблица.СуммаОплатыРегл,
	|	Таблица.СуммаОплатыВВалютеПлатежа,
	|
	|	Таблица.СуммаПостоплаты,
	|	Таблица.СуммаПостоплатыРегл,
	|	Таблица.СуммаПостоплатыВВалютеПлатежа,
	|	
	|	Таблица.СуммаПредоплаты,
	|	Таблица.СуммаПредоплатыРегл,
	|	Таблица.СуммаПредоплатыВВалютеПлатежа,
	|
	|	Таблица.ВалютаВзаиморасчетов,
	|
	|	Таблица.СуммаОплатыВВалютеВзаиморасчетов,
	|	Таблица.СуммаПостоплатыВВалютеВзаиморасчетов,
	|	Таблица.СуммаПредоплатыВВалютеВзаиморасчетов,
	|
	|	Таблица.ИсточникГФУДенежныхСредств,
	|	Таблица.ИсточникГФУРасчетов
	|ИЗ
	|	ВтДвиженияДенежныеСредстваКонтрагент КАК Таблица
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ИнициализироватьВтДвиженияДенежныеСредстваКонтрагент(Запрос)
	
	Если Запрос.Параметры.Свойство("ВтДвиженияДенежныеСредстваКонтрагентИнициализирована") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	ЗапросИнициализации = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента) КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.КассаККМ.Подразделение КАК Подразделение,
	|
	|	ДанныеДокумента.КассаККМ КАК ДенежныеСредства,
	|	ВидыПодарочныхСертификатов.НаправлениеДеятельности КАК НаправлениеДеятельностиДС,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные) КАК ТипДенежныхСредств,
	|	ДанныеДокумента.Валюта КАК ВалютаПлатежа,
	|	&СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|
	|	НЕОПРЕДЕЛЕНО КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.РозничныйПокупатель) КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО КАК Договор,
	|	ТаблицаПлатежей.ПодарочныйСертификат КАК ОбъектРасчетов,
	|
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2)) КАК СуммаОплаты,
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(31,2)) КАК СуммаОплатыРегл,
	|	ТаблицаПлатежей.Сумма КАК СуммаОплатыВВалютеПлатежа,
	|
	|	0 КАК СуммаПостоплаты,
	|	0 КАК СуммаПостоплатыРегл,
	|	0 КАК СуммаПостоплатыВВалютеПлатежа,
	|	
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2)) КАК СуммаПредоплаты,
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(31,2)) КАК СуммаПредоплатыРегл,
	|	ТаблицаПлатежей.Сумма КАК СуммаПредоплатыВВалютеПлатежа,
	|
	|	ДанныеДокумента.Валюта КАК ВалютаВзаиморасчетов,
	|
	|	0 КАК СуммаОплатыВВалютеВзаиморасчетов,
	|	0 КАК СуммаПостоплатыВВалютеВзаиморасчетов,
	|	0 КАК СуммаПредоплатыВВалютеВзаиморасчетов,
	|
	|	ДанныеДокумента.КассаККМ КАК ИсточникГФУДенежныхСредств,
	|	НЕОПРЕДЕЛЕНО КАК ИсточникГФУРасчетов
	|ИЗ
	|	Документ.РеализацияПодарочныхСертификатов КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияПодарочныхСертификатов.ПодарочныеСертификаты КАК ТаблицаПлатежей
	|		ПО ИСТИНА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыПодарочныхСертификатов КАК ВидыПодарочныхСертификатов
	|		ПО ТаблицаПлатежей.ПодарочныйСертификат.Владелец = ВидыПодарочныхСертификатов.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ТаблицаПлатежей.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиентаПоПлатежнойКарте) КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация КАК Организация,
	|	БанковскиеСчетаОрганизаций.Подразделение КАК Подразделение,
	|
	|	ТаблицаПлатежей.ЭквайринговыйТерминал.Владелец КАК ДенежныеСредства,
	|	БанковскиеСчетаОрганизаций.НаправлениеДеятельности КАК НаправлениеДеятельностиДС,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.ДенежныеСредстваУЭквайера) КАК ТипДенежныхСредств,
	|	ДанныеДокумента.Валюта КАК ВалютаПлатежа,
	|	&СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|
	|	НЕОПРЕДЕЛЕНО КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.РозничныйПокупатель) КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО КАК Договор,
	|	НЕОПРЕДЕЛЕНО КАК ОбъектРасчетов,
	|
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2)) КАК СуммаОплаты,
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(31,2)) КАК СуммаОплатыРегл,
	|	ТаблицаПлатежей.Сумма КАК СуммаОплатыВВалютеПлатежа,
	|
	|	0 КАК СуммаПостоплаты,
	|	0 КАК СуммаПостоплатыРегл,
	|	0 КАК СуммаПостоплатыВВалютеПлатежа,
	|	
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2)) КАК СуммаПредоплаты,
	|	ВЫРАЗИТЬ(ТаблицаПлатежей.Сумма * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(31,2)) КАК СуммаПредоплатыРегл,
	|	ТаблицаПлатежей.Сумма КАК СуммаПредоплатыВВалютеПлатежа,
	|
	|	ДанныеДокумента.Валюта КАК ВалютаВзаиморасчетов,
	|
	|	0 КАК СуммаОплатыВВалютеВзаиморасчетов,
	|	0 КАК СуммаПостоплатыВВалютеВзаиморасчетов,
	|	0 КАК СуммаПредоплатыВВалютеВзаиморасчетов,
	|
	|	ТаблицаПлатежей.ЭквайринговыйТерминал.Владелец.БанковскийСчет КАК ИсточникГФУДенежныхСредств,
	|	НЕОПРЕДЕЛЕНО КАК ИсточникГФУРасчетов,
	|	ЛОЖЬ КАК ОплатаОбработана
	|ИЗ
	|	Документ.РеализацияПодарочныхСертификатов КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияПодарочныхСертификатов.ОплатаПлатежнымиКартами КАК ТаблицаПлатежей
	|		ПО ИСТИНА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|		ПО ТаблицаПлатежей.ЭквайринговыйТерминал.Владелец.БанковскийСчет = БанковскиеСчетаОрганизаций.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ТаблицаПлатежей.Ссылка = &Ссылка
	|");
	
	ЗапросИнициализации.Параметры.Вставить("Ссылка", Запрос.Параметры.Ссылка);
	ЗапросИнициализации.Параметры.Вставить("КоэффициентПересчетаВВалютуУпр", Запрос.Параметры.КоэффициентПересчетаВВалютуУпр);
	ЗапросИнициализации.Параметры.Вставить("КоэффициентПересчетаВВалютуРегл", Запрос.Параметры.КоэффициентПересчетаВВалютуРегл);
	ЗапросИнициализации.Параметры.Вставить("СтатьяДвиженияДенежныхСредств", Запрос.Параметры.СтатьяДвиженияДенежныхСредств);
	
	РезультатЗапроса = ЗапросИнициализации.ВыполнитьПакет();
	ОплатаПодарочныеСертификаты = РезультатЗапроса[0].Выгрузить();
	ОплатаПлатежныеКарты        = РезультатЗапроса[1].Выгрузить();
	
	ЗапросПомещениеВоВременнуюТаблицу = Новый Запрос("
	|ВЫБРАТЬ
	|	Таблица.Период,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.Организация,
	|	Таблица.Подразделение,
	|
	|	Таблица.ДенежныеСредства,
	|	Таблица.НаправлениеДеятельностиДС,
	|	Таблица.ТипДенежныхСредств,
	|	Таблица.ВалютаПлатежа,
	|	Таблица.СтатьяДвиженияДенежныхСредств,
	|
	|	Таблица.Партнер,
	|	Таблица.Контрагент,
	|	Таблица.Договор,
	|	Таблица.ОбъектРасчетов,
	|
	|	Таблица.СуммаОплаты,
	|	Таблица.СуммаОплатыРегл,
	|	Таблица.СуммаОплатыВВалютеПлатежа,
	|
	|	Таблица.СуммаПостоплаты,
	|	Таблица.СуммаПостоплатыРегл,
	|	Таблица.СуммаПостоплатыВВалютеПлатежа,
	|	
	|	Таблица.СуммаПредоплаты,
	|	Таблица.СуммаПредоплатыРегл,
	|	Таблица.СуммаПредоплатыВВалютеПлатежа,
	|
	|	Таблица.ВалютаВзаиморасчетов,
	|
	|	Таблица.СуммаОплатыВВалютеВзаиморасчетов,
	|	Таблица.СуммаПостоплатыВВалютеВзаиморасчетов,
	|	Таблица.СуммаПредоплатыВВалютеВзаиморасчетов,
	|
	|	Таблица.ИсточникГФУДенежныхСредств,
	|	Таблица.ИсточникГФУРасчетов
	|ПОМЕСТИТЬ ВтДвиженияДенежныеСредстваКонтрагент
	|ИЗ
	|	&Таблица КАК Таблица
	|");
	
	ДвиженияДенежныеСредстваКонтрагент = ПодарочныеСертификатыСервер.ПодготовитьТаблицуДвиженияДенежныеСредстваКонтрагент(
		ОплатаПодарочныеСертификаты,
		ОплатаПлатежныеКарты);
	ЗапросПомещениеВоВременнуюТаблицу.МенеджерВременныхТаблиц = Запрос.МенеджерВременныхТаблиц;
	ЗапросПомещениеВоВременнуюТаблицу.Параметры.Вставить("Таблица", ДвиженияДенежныеСредстваКонтрагент);
	ЗапросПомещениеВоВременнуюТаблицу.Выполнить();
	
	Запрос.УстановитьПараметр("ВтДвиженияДенежныеСредстваКонтрагентИнициализирована", Истина);
	
КонецПроцедуры


Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&ИдентификаторМетаданных КАК ТипСсылки,
	|	&ХозОперацияДляРеестра КАК ХозяйственнаяОперация,
	|	&Организация КАК Организация,
	|	&Партнер КАК Партнер,
	|	НЕОПРЕДЕЛЕНО КАК МестоХранения,
	|	НЕОПРЕДЕЛЕНО КАК Контрагент,
	|	&Подразделение КАК Подразделение,
	|	&Период КАК ДатаДокументаИБ,
	|	&Ссылка КАК Ссылка,
	|	&Номер КАК НомерДокументаИБ,
	|	НЕОПРЕДЕЛЕНО КАК Статус,
	|	&Кассир КАК Ответственный,
	|	НЕОПРЕДЕЛЕНО КАК Автор,
	|	ЛОЖЬ КАК ДополнительнаяЗапись,
	|	НЕОПРЕДЕЛЕНО КАК Дополнительно,
	|	&Комментарий КАК Комментарий,
	|	&Проведен КАК Проведен,
	|	&ПометкаУдаления КАК ПометкаУдаления,
	|	&Период КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать КАК НомерПервичногоДокумента,
	|	&СуммаДокумента КАК Сумма,
	|	&Валюта КАК Валюта,
	|	НЕОПРЕДЕЛЕНО КАК Договор,
	|	НЕОПРЕДЕЛЕНО КАК НаправлениеДеятельности,
	|	ЛОЖЬ КАК СторноИсправление,
	|	НЕОПРЕДЕЛЕНО КАК СторнируемыйДокумент,
	|	НЕОПРЕДЕЛЕНО КАК ИсправляемыйДокумент,
	|	&Период КАК ДатаОтраженияВУчете,
	|	НЕОПРЕДЕЛЕНО КАК Приоритет";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.РеализацияПодарочныхСертификатов";
	ЗначенияПараметров = Новый Структура;
	ЗначенияПараметров.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.РеализацияПодарочныхСертификатов"));
	ЗначенияПараметров.Вставить("ХозОперацияДляРеестра", Перечисления.ХозяйственныеОперации.РеализацияПодарочныхСертификатов);
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ПереопределениеРасчетаПараметров = Новый Структура;
		ПереопределениеРасчетаПараметров.Вставить("Подразделение", "КассаККМ.Подразделение");
		
		ЗначенияПараметров.Вставить("Подразделение", Справочники.СтруктураПредприятия.ПустаяСсылка());
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
			ТекстЗапроса, ПолноеИмяДокумента, СинонимТаблицыДокумента, Ложь, ПереопределениеРасчетаПараметров);
	Иначе
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
			ТекстЗапроса, ПолноеИмяДокумента, СинонимТаблицыДокумента);
	КонецЕсли;
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	Если ПолучитьФункциональнуюОпцию("ИспользоватьПодарочныеСертификаты") Тогда
		
		// Подарочный сертификат
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьПодарочныхСертификатов";
		КомандаПечати.Идентификатор = "ПодарочныйСертификат";
		КомандаПечати.Представление = НСтр("ru = 'Подарочный сертификат'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
	КонецЕсли;

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
КонецПроцедуры

// Функция получает данные для формирования печатной формы Подарочный сертификат.
//
//
// Возвращаемое значение:
// 	Структура:
//		* РезультатЗапроса - РезультатЗапроса - Содержит информацию для заполнения печатной формы
//		* ЗаголовокДокумента - Строка - Отображаемый заголовок табличного документа
//
Функция ПолучитьДанныеДляПечатнойФормыПодарочныйСертификат(ПараметрыПечати, МассивОбъектов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПодарочныеСертификаты.Ссылка        КАК Ссылка,
	|	ПодарочныеСертификаты.Код           КАК СерийныйНомер,
	|	ПодарочныеСертификаты.Штрихкод      КАК Штрихкод,
	|	ПодарочныеСертификаты.МагнитныйКод  КАК МагнитныйКод,
	|	ПодарочныеСертификаты.Владелец.Номинал  КАК Номинал,
	|	ПодарочныеСертификаты.Владелец.Валюта   КАК Валюта
	|ИЗ
	|	Справочник.ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|ГДЕ
	|	ПодарочныеСертификаты.Ссылка В (ВЫБРАТЬ Т.ПодарочныйСертификат ИЗ Документ.РеализацияПодарочныхСертификатов.ПодарочныеСертификаты КАК Т ГДЕ Т.Ссылка В(&МассивДокументов))
	|");
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДанныхДляПечати    = Новый Структура("РезультатЗапроса, ЗаголовокДокумента",
	                                               РезультатЗапроса, НСтр("ru = 'Подарочный сертификат'"));
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
