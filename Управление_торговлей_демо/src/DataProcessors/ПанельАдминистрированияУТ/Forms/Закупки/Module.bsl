#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = НастройкиСистемыПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	РежимРаботы = Новый Структура;
	
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьВерсионированиеОбъектов");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьСинхронизациюДанных");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьЗаказыКлиентов");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьЗаказыНаВнутреннееПотребление");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьЗаказыНаСборку");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьЗаявкиНаВозвратТоваровОтКлиентов");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьПередачиТоваровМеждуОрганизациями");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьНесколькоСкладов");
	ВнешниеРодительскиеКонстанты.Вставить("ПартионныйУчетВерсии22");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьОтветственноеХранениеВПроцессеЗакупки");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьТоварыВПутиОтПоставщиков");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьНеотфактурованныеПоставки");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьВалютныеПлатежи");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьОказаниеАгентскихУслугПриЗакупке");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи");
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	Элементы.ПояснениеИспользованиеЭтаповОплатыВЗакупках.Заголовок = НСтр(
		"ru = 'Настройка определяет возможные варианты планирования оплаты в документах ""Отчет комитенту"".'");
	
	
	// Обновление состояния элементов
	УстановитьДоступность();
	НастройкиСистемыЛокализация.ПриСозданииНаСервере_Закупки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗначенияПоУмолчанию = Новый Структура;
	
	НастройкиСистемыЛокализация.ПриЧтенииНаСервере_Закупки(ЭтаФорма);
	ОбщегоНазначенияУТКлиентСервер.СохранитьЗначенияДоИзменения(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
	 ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
	 		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
	 			Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
	Если Источник = ЭтаФорма Тогда
		Если Параметр.Свойство("Элемент") Тогда
			Подключаемый_ПриИзмененииРеквизита(Параметр.Элемент, Истина, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьЗаказыПоставщикамПриИзменении(Элемент)
	
	Если НаборКонстант.ИспользоватьЗаказыПоставщикам И НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств Тогда
		
		УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Истина);
		
	Иначе
		
		УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Ложь);
		
	КонецЕсли;

	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПоступлениеПоНесколькимЗаказамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура НеЗакрыватьЗаказыПоставщикамБезПолногоПоступленияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура НеЗакрыватьЗаказыПоставщикамБезПолнойОплатыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАктыОРасхожденияхПослеПриемкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтветственноеХранениеСПравомПродажиПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНеотфактурованныеПоставкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьТоварыВПутиОтПоставщиковПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСогласованиеЗаказовПоставщикамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСтатусыЗаказовПоставщикамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПричиныОтменыЗаказовПоставщикамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСкладыВТабличнойЧастиДокументовЗакупкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеЭтаповОплатыВЗакупкахПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДоговорыСПоставщикамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКорректировкиПриобретенийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРеквизита(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВерсионированиеДокументовЗакупки(Команда)
	
	Результат = Новый Структура;
	СохранитьЗначениеРеквизита("ВключитьВерсионированиеДокументовЗакупки", Результат);
	
	Если Результат.Свойство("ВерсионированиеВключено") Тогда
		
		Если Результат.ВерсионированиеВключено Тогда
			Пояснение = НСтр("ru = 'Для документов заказов поставщику установлен вариант версионирования ""Версионировать при проведении""'");
		Иначе
			Пояснение = НСтр("ru = 'Для документов заказов поставщику версионирование уже было включено'");
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Версионирование включено'"),, Пояснение, БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НазначитьОтветственныхЗаСогласованиеЛогистическихУсловийДокументовЗакупки(Команда)
	ОткрытьФорму("РегистрСведений.ИсполнителиЗадач.Форма.ИсполнителиРолиСОбъектомАдресации", 
		Новый Структура("ОсновнойОбъектАдресации,Роль", 
			Неопределено, 
			ПредопределенноеЗначение("Справочник.РолиИсполнителей.СогласующийЛогистическиеУсловияЗакупок")));
КонецПроцедуры

&НаКлиенте
Процедура НазначитьОтветственныхЗаСогласованиеФинансовыхУсловийДокументовЗакупки(Команда)
	ОткрытьФорму("РегистрСведений.ИсполнителиЗадач.Форма.ИсполнителиРолиСОбъектомАдресации", 
		Новый Структура("ОсновнойОбъектАдресации,Роль", 
			Неопределено, 
			ПредопределенноеЗначение("Справочник.РолиИсполнителей.СогласующийФинансовыеУсловияЗакупок")));
КонецПроцедуры

&НаКлиенте
Процедура НазначитьОтветственныхЗаСогласованиеЦеновыхУсловийДокументовЗакупки(Команда)
	ОткрытьФорму("РегистрСведений.ИсполнителиЗадач.Форма.ИсполнителиРолиСОбъектомАдресации", 
		Новый Структура("ОсновнойОбъектАдресации,Роль", 
			Неопределено, 
			ПредопределенноеЗначение("Справочник.РолиИсполнителей.СогласующийЦеновыеУсловияЗакупок")));
КонецПроцедуры

&НаКлиенте
Процедура НазначитьОтветственныхЗаСогласованиеКоммерческихУсловийДокументовЗакупки(Команда)
	ОткрытьФорму("РегистрСведений.ИсполнителиЗадач.Форма.ИсполнителиРолиСОбъектомАдресации", 
		Новый Структура("ОсновнойОбъектАдресации,Роль", 
			Неопределено, 
			ПредопределенноеЗначение("Справочник.РолиИсполнителей.СогласующийКоммерческиеУсловияЗакупок")));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина, ВнешнееИзменение = Ложь)
	
	Если НЕ ВнешнееИзменение Тогда
		НастройкиСистемыКлиентЛокализация.ПриИзмененииРеквизита_Закупки(
			Элемент,
			ЭтаФорма);
	КонецЕсли;
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаНавигационнойСсылкиФормы(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиСистемыКлиентЛокализация.ОбработкаНавигационнойСсылкиФормы_Закупки(Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Новый Структура);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если СтрНачинаетсяС(НРег(РеквизитПутьКДанным), НРег("НаборКонстант.")) Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
		КонстантаИмя = ЧастиИмени[1];
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
		Если РеквизитПутьКДанным = "ВключитьВерсионированиеДокументовЗакупки" Тогда
			НаборКонстант.ИспользоватьВерсионированиеОбъектов = Истина;
			КонстантаИмя = "ИспользоватьВерсионированиеОбъектов";
		КонецЕсли;

	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если НастройкиСистемыПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "ВключитьВерсионированиеДокументовЗакупки" Тогда
		
		ОбъектыДляВерсионирования = Новый Соответствие;
		
		Если НаборКонстант.ИспользоватьЗаказыПоставщикам Тогда
			ОбъектыДляВерсионирования.Вставить("Документ.ЗаказПоставщику", "ВерсионироватьПриПроведении");
		КонецЕсли;
		
		Результат.Вставить("ВерсионированиеВключено",
			ОбщегоНазначенияУТ.ВключитьВерсионированиеОбъектов(ОбъектыДляВерсионирования));
		УстановитьДоступностьВерсионированияДокументовЗакупки();
	КонецЕсли;
		
	Возврат КонстантаИмя
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаказыПоставщикам" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьЗаказыПоставщикам;
		ЕстьОбменыСФормированиемДоговоровПоЗаказам =
			Константы.ИспользоватьСинхронизациюДанных.Получить() И ОбменДаннымиУТУП.ЕстьОбменыСФормированиемДоговоровПоЗаказам();
		
		Элементы.ИспользоватьПоступлениеПоНесколькимЗаказам.Доступность 				= ЗначениеКонстанты И НЕ ЕстьОбменыСФормированиемДоговоровПоЗаказам;
		Элементы.НеЗакрыватьЗаказыПоставщикамБезПолногоПоступления.Доступность 			= ЗначениеКонстанты И НаборКонстант.ИспользоватьСтатусыЗаказовПоставщикам;
		Элементы.НеЗакрыватьЗаказыПоставщикамБезПолнойОплаты.Доступность				= ЗначениеКонстанты И НаборКонстант.ИспользоватьСтатусыЗаказовПоставщикам;
		Элементы.ИспользоватьСогласованиеЗаказовПоставщикам.Доступность 				= ЗначениеКонстанты И НаборКонстант.ИспользоватьСтатусыЗаказовПоставщикам;
		Элементы.ГруппаКомментарийИспользоватьПоступлениеПоНесколькимЗаказам.Видимость 	= ЕстьОбменыСФормированиемДоговоровПоЗаказам;
		Элементы.ИспользоватьСтатусыЗаказовПоставщикам.Доступность                      = ЗначениеКонстанты;
		Элементы.ИспользоватьПричиныОтменыЗаказовПоставщикам.Доступность                = ЗначениеКонстанты;
		Элементы.ГруппаКомментарийКонтролироватьЗакрытие.Видимость                      = ЗначениеКонстанты И НЕ НаборКонстант.ИспользоватьСтатусыЗаказовПоставщикам;
		
		УстановитьДоступностьВерсионированияДокументовЗакупки();
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСогласованиеЗаказовПоставщикам" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьСогласованиеЗаказовПоставщикам;
		
		Элементы.НазначитьОтветственныхЗаСогласованиеЛогистическихУсловийДокументовЗакупки.Доступность = ЗначениеКонстанты;
		Элементы.НазначитьОтветственныхЗаСогласованиеФинансовыхУсловийДокументовЗакупки.Доступность    = ЗначениеКонстанты;
		Элементы.НазначитьОтветственныхЗаСогласованиеЦеновыхУсловийДокументовЗакупки.Доступность       = ЗначениеКонстанты;
		Элементы.НазначитьОтветственныхЗаСогласованиеКоммерческихУсловийДокументовЗакупки.Доступность  = ЗначениеКонстанты;
		
		УстановитьДоступностьВерсионированияДокументовЗакупки();
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСтатусыЗаказовПоставщикам" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьСтатусыЗаказовПоставщикам;
		
		Элементы.ИспользоватьСогласованиеЗаказовПоставщикам.Доступность        = НаборКонстант.ИспользоватьЗаказыПоставщикам И ЗначениеКонстанты;
		Элементы.НеЗакрыватьЗаказыПоставщикамБезПолногоПоступления.Доступность = ЗначениеКонстанты;
		Элементы.НеЗакрыватьЗаказыПоставщикамБезПолнойОплаты.Доступность       = ЗначениеКонстанты;
		Элементы.ГруппаКомментарийКонтролироватьЗакрытие.Видимость             = НаборКонстант.ИспользоватьЗаказыПоставщикам И НЕ ЗначениеКонстанты;
			
		УстановитьДоступностьВерсионированияДокументовЗакупки();
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВерсионированиеОбъектов" ИЛИ РеквизитПутьКДанным = "" Тогда
		УстановитьДоступностьВерсионированияДокументовЗакупки();
	КонецЕсли;

	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьНесколькоСкладов;
		
		Элементы.ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки.Доступность = ЗначениеКонстанты;
		Элементы.ГруппаКомментарийИспользоватьСкладыВТабличнойЧастиДокументовЗакупки.Видимость = Не ЗначениеКонстанты;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьДоговорыСПоставщиками" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстантыОтветХранение 				= НаборКонстант.ИспользоватьОтветственноеХранениеВПроцессеЗакупки;
		ЗначениеКонстантыТоварыВПутиОтПоставщиков 	= НаборКонстант.ИспользоватьТоварыВПутиОтПоставщиков;
		ЗначениеКонстантыНеотфактурованныеПоставки 	= НаборКонстант.ИспользоватьНеотфактурованныеПоставки;
		ЗначениеКонстантыВалютныеПлатежи            = НаборКонстант.ИспользоватьВалютныеПлатежи;
		
		ДоговорыСПоставщикамиРедактированиеДоступно = Не ЗначениеКонстантыОтветХранение
													И Не ЗначениеКонстантыТоварыВПутиОтПоставщиков
													И Не ЗначениеКонстантыНеотфактурованныеПоставки
													И Не ЗначениеКонстантыВалютныеПлатежи;
			
		Элементы.ИспользоватьДоговорыСПоставщиками.Доступность 										= ДоговорыСПоставщикамиРедактированиеДоступно;
		Элементы.ГруппаДоговорыСПоставщикамиНевозможноОтключить.Видимость 							= Не ДоговорыСПоставщикамиРедактированиеДоступно;
		Элементы.КомментарийИспользоватьДоговорыСПоставщикамиПриемкаНаХранение.Видимость 			= ЗначениеКонстантыОтветХранение;
		Элементы.КомментарийИспользоватьДоговорыСПоставщикамиТоварыВПути.Видимость 					= ЗначениеКонстантыТоварыВПутиОтПоставщиков;
		Элементы.КомментарийИспользоватьДоговорыСПоставщикамиНеотфактурованныеПоставки.Видимость 	= ЗначениеКонстантыНеотфактурованныеПоставки;
		Элементы.КомментарийИспользоватьДоговорыСПоставщикамиВалютныеПлатежи.Видимость              = ЗначениеКонстантыВалютныеПлатежи;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьТоварыВПутиОтПоставщиков"
		Или РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНеотфактурованныеПоставки"
		Или РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстантыПартионныйУчетВерсии22 = РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22();

		// Настройка товаров в пути
		Элементы.ИспользоватьТоварыВПутиОтПоставщиков.Доступность = 
				ЗначениеКонстантыПартионныйУчетВерсии22;
		Элементы.ГруппаКомментарийИспользоватьТоварыВПутиОтПоставщиков.Видимость = 
			Не ЗначениеКонстантыПартионныйУчетВерсии22;
		Элементы.КомментарийИспользоватьТоварыВПутиОтПоставщиков.Видимость =
			Не ЗначениеКонстантыПартионныйУчетВерсии22;
		Элементы.КомментарийИспользоватьТоварыВПутиОтПоставщиковПоВидамЗапасов.Видимость =
			ЗначениеКонстантыПартионныйУчетВерсии22;
		
		// Настройка неотфактурованных поставок
		Элементы.ИспользоватьНеотфактурованныеПоставки.Доступность = 
				ЗначениеКонстантыПартионныйУчетВерсии22;
		Элементы.ГруппаКомментарийИспользоватьНеотфактурованныеПоставки.Видимость = 
			Не ЗначениеКонстантыПартионныйУчетВерсии22;
		Элементы.КомментарийИспользоватьНеотфактурованныеПоставки.Видимость =
			Не ЗначениеКонстантыПартионныйУчетВерсии22;
		Элементы.КомментарийИспользоватьНеотфактурованныеПоставкиПоВидамЗапасов.Видимость =
			ЗначениеКонстантыПартионныйУчетВерсии22;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОтветственноеХранениеВПроцессеЗакупки"
		Или РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьОтветственноеХранениеВПроцессеЗакупки;
		
		Элементы.АктыРасхожденийПослеПриемкиПоПриемкамТоваровНаХранение.Видимость = ЗначениеКонстанты;
		ИспользованиеАгентскойЗакупки = Константы.ИспользоватьОказаниеАгентскихУслугПриЗакупке.Получить();
		Элементы.ИспользоватьОтветственноеХранениеВПроцессеЗакупки.Доступность = Не ИспользованиеАгентскойЗакупки;
		Элементы.ГруппаКомментарийИспользоватьОтветственноеХранение.Видимость = ИспользованиеАгентскойЗакупки;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьАктыРасхожденийПослеПриемки"
		Или РеквизитПутьКДанным = "" Тогда
	
		ЗначениеКонстанты = НаборКонстант.ИспользоватьАктыРасхожденийПослеПриемки;
	
		Элементы.АктыРасхожденийПослеПриемкиПоВозвратам.Доступность = ЗначениеКонстанты;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "" Тогда
	
		ЗначениеКонстанты = Константы.ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи.Получить();
		
		Элементы.АктыРасхожденийПослеПриемкиПоПоступлениямТоваровОтХранителя.Видимость = ЗначениеКонстанты;
		
	КонецЕсли;
	
	ОбменДаннымиУТУП.УстановитьДоступностьНастроекУзлаИнформационнойБазы(ЭтаФорма);
	ОтображениеПредупрежденияПриРедактировании(РеквизитПутьКДанным);
	
	НастройкиСистемыЛокализация.УстановитьДоступность_Закупки(РеквизитПутьКДанным, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОтображениеПредупрежденияПриРедактировании(РеквизитПутьКДанным)
	
	СтруктураКонстант = Новый Структура(
		"ИспользоватьСтатусыЗаказовПоставщикам,
		|ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки");
	
	СтруктураКонстант.Вставить("ИспользоватьОтветственноеХранениеВПроцессеЗакупки");
	
	НастройкиСистемыЛокализация.ОтображениеПредупрежденияПриРедактировании_Закупки(СтруктураКонстант);
	
	Для Каждого КлючИЗначение Из СтруктураКонстант Цикл
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы[КлючИЗначение.Ключ],
			НаборКонстант[КлючИЗначение.Ключ]);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочие

&НаСервере
Процедура УстановитьДоступностьВерсионированияДокументовЗакупки()
	ИспользоватьВерсионированиеОбъекта = ОбщегоНазначенияУТ.ИспользоватьВерсионированиеОбъекта("Документ.ЗаказПоставщику");
	Элементы.ВключитьВерсионированиеДокументовЗакупки.Доступность =
		НаборКонстант.ИспользоватьСогласованиеЗаказовПоставщикам
		И (НЕ НаборКонстант.ИспользоватьВерсионированиеОбъектов
			ИЛИ НЕ ИспользоватьВерсионированиеОбъекта);
			
	Если НЕ ИспользоватьВерсионированиеОбъекта Тогда
		Элементы.ВключитьВерсионированиеДокументовЗакупки.Заголовок = НСтр("ru='Включить версионирование'");
	Иначе
		Элементы.ВключитьВерсионированиеДокументовЗакупки.Заголовок = НСтр("ru='Версионирование включено'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Процедура УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Использование)
	
	Константы.ИспользоватьЗаказыПоставщикамИЗаявкиНаРасходованиеДС.Установить(Использование);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти