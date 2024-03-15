
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИтогиПоВалютам.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыИтоговПоВалютам));
	
КонецПроцедуры

#КонецОбласти
