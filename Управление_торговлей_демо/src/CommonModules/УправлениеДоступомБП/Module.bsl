#Область ПрограммныйИнтерфейс

// Определяет перечень организаций, чтение данных которых, размещенных в конкретном объекте метаданных,
// разрешено пользователю настройками прав доступа.
//
// Функцию можно использовать, если требуется получать данные в привилегированном режиме для предоставления их пользователю - 
// она позволяет ограничить эти данные в соответствии с настройками.
//
// Функцию можно использовать только в тех случаях (для тех объектов),
// когда применяется стандартное ограничение доступа к запрашиваемому объекту метаданных - 
// то есть, аналогичное ограничению, применяемому для регистру бухгалтерии Хозрасчетный
// роли ДобавлениеИзменениеДанныхБухгалтерии.
//
// Порядок использования:
//  1. с помощью функции определяется список доступных организаций
//  2. в текстах запросов к самим данных (регистрам, документам) 
//     устанавливаются отборы по этим организациям
//  3. перед выполнением запроса к данным включается привилегированный режим.
//
// При использовании функции следует иметь в виду, что в общем случае ограничить выбираемые данные
// в соответствии с ОДД по Организации недостаточно:
// 1. в прикладном решении могут использоваться и иные виды доступа, не только Организации
// 2. перед установкой привилегированного режима в вызывающем коде следует проверить наличие прав
//    на чтение запрашиваемой таблицы (регистра, документов) в целом.
//
// Не следует (запрещается) вызывать эту функцию из кода, который может выполняться в привилегированном режиме,
// так как это приведет к последующей неверной ее работе вне привилегированного режима:
// может повторно использоваться значение, вычисленное в привилегированном режиме.
//
// Возвращаемое значение:
//  ФиксированныйМассив - содержит СправочникСсылка.Организации
//
// См. также ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS()
//
// Параметры:
//  ИмяОбъектаДанных - Строка - полное имя объекта данных, доступ к которым проверяется, например, "РегистрБухгалтерии.Хозрасчетный"
//  ПравоНаИзменение - Булево - Истина, если после выполнения запроса данные предполагается менять
//               и нужно проверить, что у пользователя есть право на изменение
//  Пользователь     - СправочникСсылка.Пользователи - Ссылка на пользователя, для которого нужно получить список организаций.
// 
Функция ОрганизацииДанныеКоторыхДоступныПользователю(ИмяОбъектаДанных, ПравоНаИзменение = Ложь, Пользователь = Неопределено) Экспорт
	
	Запрос = Новый Запрос;

	Если Пользователи.ЭтоПолноправныйПользователь(Пользователь , , Ложь)
	 Или Не УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей() Тогда
		
		// Ограничений по RLS нет, возвращаем все организации из справочника
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации";
		
		МассивОрганизаций = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
		Возврат Новый ФиксированныйМассив(МассивОрганизаций);
		
	КонецЕсли;

	Если ПараметрыСеанса.ОграничениеДоступаНаУровнеЗаписейУниверсально Тогда
	
		// Используется механизм ограничения доступа БСП 3.0.
		// В этом случае проверка права на запись отдельно не учитывается,
		// т.к. права на добавление/изменение/удаление проверяются в момент записи, а не чтения,
		// поэтому считаем, что если есть право на чтение, то может быть доступен и для записи.
		
		// Список доступных организаций получаем в обычном, непривилегированном режиме.
		// Выбираем список организаций, по которым можно читать записи регистра.
		
		Запрос.Текст = СтрЗаменить(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	ИСТИНА В
		|			(ВЫБРАТЬ ПЕРВЫЕ 1
		|				ИСТИНА
		|			ИЗ
		|				#ТаблицаРегистра КАК ТаблицаРегистра
		|			ГДЕ
		|				ТаблицаРегистра.Организация = Организации.Ссылка)",
		"#ТаблицаРегистра", ИмяОбъектаДанных);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		МассивОрганизаций = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		// Если по организации не введено ни одной записи, то считаем, что ее данные можно читать любому пользователю.
		
		Запрос.Текст = СтрЗаменить(
		"ВЫБРАТЬ
		|	Организации.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|		ЛЕВОЕ СОЕДИНЕНИЕ #ТаблицаРегистра КАК ТаблицаРегистра
		|		ПО Организации.Ссылка = ТаблицаРегистра.Организация
		|ГДЕ
		|	ТаблицаРегистра.Организация ЕСТЬ NULL",
		"#ТаблицаРегистра", ИмяОбъектаДанных);
		
		УстановитьПривилегированныйРежим(Истина);
		РезультатЗапроса = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОрганизаций,
			РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	Иначе

		// Запрос взят из шаблона #ПоЗначениям роли ДобавлениеИзменениеДанныхБухгалтерии
		// с теми параметрами, с которыми он применяется для регистра бухгалтерии Хозрасчетный.
		Запрос.УстановитьПараметр("Пользователь",
			?(Пользователь = Неопределено, Пользователи.ТекущийПользователь(), Пользователь));
		Запрос.УстановитьПараметр("Изменение", ПравоНаИзменение);
		Запрос.УстановитьПараметр("ИмяОбъектаДанных", ИмяОбъектаДанных);
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	ИСТИНА В
		|			(ВЫБРАТЬ ПЕРВЫЕ 1
		|				ИСТИНА
		|			ИЗ
		|				Справочник.ИдентификаторыОбъектовМетаданных КАК СвойстваТекущейТаблицы
		|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа КАК ГруппыДоступа
		|					ПО
		|						СвойстваТекущейТаблицы.ПолноеИмя = &ИмяОбъектаДанных
		|							И ИСТИНА В
		|								(ВЫБРАТЬ ПЕРВЫЕ 1
		|									ИСТИНА
		|								ИЗ
		|									РегистрСведений.ТаблицыГруппДоступа КАК ТаблицыГруппДоступа
		|								ГДЕ
		|									ТаблицыГруппДоступа.Таблица = СвойстваТекущейТаблицы.Ссылка
		|									И ТаблицыГруппДоступа.ГруппаДоступа = ГруппыДоступа.Ссылка
		|									И ТаблицыГруппДоступа.ПравоИзменение = &Изменение)
		|							И ГруппыДоступа.Ссылка В
		|								(ВЫБРАТЬ
		|									ГруппыДоступаПользователи.Ссылка КАК ГруппаДоступа
		|								ИЗ
		|									Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|										ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|										ПО
		|											СоставыГруппПользователей.Пользователь = &Пользователь
		|												И СоставыГруппПользователей.ГруппаПользователей = ГруппыДоступаПользователи.Пользователь)
		|			ГДЕ
		|				ВЫБОР
		|					КОГДА ИСТИНА В
		|							(ВЫБРАТЬ ПЕРВЫЕ 1
		|								ИСТИНА
		|							ИЗ
		|								РегистрСведений.ЗначенияГруппДоступа КАК Значения
		|									ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ГруппыЗначенийДоступа КАК ГруппыЗначений
		|									ПО
		|										Значения.ГруппаДоступа = ГруппыДоступа.Ссылка
		|											И Значения.ЗначениеДоступа = Организации.Ссылка
		|											И ГруппыЗначений.ЗначениеДоступа = ГруппыЗначений.ГруппаЗначенийДоступа)
		|						ТОГДА ИСТИНА
		|					ИНАЧЕ ЛОЖЬ
		|				КОНЕЦ = ВЫБОР
		|					КОГДА ИСТИНА В
		|							(ВЫБРАТЬ ПЕРВЫЕ 1
		|								ИСТИНА
		|							ИЗ
		|								РегистрСведений.ЗначенияГруппДоступаПоУмолчанию КАК ЗначенияПоУмолчанию
		|							ГДЕ
		|								ЗначенияПоУмолчанию.ГруппаДоступа = ГруппыДоступа.Ссылка
		|								И ТИПЗНАЧЕНИЯ(ЗначенияПоУмолчанию.ТипЗначенийДоступа) = ТИПЗНАЧЕНИЯ(Организации.Ссылка)
		|								И ЗначенияПоУмолчанию.ВсеРазрешены = ЛОЖЬ)
		|						ТОГДА ИСТИНА
		|					ИНАЧЕ ЛОЖЬ
		|				КОНЕЦ)";
		
		Если Не ПравоНаИзменение Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И ТаблицыГруппДоступа.ПравоИзменение = &Изменение", "");
		КонецЕсли;
		Запрос.Текст = ТекстЗапроса;
		
		// Доступ к настройкам RLS выполняется в привилегированном режиме.
		УстановитьПривилегированныйРежим(Истина);
		РезультатЗапроса = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		
		МассивОрганизаций = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");		
		
	КонецЕсли;

	Возврат Новый ФиксированныйМассив(МассивОрганизаций);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Включает виды доступа в подсистеме БСП "Управление доступом".
// См. УправлениеДоступомПереопределяемый.ПриЗаполненииВидовДоступа()
//
Процедура ЗаполнитьВидыДоступа(ВидыДоступа) Экспорт
	
	// Организации
	Если ВидыДоступа.Найти("Организации", "Имя") = Неопределено Тогда // Могут быть добавлены библиотеками
		ВидДоступа = ВидыДоступа.Добавить();
		ВидДоступа.Имя           = "Организации";
		ВидДоступа.Представление = НСтр("ru = 'Организации'");
		ВидДоступа.ТипЗначений   = Тип("СправочникСсылка.Организации");
	КонецЕсли;
	
КонецПроцедуры

// Позволяет указать списки, у которых объекты метаданных содержат описание логики ограничения
// доступа в модулях менеджеров или переопределяемом модуле.
//
// В модулях менеджеров указанных списков должна быть размещена процедура обработчика,
// в которую передаются следующие параметры.
// 
//  Ограничение - Структура - со свойствами:
//    * Текст                             - Строка - ограничение доступа для пользователей.
//                                            Если пустая строка, значит доступ разрешен.
//    * ТекстДляВнешнихПользователей      - Строка - ограничение доступа для внешних пользователей.
//                                            Если пустая строка, значит доступ запрещен.
//    * ПоВладельцуБезЗаписиКлючейДоступа - Неопределено - определить автоматически.
//                                        - Булево - если Ложь, то всегда записывать ключи доступа,
//                                            если Истина, тогда не записывать ключи доступа,
//                                            а использовать ключи доступа владельца (требуется,
//                                            чтобы ограничение было строго по объекту-владельцу).
///   * ПоВладельцуБезЗаписиКлючейДоступаДляВнешнихПользователей - Неопределено, Булево - см.
//                                            описание предыдущего параметра.
//
// Далее пример процедуры для модуля менеджера.
//
//// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
//Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
//	
//	Ограничение.Текст =
//	"РазрешитьЧтениеИзменение
//	|ГДЕ
//	|	ЗначениеРазрешено(Организация)
//	|	И ЗначениеРазрешено(Контрагент)";
//	
//КонецПроцедуры
//
// Параметры:
//  Списки - Соответствие - списки с ограничением доступа:
//             * Ключ     - ОбъектМетаданных - список с ограничением доступа.
//             * Значение - Булево - Истина - текст ограничения в модуле менеджера.
//                                 - Ложь   - текст ограничения в этом переопределяемом
//                модуле в процедуре ПриЗаполненииОграниченияДоступа.
//
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт


	Списки.Вставить(Метаданные.РегистрыСведений.ЖурналУчетаСчетовФактур, Истина);


	Списки.Вставить(Метаданные.РегистрыСведений.ОшибочныеРеквизитыКонтрагентов, Истина);


	Списки.Вставить(Метаданные.РегистрыНакопления.НДСЗаписиКнигиПокупок, Истина);
	Списки.Вставить(Метаданные.РегистрыНакопления.НДСЗаписиКнигиПродаж, Истина);

	
КонецПроцедуры

#КонецОбласти
