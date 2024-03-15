
#Область ПрограммныйИнтерфейс

// Устанавливает видимость команды отправки по электронной почте на форме.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой необходимо настроить видимость команды.
//
Процедура ПриСозданииНаСервере(Форма) Экспорт
	
	// Совместимость с БП.
	
КонецПроцедуры

// Возвращает адреса электронной почты из контактной информации контрагента и его контактных лиц.
//
// Параметры:
//  Контрагент - СправочникСсылка.Контрагенты - ссылка на контрагента.
//
// Возвращаемое значение:
//  Массив - содержит структуры с адресом электронной почты и владельцем контактной информации.
//           Состав ключей структуры см. НовыеПараметрыПолучателя().
//
Функция АдресаЭлектроннойПочты(Контрагент) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Получатели = ОтправкаПочтовыхСообщенийПереопределяемый.АдресаЭлектроннойПочты(Контрагент);
	
	Если НЕ ЗначениеЗаполнено(Получатели) ИЛИ НЕ ТипЗнч(Получатели) = Тип("Массив") Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Возврат Получатели;
	
КонецФункции

// Формирует структуру параметров электронного письма для отправки отчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - см.ОтправкаПочтовыхСообщенийКлиент.ОтправитьОтчет.
//  ДополнительныеПараметры - Структура - см.ОтправкаПочтовыхСообщенийКлиент.ОтправитьОтчет.
//
// Возвращаемое значение:
//  Структура - Структура параметров для передачи в функцию РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо.
//
Функция ПараметрыЭлектронногоПисьмаДляОтчетов(ПараметрыОтчета, ДополнительныеПараметры = Неопределено) Экспорт
	
	Вложения = ПоместитьТабличныйДокументОтчетаВоВременноеХранилище(ПараметрыОтчета, ДополнительныеПараметры);
	
	Получатель = "";
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		
		Если ДополнительныеПараметры.Свойство("ДопВложения") Тогда
			ДополнитьВложения(Вложения, ДополнительныеПараметры.ДопВложения);
		КонецЕсли;
		
		Если ДополнительныеПараметры.Свойство("Контрагент") Тогда
			Получатель = АдресаЭлектроннойПочты(ДополнительныеПараметры.Контрагент);
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстПисьма = ОписьВложенийПисьма(Вложения);
	
	ПараметрыПисьма = НовыеПараметрыПисьма();
	ПараметрыПисьма.Получатель = Получатель;
	ПараметрыПисьма.Тема       = ПараметрыОтчета.Заголовок;
	ПараметрыПисьма.Текст      = ТекстПисьма;
	ПараметрыПисьма.Вложения   = ПодготовитьВложенияПочтовогоСообщения(Вложения);
	
	Если ЗначениеЗаполнено(ДополнительныеПараметры) Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыПисьма, ДополнительныеПараметры);
	КонецЕсли;
	
	Возврат ПараметрыПисьма;
	
КонецФункции

// Устанавливает соединение с сервером электронной почты.
//
// Параметры:
//  УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись для соединения.
//  ДляПолучения - Булево - Если Истина, то соединение может быть использовано для загрузки почтовых сообщений.
//  Протокол - ПротоколИнтернетПочты - Протокол используемый для загрузки почтовых сообщений. По умолчанию - POP3.
//
// Возвращаемое значение:
//  ИнтернетПочта - если с сервером удалось установить соединение.
//  Неопределено - если при установки соединения возникло исключение.
//
Функция УстановитьСоединениеССервером(УчетнаяЗапись, ДляПолучения = Ложь, Протокол = Неопределено) Экспорт
	
	Соединение = Новый ИнтернетПочта;
	ИнтернетПочтовыйПрофиль = ИнтернетПочтовыйПрофиль(УчетнаяЗапись, ДляПолучения);
	
	Если Протокол = Неопределено Тогда
		Протокол = ПротоколИнтернетПочты.POP3;
	КонецЕсли;
	
	Попытка
		Соединение.Подключиться(ИнтернетПочтовыйПрофиль, Протокол);
		Возврат Соединение;
		
	Исключение
		КодОсновногоЯзыка  = ОбщегоНазначения.КодОсновногоЯзыка();
		ИмяСобытия = НСтр("ru = 'Установка соединения с сервером электронной почты'", КодОсновногоЯзыка);
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Неопределено;
		
	КонецПопытки;
КонецФункции

// Подготавливает опись переданных файлов в формате HTML.
//
// Параметры:
//  Вложения - СписокЗначений, Структура, Соответствие - коллекция файлов. Для списка значений как наименование файла
//              в описи используется Представление. Для структуры или соответствия Ключ.
//
// Возвращаемое значение:
//
//  Строка - описание переданных файлов в формате HTML.
//
Функция ОписьВложенийПисьма(Вложения) Экспорт
	
	ТекстПисьма = НСтр("ru = 'К письму приложены файлы:'");
	
	Если ТипЗнч(Вложения) = Тип("СписокЗначений") Тогда
		Для Каждого Вложение Из Вложения Цикл
			ТекстПисьма = ТекстПисьма + Символы.ПС + СтрШаблон(НСтр("ru='- %1'"), Вложение.Представление);
		КонецЦикла;
	КонецЕсли;
	
	Если ТипЗнч(Вложения) = Тип("Структура") ИЛИ ТипЗнч(Вложения) = Тип("Соответствие") Тогда
		Для Каждого Вложение Из Вложения Цикл
			ТекстПисьма = ТекстПисьма + Символы.ПС + СтрШаблон(НСтр("ru='- %1'"), Вложение.Ключ);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТекстПисьма;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Создает профиль переданной учетной записи для подключения к почтовому серверу.
//
// Параметры:
//  УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись.
//
// Возвращаемое значение:
//  ИнтернетПочтовыйПрофиль - профиль учетной записи;
//  Неопределено - не удалось получить учетную запись по ссылке.
//
Функция ИнтернетПочтовыйПрофиль(УчетнаяЗапись, ДляПолучения)
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УчетныеЗаписиЭлектроннойПочты.СерверВходящейПочты КАК АдресСервераIMAP,
	|	УчетныеЗаписиЭлектроннойПочты.ПортСервераВходящейПочты КАК ПортIMAP,
	|	УчетныеЗаписиЭлектроннойПочты.ИспользоватьЗащищенноеСоединениеДляВходящейПочты КАК ИспользоватьSSLIMAP,
	|	УчетныеЗаписиЭлектроннойПочты.Пользователь КАК ПользовательIMAP,
	|	УчетныеЗаписиЭлектроннойПочты.СерверВходящейПочты КАК АдресСервераPOP3,
	|	УчетныеЗаписиЭлектроннойПочты.ПортСервераВходящейПочты КАК ПортPOP3,
	|	УчетныеЗаписиЭлектроннойПочты.ИспользоватьЗащищенноеСоединениеДляВходящейПочты КАК ИспользоватьSSLPOP3,
	|	УчетныеЗаписиЭлектроннойПочты.Пользователь КАК Пользователь,
	|	УчетныеЗаписиЭлектроннойПочты.СерверИсходящейПочты КАК АдресСервераSMTP,
	|	УчетныеЗаписиЭлектроннойПочты.ПортСервераИсходящейПочты КАК ПортSMTP,
	|	УчетныеЗаписиЭлектроннойПочты.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты КАК ИспользоватьSSLSMTP,
	|	УчетныеЗаписиЭлектроннойПочты.ТребуетсяВходНаСерверПередОтправкой КАК POP3ПередSMTP,
	|	УчетныеЗаписиЭлектроннойПочты.ПользовательSMTP КАК ПользовательSMTP,
	|	УчетныеЗаписиЭлектроннойПочты.ВремяОжидания КАК Таймаут,
	|	УчетныеЗаписиЭлектроннойПочты.ПротоколВходящейПочты КАК Протокол
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", УчетнаяЗапись);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = Неопределено;
	Если Выборка.Следующий() Тогда
		СписокСвойствIMAP = "АдресСервераIMAP,ПортIMAP,ИспользоватьSSLIMAP,ПользовательIMAP";
		СписокСвойствPOP3 = "АдресСервераPOP3,ПортPOP3,ИспользоватьSSLPOP3,Пользователь";
		СписокСвойствSMTP = "АдресСервераSMTP,ПортSMTP,ИспользоватьSSLSMTP,ПользовательSMTP";
		
		Результат = Новый ИнтернетПочтовыйПрофиль;
		Если ДляПолучения Тогда
			Если Выборка.Протокол = "IMAP" Тогда
				ТребуемыеСвойства = СписокСвойствIMAP;
				УстановитьПривилегированныйРежим(Истина);
				Результат.ПарольIMAP = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(УчетнаяЗапись);
				УстановитьПривилегированныйРежим(Ложь);
			Иначе
				ТребуемыеСвойства = СписокСвойствPOP3;
				УстановитьПривилегированныйРежим(Истина);
				Результат.Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(УчетнаяЗапись);
				УстановитьПривилегированныйРежим(Ложь);
			КонецЕсли;
		Иначе
			ТребуемыеСвойства = СписокСвойствSMTP;
			Если Выборка.Протокол <> "IMAP" И Выборка.POP3ПередSMTP Тогда
				ТребуемыеСвойства = ТребуемыеСвойства + ",POP3ПередSMTP," + СписокСвойствPOP3;
			КонецЕсли;
			УстановитьПривилегированныйРежим(Истина);
			Результат.ПарольSMTP = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(УчетнаяЗапись, "ПарольSMTP");
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		ТребуемыеСвойства = ТребуемыеСвойства + ",Таймаут";
		ЗаполнитьЗначенияСвойств(Результат, Выборка, ТребуемыеСвойства);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция НовыеПараметрыПолучателя() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Выбран"                      , Ложь);
	Результат.Вставить("ИсточникКонтактнойИнформации", Справочники.Контрагенты.ПустаяСсылка());
	Результат.Вставить("Адрес"                       , "");
	Результат.Вставить("Представление"               , "");
	
	Возврат Результат;
	
КонецФункции

Функция ПоместитьТабличныйДокументОтчетаВоВременноеХранилище(ПараметрыОтчета, ДополнительныеПараметры = Неопределено)
	
	Результат = Новый СписокЗначений;
	
	ТабличныйДокумент = ПараметрыОтчета.ТабличныйДокумент;
	
	ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременнойПапки);
	ПолныйПутьКФайлу = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки);
	
	Если ТабличныйДокумент.Вывод = ИспользованиеВывода.Запретить Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") И ДополнительныеПараметры.Свойство("ИмяФайла") Тогда
		ИмяФайла = ДополнительныеПараметры.ИмяФайла;
	Иначе
		ИмяФайла = ПараметрыОтчета.Заголовок;
	КонецЕсли;
	
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла);
	Если Прав(ИмяФайла, 1) = "." Тогда
		ИмяФайла = ИмяФайла + "xls";
	Иначе
		ИмяФайла = ИмяФайла + ".xls";
	КонецЕсли;
	
	ПолноеИмяФайла = УникальноеИмяФайла(ПолныйПутьКФайлу + ИмяФайла);
	
	ТабличныйДокумент.Записать(ПолноеИмяФайла, ТипФайлаТабличногоДокумента.XLS);
	
	Результат.Добавить(ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПолноеИмяФайла), Новый УникальныйИдентификатор), ИмяФайла);
	
	УдалитьФайлы(ИмяВременнойПапки);
	
	Возврат Результат;
	
КонецФункции

Процедура ДополнитьВложения(Вложения, ВложенияКДополнению)
	
	Для Каждого ОписаниеВложения Из ВложенияКДополнению Цикл
		// Ключ - адрес двоичных данных во временном хранилище, значение - имя файла для отображения во вложениях.
		Вложения.Добавить(ОписаниеВложения.Ключ, ОписаниеВложения.Значение);
	КонецЦикла;
	
КонецПроцедуры

Функция УникальноеИмяФайла(ИмяФайла)
	
	Файл = Новый Файл(ИмяФайла);
	ИмяБезРасширения = Файл.ИмяБезРасширения;
	Расширение = Файл.Расширение;
	Папка = Файл.Путь;
	
	Счетчик = 1;
	Пока Файл.Существует() Цикл
		Счетчик = Счетчик + 1;
		Файл = Новый Файл(Папка + ИмяБезРасширения + " (" + Счетчик + ")" + Расширение);
	КонецЦикла;
	
	Возврат Файл.ПолноеИмя;
	
КонецФункции

Функция НовыеПараметрыПисьма() Экспорт
	
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Отправитель"              , Справочники.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка());
	ПараметрыПисьма.Вставить("Получатель"               , "");
	ПараметрыПисьма.Вставить("Тема"                     , "");
	ПараметрыПисьма.Вставить("Текст"                    , "");
	ПараметрыПисьма.Вставить("Вложения"                 , "");
	ПараметрыПисьма.Вставить("УдалятьФайлыПослеОтправки", Истина);
	
	Возврат ПараметрыПисьма;
	
КонецФункции

Функция ПодготовитьВложенияПочтовогоСообщения(СписокВложений)

	// Массив структур Вложения, как описано для функции РаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма().
	Результат = Новый Массив;
	
	Для Каждого ЭлементСписка Из СписокВложений Цикл
	
		НовоеВложение = Новый Структура();
		НовоеВложение.Вставить("Представление",             ЭлементСписка.Представление);
		НовоеВложение.Вставить("АдресВоВременномХранилище", ЭлементСписка.Значение);
	
		Результат.Добавить(НовоеВложение);
		
	КонецЦикла;

	Возврат Результат;

КонецФункции

#КонецОбласти