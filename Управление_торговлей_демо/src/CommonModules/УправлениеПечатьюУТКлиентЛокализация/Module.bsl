
#Область ПрограммныйИнтерфейс

// Вызывается из обработчика Подключаемый_ОбработкаНавигационнойСсылки формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Позволяет реализовать обработчик нажатия гиперссылки, которая добавлена в форму 
// с помощью УправлениеПечатьюПереопределяемый.ПечатьДокументовПриСозданииНаСервере.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//  Элемент              - ПолеФормы - элемент формы, вызвавший данное событие.
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - значение гиперссылки форматированной строки. Передается по ссылке.
//  СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события. Если установить
//                                  значение Ложь, стандартная обработка события производиться не будет.
//
Процедура ПечатьДокументовОбработкаНавигационнойСсылки(Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействиеКлиент.ПечатьДокументовОбработкаНавигационнойСсылки(Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	// Конец ЭлектронноеВзаимодействие
	
КонецПроцедуры

// Вызывается из обработчика Подключаемый_ВыполнитьКоманду формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Позволяет реализовать клиентскую часть обработчика команды, которая добавлена в форму 
// с помощью УправлениеПечатьюПереопределяемый.ПечатьДокументовПриСозданииНаСервере.
//
// Параметры:
//  Форма                         - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//  Команда                       - КомандаФормы     - выполняемая команда.
//  ПродолжитьВыполнениеНаСервере - Булево - при установке значения Истина, выполнение обработчика будет продолжено в
//                                           серверном контексте в процедуре УправлениеПечатьюПереопределяемый.ПечатьДокументовПриВыполненииКоманды.
//  ДополнительныеПараметры       - Произвольный - параметры, которые необходимо передать в серверный контекст.
//
// Пример:
//  Если Команда.Имя = "МояКоманда" Тогда
//   НастройкаПечатнойФормы = УправлениеПечатьюКлиент.НастройкаТекущейПечатнойФормы(Форма);
//   
//   ДополнительныеПараметры = Новый Структура;
//   ДополнительныеПараметры.Вставить("ИмяКоманды", Команда.Имя);
//   ДополнительныеПараметры.Вставить("ИмяРеквизитаТабличногоДокумента", НастройкаПечатнойФормы.ИмяРеквизита);
//   ДополнительныеПараметры.Вставить("НазваниеПечатнойФормы", НастройкаПечатнойФормы.Название);
//   
//   ПродолжитьВыполнениеНаСервере = Истина;
//  КонецЕсли;
//
Процедура ПечатьДокументовВыполнитьКоманду(Форма, Команда, ПродолжитьВыполнениеНаСервере, ДополнительныеПараметры) Экспорт
	
	//++ Локализация


	//-- Локализация
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействиеКлиент.ПечатьДокументовВыполнитьКоманду(Форма, Команда, ПродолжитьВыполнениеНаСервере, ДополнительныеПараметры);
	// Конец ЭлектронноеВзаимодействие
	
КонецПроцедуры

// Вызывается из обработчика ОбработкаОповещения формы ПечатьДокументов.
// Позволяет реализовать обработчик внешнего события в форме.
//
// Параметры:
//  Форма      - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//  ИмяСобытия - Строка - идентификатор оповещения.
//  Параметр   - Произвольный - произвольный параметр оповещения.
//  Источник   - Произвольный - источник события.
//
Процедура ПечатьДокументовОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействиеКлиент.ПечатьДокументовОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник);
	// Конец ЭлектронноеВзаимодействие
	
КонецПроцедуры

#Область Инв3_Инв19

// Печатает Инв3 и Инв19
//
// Параметры:
//  ОписаниеКоманды - Структура
//
Функция ПечатьИНВ3_19(ОписаниеКоманды) Экспорт
	                    	
	ОчиститьСообщения();
	// не поддерживаем множественную печать
	Если ОписаниеКоманды.ОбъектыПечати.Количество() > 1 Тогда
		ТекстСообщения = НСтр("ru = 'Не поддерживается групповое формирование печатных форм ""ИНВ-3"" и ""ИНВ-19"" через список документов ""Пересчеты товаров"".'");	
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;
	КонецЕсли;
	
	ПараметрыФормирования = УправлениеПечатьюУТВызовСервера.ПолучитьПараметрыФормирования(ОписаниеКоманды.ОбъектыПечати);
	ПараметрыФормирования.Вставить("Идентификатор", ОписаниеКоманды.Идентификатор);
	
	ОткрытьФорму("Документ.ИнвентаризационнаяОпись.Форма.ФормаПечати",
		ПараметрыФормирования, ОписаниеКоманды.Форма,,,,,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
КонецФункции

#КонецОбласти

#Область Км3

// Выводит печатную форму КМ3-3.
//
// Параметры:
//	ОписаниеКоманды - Структура - структура с описанием команды.
//
// Возвращаемое значение:
//	Неопределено
//
Функция ПечатьКМ3(ОписаниеКоманды) Экспорт
	
	СтруктураОшибок = УправлениеПечатьюУТВызовСервераЛокализация.ПроверитьПроведенностьИСтатусПробитДокументовДляПечатиИНВ3(
		ОписаниеКоманды.Идентификатор,
		ОписаниеКоманды.ОбъектыПечати);
	
	Если СтруктураОшибок.КоличествоЧеков > 0 Тогда
		
		Если СтруктураОшибок.КоличествоЧеков = 1 Тогда
			ТекстПредупреждения = НСтр("ru = 'Для того чтобы распечатать КМ3, необходимо предварительно пробить чек ККМ на возврат.'");
		Иначе
			ТекстПредупреждения = НСтр("ru = 'Для того чтобы распечатать КМ3, необходимо предварительно пробить чеки ККМ на возврат.'");
		КонецЕсли;
		
		ПоказатьПредупреждение(,ТекстПредупреждения, 30);
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Если СтруктураОшибок.КоличествоОтчетов > 0 Тогда
		
		Если СтруктураОшибок.КоличествоОтчетов = 1 Тогда
			ТекстПредупреждения = НСтр("ru = 'Для того чтобы распечатать КМ3, необходимо предварительно провести отчет о розничных продажах.'");
		Иначе
			ТекстПредупреждения = НСтр("ru = 'Для того чтобы распечатать КМ3, необходимо предварительно провести отчеты о розничных продажах.'");
		КонецЕсли;
		
		ПоказатьПредупреждение(,ТекстПредупреждения, 30);
		
		Возврат Ложь;
		
	КонецЕсли;
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Обработка.ПечатьКМ3",
		"КМ3",
		ОписаниеКоманды.ОбъектыПечати,
		ОписаниеКоманды.Форма);
	
КонецФункции

#КонецОбласти

#Область АкцизныеМарки

// Получает данные для печати и открывает форму обработки печати этикеток и ценников.
//
// Параметры:
//	ОписаниеКоманды - Структура - структура с описанием команды.
//
// Возвращаемое значение:
//	Неопределено
//
Функция ПечатьАкцизныхМарок(ОписаниеКоманды) Экспорт
	
	ИмяОбработкиПечатьЭтикетокИЦенников = ЦенообразованиеКлиент.ИмяОбработкиПечатьЭтикетокИЦенников();
	ДанныеДляПечати = УправлениеПечатьюУТВызовСервераЛокализация.ДанныеДляПечатиАкцизныхМарок(ОписаниеКоманды.Идентификатор, ОписаниеКоманды.ОбъектыПечати);
	
	Если Не ДанныеДляПечати.ЕстьЭтикеткиДляПечати Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Нет данных для печати акцизных марок.'"));
		Возврат Неопределено;
	КонецЕсли;
	
	Если ДанныеДляПечати.ЕстьШаблонЭтикетки Тогда
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			ИмяОбработкиПечатьЭтикетокИЦенников,
			"ЭтикеткаАкцизныеМарки",
			ОписаниеКоманды.ОбъектыПечати,
			Неопределено,
			Новый Структура(
				"АдресВХранилище, ШаблонЭтикетки, КоличествоЭкземпляров",
				ДанныеДляПечати.АдресВХранилище, ДанныеДляПечати.ШаблонЭтикетки, 1));
	Иначе
		ОткрытьФорму(ИмяОбработкиПечатьЭтикетокИЦенников+".Форма.ФормаАкцизныеМарки",
			Новый Структура("АдресВХранилище", ДанныеДляПечати.АдресВХранилище),
			ОписаниеКоманды.Форма,
			Новый УникальныйИдентификатор);
	КонецЕсли;
		
КонецФункции

#КонецОбласти

#Область ЭтикеткиИСМП

// Выполняет команду печати этикеток обуви
//
// Параметры:
//	ОписаниеКоманды - Структура - структура с описанием команды.
//
// Возвращаемое значение:
//	Неопределено
//
Функция ПечатьЭтикетокОбувь(ОписаниеКоманды) Экспорт
	//++ Локализация
	ИмяОбработкиПечатьЭтикетокИЦенников = ЦенообразованиеКлиент.ИмяОбработкиПечатьЭтикетокИЦенников();
	Если ОписаниеКоманды.СтруктураДанных.ОбъектыПечати.Количество() = 0 Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Нет данных для печати этикеток обуви.'"));
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрКоманды = Новый Массив;
	ПараметрКоманды.Добавить(ПредопределенноеЗначение("Документ.МаркировкаТоваровИСМП.ПустаяСсылка"));
	
	ПараметрыПечати = Новый Структура();
	ПараметрыПечати.Вставить("КоличествоЭкземпляров", 1);
	ПараметрыПечати.Вставить("Документ", ОписаниеКоманды.СтруктураДанных.Документ);
	ПараметрыПечати.Вставить("АдресВХранилище", ПоместитьВоВременноеХранилище(ОписаниеКоманды.СтруктураДанных));
	ПараметрыПечати.Вставить("КаждаяЭтикеткаНаНовомЛисте", ОписаниеКоманды.СтруктураДанных.КаждаяЭтикеткаНаНовомЛисте);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		ИмяОбработкиПечатьЭтикетокИЦенников,
		"ЭтикеткаКодМаркировкиИСМП",
		ПараметрКоманды,
		Неопределено,
		ПараметрыПечати);
	//-- Локализация
КонецФункции

// Получает данные для печати и открывает форму обработки печати этикеток и ценников.
//
// Параметры:
//	ОписаниеКоманды - Структура - структура с описанием команды.
//
// Возвращаемое значение:
//	Неопределено
//
Функция ПечатьШтрихкодовУпаковок(ОписаниеКоманды) Экспорт
	
	ИмяОбработкиПечатьЭтикетокИЦенников = ЦенообразованиеКлиент.ИмяОбработкиПечатьЭтикетокИЦенников();
	ДанныеДляПечати = УправлениеПечатьюУТВызовСервераЛокализация.ДанныеДляПечатиШтрихкодовУпаковок(
		ОписаниеКоманды.Идентификатор, ОписаниеКоманды.ОбъектыПечати);
	
	Если Не ДанныеДляПечати.ЕстьЭтикеткиДляПечати Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Нет данных для печати штрихкодов упаковок.'"));
		Возврат Неопределено;
	КонецЕсли;
	
	Если ДанныеДляПечати.ЕстьШаблонЭтикетки Тогда
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			ИмяОбработкиПечатьЭтикетокИЦенников,
			"ЭтикеткаШтрихкодыУпаковки",
			ОписаниеКоманды.ОбъектыПечати,
			Неопределено,
			Новый Структура(
				"АдресВХранилище, ШаблонЭтикетки, КоличествоЭкземпляров",
				ДанныеДляПечати.АдресВХранилище, ДанныеДляПечати.ШаблонЭтикетки, 1));
	Иначе
		ОткрытьФорму(
			"Справочник.ШаблоныЭтикетокИЦенников.Форма.ФормаШтрихкодыУпаковокИС",
			Новый Структура("АдресВХранилище", ДанныеДляПечати.АдресВХранилище),
			ОписаниеКоманды.Форма,
			Новый УникальныйИдентификатор);
	КонецЕсли;
		
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
