//++ Устарело_Производство21
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru='Непосредственное формирование отчета ""Настройка списка"" не предусмотрено.'");
	ВызватьИсключение ТекстСообщения;
	
КонецПроцедуры
//-- Устарело_Производство21