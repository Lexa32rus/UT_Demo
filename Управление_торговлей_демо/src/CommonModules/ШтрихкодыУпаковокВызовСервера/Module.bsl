#Область ПрограммныйИнтерфейс

// Возвращает считанные из макета свойства ключей идентификаторов GS1
//
// Возвращаемое значение:
// 	Соответствие - Соответствие кодов идентификаторов их свойствам
// 	 * Ключ     - Строка - Код (ключ) идентификатора GS1. Только цифровые символы ключа идентификатора. Например, код "310X" будет преобразован в "310".
// 	 * Значение - Структура - Свойства идентификатора GS1
// 	   ** ИмяИдентификатора - Строка - Имя идентификатора применения в верхнем регистре, например, "МАССАНЕТТОВКГ" или "GTIN01" или "ДАТАПРОИЗВОДСТВА"
// 	   ** ПредставлениеИдентификатора - Строка - пользовательское Представление имени идентификатора, приводится к соответствующему языку в макете. Например, "Масса нетто в кг. (310Х)"
// 	   ** ПредставлениеИдентификатораДляУпорядочивания - Строка - Пользовательское представление имени идентификатора, ключ идентификатора с нецифровыми символами указывается в начале. 
// 	                                                              Используется в списках, где упорядочивание идет по представлению. Например, "(310Х) Масса нетто в кг."
// 	   ** ДлинаКода - Число - Количество знаков, отводимых в штрихкоде под значение параметра
// 	   ** ЗначениеПеременнойДлины - Булево - Признак переменной длины у параметра в штрихкоде
// 	   ** ДополнительныйПараметрИмя - Имя дополнительного параметра, прибавляемого к ключу (коду) идентификатора,
// 	                                  например, МассаНеттоВКг имеет ключ 310 и значение доп параметра от 0 до 5, тогда
// 	                                  полное значение ключа будет от 3100 до 3105, или в скобках от (3100) до (3105).
// 	                                  В данном случае дополнительный параметр задает количество знаков после запятой в штрихкоде.
// 	                                  Имя дополнительного параметра кодирует смысловое предназначение параметра.
// 	   ** ДлинаДопПараметра - Число - Длина дополнительного параметра в штрихкоде.
// 	   ** ДополнительныйПараметрМинимальноеЗначение - Число - Минимальное значение дополнительного параметра. Задается
// 	                                                          для случаев ручного интерактивного изменения (например при генерации штрихкода)
// 	   ** ДополнительныйПараметрМаксимальноеЗначение - Число - Максимальное значение дополнительного параметра
// 	   ** ДополнительныйПараметрЗначениеПоУмолчанию - Число - Значение по умолчанию для дополнительного параметра
// 	   ** ДополнительныйПараметрПредставление - Строка - Пользовательское представление имени дополнительного идентификатора
// 	   ** БазовыйТипДанных - Описание типов данных - Описание типов данных для значения идентификатора GS1. Может уточняться в зависимости
// 	                                                 от значения дополнительного параметра.
//
Функция ПрочитатьСвойстваКлючейИдентификаторовПрименения() Экспорт
	
	// Базовый тип данных может уточняться значениями квалификаторов типов
	// в зависимости от значения дополнительного параметра.
	// См. ШтрихкодыУпаковокКлиентСервер.ТипЗначенияПараметра
	КлючиИдентификаторов = Новый Соответствие;
	
	Макет = Обработки.ГенерацияШтрихкодовУпаковок.ПолучитьМакет("ИдентификаторыПримененияGS1");
	
	ВысотаТаблицы = Макет.ВысотаТаблицы;
	
	Цифры = Новый Массив;
	Для ЗначениеСчетчика = 0 По 9 Цикл
		Цифры.Добавить(Формат(ЗначениеСчетчика, "ЧН=0; ЧГ=0"));
	КонецЦикла;
	
	Для НомерСтроки = 2 По ВысотаТаблицы Цикл
		ШаблонИмениОбласти = "R" + Формат(НомерСтроки, "ЧН=0; ЧГ=0");
		
		КлючИдентификатора     = СокрЛП(Макет.Область(ШаблонИмениОбласти + "C1").Текст);
		ИмяИдентификатора      = ВРЕГ(СокрЛП(Макет.Область(ШаблонИмениОбласти + "C2").Текст));
		ПредставлениеИдентификатора   = СокрЛП(Макет.Область(ШаблонИмениОбласти + "C3").Текст);
		БазовыйТипДанныхСтрока = ВРЕГ(СокрЛП(Макет.Область(ШаблонИмениОбласти + "C4").Текст));
		ДлинаКода              = СокрЛП(Макет.Область(ШаблонИмениОбласти + "C5").Текст);
		ЗначениеПеременнойДлины       = СокрЛП(Макет.Область(ШаблонИмениОбласти + "C6").Текст);
		ДополнительныйПараметрИмя     = ВРЕГ(СокрЛП(Макет.Область(ШаблонИмениОбласти + "C7").Текст));
		ДлинаДополнительногоПараметра = СокрЛП(Макет.Область(ШаблонИмениОбласти + "C8").Текст);
		ДополнительныйПараметрМинимальноеЗначение  = СокрЛП(Макет.Область(ШаблонИмениОбласти + "C9").Текст);
		ДополнительныйПараметрМаксимальноеЗначение = СокрЛП(Макет.Область(ШаблонИмениОбласти + "C10").Текст);
		ДополнительныйПараметрЗначениеПоУмолчанию  = СокрЛП(Макет.Область(ШаблонИмениОбласти + "C11").Текст);
		
		Если ПустаяСтрока(КлючИдентификатора) Тогда
			Продолжить;
		КонецЕсли;
		
		//КлючИдентификатора может содержать не цифровые символы дополнительных параметров
		КоличествоСимволов = СтрДлина(КлючИдентификатора);
		КлючИдентификатораЦифрами = "";
		Для ЗначениеСчетчика = 1 По КоличествоСимволов Цикл
			Символ = Сред(КлючИдентификатора, ЗначениеСчетчика, 1);
			Если НЕ Цифры.Найти(Символ) = Неопределено Тогда
				КлючИдентификатораЦифрами = КлючИдентификатораЦифрами + Символ;
			КонецЕсли;
		КонецЦикла;
		
		ДлинаКода = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ДлинаКода);
		
		ЗначениеПеременнойДлины = ?(ВРЕГ(ЗначениеПеременнойДлины) = "ИСТИНА", Истина, Ложь);
		
		Если БазовыйТипДанныхСтрока = ВРЕГ("Число") Тогда
			Если ДополнительныйПараметрИмя = ВРЕГ("ЧислоЗнаковПослеЗапятой") Тогда
				ЧислоЗнаковПослеЗапятой = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ДополнительныйПараметрЗначениеПоУмолчанию);
			Иначе
				ЧислоЗнаковПослеЗапятой = 0;
			КонецЕсли;
			КвалификаторыЧисла = Новый КвалификаторыЧисла(ДлинаКода,
			                                              ЧислоЗнаковПослеЗапятой,
			                                              ДопустимыйЗнак.Неотрицательный);
		Иначе
			КвалификаторыЧисла = Новый КвалификаторыЧисла;
		КонецЕсли;
		
		Если БазовыйТипДанныхСтрока = ВРЕГ("Строка") Тогда
			КвалификаторыСтроки = Новый КвалификаторыСтроки(ДлинаКода,
				?(ЗначениеПеременнойДлины = Истина, ДопустимаяДлина.Переменная, ДопустимаяДлина.Фиксированная));
		Иначе
			КвалификаторыСтроки = Новый КвалификаторыСтроки;
		КонецЕсли;
		
		Если БазовыйТипДанныхСтрока = ВРЕГ("Дата") Тогда
			КвалификаторыДаты = Новый КвалификаторыДаты(ЧастиДаты.Дата);
		ИначеЕсли БазовыйТипДанныхСтрока = ВРЕГ("ДатаВремя") Тогда
			КвалификаторыДаты = Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя);
			БазовыйТипДанныхСтрока = ВРЕГ("Дата");
		ИначеЕсли БазовыйТипДанныхСтрока = ВРЕГ("Время") Тогда
			КвалификаторыДаты = Новый КвалификаторыДаты(ЧастиДаты.Время);
			БазовыйТипДанныхСтрока = ВРЕГ("Дата");
		Иначе
			КвалификаторыДаты = Новый КвалификаторыДаты;
		КонецЕсли;
		
		БазовыйТипДанных = Новый ОписаниеТипов(БазовыйТипДанныхСтрока,,, КвалификаторыЧисла, КвалификаторыСтроки, КвалификаторыДаты);
		
		ДлинаДополнительногоПараметра = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ДлинаДополнительногоПараметра);
		ДополнительныйПараметрМинимальноеЗначение = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ДополнительныйПараметрМинимальноеЗначение);
		ДополнительныйПараметрМаксимальноеЗначение = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ДополнительныйПараметрМаксимальноеЗначение);
		ДополнительныйПараметрЗначениеПоУмолчанию = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ДополнительныйПараметрЗначениеПоУмолчанию);
		
		Если ДополнительныйПараметрИмя = ВРЕГ("ЧислоЗнаковПослеЗапятой") Тогда
			ДополнительныйПараметрПредставление = НСтр("ru = 'Точность'");
		Иначе
			ДополнительныйПараметрПредставление = "";
		КонецЕсли;
		
		// Представление идентификатора для отображения на форме обработки
		ПредставлениеИдентификатораСКодомВКонце = ПредставлениеИдентификатора + " "
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("(%1)", КлючИдентификатора);
		// Представление идентификатора в списках, упорядочиваемых по представлению
		ПредставлениеИдентификатораДляУпорядочивания = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("(%1)", КлючИдентификатора)
			+ " " + ПредставлениеИдентификатора;
		
		Свойства = Новый Структура;
		Свойства.Вставить("Индекс", НомерСтроки - 1);
		Свойства.Вставить("ИмяИдентификатора", ИмяИдентификатора);
		Свойства.Вставить("ПредставлениеИдентификатора", ПредставлениеИдентификатораСКодомВКонце);
		Свойства.Вставить("ПредставлениеИдентификатораДляУпорядочивания", ПредставлениеИдентификатораДляУпорядочивания);
		Свойства.Вставить("ДлинаКода", ДлинаКода);
		Свойства.Вставить("ЗначениеПеременнойДлины", ЗначениеПеременнойДлины);
		Свойства.Вставить("ДополнительныйПараметрИмя", ДополнительныйПараметрИмя);
		Свойства.Вставить("ДлинаДопПараметра", ДлинаДополнительногоПараметра);
		Свойства.Вставить("ДополнительныйПараметрМинимальноеЗначение", ДополнительныйПараметрМинимальноеЗначение);
		Свойства.Вставить("ДополнительныйПараметрМаксимальноеЗначение", ДополнительныйПараметрМаксимальноеЗначение);
		Свойства.Вставить("ДополнительныйПараметрЗначениеПоУмолчанию", ДополнительныйПараметрЗначениеПоУмолчанию);
		Свойства.Вставить("ДополнительныйПараметрПредставление", ДополнительныйПараметрПредставление);
		Свойства.Вставить("БазовыйТипДанных", БазовыйТипДанных);
		
		КлючиИдентификаторов.Вставить(КлючИдентификатораЦифрами, Свойства);
		
	КонецЦикла;
	
	Возврат КлючиИдентификаторов;
	
КонецФункции

#КонецОбласти
