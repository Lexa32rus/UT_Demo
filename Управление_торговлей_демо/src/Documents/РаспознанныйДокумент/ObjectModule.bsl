
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипДокумента <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ТипДокумента")
		Или ВариантОбработки <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ВариантОбработки") Тогда 
		
		РаспознаваниеДокументовСлужебный.ИзменитьПорядокРеквизитовРаспознаваемогоДокумента(ЭтотОбъект);
	КонецЕсли;
	
	НомерДокумента = РаспознаваниеДокументовСлужебныйКлиентСервер.ЗначениеРеквизитаДокумента(ЭтотОбъект, "НомерДокумента");
	ДатаДокумента = РаспознаваниеДокументовСлужебныйКлиентСервер.ЗначениеРеквизитаДокумента(ЭтотОбъект, "ДатаДокумента");
	СуммаДокумента = РаспознаваниеДокументовСлужебныйКлиентСервер.ЗначениеРеквизитаДокумента(ЭтотОбъект, "ИтогоВсего");
	
	Наименование = Документы.РаспознанныйДокумент.НаименованиеРаспознанногоДокумента(ЭтотОбъект);
	
	Если Не МобильноеПриложение.Пустая() Тогда
		УстановитьПривилегированныйРежим(Истина);
		Отправитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(МобильноеПриложение, "Наименование");
		Ответственный = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(МобильноеПриложение, "Ответственный");
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	ДатаПоследнегоИзменения = ТекущаяДатаСеанса();
	
	// Для оптимальной работы ЗаполненнаяТаблицаДокумента и СохранитьТаблицуДокумента модуля РаспознаваниеДокументовСлужебный
	РеквизитыТабличныхЧастей.Сортировать("НомерСтрокиТЧ");

	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.ИсходныеДанныеЗаданийРаспознаваниеДокументов.ИзменитьОтветственного(ЭтотОбъект);
		
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторыФайлов = РегистрыСведений.РезультатыОбработкиЗаданийРаспознаваниеДокументов
		.ПолучитьИдФайловПоИдРезультата(ИдентификаторРезультата);
	
	РегистрыСведений.ИсходныеДанныеЗаданийРаспознаваниеДокументов
		.УдалитьЗаписиПоИдФайлов(ИдентификаторыФайлов);
	
	РегистрыСведений.РезультатыОбработкиЗаданийРаспознаваниеДокументов
		.УдалитьЗаписиПоИдРезультата(ИдентификаторРезультата);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли