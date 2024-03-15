#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущаяИнициализация;
Перем ТекущийКонтейнер; // ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - контейнер.
Перем ТекущиеОбработчики;
Перем ТекущиеСловариЗамен; // Соответствие - словари замен.

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура Инициализировать(Контейнер, Обработчики, СоответствиеСсылок = Неопределено) Экспорт
	
	Если ТекущаяИнициализация Тогда
		
		ВызватьИсключение НСтр("ru = 'Объект уже был инициализирован ранее.'");
		
	КонецЕсли;
		
	ТекущийКонтейнер = Контейнер;
	ТекущиеОбработчики = Обработчики;

	Если СоответствиеСсылок = Неопределено Тогда
		ТекущиеСловариЗамен = Новый Соответствие();
	Иначе
		ТекущиеСловариЗамен = СоответствиеСсылок;
	КонецЕсли;
		
	ТекущаяИнициализация = Истина;
	
КонецПроцедуры

Процедура ЗаменитьСсылку(Знач ИмяТипаXML, Знач СтарыйИдентификатор, Знач НовыйИдентификатор, Знач ТолькоПриОтсутствии = Ложь) Экспорт
	
	Если ТекущиеСловариЗамен.Получить(ИмяТипаXML) = Неопределено Тогда
		ТекущиеСловариЗамен.Вставить(ИмяТипаXML, Новый Соответствие());
	КонецЕсли;
	
	Если ТолькоПриОтсутствии Тогда
		СоответствиеСсылок = ТекущиеСловариЗамен.Получить(ИмяТипаXML);
		Если СоответствиеСсылок.Получить(СтарыйИдентификатор) = Неопределено Тогда
			СоответствиеСсылок.Вставить(СтарыйИдентификатор, НовыйИдентификатор);
		КонецЕсли;
	Иначе
		ТекущиеСловариЗамен.Получить(ИмяТипаXML).Вставить(СтарыйИдентификатор, НовыйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

// Заменяет ссылки в файле.
//
// Параметры:
//  ОписаниеФайла - СтрокаТаблицыЗначений - см. переменную "Состав" модуля объекта обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//
Процедура ВыполнитьЗаменуСсылокВФайле(Знач ОписаниеФайла) Экспорт
	
	ВремФайл = ПолучитьИмяВременногоФайла("xml");
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ВремФайл);
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ОписаниеФайла.ПолноеИмя);
	
	ЗаменитьСсылкиПриЗагрузкеИзXML(ЧтениеXML, ЗаписьXML);
	
	ЧтениеXML.Закрыть();
	ЗаписьXML.Закрыть();
	
	ПереместитьФайл(ВремФайл, ОписаниеФайла.ПолноеИмя);
	
КонецПроцедуры

Процедура СохранитьСоответствиеСсылокВоВременноеХранилище(Адрес) Экспорт
	
	 ПоместитьВоВременноеХранилище(ТекущиеСловариЗамен, Адрес);
	
КонецПроцедуры

Функция СоответствиеСсылок() Экспорт
	
	Возврат ТекущиеСловариЗамен;
	
КонецФункции


Процедура Закрыть() Экспорт
	
	ВыполнитьЗаменуСсылок();
	ТекущийКонтейнер = Неопределено;
	ТекущиеСловариЗамен = Новый Соответствие();
	ТекущаяИнициализация = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет ряд действий по замене ссылок.
//
Процедура ВыполнитьЗаменуСсылок()
	
	ТипыФайлов = ВыгрузкаЗагрузкаДанныхСлужебный.ТипыФайловПоддерживающиеЗаменуСсылок();
	
	ОписанияФайлов = ТекущийКонтейнер.ПолучитьОписанияФайловИзКаталога(ТипыФайлов);
	Для Каждого ОписаниеФайла Из ОписанияФайлов Цикл
		
		ВыполнитьЗаменуСсылокВФайле(ОписаниеФайла);
		
	КонецЦикла;
	
	ТекущиеОбработчики.ПриЗаменеСсылок(ТекущийКонтейнер, ТекущиеСловариЗамен);
	
КонецПроцедуры

Процедура ЗаменитьСсылкиПриЗагрузкеИзXML(ЧтениеXML, ЗаписьXML)
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			ЗаписьXML.ЗаписатьНачалоЭлемента(ЧтениеXML.Имя);
			
			ТипЗначения = Неопределено;
			Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
				
				ЗаписьXML.ЗаписатьАтрибут(ЧтениеXML.Имя, ЧтениеXML.Значение);
				
				Если ЧтениеXML.ЛокальноеИмя = "type" И ЧтениеXML.URIПространстваИмен = "http://www.w3.org/2001/XMLSchema-instance" Тогда
					Части = СтрРазделить(ЧтениеXML.Значение, ":");
					Если Части.Количество() = 1 Тогда
						Префикс = "";
						ИмяТипа = Части[0];
					Иначе
						Префикс = Части[0];
						ИмяТипа = Части[1];
					КонецЕсли;
					Если ЧтениеXML.НайтиURIПространстваИмен(Префикс) = "http://v8.1c.ru/8.1/data/enterprise/current-config" Тогда
						ТипЗначения = ИмяТипа;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
			
			НовоеЗначение = Неопределено;
			
			Если ТипЗначения <> Неопределено Тогда
				Ссылки = ТекущиеСловариЗамен.Получить(ТипЗначения);
				Если Ссылки <> Неопределено Тогда
					НовоеЗначение = Ссылки.Получить(ЧтениеXML.Значение);
				КонецЕсли;
			КонецЕсли;
			
			Если НовоеЗначение = Неопределено Тогда
				ЗаписьXML.ЗаписатьТекст(ЧтениеXML.Значение);
			Иначе
				ЗаписьXML.ЗаписатьТекст(НовоеЗначение);
			КонецЕсли;
			
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			
			ЗаписьXML.ЗаписатьКонецЭлемента();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ТекущаяИнициализация = Ложь;

#КонецОбласти

#КонецЕсли