
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Заголовок = НСтр("ru='Результаты проверки состояния учета'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	НастроитьДинамическийСписок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		ОписаниеПроверки = "";
	Иначе
		ОписаниеПроверки = СокрЛП(Элементы.Список.ТекущиеДанные.ОписаниеПроверки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.Подробнее И НЕ ТекущиеДанные.ЭтоСоставнойОбъект И ЗначениеЗаполнено(ТекущиеДанные.Объект) Тогда
		ОтображаемоеЗначение = ТекущиеДанные.Объект;
	ИначеЕсли НЕ ТекущиеДанные.ЕстьЗаписьРегистраОбъектов Тогда
		ОтображаемоеЗначение = СформироватьКлючЗаписиРегистраПроблемСостоянияСистемы(ТекущиеДанные);
	Иначе
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПоказатьЗначение(, ОтображаемоеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьКлючЗаписиРегистраПроблемСостоянияСистемы(ТекущиеДанные)
	
	Отбор = Новый Структура("Проверка, Организация, ПроверяемыйПериод, Проблема");
	ЗаполнитьЗначенияСвойств(Отбор, ТекущиеДанные);
	
	КлючЗаписи = РегистрыСведений.ПроблемыСостоянияСистемы.СоздатьКлючЗаписи(Отбор);
	
	Возврат КлючЗаписи;
	
КонецФункции
	
&НаСервере
Процедура НастроитьДинамическийСписок()
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список,
		"ТекстПодробнее",
		ЗакрытиеМесяцаСервер.ТекстПодробнееПоУмолчанию());
		
	ПараметрыПроверок = Параметры.ПараметрыПроверок;
	Если ТипЗнч(ПараметрыПроверок) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ОтображатьОрганизации = Ложь;
	
	Для Каждого КлючИЗначение Из ПараметрыПроверок Цикл
		
		Если НЕ ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
			Продолжить;
		КонецЕсли;
		
		Если КлючИЗначение.Ключ = "МассивОрганизаций" Тогда
			
			ИмяПоля = "Организация";
			УсловиеСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			
			Если КлючИЗначение.Значение.Количество() > 0 Тогда
				ОтображатьОрганизации = Истина;
			КонецЕсли;
			
		ИначеЕсли КлючИЗначение.Ключ = "ПроверяемыйПериод" Тогда
			
			ИмяПоля = "НачалоПериода";
			УсловиеСравнения = ВидСравненияКомпоновкиДанных.Равно;
			
		ИначеЕсли КлючИЗначение.Ключ = "ПериодРегистрации" Тогда
			
			Продолжить;
			
		Иначе
			
			ИмяПоля = КлючИЗначение.Ключ;
			
			Если ТипЗнч(КлючИЗначение.Значение) = Тип("Массив")
			 ИЛИ ТипЗнч(КлючИЗначение.Значение) = Тип("СписокЗначений") Тогда
				УсловиеСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			Иначе
				УсловиеСравнения = ВидСравненияКомпоновкиДанных.Равно;
			КонецЕсли;
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			ИмяПоля,
			КлючИЗначение.Значение,
			УсловиеСравнения,
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
		
	КонецЦикла;
	
	Элементы.Организация.Видимость = ОтображатьОрганизации И ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
КонецПроцедуры

#КонецОбласти
