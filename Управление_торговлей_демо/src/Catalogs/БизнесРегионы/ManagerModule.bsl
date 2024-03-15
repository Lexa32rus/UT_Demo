

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	КомандаОтчет = Отчеты.КонтактнаяИнформация.ДобавитьКомандуКонтактнаяИнформацияПоПартнерам(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.Представление = НСтр("ru = 'Контактная информация партнеров по бизнес-региону'");
	КонецЕсли;
	
	КомандаОтчет = Отчеты.КонтактнаяИнформация.ДобавитьКомандуКонтактнаяИнформацияКонтактныхЛиц(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
