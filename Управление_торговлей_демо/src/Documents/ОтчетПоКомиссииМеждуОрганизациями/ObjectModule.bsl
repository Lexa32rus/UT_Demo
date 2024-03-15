#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует параметры заполнения видов запасов дополнительных свойств документа, используемых при записи документа
// в режиме 'Проведения' или 'Отмены проведения'.
//
// Параметры:
//	ДокументОбъект - ДокументОбъект.ОтчетПоКомиссииМеждуОрганизациями - документ, для которого выполняется инициализация параметров.
//	РежимЗаписи - РежимЗаписиДокумента - режим записи документа.
//
Процедура ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ДокументОбъект, РежимЗаписи = Неопределено) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Заполняет реквизиты, хранящие информацию о видах запасов и аналитиках учета номенклатуры в табличной части 'Товары'
// документа, а также заполняет табличную часть 'ВидыЗапасов'.
//
// Параметры:
//	Отказ - Булево - признак того, что не удалось заполнить данные.
//	ТаблицыДокумента - см. Документы.ОтчетПоКомиссииМеждуОрганизациями.КоллекцияТабличныхЧастейТоваров.
//
Процедура ЗаполнитьВидыЗапасовПриОбмене(Отказ, ТаблицыДокумента) Экспорт
	
	ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров();
	
	Если ТаблицыДокумента <> Неопределено Тогда
		ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(ТаблицыДокумента);
		ДополнительныеСвойства.Вставить("ТаблицыЗаполненияВидовЗапасовПриОбмене", ТаблицыДокумента);
	Иначе
		ИмяПараметра = "ТаблицыДокумента";
		
		ТекстИсключения = НСтр("ru = 'Для заполнения видов запасов не передан параметр ""%1"".'");
		ТекстИсключения = СтрШаблон(ТекстИсключения, ИмяПараметра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ЗаполнитьВидыЗапасов(Отказ);
	ДополнительныеСвойства.Удалить("ТаблицыЗаполненияВидовЗапасовПриОбмене");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ИдентификаторПлатежа		= Неопределено;
	ВидыЗапасовУказаныВручную	= Ложь;
	
	ВидыЗапасов.Очистить();
	
	РасшифровкаПлатежаСКлиентом.Очистить();
	РасшифровкаПлатежаСПоставщиком.Очистить();
	РасшифровкаПлатежаСКлиентомВознаграждение.Очистить();
	РасшифровкаПлатежаСПоставщикомВознаграждение.Очистить();
	
	ТекущаяСтрока = Новый Структура("СтавкаНДС", Справочники.СтавкиНДС.ПустаяСсылка());

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("СкорректироватьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(ЭтотОбъект));
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	СтавкаНДСВознаграждения = ТекущаяСтрока.СтавкаНДС;

	СуммаНДСВознаграждения = УчетНДСУПКлиентСервер.РассчитатьСуммуНДС(СуммаВознаграждения,
		УчетНДСУПКлиентСервер.ЗначениеСтавкиНДС(СтавкаНДСВознаграждения));
	
	СтруктураДействий = Новый Структура;
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	СтруктураДействий.Вставить("СкорректироватьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(ЭтотОбъект));
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Товары, СтруктураДействий, КэшированныеЗначения);
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВТЧ(ЭтотОбъект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(КэшированныеЗначения.ОбработанныеСтроки, СтруктураДействий, Неопределено);
	
	ПараметрыПересчета = УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ПараметрыПолученияКоэффициентаРНПТ(
							ЭтотОбъект,
							"Организация");
	УчетПрослеживаемыхТоваровЛокализация.ЗаполнитьКоличествоПоРНПТВТабличнойЧасти(ПараметрыПересчета, Товары);
	
	ВзаиморасчетыСервер.ПриКопировании(ЭтотОбъект);
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "Товары,ВидыЗапасов");
	
	ОтчетПоКомиссииМеждуОрганизациямиЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Автор = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ЗаполнятьПоТоварамКОформлению") Тогда
		
		Комиссионер = ДанныеЗаполнения.Комиссионер;
		Валюта = ДанныеЗаполнения.Валюта;
		Организация = ДанныеЗаполнения.Организация;
		НачалоПериода = ДанныеЗаполнения.НачалоПериода;
		КонецПериода = ДанныеЗаполнения.КонецПериода;
		Если ТекущаяДатаСеанса() > КонецМесяца(КонецПериода)
			И ЗначениеЗаполнено(КонецПериода) Тогда
			Дата = КонецПериода;
		Иначе
			Дата = ТекущаяДатаСеанса();
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Договор") Тогда
			Договор = ДанныеЗаполнения.Договор;
			
			ИменаПолей = "НаправлениеДеятельности, ПорядокРасчетов";
			РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, ИменаПолей);
			НаправлениеДеятельности = РеквизитыДоговора.НаправлениеДеятельности;
			ПорядокРасчетов = РеквизитыДоговора.ПорядокРасчетов;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("НалогообложениеНДС") Тогда
			НалогообложениеНДС = ДанныеЗаполнения.НалогообложениеНДС;
		КонецЕсли;
		
		ЗаполнитьТоварыПоОстаткамКОформлению(ДанныеЗаполнения.КонецПериода);
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ВзаиморасчетыСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);
	
	ОтчетПоКомиссииМеждуОрганизациямиЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	ПроверитьОрганизации(Отказ);
	
	Если ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(Комиссионер) Тогда
		
		СтруктураПроверки = Справочники.Организации.СтраныРегистрацииИВалютыРегламентированногоУчетаСовпадают(Организация, Комиссионер);
		
		Если Не СтруктураПроверки.ВалютыСовпадают Тогда
			ТекстОшибки = НСтр("ru = 'Валюты регламентированного учета комитента %1 и комиссионера %2 должны совпадать.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Организация, Комиссионер);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "Организация",, Отказ);
		КонецЕсли;
		
		Если Не СтруктураПроверки.СтраныСовпадают Тогда
			ТекстОшибки = НСтр("ru = 'Страны регистрации комитента %1 и комиссионера %2 должны совпадать.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Организация, Комиссионер);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "Организация",, Отказ);
		КонецЕсли;
	
	КонецЕсли;
	
	Документы.ОтчетПоКомиссииМеждуОрганизациями.ЗаполнитьИменаРеквизитовПоСпособуРасчетаВознаграждения(
		СпособРасчетаВознаграждения,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	Если Не РасчетыЧерезОтдельногоКонтрагента Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Партнер");
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоПоРНПТ");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерГТД");
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	КомиссионнаяТорговляСервер.ПроверитьКорректностьПериода(ЭтотОбъект, Отказ);
	
	ПроверитьКорректностьПериодаИДаты(Отказ);
	
	Если СпособРасчетаВознаграждения <> Перечисления.СпособыРасчетаКомиссионногоВознаграждения.НеРассчитывается Тогда
		КомиссионнаяТорговляСервер.ПроверитьУслугуПоКомиссионномуВознаграждению(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ОтчетПоКомиссииМеждуОрганизациямиЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	РасчетСуммаДокумента = Товары.Итог("СуммаПродажи");
	Если СуммаДокумента <> РасчетСуммаДокумента Тогда
		СуммаДокумента = РасчетСуммаДокумента;
	КонецЕсли;
	
	РасчетСуммаВознаграждения = Товары.Итог("СуммаВознаграждения");
	Если СуммаВознаграждения <> РасчетСуммаВознаграждения Тогда
		СуммаВознаграждения = РасчетСуммаВознаграждения;
	КонецЕсли;
	
	Если СуммаНДСВознаграждения <> Товары.Итог("СуммаНДСВознаграждения") Тогда
		КомиссионнаяТорговляСервер.ЗаполнитьСуммуНДСВознагражденияВТабличнойЧасти(Товары, СуммаНДСВознаграждения);
	КонецЕсли;
	
	УчетПрослеживаемыхТоваровЛокализация.ОчиститьДанныеПоИмпортнымТоварамВДокументахКомиссионера(ЭтотОбъект, Истина);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров();
		ЗаполнитьВидыЗапасов(Отказ);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Товары,ВидыЗапасов");
	
	Если РасчетыЧерезОтдельногоКонтрагента
		И Организация <> Справочники.Организации.УправленческаяОрганизация Тогда
		
		Если Не ЗначениеЗаполнено(ДатаВходящегоДокумента) Тогда
			ДатаВходящегоДокумента = НачалоДня(Дата);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(НомерВходящегоДокумента) Тогда
			НомерВходящегоДокумента = Номер;
		КонецЕсли;
		
	Иначе
		Если ЗначениеЗаполнено(ДатаВходящегоДокумента) Тогда
			ДатаВходящегоДокумента = Неопределено;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НомерВходящегоДокумента) Тогда
			НомерВходящегоДокумента = "";
		КонецЕсли;
	КонецЕсли;
		
	Если Не РасчетыЧерезОтдельногоКонтрагента Тогда
		Если ЗначениеЗаполнено(Партнер) Тогда
			Партнер = Неопределено;
		КонецЕсли;
		Если ЗначениеЗаполнено(Контрагент) Тогда
			Контрагент = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	// Очистим реквизиты документа не используемые для способа расчета вознаграждения.
	МассивВсехРеквизитов		= Новый Массив;
	МассивРеквизитовОперации	= Новый Массив;
	
	Документы.ОтчетПоКомиссииМеждуОрганизациями.ЗаполнитьИменаРеквизитовПоСпособуРасчетаВознаграждения(
		СпособРасчетаВознаграждения,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	Если ЭтоНовый()
		И Не ЗначениеЗаполнено(Номер) Тогда
		
		УстановитьНовыйНомер();
		
	КонецЕсли;
	
	ИдентификаторПлатежа = ОбщегоНазначенияУТ.ПолучитьУникальныйИдентификаторПлатежа(ЭтотОбъект);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурКомиссионеру(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыКомиссионеруПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления, Проведен);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления, Проведен);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления, Проведен);
	
	ВзаиморасчетыСервер.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	
	ОтчетПоКомиссииМеждуОрганизациямиЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Если Не ЗначениеЗаполнено(Автор)
		И ЭтоНовый() Тогда
		
		Автор = Пользователи.ТекущийПользователь();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурКомиссионеру(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыКомиссионеруПриПроведении(ПараметрыРегистрации);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПриПроведении(ПараметрыРегистрации);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПриПроведении(ПараметрыРегистрации);
	
	ОтчетПоКомиссииМеждуОрганизациямиЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурКомиссионеру(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыКомиссионеруПриУдаленииПроведения(ПараметрыРегистрации);
	
	ПараметрыРегистрации = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПриУдаленииПроведения(ПараметрыРегистрации);
	
	ПараметрыРегистрации = Документы.ВыкупВозвратнойТарыУПоставщика.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПриУдаленииПроведения(ПараметрыРегистрации);
	
	ОтчетПоКомиссииМеждуОрганизациямиЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ОтчетПоКомиссииМеждуОрганизациямиЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьТоварыПоОстаткамКОформлению(ДатаЗаполнения) Экспорт
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Дата",				Дата);
	ПараметрыЗаполнения.Вставить("НачалоПериода",		НачалоПериода);
	ПараметрыЗаполнения.Вставить("КонецПериода",		КонецПериода);
	ПараметрыЗаполнения.Вставить("Организация",			Комиссионер);
	ПараметрыЗаполнения.Вставить("Партнер",				Организация);
	ПараметрыЗаполнения.Вставить("Контрагент",			Неопределено);
	ПараметрыЗаполнения.Вставить("Соглашение",			Справочники.СоглашенияСПоставщиками.ПустаяСсылка());
	ПараметрыЗаполнения.Вставить("Договор",				Договор);
	ПараметрыЗаполнения.Вставить("Валюта",				Валюта);
	ПараметрыЗаполнения.Вставить("НалогообложениеНДС",	НалогообложениеНДС);
	ПараметрыЗаполнения.Вставить("ЦенаВключаетНДС",		ЦенаВключаетНДС);
	ПараметрыЗаполнения.Вставить("Товары",				Товары);
	
	ЕстьНомерГТД = УчетПрослеживаемыхТоваровЛокализация.ИспользоватьУчетПрослеживаемыхИмпортныхТоваров(Дата);
	
	КомиссионнаяТорговляСервер.ЗаполнитьПоТоварамКОформлениюОтчетовКомитентуЗаПериод(
		ПараметрыЗаполнения,
		НачалоПериода,
		?(ЗначениеЗаполнено(КонецПериода), КонецПериода, КонецМесяца(Дата)),
		ЕстьНомерГТД);
	
	Если Не ЗначениеЗаполнено(ВидЦены) Тогда
		ВидЦены = Справочники.ВидыЦен.ВидЦеныПоУмолчанию(ВидЦены,
														Новый Структура("ИспользоватьПриПередачеМеждуОрганизациями",
																		Истина));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВидЦены) Тогда
		Реквизиты = Справочники.ВидыЦен.ПолучитьРеквизитыВидаЦены(ВидЦены);
		
		Если Не ЗначениеЗаполнено(Валюта) Тогда
			Валюта = Реквизиты.ВалютаЦены;
		КонецЕсли;
		
		ЦенаВключаетНДС = Реквизиты.ЦенаВключаетНДС;
		
		ПараметрыЗаполнения = Новый Структура;
		ПараметрыЗаполнения.Вставить("Дата",			Дата);
		ПараметрыЗаполнения.Вставить("Организация",		Организация);
		ПараметрыЗаполнения.Вставить("Валюта",			Валюта);
		ПараметрыЗаполнения.Вставить("ВидЦены",			ВидЦены);
		ПараметрыЗаполнения.Вставить("ПоляЗаполнения",	"Цена, ВидЦены");
		
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьСумму",		"КоличествоУпаковок");
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС",	СтруктураПересчетаСуммы);
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС",	СтруктураПересчетаСуммы);
		
		ЦеныПредприятияЗаполнениеСервер.ЗаполнитьЦены(Товары, Неопределено, ПараметрыЗаполнения, СтруктураДействий);
	КонецЕсли;
	
	ПараметрыПолученияКоэффициентаРНПТ = УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ПараметрыПолученияКоэффициентаРНПТ(
											ЭтотОбъект,
											"Организация");
	УчетПрослеживаемыхТоваровЛокализация.ЗаполнитьКоличествоПоРНПТВТабличнойЧасти(ПараметрыПолученияКоэффициентаРНПТ,
																					Товары);
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Организация		= ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Валюта			= ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
	ВидЦены			= Справочники.ВидыЦен.ВидЦеныПоУмолчанию(ВидЦены, 
						Новый Структура("ИспользоватьПриПередачеМеждуОрганизациями", Истина));
	
	ХозяйственнаяОперация = Перечисления.ТипыДоговоровМеждуОрганизациями.Комиссионный;
	ГруппаФинансовогоУчета	= Справочники.ГруппыФинансовогоУчетаРасчетов.ПолучитьГруппуФинансовогоУчетаПоУмолчанию(Организация, Валюта, ХозяйственнаяОперация);
	ГруппаФинансовогоУчетаПолучателя = Справочники.ГруппыФинансовогоУчетаРасчетов.ПолучитьГруппуФинансовогоУчетаПоУмолчанию(Организация, Валюта, ХозяйственнаяОперация, Истина);
	
	Если Не ЗначениеЗаполнено(НалогообложениеНДС) Тогда
		ПараметрыЗаполнения = Документы.ОтчетПоКомиссииМеждуОрганизациями.ПараметрыЗаполненияНалогообложенияНДС(ЭтотОбъект);
		УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС",  ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(ЭтотОбъект));
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВТЧ(ЭтотОбъект));
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", Новый Структура("ЦенаВключаетНДС", ЭтотОбъект.ЦенаВключаетНДС));
		СтруктураДействий.Вставить("ПересчитатьСуммуПродажиНДС");
		СтруктураДействий.Вставить("ОчиститьСуммуВознаграждения");
		
		ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Товары, СтруктураДействий, Неопределено);
		
	КонецЕсли;
	ОтветственныеЛицаСервер.ЗаполнитьМенеджера(ЭтотОбъект, Ложь);
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	Если НЕ ЗначениеЗаполнено(Менеджер) Тогда
		Менеджер = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

// Заполняет аналитики учета номенклатуры в табличных частях документа, хранящих информацию о товарах.
// Если параметр не передан, тогда будет выполнено заполнение данных в табличных частях документа.
//
// Параметры:
//	ТаблицыДокумента - см. Документы.ОтчетПоКомиссииМеждуОрганизациями.КоллекцияТабличныхЧастейТоваров.
//
Процедура ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(ТаблицыДокумента = Неопределено)
	
	Если ТаблицыДокумента = Неопределено Тогда
		ТаблицыДокумента = Документы.ОтчетПоКомиссииМеждуОрганизациями.КоллекцияТабличныхЧастейТоваров();
		
		ЗаполнитьЗначенияСвойств(ТаблицыДокумента, ЭтотОбъект);
	КонецЕсли;
	
	ТаблицаТовары = ТаблицыДокумента.Товары;
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(
					Перечисления.ХозяйственныеОперации.ОтчетКомитенту,
					Неопределено,
					Подразделение,
					Организация);
	
	ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
	ИменаПолей.СтатусУказанияСерий = "";
	ИменаПолей.Назначение = "";
	
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(ТаблицаТовары, МестаУчета, ИменаПолей);
	
КонецПроцедуры

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц		= ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов	= ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	Если Не Проведен
		Или ПерезаполнитьВидыЗапасов
		Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
		Или ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
		
		ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
		ПараметрыЗаполнения.ИмяТаблицыОстатков = "КомиссионныеТоварыИнтеркампани";
		ПараметрыЗаполнения.ПриПодбореПоИнтеркампаниИсключатьОрганизации = Комиссионер;
		
		ОтборыВидовЗапасов = ПараметрыЗаполнения.ОтборыВидовЗапасов;
		ОтборыВидовЗапасов.Организация = Комиссионер;
		ОтборыВидовЗапасов.ВладелецТовара = Организация;
		ОтборыВидовЗапасов.Валюта = Валюта;
		ОтборыВидовЗапасов.ТипЗапасов = Перечисления.ТипыЗапасов.КомиссионныйТовар;
		
		Если ЗначениеЗаполнено(Договор) Тогда
			ОтборыВидовЗапасов.Договор = Договор;
		Иначе
			ОтборыВидовЗапасов.Договор = Новый Массив; // Массив из СправочникСсылка.ДоговорыМеждуОрганизациями
			ОтборыВидовЗапасов.Договор.Добавить(Неопределено);
			ОтборыВидовЗапасов.Договор.Добавить(Справочники.ДоговорыМеждуОрганизациями.ПустаяСсылка());
		КонецЕсли;
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоКомиссионнымТоварамИнтеркампани(ЭтотОбъект,
																			МенеджерВременныхТаблиц,
																			Отказ,
																			ПараметрыЗаполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВременныеТаблицыДанныхДокумента()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&Дата			КАК Дата,
	|	&Организация	КАК Организация,
	|	&Комиссионер	КАК Комиссионер,
	|	&Организация	КАК Партнер,
	|	&Организация	КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	&Договор		КАК Договор,
	|	&Валюта			КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтчетПоКомиссииМеждуОрганизациями) КАК ХозяйственнаяОперация,
	|	ЛОЖЬ			КАК ЕстьСделкиВТабличнойЧасти,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки							КАК НомерСтроки,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры			КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура							КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика						КАК Характеристика,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)		КАК Назначение,
	|	ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)	КАК Серия,
	|	0													КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.Упаковка								КАК Упаковка,
	|	ТаблицаТоваров.Количество							КАК Количество,
	|	ТаблицаТоваров.КоличествоУпаковок					КАК КоличествоУпаковок,
	|	ТаблицаТоваров.КоличествоПоРНПТ						КАК КоличествоПоРНПТ,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)			КАК Склад,
	|	ТаблицаТоваров.СтавкаНДС							КАК СтавкаНДС,
	|	ТаблицаТоваров.СуммаПродажи							КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаПродажиНДС						КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаВознаграждения					КАК СуммаВознаграждения,
	|	ТаблицаТоваров.СуммаНДСВознаграждения				КАК СуммаНДСВознаграждения,
	|	ТаблицаТоваров.НомерГТД								КАК НомерГТД,
	|	ТаблицаТоваров.СчетФактураВыставленныйКомиссионера	КАК СчетФактураВыставленныйКомиссионера,
	|	ТаблицаТоваров.ДатаСчетаФактурыКомиссионера			КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаТоваров.Покупатель							КАК Покупатель,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка)	КАК Сделка,
	|	ИСТИНА												КАК ПодбиратьВидыЗапасов
	|ПОМЕСТИТЬ ВтТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки							КАК НомерСтроки,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры			КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура							КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика						КАК Характеристика,
	|	ТаблицаТоваров.Назначение							КАК Назначение,
	|	ТаблицаТоваров.Серия								КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий					КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.Упаковка								КАК Упаковка,
	|	ТаблицаТоваров.Количество							КАК Количество,
	|	ТаблицаТоваров.КоличествоУпаковок					КАК КоличествоУпаковок,
	|	ТаблицаТоваров.КоличествоПоРНПТ						КАК КоличествоПоРНПТ,
	|	ТаблицаТоваров.Склад								КАК Склад,
	|	ТаблицаТоваров.СтавкаНДС							КАК СтавкаНДС,
	|	ТаблицаТоваров.СуммаСНДС							КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС								КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаВознаграждения					КАК СуммаВознаграждения,
	|	ТаблицаТоваров.СуммаНДСВознаграждения				КАК СуммаНДСВознаграждения,
	|	ТаблицаТоваров.НомерГТД								КАК НомерГТД,
	|	ТаблицаТоваров.СчетФактураВыставленныйКомиссионера	КАК СчетФактураВыставленныйКомиссионера,
	|	ТаблицаТоваров.ДатаСчетаФактурыКомиссионера			КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаТоваров.Покупатель							КАК Покупатель,
	|	ТаблицаТоваров.Сделка								КАК Сделка,
	|	ТаблицаТоваров.ПодбиратьВидыЗапасов					КАК ПодбиратьВидыЗапасов
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	ВтТаблицаТоваров КАК ТаблицаТоваров
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ТаблицаТоваров.Номенклатура = СправочникНоменклатура.Ссылка
	|ГДЕ
	|	СправочникНоменклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|												ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки							КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры			КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов							КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД								КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество							КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ						КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СтавкаНДС							КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.СуммаСНДС							КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС								КАК СуммаНДС,
	|	ТаблицаВидыЗапасов.СуммаВознаграждения					КАК СуммаВознаграждения,
	|	ТаблицаВидыЗапасов.СуммаНДСВознаграждения				КАК СуммаНДСВознаграждения,
	|	ТаблицаВидыЗапасов.ДатаСчетаФактурыКомиссионера			КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаВидыЗапасов.СчетФактураВыставленныйКомиссионера	КАК СчетФактураВыставленныйКомиссионера,
	|	ТаблицаВидыЗапасов.Покупатель							КАК Покупатель,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)				КАК СкладОтгрузки,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)				КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка)		КАК Сделка,
	|	&ВидыЗапасовУказаныВручную								КАК ВидыЗапасовУказаныВручную
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки							КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры			КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура									КАК Номенклатура,
	|	Аналитика.Характеристика								КАК Характеристика,
	|	Аналитика.Серия											КАК Серия,
	|	ТаблицаВидыЗапасов.ВидЗапасов							КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД								КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество							КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ						КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СтавкаНДС							КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.СуммаСНДС							КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС								КАК СуммаНДС,
	|	ТаблицаВидыЗапасов.СуммаВознаграждения					КАК СуммаВознаграждения,
	|	ТаблицаВидыЗапасов.СуммаНДСВознаграждения				КАК СуммаНДСВознаграждения,
	|	ТаблицаВидыЗапасов.ДатаСчетаФактурыКомиссионера			КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаВидыЗапасов.СчетФактураВыставленныйКомиссионера	КАК СчетФактураВыставленныйКомиссионера,
	|	ТаблицаВидыЗапасов.Покупатель							КАК Покупатель,
	|	ТаблицаВидыЗапасов.Склад								КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.Склад								КАК Склад,
	|	ТаблицаВидыЗапасов.Сделка								КАК Сделка,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную			КАК ВидыЗапасовУказаныВручную
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ТаблицаТоваров = ?(ДополнительныеСвойства.Свойство("ТаблицыЗаполненияВидовЗапасовПриОбмене")
							И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене <> Неопределено
							И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Свойство("Товары"),
						ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Товары,
						Товары);
	
	Запрос.УстановитьПараметр("Ссылка",						Ссылка);
	Запрос.УстановитьПараметр("Дата",						Дата);
	Запрос.УстановитьПараметр("Организация",				Организация);
	Запрос.УстановитьПараметр("Комиссионер",				Комиссионер);
	Запрос.УстановитьПараметр("Договор",					Договор);
	Запрос.УстановитьПараметр("Валюта",						Валюта);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную",	ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ТаблицаТоваров",				ТаблицаТоваров);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов",			ВидыЗапасов);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

Процедура ПроверитьОрганизации(Отказ)
	
	Если ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(Комиссионер) Тогда
		
		Если Организация = Комиссионер Тогда
			
			Текст = НСтр("ru = 'Одна и та же организация не может являться комитентом и комиссионером одновременно'");
			ОбщегоНазначения.СообщитьПользователю(Текст, ЭтотОбъект, "Организация", , Отказ);
			
		ИначеЕсли ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс")
			И Справочники.Организации.ОрганизацииВзаимосвязаныПоОрганизационнойСтруктуре(Организация, Комиссионер) Тогда
		
			Текст = НСтр("ru = 'Организация-получатель не должна быть взаимосвязана с организацией-отправителем по организационной структуре.'");
			ОбщегоНазначения.СообщитьПользователю(Текст, ЭтотОбъект, "Комиссионер", , Отказ);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Организация, Дата, Комиссионер, Валюта";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Функция ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.СтавкаНДС					КАК СтавкаНДС,
	|	ТаблицаТоваров.ДатаСчетаФактурыКомиссионера	КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаТоваров.Покупатель					КАК Покупатель,
	|	ТаблицаТоваров.НомерГТД						КАК НомерГТД
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры			КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.СтавкаНДС							КАК СтавкаНДС,
	|		ТаблицаТоваров.ДатаСчетаФактурыКомиссионера			КАК ДатаСчетаФактурыКомиссионера,
	|		ТаблицаТоваров.СчетФактураВыставленныйКомиссионера	КАК СчетФактураВыставленныйКомиссионера,
	|		ТаблицаТоваров.Покупатель							КАК Покупатель,
	|		ТаблицаТоваров.НомерГТД								КАК НомерГТД,
	|		ТаблицаТоваров.Количество							КАК Количество,
	|		ТаблицаТоваров.Количество							КАК КоличествоПоРНПТ,
	|		ТаблицаТоваров.СуммаСНДС							КАК СуммаСНДС,
	|		ТаблицаТоваров.СуммаНДС								КАК СуммаНДС,
	|		ТаблицаТоваров.СуммаВознаграждения					КАК СуммаВознаграждения,
	|		ТаблицаТоваров.СуммаНДСВознаграждения				КАК СуммаНДСВознаграждения
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|	ГДЕ
	|		ТаблицаТоваров.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|														ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры			КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаВидыЗапасов.СтавкаНДС							КАК СтавкаНДС,
	|		ТаблицаВидыЗапасов.ДатаСчетаФактурыКомиссионера			КАК ДатаСчетаФактурыКомиссионера,
	|		ТаблицаВидыЗапасов.СчетФактураВыставленныйКомиссионера	КАК СчетФактураВыставленныйКомиссионера,
	|		ТаблицаВидыЗапасов.Покупатель							КАК Покупатель,
	|		ТаблицаВидыЗапасов.НомерГТД								КАК НомерГТД,
	|		-ТаблицаВидыЗапасов.Количество							КАК Количество,
	|		-ТаблицаВидыЗапасов.Количество							КАК КоличествоПоРНПТ,
	|		-ТаблицаВидыЗапасов.СуммаСНДС							КАК СуммаСНДС,
	|		-ТаблицаВидыЗапасов.СуммаНДС							КАК СуммаНДС,
	|		-ТаблицаВидыЗапасов.СуммаВознаграждения					КАК СуммаВознаграждения,
	|		-ТаблицаВидыЗапасов.СуммаНДСВознаграждения				КАК СуммаНДСВознаграждения
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|	
	|	) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.СтавкаНДС,
	|	ТаблицаТоваров.ДатаСчетаФактурыКомиссионера,
	|	ТаблицаТоваров.СчетФактураВыставленныйКомиссионера,
	|	ТаблицаТоваров.Покупатель,
	|	ТаблицаТоваров.НомерГТД
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТоваров.Количество) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.КоличествоПоРНПТ) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаСНДС) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаНДС) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаВознаграждения) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаНДСВознаграждения) <> 0";
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	РезультатЗапрос = Запрос.Выполнить();
	
	Возврат (Не РезультатЗапрос.Пустой());
	
КонецФункции

Процедура ПроверитьКорректностьПериодаИДаты(Отказ) Экспорт
	
	Если КонецМесяца(Дата) <> КонецМесяца(КонецПериода)
		Или НачалоМесяца(Дата) <> НачалоМесяца(НачалоПериода) Тогда
		
		ТекстСообщения = НСтр("ru='Период, за который отчитывается комиссионер, должен находиться в том же месяце, в котором проводится документ.'");
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Неопределено, "УстановитьИнтервал", "Объект", Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
