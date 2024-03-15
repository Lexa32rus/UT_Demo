
#Область ПрограммныйИнтерфейс

// Дополняет структуру действий пересчета строки табличной части, с целью заполнения признака 'ВедетсяУчетПоРНПТ'.
//
// Параметры:
//	СтруктураДействий - Структура - описывает действия, где:
//		* Ключ - Строка - наименование действия.
//		* Значение - Структура - параметры действия.
//	ПараметрыДействияСоСтрокой - Структура, Неопределено - коллекция, ключом у которой выступает имя источника поля
//															номенклатура (для которой осуществляется проверка признака
//															прослеживаемости), например, "НоменклатураОприходование".
//															А значением - имя поля, хранящим сведения о признаке
//															прослеживаемости номенклатуры, например,
//															"ВедетсяУчетПоРНПТОприходование".
//
Процедура ДополнитьОписаниеНастроекЗаполненияСлужебныхРеквизитовТабличнойЧасти(СтруктураДействий,
																				ПараметрыДействияСоСтрокой = Неопределено) Экспорт
	
	Если ПараметрыДействияСоСтрокой = Неопределено Тогда
		ПараметрыДействияСоСтрокой = Новый Структура("Номенклатура", "ВедетсяУчетПоРНПТ");
	КонецЕсли;
	//++ Локализация
	СтруктураДействий.Вставить("ЗаполнитьПризнакВедетсяУчетПоРНПТ", ПараметрыДействияСоСтрокой);
	//-- Локализация
	
КонецПроцедуры

// Возвращает структуру, содержащую поля значений, используемых для заполнения количества по РНПТ в строках табличной
// части документа.
//
// Параметры:
//	Объект - ДанныеФормыСтруктура, Структура - данные формы объекта, которые содержат:
//		* Ссылка - ДокументСсылка - ссылка на документ в ИБ, с которым осуществляется работа.
//	ИмяПоляМестоХранения - Строка - имя поля Склад или другого места хранения, находящегося в шапке объекта или табличной части.
//	МестоХраненияВТабличнойЧасти - Булево - признак наличия поля Склад или другого места хранения в табличной части объекта.
//
// Возвращаемое значение:
//	Структура - содержит следующие свойства:
//		* ИсключаемыйДокумент - ДокументСсылка - документ, движения которого исключаются при расчета коэффициента по РНПТ.
//		* Организация - СправочникСсылка.Организации - организация, для которой рассчитывается коэффициент по РНПТ.
//		* Соглашение - СправочникСсылка.СоглашенияСКлиентами - соглашение, для которого рассчитывается коэффициент по РНПТ.
//		* МестоХраненияВТабличнойЧасти - Булево - признак наличия поля Склад или другого места хранения в табличной части объекта.
//		* ИмяПоляМестоХранения - Строка - имя поля Склад или другого места хранения, находящегося в шапке объекта или табличной части.
//		* МестоХранения - СправочникСсылка.Склады - склад или другое место хранения, для которого рассчитывается коэффициент по РНПТ.
//		* ИменаПолейССуффиксом - Структура- коллекция, содержащая имена рекизитов с суффиксом. Ключом коллекции
//											выступает имя реквизита без суффикса, например "Номенклатура", а значением
//											задается имя реквизита с суффиксом, например "НоменклатураОприходование".
//
Функция ПараметрыПолученияКоэффициентаРНПТ(Объект, ИмяПоляМестоХранения = "Склад", МестоХраненияВТабличнойЧасти = Ложь) Экспорт
	
	СтруктураЗаполненияКоэффициентаРНПТ = Новый Структура;
	СтруктураЗаполненияКоэффициентаРНПТ.Вставить("Дата",							Объект.Дата);
	СтруктураЗаполненияКоэффициентаРНПТ.Вставить("ИсключаемыйДокумент",				Объект.Ссылка);
	СтруктураЗаполненияКоэффициентаРНПТ.Вставить("Организация",						Объект.Организация);
	СтруктураЗаполненияКоэффициентаРНПТ.Вставить("МестоХраненияВТабличнойЧасти",	МестоХраненияВТабличнойЧасти);
	СтруктураЗаполненияКоэффициентаРНПТ.Вставить("ИмяПоляМестоХранения",			ИмяПоляМестоХранения);
	СтруктураЗаполненияКоэффициентаРНПТ.Вставить("МестоХранения",					Неопределено);
	СтруктураЗаполненияКоэффициентаРНПТ.Вставить("Соглашение",
												ПредопределенноеЗначение("Справочник.СоглашенияСКлиентами.ПустаяСсылка"));
	СтруктураЗаполненияКоэффициентаРНПТ.Вставить("ИменаПолейССуффиксом",			Новый Структура);
	
	Если Не МестоХраненияВТабличнойЧасти Тогда
		СтруктураЗаполненияКоэффициентаРНПТ.Вставить("МестоХранения", Объект[ИмяПоляМестоХранения]);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "Соглашение") Тогда
		СтруктураЗаполненияКоэффициентаРНПТ.Соглашение = Объект.Соглашение;
	КонецЕсли;
	
	Возврат СтруктураЗаполненияКоэффициентаРНПТ;
	
КонецФункции

// Дополняет структуру действий пересчета строки табличной части, с целью пересчета поля 'КоличествоПоРНПТ'.
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - данные формы объекта.
//	СтруктураДействий - Структура - описывает действия, где Ключ - наименование действия,
//									Значение - Структура - параметры действия.
//	ИмяПоляМестоХранения - Строка - имя поля Склад или другого места хранения, находящегося в шапке объекта или табличной части.
//	МестоХраненияВТабличнойЧасти - Булево - признак наличия поля Склад или другого места хранения в табличной части объекта.
//
Процедура ДополнитьОписаниеНастроекПересчетаРеквизитовТабличнойЧасти(Объект,
																	СтруктураДействий,
																	ИмяПоляМестоХранения = "Склад",
																	МестоХраненияВТабличнойЧасти = Ложь) Экспорт
	
	//++ Локализация
	СтруктураПересчетаКоличестваРНПТ = ПараметрыПолученияКоэффициентаРНПТ(Объект, ИмяПоляМестоХранения, МестоХраненияВТабличнойЧасти);
	
	СтруктураДействий.Вставить("ПересчитатьКоличествоПоРНПТ", СтруктураПересчетаКоличестваРНПТ);
	//-- Локализация
	
КонецПроцедуры

// Возвращает значение коэффициента по РНПТ для текущей строки табличной части объекта по заданным параметрам.
//
// Параметры:
//	ПараметрыПересчета - Структура - см. УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ПараметрыПолученияКоэффициентаРНПТ().
//	ТекущаяСтрока - Структура - строка табличной части для которой выполняется расчет коэффициента по РНПТ.
//	КэшированныеЗначения - Структура - кэшированные значения текущей строки табличной части.
//
// Возвращаемое значение:
//	Число - коэффициент по РНПТ.
//
Функция ПолучитьКоэффициентРНПТ(ПараметрыПересчета, ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	Результат = 0;
	
	//++ Локализация
	ИсключаемыйДокумент	= ПараметрыПересчета.ИсключаемыйДокумент;
	Дата				= ПараметрыПересчета.Дата;
	Организация			= ПараметрыПересчета.Организация;
	Соглашение			= ПараметрыПересчета.Соглашение;
	МестоХранения		= ?(ПараметрыПересчета.МестоХраненияВТабличнойЧасти,
							ТекущаяСтрока[ПараметрыПересчета.ИмяПоляМестоХранения],
							ПараметрыПересчета.МестоХранения);
	
	КлючКоэффициента	= КлючКэшаКоэффициентРНПТ(ТекущаяСтрока, ПараметрыПересчета);
	Кэш					= КэшированныеЗначения.КоэффициентыРНПТ[КлючКоэффициента];
	
	Если Кэш = Неопределено Тогда
		#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
			
			Если УчетПрослеживаемыхТоваровЛокализация.ИспользоватьУчетПрослеживаемыхИмпортныхТоваров(Дата) Тогда
				
				Товары = Новый ТаблицаЗначений;
				Товары.Колонки.Добавить("Номенклатура",		Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
				Товары.Колонки.Добавить("Характеристика",	Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
				Товары.Колонки.Добавить("МестоХранения",	Новый ОписаниеТипов("СправочникСсылка.Склады,
																				|СправочникСсылка.Партнеры,
																				|СправочникСсылка.ДоговорыКонтрагентов,
																				|СправочникСсылка.Организации,
																				|ДокументСсылка.ПриобретениеТоваровУслуг,
																				|ДокументСсылка.ВозвратТоваровПоставщику,
																				|ДокументСсылка.КорректировкаПриобретения"));
				
				Товары.Колонки.Добавить("НомерГТД",			Новый ОписаниеТипов("СправочникСсылка.НомераГТД"));
				
				Строка = Товары.Добавить();
				ЗаполнитьЗначенияСвойств(Строка, ТекущаяСтрока);
				
				Строка.МестоХранения = МестоХранения;
				
				ЗначенияРеквизитов = ОбработкаТабличнойЧастиСервер.ПолучитьКоэффициентРНПТ(ИсключаемыйДокумент,
																							Организация,
																							Товары,
																							КэшированныеЗначения,
																							Соглашение);
				
				Если ЗначенияРеквизитов.Количество() > 0 Тогда
					Результат = ЗначенияРеквизитов[0].Коэффициент;
				КонецЕсли;
				
				КэшированныеЗначения.КоэффициентыРНПТ.Вставить(КлючКоэффициента, Результат);
				
			КонецЕсли;
			
		#Иначе
			
			ТекстИсключения = НСтр("ru = 'Попытка получения коэффициента по РНПТ на клиенте.'");
			
			ВызватьИсключение ТекстИсключения;
			
		#КонецЕсли
	Иначе
		Результат = Кэш;
	КонецЕсли;
	//-- Локализация
	
	Возврат Результат;
	
КонецФункции

// Вызывается после разбиения строки, для корректного распределения количества по РНПТ.
// Может быть передана в обработку оповещения метода ОбщегоНазначенияУТКлиент.РазбитьСтрокуТЧ.
//
// Параметры:
//	НоваяСтрока - ДанныеФормыЭлементКоллекции - строка табличной части после выполнения разбиения.
//	ДополнительныеПараметры - Структура - со следующими ключами:
//		* ИсходнаяСтрока - ДанныеФормыЭлементКоллекции - ссылка на строку табличной части, которую разбиваем.
//		* ИсходноеКоличество - Число - количество исходной строки, до разбиения.
//
Процедура РазбитьСтрокуЗавершение(НоваяСтрока, ДополнительныеПараметры) Экспорт
	
	//++ Локализация
	Если НоваяСтрока <> Неопределено Тогда
		
		Если ДополнительныеПараметры = Неопределено
			Или Не ДополнительныеПараметры.Свойство("ИсходнаяСтрока")
			Или Не ДополнительныеПараметры.Свойство("ИсходноеКоличество") Тогда
			
			ИмяМетода = "УчетПрослеживаемыхТоваровЛокализация.РазбитьСтрокуЗавершение";
			ИмяВходящегоПараметра = "ДополнительныеПараметры";
			
			ТекстОшибки = НСтр("ru='Ошибка в методе %1, входящий параметр %2 задан некорректно.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, ИмяМетода, ИмяВходящегоПараметра);
			
			ВызватьИсключение ТекстОшибки;
			
		КонецЕсли;
		
		ИсходноеКоличество			= ДополнительныеПараметры.ИсходноеКоличество;
		ИсходноеКоличествоПоРНПТ	= ДополнительныеПараметры.ИсходноеКоличествоРНПТ;
		ИсходнаяСтрока				= ДополнительныеПараметры.ИсходнаяСтрока;
		
		Если ИсходноеКоличество <> 0 Тогда
			КоэффициентРазбиения = ИсходнаяСтрока.Количество / ИсходноеКоличество;
			
			ИсходнаяСтрока.КоличествоПоРНПТ	= ИсходноеКоличествоПоРНПТ * КоэффициентРазбиения;
			НоваяСтрока.КоличествоПоРНПТ	= ИсходноеКоличествоПоРНПТ - ИсходнаяСтрока.КоличествоПоРНПТ;
		КонецЕсли;
		
	КонецЕсли;
	//-- Локализация
	
КонецПроцедуры

// Дополняет (или создает) структуру содержащую необходимую информацию для разбиения строки табличной части,
// с учетом количества по РНПТ.
//
// Параметры:
//	ТекущаяСтрока - Структура - выделенная строка табличной части.
//	ДополнительныеПараметры - Структура - одноименноый входящий параметр объекта ОписаниеОповещения.
//
// Возвращаемое значение:
//	Структура - свойства содержат необходимую информацию для разбиения строки табличной части
//				с учетом количества по РНПТ.
//
Функция ДополнитьОписаниеПараметровРазбиенияСтрокиТабличнойЧасти(ТекущаяСтрока,
																ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ДополнительныеПараметры) Тогда
		ДополнительныеПараметры = Новый Структура();
	КонецЕсли;
	
	//++ Локализация
	Если ТекущаяСтрока <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("ИсходноеКоличество",		ТекущаяСтрока.Количество);
		ДополнительныеПараметры.Вставить("ИсходноеКоличествоРНПТ",	ТекущаяСтрока.КоличествоПоРНПТ);
		ДополнительныеПараметры.Вставить("ИсходнаяСтрока",			ТекущаяСтрока);
	КонецЕсли;
	//-- Локализация
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

// Открывает форму отчета Ведомость прослеживаемых товаров в составе ОС с заданными параметрами.
//
// Параметры:
//	ПараметрыФормы - Структура - параметры для формирования отчета.
Процедура СформироватьВедомость(ПараметрыФормы) Экспорт
	
	//++ Локализация


	//-- Локализация
	
КонецПроцедуры

// Открывает форму подбора с заданными параметрами.
//
// Параметры:
//	ПараметрыПодбора - Структура - параметры для формирования отчета.
//  Форма - Форма - форма-владелец.
Процедура ОткрытьФормуПодбора(ПараметрыПодбора, Форма) Экспорт
	
	//++ Локализация


	//-- Локализация
	
КонецПроцедуры

//	Возвращает имя формы подбора по остаткам прослеживаемых товаров в составе ОС
//
// Возвращаемое значение:
//	Строка - имя формы подбора по остаткам прослеживаемых товаров в составе ОС
//
Функция ИмяФормыПодбораПоОстаткамПрослеживаемхТоваровВОС() Экспорт
	
	ИмяФормыПодбора = "";
	//++ Локализация


	//-- Локализация
	Возврат ИмяФормыПодбора;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция КлючКэшаКоэффициентРНПТ(ТекущаяСтрока, ПараметрыПересчета) Экспорт
	
	КлючКэша		= "";
	ПустоеЗначение	= "ПустоеЗначение";
	МестоХранения	= ?(ПараметрыПересчета.МестоХраненияВТабличнойЧасти,
						ТекущаяСтрока[ПараметрыПересчета.ИмяПоляМестоХранения],
						ПараметрыПересчета.МестоХранения);
	
	КлючКэша = ?(ЗначениеЗаполнено(ПараметрыПересчета.Организация),
				Строка(ПараметрыПересчета.Организация.УникальныйИдентификатор()),
				ПустоеЗначение);
	КлючКэша = КлючКэша + ?(ЗначениеЗаполнено(ПараметрыПересчета.Соглашение),
							Строка(ПараметрыПересчета.Соглашение.УникальныйИдентификатор()),
							ПустоеЗначение);
	КлючКэша = КлючКэша + ?(ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура),
							Строка(ТекущаяСтрока.Номенклатура.УникальныйИдентификатор()),
							ПустоеЗначение);
	КлючКэша = КлючКэша + ?(ЗначениеЗаполнено(ТекущаяСтрока.Характеристика),
							Строка(ТекущаяСтрока.Характеристика.УникальныйИдентификатор()),
							ПустоеЗначение);
	КлючКэша = КлючКэша + ?(ЗначениеЗаполнено(МестоХранения),
							Строка(МестоХранения.УникальныйИдентификатор()),
							ПустоеЗначение);
	КлючКэша = КлючКэша + ?(ЗначениеЗаполнено(ТекущаяСтрока.НомерГТД),
							Строка(ТекущаяСтрока.НомерГТД.УникальныйИдентификатор()),
							ПустоеЗначение);
	КлючКэша = КлючКэша + ?(ЗначениеЗаполнено(ПараметрыПересчета.Дата),
							Строка(ПараметрыПересчета.Дата),
							ПустоеЗначение);
	
	Возврат КлючКэша;
	
КонецФункции

#КонецОбласти
