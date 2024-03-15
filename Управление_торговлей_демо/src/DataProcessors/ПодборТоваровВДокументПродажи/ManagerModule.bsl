#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСтатусУказанияСерииВСтроке(ВариантОбеспечения, Строка, ПараметрыУказанияСерий) Экспорт
	
	Если Не ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры
		Или Не ЗначениеЗаполнено(Строка.Номенклатура)
		Или Не ЗначениеЗаполнено(Строка.Склад)
		Или ПараметрыУказанияСерий.ЭтоЗаказ
			И ВариантОбеспечения <> ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить")
			И ВариантОбеспечения <> ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.СоСклада") Тогда
		Строка.СтатусУказанияСерий = 0;
		СтруктураСерия = Новый Структура("Серия", Справочники.СерииНоменклатуры.ПустаяСсылка());
		ЗаполнитьЗначенияСвойств(Строка, СтруктураСерия);
		Возврат;
	КонецЕсли;
	
	Склад = Строка.Склад;
	СтруктураСклады = Новый Структура;
	Если ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
		СтруктураСклады.Вставить(ПараметрыУказанияСерий.ИмяПоляСклад,Склад);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяПоляСкладОтправитель) Тогда
		СтруктураСклады.Вставить(ПараметрыУказанияСерий.ИмяПоляСкладОтправитель,Склад);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяПоляСкладПолучатель) Тогда
		СтруктураСклады.Вставить(ПараметрыУказанияСерий.ИмяПоляСкладПолучатель,Справочники.Склады.ПустаяСсылка());
	КонецЕсли;
	
	ТаблицаТоваров = Новый ТаблицаЗначений;
	ТаблицаТоваров.Колонки.Добавить("Номенклатура",Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаТоваров.Колонки.Добавить("Характеристика",Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаТоваров.Колонки.Добавить("Серия",Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	ТаблицаТоваров.Колонки.Добавить("ВариантОбеспечения",Новый ОписаниеТипов("ПеречислениеСсылка.ВариантыОбеспечения"));
	ТаблицаТоваров.Колонки.Добавить("Обособленно",Новый ОписаниеТипов("Булево"));
	ТаблицаТоваров.Колонки.Добавить(ПараметрыУказанияСерий.ИмяПоляКоличество,Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,3,ДопустимыйЗнак.Неотрицательный)));
	ТаблицаТоваров.Колонки.Добавить("Упаковка",Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
	ТаблицаТоваров.Колонки.Добавить("НомерСтроки",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,0,ДопустимыйЗнак.Неотрицательный)));
	Если ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
		ТаблицаТоваров.Колонки.Добавить(ПараметрыУказанияСерий.ИмяПоляСклад,Новый ОписаниеТипов("СправочникСсылка.Склады"));
	КонецЕсли;
	
	НоменклатураСервер.ДополнитьТаблицуКолонкамиПоПолямПараметровУказанияСерий(ПараметрыУказанияСерий, ТаблицаТоваров); // Здесь же СтатусУказанияСерий
	
	ТаблицаСерий = ТаблицаТоваров.Скопировать();
	
	НоваяСтрока = ТаблицаТоваров.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
	НоваяСтрока.НомерСтроки = 1;
	НоваяСтрока.ВариантОбеспечения = ВариантОбеспечения;
	
	ОбъектСтруктура = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаТоваров[0]);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ОбъектСтруктура, СтруктураСклады, Истина);
	
	Если Не ПараметрыУказанияСерий.ТоварВШапке Тогда
		ОбъектСтруктура.Вставить(ПараметрыУказанияСерий.ИмяТЧТовары, ТаблицаТоваров);
		ИсточникСтатусаСерий = ОбъектСтруктура[ПараметрыУказанияСерий.ИмяТЧТовары][0];
	Иначе
		ИсточникСтатусаСерий = ОбъектСтруктура;
	КонецЕсли;
	
	Если ПараметрыУказанияСерий.ИмяТЧСерии <> ПараметрыУказанияСерий.ИмяТЧТовары
		И ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяТЧСерии) Тогда
		ОбъектСтруктура.Вставить(ПараметрыУказанияСерий.ИмяТЧСерии, ТаблицаСерий);
	КонецЕсли;
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ОбъектСтруктура,ПараметрыУказанияСерий);
	
	Если ИсточникСтатусаСерий.СтатусУказанияСерий > 8 Тогда
		Строка.СтатусУказанияСерий = ИсточникСтатусаСерий.СтатусУказанияСерий;
	Иначе
		Строка.СтатусУказанияСерий = 0;
	КонецЕсли;
	
	Если Строка.СтатусУказанияСерий = 0 Тогда
		СтруктураСерия = Новый Структура("Серия", Справочники.СерииНоменклатуры.ПустаяСсылка());
		ЗаполнитьЗначенияСвойств(Строка, СтруктураСерия);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли