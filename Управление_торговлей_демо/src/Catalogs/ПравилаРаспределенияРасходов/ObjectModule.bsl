#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	
	ПараметрыВыбораСтатейИАналитик = Справочники.ПравилаРаспределенияРасходов.ПараметрыВыбораСтатейИАналитик(НазначениеПравила);
	Если Не ПараметрыВыбораСтатейИАналитик = Неопределено Тогда
		ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	КонецЕсли;
		
	
КонецПроцедуры


Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	Если Устаревшее Тогда
		
		НепроверяемыеРеквизиты.Добавить("БазаРаспределенияПоПартиям");
		НепроверяемыеРеквизиты.Добавить("СтатьяСписанияРБП");
		НепроверяемыеРеквизиты.Добавить("АналитикаРасходовРБП");
		
	Иначе
		
		
		Если Не НазначениеПравила = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаРБП Тогда
			
			НепроверяемыеРеквизиты.Добавить("СтатьяСписанияРБП");
			НепроверяемыеРеквизиты.Добавить("АналитикаРасходовРБП");
			
		КонецЕсли;
		
		Если НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.ПоКоэффициентам
			Или Не НазначениеПравила = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаСебестоимостьТоваров Тогда
			НепроверяемыеРеквизиты.Добавить("БазаРаспределенияПоПартиям");
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
