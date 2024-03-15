#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура загружает XML файл в информационную базу.
//
// Параметры:
//    Объект - ЛюбаяСсылка - Не используется
//    XMLФайл - ЛюбаяСсылка - Не используется
//    ПроводитьДокументыПриЗагрузке - Булево - Признак необходимости проведения документов при загрузке в ИБ
//    Адрес - Строка - Адрес во временном хранилище.
//
Процедура ЗагрузитьXMLФайлВИнформационнуюБазуСервер(Объект, XMLФайл, ПроводитьДокументыПриЗагрузке, Адрес) Экспорт
	
	ДеревоЗначенийXMLФайл = Новый ДеревоЗначений;
	ДеревоЗначенийXMLФайл.Колонки.Добавить("ИмяЭлемента");
	ДеревоЗначенийXMLФайл.Колонки.Добавить("ЗначениеЭлемента");
	
	Если ПрочитатьXMLФайлВДеревоЗначений(Объект, XMLФайл, ДеревоЗначенийXMLФайл, Адрес) Тогда
		Если ДеревоЗначенийXMLФайл.Строки.Количество() > 0 Тогда
			Если ДеревоЗначенийXMLФайл.Строки.Найти("СтрокаПоМерчанту", "ИмяЭлемента", Истина) = Неопределено Тогда
				
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru='В файле с данными не найден элемент с наименованием ""СтрокаПоМерчанту"".
					|Формат выбранного файла не соответствует поддерживаемому формату.'"), , "XMLФайл");
			Иначе
				ЗагрузитьXMLФайлИзДереваЗначенийВИнформационнуюБазу(ДеревоЗначенийXMLФайл.Строки, ПроводитьДокументыПриЗагрузке);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура СоздатьДокументОтчетБанкаПоОперациямЭквайринга(Элементы, НомерОтчета, ПроводитьДокументыПриЗагрузке, АтрибутыЭлементаДанныеПоЗапросу)
	
	НомерСтрокиПоТерминалу = 0;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ЭквайринговыеТерминалы.Владелец.Ссылка КАК ДоговорЭквайринга,
	|	ЭквайринговыеТерминалы.Ссылка КАК ЭквайринговыйТерминал,
	|	ЭквайринговыеТерминалы.Владелец.Организация КАК Организация,
	|	ЭквайринговыеТерминалы.Владелец.Организация.ИНН КАК ИННОрганизации,
	|	ЭквайринговыеТерминалы.Владелец.БанковскийСчет.ВалютаДенежныхСредств КАК Валюта,
	|	ЕСТЬNULL(ЭквайринговыеТерминалы.Владелец.БанковскийСчет.Банк.Код, ЭквайринговыеТерминалы.Владелец.БанковскийСчет.БИКБанка) КАК БИКБанка,
	|	ЭквайринговыеТерминалы.Владелец.БанковскийСчет.НомерСчета КАК НомерСчетаБанка,
	|	ЭквайринговыеТерминалы.Владелец.СтатьяРасходов КАК СтатьяРасходов,
	|	ЭквайринговыеТерминалы.Владелец.АналитикаРасходов КАК АналитикаРасходов,
	|	ЭквайринговыеТерминалы.Владелец.ПодразделениеРасходов КАК Подразделение,
	|	ЭквайринговыеТерминалы.Владелец.СпособОтраженияКомиссии = ЗНАЧЕНИЕ(Перечисление.СпособыОтраженияЭквайринговойКомиссии.ВОтчете) КАК ОтражатьКОмиссию,
	|	ЭквайринговыеТерминалы.Владелец.ДетальнаяСверкаТранзакций КАК ДетальнаяСверкаТранзакций
	|ИЗ
	|	Справочник.ЭквайринговыеТерминалы КАК ЭквайринговыеТерминалы
	|ГДЕ
	|	ЭквайринговыеТерминалы.Код = &Код
	|");
	
	Если ПроводитьДокументыПриЗагрузке Тогда
		РежимЗаписиДок = РежимЗаписиДокумента.Проведение;
	Иначе
		РежимЗаписиДок = РежимЗаписиДокумента.Запись;
	КонецЕсли;
	
	ДокументОбъект = Документы.ОтчетБанкаПоОперациямЭквайринга.СоздатьДокумент();
	
	СуммаКомиссии = 0;
	
	Для Каждого Элемент Из Элементы Цикл
		
		Если Элемент.ИмяЭлемента = "Дата" Тогда
			
			Попытка
				
				Если КонецДня(СтрЗаменить(Элемент.ЗначениеЭлемента, "-", "")) = КонецДня(ТекущаяДатаСеанса()) Тогда
					
					ДокументОбъект.Дата =
						СтрЗаменить(Элемент.ЗначениеЭлемента, "-", "") +
						Формат(Час(ТекущаяДатаСеанса()), "ЧЦ=2; ЧВН=") +
						Формат(Минута(ТекущаяДатаСеанса()), "ЧЦ=2; ЧВН=") +
						Формат(Секунда(ТекущаяДатаСеанса()), "ЧЦ=2; ЧВН=");
				Иначе
					ДокументОбъект.Дата = СтрЗаменить(Элемент.ЗначениеЭлемента, "-", "") + "120000";
				КонецЕсли;
				
			Исключение
				ДокументОбъект.Дата = Неопределено;
			КонецПопытки;
			
		ИначеЕсли Элемент.ИмяЭлемента = "НомерМерчанта" Тогда
			
			Если ЗначениеЗаполнено(Элемент.ЗначениеЭлемента) И СтрДлина(Элемент.ЗначениеЭлемента) <= 11 Тогда
				
				Попытка
					ДокументОбъект.Номер = Элемент.ЗначениеЭлемента;
				Исключение
					ДокументОбъект.Номер = "";
				КонецПопытки;
			КонецЕсли;
		
		ИначеЕсли Элемент.ИмяЭлемента = "СтрокаПоТерминалу" Тогда
			
			НомерСтрокиПоТерминалу = НомерСтрокиПоТерминалу + 1;
			СтрокаПоТерминалу = Новый Структура;
			
			Для каждого СтрокаТабличнойЧасти Из Элемент.Строки Цикл
				СтрокаПоТерминалу.Вставить(СтрокаТабличнойЧасти.ИмяЭлемента, СтрокаТабличнойЧасти.ЗначениеЭлемента);
			КонецЦикла;
			
			Если СтрокаПоТерминалу.Свойство("СуммаОперации") И Число(СтрокаПоТерминалу.СуммаОперации) < 0 Тогда
				СтрокаПоТерминалу.Вставить("ТипОперации", "возврат");
			КонецЕсли;
			
			Знч = Неопределено;
			
			Если СтрокаПоТерминалу.Свойство("ТипОперации", Знч) Тогда
				
				Если Не ЗначениеЗаполнено(Знч) Тогда
					
					ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не указан тип операции. Элемент ""СтрокаПоТерминалу"" №%2 не загружен.'"), НомерОтчета, НомерСтрокиПоТерминалу));
					Продолжить;
					
				ИначеЕсли ВРег(СокрЛП(Знч)) = ВРег("оплата") Тогда
					СтрТаблЧасть = ДокументОбъект.Покупки.Добавить();
				ИначеЕсли ВРег(СокрЛП(Знч)) = ВРег("возврат") Или ВРег(СокрЛП(Знч)) = ВРег("отмена") Тогда
					СтрТаблЧасть = ДокументОбъект.Возвраты.Добавить();
				Иначе
					Продолжить;
				КонецЕсли;
			Иначе
				
				ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не найден элемент ""ТипОперации"". Элемент ""СтрокаПоТерминалу"" №%2 не загружен.'"), НомерОтчета, НомерСтрокиПоТерминалу));
				Продолжить;
			КонецЕсли;
			
			Если СтрокаПоТерминалу.Свойство("НомерТерминала", Знч) Тогда
				
				Если Не ЗначениеЗаполнено(Знч) Тогда
					
					ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не указан номер терминала.'"), НомерОтчета, НомерСтрокиПоТерминалу));
					РежимЗаписиДок = РежимЗаписиДокумента.Запись;
				Иначе
					
					Запрос.УстановитьПараметр("Код", СокрЛП(СтрокаПоТерминалу.НомерТерминала));
					
					Выборка = Запрос.Выполнить().Выбрать();
					Если Выборка.Следующий() Тогда
						
						СтрТаблЧасть.ЭквайринговыйТерминал = Выборка.ЭквайринговыйТерминал;
						
						Если Не ЗначениеЗаполнено(ДокументОбъект.ДоговорЭквайринга) Тогда
							
							ДокументОбъект.ДоговорЭквайринга = Выборка.ДоговорЭквайринга;
							ДокументОбъект.Организация       = Выборка.Организация;
							ДокументОбъект.Валюта            = Выборка.Валюта;
							
							Если АтрибутыЭлементаДанныеПоЗапросу.ИНН <> Выборка.ИННОрганизации Тогда
								ОбщегоНазначения.СообщитьПользователю(
									НСтр("ru='В отчете банка по операциям эквайринга идентификационный номер налогоплательщика (ИНН) не соответствует идентификационному номеру налогоплательщика договора эквайринга в информационной базе.'"));
								РежимЗаписиДок = РежимЗаписиДокумента.Запись;
							КонецЕсли;
								
							Если АтрибутыЭлементаДанныеПоЗапросу.БИК <> Выборка.БИКБанка Тогда
								ОбщегоНазначения.СообщитьПользователю(
									НСтр("ru='В отчете банка по операциям эквайринга банковский идентификационный код (БИК) не соответствует банковскому идентификационному коду договора эквайринга в информационной базе.'"));
								РежимЗаписиДок = РежимЗаписиДокумента.Запись;
							КонецЕсли;
								
							Если АтрибутыЭлементаДанныеПоЗапросу.РасчетныйСчетОрганизации <> Выборка.НомерСчетаБанка Тогда
								ОбщегоНазначения.СообщитьПользователю(
									НСтр("ru='В отчете банка по операциям эквайринга не указан расчетный счет организации или не соответствует расчетному счету организации договора эквайринга в информационной базе.'"));
								РежимЗаписиДок = РежимЗаписиДокумента.Запись;
							КонецЕсли;
						КонецЕсли;
					Иначе
						
						ОбщегоНазначения.СообщитьПользователю(
							СтрШаблон(НСтр("ru='В информационной базе не найден эквайринговый терминал с кодом %1.'"), СокрЛП(СтрокаПоТерминалу.НомерТерминала)));
						РежимЗаписиДок = РежимЗаписиДокумента.Запись;
					КонецЕсли;
				КонецЕсли;
			Иначе
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не найден элемент ""НомерТерминала"".'"), НомерОтчета, НомерСтрокиПоТерминалу));
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
			КонецЕсли;
			
			Если СтрокаПоТерминалу.Свойство("ВремяОперации", Знч) Тогда
				Если Не ЗначениеЗаполнено(Знч) Тогда
					ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не указано время операции.'"), НомерОтчета, НомерСтрокиПоТерминалу));
					РежимЗаписиДок = РежимЗаписиДокумента.Запись;
				Иначе
					СтрТаблЧасть.ДатаПлатежа = СтрЗаменить(Лев(СтрокаПоТерминалу.ВремяОперации, 10), "-", "");
				КонецЕсли;
			Иначе
				ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не найден элемент ""ВремяОперации"".'"), НомерОтчета, НомерСтрокиПоТерминалу));
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
			КонецЕсли;
			
			Если СтрокаПоТерминалу.Свойство("СуммаОперации", Знч) Тогда
				Если Не ЗначениеЗаполнено(Знч) Тогда
					ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не указана сумма операции.'"), НомерОтчета, НомерСтрокиПоТерминалу));
					РежимЗаписиДок = РежимЗаписиДокумента.Запись;
				Иначе
					Если Число(СтрокаПоТерминалу.СуммаОперации) < 0 Тогда
						СтрТаблЧасть.Сумма = Строка((-1) * Число(СтрокаПоТерминалу.СуммаОперации));
					Иначе
						СтрТаблЧасть.Сумма = СтрокаПоТерминалу.СуммаОперации;
					КонецЕсли;
				КонецЕсли;
			Иначе
				ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1, элемент ""СтрокаПоТерминалу"" №%2) не найден элемент ""СуммаОперации"".'"), НомерОтчета, НомерСтрокиПоТерминалу));
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
			КонецЕсли;
			
			СтрокаПоТерминалу.Свойство("НомерКарты", СтрТаблЧасть.НомерПлатежнойКарты);
			СтрокаПоТерминалу.Свойство("КодАвторизации", СтрТаблЧасть.КодАвторизации);
			
			Если СтрокаПоТерминалу.Свойство("Комиссия", Знч) Тогда
				Если ЗначениеЗаполнено(Знч) Тогда
					Если ВРег(СокрЛП(СтрокаПоТерминалу.ТипОперации)) = ВРег("оплата") Тогда
						СуммаКомиссии = СуммаКомиссии + СтрокаПоТерминалу.Комиссия;
					ИначеЕсли ВРег(СокрЛП(СтрокаПоТерминалу.ТипОперации)) = ВРег("возврат")
						Или ВРег(СокрЛП(СтрокаПоТерминалу.ТипОперации)) = ВРег("отмена") Тогда
						СуммаКомиссии = СуммаКомиссии - СтрокаПоТерминалу.Комиссия;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли Элемент.ИмяЭлемента = "КонтрольнаяСуммаПоДате" Тогда
			
			КоличествоЗаписейОплата  = 0;
			КоличествоЗаписейВозврат = 0;
			СуммаИтогоОплата         = 0;
			СуммаИтогоВозврат        = 0;
			
			Для Каждого ЭлементКонтрольнойСуммыПоДате Из Элемент.Строки Цикл
				
				Если ЭлементКонтрольнойСуммыПоДате.ИмяЭлемента = "Дата" Тогда
					Если КонецДня(СтрЗаменить(ЭлементКонтрольнойСуммыПоДате.ЗначениеЭлемента, "-", "")) <> КонецДня(ДокументОбъект.Дата) Тогда
						ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1) дата в элементе ""КонтрольнаяСуммаПоДате"" не соответствует дате операции.'"), НомерОтчета));
						РежимЗаписиДок = РежимЗаписиДокумента.Запись;
						Прервать;
					КонецЕсли;
				
				ИначеЕсли ЭлементКонтрольнойСуммыПоДате.ИмяЭлемента = "Операция" Тогда
					
					Если ВРег(СокрЛП(ЭлементКонтрольнойСуммыПоДате.Строки[0].ЗначениеЭлемента)) = ВРег("оплата") Тогда
						
						КоличествоЗаписейОплата = КоличествоЗаписейОплата + ЭлементКонтрольнойСуммыПоДате.Строки[1].ЗначениеЭлемента;
						СуммаИтогоОплата        = СуммаИтогоОплата + ЭлементКонтрольнойСуммыПоДате.Строки[2].ЗначениеЭлемента;
						
					ИначеЕсли ВРег(СокрЛП(ЭлементКонтрольнойСуммыПоДате.Строки[0].ЗначениеЭлемента)) = ВРег("возврат")
						Или ВРег(СокрЛП(ЭлементКонтрольнойСуммыПоДате.Строки[0].ЗначениеЭлемента)) = ВРег("отмена") Тогда
						
						КоличествоЗаписейВозврат = КоличествоЗаписейВозврат + ЭлементКонтрольнойСуммыПоДате.Строки[1].ЗначениеЭлемента;
						СуммаИтогоВозврат        = СуммаИтогоВозврат + ЭлементКонтрольнойСуммыПоДате.Строки[2].ЗначениеЭлемента;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Если КоличествоЗаписейОплата <> ДокументОбъект.Покупки.Количество() Тогда
				ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1) количество записей по оплате в элементе ""КонтрольнаяСуммаПоДате"" не соответствует количеству операций по оплате.'"), НомерОтчета));
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
			КонецЕсли;
			
			Если СуммаИтогоОплата <> ДокументОбъект.Покупки.Итог("Сумма") Тогда
				ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1) итоговая сумма по оплате в элементе ""КонтрольнаяСуммаПоДате"" не соответствует итоговой сумме операций по оплате.'"), НомерОтчета));
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
			КонецЕсли;
			
			Если КоличествоЗаписейВозврат <> ДокументОбъект.Возвраты.Количество() Тогда
				ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1) количество записей по возврату и по отмене в элементе ""КонтрольнаяСуммаПоДате"" не соответствует количеству операций по возврату.'"), НомерОтчета));
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
			КонецЕсли;
			
			Если СуммаИтогоВозврат <> ДокументОбъект.Возвраты.Итог("Сумма") Тогда
				ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='В отчете банка по операциям эквайринга (элемент ""Отчет"" №%1) итоговая сумма по возврату и по отмене в элементе ""КонтрольнаяСуммаПоДате"" не соответствует итоговой сумме операций по возврату.'"), НомерОтчета));
				РежимЗаписиДок = РежимЗаписиДокумента.Запись;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		
		Если Не ЗначениеЗаполнено(ДокументОбъект.Дата) Тогда
			
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='При загрузке элемента ""Отчет"" №%1 в документе ""Отчет банка по операциям эквайринга"" не заполнена дата операции по платежной карте. Документ не создан.'"), НомерОтчета));
			Возврат;
			
		ИначеЕсли ДокументОбъект.Покупки.Количество() + ДокументОбъект.Возвраты.Количество() = 0 Тогда
			
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='При загрузке элемента ""Отчет"" №%1 в документе ""Отчет банка по операциям эквайринга"" не заполнены платежи. Документ не создан.'"), НомерОтчета));
			Возврат;
		КонецЕсли;
		
		Если Выборка.ОтражатьКомиссию И СуммаКомиссии <> 0 Тогда
			ДокументОбъект.СуммаКомиссии     = СуммаКомиссии;
			ДокументОбъект.СтатьяРасходов    = Выборка.СтатьяРасходов;
			ДокументОбъект.АналитикаРасходов = Выборка.АналитикаРасходов;
			ДокументОбъект.Подразделение     = Выборка.Подразделение;
		КонецЕсли;
		
		ДокументОбъект.ОтражатьКомиссию = Выборка.ОтражатьКомиссию;
		ДокументОбъект.ДетальнаяСверкаТранзакций = Выборка.ДетальнаяСверкаТранзакций;
		ДокументОбъект.Ответственный = Пользователи.ТекущийПользователь();
		
		Если РежимЗаписиДок = РежимЗаписиДокумента.Проведение И Не ДокументОбъект.ПроверитьЗаполнение() Тогда
			РежимЗаписиДок = РежимЗаписиДокумента.Запись;
		КонецЕсли;
		
		ДокументОбъект.Записать(РежимЗаписиДок);
		
		ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='%1 документ ""Отчет банка по операциям эквайринга"" №%2 от %3.'"),
			?(РежимЗаписиДок = РежимЗаписиДокумента.Запись, "Записан", "Проведен"),
			ДокументОбъект.Номер,
			ДокументОбъект.Дата));
			
	Исключение
		
		ОбщегоНазначения.СообщитьПользователю(СтрШаблон(
			НСтр("ru='Документ ""Отчет банка по операциям эквайринга"" №%1 от %2 не %3. Произошли ошибки при %4.'"),
			ДокументОбъект.Номер,
			ДокументОбъект.Дата,
			?(РежимЗаписиДок = РежимЗаписиДокумента.Запись, "записан", "проведен"),
			?(РежимЗаписиДок = РежимЗаписиДокумента.Запись, "записи", "проведении")));
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗагрузитьXMLФайлИзДереваЗначенийВИнформационнуюБазу(Элементы, ПроводитьДокументыПриЗагрузке, АтрибутыЭлементаДанныеПоЗапросу = Неопределено)
	
	НомерОтчета = 0;
	
	Если АтрибутыЭлементаДанныеПоЗапросу = Неопределено Тогда
		АтрибутыЭлементаДанныеПоЗапросу = Новый Структура;
	КонецЕсли;
	
	Для каждого Элемент Из Элементы Цикл
		
		Если Элемент.ИмяЭлемента = "РезультатЗапроса" Тогда
			
			Если Элемент.ЗначениеЭлемента = "ошибкаЗапроса" Тогда
				
				ОбщегоНазначения.СообщитьПользователю(
					НСтр("ru='Ошибка в запросе на предоставление отчета по операциям эквайринга. Отчет не загружен.'"));
				
			ИначеЕсли Элемент.ЗначениеЭлемента = "данныеОтсутствуют" Тогда
				
				ОбщегоНазначения.СообщитьПользователю(
					НСтр("ru='В отчете по операциям эквайринга отсутствуют данные. Отчет не загружен.'"));
			Иначе
				
				ОбщегоНазначения.СообщитьПользователю(
					НСтр("ru='В отчете по операциям эквайринга некорректное значение элемента ""РезультатЗапроса"". Отчет не загружен.'"));
			КонецЕсли;
			
			Возврат;
			
		ИначеЕсли Элемент.ИмяЭлемента = "СтрокаПоМерчанту" Тогда
			
			НомерОтчета = НомерОтчета + 1;
			
			Если Элемент.Строки.Найти("Дата", "ИмяЭлемента") = Неопределено Тогда
				
				ДатаПлатежногоПоручения = "";
				
				Если АтрибутыЭлементаДанныеПоЗапросу.Свойство("ДатаПлатежногоПоручения", ДатаПлатежногоПоручения) Тогда
					
					Если ЗначениеЗаполнено(ДатаПлатежногоПоручения) Тогда
						
						СтрДереваЗначений = Элемент.Строки.Добавить();
						СтрДереваЗначений.ИмяЭлемента = "Дата";
						СтрДереваЗначений.ЗначениеЭлемента = ДатаПлатежногоПоручения;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			МассивСтрокПоТерминалу = Элемент.Строки.НайтиСтроки(Новый Структура("ИмяЭлемента", "СтрокаПоТерминалу"));
			
			Для каждого СтрокаПоТерминалу Из МассивСтрокПоТерминалу Цикл
				
				Если СтрокаПоТерминалу.Строки.Найти("ТипОперации", "ИмяЭлемента") = Неопределено Тогда
					
					Если АтрибутыЭлементаДанныеПоЗапросу.Свойство("ДатаПлатежногоПоручения") Тогда
						
						СтрДереваЗначений = СтрокаПоТерминалу.Строки.Добавить();
						СтрДереваЗначений["ИмяЭлемента"] = "ТипОперации";
						СтрДереваЗначений.ЗначениеЭлемента = "оплата";
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			СоздатьДокументОтчетБанкаПоОперациямЭквайринга(Элемент.Строки, НомерОтчета, ПроводитьДокументыПриЗагрузке, АтрибутыЭлементаДанныеПоЗапросу);
			
		ИначеЕсли Элемент.ИмяЭлемента = "НаименованиеОрганизации"
			Или Элемент.ИмяЭлемента = "ИНН"
			Или Элемент.ИмяЭлемента = "БИК"
			Или Элемент.ИмяЭлемента = "РасчетныйСчетОрганизации"
			Или Элемент.ИмяЭлемента = "ДатаПлатежногоПоручения" Тогда
			
			АтрибутыЭлементаДанныеПоЗапросу.Вставить(Элемент.ИмяЭлемента, Элемент.ЗначениеЭлемента);
			
		ИначеЕсли Элемент.Строки.Количество() > 0 Тогда
			
			Если Элемент.ИмяЭлемента = "ПлатежноеПоручение" Тогда
				ЗагрузитьXMLФайлИзДереваЗначенийВИнформационнуюБазу(Элемент.Строки, ПроводитьДокументыПриЗагрузке, АтрибутыЭлементаДанныеПоЗапросу);
			Иначе
				ЗагрузитьXMLФайлИзДереваЗначенийВИнформационнуюБазу(Элемент.Строки, ПроводитьДокументыПриЗагрузке);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПрочитатьXMLФайлВДеревоЗначений(Объект, XMLФайл, ДеревоЗначенийXMLФайл, Адрес)
	
	ДеревоЗначенийXMLФайл.Строки.Очистить();
	
	ВремФайл = ПолучитьИмяВременногоФайла();
	
	Данные = ПолучитьИзВременногоХранилища(Адрес); // ДвоичныеДанные
	Данные.Записать(ВремФайл);
	
	ФайлXML = Новый ЧтениеXML;
	ФайлXML.ОткрытьФайл(ВремФайл);
	
	Родитель = Неопределено;
	
	Попытка
		
		Пока ФайлXML.Прочитать() Цикл
			
			Если ФайлXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				
				Если Родитель = Неопределено Тогда
					ЭлементДереваЗначенийXMLФайл = ДеревоЗначенийXMLФайл.Строки.Добавить();
				Иначе
					СтрокиРодителя = Родитель.Строки; // КоллекцияСтрокДереваЗначений
					ЭлементДереваЗначенийXMLФайл = СтрокиРодителя.Добавить();
				КонецЕсли;
				
				ЭлементДереваЗначенийXMLФайл.ИмяЭлемента = ФайлXML.Имя;
				Родитель = ЭлементДереваЗначенийXMLФайл;
				
			ИначеЕсли ФайлXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
				
				Если НЕ Родитель = Неопределено Тогда
					Родитель = Родитель.Родитель;
				КонецЕсли;
				
			ИначеЕсли ФайлXML.ТипУзла = ТипУзлаXML.Текст Тогда
				
				ЭлементДереваЗначенийXMLФайл.ЗначениеЭлемента = ФайлXML.Значение;
			КонецЕсли;
			
			Если ФайлXML.КоличествоАтрибутов() > 0 Тогда
				
				Пока ФайлXML.ПрочитатьАтрибут() Цикл
					
					ЭлементДереваЗначенийXMLФайлАтрибут = ЭлементДереваЗначенийXMLФайл.Строки.Добавить();
					ЭлементДереваЗначенийXMLФайлАтрибут["ИмяЭлемента"]   = ФайлXML.Имя;
					ЭлементДереваЗначенийXMLФайлАтрибут.ЗначениеЭлемента = ФайлXML.Значение;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
	Исключение
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Выбран файл с данными не в формате XML.'"),, "XMLФайл");
		Возврат Ложь;
	КонецПопытки;
	
	Попытка
		УдалитьФайлы(ВремФайл);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Загрузка отчета банка по эквайрингу.Удаление временного файла'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли