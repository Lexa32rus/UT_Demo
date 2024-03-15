#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущиеНастройкиСканирования = ИнтеграцияИСМПВызовСервера.НастройкиСканированияКодовМаркировки();
	
	НастроитьФорму();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ЗаполнитьТаблицуНастроек(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВладелецФормы = Неопределено Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru ='Открытие формы без владельца не предусмотренно'"));
		Возврат;
	КонецЕсли;
	
	ОбновитьКэшРанееВыбранных();
	УстановитьВидимостьДоступность(ЭтотОбъект);
	ЗаполнитьИтоговыеПредставления(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Закрыть(ВозвращаемоеЗначениеПриЗакрытии());
	
КонецПроцедуры

&НаКлиенте
Процедура Отметить(Команда)
	
	УстановитьСнятьОтметку();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметку(Команда)
	
	УстановитьСнятьОтметку(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОписанияОповещений

&НаКлиенте
Процедура ВыборЗначенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		ДополнительныеПараметры.ТекущиеДанные.Значение = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(
			ДополнительныеПараметры.ПредыдущееЗначение);
		ДополнительныеПараметры.ТекущиеДанные.ПредставлениеЗначения = ДополнительныеПараметры.ПредыдущееПредставление;
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.ТекущиеДанные.Отметка  = Истина;
	ДополнительныеПараметры.ТекущиеДанные.Значение = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(Результат);
	
	ПривестиЗначениеПоСтроке(ЭтотОбъект, ДополнительныеПараметры.ТекущиеДанные);
	
	Элементы.ТаблицаНастроек.ЗакончитьРедактированиеСтроки(Ложь);
	
	ЗаполнитьИсключенияТекущихНастроек(ЭтотОбъект);
	ЗаполнитьИтоговыеПредставления(ЭтотОбъект);
	ОбновитьКэшРанееВыбранных();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВариантОтображенияПриИзменении(Элемент)
	
	СменитьВариантОтображения();
	ЗаполнитьТаблицуНастроек();
	ОбновитьКэшРанееВыбранных();
	ЗаполнитьИтоговыеПредставления(ЭтотОбъект);
	УстановитьВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекПредставлениеЗначенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = ТаблицаНастроек.НайтиПоИдентификатору(Элементы.ТаблицаНастроек.ТекущаяСтрока);
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ТекущиеДанные",           ТекущиеДанные);
	ДополнительныеПараметры.Вставить("ПредыдущееЗначение",      ТекущиеДанные.Значение);
	ДополнительныеПараметры.Вставить("ПредыдущееПредставление", ТекущиеДанные.ПредставлениеЗначения);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Заголовок",           "");
	ПараметрыОткрытия.Вставить("ДоступныеЗначения",   Новый СписокЗначений());
	ПараметрыОткрытия.Вставить("ВыбранныеЗначения",   Новый СписокЗначений());
	ПараметрыОткрытия.Вставить("ЗначениеОграничения", ТекущиеДанные.ЗначениеОграничения);
	
	ВыборЗначенияЗавершение = Новый ОписаниеОповещения("ВыборЗначенияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Если ВариантОтображения = ВариантПоВидамПродукции() Тогда
		
		ДопустимыеВидыОпераций = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ДопустимыеВидыОпераций();
		Для Каждого ЭлементВидОперации Из ДопустимыеВидыОпераций Цикл
			
			Если ТекущиеДанные.Значение.НайтиПоЗначению(ЭлементВидОперации.Значение) = Неопределено Тогда
				ПараметрыОткрытия.ДоступныеЗначения.Добавить(ЭлементВидОперации.Значение, ЭлементВидОперации.Представление);
			Иначе
				ПараметрыОткрытия.ВыбранныеЗначения.Добавить(ЭлементВидОперации.Значение, ЭлементВидОперации.Представление);
			КонецЕсли;
			
		КонецЦикла;
		
		Если ТекущиеДанные.ОграничитьОтключение
			И ПараметрыОткрытия.ЗначениеОграничения.Количество() = 0 Тогда
			ПараметрыОткрытия.ЗначениеОграничения = ДопустимыеВидыОпераций;
		ИначеЕсли ОграниченияНастроек <> Неопределено
			И Не ОграниченияНастроек.РежимИсключения Тогда
			ДопустимыеВидыОперацийОтметки = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ДопустимыеВидыОпераций(ИмяПараметраНастройки);
			Для Каждого ЭлементСписка Из ДопустимыеВидыОпераций Цикл
				Если ДопустимыеВидыОперацийОтметки.НайтиПоЗначению(ЭлементСписка.Значение) = Неопределено Тогда
					ПараметрыОткрытия.ЗначениеОграничения.Добавить(ЭлементСписка.Значение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	Иначе
		
		Для Каждого ЭлементВидПродукции Из УчитываемыеВидыМаркируемойПродукции Цикл
			
			ВидПродукции = ЭлементВидПродукции.Значение;
			
			Если ТекущиеДанные.Значение.НайтиПоЗначению(ВидПродукции) = Неопределено Тогда
				ПараметрыОткрытия.ДоступныеЗначения.Добавить(ВидПродукции);
			Иначе
				ПараметрыОткрытия.ВыбранныеЗначения.Добавить(ВидПродукции);
			КонецЕсли;
			
		КонецЦикла;
		
		Если ТекущиеДанные.ОграничитьОтключение
			И ПараметрыОткрытия.ЗначениеОграничения.Количество() = 0 Тогда
			ПараметрыОткрытия.ЗначениеОграничения = УчитываемыеВидыМаркируемойПродукции;
		КонецЕсли;
		
	КонецЕсли;
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормаМножественногоВыбораИСМП",
		ПараметрыОткрытия,
		ЭтотОбъект,,,,
		ВыборЗначенияЗавершение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекПриИзменении(Элемент)
	
	ЗаполнитьИсключенияТекущихНастроек(ЭтотОбъект);
	ЗаполнитьИтоговыеПредставления(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекПредставлениеПриИзменении(Элемент)
	
	ТекущиеДанные = ТаблицаНастроек.НайтиПоИдентификатору(Элементы.ТаблицаНастроек.ТекущаяСтрока);
	ТекущиеДанные.Отметка = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = ТаблицаНастроек.НайтиПоИдентификатору(Элементы.ТаблицаНастроек.ТекущаяСтрока);
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекущиеДанные.Значение.Очистить();
		РанееВыбранноеЗначение = КэшРанееВыбранных.Получить(ВыбранноеЗначение);
		
		Если РанееВыбранноеЗначение <> Неопределено Тогда
			ТекущиеДанные.Значение = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(РанееВыбранноеЗначение.Значение);
			ТекущиеДанные.ПредставлениеЗначения = РанееВыбранноеЗначение.Представление;
			ДополнитьСтрокуДанныхИсключенями(ТекущиеДанные);
		КонецЕсли;
		
		ТекущиеДанные.Отметка = Истина;
		
	Иначе
		
		ТекущиеДанные.Значение.Очистить();
		ТекущиеДанные.ПредставлениеЗначения = "";
		
	КонецЕсли;
	
	ПривестиЗначениеПоСтроке(ЭтотОбъект, ТекущиеДанные);
	Элементы.ТаблицаНастроек.ЗакончитьРедактированиеСтроки(Ложь);
	
	ЗаполнитьИсключенияТекущихНастроек(ЭтотОбъект);
	ЗаполнитьИтоговыеПредставления(ЭтотОбъект);
	
	ЗаполнитьСписокВыбораЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ДополнитьСтрокуДанныхИсключенями(СтроткаДанных)
	
	Если Не СтроткаДанных.ОграничитьОтключение Тогда
		Возврат;
	КонецЕсли;
	
	Если СтроткаДанных.ЗначениеОграничения.Количество() = 0 Тогда
		СтроткаДанных.Значение.Очистить();
	Иначе
		
		Для Каждого ЭлементСписка Из СтроткаДанных.ЗначениеОграничения Цикл
			Если СтроткаДанных.Значение.НайтиПоЗначению(ЭлементСписка.Значение) = Неопределено Тогда
				СтроткаДанных.Значение.Добавить(
					ЭлементСписка.Значение,
					НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ПредставлениеНастройки(ЭлементСписка.Значение));
			КонецЕсли;
		КонецЦикла;
		
		СтроткаДанных.Значение.СортироватьПоПредставлению();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СменитьВариантОтображения()
	
	ГруппаНастроек = НастройкаПараметровСканированияСлужебныйКлиентСервер.ЗначениеГруппыНастроек(
		ТекущиеНастройкиСканирования,
		ИмяПараметраНастройки);
	
	ДопустимыеВидыОпераций = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ДопустимыеВидыОпераций(ИмяПараметраНастройки);
	
	Если ГруппаНастроек.ВариантОтображения = ВариантПоОперациям() Тогда
		
		ПолныйСписок          = УчитываемыеВидыМаркируемойПродукции.ВыгрузитьЗначения();
		ПолныйСписокВложенный = ДопустимыеВидыОпераций.ВыгрузитьЗначения();
		
	Иначе
		
		ПолныйСписок          = ДопустимыеВидыОпераций.ВыгрузитьЗначения();
		ПолныйСписокВложенный = УчитываемыеВидыМаркируемойПродукции.ВыгрузитьЗначения();
		
	КонецЕсли;
	
	ГруппаНастроек.Исключения = НастройкаПараметровСканированияСлужебныйКлиентСервер.ТранспонироватьЗначенияИсключения(
		ГруппаНастроек.Исключения,
		ПолныйСписок,
		ПолныйСписокВложенный);
	
	Если ОграниченияНастроек <> Неопределено Тогда
		
		ОграниченияНастроек.Исключения = НастройкаПараметровСканированияСлужебныйКлиентСервер.ТранспонироватьЗначенияИсключения(
			ОграниченияНастроек.Исключения,
			ПолныйСписок,
			ПолныйСписокВложенный);
		
	КонецЕсли;
	
	ГруппаНастроек.ВариантОтображения = ВариантОтображения;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПривестиЗначениеПоСтроке(Форма, ТекущиеДанные)
	
	ДанныеИзменены = Ложь;
	
	Если Форма.ВариантОтображения = ВариантПоВидамПродукции() Тогда
		ПолныйСписок = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ДопустимыеВидыОпераций();
	Иначе
		ПолныйСписок = Форма.УчитываемыеВидыМаркируемойПродукции;
	КонецЕсли;
	
	РазностьПолныхНастроек = ОбщегоНазначенияКлиентСервер.РазностьМассивов(
		ПолныйСписок.ВыгрузитьЗначения(),
		ТекущиеДанные.Значение.ВыгрузитьЗначения());
	
	Если ТекущиеДанные.Значение.Количество()
		И РазностьПолныхНастроек.Количество() = 0 Тогда
		
		ТекущиеДанные.Значение.Очистить();
		ДанныеИзменены = Истина;
		
	КонецЕсли;
	
	ДанныеСокращения = НастройкаПараметровСканированияСлужебныйКлиентСервер.ДанныеСокращения(ТекущиеДанные.Значение);
	ТекущиеДанные.ПредставлениеЗначения = ДанныеСокращения.Текст;
	
	Возврат ДанныеИзменены;
	
КонецФункции

&НаКлиенте
Процедура УстановитьСнятьОтметку(Отметка = Истина)
	
	Если ОграниченияНастроек <> Неопределено 
		И Не ОграниченияНастроек.РежимИсключения Тогда
		ЗначениеОтметкиОграничения = Ложь;
	Иначе
		ЗначениеОтметкиОграничения = Истина;
	КонецЕсли;
	
	Если Элементы.ТаблицаНастроек.ВыделенныеСтроки.Количество() > 1 Тогда
		Для Каждого ВыделеннаяСтрока Из Элементы.ТаблицаНастроек.ВыделенныеСтроки Цикл
			СтрокаТаблицы = ТаблицаНастроек.НайтиПоИдентификатору(ВыделеннаяСтрока);
			Если СтрокаТаблицы.ОграничитьОтключение Тогда
				СтрокаТаблицы.Отметка = ЗначениеОтметкиОграничения;
			Иначе
				СтрокаТаблицы.Отметка = Отметка;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Для Каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
			Если СтрокаТаблицы.ОграничитьОтключение Тогда
				СтрокаТаблицы.Отметка = ЗначениеОтметкиОграничения;
			Иначе
				СтрокаТаблицы.Отметка = Отметка;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ЗаполнитьИсключенияТекущихНастроек(ЭтотОбъект);
	ЗаполнитьИтоговыеПредставления(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбораЗначения()
	
	ДанныеВыбора = Элементы.ТаблицаНастроекПредставлениеЗначения.СписокВыбора;
	ДанныеВыбора.Очистить();
	
	ДанныеВыбора.Добавить("", ПредставлениеВсеЗначения(ВариантОтображения));
	
	Для Каждого Элемент Из ДанныеБыстрогоВыбораЗначения() Цикл
		ДанныеВыбора.Добавить(Элемент.Значение, Элемент.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКэшРанееВыбранных()
	
	ВременныйКэшРанееВыбранных = Новый Соответствие();
	
	Для Каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
		
		Если СтрокаТаблицы.Значение.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеСокращения = НастройкаПараметровСканированияСлужебныйКлиентСервер.ДанныеСокращения(СтрокаТаблицы.Значение);
		
		ЗначениеКэша = Новый Структура();
		ЗначениеКэша.Вставить("Значение",      СтрокаТаблицы.Значение);
		ЗначениеКэша.Вставить("Представление", ДанныеСокращения.Текст);
		
		ВременныйКэшРанееВыбранных.Вставить(ДанныеСокращения.Идентификатор, ЗначениеКэша);
		
	КонецЦикла;
	
	КэшРанееВыбранных = Новый ФиксированноеСоответствие(ВременныйКэшРанееВыбранных);
	
	ЗаполнитьСписокВыбораЗначения();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьИсключенияТекущихНастроек(Форма)
	
	ГруппаНастроек = НастройкаПараметровСканированияСлужебныйКлиентСервер.ЗначениеГруппыНастроек(
		Форма.ТекущиеНастройкиСканирования,
		Форма.ИмяПараметраНастройки);
	
	ГруппаНастроек.ВариантОтображения = Форма.ВариантОтображения;
	ГруппаНастроек.Исключения         = Новый Соответствие();
	
	Для Каждого СтрокаТаблицы Из Форма.ТаблицаНастроек Цикл
		
		Если Не СтрокаТаблицы.Отметка Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТаблицы.Значение.СортироватьПоЗначению();
		
		Если СтрокаТаблицы.Значение.Количество() Тогда
		
			Для Каждого Элемент Из СтрокаТаблицы.Значение Цикл
				НастройкаПараметровСканированияСлужебныйКлиентСервер.ДобавитьВИсключение(
					ГруппаНастроек,
					СтрокаТаблицы.Настройка,
					Элемент.Значение);
			КонецЦикла;
			
		Иначе
			
			НастройкаПараметровСканированияСлужебныйКлиентСервер.ДобавитьВИсключение(
				ГруппаНастроек,
				СтрокаТаблицы.Настройка);
			
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ВозвращаемоеЗначениеПриЗакрытии()
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ИмяПараметраНастройки", ИмяПараметраНастройки);
	ВозвращаемоеЗначение.Вставить("Настройки",             ТекущиеНастройкиСканирования);
	
	ГруппаНастроек = НастройкаПараметровСканированияСлужебныйКлиентСервер.ЗначениеГруппыНастроек(
		ТекущиеНастройкиСканирования,
		ИмяПараметраНастройки);
	
	Если ГруппаНастроек.ВариантОтображения <> ВариантПоВидамПродукции() Тогда
		
		ДопустимыеВидыОпераций    = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ДопустимыеВидыОпераций();
		ГруппаНастроек.Исключения = НастройкаПараметровСканированияСлужебныйКлиентСервер.ТранспонироватьЗначенияИсключения(
			ГруппаНастроек.Исключения,
			УчитываемыеВидыМаркируемойПродукции.ВыгрузитьЗначения(),
			ДопустимыеВидыОпераций.ВыгрузитьЗначения());
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаСервере
Процедура НастроитьФорму()
	
	ИмяПараметраНастройки = Параметры.ИмяПараметраНастройки;
	ОграниченияНастроек   = Параметры.ОграниченияНастроек;
	
	Если Не ЗначениеЗаполнено(ИмяПараметраНастройки) Тогда
		Возврат;
	КонецЕсли;
	
	ГруппаНастроек = НастройкаПараметровСканированияСлужебныйКлиентСервер.ЗначениеГруппыНастроек(
		ТекущиеНастройкиСканирования,
		ИмяПараметраНастройки);
	
	СинонимыНастроекСканирования = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ПредставленияПараметровСканирования();
	ЗначениеСинонима = СинонимыНастроекСканирования.Получить(ИмяПараметраНастройки);
	Если ЗначениеСинонима = Неопределено Тогда
		ЗначениеСинонима = НастройкаПараметровСканированияСлужебныйКлиентСервер.ПредставлениеПараметраБезСинонима(ИмяПараметраНастройки);
	КонецЕсли;
	Если ГруппаНастроек.РежимИсключения Тогда
		Заголовок = СтрШаблон(НСтр("ru ='%1 (исключения)'"), ЗначениеСинонима);
	Иначе
		Заголовок = ЗначениеСинонима;
	КонецЕсли;
	
	Элементы.ВариантОтображения.СписокВыбора.Добавить(ВариантПоВидамПродукции(), НСтр("ru ='Товарные группы'"));
	Элементы.ВариантОтображения.СписокВыбора.Добавить(ВариантПоОперациям(),      НСтр("ru ='Операции'"));
	
	УстановитьУсловноеОформление();
	
	Для Каждого ВидПродукции Из ИнтеграцияИСМПКлиентСерверПовтИсп.УчитываемыеВидыМаркируемойПродукции() Цикл
		УчитываемыеВидыМаркируемойПродукции.Добавить(ВидПродукции);
	КонецЦикла;
	
	Если УчитываемыеВидыМаркируемойПродукции.Количество() = 1 Тогда
		Элементы.ВариантОтображения.Видимость = Ложь;
		Элементы.ТаблицаНастроекПредставлениеЗначения.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ТаблицаНастроекПредставлениеЗначения.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ИСМППрисоединенныеФайлы");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	//
	Вариант = ВариантПоВидамПродукции();
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастроекПредставлениеЗначения.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастроекПредставлениеЗначения.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ВариантОтображения.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Вариант;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", ПредставлениеВсеЗначения(Вариант));
	
	//
	Вариант = ВариантПоОперациям();
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастроекПредставлениеЗначения.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастроекПредставлениеЗначения.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ВариантОтображения.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Вариант;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", ПредставлениеВсеЗначения(Вариант));
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаНастроек");
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастроекОтметка.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастроекОтметка.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНастроекОграничитьОтключение.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьИтоговыеПредставления(Форма)
	
	Элементы = Форма.Элементы;
	
	ГруппаНастроек = НастройкаПараметровСканированияСлужебныйКлиентСервер.ЗначениеГруппыНастроек(
		Форма.ТекущиеНастройкиСканирования,
		Форма.ИмяПараметраНастройки);
	
	ПредставленияИсключения = НастройкаПараметровСканированияСлужебныйКлиентСервер.ПредставленияИсключения(ГруппаНастроек,, Ложь);
	
	Если ЗначениеЗаполнено(ПредставленияИсключения.Полное) Тогда
		Элементы.ГруппаТаблицаНастроек.РасширеннаяПодсказка.Заголовок = ПредставленияИсключения.Полное;
		Элементы.ГруппаТаблицаНастроек.ОтображениеПодсказки           = ОтображениеПодсказки.ОтображатьСнизу;
	Иначе
		Элементы.ГруппаТаблицаНастроек.РасширеннаяПодсказка.Заголовок = "";
		Элементы.ГруппаТаблицаНастроек.ОтображениеПодсказки           = ОтображениеПодсказки.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуНастроек(Иницилизация = Ложь)
	
	ТаблицаНастроек.Очистить();
	
	Если Не ЗначениеЗаполнено(ИмяПараметраНастройки) Тогда
		Возврат;
	КонецЕсли;
	
	ГруппаНастроек = НастройкаПараметровСканированияСлужебныйКлиентСервер.ЗначениеГруппыНастроек(
		ТекущиеНастройкиСканирования,
		ИмяПараметраНастройки);
	
	ДопустимыеВидыОпераций = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ДопустимыеВидыОпераций().ВыгрузитьЗначения();
	ВариантОтображения     = ГруппаНастроек.ВариантОтображения;
	
	Если Иницилизация
		И ВариантОтображения <> ВариантПоВидамПродукции() Тогда
		
		ГруппаНастроек.Исключения = НастройкаПараметровСканированияСлужебныйКлиентСервер.ТранспонироватьЗначенияИсключения(
			ГруппаНастроек.Исключения,
			ДопустимыеВидыОпераций,
			УчитываемыеВидыМаркируемойПродукции.ВыгрузитьЗначения());
		
		Если ОграниченияНастроек <> Неопределено Тогда
			ОграниченияНастроек.Исключения = НастройкаПараметровСканированияСлужебныйКлиентСервер.ТранспонироватьЗначенияИсключения(
				ОграниченияНастроек.Исключения,
				ДопустимыеВидыОпераций,
				УчитываемыеВидыМаркируемойПродукции.ВыгрузитьЗначения());
		КонецЕсли;
		
	КонецЕсли;
	
	Если УчитываемыеВидыМаркируемойПродукции.Количество() = 1
		И ВариантОтображения <> ВариантПоОперациям() Тогда
		
		ГруппаНастроек.Исключения = НастройкаПараметровСканированияСлужебныйКлиентСервер.ТранспонироватьЗначенияИсключения(
			ГруппаНастроек.Исключения,
			ДопустимыеВидыОпераций,
			УчитываемыеВидыМаркируемойПродукции.ВыгрузитьЗначения());
		
		Если ОграниченияНастроек <> Неопределено Тогда
			ОграниченияНастроек.Исключения = НастройкаПараметровСканированияСлужебныйКлиентСервер.ТранспонироватьЗначенияИсключения(
				ОграниченияНастроек.Исключения,
				ДопустимыеВидыОпераций,
				УчитываемыеВидыМаркируемойПродукции.ВыгрузитьЗначения());
		КонецЕсли;
		
		ВариантОтображения = ВариантПоОперациям();
		
	КонецЕсли;
	
	ПеречитатьЗначенияИсключений = Ложь;
	
	Если ВариантОтображения = ВариантПоВидамПродукции() Тогда
		
		Для Каждого ЭлементВидПродукции Из УчитываемыеВидыМаркируемойПродукции Цикл
			
			ВидПродукции = ЭлементВидПродукции.Значение;
			
			НоваяСтрока                        = ТаблицаНастроек.Добавить();
			НоваяСтрока.Настройка              = ВидПродукции;
			НоваяСтрока.ПредставлениеНастройки = ВидПродукции;
			
			ИсключенияПоВидуПродукции = ГруппаНастроек.Исключения.Получить(ВидПродукции);
			
			Если ИсключенияПоВидуПродукции <> Неопределено Тогда
				
				НоваяСтрока.Отметка = Истина;
				НоваяСтрока.Значение.Очистить();
				
				Для Каждого КлючИЗначение Из ИсключенияПоВидуПродукции Цикл
					НоваяСтрока.Значение.Добавить(
						КлючИЗначение.Ключ,
						НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ПредставлениеНастройки(КлючИЗначение.Ключ));
				КонецЦикла;
				
				ДанныеИзменены = ПривестиЗначениеПоСтроке(ЭтотОбъект, НоваяСтрока);
				
				Если ДанныеИзменены Тогда
					ПеречитатьЗначенияИсключений = Истина;
				КонецЕсли;
				
			КонецЕсли;
			
			Если ОграниченияНастроек <> Неопределено Тогда
				
				ОграниченияПоВидуПродукции = ОграниченияНастроек.Исключения.Получить(ВидПродукции);
				
				Если ОграниченияПоВидуПродукции <> Неопределено Тогда
					
					НоваяСтрока.ОграничитьОтключение = Истина;
					
					Для Каждого КлючИЗначение Из ОграниченияПоВидуПродукции Цикл
						НоваяСтрока.ЗначениеОграничения.Добавить(КлючИЗначение.Ключ);
					КонецЦикла;
					
				КонецЕсли;
			
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Для Каждого ВидОперации Из ДопустимыеВидыОпераций Цикл
			
			НоваяСтрока                        = ТаблицаНастроек.Добавить();
			НоваяСтрока.Настройка              = ВидОперации;
			НоваяСтрока.ПредставлениеНастройки = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ПредставлениеНастройки(ВидОперации);
			
			ИсключенияПоВидуОперации = ГруппаНастроек.Исключения.Получить(ВидОперации);
			
			Если ИсключенияПоВидуОперации <> Неопределено Тогда
				
				НоваяСтрока.Отметка = Истина;
				НоваяСтрока.Значение.Очистить();
				
				Для Каждого КлючИЗначение Из ИсключенияПоВидуОперации Цикл
					НоваяСтрока.Значение.Добавить(КлючИЗначение.Ключ, СокрЛП(КлючИЗначение.Ключ));
				КонецЦикла;
				
				ДанныеИзменены = ПривестиЗначениеПоСтроке(ЭтотОбъект, НоваяСтрока);
				
				Если ДанныеИзменены Тогда
					ПеречитатьЗначенияИсключений = Истина;
				КонецЕсли;
				
			КонецЕсли;
			
			Если ОграниченияНастроек <> Неопределено Тогда
				
				ОграниченияПоВидуОперации = ОграниченияНастроек.Исключения.Получить(ВидОперации);
				
				Если ОграниченияПоВидуОперации <> Неопределено Тогда
					
					НоваяСтрока.ОграничитьОтключение = Истина;
					
					Для Каждого КлючИЗначение Из ОграниченияПоВидуОперации Цикл
						НоваяСтрока.ЗначениеОграничения.Добавить(КлючИЗначение.Ключ);
					КонецЦикла;
					
				КонецЕсли;
			
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ТаблицаНастроек.Сортировать("ПредставлениеНастройки");
	
	Если ПеречитатьЗначенияИсключений Тогда
		ЗаполнитьИсключенияТекущихНастроек(ЭтотОбъект);
		ЗаполнитьИтоговыеПредставления(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоступность(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.ВариантОтображения = ВариантПоВидамПродукции() Тогда
		
		Элементы.ТаблицаНастроекГруппаСОтметкой.Заголовок       = НСтр("ru ='Товарная группа'");
		Элементы.ТаблицаНастроекПредставлениеЗначения.Заголовок = НСтр("ru ='Операция'");
		
	Иначе
		
		Элементы.ТаблицаНастроекГруппаСОтметкой.Заголовок       = НСтр("ru ='Операция'");
		Элементы.ТаблицаНастроекПредставлениеЗначения.Заголовок = НСтр("ru ='Товарная группа'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДанныеБыстрогоВыбораЗначения()
	
	ВозвращаемоеЗначение = Новый СписокЗначений();
	НастройкиСоЗначением = Новый Соответствие();
	
	Для Каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
		
		Если СтрокаТаблицы.Значение.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеСокращения = НастройкаПараметровСканированияСлужебныйКлиентСервер.ДанныеСокращения(
			СтрокаТаблицы.Значение, 2);
		
		НастрокиПоИдентификатору = НастройкиСоЗначением.Получить(ДанныеСокращения.Идентификатор);
		Если НастрокиПоИдентификатору = Неопределено Тогда
			НастрокиПоИдентификатору = Новый СписокЗначений();
			НастройкиСоЗначением.Вставить(ДанныеСокращения.Идентификатор, НастрокиПоИдентификатору);
		КонецЕсли;
		
		НастрокиПоИдентификатору.Добавить(СтрокаТаблицы.Настройка, СтрокаТаблицы.ПредставлениеНастройки);
		
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из КэшРанееВыбранных Цикл
		
		ТекстВыбранныхНастроек    = "";
		НастройкиПоИдентификатору = НастройкиСоЗначением.Получить(КлючИЗначение.Ключ);
		
		Если НастройкиПоИдентификатору <> Неопределено Тогда
			НастройкиПоИдентификатору.СортироватьПоПредставлению();
			ДанныеСокращения = НастройкаПараметровСканированияСлужебныйКлиентСервер.ДанныеСокращения(
				НастройкиПоИдентификатору, 1);
			ТекстВыбранныхНастроек = СтрШаблон("%1(%2)", " ", ДанныеСокращения.Текст);
		
			ВозвращаемоеЗначение.Добавить(
				КлючИЗначение.Ключ,
				СтрШаблон("%1%2", КлючИЗначение.Значение.Представление, ТекстВыбранныхНастроек));
			
		КонецЕсли;
		
	КонецЦикла;
	
	ВозвращаемоеЗначение.СортироватьПоПредставлению();
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВариантПоВидамПродукции()
	Возврат НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ВариантОтображенияПоВидамПродукции();
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВариантПоОперациям()
	Возврат  НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ВариантОтображенияПоОперациям();
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеВсеЗначения(Вариант)
	
	Если Вариант = ВариантПоВидамПродукции() Тогда
		Возврат НСтр("ru ='<Все операции>'");
	Иначе
		Возврат НСтр("ru ='<Все товарные группы>'");
	КонецЕсли;
	
КонецФункции

#КонецОбласти
