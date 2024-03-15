#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура заполняет табличную часть документа по правилу заполнения из различных источников.
//
Процедура ЗаполнитьПоПравилуЗаполнения() Экспорт 
	
	Параметры = Новый Структура("Ссылка, Сценарий, КроссТаблица, ИзменитьРезультатНа, ЗаполненоАвтоматически, ТочностьОкругления, 
		|Склад, МаксимальныйКодСтрокиТовары, Статус, Периодичность, НачалоПериода, ОкончаниеПериода");
	
	ЗаполнитьЗначенияСвойств(Параметры, ЭтотОбъект);
	
	Параметры.Вставить("ЗаполнятьПоПравилу", Истина);
	Параметры.Вставить("ПравилоЗаполнения", ПравилоЗаполнения.Выгрузить());
	Параметры.Вставить("ПользовательскиеНастройки", ПользовательскиеНастройки.Получить());
	
	ЗаполняемаяТЧ = Товары.Выгрузить();
	Если ОбновитьДополнить = 0 Тогда
		ЗаполняемаяТЧ.Очистить();
	КонецЕсли;
	
	Параметры.Вставить("ЗаполняемаяТЧ", ЗаполняемаяТЧ);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено);
	Документы.ПланСборкиРазборки.ЗаполнитьПоПравилуЗаполнения(Параметры, АдресХранилища);
	
	ЗаполняемаяТЧ = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Товары.Загрузить(ЗаполняемаяТЧ);
	
	МаксимальныйКодСтрокиТовары = Параметры.МаксимальныйКодСтрокиТовары;
	
	ЗаполненоАвтоматически = Истина;
	
КонецПроцедуры

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыПланов[НовыйСтатус];
	
	Статус = ЗначениеНовогоСтатуса;
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	// Пропускаем обработку, чтобы гарантировать получение формы объекта при передаче параметра "АвтоТест".
	Если ДанныеЗаполнения = "АвтоТест" Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ДанныеЗаполнения.Свойство("Сценарий", ЭтотОбъект.Сценарий);
		ДанныеЗаполнения.Свойство("ВидПлана", ЭтотОбъект.ВидПлана);
		ДанныеЗаполнения.Свойство("НачалоПериода", ЭтотОбъект.НачалоПериода);
		ДанныеЗаполнения.Свойство("ОкончаниеПериода", ЭтотОбъект.ОкончаниеПериода);
		ДанныеЗаполнения.Свойство("Статус", ЭтотОбъект.Статус);
	Иначе
		ЗаполнитьДанныеПоУмолчанию();
	КонецЕсли;
	
	ЗаполнитьРеквизитыПланаПоСценариюВидуПлана();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи <> РежимЗаписиДокумента.Запись 
		И Не ДополнительныеСвойства.Свойство("ПропуститьПроверкуЗапретаИзменения") Тогда
		
		ДанныеДляПроверки = ДатыЗапретаИзменения.ШаблонДанныхДляПроверки();
		НоваяСтрока = ДанныеДляПроверки.Добавить();
		НоваяСтрока.Дата   = НачалоПериода;
		НоваяСтрока.Раздел = "Планирование";
		НоваяСтрока.Объект = Сценарий;
		
		Если ЗначениеЗаполнено(СценарийБюджетирования) Тогда
			НоваяСтрока = ДанныеДляПроверки.Добавить();
			НоваяСтрока.Дата   = НачалоПериода;
			НоваяСтрока.Раздел = "Бюджетирование";
			НоваяСтрока.Объект = СценарийБюджетирования;
		КонецЕсли;
		
		ОписаниеДанных = Новый Структура;
		ОписаниеДанных.Вставить("НоваяВерсия", Истина);
		ОписаниеДанных.Вставить("Данные",      Ссылка);
		
		ОписаниеОшибки = "";
		Если ДатыЗапретаИзменения.НайденЗапретИзмененияДанных(ДанныеДляПроверки, ОписаниеДанных, ОписаниеОшибки) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				ОписаниеОшибки,
				ЭтотОбъект,
				, // Поле
				, // ПутьКДанным
				Отказ);
		КонецЕсли;
			
	КонецЕсли;
	
	
	// Заполнить даты поступления
	Если Не КроссТаблица Тогда
		Для Каждого Строка Из Товары Цикл
			Если Не ЗначениеЗаполнено(Строка.ДатаСборкиРазборки) Тогда
				Строка.ДатаСборкиРазборки = НачалоПериода;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Замещающий Тогда
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗамещениеПланов");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("ВидПлана", ВидПлана);
		Блокировка.Заблокировать();
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Планирование.ПроверитьСтатусУтвержден(ЭтотОбъект, Отказ, РежимЗаписи, Перечисления.ТипыПланов.ПланСборкиРазборки);
	
	Для каждого СтрокаТЧ Из Товары Цикл
		Если ЗначениеЗаполнено(Склад) Тогда
			СтрокаТЧ.Склад = Склад;
		КонецЕсли; 
	КонецЦикла;
	
	
	Если Замещающий 
		И Не ЭтоНовый()
		И Не Отказ Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбновитьЗамещениеПлана(РежимЗаписи);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Если Не Замещающий
		И Не ЭтоНовый()
		И Не Отказ
		И Планирование.ЕстьЗамещениеПлана(Ссылка) Тогда
		НаборЗаписей = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ЗамещенныйПлан.Установить(Ссылка);
		
		НаборЗаписей.Записать();
	КонецЕсли;
	
	Если ЗаполнятьАвтоматически
		И (Статус = Перечисления.СтатусыПланов.Отменен
		Или Статус = Перечисления.СтатусыПланов.ВПодготовке) Тогда
		ЗаполнятьАвтоматически = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЗамещениеПлана(РежимЗаписи, ОбновлениеИБ = Ложь) Экспорт
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения
		Или (РежимЗаписи = РежимЗаписиДокумента.Запись И Не Проведен) Тогда
		
		Для Каждого Строка Из Товары Цикл
			Строка.Замещен = Ложь;
			Строка.ЗамещенКЗаказу = Ложь;
		КонецЦикла;
		
		НаборЗаписей = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ЗамещенныйПлан.Установить(Ссылка);
		
		НаборЗаписей.Записать();
		Возврат;
	КонецЕсли;
		
	Периоды = Новый ТаблицаЗначений();
	Периоды.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	ДобавлениеДатаНачала = НачалоПериода;
	Пока ДобавлениеДатаНачала < КонецДня(ОкончаниеПериода) Цикл
		НоваяСтрока = Периоды.Добавить();
		НоваяСтрока.Период = ДобавлениеДатаНачала;
		
		ДатуОкончанияПериода = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(ДобавлениеДатаНачала, Периодичность);
		ДобавлениеДатаНачала = ДатуОкончанияПериода+1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Периоды.Период КАК Период
	|ПОМЕСТИТЬ Периоды
	|ИЗ
	|	&Периоды КАК Периоды
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПланСборкиРазборкиЗамещающий.Ссылка КАК Ссылка,
	|	ПланСборкиРазборкиЗамещающий.ВидПлана КАК ВидПлана,
	|	ВЫБОР
	|		КОГДА &НачалоПериода > ПланСборкиРазборкиЗамещающий.НачалоПериода
	|			ТОГДА &НачалоПериода
	|		ИНАЧЕ ПланСборкиРазборкиЗамещающий.НачалоПериода
	|	КОНЕЦ КАК НачалоПериода,
	|	ВЫБОР
	|		КОГДА &ОкончаниеПериода < ПланСборкиРазборкиЗамещающий.ОкончаниеПериода
	|			ТОГДА &ОкончаниеПериода
	|		ИНАЧЕ ПланСборкиРазборкиЗамещающий.ОкончаниеПериода
	|	КОНЕЦ КАК ОкончаниеПериода,
	|	ПланСборкиРазборкиЗамещающий.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Утвержден)
	|		И &Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Утвержден) КАК ЗамещенКЗаказу,
	|	ПланСборкиРазборкиЗамещающий.Статус.Порядок >= &СтатусИндекс
	|		ИЛИ ПланСборкиРазборкиЗамещающий.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.НаУтверждении)
	|			И &Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Утвержден) КАК Замещен,
	|	ПланСборкиРазборкиЗамещающий.Статус КАК СтатусЗамещения
	|ПОМЕСТИТЬ ЗамещаемыеПланы
	|ИЗ
	|	Документ.ПланСборкиРазборки КАК ПланСборкиРазборкиЗамещающий
	|ГДЕ
	|	ПланСборкиРазборкиЗамещающий.ОкончаниеПериода >= &НачалоПериода
	|	И ПланСборкиРазборкиЗамещающий.НачалоПериода <= &ОкончаниеПериода
	|	И ПланСборкиРазборкиЗамещающий.Ссылка <> &Ссылка
	|	И ПланСборкиРазборкиЗамещающий.Проведен
	|	И ПланСборкиРазборкиЗамещающий.ВидПлана = &ВидПлана
	|	И &Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Отменен)
	|	И (ПланСборкиРазборкиЗамещающий.Статус.Порядок >= &СтатусИндекс
	|			ИЛИ ПланСборкиРазборкиЗамещающий.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.НаУтверждении)
	|				И &Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Утвержден))
	|	И ПланСборкиРазборкиЗамещающий.Дата > &Дата
	|	И ПланСборкиРазборкиЗамещающий.Назначение = &Назначение
	|	И ПланСборкиРазборкиЗамещающий.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|	И ПланСборкиРазборкиЗамещающий.Склад = &Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещаемыеПланы.ВидПлана КАК ВидПлана,
	|	Периоды.Период КАК ЗамещенныйПериод,
	|	ЛОЖЬ КАК КЗамещению,
	|	ЛОЖЬ КАК КОтменеЗамещения,
	|	ЗамещаемыеПланы.Ссылка КАК ЗамещающийПлан,
	|	&Ссылка КАК ЗамещенныйПлан,
	|	ЗамещаемыеПланы.ЗамещенКЗаказу КАК ЗамещенКЗаказу,
	|	ЗамещаемыеПланы.Замещен КАК Замещен,
	|	ЗамещаемыеПланы.СтатусЗамещения КАК СтатусЗамещения
	|ПОМЕСТИТЬ ЗамещениеПланов
	|ИЗ
	|	ЗамещаемыеПланы КАК ЗамещаемыеПланы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Периоды КАК Периоды
	|		ПО ЗамещаемыеПланы.НачалоПериода <= Периоды.Период
	|			И ЗамещаемыеПланы.ОкончаниеПериода >= Периоды.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланСборкиРазборкиТовары.ДатаСборкиРазборки КАК ДатаСборкиРазборки,
	|	ВЫБОР &Периодичность
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланСборкиРазборкиТовары.ДатаСборкиРазборки, НЕДЕЛЯ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланСборкиРазборкиТовары.ДатаСборкиРазборки, ДЕКАДА)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланСборкиРазборкиТовары.ДатаСборкиРазборки, МЕСЯЦ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланСборкиРазборкиТовары.ДатаСборкиРазборки, КВАРТАЛ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланСборкиРазборкиТовары.ДатаСборкиРазборки, ПОЛУГОДИЕ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланСборкиРазборкиТовары.ДатаСборкиРазборки, ГОД)
	|		ИНАЧЕ ПланСборкиРазборкиТовары.ДатаСборкиРазборки
	|	КОНЕЦ КАК Период
	|ПОМЕСТИТЬ ПланСборкиРазборкиТовары
	|ИЗ
	|	&ПланСборкиРазборкиТовары КАК ПланСборкиРазборкиТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланСборкиРазборкиТовары.ДатаСборкиРазборки КАК ДатаСборкиРазборки,
	|	МАКСИМУМ(ЗамещениеПланов.ЗамещенКЗаказу) КАК ЗамещенКЗаказу,
	|	МАКСИМУМ(ЗамещениеПланов.Замещен) КАК Замещен
	|ИЗ
	|	ЗамещениеПланов КАК ЗамещениеПланов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСборкиРазборкиТовары КАК ПланСборкиРазборкиТовары
	|		ПО ЗамещениеПланов.ЗамещенныйПериод = ПланСборкиРазборкиТовары.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	ПланСборкиРазборкиТовары.ДатаСборкиРазборки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещениеПланов.ВидПлана КАК ВидПлана,
	|	ЗамещениеПланов.ЗамещенныйПериод КАК ЗамещенныйПериод,
	|	ЗамещениеПланов.КЗамещению КАК КЗамещению,
	|	ЗамещениеПланов.КОтменеЗамещения КАК КОтменеЗамещения,
	|	ЗамещениеПланов.ЗамещающийПлан КАК ЗамещающийПлан,
	|	ЗамещениеПланов.ЗамещенныйПлан КАК ЗамещенныйПлан,
	|	ЗамещениеПланов.СтатусЗамещения КАК СтатусЗамещения
	|ИЗ
	|	ЗамещениеПланов КАК ЗамещениеПланов";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидПлана", ВидПлана);
	Запрос.УстановитьПараметр("СтатусИндекс", Перечисления.СтатусыПланов.Индекс(Статус));
	Запрос.УстановитьПараметр("Статус", Статус);
	Запрос.УстановитьПараметр("Статус", Статус);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Назначение", Назначение);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("ОкончаниеПериода", ОкончаниеПериода);
	Запрос.УстановитьПараметр("Периоды", Периоды);
	Запрос.УстановитьПараметр("Периодичность", Периодичность);
	Запрос.УстановитьПараметр("ПланСборкиРазборкиТовары", Товары.Выгрузить());
	
	ЗапросПакет = Запрос.ВыполнитьПакет();
	Выборка = ЗапросПакет[4].Выбрать();
	ТаблицаЗамещениеПлана = ЗапросПакет[5].Выгрузить();
	
	Для Каждого Строка Из Товары Цикл
		Строка.Замещен = Ложь;
		Строка.ЗамещенКЗаказу = Ложь;
	КонецЦикла;
	
	Пока Выборка.Следующий() Цикл
		
		Отбор = Новый Структура("ДатаСборкиРазборки", Выборка.ДатаСборкиРазборки);
		ЗамещаемыеСтроки = Товары.НайтиСтроки(Отбор);
		Для Каждого Строка Из ЗамещаемыеСтроки Цикл
			Строка.Замещен = Выборка.Замещен;
			Строка.ЗамещенКЗаказу = Выборка.ЗамещенКЗаказу;
		КонецЦикла;
		
	КонецЦикла;
	
	НаборЗаписей = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЗамещенныйПлан.Установить(Ссылка);
		
	НаборЗаписей.Загрузить(ТаблицаЗамещениеПлана);
	
	Если ОбновлениеИБ Тогда
		НаборЗаписей.ДополнительныеСвойства.Вставить("РегистрироватьНаУзлахПлановОбменаПриОбновленииИБ", Неопределено);
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
		НаборЗаписей.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	Если Не Отказ И (Замещающий 
		ИЛИ Планирование.ЕстьЗамещениеПлана(Ссылка)) Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбновитьЗамещенныеПланы();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЗамещенныеПланы()
	
	Периоды = Новый ТаблицаЗначений();
	Периоды.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	ДобавлениеДатаНачала = НачалоПериода;
	Пока ДобавлениеДатаНачала < КонецДня(ОкончаниеПериода) Цикл
		НоваяСтрока = Периоды.Добавить();
		НоваяСтрока.Период = ДобавлениеДатаНачала;
		
		ДатуОкончанияПериода = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(ДобавлениеДатаНачала, Периодичность);
		ДобавлениеДатаНачала = ДатуОкончанияПериода+1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Периоды.Период КАК Период
	|ПОМЕСТИТЬ Периоды
	|ИЗ
	|	&Периоды КАК Периоды
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПланСборкиРазборкиЗамещенный.Ссылка КАК Ссылка,
	|	ПланСборкиРазборкиЗамещенный.ВидПлана КАК ВидПлана,
	|	ВЫБОР
	|		КОГДА ПланСборкиРазборки.НачалоПериода > ПланСборкиРазборкиЗамещенный.НачалоПериода
	|			ТОГДА ПланСборкиРазборки.НачалоПериода
	|		ИНАЧЕ ПланСборкиРазборкиЗамещенный.НачалоПериода
	|	КОНЕЦ КАК НачалоПериода,
	|	ВЫБОР
	|		КОГДА ПланСборкиРазборки.ОкончаниеПериода < ПланСборкиРазборкиЗамещенный.ОкончаниеПериода
	|			ТОГДА ПланСборкиРазборки.ОкончаниеПериода
	|		ИНАЧЕ ПланСборкиРазборкиЗамещенный.ОкончаниеПериода
	|	КОНЕЦ КАК ОкончаниеПериода,
	|	ПланСборкиРазборки.Статус КАК СтатусЗамещения
	|ПОМЕСТИТЬ ЗамещенныеПланы
	|ИЗ
	|	Документ.ПланСборкиРазборки КАК ПланСборкиРазборки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПланСборкиРазборки КАК ПланСборкиРазборкиЗамещенный
	|		ПО ПланСборкиРазборки.ВидПлана = ПланСборкиРазборкиЗамещенный.ВидПлана
	|			И (ПланСборкиРазборки.Статус.Порядок >= ПланСборкиРазборкиЗамещенный.Статус.Порядок
	|				ИЛИ ПланСборкиРазборки.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.НаУтверждении)
	|					И ПланСборкиРазборкиЗамещенный.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Утвержден))
	|			И ПланСборкиРазборкиЗамещенный.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Отменен)
	|			И ПланСборкиРазборки.Дата > ПланСборкиРазборкиЗамещенный.Дата
	|			И ПланСборкиРазборки.Назначение = ПланСборкиРазборкиЗамещенный.Назначение
	|			И ПланСборкиРазборки.ХозяйственнаяОперация = ПланСборкиРазборкиЗамещенный.ХозяйственнаяОперация
	|			И ПланСборкиРазборки.Склад = ПланСборкиРазборкиЗамещенный.Склад
	|			И (ПланСборкиРазборкиЗамещенный.Проведен)
	|			И (ПланСборкиРазборкиЗамещенный.Замещающий)
	|ГДЕ
	|	ПланСборкиРазборкиЗамещенный.ОкончаниеПериода >= ПланСборкиРазборки.НачалоПериода
	|	И ПланСборкиРазборкиЗамещенный.НачалоПериода <= ПланСборкиРазборки.ОкончаниеПериода
	|	И ПланСборкиРазборки.Ссылка = &Ссылка
	|	И ПланСборкиРазборки.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещаемыеПланы.ВидПлана КАК ВидПлана,
	|	Периоды.Период КАК ЗамещенныйПериод,
	|	ЗамещаемыеПланы.Ссылка КАК ЗамещенныйПлан,
	|	&Ссылка КАК ЗамещающийПлан,
	|	ЗамещаемыеПланы.СтатусЗамещения КАК СтатусЗамещения
	|ПОМЕСТИТЬ ЗамещенныеПланыПоПериодам
	|ИЗ
	|	ЗамещенныеПланы КАК ЗамещаемыеПланы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Периоды КАК Периоды
	|		ПО ЗамещаемыеПланы.НачалоПериода <= Периоды.Период
	|			И ЗамещаемыеПланы.ОкончаниеПериода >= Периоды.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещениеПланов.ЗамещающийПлан КАК ЗамещающийПлан,
	|	ЗамещениеПланов.ЗамещенныйПлан КАК ЗамещенныйПлан,
	|	ЗамещениеПланов.ЗамещенныйПериод КАК ЗамещенныйПериод,
	|	ЗамещениеПланов.ВидПлана КАК ВидПлана,
	|	ВЫБОР
	|		КОГДА ЗамещенныеПланыПоПериодам.СтатусЗамещения ЕСТЬ NULL
	|			ТОГДА ЗамещениеПланов.СтатусЗамещения
	|		ИНАЧЕ ЗамещенныеПланыПоПериодам.СтатусЗамещения
	|	КОНЕЦ КАК СтатусЗамещения,
	|	ЗамещениеПланов.КЗамещению КАК КЗамещению,
	|	ВЫБОР
	|		КОГДА ЗамещенныеПланыПоПериодам.ЗамещенныйПериод ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК КОтменеЗамещения
	|ПОМЕСТИТЬ ЗамещениеПлановСуммаДвижений
	|ИЗ
	|	РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЗамещенныеПланыПоПериодам КАК ЗамещенныеПланыПоПериодам
	|		ПО ЗамещениеПланов.ВидПлана = ЗамещенныеПланыПоПериодам.ВидПлана
	|			И ЗамещениеПланов.ЗамещенныйПериод = ЗамещенныеПланыПоПериодам.ЗамещенныйПериод
	|			И ЗамещениеПланов.ЗамещающийПлан = ЗамещенныеПланыПоПериодам.ЗамещающийПлан
	|			И ЗамещениеПланов.ЗамещенныйПлан = ЗамещенныеПланыПоПериодам.ЗамещенныйПлан
	|			И ЗамещениеПланов.СтатусЗамещения = ЗамещенныеПланыПоПериодам.СтатусЗамещения
	|ГДЕ
	|	ЗамещениеПланов.ЗамещающийПлан = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗамещенныеПланыПоПериодам.ЗамещающийПлан,
	|	ЗамещенныеПланыПоПериодам.ЗамещенныйПлан,
	|	ЗамещенныеПланыПоПериодам.ЗамещенныйПериод,
	|	ЗамещенныеПланыПоПериодам.ВидПлана,
	|	ЗамещенныеПланыПоПериодам.СтатусЗамещения,
	|	ИСТИНА,
	|	ЛОЖЬ
	|ИЗ
	|	ЗамещенныеПланыПоПериодам КАК ЗамещенныеПланыПоПериодам
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов
	|		ПО ЗамещенныеПланыПоПериодам.ВидПлана = ЗамещениеПланов.ВидПлана
	|			И ЗамещенныеПланыПоПериодам.ЗамещенныйПериод = ЗамещениеПланов.ЗамещенныйПериод
	|			И ЗамещенныеПланыПоПериодам.ЗамещенныйПлан = ЗамещениеПланов.ЗамещенныйПлан
	|			И ЗамещенныеПланыПоПериодам.ЗамещающийПлан = ЗамещениеПланов.ЗамещающийПлан
	|			И ЗамещенныеПланыПоПериодам.СтатусЗамещения = ЗамещениеПланов.СтатусЗамещения
	|ГДЕ
	|	ЗамещениеПланов.ЗамещенныйПериод ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗамещениеПлановСуммаДвижений.ЗамещающийПлан КАК ЗамещающийПлан,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан КАК ЗамещенныйПлан,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод КАК ЗамещенныйПериод,
	|	ЗамещениеПлановСуммаДвижений.ВидПлана КАК ВидПлана,
	|	МИНИМУМ(ЕСТЬNULL(ЗамещениеПланов1.КЗамещению, ЗамещениеПлановСуммаДвижений.КЗамещению)) КАК КЗамещению,
	|	МИНИМУМ(ЗамещениеПлановСуммаДвижений.КОтменеЗамещения) КАК КОтменеЗамещения,
	|	МИНИМУМ(ЕСТЬNULL(ЗамещениеПланов.КОтменеЗамещения, ИСТИНА)) КАК ВыполнитьОтменуЗамещению,
	|	ЗамещениеПлановСуммаДвижений.СтатусЗамещения
	|ПОМЕСТИТЬ ЗамещениеПланов
	|ИЗ
	|	ЗамещениеПлановСуммаДвижений КАК ЗамещениеПлановСуммаДвижений
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов
	|		ПО ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан = ЗамещениеПланов.ЗамещенныйПлан
	|			И ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод = ЗамещениеПланов.ЗамещенныйПериод
	|			И (НЕ ЗамещениеПланов.КОтменеЗамещения)
	|			И (&Ссылка <> ЗамещениеПланов.ЗамещающийПлан)
	|			И (ЗамещениеПлановСуммаДвижений.СтатусЗамещения = ЗамещениеПланов.СтатусЗамещения)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов1
	|		ПО ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан = ЗамещениеПланов1.ЗамещенныйПлан
	|			И ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод = ЗамещениеПланов1.ЗамещенныйПериод
	|			И (НЕ ЗамещениеПланов1.КЗамещению)
	|			И (ЗамещениеПлановСуммаДвижений.СтатусЗамещения = ЗамещениеПланов1.СтатусЗамещения)
	|			И (&Ссылка <> ЗамещениеПланов1.ЗамещающийПлан)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗамещениеПлановСуммаДвижений.ВидПлана,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан,
	|	ЗамещениеПлановСуммаДвижений.ЗамещающийПлан,
	|	ЗамещениеПлановСуммаДвижений.СтатусЗамещения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещениеПланов.ЗамещающийПлан КАК ЗамещающийПлан,
	|	ЗамещениеПланов.ЗамещенныйПлан КАК ЗамещенныйПлан,
	|	ЗамещениеПланов.ЗамещенныйПериод КАК ЗамещенныйПериод,
	|	ЗамещениеПланов.ВидПлана КАК ВидПлана,
	|	ЗамещениеПланов.КЗамещению КАК КЗамещению,
	|	ЗамещениеПланов.КОтменеЗамещения КАК КОтменеЗамещения,
	|	ЗамещениеПланов.ВыполнитьОтменуЗамещению КАК ВыполнитьОтменуЗамещению,
	|	ЗамещениеПланов.СтатусЗамещения
	|ИЗ
	|	ЗамещениеПланов КАК ЗамещениеПланов
	|ИТОГИ ПО
	|	ЗамещенныйПлан";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Периоды", Периоды);
	Запрос.УстановитьПараметр("Периодичность", Периодичность);
	
	ЗапросПакет = Запрос.ВыполнитьПакет(); 
	ВыборкаЗамещенныйПлан = ЗапросПакет[5].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ОбновитьЗамещениеПлана = Ложь;
	
	Пока ВыборкаЗамещенныйПлан.Следующий() Цикл
		
		НаборЗаписейОчереди = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
		НаборЗаписейОчереди.Отбор.ЗамещающийПлан.Установить(Ссылка);
		НаборЗаписейОчереди.Отбор.ЗамещенныйПлан.Установить(ВыборкаЗамещенныйПлан.ЗамещенныйПлан); 
		
		Выборка = ВыборкаЗамещенныйПлан.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока Выборка.Следующий() Цикл
			
			Если (Выборка.КЗамещению И Выборка.КОтменеЗамещения)Тогда
				ОбновитьЗамещениеПлана = Истина;
			ИначеЕсли Выборка.КОтменеЗамещения И НЕ Выборка.ВыполнитьОтменуЗамещению Тогда
				Продолжить;
			ИначеЕсли Выборка.КЗамещению Или Выборка.КОтменеЗамещения Тогда
				ОбновитьЗамещениеПлана = Истина;
				ЗаписьОчереди = НаборЗаписейОчереди.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьОчереди, Выборка);
			ИначеЕсли Проведен Тогда
				ЗаписьОчереди = НаборЗаписейОчереди.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьОчереди, Выборка);
			КонецЕсли;
			
		КонецЦикла;
		
		НаборЗаписейОчереди.Записать();
		
	КонецЦикла;
	
	Если ОбновитьЗамещениеПлана Тогда
		Планирование.ЗапускВыполненияФоновогоПроведенияПлана();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Статус = Метаданные().Реквизиты.Статус.ЗначениеЗаполнения;
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	ЗаполнитьРеквизитыПланаПоСценариюВидуПлана();
	Для каждого СтрокаТовары Из Товары Цикл

		СтрокаТовары.Отменено = Ложь;

	КонецЦикла;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	Если Не Отказ
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сценарий,"УправлениеПроцессомПланирования") Тогда
		
		Планирование.ЗапускВыполненияФоновойПроверкиРасчетаДефицитаПоЭтапам(Сценарий, ВидПлана);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	Если Не Отказ
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сценарий,"УправлениеПроцессомПланирования") Тогда
		
		Планирование.ЗапускВыполненияФоновойПроверкиРасчетаДефицитаПоЭтапам(Сценарий, ВидПлана);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	Если КроссТаблица Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Номенклатура");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУпаковок");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ВариантКомплектации");
	Иначе
		ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияКоличества();
		ПараметрыПроверки.ПроверитьВозможностьОкругления = Ложь;
		НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	КонецЕсли;
	
	ПараметрыПроверки = Новый Структура;
	ПараметрыПроверки.Вставить("ИмяТЧ",                    "Товары");
	ПараметрыПроверки.Вставить("ПредставлениеТЧ",          НСтр("ru='Комплекты'"));
	ПараметрыПроверки.Вставить("Периодичность",            Периодичность);
	ПараметрыПроверки.Вставить("ДатаНачала",               НачалоПериода);
	ПараметрыПроверки.Вставить("ДатаОкончания",            ОкончаниеПериода);
	ПараметрыПроверки.Вставить("ИмяПоляДатыПериода",       "ДатаСборкиРазборки");
	ПараметрыПроверки.Вставить("ПредставлениеДатыПериода", НСтр("ru='Дата сборки (разборки)'"));
	
	Если Не КроссТаблица Тогда
		ПланированиеКлиентСервер.ПроверитьДатуПериодаТЧ(ЭтотОбъект, Отказ, ПараметрыПроверки);
	КонецЕсли;
	
	Если КроссТаблица Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Характеристика");
	Иначе
		НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	КонецЕсли; 	
	
	Планирование.ОбработкаПроверкиЗаполненияПоСценариюВидуПлана(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	Если Не КроссТаблица
		И ЗначениеЗаполнено(ВидПлана)
		И Не ЗаполнятьПоДефициту Тогда
		
		РеквизитыВидПлана = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидПлана,"ЗаполнятьНазначениеВТЧ, ЗаполнятьСоглашение, ЗаполнятьСклад, ЗаполнятьПартнера");
		
		Запрос = Новый Запрос();
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаТовары.Номенклатура,
		|	ТаблицаТовары.Характеристика,
		|	ТаблицаТовары.Склад,
		|	ТаблицаТовары.Назначение,
		|	ТаблицаТовары.ДатаСборкиРазборки,
		|	ТаблицаТовары.Количество
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&ТаблицаТовары КАК ТаблицаТовары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.Склад,
		|	Товары.Назначение,
		|	СУММА(Товары.Количество) КАК Количество
		|ИЗ
		|	Товары КАК Товары
		|ГДЕ
		|	Товары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|	И (Не &ЗаполнятьСклад ИЛИ Товары.Склад <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
		|
		|СГРУППИРОВАТЬ ПО
		|	Товары.Номенклатура,
		|	Товары.Склад,
		|	Товары.Назначение,
		|	Товары.ДатаСборкиРазборки,
		|	Товары.Характеристика
		|
		|ИМЕЮЩИЕ
		|	СУММА(Товары.Количество) = 0";
		Запрос.УстановитьПараметр("ТаблицаТовары", Товары.Выгрузить());
		Запрос.УстановитьПараметр("ЗаполнятьСклад", РеквизитыВидПлана.ЗаполнятьСклад);
		РеквизитыВидПлана = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидПлана,"ЗаполнятьНазначениеВТЧ, ЗаполнятьСклад, ЗаполнятьСкладВТЧ");
		
		ТаблицаОшибок = Запрос.Выполнить().Выгрузить();
		
		КлючДанных = ОбщегоНазначенияУТ.КлючДанныхДляСообщенияПользователю(ЭтотОбъект);
		СтруктураПоиска = Новый Структура("Номенклатура,Характеристика,Назначение,Склад");
		
		Для Каждого СтрокаОшибки Из ТаблицаОшибок Цикл
			
			ТекстСообщения = НСтр("ru='Для строк плана с номенклатурой %Номенклатура%%Характеристика%%Назначение%%Склад% не запланировано количество ни в одном периоде планирования.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номенклатура%", СтрокаОшибки.Номенклатура);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Характеристика%", ?(ЗначениеЗаполнено(СтрокаОшибки.Характеристика), НСтр("ru=', характеристикой'") + " " + СтрокаОшибки.Характеристика, ""));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Назначение%", ?(ЗначениеЗаполнено(СтрокаОшибки.Назначение)
				И РеквизитыВидПлана.ЗаполнятьНазначениеВТЧ,
				НСтр("ru=', назначением'") + " " + СтрокаОшибки.Назначение, ""));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Склад%", ?(ЗначениеЗаполнено(СтрокаОшибки.Склад)
				И РеквизитыВидПлана.ЗаполнятьСкладВТЧ , НСтр("ru=', складом'") + " " + СтрокаОшибки.Склад, ""));
			
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаОшибки);
			СтрокаПоиска = Товары.НайтиСтроки(СтруктураПоиска)[0];
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаПоиска.НомерСтроки, "КоличествоУпаковок");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,КлючДанных, Поле,"Объект",Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Не КроссТаблица
		И ЗначениеЗаполнено(ВидПлана) Тогда
		
		ПоляГруппировки = "Номенклатура,Характеристика,Назначение,Упаковка,Склад,ВариантКомплектации,ДатаСборкиРазборки";
		Планирование.ОбработкаПроверкиДублированияСтрок(Товары, "Товары", ПоляГруппировки, Отказ);
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет реквизиты в документе, значением по умолчанию.
//
Процедура ЗаполнитьДанныеПоУмолчанию()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ВЫБОР
	|		КОГДА Склады.ПометкаУдаления
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|		ИНАЧЕ ДанныеДокумента.Склад
	|	КОНЕЦ КАК Склад,
	|	ВЫБОР
	|		КОГДА СценарииТоварногоПланирования.ПометкаУдаления
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.СценарииТоварногоПланирования.ПустаяСсылка)
	|		ИНАЧЕ ДанныеДокумента.Сценарий
	|	КОНЕЦ КАК Сценарий,
	|	ВЫБОР
	|		КОГДА ВидыПланов.ПометкаУдаления
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыПланов.ПустаяСсылка)
	|		ИНАЧЕ ДанныеДокумента.ВидПлана
	|	КОНЕЦ КАК ВидПлана,
	|	ДанныеДокумента.ЗаполнятьПоФормуле КАК ЗаполнятьПоФормуле,
	|	ДанныеДокумента.КроссТаблица КАК КроссТаблица
	|ИЗ
	|	Документ.ПланСборкиРазборки КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыПланов КАК ВидыПланов
	|		ПО ДанныеДокумента.ВидПлана = ВидыПланов.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СценарииТоварногоПланирования КАК СценарииТоварногоПланирования
	|		ПО ДанныеДокумента.Сценарий = СценарииТоварногоПланирования.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|		ПО ДанныеДокумента.Склад = Склады.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ответственный = &Ответственный
	|	И ДанныеДокумента.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеДокумента.Дата УБЫВ");
	
	Запрос.УстановитьПараметр("Ответственный", Ответственный);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		
	КонецЕсли;
	
	Сценарий = ЗначениеНастроекПовтИсп.ПолучитьСценарийПоУмолчанию(Перечисления.ТипыПланов.ПланСборкиРазборки, Сценарий);
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПланаПоСценариюВидуПлана()
	
	РеквизитыСценария = "Периодичность";
	ПараметрыСценария = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Сценарий, РеквизитыСценария);
	Если НЕ ЗначениеЗаполнено(ВидПлана) Тогда
		ВидПлана = Планирование.ПолучитьВидПланаПоУмолчанию(Перечисления.ТипыПланов.ПланСборкиРазборки, Сценарий);
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыСценария);
	
	Если ЗначениеЗаполнено(ВидПлана) Тогда
		Реквизиты = "ЗаполнятьПланОплат,ЗаполнятьПоФормуле,Замещающий";
		
		ПараметрыВидаПлана = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидПлана, Реквизиты);
		
		СтруктураНастроекВидПлана = Планирование.ПолучитьНастройкиПоУмолчанию(Перечисления.ТипыПланов.ПланСборкиРазборки, ВидПлана);
		Если СтруктураНастроекВидПлана.Свойство("Формула") Тогда
			ПараметрыВидаПлана.Вставить("СтруктураНастроек", СтруктураНастроекВидПлана);
		КонецЕсли;
		Для каждого Элемент Из СтруктураНастроекВидПлана Цикл
			ПараметрыВидаПлана.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыВидаПлана);
		ЭтотОбъект.СтруктураНастроек  = Новый ХранилищеЗначения(СтруктураНастроекВидПлана);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОпределитьВариантКомплектации(СписокСтрокТовары = Неопределено, ТоварыПоДатам = Неопределено) Экспорт

	Если КроссТаблица Тогда
		ТаблицаТовары = ТоварыПоДатам.Выгрузить(СписокСтрокТовары, "Номенклатура,Характеристика, ВариантКомплектации");
	Иначе
		ТаблицаТовары = Товары.Выгрузить(СписокСтрокТовары, "Номенклатура,Характеристика, ВариантКомплектации");
	КонецЕсли;
	
	Если СписокСтрокТовары <> Неопределено Тогда
		СписокСтрокТоварыКОбработке = СписокСтрокТовары;
	Иначе
		Если КроссТаблица Тогда
			СписокСтрокТоварыКОбработке = ТоварыПоДатам;
		Иначе
			СписокСтрокТоварыКОбработке = Товары;
		КонецЕсли;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура        КАК Номенклатура,
	|	ТаблицаТовары.Характеристика      КАК Характеристика,
	|	ВЫРАЗИТЬ(ТаблицаТовары.ВариантКомплектации КАК Справочник.ВариантыКомплектацииНоменклатуры) КАК ВариантКомплектации
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТаблицаТовары.Номенклатура                           КАК Номенклатура,
	|	ТаблицаТовары.Характеристика                         КАК Характеристика,
	|	ВариантыКомплектацииНоменклатуры.Ссылка              КАК ВариантКомплектации,
	|	ВариантыКомплектацииНоменклатуры.Основной            КАК Основной
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВариантыКомплектацииНоменклатуры КАК ВариантыКомплектацииНоменклатуры
	|		ПО ТаблицаТовары.Номенклатура = ВариантыКомплектацииНоменклатуры.Владелец
	|			И ТаблицаТовары.Характеристика = ВариантыКомплектацииНоменклатуры.Характеристика
	|			И (ТаблицаТовары.ВариантКомплектации = ВариантыКомплектацииНоменклатуры.Ссылка
	|				ИЛИ ТаблицаТовары.ВариантКомплектации = ЗНАЧЕНИЕ(Справочник.ВариантыКомплектацииНоменклатуры.ПустаяСсылка)
	|				ИЛИ ТаблицаТовары.ВариантКомплектации.Владелец <> ТаблицаТовары.Номенклатура)
	|			И (НЕ ВариантыКомплектацииНоменклатуры.ПометкаУдаления)";
	
	Запрос.УстановитьПараметр("ТаблицаТовары", ТаблицаТовары);
	
	ТаблицаВариантыКомплектации = Запрос.Выполнить().Выгрузить();
	ТаблицаВариантыКомплектации.Индексы.Добавить("Номенклатура,Характеристика");
	
	ЗаполняемыеРеквизиты = "ВариантКомплектации,УпаковкаКомплектация,КоличествоКомплектация,КоличествоУпаковокКомплектация";
	
	Для каждого СтрокаТовар Из СписокСтрокТоварыКОбработке Цикл
		СтруктураПоиска = Новый Структура("Номенклатура,Характеристика", СтрокаТовар.Номенклатура, СтрокаТовар.Характеристика);
  		СписокВариантовКомплектации = ТаблицаВариантыКомплектации.НайтиСтроки(СтруктураПоиска);
		ВариантыКомплектации = Новый Массив;
		Для каждого СтрокаВариантКомплектации Из СписокВариантовКомплектации Цикл
			Если СтрокаВариантКомплектации.Основной Тогда
				ВариантыКомплектации.Очистить();
				ВариантыКомплектации.Добавить(СтрокаВариантКомплектации);
				Прервать;
			Иначе
				ВариантыКомплектации.Добавить(СтрокаВариантКомплектации);
			КонецЕсли;
		КонецЦикла;
		
		Если ВариантыКомплектации.Количество() = 1 Тогда
			// Вариант комплектации должен быть основным или единственным
			СтрокаТовар.ВариантКомплектации = ВариантыКомплектации[0].ВариантКомплектации;
		Иначе
			СтрокаТовар.ВариантКомплектации = Справочники.ВариантыКомплектацииНоменклатуры.ПустаяСсылка();
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
