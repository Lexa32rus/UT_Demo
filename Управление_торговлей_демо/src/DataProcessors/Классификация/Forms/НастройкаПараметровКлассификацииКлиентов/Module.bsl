
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
	
		Возврат;
	
	КонецЕсли;
	
	Периоды.Добавить(Перечисления.Периодичность.День);
	Периоды.Добавить(Перечисления.Периодичность.Неделя);
	Периоды.Добавить(Перечисления.Периодичность.Декада);
	Периоды.Добавить(Перечисления.Периодичность.Месяц);
	Периоды.Добавить(Перечисления.Периодичность.Квартал);
	Периоды.Добавить(Перечисления.Периодичность.Полугодие);
	Периоды.Добавить(Перечисления.Периодичность.Год);
	
	ИспользоватьКлассификациюПоВыручке = Константы.ИспользоватьABCXYZКлассификациюПартнеровПоВыручке.Получить();
	ИспользоватьКлассификациюПоВаловойПрибыли = Константы.ИспользоватьABCXYZКлассификациюПартнеровПоВаловойПрибыли.Получить();
	ИспользоватьКлассификациюПоКоличествуПродаж = Константы.ИспользоватьABCXYZКлассификациюПартнеровПоКоличествуПродаж.Получить();
	ПериодABCКлассификации = Константы.ПериодABCКлассификацииПартнеров.Получить();
	КоличествоПериодовABCКлассификации = Константы.КоличествоПериодовABCКлассификацииПартнеров.Получить();
	ПериодXYZКлассификации = Константы.ПериодXYZКлассификацииПартнеров.Получить();
	КоличествоПериодовXYZКлассификации = Константы.КоличествоПериодовXYZКлассификацииПартнеров.Получить();
	ПодпериодXYZКлассификации = Константы.ПодпериодXYZКлассификацииПартнеров.Получить();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступныеЗначенияПодпериод(Элементы.ПодпериодXYZКлассификации, ПериодXYZКлассификации);
	
	Элементы.ДекорацияABCКлассификацияОписание.Заголовок = СтрШаблон(НСтр("ru = 'По данным за период: %1.'"),
		ОбеспечениеКлиентСервер.ОписаниеНастройки(ПериодABCКлассификации, КоличествоПериодовABCКлассификации));
	Элементы.ДекорацияXYZКлассификацияОписание.Заголовок = СтрШаблон(НСтр("ru = 'По данным за период: %1.'"),
		ОбеспечениеКлиентСервер.ОписаниеНастройки(ПериодXYZКлассификации, КоличествоПериодовXYZКлассификации, ПодпериодXYZКлассификации));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодABCКлассификацииПриИзменении(Элемент)
	
	Элементы.ДекорацияABCКлассификацияОписание.Заголовок = СтрШаблон(НСтр("ru = 'По данным за период: %1.'"),
		ОбеспечениеКлиентСервер.ОписаниеНастройки(ПериодABCКлассификации, КоличествоПериодовABCКлассификации));
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПериодовABCКлассификацииПриИзменении(Элемент)
	
	Элементы.ДекорацияABCКлассификацияОписание.Заголовок = СтрШаблон(НСтр("ru = 'По данным за период: %1.'"),
		ОбеспечениеКлиентСервер.ОписаниеНастройки(ПериодABCКлассификации, КоличествоПериодовABCКлассификации));
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодXYZКлассификацииПриИзменении(Элемент)
	
	УстановитьДоступныеЗначенияПодпериод(Элементы.ПодпериодXYZКлассификации, ПериодXYZКлассификации);
	
	Элементы.ДекорацияXYZКлассификацияОписание.Заголовок = СтрШаблон(НСтр("ru = 'По данным за период: %1.'"),
		ОбеспечениеКлиентСервер.ОписаниеНастройки(ПериодXYZКлассификации, КоличествоПериодовXYZКлассификации, ПодпериодXYZКлассификации));

КонецПроцедуры

&НаКлиенте
Процедура КоличествоПериодовXYZКлассификацииПриИзменении(Элемент)
	
	Элементы.ДекорацияXYZКлассификацияОписание.Заголовок = СтрШаблон(НСтр("ru = 'По данным за период: %1.'"),
		ОбеспечениеКлиентСервер.ОписаниеНастройки(ПериодXYZКлассификации, КоличествоПериодовXYZКлассификации, ПодпериодXYZКлассификации));
	
КонецПроцедуры

&НаКлиенте
Процедура ПодпериодXYZКлассификацииПриИзменении(Элемент)
	
	Элементы.ДекорацияXYZКлассификацияОписание.Заголовок = СтрШаблон(НСтр("ru = 'По данным за период: %1.'"),
		ОбеспечениеКлиентСервер.ОписаниеНастройки(ПериодXYZКлассификации, КоличествоПериодовXYZКлассификации, ПодпериодXYZКлассификации));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура OK(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		СохранитьПараметры();
		
		КодВозврата = Новый Структура;
		
		КодВозврата.Вставить("ИспользоватьКлассификациюПоВыручке", ИспользоватьКлассификациюПоВыручке);
		КодВозврата.Вставить("ИспользоватьКлассификациюПоВаловойПрибыли", ИспользоватьКлассификациюПоВаловойПрибыли);
		КодВозврата.Вставить("ИспользоватьКлассификациюПоКоличествуПродаж", ИспользоватьКлассификациюПоКоличествуПродаж);
		КодВозврата.Вставить("ПериодABCКлассификации", ПериодABCКлассификации);
		КодВозврата.Вставить("КоличествоПериодовABCКлассификации", КоличествоПериодовABCКлассификации);
		КодВозврата.Вставить("ПериодXYZКлассификации", ПериодXYZКлассификации);
		КодВозврата.Вставить("КоличествоПериодовXYZКлассификации", КоличествоПериодовXYZКлассификации);
		КодВозврата.Вставить("ПодпериодXYZКлассификации", ПодпериодXYZКлассификации);
		
		Закрыть(КодВозврата);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура УстановитьДоступныеЗначенияПодпериод(Элемент, ВыбранныйПериод)
	
	Элемент.СписокВыбора.Очистить();
		
	Если ЗначениеЗаполнено(ВыбранныйПериод) Тогда
		
		Для каждого Период Из Периоды Цикл
		
			Элемент.СписокВыбора.Добавить(Период.Значение);
			
			Если ВыбранныйПериод = Период.Значение Тогда
				
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьПараметры()
	
	// Запись констант осуществляется в привелигированном режиме.
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.ИспользоватьABCXYZКлассификациюПартнеровПоВыручке.Установить(ИспользоватьКлассификациюПоВыручке);
	Константы.ИспользоватьABCXYZКлассификациюПартнеровПоВаловойПрибыли.Установить(ИспользоватьКлассификациюПоВаловойПрибыли);
	Константы.ИспользоватьABCXYZКлассификациюПартнеровПоКоличествуПродаж.Установить(ИспользоватьКлассификациюПоКоличествуПродаж);
	Константы.ПериодABCКлассификацииПартнеров.Установить(ПериодABCКлассификации);
	Константы.КоличествоПериодовABCКлассификацииПартнеров.Установить(КоличествоПериодовABCКлассификации);
	Константы.ПериодXYZКлассификацииПартнеров.Установить(ПериодXYZКлассификации);
	Константы.КоличествоПериодовXYZКлассификацииПартнеров.Установить(КоличествоПериодовXYZКлассификации);
	Константы.ПодпериодXYZКлассификацииПартнеров.Установить(ПодпериодXYZКлассификации);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	// Выключение привелигированного режима.
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
