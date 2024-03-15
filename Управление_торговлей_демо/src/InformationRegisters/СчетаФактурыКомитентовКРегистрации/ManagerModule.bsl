#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Переформировывает распоряжения на регистрацию счетов-фактур от комитентов.
//
// Параметры:
// 	 ОтчетКомитенту - ДокументСсылка - Ссылка Отчет комитенту, при записи которого необходимо обновить состояние.
//
Процедура ОбновитьСостояние(СчетаФактурыВыданные, Отказ = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(СчетаФактурыВыданные, Неопределено);
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(СчетаФактурыВыданные, Документы.СчетФактураВыданный.ПустаяСсылка());
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(СчетаФактурыВыданные, Документы.СчетФактураКомиссионеру.ПустаяСсылка());
	
	СчетаФактурыВыданные = ОбщегоНазначенияКлиентСервер.СвернутьМассив(СчетаФактурыВыданные);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВложеннаяТаблица.Организация,
	|	ВложеннаяТаблица.Комитент,
	|	ВложеннаяТаблица.Покупатель,
	|	ВложеннаяТаблица.СчетФактураВыданный,
	|	ВложеннаяТаблица.Валюта,
	|	ВложеннаяТаблица.Дата КАК Дата,
	|	СУММА(ВложеннаяТаблица.СуммаСНДС) КАК СуммаСНДС,
	|	СУММА(ВложеннаяТаблица.СуммаНДС) КАК СуммаНДС
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДанныеОснованийСчетовФактур.Организация КАК Организация,
	|		ДанныеОснованийСчетовФактур.Контрагент КАК Комитент,
	|		ДанныеОснованийСчетовФактур.ПокупательКомиссионногоТовара КАК Покупатель,
	|		ДанныеОснованийСчетовФактур.СчетФактураВыданныйКомиссионером КАК СчетФактураВыданный,
	|		ДанныеОснованийСчетовФактур.Валюта КАК Валюта,
	|		ДанныеОснованийСчетовФактур.ДатаСчетаФактурыКомиссионера КАК Дата,
	|		ДанныеОснованийСчетовФактур.СуммаБезНДС + ДанныеОснованийСчетовФактур.СуммаНДС КАК СуммаСНДС,
	|		ДанныеОснованийСчетовФактур.СуммаНДС КАК СуммаНДС,
	|		ДанныеОснованийСчетовФактур.СтавкаНДС.ПеречислениеСтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС0) КАК ЭтоСтавкаНДС0
	|	ИЗ
	|		РегистрСведений.ДанныеОснованийСчетовФактур КАК ДанныеОснованийСчетовФактур
	|	ГДЕ
	|		ДанныеОснованийСчетовФактур.ТипСчетаФактуры = &ИдентификаторТипСчетаФактурыКомитенту
	|		И ДанныеОснованийСчетовФактур.СчетФактураВыданныйКомиссионером В (&СчетаФактурыВыданные)
	|		
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СчетФактураКомитента.Организация КАК Организация,
	|		СчетФактураКомитента.Комитент КАК Комитент,
	|		ТаблицаПокупатели.Покупатель КАК Покупатель,
	|		ТаблицаПокупатели.СчетФактураВыданный КАК СчетФактураВыданный,
	|		СчетФактураКомитента.Валюта КАК Валюта,
	|		НАЧАЛОПЕРИОДА(СчетФактураКомитента.ДатаСоставления, ДЕНЬ) КАК Дата,
	|		-ТаблицаПокупатели.СуммаСНДС КАК СуммаСНДС,
	|		-ТаблицаПокупатели.СуммаНДС  КАК СуммаНДС,
	|		ЛОЖЬ
	|	ИЗ
	|		Документ.СчетФактураКомитента.Покупатели КАК ТаблицаПокупатели
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			Документ.СчетФактураКомитента КАК СчетФактураКомитента
	|		ПО
	|			ТаблицаПокупатели.Ссылка = СчетФактураКомитента.Ссылка
	|	ГДЕ
	|		ТаблицаПокупатели.СчетФактураВыданный В (&СчетаФактурыВыданные)
	|		И СчетФактураКомитента.Проведен) ВложеннаяТаблица
	|	
	|СГРУППИРОВАТЬ ПО
	|	ВложеннаяТаблица.Организация,
	|	ВложеннаяТаблица.Комитент,
	|	ВложеннаяТаблица.Покупатель,
	|	ВложеннаяТаблица.СчетФактураВыданный,
	|	ВложеннаяТаблица.Валюта,
	|	ВложеннаяТаблица.Дата
	|
	|ИМЕЮЩИЕ
	|	СУММА(ВложеннаяТаблица.СуммаСНДС) <> 0 И (СУММА(ВложеннаяТаблица.СуммаНДС) <> 0
	|											ИЛИ МАКСИМУМ(ВложеннаяТаблица.ЭтоСтавкаНДС0))
	|";
	
	Запрос.УстановитьПараметр("СчетаФактурыВыданные", СчетаФактурыВыданные);
	Запрос.УстановитьПараметр("ИдентификаторТипСчетаФактурыКомитенту", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СчетФактураКомитента"));
	
	СчетаФактурыКомитентовКРегистрации = Запрос.Выполнить().Выгрузить();
	СчетаФактурыКомитентовКРегистрации.Индексы.Добавить("СчетФактураВыданный");
	МассивПолейСодержащихОшибки = Новый Массив;
	МассивСравниваемыхПолей = Новый Массив;
	МассивСравниваемыхПолей.Добавить("Дата");
	МассивСравниваемыхПолей.Добавить("Организация");
	МассивСравниваемыхПолей.Добавить("Валюта");
	МассивСравниваемыхПолей.Добавить("Покупатель");
	
	
	Для каждого СчетФактураВыданный Из СчетаФактурыВыданные Цикл
		
		Отбор = Новый Структура("СчетФактураВыданный", СчетФактураВыданный);
		Строки = СчетаФактурыКомитентовКРегистрации.НайтиСтроки(Отбор);
		Если Строки.Количество()>1 Тогда
			Для каждого Поле Из МассивСравниваемыхПолей Цикл
				Для Инд = 0 по Строки.Количество()-2 Цикл
					ТекСтрока = Строки.Получить(Инд);
					СледСтрока = Строки.Получить(Инд+1);
					Если ТекСтрока[Поле]<>СледСтрока[Поле] Тогда
						МассивПолейСодержащихОшибки.Добавить(Поле);	
					КонецЕсли;
				КонецЦикла;	
			КонецЦикла;
		Иначе
			НаборЗаписей = РегистрыСведений.СчетаФактурыКомитентовКРегистрации.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.СчетФактураВыданный.Установить(СчетФактураВыданный);
			Для каждого Строка Из Строки Цикл
				НоваяЗапись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, Строка);
			КонецЦикла;
			НаборЗаписей.Записать();
		КонецЕсли;
		
		Для каждого Поле Из МассивПолейСодержащихОшибки Цикл
	 
			СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Невозможно провести документ: ранее зарегистрирована %1
																						|с другим значением реквизита [%2]'"),СчетФактураВыданный,Поле);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрокаСообщения,,,,);	
			Отказ = Истина;
		
		КонецЦикла;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(СчетФактураВыданный.Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли