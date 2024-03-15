
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияВЕТИСПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект, "Номенклатура");
	
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,
		"Характеристика", "Объект.Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,
		"Серия", "Объект.Номенклатура");
	
	Если Не ЗначениеЗаполнено(Объект.ИсходныйКлючЗаписи) Тогда
		ПриСозданииЧтенииНаСервере();
		ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриВыбореНоменклатуры", ЭтотОбъект);
	
	СобытияФормВЕТИСКлиентПереопределяемый.ОбработкаВыбораНоменклатуры(ОписаниеОповещения, ВыбранноеЗначение,
		ИсточникВыбора);
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		СобытияФормВЕТИСКлиентПереопределяемый.ОбработкаВыбораСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение,
			ИсточникВыбора);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	НоменклатураПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СобытияФормВЕТИСКлиентПереопределяемый.ОткрытьФормуВыбораНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаПриИзменении(Элемент)
	
	ТекущиеДанные       = ДанныеЗаписиСтруктурой(Объект);
	ПараметрыЗаполнения = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	
	СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииХарактеристики(ЭтотОбъект, ТекущиеДанные, Неопределено,
		ПараметрыЗаполнения);
	
	ЗаполнитьЗначенияСвойств(Объект, ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = ДанныеЗаписиСтруктурой(Объект);
	
	СобытияФормВЕТИСКлиентПереопределяемый.НачалоВыбораХарактеристики(ЭтотОбъект, ТекущиеДанные, Элемент, ДанныеВыбора,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	СобытияФормВЕТИСКлиентПереопределяемый.ХарактеристикаСоздание(ЭтотОбъект, Неопределено, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СерияПриИзменении(Элемент)
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		ТекущиеДанные = ДанныеЗаписиСтруктурой(Объект);
		
		СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииСерии(ЭтотОбъект,
																ПараметрыУказанияСерий,
																ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьПодборСерий(Элемент.ТекстРедактирования, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область Серии

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "", СтандартнаяОбработка)
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		
		ИнтеграцияИСКлиент.ОткрытьПодборСерий(ЭтаФорма,, Текст, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект, "Характеристика", "ХарактеристикиИспользуются");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()

	ХарактеристикиИспользуются = ИнтеграцияИС.ПризнакИспользованияХарактеристик(Объект.Номенклатура);
	СерииИспользуются = ПризнакИспользованияСерий(Объект.Номенклатура);
	ПараметрыУказанияСерий = ИнтеграцияИС.ПараметрыУказанияСерийФормыОбъекта(Объект, РегистрыСведений.СоответствиеНоменклатурыВЕТИС);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПризнакИспользованияСерий(Номенклатура)
	
	Возврат ИнтеграцияИС.ПризнакИспользованияСерий(Номенклатура);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.ХарактеристикиИспользуются Тогда
		Элементы.Характеристика.Доступность    = Истина;
		Элементы.Характеристика.ПодсказкаВвода = "";
	Иначе
		Элементы.Характеристика.Доступность    = Ложь;
		Элементы.Характеристика.ПодсказкаВвода = НСтр("ru = '<характеристики не используются>'");
	КонецЕсли;
	
	Если Форма.СерииИспользуются Тогда
		Элементы.Серия.Доступность    = Истина;
		Элементы.Серия.ПодсказкаВвода = "";
	Иначе
		Элементы.Серия.Доступность    = Ложь;
		Элементы.Серия.ПодсказкаВвода = НСтр("ru = '<серии не используются>'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НоменклатураПриИзмененииНаСервере()
	
	ЗаполнениеСвойствПриИзмененииНоменклатуры();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнениеСвойствПриИзмененииНоменклатуры()
	
	Если Не ЗначениеЗаполнено(Объект.Номенклатура) Тогда
		ХарактеристикиИспользуются = Ложь;
		СерииИспользуются          = Ложь;
	Иначе
		ХарактеристикиИспользуются = ИнтеграцияИС.ПризнакИспользованияХарактеристик(Объект.Номенклатура);
		СерииИспользуются          = ПризнакИспользованияСерий(Объект.Номенклатура);
	КонецЕсли;
	
	ТекущиеДанные = ДанныеЗаписиСтруктурой(Объект);
	
	ПараметрыЗаполнения = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус = ПараметрыУказанияСерий <> Неопределено;
	
	СобытияФормВЕТИСПереопределяемый.ПриИзмененииНоменклатуры(ЭтотОбъект, ТекущиеДанные, Неопределено, ПараметрыЗаполнения,
		ПараметрыУказанияСерий);
	
	ЗаполнитьЗначенияСвойств(Объект, ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореНоменклатуры(Номенклатура, ДополнительныеПараметры) Экспорт
	
	Если Номенклатура = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Номенклатура = Номенклатура;
	
	НоменклатураПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДанныеЗаписиСтруктурой(Объект)
	
	ИменаСвойств = "Номенклатура, Характеристика, Серия, СтатусУказанияСерий, Артикул, ТипНоменклатуры, "
					+ "ХарактеристикиИспользуются, ЕдиницаИзмерения";
	
	ТекущиеДанные = Новый Структура(ИменаСвойств);
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, Объект);
	
	Возврат ТекущиеДанные;
	
КонецФункции

#КонецОбласти
