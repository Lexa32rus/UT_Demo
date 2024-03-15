
#Область ОбработчикиСобытийФормы
 
&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	Результат = Новый Массив;
	
	Если ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс() Тогда
		Если РазрешитьРедактированиеГоловнаяОрганизация Или Не ОбособленноеПодразделение Тогда
			Результат.Добавить("ГоловнаяОрганизация");
		КонецЕсли;
	КонецЕсли;
	
	Если РазрешитьРедактированиеВалютыРегламентированногоУчета Тогда
		Результат.Добавить("ВалютаРегламентированногоУчета");
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры // РазрешитьРедактирование()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбособленноеПодразделение = Параметры.ОбособленноеПодразделение;
	
	Элементы.ГруппаГоловнаяОрганизация.Видимость = Параметры.ОбособленноеПодразделение;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс()
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс");
	
КонецФункции

#КонецОбласти
