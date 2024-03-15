#Область ПрограммныйИнтерфейс

// Проверяет, является ли переданный тип договора договором продажи.
//
// Параметры:
//  ТипДоговора - ПеречислениеСсылка.ТипыДоговоров - тип договора, который необходимо проверить.
//
// Возвращаемое значение:
//  Булево - Истина, если тип договора относится к договорам продажи.
//
Функция ЭтоДоговорПродажи(ТипДоговора) Экспорт
	
	Если ТипДоговора = Перечисления.ТипыДоговоров.СПокупателем
		Или ТипДоговора = Перечисления.ТипыДоговоров.СКомиссионером
		Или ТипДоговора = Перечисления.ТипыДоговоров.СХранителем
		Или ТипДоговора = Перечисления.ТипыДоговоров.СДавальцем Тогда
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

// Проверяет, является ли переданный тип договора договором закупки.
//
// Параметры:
//  ТипДоговора - ПеречислениеСсылка.ТипыДоговоров - тип договора, который необходимо проверить.
//
// Возвращаемое значение:
//  Булево - Истина, если тип договора относится к договорам закупки.
//
Функция ЭтоДоговорЗакупки(ТипДоговора) Экспорт
	
Если ТипДоговора = Перечисления.ТипыДоговоров.СПоставщиком
	ИЛИ ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком
	ИЛИ ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком2_5
	ИЛИ ТипДоговора = Перечисления.ТипыДоговоров.СПоклажедателем
	ИЛИ ТипДоговора = Перечисления.ТипыДоговоров.СКомитентом
	ИЛИ ТипДоговора = Перечисления.ТипыДоговоров.ВвозИзЕАЭС
	ИЛИ ТипДоговора = Перечисления.ТипыДоговоров.СКомитентомНаЗакупку
	ИЛИ ТипДоговора = Перечисления.ТипыДоговоров.Импорт Тогда
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

// Параметры:
// 	ДанныеВыбора - СписокЗначений
// 	Параметры - Структура:
// 		* Отбор - Структура:
// 			** Ссылка - ЛюбаяСсылка, ФиксированныйМассив - 
// 	СтандартнаяОбработка - Булево
// 
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами") Тогда
		
		ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПокупателем"));
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах") Тогда
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СКомиссионером"));
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.РеализацияЧерезКомиссионера"));
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи") Тогда
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СХранителем"));
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьОказаниеАгентскихУслугПриЗакупке") Тогда
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СКомитентомНаЗакупку"));
		КонецЕсли;
		
	КонецЕсли;
	
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСПоставщиками") Тогда
		
		ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПоставщиком"));
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриЗакупках") Тогда
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СКомитентом"));
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьИмпортныеЗакупки") Тогда
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.Импорт"));
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьВвозТоваровИзТаможенногоСоюза") Тогда
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.ВвозИзЕАЭС"));
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьОтветственноеХранениеВПроцессеЗакупки") Тогда
			ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПоклажедателем"));
		КонецЕсли;
		
	КонецЕсли;
	
	
	Если Параметры.Отбор.Свойство("Ссылка") Тогда
		
		СписокДопустимыхЗначений = ДанныеВыбора.Скопировать();
		ДанныеВыбора.Очистить();
		
		ЗначениеОтбораСсылки = Параметры.Отбор.Ссылка;
		Если Не ТипЗнч(ЗначениеОтбораСсылки) = Тип("ФиксированныйМассив") Тогда
			
			МассивЗначенийВОтборе = Новый Массив;
			МассивЗначенийВОтборе.Добавить(ЗначениеОтбораСсылки);
			
		Иначе
			МассивЗначенийВОтборе = ЗначениеОтбораСсылки;
		КонецЕсли;
		
		Для Каждого ТекЗначение Из МассивЗначенийВОтборе Цикл
			
			Если СписокДопустимыхЗначений.НайтиПоЗначению(ТекЗначение) <> Неопределено Тогда
				ДанныеВыбора.Добавить(ТекЗначение);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.СтрокаПоиска) Тогда
		
		ИндексЭлемента = -(ДанныеВыбора.Количество()-1);
		Для ИндексЭлемента = ИндексЭлемента По 0 Цикл
			ТекЭлемент = ДанныеВыбора.Получить(-ИндексЭлемента);
			Если НЕ СтрНачинаетсяС(НРег(ТекЭлемент.Значение), НРег(Параметры.СтрокаПоиска)) Тогда
				ДанныеВыбора.Удалить(ТекЭлемент);
			КонецЕсли;	
		КонецЦикла;
		
	КонецЕсли;	
	
	ДанныеВыбора.СортироватьПоЗначению();

КонецПроцедуры

#КонецОбласти

