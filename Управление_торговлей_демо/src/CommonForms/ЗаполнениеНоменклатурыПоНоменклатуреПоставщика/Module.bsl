#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	ИдентификаторВызывающейФормы = Параметры.УникальныйИдентификатор;
	ТаблицаНоменклатурыПартнера = ПолучитьИзВременногоХранилища(Параметры.АдресТоваровВХранилище);
	
	Если Параметры.Свойство("ОтборТипНоменклатуры") Тогда
		ОтборТипНоменклатуры = Параметры.ОтборТипНоменклатуры;
		НовыйМассив = Новый Массив();
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ТипНоменклатуры", ОтборТипНоменклатуры);
		НовыйМассив.Добавить(НовыйПараметр);
		Элементы.ТоварыНоменклатура.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассив);
	Иначе
		ОтборТипНоменклатуры = Неопределено;
	КонецЕсли;
	
	// Подготовка номенклатуры поставщика для сопоставления
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Товары.НоменклатураПартнера КАК Ссылка,
		|	Товары.НомерСтроки            КАК НомерСтроки
		|ПОМЕСТИТЬ
		|	Товары
		|ИЗ
		|	&Товары КАК Товары
		|;
		|ВЫБРАТЬ
		|	Товары.Ссылка.Артикул      КАК АртикулПоиск,
		|	Товары.Ссылка.Наименование КАК НаименованиеПоиск,
		|	Товары.Ссылка              КАК Ссылка,
		|	Товары.НомерСтроки         КАК НомерСтроки
		|ИЗ
		|	Товары КАК Товары
		|");
		
	Запрос.УстановитьПараметр("Товары", ТаблицаНоменклатурыПартнера);
	ТаблицаНоменклатурыПартнера = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ТекСтрока Из ТаблицаНоменклатурыПартнера Цикл
		
		ТекСтрока.АртикулПоиск = СтрЗаменить(ТекСтрока.АртикулПоиск, " ", "");
		ТекСтрока.НаименованиеПоиск = СтрЗаменить(ТекСтрока.НаименованиеПоиск, " ", "");
		
	КонецЦикла;
	
	// Подготовка номенклатуры для сопоставления
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Номенклатура.Артикул        КАК АртикулПоиск,
		|	Номенклатура.Наименование   КАК НаименованиеПоиск,
		|	Номенклатура.Ссылка         КАК Ссылка
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	НЕ Номенклатура.ЭтоГруппа
		|	И НЕ Номенклатура.ПометкаУдаления
		|	И (&ЕстьОтборТипНоменклатуры = ЛОЖЬ
		|		ИЛИ Номенклатура.ТипНоменклатуры В (&ОтборТипНоменклатуры))
		|");
		
	Запрос.УстановитьПараметр("ОтборТипНоменклатуры", ОтборТипНоменклатуры);
	Запрос.УстановитьПараметр("ЕстьОтборТипНоменклатуры", ЗначениеЗаполнено(ОтборТипНоменклатуры));
	ТаблицаНоменклатуры = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ТекСтрока Из ТаблицаНоменклатуры Цикл
		
		ТекСтрока.АртикулПоиск = СтрЗаменить(ТекСтрока.АртикулПоиск, " ", "");
		ТекСтрока.НаименованиеПоиск = СтрЗаменить(ТекСтрока.НаименованиеПоиск, " ", "");
		
	КонецЦикла;
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	НоменклатураПартнера.НомерСтроки         КАК НомерСтроки,
		|	НоменклатураПартнера.АртикулПоиск        КАК АртикулПоиск,
		|	НоменклатураПартнера.НаименованиеПоиск   КАК НаименованиеПоиск,
		|	НоменклатураПартнера.Ссылка              КАК Ссылка
		|ПОМЕСТИТЬ НоменклатураПартнера
		|ИЗ
		|	&НоменклатураПартнера КАК НоменклатураПартнера
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	НаименованиеПоиск,
		|	АртикулПоиск
		|;
		|ВЫБРАТЬ
		|	Номенклатура.АртикулПоиск        КАК АртикулПоиск,
		|	Номенклатура.НаименованиеПоиск   КАК НаименованиеПоиск,
		|	Номенклатура.Ссылка              КАК Ссылка
		|ПОМЕСТИТЬ Номенклатура
		|ИЗ
		|	&Номенклатура КАК Номенклатура
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	НаименованиеПоиск,
		|	АртикулПоиск
		|;
		|ВЫБРАТЬ
		|	НоменклатураПартнера.НомерСтроки           КАК НомерСтроки,
		|	НоменклатураПартнера.Ссылка                КАК НоменклатураПартнера,
		|	НоменклатураПартнера.Ссылка.Номенклатура   КАК НоменклатураПартнераНоменклатура,
		|	НоменклатураПартнера.Ссылка.Характеристика КАК НоменклатураПартнераХарактеристика,
		|	НоменклатураПартнера.Ссылка.Упаковка       КАК НоменклатураПартнераУпаковка,
		|	Номенклатура.Ссылка                          КАК Номенклатура
		|ИЗ
		|	НоменклатураПартнера КАК НоменклатураПартнера
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	Номенклатура
		|ПО
		|	(НоменклатураПартнера.АртикулПоиск = Номенклатура.АртикулПоиск И НоменклатураПартнера.АртикулПоиск <> """")
		|	ИЛИ (НоменклатураПартнера.НаименованиеПоиск = Номенклатура.НаименованиеПоиск)
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|ИТОГИ ПО
		|	НомерСтроки
		|");
		
	Запрос.УстановитьПараметр("НоменклатураПартнера", ТаблицаНоменклатурыПартнера);
	Запрос.УстановитьПараметр("Номенклатура", ТаблицаНоменклатуры);
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Товары.Добавить();
		НоваяСтрока.НомерСтроки = Выборка.НомерСтроки;
		ВыборкаНоменклатура = Выборка.Выбрать();
		
		Если ВыборкаНоменклатура.Количество() = 1 Тогда
			ВыборкаНоменклатура.Следующий();
			НоваяСтрока.НоменклатураПартнера = ВыборкаНоменклатура.НоменклатураПартнера;
			Если ЗначениеЗаполнено(ВыборкаНоменклатура.НоменклатураПартнераНоменклатура) Тогда
				НоваяСтрока.Номенклатура = ВыборкаНоменклатура.НоменклатураПартнераНоменклатура;
				НоваяСтрока.Характеристика = ВыборкаНоменклатура.НоменклатураПартнераХарактеристика;
				НоваяСтрока.Упаковка = ВыборкаНоменклатура.НоменклатураПартнераУпаковка;
			ИначеЕсли ЗначениеЗаполнено(ВыборкаНоменклатура.Номенклатура) Тогда
				НоваяСтрока.Номенклатура = ВыборкаНоменклатура.Номенклатура;
				НоваяСтрока.КоличествоНоменклатурыДляВыбора = НоваяСтрока.КоличествоНоменклатурыДляВыбора + 1;
				ДобавитьНоменклатуруДляВыбора(ВыборкаНоменклатура.НоменклатураПартнера, ВыборкаНоменклатура.Номенклатура);
			КонецЕсли;
		Иначе
			Пока ВыборкаНоменклатура.Следующий() Цикл
				
				Если Не ЗначениеЗаполнено(НоваяСтрока.НоменклатураПартнера) Тогда
					НоваяСтрока.НоменклатураПартнера = ВыборкаНоменклатура.НоменклатураПартнера;
					Если ЗначениеЗаполнено(ВыборкаНоменклатура.НоменклатураПартнераНоменклатура) Тогда
						НоваяСтрока.Номенклатура = ВыборкаНоменклатура.НоменклатураПартнераНоменклатура;
						НоваяСтрока.Характеристика = ВыборкаНоменклатура.НоменклатураПартнераХарактеристика;
						НоваяСтрока.Упаковка = ВыборкаНоменклатура.НоменклатураПартнераУпаковка;
					КонецЕсли;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(ВыборкаНоменклатура.Номенклатура) Тогда
					НоваяСтрока.КоличествоНоменклатурыДляВыбора = НоваяСтрока.КоличествоНоменклатурыДляВыбора + 1;
					ДобавитьНоменклатуруДляВыбора(ВыборкаНоменклатура.НоменклатураПартнера, ВыборкаНоменклатура.Номенклатура);
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	ЗаполнитьПризнакХарактеристикиИспользуются = Новый Структура("Номенклатура", "ХарактеристикиИспользуются");
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		Товары,
		Новый Структура("ЗаполнитьПризнакХарактеристикиИспользуются",
			ЗаполнитьПризнакХарактеристикиИспользуются));
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если ПринудительноЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПеренестиВДокумент И Товары.Количество() > 0 Тогда
		
		Отказ = Истина;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект),
			НСтр("ru = 'Номенклатура не перенесена в документ. Перенести?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		
		Если ПроверитьЗаполнение() Тогда
			
			ПеренестиВДокумент = Истина;
			АдресТоваровВХранилище = ПоместитьВоВременноеХранилищеНаСервере();
			Закрыть(АдресТоваровВХранилище);
			
		КонецЕсли;
		
	ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		ПринудительноЗакрытьФорму = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ШаблонСообщения = НСтр("ru='Не заполнена колонка ""Характеристика"" в строке %НомерСтроки% списка ""Товары"".'");
	
	ТекНомерСтроки = 1;
	Для Каждого ТекСтрока Из Товары Цикл
		Если ЗначениеЗаполнено(ТекСтрока.Номенклатура) И ТекСтрока.ХарактеристикиИспользуются И Не ЗначениеЗаполнено(ТекСтрока.Характеристика) Тогда
			ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%НомерСтроки%", ТекНомерСтроки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекНомерСтроки, "Характеристика"),
				,
				Отказ);
		КонецЕсли;
		ТекНомерСтроки = ТекНомерСтроки + 1;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриАктивизацииЯчейки(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Если Элемент.ТекущийЭлемент.Имя = "ТоварыНоменклатура" И ТекущаяСтрока <> Неопределено Тогда 
		СписокВыбораНоменклатура = Элементы.ТоварыНоменклатура.СписокВыбора;
		СписокВыбораНоменклатура.Очистить();
		
		ТекущаяНоменклатураПартнера = Элементы.Товары.ТекущиеДанные.НоменклатураПартнера;
		НайденныеСтроки = НоменклатураДляВыбора.НайтиСтроки(Новый Структура("НоменклатураПартнера", ТекущаяНоменклатураПартнера));
		Для Каждого ТекСтрока Из НайденныеСтроки Цикл
			СписокВыбораНоменклатура.Добавить(ТекСтрока.Номенклатура, ТекСтрока.НоменклатураПартнера);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ПеренестиВДокумент = Истина;
		АдресТоваровВХранилище = ПоместитьВоВременноеХранилищеНаСервере();
		Закрыть(АдресТоваровВХранилище);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, , 
																		     "Товары.ХарактеристикиИспользуются");

КонецПроцедуры

&НаСервере
Процедура ДобавитьНоменклатуруДляВыбора(НоменклатураПартнера, Номенклатура)
	
	СтруктураПоиска = Новый Структура();
	СтруктураПоиска.Вставить("НоменклатураПартнера", НоменклатураПартнера);
	СтруктураПоиска.Вставить("Номенклатура", Номенклатура);
	НайденныеСтроки = НоменклатураДляВыбора.НайтиСтроки(СтруктураПоиска);
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		НоваяСтрока = НоменклатураДляВыбора.Добавить();
		НоваяСтрока.НоменклатураПартнера = НоменклатураПартнера;
		НоваяСтрока.Номенклатура = Номенклатура;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьВоВременноеХранилищеНаСервере()
	
	МассивСтрок = Новый Массив();
	Для Каждого ТекСтрока Из Товары Цикл
		Если ЗначениеЗаполнено(ТекСтрока.Номенклатура) Тогда
			МассивСтрок.Добавить(ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(Товары.Выгрузить(МассивСтрок, "НомерСтроки,Номенклатура,Характеристика,Упаковка"), ИдентификаторВызывающейФормы);
	
КонецФункции

#КонецОбласти
