
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДатаНачалаРасчета 			= НачалоМесяца(Параметры.ДатаНачалаРасчета);
	ПериодРегистрации 			= НачалоМесяца(Параметры.ПериодРегистрации);
	РасшифровкаЗапретаИзменений = Параметры.РасшифровкаЗапретаИзменений; // ХранилищеЗначения
	РасшифровкаЗапретаИзменений = РасшифровкаЗапретаИзменений.Получить();
	
	Если НЕ ЗначениеЗаполнено(ДатаНачалаРасчета) ИЛИ НЕ ЗначениеЗаполнено(ПериодРегистрации)
	 ИЛИ НЕ ТипЗнч(РасшифровкаЗапретаИзменений) = Тип("ТаблицаЗначений") Тогда
		ВызватьИсключение НСтр("ru='Некорректный контекст открытия формы'");
	КонецЕсли;
	
	ЕстьДатыЗапрета     = Ложь;
	ЕстьУчетныеПолитики = Истина;
	ЕстьОрганизацииБезУчетнойПолитики = Ложь;
	
	// Заполним таблицу запретов из переданного параметра
	Для Каждого ТекСтр Из РасшифровкаЗапретаИзменений Цикл
		
		Если НЕ ЗначениеЗаполнено(ТекСтр.УчетнаяПолитика) Тогда
			ЕстьОрганизацииБезУчетнойПолитики = Истина;
		Иначе
			НачалоВеденияУчета = Макс(НачалоВеденияУчета, ТекСтр.УчетнаяПолитика);
		КонецЕсли;
		
		НоваяСтрока = ЗапретыИзменения.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтр);
		
		НоваяСтрока.ПервыйРазрешенныйПериод = Макс(ТекСтр.РегламентныеОперации, ТекСтр.БухгалтерскийУчет, ТекСтр.МеждународныйУчет);
		
		ЕстьДатыЗапрета   = ЕстьДатыЗапрета
			ИЛИ (НоваяСтрока.ПервыйРазрешенныйПериод > ДатаНачалаРасчета);
		ЕстьУчетныеПолитики = ЕстьУчетныеПолитики И НЕ ЕстьОрганизацииБезУчетнойПолитики
			И (НоваяСтрока.УчетнаяПолитика <= ДатаНачалаРасчета ИЛИ НЕ НоваяСтрока.ЕстьДвижения);
		
	КонецЦикла;
	
	// Настроим видимость элементов в зависимости от диагностированных проблем.
	Элементы.ЗапретыИзмененияПервыйРазрешенныйПериод.Видимость = ЕстьДатыЗапрета;
	Элементы.ФормаДатыЗапретаИзмененияДанных.Видимость 		   = ЕстьДатыЗапрета;
	Элементы.ЗапретыИзмененияУчетнаяПолитика.Видимость 		   = НЕ ЕстьУчетныеПолитики;
	
	// Установим заголовок формы.
	ПредставлениеПериода =
		РасчетСебестоимостиПротоколРасчета.ПредставлениеПериодаРасчета(ДатаНачалаРасчета)
		+ ?(ПериодРегистрации > ДатаНачалаРасчета,
				" - " + РасчетСебестоимостиПротоколРасчета.ПредставлениеПериодаРасчета(ПериодРегистрации),
				"");
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Расчет за период %1 невозможен'", ОбщегоНазначения.КодОсновногоЯзыка()),
		ПредставлениеПериода);
		
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
Процедура ЗапретыИзмененияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ЗапретыИзменения.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.Организация);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Запрет не задан.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияПервыйРазрешенныйПериод.Имя);
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.ПервыйРазрешенныйПериод");
	ОтборЭлемента.ПравоеЗначение = Дата(1,1,1);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Без запрета'", ОбщегоНазначения.КодОсновногоЯзыка()));
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);
	
	// Период запрещен для изменения.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияПервыйРазрешенныйПериод.Имя);
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияОрганизация.Имя);
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.ПервыйРазрешенныйПериод");
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ДатаНачалаРасчета");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Больше;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Красный);
	
	// Не задана учетная политика.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияУчетнаяПолитика.Имя);
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.УчетнаяПолитика");
	ОтборЭлемента.ПравоеЗначение = Дата(1,1,1);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Не указано'", ОбщегоНазначения.КодОсновногоЯзыка()));
	
	// Нет учетных политик в рассчитываемом периоде.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияУчетнаяПолитика.Имя);
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияОрганизация.Имя);
	
	ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.УчетнаяПолитика");
	ОтборЭлемента.ПравоеЗначение = Дата(1,1,1);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	
	ГруппаОтбора2 = ГруппаОтбора.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.УчетнаяПолитика");
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ДатаНачалаРасчета");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Больше;
	
	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.ЕстьДвижения");
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Красный);
	
	// Есть учетные политики в рассчитываемом периоде.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияУчетнаяПолитика.Имя);
	
	ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.УчетнаяПолитика");
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ДатаНачалаРасчета");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.УчетнаяПолитика");
	ОтборЭлемента.ПравоеЗначение = Дата(1,1,1);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);
	
КонецПроцедуры

#КонецОбласти
