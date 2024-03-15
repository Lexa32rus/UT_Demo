
#Область ОбработчикиСобытийФормы
// Код процедур и функций

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Сотрудник = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователи.ТекущийПользователь(), "ФизическоеЛицо");
	ПоказыватьФотоТоваров = Параметры.ПоказыватьФотоТоваров;
	ТекущийСклад = Параметры.ТекущийСклад;
	ТипСотрудника = Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки.ТипСотрудникаКурьер();
	ПериодРасчетов.Вариант = ВариантСтандартногоПериода.Сегодня;
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ТекущаяКасса = Настройки.Получить("ТекущаяКасса");
	ТекущаяВкладка = Настройки.Получить("ТекущаяВкладка");
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОформитьМеню();
	СформироватьПредставлениеПериодаРасчетов();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Склады.Форма.ФормаВыбора") Тогда
		
		ТекущийСклад = ВыбранноеЗначение;
		СфомироватьПредставлениеОтборов();
		ОбновитьДанныеФормы();
		
	ИначеЕсли ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Кассы.Форма.ФормаВыбора") Тогда
		
		ТекущаяКасса = ВыбранноеЗначение;
		СфомироватьПредставлениеОтборов();
		ОбновитьДанныеФормы();

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокРаспоряжений" Тогда
		ОбновитьДанныеФормы();
		ОформитьМеню();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокРаспоряжений

&НаКлиенте
Процедура СписокРаспоряженийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = Элементы.СписокРаспоряжений.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Распоряжение", ТекущаяСтрока.Распоряжение);
	ПараметрыОткрытияФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
		
	ОткрытьФорму(
		"Обработка.МобильноеРабочееМестоСборкиИКурьерскойДоставки.Форма.КарточкаРаспоряжения",
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриходВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРасходВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьФорму(Команда)
	
	ОбновитьДанныеФормы();
	ОформитьМеню();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыМагазинОчистить(Команда)
	
	ТекущийСклад = Неопределено;
	СфомироватьПредставлениеОтборов();
	ОбновитьДанныеФормы();

КонецПроцедуры

&НаКлиенте
Процедура ОтборыМагазинОткрыть(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", Ложь);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыОткрытияФормы.Вставить("Отбор", Новый Структура("Ссылка", ДоступныеСклады()));
		
	ОткрытьФорму(
		"Справочник.Склады.Форма.ФормаВыбора",
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыКассаОткрыть(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", Ложь);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыОткрытияФормы.Вставить("Отбор", Новый Структура("Ссылка", ДоступныеКассы()));
		
	ОткрытьФорму(
		"Справочник.Кассы.Форма.ФормаВыбора",
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыКассаОчистить(Команда)
	
	ТекущаяКасса = Неопределено;
	СфомироватьПредставлениеОтборов();
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПериодОткрыть(Команда)
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ВыборПериодаРасчетовЗавершение", ЭтаФорма);
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = ПериодРасчетов;
	Диалог.Показать(ОписаниеОповещенияОЗакрытии); 
	
КонецПроцедуры


// Обработка выбора периода
// 
// Параметры:
// 	Результат - СтандартныйПериод - диалог закрыли по кнопке "OK"; Неопределено - в противном случае
// 	Параметры - Произвольный
&НаКлиенте
Процедура ВыборПериодаРасчетовЗавершение(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		Если Результат.ДатаНачала > Результат.ДатаОкончания Тогда
			
			ТекстОшибки = НСтр("ru='Период задан неверно.
									|Дата начала периода должна быть меньше даты окончания.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		ПериодРасчетов = Результат;
		СформироватьПредставлениеПериодаРасчетов();
		ОбновитьДанныеФормы();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаРаспоряжения(Команда)
	
	Если ТекущаяВкладка = 1 Тогда
		ПерейтиНаВкладку(0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаНаличные(Команда)
	
	Если ТекущаяВкладка = 0 Тогда
		ПерейтиНаВкладку(1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьСвернутьПриход(Команда)
	
	ПриходОткрыт = Не ПриходОткрыт;
	Элементы.ГруппаСписокПриход.Видимость = ПриходОткрыт;
	Элементы.РазвернутьСвернутьПриход.Картинка = ?(ПриходОткрыт, БиблиотекаКартинок.СтрелкаВверхСборкаИДоставка, БиблиотекаКартинок.СтрелкаВнизСборкаИДоставка);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьСвернутьРасход(Команда)

	РасходОткрыт = Не РасходОткрыт;
	Элементы.ГруппаСписокРасход.Видимость = РасходОткрыт;
	Элементы.РазвернутьСвернутьРасход.Картинка = ?(РасходОткрыт, БиблиотекаКартинок.СтрелкаВверхСборкаИДоставка, БиблиотекаКартинок.СтрелкаВнизСборкаИДоставка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПерейтиНаВкладку(КодВкладки = 0)
	
	ТекущаяВкладка = КодВкладки;
	ОбновитьДанныеФормы();
	ОформитьМеню();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФормы()
	
	Запрос = Новый Запрос();
	ТекстЗапроса = "ВЫБРАТЬ
	               |	СтатусыСборкиИДоставки.Распоряжение КАК Распоряжение,
	               |	СтатусыСборкиИДоставки.Статус КАК Статус,
	               |	Документы.Склад КАК Склад,
	               |	Документы.Номер КАК Номер,
	               |	Документы.ДатаОтгрузки ДатаДоставки,
	               |	Документы.ВремяДоставкиС КАК ВремяДоставкиС,
	               |	Документы.ВремяДоставкиПо КАК ВремяДоставкиПо,
	               |	Документы.СуммаДокумента КАК СуммаДокумента,
	               |	Документы.ДополнительнаяИнформацияПоДоставке КАК Комментарий,
	               |	Документы.Валюта КАК Валюта,
	               |	Документы.ФормаОплаты КАК ФормаОплаты,
	               |	Документы.Склад.Наименование КАК СкладНаименование,
	               |	СтатусыСборкиИДоставки.ПричинаОтмены.Наименование КАК ПричинаОтменыНаименование
	               |ПОМЕСТИТЬ ВременнаяТаблицаРаспоряжения
	               |ИЗ
	               |	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента КАК Документы
	               |		ПО ((ВЫРАЗИТЬ(СтатусыСборкиИДоставки.Распоряжение КАК Документ.ЗаказКлиента)) = Документы.Ссылка)
	               |ГДЕ
	               |	СтатусыСборкиИДоставки.Статус В(&Статус)
	               |	И Документы.Курьер = &Сотрудник
	               |	И Документы.Проведен
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	СтатусыСборкиИДоставки.Распоряжение,
	               |	СтатусыСборкиИДоставки.Статус,
	               |	Документы.Склад,
	               |	Документы.Номер,
	               |	Документы.Дата,
	               |	Документы.ВремяДоставкиС,
	               |	Документы.ВремяДоставкиПо,
	               |	Документы.СуммаДокумента,
	               |	Документы.ДополнительнаяИнформацияПоДоставке,
	               |	Документы.Валюта,
	               |	Документы.ФормаОплаты,
	               |	Документы.Склад.Наименование,
	               |	СтатусыСборкиИДоставки.ПричинаОтмены.Наименование
	               |ИЗ
	               |	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК Документы
	               |		ПО ((ВЫРАЗИТЬ(СтатусыСборкиИДоставки.Распоряжение КАК Документ.РеализацияТоваровУслуг)) = Документы.Ссылка)
	               |ГДЕ
	               |	СтатусыСборкиИДоставки.Статус В(&Статус)
	               |	И Документы.Курьер = &Сотрудник
	               |	И Документы.Проведен
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СУММА(1) КАК КоличествоРаспоряжений
	               |ИЗ
	               |	ВременнаяТаблицаРаспоряжения КАК Документы
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	Документы.Склад КАК Склад,
	               |	Документы.СкладНаименование КАК СкладНаименование
	               |ИЗ
	               |	ВременнаяТаблицаРаспоряжения КАК Документы
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Кассы.Ссылка КАК Касса,
	               |	Кассы.ВалютаДенежныхСредств КАК Валюта,
	               |	Кассы.Наименование КАК КассаНаименование
	               |ИЗ
	               |	Справочник.Кассы КАК Кассы
	               |ГДЕ
	               |	Кассы.ФизическоеЛицо = &Сотрудник
	               |	И Кассы.ОперационнаяКасса = ИСТИНА
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Касса
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Документы.Распоряжение КАК Распоряжение,
	               |	Документы.Статус КАК Статус,
	               |	Документы.Склад КАК Склад,
	               |	Документы.Номер КАК Номер,
	               |	Документы.ДатаДоставки КАК ДатаДоставки,
	               |	Документы.ВремяДоставкиС КАК ВремяДоставкиС,
	               |	Документы.ВремяДоставкиПо КАК ВремяДоставкиПо,
	               |	Документы.СуммаДокумента КАК СуммаДокумента,
	               |	Документы.Комментарий КАК Комментарий,
	               |	Документы.Валюта КАК Валюта,
	               |	Документы.ФормаОплаты КАК ФормаОплаты,
	               |	Документы.СкладНаименование КАК СкладНаименование,
	               |	Документы.ПричинаОтменыНаименование КАК ПричинаОтменыНаименование
	               |ПОМЕСТИТЬ ВременнаяТаблицаРаспоряженияПоСкладу
	               |ИЗ
	               |	ВременнаяТаблицаРаспоряжения КАК Документы
	               |ГДЕ
	               |	(&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	               |			ИЛИ Документы.Склад В ИЕРАРХИИ (&Склад))
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Документы.Распоряжение КАК Распоряжение,
	               |	СУММА(1) КАК КоличествоПозиций,
	               |	СУММА(Товары.КоличествоУпаковок * &ТекстЗапросаВесУпаковки) КАК Вес
	               |ПОМЕСТИТЬ ВременнаяТаблицаТовары
	               |ИЗ
	               |	ВременнаяТаблицаРаспоряженияПоСкладу КАК Документы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента.Товары КАК Товары
	               |		ПО Документы.Распоряжение = Товары.Ссылка
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	               |		ПО (Товары.Номенклатура = СправочникНоменклатура.Ссылка)
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК СправочникВидыНоменклатуры
	               |		ПО (СправочникНоменклатура.ВидНоменклатуры = СправочникВидыНоменклатуры.Ссылка)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
	               |		ПО (Товары.Упаковка = УпаковкиЕдиницыИзмерения.Ссылка)
	               |ГДЕ
	               |	НЕ Товары.Отменено
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Документы.Распоряжение
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	Документы.Распоряжение,
	               |	СУММА(1),
	               |	СУММА(Товары.КоличествоУпаковок * &ТекстЗапросаВесУпаковки)
	               |ИЗ
	               |	ВременнаяТаблицаРаспоряженияПоСкладу КАК Документы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК Товары
	               |		ПО Документы.Распоряжение = Товары.Ссылка
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	               |		ПО (Товары.Номенклатура = СправочникНоменклатура.Ссылка)
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК СправочникВидыНоменклатуры
	               |		ПО (СправочникНоменклатура.ВидНоменклатуры = СправочникВидыНоменклатуры.Ссылка)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
	               |		ПО (Товары.Упаковка = УпаковкиЕдиницыИзмерения.Ссылка)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Документы.Распоряжение
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Документы.Распоряжение КАК Распоряжение,
	               |	Документы.Статус КАК Статус,
	               |	Документы.Склад КАК Склад,
	               |	Документы.Номер КАК Номер,
	               |	Документы.ДатаДоставки КАК ДатаДоставки,
	               |	Документы.ВремяДоставкиС КАК ВремяДоставкиС,
	               |	Документы.ВремяДоставкиПо КАК ВремяДоставкиПо,
	               |	Документы.СуммаДокумента КАК СуммаДокумента,
	               |	Документы.Комментарий КАК Комментарий,
	               |	Документы.Валюта КАК Валюта,
	               |	Документы.ФормаОплаты КАК ФормаОплаты,
	               |	Документы.СкладНаименование КАК СкладНаименование,
	               |	Документы.ПричинаОтменыНаименование КАК ПричинаОтменыНаименование,
	               |	Товары.КоличествоПозиций КАК КоличествоПозиций,
	               |	Товары.Вес КАК Вес
	               |ИЗ
	               |	ВременнаяТаблицаРаспоряженияПоСкладу КАК Документы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК Товары
	               |		ПО Документы.Распоряжение = Товары.Распоряжение
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ДатаДоставки,
	               |	ВремяДоставкиПо
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВЫБОР
	               |		КОГДА ДенежныеСредстваНаличныеОстаткиИОбороты.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	               |			ТОГДА ВЫРАЗИТЬ(ДенежныеСредстваНаличныеОстаткиИОбороты.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Номер
	               |		КОГДА ДенежныеСредстваНаличныеОстаткиИОбороты.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	               |			ТОГДА ВЫРАЗИТЬ(ДенежныеСредстваНаличныеОстаткиИОбороты.Регистратор КАК Документ.РасходныйКассовыйОрдер).Номер
	               |		ИНАЧЕ ""Прочее""
	               |	КОНЕЦ КАК Номер,
	               |	ДенежныеСредстваНаличныеОстаткиИОбороты.Период КАК Дата,
	               |	ДенежныеСредстваНаличныеОстаткиИОбороты.СуммаПриход КАК СуммаПриход,
	               |	ДенежныеСредстваНаличныеОстаткиИОбороты.СуммаРасход КАК СуммаРасход,
	               |	ДенежныеСредстваНаличныеОстаткиИОбороты.СуммаНачальныйОстаток КАК СуммаНачальныйОстаток,
	               |	ДенежныеСредстваНаличныеОстаткиИОбороты.СуммаКонечныйОстаток КАК СуммаКонечныйОстаток,
	               |	ДенежныеСредстваНаличныеОстаткиИОбороты.Касса.ВалютаДенежныхСредств КАК Валюта,
	               |	ДенежныеСредстваНаличныеОстаткиИОбороты.Период КАК Период,
	               |	ДенежныеСредстваНаличныеОстаткиИОбороты.Касса КАК Касса
	               |ИЗ
	               |	РегистрНакопления.ДенежныеСредстваНаличные.ОстаткиИОбороты(
	               |			&ДатаНачала,
	               |			&ДатаОкончания,
	               |			Регистратор,
	               |			,
	               |			Касса В
	               |				(ВЫБРАТЬ ПЕРВЫЕ 1
	               |					Кассы.Ссылка КАК Касса
	               |				ИЗ
	               |					Справочник.Кассы КАК Кассы
	               |				ГДЕ
	               |					Кассы.ПометкаУдаления = ЛОЖЬ
	               |					И Кассы.ОперационнаяКасса = ИСТИНА
	               |					И Кассы.ФизическоеЛицо = &Сотрудник
	               |					И (&Касса = ЗНАЧЕНИЕ(Справочник.Кассы.ПустаяСсылка)
	               |						ИЛИ Кассы.Ссылка = &Касса)
	               |				УПОРЯДОЧИТЬ ПО
	               |					Касса)) КАК ДенежныеСредстваНаличныеОстаткиИОбороты
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Период";
	
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("Склад", ТекущийСклад);
	Запрос.УстановитьПараметр("Касса", ТекущаяКасса);
	Запрос.УстановитьПараметр("ДатаНачала", ПериодРасчетов.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ПериодРасчетов.ДатаОкончания);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Статус", СкладыСервер.СтатусыРаспоряженийОтмененных());
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаВесУпаковки", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки(
			"УпаковкиЕдиницыИзмерения", 
			"СправочникНоменклатура"));
	
	Запрос.Текст = ТекстЗапроса;
	Результаты = Запрос.ВыполнитьПакет();
	
	РезультатСводно = Результаты[1].Выгрузить();
	СписокСкладов.Загрузить(Результаты[2].Выгрузить());
	СписокКасс.Загрузить(Результаты[3].Выгрузить());
	
	КоличествоРаспоряжений = РезультатСводно[0].КоличествоРаспоряжений;
	
	СписокРаспоряжений.Очистить();
	
	ВыборкаПоРаспоряжениям = Результаты[6].Выбрать();
	
	Пока ВыборкаПоРаспоряжениям.Следующий() Цикл
		
		НоваяСтрока = СписокРаспоряжений.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПоРаспоряжениям);
		
		Если ЗначениеЗаполнено(НоваяСтрока.Комментарий) Тогда
			НоваяСтрока.КомментарийКартинка = 1;
		КонецЕсли;
		
		Модуль = Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки;
		
		НоваяСтрока.ДатаВремяДоставкиПредставление = Модуль.ДатаВремяДоставкиПредставление(НоваяСтрока);
		НоваяСтрока.СуммаПредставление = Модуль.СуммаПредставление(НоваяСтрока);
		НоваяСтрока.ФормаОплатыПредставление = Модуль.ФормаОплатыПредставление(НоваяСтрока);
		НоваяСтрока.КоличествоПозицийПредставление = Модуль.КоличествоПозицийПредставление(НоваяСтрока);
		НоваяСтрока.ВесПредставление = Модуль.ВесПредставление(НоваяСтрока.Вес);
		
	КонецЦикла;
	
	КоличествоРаспоряженийПоСкладу = СписокРаспоряжений.Количество();
	
	ВыборкаПоРасчетам = Результаты[7].Выбрать();
	
	ЭтоПервый = Истина;
	НоваяСтрока = Неопределено;
	ОстатокНаНачалоПериода = 0;
	ОстатокНаКонецПериода = 0;
	СуммаПриход = 0;
	СуммаРасход = 0;
	СписокПриход.Очистить();
	СписокРасход.Очистить();
	
	Пока ВыборкаПоРасчетам.Следующий() Цикл
		
		Если ЭтоПервый Тогда
			ЭтоПервый = Ложь;
			ОстатокНаНачалоПериода = ВыборкаПоРасчетам.СуммаНачальныйОстаток;
			ТекущаяКасса = ВыборкаПоРасчетам.Касса;
			Валюта = ВыборкаПоРасчетам.Валюта;
		КонецЕсли;
		
		ОстатокНаКонецПериода = ВыборкаПоРасчетам.СуммаКонечныйОстаток;
		
		Если ВыборкаПоРасчетам.СуммаПриход <> 0 Тогда
			
			НоваяСтрока = СписокПриход.Добавить();
			СуммаПриход = СуммаПриход + ВыборкаПоРасчетам.СуммаПриход;
			НоваяСтрока.СуммаДокумента = ВыборкаПоРасчетам.СуммаПриход;
			
		ИначеЕсли ВыборкаПоРасчетам.СуммаРасход <> 0 Тогда
			
			НоваяСтрока = СписокРасход.Добавить();
			СуммаРасход = СуммаРасход + ВыборкаПоРасчетам.СуммаРасход;
			НоваяСтрока.СуммаДокумента = ВыборкаПоРасчетам.СуммаРасход;
			
		Иначе
			 Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПоРасчетам);
		
		Модуль = Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки;
		
		НоваяСтрока.ДокументПредставление = СтрШаблон(НСтр("ru='№ %1 (%2)'"), НоваяСтрока.Номер, Формат(НоваяСтрока.Дата, "ДФ=dd.MM.yy"));
		НоваяСтрока.СуммаПредставление = Модуль.СуммаПредставление(НоваяСтрока);
		
	КонецЦикла;
	
	Если СписокКасс.Количество() = 0 Тогда
		
		ТекущаяКасса = Неопределено;
		Валюта = Неопределено;
		ТекущаяВкладка = 0;
		
	ИначеЕсли СписокКасс.Количество() = 1 Тогда
		
		ТекущаяКасса = СписокКасс[0].Касса;
		Валюта = СписокКасс[0].Валюта;
		
	Иначе
		
		Если ТекущаяКасса = Неопределено Тогда
			
			ТекущаяКасса = СписокКасс[0].Касса;
			Валюта = СписокКасс[0].Валюта;
			
		Иначе
			НайденныеСтроки = СписокКасс.НайтиСтроки(Новый Структура("Касса", ТекущаяКасса));
			Валюта = НайденныеСтроки[0].Валюта;
		КонецЕсли;
		
	КонецЕсли;
	
	СфомироватьПредставлениеОтборов();
	СфомироватьПредставлениеЗаголовковГрупп();
	
КонецПроцедуры

&НаСервере
Процедура СфомироватьПредставлениеОтборов()
	
	ПредставленияОтборов = "";
	
	Если ЗначениеЗаполнено(ТекущийСклад) Тогда
		ПредставленияОтборов = ТекущийСклад;
		Элементы.КомандаОтборыМагазинОткрыть.ЦветТекста = ЦветаСтиля.ЦветТекстаОснонойСборкаИДоставка;
		Элементы.ГруппаКомандаОтборыМагазинКоличествоОчистить.Видимость = Истина;
		Элементы.РамкаОтборыМагазинОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
		Элементы.ГруппаОтборыМагазин.Видимость = Истина;
		Элементы.КомандаОтборыМагазинОткрыть.Заголовок = ПредставленияОтборов;
	ИначеЕсли СписокСкладов.Количество() > 1 Тогда
		ПредставленияОтборов = НСтр("ru='Выбрать магазин/склад'");
		Элементы.КомандаОтборыМагазинОткрыть.ЦветТекста = ЦветаСтиля.ЦветТекстаДополнительныйСборкаИДоставка;
		Элементы.ГруппаКомандаОтборыМагазинКоличествоОчистить.Видимость = Ложь;
		Элементы.РамкаОтборыМагазинОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюСерая;
		Элементы.ГруппаОтборыМагазин.Видимость = Истина;
		Элементы.КомандаОтборыМагазинОткрыть.Заголовок = ПредставленияОтборов;
	Иначе
		Элементы.ГруппаОтборыМагазин.Видимость = Ложь;
	КонецЕсли;
	
	Если СписокКасс.Количество() = 0 Тогда
		
		Элементы.СтраницаНаличные.Видимость = Ложь;
		
	ИначеЕсли СписокКасс.Количество() = 1 Тогда
		
		Элементы.ГруппаОтборыКасса.Видимость = Ложь;
		Элементы.ГруппаНаличныеРамкаОтборы.Видимость = Ложь;
		
	ИначеЕсли ЗначениеЗаполнено(ТекущаяКасса) Тогда
		
		ПредставленияОтборов = ТекущаяКасса;
		Элементы.КомандаОтборыКассаОткрыть.ЦветТекста = ЦветаСтиля.ЦветТекстаОснонойСборкаИДоставка;
		Элементы.РамкаОтборыКассаОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
		Элементы.ГруппаОтборыКасса.Видимость = Истина;
		Элементы.КомандаОтборыКассаОткрыть.Заголовок = ПредставленияОтборов;
		
	Иначе
		ПредставленияОтборов = НСтр("ru='Выбрать кассу'");
		Элементы.КомандаОтборыКассаОткрыть.ЦветТекста = ЦветаСтиля.ЦветТекстаДополнительныйСборкаИДоставка;
		Элементы.РамкаОтборыКассаОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюСерая;
		Элементы.ГруппаОтборыКасса.Видимость = Истина;
		Элементы.КомандаОтборыКассаОткрыть.Заголовок = ПредставленияОтборов;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СфомироватьПредставлениеЗаголовковГрупп()
	
	Если ТекущаяВкладка = 1 Тогда
	
		Модуль = Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки;
		
		Элементы.ДекорацияОстатокНаНачалоПериода.Заголовок = Модуль.СуммаПредставлениеОбщая(ОстатокНаНачалоПериода, Валюта);
		Элементы.ДекорацияОстатокНаКонецПериода.Заголовок = Модуль.СуммаПредставлениеОбщая(ОстатокНаКонецПериода, Валюта);
		
		МассивДекорация = Новый Массив();
		МассивДекорация.Добавить(БиблиотекаКартинок.ЗначокПлюс);
		МассивДекорация.Добавить(Модуль.СуммаПредставлениеОбщая(СуммаПриход, Валюта));
		Элементы.ДекорацияПриход.Заголовок = Новый ФорматированнаяСтрока(МассивДекорация);
		
		МассивДекорация = Новый Массив();
		МассивДекорация.Добавить(БиблиотекаКартинок.ЗначокМинус);
		МассивДекорация.Добавить(Модуль.СуммаПредставлениеОбщая(СуммаРасход, Валюта));
		Элементы.ДекорацияРасход.Заголовок = Новый ФорматированнаяСтрока(МассивДекорация);
		
		Элементы.РазвернутьСвернутьПриход.Видимость = СписокПриход.Количество() > 0;
		Элементы.РазвернутьСвернутьПриход.Картинка = ?(ПриходОткрыт, БиблиотекаКартинок.СтрелкаВверхСборкаИДоставка, БиблиотекаКартинок.СтрелкаВнизСборкаИДоставка);
		
		Элементы.РазвернутьСвернутьРасход.Видимость = СписокРасход.Количество() > 0;
		Элементы.РазвернутьСвернутьРасход.Картинка = ?(РасходОткрыт, БиблиотекаКартинок.СтрелкаВверхСборкаИДоставка, БиблиотекаКартинок.СтрелкаВнизСборкаИДоставка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьМеню()
	
	Если ТекущаяВкладка = 0 Тогда
		ИмяЭлементаРамка    = "РамкаРаспоряжения";
		ИмяЭлементаКоманда  = "КомандаРаспоряжения";
		ИмяЭлементаСтраница = "СтраницаРаспоряжения";
	Иначе
		ИмяЭлементаРамка    = "РамкаНаличные";
		ИмяЭлементаКоманда  = "КомандаНаличные";
		ИмяЭлементаСтраница = "СтраницаНаличные";
	КонецЕсли;
	
	ЕстьКассы = СписокКасс.Количество() <> 0;
	
	Элементы.ГруппаМенюНаличные.Видимость = ЕстьКассы;
	
	Элементы.РамкаРаспоряжения.Картинка = БиблиотекаКартинок.РамкаМенюБелая;
	Элементы.КомандаРаспоряжения.ЦветТекста = WebЦвета.Серый;
	                                                           
	Элементы.РамкаНаличные.Картинка = БиблиотекаКартинок.РамкаМенюБелая;
	Элементы.КомандаНаличные.ЦветТекста = WebЦвета.Серый;
	
	Если ЕстьКассы Тогда
		Элементы[ИмяЭлементаРамка].Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
		Элементы[ИмяЭлементаКоманда].ЦветТекста = WebЦвета.Черный;
	КонецЕсли;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы[ИмяЭлементаСтраница];
	
	СформироватьЗаголовкиКомандМеню();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗаголовкиКомандМеню()
	
	Элементы.КомандаРаспоряжения.Заголовок = СтрШаблон(НСтр("ru='Заказы (%1)'"), КоличествоРаспоряжений);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПредставлениеПериодаРасчетов()
	
	Если НачалоДня(ПериодРасчетов.ДатаНачала) <> НачалоДня(ПериодРасчетов.ДатаОкончания) Тогда
		Элементы.КомандаОтборыПериодОткрыть.Заголовок = СтрШаблон(НСтр("ru='%1 - %2'"), 
			Формат(ПериодРасчетов.ДатаНачала, "ДФ=dd.MM.yy"),
			Формат(ПериодРасчетов.ДатаОкончания, "ДФ=dd.MM.yy"));
	Иначе
		Элементы.КомандаОтборыПериодОткрыть.Заголовок = СтрШаблон(НСтр("ru='%1'"), 
			Формат(ПериодРасчетов.ДатаНачала, "ДФ=dd.MM.yy"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДоступныеСклады()
	
	Возврат СписокСкладов.Выгрузить(,"Склад").ВыгрузитьКолонку("Склад");
	
КонецФункции

&НаСервере
Функция ДоступныеКассы()
	
	Возврат СписокКасс.Выгрузить(,"Касса").ВыгрузитьКолонку("Касса");
	
КонецФункции

#КонецОбласти
