#Область ПрограммныйИнтерфейс

// Инициализировать структуру параметров запроса в ИС МОТП (ИС МП) для получения ключа сессии.
// 
// Параметры:
// 	Организация - ОпределяемыйТип.Организация - Организация.
// Возвращаемое значение:
// 	(См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии).
Функция ПараметрыЗапросаКлючаСессии(Организация = Неопределено) Экспорт
	
	ПараметрыОтправкиHTTPЗапросов = ПараметрыОтправкиHTTPЗапросов(Неопределено, Истина);
	
	ПараметрыЗапроса = ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии();
	ПараметрыЗапроса.Организация = Организация;
	
	ПараметрыЗапроса.ПредставлениеСервиса             = ПараметрыОтправкиHTTPЗапросов.ПредставлениеСервиса;
	ПараметрыЗапроса.Сервер                           = ПараметрыОтправкиHTTPЗапросов.Сервер;
	ПараметрыЗапроса.Порт                             = ПараметрыОтправкиHTTPЗапросов.Порт;
	ПараметрыЗапроса.Таймаут                          = ПараметрыОтправкиHTTPЗапросов.Таймаут;
	ПараметрыЗапроса.ИспользоватьЗащищенноеСоединение = ПараметрыОтправкиHTTPЗапросов.ИспользоватьЗащищенноеСоединение;
	
	ПараметрыЗапроса.ИмяПараметраСеанса                = ИмяДанныхКлючаСессии(ПредопределенноеЗначение("Перечисление.ТипыТокеновАвторизации.ИСМП"));
	ПараметрыЗапроса.АдресЗапросаПараметровАвторизации = "api/v3/true-api/auth/key";
	ПараметрыЗапроса.АдресЗапросаКлючаСессии           = "api/v3/true-api/auth/simpleSignIn";
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

// Инициализировать структуру параметров запроса в ИС МОТП (ИС МП) для получения ключа сессии СУЗ.
// 
// Параметры:
// 	ПараметрыСУЗ - Структура -
// Возвращаемое значение:
// 	(См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии).
Функция ПараметрыЗапросаКлючаСессииСУЗ(ПараметрыСУЗ) Экспорт
	
	ПараметрыОтправкиHTTPЗапросов = ПараметрыОтправкиHTTPЗапросов(Неопределено, Истина);
	
	ПараметрыЗапроса = ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии();
	ПараметрыЗапроса.Организация = ПараметрыСУЗ.Организация;
	
	ПараметрыЗапроса.ПредставлениеСервиса             = НСтр("ru = 'ГИС МТ (СУЗ)'");
	ПараметрыЗапроса.Сервер                           = ПараметрыОтправкиHTTPЗапросов.Сервер;
	ПараметрыЗапроса.Порт                             = ПараметрыОтправкиHTTPЗапросов.Порт;
	ПараметрыЗапроса.Таймаут                          = ПараметрыОтправкиHTTPЗапросов.Таймаут;
	ПараметрыЗапроса.ИспользоватьЗащищенноеСоединение = ПараметрыОтправкиHTTPЗапросов.ИспользоватьЗащищенноеСоединение;
	ПараметрыЗапроса.ИмяПараметраСеанса               = ИмяДанныхКлючаСессии(ПредопределенноеЗначение("Перечисление.ТипыТокеновАвторизации.СУЗ"));
	ПараметрыЗапроса.ПроизводственныйОбъект           = ПараметрыСУЗ.ПроизводственныйОбъект;
	ПараметрыЗапроса.ВремяЖизни                       = 60 * 60 * 9; // 9 часов
	
	ПараметрыЗапроса.АдресЗапросаПараметровАвторизации = "api/v3/true-api/auth/key";
	
	ПараметрыЗапроса.АдресЗапросаКлючаСессии = СтрШаблон(
		"api/v3/true-api/auth/simpleSignIn/%1",
		ПараметрыСУЗ.ИдентификаторСоединения);
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

// Возвращает имя параметра сеанса, в котором хранится информация о токене авторизации.
// 
// Параметры:
// 	ТипТокенаАвторизации - ПеречислениеСсылка.ТипыТокеновАвторизации - Тип токена авторизации.
// Возвращаемое значение:
// 	Строка - имя параметра сеанса.
Функция ИмяДанныхКлючаСессии(ТипТокенаАвторизации) Экспорт
	
	Если ТипТокенаАвторизации = ПредопределенноеЗначение("Перечисление.ТипыТокеновАвторизации.ИСМП") Тогда
		Возврат "ДанныеКлючаСессииИСМП";
	ИначеЕсли ТипТокенаАвторизации = ПредопределенноеЗначение("Перечисление.ТипыТокеновАвторизации.СУЗ") Тогда
		Возврат "ДанныеКлючаСессииСУЗ";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Возвращает адрес сервера ИС МП.
//
// Параметры:
//   ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции (В тестовом контуре адреса серверов
//                                                       могут отличаться для различных видов продукции).
//   ИспользоватьTrueAPI - Булево - Использовать true-api
//
// Возвращаемое значение:
//  Строка - адрес сервера ИС МП.
//
Функция АдресСервера(ВидПродукции = Неопределено, ИспользоватьTrueAPI = Ложь) Экспорт
	
	РежимРаботыСТестовымКонтуромИСМП = ИнтеграцияИСМПКлиентСерверПовтИсп.РежимРаботыСТестовымКонтуромИСМП();
	
	Если РежимРаботыСТестовымКонтуромИСМП Тогда
		Если ИспользоватьTrueAPI Тогда
			Возврат "markirovka.sandbox.crptech.ru";
		Иначе
			Возврат "sandbox.crptech.ru";
		КонецЕсли;
	Иначе
		Если ИспользоватьTrueAPI Тогда
			Возврат "markirovka.crpt.ru";
		Иначе
			Возврат "ismp.crpt.ru";
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Возвращает параметры для отправки HTTP запросов ИС МП.
//
// Параметры:
//   ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции (В тестовом контуре адреса серверов
//                                                       могут отличаться для различных видов продукции).
//   ИспользоватьTrueAPI - Булево - Использовать true-api.
//
// Возвращаемое значение:
//  Структура - Описание:
//   * ИспользоватьЗащищенноеСоединение - Булево - Признак использования SSL.
//   * Таймаут - Число - Таймаут соединения.
//   * Порт - Число - Порт соединения.
//   * Сервер - Строка - Адрес сервера.
//   * ПредставлениеСервиса - Строка - Представления сервиса.
//
Функция ПараметрыОтправкиHTTPЗапросов(ВидПродукции = Неопределено, ИспользоватьTrueAPI = Ложь) Экспорт
	
	ПараметрыОтправкиHTTPЗапросов = Новый Структура;
	ПараметрыОтправкиHTTPЗапросов.Вставить("ПредставлениеСервиса",             НСтр("ru = 'ГИС МТ'"));
	ПараметрыОтправкиHTTPЗапросов.Вставить("Сервер",                           АдресСервера(ВидПродукции, ИспользоватьTrueAPI));
	ПараметрыОтправкиHTTPЗапросов.Вставить("Порт",                             443);
	ПараметрыОтправкиHTTPЗапросов.Вставить("Таймаут",                          60);
	ПараметрыОтправкиHTTPЗапросов.Вставить("ИспользоватьЗащищенноеСоединение", Истина);
	
	Возврат ПараметрыОтправкиHTTPЗапросов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДоступныеМетодыИнтерфейса() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ЕмкостьУпаковкиПоGTIN", "ЕмкостьУпаковкиПоGTIN");
	ВозвращаемоеЗначение.Вставить("ВыполнитьАвторизацию",  "ВыполнитьАвторизацию");
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти
