
#Область ПрограммныйИнтерфейс

// Определяет список планов обмена, которые используют функционал подсистемы обмена данными.
//
// см. ОбменДаннымиПереопределяемый.ПолучитьПланыОбмена()
//
Процедура ПолучитьПланыОбмена(ПланыОбменаПодсистемы) Экспорт
	
	//++ Локализация
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.Полный);


	//-- Локализация
	
КонецПроцедуры

// Обработчик регистрации изменений для начальной выгрузки данных.
// 
// см. ОбменДаннымиПереопределяемый.РегистрацияИзмененийНачальнойВыгрузкиДанных()
//
Процедура РегистрацияИзмененийНачальнойВыгрузкиДанных(Знач Получатель, СтандартнаяОбработка, Отбор) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

// Обработчик при выгрузке данных.
// см. ОбменДаннымиПереопределяемый.ПриВыгрузкеДанных()
Процедура ПриВыгрузкеДанных(СтандартнаяОбработка,
								Получатель,
								ИмяФайлаСообщения,
								ДанныеСообщения,
								КоличествоЭлементовВТранзакции,
								ИмяСобытияЖурналаРегистрации,
								КоличествоОтправленныхОбъектов) Экспорт
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры


// Обработчик при загрузке данных.
// см. ОбменДаннымиПереопределяемый.ПриЗагрузкеДанных
Процедура ПриЗагрузкеДанных(СтандартнаяОбработка,
								Отправитель,
								ИмяФайлаСообщения,
								ДанныеСообщения,
								КоличествоЭлементовВТранзакции,
								ИмяСобытияЖурналаРегистрации,
								КоличествоПолученныхОбъектов) Экспорт
	//++ Локализация


	//-- Локализация
	
КонецПроцедуры

// Получает доступные для использования версии универсального формата EnterpriseData.
//
// см. ОбменДаннымиПереопределяемый.ПриПолученииДоступныхВерсийФормата()
//
Процедура ПриПолученииДоступныхВерсийФормата(ВерсииФормата) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

// Обработчик при коллизии изменений данных.
// см. ОбменДаннымиПереопределяемый.ПриКоллизииИзмененийДанных()
//
Процедура ПриКоллизииИзмененийДанных(Знач ЭлементДанных, ПолучениеЭлемента, Знач Отправитель, Знач ПолучениеОтГлавного) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

// Обработчик начальной настройки ИБ после создания узла РИБ.
// Вызывается в момент первого запуска подчиненного узла РИБ (в том числе АРМ).
//
Процедура ПриНастройкеПодчиненногоУзлаРИБ() Экспорт
	
	//++ Локализация
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие") Тогда
		МодульЭлектронноеВзаимодействие = ОбщегоНазначения.ОбщийМодуль("ЭлектронноеВзаимодействие");
		МодульЭлектронноеВзаимодействие.ПриНастройкеПодчиненногоУзлаРИБ();
	КонецЕсли;
	//-- Локализация
	
КонецПроцедуры


// Получает доступные для использования расширения универсального формата EnterpriseData.
// см. ОбменДаннымиПереопределяемый.ПриПолученииДоступныхРасширенийФормата
//
Процедура ПриПолученииДоступныхРасширенийФормата(РасширенияФормата) Экспорт
	//++ Локализация
	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает идентификатор настройки обменов с БП 3.0 (ПРОФ).
//
// Возвращаемое значение:
//   Строка - идентификатор настройки
//
Функция ИдентификаторНастройкиОбменаБП30() Экспорт
	
	// Соответствует "ОбменБП30" в пред версиях.
	ИдентификаторНастройки = "ОбменERP_БП3";
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		
		ИдентификаторНастройки = "ОбменУТ_БП3";
		
	КонецЕсли;
	
	Возврат ИдентификаторНастройки;
	
КонецФункции

// Возвращает идентификатор настройки обменов с БП 3.0 (КОРП).
//
// Возвращаемое значение:
//   Строка - идентификатор настройки
//
Функция ИдентификаторНастройкиОбменаБПКОРП30() Экспорт
	
	// Соответствует "ОбменБПКОРП30" в пред версиях.
	ИдентификаторНастройки = "ОбменERP_БПКОРП30";
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		
		ИдентификаторНастройки = "ОбменУТ_БПКОРП30";
		
	КонецЕсли;
	
	Возврат ИдентификаторНастройки;
	
КонецФункции

// Возвращает идентификатор настройки обменов базовой УТ с БП 3.0 (ПРОФ).
//
// Возвращаемое значение:
//   Строка - идентификатор настройки
//
Функция ИдентификаторНастройкиОбменаБазовойУТБП30() Экспорт
	
	// Соответствует "ОбменУТБП" в пред версиях.
	Возврат "ОбменУТБ_БП3";
	
КонецФункции

#КонецОбласти