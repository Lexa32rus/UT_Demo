
#Область ПрограммныйИнтерфейс

// АПК: 142-выкл обратная совместимость

// Выполнить операции на эквайринговом терминале.
// Если эквайринговый терминал не поддерживает печать квитанций на терминале, для печати подключается печатающее устройство.
// 
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - оповещение при завершении.
//  ИдентификаторКлиента - ФормаКлиентскогоПриложения -идентификатор формы.
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - идентификатор устройства, если неопределенно - будет предложен выбор.
//  ПараметрыОперации - Структура - параметры выполнения операции.
//  ДополнительныеПараметры - Структура - дополнительные команды.
//  ПечатающееУстройство - Неопределено - Печатающее устройство
Процедура НачатьВыполнениеОперацииНаЭквайринговомТерминале(ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства = Неопределено, ПараметрыОперации = Неопределено, ДополнительныеПараметры = Неопределено, ПечатающееУстройство = Неопределено) Экспорт
	
	ДанныеДляДополнения = МенеджерОборудованияКлиент.ПечатьСлипЧекаЭквайринговойОперации();
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		
		Для Каждого Элемент Из ДополнительныеПараметры Цикл
			ДанныеДляДополнения.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
		
	КонецЕсли;
	
	КонтекстОперации = КонтекстОперацииНаЭквайринговомТерминале();
	КонтекстОперации.ОповещениеПриЗавершении = ОповещениеПриЗавершении;
	КонтекстОперации.ИдентификаторКлиента    = ИдентификаторКлиента;   
	КонтекстОперации.ИдентификаторУстройства = ИдентификаторУстройства;
	КонтекстОперации.ПечатающееУстройство    = ПечатающееУстройство;
	КонтекстОперации.ПараметрыОперации       = ПараметрыОперации;
	КонтекстОперации.ДополнительныеПараметры = ДополнительныеПараметры; 
	КонтекстОперации.ТипТранзакции           = ПараметрыОперации.ТипТранзакции; 
	КонтекстОперации.ПодготовитьДанные       = Ложь; 
	КонтекстОперации.ОбработатьДанные        = Истина;
	КонтекстОперации.ОбработатьДанныеПриОшибке = Истина;
	КонтекстОперации.ИспользоватьПечатающееУстройство = Истина;     
	КонтекстОперации.ДополнительныеПараметры = ДанныеДляДополнения;
	ПараметрыОперации.Вставить("ПолныйСлипЧек", КонтекстОперации.ДополнительныеПараметры.ПолныйСлипЧек);
	
	ВыполнениеОперацииНаЭквайринговомТерминале(ИдентификаторУстройства, КонтекстОперации);
	
КонецПроцедуры

// Выполнить сверку итогов на эквайринговом терминале.
// Если эквайринговый терминал не поддерживает печать квитанций на терминале, для печати подключается печатающее устройство.
// 
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - оповещение при завершении.
//  ИдентификаторКлиента - ФормаКлиентскогоПриложения -идентификатор формы.
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - идентификатор устройства, если неопределенно - будет предложен выбор.
//  ПараметрыОперации - Структура - параметры выполнения операции.
//  ДополнительныеПараметры - Структура - дополнительные команды.
//  ПечатающееУстройство - Неопределено - Печатающее устройство
Процедура НачатьВыполнениеСверкиИтоговНаЭквайринговомТерминале(ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства = Неопределено, ПараметрыОперации = Неопределено, ДополнительныеПараметры = Неопределено, ПечатающееУстройство = Неопределено) Экспорт
	
	КонтекстОперации = КонтекстОперацииНаЭквайринговомТерминале();
	КонтекстОперации.ОповещениеПриЗавершении = ОповещениеПриЗавершении;
	КонтекстОперации.ИдентификаторКлиента    = ИдентификаторКлиента;   
	КонтекстОперации.ИдентификаторУстройства = ИдентификаторУстройства;
	КонтекстОперации.ПечатающееУстройство    = ПечатающееУстройство;
	КонтекстОперации.ПараметрыОперации       = ПараметрыОперации;
	КонтекстОперации.ДополнительныеПараметры = ДополнительныеПараметры; 
	КонтекстОперации.ТипТранзакции           = "Settlement"; 
	КонтекстОперации.ПодготовитьДанные       = Ложь; 
	КонтекстОперации.ОбработатьДанные        = Истина;
	КонтекстОперации.ИспользоватьПечатающееУстройство = Истина;
	
	ВыполнениеОперацииНаЭквайринговомТерминале(ИдентификаторУстройства, КонтекстОперации);
	
КонецПроцедуры

// АПК: 142-вкл

// Начать получение параметров карты.
//
// Параметры:
//   ОповещениеПриЗавершении - ОписаниеОповещения - оповещение при завершении.
//   ИдентификаторКлиента    - ФормаКлиентскогоПриложения -идентификатор формы.
//   ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - идентификатор устройства, если неопределенно - будет предложен выбор.
//   ПараметрыОперации       - Структура - параметры выполнения операции.
//   ДополнительныеПараметры - Структура - дополнительные команды.
//
Процедура НачатьПолучениеПараметровКарты(ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства = Неопределено, ПараметрыОперации = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	КонтекстОперации = КонтекстОперацииНаЭквайринговомТерминале();
	КонтекстОперации.ОповещениеПриЗавершении = ОповещениеПриЗавершении;
	КонтекстОперации.ИдентификаторКлиента    = ИдентификаторКлиента;   
	КонтекстОперации.ИдентификаторУстройства = ИдентификаторУстройства;
	КонтекстОперации.ПечатающееУстройство    = Неопределено;
	КонтекстОперации.ПараметрыОперации       = ПараметрыОперации;
	КонтекстОперации.ДополнительныеПараметры = ДополнительныеПараметры; 
	КонтекстОперации.ТипТранзакции           = "GetCardParametrs"; 
	КонтекстОперации.ПодготовитьДанные       = Ложь; 
	КонтекстОперации.ОбработатьДанные        = Ложь;
	КонтекстОперации.ИспользоватьПечатающееУстройство = Ложь;
	
	ВыполнениеОперацииНаЭквайринговомТерминале(ИдентификаторУстройства, КонтекстОперации);
	
КонецПроцедуры

// Начать выполнение аварийной отмена операции.
//
// Параметры:
//   ОповещениеПриЗавершении - ОписаниеОповещения - оповещение при завершении.
//   ИдентификаторКлиента    - ФормаКлиентскогоПриложения -идентификатор формы.
//   ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - идентификатор устройства, если неопределенно - будет предложен выбор.
//   ПараметрыОперации       - Структура - параметры выполнения операции.
//   ДополнительныеПараметры - Структура - дополнительные команды.
//
Процедура НачатьВыполнениеАварийнойОтменыОперации(ОповещениеПриЗавершении, ИдентификаторКлиента, ИдентификаторУстройства = Неопределено, ПараметрыОперации = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	КонтекстОперации = КонтекстОперацииНаЭквайринговомТерминале();
	КонтекстОперации.ОповещениеПриЗавершении = ОповещениеПриЗавершении;
	КонтекстОперации.ИдентификаторКлиента    = ИдентификаторКлиента;   
	КонтекстОперации.ИдентификаторУстройства = ИдентификаторУстройства;
	КонтекстОперации.ПечатающееУстройство    = Неопределено;
	КонтекстОперации.ПараметрыОперации       = ПараметрыОперации;
	КонтекстОперации.ДополнительныеПараметры = ДополнительныеПараметры; 
	КонтекстОперации.ТипТранзакции           = "EmergencyVoid"; 
	КонтекстОперации.ПодготовитьДанные       = Ложь; 
	КонтекстОперации.ОбработатьДанные        = Ложь;
	КонтекстОперации.ИспользоватьПечатающееУстройство = Ложь;
	
	ВыполнениеОперацииНаЭквайринговомТерминале(ИдентификаторУстройства, КонтекстОперации);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КонтекстОперацииНаЭквайринговомТерминале()
	
	КонтекстОперации = Новый Структура();
	КонтекстОперации.Вставить("ОповещениеПриЗавершении", Неопределено);
	КонтекстОперации.Вставить("ИдентификаторКлиента"   , Неопределено);   
	КонтекстОперации.Вставить("ИдентификаторУстройства", Неопределено);
	КонтекстОперации.Вставить("ПечатающееУстройство"   , Неопределено);
	КонтекстОперации.Вставить("ПараметрыОперации"      , Неопределено);
	КонтекстОперации.Вставить("ДополнительныеПараметры", Неопределено); 
	КонтекстОперации.Вставить("ТипТранзакции"          , Неопределено); 
	КонтекстОперации.Вставить("ПодготовитьДанные"        , Ложь); 
	КонтекстОперации.Вставить("ОбработатьДанные"         , Ложь);
	КонтекстОперации.Вставить("ОбработатьДанныеПриОшибке", Ложь);
	КонтекстОперации.Вставить("ИспользоватьПечатающееУстройство", Ложь);  
	КонтекстОперации.Вставить("Результат"     , Истина);
	Возврат КонтекстОперации;
	
КонецФункции

Процедура ВыполнениеОперацииНаЭквайринговомТерминале(ИдентификаторУстройства, КонтекстОперации)
	
	Если ИдентификаторУстройства = Неопределено Или ПустаяСтрока(ИдентификаторУстройства) Тогда
		ПоддерживаемыеТипыВО = Новый Массив();
		ПоддерживаемыеТипыВО.Добавить("ЭквайринговыйТерминал");       
		Оповещение = Новый ОписаниеОповещения("ВыполнениеОперацииНаЭквайринговомТерминалеЗавершение", ЭтотОбъект, КонтекстОперации);
		МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(Оповещение, ПоддерживаемыеТипыВО,
			НСтр("ru='Выберите эквайринговый терминал'"), 
			НСтр("ru='Эквайринговый терминал не подключен.'"),
			НСтр("ru='Эквайринговый терминал не выбран.'"));
	Иначе
		ВыполнениеОперацииНаЭквайринговомТерминалеЗавершение(КонтекстОперации, КонтекстОперации);
	КонецЕсли
	
КонецПроцедуры

Процедура ВыполнениеОперацииНаЭквайринговомТерминалеЗавершение(РезультатВыбора, КонтекстОперации) Экспорт
	
	Если РезультатВыбора.Результат Тогда 
		ПараметрыВыполнениеКоманды = МенеджерОборудованияКлиентСервер.ПараметрыВыполнениеКоманды(КонтекстОперации.ТипТранзакции, 
			ОборудованиеПлатежныеСистемыВызовСервера, КонтекстОперации.ДополнительныеПараметры, 
			КонтекстОперации.ПодготовитьДанные, КонтекстОперации.ОбработатьДанные, КонтекстОперации.ИспользоватьПечатающееУстройство, КонтекстОперации.ОбработатьДанныеПриОшибке);
		МенеджерОборудованияКлиент.НачатьВыполнениеКоманды(КонтекстОперации.ОповещениеПриЗавершении, КонтекстОперации.ИдентификаторКлиента, 
			РезультатВыбора.ИдентификаторУстройства, КонтекстОперации.ПараметрыОперации, ПараметрыВыполнениеКоманды, КонтекстОперации.ПечатающееУстройство);
	Иначе
		ВыполнитьОбработкуОповещения(КонтекстОперации.ОповещениеПриЗавершении, РезультатВыбора);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти  

