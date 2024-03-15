
#Область ПрограммныйИнтерфейс

// Открывает форму ввода адреса с заполненными из параметра значениями полей адреса.
//
// Параметры:
//	Элемент - ПолеФормы - элемент формы для ввода адреса;
//	Объект - ДанныеФормыКоллекция - объект, для которого выполняется событие;
//	ИменаРеквизитовАдресовДоставки - см. ДоставкаТоваровКлиентСервер.ИменаРеквизитовАдресовДоставки
//	СтандартнаяОбработка - Булево - Истина, признак выполнения стандартной обработки события начало выбора.
//
Процедура ОткрытьФормуВыбораАдресаИОбработатьРезультат(Элемент, Объект, ИменаРеквизитовАдресовДоставки, СтандартнаяОбработка = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	АдресПредставление = Объект[ИменаРеквизитовАдресовДоставки.ИмяРеквизитаАдресаДоставки];
	АдресЗначенияПолей = Объект[ИменаРеквизитовАдресовДоставки.ИмяРеквизитаАдресаДоставкиЗначенияПолей];
	АдресЗначение = Объект[ИменаРеквизитовАдресовДоставки.ИмяРеквизитаАдресаДоставкиЗначение];
	
	Если Не ЗначенияПолейАдресаДоставкиВалидны(АдресЗначенияПолей) Тогда
		АдресЗначенияПолей = "";
		АдресЗначение = "";
		ОбщегоНазначенияУТВызовСервера.ЗаполнитьЗначенияПолейКИПоПредставлению(АдресПредставление, АдресЗначенияПолей);
	КонецЕсли;
	
	ПриИзмененииПредставленияАдреса(Элемент, АдресПредставление, АдресЗначенияПолей, Ложь);
	
	// Откроем диалог редактирования КИ
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресПартнера"));
	ПараметрыОткрытия.Вставить("ЗначенияПолей",           ДоставкаТоваровКлиентСервер.ПреобразоватьСтрокуВСписокПолей(АдресЗначенияПолей));
	ПараметрыОткрытия.Вставить("Значение",                АдресЗначение);
	ПараметрыОткрытия.Вставить("Представление",           АдресПредставление);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект",						Объект);
	ДополнительныеПараметры.Вставить("ИмяРеквизитаАдресаДоставки", 	ИменаРеквизитовАдресовДоставки.ИмяРеквизитаАдресаДоставки);
	ДополнительныеПараметры.Вставить("Элемент", 					Элемент);
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьФормуВыбораАдресаИОбработатьРезультатЗавершение", 
		ДоставкаТоваровКлиент, ДополнительныеПараметры);
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия,,Оповещение);
		
КонецПроцедуры

// Актуализирует КИ из текста редактирования поля ввода.
//
// Параметры:
//		Элемент - ПолеФормы - элемент формы для ввода адреса;
//		АдресПредставление - Строка - представление адреса;
//		АдресЗначенияПолей - Строка - служебная информация, значения полей адреса.
//		ОчищатьПустоеПредставление - Булево - истина, очищать.
//
Процедура ПриИзмененииПредставленияАдреса(Элемент, АдресПредставление, АдресЗначенияПолей, ОчищатьПустоеПредставление = Истина) Экспорт
	
	Если Элемент.Вид = ВидПоляФормы.ПолеВвода Тогда
		АдресПредставление = Элемент.ТекстРедактирования;
		
		Если ОчищатьПустоеПредставление
			И АдресПредставление = "" Тогда
			ОчиститьПредставлениеАдреса(АдресПредставление, АдресЗначенияПолей);
		КонецЕсли;
		
		ОбщегоНазначенияУТВызовСервера.ЗаполнитьЗначенияПолейКИПоПредставлению(АдресПредставление, АдресЗначенияПолей);
	КонецЕсли;
	
КонецПроцедуры

// Производит очистку полей КИ при очистке текста редактирования поля ввода.
//
// Параметры:
//		АдресПредставление - Строка - представление адреса.
//		АдресЗначенияПолей - Строка - служебная информация, значения полей адреса.
//		АдресЗначение - Строка - адрес во внутреннем формате JSON или в XML, соответствующем XDTO-пакету Адрес.
//
Процедура ОчиститьПредставлениеАдреса(АдресПредставление, АдресЗначенияПолей, АдресЗначение = "") Экспорт
	
	АдресПредставление = "";
	АдресЗначенияПолей = "";
	АдресЗначение = "";
	
КонецПроцедуры

// Заполняет реквизиты доставки из структуры в соответствии с выбранным адресом
//
// Параметры:
//  ЭлементыФормы		 - ВсеЭлементыФормы	 - элементы формы, в которой происходит выбор адреса (для получения списков выбора);
//  ДокОбъект			 - ДокументОбъект	 - объект, в котором происходит выбор адреса, реквизиты этого объекта заполняются
//  	реквизитами доставки;
//  ИмяЭлементаФормы	 - Строка			 - имя элемента формы, в котором происходит выбор адреса;
//  ВыбранноеЗначение	 - Структура		 - реквизиты доставки, соответствующая выбранному адресу.
//
Процедура АдресДоставкиОбработкаВыбора(ЭлементыФормы, ДокОбъект, ИмяЭлементаФормы, ВыбранноеЗначение) Экспорт
	
	ДопИнфоИзмененоПользователем = ДоставкаТоваровКлиентСервер.ДопИнфоИзмененоПользователем(ЭлементыФормы, ДокОбъект);
	Если ИмяЭлементаФормы = "АдресДоставкиПолучателя" Тогда
		Если ДопИнфоИзмененоПользователем
			И ВыбранноеЗначение.Свойство("ДополнительнаяИнформацияПоДоставке") Тогда
			ЗаполнитьЗначенияСвойств(ДокОбъект, ВыбранноеЗначение, , "ДополнительнаяИнформацияПоДоставке");
		Иначе
			ЗаполнитьЗначенияСвойств(ДокОбъект, ВыбранноеЗначение);
		КонецЕсли;
	ИначеЕсли ИмяЭлементаФормы = "АдресДоставкиПеревозчика" Тогда
		Если ДопИнфоИзмененоПользователем 
			И ВыбранноеЗначение.Свойство("ДополнительнаяИнформацияПоДоставке") Тогда
			ЗаполнитьЗначенияСвойств(ДокОбъект, ВыбранноеЗначение,
				,"АдресДоставки, АдресДоставкиЗначенияПолей, ДополнительнаяИнформацияПоДоставке");
		Иначе
			ЗаполнитьЗначенияСвойств(ДокОбъект, ВыбранноеЗначение,
				,"АдресДоставки, АдресДоставкиЗначенияПолей");
		КонецЕсли;
		ДокОбъект.АдресДоставкиПеревозчика = ВыбранноеЗначение.АдресДоставки;
		ДокОбъект.АдресДоставкиПеревозчикаЗначенияПолей = ВыбранноеЗначение.АдресДоставкиЗначенияПолей;
		
	ИначеЕсли ИмяЭлементаФормы = "АдресДоставкиПолучателя1" Тогда
		Если ДопИнфоИзмененоПользователем
			И ВыбранноеЗначение.Свойство("ДополнительнаяИнформацияПоДоставке") Тогда
			ЗаполнитьЗначенияСвойств(ДокОбъект, ВыбранноеЗначение, , "ДополнительнаяИнформацияПоДоставке");
		Иначе
			ЗаполнитьЗначенияСвойств(ДокОбъект, ВыбранноеЗначение);
		КонецЕсли;
	ИначеЕсли ИмяЭлементаФормы = "АдресДоставкиПолучателя2" Тогда
		Если ВыбранноеЗначение.Свойство("ДополнительнаяИнформацияПоДоставке")
			И (ДопИнфоИзмененоПользователем
				ИЛИ ЗначениеЗаполнено(ВыбранноеЗначение.ДополнительнаяИнформацияПоДоставке)) Тогда
			ЗаполнитьЗначенияСвойств(ДокОбъект, ВыбранноеЗначение, , "ДополнительнаяИнформацияПоДоставке");
		Иначе
			ЗаполнитьЗначенияСвойств(ДокОбъект, ВыбранноеЗначение);
		КонецЕсли;
	ИначеЕсли ИмяЭлементаФормы = "АдресДоставкиСамовывоз" Тогда
		Если ДопИнфоИзмененоПользователем
			И ВыбранноеЗначение.Свойство("ДополнительнаяИнформацияПоДоставке") Тогда
			ЗаполнитьЗначенияСвойств(ДокОбъект, ВыбранноеЗначение, , "ДополнительнаяИнформацияПоДоставке");
		Иначе
			ЗаполнитьЗначенияСвойств(ДокОбъект, ВыбранноеЗначение);
		КонецЕсли;
	ИначеЕсли ИмяЭлементаФормы = "АдресПоставщика" Тогда
		Если ДопИнфоИзмененоПользователем Тогда
			ЗаполнитьЗначенияСвойств(ДокОбъект, ВыбранноеЗначение, , "ДополнительнаяИнформацияПоДоставке");
		Иначе
			ЗаполнитьЗначенияСвойств(ДокОбъект, ВыбранноеЗначение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

//Заполняет список перевозчиков на форме.
//
// Параметры:
//  СписокВыбораПеревозчиков - СписокЗначений - список выбора перевозчиков.
//  ДанныеПоФоновомуЗаданию - см. ДлительныеОперации.ВыполнитьВФоне
//
Процедура ОбновитьСписокПеревозчиков(СписокВыбораПеревозчиков, ДанныеПоФоновомуЗаданию) Экспорт

	МассивПеревозчиков = ПолучитьИзВременногоХранилища(ДанныеПоФоновомуЗаданию.АдресРезультата);
	УдалитьИзВременногоХранилища(ДанныеПоФоновомуЗаданию.АдресРезультата);
	
	СписокВыбораПеревозчиков.ЗагрузитьЗначения(МассивПеревозчиков);

	ДанныеПоФоновомуЗаданию = Неопределено;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьФормуВыбораАдресаИОбработатьРезультатЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Элемент 					= ДополнительныеПараметры.Элемент;
	Объект 						= ДополнительныеПараметры.Объект;
	ИмяРеквизитаАдресаДоставки	= ДополнительныеПараметры.ИмяРеквизитаАдресаДоставки;
		
	Если ТипЗнч(Результат) = Тип("Структура") Тогда // КИ введена
		
		// Перенесем данные в форму
		Объект[ИмяРеквизитаАдресаДоставки + "ЗначенияПолей"] = Результат.КонтактнаяИнформация;
		Объект[ИмяРеквизитаАдресаДоставки + "Значение"] = Результат.Значение;
		Объект[ИмяРеквизитаАдресаДоставки] = Результат.Представление;
		
		// Установим признак модифицированности
		Родитель = Элемент.Родитель;
		Пока ТипЗнч(Родитель) <> Тип("ФормаКлиентскогоПриложения") Цикл
			Родитель = Родитель.Родитель;
		КонецЦикла;
		
		Если Родитель.ИмяФормы <> "Обработка.РабочееМестоМенеджераПоДоставке.Форма.Форма" Тогда
			Родитель.Модифицированность = Истина;
		КонецЕсли;
		Родитель.ОбновитьОтображениеДанных();
		
	КонецЕсли;

КонецПроцедуры

Функция ЗначенияПолейАдресаДоставкиВалидны(АдресЗначенияПолей)
	
	ЗначенияПолейВалидны = ПустаяСтрока(АдресЗначенияПолей)
		Или (СтрНачинаетсяС(АдресЗначенияПолей, "<")
		И СтрЗаканчиваетсяНа(АдресЗначенияПолей, ">"))
		Или (СтрНачинаетсяС(АдресЗначенияПолей, "{")
		И СтрЗаканчиваетсяНа(АдресЗначенияПолей, "}"));
		
	Возврат ЗначенияПолейВалидны;
	
КонецФункции

#КонецОбласти
