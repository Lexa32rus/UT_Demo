#Область ПрограммныйИнтерфейс

// Структура для заполнения данными, по которым будет производится резервирование и печать кодов
// маркировки товаров.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * Организация          - ОпределяемыйТип.Организация - Организация. 
// * ВидПродукции         - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции.
// * СпособВводаВОборот   - ПеречислениеСсылка.СпособыВводаВОборотСУЗ - Способ ввода 
// * Шаблон               - ПеречислениеСсылка.ШаблоныКодовМаркировкиСУЗ - Шаблон кода маркировки
// * ШтрихкодУпаковки     - СправочникСсылка.ШтрихкодыУпаковокТоваров - Источник получения серии и типа штрихкода,
//                          если эти параметры не заполнены в соответствующих ключах.
// * ЭтоКодМаркировки     - Булево - Признак принадлежности структуры к маркируемой продукции,
//                          так же, могут печататься логистические упаковки.
// * СодержимоеКоличество - Число - Количество элементов внутри (для логистической упаковки)
// * НомерВГруппе         - Число - Номер по порядку (для логистической упаковки)
// * Порядок              - Число - Порядок сортировки для вывода на печать в пределах формируемой упаковки
// * Количество           - Число - Количество этикеток для печати
// * УчетноеКоличество    - Число - Количество для записи в справочник "Штрихкоды упаковок и товаров"
// * ШаблонЭтикетки       - СправочникСсылка.ШаблоныЭтикетокИЦенников - Шаблон для печати
// * ТипШтрихкода         - ПеречислениеСсылка.ТипыШтрихкодов - Тип штрихкода для печати
// * Штрихкод             - Строка - Значение штрихкода (используется дла печати и отметки о печати известного кода)
// * Номенклатура         - СправочникСсылка.Номенклатура - Номенклатура для заполнения шаблона
// * Характеристика       - СправочникСсылка.ХарактеристикиНоменклатуры - Характеристика для заполнения шаблона
// * Серия                - СправочникСсылка.СерииНоменклатуры - Серия, устанавливается в новый элемент ШтрикодУпаковкиТоваров.
// * GTIN                 - ОпределяемыйТип.GTIN - GTIN товара.
//
Функция СтруктураПечатиЭтикетки() Экспорт
	
	ПараметрыШтрихкода = Новый Структура;
	ПараметрыШтрихкода.Вставить("Организация");
	ПараметрыШтрихкода.Вставить("ВидПродукции");
	ПараметрыШтрихкода.Вставить("Номенклатура");
	ПараметрыШтрихкода.Вставить("Характеристика");
	ПараметрыШтрихкода.Вставить("Серия");
	ПараметрыШтрихкода.Вставить("Штрихкод");
	ПараметрыШтрихкода.Вставить("ТипШтрихкода");
	ПараметрыШтрихкода.Вставить("ШаблонЭтикетки");
	ПараметрыШтрихкода.Вставить("Количество", 0);
	ПараметрыШтрихкода.Вставить("УчетноеКоличество", 0);
	ПараметрыШтрихкода.Вставить("НомерВГруппе", "");
	ПараметрыШтрихкода.Вставить("Порядок", 0);
	ПараметрыШтрихкода.Вставить("СодержимоеКоличество", 0);
	ПараметрыШтрихкода.Вставить("ЭтоКодМаркировки", Истина);
	ПараметрыШтрихкода.Вставить("ШтрихкодУпаковки",
		ПредопределенноеЗначение("Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка"));
	ПараметрыШтрихкода.Вставить("Шаблон");
	ПараметрыШтрихкода.Вставить("СпособВводаВОборот");
	ПараметрыШтрихкода.Вставить("СрокГодности");
	ПараметрыШтрихкода.Вставить("КодМаркировки");
	ПараметрыШтрихкода.Вставить("ХешСуммаКодаМаркировки");
	ПараметрыШтрихкода.Вставить("КодУпаковки");
	ПараметрыШтрихкода.Вставить("ХешСуммаКодаУпаковки");
	ПараметрыШтрихкода.Вставить("МаркировкаОстатков");
	ПараметрыШтрихкода.Вставить("GTIN");
	
	Возврат ПараметрыШтрихкода;
	
КонецФункции

// Подготавливает структуру исходных данных для передачи в функцию печати
// У формы вдалельцем должна выступать форма с основным реквизитом Объект. 
// Для резервирования необходима ссылка,поэтому для новых объектов будет предпринята попытка записать
// Во входящей структуре могут быть заполнены не все поля. Обязательными являются Номенклатура [, Характеристика]
// Если не заполнено поле ШаблонЭтикетки - шаблон будет запрошен у пользователя.
// 
// Параметры:
// 	ПараметрыПечати - См. ПечатьЭтикетокИСМПКлиентСервер.СтруктураПечатиЭтикетки
// 	Форма - ФормаКлиентскогоПриложения - Источник событий
// 	Документ - ДокументСсылка - Документ, к которому будут относиться коды маркировки
// 	ДополнитьПолныйКодМаркировки - Строка - Идентификатор применения для дополнения кода маркировки
// Возвращаемое значение:
// 	Структура - Описание:
// * КаждаяЭтикеткаНаНовомЛисте - Булево - для данной функции не актульно, потому что печатается одна этикетка
// * Документ - ОпределяемыйТип.ОснованиеЗаказНаЭмиссиюКодовМаркировкиИСМП - Документ-основание, 
//     на который необходимо перерезервировать свободный код маркировки.
// * АдресВХранилище - Строка - адрес объектов печати
Функция ДанныеДляПечатиЭтикеток(ПараметрыПечати, Форма, Документ, ДополнитьПолныйКодМаркировки = "") Экспорт
	
	Если Не ЗначениеЗаполнено(Документ) Тогда
		ВызватьИсключение НСтр("ru = 'Внутренняя ошибка. Пустая ссылка на документ'");
	КонецЕсли;
	
	ПараметрыПечати.УчетноеКоличество = ПараметрыПечати.Количество;
	ПараметрыПечати.Количество = 1;

	ОбъектыПечати = Новый Массив;
	ОбъектыПечати.Добавить(ПараметрыПечати);
	
	СтруктураОбъектовПечати = Новый Структура();
	СтруктураОбъектовПечати.Вставить("РежимПечати", "НеРаспечатанныеКодыПоДокументуСРезервированием");
	СтруктураОбъектовПечати.Вставить("ОбъектыПечати", ОбъектыПечати);
	
	ДанныеДляПечати = Новый Структура;
	ДанныеДляПечати.Вставить("АдресВХранилище",
		ПоместитьВоВременноеХранилище(СтруктураОбъектовПечати, Форма.УникальныйИдентификатор));
	ДанныеДляПечати.Вставить("Документ", Документ);
	ДанныеДляПечати.Вставить("КаждаяЭтикеткаНаНовомЛисте",   Истина);
	ДанныеДляПечати.Вставить("ДополнитьПолныйКодМаркировки", ДополнитьПолныйКодМаркировки);
	
	Возврат ДанныеДляПечати;
	
КонецФункции

#КонецОбласти