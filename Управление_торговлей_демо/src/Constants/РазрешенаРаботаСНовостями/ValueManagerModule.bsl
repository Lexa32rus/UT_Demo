///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Константа.РазрешенаРаботаСНовостями: Модуль менеджера.
//
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ПередЗаписью(Отказ)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации() Тогда
		ДополнительныеСвойства.Вставить("ЗначениеПередЗаписью", Константы.РазрешенаРаботаСНовостями.Получить());
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// Получение функциональных опций "РазрешенаРаботаСНовостями"
	//  и "РазрешенаРаботаСНовостямиЧерезИнтернет" осуществляется через
	//  общий модуль "ОбработкаНовостейПовтИсп", поэтому после установки
	//  константы необходимо сбросить кэш.
	ОбновитьПовторноИспользуемыеЗначения();

	Если ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации() Тогда

		#Если ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда
			ОбъектМетаданных = Неопределено;
		#Иначе
			ОбъектМетаданных = Метаданные.Константы.РазрешенаРаботаСНовостями;
		#КонецЕсли

		// Запись в журнал регистрации
		ТекстСообщения = НСтр("ru='Записана константа РазрешенаРаботаСНовостями
			|Предыдущее значение: %ПредыдущееЗначение%
			|Новое значение: %НовоеЗначение%'");
		Если ДополнительныеСвойства.Свойство("ЗначениеПередЗаписью") Тогда
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредыдущееЗначение%", ДополнительныеСвойства.ЗначениеПередЗаписью);
		Иначе
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредыдущееЗначение%", "Неопределено");
		КонецЕсли;
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НовоеЗначение%", Значение);
		// Запись в журнал регистрации
		ОбработкаНовостейВызовСервера.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru='БИП:Новости.Изменение данных'", ОбщегоНазначения.КодОсновногоЯзыка()), // ИмяСобытия.
			НСтр("ru='Новости. Изменение данных. Константы. РазрешенаРаботаСНовостями'", ОбщегоНазначения.КодОсновногоЯзыка()), // ИдентификаторШага.
			"Информация", // УровеньЖурналаРегистрации.*
			ОбъектМетаданных, // ОбъектМетаданных
			, // Данные
			ТекстСообщения, // Комментарий
			ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации

	КонецЕсли;

	// В зависимости от текущего значения константы отключить или включить использование регламентного задания "ВсеОбновленияНовостей".
	ОбработкаНовостей.ИзменитьИспользованиеРегламентныхЗаданий(Значение);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
