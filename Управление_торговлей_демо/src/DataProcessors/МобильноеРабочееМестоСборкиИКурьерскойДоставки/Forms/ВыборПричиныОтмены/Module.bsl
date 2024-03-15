#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Распоряжение", Распоряжение);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Отказ = Ложь;
	ОтменитьРаспоряжение(ВыбраннаяСтрока, Отказ);
	
	Если Не Отказ Тогда
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтменитьРаспоряжение(ПричинаОтмены, Отказ)
	
	Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки.ОтменитьРаспоряжение(Распоряжение, ПричинаОтмены, Отказ);
	
КонецПроцедуры

#КонецОбласти
