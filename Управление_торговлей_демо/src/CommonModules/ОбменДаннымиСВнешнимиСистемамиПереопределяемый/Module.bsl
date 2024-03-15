///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ОбменДаннымиСВнешнимиСистемамиПереопределяемый".
// ОбщийМодуль.ОбменДаннымиСВнешнимиСистемамиПереопределяемый.
//
// Серверные переопределяемые процедуры обмена данными с внешними системами:
//  - определение плана обмена для хранения настроек;
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет имя плана обмена, в котором будет сохранены настройки
// обмена данными с внешними системами.
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя метаданных плана обмена.
//
// Пример:
//	ИмяПланаОбмена = "СинхронизацияДанныхЧерезУниверсальныйФормат";
//
//@skip-warning
Процедура ПриОпределенииИмениПланаОбмена(ИмяПланаОбмена) Экспорт
	
	//++ НЕ ГОСИС
	ИмяПланаОбмена = "СинхронизацияДанныхЧерезУниверсальныйФормат";
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти
