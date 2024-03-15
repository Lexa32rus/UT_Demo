

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидУпаковки                         = Параметры.ВидУпаковки;
	КодПоОКЕИ                           = Параметры.КодОКЕИБазовойЕдиницыИзмерения;
	КоличествоУпаковок                  = Параметры.КоличествоУпаковок;
	КоличествоБазовойЕдиницыИзмерения   = Параметры.КоличествоБазовойЕдиницыИзмерения;
	НаименованиеУпаковки                = Параметры.НаименованиеУпаковки;
	НаименованиеБазовойЕдиницыИзмерения = Параметры.НаименованиеБазовойЕдиницыИзмерения;
	
	ИзменитьТекущуюСтраницуВидаУпаковки(ВидУпаковки, Элементы, КоличествоУпаковок, КоличествоБазовойЕдиницыИзмерения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВидУпаковкиПриИзменении(Элемент)
	
	ИзменитьТекущуюСтраницуВидаУпаковки(ВидУпаковки, Элементы,
		КоличествоУпаковок, КоличествоБазовойЕдиницыИзмерения);
		
КонецПроцедуры
	
&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	ОчиститьСообщения();
	
	Если ПроверитьЗаполнение() Тогда
		
		ПараметрыЗакрытия = Новый Структура;
		ПараметрыЗакрытия.Вставить("ВидУпаковки", ВидУпаковки);
		ПараметрыЗакрытия.Вставить("КодОКЕИБазовойЕдиницыИзмерения", КодПоОКЕИ);
		ПараметрыЗакрытия.Вставить("КоличествоУпаковок", КоличествоУпаковок);
		ПараметрыЗакрытия.Вставить("КоличествоБазовойЕдиницыИзмерения", КоличествоБазовойЕдиницыИзмерения);
		ПараметрыЗакрытия.Вставить("НаименованиеУпаковки", НаименованиеУпаковки);
		ПараметрыЗакрытия.Вставить("НаименованиеБазовойЕдиницыИзмерения", НаименованиеБазовойЕдиницыИзмерения);
	
		Закрыть(ПараметрыЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьТекущуюСтраницуВидаУпаковки(Знач ВидУпаковки, Элементы, КоличествоУпаковок, КоличествоБазовойЕдиницыИзмерения)
		
	Если ВидУпаковки = "Упаковка" Тогда
		Если КоличествоУпаковок <> 1
			И КоличествоБазовойЕдиницыИзмерения = 1 Тогда
			КоличествоБазовойЕдиницыИзмерения = 0;
		КонецЕсли;
		КоличествоУпаковок = 1;
		Элементы.СтраницыВидовУпаковки.ТекущаяСтраница = Элементы.СтраницаУпаковка;
	ИначеЕсли ВидУпаковки = "Разупаковка" Тогда
		Если КоличествоУпаковок = 1
			И КоличествоБазовойЕдиницыИзмерения <> 1 Тогда
			КоличествоУпаковок = 0;
		КонецЕсли;
		КоличествоБазовойЕдиницыИзмерения = 1;
		Элементы.СтраницыВидовУпаковки.ТекущаяСтраница = Элементы.СтраницаРазупаковка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти



