#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("ТипТокенаАвторизации");
	Поля.Добавить("Организация");
	Поля.Добавить("ПроизводственныйОбъект");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Данные.ТипТокенаАвторизации) Тогда
		ТипТокенаАвторизации = СтрШаблон(НСтр("ru = 'токены %1'"), Строка(Данные.ТипТокенаАвторизации));
	Иначе
		ТипТокенаАвторизации = НСтр("ru = '<все токены>'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Данные.Организация) Тогда
		Организация = Строка(Данные.Организация);
	Иначе
		Организация = НСтр("ru = '<для всех организаций>'");
	КонецЕсли;
	
	Если Данные.ТипТокенаАвторизации = Перечисления.ТипыТокеновАвторизации.ИСМП Тогда
		
		Представление = СтрШаблон("%1, %2",
			ТипТокенаАвторизации, Организация);
		
	Иначе
		
		Если ЗначениеЗаполнено(Данные.ПроизводственныйОбъект) Тогда
			ПроизводственныйОбъект = Строка(Данные.ПроизводственныйОбъект);
		Иначе
			ПроизводственныйОбъект = НСтр("ru = '<для всех производственных объектов>'");
		КонецЕсли;
		
		Представление = СтрШаблон("%1, %2, %3",
			ТипТокенаАвторизации, Организация, ПроизводственныйОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Получает настройки текущего пользователя для актуализации токенов авторизации.
// 
// Параметры:
//  ДляПросмотра - Булево - определяет для чего нужно получить настройки:
//                          для просмотра списка токенов или для актуализации токенов.
// 
// Возвращаемое значение:
//  Массив из Структура:
//   * ТипТокенаАвторизации   - ПеречислениеСсылка.ТипыТокеновАвторизации - тип токена авторизации.
//   * Организация            - ОпределяемыйТип.Организация - организация.
//   * ПроизводственныйОбъект - ОпределяемыйТип.ПроизводственныйОбъектИС - производственный объект.
//   * ВремяОповещения        - Число - время в секундах, за которое необходимо оповестить ответственного об окончании срока действия токена.
//
Функция НастройкиОтветственногоЗаАктуализациюТокеновАвторизации(ДляПросмотра) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Настройки = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ответственный", Пользователи.АвторизованныйПользователь());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ТипыТокеновАвторизации.ИСМП) КАК ТипТокенаАвторизации,
	|	Ответственные.Ссылка.Организация КАК Организация,
	|	Null КАК ПроизводственныйОбъект,
	|	МАКСИМУМ(Ответственные.ВремяВСекундах) КАК ВремяВСекундах
	|ИЗ
	|	Справочник.ОтветственныеЗаАктуализациюТокеновАвторизацииИСМП.Ответственные КАК Ответственные
	|ГДЕ
	|	Ответственные.Ответственный = &Ответственный
	|	И НЕ Ответственные.Ссылка.ПометкаУдаления
	|	И (Ответственные.Ссылка.ТипТокенаАвторизации = ЗНАЧЕНИЕ(Перечисление.ТипыТокеновАвторизации.ПустаяСсылка)
	|	ИЛИ Ответственные.Ссылка.ТипТокенаАвторизации = ЗНАЧЕНИЕ(Перечисление.ТипыТокеновАвторизации.ИСМП))
	|СГРУППИРОВАТЬ ПО
	|	ЗНАЧЕНИЕ(Перечисление.ТипыТокеновАвторизации.ИСМП),
	|	Ответственные.Ссылка.Организация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ТипыТокеновАвторизации.СУЗ) КАК ТипТокенаАвторизации,
	|	Ответственные.Ссылка.Организация КАК Организация,
	|	Ответственные.Ссылка.ПроизводственныйОбъект КАК ПроизводственныйОбъект,
	|	МАКСИМУМ(Ответственные.ВремяВСекундах) КАК ВремяВСекундах
	|ИЗ
	|	Справочник.ОтветственныеЗаАктуализациюТокеновАвторизацииИСМП.Ответственные КАК Ответственные
	|ГДЕ
	|	Ответственные.Ответственный = &Ответственный
	|	И НЕ Ответственные.Ссылка.ПометкаУдаления
	|	И (Ответственные.Ссылка.ТипТокенаАвторизации = ЗНАЧЕНИЕ(Перечисление.ТипыТокеновАвторизации.ПустаяСсылка)
	|	ИЛИ Ответственные.Ссылка.ТипТокенаАвторизации = ЗНАЧЕНИЕ(Перечисление.ТипыТокеновАвторизации.СУЗ))
	|СГРУППИРОВАТЬ ПО
	|	ЗНАЧЕНИЕ(Перечисление.ТипыТокеновАвторизации.СУЗ),
	|	Ответственные.Ссылка.Организация,
	|	Ответственные.Ссылка.ПроизводственныйОбъект";
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	
	Если Не ДляПросмотра
		И ТаблицаДанных.Количество() = 0 Тогда
		Возврат Настройки;
	КонецЕсли;
	
	СертификатыДляПодписанияНаСервере = ИнтерфейсАвторизацииИСМПСлужебный.СертификатыДляПодписанияНаСервере();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	// токены ИСМП
	Таблица = ТаблицаДанных.Скопировать(
		Новый Структура("ТипТокенаАвторизации", Перечисления.ТипыТокеновАвторизации.ИСМП),
		"Организация, ВремяВСекундах");
	
	ВремяОповещенияПоВсемОрганизациям = 0;
	
	ОрганизацииПоОтветственному = Новый Соответствие;
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.Организация) Тогда
			ОрганизацииПоОтветственному.Вставить(СтрокаТаблицы.Организация, СтрокаТаблицы.ВремяВСекундах);
		Иначе
			ВремяОповещенияПоВсемОрганизациям = СтрокаТаблицы.ВремяВСекундах;
		КонецЕсли;
		
	КонецЦикла;
	
	ДоступныеОрганизации = ИнтеграцияИСМП.ДоступныеОрганизации();
	
	Для Каждого ДоступнаяОрганизация Из ДоступныеОрганизации Цикл
		
		Организация = ДоступнаяОрганизация.Значение;
		Если СертификатыДляПодписанияНаСервере <> Неопределено
			И СертификатыДляПодписанияНаСервере.Сертификаты.Найти(Организация, "Организация") <> Неопределено Тогда
			ВремяОповещения = 0;
		ИначеЕсли ОрганизацииПоОтветственному[Организация] = Неопределено Тогда
			ВремяОповещения = ВремяОповещенияПоВсемОрганизациям;
		Иначе
			ВремяОповещения = ОрганизацииПоОтветственному[Организация];
		КонецЕсли;
		
		Настройка = Новый Структура;
		Настройка.Вставить("ТипТокенаАвторизации",   Перечисления.ТипыТокеновАвторизации.ИСМП);
		Настройка.Вставить("Организация",            Организация);
		Настройка.Вставить("ПроизводственныйОбъект", Неопределено);
		Настройка.Вставить("ВремяОповещения",        ВремяОповещения);
		Настройки.Добавить(Настройка);
		
	КонецЦикла;
	
	// токены СУЗ
	Таблица = ТаблицаДанных.Скопировать(
		Новый Структура("ТипТокенаАвторизации", Перечисления.ТипыТокеновАвторизации.СУЗ),
		"Организация, ПроизводственныйОбъект, ВремяВСекундах");
	
	ПустаяОрганизация = ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("Организация");
	Если ПустаяОрганизация = Неопределено Тогда
		ПустаяОрганизация = "<ПоВсем>";
	КонецЕсли;
	
	ПустойПроизводственныйОбъект = ИнтеграцияИС.ПустоеЗначениеОпределяемогоТипа("ПроизводственныйОбъектИС");
	Если ПустойПроизводственныйОбъект = Неопределено Тогда
		ПустойПроизводственныйОбъект = "<ПоВсем>";
	КонецЕсли;
	
	ОрганизацииПоОтветственному = Новый Соответствие;
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.Организация) Тогда
			Организация = СтрокаТаблицы.Организация;
		Иначе
			Организация = ПустаяОрганизация;
		КонецЕсли;
		
		ОрганизацияПоОтветственному = ОрганизацииПоОтветственному[Организация];
		Если ОрганизацияПоОтветственному = Неопределено Тогда
			ОрганизацииПоОтветственному.Вставить(Организация, Новый Соответствие);
			ОрганизацияПоОтветственному = ОрганизацииПоОтветственному[Организация];
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.ПроизводственныйОбъект) Тогда
			ПроизводственныйОбъект = СтрокаТаблицы.ПроизводственныйОбъект;
		Иначе
			ПроизводственныйОбъект = ПустойПроизводственныйОбъект;
		КонецЕсли;
		
		ОрганизацияПоОтветственному.Вставить(ПроизводственныйОбъект, СтрокаТаблицы.ВремяВСекундах);
		
	КонецЦикла;
	
	ДоступныеНастройкиСУЗ = РегистрыСведений.НастройкиОбменаСУЗ.ДоступныеНастройкиОбменаСУЗ(ДоступныеОрганизации);
	
	Для Каждого ДоступнаяНастройкаСУЗ Из ДоступныеНастройкиСУЗ Цикл
		
		Организация = ДоступнаяНастройкаСУЗ.Организация;
		ПроизводственныйОбъект = ДоступнаяНастройкаСУЗ.ПроизводственныйОбъект;
		Если СертификатыДляПодписанияНаСервере <> Неопределено
			И СертификатыДляПодписанияНаСервере.Сертификаты.Найти(Организация, "Организация") <> Неопределено Тогда
			ВремяОповещения = 0;
		Иначе
			ОрганизацияПоОтветственному = ОрганизацииПоОтветственному[Организация];
			Если ОрганизацияПоОтветственному = Неопределено Тогда
				ОрганизацияПоОтветственному = ОрганизацииПоОтветственному[ПустаяОрганизация];
			КонецЕсли;
			Если ОрганизацияПоОтветственному = Неопределено Тогда
				ВремяОповещения = 0;
			Иначе
				ВремяОповещения = ОрганизацияПоОтветственному[ПроизводственныйОбъект];
				Если ВремяОповещения = Неопределено Тогда
					ВремяОповещения = ОрганизацияПоОтветственному[ПустойПроизводственныйОбъект];
				КонецЕсли;
				Если ВремяОповещения = Неопределено Тогда
					ВремяОповещения = 0;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Настройка = Новый Структура;
		Настройка.Вставить("ТипТокенаАвторизации",   Перечисления.ТипыТокеновАвторизации.СУЗ);
		Настройка.Вставить("Организация",            Организация);
		Настройка.Вставить("ПроизводственныйОбъект", ПроизводственныйОбъект);
		Настройка.Вставить("ВремяОповещения",        ВремяОповещения);
		Настройки.Добавить(Настройка);
		
	КонецЦикла;
	
	Возврат Настройки;
	
КонецФункции

#КонецОбласти

#КонецЕсли
