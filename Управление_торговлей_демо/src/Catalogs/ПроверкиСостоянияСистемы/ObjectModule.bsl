#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		Код = СокрЛП(Новый УникальныйИдентификатор);
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	// Заполним признак использования проверки.
	Если Используется И (ПометкаУдаления ИЛИ ВыполняетсяТолькоВКонтексте) Тогда
		Используется = Ложь;
	КонецЕсли;
	
	// Заполним способ выполнения проверки.
	Если ВыполняетсяТолькоВКонтексте Тогда
		НовыйСпособВыполнения = Перечисления.СпособыВыполненияПроверокСостоянияСистемы.Контекстно;
	ИначеЕсли НЕ Используется Тогда
		НовыйСпособВыполнения = Перечисления.СпособыВыполненияПроверокСостоянияСистемы.Вручную;
	ИначеЕсли ПоОтдельномуРасписанию Тогда
		НовыйСпособВыполнения = Перечисления.СпособыВыполненияПроверокСостоянияСистемы.ПоОтдельномуРасписанию;
	Иначе
		НовыйСпособВыполнения = Перечисления.СпособыВыполненияПроверокСостоянияСистемы.ПоОбщемуРасписанию;
	КонецЕсли;
	
	Если СпособВыполнения <> НовыйСпособВыполнения Тогда
		СпособВыполнения = НовыйСпособВыполнения;
	КонецЕсли;
	
	// Запомним дополнительные параметры автопроверки.
	Если ДополнительныеСвойства.Свойство("ДопПараметрыАвтопроверки") Тогда
		ДополнительныеПараметрыАвтопроверки = Новый ХранилищеЗначения(ДополнительныеСвойства.ДопПараметрыАвтопроверки); 
	КонецЕсли;
	
	Если НЕ ВыполняетсяТолькоВКонтексте Тогда
		
		// Создание регламентного задания.
		РасписаниеРегламентногоЗадания = Неопределено;
		Если ДополнительныеСвойства.Свойство("РасписаниеВыполнения") Тогда
			РасписаниеРегламентногоЗадания = ДополнительныеСвойства.РасписаниеВыполнения;
		КонецЕсли;
		
		ОбновитьДанныеРегламентногоЗадания(Отказ, РасписаниеРегламентногоЗадания, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	// Удаляем регламентное задание при необходимости.
	Если ВыполняетсяТолькоВКонтексте Тогда
		УдалитьРегламентноеЗадание(Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если НЕ ОбъектКопирования.ЭтоГруппа Тогда
		РегламентноеЗаданиеGUID = Неопределено;
		РегламентноеЗаданиеПредставление = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет удаление регламентного задания.
//
// Параметры:
//  Отказ                     - Булево - флаг отказа. Если в процессе выполнения процедуры были обнаружены ошибки,
//                                       то флаг отказа устанавливается в значение Истина.
// 
Процедура УдалитьРегламентноеЗадание(Отказ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Определяем регламентное задание.
	РегламентноеЗаданиеОбъект = Справочники.ПроверкиСостоянияСистемы.РегламентноеЗаданиеПоУникальномуНомеру(РегламентноеЗаданиеGUID); // РегламентноеЗадание
	
	Если РегламентноеЗаданиеОбъект <> Неопределено Тогда
		
		Попытка
			РегламентноеЗаданиеОбъект.Удалить();
		Исключение
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при удалении регламентного задания: %1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Удаление регламентного задания'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегламентныеЗадания.ПроверкаСостоянияСистемы,
				,
				ТекстСообщения);
				
			Возврат;
			
		КонецПопытки;
		
	КонецЕсли;
	
	РегламентноеЗаданиеGUID = Неопределено;
	РегламентноеЗаданиеПредставление = "";
	
КонецПроцедуры

Процедура ОбновитьДанныеРегламентногоЗадания(Отказ, РасписаниеРегламентногоЗадания, ТекущийОбъект) Экспорт
	
	Если ТекущийОбъект.ВыполняетсяТолькоВКонтексте Тогда
		// Для проверок, выполняемых только в контексте, регламентное задание не нужно.
		ТекущийОбъект.РегламентноеЗаданиеПредставление = СокрЛП(ТекущийОбъект.КонтекстВыполнения);
		Возврат;
	КонецЕсли;
	
	// Получаем регламентное задание по идентификатору, если объект не находим, то создаем новый.
	РегламентноеЗаданиеОбъект = Справочники.ПроверкиСостоянияСистемы.РегламентноеЗаданиеПоУникальномуНомеру(
		ТекущийОбъект.РегламентноеЗаданиеGUID);
	
	// При необходимости создаем регламентное задание.
	Если ТекущийОбъект.ПоОтдельномуРасписанию И РегламентноеЗаданиеОбъект = Неопределено Тогда
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.ПроверкаСостоянияСистемы);
		
		РегламентноеЗаданиеОбъект = РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
		
	КонецЕсли;
	
	Если РегламентноеЗаданиеОбъект <> Неопределено Тогда
		
		// Обновляем свойства регламентного задания данной проверки.
		ПараметрыЗадания = Новый Массив;
		ПараметрыЗадания.Добавить(ТекущийОбъект.Код);
		
		НаименованиеЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Проверка состояния системы: %1'"), СокрЛП(ТекущийОбъект.Наименование));
		
		РегламентноеЗаданиеОбъект.Наименование  = НаименованиеЗадания;
		РегламентноеЗаданиеОбъект.Использование = ТекущийОбъект.ПоОтдельномуРасписанию И ТекущийОбъект.Используется;
		РегламентноеЗаданиеОбъект.Параметры     = ПараметрыЗадания;
		
		// Обновляем расписание.
		Если РасписаниеРегламентногоЗадания <> Неопределено Тогда
			РегламентноеЗаданиеОбъект.Расписание = РасписаниеРегламентногоЗадания;
		КонецЕсли;
		
		// Записываем задание.
		УстановитьПривилегированныйРежим(Истина);
		
		Попытка
			
			РегламентноеЗаданиеОбъект.Записать();
			
			// Запоминаем GUID регл. задания в реквизите объекта.
			ТекущийОбъект.РегламентноеЗаданиеGUID = РегламентноеЗаданиеОбъект.УникальныйИдентификатор;
		
		Исключение
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Произошла ошибка при сохранении расписания выполнения проверки. Подробное описание ошибки: %1'"), 
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Изменение регламентного задания'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегламентныеЗадания.ПроверкаСостоянияСистемы,
				,
				ТекстСообщения);
			
		КонецПопытки;
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	Если НЕ ТекущийОбъект.Используется ИЛИ НЕ ТекущийОбъект.ПоОтдельномуРасписанию Тогда
		ТекущийОбъект.РегламентноеЗаданиеПредставление = "";
	Иначе
		ТекущийОбъект.РегламентноеЗаданиеПредставление =
			АудитСостоянияСистемыКлиентСервер.ПредставлениеРасписания(РасписаниеРегламентногоЗадания);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли