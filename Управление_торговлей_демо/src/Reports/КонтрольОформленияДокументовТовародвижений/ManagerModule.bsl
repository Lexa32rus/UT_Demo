#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Возвращает сериализованную в строку XML структуру для отбора строк отчета.
//
// Параметры:
//  Склад		 - СправочникСсылка.Склады	 - склад.
//  ВидОперации	 - Строка	 - вид операции.
//  Рекомендация - Строка	 - рекомендация.
// 
// Возвращаемое значение:
//  Строка - структура в виде строки XML.
//
Функция СтруктураОтборовРаспоряженийСтрокаXML(Склад, ВидОперации, Рекомендация) Экспорт
	
	Структура = Новый Структура("Склад, ВидОперации, Рекомендация", Склад, ВидОперации, Рекомендация);
	Возврат ОбщегоНазначения.ЗначениеВСтрокуXML(Структура);
	
КонецФункции

// Возвращает структуру с рекомендациями.
//
// Параметры:
//  Рекомендация - Строка	 - имя рекомендации, которой будет установлено значение Истина.
// 
// Возвращаемое значение:
//  Структура - структура со значениями полей см. ПредставленияРекомендаций.
//
Функция СтруктураРекомендаций(Рекомендация) Экспорт
	
	СтруктураРекомендаций = Новый Структура;
	Соответствие = ПредставленияРекомендаций();
	Для Каждого ЭлементСоответствия Из Соответствие Цикл
		СтруктураРекомендаций.Вставить(ЭлементСоответствия.Ключ, ЭлементСоответствия.Значение = Рекомендация);
	КонецЦикла;
	Возврат СтруктураРекомендаций;
	
КонецФункции

// Возвращает представления рекомендаций.
// 
// Возвращаемое значение:
//  Соответствие - ключ соответствия содержит имя рекомендации, значение соответствия содержит текст рекомендации.
//
Функция ПредставленияРекомендаций() Экспорт
	
	СоответствиеРекомендаций = Новый Соответствие;
	СоответствиеРекомендаций.Вставить("ЗавершитеОформлениеРасходныхОрдеровНаТовары", НСтр("ru='Завершите оформление расходных ордеров на товары'"));
	СоответствиеРекомендаций.Вставить("ОформитеВозвратТоваровОтКлиента", НСтр("ru='Оформите возврат товаров от клиента'"));
	СоответствиеРекомендаций.Вставить("ОформитеПриходныеОрдераНаТовары", НСтр("ru='Оформите приходные ордера на товары'"));
	СоответствиеРекомендаций.Вставить("ОформитеПриобретениеТоваровИУслуг", НСтр("ru='Оформите приобретение товаров и услуг'"));
	СоответствиеРекомендаций.Вставить("ОформитеПоступлениеТоваров", НСтр("ru='Оформите поступление товаров'"));
	СоответствиеРекомендаций.Вставить("ОформитеПеремещениеТоваровВСтатусеПринято", НСтр("ru='Оформите перемещение товаров в статусе ""Принято""'"));
	СоответствиеРекомендаций.Вставить("ОформитеДокументСборкиВСтатусеСобраноРазобрано", НСтр("ru='Оформите документ сборки в статусе ""Собрано (разобрано)""'"));
	СоответствиеРекомендаций.Вставить("ОформитеДокументРазборкиВСтатусеСобраноРазобрано", НСтр("ru='Оформите документ разборки в статусе ""Собрано (разобрано)""'"));
	СоответствиеРекомендаций.Вставить("ОформитеПрочееОприходованиеТоваров", НСтр("ru='Скорректируйте прочее оприходование товаров'"));
	СоответствиеРекомендаций.Вставить("ОформитеСкладскиеАктыДляОтраженияИзлишков", НСтр("ru='Оформите складские акты для отражения излишков'"));
	СоответствиеРекомендаций.Вставить("ОформитеСкладскиеАктыДляОтраженияНедостач", НСтр("ru='Оформите складские акты для отражения недостач'"));
	СоответствиеРекомендаций.Вставить("ОформитеПередачуМатериаловВПроизводствоВСтатусеПринято", НСтр("ru='Оформите передачу материалов в производство в статусе ""Принято""'"));
	СоответствиеРекомендаций.Вставить("ОформитеВозвратМатериаловИзПроизводства", НСтр("ru='Оформите возврат материалов из производства'"));
	СоответствиеРекомендаций.Вставить("ОформитеВыпускПродукции", НСтр("ru='Оформите выпуск продукции'"));
	СоответствиеРекомендаций.Вставить("ОформитеВозвратСырьяОтПереработчика", НСтр("ru='Оформите возврат сырья от переработчика'"));
	СоответствиеРекомендаций.Вставить("ОформитеПоступлениеОтПереработчика", НСтр("ru='Оформите поступление от переработчика'"));
	СоответствиеРекомендаций.Вставить("ОформитеПоступлениеСырьяОтДавальца", НСтр("ru='Оформите поступление сырья от давальца'"));
	СоответствиеРекомендаций.Вставить("ОформитеРасходныеОрдераНаТовары", НСтр("ru='Оформите расходные ордера на товары'"));
	СоответствиеРекомендаций.Вставить("ОформитеРеализацииТоваровИУслуг", НСтр("ru='Оформите реализации товаров и услуг'"));
	СоответствиеРекомендаций.Вставить("ОформитеОтгрузкиТоваровСХранения", НСтр("ru='Оформите отгрузки товаров с хранения'"));
	СоответствиеРекомендаций.Вставить("ОформитеПриемкиТоваровНаХранение", НСтр("ru='Оформите приемки товаров на хранение'"));
	Возврат СоответствиеРекомендаций;
	
КонецФункции

#КонецОбласти

#КонецЕсли