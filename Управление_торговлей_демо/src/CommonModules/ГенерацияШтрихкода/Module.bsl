///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Пустая структура для заполнения параметра "ПараметрыШтрихкода" используемого для получения изображения штрих кода.
// 
// Возвращаемое значение:
//   Структура:
//   * Ширина - Число - ширина изображения штрих кода.
//   * Высота - Число - высота изображения штрих кода.
//   * ТипКода - Число - штрихкода.
//       Возможные значение:
//      99 -  Авто выбор
//      0 - EAN8
//      1 - EAN13
//      2 - EAN128
//      3 - Code39
//      4 - Code128
//      5 - Code16k
//      6 - PDF417
//      7 - Standart (Industrial) 2 of 5
//      8 - Interleaved 2 of 5
//      9 - Code39 Расширение
//      10 - Code93
//      11 - ITF14
//      12 - RSS14
//      14 - EAN13AddOn2
//      15 - EAN13AddOn5
//      16 - QR
//      17 - GS1DataBarExpandedStacked
//      18 - Datamatrix ASCII
//      19 - Datamatrix BASE256
//      20 - Datamatrix TEXT
//      21 - Datamatrix C40
//      22 - Datamatrix X12
//      23 - Datamatrix EDIFACT
//      24 - Datamatrix GS1ASCII:
//   * ОтображатьТекст - Булево - отображать HRI теста для штрихкода.
//   * РазмерШрифта - Число - размер шрифта HRI теста для штрихкода.
//   * УголПоворота - Число - угол поворота.
//      Возможные значения: 0, 90, 180, 270.
//   * Штрихкод - Строка - значение штрихкод в виде строки или Base64.
//   * ТипВходныхДанных - Число - тип входных данных 
//      Возможные значения: 0 - Строка, 1 - Base64
//   * ПрозрачныйФон - Булево - прозрачный фон изображения штрихкода.
//   * УровеньКоррекцииQR - Число - уровень коррекции штрихкода QR.
//      Возможные значения: 0 - L, 1 - M, 2 - Q, 3 - H.
//   * Масштабировать - Булево -  масштабировать изображение штрихкода.
//   * СохранятьПропорции - Булево - сохранять пропорции изображения штрихкода.                                                              
//   * ВертикальноеВыравнивание - Число - вертикальное выравнивание штрихкода.
//      Возможные значения: 1 - По верхнему краю, 2 - По центру, 3 - По нижнему краю
//   * GS1DatabarКоличествоСтрок - Число - количество строк в штрихкоде GS1Databar.
//   * УбратьЛишнийФон - Булево
//   * ЛоготипКартинка - Строка - строка с base64 представлением png картинки логотипа.
//   * ЛоготипРазмерПроцентОтШК - Число - процент от генерированного QR для вписывания логотипа.
//
Функция ПараметрыГенерацииШтрихкода() Экспорт
	
	ПараметрыШтрихкода = Новый Структура;
	ПараметрыШтрихкода.Вставить("Ширина"            , 100);
	ПараметрыШтрихкода.Вставить("Высота"            , 100);
	ПараметрыШтрихкода.Вставить("ТипКода"           , 99);
	ПараметрыШтрихкода.Вставить("ОтображатьТекст"   , Истина);
	ПараметрыШтрихкода.Вставить("РазмерШрифта"      , 12);
	ПараметрыШтрихкода.Вставить("УголПоворота"      , 0);
	ПараметрыШтрихкода.Вставить("Штрихкод"          , "");
	ПараметрыШтрихкода.Вставить("ПрозрачныйФон"     , Истина);
	ПараметрыШтрихкода.Вставить("УровеньКоррекцииQR", 1);
	ПараметрыШтрихкода.Вставить("Масштабировать"           , Ложь);
	ПараметрыШтрихкода.Вставить("СохранятьПропорции"       , Ложь);
	ПараметрыШтрихкода.Вставить("ВертикальноеВыравнивание" , 1); 
	ПараметрыШтрихкода.Вставить("GS1DatabarКоличествоСтрок", 2);
	ПараметрыШтрихкода.Вставить("ТипВходныхДанных", 0);
	ПараметрыШтрихкода.Вставить("УбратьЛишнийФон" , Ложь); 
	ПараметрыШтрихкода.Вставить("ЛоготипКартинка");
	ПараметрыШтрихкода.Вставить("ЛоготипРазмерПроцентОтШК");
	
	Возврат ПараметрыШтрихкода;
	
КонецФункции

// Формирование изображения штрихкода.
//
// Параметры: 
//   ПараметрыШтрихкода - см. ГенерацияШтрихкода.ПараметрыГенерацииШтрихкода.
//
// Возвращаемое значение: 
//   Структура:
//      Результат - Булево - результат генерации штрихкода.
//      ДвоичныеДанные - ДвоичныеДанные - двоичные данные изображения штрихкода.
//      Картинка - Картинка - картинка с сформированным штрихкодом или НЕОПРЕДЕЛЕНО.
//
Функция ИзображениеШтрихкода(ПараметрыШтрихкода) Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ТипПлатформыКомпоненты = Строка(СистемнаяИнформация.ТипПлатформы);
	
	ВнешняяКомпонента = ГенерацияШтрихкодаСерверПовтИсп.ПодключитьКомпонентуГенерацииИзображенияШтрихкода(ТипПлатформыКомпоненты);
	
	Если ВнешняяКомпонента = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Ошибка подключения внешней компоненты печати штрихкода.'");
	#Если НЕ МобильноеПриложениеСервер Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка генерации штрихкода'", 
			ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, 
			ТекстСообщения);
	#КонецЕсли
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Возврат ПодготовитьИзображениеШтрихкода(ВнешняяКомпонента, ПараметрыШтрихкода); 
	 
КонецФункции

// Возвращает двоичные данные для формирования QR-кода.
//
// Параметры:
//  QRСтрока         - Строка - данные, которые необходимо разместить в QR-коде.
//
//  УровеньКоррекции - Число - уровень погрешности изображения, при котором данный QR-код все еще возможно 100%
//                             распознать.
//                     Параметр должен иметь тип целого и принимать одно из 4 допустимых значений:
//                     0 (7 % погрешности), 1 (15 % погрешности), 2 (25 % погрешности), 3 (35 % погрешности).
//
//  Размер           - Число - определяет длину стороны выходного изображения в пикселях.
//                     Если минимально возможный размер изображения больше этого параметра - код сформирован не будет.
//
// Возвращаемое значение:
//  ДвоичныеДанные  - буфер, содержащий байты PNG-изображения QR-кода.
// 
// Пример:
//  
//  // Выводим на печать QR-код, содержащий в себе информацию зашифрованную по УФЭБС.
//
//  QRСтрока = УправлениеПечатью.ФорматнаяСтрокаУФЭБС(РеквизитыПлатежа);
//  ТекстОшибки = "";
//  ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(QRСтрока, 0, 190, ТекстОшибки);
//  Если Не ПустаяСтрока(ТекстОшибки)
//      ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
//  КонецЕсли;
//
//  КартинкаQRКода = Новый Картинка(ДанныеQRКода);
//  ОбластьМакета.Рисунки.QRКод.Картинка = КартинкаQRКода;
//
Функция ДанныеQRКода(QRСтрока, УровеньКоррекции, Размер) Экспорт
	
	ПараметрыШтрихкода = ПараметрыГенерацииШтрихкода();
	ПараметрыШтрихкода.Ширина = Размер;
	ПараметрыШтрихкода.Высота = Размер;
	ПараметрыШтрихкода.Штрихкод = QRСтрока;
	ПараметрыШтрихкода.УровеньКоррекцииQR = УровеньКоррекции;
	ПараметрыШтрихкода.ТипКода = 16; // QR
	ПараметрыШтрихкода.УбратьЛишнийФон = Истина;
	
	Попытка
		РезультатФормированияШтрихкода = ИзображениеШтрихкода(ПараметрыШтрихкода);
		ДвоичныеДанныеКартинки = РезультатФормированияШтрихкода.ДвоичныеДанные;
	Исключение
	#Если НЕ МобильноеПриложениеСервер Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка генерации штрихкода'", 
			ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	#КонецЕсли
	КонецПопытки;
	
	Возврат ДвоичныеДанныеКартинки;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет подключение внешней компоненты.
//
// Возвращаемое значение: 
//   ОбъектВнешнейКомпоненты
//   Неопределено - если компоненту не удалось загрузить.
//
Функция ПодключитьКомпонентуГенерацииИзображенияШтрихкода() Экспорт
	
#Если НЕ МобильноеПриложениеСервер Тогда  
	УстановитьОтключениеБезопасногоРежима(Истина);
#КонецЕсли
	ВнешняяКомпонента = Неопределено;
	
#Если НЕ МобильноеПриложениеСервер Тогда
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВнешниеКомпоненты") Тогда
			МодульВнешниеКомпонентыСервер = ОбщегоНазначения.ОбщийМодуль("ВнешниеКомпонентыСервер");
			РезультатПодключения = МодульВнешниеКомпонентыСервер.ПодключитьКомпоненту("Barcode");
			Если РезультатПодключения.Подключено Тогда
				ВнешняяКомпонента = РезультатПодключения.ПодключаемыйМодуль;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
#КонецЕсли
	
	Если ВнешняяКомпонента = Неопределено Тогда 
		ВнешняяКомпонента = ОбщегоНазначения.ПодключитьКомпонентуИзМакета("Barcode", "ОбщийМакет.КомпонентаПечатиШтрихкодов");
	КонецЕсли;
	
	Если ВнешняяКомпонента = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	// Установим основные параметры компоненты.
	// Если в системе установлен шрифт Tahoma.
	Если ВнешняяКомпонента.НайтиШрифт("Tahoma") Тогда
		// Выбираем его как шрифт для формирования картинки.
		ВнешняяКомпонента.Шрифт = "Tahoma";
	Иначе
		// Шрифт Tahoma в системе отсутствует.
		// Обойдем все доступные компоненте шрифты.
		Для Сч = 0 По ВнешняяКомпонента.КоличествоШрифтов -1 Цикл
			// Получим очередной шрифт, доступный компоненте.
			ТекущийШрифт = ВнешняяКомпонента.ШрифтПоИндексу(Сч);
			// Если шрифт доступен
			Если ТекущийШрифт <> Неопределено Тогда
				// Они и будет шрифтом для формирования штрихкода.
				ВнешняяКомпонента.Шрифт = ТекущийШрифт;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	// Установим размер шрифта
	ВнешняяКомпонента.РазмерШрифта = 12;
	
	Возврат ВнешняяКомпонента;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Подготовить изображения штрихкода.
//
// Параметры: 
//   ВнешняяКомпонента - см. ГенерацияШтрихкодаСерверПовтИсп.ПодключитьКомпонентуГенерацииИзображенияШтрихкода
//   ПараметрыШтрихкода - см. ГенерацияШтрихкода.ПараметрыГенерацииШтрихкода
//
// Возвращаемое значение: 
//   Структура:
//      Результат - Булево - результат генерации штрихкода.
//      ДвоичныеДанные - ДвоичныеДанные - двоичные данные изображения штрихкода.
//      Картинка - Картинка - картинка с сформированным штрихкодом или НЕОПРЕДЕЛЕНО.
//
Функция ПодготовитьИзображениеШтрихкода(ВнешняяКомпонента, ПараметрыШтрихкода)
	
	// Результат 
	РезультатОперации = Новый Структура();
	РезультатОперации.Вставить("Результат", Ложь);
	РезультатОперации.Вставить("ДвоичныеДанные");
	РезультатОперации.Вставить("Картинка");
	
	// Зададим размер формируемой картинки.
	ШиринаШтрихкода = Окр(ПараметрыШтрихкода.Ширина);
	ВысотаШтрихкода = Окр(ПараметрыШтрихкода.Высота);
	Если ШиринаШтрихкода <= 0 Тогда
		ШиринаШтрихкода = 1
	КонецЕсли;
	Если ВысотаШтрихкода <= 0 Тогда
		ВысотаШтрихкода = 1
	КонецЕсли;
	ВнешняяКомпонента.Ширина = ШиринаШтрихкода;
	ВнешняяКомпонента.Высота = ВысотаШтрихкода;
	ВнешняяКомпонента.АвтоТип = Ложь;
	
	ШтрихкодВрем = Строка(ПараметрыШтрихкода.Штрихкод); // Преобразуем явно в строку.
	
	Если ПараметрыШтрихкода.ТипКода = 99 Тогда
		ВнешняяКомпонента.АвтоТип = Истина;
	Иначе
		ВнешняяКомпонента.АвтоТип = Ложь;
		ВнешняяКомпонента.ТипКода = ПараметрыШтрихкода.ТипКода;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("ПрозрачныйФон") Тогда
		ВнешняяКомпонента.ПрозрачныйФон = ПараметрыШтрихкода.ПрозрачныйФон;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("ТипВходныхДанных") Тогда
		ВнешняяКомпонента.ТипВходныхДанных = ПараметрыШтрихкода.ТипВходныхДанных;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("GS1DatabarКоличествоСтрок") Тогда
		ВнешняяКомпонента.GS1DatabarКоличествоСтрок = ПараметрыШтрихкода.GS1DatabarКоличествоСтрок;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("УбратьЛишнийФон") Тогда
		ВнешняяКомпонента.УбратьЛишнийФон = ПараметрыШтрихкода.УбратьЛишнийФон;
	КонецЕсли;
	
	ВнешняяКомпонента.ОтображатьТекст = ПараметрыШтрихкода.ОтображатьТекст;
	// Формируем картинку штрихкода.
	ВнешняяКомпонента.ЗначениеКода = ШтрихкодВрем;
	// Угол поворота штрихкода.
	ВнешняяКомпонента.УголПоворота = ?(ПараметрыШтрихкода.Свойство("УголПоворота"), ПараметрыШтрихкода.УголПоворота, 0);
	// Уровень коррекции QR кода (L=0, M=1, Q=2, H=3).
	ВнешняяКомпонента.УровеньКоррекцииQR = ?(ПараметрыШтрихкода.Свойство("УровеньКоррекцииQR"), ПараметрыШтрихкода.УровеньКоррекцииQR, 1);
	
	// Для обеспечения совместимости с предыдущими версиями БПО.
	Если Не ПараметрыШтрихкода.Свойство("Масштабировать")
		Или (ПараметрыШтрихкода.Свойство("Масштабировать") И ПараметрыШтрихкода.Масштабировать) Тогда
		
		Если Не ПараметрыШтрихкода.Свойство("СохранятьПропорции")
				Или (ПараметрыШтрихкода.Свойство("СохранятьПропорции") И Не ПараметрыШтрихкода.СохранятьПропорции) Тогда
			// Если установленная нами ширина меньше минимально допустимой для этого штрихкода.
			Если ВнешняяКомпонента.Ширина < ВнешняяКомпонента.МинимальнаяШиринаКода Тогда
				ВнешняяКомпонента.Ширина = ВнешняяКомпонента.МинимальнаяШиринаКода;
			КонецЕсли;
			// Если установленная нами высота меньше минимально допустимой для этого штрихкода.
			Если ВнешняяКомпонента.Высота < ВнешняяКомпонента.МинимальнаяВысотаКода Тогда
				ВнешняяКомпонента.Высота = ВнешняяКомпонента.МинимальнаяВысотаКода;
			КонецЕсли;
		ИначеЕсли ПараметрыШтрихкода.Свойство("СохранятьПропорции") И ПараметрыШтрихкода.СохранятьПропорции Тогда
			Пока ВнешняяКомпонента.Ширина < ВнешняяКомпонента.МинимальнаяШиринаКода 
				Или ВнешняяКомпонента.Высота < ВнешняяКомпонента.МинимальнаяВысотаКода Цикл
				// Если установленная нами ширина меньше минимально допустимой для этого штрихкода.
				Если ВнешняяКомпонента.Ширина < ВнешняяКомпонента.МинимальнаяШиринаКода Тогда
					ВнешняяКомпонента.Ширина = ВнешняяКомпонента.МинимальнаяШиринаКода;
					ВнешняяКомпонента.Высота = Окр(ВнешняяКомпонента.МинимальнаяШиринаКода / ШиринаШтрихкода) * ВысотаШтрихкода;
				КонецЕсли;
				// Если установленная нами высота меньше минимально допустимой для этого штрихкода.
				Если ВнешняяКомпонента.Высота < ВнешняяКомпонента.МинимальнаяВысотаКода Тогда
					ВнешняяКомпонента.Высота = ВнешняяКомпонента.МинимальнаяВысотаКода;
					ВнешняяКомпонента.Ширина = Окр(ВнешняяКомпонента.МинимальнаяВысотаКода / ВысотаШтрихкода) * ШиринаШтрихкода;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	// ВертикальноеВыравниваниеКода: 1 - по верхнему краю, 2 - по центру, 3 - по нижнему краю.
	Если ПараметрыШтрихкода.Свойство("ВертикальноеВыравнивание") И (ПараметрыШтрихкода.ВертикальноеВыравнивание > 0) Тогда
		ВнешняяКомпонента.ВертикальноеВыравниваниеКода = ПараметрыШтрихкода.ВертикальноеВыравнивание;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("РазмерШрифта") И (ПараметрыШтрихкода.РазмерШрифта > 0) 
		И (ПараметрыШтрихкода.ОтображатьТекст) И (ВнешняяКомпонента.РазмерШрифта <> ПараметрыШтрихкода.РазмерШрифта) Тогда
			ВнешняяКомпонента.РазмерШрифта = ПараметрыШтрихкода.РазмерШрифта;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("РазмерШрифта") И ПараметрыШтрихкода.РазмерШрифта > 0
		И ПараметрыШтрихкода.Свойство("МонохромныйШрифт") Тогда
		Если ПараметрыШтрихкода.МонохромныйШрифт Тогда
			ВнешняяКомпонента.МаксимальныйРазмерШрифтаДляПринтеровНизкогоРазрешения = ПараметрыШтрихкода.РазмерШрифта + 1;
		Иначе
			ВнешняяКомпонента.МаксимальныйРазмерШрифтаДляПринтеровНизкогоРазрешения = -1;
		КонецЕсли;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.ТипКода = 16 Тогда // QR
		Если ПараметрыШтрихкода.Свойство("ЛоготипКартинка") И ЗначениеЗаполнено(ПараметрыШтрихкода.ЛоготипКартинка) Тогда 
			ВнешняяКомпонента.ЛоготипКартинка = ПараметрыШтрихкода.ЛоготипКартинка;    
		Иначе
			ВнешняяКомпонента.ЛоготипКартинка = "";
		КонецЕсли;
		Если ПараметрыШтрихкода.Свойство("ЛоготипРазмерПроцентОтШК") И Не ПустаяСтрока(ПараметрыШтрихкода.ЛоготипРазмерПроцентОтШК) Тогда 
			ВнешняяКомпонента.ЛоготипРазмерПроцентОтШК = ПараметрыШтрихкода.ЛоготипРазмерПроцентОтШК;
		КонецЕсли;
	КонецЕсли;
		
	// Сформируем картинку
	ДвоичныеДанныеКартинки = ВнешняяКомпонента.ПолучитьШтрихкод();
	РезультатОперации.Результат = ВнешняяКомпонента.Результат = 0;
	// Если картинка сформировалась.
	Если ДвоичныеДанныеКартинки <> Неопределено Тогда
		РезультатОперации.ДвоичныеДанные = ДвоичныеДанныеКартинки;
		РезультатОперации.Картинка = Новый Картинка(ДвоичныеДанныеКартинки); // Формируем из двоичных данных.
	КонецЕсли;
	
	Возврат РезультатОперации;
	
КонецФункции

#КонецОбласти