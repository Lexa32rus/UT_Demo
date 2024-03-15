#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЧекККМ") Тогда
		Если Документы.ЧекККМКоррекции.ЕстьКоррекцияПоЧекуККМ(ДанныеЗаполнения) Тогда
			ВызватьИсключение НСтр("ru = 'По Чеку ККМ введен Чек ККМ коррекции. Ввод нового Чека ККМ возврат запрещен!'");
		КонецЕсли;
		Если Документы.ВозвратТоваровОтКлиента.ЕстьВозвратТоваровОтКлиентаПоЧекуККМ(ДанныеЗаполнения) Тогда
			ВызватьИсключение НСтр("ru = 'По Чеку ККМ введен Возврат товаров от клиента. Ввод нового Чека ККМ возврат запрещен!'");
		КонецЕсли;
		ПредставлениеОтложенногоЧека = "";
		Если ЗначениеЗаполнено(Документы.ЧекККМВозврат.НайтиОтложенныйЧекККМВозвратПоЧекуККМ(ДанныеЗаполнения, ПредставлениеОтложенногоЧека)) Тогда
			ТекстСообщения = НСтр("ru = 'По Чеку ККМ есть отложенный %1. Ввод нового Чека ККМ возврат запрещен!'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ПредставлениеОтложенногоЧека);
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
		
		ЗаполнитьПоЧекуККМ(ДанныеЗаполнения, ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Товары") Тогда
		Если Документы.ЧекККМКоррекции.ЕстьКоррекцияПоЧекуККМ(ДанныеЗаполнения.ЧекККМ) Тогда
			ВызватьИсключение НСтр("ru = 'По Чеку ККМ введен Чек ККМ коррекции. Ввод нового Чека ККМ возврат запрещен!'");
		КонецЕсли;
		Если Документы.ВозвратТоваровОтКлиента.ЕстьВозвратТоваровОтКлиентаПоЧекуККМ(ДанныеЗаполнения.ЧекККМ) Тогда
			ВызватьИсключение НСтр("ru = 'По Чеку ККМ введен Возврат товаров от клиента. Ввод нового Чека ККМ возврат запрещен!'");
		КонецЕсли;
		ПредставлениеОтложенногоЧека = "";
		Если ЗначениеЗаполнено(Документы.ЧекККМВозврат.НайтиОтложенныйЧекККМВозвратПоЧекуККМ(ДанныеЗаполнения.ЧекККМ, ПредставлениеОтложенногоЧека)) Тогда
			ТекстСообщения = НСтр("ru = 'По Чеку ККМ есть отложенный %1. Ввод нового Чека ККМ возврат запрещен!'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ПредставлениеОтложенногоЧека);
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
		
		ЗаполнитьПоЧекуККМ(ДанныеЗаполнения.ЧекККМ, ДанныеЗаполнения.ЧекККМ);
		Если ДанныеЗаполнения.Свойство("Кассир") и ЗначениеЗаполнено(ДанныеЗаполнения.Кассир) Тогда  		
			Кассир = ДанныеЗаполнения.Кассир;
		КонецЕсли;
		
		Товары.Очистить();
		
		ВозвращаемыеТовары = ПолучитьИзВременногоХранилища(ДанныеЗаполнения.Товары);
		
		Для Каждого СтрокаТЧ Из ВозвращаемыеТовары Цикл
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если Не ДанныеЗаполнения.Свойство("ЧтениеКомандФормы") Тогда
			ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		КонецЕсли;
		
	Иначе
		
		КассаККМ = Справочники.КассыККМ.КассаККМФискальныйРегистраторДляРМК();
		Если ЗначениеЗаполнено(КассаККМ) Тогда
			ЗаполнитьДокументПоКассеККМ(КассаККМ);
		Иначе
			ВызватьИсключение НСтр("ru = 'Для текущего рабочего места не настроено подключаемое оборудование: Фискальное устройство'");
		КонецЕсли;
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	БонусныеБаллыСервер.ЗаполнитьБонусныеБаллыЧекККМВозврат(ЭтотОбъект);
	
	ЧекККМВозвратЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если Статус = Перечисления.СтатусыЧековККМ.Пробит И РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		
		Отказ = Истина;
		ТекстОшибки = НСтр("ru='Чек ККМ на возврат пробит. Отмена проведения невозможна.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект);
		
		Возврат;
		
	КонецЕсли;
	
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЧекККМВозврат));
	
	БонусныеБаллыСервер.ЗаполнитьБонусныеБаллыЧекККМВозврат(ЭтотОбъект);
	
	ЧекККМВозвратЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ВызватьИсключение НСтр("ru = 'Чек на возврат вводится только на основании чека ККМ.'");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЧекККМ.КассоваяСмена КАК КассоваяСмена,
	|	ЧекККМ.Дата          КАК Дата,
	|	ЧекККМ.Проведен      КАК Проведен,
	|	ЧекККМ.Статус        КАК Статус
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &ЧекККМ
	|;
	|
	|///////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура   КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Количество     КАК Количество
	|ПОМЕСТИТЬ ТЧТовары
	|ИЗ
	|	&ТЗТовары КАК Товары
	|;
	|
	|///////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Количество     КАК КоличествоВЧеке,
	|	Товары.Номенклатура   КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Количество     КАК Количество
	|ПОМЕСТИТЬ врТовары
	|ИЗ
	|	Документ.ЧекККМ.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ЧекККМ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	0                     КАК КоличествоВЧеке,
	|	Товары.Номенклатура   КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	-Товары.Количество     КАК Количество
	|ИЗ
	|	Документ.ЧекККМВозврат.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка.ЧекККМ = &ЧекККМ
	|	И Товары.Ссылка <> &ЧекККМВозврат
	|	И Товары.Ссылка.Проведен
	|	И Товары.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	0                     КАК КоличествоВЧеке,
	|	Товары.Номенклатура   КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	-Товары.Количество    КАК Количество
	|ИЗ
	|	ТЧТовары КАК Товары
	|
	|;
	|
	|///////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура                  КАК Номенклатура,
	|	Товары.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Товары.Характеристика                КАК Характеристика,
	|	СУММА(Товары.Количество)             КАК Количество,
	|	СУММА(Товары.КоличествоВЧеке)        КАК КоличествоВЧеке
	|ИЗ
	|	врТовары КАК Товары
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Характеристика
	|ИМЕЮЩИЕ
	|	СУММА(Товары.Количество) < 0
	|";
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ЧекККМ",        ЧекККМ);
	Запрос.УстановитьПараметр("ЧекККМВозврат", Ссылка);
	Запрос.УстановитьПараметр("ТЗТовары", Товары.Выгрузить(,"Номенклатура, Характеристика, Количество"));
	
	Результат = Запрос.ВыполнитьПакет(); 
	
	Выборка = Результат[0].Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Если Не Выборка.Проведен Тогда
			ТекстОшибки = НСтр("ru='Чек ККМ не проведен'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "ЧекККМ",, Отказ);
		КонецЕсли;
		
		Если Выборка.Статус <> Перечисления.СтатусыЧековККМ.Пробит Тогда
			ТекстОшибки = НСтр("ru='Чек ККМ продажи не пробит'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "ЧекККМ",, Отказ);
		КонецЕсли;
		
		ТекстОшибки = "";
		Если Не РозничныеПродажи.СменаОткрыта(КассоваяСмена, Дата, ТекстОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "КассоваяСмена",, Отказ);
		КонецЕсли;
		
		ВыборкаПоТоварам = Результат[3].Выбрать();
		Если Статус <> Перечисления.СтатусыЧековККМ.Пробит Тогда
			
			Пока ВыборкаПоТоварам.Следующий() Цикл
				
				Остаток = -ВыборкаПоТоварам.Количество;
				ТоварПрисутствуетВИсходномЧеке = ВыборкаПоТоварам.КоличествоВЧеке > 0;
				
				МассивСтрок = Товары.НайтиСтроки(Новый Структура("Номенклатура, Характеристика", ВыборкаПоТоварам.Номенклатура, ВыборкаПоТоварам.Характеристика));
				
				// Изменим порядок строк на обратный
				НайденныеСтроки = Новый Массив; // Массив из СтрокаТабличнойЧасти
				Для Каждого Строка Из МассивСтрок Цикл
					НайденныеСтроки.Вставить(0,Строка);
				КонецЦикла;
				
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					
					Количество = ?(НайденнаяСтрока.Количество >= Остаток, Остаток, НайденнаяСтрока.Количество);
					Остаток = Остаток - Количество;
					
					Если ТоварПрисутствуетВИсходномЧеке Тогда
						ТекстОшибки = НСтр("ru='Количество возвращаемого товара превышает количество проданного на %1% %2%'");
						ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1%", Количество * (НайденнаяСтрока.КоличествоУпаковок / НайденнаяСтрока.Количество));
						ТекстОшибки = СтрЗаменить(ТекстОшибки, "%2%", ?(ЗначениеЗаполнено(НайденнаяСтрока.Упаковка), НайденнаяСтрока.Упаковка, НайденнаяСтрока.Номенклатура.ЕдиницаИзмерения));
						
						АдресОшибки = НСтр("ru='в строке %НомерСтроки% списка ""Товары""'");
						АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", НайденнаяСтрока.НомерСтроки);
						
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							ТекстОшибки + " " + АдресОшибки,
							ЭтотОбъект,
							ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", НайденнаяСтрока.НомерСтроки, "КоличествоУпаковок"),
							,
							Отказ);
					Иначе
						ТекстОшибки = НСтр("ru='Номенклатура %1% не продавалась по чеку %2%. Удалите номенклатурную позицию'");
						ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1%", НайденнаяСтрока.Номенклатура);
						ТекстОшибки = СтрЗаменить(ТекстОшибки, "%2%", ЧекККМ);
						
						АдресОшибки = НСтр("ru='в строке %НомерСтроки% списка ""Товары""'");
						АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", НайденнаяСтрока.НомерСтроки);
						
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							ТекстОшибки + " " + АдресОшибки,
							ЭтотОбъект,
							ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", НайденнаяСтрока.НомерСтроки, "Номенклатура"),
							,
							Отказ);
					КонецЕсли;
					
					Если Остаток <= 0 Тогда
						Прервать;
					КонецЕсли;
					
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не СкладыСервер.ИспользоватьСкладскиеПомещения(Склад, Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Помещение");
	КонецЕсли;
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЧекККМВозврат),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	
	ЧекККМВозвратЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

// Процедура заполнения документа на основании расходного кассового ордера.
//
// Параметры:
//	ДокументОснование - ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств - Заявка на платеж
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоЧекуККМ(Знач ДокументОснование, ДанныеЗаполнения)
	
	// Заполним данные шапки документа.
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЧекККМ.Валюта КАК Валюта,
	|	ЧекККМ.Ссылка КАК ЧекККМ,
	|	ЧекККМ.ВидЦены КАК ВидЦены,
	|	ЧекККМ.Организация КАК Организация,
	|	ЧекККМ.КассаККМ КАК КассаККМ,
	|	ЧекККМ.Склад КАК Склад,
	|	ЧекККМ.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ЧекККМ.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЧекККМ.Статус КАК Статус,
	|	ЧекККМ.Проведен КАК Проведен,
	|	ЧекККМ.Партнер КАК Партнер,
	|	ЧекККМ.КартаЛояльности КАК КартаЛояльности
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &Ссылка
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НоменклатураЕГАИС КАК НоменклатураЕГАИС,
	|	Товары.НоменклатураНабора КАК НоменклатураНабора,
	|	Товары.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Количество КАК Количество,
	|	ВЫРАЗИТЬ(ВЫБОР
	|		КОГДА Товары.СуммаРучнойСкидки + Товары.СуммаАвтоматическойСкидки + Товары.СуммаБонусныхБалловКСписаниюВВалюте = 0
	|		ИЛИ Товары.КоличествоУпаковок = 0
	|			ТОГДА Товары.Цена
	|		ИНАЧЕ Товары.Сумма / Товары.КоличествоУпаковок
	|	КОНЕЦ КАК ЧИСЛО(31, 2)) КАК Цена,
	|	Товары.Сумма КАК Сумма,
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	Товары.СуммаНДС КАК СуммаНДС,
	|	Товары.Помещение КАК Помещение,
	|	Товары.Продавец КАК Продавец
	|ПОМЕСТИТЬ врТовары
	|ИЗ
	|	Документ.ЧекККМ.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Товары.НоменклатураЕГАИС КАК НоменклатураЕГАИС,
	|	Товары.НоменклатураНабора КАК НоменклатураНабора,
	|	Товары.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	Товары.Номенклатура,
	|	Товары.Номенклатура.ТипНоменклатуры,
	|	Товары.Характеристика,
	|	Товары.Серия,
	|	Товары.СтатусУказанияСерий,
	|	Товары.Упаковка,
	|	-Товары.КоличествоУпаковок,
	|	-Товары.Количество,
	|	Товары.Цена,
	|	-Товары.Сумма,
	|	Товары.СтавкаНДС,
	|	-Товары.СуммаНДС,
	|	Товары.Помещение,
	|	Товары.Продавец
	|ИЗ
	|	Документ.ЧекККМВозврат.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка.ЧекККМ = &Ссылка
	|	И Товары.Ссылка.Проведен
	|	И Товары.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НоменклатураЕГАИС КАК НоменклатураЕГАИС,
	|	Товары.НоменклатураНабора КАК НоменклатураНабора,
	|	Товары.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	Товары.Цена КАК Цена,
	|	Товары.Помещение КАК Помещение,
	|	Товары.Продавец КАК Продавец,
	|	СУММА(Товары.КоличествоУпаковок) КАК КоличествоУпаковок,
	|	СУММА(Товары.Количество) КАК Количество,
	|	СУММА(Товары.Сумма) КАК Сумма,
	|	СУММА(Товары.СуммаНДС) КАК СуммаНДС
	|ИЗ
	|	врТовары КАК Товары
	|СГРУППИРОВАТЬ ПО
	|	Товары.НоменклатураЕГАИС,
	|	Товары.НоменклатураНабора,
	|	Товары.ХарактеристикаНабора,
	|	Товары.Номенклатура,
	|	Товары.Номенклатура.ТипНоменклатуры,
	|	Товары.Характеристика,
	|	Товары.СтатусУказанияСерий,
	|	Товары.Серия,
	|	Товары.Помещение,
	|	Товары.Продавец,
	|	Товары.Упаковка,
	|	Товары.СтавкаНДС,
	|	Товары.Цена
	|ИМЕЮЩИЕ
	|	СУММА(Товары.Количество) > 0
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Серии.Номенклатура КАК Номенклатура,
	|	Серии.Характеристика КАК Характеристика,
	|	Серии.Серия КАК Серия,
	|	Серии.Помещение КАК Помещение,
	|	Серии.Количество КАК Количество
	|ПОМЕСТИТЬ врСерии
	|ИЗ
	|	Документ.ЧекККМ.Серии КАК Серии
	|ГДЕ
	|	Серии.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Серии.Номенклатура,
	|	Серии.Характеристика,
	|	Серии.Серия,
	|	Серии.Помещение,
	|	-Серии.Количество
	|ИЗ
	|	Документ.ЧекККМВозврат.Серии КАК Серии
	|ГДЕ
	|	Серии.Ссылка.ЧекККМ = &Ссылка
	|	И Серии.Ссылка.Проведен
	|	И Серии.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Серии.Номенклатура КАК Номенклатура,
	|	Серии.Характеристика КАК Характеристика,
	|	Серии.Серия КАК Серия,
	|	Серии.Помещение КАК Помещение,
	|	СУММА(Серии.Количество) КАК Количество
	|ИЗ
	|	врСерии КАК Серии
	|СГРУППИРОВАТЬ ПО
	|	Серии.Номенклатура,
	|	Серии.Характеристика,
	|	Серии.Серия,
	|	Серии.Помещение
	|ИМЕЮЩИЕ
	|	СУММА(Серии.Количество) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОплатыПлатежнымиКартами.ВидОплаты КАК ВидОплаты,
	|	ОплатыПлатежнымиКартами.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	ОплатыПлатежнымиКартами.КодАвторизации КАК КодАвторизации,
	|	ОплатыПлатежнымиКартами.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	ОплатыПлатежнымиКартами.Сумма КАК Сумма,
	|	ОплатыПлатежнымиКартами.ОплатаОтменена КАК ОплатаОтменена
	|ПОМЕСТИТЬ ВозвратОплатыПлатежнымиКартамиПоЧеку
	|ИЗ
	|	Документ.ЧекККМВозврат КАК ЧекККМВозврат
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЧекККМВозврат.ОплатаПлатежнымиКартами КАК ОплатыПлатежнымиКартами
	|		ПО (ОплатыПлатежнымиКартами.Ссылка = ЧекККМВозврат.Ссылка)
	|ГДЕ
	|	ЧекККМВозврат.ЧекККМ = &Ссылка
	|	И ЧекККМВозврат.Проведен
	|	И ЧекККМВозврат.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОплатаПлатежнымиКартами.ВидОплаты КАК ВидОплаты,
	|	ОплатаПлатежнымиКартами.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	ОплатаПлатежнымиКартами.КодАвторизации КАК КодАвторизации,
	|	ОплатаПлатежнымиКартами.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	ОплатаПлатежнымиКартами.Сумма КАК Сумма,
	|	ОплатаПлатежнымиКартами.ИдентификаторКорзины КАК ИдентификаторКорзины,
	|	ОплатаПлатежнымиКартами.СсылочныйНомер КАК СсылочныйНомер,
	|	ОплатаПлатежнымиКартами.НомерЧекаЭТ КАК НомерЧекаЭТ
	|ИЗ
	|	Документ.ЧекККМ.ОплатаПлатежнымиКартами КАК ОплатаПлатежнымиКартами
	|ГДЕ
	|	ОплатаПлатежнымиКартами.Ссылка = &Ссылка
	|	И
	|	НЕ (ОплатаПлатежнымиКартами.ВидОплаты
	|	  , ОплатаПлатежнымиКартами.ЭквайринговыйТерминал
	|	  , ОплатаПлатежнымиКартами.КодАвторизации
	|	  , ОплатаПлатежнымиКартами.НомерПлатежнойКарты
	|     , ОплатаПлатежнымиКартами.Сумма
	|	  , ИСТИНА) В
	|		(ВЫБРАТЬ
	|			ВозвратОплатыПлатежнымиКартамиПоЧеку.ВидОплаты,
	|			ВозвратОплатыПлатежнымиКартамиПоЧеку.ЭквайринговыйТерминал,
	|			ВозвратОплатыПлатежнымиКартамиПоЧеку.КодАвторизации,
	|			ВозвратОплатыПлатежнымиКартамиПоЧеку.НомерПлатежнойКарты,
	|			ВозвратОплатыПлатежнымиКартамиПоЧеку.Сумма,
	|			ВозвратОплатыПлатежнымиКартамиПоЧеку.ОплатаОтменена
	|		ИЗ
	|			ВозвратОплатыПлатежнымиКартамиПоЧеку КАК ВозвратОплатыПлатежнымиКартамиПоЧеку)
	|;";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатЗапроса[0].Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка, ,"Статус, Проведен");
	
	Если РезультатЗапроса[2].Пустой() Тогда
		ТекстОшибки = НСтр("ru='По данному чеку ККМ все товары уже возвращены.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если Не Выборка.Проведен Тогда
		ТекстОшибки = НСтр("ru='Чек ККМ не проведен. Ввод на основании невозможен.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если Выборка.Статус <> Перечисления.СтатусыЧековККМ.Пробит Тогда
		ТекстОшибки = НСтр("ru='Чек ККМ не пробит. Ввод на основании невозможен.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	СтруктураСостояниеКассовойСмены = РозничныеПродажи.ПолучитьСостояниеКассовойСмены(Выборка.КассаККМ);
	КассоваяСмена = СтруктураСостояниеКассовойСмены.КассоваяСмена;
	
	Товары.Загрузить(РезультатЗапроса[2].Выгрузить());
	Серии.Загрузить(РезультатЗапроса[4].Выгрузить());
	ОплатаПлатежнымиКартами.Загрузить(РезультатЗапроса[6].Выгрузить());
	
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	
КонецПроцедуры

// Инициализирует данные документа.
//
// Параметры:
//		ДокументОбъект - Объект, который будет заполнен.
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Кассир) Тогда
		Кассир = Пользователи.ТекущийПользователь();		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоКассеККМ(КассаККМ)
	
	СостояниеКассовойСмены = РозничныеПродажи.ПолучитьСостояниеКассовойСмены(КассаККМ);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеКассовойСмены,,"Кассир");
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("КассаККМ") Тогда
		ЗаполнитьДокументПоКассеККМ(ДанныеЗаполнения.КассаККМ);
	ИначеЕсли ДанныеЗаполнения.Свойство("КассоваяСмена") И ТипЗнч(ДанныеЗаполнения.КассоваяСмена) = Тип("ДокументСсылка.КассоваяСмена") Тогда
		КассаККМДляЗаполнения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.КассоваяСмена, "КассаККМ");
		Если Не КассаККМДляЗаполнения = Неопределено Тогда
			ЗаполнитьДокументПоКассеККМ(КассаККМДляЗаполнения);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

#КонецОбласти

#КонецОбласти

#КонецЕсли