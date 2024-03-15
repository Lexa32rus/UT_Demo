#Область СлужебныйПрограммныйИнтерфейс

// Возвращает доступные типы ввода остатков
// 
// Возвращаемое значение:
// 	Массив - Доступные типы ввода остатков
//
Функция ДоступныеТипыВводаОстатков() Экспорт
	Возврат ВводОстатковСервер.ПодготовитьДоступныеТипыДокументов();
КонецФункции

// Возвращает описания разделов и хозяйственных операций ввода остатков.
// 
// Возвращаемое значение:
// 	ТаблицаЗначений - Описание: таблица значений содержащая описание хозяйственных операций ввода остатков.
// * РазделУчета - Строка  - Текстовое представление раздела учета 
// * ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Значение хозяйственной операции ввода остатков
// * ПояснениеРазделаУчета - Строка - Текстовое представление описания хозяйственной операции ввода остатков 
// * ПорядокВДереве        - Число - Иерархия хозяйственной операции в дереве ввода остатков 
// * ДоступностьВвода      - Булево - Разрешает или запрещает ввод документа ввода остатков
// * ДокументВводаОстатков - СправочникСсылка.ИдентификаторыОбъектовМетаданных - Идентификатор документа ввода остатков
// * ШаблонЗаголовкаДокумента - Строка - Шаблон по которому строится представление документа.
// 
Функция ОписаниеРазделовВводаОстатков() Экспорт
	Возврат ВводОстатковСервер.ОписаниеРазделовВводаОстатков();
КонецФункции
	
#КонецОбласти