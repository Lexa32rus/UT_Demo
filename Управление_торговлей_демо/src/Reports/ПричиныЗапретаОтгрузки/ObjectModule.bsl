#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - см. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Ложь;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	ФормаПараметры = ЭтаФорма.ФормаПараметры;
	
	Если ФормаПараметры.Свойство("Отбор") И ФормаПараметры.Отбор.Свойство("Договор") И ЗначениеЗаполнено(ФормаПараметры.Отбор.Договор) Тогда
		СоставПараметров = "
		|ОграничиватьСуммуЗадолженности,
		|ДопустимаяСуммаЗадолженности,
		|ЗапрещаетсяПросроченнаяЗадолженность";
		
		ДанныеДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ФормаПараметры.Отбор.Договор, СоставПараметров);
		ФормаПараметры.Отбор.Вставить("ДопустимаяСуммаЗадолженности", ДанныеДоговора.ДопустимаяСуммаЗадолженности);
		
		Если ДанныеДоговора.ОграничиватьСуммуЗадолженности И ДанныеДоговора.ЗапрещаетсяПросроченнаяЗадолженность Тогда
			КлючТекущегоВарианта = "ЗапретОтгрузкиПоКредитуИПросрочке";
		ИначеЕсли ДанныеДоговора.ОграничиватьСуммуЗадолженности Тогда
			КлючТекущегоВарианта = "ЗапретОтгрузкиПоКредиту";
		ИначеЕсли ДанныеДоговора.ЗапрещаетсяПросроченнаяЗадолженность Тогда
			КлючТекущегоВарианта = "ЗапретОтгрузкиПоПросрочке";
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("ДанныеПоСуммеПродажи") И Параметры.ДанныеПоСуммеПродажи.Свойство("СуммаВзаиморасчетов") Тогда
		ФормаПараметры.Отбор.Вставить("СуммаПродажи", Параметры.ДанныеПоСуммеПродажи.СуммаВзаиморасчетов);
	ИначеЕсли Параметры.Свойство("ДанныеПоСуммеПродажи") Тогда
		ФормаПараметры.Отбор.Вставить("СуммаПродажи", РассчитатьСуммуВзаиморасчетов(Параметры.ДанныеПоСуммеПродажи));
	КонецЕсли;
	
	Если Параметры.Свойство("ДанныеПоСуммеПродажи") И Параметры.ДанныеПоСуммеПродажи.Свойство("Дата") Тогда
		перДата = ?(Параметры.ДанныеПоСуммеПродажи.Дата > ТекущаяДатаСеанса(), КонецДня(Параметры.ДанныеПоСуммеПродажи.Дата), КонецДня(ТекущаяДатаСеанса()));
		ФормаПараметры.Отбор.Вставить("ДатаОтчета", перДата);       
	Иначе
		ФормаПараметры.Отбор.Вставить("ДатаОтчета", КонецДня(ТекущаяДатаСеанса())); 
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПриЗагрузкеПользовательскихНастроекНаСервере.
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	
	ПартнерыИКонтрагенты.УдалитьЭлементИзНастроекОтборовОтчета(Отчет.КомпоновщикНастроек, "Контрагент");
	
	НовыеПользовательскиеНастройкиКД = КомпоновщикНастроекФормы.ПользовательскиеНастройки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция РассчитатьСуммуВзаиморасчетов(СтруктураПараметров)
	
	СтруктураПараметров.Вставить("СуммаВзаиморасчетов");
	ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетов(СтруктураПараметров);
	Возврат СтруктураПараметров.СуммаВзаиморасчетов;
	
КонецФункции
#КонецОбласти

#КонецЕсли