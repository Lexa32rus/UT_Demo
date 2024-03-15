#Область ПрограммныйИнтерфейс



#Область ПроверкаФормулы

// Возвращает шаблон параметров проверки формулы.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * ФункцииОбщегоМодуля - Массив из см. РаботаСФормуламиКлиентСервер.ОписаниеФункцииОбщегоМодуля
// * ФормулаДляВычисленияВЗапросе - Булево - Признак исполнения функции в качестве выражения текста запроса.
// * Поле - Строка - Путь к реквизиту формы, для которого было выведено сообщение, или к данным объекта.
// * ПутьКДанным - Строка - Содержит путь в форме, которая будет отображать сообщение, до объекта, связанного с этим сообщением.
// * СообщениеОбОшибке - Строка - Значение по умолчанию "". Если сообщение заполнено, то при наличии ошибки будет выводится указанное сообщение.
// * НеВыводитьСообщения - Булево - Флаг, позволяющий отключить вывод сообщений об ошибках.
// * ТипыОперандов - Соответствие - типы операндов
//
Функция ПараметрыПроверкиФормулы() Экспорт
	
	ПараметрыПроверки = Новый Структура;
	ПараметрыПроверки.Вставить("ФункцииОбщегоМодуля", Новый Массив);
	ПараметрыПроверки.Вставить("ФормулаДляВычисленияВЗапросе", Ложь);
	ПараметрыПроверки.Вставить("Поле", "");
	ПараметрыПроверки.Вставить("ПутьКДанным", "");
	ПараметрыПроверки.Вставить("СообщениеОбОшибке", "");
	ПараметрыПроверки.Вставить("НеВыводитьСообщения", Ложь);
	ПараметрыПроверки.Вставить("ТипыОперандов", Новый Соответствие);
	
	Возврат ПараметрыПроверки;
	
КонецФункции

// Осуществляет проверку формулы при интерактивных действиях пользователя.
//
// Параметры:
//   Формула - Строка - текст формулы.
//   Операнды - Массив из Строка - операнды формулы.
//   ТипРезультата - ОписаниеТипов - ожидаемый тип результата вычисления.
//   ПараметрыПроверки - см. ПараметрыПроверкиФормулы.
//
Процедура ПроверитьФормулуИнтерактивно(Формула, Операнды, ТипРезультата, ПараметрыПроверки = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(Формула) Тогда
		Если ПроверитьФормулу(Формула, Операнды, ТипРезультата, ПараметрыПроверки) Тогда
			
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'В формуле ошибок не обнаружено'"),
				,
				,
				БиблиотекаКартинок.Информация32);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Осуществляет проверку корректности формулы.
//
// Параметры:
//   Формула - Строка - текст формулы.
//   Операнды - Массив из Строка - операнды формулы.
//   ТипРезультата - ОписаниеТипов - ожидаемый тип результата вычисления.
//   ПараметрыПроверки - см. ПараметрыПроверкиФормулы.
//
// Возвращаемое значение:
//  Булево - Ложь, если есть ошибки, иначе Истина.
//
Функция ПроверитьФормулу(Формула, Операнды, ТипРезультата, ПараметрыПроверки = Неопределено) Экспорт
	
	
	Если НЕ ПараметрыПроверки = Неопределено Тогда
		ФункцииОбщегоМодуля = ПараметрыПроверки.ФункцииОбщегоМодуля;
	Иначе
		ФункцииОбщегоМодуля = Новый Массив; // Массив из см. РаботаСФормуламиКлиентСервер.ОписаниеФункцииОбщегоМодуля
	КонецЕсли;
	
	Если НЕ ПараметрыПроверки = Неопределено Тогда
		ВыводитьСообщения = НЕ ПараметрыПроверки.НеВыводитьСообщения;
		Поле = ПараметрыПроверки.Поле;
		ПутьКДанным = ПараметрыПроверки.ПутьКДанным;
		СообщениеОбОшибке = ПараметрыПроверки.СообщениеОбОшибке;
		ТипыОперандов = ПараметрыПроверки.ТипыОперандов;
	Иначе
		ВыводитьСообщения = Истина;
		Поле = "";
		ПутьКДанным = "";
		СообщениеОбОшибке = "";
		ТипыОперандов = Неопределено;
	КонецЕсли;
	
	Результат = Истина;
	
	Если ЗначениеЗаполнено(Формула) Тогда
		
		ТипыРезультата = ТипРезультата.Типы();
		Если ТипыРезультата.Количество() = 1
			И ТипыРезультата[0] = Тип("Строка") Тогда
			ТекстРасчета = """Строка"" + " + Формула;
			ЗначениеЗамены = """1""";
		ИначеЕсли ТипыРезультата.Количество() = 1
			И ТипыРезультата[0] = Тип("Дата") Тогда
				ЗначениеЗамены = "1 ";
			ТекстРасчета = Формула;
		Иначе
			ЗначениеЗамены = "1 ";
			ТекстРасчета = Формула;
		КонецЕсли;
		
		РаботаСФормуламиВызовСервера.ПолучитьТекстРасчета(ТекстРасчета, Операнды, ЗначениеЗамены, ТипыОперандов);
		
		Попытка
			
				Если ФункцииОбщегоМодуля.Количество() > 0 Тогда
					
					Для каждого СвойстваФункции Из ФункцииОбщегоМодуля Цикл
						ТекстРасчета = СтрЗаменить(ТекстРасчета, СвойстваФункции.Идентификатор, СвойстваФункции.ПолныйПуть);
					КонецЦикла; 
					
				КонецЕсли;
				
				РезультатРасчета = Вычислить(ТекстРасчета);
			
			
			ТекстПроверки = СтрЗаменить(Формула, Символы.ПС, "");
			ТекстПроверки = СтрЗаменить(ТекстПроверки, " ", "");
			ОтсутствиеРазделителей = Найти(ТекстПроверки, "][")
				+ Найти(ТекстПроверки, """[")
				+ Найти(ТекстПроверки, "]""");
			Если ОтсутствиеРазделителей > 0 Тогда
				
				ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
					"Ошибка при проверке формулы:"+ Формула,
					"Ошибка", ,, Истина);
		
				Если ВыводитьСообщения Тогда
					ТекстСообщения = НСтр("ru = 'В формуле обнаружены ошибки. Между операндами должен присутствовать оператор или разделитель'");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						ТекстСообщения,
						,
						Поле,
						ПутьКДанным,);
				КонецЕсли;
				Результат = Ложь;
			КонецЕсли;
			
			ТипРезультатаРасчетаПравильный = Ложь;
			
			Для Каждого ДопустимыйТип Из ТипРезультата.Типы() Цикл
				Если ТипЗнч(РезультатРасчета) = ДопустимыйТип Тогда
					ТипРезультатаРасчетаПравильный = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если Не ТипРезультатаРасчетаПравильный Тогда
				Результат = Ложь;
				
				ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
					"Ошибка при проверке формулы:"+ Формула,
					"Ошибка", ,, Истина);
				
				Если ВыводитьСообщения Тогда
					ТекстСообщения = НСтр("ru = 'В формуле обнаружены ошибки. Результат расчета должен быть типа %1'");
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения,
						ТипРезультата);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						ТекстСообщения,,
						Поле,
						ПутьКДанным);
				КонецЕсли;
			КонецЕсли;
		
		Исключение
			
			Результат = Ложь;
			
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
					"Ошибка при проверке формулы:"+ Формула,
					"Ошибка", ,, Истина);
			
			Если ВыводитьСообщения Тогда
				Если ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
					ТекстСообщения = СообщениеОбОшибке;
				Иначе
					ТекстСообщения = НСтр("ru = 'В формуле обнаружены ошибки. Проверьте формулу. Формулы должны составляться по правилам написания выражений на встроенном языке 1С:Предприятия.'");
				КонецЕсли;
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,,
					Поле,
					ПутьКДанным);
			КонецЕсли;
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


#КонецОбласти


#КонецОбласти
