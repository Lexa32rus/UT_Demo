///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

//++ Локализация

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

Процедура ОбновитьИнформативныеЦеныНоменклатуры(ТолькоИзменения = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.ИнформативныеЦеныНоменклатуры");
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		БлокировкаДанных.Заблокировать();
	
		Запрос = Новый Запрос;
		
		ТекстЗапросаОбщий = "ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	СинхронизацияДанныхЧерезУниверсальныйФорматВидыЦенНоменклатуры.ВидЦенНоменклатуры КАК ВидЦены
			|ПОМЕСТИТЬ ВТ_ОтборВидыЦен
			|ИЗ
			|	ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ВидыЦенНоменклатуры КАК СинхронизацияДанныхЧерезУниверсальныйФорматВидыЦенНоменклатуры
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
			|	ЦеныНоменклатурыСрезПоследних.Характеристика КАК ХарактеристикаНоменклатуры,
			|	ЦеныНоменклатурыСрезПоследних.ВидЦены КАК ПравилоФормированиеЦены,
			|	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
			|	ЦеныНоменклатурыСрезПоследних.Упаковка КАК Упаковка,
			|	ЦеныНоменклатурыСрезПоследних.Валюта КАК Валюта
			|ПОМЕСТИТЬ ВТ_АктуальныеЦены
			|ИЗ
			|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
			|			,
			|			НЕ Цена = 0
			|				И ВидЦены В
			|					(ВЫБРАТЬ
			|						ВТ_ОтборВидыЦен.ВидЦены
			|					ИЗ
			|						ВТ_ОтборВидыЦен КАК ВТ_ОтборВидыЦен)) КАК ЦеныНоменклатурыСрезПоследних
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	СоглашенияСКлиентамиТовары.Номенклатура,
			|	СоглашенияСКлиентамиТовары.Характеристика,
			|	СоглашенияСКлиентамиТовары.Ссылка,
			|	СоглашенияСКлиентамиТовары.Цена,
			|	СоглашенияСКлиентамиТовары.Упаковка,
			|	СоглашенияСКлиентамиТовары.Ссылка.Валюта
			|ИЗ
			|	Справочник.СоглашенияСКлиентами.Товары КАК СоглашенияСКлиентамиТовары
			|ГДЕ
			|	НЕ СоглашенияСКлиентамиТовары.Ссылка.ПометкаУдаления
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура,
			|	ХарактеристикаНоменклатуры,
			|	ПравилоФормированиеЦены";
		
		Если ТолькоИзменения Тогда
			
			ТекстЗапросаДобавочный = "ВЫБРАТЬ
				|	ИнформативныеЦеныНоменклатуры.Номенклатура КАК Номенклатура,
				|	ИнформативныеЦеныНоменклатуры.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
				|	ИнформативныеЦеныНоменклатуры.ПравилоФормированиеЦены КАК ПравилоФормированиеЦены,
				|	ИнформативныеЦеныНоменклатуры.Цена КАК Цена,
				|	ИнформативныеЦеныНоменклатуры.Валюта КАК Валюта,
				|	ИнформативныеЦеныНоменклатуры.Упаковка КАК Упаковка
				|ПОМЕСТИТЬ ВТ_ИнформативныеЦены
				|ИЗ
				|	РегистрСведений.ИнформативныеЦеныНоменклатуры КАК ИнформативныеЦеныНоменклатуры
				|
				|ИНДЕКСИРОВАТЬ ПО
				|	Номенклатура,
				|	ХарактеристикаНоменклатуры,
				|	ПравилоФормированиеЦены
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ВТ_ИнформативныеЦены.Номенклатура КАК Номенклатура,
				|	ВТ_ИнформативныеЦены.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
				|	ВТ_ИнформативныеЦены.ПравилоФормированиеЦены КАК ПравилоФормированиеЦены,
				|	ВТ_АктуальныеЦены.Цена КАК Цена
				|ПОМЕСТИТЬ ВТ_Удаление
				|ИЗ
				|	ВТ_ИнформативныеЦены КАК ВТ_ИнформативныеЦены
				|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_АктуальныеЦены КАК ВТ_АктуальныеЦены
				|		ПО (ВТ_АктуальныеЦены.Номенклатура = ВТ_ИнформативныеЦены.Номенклатура)
				|			И (ВТ_АктуальныеЦены.ХарактеристикаНоменклатуры = ВТ_ИнформативныеЦены.ХарактеристикаНоменклатуры)
				|			И (ВТ_АктуальныеЦены.ПравилоФормированиеЦены = ВТ_ИнформативныеЦены.ПравилоФормированиеЦены)
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ВТ_АктуальныеЦены.Номенклатура КАК Номенклатура,
				|	ВТ_АктуальныеЦены.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
				|	ВТ_АктуальныеЦены.ПравилоФормированиеЦены КАК ПравилоФормированиеЦены,
				|	ВТ_АктуальныеЦены.Цена КАК Цена,
				|	ВТ_АктуальныеЦены.Валюта КАК Валюта,
				|	ВТ_АктуальныеЦены.Упаковка КАК Упаковка,
				|	ЕСТЬNULL(ВТ_ИнформативныеЦены.Цена, 0) КАК ИнфЦена,
				|	ЕСТЬNULL(ВТ_ИнформативныеЦены.Валюта, ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)) КАК ИнфВалюта,
				|	ЕСТЬNULL(ВТ_ИнформативныеЦены.Упаковка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) КАК ИнфУпаковка
				|ПОМЕСТИТЬ ВТ_ИзменениеДобавление
				|ИЗ
				|	ВТ_АктуальныеЦены КАК ВТ_АктуальныеЦены
				|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИнформативныеЦены КАК ВТ_ИнформативныеЦены
				|		ПО ВТ_АктуальныеЦены.Номенклатура = ВТ_ИнформативныеЦены.Номенклатура
				|			И ВТ_АктуальныеЦены.ХарактеристикаНоменклатуры = ВТ_ИнформативныеЦены.ХарактеристикаНоменклатуры
				|			И ВТ_АктуальныеЦены.ПравилоФормированиеЦены = ВТ_ИнформативныеЦены.ПравилоФормированиеЦены
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ВТ_Удаление.Номенклатура КАК Номенклатура,
				|	ВТ_Удаление.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
				|	ВТ_Удаление.ПравилоФормированиеЦены КАК ПравилоФормированиеЦены
				|ИЗ
				|	ВТ_Удаление КАК ВТ_Удаление
				|ГДЕ
				|	ВТ_Удаление.Цена ЕСТЬ NULL
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ВТ_ИзменениеДобавление.Номенклатура КАК Номенклатура,
				|	ВТ_ИзменениеДобавление.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
				|	ВТ_ИзменениеДобавление.ПравилоФормированиеЦены КАК ПравилоФормированиеЦены,
				|	ВТ_ИзменениеДобавление.Цена КАК Цена,
				|	ВТ_ИзменениеДобавление.Валюта КАК Валюта,
				|	ВТ_ИзменениеДобавление.Упаковка КАК Упаковка
				|ИЗ
				|	ВТ_ИзменениеДобавление КАК ВТ_ИзменениеДобавление
				|ГДЕ
				|	НЕ(ВТ_ИзменениеДобавление.Цена = ВТ_ИзменениеДобавление.ИнфЦена
				|				И ВТ_ИзменениеДобавление.Валюта = ВТ_ИзменениеДобавление.ИнфВалюта
				|				И ВТ_ИзменениеДобавление.Упаковка = ВТ_ИзменениеДобавление.ИнфУпаковка)";
				
			Запрос.Текст = ТекстЗапросаОбщий + ОбщегоНазначения.РазделительПакетаЗапросов() + ТекстЗапросаДобавочный;
			Результат = Запрос.ВыполнитьПакет(); 
			
			Выборка = Результат[Результат.Количество() - 2].Выбрать();
			Пока Выборка.Следующий() Цикл
				НаборДляУдаления = РегистрыСведений.ИнформативныеЦеныНоменклатуры.СоздатьНаборЗаписей();
				НаборДляУдаления.Отбор.Номенклатура.Установить(Выборка.Номенклатура);
				НаборДляУдаления.Отбор.ХарактеристикаНоменклатуры.Установить(Выборка.ХарактеристикаНоменклатуры);
				НаборДляУдаления.Отбор.ПравилоФормированиеЦены.Установить(Выборка.ПравилоФормированиеЦены);
				НаборДляУдаления.Записать(Истина);
			КонецЦикла;
			
			Выборка = Результат[Результат.Количество() - 1].Выбрать();
			Пока Выборка.Следующий() Цикл
				НоваяЗапись = РегистрыСведений.ИнформативныеЦеныНоменклатуры.СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
				НоваяЗапись.Записать(Истина);
			КонецЦикла;
			
		Иначе
			
			НЗ = РегистрыСведений.ИнформативныеЦеныНоменклатуры.СоздатьНаборЗаписей();
			НЗ.Записать(Истина);
			
			ТекстЗапросаДобавочный = "ВЫБРАТЬ
			|	ВТ_АктуальныеЦены.Номенклатура КАК Номенклатура,
			|	ВТ_АктуальныеЦены.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
			|	ВТ_АктуальныеЦены.ПравилоФормированиеЦены КАК ПравилоФормированиеЦены,
			|	ВТ_АктуальныеЦены.Цена КАК Цена,
			|	ВТ_АктуальныеЦены.Упаковка КАК Упаковка,
			|	ВТ_АктуальныеЦены.Валюта КАК Валюта
			|ИЗ
			|	ВТ_АктуальныеЦены КАК ВТ_АктуальныеЦены";
			
			Запрос.Текст = ТекстЗапросаОбщий + ОбщегоНазначения.РазделительПакетаЗапросов() + ТекстЗапросаДобавочный;
			
			НаборЗаписей = РегистрыСведений.ИнформативныеЦеныНоменклатуры.СоздатьНаборЗаписей();
			НаборЗаписей.Загрузить(Запрос.Выполнить().Выгрузить());
			
			Если НаборЗаписей.Модифицированность() Тогда
				НаборЗаписей.Записать(Ложь);
			КонецЕсли;
			
		КонецЕсли;
	
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Не удалось обновить информативные цены номенклатуры'", 
									ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;

	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

//-- Локализация