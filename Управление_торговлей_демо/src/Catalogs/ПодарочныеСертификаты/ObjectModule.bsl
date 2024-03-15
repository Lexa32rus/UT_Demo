#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыПодарочныхСертификатов.ТипКарты КАК ТипКарты
	|ИЗ
	|	Справочник.ВидыПодарочныхСертификатов КАК ВидыПодарочныхСертификатов
	|ГДЕ
	|	ВидыПодарочныхСертификатов.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", Владелец);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Выборка.Следующий();
	
	Если ЗначениеЗаполнено(Штрихкод) И (Выборка.ТипКарты = Перечисления.ТипыКарт.Штриховая ИЛИ Выборка.ТипКарты = Перечисления.ТипыКарт.Смешанная) Тогда
		
		ПодарочныеСертификаты = ПодарочныеСертификатыВызовСервера.НайтиПодарочныеСертификатыПоШтрихкоду(Штрихкод);
		Для Каждого СтрокаТЧ Из ПодарочныеСертификаты.ЗарегистрированныеПодарочныеСертификаты Цикл
			Если СтрокаТЧ.Ссылка <> Ссылка И СтрокаТЧ.ВидПодарочногоСертификата = Владелец Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Такой штрихкод уже зарегистрирован для подарочного сертификата ""%1""'"), СтрокаТЧ.Ссылка),
					ЭтотОбъект,
					"Штрихкод",
					,
					Отказ);
			КонецЕсли;
		КонецЦикла;
		
		СертификатСоответствуетДиапазону = Ложь;
		ВозможныеВидыСертификатов = ПодарочныеСертификатыСервер.ПолучитьВозможныеВидыПодарочныхСертификатовПоКодуПодарочногоСертификата(Штрихкод, Перечисления.ТипыКодовКарт.Штрихкод);
		Для Каждого ВозможныйВидСертификата Из ВозможныеВидыСертификатов Цикл
			Если ВозможныйВидСертификата = Владелец Тогда
				СертификатСоответствуетДиапазону = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если НЕ СертификатСоответствуетДиапазону Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Штрихкод не входит в допустимый диапазон штрихкодов ""%1""'"), Владелец),
				ЭтотОбъект,
				"Штрихкод",
				,
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МагнитныйКод) И (Выборка.ТипКарты = Перечисления.ТипыКарт.Магнитная ИЛИ Выборка.ТипКарты = Перечисления.ТипыКарт.Смешанная) Тогда
		
		ПодарочныеСертификаты = ПодарочныеСертификатыВызовСервера.НайтиПодарочныеСертификатыПоМагнитномуКоду(МагнитныйКод);
		Для Каждого СтрокаТЧ Из ПодарочныеСертификаты.ЗарегистрированныеПодарочныеСертификаты Цикл
			Если СтрокаТЧ.Ссылка <> Ссылка И СтрокаТЧ.ВидПодарочногоСертификата = Владелец Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Такой магнитный код уже зарегистрирован для подарочного сертификата ""%1""'"), СтрокаТЧ.Ссылка),
					ЭтотОбъект,
					"МагнитныйКод",
					,
					Отказ);
			КонецЕсли;
		КонецЦикла;
		
		СертификатСоответствуетДиапазону = Ложь;
		ВозможныеВидыСертификатов = ПодарочныеСертификатыСервер.ПолучитьВозможныеВидыПодарочныхСертификатовПоКодуПодарочногоСертификата(МагнитныйКод, Перечисления.ТипыКодовКарт.МагнитныйКод);
		Для Каждого ВозможныйВидСертификата Из ВозможныеВидыСертификатов Цикл
			Если ВозможныйВидСертификата = Владелец Тогда
				СертификатСоответствуетДиапазону = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если НЕ СертификатСоответствуетДиапазону Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Магнитный код не входит в допустимый диапазон штрихкодов ""%1""'"), Владелец),
				ЭтотОбъект,
				"МагнитныйКод",
				,
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если Выборка.ТипКарты = Перечисления.ТипыКарт.Магнитная Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Штрихкод");
	КонецЕсли;
	Если Выборка.ТипКарты = Перечисления.ТипыКарт.Штриховая Тогда
		МассивНепроверяемыхРеквизитов.Добавить("МагнитныйКод");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыПодарочныхСертификатов.ТипКарты КАК ТипКарты
	|ИЗ
	|	Справочник.ВидыПодарочныхСертификатов КАК ВидыПодарочныхСертификатов
	|ГДЕ
	|	ВидыПодарочныхСертификатов.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Владелец);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Если Выборка.ТипКарты = Перечисления.ТипыКарт.Магнитная Тогда
		Штрихкод = "";
	КонецЕсли;
	
	Если Выборка.ТипКарты = Перечисления.ТипыКарт.Штриховая Тогда
		МагнитныйКод = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
