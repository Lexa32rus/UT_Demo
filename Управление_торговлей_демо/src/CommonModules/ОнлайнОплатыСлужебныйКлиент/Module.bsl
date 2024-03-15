///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ОнлайнОплаты".
// ОбщийМодуль.ОнлайнОплатыСлужебныйКлиент.
//
// Клиентские процедуры настройки интеграции с онлайн оплатами:
//  - инициализация параметров открытия и открытие форм настроек, платежных ссылок онлайн оплат, шаблонов сообщений;
//  - алгоритмы настройки формы "Интернет-поддержка и сервисы".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Открывает форму формирования платежной ссылки основания платежа.
// Перед открытием проверяется наличие подключенной интернет-поддержки пользователей.
//
// Параметры:
//  ОснованиеПлатежа - Произвольный - основание платежа, для которого будет формироваться ссылка.
//
Процедура ОткрытьФормуПлатежнойСсылки(Знач ОснованиеПлатежа) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ОснованиеПлатежа", ОснованиеПлатежа);
	
	ОбработкаПродолжения = Новый ОписаниеОповещения("ОткрытьФормуПлатежнойСсылкиПродолжение", ЭтотОбъект, Параметры);
	
	НачатьПроверкуИПодключениеИПП(ОбработкаПродолжения);
	
КонецПроцедуры

// См. ОнлайнОплаты.ПриОпределенииКомандПодключенныхКОбъекту
//
Процедура Подключаемый_ОткрытьФормуПлатежнойСсылки(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	ОнлайнОплатыКлиент.ОткрытьФормуПлатежнойСсылки(ПараметрКоманды);
	
КонецПроцедуры

// Выполнение проверки и подключение к ИПП.
// Параметры:
//  ОбработкаЗавершения - ОписаниеОповещения - Процедура, которая будет либо выполнена сразу, если вход в ИПП выполнен,
//    либо после вывода пользователю диалога о необходимости подключения к ИПП и ввода учетных данных.
//    Параметр Результат процедуры-обработчика может принимать значение Ложь,если пользователь отказался от подключения
//    к ИПП или отменил ввод учетных данных, либо Истина, если вход в ИПП выполнен.
//
Процедура НачатьПроверкуИПодключениеИПП(Знач ОбработкаЗавершения = Неопределено)
	
	Если ПроверитьПодключениеИПП() Тогда
		
		Если ОбработкаЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОбработкаЗавершения, Истина);
		КонецЕсли;
		
	Иначе
		
		ПоказатьВопросПодключенияИПП(ОбработкаЗавершения);
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму настройки онлайн оплаты.
//
// Параметры:
//  ПараметрыФормы -  Структура - Параметры формы. Ключ структуры - имя параметра, 
//    а значение - значение параметра формы. Имя элемента должно совпадать с именем параметра структуры.
//  Владелец - форма или элемент управления другой формы.
//  ОписаниеОповещения - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана при закрытии формы.
//
Процедура ОткрытьФормуНастроекОнлайнОплаты(
			ПараметрыФормы, 
			Владелец = Неопределено, 
			ОписаниеОповещения = Неопределено) Экспорт
	
	ОткрытьФорму("Справочник.НастройкиОнлайнОплат.Форма.ФормаЭлемента",
		ПараметрыФормы,
		Владелец,
		,
		,
		,
		ОписаниеОповещения);
	
КонецПроцедуры

Функция ОписаниеПараметровФормыНастройкиОнлайнОплаты() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("Ключ", Неопределено);
	Результат.Вставить("ПроверкаПодключенияСервиса", Ложь);
	
	Возврат Результат;
	
КонецФункции

Процедура ОткрытьФормуПлатежнойСсылкиПродолжение(Знач ПодключенаИПП, Знач Параметры) Экспорт
	
	Если Не ПодключенаИПП Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ОснованиеПлатежа", Параметры.ОснованиеПлатежа);
	
	ОткрытьФорму("Справочник.НастройкиОнлайнОплат.Форма.ФормаПодготовкиПлатежнойСсылки", ПараметрыФормы);
	
КонецПроцедуры

Процедура ПослеОтветаНаВопросОСозданииШаблонов(Результат, Параметры) Экспорт
	
	МассивШаблонов = Параметры.МассивШаблонов;
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		
		ИнтеграцияСПлатежнымиСистемамиВызовСервера.УстановитьИспользованиеШаблоновСообщенийПроверкаПодсистем();
		
		МассивСозданныхШаблонов =
			ОнлайнОплатыСлужебныйВызовСервера.СоздатьПредопределенныеШаблоныСообщенийПроверкаПодсистем();
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивШаблонов, МассивСозданныхШаблонов);
	КонецЕсли;
	
	ОткрытьФормуШаблонаСообщенийСОтбором(МассивШаблонов, Параметры.УникальныйИдентификатор);
	
КонецПроцедуры

Процедура ОткрытьФормуШаблонаСообщенийСОтбором(МассивШаблонов, УникальныйИдентификатор)
	
	ОтборФормы = Новый Структура();
	ОтборФормы.Вставить("Ссылка", МассивШаблонов);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Отбор", ОтборФормы);
	
	Форма = "Справочник.ШаблоныСообщений.ФормаСписка";
	
	ОткрытьФорму(Форма, ПараметрыФормы, ЭтотОбъект, УникальныйИдентификатор);
	
КонецПроцедуры

Процедура ОткрытьШаблоныСообщенийОнлайнОплат(УникальныйИдентификатор) Экспорт
	
	РезультатПроверки = ОнлайнОплатыСлужебныйВызовСервера.ВсеШаблоныСозданы();
	
	Если РезультатПроверки.ВсеШаблоны Тогда
		
		ОткрытьФормуШаблонаСообщенийСОтбором(
			РезультатПроверки.МассивШаблонов,
			УникальныйИдентификатор);
			
	Иначе
		
		РезультатПроверки.Вставить("УникальныйИдентификатор",УникальныйИдентификатор);
		
		Оповещение = Новый ОписаниеОповещения(
			"ПослеОтветаНаВопросОСозданииШаблонов",
			ЭтотОбъект,
			РезультатПроверки);
		
		ПоказатьВопрос(
			Оповещение,
			НСтр("ru = 'Создать шаблоны сообщений для автоматического заполнения на основании данных документов?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#Область ИнтернетПоддержкаПользователей

Функция ПроверитьПодключениеИПП() 
	
	Возврат ОнлайнОплатыСлужебныйВызовСервера.ДанныеИнтернетПоддержкиУказаны();
	
КонецФункции

Процедура ПоказатьВопросПодключенияИПП(Знач ОбработкаЗавершения = Неопределено) 
	
	Параметры = Новый Структура;
	Параметры.Вставить("ОбработкаЗавершения", ОбработкаЗавершения);
	
	ОбработкаОтвета = Новый ОписаниеОповещения("ПоказатьВопросПодключенияИПП_Завершение", ЭтотОбъект, Параметры);
	
	ТекстВопроса = НСтр("ru='Для использования функций взаимодействия с сервисом ЮKassa,
		|необходимо подключиться к Интернет-поддержке пользователей.
		|Подключиться сейчас?'");
	ПоказатьВопрос(ОбработкаОтвета, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

Процедура ПоказатьВопросПодключенияИПП_Завершение(Знач Ответ, Знач Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ОбработкаПодключения = Новый ОписаниеОповещения("НачатьПодключениеИПП_Завершение", ЭтотОбъект, Параметры);
		
		НачатьПодключениеИПП(ОбработкаПодключения);
		
	Иначе
		
		Если Параметры.ОбработкаЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Параметры.ОбработкаЗавершения, Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьПодключениеИПП(Знач ОбработкаПодключения = Неопределено)
	
	ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОбработкаПодключения, ЭтотОбъект);
	
КонецПроцедуры

Процедура НачатьПодключениеИПП_Завершение(Знач ДанныеПодключения, Знач Параметры) Экспорт
	
	Если Параметры.ОбработкаЗавершения <> Неопределено Тогда
		
		Подключено = (ДанныеПодключения <> Неопределено);
		ВыполнитьОбработкуОповещения(Параметры.ОбработкаЗавершения, Подключено);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти