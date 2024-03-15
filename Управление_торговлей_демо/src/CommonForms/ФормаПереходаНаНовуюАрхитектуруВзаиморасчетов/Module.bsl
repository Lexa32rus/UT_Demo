
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПроцесс;
	Интервал = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("Подключаемый_ЗапуститьПереход", 0.1, Истина);
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", Интервал, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьЗавершениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ЖурналРегистрации" Тогда
		КодОсновногоЯзыка = ОбщегоНазначенияКлиент.КодОсновногоЯзыка();
		СобытияЖурнала = Новый Массив;
		СобытияЖурнала.Добавить(НСтр("ru = 'Включение онлайн взаиморасчетов с партнерами.'", КодОсновногоЯзыка));
		СобытияЖурнала.Добавить(НСтр("ru = 'Включение онлайн взаиморасчетов с партнерами. Не удалось заполнить регистр перехода.'", КодОсновногоЯзыка));
		СобытияЖурнала.Добавить(НСтр("ru = 'Включение онлайн взаиморасчетов с партнерами. Работа потока.'", КодОсновногоЯзыка));
		СобытияЖурнала.Добавить(НСтр("ru = 'Включение онлайн взаиморасчетов с партнерами. Этап 2.'", КодОсновногоЯзыка));
		Отбор = Новый Структура;
		Отбор.Вставить("СобытиеЖурналаРегистрации", СобытияЖурнала);
		Отбор.Вставить("Уровень", "Ошибка");
		Отбор.Вставить("ДатаНачала", НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса()));
		Отбор.Вставить("ДатаОкончания", ОбщегоНазначенияКлиент.ДатаСеанса());
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Отбор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	ОтменитьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СообщитьВТехПоддержку(Команда)
	
	//++ Локализация
	ОткрытьФорму("Обработка.ПомощникОбращенияВТехническуюПоддержку.Форма.Форма");
	//-- Локализация
	Возврат; // обработка не требуется
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции 

&НаКлиенте
Процедура Подключаемый_ЗапуститьПереход()
	
	ЗапуститьПереходНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	Сведения = ОбновитьПрогресс();
	Если Сведения.Задание.Статус = "Выполняется" Тогда
		Интервал = Интервал * 1.2;
		Если Интервал > 15 Тогда
			Интервал = 15;
		КонецЕсли;
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", Интервал, Истина);
	Иначе
		ЗаполнитьРегистрыЗавершениеНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗапуститьПереходНаСервере()
	
	ИмяПроцедуры = "ОперативныеВзаиморасчетыСервер.ЗаполнитьРегистрыПриВключенииНовойАрхитектуры";
	ПараметрыПроцедуры = Новый Массив;
	ПараметрыПроцедуры.Добавить(Новый Структура);
	ПараметрыПроцедуры.Добавить(УникальныйИдентификатор);
	Наименование = НСтр("ru = 'Автоматический переход на онлайн взаиморасчеты'");
	Ключ = Новый УникальныйИдентификатор;
	Задание = ФоновыеЗадания.Выполнить(ИмяПроцедуры, ПараметрыПроцедуры, Ключ, Наименование);
	ИдентификаторЗадания = Задание.УникальныйИдентификатор;
	
КонецПроцедуры

&НаКлиенте
Функция ОбновитьПрогресс()
	
	ИнфоВыполнения = ОбновитьСведенияОХодеВыполнения(ИдентификаторЗадания);
	Если ИнфоВыполнения.Всего > 0 Тогда
		Элементы.Индикатор.МаксимальноеЗначение = ИнфоВыполнения.Всего;
		Индикатор = ИнфоВыполнения.Обработано;
		Элементы.Индикатор.Видимость = Истина;
	КонецЕсли;
	Возврат ИнфоВыполнения;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОбновитьСведенияОХодеВыполнения(ИдентификаторЗадания)
	
	ВсегоКПереносу = 0;
	Отбор = Новый Структура("КлючОбъекта,КлючНастроек", "ПереходНаНовуюАрхитектуруВзаиморасчетов", "ВсегоКПереносу");
	Настройка = ХранилищеОбщихНастроек.Выбрать(Отбор);
	Если Настройка.Следующий() Тогда
		ВсегоКПереносу = Настройка.Настройки;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	""НеОбработанные"" КАК Наименование,
	|	КОЛИЧЕСТВО(ЗаданияКРаспределениюРасчетов.ОбъектРасчетов) КАК Всего
	|ИЗ
	|	РегистрСведений.ЗаданияКРаспределениюРасчетов КАК ЗаданияКРаспределениюРасчетов
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""ДополнительныеЗаписи"" КАК Наименование,
	|	КОЛИЧЕСТВО(ЗаданияКРаспределениюРасчетов.ОбъектРасчетов)
	|ИЗ
	|	РегистрСведений.ЗаданияКРаспределениюРасчетов КАК ЗаданияКРаспределениюРасчетов
	|ГДЕ
	|	ЗаданияКРаспределениюРасчетов.Документ <> НЕОПРЕДЕЛЕНО";
	Запрос = Новый Запрос(ТекстЗапроса);
	
	ЗаписейВРегистре = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Всего");
	НеОбработанные = ЗаписейВРегистре[0];
	ДополнительныеЗаписи = ЗаписейВРегистре[1];
	
	ВсегоКПереносу = ВсегоКПереносу + ДополнительныеЗаписи;
	Обработано = ?(НеОбработанные = 0, 0, ВсегоКПереносу - НеОбработанные);
	Результат = Новый Структура("Всего,Обработано", ВсегоКПереносу, Обработано);
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Описание = Новый Структура("Статус");
	Если Задание <> Неопределено Тогда
		Описание = Новый Структура;
		Статус = "Выполняется";
		Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
			Статус = "Ошибка";
		ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Завершено Тогда
			Статус = "Выполнено";
		КонецЕсли;
		Описание.Вставить("Статус", Статус);
		Если Статус = "Ошибка" И Задание.ИнформацияОбОшибке <> Неопределено Тогда
			Описание.КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(Задание.ИнформацияОбОшибке);
			Описание.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(Задание.ИнформацияОбОшибке);
		КонецЕсли;
	КонецЕсли; 
	Результат.Вставить("Задание", Описание);
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОтменитьИЗакрыть()
	
	ОтменитьВыполнениеЗадания();
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
		Если Задание = Неопределено	Или Задание.Состояние <> СостояниеФоновогоЗадания.Активно Тогда
			Возврат;
		КонецЕсли;
		
		Попытка
			Задание.Отменить();
		Исключение
			// Возможно задание как раз в этот момент закончилось и ошибки нет.
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Длительные операции. Отмена выполнения фонового задания'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Информация, , , КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРегистрыЗавершениеНаСервере()
	
	Элементы.ФормаОтмена.Заголовок = НСтр("ru = 'Закрыть'");
	Если НЕ Константы.НоваяАрхитектураВзаиморасчетов.Получить() Тогда
		Элементы.ДекорацияИнфо.Картинка = БиблиотекаКартинок.Ошибка32;
		//++ Локализация
		Элементы.ФормаТехПоддержка.Видимость = Истина;
		//-- Локализация
		
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(НСтр("ru = 'В процессе перехода возникли ошибки.
		|Для расследования и устранения причин возникновения ошибок
		|обратитесь пожалуйста в службу технической поддержки.'") + Символы.ПС);
		ТекстГиперссылки = НСтр("ru = 'см. журнал регистрации'");
		СтрокаГиперссылки = Новый ФорматированнаяСтрока(
			ТекстГиперссылки, 
	    	, 
			ЦветаСтиля.ЦветТекстаКнопки, ,
			"ЖурналРегистрации");
		МассивСтрок.Добавить(СтрокаГиперссылки);
		Элементы.НадписьЗавершение.Заголовок = Новый ФорматированнаяСтрока(МассивСтрок);
		Константы.НеСпрашиватьПроПереходНаОнлайнВзаиморасчеты.Установить(Истина);
	КонецЕсли;
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗавершение;
	
КонецПроцедуры

#КонецОбласти