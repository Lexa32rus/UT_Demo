//@strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание HTTP соединения.
// 
// Параметры:
// 	URL - Строка
// 	Таймаут - Число
// Возвращаемое значение:
// 	Структура:
// 	 * HTTPСоединение - HTTPСоединение
// 	 * СтруктураURI - см. ОбщегоНазначенияКлиентСервер.СтруктураURI
Функция ОписаниеHTTPСоединения(URL, Таймаут) Экспорт
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
 
	Если СтруктураURI.Схема = "https" Тогда
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	Иначе
		ЗащищенноеСоединение = Неопределено;
	КонецЕсли;
	
	Прокси = ПолучениеФайловИзИнтернета.ПолучитьПрокси(СтруктураURI.Схема);
	
	Хост = СтруктураURI.Хост;
	Если ЗначениеЗаполнено(СтруктураURI.ПутьНаСервере) Тогда
		Хост = СтрШаблон("%1/%2", СтруктураURI.Хост, СтруктураURI.ПутьНаСервере);
	КонецЕсли;
	
	HTTPСоединение = Новый HTTPСоединение(Хост, СтруктураURI.Порт, СтруктураURI.Логин, СтруктураURI.Пароль, Прокси,
		Таймаут, ЗащищенноеСоединение);
		
	ОписаниеСоединения = Новый Структура;
	ОписаниеСоединения.Вставить("HTTPСоединение", HTTPСоединение);
	ОписаниеСоединения.Вставить("СтруктураURI", СтруктураURI);
	
	Возврат ОписаниеСоединения;
	
КонецФункции

// Отправляет данные на указанный адрес для обработки с использованием указанного HTTP-метода.
// 
// Параметры:
// 	ОписаниеСоединения - см. ОписаниеHTTPСоединения
// 	HTTPЗапрос - HTTPЗапрос
// 	Метод - Строка - см. HTTPМетоды
// 	ВидОперации - Строка - используется для уточнения ошибки при выполнении метода.
// 	КонтекстДиагностики - см. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
// 	ПараметрыВызова - см. НовыеПараметрыВызоваHTTPМетода
// Возвращаемое значение:
// 	Структура - Описание:
// * Успех - Булево - если Истина - вызов метода выполнен успешно.
// * Ответ -  HTTPОтвет, Неопределено - объект, полученный в результате вызова метода.
//            Принимает значение Неопределено, если Успех - Ложь.
Функция ВызватьHTTPМетод(ОписаниеСоединения, HTTPЗапрос, Метод, ВидОперации, КонтекстДиагностики = Неопределено,
	ПараметрыВызова = Неопределено) Экспорт
	
	Если ПараметрыВызова = Неопределено Тогда
		ПараметрыВызова = НовыеПараметрыВызоваHTTPМетода();
	КонецЕсли;
	
	РезультатВызова = Новый Структура;
	РезультатВызова.Вставить("Успех", Ложь);
	РезультатВызова.Вставить("Ответ", Неопределено);
	
	Попытка
		Ответ = ОписаниеСоединения.HTTPСоединение.ВызватьHTTPМетод(Метод, HTTPЗапрос);
		РезультатВызова.Ответ = Ответ;
		РезультатВызова.Успех = Истина;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибкиВыполненияHTTPЗапроса(ОписаниеСоединения,
			HTTPЗапрос, Ответ, Метод, ПараметрыВызова.МаскируемыеПараметрыПриЛогировании, ИнформацияОбОшибке);
		ВидОшибки = ИнтернетСоединениеБЭДКлиентСервер.ВидОшибкиИнтернетСоединение();
		Ошибка = ОбработкаНеисправностейБЭД.НоваяОшибка(ВидОперации,
			ВидОшибки, ПодробноеПредставлениеОшибки, КраткоеПредставлениеОшибки);
		ОбработкаНеисправностейБЭД.ДобавитьОшибку(КонтекстДиагностики, Ошибка,
			ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ИнтернетСоединение);
	КонецПопытки;
	
	Возврат РезультатВызова;
	
КонецФункции

// Возвращает параметры вызова HTTPМетода.
// Для использования в ИнтернетСоединениеБЭД.ВызватьHTTPМетод.
// 
// Возвращаемое значение:
//  Структура:
// * МаскируемыеПараметрыПриЛогировании - Массив из Строка - содержит имена параметров, которые будут замаскированы при
// записи ошибки в журнал регистрации с целью скрытия секретных данных, напр. /API/SendRequest?login=1c&password=***.
Функция НовыеПараметрыВызоваHTTPМетода() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("МаскируемыеПараметрыПриЛогировании", Новый Массив);
	
	Возврат Параметры;
	
КонецФункции

// Возвращает HTTP методы.
// 
// Возвращаемое значение:
// 	Структура:
// * CONNECT - Строка
// * COPY - Строка
// * DELETE - Строка
// * GET - Строка
// * HEAD - Строка
// * LOCK - Строка
// * MERGE - Строка
// * MKCOL - Строка
// * MOVE - Строка
// * OPTIONS - Строка
// * PATCH - Строка
// * POST - Строка
// * PROPFIND - Строка
// * PROPPATCH - Строка
// * PUT - Строка
// * TRACE - Строка
// * UNLOCK - Строка
Функция HTTPМетоды() Экспорт
	
	Методы = Новый Структура;
	Методы.Вставить("CONNECT", "CONNECT");
	Методы.Вставить("COPY", "COPY");
	Методы.Вставить("DELETE", "DELETE");
	Методы.Вставить("GET", "GET");
	Методы.Вставить("HEAD", "HEAD");
	Методы.Вставить("LOCK", "LOCK");
	Методы.Вставить("MERGE", "MERGE");
	Методы.Вставить("MKCOL", "MKCOL");
	Методы.Вставить("MOVE", "MOVE");
	Методы.Вставить("OPTIONS", "OPTIONS");
	Методы.Вставить("PATCH", "PATCH");
	Методы.Вставить("POST", "POST");
	Методы.Вставить("PROPFIND", "PROPFIND");
	Методы.Вставить("PROPPATCH", "PROPPATCH");
	Методы.Вставить("PUT", "PUT");
	Методы.Вставить("TRACE", "TRACE");
	Методы.Вставить("UNLOCK", "UNLOCK");
	
	Возврат Методы;
	
КонецФункции

// Возвращает таймаут для использования в объекте HTTPСоединение.
// 
// Параметры:
// 	Размер - Число - размер файла
// Возвращаемое значение:
// 	Число
Функция ТаймаутПоРазмеруФайла(Размер) Экспорт
	
	БайтВМегабайте = 1048576;
	
	Если Размер > БайтВМегабайте Тогда
		Если Размер < БайтВМегабайте * 10 Тогда
			КоличествоСекунд = 10 * 128;
		Иначе 
			КоличествоСекунд = Окр(Размер / БайтВМегабайте * 128);
		КонецЕсли;
		Возврат ?(КоличествоСекунд > 43200, 43200, КоличествоСекунд);
	КонецЕсли;
	
	Возврат 128;
	
КонецФункции

// Функция формирует прокси по настройкам прокси и протоколу.
//
// Параметры:
//  Протокол - Строка - протокол для которого устанавливаются параметры прокси сервера, например http, https, ftp.
//
// Возвращаемое значение:
//  ИнтернетПрокси - описание параметров прокси-серверов.
// 
Функция СформироватьПрокси(Протокол) Экспорт
	
	// НастройкаПроксиСервера - Соответствие:
	//  ИспользоватьПрокси - использовать ли прокси-сервер;
	//  НеИспользоватьПроксиДляЛокальныхАдресов - использовать ли прокси-сервер для локальных адресов;
	//  ИспользоватьСистемныеНастройки - использовать ли системные настройки прокси-сервера;
	//  Сервер       - адрес прокси-сервера;
	//  Порт         - порт прокси-сервера;
	//  Пользователь - имя пользователя для авторизации на прокси-сервере;
	//  Пароль       - пароль пользователя.
	НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
	Если НастройкаПроксиСервера <> Неопределено Тогда
		ИспользоватьПрокси = НастройкаПроксиСервера.Получить("ИспользоватьПрокси");
		ИспользоватьСистемныеНастройки = НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки");
		Если ИспользоватьПрокси Тогда
			Если ИспользоватьСистемныеНастройки Тогда
				// Системные настройки прокси-сервера.
				Прокси = Новый ИнтернетПрокси(Истина);
			Иначе
				// Ручные настройки прокси-сервера.
				Прокси = Новый ИнтернетПрокси;
				Прокси.Установить(Протокол, НастройкаПроксиСервера["Сервер"], НастройкаПроксиСервера["Порт"],
					НастройкаПроксиСервера["Пользователь"], НастройкаПроксиСервера["Пароль"]);
				Прокси.НеИспользоватьПроксиДляЛокальныхАдресов = НастройкаПроксиСервера["НеИспользоватьПроксиДляЛокальныхАдресов"];
			КонецЕсли;
		Иначе
			// Не использовать прокси-сервер.
			Прокси = Новый ИнтернетПрокси(Ложь);
		КонецЕсли;
	Иначе
		Прокси = Неопределено;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

// Определяет параметры HTTP соединения по URL адресу.
//
// Параметры:
//  АдресСайта - Строка - URL сайта;
//  ЗащищенноеСоединение - Булево - возвращает Истина, если требуется шифрование;
//  Адрес - Строка - адрес сайта без протокола;
//  Протокол - Строка - название протокола.
//
Процедура ОпределитьПараметрыСайта(Знач АдресСайта, ЗащищенноеСоединение, Адрес, Протокол) Экспорт
	
	АдресСайта = СокрЛП(АдресСайта);
	
	АдресСайта = СтрЗаменить(АдресСайта, "\", "/");
	АдресСайта = СтрЗаменить(АдресСайта, " ", "");
	
	Если НРег(Лев(АдресСайта, 7)) = "http://" Тогда
		Протокол = "http";
		Адрес = Сред(АдресСайта,8);
		ЗащищенноеСоединение = Неопределено;
	ИначеЕсли НРег(Лев(АдресСайта, 8)) = "https://" Тогда
		Протокол =  "https";
		Адрес = Сред(АдресСайта,9);
		
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	КонецЕсли;
	
КонецПроцедуры

// Получает файл из Интернета по протоколу http(s), либо ftp и сохраняет его во временное хранилище.
// Примечание: После получения файла временное хранилище необходимо самостоятельно очистить
// при помощи метода УдалитьИзВременногоХранилища. Если этого не сделать, то файл будет находиться
// в памяти сервера до конца сеанса.
//
// Параметры:
//   URL                - Строка - url файла в формате [Протокол://]<Сервер>/<Путь к файлу на сервере>.
//   ПараметрыПолучения - Структура - см. ПолучениеФайловИзИнтернетаКлиентСервер.ПараметрыПолученияФайла.
//   ПараметрыЖурналирования - Неопределено - журналирования не требуется
//                           - Структура - Необходимо вести журнал обмена. Содержит поля:
//                               * ОбщийМодуль - ОбщийМодуль - общий модуль, методы которого будут вызываться для сохранения журнала:
//                                   - Перед отправкой данных вызывается ОбщийМодуль.ПриОтправкеДанныхHTTP(URL, HTTPСоединение, HTTPЗапрос, ПараметрыЖурналирования)
//                                   - После получения ответа вызывается: ОбщийМодуль.ПриПолученииДанныхHTTP(HTTPОтвет, ИмяФайла, ПараметрыЖурналирования)
//
// Возвращаемое значение:
//   Структура - Структура со свойствами:
//      * Статус            - Булево - результат получения файла.
//      * Путь   - Строка   - адрес временного хранилища с двоичными данными файла,
//                            ключ используется только если статус Истина.
//      * СообщениеОбОшибке - Строка - сообщение об ошибке, если статус Ложь.
//      * Заголовки         - Соответствие - см. в синтаксис-помощнике описание параметра Заголовки объекта HTTPОтвет.
//      * КодСостояния      - Число - Добавляется при возникновении ошибки.
//                                    См. в синтаксис-помощнике описание параметра КодСостояния объекта HTTPОтвет.
//
Функция СкачатьФайлВоВременноеХранилище(Знач URL, ПараметрыПолучения = Неопределено, ПараметрыЖурналирования = Неопределено) Экспорт
	
	НастройкаСохранения = Новый Соответствие;
	НастройкаСохранения.Вставить("МестоХранения", "ВременноеХранилище");
	
	Возврат СкачатьФайл(URL, ПараметрыПолучения, НастройкаСохранения, ПараметрыЖурналирования);
	
КонецФункции

// Возвращает текст расшифровки кода состояния HTTP
//
// Параметры:
//  КодСостояния - Число - код состояния HTTP
// 
// Возвращаемое значение:
//  Строка - подробное описание кода.
//
Функция РасшифровкаКодаСостоянияHTTP(КодСостояния) Экспорт
	
	Если КодСостояния = 304 Тогда // Not Modified
		Расшифровка = НСтр("ru = 'Нет необходимости повторно передавать запрошенные ресурсы.'");
	ИначеЕсли КодСостояния = 400 Тогда // Bad Request
		Расшифровка = НСтр("ru = 'Запрос не может быть исполнен.'");
	ИначеЕсли КодСостояния = 401 Тогда // Unauthorized
		Расшифровка = НСтр("ru = 'Попытка авторизации на сервере была отклонена.'");
	ИначеЕсли КодСостояния = 402 Тогда // Payment Required
		Расшифровка = НСтр("ru = 'Требуется оплата.'");
	ИначеЕсли КодСостояния = 403 Тогда // Forbidden
		Расшифровка = НСтр("ru = 'К запрашиваемому ресурсу нет доступа.'");
	ИначеЕсли КодСостояния = 404 Тогда // Not Found
		Расшифровка = НСтр("ru = 'Запрашиваемый ресурс не найден на сервере.'");
	ИначеЕсли КодСостояния = 405 Тогда // Method Not Allowed
		Расшифровка = НСтр("ru = 'Метод запроса не поддерживается сервером.'");
	ИначеЕсли КодСостояния = 406 Тогда // Not Acceptable
		Расшифровка = НСтр("ru = 'Запрошенный формат данных не поддерживается сервером.'");
	ИначеЕсли КодСостояния = 407 Тогда // Proxy Authentication Required
		Расшифровка = НСтр("ru = 'Ошибка аутентификации на прокси-сервере'");
	ИначеЕсли КодСостояния = 408 Тогда // Request Timeout
		Расшифровка = НСтр("ru = 'Время ожидания сервером передачи от клиента истекло.'");
	ИначеЕсли КодСостояния = 409 Тогда // Conflict
		Расшифровка = НСтр("ru = 'Запрос не может быть выполнен из-за конфликтного обращения к ресурсу.'");
	ИначеЕсли КодСостояния = 410 Тогда // Gone
		Расшифровка = НСтр("ru = 'Ресурс на сервере был перемешен.'");
	ИначеЕсли КодСостояния = 411 Тогда // Length Required
		Расшифровка = НСтр("ru = 'Сервер требует указание ""Content-length."" в заголовке запроса.'");
	ИначеЕсли КодСостояния = 412 Тогда // Precondition Failed
		Расшифровка = НСтр("ru = 'Запрос не применим к ресурсу'");
	ИначеЕсли КодСостояния = 413 Тогда // Request Entity Too Large
		Расшифровка = НСтр("ru = 'Сервер отказывается обработать, слишком большой объем передаваемых данных.'");
	ИначеЕсли КодСостояния = 414 Тогда // Request-URL Too Long
		Расшифровка = НСтр("ru = 'Сервер отказывается обработать, слишком длинный URL.'");
	ИначеЕсли КодСостояния = 415 Тогда // Unsupported Media-Type
		Расшифровка = НСтр("ru = 'Сервер заметил, что часть запроса была сделана в неподдерживаемом формат'");
	ИначеЕсли КодСостояния = 416 Тогда // Requested Range Not Satisfiable
		Расшифровка = НСтр("ru = 'Часть запрашиваемого ресурса не может быть предоставлена'");
	ИначеЕсли КодСостояния = 417 Тогда // Expectation Failed
		Расшифровка = НСтр("ru = 'Сервер не может предоставить ответ на указанный запрос.'");
	ИначеЕсли КодСостояния = 429 Тогда // Too Many Requests
		Расшифровка = НСтр("ru = 'Слишком много запросов за короткое время.'");
	ИначеЕсли КодСостояния = 500 Тогда // Internal Server Error
		Расшифровка = НСтр("ru = 'Внутренняя ошибка сервера.'");
	ИначеЕсли КодСостояния = 501 Тогда // Not Implemented
		Расшифровка = НСтр("ru = 'Сервер не поддерживает метод запроса.'");
	ИначеЕсли КодСостояния = 502 Тогда // Bad Gateway
		Расшифровка = НСтр("ru = 'Сервер, выступая в роли шлюза или прокси-сервера, 
		                         |получил недействительное ответное сообщение от вышестоящего сервера.'");
	ИначеЕсли КодСостояния = 503 Тогда // Server Unavailable
		Расшифровка = НСтр("ru = 'Сервер временно не доступен.'");
	ИначеЕсли КодСостояния = 504 Тогда // Gateway Timeout
		Расшифровка = НСтр("ru = 'Сервер в роли шлюза или прокси-сервера 
		                         |не дождался ответа от вышестоящего сервера для завершения текущего запроса.'");
	ИначеЕсли КодСостояния = 505 Тогда // HTTP Version Not Supported
		Расшифровка = НСтр("ru = 'Сервер не поддерживает указанную в запросе версию протокола HTTP'");
	ИначеЕсли КодСостояния = 506 Тогда // Variant Also Negotiates
		Расшифровка = НСтр("ru = 'Сервер настроен некорректно, и не способен обработать запрос.'");
	ИначеЕсли КодСостояния = 507 Тогда // Insufficient Storage
		Расшифровка = НСтр("ru = 'На сервере недостаточно места для выполнения запроса.'");
	ИначеЕсли КодСостояния = 509 Тогда // Bandwidth Limit Exceeded
		Расшифровка = НСтр("ru = 'Сервер превысил отведенное ограничение на потребление трафика.'");
	ИначеЕсли КодСостояния = 510 Тогда // Not Extended
		Расшифровка = НСтр("ru = 'Сервер требует больше информации о совершаемом запросе.'");
	ИначеЕсли КодСостояния = 511 Тогда // Network Authentication Required
		Расшифровка = НСтр("ru = 'Требуется авторизация на сервере.'");
	Иначе 
		Расшифровка = НСтр("ru = '<Неизвестный код состояния>.'");
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '[%1] %2'"), 
		КодСостояния, 
		Расшифровка);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает подробное представление ошибки выполнения HTTP-запроса.
// 
// Параметры:
// 	ОписаниеСоединения - см. ОписаниеHTTPСоединения
// 	HTTPЗапрос - HTTPЗапрос
// 	HTTPОтвет - HTTPОтвет
// 	Метод - Строка - см. HTTPМетоды
// 	МаскируемыеПараметры - Массив из Строка
// 	ИнформацияОбОшибке - ИнформацияОбОшибке
// Возвращаемое значение:
// 	Строка
Функция ПодробноеПредставлениеОшибкиВыполненияHTTPЗапроса(ОписаниеСоединения, HTTPЗапрос, HTTPОтвет, Метод,
	МаскируемыеПараметры, ИнформацияОбОшибке)
	
	ШаблонОшибки = НСтр("ru = 'Ошибка при выполнении HTTP-запроса:
		|%1
		|Адрес ресурса: %2
		|Метод: %3
		|Ответ: %4'");
	
	Если ТипЗнч(HTTPОтвет) = Тип("HTTPОтвет") Тогда
		Ответ = СтрШаблон("%1
		|%2", HTTPОтвет.КодСостояния, HTTPОтвет.ПолучитьТелоКакСтроку());
	Иначе
		Ответ = "";
	КонецЕсли;
	
	ПодробноеПредставлениеОшибки = СтрШаблон(ШаблонОшибки,
		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке),
		ПолныйАдресИнтернетРесурса(ОписаниеСоединения, HTTPЗапрос, МаскируемыеПараметры),
		Метод,
		Ответ);
	
	Возврат ПодробноеПредставлениеОшибки;
	
КонецФункции

// Возвращает полный адрес интернет-ресурса.
// 
// Параметры:
// 	ОписаниеСоединения - см. ОписаниеHTTPСоединения
// 	HTTPЗапрос - HTTPЗапрос
// 	МаскируемыеПараметры - Массив из Строка
// Возвращаемое значение:
// 	Строка
Функция ПолныйАдресИнтернетРесурса(ОписаниеСоединения, HTTPЗапрос, МаскируемыеПараметры)
	
	СтруктураURI = ОписаниеСоединения.СтруктураURI;
	Соединение = ОписаниеСоединения.HTTPСоединение;
	Схема = ?(Соединение.ЗащищенноеСоединение = Неопределено, "http", "https");
	Порт = Соединение.Порт;
	ПолныйАдрес = СтрШаблон("%1://%2:%3", Схема, СтруктураURI.Хост, Порт);
	Если ЗначениеЗаполнено(СтруктураURI.ПутьНаСервере) Тогда
		ПолныйАдрес = ПолныйАдрес + "/" + СтруктураURI.ПутьНаСервере;
	КонецЕсли;
	Если ЗначениеЗаполнено(HTTPЗапрос.АдресРесурса) Тогда
		ПолныйАдрес = ПолныйАдрес + "/" + ЗамаскироватьПараметрыВАдресе(HTTPЗапрос.АдресРесурса, МаскируемыеПараметры);
	КонецЕсли;
	Возврат ПолныйАдрес;
		
КонецФункции

// Маскирует значения параметров в адресе ресурса.
// 
// Параметры:
//  АдресРесурса - Строка
//  МаскируемыеПараметры - Массив из Строка
// 
// Возвращаемое значение:
//  Строка
Функция ЗамаскироватьПараметрыВАдресе(АдресРесурса, МаскируемыеПараметры)
	
	ЧастиАдреса = СтрРазделить(АдресРесурса, "?", Ложь);
	Если ЧастиАдреса.Количество() < 2 Тогда
		Возврат АдресРесурса;
	КонецЕсли;
	
	СтрокаДоПараметров = ЧастиАдреса[0];
	СтрокаПараметров = ЧастиАдреса[1];
	Параметры = СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(СтрокаПараметров, "&");
	
	ЗамаскированныеПараметры = Новый Массив;
	Для Каждого Параметр Из Параметры Цикл
		Если МаскируемыеПараметры.Найти(Параметр.Ключ) = Неопределено Тогда
			ЗначениеПараметра = Параметр.Значение;
		Иначе
			ЗначениеПараметра = "***";
		КонецЕсли;
		ЗамаскированныеПараметры.Добавить(Параметр.Ключ + "=" + ЗначениеПараметра);
	КонецЦикла;
	
	Возврат СтрокаДоПараметров + "?" + СтрСоединить(ЗамаскированныеПараметры, "&");
	
КонецФункции

Функция ПараметрыПолученияФайла()
	
	ПараметрыПолучения = Новый Структура;
	ПараметрыПолучения.Вставить("ПутьДляСохранения", Неопределено);
	ПараметрыПолучения.Вставить("Пользователь", Неопределено);
	ПараметрыПолучения.Вставить("Пароль", Неопределено);
	ПараметрыПолучения.Вставить("Порт", Неопределено);
	ПараметрыПолучения.Вставить("Таймаут", АвтоматическоеОпределениеТаймаута());
	ПараметрыПолучения.Вставить("ЗащищенноеСоединение", Неопределено);
	ПараметрыПолучения.Вставить("ПассивноеСоединение", Неопределено);
	ПараметрыПолучения.Вставить("Заголовки", Новый Соответствие);
	ПараметрыПолучения.Вставить("ИспользоватьАутентификациюОС", Ложь);
	ПараметрыПолучения.Вставить("УровеньИспользованияЗащищенногоСоединения", Неопределено);
	
	Возврат ПараметрыПолучения;
	
КонецФункции

Функция СкачатьФайл(Знач URL, Знач ПараметрыПолучения, Знач НастройкаСохранения, Знач ПараметрыЖурналирования)
	
	НастройкиПолучения = ПараметрыПолученияФайла();
	Если ПараметрыПолучения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(НастройкиПолучения, ПараметрыПолучения);
	КонецЕсли;
	
	Если НастройкаСохранения.Получить("МестоХранения") <> "ВременноеХранилище" Тогда
		НастройкаСохранения.Вставить("Путь", НастройкиПолучения.ПутьДляСохранения);
	КонецЕсли;
	
	НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
	
	Перенаправления = Новый Массив;
	
	Возврат ПолучитьФайлИзИнтернет(URL, НастройкаСохранения, НастройкиПолучения,
		НастройкаПроксиСервера, Перенаправления, ПараметрыЖурналирования);
	
КонецФункции

Функция АвтоматическоеОпределениеТаймаута()
	
	Возврат -1;
	
КонецФункции

Функция ПолучитьФайлИзИнтернет(Знач URL, Знач НастройкаСохранения, Знач НастройкаСоединения, Знач НастройкиПрокси, Перенаправления, ПараметрыЖурналирования)
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	
	Сервер        = СтруктураURI.Хост;
	ПутьНаСервере = СтруктураURI.ПутьНаСервере;
	Протокол      = СтруктураURI.Схема;
	
	Если ПустаяСтрока(Протокол) Тогда 
		Протокол = "http";
	КонецЕсли;
	
	ЗащищенноеСоединение = НастройкаСоединения.ЗащищенноеСоединение;
	ИмяПользователя      = НастройкаСоединения.Пользователь;
	ПарольПользователя   = НастройкаСоединения.Пароль;
	Порт                 = НастройкаСоединения.Порт;
	Таймаут              = НастройкаСоединения.Таймаут;
	
	Если (Протокол = "https" Или Протокол = "ftps") И ЗащищенноеСоединение = Неопределено Тогда
		ЗащищенноеСоединение = Истина;
	КонецЕсли;
	
	Если ЗащищенноеСоединение = Истина Тогда
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	ИначеЕсли ЗащищенноеСоединение = Ложь Тогда
		ЗащищенноеСоединение = Неопределено;
		// Иначе параметр ЗащищенноеСоединение был задан в явном виде.
	КонецЕсли;
	
	Если Порт = Неопределено Тогда
		Порт = СтруктураURI.Порт;
	КонецЕсли;
	
	Если НастройкиПрокси = Неопределено Тогда 
		Прокси = Неопределено;
	Иначе 
		Прокси = НовыйИнтернетПрокси(НастройкиПрокси, Протокол);
	КонецЕсли;
	
	ПутьСформированАвтоматически = Ложь;
	Если НастройкаСохранения["Путь"] <> Неопределено Тогда
		ПутьДляСохранения = НастройкаСохранения["Путь"];
	Иначе
		ПутьДляСохранения = ПолучитьИмяВременногоФайла(); // АПК:441 Временный файл должен удаляться вызывающим кодом.
		ПутьСформированАвтоматически = Истина; 
	КонецЕсли;
	
	Если Таймаут = Неопределено Тогда 
		Таймаут = АвтоматическоеОпределениеТаймаута();
	КонецЕсли;
	
	Заголовки                    = НастройкаСоединения.Заголовки;
	ИспользоватьАутентификациюОС = НастройкаСоединения.ИспользоватьАутентификациюОС;
	
	Попытка
		
		Если Таймаут = АвтоматическоеОпределениеТаймаута() Тогда
			
			Соединение = Новый HTTPСоединение(
				Сервер, 
				Порт, 
				ИмяПользователя, 
				ПарольПользователя,
				Прокси, 
				7, 
				ЗащищенноеСоединение, 
				ИспользоватьАутентификациюОС);
			
			РазмерФайла = РазмерФайлаHTTP(Соединение, ПутьНаСервере, Заголовки, URL, ПараметрыЖурналирования);
			Таймаут = ТаймаутПоРазмеруФайла(РазмерФайла);
			
		КонецЕсли;
		
		Соединение = Новый HTTPСоединение(
			Сервер, 
			Порт, 
			ИмяПользователя, 
			ПарольПользователя,
			Прокси, 
			Таймаут, 
			ЗащищенноеСоединение, 
			ИспользоватьАутентификациюОС);
		
		Сервер = Соединение.Сервер;
		Порт   = Соединение.Порт;
		
		ЗапросHTTP = Новый HTTPЗапрос(ПутьНаСервере, Заголовки);
		ЗапросHTTP.Заголовки.Вставить("Accept-Charset", "UTF-8");
		ЗапросHTTP.Заголовки.Вставить("X-1C-Request-UID", Строка(Новый УникальныйИдентификатор));
		Если ПараметрыЖурналирования <> Неопределено Тогда
			ПараметрыЖурналирования.ОбщийМодуль.ПриОтправкеДанныхHTTP(
				"GET", URL, Соединение, ЗапросHTTP, ПараметрыЖурналирования);
		КонецЕсли;
		ОтветHTTP = Соединение.Получить(ЗапросHTTP, ПутьДляСохранения);
		
		Если ПараметрыЖурналирования <> Неопределено Тогда
			ПараметрыЖурналирования.ОбщийМодуль.ПриПолученииДанныхHTTP(ОтветHTTP, ПутьДляСохранения, ПараметрыЖурналирования);
		КонецЕсли;
		
	Исключение
		
		РезультатДиагностики = ПолучениеФайловИзИнтернета.ДиагностикаСоединения(URL);
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось установить HTTP-соединение с сервером %1:%2
			           |по причине:
			           |%3
			           |
			           |Результат диагностики:
			           |%4'"),
			Сервер, Формат(Порт, "ЧГ="),
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),
			РезультатДиагностики.ОписаниеОшибки);
		
		ДописатьПредставлениеПеренаправлений(Перенаправления, ТекстОшибки);
			
		Возврат РезультатПолученияФайла(Ложь, ТекстОшибки);
		
	КонецПопытки;
	
	Попытка
		
		Если ОтветHTTP.КодСостояния = 301 // 301 Moved Permanently
			Или ОтветHTTP.КодСостояния = 302 // 302 Found, 302 Moved Temporarily
			Или ОтветHTTP.КодСостояния = 303 // 303 See Other by GET
			Или ОтветHTTP.КодСостояния = 307 // 307 Temporary Redirect
			Или ОтветHTTP.КодСостояния = 308 Тогда // 308 Permanent Redirect
			
			Если Перенаправления.Количество() > 7 Тогда
				
				УдалитьПолученныйФайл(ПутьДляСохранения, ПутьСформированАвтоматически);
				
				ВызватьИсключение 
					НСтр("ru = 'Превышено количество перенаправлений.'");
			Иначе 
				
				НовыйURL = ОтветHTTP.Заголовки["Location"];
				
				Если НовыйURL = Неопределено Тогда 
					
					УдалитьПолученныйФайл(ПутьДляСохранения, ПутьСформированАвтоматически);
					
					ВызватьИсключение 
						НСтр("ru = 'Некорректное перенаправление, отсутствует HTTP-заголовок ответа ""Location"".'");
				КонецЕсли;
				
				НовыйURL = СокрЛП(НовыйURL);
				
				Если ПустаяСтрока(НовыйURL) Тогда
					
					УдалитьПолученныйФайл(ПутьДляСохранения, ПутьСформированАвтоматически);
					
					ВызватьИсключение 
						НСтр("ru = 'Некорректное перенаправление, пустой HTTP-заголовок ответа ""Location"".'");
				КонецЕсли;
				
				Если Перенаправления.Найти(НовыйURL) <> Неопределено Тогда
					
					УдалитьПолученныйФайл(ПутьДляСохранения, ПутьСформированАвтоматически);
					
					ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Циклическое перенаправление.
						           |Попытка перейти на %1 уже выполнялась ранее.'"),
						НовыйURL);
				КонецЕсли;
				
				Перенаправления.Добавить(URL);
				
				Если Не СтрНачинаетсяС(НовыйURL, "http") Тогда
					// <схема>://<хост>:<порт>/<путь>
					НовыйURL = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						"%1://%2:%3/%4", Протокол, Сервер, Формат(Порт, "ЧГ="), НовыйURL);
				КонецЕсли;
				
				УдалитьПолученныйФайл(ПутьДляСохранения, ПутьСформированАвтоматически);
				
				Возврат ПолучитьФайлИзИнтернет(НовыйURL, НастройкаСохранения, НастройкаСоединения,
					НастройкиПрокси, Перенаправления, ПараметрыЖурналирования);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ОтветHTTP.КодСостояния < 200 Или ОтветHTTP.КодСостояния >= 300 Тогда
			
			Если ОтветHTTP.КодСостояния = 304 Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сервер убежден, что с вашего последнего запроса его ответ не изменился:
					           |%1'"),
					РасшифровкаКодаСостоянияHTTP(ОтветHTTP.КодСостояния));
				
				ДописатьТелоОтветаСервера(ПутьДляСохранения, ТекстОшибки);
				
				УдалитьПолученныйФайл(ПутьДляСохранения, ПутьСформированАвтоматически);
				
				ВызватьИсключение ТекстОшибки;
				
			ИначеЕсли ОтветHTTP.КодСостояния < 200
				Или ОтветHTTP.КодСостояния >= 300 И ОтветHTTP.КодСостояния < 400 Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Неподдерживаемый ответ сервера:
					           |%1'"),
					РасшифровкаКодаСостоянияHTTP(ОтветHTTP.КодСостояния));
				
				ДописатьТелоОтветаСервера(ПутьДляСохранения, ТекстОшибки);
				
				УдалитьПолученныйФайл(ПутьДляСохранения, ПутьСформированАвтоматически);
				
				ВызватьИсключение ТекстОшибки;
				
			ИначеЕсли ОтветHTTP.КодСостояния >= 400 И ОтветHTTP.КодСостояния < 500 Тогда 
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при выполнении запроса:
					           |%1'"),
					РасшифровкаКодаСостоянияHTTP(ОтветHTTP.КодСостояния));
				
				ДописатьТелоОтветаСервера(ПутьДляСохранения, ТекстОшибки);
				
				УдалитьПолученныйФайл(ПутьДляСохранения, ПутьСформированАвтоматически);
				
				ВызватьИсключение ТекстОшибки;
				
			Иначе 
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка сервера при обработке запроса к ресурсу:
					           |%1'"),
					РасшифровкаКодаСостоянияHTTP(ОтветHTTP.КодСостояния));
				
				ДописатьТелоОтветаСервера(ПутьДляСохранения, ТекстОшибки);
				
				УдалитьПолученныйФайл(ПутьДляСохранения, ПутьСформированАвтоматически);
				
				ВызватьИсключение ТекстОшибки;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить файл %1 с сервера %2:%3
			           |по причине:
			           |%4'"),
			URL, Сервер, Формат(Порт, "ЧГ="),
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ДописатьПредставлениеПеренаправлений(Перенаправления, ТекстОшибки);
		
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
			           |
			           |Трассировка:
			           |ЗащищенноеСоединение: %2
			           |Таймаут: %3
			           |ИспользоватьАутентификациюОС: %4'"),
			ТекстОшибки,
			Формат(Соединение.Защищенное, "БЛ=Нет; БИ=Да"),
			Формат(Соединение.Таймаут, "ЧГ=0"),
			Формат(Соединение.ИспользоватьАутентификациюОС, "БЛ=Нет; БИ=Да"));
		
		ДописатьЗаголовкиHTTP(ЗапросHTTP, СообщениеОбОшибке);
		ДописатьЗаголовкиHTTP(ОтветHTTP, СообщениеОбОшибке);
		
		ВидОперации = НСтр("ru = 'Получение файла через интернет'");
		ЭлектронноеВзаимодействие.ОбработатьОшибку(ВидОперации, СообщениеОбОшибке, , "ЭлектронноеВзаимодействие");
		
		Возврат РезультатПолученияФайла(Ложь, ТекстОшибки, ОтветHTTP);
		
	КонецПопытки;
	
	// Если сохраняем файл в соответствии с настройкой.
	Если НастройкаСохранения["МестоХранения"] = "ВременноеХранилище" Тогда
		КлючУникальности = Новый УникальныйИдентификатор;
		Адрес = ПоместитьВоВременноеХранилище (Новый ДвоичныеДанные(ПутьДляСохранения), КлючУникальности);
		УдалитьПолученныйФайл(ПутьДляСохранения, ПутьСформированАвтоматически);
		Возврат РезультатПолученияФайла(Истина, Адрес, ОтветHTTP);
	ИначеЕсли НастройкаСохранения["МестоХранения"] = "Клиент"
		Или НастройкаСохранения["МестоХранения"] = "Сервер" Тогда
		// Файл с путем ПутьДляСохранения не удаляем, он является результатом.
		// его должен удалить вызывающий код.		
		Возврат РезультатПолученияФайла(Истина, ПутьДляСохранения, ОтветHTTP);
	Иначе
		УдалитьПолученныйФайл(ПутьДляСохранения, ПутьСформированАвтоматически);
		ВызватьИсключение НСтр("ru = 'Не указано место для сохранения файла.'");
	КонецЕсли;
	
КонецФункции

Процедура ДописатьЗаголовкиHTTP(Объект, ТекстОшибки)
	
	Если ТипЗнч(Объект) = Тип("HTTPЗапрос") Тогда 
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
			           |
			           |HTTP запрос:
			           |Адрес ресурса: %2
			           |Заголовки: %3'"),
			ТекстОшибки,
			Объект.АдресРесурса,
			ПредставлениеЗаголовковHTTP(Объект.Заголовки));
	ИначеЕсли ТипЗнч(Объект) = Тип("HTTPОтвет") Тогда
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
			           |
			           |HTTP ответ:
			           |Код ответа: %2
			           |Заголовки: %3'"),
			ТекстОшибки,
			Объект.КодСостояния,
			ПредставлениеЗаголовковHTTP(Объект.Заголовки));
	КонецЕсли;
	
КонецПроцедуры

Функция ПредставлениеЗаголовковHTTP(Заголовки)
	
	ПредставлениеЗаголовков = "";
	
	Для каждого Заголовок Из Заголовки Цикл 
		ПредставлениеЗаголовков = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
			           |%2: %3'"), 
			ПредставлениеЗаголовков,
			Заголовок.Ключ, Заголовок.Значение);
	КонецЦикла;
		
	Возврат ПредставлениеЗаголовков;
	
КонецФункции

Процедура ДописатьТелоОтветаСервера(ПутьКФайлу, ТекстОшибки)
	
	ТелоОтветаСервера = ТекстИзHTMLИзФайла(ПутьКФайлу);
	
	Если Не ПустаяСтрока(ТелоОтветаСервера) Тогда 
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
			           |
			           |Сообщение, полученное от сервера:
			           |%2'"),
			ТекстОшибки,
			ТелоОтветаСервера);
	КонецЕсли;
	
КонецПроцедуры

Функция ТекстИзHTMLИзФайла(ПутьКФайлу)
	
	ФайлОтвета = Новый ЧтениеТекста(ПутьКФайлу, КодировкаТекста.UTF8);
	ИсходныйТекст = ФайлОтвета.Прочитать(1024 * 15);
	ТекстОшибки = СтроковыеФункцииКлиентСервер.ИзвлечьТекстИзHTML(ИсходныйТекст);
	ФайлОтвета.Закрыть();
	
	Возврат ТекстОшибки;
	
КонецФункции

// Функция, заполняющая структуру по параметрам.
//
// Параметры:
// УспехОперации - булево - успех или неуспех операции.
// СообщениеПуть - строка - 
//
// Возвращаемое значение - структура:
//          поле успех - булево
//          поле путь  - строка.
//
Функция РезультатПолученияФайла(Знач Статус, Знач СообщениеПуть, HTTPОтвет = Неопределено)
	
	Результат = Новый Структура("Статус", Статус);
	
	Если Статус Тогда
		Результат.Вставить("Путь", СообщениеПуть);
	Иначе
		Результат.Вставить("СообщениеОбОшибке", СообщениеПуть);
		Результат.Вставить("КодСостояния", 1);
	КонецЕсли;
	
	Если HTTPОтвет <> Неопределено Тогда
		ЗаголовкиОтвета = HTTPОтвет.Заголовки;
		Если ЗаголовкиОтвета <> Неопределено Тогда
			Результат.Вставить("Заголовки", ЗаголовкиОтвета);
		КонецЕсли;
		
		Результат.Вставить("КодСостояния", HTTPОтвет.КодСостояния);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура УдалитьПолученныйФайл(ПутьКФайлу, ПутьСформированАвтоматически)
	
	Если Не ПутьСформированАвтоматически Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьФайлы(ПутьКФайлу);
	
КонецПроцедуры

Процедура ДописатьПредставлениеПеренаправлений(Перенаправления, ТекстОшибки)
	
	Если Перенаправления.Количество() > 0 Тогда 
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
			           |
			           |Выполненные перенаправления (%2):
			           |%3'"),
			ТекстОшибки,
			Перенаправления.Количество(),
			СтрСоединить(Перенаправления, Символы.ПС));
	КонецЕсли;
	
КонецПроцедуры

// Возвращает прокси по настройкам НастройкаПроксиСервера для заданного протокола Протокол.
//
// Параметры:
//   НастройкаПроксиСервера - Соответствие:
//		ИспользоватьПрокси - использовать ли прокси-сервер.
//		НеИспользоватьПроксиДляЛокальныхАдресов - использовать ли прокси-сервер для локальных адресов.
//		ИспользоватьСистемныеНастройки - использовать ли системные настройки прокси-сервера.
//		Сервер       - адрес прокси-сервера.
//		Порт         - порт прокси-сервера.
//		Пользователь - имя пользователя для авторизации на прокси-сервере.
//		Пароль       - пароль пользователя.
//		ИспользоватьАутентификациюОС - Булево - признак использования аутентификации средствами операционной системы.
//   Протокол - строка - протокол для которого устанавливаются параметры прокси сервера, например "http", "https",
//                       "ftp".
// 
// Возвращаемое значение:
//   ИнтернетПрокси
// 
Функция НовыйИнтернетПрокси(НастройкаПроксиСервера, Протокол)
	
	Если НастройкаПроксиСервера = Неопределено Тогда
		// Системные установки прокси-сервера.
		Возврат Неопределено;
	КонецЕсли;
	
	ИспользоватьПрокси = НастройкаПроксиСервера.Получить("ИспользоватьПрокси");
	Если Не ИспользоватьПрокси Тогда
		// Не использовать прокси-сервер.
		Возврат Новый ИнтернетПрокси(Ложь);
	КонецЕсли;
	
	ИспользоватьСистемныеНастройки = НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки");
	Если ИспользоватьСистемныеНастройки Тогда
		// Системные настройки прокси-сервера.
		Возврат Новый ИнтернетПрокси(Истина);
	КонецЕсли;
	
	// Настройки прокси-сервера, заданные вручную.
	Прокси = Новый ИнтернетПрокси;
	
	// Определение адреса и порта прокси-сервера.
	ДополнительныеНастройки = НастройкаПроксиСервера.Получить("ДополнительныеНастройкиПрокси");
	ПроксиПоПротоколу = Неопределено;
	Если ТипЗнч(ДополнительныеНастройки) = Тип("Соответствие") Тогда
		ПроксиПоПротоколу = ДополнительныеНастройки.Получить(Протокол);
	КонецЕсли;
	
	ИспользоватьАутентификациюОС = НастройкаПроксиСервера.Получить("ИспользоватьАутентификациюОС");
	ИспользоватьАутентификациюОС = ?(ИспользоватьАутентификациюОС = Истина, Истина, Ложь);
	
	Если ТипЗнч(ПроксиПоПротоколу) = Тип("Структура") Тогда
		Прокси.Установить(Протокол, ПроксиПоПротоколу.Адрес, ПроксиПоПротоколу.Порт,
			НастройкаПроксиСервера["Пользователь"], НастройкаПроксиСервера["Пароль"], ИспользоватьАутентификациюОС);
	Иначе
		Прокси.Установить(Протокол, НастройкаПроксиСервера["Сервер"], НастройкаПроксиСервера["Порт"], 
			НастройкаПроксиСервера["Пользователь"], НастройкаПроксиСервера["Пароль"], ИспользоватьАутентификациюОС);
	КонецЕсли;
	
	Прокси.НеИспользоватьПроксиДляЛокальныхАдресов = НастройкаПроксиСервера["НеИспользоватьПроксиДляЛокальныхАдресов"];
	
	АдресаИсключений = НастройкаПроксиСервера.Получить("НеИспользоватьПроксиДляАдресов");
	Если ТипЗнч(АдресаИсключений) = Тип("Массив") Тогда
		Для каждого АдресИсключения Из АдресаИсключений Цикл
			Прокси.НеИспользоватьПроксиДляАдресов.Добавить(АдресИсключения);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

Функция РазмерФайлаHTTP(
	СоединениеHTTP,
	Знач ПутьНаСервере,
	Знач Заголовки=Неопределено,
	URL=Неопределено,
	ПараметрыЖурналирования=Неопределено)
	
	ЗапросHTTP = Новый HTTPЗапрос(ПутьНаСервере, Заголовки);
	Если ПараметрыЖурналирования <> Неопределено Тогда
		ПараметрыЖурналирования.ОбщийМодуль.ПриОтправкеДанныхHTTP(
			"HEAD", URL, СоединениеHTTP, ЗапросHTTP, ПараметрыЖурналирования);
	КонецЕсли;
	Попытка
		ПолученныеЗаголовки = СоединениеHTTP.ПолучитьЗаголовки(ЗапросHTTP);// HEAD
	Исключение
		Возврат 0;
	КонецПопытки;
	Если ПараметрыЖурналирования <> Неопределено Тогда
		ПараметрыЖурналирования.ОбщийМодуль.ПриПолученииДанныхHTTP(
			ПолученныеЗаголовки, Неопределено, ПараметрыЖурналирования);
	КонецЕсли;
	РазмерСтрокой = ПолученныеЗаголовки.Заголовки["Content-Length"];
	
	ТипЧисло = Новый ОписаниеТипов("Число");
	РазмерФайла = ТипЧисло.ПривестиЗначение(РазмерСтрокой);
	
	Возврат РазмерФайла;
	
КонецФункции

#КонецОбласти