#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Переформировывает распоряжения на оформления счетов-фактур комиссионерам.
//
// Параметры:
// 	 ОтчетыКомиссионеров - Массив - Отчеты по комиссии, по которым необходимо выполнить формирование распоряжений.
// 
Процедура ОбновитьСостояние(ОтчетыКомиссионеров) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеОтчетовКомиссионеров.Организация КАК Организация,
	|	ДанныеОтчетовКомиссионеров.Регистратор КАК ОтчетКомиссионера,
	|	ДанныеОтчетовКомиссионеров.Контрагент  КАК Комиссионер,
	|	ДанныеОтчетовКомиссионеров.ДатаСчетаФактурыКомиссионера КАК ДатаСчетаФактуры,
	|	ДанныеОтчетовКомиссионеров.НомерСчетаФактурыКомиссионера КАК НомерСчетаФактуры,
	|	ДанныеОтчетовКомиссионеров.ПокупательКомиссионногоТовара КАК Покупатель,
	|	ДанныеОтчетовКомиссионеров.Валюта КАК Валюта,
	|	СУММА(ДанныеОтчетовКомиссионеров.СуммаБезНДС + ДанныеОтчетовКомиссионеров.СуммаНДС) КАК СуммаСНДС,
	|	СУММА(ДанныеОтчетовКомиссионеров.СуммаНДС) КАК СуммаНДС,
	|	ВЫБОР
	|		КОГДА ДанныеОтчетовКомиссионеров.ТипСчетаФактуры = &ИдентификаторСчетФактураКомиссионеру
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК ТипДокумента
	|ПОМЕСТИТЬ СчетаФакутурыКомиссионеруКРегистрации
	|ИЗ
	|	РегистрСведений.ДанныеОснованийСчетовФактур КАК ДанныеОтчетовКомиссионеров
	|ГДЕ
	|	ДанныеОтчетовКомиссионеров.Регистратор В (&Ссылки)
	|	И ДанныеОтчетовКомиссионеров.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС)
	|	И (ДанныеОтчетовКомиссионеров.ТипСчетаФактуры = &ИдентификаторСчетФактураКомиссионеру
	|		ИЛИ ДанныеОтчетовКомиссионеров.ТипСчетаФактуры = &ИдентификаторСчетФактураВыданныйКомиссионеру)
	|	
	|СГРУППИРОВАТЬ ПО
	|	ДанныеОтчетовКомиссионеров.Организация,
	|	ДанныеОтчетовКомиссионеров.Регистратор,
	|	ДанныеОтчетовКомиссионеров.Контрагент,
	|	ДанныеОтчетовКомиссионеров.ДатаСчетаФактурыКомиссионера,
	|	ДанныеОтчетовКомиссионеров.НомерСчетаФактурыКомиссионера,
	|	ДанныеОтчетовКомиссионеров.ПокупательКомиссионногоТовара,
	|	ДанныеОтчетовКомиссионеров.Валюта,
	|	ДанныеОтчетовКомиссионеров.ТипСчетаФактуры
	|;
	|
	|ВЫБРАТЬ
	|	1 КАК ТипДокумента,
	|	СчетФактураКомиссионеру.Ссылка КАК Ссылка,
	|	СчетФактураКомиссионеру.Организация КАК Организация,
	|	СчетФактураКомиссионеру.ДокументОснование КАК ОтчетКомиссионера,
	|	СчетФактураКомиссионеру.Комиссионер КАК Комиссионер,
	|	ТаблицаПокупатели.Покупатель КАК Покупатель,
	|	НАЧАЛОПЕРИОДА(СчетФактураКомиссионеру.Дата, ДЕНЬ) КАК ДатаСчетаФактуры,
	|	ТаблицаПокупатели.НомерСчетаФактуры КАК НомерСчетаФактуры,
	|	СчетФактураКомиссионеру.Валюта КАК Валюта
	|ПОМЕСТИТЬ СчетаФактурыКомиссионеру
	|ИЗ
	|	Документ.СчетФактураКомиссионеру КАК СчетФактураКомиссионеру
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.СчетФактураКомиссионеру.Покупатели КАК ТаблицаПокупатели
	|	ПО
	|		СчетФактураКомиссионеру.Ссылка = ТаблицаПокупатели.Ссылка
	|ГДЕ
	|	СчетФактураКомиссионеру.ДокументОснование В (&Ссылки)
	|	И СчетФактураКомиссионеру.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2 КАК ТипДокумента,
	|	СчетФактураВыданный.Ссылка КАК Ссылка,
	|	СчетФактураВыданный.Организация КАК Организация,
	|	СчетФактураВыданный.ДокументОснование КАК ОтчетКомиссионера,
	|	СчетФактураВыданный.Контрагент КАК Комиссионер,
	|	ТаблицаПокупатели.Покупатель КАК Покупатель,
	|	НАЧАЛОПЕРИОДА(СчетФактураВыданный.Дата, ДЕНЬ) КАК ДатаСчетаФактуры,
	|	ТаблицаПокупатели.НомерСчетаФактуры КАК НомерСчетаФактуры,
	|	СчетФактураВыданный.Валюта КАК Валюта
	|ИЗ
	|	Документ.СчетФактураВыданный КАК СчетФактураВыданный
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.СчетФактураВыданный.Покупатели КАК ТаблицаПокупатели
	|	ПО
	|		СчетФактураВыданный.Ссылка = ТаблицаПокупатели.Ссылка
	|ГДЕ
	|	СчетФактураВыданный.ДокументОснование В (&Ссылки)
	|	И СчетФактураВыданный.Проведен
	|;
	|
	|ВЫБРАТЬ
	|	КРегистрации.ОтчетКомиссионера,
	|	КРегистрации.Комиссионер,
	|	КРегистрации.Организация,
	|	КРегистрации.Покупатель,
	|	КРегистрации.ДатаСчетаФактуры,
	|	КРегистрации.НомерСчетаФактуры,
	|	КРегистрации.Валюта,
	|	КРегистрации.СуммаСНДС,
	|	КРегистрации.СуммаНДС
	|ИЗ
	|	СчетаФакутурыКомиссионеруКРегистрации КАК КРегистрации
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		СчетаФактурыКомиссионеру КАК СчетаФактурыКомиссионеру
	|	ПО
	|		КРегистрации.ТипДокумента = СчетаФактурыКомиссионеру.ТипДокумента
	|		И КРегистрации.ОтчетКомиссионера = СчетаФактурыКомиссионеру.ОтчетКомиссионера
	|		И КРегистрации.Покупатель = СчетаФактурыКомиссионеру.Покупатель
	|		И КРегистрации.НомерСчетаФактуры = СчетаФактурыКомиссионеру.НомерСчетаФактуры
	|		И (КРегистрации.ДатаСчетаФактуры = СчетаФактурыКомиссионеру.ДатаСчетаФактуры
	|			ИЛИ КРегистрации.ДатаСчетаФактуры = &ПустаяДата)
	|ГДЕ
	|	СчетаФактурыКомиссионеру.Ссылка ЕСТЬ NULL
	|";
	ИдентификаторСчетФактураКомиссионеру = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СчетФактураКомиссионеру");
	ИдентификаторСчетФактураВыданныйКомиссионеру = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СчетФактураВыданный");
	Запрос.УстановитьПараметр("ИдентификаторСчетФактураКомиссионеру", ИдентификаторСчетФактураКомиссионеру);
	Запрос.УстановитьПараметр("ИдентификаторСчетФактураВыданныйКомиссионеру", ИдентификаторСчетФактураВыданныйКомиссионеру);
	Запрос.УстановитьПараметр("Ссылки", ОтчетыКомиссионеров);
	Запрос.УстановитьПараметр("ПустаяДата", Дата(1,1,1));
	
	СчетаФактурыКомиссионерамКОформлению = Запрос.Выполнить().Выгрузить(); 
	СчетаФактурыКомиссионерамКОформлению.Индексы.Добавить("ОтчетКомиссионера");
	
	Для каждого ОтчетКомиссионера Из ОтчетыКомиссионеров Цикл
		НаборЗаписей = РегистрыСведений.СчетаФактурыКомиссионерамКОформлению.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ОтчетКомиссионера.Установить(ОтчетКомиссионера);
		Строки = СчетаФактурыКомиссионерамКОформлению.НайтиСтроки(Новый Структура("ОтчетКомиссионера", ОтчетКомиссионера));
		Для каждого Строка Из Строки Цикл
			Запись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, Строка);
		КонецЦикла;
		НаборЗаписей.Записывать = Истина;
		НаборЗаписей.Записать();
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ОтчетКомиссионера.Организация)
	|	И ЗначениеРазрешено(ОтчетКомиссионера.Партнер)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//  Обработчики - ТаблицаЗначений - описание полей, см. в процедуре
//                ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.МонопольныйРежим    = Ложь;
//
// Параметры:
// 	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.СчетаФактурыКомиссионерамКОформлению.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.9.56";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("b63d7f88-57bc-4c53-8a4f-8834b8fedbd9");
	Обработчик.Многопоточный = Ложь;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.СчетаФактурыКомиссионерамКОформлению.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Удаление пустой записи в регистре ""Счета-фактуры комиссионерам к оформлению""'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыСведений.СчетаФактурыКомиссионерамКОформлению.ПолноеИмя());

	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.СчетаФактурыКомиссионерамКОформлению.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.РегистрыСведений.СчетаФактурыКомиссионерамКОформлению.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "РегистрСведений.СчетаФактурыКомиссионерамКОформлению";
	НаборЗаписей = РегистрыСведений.СчетаФактурыКомиссионерамКОформлению.СоздатьНаборЗаписей();
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		
		// Блокировка регистра распределения запасов.
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СчетаФактурыКомиссионерамКОформлению");
		ЭлементБлокировки.УстановитьЗначение("ОтчетКомиссионера", Документы.ОтчетКомиссионера.ПустаяСсылка());
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
		
		Блокировка.Заблокировать();
		
		НаборЗаписей.Отбор.ОтчетКомиссионера.Установить(Неопределено, Истина);
		
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0 Тогда
			НаборЗаписей.Очистить();
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей, Истина);
		КонецЕсли;
		
		Параметры.ОбработкаЗавершена = Истина;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Неопределено);
		
	КонецПопытки;
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#КонецЕсли