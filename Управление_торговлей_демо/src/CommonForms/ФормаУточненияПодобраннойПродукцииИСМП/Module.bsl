#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	ЗаполнитьДанныеФормыПриСозданииНаСервере();
	СброситьРазмерыИПоложениеОкна();
	
	СобытияФормИСКлиентСерверПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(
		ЭтотОбъект, ПараметрыСканирования.ДопустимыеВидыПродукции, "Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(
		ЭтотОбъект, "Характеристика", "Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(
		ЭтотОбъект, "Серия", "Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСХарактеристикой(
		ЭтотОбъект, "Серия", "Характеристика");
	
	ИнтеграцияИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект, "");
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	УстановитьЗаголовокЭлементаИдентификаторВЕТИС();
	УстановитьФорматДатыГоденДо(ЭтотОбъект);
	УстановитьВидимостьДоступностьЭлементовПриСозданииНаСервере();
	
	ОбновитьОтображениеПоляКоличество();
	ОбновитьОтображениеПоляКоличествоОСУ();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не УказатьИдентификаторВЕТИС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ИдентификаторПроисхожденияВЕТИС");
	КонецЕсли;
	
	Если Не УказатьСрокГодности Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ГоденДо");
	КонецЕсли;
	
	Если УточнениеКоличестваОСУДопустимо Тогда
		ПроверяемыеРеквизиты.Добавить("GTIN");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("GTIN");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	СобытияФормИСПереопределяемый.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ИмяФормыУказанияСерии = "";
	ШтрихкодированиеИСКлиентПереопределяемый.ЗаполнитьПолноеИмяФормыУказанияСерии(ИмяФормыУказанияСерии);
	
	Если ИсточникВыбора.ИмяФормы = ИмяФормыУказанияСерии Тогда
		Серия = ВыбранноеЗначение.Значение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	НоменклатураПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаПриИзменении(Элемент)
	ОбновитьДанныеGTIN();
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВидыПродукции = Новый Массив;
	ВидыПродукции.Добавить(ВидПродукции);
	
	СобытияФормИСКлиентПереопределяемый.ПриНачалеВыбораНоменклатуры(Элемент, ВидыПродукции, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		
		ИнтеграцияИСКлиент.ОткрытьПодборСерий(ЭтотОбъект, ПараметрыУказанияСерий, Элемент.ТекстРедактирования, СтандартнаяОбработка, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторПроисхожденияВЕТИСПриИзменении(Элемент)
	УстановитьФорматДатыГоденДо(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторПроисхожденияВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияИСМПВЕТИСКлиент");
	ПараметрыОткрытия = Модуль.ПараметрыВыбораИдентификатораПросхождения(ПараметрыСканирования.ВидОперацииИСМП);
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, ЭтотОбъект);
	ПараметрыОткрытия.ОповещениеВыбора = Новый ОписаниеОповещения("ВыборИдентификатораПроисхожденияВЕТИСЗавершение", ЭтотОбъект);
	ПараметрыОткрытия.Организация = ПараметрыСканирования.Организация;
	Модуль.ОткрытьФормуВыбораИдентификатораПроисхожденияВЕТИС(ПараметрыОткрытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборИдентификатораПроисхожденияВЕТИСЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторыВЕТИС = Новый Массив;
	ИдентификаторыВЕТИС.Добавить(Результат);
	ДобавитьИдентификаторыВЕТИСВСписокВыбора(ИдентификаторыВЕТИС);
	
	ИдентификаторПроисхожденияВЕТИС = Результат;
	УстановитьГоденДоИСкоропортящаясяПродукцияПоИдентификаторПроисхожденияВЕТИС();
	
	УстановитьФорматДатыГоденДо(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьГоденДоИСкоропортящаясяПродукцияПоИдентификаторПроисхожденияВЕТИС()
	
	Если Не ЗначениеЗаполнено(ИдентификаторПроисхожденияВЕТИС) 
		Или Не УказатьСрокГодности Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеВЕТИС = ДанныеИдентификаторовПроисхожденияВЕТИС(ИдентификаторПроисхожденияВЕТИС);
	
	ГоденДо                  = ДанныеВЕТИС[ИдентификаторПроисхожденияВЕТИС].СрокГодности;
	СкоропортящаясяПродукция = ДанныеВЕТИС[ИдентификаторПроисхожденияВЕТИС].СкоропортящаясяПродукция;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПотребительскихУпаковокДляРедактированияПриИзменении(Элемент)
	
	МинимальноеКоличествоПотребительскихУпаковок = КоличествоПотребительскихУпаковок - КоличествоПотребительскихУпаковокОСУ;
	
	Если МинимальноеКоличествоПотребительскихУпаковок > КоличествоПотребительскихУпаковокДляРедактирования Тогда
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru = '""Количество потребительских упаковок"" не может быть меньше %1'"),
			МинимальноеКоличествоПотребительскихУпаковок);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, Элементы.КоличествоПотребительскихУпаковокДляРедактирования.Имя);
		
		КоличествоПотребительскихУпаковокДляРедактирования = МинимальноеКоличествоПотребительскихУпаковок;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если УточнениеКоличестваОСУДопустимо Тогда
		
		Если ДопустимаПроизвольнаяЕдиницаУчета Тогда
			ИсходноеКоличествоУпаковок = КоличествоПотребительскихУпаковок;
		Иначе
			ИсходноеКоличествоУпаковок = КоличествоПодобрано;
		КонецЕсли;
		
		МинимальноеКоличествоПотребительскихУпаковок = ИсходноеКоличествоУпаковок - КоличествоПотребительскихУпаковокОСУ;
		Если МинимальноеКоличествоПотребительскихУпаковок > КоличествоПотребительскихУпаковокДляРедактирования Тогда
			ТекстОшибки = СтрШаблон(
				НСтр("ru = '""Количество потребительских упаковок"" не может быть меньше %1'"),
				МинимальноеКоличествоПотребительскихУпаковок);
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки,, Элементы.КоличествоПотребительскихУпаковокДляРедактирования.Имя);
			Возврат;
		КонецЕсли;
		
		ВсегоОСУ     = КоличествоПотребительскихУпаковокДляРедактирования - МинимальноеКоличествоПотребительскихУпаковок;
		ДобавленоОСУ = 0;
		УдаленоОСУ   = 0;
		
		Если КоличествоПотребительскихУпаковокДляРедактирования = ИсходноеКоличествоУпаковок Тогда
			// Количество потребительских упаковок не изменено
		ИначеЕсли КоличествоПотребительскихУпаковокДляРедактирования > ИсходноеКоличествоУпаковок Тогда
			// Добавлены упаковки ОСУ
			ДобавленоОСУ = КоличествоПотребительскихУпаковокДляРедактирования - ИсходноеКоличествоУпаковок;
		Иначе
			// Удалены упаковки ОСУ
			УдаленоОСУ = ИсходноеКоличествоУпаковок - КоличествоПотребительскихУпаковокДляРедактирования;
		КонецЕсли;
		
		Если ВсегоОСУ = 0 И ДобавленоОСУ = 0 И УдаленоОСУ = 0 Тогда
			
			ТекстОшибки = НСтр("ru = '""Количество потребительских упаковок"" не изменилось'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки,, Элементы.КоличествоПотребительскихУпаковокДляРедактирования.Имя);
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если УточнениеПодобранногоКоличестваМерногоТовара(ЭтотОбъект)
		И КоличествоПотребительскихУпаковокТребующихВзвешивания > 0
		И КоличествоПодобрано < КоличествоПодобраноВзвешено
		И КоличествоПодобрано <> 0 Тогда // Разрешено указывать 0, если товар требуется перевзвесить
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'Количество должно быть не менее %1'"),
			КоличествоПодобраноВзвешено);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки,, Элементы.КоличествоПодобрано.Имя);
		
		Возврат;
		
	ИначеЕсли Не ТребуетВзвешивания И КоличествоВПотребительскойУпаковке = 0 Тогда
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'Для номенклатуры %1 не задано ""Количество в потребительской упаковке"" в настройках ""Описание номенклатуры ИС""'"),
			Номенклатура);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки,, Элементы.Номенклатура.Имя);
		
		Возврат;
		
	КонецЕсли;
	
	ДанныеВыбора = Новый Структура;
	
	Если УточнениеДанныхОТовареДопустимо Или УточнениеКоличестваОСУДопустимо Тогда
		
		ДанныеВыбора.Вставить("Номенклатура",   Номенклатура);
		ДанныеВыбора.Вставить("Характеристика", Характеристика);
		ДанныеВыбора.Вставить("Серия",          Серия);
		
		ДанныеВыбора.Вставить("ИдентификаторПроисхожденияВЕТИС", ИдентификаторПроисхожденияВЕТИС);
		ДанныеВыбора.Вставить("ГоденДо",                         ГоденДо);
		
		ДанныеВыбора.Вставить("ПроизвольнаяЕдиницаУчета", ПроизвольнаяЕдиницаУчета);
		ДанныеВыбора.Вставить("ТребуетВзвешивания",       ТребуетВзвешивания);
		
	КонецЕсли;
	
	Если УточнениеПодобранногоКоличестваМерногоТовара(ЭтотОбъект)
		Или УточнениеПодобранногоКоличестваМерногоТовараОСУ(ЭтотОбъект) Тогда
		
		ДанныеВыбора.Вставить("Количество", КоличествоПодобрано);
		
	КонецЕсли;
	
	Если УточнениеКоличестваОСУДопустимо Тогда
		
		МинимальноеКоличествоПотребительскихУпаковок = ИсходноеКоличествоУпаковок - КоличествоПотребительскихУпаковокОСУ;
		
		ДанныеВыбора.Вставить("GTIN",                                 GTIN);
		ДанныеВыбора.Вставить("КоличествоПотребительскихУпаковок",    КоличествоПотребительскихУпаковокДляРедактирования);
		ДанныеВыбора.Вставить("КоличествоПотребительскихУпаковокОСУ", КоличествоПотребительскихУпаковокДляРедактирования - МинимальноеКоличествоПотребительскихУпаковок);
		
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("КоличествоВПотребительскойУпаковке",           КоличествоВПотребительскойУпаковке);
	ПараметрыЗакрытия.Вставить("УточнениеПодобранногоКоличестваМерногоТовара", УточнениеПодобранногоКоличестваМерногоТовара(ЭтотОбъект));
	ПараметрыЗакрытия.Вставить("УточнениеКоличестваОСУДопустимо",              УточнениеКоличестваОСУДопустимо);
	ПараметрыЗакрытия.Вставить("ДанныеВыбора",                                 ДанныеВыбора);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВес(Команда)
	
	МенеджерОборудованияКлиентИС.НачатьПолученияВесаСЭлектронныхВесов(
		Новый ОписаниеОповещения("ПолучитьВесЗавершение", ЭтотОбъект),
		УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДанныеФормыПриСозданииНаСервере()
	
	Заголовок = НСтр("ru = 'Уточнение данных'");
	
	ТипыНоменклатуры.ЗагрузитьЗначения(Метаданные.ОпределяемыеТипы.Номенклатура.Тип.Типы());
	
	ДопустимаПроизвольнаяЕдиницаУчета  = Параметры.ДопустимаПроизвольнаяЕдиницаУчета;
	УточнениеДанныхОТовареДопустимо    = Параметры.УточнениеДанныхОТовареДопустимо;
	ЗапрашиватьКоличествоМерногоТовара = Параметры.ЗапрашиватьКоличествоМерногоТовара;
	УточнениеКоличестваОСУДопустимо    = Параметры.УточнениеКоличестваОСУДопустимо;
	
	ПараметрыСканирования = ОбщегоНазначения.СкопироватьРекурсивно(Параметры.ПараметрыСканирования);
	Склад                 = ПараметрыСканирования.Склад;
	ВидПродукции          = Параметры.ВидПродукции;
	
	ПараметрыУказанияСерий = ОбщегоНазначения.СкопироватьРекурсивно(ПараметрыСканирования.ПараметрыУказанияСерий);
	ИнтеграцияИСПереопределяемый.ЗаполнитьПараметрыУказанияСерий(ПараметрыУказанияСерий,
		Метаданные.ОбщиеФормы.ФормаУточненияПодобраннойПродукцииИСМП, ЭтотОбъект);
	Количество = 1;
	
	Номенклатура   = Параметры.Номенклатура;
	Характеристика = Параметры.Характеристика;
	Серия          = Параметры.Серия;
	НоменклатураПриИзмененииСервер();
	
	КоличествоПодобрано                                   = Параметры.КоличествоПодобрано;
	КоличествоПодобраноВзвешено                           = Параметры.КоличествоПодобраноВзвешено;
	КоличествоПодобраноВзвешеноОСУ                        = Параметры.КоличествоПодобраноВзвешеноОСУ;
	КоличествоПотребительскихУпаковок                     = Параметры.КоличествоПотребительскихУпаковок;
	КоличествоПотребительскихУпаковокТребующихВзвешивания = Параметры.КоличествоПотребительскихУпаковокТребующихВзвешивания;
	КоличествоПотребительскихУпаковокОСУ                  = Параметры.КоличествоПотребительскихУпаковокОСУ;
	КоличествоПотребительскихУпаковокДляРедактирования    = ?(ДопустимаПроизвольнаяЕдиницаУчета, КоличествоПотребительскихУпаковок, КоличествоПодобрано);
	
	Если КоличествоПотребительскихУпаковок > 0 Тогда
		УточнениеКоличестваТовараДопустимо = Не ТребуетВзвешивания Или КоличествоПотребительскихУпаковокТребующихВзвешивания > 0;
	КонецЕсли;
	
	GTIN = Параметры.GTIN;
	Элементы.GTIN.СписокВыбора.ЗагрузитьЗначения(Параметры.КодыGTIN.ВыгрузитьЗначения());
	
	Если Не ЗначениеЗаполнено(GTIN)
		И Элементы.GTIN.СписокВыбора.Количество() = 1 Тогда
		GTIN = Элементы.GTIN.СписокВыбора[0].Значение;
	КонецЕсли;
	
	ЗаполнитьИдентификаторыПроисхожденияВЕТИС();
	ЗаполнитьСрокГодности();
	
	Если Не УточнениеДанныхОТовареДопустимо Тогда
		Элементы.Номенклатура.ТолькоПросмотр   = Истина;
		Элементы.Характеристика.ТолькоПросмотр = Истина;
		
		Элементы.ГруппаДанныеВЕТИС.ТолькоПросмотр  = Истина;
		Элементы.ГруппаСрокГодности.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Элементы.ГруппаGTIN.Видимость = УточнениеКоличестваОСУДопустимо;
	Элементы.GTIN.ТолькоПросмотр = ЗначениеЗаполнено(GTIN);
	
КонецПроцедуры

&НаСервере
Процедура НоменклатураПриИзмененииСервер()
	
	СобытияФормИСПереопределяемый.ПриИзмененииНоменклатуры(ЭтотОбъект, ЭтотОбъект,, ПараметрыУказанияСерий);
	
	УказатьСрокГодности = ПараметрыСканирования.Свойство("ЗаполнятьСрокГодности")
		И ПараметрыСканирования.ЗаполнятьСрокГодности
		И ИнтеграцияИСКлиентСервер.ЭтоМолочнаяПродукцияИСМП(ВидПродукции);
	
	Если УказатьИдентификаторВЕТИС И ЗначениеЗаполнено(ИдентификаторПроисхожденияВЕТИС) Тогда
		
		ДанныеСопоставления = Новый Структура;
		ДанныеСопоставления.Вставить("Номенклатура", Номенклатура);
		ДанныеСопоставления.Вставить("Характеристика", Характеристика);
		ДанныеСопоставления.Вставить("Серия", Серия);
		Модуль = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияИСМПВЕТИС");
		Если Не Модуль.НоменклатураСоответствуетСопоставленнойПродукцииВЕТИСПоИдентификаторуПроисхождения(
				ИдентификаторПроисхожденияВЕТИС, ДанныеСопоставления) Тогда
			ИдентификаторПроисхожденияВЕТИС = Неопределено;
		ИначеЕсли УказатьСрокГодности Тогда
			ДанныеВЕТИС              = ДанныеИдентификаторовПроисхожденияВЕТИС(ИдентификаторПроисхожденияВЕТИС);
			ГоденДо                  = ДанныеВЕТИС[ИдентификаторПроисхожденияВЕТИС].СрокГодности;
			СкоропортящаясяПродукция = ДанныеВЕТИС[ИдентификаторПроисхожденияВЕТИС].СкоропортящаясяПродукция;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПроизвольнаяЕдиницаУчета Тогда
		Если ТребуетВзвешивания Тогда
			КоличествоВПотребительскойУпаковке = 0;
		Иначе
			КоличествоВПотребительскойУпаковке = РегистрыСведений.ОписаниеНоменклатурыИС.ПолучитьОписание(Номенклатура)[Номенклатура].КоличествоВПотребительскойУпаковке;
		КонецЕсли;
	Иначе
		КоличествоВПотребительскойУпаковке = 1;
	КонецЕсли;
	
	ОбновитьОтображениеПоляКоличество();
	ОбновитьОтображениеПоляКоличествоОСУ();
	ОбновитьДанныеGTIN();
	
	СобытияФормИС.ПрименитьУсловноеОформлениеКПолю(ЭтотОбъект, "Характеристика");
	СобытияФормИС.ПрименитьУсловноеОформлениеКПолю(ЭтотОбъект, "Серия");
	ОбновитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтображениеПоляКоличество()
	
	Элементы.ГруппаКоличество.Видимость = УточнениеПодобранногоКоличестваМерногоТовара(ЭтотОбъект)
		Или УточнениеПодобранногоКоличестваМерногоТовараОСУ(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтображениеПоляКоличествоОСУ()
	
	Элементы.ГруппаКоличествоОСУ.Видимость = УточнениеКоличестваОСУДопустимо;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьДоступностьЭлементов()
	
	Если УказатьСрокГодности Тогда
		Элементы.ГруппаСрокГодности.Видимость = Истина;
	ИначеЕсли ЗначениеЗаполнено(ГоденДо) Тогда
		Элементы.ГруппаСрокГодности.Видимость = Истина;
		Элементы.ГруппаСрокГодности.ТолькоПросмотр = Истина;
	Иначе
		Элементы.ГруппаСрокГодности.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеИдентификаторовПроисхожденияВЕТИС(ИдентификаторыПроисхождения)
	
	Модуль = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияИСМПВЕТИС");
	Возврат Модуль.ДанныеИдентификаторовПроисхождения(ИдентификаторыПроисхождения);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьИдентификаторыПроисхожденияВЕТИС()
	
	УказатьИдентификаторВЕТИС = ПараметрыСканирования.Свойство("ЗаполнятьДанныеВЕТИС")
		И ПараметрыСканирования.ЗаполнятьДанныеВЕТИС;
	
	Если Не УказатьИдентификаторВЕТИС Тогда
		Возврат;
	Иначе
		Элементы.ИдентификаторПроисхожденияВЕТИС.АвтоОтметкаНезаполненного = ПараметрыСканирования.ЗаполнятьДанныеВЕТИС;
	КонецЕсли;
	
	ИдентификаторыВЕТИС = Новый Массив;
	
	Если ТипЗнч(Параметры.ИдентификаторыПроисхожденияВЕТИС) = Тип("Массив") Тогда
		ИдентификаторыВЕТИС = Параметры.ИдентификаторыПроисхожденияВЕТИС;
	ИначеЕсли ЗначениеЗаполнено(Параметры.ИдентификаторыПроисхожденияВЕТИС) Тогда
		ИдентификаторПроисхожденияВЕТИС = Параметры.ИдентификаторыПроисхожденияВЕТИС;
		ИдентификаторыВЕТИС.Добавить(ИдентификаторПроисхожденияВЕТИС);
	КонецЕсли;
	
	ДобавитьИдентификаторыВЕТИСВСписокВыбора(ИдентификаторыВЕТИС, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьИдентификаторыВЕТИСВСписокВыбора(Идентификаторы, РежимОткрытияСпискаВыбора = Ложь)
	
	Если Идентификаторы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Модуль = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияИСМПВЕТИС");
	ДанныеИдентификаторовПроисхождения = Модуль.ДанныеИдентификаторовПроисхождения(Идентификаторы);
	
	Для Каждого КлючИЗначение Из ДанныеИдентификаторовПроисхождения Цикл
		
		ПредставлениеСсылки = СтрШаблон(НСтр("ru = '%1'"), КлючИЗначение.Значение.Представление);
		Элементы.ИдентификаторПроисхожденияВЕТИС.СписокВыбора.Вставить(0, КлючИЗначение.Ключ, ПредставлениеСсылки);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСрокГодности()
	
	УказатьСрокГодности = ПараметрыСканирования.Свойство("ЗаполнятьСрокГодности")
		И ПараметрыСканирования.ЗаполнятьСрокГодности
		И ИнтеграцияИСКлиентСервер.ЭтоМолочнаяПродукцияИСМП(ВидПродукции);
	
	Если Не УказатьСрокГодности Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ГоденДо) Тогда
		ГоденДо                  = Параметры.ГоденДо;
		СкоропортящаясяПродукция = Параметры.СкоропортящаясяПродукция;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтотОбъект, "Характеристика", "ХарактеристикиИспользуются");
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(
		ЭтотОбъект, "Серия", "СтатусУказанияСерий", "ТипНоменклатуры");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементовПриСозданииНаСервере()
	
	ОбновитьВидимостьДоступностьЭлементов();
	
	Если УказатьИдентификаторВЕТИС Тогда
		Элементы.ГруппаДанныеВЕТИС.Видимость = Истина;
	ИначеЕсли ЗначениеЗаполнено(ИдентификаторПроисхожденияВЕТИС) Тогда
		Элементы.ГруппаДанныеВЕТИС.Видимость = Истина;
		Элементы.ГруппаДанныеВЕТИС.ТолькоПросмотр = Истина;
	Иначе
		Элементы.ГруппаДанныеВЕТИС.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВесЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		
		КоличествоПодобрано = РезультатВыполнения.Вес;
		
	Иначе
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтрШаблон(НСтр("ru = 'При выполнении операции произошла ошибка: %1'"),
				РезультатВыполнения.ОписаниеОшибки));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокЭлементаИдентификаторВЕТИС()
	
	Элементы.ИдентификаторПроисхожденияВЕТИС.Заголовок = ИнтеграцияИСМПВЕТИСКлиентСервер.ИмяИдентификатораПроисхожденияВЕТИС();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьФорматДатыГоденДо(Форма)
	
	Если Форма.СкоропортящаясяПродукция Тогда
		ФорматДаты = "ДФ='dd.MM.yyyy HH:mm';";
	Иначе
		ФорматДаты = "ДФ=dd.MM.yyyy;";
	КонецЕсли;
	
	Форма.Элементы.ГоденДо.Формат               = ФорматДаты;
	Форма.Элементы.ГоденДо.ФорматРедактирования = ФорматДаты;
	
КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить(ЭтотОбъект.ИмяФормы, "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция УточнениеПодобранногоКоличестваМерногоТовара(Форма)
	
	Возврат Форма.ТребуетВзвешивания
		И Форма.УточнениеКоличестваТовараДопустимо
		И Не Форма.ЗапрашиватьКоличествоМерногоТовара;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция УточнениеПодобранногоКоличестваМерногоТовараОСУ(Форма)
	
	Возврат Форма.ТребуетВзвешивания
		И Форма.УточнениеКоличестваОСУДопустимо;
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеGTIN()
	
	Элементы.GTIN.СписокВыбора.ЗагрузитьЗначения(МассивЗначенийGTINДляВыбора());
	
	Если Элементы.GTIN.СписокВыбора.НайтиПоЗначению(GTIN) = Неопределено Тогда
		Если ПроверкаИПодборПродукцииИСМПКлиентСервер.ЭтоДокументПриобретения(ПараметрыСканирования.СсылкаНаОбъект)
			И ЗначениеЗаполнено(GTIN) Тогда
			Элементы.GTIN.СписокВыбора.Добавить(GTIN);
		Иначе
			GTIN = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(GTIN)
		И Элементы.GTIN.СписокВыбора.Количество() = 1 Тогда
		GTIN = Элементы.GTIN.СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция МассивЗначенийGTINДляВыбора()
	
	ДопустимыеВидыУпаковок = Новый Массив;
	ДопустимыеВидыУпаковок.Добавить(Перечисления.ВидыУпаковокИС.Потребительская);
	ДопустимыеВидыУпаковок.Добавить(Перечисления.ВидыУпаковокИС.Набор);
	ДопустимыеВидыУпаковок.Добавить(Перечисления.ВидыУпаковокИС.Неопределен);
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("Номенклатура",               Номенклатура);
	ПараметрыВыбора.Вставить("Характеристика",             Характеристика);
	ПараметрыВыбора.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);
	
	Возврат ИнтеграцияИСМП.МассивЗначенийGTINДляВыбора(ПараметрыВыбора, ЭтотОбъект, Ложь, ДопустимыеВидыУпаковок);
	
КонецФункции

#КонецОбласти