///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Если Параметры.Свойство("КодВалюты") Тогда
			Объект.Код = Параметры.КодВалюты;
		КонецЕсли;
		
		Если Параметры.Свойство("НаименованиеКраткое") Тогда
			Объект.Наименование = Параметры.НаименованиеКраткое;
		КонецЕсли;
		
		Если Параметры.Свойство("НаименованиеПолное") Тогда
			Объект.НаименованиеПолное = Параметры.НаименованиеПолное;
		КонецЕсли;
		
		Если Параметры.Свойство("Загружается") И Параметры.Загружается Тогда
			Объект.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета;
		Иначе 
			Объект.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.РучнойВвод;
		КонецЕсли;
		
		Если Параметры.Свойство("ПараметрыПрописи") Тогда
			Объект.ПараметрыПрописи = Параметры.ПараметрыПрописи;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьДоступностьЭлементов(ЭтотОбъект);
	
	ЗаполнитьПодменюПараметрыПрописиВалюты();
	Элементы.ГиперссылкаПараметрыПрописиВалюты.Видимость = ФормыВводаПрописей.Количество() = 1;
	Элементы.ГруппаПараметрыПрописиВалюты.Видимость = ФормыВводаПрописей.Количество() > 1;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ФормулаРасчетаКурса.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
		Элементы.ОсновнаяВалюта.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Авто;
		Элементы.ГруппаШапка.ВыравниваниеЭлементовИЗаголовков =
			ВариантВыравниванияЭлементовИЗаголовков.ЭлементыПравоЗаголовкиЛево;
	КонецЕсли;
	
	//++ НЕ ГОСИС
	ИспользоватьНесколькоВалют = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	Если НЕ ИспользоватьНесколькоВалют Тогда
		Элементы.ГруппаСпособУстановкиКурса.Видимость = Ложь;
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = ЭтотОбъект И ИмяСобытия = "ПараметрыПрописиВалюты" Тогда
		УстановитьПрописиНаЯзыке(Параметр.ПараметрыПрописи, Параметр.КодЯзыка);
		Если Параметр.Записать Тогда
			Записать();
		Иначе
			Модифицированность = Истина;
		КонецЕсли;
		Если Параметр.Закрыть Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

////////////////////////////////////////////////////////////////////////////////
// Страница "Основные сведения".

&НаКлиенте
Процедура ОсновнаяВалютаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПодготовитьДанныеВыбораПодчиненнойВалюты(ДанныеВыбора, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура КурсВалютыПриИзменении(Элемент)
	УстановитьДоступностьЭлементов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПрописиВалютыНажатие(Элемент)
	
	ОткрытьПараметрыПрописиВалюты(0);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ПодготовитьДанныеВыбораПодчиненнойВалюты(ДанныеВыбора, Ссылка)
	
	// Подготавливает список выбора для подчиненной валюты таким образом,
	// чтобы в список не попала сама подчиненная валюта.
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка,
	|	Валюты.НаименованиеПолное КАК НаименованиеПолное,
	|	Валюты.Наименование КАК Наименование
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.Ссылка <> &Ссылка
	|	И Валюты.ОсновнаяВалюта = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Валюты.НаименованиеПолное";
	
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка, Выборка.НаименованиеПолное + " (" + Выборка.Наименование + ")");
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементов(Форма)
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	Элементы.ГруппаНаценкаНаКурсДругойВалюты.Доступность = Объект.СпособУстановкиКурса = ПредопределенноеЗначение("Перечисление.СпособыУстановкиКурсаВалюты.НаценкаНаКурсДругойВалюты");
	Элементы.ФормулаРасчетаКурса.Доступность = Объект.СпособУстановкиКурса = ПредопределенноеЗначение("Перечисление.СпособыУстановкиКурсаВалюты.РасчетПоФормуле");
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровПрописиВалюты(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ПараметрыПрописи = Результат;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПрописиНаЯзыке(ПараметрыПрописи, КодЯзыка)
	
	Если КодЯзыка = ОбщегоНазначенияКлиент.КодОсновногоЯзыка() Тогда
		Объект.ПараметрыПрописи = ПараметрыПрописи;
		Возврат;
	КонецЕсли;
	
	НайденнаяСтрока = Неопределено;
	Для Каждого СтрокаТаблицы Из Объект.Представления Цикл
		Если СтрокаТаблицы.КодЯзыка = КодЯзыка Тогда
			НайденнаяСтрока = СтрокаТаблицы;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НайденнаяСтрока =  Неопределено Тогда
		НайденнаяСтрока = Объект.Представления.Добавить();
		НайденнаяСтрока.КодЯзыка = КодЯзыка;
	КонецЕсли;
	
	НайденнаяСтрока.ПараметрыПрописи = ПараметрыПрописи;
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыПрописиВалютыНаЯзыке(КодЯзыка)
	
	Если КодЯзыка = ОбщегоНазначенияКлиент.КодОсновногоЯзыка() Тогда
		Возврат Объект.ПараметрыПрописи;
	КонецЕсли;
	
	НайденнаяСтрока = Неопределено;
	Для Каждого СтрокаТаблицы Из Объект.Представления Цикл
		Если СтрокаТаблицы.КодЯзыка = КодЯзыка Тогда
			НайденнаяСтрока = СтрокаТаблицы;
		КонецЕсли;
	КонецЦикла;
	
	Если НайденнаяСтрока = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат НайденнаяСтрока.ПараметрыПрописи;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПодменюПараметрыПрописиВалюты()
	
	Кнопка = Неопределено;
	ФормыВводаПрописей = РаботаСКурсамиВалютСлужебный.ФормыВводаПрописей();
	Для Индекс = 0 По ФормыВводаПрописей.Количество() - 1 Цикл
		ИмяКоманды = "ПараметрыПрописиВалюты_" + XMLСтрока(Индекс);
		
		КодЯзыка = ФормыВводаПрописей[Индекс].Значение;
		Команда = Команды.Добавить(ИмяКоманды);
		Если ЗначениеЗаполнено(КодЯзыка) Тогда
			Команда.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1...'"),
				РаботаСКурсамиВалютСлужебный.ПредставлениеЯзыка(КодЯзыка));;
		Иначе
			Команда.Заголовок = НСтр("ru = 'На других языках...'");
		КонецЕсли;
		
		Команда.Действие = "Подключаемый_ОткрытьФормуПараметрыПрописиВалюты";
		
		Кнопка = Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Элементы.ГруппаПараметрыПрописиВалюты);
		Кнопка.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
		Кнопка.ИмяКоманды = ИмяКоманды;
	КонецЦикла;
	
КонецПроцедуры

// Параметры:
//   Команда - КомандаФормы
//
&НаКлиенте
Процедура Подключаемый_ОткрытьФормуПараметрыПрописиВалюты(Команда)
	
	Индекс = Число(Сред(Команда.Имя, СтрДлина("ПараметрыПрописиВалюты_") + 1));
	ОткрытьПараметрыПрописиВалюты(Индекс);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПараметрыПрописиВалюты(Индекс)
	
	ИмяФормыПрописей = ФормыВводаПрописей[Индекс].Представление;
	КодЯзыка = ФормыВводаПрописей[Индекс].Значение;
	
	Если ИмяФормыПрописей = "ПараметрыПрописиВалютыНаДругихЯзыках" Тогда
		ПараметрыПрописиВалютыНаДругихЯзыках();
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПараметрыПрописи", ПараметрыПрописиВалютыНаЯзыке(КодЯзыка));
		ПараметрыФормы.Вставить("КодЯзыка", КодЯзыка);
		
		ОткрытьФорму(ИмяФормыПрописей, ПараметрыФормы, ЭтотОбъект, , , НавигационнаяСсылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПараметрыПрописиВалютыНаДругихЯзыках(Команда)
	
	ПараметрыПрописиВалютыНаДругихЯзыках();
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПрописиВалютыНаДругихЯзыках()
	
	ИмяРеквизита = "ПараметрыПрописи";
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяРеквизита", ИмяРеквизита);
	ПараметрыФормы.Вставить("ТекущееЗначение", Объект.ПараметрыПрописи);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	ПараметрыФормы.Вставить("Представления", Объект.Представления);
	
	ОткрытьФорму("Справочник.Валюты.Форма.ПараметрыПрописиВалютыНаДругихЯзыках", ПараметрыФормы, ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_Валюты", Объект.Ссылка);
КонецПроцедуры

#КонецОбласти
