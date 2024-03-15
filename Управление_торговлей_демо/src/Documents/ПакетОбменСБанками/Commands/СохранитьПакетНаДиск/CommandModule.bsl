#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДанныеФайла = ДанныеПрисоединенногоФайлаПакетаНаСервере(ПараметрКоманды);
	
	Если ЗначениеЗаполнено(ДанныеФайла) Тогда
		ПолучитьФайл(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла, ДанныеФайла.ИмяФайла);
	ИначеЕсли ЭтоОбменЧерезДополнительнуюОбработку(ПараметрКоманды, ДанныеФайла) Тогда
		ПолучитьФайл(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла, ДанныеФайла.ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДанныеПрисоединенногоФайлаПакетаНаСервере(Пакет)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПрисоединенныеФайлы.Ссылка
	|ИЗ
	|	Справочник.ПакетОбменСБанкамиПрисоединенныеФайлы КАК ПрисоединенныеФайлы
	|ГДЕ
	|	ПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла";
	
	Запрос.УстановитьПараметр("ВладелецФайла", Пакет);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	Если РезультатЗапроса.Следующий() Тогда
		
		Возврат РаботаСФайлами.ДанныеФайла(РезультатЗапроса.Ссылка);
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ЭтоОбменЧерезДополнительнуюОбработку(Пакет, ДанныеФайла)
	
	НастройкаОбмена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пакет, "НастройкаОбмена");
	ПрограммаБанка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаОбмена, "ПрограммаБанка");
	Если ПрограммаБанка = Перечисления.ПрограммыБанка.ОбменЧерезДопОбработку
		ИЛИ ПрограммаБанка = Перечисления.ПрограммыБанка.ОбменЧерезВК Тогда
		СообщенияОбмена = ОбменСБанкамиСлужебный.СообщенияОбменаВПакете(Пакет);
		Для каждого СообщениеОбмена Из СообщенияОбмена Цикл
			ВидЭД = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СообщениеОбмена, "ВидЭД");
			Если ВидЭД = Перечисления.ВидыЭДОбменСБанками.ПлатежноеПоручение Тогда
				ДвоичныеДанныеФайла = ОбменСБанкамиСлужебный.ДанныеФайлаДляТехническойПоддержки(СообщениеОбмена);
				Если ДвоичныеДанныеФайла = Неопределено Тогда
					ТекстСообщения = НСтр("ru = 'Не обнаружен присоединенный файл объекта.'");
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, СообщениеОбмена);
				Иначе
					СсылкаНаФайл = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
					ИмяФайла = Строка(СообщениеОбмена);
					ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла) + ".zip";
					ИмяФайла = СтроковыеФункции.СтрокаЛатиницей(ИмяФайла);
					ДанныеФайла = Новый Структура("СсылкаНаДвоичныеДанныеФайла, ИмяФайла", СсылкаНаФайл, ИмяФайла);
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Возврат Истина
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции


#КонецОбласти