///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПлатежнаяСсылка") Тогда
		
		ПлатежнаяСсылка = Параметры.ПлатежнаяСсылка;
		QRКод = СервисИнтеграцииССБП.СоздатьQRКодОплаты(
			Параметры.ПлатежнаяСсылка,
			360,
			0);
		QRКодКартинкой = ПоместитьВоВременноеХранилище(QRКод, ЭтотОбъект);
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	ДанныеПлатежнойСсылки = Новый Структура;
	ДанныеПлатежнойСсылки.Вставить("ПлатежнаяСсылка", ПлатежнаяСсылка);
	ДанныеПлатежнойСсылки.Вставить("QRКод", QRКод);
	
	НастройкиФормы = Новый Структура;
	НастройкиФормы.Вставить("Группа", Элементы.ГруппаКнопок);
	
	ИнтеграцияПодсистемБИП.ПриСозданииНаСервереФормыQRКода(
		ЭтотОбъект,
		НастройкиФормы);
	ИнтеграцияСПлатежнымиСистемамиПереопределяемый.ПриСозданииНаСервереФормыQRКода(
		ЭтотОбъект,
		НастройкиФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОповещениеПослеЗавершенияНастройкиФормы = Новый ОписаниеОповещения(
		"Подключаемый_ПослеЗавершенияНастройкиФормы",
		ЭтотОбъект,
		Новый Структура);
	
	ИнтеграцияПодсистемБИПКлиент.ПриОткрытииФормыQRКода(
		ЭтотОбъект,
		ДанныеПлатежнойСсылки,
		ОповещениеПослеЗавершенияНастройкиФормы);
	
	ИнтеграцияСПлатежнымиСистемамиКлиентПереопределяемый.ПриОткрытииФормыQRКода(
		ЭтотОбъект,
		ДанныеПлатежнойСсылки,
		ОповещениеПослеЗавершенияНастройкиФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ИнтеграцияПодсистемБИПКлиент.ПриЗакрытииФормыQRКода(ЭтотОбъект);
	ИнтеграцияСПлатежнымиСистемамиКлиентПереопределяемый.ПриЗакрытииФормыQRКода(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПриОбработкеНажатияКоманды(Команда)
	
	ИнтеграцияПодсистемБИПКлиент.ПриОбработкеНажатияКоманды(
		ЭтотОбъект,
		Команда,
		ДанныеПлатежнойСсылки);
	ИнтеграцияСПлатежнымиСистемамиКлиентПереопределяемый.ПриОбработкеНажатияКоманды(
		ЭтотОбъект,
		Команда,
		ДанныеПлатежнойСсылки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПослеЗавершенияНастройкиФормы(РезультатВыполнения, Параметры) Экспорт
	
	ИнтеграцияПодсистемБИПКлиент.ПриОтображенииQRКода(
		ДанныеПлатежнойСсылки,
		Параметры);
	ИнтеграцияСПлатежнымиСистемамиКлиентПереопределяемый.ПриОтображенииQRКода(
		ДанныеПлатежнойСсылки,
		Параметры);
	
КонецПроцедуры

#КонецОбласти
