#Область СлужебныйПрограммныйИнтерфейс

// См. УчетНДСКлиентСервер.ТипыНалогообложенияСкрывающиеРеквизитыНДС
Процедура ДополнитьТипыНалогообложенияСкрывающиеРеквизитыНДС(Массив) Экспорт
	
	//++ Локализация
	Массив.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД"));
	Массив.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.НалоговыйАгентПоНДС"));
	Массив.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя"));
	Массив.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.РеализацияРаботУслугНаЭкспорт"));
	Массив.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаПоПатенту"));
	//-- Локализация
	
КонецПроцедуры

// Рассчитывает сумму НДС исходя из суммы и флагов налогообложения.
//
// Параметры:
//  Сумма            - Число - сумма от которой надо рассчитывать налоги;
//  СтавкаНДС        - Число, СправочникСсылка.СтавкиНДС - Значение или ссылка на ставку НДС.
//  СуммаВключаетНДС - Булево - признак включения НДС в сумму ("внутри" или "сверху");
//  НалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС - налогообложение документа
//
// Возвращаемое значение:
//  Число - полученная сумма НДС.
//
Функция РассчитатьСуммуНДС(Сумма, СтавкаНДС, СуммаВключаетНДС = Истина, НалогообложениеНДС = Неопределено) Экспорт

	СуммаНДС = Неопределено;
	
	//++ Локализация
	Если НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ЭлектронныеУслуги") Тогда
		Если ТипЗнч(СтавкаНДС) = Тип("СправочникСсылка.СтавкиНДС") Тогда
			ЗначениеСтавкиНДС = УчетНДСУПКлиентСервер.ЗначениеСтавкиНДС(СтавкаНДС);
		Иначе
			ЗначениеСтавкиНДС = СтавкаНДС; 
		КонецЕсли;
	
		СуммаНДС = Окр(Сумма * ЗначениеСтавкиНДС / 100, 2, РежимОкругления.Окр15как20);
	КонецЕсли;
	//-- Локализация
	
	Возврат СуммаНДС;
	
КонецФункции

#КонецОбласти
