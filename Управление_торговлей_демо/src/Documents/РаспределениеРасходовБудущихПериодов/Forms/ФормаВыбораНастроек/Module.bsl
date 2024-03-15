
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПравилоУУ = Параметры.ПравилоРаспределенияРасходовУпр;
	ДокументУУ = Параметры.ДокументУпр;
	Элементы.ГруппаУправленческийУчет.Видимость = Параметры.Свойство("УправленческийУчет") И Параметры.УправленческийУчет;
	Элементы.ГруппаСоздатьУпрУчет.Видимость = НЕ ЗначениеЗаполнено(ДокументУУ);
	Элементы.ДокументУУ.Видимость = ЗначениеЗаполнено(ДокументУУ);

	ПравилоРУ = Параметры.ПравилоРаспределенияРасходовРегл;
	ДокументРУ = Параметры.ДокументРегл;
	Элементы.ГруппаРегламентированныйУчет.Видимость = Параметры.Свойство("РегламентированныйУчет") И Параметры.РегламентированныйУчет;
	Элементы.ГруппаСоздатьРеглУчет.Видимость = НЕ ЗначениеЗаполнено(ДокументРУ);
	Элементы.ДокументРУ.Видимость = ЗначениеЗаполнено(ДокументРУ);

	
	НастройкиСистемыЛокализация.УстановитьВидимостьЭлементовЛокализации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УправленческийУчетПриИзменении(Элемент)
	Если УправленческийУчет И НЕ ЗначениеЗаполнено(ПравилоРБП) Тогда
		ПравилоРБП = ПравилоУУ;
		РегламентированныйУчет = ПравилоРУ = ПравилоРБП;
		НалоговыйУчет = ПравилоНУ = ПравилоРБП;
	Иначе
		ПроверитьАктуальностьПравилаРБП();
	КонецЕсли;
	УправлениеЭлементамиФормы()
КонецПроцедуры

&НаКлиенте
Процедура РегламентированныйУчетПриИзменении(Элемент)
	Если РегламентированныйУчет И НЕ ЗначениеЗаполнено(ПравилоРБП) Тогда
		ПравилоРБП = ПравилоРУ;
		УправленческийУчет = ПравилоУУ = ПравилоРБП;
		НалоговыйУчет = ПравилоНУ = ПравилоРБП;
	Иначе
		ПроверитьАктуальностьПравилаРБП();
	КонецЕсли;
	УправлениеЭлементамиФормы()
КонецПроцедуры

&НаКлиенте
Процедура НалоговыйУчетПриИзменении(Элемент)
	Если НалоговыйУчет И НЕ ЗначениеЗаполнено(ПравилоРБП) Тогда
		ПравилоРБП = ПравилоНУ;
		УправленческийУчет = ПравилоУУ = ПравилоРБП;
		РегламентированныйУчет = ПравилоРУ = ПравилоРБП;
	Иначе
		ПроверитьАктуальностьПравилаРБП();
	КонецЕсли;
	УправлениеЭлементамиФормы()
КонецПроцедуры

&НаКлиенте
Процедура ПравилоУУПриИзменении(Элемент)
	УправлениеЭлементамиФормы()
КонецПроцедуры

&НаКлиенте
Процедура ПравилоРУПриИзменении(Элемент)
	УправлениеЭлементамиФормы()
КонецПроцедуры

&НаКлиенте
Процедура ПравилоНУПриИзменении(Элемент)
	УправлениеЭлементамиФормы()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	Результат = Новый Структура("ПравилоРБП", ПравилоРБП);
	Результат.Вставить("УправленческийУчет", УправленческийУчет);
	Результат.Вставить("РегламентированныйУчет", РегламентированныйУчет);
	Закрыть(Результат);
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаКлиенте
Процедура УправлениеЭлементамиФормы()
	
	Элементы.УправленческийУчет.Доступность = НЕ ЗначениеЗаполнено(ПравилоРБП) ИЛИ ПравилоУУ = ПравилоРБП;
	Элементы.ПравилоУУ.Доступность = НЕ УправленческийУчет;
	
	Элементы.РегламентированныйУчет.Доступность = НЕ ЗначениеЗаполнено(ПравилоРБП) ИЛИ ПравилоРУ = ПравилоРБП;
	Элементы.ПравилоРУ.Доступность = НЕ РегламентированныйУчет;
	
	Элементы.ФормаСоздать.Доступность = ЗначениеЗаполнено(ПравилоРБП);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьАктуальностьПравилаРБП()
	Если НЕ УправленческийУчет 
		И НЕ РегламентированныйУчет
	 Тогда
		ПравилоРБП = Справочники.ПравилаРаспределенияРасходов.ПустаяСсылка();
	КонецЕсли;
КонецПроцедуры



#КонецОбласти