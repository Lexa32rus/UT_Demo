#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.Отбор);
	 	
	Если Параметры.Свойство("До") Тогда
		До = Параметры.До;
	КонецЕсли;
	Если Параметры.Свойство("От") Тогда
		От = Параметры.От;
	КонецЕсли;
	Если Параметры.Свойство("Выручка") Тогда
		Выручка = Параметры.Выручка;
	КонецЕсли;
	Если Параметры.Свойство("Потенциал") Тогда
		Потенциал = Параметры.Потенциал;
	КонецЕсли;
	Если Параметры.Свойство("Покупки") Тогда
		Покупки = Параметры.Покупки;
	КонецЕсли;
	Если Параметры.Свойство("ПокупкиОт") Тогда
		ПокупкиОт = Параметры.ПокупкиОт;
	КонецЕсли;
	Если Параметры.Свойство("ПокупкиДо") Тогда
		ПокупкиДо = Параметры.ПокупкиДо;
	КонецЕсли;

	Проценты = Параметры.Проценты;
	СписокРасшифровки = Параметры.СписокРасшифровки;
	Сегмент = Параметры.Сегмент;
	
	Если Сегмент = "АН" Тогда 
		Заголовок = НСтр("ru='Активные новые клиенты'");
	ИначеЕсли Сегмент = "АП" Тогда 
		Заголовок = НСтр("ru='Активные перспективные клиенты'");	
	ИначеЕсли Сегмент = "АВ" Тогда 
		Заголовок = НСтр("ru='Активные верные клиенты'");	
	ИначеЕсли Сегмент = "ЗН" Тогда 
		Заголовок = НСтр("ru='Засыпающие новые клиенты'");	
	ИначеЕсли Сегмент = "ЗП" Тогда 
		Заголовок = НСтр("ru='Засыпающие перспективные клиенты'");	
	ИначеЕсли Сегмент = "ЗВ" Тогда 
		Заголовок = НСтр("ru='Засыпающие верные клиенты'");	
	ИначеЕсли Сегмент = "СН" Тогда 
		Заголовок = НСтр("ru='Спящие новые клиенты'");	
	ИначеЕсли Сегмент = "СП" Тогда 
		Заголовок = НСтр("ru='Спящие перспективные клиенты'");
	ИначеЕсли Сегмент = "СВ" Тогда 
		Заголовок = НСтр("ru='Спящие верные клиенты'");	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	РезультатВыполнения = Сегменты();
	Если НЕ РезультатВыполнения.Статус = "Выполнено" Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ФоновоеЗаданиеОтменить(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция Сегменты()
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ФоновоеЗаданиеОтменить(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;

ИменаПараметровОтборов = "ДатаНачала, ДатаОкончания, ПериодИспользование,СписокРасшифровки,
		|Организация,ОрганизацияИспользование,
		|Менеджер,МенеджерИспользование,
		|Номенклатура,НоменклатураИспользование,
		|СегментКлиентов,СегментКлиентовИспользование,
		|СегментНоменклатуры,СегментНоменклатурыИспользование,
		|СуммаПокупок,СуммаПокупокИспользование";

	ПараметрыЗапроса = Новый Структура(ИменаПараметровОтборов);
	ЗаполнитьЗначенияСвойств(ПараметрыЗапроса, ЭтаФорма);
	ПараметрыЗапроса.Вставить("ДатаНачалаПериода",ДатаНачала);
	ПараметрыЗапроса.Вставить("ДатаОкончанияПериода",ДатаОкончания);

	ПараметрыВыполненияВФоне=ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"Отчеты.ПовторныеПродажи.ЗаполнитьСписокКлиентов", 
		ПараметрыЗапроса,
		ПараметрыВыполненияВФоне);
	
	ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	АдресХранилища       = РезультатВыполнения.АдресРезультата;
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		ВывестиСписок();
	КонецЕсли;

	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ВывестиСписок();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ФоновоеЗаданиеОтменить(ИдентификаторЗадания)
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
КонецПроцедуры

&НаСервере
Процедура ВывестиСписок()
	
	РезультатСписок = ПолучитьИзВременногоХранилища(АдресХранилища);
	УдалитьИзВременногоХранилища(АдресХранилища);
	ИдентификаторЗадания = Неопределено;

	Макет = Отчеты.ПовторныеПродажи.ПолучитьМакет("КлиентыСегмента");
		
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьОписание = Макет.ПолучитьОбласть("Описание");
	
	//Описываем область Шапка	
	Текст = НСтр("ru='Всего: [Количество] ([Проценты]% клиентов из всех сегментов)'");
	Значения = Новый Структура("Количество, Проценты", СписокРасшифровки.Количество(), Формат(Проценты,"ЧДЦ=0"));		
	ОбластьШапка.Параметры.КолвоКлиентов = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Текст,Значения);
	
	Валюта = Константы.ВалютаУправленческогоУчета.Получить();
	Значения.Вставить("Валюта", Валюта);

	Если Сегмент = "АН" Или Сегмент = "АП"
		Или Сегмент = "АВ" Тогда
		Текст = НСтр("ru='Выручка за период: [Выручка] [Валюта]'");
	    Картинка = БиблиотекаКартинок.ОтчетПовторныеПродажиВыручка;
		Значения.Вставить("Выручка", Формат(Выручка,"ЧДЦ=0"));
	Иначе
		Текст = НСтр("ru='Потенциал за период: [Потенциал]'");
	    Картинка = БиблиотекаКартинок.ОтчетПовторныеПродажиПотенциал;
		Значения.Вставить("Потенциал", Формат(Потенциал));
	КонецЕсли;
	
	ОбластьШапка.Параметры.ВыручкаПотенциал = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Текст,Значения);
	
	//Описываем область Описание
	Если Сегмент = "АН" Тогда   
		ОбластьШапка.Параметры.НазваниеСегмента = НСтр("ru='Активные новые клиенты'");  
		Цвет = Новый Цвет(230, 255, 205);
		Значения.Вставить("До", До);
		Текст = НСтр("ru='Клиенты, совершившие на конец периода единственную покупку, причем эта покупка состоялась менее [До] дн. назад, считая с конца периода.'");
	ИначеЕсли Сегмент = "АП" Тогда  
		ОбластьШапка.Параметры.НазваниеСегмента = НСтр("ru='Активные перспективные клиенты'");
		Цвет = Новый Цвет(201, 255, 148);
		Значения.Вставить("До", До);
		Значения.Вставить("ПокупкиОт", ПокупкиОт);
		Значения.Вставить("ПокупкиДо", ПокупкиДо);
		Текст = НСтр("ru='Клиенты, совершившие на конец периода от [ПокупкиОт] до [ПокупкиДо] покупок, причем последняя покупка состоялась менее [До] дн. назад, считая с конца периода.'");	
	ИначеЕсли Сегмент = "АВ" Тогда 
		ОбластьШапка.Параметры.НазваниеСегмента = НСтр("ru='Активные верные клиенты'");
		Цвет = Новый Цвет(173, 255, 90);
		Значения.Вставить("До", До);
		Значения.Вставить("Покупки", Покупки);
		Текст = НСтр("ru='Клиенты, совершившие на конец периода более [Покупки] покупок, причем последняя покупка состоялась менее [До] дн. назад, считая с конца периода.'");	
		
	ИначеЕсли Сегмент = "ЗН" Тогда   
		ОбластьШапка.Параметры.НазваниеСегмента = НСтр("ru='Засыпающие новые клиенты'");
		Цвет = Новый Цвет(255, 255, 205);
		Текст = НСтр("ru='Клиенты, совершившие на конец периода единственную покупку, причём эта покупка состоялась от [От] до [До] дн. назад, считая с конца периода.'");
		Значения.Вставить("От", От);
		Значения.Вставить("До", До);	
	ИначеЕсли Сегмент = "ЗП" Тогда 
		ОбластьШапка.Параметры.НазваниеСегмента = НСтр("ru='Засыпающие перспективные клиенты'");
		Цвет = Новый Цвет(255, 255, 148);
		Текст = НСтр("ru='Клиенты, совершившие на конец периода от [ПокупкиОт] до [ПокупкиДо] покупок, причём последняя покупка состоялась от [От] до [До] дн. назад, считая с конца периода.'");
		Значения.Вставить("От", От);
		Значения.Вставить("До", До);
		Значения.Вставить("ПокупкиОт", ПокупкиОт);
		Значения.Вставить("ПокупкиДо", ПокупкиДо);
	ИначеЕсли Сегмент = "ЗВ" Тогда 
		ОбластьШапка.Параметры.НазваниеСегмента = НСтр("ru='Засыпающие верные клиенты'");
		Цвет = Новый Цвет(255, 255, 90);
		Значения.Вставить("До", До);
		Значения.Вставить("От", От);
		Значения.Вставить("Покупки", Покупки);
		Текст = НСтр("ru='Клиенты, совершившие на конец периода более [Покупки] покупок, причём последняя покупка состоялась от [От] до [До] дн. назад, считая с конца периода.'");	
	
	ИначеЕсли Сегмент = "СН" Тогда     
		ОбластьШапка.Параметры.НазваниеСегмента = НСтр("ru='Спящие новые клиенты'");
		Цвет = Новый Цвет(255, 205, 205);
		Значения.Вставить("От", От);
		Текст = НСтр("ru='Клиенты, совершившие на конец периода единственную покупку, причём эта покупка состоялась более [От] дн. назад, считая с конца периода.'");
	ИначеЕсли Сегмент = "СП" Тогда 
		ОбластьШапка.Параметры.НазваниеСегмента = НСтр("ru='Спящие перспективные клиенты'");
		Цвет = Новый Цвет(255, 148, 148);
		Значения.Вставить("ПокупкиОт", ПокупкиОт);
		Значения.Вставить("ПокупкиДо", ПокупкиДо);
		Значения.Вставить("От", От);
		Текст = НСтр("ru='Клиенты, совершившие на конец периода от [ПокупкиОт] до [ПокупкиДо] покупок, причем последняя покупка состоялась более [От] дн. назад, считая с конца периода.'");
	ИначеЕсли Сегмент = "СВ" Тогда     
		ОбластьШапка.Параметры.НазваниеСегмента = НСтр("ru='Спящие верные клиенты'");
		Цвет = Новый Цвет(255, 90, 90);
		Значения.Вставить("Покупки",Покупки);
		Значения.Вставить("От", От);
		Значения.Вставить("До", До);
		Текст = НСтр("ru='Клиенты, совершившие на конец периода более [Покупки] покупок,причём последняя покупка состоялась более [От] дн. назад, считая с конца периода.'");
	КонецЕсли;
	
	ОбластьОписание.Параметры.ОписаниеСегмента = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Текст,Значения);
	Результат.Очистить();	
	Результат.Вывести(ОбластьШапка);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
	Результат.Вывести(ОбластьОписание);
	Результат.Область("R5C1").Картинка = Картинка;
	Результат.Область("Шапка").ЦветФона = Цвет;

	//Проверка на заполненость отборов
	Если ПериодИспользование Или ОрганизацияИспользование Или МенеджерИспользование
		Или СуммаПокупокИспользование Или СегментКлиентовИспользование
		Или СегментНоменклатурыИспользование Или НоменклатураИспользование Тогда
		ОбластьПараметры = Макет.ПолучитьОбласть("ОблПараметры");
	    Результат.Вывести(ОбластьПараметры);
	КонецЕсли;
		
	Если ПериодИспользование Тогда
		ОбластьПериод = Макет.ПолучитьОбласть("ОблПериод");
		ШаблонДаты = НСтр("ru='ДФ=%Парам1%'");
		ШаблонДаты = СтрЗаменить(ШаблонДаты, "%Парам1%", "dd.MM.yyyy");
		Значения.Вставить("ДатаНачала", Формат(ДатаНачала,ШаблонДаты));
		Значения.Вставить("ДатаОкончания", Формат(ДатаОкончания,ШаблонДаты));
		Текст = НСтр("ru='[ДатаНачала] - [ДатаОкончания]'");
		ОбластьПериод.Параметры.Период = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Текст,Значения); 
		Результат.Вывести(ОбластьПериод);
	КонецЕсли;
	
	Если ОрганизацияИспользование Тогда
		ОбластьОрганизация = Макет.ПолучитьОбласть("ОблОрганизация");
		ОбластьОрганизация.Параметры.Организация = Организация; 
		Результат.Вывести(ОбластьОрганизация);
	КонецЕсли;

	Если МенеджерИспользование Тогда
		ОбластьМенеджер = Макет.ПолучитьОбласть("ОблМенеджер");
		ОбластьМенеджер.Параметры.Менеджер = Менеджер; 
		Результат.Вывести(ОбластьМенеджер);
	КонецЕсли;
	
	Если СуммаПокупокИспользование Тогда
		ОбластьСуммаОт = Макет.ПолучитьОбласть("ОблСуммаОт");
		Значения.Вставить("СуммаОт", СуммаПокупок);
		Текст = НСтр("ru='[СуммаОт] [Валюта].'");
		ОбластьСуммаОт.Параметры.СуммаПокупокОт = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Текст,Значения); 
		Результат.Вывести(ОбластьСуммаОт);
	КонецЕсли;
	
	Если СегментКлиентовИспользование Тогда
		ОбластьСегментКлиентов = Макет.ПолучитьОбласть("ОблСегментКлиентов");
		ОбластьСегментКлиентов.Параметры.СегментКлиентов = СегментКлиентов ; 
		Результат.Вывести(ОбластьСегментКлиентов);
	КонецЕсли;
	
	Если СегментНоменклатурыИспользование Тогда
		ОбластьСегментНоменклатуры = Макет.ПолучитьОбласть("ОблСегментНоменклатуры");
		ОбластьСегментНоменклатуры.Параметры.СегментНоменклатуры = СегментНоменклатуры; 
		Результат.Вывести(ОбластьСегментНоменклатуры);
	КонецЕсли;
	
	Если НоменклатураИспользование Тогда
		ОбластьНоменклатура = Макет.ПолучитьОбласть("ОблНоменклатура");
		ОбластьНоменклатура.Параметры.Номенклатура = Номенклатура; 
		Результат.Вывести(ОбластьНоменклатура);
	КонецЕсли;
	
	//Выводим шапку таблицы
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ТаблицаШапка");
	Результат.Вывести(ОбластьШапкаТаблицы);
	
	Текст = НСтр("ru='Сумма покупок за период, [Валюта]'");	
	Результат.Область("Сумма").Текст =СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Текст,Значения);
	
	Текст = НСтр("ru='Сумма покупок на конец периода за всё время, [Валюта]'");	
	Результат.Область("СуммаВсего").Текст =СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Текст,Значения);
	
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	
	//Заполняем параметры расшифровки
	ИменаПараметровОтборов = 
		"Организация,ОрганизацияИспользование,
		|Менеджер,МенеджерИспользование,
		|ДатаНачала,ДатаОкончания,ПериодИспользование,
		|Номенклатура,НоменклатураИспользование,,
		|СегментКлиентов,СегментКлиентовИспользование,
		|СегментНоменклатуры,СегментНоменклатурыИспользование,
		|СуммаПокупок,СуммаПокупокИспользование,
		|ПокупкиПерспективныеДо,АктивныеДо,ЗасыпающиеДо,
		|АктивныеПерспективныеДо,ЗасыпающиеПерспективныеДо,
		|АктивныеВерныеДо,ЗасыпающиеВерныеДо,ПокупкиВерные";

	Отборы = Новый Структура(ИменаПараметровОтборов);
	ЗаполнитьЗначенияСвойств(Отборы, ЭтаФорма);
	
	//Заполняем таблицу
	СписокКлиентов = РезультатСписок.СписокКлиентов;
	Для Каждого Строка Из СписокКлиентов Цикл
		ОбластьСтрока.Параметры.Клиент = Строка.Клиент.НаименованиеПолное;
		РасшифровкаК = Новый Структура ("Клиент",Строка.Клиент);
		ОбластьСтрока.Параметры.рКлиент = РасшифровкаК;
		
		ОбластьСтрока.Параметры.МенеджерКлиента = Строка.МенеджерКлиента;
		РасшифровкаМ = Новый Структура ("Менеджер",Строка.МенеджерКлиента);
		ОбластьСтрока.Параметры.рМенеджер = РасшифровкаМ;

		ОбластьСтрока.Параметры.ДатаПокупки = Строка.ДатаПокупки;
		
		РасшифровкаП = Новый Структура ("КолвоПокупок",Строка.Клиент);
		РасшифровкаП.Вставить("Отбор",Отборы);
		ОбластьСтрока.Параметры.КолвоПокупок = Строка.КолвоПокупок;
		ОбластьСтрока.Параметры.pКолвоПокупок = РасшифровкаП;
		
		РасшифровкаПВсе = Новый Структура ("КолвоПокупокВсего",Строка.Клиент);
		РасшифровкаПВсе.Вставить("Отбор",Отборы);
		ОбластьСтрока.Параметры.КолвоПокупокВсего = Строка.КолвоПокупокВсего;
		ОбластьСтрока.Параметры.pКолвоПокупокВсего = РасшифровкаПВсе;
		
		ОбластьСтрока.Параметры.СуммаПокупок = Строка.СуммаПокупок;
		ОбластьСтрока.Параметры.СуммаПокупокВсего = Строка.СуммаПокупокВсего;
		ОбластьСтрока.Параметры.ЭлАдрес = Строка.ЭлАдрес;
		ОбластьСтрока.Параметры.Телефон = Строка.Телефон;
		Результат.Вывести(ОбластьСтрока);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	СтандартнаяОбработка = Ложь;
	Если Расшифровка.Свойство("Клиент") Тогда
		ПоказатьЗначение(,Расшифровка.Клиент);
	ИначеЕсли Расшифровка.Свойство("Менеджер") Тогда
		ПоказатьЗначение(,Расшифровка.Менеджер);
	ИначеЕсли Расшифровка.Свойство("КолвоПокупок") Тогда 
		Расшифровка.Вставить("ВидПокупок","КолвоПокупок");
		ОткрытьФорму("Отчет.ПовторныеПродажи.Форма.ФормаСпискаПокупок",Расшифровка,ЭтаФорма);
	ИначеЕсли Расшифровка.Свойство("КолвоПокупокВсего") Тогда
		Расшифровка.Вставить("ВидПокупок","КолвоПокупокВсего");
		ОткрытьФорму("Отчет.ПовторныеПродажи.Форма.ФормаСпискаПокупок",Расшифровка,ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
