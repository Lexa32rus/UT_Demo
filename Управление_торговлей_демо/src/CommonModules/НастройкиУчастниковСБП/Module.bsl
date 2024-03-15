///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ИнтеграцияСПлатежнымиСистемами".
// ОбщийМодуль.НастройкиУчастниковСБП.
//
// Серверные процедуры и функции настроек выполнения обмена с Системой быстрых платежей.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область БанкОткрытие

// См. СервисИнтеграцииССБП.ИдентификаторТорговойТочки.
//
Функция ИдентификаторТорговойТочкиБанкОткрытие(ПараметрыАутентификации) Экспорт
	
	Возврат ИдентификаторТорговойТочкиПоУмолчанию(ПараметрыАутентификации);
	
КонецФункции

// См. СервисИнтеграцииССБП.НастройкиАутентификации.
//
Процедура НастройкиАутентификацииБанкОткрытие(Реквизиты, Подсказка) Экспорт
	
	Реквизиты.Добавить(
		ИнтеграцияСПлатежнымиСистемамиСлужебный.НовыйОписаниеРеквизита(
			"ИдентификаторМерчанта",
			ОбщегоНазначения.ОписаниеТипаСтрока(100),
			НСтр("ru = 'Merchant Id'"),
			Истина,
			Ложь,
			ПодсказкаПоляИдентификаторМерчантаПоУмолчанию()));
	Реквизиты.Добавить(
		ИнтеграцияСПлатежнымиСистемамиСлужебный.НовыйОписаниеРеквизита(
			"Логин",
			ОбщегоНазначения.ОписаниеТипаСтрока(100),
			НСтр("ru = 'Логин'"),
			Истина));
	Реквизиты.Добавить(
		ИнтеграцияСПлатежнымиСистемамиСлужебный.НовыйОписаниеРеквизита(
			"Пароль",
			ОбщегоНазначения.ОписаниеТипаСтрока(100),
			НСтр("ru = 'Пароль'"),
			Истина,
			Истина));
	Подсказка = НСтр("ru = 'Для подключения к Системе быстрых платежей заполните"
		+ " настройки или отправьте <a href=""%1"">заявку на подключение</a> в Банк ""Открытие"".'");
	
КонецПроцедуры

// См. СервисИнтеграцииССБП.ДанныеАутентификацииВПлатежнойСистеме.
//
Функция ДанныеАутентификацииЗапросБанкОткрытие(
		ДанныеАутентификации,
		ТорговаяТочка,
		ПлатежнаяСистема,
		ТребуетсяОбновление) Экспорт
	
	// Данные токена должны быть удалены из ИБ
	// в принудительном порядке, для получения
	// обновленной информации.
	Если ТребуетсяОбновление Тогда
		
		ДанныеАутентификации.expiresDate = Неопределено;
		ДанныеАутентификации.tokenType   = Неопределено;
		ДанныеАутентификации.expiresDate = Неопределено;
		
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
			ТорговаяТочка,
			ДанныеАутентификации);
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	Возврат СервисИнтеграцииССБП.ЗаголовокАутентификацииПоДаннымАутентификации(
		ПлатежнаяСистема,
		ДанныеАутентификации,
		Неопределено,
		ТорговаяТочка);
	
КонецФункции

// См. СервисИнтеграцииССБП.СохранитьНастройкиАутентификации.
//
Процедура СохранитьНастройкиАутентификацииБанкОткрытие(Интеграция, ПараметрыАутентификации) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Если данные не менялись пользователем, перед заполнением
	// необходимо восстановить значения из ИБ.
	Если ПараметрыАутентификации.Получить("Пароль") = ИнтеграцияСПлатежнымиСистемамиСлужебный.СтрокаСекретныхДанныхПоУмолчанию() Тогда
		Данные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
			Интеграция);
		ПараметрыАутентификации.Вставить("Пароль", Данные.password);
	КонецЕсли;
	
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
		Интеграция,
		ПреобразоватьНастройкиАутентификацииБанкОткрытие(
			ПараметрыАутентификации));
	
КонецПроцедуры

// См. СервисИнтеграцииССБП.ДанныеАутентификацииВПлатежнойСистеме.
//
Процедура ДанныеАутентификацииНастройкиБанкОткрытие(Данные, Результат) Экспорт
	
	// При переходе в Фреш или в АРМ данные из безопасного хранилища не мигрируют.
	// Пользователь должен самостоятельно заполнить информацию в настройках.
	Если ЗначениеЗаполнено(Данные) Тогда
		Результат.Вставить("Логин", Данные.login);
		Результат.Вставить("Пароль", ИнтеграцияСПлатежнымиСистемамиСлужебный.СтрокаСекретныхДанныхПоУмолчанию()); // Забивание данных *.
		Результат.Вставить("ИдентификаторМерчанта", Данные.merchantId);
	Иначе
		Результат.Вставить("Логин", "");
		Результат.Вставить("Пароль", "");
		Результат.Вставить("ИдентификаторМерчанта", "");
	КонецЕсли;
	
КонецПроцедуры

// См. СервисИнтеграцииССБП.ПреобразоватьНастройкиАутентификации.
//
Функция ПреобразоватьНастройкиАутентификацииБанкОткрытие(ПараметрыАутентификации) Экспорт
	
	ДанныеАутентификации = Новый Структура;
	ДанныеАутентификации.Вставить("login",       ПараметрыАутентификации.Получить("Логин"));
	ДанныеАутентификации.Вставить("password",    ПараметрыАутентификации.Получить("Пароль"));
	ДанныеАутентификации.Вставить("merchantId",  ПараметрыАутентификации.Получить("ИдентификаторМерчанта"));
	ДанныеАутентификации.Вставить("accessToken", Неопределено);
	ДанныеАутентификации.Вставить("tokenType",   Неопределено);
	ДанныеАутентификации.Вставить("expiresDate", Неопределено);
	
	Возврат ДанныеАутентификации;
	
КонецФункции 

// Определяет идентификатор участника СБП.
//
// Возвращаемое значение:
//  Строка - идентификатор Банка Открытие.
//
Функция ИдентификаторБанкОткрытие() Экспорт
	
	Возврат "Otkrytie";
	
КонецФункции

#КонецОбласти

#Область СКББанк

// См. СервисИнтеграцииССБП.ИдентификаторТорговойТочки.
//
Функция ИдентификаторТорговойТочкиСКБ(ПараметрыАутентификации) Экспорт
	
	Возврат ИдентификаторТорговойТочкиПоУмолчанию(ПараметрыАутентификации);
	
КонецФункции

// См. СервисИнтеграцииССБП.НастройкиАутентификации.
//
Процедура НастройкиАутентификацииСКББанк(Реквизиты, Подсказка) Экспорт
	
	Реквизиты.Добавить(
		ИнтеграцияСПлатежнымиСистемамиСлужебный.НовыйОписаниеРеквизита(
			"ИдентификаторМерчанта",
			ОбщегоНазначения.ОписаниеТипаСтрока(100),
			НСтр("ru = 'Merchant Id'"),
			Истина,
			Ложь,
			ПодсказкаПоляИдентификаторМерчантаПоУмолчанию()));
	Реквизиты.Добавить(
		ИнтеграцияСПлатежнымиСистемамиСлужебный.НовыйОписаниеРеквизита(
			"Логин",
			ОбщегоНазначения.ОписаниеТипаСтрока(100),
			НСтр("ru = 'Логин'"),
			Истина));
	Реквизиты.Добавить(
		ИнтеграцияСПлатежнымиСистемамиСлужебный.НовыйОписаниеРеквизита(
			"Пароль",
			ОбщегоНазначения.ОписаниеТипаСтрока(100),
			НСтр("ru = 'Пароль'"),
			Истина,
			Истина));
	Подсказка = НСтр("ru = 'Для подключения к Системе быстрых платежей заполните"
		+ " настройки или отправьте <a href=""%1"">заявку на подключение</a> в Филиал ""Дело"" ПАО ""СКБ-банк"".'");
	
КонецПроцедуры

// См. СервисИнтеграцииССБП.ДанныеАутентификацииВПлатежнойСистеме.
//
Функция ДанныеАутентификацииЗапросСКББанк(
		ДанныеАутентификации,
		ТорговаяТочка,
		ПлатежнаяСистема) Экспорт
	
	Возврат СервисИнтеграцииССБП.ЗаголовокАутентификацииПоДаннымАутентификации(
		ПлатежнаяСистема,
		ДанныеАутентификации,
		Неопределено,
		ТорговаяТочка);
	
КонецФункции

// См. СервисИнтеграцииССБП.СохранитьНастройкиАутентификации.
//
Процедура СохранитьНастройкиАутентификацииСКББанк(Интеграция, ПараметрыАутентификации) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Если данные не менялись пользователем, перед заполнением
	// необходимо восстановить значения из ИБ.
	Если ПараметрыАутентификации.Получить("Пароль") = ИнтеграцияСПлатежнымиСистемамиСлужебный.СтрокаСекретныхДанныхПоУмолчанию() Тогда
		Данные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
			Интеграция);
		ПараметрыАутентификации.Вставить("Пароль", Данные.password);
	КонецЕсли;
	
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
		Интеграция,
		ПреобразоватьНастройкиАутентификацииСКББанк(
			ПараметрыАутентификации));
	
КонецПроцедуры

// См. СервисИнтеграцииССБП.ДанныеАутентификацииВПлатежнойСистеме.
//
Процедура ДанныеАутентификацииНастройкиСКББанк(Данные, Результат) Экспорт
	
	// При переходе в Фреш или в АРМ данные из безопасного хранилища не мигрируют.
	// Пользователь должен самостоятельно заполнить информацию в настройках.
	Если ЗначениеЗаполнено(Данные) Тогда
		Результат.Вставить("Логин", Данные.login);
		Результат.Вставить("Пароль", ИнтеграцияСПлатежнымиСистемамиСлужебный.СтрокаСекретныхДанныхПоУмолчанию()); // Забивание данных *.
		Результат.Вставить("ИдентификаторМерчанта", Данные.merchantId);
	Иначе
		Результат.Вставить("Логин",                 "");
		Результат.Вставить("Пароль",                "");
		Результат.Вставить("ИдентификаторМерчанта", "");
	КонецЕсли;
	
КонецПроцедуры

// См. СервисИнтеграцииССБП.ПреобразоватьНастройкиАутентификации.
//
Функция ПреобразоватьНастройкиАутентификацииСКББанк(ПараметрыАутентификации) Экспорт
	
	ДанныеАутентификации = Новый Структура;
	ДанныеАутентификации.Вставить("login", ПараметрыАутентификации.Получить("Логин"));
	ДанныеАутентификации.Вставить("password", ПараметрыАутентификации.Получить("Пароль"));
	ДанныеАутентификации.Вставить("merchantId", ПараметрыАутентификации.Получить("ИдентификаторМерчанта"));
	
	Возврат ДанныеАутентификации;
	
КонецФункции 

// Определяет идентификатор участника СБП.
//
// Возвращаемое значение:
//  Строка - идентификатор Банка Открытие.
//
Функция ИдентификаторСКББанк() Экспорт
	
	Возврат "SKB";
	
КонецФункции

#КонецОбласти

#Область Webmoney

// См. СервисИнтеграцииССБП.ИдентификаторТорговойТочки.
//
Функция ИдентификаторТорговойТочкиWebmoney(ПараметрыАутентификации) Экспорт
	
	Возврат ИдентификаторТорговойТочкиПоУмолчанию(ПараметрыАутентификации);
	
КонецФункции

// См. СервисИнтеграцииССБП.НастройкиАутентификации.
//
Процедура НастройкиАутентификацииWebmoney(Реквизиты, Подсказка) Экспорт
	
	Реквизиты.Добавить(
		ИнтеграцияСПлатежнымиСистемамиСлужебный.НовыйОписаниеРеквизита(
			"ИдентификаторМерчанта",
			ОбщегоНазначения.ОписаниеТипаСтрока(100),
			НСтр("ru = 'Merchant Id'"),
			Истина,
			Ложь,
			ПодсказкаПоляИдентификаторМерчантаПоУмолчанию()));
	Реквизиты.Добавить(
		ИнтеграцияСПлатежнымиСистемамиСлужебный.НовыйОписаниеРеквизита(
			"Токен",
			ОбщегоНазначения.ОписаниеТипаСтрока(150),
			НСтр("ru = 'Токен'"),
			Истина,
			Истина));
	Подсказка = НСтр("ru = 'Для подключения к Системе быстрых платежей заполните"
		+ " настройки или отправьте <a href=""%1"">заявку на подключение</a> в WebMoney (Банк ККБ).'");
	
КонецПроцедуры

// См. СервисИнтеграцииССБП.ДанныеАутентификацииВПлатежнойСистеме.
//
Функция ДанныеАутентификацииЗапросWebmoney(
		ДанныеАутентификации,
		ТорговаяТочка,
		ПлатежнаяСистема) Экспорт
	
	Возврат СервисИнтеграцииССБП.ЗаголовокАутентификацииПоДаннымАутентификации(
		ПлатежнаяСистема,
		ДанныеАутентификации,
		Неопределено,
		ТорговаяТочка);
	
КонецФункции

// См. СервисИнтеграцииССБП.СохранитьНастройкиАутентификации.
//
Процедура СохранитьНастройкиАутентификацииWebmoney(Интеграция, ПараметрыАутентификации) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Если данные не менялись пользователем, перед заполнением
	// необходимо восстановить значения из ИБ.
	Если ПараметрыАутентификации.Получить("Токен") = ИнтеграцияСПлатежнымиСистемамиСлужебный.СтрокаСекретныхДанныхПоУмолчанию() Тогда
		Данные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
			Интеграция);
		ПараметрыАутентификации.Вставить("Токен", Данные.token);
	КонецЕсли;
	
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
		Интеграция,
		ПреобразоватьНастройкиАутентификацииWebmoney(
			ПараметрыАутентификации));
	
КонецПроцедуры

// См. СервисИнтеграцииССБП.ДанныеАутентификацииВПлатежнойСистеме.
//
Процедура ДанныеАутентификацииНастройкиWebmoney(Данные, Результат) Экспорт
	
	// При переходе в Фреш или в АРМ данные из безопасного хранилища не мигрируют.
	// Пользователь должен самостоятельно заполнить информацию в настройках.
	Если ЗначениеЗаполнено(Данные) Тогда
		Результат.Вставить("Токен", ИнтеграцияСПлатежнымиСистемамиСлужебный.СтрокаСекретныхДанныхПоУмолчанию()); // Забивание данных *.
		Результат.Вставить("ИдентификаторМерчанта", Данные.merchantId);
	Иначе
		Результат.Вставить("Токен",                "");
		Результат.Вставить("ИдентификаторМерчанта", "");
	КонецЕсли;
	
КонецПроцедуры

// См. СервисИнтеграцииССБП.ПреобразоватьНастройкиАутентификации.
//
Функция ПреобразоватьНастройкиАутентификацииWebmoney(ПараметрыАутентификации) Экспорт
	
	ДанныеАутентификации = Новый Структура;
	ДанныеАутентификации.Вставить("token", ПараметрыАутентификации.Получить("Токен"));
	ДанныеАутентификации.Вставить("merchantId", ПараметрыАутентификации.Получить("ИдентификаторМерчанта"));
	
	Возврат ДанныеАутентификации;
	
КонецФункции 

// Определяет идентификатор участника СБП.
//
// Возвращаемое значение:
//  Строка - идентификатор Банка Открытие.
//
Функция ИдентификаторWebmoney() Экспорт
	
	Возврат "Webmoney";
	
КонецФункции

#КонецОбласти

#Область PayMaster

// См. СервисИнтеграцииССБП.ИдентификаторТорговойТочки.
//
Функция ИдентификаторТорговойТочкиPayMaster(ПараметрыАутентификации) Экспорт
	
	Возврат ИдентификаторТорговойТочкиПоУмолчанию(ПараметрыАутентификации);
	
КонецФункции

// См. СервисИнтеграцииССБП.НастройкиАутентификации.
//
Процедура НастройкиАутентификацииPayMaster(Реквизиты, Подсказка) Экспорт
	
	Реквизиты.Добавить(
		ИнтеграцияСПлатежнымиСистемамиСлужебный.НовыйОписаниеРеквизита(
			"ИдентификаторМерчанта",
			ОбщегоНазначения.ОписаниеТипаСтрока(100),
			НСтр("ru = 'Merchant Id'"),
			Истина,
			Ложь,
			ПодсказкаПоляИдентификаторМерчантаПоУмолчанию()));
	Реквизиты.Добавить(
		ИнтеграцияСПлатежнымиСистемамиСлужебный.НовыйОписаниеРеквизита(
			"Токен",
			ОбщегоНазначения.ОписаниеТипаСтрока(150),
			НСтр("ru = 'Токен'"),
			Истина,
			Истина));
	Подсказка = НСтр("ru = 'Для подключения к Системе быстрых платежей заполните"
		+ " настройки или отправьте <a href=""%1"">заявку на подключение</a> в PayMaster (ООО ""Пэймастер"").'");
	
КонецПроцедуры

// См. СервисИнтеграцииССБП.ДанныеАутентификацииВПлатежнойСистеме.
//
Функция ДанныеАутентификацииЗапросPayMaster(
		ДанныеАутентификации,
		ТорговаяТочка,
		ПлатежнаяСистема) Экспорт
	
	Возврат СервисИнтеграцииССБП.ЗаголовокАутентификацииПоДаннымАутентификации(
		ПлатежнаяСистема,
		ДанныеАутентификации,
		Неопределено,
		ТорговаяТочка);
	
КонецФункции

// См. СервисИнтеграцииССБП.СохранитьНастройкиАутентификации.
//
Процедура СохранитьНастройкиАутентификацииPayMaster(Интеграция, ПараметрыАутентификации) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Если данные не менялись пользователем, перед заполнением
	// необходимо восстановить значения из ИБ.
	Если ПараметрыАутентификации.Получить("Токен") = ИнтеграцияСПлатежнымиСистемамиСлужебный.СтрокаСекретныхДанныхПоУмолчанию() Тогда
		Данные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
			Интеграция);
		ПараметрыАутентификации.Вставить("Токен", Данные.token);
	КонецЕсли;
	
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
		Интеграция,
		ПреобразоватьНастройкиАутентификацииWebmoney(
			ПараметрыАутентификации));
	
КонецПроцедуры

// См. СервисИнтеграцииССБП.ДанныеАутентификацииВПлатежнойСистеме.
//
Процедура ДанныеАутентификацииНастройкиPayMaster(Данные, Результат) Экспорт
	
	// При переходе в Фреш или в АРМ данные из безопасного хранилища не мигрируют.
	// Пользователь должен самостоятельно заполнить информацию в настройках.
	Если ЗначениеЗаполнено(Данные) Тогда
		Результат.Вставить("Токен", ИнтеграцияСПлатежнымиСистемамиСлужебный.СтрокаСекретныхДанныхПоУмолчанию()); // Забивание данных *.
		Результат.Вставить("ИдентификаторМерчанта", Данные.merchantId);
	Иначе
		Результат.Вставить("Токен",                "");
		Результат.Вставить("ИдентификаторМерчанта", "");
	КонецЕсли;
	
КонецПроцедуры

// См. СервисИнтеграцииССБП.ПреобразоватьНастройкиАутентификации.
//
Функция ПреобразоватьНастройкиАутентификацииPayMaster(ПараметрыАутентификации) Экспорт
	
	ДанныеАутентификации = Новый Структура;
	ДанныеАутентификации.Вставить("token", ПараметрыАутентификации.Получить("Токен"));
	ДанныеАутентификации.Вставить("merchantId", ПараметрыАутентификации.Получить("ИдентификаторМерчанта"));
	
	Возврат ДанныеАутентификации;
	
КонецФункции 

// Определяет идентификатор участника СБП.
//
// Возвращаемое значение:
//  Строка - идентификатор Банка Открытие.
//
Функция ИдентификаторPayMaster() Экспорт
	
	Возврат "PayMaster";
	
КонецФункции

#КонецОбласти

#Область Промсвязьбанк

// См. СервисИнтеграцииССБП.ИдентификаторТорговойТочки.
//
Функция ИдентификаторТорговойТочкиПромсвязьбанк(ПараметрыАутентификации) Экспорт
	
	Возврат ИдентификаторТорговойТочкиПоУмолчанию(ПараметрыАутентификации);
	
КонецФункции

// См. СервисИнтеграцииССБП.НастройкиАутентификации.
//
Процедура НастройкиАутентификацииПромсвязьбанк(Реквизиты, Подсказка) Экспорт
	
	Реквизиты.Добавить(
		ИнтеграцияСПлатежнымиСистемамиСлужебный.НовыйОписаниеРеквизита(
			"ИдентификаторМерчанта",
			ОбщегоНазначения.ОписаниеТипаСтрока(100),
			НСтр("ru = 'Merchant Id'"),
			Истина,
			Ложь,
			ПодсказкаПоляИдентификаторМерчантаПоУмолчанию()));
	Реквизиты.Добавить(
		ИнтеграцияСПлатежнымиСистемамиСлужебный.НовыйОписаниеРеквизита(
			"Ключ",
			ОбщегоНазначения.ОписаниеТипаСтрока(100),
			НСтр("ru = 'Ключ'"),
			Истина,
			Истина));
	
	Подсказка = НСтр("ru = 'Для подключения к Системе быстрых платежей заполните"
		+ " настройки или отправьте <a href=""%1"">заявку на подключение</a> в Промсвязьбанка.'");
	
КонецПроцедуры

// См. СервисИнтеграцииССБП.ДанныеАутентификацииВПлатежнойСистеме.
//
Функция ДанныеАутентификацииЗапросПромсвязьбанк(
		ДанныеАутентификации,
		ТорговаяТочка,
		ПлатежнаяСистема,
		ДанныеДляПодписи) Экспорт
	
	Возврат СервисИнтеграцииССБП.ЗаголовокАутентификацииПоДаннымАутентификации(
		ПлатежнаяСистема,
		ДанныеАутентификации,
		ДанныеДляПодписи,
		ТорговаяТочка);
	
КонецФункции

// См. СервисИнтеграцииССБП.СохранитьНастройкиАутентификации.
//
Процедура СохранитьНастройкиАутентификацииПромсвязьбанк(Интеграция, ПараметрыАутентификации) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Если данные не менялись пользователем, перед заполнением
	// необходимо восстановить значения из ИБ. В противном
	// случае требуется дополнительное преобразование ключа
	// перед сохранением.
	Если ПараметрыАутентификации.Получить("Ключ") = ИнтеграцияСПлатежнымиСистемамиСлужебный.СтрокаСекретныхДанныхПоУмолчанию() Тогда
		Данные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
			Интеграция);
		ПараметрыАутентификации.Вставить("Ключ", Данные.key);
	Иначе
		ПараметрыАутентификации.Вставить("Ключ",
				ПолучитьДвоичныеДанныеИзHexСтроки(
					ПараметрыАутентификации.Получить("Ключ")));
	КонецЕсли;
	
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
		Интеграция,
		ПреобразоватьНастройкиАутентификацииПромсвязьбанкСохранение(
			ПараметрыАутентификации));
	
КонецПроцедуры

// См. СервисИнтеграцииССБП.ДанныеАутентификацииВПлатежнойСистеме.
//
Процедура ДанныеАутентификацииНастройкиПромсвязьбанк(Данные, Результат) Экспорт
	
	// При переходе в Фреш или в АРМ данные из безопасного хранилища не мигрируют.
	// Пользователь должен самостоятельно заполнить информацию в настройках.
	Если ЗначениеЗаполнено(Данные) Тогда
		Результат.Вставить("Ключ",                  ИнтеграцияСПлатежнымиСистемамиСлужебный.СтрокаСекретныхДанныхПоУмолчанию()); // Забивание данных *.
		Результат.Вставить("ИдентификаторМерчанта", Данные.merchantId);
	Иначе
		Результат.Вставить("Ключ",                  "");
		Результат.Вставить("ИдентификаторМерчанта", "");
	КонецЕсли;
	
КонецПроцедуры

// Выполняет преобразование параметров аутентификации в формат
// хранения и выполнения запросов к сервису.
//
// Параметры:
//  ПараметрыАутентификации - Соответствие - настройки аутентификации платежной системы.
//
// Возвращаемое значение:
//  Структура - преобразованные настройки аутентификации.
//
Функция ПреобразоватьНастройкиАутентификацииПромсвязьбанкСохранение(ПараметрыАутентификации)
	
	ДанныеАутентификации = Новый Структура;
	ДанныеАутентификации.Вставить("key", ПараметрыАутентификации.Получить("Ключ"));
	ДанныеАутентификации.Вставить("merchantId", ПараметрыАутентификации.Получить("ИдентификаторМерчанта"));
	
	Возврат ДанныеАутентификации;
	
КонецФункции

// См. СервисИнтеграцииССБП.ПреобразоватьНастройкиАутентификации.
//
Функция ПреобразоватьНастройкиАутентификацииПромсвязьбанк(ПараметрыАутентификации) Экспорт
	
	ДанныеАутентификации = Новый Структура;
	ДанныеАутентификации.Вставить("key", ПолучитьДвоичныеДанныеИзHexСтроки(ПараметрыАутентификации.Получить("Ключ")));
	ДанныеАутентификации.Вставить("merchantId", ПараметрыАутентификации.Получить("ИдентификаторМерчанта"));
	ДанныеАутентификации.Вставить("ХешФункция", ХешФункция.SHA256);
	
	Возврат ДанныеАутентификации;
	
КонецФункции

// Определяет идентификатор участника СБП.
//
// Возвращаемое значение:
//  Строка - идентификатор Банка Открытие.
//
Функция ИдентификаторПромсвязьбанк() Экспорт
	
	Возврат "PSB";
	
КонецФункции

#КонецОбласти

#Область ПрочиеСлужебныеПроцедурыФункции

// См. СервисИнтеграцииССБП.ИдентификаторТорговойТочки.
//
Функция ИдентификаторТорговойТочкиПоУмолчанию(ПараметрыАутентификации)
	
	Возврат ПараметрыАутентификации.Получить("ИдентификаторМерчанта");
	
КонецФункции

// Формирует представление подсказки для поля настроек Merchant Id.
//
// Возвращаемое значение:
//  Строка - подсказка поля формы.
//
Функция ПодсказкаПоляИдентификаторМерчантаПоУмолчанию()
	
	Возврат НСтр("ru = 'Идентификатор торговой точки в Системе быстрых платежей.'");
	
КонецФункции

#КонецОбласти

#КонецОбласти
