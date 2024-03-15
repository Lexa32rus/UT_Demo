#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КлючЗаписи = Неопределено;
	ЭтоФормаЗаписи = Параметры.Свойство("Ключ", КлючЗаписи);
	Организация = Параметры.Организация;

	Элементы.Организация.Видимость = НЕ ЗначениеЗаполнено(Организация);
	Заголовок = Заголовок + " " + Строка(Организация);
	
	ИмяРегистра = Метаданные.РегистрыСведений.НастройкиСистемыНалогообложения.Имя;
	ТолькоПросмотр = НЕ ПравоДоступа("Изменение", Метаданные.РегистрыСведений.НастройкиСистемыНалогообложения);
	Если Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		СкопироватьЗаписьРегистра(Параметры.ЗначениеКопирования);
	Иначе
		ПрочитатьЗаписьРегистра(КлючЗаписи);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Возврат
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И ЗавершениеРаботы Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		ЗадатьВопросФормаМодифицирована("ВопросПередЗакрытиемЗавершение");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаИзмененияПриИзменении(Элемент)
	ТекстВопроса = НСтр("ru = 'Создать новую настройку на %1? Иначе будет изменен период существующей.'");
	ТекстВопроса = СтрШаблон(ТекстВопроса, Формат(НачалоМесяца(ДатаИзменения),"ДЛФ=D"));
	ПоказатьВопрос(Новый ОписаниеОповещения("ДатаИзмененияПриИзмененииЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура ДатаИзмененияПриИзмененииЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		ПрочитатьЗаписьРегистраПриИзменииРеквизита(,ДатаИзменения);
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		ПрочитатьЗаписьРегистраПриИзменииРеквизита(,ДатаИзменения, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Организация = Запись.Организация;
	ПрочитатьЗаписьРегистраПриИзменииРеквизита(,ДатаИзменения);
КонецПроцедуры

&НаКлиенте
Процедура ДатаПереходаНаУСНПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Запись.ДатаПереходаНаУСН) Тогда
		Запись.ДатаПереходаНаУСН = НачалоГода(Запись.ДатаПереходаНаУСН);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СистемаНалогообложенияПриИзменении(Элемент)
	УстановитьВидимостьЭлементов(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПрименяетсяПСНПриИзменении(Элемент)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ПрименяетсяАУСНПриИзменении(Элемент)
	УстановитьВидимостьЭлементов(ЭтотОбъект);
	УстановитьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	Если ЗаписатьИзменения(Истина) Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьИзменения();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПрочитатьЗаписьРегистраПриИзменииРеквизита(КлючЗаписи = Неопределено, ПериодЗаписи = Неопределено, СоздатьНовую = Ложь)
	Если НЕ Копирование Тогда
		ПрочитатьЗаписьРегистра(КлючЗаписи, ПериодЗаписи, СоздатьНовую);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПрочитатьЗаписьРегистра(КлючЗаписи = Неопределено, ПериодЗаписи = Неопределено, СоздатьНовую = Ложь)
	НастройкиНалоговУчетныхПолитик.ПрочитатьЗаписьРегистра(ЭтотОбъект, 
		ИмяРегистра,
		Организация,
		СоздатьНовую,
		КлючЗаписи,
		ПериодЗаписи);
	УстановитьВидимостьЭлементов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура СкопироватьЗаписьРегистра(ЗначениеКопирования)
	НастройкиНалоговУчетныхПолитик.СкопироватьУчетнуюПолитику(ЭтотОбъект, ЗначениеКопирования, ИмяРегистра);
	УстановитьВидимостьЭлементов(ЭтотОбъект);
	Копирование = Истина;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьПослеЗаписи()
	
	ПараметрыОповещения = Новый Структура("Организация, Период", Запись.Организация, Запись.Период);
	ИмяСобытия = "Запись_" + ИмяРегистра;
	Оповестить(ИмяСобытия, ПараметрыОповещения);
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьИзмененияНаСервере(Закрытие = Ложь)
	ЗаписьУспешна = НастройкиНалоговУчетныхПолитик.ЗаписатьИзменениеЗаписейРегистра(ЭтотОбъект, Закрытие);
	Возврат ЗаписьУспешна;
КонецФункции

&НаКлиенте
Функция ЗаписатьИзменения(Закрытие = Ложь)
	ОчиститьСообщения();
	ЗаписьУспешна = ЗаписатьИзмененияНаСервере(Закрытие);
	Если ЗаписьУспешна Тогда
		ОповеститьПослеЗаписи();
	КонецЕсли;
	Возврат ЗаписьУспешна;
КонецФункции

&НаКлиенте
Процедура ОписаниеИсторииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "ИсторияИзменений" Тогда
		Если Модифицированность Тогда
			ЗадатьВопросФормаМодифицирована("ОткрытьИсториюИзмененийПродолжение");
		Иначе
			ОткрытьИсториюИзменений();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопросФормаМодифицирована(ИмяОповещения)
	
	ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
	Оповещение = Новый ОписаниеОповещения(ИмяОповещения, ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		Если НЕ ЗаписатьИзменения(Истина) Тогда
			Возврат;
		КонецЕсли;
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсториюИзменений()
	ОткрытьФорму("РегистрСведений.НастройкиСистемыНалогообложения.Форма.РедактированиеИстории",
		Новый Структура("ТолькоПросмотр, Организация", ТолькоПросмотр, Организация),
		ЭтаФорма,,,,
		Новый ОписаниеОповещения("ОткрытьИсториюИзмененийЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсториюИзмененийПродолжение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Нет Тогда
		ОткрытьИсториюИзменений();
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		Если НЕ ЗаписатьИзменения(Ложь) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсториюИзмененийЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда
		ПрочитатьЗаписьРегистра(Результат);
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьЭлементов(Форма)
	
	Элементы = Форма.Элементы;
	ЮрФизЛицо = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Форма.Запись.Организация, "ЮрФизЛицо");
	ИП = ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ИндивидуальныйПредприниматель");
	
	ПрименяетсяУСН = Форма.Запись.СистемаНалогообложения = ПредопределенноеЗначение("Перечисление.СистемыНалогообложения.Упрощенная");
	Элементы.ДатаПереходаНаУСН.Видимость = ПрименяетсяУСН;
	Элементы.УведомлениеДата.Видимость = ПрименяетсяУСН;
	Элементы.УведомлениеНомер.Видимость = ПрименяетсяУСН;
	Элементы.ПрименяетсяАУСН.Видимость = ПрименяетсяУСН;
	Элементы.ПрименяетсяПСН.Видимость = ИП;
	ПрименяетсяАУСН = ПрименяетсяУСН И Форма.Запись.ПрименяетсяАУСН;
	Элементы.ПлательщикЕНП.Видимость = НЕ ПрименяетсяАУСН;
	Форма.ТолькоПросмотр = Форма.ТолькоПросмотр Или Форма.ОбособленноеПодразделение;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов()

	Элементы.ПрименяетсяАУСН.Доступность = Не Запись.ПрименяетсяПСН;
	Элементы.ПрименяетсяПСН.Доступность = Не Запись.ПрименяетсяАУСН;

КонецПроцедуры

#КонецОбласти