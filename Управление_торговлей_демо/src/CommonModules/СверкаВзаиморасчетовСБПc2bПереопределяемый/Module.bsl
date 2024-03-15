///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.СверкаВзаиморасчетовСБПc2b".
// ОбщийМодуль.СверкаВзаиморасчетовСБПc2bПереопределяемый.
//
// Переопределяемые серверные процедуры выполнения сверки взаиморасчетов:
//  - определение настроек подсистемы;
//  - определение оборотов оплат и возвратов по первичным документам;
//  - списание расходов комиссии;
//  - определение параметров операций оплат и возвратов для проведения сверки взаиморасчетов.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определят настройки использования подсистемы.
//
// Параметры:
//  Настройки - Структура - настройки выполнения сверки взаиморасчетов:
//    * ИспользоватьДокументСверки - Булево - определяет доступность использования документа "СверкаВзаиморасчетовСБПc2b";
//    * ИспользоватьСписаниеРасходов - Булево - определяет порядок списания комиссии при загрузки сверки оборотов.
//
Процедура ПриНастройкеСверкиВзаиморасчетов(Настройки) Экспорт
	
	
КонецПроцедуры

// Определяет обороты оплат и возвратов по списку документов для проведения
// сверки взаиморасчетов с платежными системами.
//
// Параметры:
//  ДокументыОплаты - Массив из ОпределяемыйТип.ДокументОперацииБИП - данные документов
//    для которых необходимо проводить сверку;
//  НастройкаПодключения - СправочникСсылка.НастройкиИнтеграцииСПлатежнымиСистемами -
//    настройка интеграции с платежной системой;
//  Обороты - Структура - данные оборотов продаж и оплат:
//    *СуммаОплат - Число - общая сумма оплат по документам в торговой точке;
//    *СуммаВозвратов - Число - общая сумма возвратов по документам в торговой точке.
//
Процедура ПриОпределенииОборотов(ДокументыОплаты, НастройкаПодключения, Обороты) Экспорт
	
	
КонецПроцедуры

// Производит списание расходов комиссии платежной системы за проведение операций.
//
// Параметры:
//  ПараметрыСписанияРасходов - Структура - данные для списания расходов комиссии:
//   *НастройкаИнтеграции - СправочникСсылка.НастройкиИнтеграцииСПлатежнымиСистемами -
//    настройка интеграции с платежной системой;
//   *НачалоПериода - Дата - начало периода отчета по сверке взаиморасчетов;
//   *КонецПериода - Дата - окончание периода отчета по сверке взаиморасчетов;
//   *СуммаКомиссии - Число - комиссия за проведение операций платежной системы;
//  ДокументСписания - ОпределяемыйТип.СписаниеРасходовБИП - сформированные документ
//    списания расходов комиссии.
//
Процедура ПриСписанииРасходовКомиссии(ПараметрыСписанияРасходов, ДокументСписания) Экспорт
	
	
КонецПроцедуры

// Определяет суммы оплат и возвратов по списку документов для проведения
// сверки взаиморасчетов с платежными системами.
//
// Параметры:
//  ДокументыОплат - Массив из ОпределяемыйТип.ДокументОперацииБИП - данные документов
//    для которых необходимо проводить сверку;
//  НастройкаПодключения - СправочникСсылка.НастройкиИнтеграцииСПлатежнымиСистемами -
//    настройка интеграции с платежной системой;
//  ДанныеОпераций - Соответствие - информация об операциях оплат для вывода в отчет:
//    *Ключ - ОпределяемыйТип.ДокументОперацииБИП - документ оплаты или возврата;
//    *Значение - Структура - см. СверкаВзаиморасчетовСБПc2b.НовыйДанныеОперацийОплат.
//
Процедура ПриОпределенииДанныхОпераций(ДокументыОплат, НастройкаПодключения, ДанныеОпераций) Экспорт
	
	
КонецПроцедуры

#КонецОбласти
