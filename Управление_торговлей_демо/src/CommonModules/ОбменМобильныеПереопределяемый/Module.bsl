#Область ПрограммныйИнтерфейс

// Функция выполняет проверку того, что данные нужно переностить в данный узел
//
// Параметры:
//  Данные - Объект, набор записей,... который нужно проверить.
//            То, что переносится везде, не обрабатывается
//  УзелОбмена - узел плана обмена, куда осуществляется перенос
//
// Возвращаемое значение:
//  Перенос - булево, если Истина - необходимо выполнять перенос, 
//			  иначе - перенос выполнять не нужно
//
Функция НуженПереносДанных(Данные, УзелОбмена) Экспорт
	
	Перенос = Истина;
	
	Возврат Перенос;
	
КонецФункции

// Процедура записывает данные в формат XML
// Процедура анализирует переданный объект данных и на основе этого анализа
// записывает его определенным образом в формат XML
//
// Параметры:
//  ЗаписьXML	- объект, записывающий XML данные
//  Данные 		- данные, подлежащие записи в формат XML
//
Процедура ЗаписатьДанные(ЗаписьXML, Данные) Экспорт
	
	// В данном случае, нет данных, которые требуют нестандартной обработки
	// Записываем данные с помощью стандартного метода
	
	Если ТипЗнч(Данные) = Тип("СправочникОбъект.УпаковкиЕдиницыИзмерения") Тогда
		УпаковкиЕдиницыИзмеренияВXML(ЗаписьXML, Данные);
	ИначеЕсли ТипЗнч(Данные) = Тип("СправочникОбъект.НаборыУпаковок") Тогда
		НаборыУпаковокВXML(ЗаписьXML, Данные);
	ИначеЕсли ТипЗнч(Данные) = Тип("СправочникОбъект.Номенклатура") Тогда
		НоменклатураВXML(ЗаписьXML, Данные);
	ИначеЕсли ТипЗнч(Данные) = Тип("СправочникОбъект.Пользователи") Тогда
		ПользователиВXML(ЗаписьXML, Данные);
	ИначеЕсли ТипЗнч(Данные) = Тип("СправочникОбъект.Склады") Тогда
		СкладыВXML(ЗаписьXML, Данные);
	ИначеЕсли ТипЗнч(Данные) = Тип("СправочникОбъект.СкладскиеПомещения") Тогда
		СкладскиеПомещенияВXML(ЗаписьXML, Данные);
	ИначеЕсли ТипЗнч(Данные) = Тип("СправочникОбъект.СкладскиеЯчейки") Тогда
		СкладскиеЯчейкиВXML(ЗаписьXML, Данные);
	ИначеЕсли ТипЗнч(Данные) = Тип("СправочникОбъект.ХарактеристикиНоменклатуры") Тогда
		ХарактеристикиНоменклатурыВXML(ЗаписьXML, Данные);
	ИначеЕсли ТипЗнч(Данные) = Тип("СправочникОбъект.ВидыНоменклатуры") Тогда
		ВидыНоменклатурыВXML(ЗаписьXML, Данные);
	ИначеЕсли ТипЗнч(Данные) = Тип("РегистрСведенийНаборЗаписей.ШтрихкодыНоменклатуры") Тогда
		ШтрихкодыНоменклатурыВXML(ЗаписьXML, Данные);
	КонецЕсли;
	
	#Если МобильныйАвтономныйСервер Тогда
		Константы.ОтправленоЗаписей.Установить(Константы.ОтправленоЗаписей.Получить() + 1);
	#КонецЕсли
	
КонецПроцедуры

// Функция читает данные из формат XML
// Процедура анализирует переданный объект ЧтениеXML и на основе этого анализа
// читает из него данные определенным образом
//
// Параметры:
//  ЧтениеXML	- объект, читающий XML данные
//
// Возвращаемое значение:
//  Данные - значение, прочитанное из объекта ЧтениеXML
//
Функция ПрочитатьДанные(ЧтениеXML) Экспорт
	
	Если ЧтениеXML.Имя = "CatalogObject.УпаковкиЕдиницыИзмерения" Тогда
		Данные = УпаковкиЕдиницыИзмеренияИзXML(ЧтениеXML);
	ИначеЕсли ЧтениеXML.Имя = "CatalogObject.НаборыУпаковок" Тогда
		Данные = НаборыУпаковокИзXML(ЧтениеXML);
	ИначеЕсли ЧтениеXML.Имя = "CatalogObject.Номенклатура" Тогда
		Данные = НоменклатураИзXML(ЧтениеXML);
	ИначеЕсли ЧтениеXML.Имя = "CatalogObject.Пользователи" Тогда
		Данные = ПользователиИзXML(ЧтениеXML);
	ИначеЕсли ЧтениеXML.Имя = "CatalogObject.Склады" Тогда
		Данные = СкладыИзXML(ЧтениеXML);
	ИначеЕсли ЧтениеXML.Имя = "CatalogObject.СкладскиеПомещения" Тогда
		Данные = СкладскиеПомещенияИзXML(ЧтениеXML);
	ИначеЕсли ЧтениеXML.Имя = "CatalogObject.СкладскиеЯчейки" Тогда
		Данные = СкладскиеЯчейкиИзXML(ЧтениеXML);
	ИначеЕсли ЧтениеXML.Имя = "CatalogObject.ХарактеристикиНоменклатуры" Тогда
		Данные = ХарактеристикиНоменклатурыИзXML(ЧтениеXML);
	ИначеЕсли ЧтениеXML.Имя = "CatalogObject.ВидыНоменклатуры" Тогда
		Данные = ВидыНоменклатурыИзXML(ЧтениеXML);
	ИначеЕсли ЧтениеXML.Имя = "CatalogObject.ВидыНоменклатуры" Тогда
		Данные = ВидыНоменклатурыИзXML(ЧтениеXML);
	ИначеЕсли ЧтениеXML.Имя = "InformationRegisters.ШтрихкодыНоменклатуры" Тогда
		Данные = ШтрихкодыНоменклатурыИзXML(ЧтениеXML);
	КонецЕсли;
	
#Если НЕ МобильныйАвтономныйСервер Тогда
#Иначе
	Константы.ПринятоЗаписей.Установить(Константы.ПринятоЗаписей.Получить() + 1);
#КонецЕсли
	
	Возврат Данные;
	
КонецФункции

// Процедура регистрирует изменения, для всех данных, входящих в состав плана обмена
// Параметры:
//  УзелОбмена - узел плана обмена, для которого регистрируются изменения
Процедура ЗарегистрироватьИзмененияДанных(УзелОбмена) Экспорт
	
	СоставПланаОбмена = УзелОбмена.Метаданные().Состав;
	Для Каждого ЭлементСоставаПланаОбмена Из СоставПланаОбмена Цикл
		
		ПланыОбмена.ЗарегистрироватьИзменения(УзелОбмена,ЭлементСоставаПланаОбмена.Метаданные);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ВыгрузкаДанных

Процедура НоменклатураВXML(ЗаписьXML, Данные)
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("CatalogObject.Номенклатура");
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Ссылка");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Ссылка.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Родитель");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Родитель.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Наименование");
	ЗаписьXML.ЗаписатьТекст(Данные.Наименование);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("ЭтоГруппа");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.ЭтоГруппа));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	Если НЕ Данные.ЭтоГруппа Тогда
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("Артикул");
		ЗаписьXML.ЗаписатьТекст(Данные.Артикул);
		ЗаписьXML.ЗаписатьКонецЭлемента();
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("ЕдиницаИзмерения");
		ЗаписьXML.ЗаписатьТекст(Строка(Данные.ЕдиницаИзмерения.УникальныйИдентификатор()));
		ЗаписьXML.ЗаписатьКонецЭлемента();
		
	КонецЕсли;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

Процедура УпаковкиЕдиницыИзмеренияВXML(ЗаписьXML, Данные)
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("CatalogObject.УпаковкиЕдиницыИзмерения");
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Ссылка");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Ссылка.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Владелец");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Владелец.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Родитель");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Родитель.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Наименование");
	ЗаписьXML.ЗаписатьТекст(Данные.Наименование);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("НаименованиеПолное");
	ЗаписьXML.ЗаписатьТекст(Данные.НаименованиеПолное);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("ЕдиницаИзмерения");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.ЕдиницаИзмерения.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("КоличествоУпаковок");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.КоличествоУпаковок));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

Процедура НаборыУпаковокВXML(ЗаписьXML, Данные)
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("CatalogObject.НаборыУпаковок");
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Ссылка");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Ссылка.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Наименование");
	ЗаписьXML.ЗаписатьТекст(Данные.Наименование);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("ЕдиницаИзмерения");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.ЕдиницаИзмерения.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("ЕдиницаДляОтчетов");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.ЕдиницаДляОтчетов.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("КоэффициентЕдиницыДляОтчетов");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.КоэффициентЕдиницыДляОтчетов));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

Процедура ПользователиВXML(ЗаписьXML, Данные)
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("CatalogObject.Пользователи");
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Ссылка");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Ссылка.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Наименование");
	ЗаписьXML.ЗаписатьТекст(Данные.Наименование);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("ИдентификаторПользователяИБ");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.ИдентификаторПользователяИБ));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

Процедура СкладыВXML(ЗаписьXML, Данные)
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("CatalogObject.Склады");
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Ссылка");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Ссылка.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Наименование");
	ЗаписьXML.ЗаписатьТекст(Данные.Наименование);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Родитель");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Родитель.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("ЭтоГруппа");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.ЭтоГруппа));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	Если НЕ Данные.ЭтоГруппа Тогда
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("ИспользоватьАдресноеХранение");
		ЗаписьXML.ЗаписатьТекст(Строка(Данные.ИспользоватьАдресноеХранение));
		ЗаписьXML.ЗаписатьКонецЭлемента();
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("ИспользоватьАдресноеХранениеСправочно");
		ЗаписьXML.ЗаписатьТекст(Строка(Данные.ИспользоватьАдресноеХранениеСправочно));
		ЗаписьXML.ЗаписатьКонецЭлемента();
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("ИспользоватьОрдернуюСхемуПриОтгрузке");
		ЗаписьXML.ЗаписатьТекст(Строка(Данные.ИспользоватьОрдернуюСхемуПриОтгрузке));
		ЗаписьXML.ЗаписатьКонецЭлемента();
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач");
		ЗаписьXML.ЗаписатьТекст(Строка(Данные.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач));
		ЗаписьXML.ЗаписатьКонецЭлемента();
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("ИспользоватьОрдернуюСхемуПриПоступлении");
		ЗаписьXML.ЗаписатьТекст(Строка(Данные.ИспользоватьОрдернуюСхемуПриПоступлении));
		ЗаписьXML.ЗаписатьКонецЭлемента();
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("ИспользоватьСерииНоменклатуры");
		ЗаписьXML.ЗаписатьТекст(Строка(Данные.ИспользоватьСерииНоменклатуры));
		ЗаписьXML.ЗаписатьКонецЭлемента();
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("ИспользоватьСкладскиеПомещения");
		ЗаписьXML.ЗаписатьТекст(Строка(Данные.ИспользоватьСкладскиеПомещения));
		ЗаписьXML.ЗаписатьКонецЭлемента();
		
	КонецЕсли;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

Процедура СкладскиеПомещенияВXML(ЗаписьXML, Данные)
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("CatalogObject.СкладскиеПомещения");
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Ссылка");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Ссылка.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Наименование");
	ЗаписьXML.ЗаписатьТекст(Данные.Наименование);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Владелец");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Владелец.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("ИспользоватьАдресноеХранение");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.ИспользоватьАдресноеХранение));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("ИспользоватьАдресноеХранениеСправочно");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.ИспользоватьАдресноеХранениеСправочно));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

Процедура СкладскиеЯчейкиВXML(ЗаписьXML, Данные)
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("CatalogObject.СкладскиеЯчейки");
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Ссылка");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Ссылка.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Наименование");
	ЗаписьXML.ЗаписатьТекст(Данные.Наименование);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Родитель");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Родитель.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("ЭтоГруппа");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.ЭтоГруппа));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Владелец");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Владелец.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	Если НЕ Данные.ЭтоГруппа Тогда
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("ТипСкладскойЯчейки");
		ЗаписьXML.ЗаписатьТекст(Строка(Данные.ТипСкладскойЯчейки));
		ЗаписьXML.ЗаписатьКонецЭлемента();
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("Помещение");
		ЗаписьXML.ЗаписатьТекст(Строка(Данные.Помещение.УникальныйИдентификатор()));
		ЗаписьXML.ЗаписатьКонецЭлемента();
		
	КонецЕсли;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

Процедура ХарактеристикиНоменклатурыВXML(ЗаписьXML, Данные)
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("CatalogObject.ХарактеристикиНоменклатуры");
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Ссылка");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Ссылка.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Наименование");
	ЗаписьXML.ЗаписатьТекст(Данные.Наименование);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("НаименованиеПолное");
	ЗаписьXML.ЗаписатьТекст(Данные.НаименованиеПолное);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("ВладелецТип");
	ЗаписьXML.ЗаписатьТекст(Строка(ТипЗнч(Данные.Владелец)));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Владелец");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Владелец.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

Процедура ВидыНоменклатурыВXML(ЗаписьXML, Данные)
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("CatalogObject.ВидыНоменклатуры");
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Ссылка");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Ссылка.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Наименование");
	ЗаписьXML.ЗаписатьТекст(Данные.Наименование);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Родитель");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.Родитель.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("ЭтоГруппа");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные.ЭтоГруппа));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

Процедура ШтрихкодыНоменклатурыВXML(ЗаписьXML, Данные)
	
	Если Данные.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("InformationRegisterRecordSet.ШтрихкодыНоменклатуры");
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Номенклатура");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные[0].Номенклатура.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Характеристика");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные[0].Характеристика.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();

	ЗаписьXML.ЗаписатьНачалоЭлемента("Упаковка");
	ЗаписьXML.ЗаписатьТекст(Строка(Данные[0].Упаковка.УникальныйИдентификатор()));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Штрихкод");
	ЗаписьXML.ЗаписатьТекст(Данные[0].Штрихкод);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаДанных

Функция УпаковкиЕдиницыИзмеренияИзXML(ЧтениеXML)
	
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	ДанныеСсылка = Справочники.УпаковкиЕдиницыИзмерения.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Ссылка));
	Данные = ДанныеСсылка.ПолучитьОбъект();
	
	Если Данные = Неопределено Тогда
		Данные = Справочники.УпаковкиЕдиницыИзмерения.СоздатьЭлемент();
		Данные.УстановитьСсылкуНового(ДанныеСсылка);
	Иначе
		Данные = ДанныеСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Данные, ОбъектXDTO);
	
	Данные.Родитель = Справочники.УпаковкиЕдиницыИзмерения.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Родитель));
	
	Если ТипЗнч(ОбъектXDTO.НаименованиеПолное) = Тип("ОбъектXDTO") Тогда
		Данные.НаименованиеПолное = "";
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

Функция НаборыУпаковокИзXML(ЧтениеXML)
	
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	ДанныеСсылка = Справочники.НаборыУпаковок.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Ссылка));
	Данные = ДанныеСсылка.ПолучитьОбъект();
	
	Если Данные = Неопределено Тогда
		Данные = Справочники.НаборыУпаковок.СоздатьЭлемент();
		Данные.УстановитьСсылкуНового(ДанныеСсылка);
	Иначе
		Данные = ДанныеСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Данные, ОбъектXDTO);
	
	Возврат Данные;
	
КонецФункции

Функция НоменклатураИзXML(ЧтениеXML)
	
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	ЭтоГруппа = Булево(ОбъектXDTO.ЭтоГруппа);
	
	ДанныеСсылка = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Ссылка));
	Данные = ДанныеСсылка.ПолучитьОбъект();
	
	Если Данные = Неопределено И ЭтоГруппа Тогда
		Данные = Справочники.Номенклатура.СоздатьГруппу();
		Данные.УстановитьСсылкуНового(ДанныеСсылка);
	ИначеЕсли Данные = Неопределено И НЕ ЭтоГруппа Тогда
		Данные = Справочники.Номенклатура.СоздатьЭлемент();
		Данные.УстановитьСсылкуНового(ДанныеСсылка);
	Иначе
		Данные = ДанныеСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Данные, ОбъектXDTO);
	
	Данные.Родитель = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Родитель));
	
	Если ЭтоГруппа Тогда
		Возврат Данные;
	КонецЕсли;
	
	Данные.ЕдиницаИзмерения = Справочники.УпаковкиЕдиницыИзмерения.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.ЕдиницаИзмерения));
	
	Если ТипЗнч(ОбъектXDTO.Артикул) = Тип("ОбъектXDTO") Тогда
		Данные.Артикул = "";
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

Функция ПользователиИзXML(ЧтениеXML)
	
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	ДанныеСсылка = Справочники.Пользователи.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Ссылка));
	Данные = ДанныеСсылка.ПолучитьОбъект();
	
	Если Данные = Неопределено Тогда
		Данные = Справочники.Пользователи.СоздатьЭлемент();
		Данные.УстановитьСсылкуНового(ДанныеСсылка);
	Иначе
		Данные = ДанныеСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Данные, ОбъектXDTO);
	Данные.ИдентификаторПользователяИБ = Новый УникальныйИдентификатор(ОбъектXDTO.ИдентификаторПользователяИБ);
	
	Возврат Данные;
	
КонецФункции

Функция СкладыИзXML(ЧтениеXML)
	
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	ЭтоГруппа = Булево(ОбъектXDTO.ЭтоГруппа);
	
	ДанныеСсылка = Справочники.Склады.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Ссылка));
	Данные = ДанныеСсылка.ПолучитьОбъект();
	
	Если Данные = Неопределено И ЭтоГруппа Тогда
		Данные = Справочники.Склады.СоздатьГруппу();
		Данные.УстановитьСсылкуНового(ДанныеСсылка);
	ИначеЕсли Данные = Неопределено И НЕ ЭтоГруппа Тогда
		Данные = Справочники.Склады.СоздатьЭлемент();
		Данные.УстановитьСсылкуНового(ДанныеСсылка);
	Иначе
		Данные = ДанныеСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Данные, ОбъектXDTO);
	
	Данные.Родитель = Справочники.Склады.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Родитель));
	
	Если ЭтоГруппа Тогда
		Возврат Данные;
	КонецЕсли;
	
	Данные.ИспользоватьАдресноеХранение                          = Булево(ОбъектXDTO.ИспользоватьАдресноеХранение);
	Данные.ИспользоватьАдресноеХранениеСправочно                 = Булево(ОбъектXDTO.ИспользоватьАдресноеХранениеСправочно);
	Данные.ИспользоватьОрдернуюСхемуПриОтгрузке                  = Булево(ОбъектXDTO.ИспользоватьОрдернуюСхемуПриОтгрузке);
	Данные.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач = Булево(ОбъектXDTO.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач);
	Данные.ИспользоватьОрдернуюСхемуПриПоступлении               = Булево(ОбъектXDTO.ИспользоватьОрдернуюСхемуПриПоступлении);
	Данные.ИспользоватьСерииНоменклатуры                         = Булево(ОбъектXDTO.ИспользоватьСерииНоменклатуры);
	Данные.ИспользоватьСкладскиеПомещения                        = Булево(ОбъектXDTO.ИспользоватьСкладскиеПомещения);
	
	Возврат Данные;
	
КонецФункции

Функция СкладскиеПомещенияИзXML(ЧтениеXML)
	
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	ДанныеСсылка = Справочники.СкладскиеПомещения.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Ссылка));
	Данные = ДанныеСсылка.ПолучитьОбъект();
	
	Если Данные = Неопределено Тогда
		Данные = Справочники.СкладскиеПомещения.СоздатьЭлемент();
		Данные.УстановитьСсылкуНового(ДанныеСсылка);
	Иначе
		Данные = ДанныеСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Данные, ОбъектXDTO);
	Данные.ИспользоватьАдресноеХранение = Булево(ОбъектXDTO.ИспользоватьАдресноеХранение);
	Данные.ИспользоватьАдресноеХранениеСправочно = Булево(ОбъектXDTO.ИспользоватьАдресноеХранениеСправочно);
	
	Данные.Владелец = Справочники.Склады.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Владелец));
	
	Возврат Данные;
	
КонецФункции

Функция СкладскиеЯчейкиИзXML(ЧтениеXML)
	
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	ЭтоГруппа = Булево(ОбъектXDTO.ЭтоГруппа);
	
	ДанныеСсылка = Справочники.СкладскиеЯчейки.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Ссылка));
	Данные = ДанныеСсылка.ПолучитьОбъект();
	
	Если Данные = Неопределено И ЭтоГруппа Тогда
		Данные = Справочники.СкладскиеЯчейки.СоздатьГруппу();
		Данные.УстановитьСсылкуНового(ДанныеСсылка);
	ИначеЕсли Данные = Неопределено И НЕ ЭтоГруппа Тогда
		Данные = Справочники.СкладскиеЯчейки.СоздатьЭлемент();
		Данные.УстановитьСсылкуНового(ДанныеСсылка);
	Иначе
		Данные = ДанныеСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Данные, ОбъектXDTO);
	
	Данные.Родитель = Справочники.СкладскиеЯчейки.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Родитель));
	Данные.Владелец = Справочники.Склады.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Владелец));
	
	Если ЭтоГруппа Тогда
		Возврат Данные;
	КонецЕсли;
	
	Данные.Помещение          = Справочники.СкладскиеПомещения.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Помещение));
	Если ТипЗнч(ОбъектXDTO.ТипСкладскойЯчейки) = Тип("Строка") Тогда
		Данные.ТипСкладскойЯчейки = Перечисления.ТипыСкладскихЯчеек[ОбъектXDTO.ТипСкладскойЯчейки];
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

Функция ХарактеристикиНоменклатурыИзXML(ЧтениеXML)
	
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	ДанныеСсылка = Справочники.ХарактеристикиНоменклатуры.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Ссылка));
	Данные = ДанныеСсылка.ПолучитьОбъект();
	
	Если Данные = Неопределено Тогда
		Данные = Справочники.ХарактеристикиНоменклатуры.СоздатьЭлемент();
		Данные.УстановитьСсылкуНового(ДанныеСсылка);
	Иначе
		Данные = ДанныеСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Данные, ОбъектXDTO);
	
	// Определить тип и по нему поискать ссылки
	Данные.Владелец = Справочники.Склады.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Владелец));
	
	Возврат Данные;
	
КонецФункции

Функция ВидыНоменклатурыИзXML(ЧтениеXML)
	
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	ЭтоГруппа = Булево(ОбъектXDTO.ЭтоГруппа);
	
	ДанныеСсылка = Справочники.ВидыНоменклатуры.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Ссылка));
	Данные = ДанныеСсылка.ПолучитьОбъект();
	
	Если Данные = Неопределено И ЭтоГруппа Тогда
		Данные = Справочники.ВидыНоменклатуры.СоздатьГруппу();
		Данные.УстановитьСсылкуНового(ДанныеСсылка);
	ИначеЕсли Данные = Неопределено И НЕ ЭтоГруппа Тогда
		Данные = Справочники.ВидыНоменклатуры.СоздатьЭлемент();
		Данные.УстановитьСсылкуНового(ДанныеСсылка);
	Иначе
		Данные = ДанныеСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Данные, ОбъектXDTO);
	
	Данные.Родитель = Справочники.ВидыНоменклатуры.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Родитель));
	
	Если ЭтоГруппа Тогда
		Возврат Данные;
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

Функция ШтрихкодыНоменклатурыИзXML(ЧтениеXML)
	
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	МенеджерЗаписи = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Штрихкод       = ОбъектXDTO.Штрихкод;
	МенеджерЗаписи.Номенклатура   = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Номенклатура));
	МенеджерЗаписи.Характеристика = Справочники.ХарактеристикиНоменклатуры.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Характеристика));
	МенеджерЗаписи.Упаковка       = Справочники.УпаковкиЕдиницыИзмерения.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.Упаковка));
	Попытка
		МенеджерЗаписи.Записать();
	Исключение
	КонецПопытки;
	
	Возврат Неопределено;
	
КонецФункции

Процедура ЗарегистрироватьИзмененияДляРМКладовщикаПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	УзлыДляРегистрации = УзлыДляРегистрации();
	
	ЗарегистрироватьИзмененияДляУзловОбмена(УзлыДляРегистрации, Источник);
	
КонецПроцедуры

// Возвращает массив узлов плана обмена с учетом исключаемых.
//
// Возвращаемое значение:
//  Массив - массив узлов для регистрации изменений.
//
Функция УзлыДляРегистрации()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	Мобильные.Ссылка
	|ИЗ
	|	ПланОбмена.Мобильные КАК Мобильные
	|ГДЕ
	|	НЕ Мобильные.ПометкаУдаления
	|	И НЕ Мобильные.ЭтотУзел");
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецФункции

// Регистрирует объекты в узлах обмена мобильного приложения.
//
// Параметры:
//  МассивУзлов - Массив - содержит узлы для регистрации изменений объекта;
//  Объект - СправочникОбъект, РегистрСведенийНаборЗаписей - объект для которого регистрируются изменения.
//
Процедура ЗарегистрироватьИзмененияДляУзловОбмена(МассивУзлов, Объект) Экспорт
	
	Если МассивУзлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Объект.Ссылка);
	
	//Если ТипЗнч(Объект) = Тип("РегистрСведенийНаборЗаписей.ЦеныНоменклатуры") Тогда
	//	ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Объект);
	//ИначеЕсли ТипЗнч(Объект) = Тип("СправочникОбъект.НоменклатураПрисоединенныеФайлы") Тогда
	//	Если ЗначениеЗаполнено(Объект.ВладелецФайла) Тогда
	//		Для Каждого УзелОбмена Из МассивУзлов Цикл
	//			РеквизитыУзла = МобильноеПриложениеЗаказыКлиентов.РеквизитыУзла(УзелОбмена);
	//			ПередаватьИзображенияТоваров = ?(РеквизитыУзла.ПередаватьИзображенияТоваров = Неопределено,
	//					Ложь, РеквизитыУзла.ПередаватьИзображенияТоваров);
	//			Если ПередаватьИзображенияТоваров Тогда
	//				ПланыОбмена.ЗарегистрироватьИзменения(УзелОбмена, Объект.Ссылка);
	//			КонецЕсли;
	//		КонецЦикла;
	//	КонецЕсли;
	//ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.НоменклатураПрисоединенныеФайлы") Тогда
	//	ОбъектВладелецФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект, "ВладелецФайла");
	//	Если ЗначениеЗаполнено(ОбъектВладелецФайла) Тогда
	//		Для Каждого УзелОбмена Из МассивУзлов Цикл
	//			РеквизитыУзла = МобильноеПриложениеЗаказыКлиентов.РеквизитыУзла(УзелОбмена);
	//			ПередаватьИзображенияТоваров = ?(РеквизитыУзла.ПередаватьИзображенияТоваров = Неопределено,
	//					Ложь, РеквизитыУзла.ПередаватьИзображенияТоваров);
	//			Если ПередаватьИзображенияТоваров Тогда
	//				ПланыОбмена.ЗарегистрироватьИзменения(УзелОбмена, Объект);
	//			КонецЕсли;
	//		КонецЦикла;
	//	КонецЕсли;
	//ИначеЕсли ТипЗнч(Объект) = Тип("СправочникОбъект.Номенклатура") Тогда
	//	ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Объект.Ссылка);
	//КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияДляРМКладовщикаРегистрыПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	УзлыДляРегистрации = УзлыДляРегистрации();
	
	ЗарегистрироватьИзмененияДляУзловОбменаРегистры(УзлыДляРегистрации, Источник);
	
КонецПроцедуры

// Регистрирует объекты в узлах обмена мобильного приложения.
//
// Параметры:
//  МассивУзлов - Массив - содержит узлы для регистрации изменений объекта;
//  НаборЗаписей - РегистрСведенийНаборЗаписей - объект для которого регистрируются изменения.
//
Процедура ЗарегистрироватьИзмененияДляУзловОбменаРегистры(МассивУзлов, НаборЗаписей) Экспорт
	
	Если МассивУзлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, НаборЗаписей);
	
КонецПроцедуры

#КонецОбласти