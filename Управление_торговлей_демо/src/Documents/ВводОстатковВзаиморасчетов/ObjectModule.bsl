#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Документы.ВводОстатковВзаиморасчетов.ЗаполнитьОбъектыРасчетов(ЭтотОбъект, РежимЗаписи);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ОтражатьВОперативномУчете И Не ОтражатьВБУиНУ И Не ОтражатьВУУ Тогда
		ТекстСообщения = НСтр("ru='Операция должна отражаться в одном из учетов'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , 
			"Объект.ОтражатьВОперативномУчете", , Отказ);
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ОтражатьВОперативномУчете
		И (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиКлиентов
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиПоставщикам
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовКлиентов
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовПоставщикам) Тогда
		
		ПроверитьРазрядностьНомеровОбъектовРасчета(Отказ);
		
	КонецЕсли;
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиКлиентов
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковАвансовКлиентов
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиПоставщикам
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковАвансовПоставщикам Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами");
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовКлиентов
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовПоставщикам
		Или Не ОтражатьВОперативномУчете Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.ДатаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.ДатаРасчетногоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.НомерРасчетногоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.ОбъектРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.ДокументРасчетов");
		
		ПроверитьЗаполнениеТабличнойЧастиРасчетыСПартнерами(Отказ, ХозяйственнаяОперация);
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиКлиентов
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиПоставщикам Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.ДатаРасчетногоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.НомерРасчетногоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.ОбъектРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("РасчетыСПартнерами.ДокументРасчетов");
		
		ПроверитьЗаполнениеТабличнойЧастиРасчетыСПартнерами(Отказ, ХозяйственнаяОперация);
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("ОрганизацияПолучатель");

	ИсправлениеДокументов.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка." + Метаданные().Имя) Тогда
		
		ИсправлениеДокументов.ЗаполнитьИсправление(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИсправлениеДокументов.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ВводОстатковЛокализация.ВводОстатковВзаиморасчетовПередУдалением(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ХозяйственнаяОперация") Тогда
			ХозяйственнаяОперация = ДанныеЗаполнения.ХозяйственнаяОперация;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Комментарий") Тогда
			Комментарий = ДанныеЗаполнения.Комментарий;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ЗначениеКопирования") Тогда
			ВводОстатковСервер.ЗаполнитьЗначенияПоСтаромуВводуОстатков(ЭтотОбъект, ДанныеЗаполнения.ЗначениеКопирования);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ПроверитьЗаполнениеТабличнойЧастиРасчетыСПартнерами(Отказ, ХозяйственнаяОперация)

	Для Каждого СтрокаТаблицы Из РасчетыСПартнерами Цикл
		
		НеобходимоЗаполнитьОбъектРасчетов = Ложь;
		НеобходимоЗаполнитьНомерРасчетногоДокумента = Ложь;
		НеобходимоЗаполнитьДатуРасчетногоДокумента = Ложь;
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.ОбъектРасчетов) Тогда
			НеобходимоЗаполнитьОбъектРасчетов = Истина;
		КонецЕсли;
		
		Если НеобходимоЗаполнитьОбъектРасчетов Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Не заполнена колонка ""Объект расчетов"" в строке %1 списка ""Расчеты с партнерами""'"),
					СтрокаТаблицы.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"РасчетыСПартнерами[" + (СтрокаТаблицы.НомерСтроки - 1) + "].ОбъектРасчетов",
				,
				Отказ);
		КонецЕсли;
			
		Если НеобходимоЗаполнитьНомерРасчетногоДокумента Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Не заполнена колонка ""Номер"" в строке %1 списка ""Расчеты с партнерами""'"),
						СтрокаТаблицы.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"РасчетыСПартнерами[" + (СтрокаТаблицы.НомерСтроки - 1) + "].НомерРасчетногоДокумента",
				,
				Отказ);
		КонецЕсли;
		
		Если НеобходимоЗаполнитьДатуРасчетногоДокумента Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Не заполнена колонка ""Дата"" в строке %1 списка ""Расчеты с партнерами""'"),
						СтрокаТаблицы.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"РасчетыСПартнерами[" + (СтрокаТаблицы.НомерСтроки - 1) + "].ДатаРасчетногоДокумента",
				,
				Отказ);
		КонецЕсли;
		
		Если ОтражатьВОперативномУчете
			 И Не ЗначениеЗаполнено(СтрокаТаблицы.ДокументРасчетов) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Не заполнена колонка ""Расчетный документ"" в строке %1 списка ""Расчеты с партнерами""'"),
						СтрокаТаблицы.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"РасчетыСПартнерами[" + (СтрокаТаблицы.НомерСтроки - 1) + "].ДокументРасчетов",
				,
				Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьРазрядностьНомеровОбъектовРасчета(Отказ)
	
	ШаблонСообщения = НСтр("ru='Длина номера объекта расчетов превышает допустимую длину (%Длина%) для выбранного объекта расчетов в строке %НомерСтроки%.'");
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиКлиентов
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиПоставщикам
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовКлиентов
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковАвансовПоставщикам Тогда
		
		ТабличнаяЧасть    = РасчетыСПартнерами;
		ИмяТабличнойЧасти = "РасчетыСПартнерами";

	Иначе
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ТабличнаяЧасть Цикл
		Если СтрокаТаблицы.ОбъектРасчетов <> Неопределено Тогда
			ТипОбъектаРасчетов = ТипЗнч(СтрокаТаблицы.ОбъектРасчетов);
			ЭтоСправочник = Справочники.ТипВсеСсылки().СодержитТип(ТипОбъектаРасчетов);
			ЭтоДокумент = Документы.ТипВсеСсылки().СодержитТип(ТипОбъектаРасчетов);
			ДлинаНомера = 0;
			МетаданныеОбъектаРасчетов = Метаданные.НайтиПоТипу(ТипОбъектаРасчетов);
			Если ЭтоСправочник И МетаданныеОбъектаРасчетов <> Неопределено Тогда
				ДлинаНомера = МетаданныеОбъектаРасчетов.ДлинаКода;
			ИначеЕсли ЭтоДокумент И МетаданныеОбъектаРасчетов <> Неопределено Тогда
				ДлинаНомера = МетаданныеОбъектаРасчетов.ДлинаНомера;
			Иначе
				Возврат;
			КонецЕсли;
			Если (СтрДлина(СтрокаТаблицы.НомерРасчетногоДокумента) > ДлинаНомера)
				И ДлинаНомера > 0 Тогда
			ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%Длина%", ДлинаНомера);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", СтрокаТаблицы.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТабличнойЧасти, СтрокаТаблицы.НомерСтроки, "НомерРасчетногоДокумента"),
				,
				Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
