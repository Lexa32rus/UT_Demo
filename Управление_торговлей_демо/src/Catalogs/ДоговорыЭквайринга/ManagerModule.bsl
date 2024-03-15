#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция определяет реквизиты выбранного договора эквайринга.
//
// Параметры:
//    Договор - СправочникСсылка.ДоговорыЭквайринга - Ссылка на договор эквайринга.
//
// Возвращаемое значение:
//    Структура - Реквизиты договора эквайринга.
//
Функция РеквизитыДоговора(Договор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеСправочника.Организация                                    КАК Организация,
	|	ДанныеСправочника.БанковскийСчет                                 КАК БанковскийСчет,
	|	ДанныеСправочника.БанковскийСчет.ВалютаДенежныхСредств           КАК Валюта,
	|	ДанныеСправочника.Контрагент                                     КАК Эквайер,
	|	ДанныеСправочника.БанковскийСчетКонтрагента                      КАК БанковскийСчетКонтрагента,
	|	ДанныеСправочника.ИспользуютсяЭквайринговыеТерминалы             КАК ИспользуютсяЭквайринговыеТерминалы,
	|	ДанныеСправочника.ДетальнаяСверкаТранзакций                      КАК ДетальнаяСверкаТранзакций,
	|	ДанныеСправочника.СпособОтраженияКомиссии                        КАК СпособОтраженияКомиссии,
	|	ДанныеСправочника.ФиксированнаяСтавкаКомиссии                    КАК ФиксированнаяСтавкаКомиссии,
	|	ДанныеСправочника.СтавкаКомиссии                                 КАК СтавкаКомиссии,
	|	ДанныеСправочника.ВзимаетсяКомиссияПриВозврате                   КАК ВзимаетсяКомиссияПриВозврате,
	|	ДанныеСправочника.РазрешитьПлатежиБезУказанияЗаявок              КАК РазрешитьПлатежиБезУказанияЗаявок,
	|	ДанныеСправочника.СтатьяРасходов                                 КАК СтатьяРасходов,
	|	ДанныеСправочника.АналитикаРасходов                              КАК АналитикаРасходов,
	|	ДанныеСправочника.ПодразделениеРасходов                          КАК ПодразделениеРасходов,
	|	ДанныеСправочника.НаправлениеДеятельности                        КАК НаправлениеДеятельности,
	|	ДанныеСправочника.СтатьяДвиженияДенежныхСредствПоступлениеОплаты КАК СтатьяДвиженияДенежныхСредствПоступлениеОплаты,
	|	ДанныеСправочника.СтатьяДвиженияДенежныхСредствВозврат           КАК СтатьяДвиженияДенежныхСредствВозврат
	|ИЗ
	|	Справочник.ДоговорыЭквайринга КАК ДанныеСправочника
	|ГДЕ
	|	ДанныеСправочника.Ссылка = &Договор
	|";
	
	Запрос.УстановитьПараметр("Договор", Договор);
	
	СтруктураРеквизитов = Новый Структура("Организация, БанковскийСчет, Валюта, Эквайер, БанковскийСчетКонтрагента,
		|ИспользуютсяЭквайринговыеТерминалы, ДетальнаяСверкаТранзакций,
		|СпособОтраженияКомиссии, ФиксированнаяСтавкаКомиссии, СтавкаКомиссии, ВзимаетсяКомиссияПриВозврате, РазрешитьПлатежиБезУказанияЗаявок,
		|СтатьяРасходов, АналитикаРасходов, ПодразделениеРасходов, НаправлениеДеятельности,
		|СтатьяДвиженияДенежныхСредствПоступлениеОплаты, СтатьяДвиженияДенежныхСредствВозврат");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Выборка);
	КонецЕсли;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

// Функция определяет договор эквайринга по выбранной организации.
//
// Возвращает договор, если найден единственный договор.
// Возвращает пустую ссылку, в противном случае.
//
// Параметры:
//    Организация - СправочникСсылка.Организации - Выбранная организация.
//    Эквайер - СправочникСсылка.Контрагенты - Выбранный контрагент.
//    Валюта - СправочникСсылка.Валюты - Выбранная валюта.
//
// Возвращаемое значение:
//    СправочникСсылка.ДоговорыЭквайринга - Найденный договор.
//
Функция ДоговорПоУмолчанию(Организация = Неопределено, Эквайер = Неопределено, Валюта = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	ДанныеСправочника.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ДоговорыЭквайринга КАК ДанныеСправочника
	|ГДЕ
	|	НЕ ДанныеСправочника.ПометкаУдаления
	|	И ДанныеСправочника.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Действует)
	|	И (ДанныеСправочника.Организация = &Организация
	|		ИЛИ &Организация = Неопределено)
	|	И (ДанныеСправочника.Контрагент = &Эквайер
	|		ИЛИ &Эквайер = Неопределено)
	|	И (ДанныеСправочника.БанковскийСчет.ВалютаДенежныхСредств = &Валюта
	|		ИЛИ &Валюта = Неопределено
	|		ИЛИ ДанныеСправочника.БанковскийСчет.ВалютаДенежныхСредств ЕСТЬ NULL)
	|";
	
	Запрос.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Организация), Организация, Неопределено));
	Запрос.УстановитьПараметр("Эквайер", ?(ЗначениеЗаполнено(Эквайер), Эквайер, Неопределено));
	Запрос.УстановитьПараметр("Валюта", ?(ЗначениеЗаполнено(Валюта), Валюта, Неопределено));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество()=1 И Выборка.Следующий() Тогда
		Результат = Выборка.Ссылка;
	Иначе
		Результат = Справочники.ДоговорыЭквайринга.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Партнер");
	Результат.Добавить("Контрагент");
	Результат.Добавить("Организация");
	Результат.Добавить("Подразделение");
	Результат.Добавить("БанковскийСчет");
	Результат.Добавить("НаправлениеДеятельности");
	
	Возврат Результат;
	
КонецФункции

// Добавляет команду создания справочника "Договоры лизинга".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	МетаданныеСправочника = Метаданные.Справочники.ДоговорыЭквайринга;
	
	Если ПравоДоступа("Добавление", МетаданныеСправочника) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = МетаданныеСправочника.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(МетаданныеСправочника);
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Документы.ОтчетБанкаПоОперациямЭквайринга.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Определяет свойства полей формы в зависимости от данных
//
// Параметры:
//	Настройки - ТаблицаЗначений - таблица с колонками:
//		* Поля - Массив - поля, для которых определяются настройки отображения
//		* Условие - ОтборКомпоновкиДанных - условия применения настройки
//		* Свойства - Структура - имена и значения свойств
//
Процедура ЗаполнитьНастройкиПолейФормы(Настройки) Экспорт
	
	Финансы = ФинансоваяОтчетностьСервер;
	
	// Основание
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СтавкаКомиссии");
	Финансы.НовыйОтбор(Элемент.Условие, "ФиксированнаяСтавкаКомиссии", Истина);
	Элемент.Свойства.Вставить("Доступность");
	
	// ВзимаетсяКомиссияПриВозврате
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ВзимаетсяКомиссияПриВозврате");
	ГруппаИли = Финансы.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	Финансы.НовыйОтбор(ГруппаИли, "СпособОтраженияКомиссии", Перечисления.СпособыОтраженияЭквайринговойКомиссии.ПриЗачислении);
	Финансы.НовыйОтбор(ГруппаИли, "СпособОтраженияКомиссии", Перечисления.СпособыОтраженияЭквайринговойКомиссии.ВоВремяТранзакции);
	Элемент.Свойства.Вставить("Доступность");
	
	// НадписьЭквайринговыеТерминалы
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("НадписьЭквайринговыеТерминалы");
	Финансы.НовыйОтбор(Элемент.Условие, "ИспользуютсяЭквайринговыеТерминалы", Истина);
	Элемент.Свойства.Вставить("Видимость");
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияПартнеров КАК Т2 
	|	ПО Т2.Родитель = Т.Партнер
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Т2.Партнер)
	|	И ЗначениеРазрешено(Т.Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Заполняет реквизиты параметров настройки счетов учета эквайринга, которые влияют на настройку,
// 	соответствующими им именам реквизитов аналитики учета.
//
// Параметры:
// 	СоответствиеИмен - Соответствие - ключом выступает имя реквизита, используемое в настройке счетов учета,
// 		значением является соответствующее имя реквизита аналитики учета.
// 
Процедура ЗаполнитьСоответствиеРеквизитовНастройкиСчетовУчета(СоответствиеИмен) Экспорт
	
	СоответствиеИмен.Организация = "Организация";
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

