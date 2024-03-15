
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗагрузитьСписок(Отказ);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = СписокСозданныеДокументы.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокСозданныеДокументыКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗакрытьБезВопроса Тогда
		
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		Если ЗавершениеРаботы Тогда
			ТекстПредупреждения = НСтр("ru = 'Данные были изменены. Все изменения будут потеряны.'");
			Возврат;
		КонецЕсли;
		
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.ОК, НСтр("ru = 'Закрыть'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
		
		ТекстВопроса = НСтр("ru = 'Работа с созданными документами не была завершена. Закрыть форму?'");
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросОЗакрытии", ЭтотОбъект), ТекстВопроса, Кнопки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_АктВыполненныхРабот"
		Или ИмяСобытия = "Запись_ПередачаТоваровХранителю"
		Или ИмяСобытия = "Запись_РеализацияТоваровУслуг"
		Или ИмяСобытия = "Запись_ПриходныйКассовыйОрдер"
		Или ИмяСобытия = "Запись_ПоступлениеТоваровОтХранителя"
		Или ИмяСобытия = "Запись_ОтгрузкаТоваровСХранения" Тогда
		
		Элементы.СписокСозданныеДокументы.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокСозданныеДокументы);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокСозданныеДокументы, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокСозданныеДокументы);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура НазадЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	СписокОшибок = УдалитьСозданныеДокументы();
	Если ЗначениеЗаполнено(СписокОшибок) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(СписокОшибок);
	Иначе
		ЗакрытьБезВопроса = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УдалитьСозданныеДокументы()
	
	СсылкиНаУдаление = СписокДокументов.ВыгрузитьЗначения();
	
	МассивИсключений = Новый Массив();
	МассивИсключений.Добавить(Метаданные.РегистрыСведений.РеестрДокументов); 
	МассивИсключений.Добавить(Метаданные.РегистрыСведений.ЗаданияКРасчетуСебестоимости);
	МассивИсключений.Добавить(Метаданные.РегистрыСведений.ДанныеПервичныхДокументов);
	МассивИсключений.Добавить(Метаданные.РегистрыСведений.ЗаданияКЗакрытиюМесяца);
	МассивИсключений.Добавить(Метаданные.РегистрыСведений.ЗаданияКРаспределениюРасчетовСКлиентами);
	
	МассивИсключений.Добавить(Метаданные.Документы.РеализацияТоваровУслуг);
	
	ПолноеИмяСчетФактурыВыданный = УчетНДСУП.ПолноеИмяСчетФактурыВыданный();
	Если ЗначениеЗаполнено(ПолноеИмяСчетФактурыВыданный) Тогда
		ЧастиПолногоИмениСчетФактурыВыданный = СтрРазделить(ПолноеИмяСчетФактурыВыданный, ".");
		МассивИсключений.Добавить(Метаданные.Документы[ЧастиПолногоИмениСчетФактурыВыданный[1]]);
	КонецЕсли;
	СписокОшибок = ОбщегоНазначенияУТ.УдалитьДокументы(СсылкиНаУдаление, МассивИсключений);
	
	Элементы.СписокСозданныеДокументы.Обновить();
	
	Возврат СписокОшибок;
	
КонецФункции

&НаКлиенте
Процедура Назад(Команда)
	Кнопки = Новый СписокЗначений();
	Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Удалить документы'"));
	Кнопки.Добавить(КодВозвратаДиалога.Отмена);
	
	ТекстВопроса = НСтр("ru = 'Сформированные документы будут удалены.'");
	
	ПоказатьВопрос(Новый ОписаниеОповещения("НазадЗавершение", ЭтотОбъект), ТекстВопроса, Кнопки);
КонецПроцедуры

&НаКлиенте
Процедура Принять(Команда)
	ВопросНепроведенныеДокументы();
КонецПроцедуры

&НаКлиенте
Процедура Провести(Команда)
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.СписокСозданныеДокументы, Заголовок);
	ОбеспечениеВДокументахКлиент.ПроверитьЗапуститьФоновоеЗаданиеРаспределенияЗапасов();
КонецПроцедуры

&НаКлиенте
Процедура ОтменаПроведения(Команда)
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.СписокСозданныеДокументы, Заголовок);
	ОбеспечениеВДокументахКлиент.ПроверитьЗапуститьФоновоеЗаданиеРаспределенияЗапасов();
КонецПроцедуры

&НаКлиенте
Процедура СписокСозданныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСозданныеДокументыПриАктивизацииСтроки(Элемент)
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ЗагрузитьСписок(Отказ)
	
	ПараметрыСозданныхДокументов = ПродажиСервер.ПрочитатьДанныеИзБезопасногоХранилища("ФормаСозданныеДокументыПродажи");
	Если ТипЗнч(ПараметрыСозданныхДокументов) = Тип("Структура") Тогда
		СозданныеДокументы = ПараметрыСозданныхДокументов.Параметры.СозданныеДокументы;
	Иначе
		СозданныеДокументы = ПараметрыСозданныхДокументов;
	КонецЕсли;
	Если ЗначениеЗаполнено(СозданныеДокументы) Тогда
		ПродажиСервер.УдалитьДанныеИзБезопасногоХранилища("ФормаСозданныеДокументыПродажи");
	Иначе
		ВызватьИсключение НСтр("ru='Произошла исключительная ситуация при создании документов.'");
		Отказ = Истина;
	КонецЕсли;
	
	Для Каждого ТекСтрока Из СозданныеДокументы Цикл
		СписокДокументов.Добавить(ТекСтрока.Документ);
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокСозданныеДокументы,
		"Ссылка",
		СписокДокументов.ВыгрузитьЗначения(),
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы() 
	
	КоличествоДокументов = СписокДокументов.Количество();
	
	СклонениеСоздано = НСтр("ru = 'Создан, Создано, Создано'");
	Создано = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоДокументов, СклонениеСоздано);
	Создано = СтрЗаменить(Создано, КоличествоДокументов + " ", "");
	
	СклонениеДокументов = НСтр("ru = 'документ, документа, документов'");
	Документов = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоДокументов, СклонениеДокументов);
	
	Заголовок = Создано + " " + Документов;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОЗакрытии(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.ОК Тогда
		ВопросНепроведенныеДокументы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросНепроведенныеДокументы()
	Если ЕстьНепроведенныеДокументы() Тогда
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Да);
		Кнопки.Добавить(КодВозвратаДиалога.Нет);
		
		ТекстВопроса = НСтр("ru='Некоторые документы не были проведены. Вы уверены, что хотите оставить документы непроведенными?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросОЗакрытииНепроведенныеДокументы", ЭтотОбъект), ТекстВопроса, Кнопки);
	Иначе
		ЗакрытьБезВопроса = Истина;
		Оповестить("Принять_ФормаСозданныхДокументов",, ЭтаФорма);
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВопросОЗакрытииНепроведенныеДокументы(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		ЗакрытьБезВопроса = Истина;
		Оповестить("Принять_ФормаСозданныхДокументов",, ЭтаФорма);
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЕстьНепроведенныеДокументы() 
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	РеестрДокументов.Ссылка
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|ГДЕ
	|	НЕ РеестрДокументов.Проведен
	|	И РеестрДокументов.Ссылка В (&СписокДокументов)
	|");
	
	Запрос.УстановитьПараметр("СписокДокументов", СписокДокументов);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокСозданныеДокументы.Дата", "СписокСозданныеДокументыДата");
	
КонецПроцедуры

#КонецОбласти