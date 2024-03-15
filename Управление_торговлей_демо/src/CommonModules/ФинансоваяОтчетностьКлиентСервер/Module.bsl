

#Область ПрограммныйИнтерфейс

// Возвращает структуру значений параметров для подстановки в текстовые поля, используемых в финансовых отчетах.
//
// Параметры:
//  ИсключаяСкобки - Булево - Если истина, то из имени и представления параметра будут исключены ограничивающие квадратные скобки.
//  		Значение по умолчанию Ложь. 
//  КодЯзыка - Строка - Код языка. По умолчанию пустая строка - соответствует языку текущего пользователя.
//  		Задается при необходимости получения представления для конкретного языка, например, для основного языка конфигурации.
//
// Возвращаемое значение:
//  Структура - Структура параметров, используемых в финансовых отчетах:
//   * КомплектОтчетов - Структура - Структура, хранящая нелокализируемое хранимое в базе данных значение и локализируемое представление:
//     ** Имя - Строка - Идентификатор параметра. Не локализуется, хранится в базе данных. Например, "[ТекущаяДатаИВремя]".
//     ** Представление - Строка - Представление переменной, может заключаться в квадратные скобки.
//   * ВидОтчета - Структура - Структура, хранящая нелокализируемое хранимое в базе данных значение и локализируемое представление:
//     ** Имя - Строка - Идентификатор параметра. Не локализуется, хранится в базе данных. Например, "[ТекущаяДатаИВремя]".
//     ** Представление - Строка - Представление переменной, может заключаться в квадратные скобки.
//   * ТекущаяДатаИВремя - Структура - Структура, хранящая нелокализируемое хранимое в базе данных значение и локализируемое представление:
//     ** Имя - Строка - Идентификатор параметра. Не локализуется, хранится в базе данных. Например, "[ТекущаяДатаИВремя]".
//     ** Представление - Строка - Представление переменной, может заключаться в квадратные скобки.
//   * ПериодОтчетности - Структура - Структура, хранящая нелокализируемое хранимое в базе данных значение и локализируемое представление:
//     ** Имя - Строка - Идентификатор параметра. Не локализуется, хранится в базе данных. Например, "[ТекущаяДатаИВремя]".
//     ** Представление - Строка - Представление переменной, может заключаться в квадратные скобки.
//   * КонечнаяДатаПериодаОтчета - Структура - Структура, хранящая нелокализируемое хранимое в базе данных значение и локализируемое представление:
//     ** Имя - Строка - Идентификатор параметра. Не локализуется, хранится в базе данных. Например, "[ТекущаяДатаИВремя]".
//     ** Представление - Строка - Представление переменной, может заключаться в квадратные скобки.
//   * Организация - Структура - Структура, хранящая нелокализируемое хранимое в базе данных значение и локализируемое представление:
//     ** Имя - Строка - Идентификатор параметра. Не локализуется, хранится в базе данных. Например, "[ТекущаяДатаИВремя]".
//     ** Представление - Строка - Представление переменной, может заключаться в квадратные скобки./
//
Функция ПеременныеФинансовыхОтчетов(ИсключаяСкобки = Ложь, КодЯзыка = "") Экспорт
	
	Результат = Новый Структура;
	
	ШаблонПеременной = ?(ИсключаяСкобки, "%1", "[%1]");
	
	
	ИмяПеременной = "КомплектОтчетов";
	Имя = СтрШаблон(ШаблонПеременной, ИмяПеременной);
	ПредставлениеПеременной = НСтр("ru = 'Комплект отчетов'", КодЯзыка);
	ЗначениеИПредставление = ОписаниеПеременной(Имя, ПредставлениеПеременной);
	Результат.Вставить(ИмяПеременной, ЗначениеИПредставление);
	
	
	ИмяПеременной = "ВидОтчета";
	Имя = СтрШаблон(ШаблонПеременной, ИмяПеременной);
	ПредставлениеПеременной = НСтр("ru = 'Вид отчета'", КодЯзыка);
	ЗначениеИПредставление = ОписаниеПеременной(Имя, ПредставлениеПеременной);
	Результат.Вставить(ИмяПеременной, ЗначениеИПредставление);
	
	
	ИмяПеременной = "ТекущаяДатаИВремя";
	Имя = СтрШаблон(ШаблонПеременной, ИмяПеременной);
	ПредставлениеПеременной = НСтр("ru = 'Текущая дата и время'", КодЯзыка);
	ЗначениеИПредставление = ОписаниеПеременной(Имя, ПредставлениеПеременной);
	Результат.Вставить(ИмяПеременной, ЗначениеИПредставление);
	
	
	ИмяПеременной = "ПериодОтчетности";
	Имя = СтрШаблон(ШаблонПеременной, ИмяПеременной);
	ПредставлениеПеременной = НСтр("ru = 'Период отчетности'", КодЯзыка);
	ЗначениеИПредставление = ОписаниеПеременной(Имя, ПредставлениеПеременной);
	Результат.Вставить(ИмяПеременной, ЗначениеИПредставление);
	
	
	ИмяПеременной = "КонечнаяДатаПериодаОтчета";
	Имя = СтрШаблон(ШаблонПеременной, ИмяПеременной);
	ПредставлениеПеременной = НСтр("ru = 'Конечная дата периода отчета'", КодЯзыка);
	ЗначениеИПредставление = ОписаниеПеременной(Имя, ПредставлениеПеременной);
	Результат.Вставить(ИмяПеременной, ЗначениеИПредставление);
	
	
	ИмяПеременной = "Организация";
	Имя = СтрШаблон(ШаблонПеременной, ИмяПеременной);
	ПредставлениеПеременной = НСтр("ru = 'Организация'", КодЯзыка);
	ЗначениеИПредставление = ОписаниеПеременной(Имя, ПредставлениеПеременной);
	Результат.Вставить(ИмяПеременной, ЗначениеИПредставление);
	
	
	Возврат Результат;
	
КонецФункции

// Возвращаемое значение:
//  Структура - Структура, хранящая нелокализируемое хранимое в базе данных значение и локализируемое представление:
//  * Имя   - Строка - Идентификатор параметра. Не локализуется, хранится в базе данных. Например, "[ТекущаяДатаИВремя]".
//  * Представление - Строка - Представление параметра.
// 
Функция ОписаниеПеременной(Имя = "", Представление = "")
	Возврат Новый Структура("Имя, Представление", Имя, Представление);
КонецФункции

// Возвращает упорядоченный массив значений переменных для подстановки в текстовые поля, используемых в финансовых отчетах.
//
// Параметры:
//  КодЯзыка         - Строка       - Код языка. По умолчанию пустая строка - соответствует языку текущего пользователя.
//                                    Задается при необходимости получения представления для конкретного языка, например, для основного языка конфигурации.
//
// Возвращаемое значение:
//  Массив из см. НовыйСтруктураПеременнойФинансовыхОтчетов - Упорядоченный массив параметров,
//  используемых в финансовых отчетах для подстановки в текстовые поля.
//
Функция УпорядоченныеПеременныеФинансовыхОтчетов(КодЯзыка = "") Экспорт
	
	Результат = Новый Массив;
	
	ПеременныеОтчетов = ПеременныеФинансовыхОтчетов(Истина, КодЯзыка);
	
	ЗначениеИПредставление = ОписаниеПеременной(ПеременныеОтчетов.КомплектОтчетов.Имя,
		ПеременныеОтчетов.КомплектОтчетов.Представление);
	Результат.Добавить(ЗначениеИПредставление);
	
	
	ЗначениеИПредставление = ОписаниеПеременной(ПеременныеОтчетов.ВидОтчета.Имя,
		ПеременныеОтчетов.ВидОтчета.Представление);
	Результат.Добавить(ЗначениеИПредставление);
	
	
	ЗначениеИПредставление = ОписаниеПеременной(ПеременныеОтчетов.ТекущаяДатаИВремя.Имя,
		ПеременныеОтчетов.ТекущаяДатаИВремя.Представление);
	Результат.Добавить(ЗначениеИПредставление);
	
	
	ЗначениеИПредставление = ОписаниеПеременной(ПеременныеОтчетов.ПериодОтчетности.Имя,
		ПеременныеОтчетов.ПериодОтчетности.Представление);
	Результат.Добавить(ЗначениеИПредставление);
	
	
	ЗначениеИПредставление = ОписаниеПеременной(ПеременныеОтчетов.КонечнаяДатаПериодаОтчета.Имя,
		ПеременныеОтчетов.КонечнаяДатаПериодаОтчета.Представление);
	Результат.Добавить(ЗначениеИПредставление);
	
	
	ЗначениеИПредставление = ОписаниеПеременной(ПеременныеОтчетов.Организация.Имя,
		ПеременныеОтчетов.Организация.Представление);
	Результат.Добавить(ЗначениеИПредставление);
	
	
	Возврат Результат;
	
КонецФункции

// Получает строки периода по значению перечисления.
// 
// Параметры:
// 	Период - ПеречислениеСсылка.Периодичность
// Возвращаемое значение:
// 	Структура - различные представления строка периода, содержит поля:
// 	 * Период - Строка - "Период" + период
// 	 * ВыражениеПериода - Строка - "ВыражениеПериода" + период
// 	 * ФлагПериод - Строка - "ФлагПериод" + период.
// 	 * ПериодОтчет - Строка - "Период" + период + "Отчет"
// 	 * ПериодСоединение - Строка - "Период" + период + "Соединение"
//
Функция СтрокиПериода(Период) Экспорт
	
	СтруктураВозврата = Новый Структура("Период, ПериодОтчет, ПериодСоединение, ВыражениеПериода, ФлагПериод");
	
	Если Не ЗначениеЗаполнено(Период) Тогда
		СтруктураВозврата.Период = "Период";
		СтруктураВозврата.ПериодОтчет = "ПериодОтчет";
		СтруктураВозврата.ПериодСоединение = "ПериодСоединение";
		СтруктураВозврата.ВыражениеПериода = "ВыражениеПериода";
		СтруктураВозврата.ФлагПериод = "ФлагПериод";
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		СтруктураВозврата.Период = "ПериодДень";
		СтруктураВозврата.ПериодОтчет = "ПериодДеньОтчет";
		СтруктураВозврата.ПериодСоединение = "ПериодДеньСоединение";
		СтруктураВозврата.ВыражениеПериода = "ВыражениеПериодаДень";
		СтруктураВозврата.ФлагПериод = "ФлагПериодДень";
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		СтруктураВозврата.Период = "ПериодНеделя";
		СтруктураВозврата.ПериодОтчет = "ПериодНеделяОтчет";
		СтруктураВозврата.ПериодСоединение = "ПериодНеделяСоединение";
		СтруктураВозврата.ВыражениеПериода = "ВыражениеПериодаНеделя";
		СтруктураВозврата.ФлагПериод = "ФлагПериодНеделя";
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		СтруктураВозврата.Период = "ПериодДекада";
		СтруктураВозврата.ПериодОтчет = "ПериодДекадаОтчет";
		СтруктураВозврата.ПериодСоединение = "ПериодДекадаСоединение";
		СтруктураВозврата.ВыражениеПериода = "ВыражениеПериодаДекада";
		СтруктураВозврата.ФлагПериод = "ФлагПериодДекада";
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		СтруктураВозврата.Период = "ПериодМесяц";
		СтруктураВозврата.ПериодОтчет = "ПериодМесяцОтчет";
		СтруктураВозврата.ПериодСоединение = "ПериодМесяцСоединение";
		СтруктураВозврата.ВыражениеПериода = "ВыражениеПериодаМесяц";
		СтруктураВозврата.ФлагПериод = "ФлагПериодМесяц";
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		СтруктураВозврата.Период = "ПериодКвартал";
		СтруктураВозврата.ПериодОтчет = "ПериодКварталОтчет";
		СтруктураВозврата.ПериодСоединение = "ПериодКварталСоединение";
		СтруктураВозврата.ВыражениеПериода = "ВыражениеПериодаКвартал";
		СтруктураВозврата.ФлагПериод = "ФлагПериодКвартал";
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		СтруктураВозврата.Период = "ПериодПолугодие";
		СтруктураВозврата.ПериодОтчет = "ПериодПолугодиеОтчет";
		СтруктураВозврата.ПериодСоединение = "ПериодПолугодиеСоединение";
		СтруктураВозврата.ВыражениеПериода = "ВыражениеПериодаПолугодие";
		СтруктураВозврата.ФлагПериод = "ФлагПериодПолугодие";
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		СтруктураВозврата.Период = "ПериодГод";
		СтруктураВозврата.ПериодОтчет = "ПериодГодОтчет";
		СтруктураВозврата.ПериодСоединение = "ПериодГодСоединение";
		СтруктураВозврата.ВыражениеПериода = "ВыражениеПериодаГод";
		СтруктураВозврата.ФлагПериод = "ФлагПериодГод";
	Иначе
		ВызватьИсключение НСтр("ru = 'Неизвестное значение перечисления:'") + " " + Период
	КонецЕсли;
	
	Возврат СтруктураВозврата;
		
КонецФункции

// Возвращает периодичность по строковому выражению периода
//
// Параметры:
//  ПериодСтрока - строковое выражение периода ("ПериодДень", "ПериодНеделя", "ПериодМесяц" и др.)
//
// Возвращаемое значение:
//    Периодичность - значение перечисления Периодичность
//
Функция ПериодичностьПоПериодуСтрокой(ПериодСтрока) Экспорт
	
	Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.ПустаяСсылка");
	
	Если ПериодСтрока = "ПериодДень" Тогда
		Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День");
	ИначеЕсли ПериодСтрока = "ПериодНеделя" Тогда
		Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя");
	ИначеЕсли ПериодСтрока = "ПериодДекада" Тогда
		Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада");
	ИначеЕсли ПериодСтрока = "ПериодМесяц" Тогда
		Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц");
	ИначеЕсли ПериодСтрока = "ПериодКвартал" Тогда
		Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал");
	ИначеЕсли ПериодСтрока = "ПериодПолугодие" Тогда
		Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие");
	ИначеЕсли ПериодСтрока = "ПериодГод" Тогда
		Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год");
	КонецЕсли;
	
	Возврат Периодичность;
	
КонецФункции


// Возвращает родителя переданной строки в зависимости от типа.
//
//	Параметры:
//		СтрокаДерева - ДанныеФормыЭлементДерева, СтрокаДереваЗначений - строка дерева элементов отчета.
//
//	Возвращаемое значение:
//		ДанныеФормыЭлементДерева - Родитель строки,
//		СтрокаДереваЗначений - Родитель строки.
//
Функция РодительСтроки(СтрокаДерева) Экспорт
	
	Если ТипЗнч(СтрокаДерева) = Тип("ДанныеФормыЭлементДерева")
		ИЛИ ТипЗнч(СтрокаДерева) = Тип("ДанныеФормыДерево") Тогда
		РодительСтроки = СтрокаДерева.ПолучитьРодителя();
	Иначе
		РодительСтроки = СтрокаДерева.Родитель;
	КонецЕсли;
	
	Возврат РодительСтроки;
	
КонецФункции

#КонецОбласти

