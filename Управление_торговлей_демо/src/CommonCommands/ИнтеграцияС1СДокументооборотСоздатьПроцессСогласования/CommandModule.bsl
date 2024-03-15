#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Параметры = Новый Структура;
	Параметры.Вставить("ПредметСогласования", ПараметрКоманды);
	Параметры.Вставить("Источник", ПараметрыВыполненияКоманды.Источник);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПроверитьПодключениеЗавершение", ЭтотОбъект, Параметры);
		
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПроверитьПодключение(
		ОписаниеОповещения,,, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьПодключениеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда // авторизация успешна
		
		ИнтеграцияС1СДокументооборотКлиент.НачатьСогласование(Параметры);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти