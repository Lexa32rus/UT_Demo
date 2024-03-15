 
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ЗагрузитьВидыЦен();
	
	ТолькоВыделенныеСтроки = Параметры.ТолькоВыделенные;
	ПрименятьОкругление    = Истина;
	
	Элементы.ТолькоВыделенныеСтроки.Заголовок = НСтр("ru = 'Пересчитать строки документа'");

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ВариантИзмененияЦены	= 1;
	
	НастроитьВидимостьИДоступностьЭлементовФормы(ЭтаФорма)

КонецПроцедуры

&НаКлиенте
Процедура ВариантИзмененияЦеныПриИзменении(Элемент)
	
	НастроитьОтборСтрок(ЭтаФорма);
	НастроитьВидимостьИДоступностьЭлементовФормы(ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РазрешитьИзменятьФормулы(СпособЗаданияЦены)
	
	Возврат  Справочники.ВидыЦен.РазрешитьИзменятьФормулы(СпособЗаданияЦены); 
	
КонецФункции


&НаКлиенте
Процедура НастроитьОтборСтрок(Форма)
		
	ОтборСтрок = Новый ФиксированнаяСтруктура("ОтображатьСтроку", Истина);	
	
	Если Форма.ВариантИзмененияЦены=1 Тогда //изменить на процент
		
		Для Каждого Стр Из ВидыЦен Цикл
			Стр.ОтображатьСтроку = Стр.РазворачиватьПоВалютам;
			Если НЕ Стр.РазворачиватьПоВалютам Тогда 
				Стр.Пересчитать = Ложь;
			КонецЕсли;
		КонецЦикла;
		Форма.Элементы.ВидыЦен.ОтборСтрок = ОтборСтрок;
		
	ИначеЕсли Форма.ВариантИзмененияЦены=2 Тогда  //изменить на значение
		
		Для Каждого Стр Из ВидыЦен Цикл
			Стр.ОтображатьСтроку = Истина;
		КонецЦикла;

		Форма.Элементы.ВидыЦен.ОтборСтрок = Неопределено;	
		
	ИначеЕсли Форма.ВариантИзмененияЦены=3 Тогда //установить значение
		
		Для Каждого Стр Из ВидыЦен Цикл
			Стр.ОтображатьСтроку = Истина;
		КонецЦикла;
		
		Форма.Элементы.ВидыЦен.ОтборСтрок = Неопределено;
		
	ИначеЕсли Форма.ВариантИзмененияЦены=4 Тогда //округлить
		
		Для каждого Стр Из ВидыЦен Цикл
			Если Стр.СпособЗаданияЦены = ПредопределенноеЗначение("Перечисление.СпособыЗаданияЦен.Вручную")
				И Стр.РазворачиватьПоВалютам Тогда
				Стр.ОтображатьСтроку = Истина;
				Стр.Пересчитать = Ложь;
			Иначе
				Стр.ОтображатьСтроку = Ложь;
			КонецЕсли;		
		КонецЦикла;
		Форма.Элементы.ВидыЦен.ОтборСтрок = ОтборСтрок;
		
	ИначеЕсли Форма.ВариантИзмененияЦены=5 Тогда //расчитать по формуле
		
		Для каждого Стр Из ВидыЦен Цикл
			Если РазрешитьИзменятьФормулы(Стр.СпособЗаданияЦены) Тогда
				Стр.ОтображатьСтроку = Стр.РазворачиватьПоВалютам;
				Стр.Пересчитать = Ложь;
			Иначе
				Стр.ОтображатьСтроку = Ложь;
			КонецЕсли;
		КонецЦикла;
		Форма.Элементы.ВидыЦен.ОтборСтрок = ОтборСтрок;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьВидимостьИДоступностьЭлементовФормы(Форма)

	Форма.Элементы.ОК.Заголовок 				= НСтр("ru = 'Изменить'");
	
	Форма.Элементы.ВариантИзменения.Видимость 	= Истина;
	Форма.Элементы.ПрименятьОкругление.Видимость= Истина;
	Форма.Элементы.НадписьОкругление.Видимость	= Ложь;
	ОтборСтрок = Новый ФиксированнаяСтруктура("ОтображатьСтроку", Истина);
	
	Если Форма.ВариантИзмененияЦены=1 Тогда
		
		Форма.Элементы.ВариантИзменения.Заголовок 		= НСтр("ru = 'Изменять на процент по отношению к'");
		Форма.Заголовок 								= НСтр("ru = 'Изменить на процент'");
			
		Форма.Элементы.ВидыЦенПроцентИзменения.Видимость= Истина;
		Форма.Элементы.ВидыЦенСуммаИзменения.Видимость 	= Ложь;
		Форма.Элементы.ВидыЦенЦена.Видимость 			= Ложь;
		Форма.Элементы.ВидыЦенСсылкаВалютаЦены.Видимость= Ложь;
		Форма.Элементы.ВидыЦенФормула.Видимость= Ложь;
		Форма.Элементы.ВидыЦен.ОтборСтрок = ОтборСтрок;
		
	ИначеЕсли Форма.ВариантИзмененияЦены=2 Тогда
			
		Форма.Элементы.ВариантИзменения.Заголовок 		= НСтр("ru = 'Изменять на сумму по отношению к'");
		Форма.Заголовок 								= НСтр("ru = 'Изменить на сумму'");
			
		Форма.Элементы.ВидыЦенПроцентИзменения.Видимость= Ложь;
		Форма.Элементы.ВидыЦенСуммаИзменения.Видимость 	= Истина;
		Форма.Элементы.ВидыЦенЦена.Видимость 			= Ложь;
		Форма.Элементы.ВидыЦенСсылкаВалютаЦены.Видимость= Истина;
		Форма.Элементы.ВидыЦенФормула.Видимость= Ложь;
				
	ИначеЕсли Форма.ВариантИзмененияЦены=3 Тогда

		Форма.Заголовок 								= НСтр("ru = 'Установить цену'");
			
		Форма.Элементы.ВариантИзменения.Видимость 		= Ложь;
		Форма.Элементы.ПрименятьОкругление.Видимость	= Ложь;
		Форма.Элементы.ОК.Заголовок 					= НСтр("ru = 'Применить'");
		
		Форма.Элементы.ВидыЦенПроцентИзменения.Видимость= Ложь;
		Форма.Элементы.ВидыЦенСуммаИзменения.Видимость 	= Ложь;
		Форма.Элементы.ВидыЦенЦена.Видимость 			= Истина;
		Форма.Элементы.ВидыЦенСсылкаВалютаЦены.Видимость= Истина;
		Форма.Элементы.ВидыЦенФормула.Видимость= Ложь;
		
	ИначеЕсли Форма.ВариантИзмененияЦены=4 Тогда
		
		Форма.Заголовок 								= НСтр("ru = 'Округлить цены'");
		
		Форма.Элементы.НадписьОкругление.Видимость		= Истина;
			
		Форма.Элементы.ВариантИзменения.Видимость 		= Ложь;
		Форма.Элементы.ПрименятьОкругление.Видимость	= Ложь;
		Форма.Элементы.ОК.Заголовок 					= НСтр("ru = 'Округлить'");
		
		Форма.Элементы.ВидыЦенПроцентИзменения.Видимость= Ложь;
		Форма.Элементы.ВидыЦенСуммаИзменения.Видимость 	= Ложь;
		Форма.Элементы.ВидыЦенЦена.Видимость 			= Ложь;
		Форма.Элементы.ВидыЦенСсылкаВалютаЦены.Видимость= Ложь;
		Форма.Элементы.ВидыЦенФормула.Видимость= Ложь;
	
	ИначеЕсли Форма.ВариантИзмененияЦены=5 Тогда
			
		Форма.Заголовок 								= НСтр("ru = 'Рассчитать по формуле'");
		
		Форма.Элементы.ВариантИзменения.Видимость 		= Ложь;
		Форма.Элементы.ПрименятьОкругление.Видимость	= Ложь;
		Форма.Элементы.ОК.Заголовок 					= НСтр("ru = 'Рассчитать'");
		
		Форма.Элементы.ВидыЦенПроцентИзменения.Видимость= Ложь;
		Форма.Элементы.ВидыЦенСуммаИзменения.Видимость 	= Ложь;
		Форма.Элементы.ВидыЦенЦена.Видимость 			= Ложь;
		Форма.Элементы.ВидыЦенСсылкаВалютаЦены.Видимость= Ложь;
		Форма.Элементы.ВидыЦенФормула.Видимость= Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыФормыРедактированияЦены(ИмяЭлемента,Формула, ВидЦены)
	
	ВлияющиеЦены = ПолучитьТаблицуВлияющихЦен(ВидЦены);
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Формула", Формула);
	СтруктураВозврата.Вставить("ДеревоОперандов", ПоместитьВлияющиеВидыЦенВХранилище(ВлияющиеЦены));
	СтруктураВозврата.Вставить("ОперандыЗаголовок", НСтр("ru = 'Доступные виды цен'"));
	СтруктураВозврата.Вставить("Операторы", АдресХранилищаДереваОператоров);
	СтруктураВозврата.Вставить("ТипРезультата", Новый ОписаниеТипов("Число"));
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаКлиенте
Процедура ВидыЦенФормулаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ВидыЦен.ТекущиеДанные;
	ДополнительныеПараметры = новый Структура("ИмяЭлементаВозврата", "Формула");
	ОткрытьФорму("ОбщаяФорма.КонструкторФормул", 
		ПолучитьПараметрыФормыРедактированияЦены(Элемент.Имя, ТекущиеДанные["Формула"], ТекущиеДанные["Ссылка"]),
		 Элемент,,,, Новый ОписаниеОповещения("КонструкторФормулЗавершение", ЭтотОбъект,ДополнительныеПараметры),
		 РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
КонецПроцедуры


&НаКлиенте
Процедура КонструкторФормулЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    РезультатРедактирования = Результат;
    ТекущиеДанные = Элементы.ВидыЦен.ТекущиеДанные;
    
    Если РезультатРедактирования <> Неопределено Тогда    	
		ТекущиеДанные[ДополнительныеПараметры.ИмяЭлементаВозврата]	= РезультатРедактирования;	
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыЦен

&НаКлиенте
Процедура ВидыЦенПроцентИзмененияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВидыЦен.ТекущиеДанные;
	ТекущиеДанные.Пересчитать = Истина;
	
КонецПроцедуры


&НаКлиенте
Процедура ВидыЦенСуммаИзмененияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВидыЦен.ТекущиеДанные;
	ТекущиеДанные.Пересчитать = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ВидыЦенЦенаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВидыЦен.ТекущиеДанные;
	ТекущиеДанные.Пересчитать = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ВидыЦенФормулаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВидыЦен.ТекущиеДанные;
	ТекущиеДанные.Пересчитать = Истина;

КонецПроцедуры



#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
		
	МассивВидовЦен = Новый Массив();
	Для Каждого ВидЦены Из ВидыЦен Цикл
		Если ВидЦены.Пересчитать Тогда
			Если ВариантИзмененияЦены = 1 Тогда // изменить на процент
				МассивВидовЦен.Добавить(Новый Структура("ВидЦены, ПроцентИзменения", ВидЦены.Ссылка, ВидЦены.ПроцентИзменения));
			ИначеЕсли ВариантИзмененияЦены = 2 Тогда // изменить на сумму
				МассивВидовЦен.Добавить(Новый Структура("ВидЦены, СуммаИзменения, ВалютаЦены", ВидЦены.Ссылка, 
																							   ВидЦены.СуммаИзменения, 
																							   ВидЦены.ВалютаЦены));
			ИначеЕсли ВариантИзмененияЦены = 3 Тогда // установить цену
				МассивВидовЦен.Добавить(Новый Структура("ВидЦены, Цена, ВалютаЦены", ВидЦены.Ссылка, 
																					 ВидЦены.Цена, 
																					 ВидЦены.ВалютаЦены));
			ИначеЕсли ВариантИзмененияЦены = 4 Тогда // округлить
				МассивВидовЦен.Добавить(ВидЦены.Ссылка);
			ИначеЕсли ВариантИзмененияЦены = 5 Тогда // по формуле
				МассивВидовЦен.Добавить(Новый Структура("ВидЦены, Формула", ВидЦены.Ссылка, ВидЦены.Формула));
				ПрименятьОкругление = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Структура();
	Результат.Вставить("ИзменятьПоОтношениюКСтаройЦене", ВариантИзменения = 1);
	Результат.Вставить("ВидыЦен",                        МассивВидовЦен);
	Результат.Вставить("ТолькоВыделенныеСтроки",         ТолькоВыделенныеСтроки = 1);
	Результат.Вставить("ПрименятьОкругление",            ПрименятьОкругление);
	Результат.Вставить("ВариантИзмененияЦены",           ВариантИзмененияЦены);
	Результат.Вставить("ЗагрузкаСтарыхЦен",              ЗагрузкаСтарыхЦен);
	Результат.Вставить("ОкруглениеРучныхЦен",            ПрименятьОкругление);
	Результат.Вставить("ТолькоНезаполненные", Ложь);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыЦенВыбратьВсе(Команда)
	
	Для Каждого ВидЦены Из ВидыЦен Цикл
		Если Не ВидЦены.Пересчитать Тогда
			ВидЦены.Пересчитать = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыЦенИсключитьВсе(Команда)
	
	Для Каждого ВидЦены Из ВидыЦен Цикл
		Если ВидЦены.Пересчитать Тогда
			ВидЦены.Пересчитать = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Функция ПолучитьТаблицуИзМассиваСтрок(МассивСтрок)
	
	ТаблицаЗначений = Новый ТаблицаЗначений();
	ТаблицаЗначений.Колонки.Добавить("ВидЦены", Новый ОписаниеТипов("СправочникСсылка.ВидыЦен"));
	ТаблицаЗначений.Колонки.Добавить("Валюта", Новый ОписаниеТипов("СправочникСсылка.Валюты"));
	
	Для каждого Стр ИЗ МассивСтрок Цикл
		СтрНов = ТаблицаЗначений.Добавить();
		ЗаполнитьЗначенияСвойств(СтрНов, Стр);
	КонецЦикла;
	
	Возврат ТаблицаЗначений; 
	
КонецФункции

// Процедура загружает виды цен в таблицу ВидыЦен в порядке,
// соответвующим порядку в документе.
&НаСервере
Процедура ЗагрузитьВидыЦен()
	
	Запрос = Новый Запрос();
		
	Если Параметры.Свойство("МассивВалютПоВидамЦен") Тогда

		Запрос.Текст = "
		|ВЫБРАТЬ 
		|	ВидЦены КАК ВидЦены,
		|   Валюта КАК Валюта
		|ПОМЕСТИТЬ ТаблицаВалют
		|Из
		|&ТаблицаВалютПоВидамЦен КАК ТаблицаВалютПоВидамЦен
		|;
		|ВЫБРАТЬ
		|	ВидыЦен.Ссылка            КАК Ссылка,
		|	ТаблицаВалют.Валюта       КАК ВалютаЦены,
		|	ВидыЦен.СпособЗаданияЦены КАК СпособЗаданияЦены,
		|	ВидыЦен.Идентификатор КАК Идентификатор,
		|	ВЫБОР
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.Вручную)
		|		ТОГДА
		|			0
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.ЗаполнятьПоДаннымИБ)
		|		ТОГДА
		|			1
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.РассчитыватьПоФормуламОтДругихВидовЦен)
		|		ТОГДА
		|			2
		|	КОНЕЦ КАК ИндексКартинки
		|ИЗ
		|	ТаблицаВалют
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Справочник.ВидыЦен КАК ВидыЦен
		|		ПО (ТаблицаВалют.ВидЦены = ВидыЦен.Ссылка)
		|	ГДЕ
		|	ВидыЦен.Ссылка is not NULL";
		
		
		ТаблицаВалютПоВидамЦен = ПолучитьТаблицуИзМассиваСтрок(Параметры.МассивВалютПоВидамЦен);
		Запрос.УстановитьПараметр("ТаблицаВалютПоВидамЦен", ТаблицаВалютПоВидамЦен);	
		
	Иначе
		Запрос.Текст = "ВЫБРАТЬ
		|	ВидыЦен.Ссылка            КАК Ссылка,
		|	ВидыЦен.ВалютаЦены        КАК ВалютаЦены,
		|	ВидыЦен.СпособЗаданияЦены КАК СпособЗаданияЦены,
		|	ВидыЦен.Идентификатор КАК Идентификатор,
		|	ВЫБОР
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.Вручную)
		|		ТОГДА
		|			0
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.ЗаполнятьПоДаннымИБ)
		|		ТОГДА
		|			1
		|		КОГДА
		|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.РассчитыватьПоФормуламОтДругихВидовЦен)
		|		ТОГДА
		|			2
		|	КОНЕЦ КАК ИндексКартинки
		|ИЗ
		|	Справочник.ВидыЦен КАК ВидыЦен
		|ГДЕ
		|	ВидыЦен.Ссылка В(&МассивВидовЦен)";

		Запрос.УстановитьПараметр("МассивВидовЦен", Параметры.ВсеВидыЦен);
		
	КонецЕсли;	
	ТаблицаВидовЦен = Запрос.Выполнить().Выгрузить();
	
	// Для того, чтобы виды цен в списке были в том же порядке, как и на форме документа,
	// загружаем их вручную
	Для Каждого ВидЦен Из Параметры.ВсеВидыЦен Цикл
		
		Отбор = Новый Структура();
		Отбор.Вставить("Ссылка", ВидЦен); 
		НайденныйВидЦен = ТаблицаВидовЦен.НайтиСтроки(Отбор);	
		Инд = 0;
		Для каждого Стр Из НайденныйВидЦен Цикл		

			СтрокаВидаЦен                   = ВидыЦен.Добавить();
			СтрокаВидаЦен.Ссылка            = ВидЦен;
			СтрокаВидаЦен.СпособЗаданияЦены = Стр.СпособЗаданияЦены;
			СтрокаВидаЦен.Пересчитать       = Ложь;
			СтрокаВидаЦен.ИндексКартинки    = Стр.ИндексКартинки;
			СтрокаВидаЦен.Идентификатор = Стр.Идентификатор;
			СтрокаВидаЦен.ВалютаЦены = Стр.ВалютаЦены;
			Если  Инд = 0 Тогда
				СтрокаВидаЦен.ОтображатьСтроку = Истина;
				СтрокаВидаЦен.РазворачиватьПоВалютам = Истина;
			Иначе
				СтрокаВидаЦен.ОтображатьСтроку = Ложь;
				СтрокаВидаЦен.РазворачиватьПоВалютам = Ложь;
				СтрокаВидаЦен.Пересчитать = Ложь;
			КонецЕсли;	
			
			Инд = Инд + 1;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуВлияющихЦен(ВидЦены)
	
	Запрос = новый Запрос();
	Запрос.Параметры.Вставить("ВидЦены",ВидЦены);
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВидыЦенВлияющиеВидыЦен.ВлияющийВидЦен КАК Ссылка,
	|	ВидыЦенВлияющиеВидыЦен.ВлияющийВидЦен.Идентификатор КАК Идентификатор,
	|	ВидыЦенВлияющиеВидыЦен.ВлияющийВидЦен.ПометкаУдаления КАК ПометкаУдаления
	|ИЗ
	|	Справочник.ВидыЦен.ВлияющиеВидыЦен КАК ВидыЦенВлияющиеВидыЦен
	|ГДЕ
	|	ВидыЦенВлияющиеВидыЦен.Ссылка = &ВидЦены";
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПоместитьВлияющиеВидыЦенВХранилище(ВлияющиеЦены)

	Дерево = РаботаСФормулами.ПолучитьПустоеДеревоОперандов();

	Для Каждого СтрокаВидыЦены Из ВлияющиеЦены Цикл	
		СтрокаОперанда = РаботаСФормулами.НоваяСтрокаДереваОперанда(Дерево);
		СтрокаОперанда.Идентификатор = СтрокаВидыЦены.Идентификатор;
		СтрокаОперанда.Представление = Строка(СтрокаВидыЦены.Ссылка);
		СтрокаОперанда.ПометкаУдаления = СтрокаВидыЦены.ПометкаУдаления;
		СтрокаОперанда.ТипЗначения = Новый ОписаниеТипов("Число");
	КонецЦикла;
	
	АдресВХранилище = ПоместитьВоВременноеХранилище(Дерево, УникальныйИдентификатор);
	
	Возврат АдресВХранилище;
	
КонецФункции

#КонецОбласти

#КонецОбласти
