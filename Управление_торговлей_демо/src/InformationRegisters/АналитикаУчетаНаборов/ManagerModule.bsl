#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция получает элемент справочника - ключ аналитики учета номенклатураы.
//
// Параметры:
//	ПараметрыАналитики - ВыборкаДанных, Структура - Выборка или Структура с полями "Номенклатура, Характеристика".
//
// Возвращаемое значение:
//	СправочникСсылка.КлючиАналитикиУчетаНоменклатуры - Созданный элемент справочника.
//
Функция ЗначениеКлючаАналитики(ПараметрыАналитики) Экспорт

	НаборЗаписей = ПолучитьНаборЗаписей(ПараметрыАналитики);
	
	Если НаборЗаписей <> Неопределено Тогда
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0
			И Не ЗначениеЗаполнено(НаборЗаписей[0].КлючАналитики) Тогда
			НаборЗаписей.Очистить();
			НаборЗаписей.Записать();
		КонецЕсли;

		Если НаборЗаписей.Количество() > 0
			И ЗначениеЗаполнено(НаборЗаписей[0].КлючАналитики) Тогда
			Результат = НаборЗаписей[0].КлючАналитики;
		Иначе
			Результат = СоздатьКлючАналитики(ПараметрыАналитики);
		КонецЕсли;

		Возврат Результат;
	КонецЕсли;

КонецФункции

// Функция получает элемент справочника - ключ аналитики учета.
//
// Параметры:
//	ПараметрыАналитики - ВыборкаДанных, Структура - ВыборкаДанных или Структура с полями "Номенклатура, Характеристика, Склад".
//	ЗаписьПриОбновленииИБ - Булево - 
//
// Возвращаемое значение:
//	СправочникСсылка.КлючиАналитикиУчетаНоменклатуры - Созданный элемент справочника.
//
Функция СоздатьКлючАналитики(ПараметрыАналитики, ЗаписьПриОбновленииИБ = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеЗаполнено(ПараметрыАналитики.НоменклатураНабора) Тогда
		НаборЗаписей = ПолучитьНаборЗаписей(ПараметрыАналитики);
		
		Если НаборЗаписей <> Неопределено Тогда // Создание нового ключа аналитики.
			
			НачатьТранзакцию();
			Попытка
				
				СтрокаНабора = НаборЗаписей[0];
				
				СправочникОбъект = Справочники.КлючиАналитикиУчетаНаборов.СоздатьЭлемент();
				СправочникОбъект.Наименование = ПолучитьПолноеНаименованиеКлючаАналитики(СтрокаНабора);
				ЗаполнитьЗначенияСвойств(СправочникОбъект, ПараметрыАналитики, "НоменклатураНабора, ХарактеристикаНабора");
				Если ЗаписьПриОбновленииИБ Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
				Иначе
					СправочникОбъект.Записать();
				КонецЕсли;
				
				Результат = СправочникОбъект.Ссылка;
				
				СтрокаНабора.КлючАналитики = Результат;
				Если ЗаписьПриОбновленииИБ Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей, Ложь, Истина);
				Иначе
					НаборЗаписей.Записать(Ложь);
				КонецЕсли;
				
				ЗафиксироватьТранзакцию();
			Исключение
				// во время инициализации ключа, данный ключ уже был создан в ИБ другим сеансом.
				НаборЗаписей.Прочитать();
				Если НаборЗаписей.Количество() = 0 Тогда // запись не создана из-за ошибки заполнения полей.
					ОтменитьТранзакцию();
					ВызватьИсключение;
				Иначе
					ОтменитьТранзакцию();
					Результат = НаборЗаписей[0].КлючАналитики;
				КонецЕсли;
			КонецПопытки;
			
			Возврат Результат;
			
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Заполняет поле АналитикаУчетаНаборов в коллекции, содержащей номенклатуру, характеристику.
//
// Параметры:
//
//	Коллекция - ТабличнаяЧасть
//
Процедура ЗаполнитьВКоллекции(Коллекция) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИменаПолей = ИменаПолейКоллекцииПоУмолчанию();
	Если Истина Тогда ТекстЗапроса = "
		|ВЫБРАТЬ
		|	Коллекция.НомерСтроки - 1 КАК Индекс,
		|	&ПолеАналитика КАК АналитикаУчетаНаборов,
		|	&ПолеНоменклатура КАК НоменклатураНабора,
		|	&ПолеХарактеристика КАК ХарактеристикаНабора
		|
		|ПОМЕСТИТЬ Коллекция
		|ИЗ &Коллекция КАК Коллекция;
		|
		|ВЫБРАТЬ
		|	Коллекция.Индекс,
		|	Аналитика.КлючАналитики КАК АналитикаУчетаНаборов,
		|	Коллекция.НоменклатураНабора,
		|	Коллекция.ХарактеристикаНабора
		|ИЗ
		|	Коллекция КАК Коллекция
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СН
		|		ПО СН.Ссылка = Коллекция.НоменклатураНабора
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНаборов КАК Аналитика
		|		ПО Аналитика.НоменклатураНабора = Коллекция.НоменклатураНабора И Аналитика.ХарактеристикаНабора = Коллекция.ХарактеристикаНабора
		|ГДЕ
		|	Аналитика.КлючАналитики ЕСТЬ NULL ИЛИ Аналитика.КлючАналитики <> Коллекция.АналитикаУчетаНаборов
		|";
	КонецЕсли;
	
	// заменим в тексте запроса подставляемые поля из структуры ИменаПолей
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеАналитика", "Коллекция." + ИменаПолей.АналитикаУчетаНаборов);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеНоменклатура", "Коллекция." + ИменаПолей.НоменклатураНабора);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеХарактеристика", "Коллекция." + ИменаПолей.ХарактеристикаНабора);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Коллекция", Коллекция);

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не ЗначениеЗаполнено(Выборка.АналитикаУчетаНаборов) Тогда
			КлючАналитики = ЗначениеКлючаАналитики(Выборка)
		Иначе
			КлючАналитики = Выборка.АналитикаУчетаНаборов;
		КонецЕсли;
		Коллекция[Выборка.Индекс][ИменаПолей.АналитикаУчетаНаборов] = КлючАналитики;
	КонецЦикла;
КонецПроцедуры

// Возвращает структуру полей выбора информации из коллекции для формирования аналитики учета номенклатуры.
//
// Возвращаемое значение:
//	Структура - содержит реальные имена полей коллекции для получения и формирования аналитики.
//		содержит две секции, если значение ключа Неопределено, то имя поля должно браться из имени ключа.
//		секция идентификации {Номенклатура, Характеристика, АналитикаУчетаНоменклатуры, СтатусУказанияСерий, Серия},
//			все ключи заданы.
//		секция места учета {Произвольный, [Товар, ВозвратнаяТара, Услуга, ] Работа}, ключи Произвольный и Работа заданы.
//			реквизиты этой секции должны содержать имена колонок коллекции, откуда надо брать значения для одноименных
//			типов номенклатуры.
//
Функция ИменаПолейКоллекцииПоУмолчанию() Экспорт
	Возврат Новый Структура(
		"НоменклатураНабора, ХарактеристикаНабора, АналитикаУчетаНаборов",
		"НоменклатураНабора", "ХарактеристикаНабора", "АналитикаУчетаНаборов");
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Функция ПолучитьНаборЗаписей(ПараметрыАналитики)
	
	// В параметрах аналитики могут быть не все свойства
	СтруктураАналитики = Новый Структура("НоменклатураНабора, ХарактеристикаНабора");
	ЗаполнитьЗначенияСвойств(СтруктураАналитики, ПараметрыАналитики);
	Если НЕ ЗначениеЗаполнено(СтруктураАналитики.НоменклатураНабора)
	 И НЕ ЗначениеЗаполнено(СтруктураАналитики.ХарактеристикаНабора) Тогда
		Возврат Неопределено
	Иначе
		НаборЗаписей = РегистрыСведений.АналитикаУчетаНаборов.СоздатьНаборЗаписей();
		
		Для Каждого КлючЗначение Из СтруктураАналитики Цикл
			ЭлементОтбора = НаборЗаписей.Отбор[КлючЗначение.Ключ]; // ЭлементОтбора
			ЭлементОтбора.Установить(КлючЗначение.Значение);
		КонецЦикла;
		
		НоваяСтрока = НаборЗаписей.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураАналитики, "НоменклатураНабора, ХарактеристикаНабора");
		Возврат НаборЗаписей;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПолноеНаименованиеКлючаАналитики(МенеджерЗаписи)

	// Получим наименование ключа аналитики на основном языке с учетом мультиязычности справочников
	Возврат СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(МенеджерЗаписи.НоменклатураНабора, "Наименование")) + "; " 
		+ ?(ЗначениеЗаполнено(МенеджерЗаписи.ХарактеристикаНабора), СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(МенеджерЗаписи.ХарактеристикаНабора, "Наименование")), "");

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли