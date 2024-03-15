#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

Процедура ПередЗаписью(Отказ, Замещение)
		
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Отказ = Истина;
		ВызватьИсключение 
			НСтр("ru = 'Изменение регистра ""Задания к распределению расчетов с клиентами"" следует выполнять только в главном узле РИБ.
			           |Затем выполнить синхронизацию с подчиненными узлами.'");
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#КонецЕсли