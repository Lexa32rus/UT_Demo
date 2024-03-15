
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает сертификат подписавшей стороны из коллекции сертификатов, извлеченной из данных подписи. 
// Поиск происходит с учетом того, что CN Субъекта и Издателя могут быть равны.
//
// Параметры:
//  СертификатыПодписи - Массив из СертификатКриптографии - сертификаты, извлеченные из данных подписи,
//                                                          см. метод платформы ПолучитьСертификатыИзПодписи.
// 
// Возвращаемое значение:
// СертификатКриптографии, Неопределено - сертификат, с помощью которого была произведена подпись.
//
Функция СертификатПодписавшейСтороны(Знач СертификатыПодписи) Экспорт
	
	Возврат КриптографияБЭДСлужебныйКлиентСервер.НайтиСертификатПодписавшейСтороныРекурсивно(СертификатыПодписи);
	
КонецФункции

// Возвращает пустой результат получения отпечатков сертификатов.
// 
// Возвращаемое значение:
// 	Структура:
// * Отпечатки - Массив из Строка
// * Ошибка - Булево - при получении отпечатков произошла ошибка
// * Доступность - Булево - используется ли криптография в контекстах: клиент, сервер, облачный сервис криптографии.
// * ТекстОшибки - Строка
Функция НовыйРезультатПолученияОтпечатков() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Ошибка", Ложь);
	Результат.Вставить("ТекстОшибки", "");
	Результат.Вставить("Доступность", Ложь);
	Результат.Вставить("Отпечатки", Новый Массив);
	
	Возврат Результат;
	
КонецФункции

// Возвращает результаты получения отпечатков сертификатов в контекстах: Клиент, Сервер, Облако.
// 
// Возвращаемое значение:
// 	Структура:
// * Клиент - см. НовыйРезультатПолученияОтпечатков.
//          - Неопределено - получение отпечатков не выполнялось.
// * Сервер - см. НовыйРезультатПолученияОтпечатков .
//          - Неопределено - получение отпечатков не выполнялось.
// * Облако - см. НовыйРезультатПолученияОтпечатков.
//          - Неопределено - получение отпечатков не выполнялось.
Функция НовыеРезультатыПолученияОтпечатков() Экспорт
	
	Результаты = Новый Структура;
	Результаты.Вставить("Клиент", Неопределено);
	Результаты.Вставить("Сервер", Неопределено);
	Результаты.Вставить("Облако", Неопределено);
	
	Возврат Результаты;
	
КонецФункции

// Возвращает описание подписи.
// 
// Возвращаемое значение:
//  Структура:
//  * Подпись - ДвоичныеДанные
//  * Сертификат - ДвоичныеДанные
//  * Отпечаток - Строка
//  * КомуВыданСертификат - Строка
//  * УстановившийПодпись - СправочникСсылка.Пользователи
//  * ДатаПроверкиПодписи - Дата
//  * ПодписьВерна - Булево
//  * ИмяФайлаПодписи - Строка
//  * ДатаПодписи - Дата
//  * Комментарий - Строка
//  * ТипПодписи - ПеречислениеСсылка.ТипыЭлектроннойПодписи
//  * СрокДействияПоследнейМеткиВремени - Дата - срок действия сертификата, которым подписана
//                                    последняя метка времени (или пустая дата, если нет метки времени)
//  * ПорядковыйНомер - Число - идентификатор подписи, по которому можно упорядочивать их в списке.
//                      Не заполнен, если подпись не связана с объектом.
//  * ПодписанныйОбъект - ОпределяемыйТип.ПодписанныйОбъект - идентификатор подписи, по которому можно
//                        упорядочивать их в списке. Не заполнен, если подпись не связана с объектом.
//  * ОшибкаПриАвтоматическомПродлении - Булево - служебный, заполняется регламентным заданием.
//  * ОписаниеСертификата - Структура - свойство, требуемое для сертификатов, которые
//                          не могут быть переданы в метод платформы СертификатКриптографии, со свойствами:
//  ** СерийныйНомер - Строка - серийный номер сертификата, как у объекта платформы СертификатКриптографии.
//  ** КемВыдан      - Строка - как возвращает функция ПредставлениеИздателя.
//  ** КомуВыдан     - Строка - как возвращает функция ПредставлениеСубъекта.
//  ** ДатаНачала    - Строка - дата сертификата, как у объекта платформы СертификатКриптографии в формате "ДЛФ=D".
//  ** ДатаОкончания - Строка - дата сертификата, как у объекта платформы СертификатКриптографии в формате "ДЛФ=D".
Функция НовыеСвойстваПодписи() Экспорт
	
	СвойстваПодписи = Новый Структура;
	СвойстваПодписи.Вставить("Подпись");
	СвойстваПодписи.Вставить("Сертификат");
	СвойстваПодписи.Вставить("Отпечаток", "");
	СвойстваПодписи.Вставить("КомуВыданСертификат", "");
	СвойстваПодписи.Вставить("ДатаПодписи", Дата(1, 1, 1));
	СвойстваПодписи.Вставить("ИмяФайлаПодписи", "");
	СвойстваПодписи.Вставить("ПодписьВерна", Ложь);
	СвойстваПодписи.Вставить("ДатаПроверкиПодписи", Дата(1, 1, 1));
	СвойстваПодписи.Вставить("УстановившийПодпись",
		ПредопределенноеЗначение("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка"));
	СвойстваПодписи.Вставить("Комментарий", "");
	СвойстваПодписи.Вставить("ТипПодписи");
	СвойстваПодписи.Вставить("СрокДействияПоследнейМеткиВремени");
	СвойстваПодписи.Вставить("ПорядковыйНомер");
	СвойстваПодписи.Вставить("ПодписанныйОбъект");
	СвойстваПодписи.Вставить("ОшибкаПриАвтоматическомПродлении");
	СвойстваПодписи.Вставить("ОписаниеСертификата");
	
	Возврат СвойстваПодписи;
	
КонецФункции

// Возвращает результат проверки подписи.
// 
// Возвращаемое значение:
//  Структура:
// * ОписаниеОшибки - Строка
// * СвойстваПодписи - см. НовыеСвойстваПодписи
Функция НовыйРезультатПроверкиПодписи() Экспорт
	
	РезультатПроверки = Новый Структура;
	РезультатПроверки.Вставить("ОписаниеОшибки", "");
	РезультатПроверки.Вставить("СвойстваПодписи", НовыеСвойстваПодписи());
	
	Возврат РезультатПроверки;
	
КонецФункции

#Область ОбработкаНеисправностей

// Возвращает вид ошибки, возникающей при проблемах с криптографией.
// 
// Возвращаемое значение:
// 	См. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки
Функция ВидОшибкиКриптография() Экспорт
	
	ОбработчикВыполненияДиагностики = "ОбработкаНеисправностейБЭДКлиент.ОткрытьМастерДиагностики";
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "ОшибкаКриптографии";
	ВидОшибки.ВыполнятьОбработчикАвтоматически = Истина;
	ВидОшибки.АвтоматическиВыполняемыйОбработчик = ОбработчикВыполненияДиагностики;
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Ошибка криптографии'");
	ВидОшибки.ОписаниеРешения = НСтр("ru = '<a href = ""Выполните"">Выполните</a> диагностику криптографии'");
	ВидОшибки.ОбработчикиНажатия.Вставить("Выполните", ОбработчикВыполненияДиагностики);
	
	Возврат ВидОшибки;
	
КонецФункции

#КонецОбласти

#КонецОбласти
