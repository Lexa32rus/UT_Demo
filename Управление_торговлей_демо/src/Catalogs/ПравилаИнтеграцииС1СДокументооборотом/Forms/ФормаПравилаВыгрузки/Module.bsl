#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ИмяРеквизитаОбъектаДО", ИмяРеквизитаОбъектаДО);
	Параметры.Свойство("ПредставлениеРеквизитаОбъектаДО", ПредставлениеРеквизитаОбъектаДО);
	Параметры.Свойство("ТипРеквизитаОбъектаДО", ТипРеквизитаОбъектаДО);
	Параметры.Свойство("Вариант", Вариант);
	Параметры.Свойство("ИмяРеквизитаОбъектаИС", ИмяРеквизитаОбъектаИС);
	Параметры.Свойство("ЗначениеРеквизитаДО", ЗначениеРеквизитаДО);
	Параметры.Свойство("ЗначениеРеквизитаДОID", ЗначениеРеквизитаДОID);
	Параметры.Свойство("ЗначениеРеквизитаДОТип", ЗначениеРеквизитаДОТип);
	Параметры.Свойство("ВычисляемоеВыражение", ВычисляемоеВыражение);
	Параметры.Свойство("ТипОбъектаДО", ТипОбъектаДО);
	Параметры.Свойство("ТипОбъектаИС", ТипОбъектаИС);
	Параметры.Свойство("Обновлять", Обновлять);
	Параметры.Свойство("ОбновлятьРодитель", ОбновлятьРодитель);
	Параметры.Свойство("ДополнительныйРеквизитДОID", ДополнительныйРеквизитДОID);
	Параметры.Свойство("ДополнительныйРеквизитДОТип", ДополнительныйРеквизитДОТип);
	Параметры.Свойство("Ключевой", Ключевой);
	Параметры.Свойство("ШаблонЗначение", ШаблонЗначение);
	Параметры.Свойство("ШаблонID", ШаблонID);
	Параметры.Свойство("ЗаполненВШаблоне", ЗаполненВШаблоне);
	Параметры.Свойство("Таблица", Таблица);
	Параметры.Свойство("Зависимый", Зависимый);
	Параметры.Свойство("ВидДокументаДО", ВидДокументаДО);
	
	РеквизитОбъекта = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.РеквизитОбъекта");
	УказанноеЗначение = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.УказанноеЗначение");
	ВыражениеНаВстроенномЯзыке =
		ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.ВыражениеНаВстроенномЯзыке");
	ИзШаблона = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.ИзШаблона");
	НеЗаполнять = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.ПустаяСсылка");
	
	Если ЗаполненВШаблоне Тогда
		
		СписокВариантов = Элементы.Вариант.СписокВыбора;
		СписокВариантов.Удалить(СписокВариантов.НайтиПоЗначению(НеЗаполнять));
		СписокВариантов.Добавить(ИзШаблона, НСтр("ru = 'Из шаблона'"));
			
		Элементы.СтраницыШаблон.ТекущаяСтраница = Элементы.СтраницаЗаполненВШаблоне;
			
		Если Параметры.ШаблонЗапрещаетИзменение = Истина Или ИмяРеквизитаОбъектаДО = "documentType" Тогда
			
			ШаблонЗапрещаетИзменение = Истина;
			
			Вариант = ИзШаблона;
			Элементы.Вариант.Доступность = Ложь;
			
			Если ИмяРеквизитаОбъектаДО = "documentType" Тогда
				ИнформационнаяНадпись = НСтр("ru = 'Вид документа выбран в шаблоне и не может быть изменен.'");
			Иначе
				ИнформационнаяНадпись = НСтр("ru = 'Шаблон запрещает изменение заданных в нем реквизитов.'");
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе // не заполнен в шаблоне
		
		Элементы.СтраницыШаблон.ТекущаяСтраница = Элементы.СтраницаНеЗаполненВШаблоне;
		
		Если ИмяРеквизитаОбъектаДО = "documentType" Тогда
			Вариант = УказанноеЗначение;
			Элементы.Вариант.Доступность = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	// Выберем вариант по умолчанию.
	Если Не ЗначениеЗаполнено(Вариант) Тогда
		
		Если Не ЗаполненВШаблоне Тогда
			Если ИмяРеквизитаОбъектаДО = "folder"
					Или ИмяРеквизитаОбъектаДО = "accessLevel"
					Или ИмяРеквизитаОбъектаДО = "activityMatter" Тогда
				Обновлять = Ложь;
			Иначе
				Обновлять = Истина;
			КонецЕсли;
		Иначе
			Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.ИзШаблона;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Зависимый Тогда
		Обновлять = ОбновлятьРодитель;
	КонецЕсли;
	
	// Настроим поле ввода для примитивных типов.
	Если ТипРеквизитаОбъектаДО.Количество() = 0 Тогда
		Элементы.Вариант.СписокВыбора.Удалить(Элементы.Вариант.СписокВыбора.НайтиПоЗначению(УказанноеЗначение));
		Элементы.ЗначениеРеквизитаДО.Видимость = Ложь;
	Иначе
		ПервыйТип = ТипРеквизитаОбъектаДО[0].Значение;
		Если ЗначениеРеквизитаДО = Неопределено Тогда
			
			Если ПервыйТип = "Число" Тогда
				ЗначениеРеквизитаДО = 0;
				
			ИначеЕсли ПервыйТип = "Дата" Тогда
				ЗначениеРеквизитаДО = Дата(1, 1, 1);
				
			ИначеЕсли ПервыйТип = "Булево" Тогда
				ЗначениеРеквизитаДО = Ложь;
				
			Иначе // строка или ссылочный тип ДО
				ЗначениеРеквизитаДО = "";
				
			КонецЕсли;
		КонецЕсли;
		
		Если ПервыйТип = "Число" Или ПервыйТип = "Дата" Тогда
			Элементы.ЗначениеРеквизитаДО.КнопкаРегулирования = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	// Ограничим выбор вариантов заполнения и флажка Ключевой.
	Если ИмяРеквизитаОбъектаДО = "documentType" Тогда
		Ключевой = Истина;
		Элементы.Ключевой.Доступность = Ложь;
		Элементы.Обновлять.Доступность = Ложь;
	Иначе
		Если Вариант = ВыражениеНаВстроенномЯзыке
			Или Вариант = РеквизитОбъекта
			Или Вариант = НеЗаполнять Тогда
			Элементы.Ключевой.Доступность = Ложь;
		Иначе
			Элементы.Ключевой.Доступность = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ДоступенФункционалОбмен = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3.CORP");
	Элементы.Обновлять.Видимость = ДоступенФункционалОбмен;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КлючевойПриИзменении(Элемент)
	
	Если Ключевой Тогда
		Если ЗаполненВШаблоне Тогда
			Если ШаблонЗапрещаетИзменение Тогда
				Вариант = ИзШаблона;
				УстановитьДоступность();
			КонецЕсли;
		Иначе
			Вариант = УказанноеЗначение;
			УстановитьДоступность();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПриИзменении(Элемент)
	
	Если Вариант = ВыражениеНаВстроенномЯзыке Или Вариант = РеквизитОбъекта
			Или (Вариант = НеЗаполнять И Не ЗаполненВШаблоне) Тогда
		Ключевой = Ложь;
		Элементы.Ключевой.Доступность = Ложь;
	Иначе
		Элементы.Ключевой.Доступность = Истина;
	КонецЕсли;
	
	Если Зависимый Тогда
		Обновлять = ОбновлятьРодитель;
	Иначе
		Обновлять =
			ДоступенФункционалОбмен
			И (Обновлять Или Вариант = РеквизитОбъекта)
			И Не (Вариант = НеЗаполнять)
			И Не (Вариант = УказанноеЗначение);
	КонецЕсли;
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяРеквизитаОбъектаИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьРеквизитОбъектаПотребителя();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеРеквизитаДОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ТипЗнч(ЗначениеРеквизитаДО) = Тип("Число")
		Или ТипЗнч(ЗначениеРеквизитаДО) = Тип("Дата")
		Или ТипЗнч(ЗначениеРеквизитаДО) = Тип("Булево") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ВыбратьЗначениеРеквизитаДО(Элементы.ЗначениеРеквизитаДО);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеРеквизитаДООбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь; 
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ЗначениеРеквизитаДО = ВыбранноеЗначение.name;
		ЗначениеРеквизитаДОID = ВыбранноеЗначение.ID;
		ЗначениеРеквизитаДОТип = ВыбранноеЗначение.type;
	Иначе
		ЗначениеРеквизитаДО = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеРеквизитаДОАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание,
		СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		ПервыйТип = ТипРеквизитаОбъектаДО[0].Значение;
		Если ПервыйТип = "Строка"
			Или ПервыйТип = "Булево"
			Или ПервыйТип = "Дата"
			Или ПервыйТип = "Число" Тогда
			Возврат;
		КонецЕсли;
			
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			ПервыйТип, ДанныеВыбора, Текст, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеРеквизитаДООкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных,
		СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		ПервыйТип = ТипРеквизитаОбъектаДО[0].Значение;
		Если ПервыйТип = "Строка"
			Или ПервыйТип = "Булево"
			Или ПервыйТип = "Дата"
			Или ПервыйТип = "Число" Тогда
			Возврат;
		КонецЕсли;
			
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			ПервыйТип, ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ЗначениеРеквизитаДООбработкаВыбора(
				Элементы.ЗначениеРеквизитаДО,
				ДанныеВыбора[0].Значение,
				СтандартнаяОбработка);
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВычисляемоеВыражениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьВычисляемоеВыражение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Вариант", Вариант);
	Результат.Вставить("ИмяРеквизитаОбъектаИС");
	Результат.Вставить("ЗначениеРеквизитаДО");
	Результат.Вставить("ЗначениеРеквизитаДОID");
	Результат.Вставить("ЗначениеРеквизитаДОТип");
	Результат.Вставить("ВычисляемоеВыражение");
	Результат.Вставить("Картинка");
	Результат.Вставить("Обновлять", Обновлять);
	Результат.Вставить("ЭтоДополнительныйРеквизитИС", ЭтоДополнительныйРеквизитИС);
	Результат.Вставить("ДополнительныйРеквизитИС", ДополнительныйРеквизитИС);
	Результат.Вставить("Ключевой", Ключевой);
	Результат.Вставить("ШаблонПредставление");
	
	Если Вариант = РеквизитОбъекта Тогда
		
		Результат.ИмяРеквизитаОбъектаИС = ИмяРеквизитаОбъектаИС;
		Результат.Картинка = 1;
		
	ИначеЕсли Вариант = УказанноеЗначение Тогда
		
		Результат.ЗначениеРеквизитаДО = ЗначениеРеквизитаДО;
		Результат.ЗначениеРеквизитаДОID = ЗначениеРеквизитаДОID;
		Результат.ЗначениеРеквизитаДОТип = ЗначениеРеквизитаДОТип;
		
		// Проверим, нет ли конфликта правила и шаблона.
		Если ЗаполненВШаблоне
				И ((ЗначениеЗаполнено(ЗначениеРеквизитаДОID) И ЗначениеРеквизитаДОID <> ШаблонID)
					Или (Не ЗначениеЗаполнено(ЗначениеРеквизитаДОID) И ЗначениеРеквизитаДО <> ШаблонЗначение)) Тогда
			
			Результат.Картинка = 4;
			Результат.ШаблонПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'шаблон: %1'"),
				ШаблонЗначение);
			
		Иначе // конфликта нет
			
			Результат.Картинка = 2;
			
		КонецЕсли;
		
	ИначеЕсли Вариант = ВыражениеНаВстроенномЯзыке Тогда
		
		Результат.ВычисляемоеВыражение = ВычисляемоеВыражение;
		Результат.Картинка = 3;
		
	ИначеЕсли Вариант = ИзШаблона Тогда
		
		Результат.ШаблонПредставление = ШаблонЗначение;
		Результат.Картинка = 5;
		
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьРеквизитОбъектаПотребителя()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъекта", ТипОбъектаИС);
	ПараметрыФормы.Вставить("ИмяРеквизитаОбъектаИС", ИмяРеквизитаОбъектаИС);
	ПараметрыФормы.Вставить("ПредставлениеРеквизитаОбъектаДО", ПредставлениеРеквизитаОбъектаДО);
	ПараметрыФормы.Вставить("Таблица", Таблица);
	ПараметрыФормы.Вставить("ЭтоТаблица", Ложь);
	
	ИмяФормыВыбора = "Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ВыборРеквизитаПотребителя";
	Оповещение = Новый ОписаниеОповещения("ВыбратьРеквизитОбъектаПотребителяЗавершение", ЭтотОбъект);
	
	ОткрытьФорму(ИмяФормыВыбора, ПараметрыФормы, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьРеквизитОбъектаПотребителяЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда 
		Результат.Свойство("Имя", ИмяРеквизитаОбъектаИС);
		Результат.Свойство("ЭтоДополнительныйРеквизитИС", ЭтоДополнительныйРеквизитИС);
		Результат.Свойство("ДополнительныйРеквизитИС", ДополнительныйРеквизитИС);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначениеРеквизитаДО(Элемент)
	
	Типы = ТипРеквизитаОбъектаДО;
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("ОписаниеТипа", ТипРеквизитаОбъектаДО);
	ПараметрыВыбора.Вставить("ТекстРедактирования", Элемент.ТекстРедактирования);
	
	Если Типы.Количество() = 1 Тогда 
		ВыбратьЗначениеРеквизитаДОЗавершение(Типы[0].Значение, ПараметрыВыбора);
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ВыбратьЗначениеРеквизитаДОЗавершение",
			ЭтотОбъект,
			ПараметрыВыбора);
		СписокТипов = Новый СписокЗначений;
		СписокТипов.ЗагрузитьЗначения(Типы);
		ПоказатьВыборИзСписка(ОписаниеОповещения, СписокТипов, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначениеРеквизитаДОЗавершение(ЗначениеТипа, ПараметрыВыбора) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьЗначениеРеквизитаДОЗавершениеВводаЗначения", ЭтотОбъект);
	
	Если ЗначениеТипа = "Строка" Тогда
		ЗначениеРеквизита = ПараметрыВыбора.ТекстРедактирования;
		ПоказатьВводСтроки(Оповещение, ЗначениеРеквизита,
			ПредставлениеРеквизитаОбъектаДО,, Истина);
		
	ИначеЕсли ЗначениеТипа = "Число" Тогда
		ЗначениеРеквизита = ЗначениеРеквизитаДО;
		ПоказатьВводЧисла(Оповещение, ЗначениеРеквизита,
			ПредставлениеРеквизитаОбъектаДО, 15, 5);
		
	ИначеЕсли ЗначениеТипа = "Дата" Тогда
		ЗначениеРеквизита = ЗначениеРеквизитаДО;
		ПоказатьВводДаты(Оповещение, ЗначениеРеквизита,
			ПредставлениеРеквизитаОбъектаДО,
			ЧастиДаты.Дата);
		
	ИначеЕсли ЗначениеТипа = "ДатаВремя" Тогда
		ЗначениеРеквизита = ЗначениеРеквизитаДО;
		ПоказатьВводДаты(Оповещение, ЗначениеРеквизита,
			ПредставлениеРеквизитаОбъектаДО,
			ЧастиДаты.ДатаВремя);
		
	ИначеЕсли ЗначениеТипа = "Время" Тогда
		ЗначениеРеквизита = ЗначениеРеквизитаДО;
		ПоказатьВводДаты(Оповещение, ЗначениеРеквизита,
			ПредставлениеРеквизитаОбъектаДО,
			ЧастиДаты.Время);
		
	ИначеЕсли ЗначениеТипа = "Булево" Тогда
		ЗначениеРеквизита = ЗначениеРеквизитаДО;
		ПоказатьВводЗначения(Оповещение, ЗначениеРеквизита,
			ПредставлениеРеквизитаОбъектаДО, Тип("Булево"));
		
	ИначеЕсли ЗначениеТипа = "DMParty" Тогда
		СписокДоступныхТипов = Новый СписокЗначений;
		
		СписокДоступныхТипов.Добавить(
			Новый Структура("XDTOClassName, Presentation", "DMOrganization", НСтр("ru = 'Организация'")));
		СписокДоступныхТипов.Добавить(
			Новый Структура("XDTOClassName, Presentation", "DMCorrespondent", НСтр("ru = 'Контрагент'")));
		СписокДоступныхТипов.Добавить(
			Новый Структура("XDTOClassName, Presentation", "DMUser", НСтр("ru = 'Пользователь'")));
		
		ЗаголовокФормы = НСтр("ru = 'Выбор типа значения'");
		
		ПараметрыФормы = Новый Структура("СписокДоступныхТипов, ЗаголовокФормы",
			СписокДоступныхТипов, ЗаголовокФормы);
		ОповещениеВыборТипа = Новый ОписаниеОповещения(
			"ВыборТипаЗавершение",
			ЭтотОбъект,
			Новый Структура("Оповещение", Оповещение));
		
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборОдногоТипаИзСоставногоТипа",
			ПараметрыФормы,,,,, ОповещениеВыборТипа);
		
	ИначеЕсли ЗначениеТипа = "DMPartyRowContact" Тогда
		СписокДоступныхТипов = Новый СписокЗначений;
		
		СписокДоступныхТипов.Добавить(
			Новый Структура("XDTOClassName, Presentation", "DMContactPerson", НСтр("ru = 'Контактное лицо'")));
		СписокДоступныхТипов.Добавить(
			Новый Структура("XDTOClassName, Presentation", "DMUser", НСтр("ru = 'Пользователь'")));
		
		ЗаголовокФормы = НСтр("ru = 'Выбор типа значения'");
		
		ПараметрыФормы = Новый Структура("СписокДоступныхТипов, ЗаголовокФормы",
			СписокДоступныхТипов, ЗаголовокФормы);
		ОповещениеВыборТипа = Новый ОписаниеОповещения(
			"ВыборТипаЗавершение",
			ЭтотОбъект,
			Новый Структура("Оповещение", Оповещение));
		
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборОдногоТипаИзСоставногоТипа",
			ПараметрыФормы,,,,, ОповещениеВыборТипа);
		
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТипОбъектаВыбора", ЗначениеТипа);
		Если ЗначениеЗаполнено(ЗначениеРеквизитаДОID)
			И ЗначениеТипа = ЗначениеРеквизитаДОТип Тогда
			ПараметрыФормы.Вставить("ВыбранныйЭлемент", ЗначениеРеквизитаДОID);
		КонецЕсли;
		Если ЗначениеТипа = "DMObjectPropertyValue" Тогда 
			Владелец = Новый Структура;
			Владелец.Вставить("ID", 	ДополнительныйРеквизитДОID);
			Владелец.Вставить("Type", 	ДополнительныйРеквизитДОТип);
			
			Отбор = Новый Структура;
			Отбор.Вставить("AdditionalProperty", Владелец);
			
			ПараметрыФормы.Вставить("Отбор", Отбор);
		КонецЕсли;
		
		ИмяФормыВыбора = "Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.ВыборИзСписка";
		ОткрытьФорму(ИмяФормыВыбора, ПараметрыФормы, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборТипаЗавершение(ВыбранныйТип, Параметры) Экспорт
	
	Если ВыбранныйТип = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаВыбора", ВыбранныйТип);
	Если ЗначениеЗаполнено(ЗначениеРеквизитаДОID) И ВыбранныйТип = ЗначениеРеквизитаДОТип Тогда
		ПараметрыФормы.Вставить("ВыбранныйЭлемент", ЗначениеРеквизитаДОID);
	КонецЕсли;
	
	ИмяФормыВыбора = "Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.ВыборИзСписка";
	ОткрытьФорму(
		ИмяФормыВыбора,
		ПараметрыФормы,
		ЭтотОбъект,,,,
		Параметры.Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначениеРеквизитаДОЗавершениеВводаЗначения(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат <> Неопределено Тогда
		Если ТипЗнч(Результат) = Тип("Структура") Тогда 
			ЗначениеРеквизитаДО = Результат.РеквизитПредставление;
			ЗначениеРеквизитаДОID = Результат.РеквизитID;
			ЗначениеРеквизитаДОТип = Результат.РеквизитТип;
		Иначе
			ЗначениеРеквизитаДО = Результат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВычисляемоеВыражение()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВычисляемоеВыражение", ВычисляемоеВыражение);
	ПараметрыФормы.Вставить("ТипВыражения", "ПравилоВыгрузки");
	ПараметрыФормы.Вставить("ТипОбъектаИС", ТипОбъектаИС);
	ПараметрыФормы.Вставить("ТипОбъектаДО", ТипОбъектаДО);
	ПараметрыФормы.Вставить("ЭтоТаблица", Ложь);
	ПараметрыФормы.Вставить("ВидДокументаДО", ВидДокументаДО);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьВычисляемоеВыражениеЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ВыражениеНаВстроенномЯзыке",
		ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВычисляемоеВыражениеЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда 
		ВычисляемоеВыражение = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступность()
	
	Элементы.ИмяРеквизитаОбъектаИС.Доступность = (Вариант = РеквизитОбъекта);
	Элементы.ИмяРеквизитаОбъектаИС.АвтоОтметкаНезаполненного = (Вариант = РеквизитОбъекта);
	Элементы.ИмяРеквизитаОбъектаИС.ОтметкаНезаполненного = (Вариант = РеквизитОбъекта) И Не ЗначениеЗаполнено(ИмяРеквизитаОбъектаИС);
	
	Элементы.ЗначениеРеквизитаДО.Доступность = (Вариант = УказанноеЗначение);
	Элементы.ЗначениеРеквизитаДО.АвтоОтметкаНезаполненного = (Вариант = УказанноеЗначение);
	Элементы.ЗначениеРеквизитаДО.ОтметкаНезаполненного = (Вариант = УказанноеЗначение) И Не ЗначениеЗаполнено(ЗначениеРеквизитаДО);
	
	Элементы.ВычисляемоеВыражение.Доступность = (Вариант = ВыражениеНаВстроенномЯзыке);
	Элементы.ВычисляемоеВыражение.АвтоОтметкаНезаполненного = (Вариант = ВыражениеНаВстроенномЯзыке);
	Элементы.ВычисляемоеВыражение.ОтметкаНезаполненного = (Вариант = ВыражениеНаВстроенномЯзыке) И Не ЗначениеЗаполнено(ВычисляемоеВыражение);
	
	РазрешеноОбновление = Не ШаблонЗапрещаетИзменение
		И (Вариант <> УказанноеЗначение)
		И (Вариант <> ИзШаблона);
	Элементы.Обновлять.Доступность = РазрешеноОбновление И Не Зависимый;
	
	Если Зависимый Тогда
		Обновлять = ОбновлятьРодитель;
	Иначе
		Обновлять = Обновлять И РазрешеноОбновление;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Вариант = РеквизитОбъекта Тогда 
		ПроверяемыеРеквизиты.Добавить("ИмяРеквизитаОбъектаИС");
		
	ИначеЕсли Вариант = УказанноеЗначение Тогда 
		ПроверяемыеРеквизиты.Добавить("ЗначениеРеквизитаДО");
		
	ИначеЕсли Вариант = ВыражениеНаВстроенномЯзыке Тогда 
		ПроверяемыеРеквизиты.Добавить("ВычисляемоеВыражение");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти