#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтборЭлектронныйДокумент = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры.Отбор, "ЭлектронныйДокумент");
	Если ЗначениеЗаполнено(ОтборЭлектронныйДокумент) Тогда
		Элементы.ЭлектронныйДокумент.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти