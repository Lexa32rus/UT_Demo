#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//
// Возвращаемое значение:
//	СтрокаТаблицыЗначений, Неопределено - сформированная команда для вывода в подменю.
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.КонтрольВыданныхПодотчетномуЛицуАвансовПоЗаявке) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.КонтрольВыданныхПодотчетномуЛицуАвансовПоЗаявке.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Контроль выданных подотчетному лицу авансов'");
		КомандаОтчет.ВидимостьВФормах = "ФормаСписка, ФормаСпискаДокументов, ФормаСпискаЗаявокКСогласованию";
		КомандаОтчет.Порядок       = 70;
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.КлючВарианта = "КонтрольПоЗаявкеКонтекст";
		
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(
			КомандаОтчет,
			"ХозяйственнаяОперация",
			Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику,
			ВидСравненияКомпоновкиДанных.Равно);
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.КонтрольВыданныхПодотчетномуЛицуАвансовПоЗаявке.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Контроль выданных подотчетному лицу авансов'");
		КомандаОтчет.ВидимостьВФормах = "ФормаДокумента";
		КомандаОтчет.Порядок       = 70;
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.КлючВарианта = "КонтрольПоЗаявкеКонтекст";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли