///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиТекущемуПользователю() <> Истина Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// Если включено разделение данных, и мы зашли в неразделенном сеансе,
		//  то нельзя устанавливать пользовательские свойства новости.
		// Зашли в конфигурацию под пользователем без разделения (и не вошли в область данных).
		Если ИнтернетПоддержкаПользователей.СеансЗапущенБезРазделителей() Тогда
			Элементы.ГруппаКоманднаяПанель.Видимость = Ложь;
			ПолучитьТекущегоПользователя = Ложь;
		Иначе
			ПолучитьТекущегоПользователя = Истина;
		КонецЕсли;
	Иначе
		ПолучитьТекущегоПользователя = Истина;
	КонецЕсли;

	Если ПолучитьТекущегоПользователя = Истина Тогда
		ЭтотОбъект.ПараметрыСеанса_ТекущийПользователь = Пользователи.ТекущийПользователь();
	Иначе
		ЭтотОбъект.ПараметрыСеанса_ТекущийПользователь = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;

	Если ВРег(Параметры.РежимОткрытияОкна) = ВРег("БлокироватьОкноВладельца") Тогда
		ЭтотОбъект.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе // Все остальные значения
		// По-умолчанию - независимое открытие.
		ЭтотОбъект.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
	КонецЕсли;

	ЭтотОбъект.ЗаголовокФормы = Параметры.Заголовок;
	Если ПустаяСтрока(ЭтотОбъект.ЗаголовокФормы) = Истина Тогда
		ЭтотОбъект.ЗаголовокФормы = НСтр("ru='Новости'");
	КонецЕсли;

	Если (Параметры.ПоказыватьПанельНавигации = Истина)
			И (ОбработкаНовостейПовтИсп.ЕстьРолиЧтенияНовостей()) Тогда
		Элементы.ГруппаНавигация.Видимость = Истина;
	Иначе
		Элементы.ГруппаНавигация.Видимость = Ложь;
	КонецЕсли;

#Область ЗаполнитьТаблицуНовостей

	// Последовательность подготовки новостей для показа
	//  - поиск новостей:
	//    -- ОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере;
	//      -- переопределение: ОбработкаНовостейПереопределяемый.ДополнительноОбработатьМассивКонтекстныхНовостей;
	//  - отображение новостей:
	//    -- ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии;
	//      -- переопределение: ОбработкаНовостейКлиентПереопределяемый.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии_ПередСтандартнойОбработкой;
	//      -- переопределение: ОбработкаНовостейКлиентПереопределяемый.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии_ПослеСтандартнойОбработки;
	//      -- переопределение: ОбработкаНовостейКлиентПереопределяемый.ПереопределитьПараметрыОткрытияФормыСпискаОченьВажныхКонтекстныхНовостей (только очень важные новости);
	//    -- ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриПроизвольномСобытии;
	// Переопределить новости, которые должны попасть в СписокНовостей, можно в переопределениях.

	ЭтотОбъект.СписокНовостей.Очистить();
	Для Каждого ТекущаяНовость Из Параметры.СписокНовостей Цикл
		ЭтотОбъект.СписокНовостей.Добавить(ТекущаяНовость.Значение, ТекущаяНовость.Значение.УИННовости);
	КонецЦикла;

#КонецОбласти

	ЭтотОбъект.Заголовок = ЭтотОбъект.ЗаголовокФормы + " (" + ЭтотОбъект.СписокНовостей.Количество() + ")";

	ЭтотОбъект.ТекстНовостей = ОбработкаНовостей.ПолучитьХТМЛТекстНовостей(
		ЭтотОбъект.СписокНовостей.ВыгрузитьЗначения(), // Для массива нельзя вызывать ПовтИсп.
		Новый Структура("ОтображатьЗаголовок", Истина));

	ЭтотОбъект.ОповещениеВключено = Истина; // Для списка новостей (в отличие от одной новости) пользователю необходимо вручную отключить оповещение.

	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьФормуОченьВажныхНовостейПриСозданииНаСервере(
		ЭтотОбъект,
		Отказ,
		СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если ЗавершениеРаботы = Истина Тогда
		// Запрещены серверные вызовы и открытие форм.
		// В таком исключительном случае, когда выходят из программы,
		//  можно проигнорировать установку признака прочтенности у новостей.
	Иначе

		// Прочтена - При закрытии помечать все новости как прочитанные.
		// ОповещениеВключено - в зависимости от установленной галочки.

		Для Каждого ТекущаяНовость Из ЭтотОбъект.СписокНовостей Цикл
			Оповестить(
				"Новости. Новость прочтена",
				Истина,
				ТекущаяНовость.Значение);
			Оповестить(
				"Новости. Изменено состояние оповещения о новости",
				ЭтотОбъект.ОповещениеВключено,
				ТекущаяНовость.Значение);
		КонецЦикла;

		Если НЕ ЭтотОбъект.ПараметрыСеанса_ТекущийПользователь.Пустая() Тогда
			СписокОчисткиКонтекстныхНовостей = ЗаписатьИзменениеСостоянияНовостиСервер(
				ЭтотОбъект.СписокНовостей,
				ЭтотОбъект.ОповещениеВключено,
				ЭтотОбъект.ПараметрыСеанса_ТекущийПользователь);

			// Для новостей с отключенным признаком Оповещение очистить кэш контекстных новостей.
			Если ЭтотОбъект.ОповещениеВключено = Ложь Тогда
				Для Каждого ПараметрыКонтекстнойНовости Из СписокОчисткиКонтекстныхНовостей Цикл
					ОбработкаНовостейКлиент.УдалитьКонтекстныеНовостиИзКэшаПриложения(
						ПараметрыКонтекстнойНовости.Значение,
						ПараметрыКонтекстнойНовости.Представление);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ОбработкаНовостейКлиент.ПросмотрНовости_ОбработкаОповещения(ИмяСобытия, Параметр, Источник, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстНовостейПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)

	ОбработкаНовостейКлиент.ОбработкаНажатияВТекстеНовости(
		ЭтотОбъект.СписокНовостей,
		ДанныеСобытия,
		СтандартнаяОбработка,
		ЭтотОбъект,
		Элемент);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаБольшеНеПоказывать(Команда)

	ЭтотОбъект.ОповещениеВключено = Ложь;
	ЭтотОбъект.Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказатьПозже(Команда)

	ЭтотОбъект.ОповещениеВключено = Истина;
	ЭтотОбъект.Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
// Функция записывает регистр сведений "СостоянияНовостей".
// Также подготавливается список данных для очистки кэша контекстных новостей.
//
// Параметры:
//  лкСписокНовостей      - СписокЗначений - список новостей;
//  лкОповещениеВключено  - Булево;
//  лкТекущийПользователь - СправочникСсылка.Пользователи.
//
// Возвращаемое значение:
//   СписокЗначений - список данных, для которых надо очистить кэш контекстных новостей:
//     * Значение - ИдентификаторМетаданных;
//     * Представление - ИдентификаторФормы.
//
Функция ЗаписатьИзменениеСостоянияНовостиСервер(лкСписокНовостей, лкОповещениеВключено, лкТекущийПользователь)

	СписокДанныхДляОчисткиКэшаКонтекстныхНовостей = Новый СписокЗначений;

	Для Каждого ТекущаяНовость Из лкСписокНовостей Цикл
		Запись = РегистрыСведений.СостоянияНовостей.СоздатьМенеджерЗаписи();
		Запись.Пользователь = лкТекущийПользователь;
		Запись.Новость      = ТекущаяНовость.Значение;
		Запись.Прочитать(); // Запись будет ниже. // На тот случай, если были установлены другие свойства
		// Вдруг новость не выбрана (т.е. ее нет в базе) - перезаполнить менеджер записи и записать.
		Запись.Пользователь         = лкТекущийПользователь;
		Запись.Новость              = ТекущаяНовость.Значение;
		Запись.Прочтена             = Истина; // Всегда устанавливать прочтенность
		// Запись.Пометка Не трогать.
		Запись.ОповещениеВключено   = лкОповещениеВключено;
		// Запись.ДатаНачалаОповещения Не трогать.
		Запись.Записать(Истина);
	КонецЦикла;

	Если лкОповещениеВключено = Ложь Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Спр.Метаданные КАК ИдентификаторМетаданных,
			|	Спр.Форма      КАК ИдентификаторФормы
			|ИЗ
			|	Справочник.Новости.ПривязкаКМетаданным КАК Спр
			|ГДЕ
			|	Спр.Ссылка В (&МассивНовостейДляОчисткиКэшаКонтекстныхНовостей)
			|";
		Запрос.УстановитьПараметр("МассивНовостейДляОчисткиКэшаКонтекстныхНовостей", лкСписокНовостей.ВыгрузитьЗначения());

		Результат = Запрос.Выполнить(); // ЗаписатьИзменениеСостоянияНовостиСервер()
		Если НЕ Результат.Пустой() Тогда
			Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.Прямой);
			Пока Выборка.Следующий() Цикл
				СписокДанныхДляОчисткиКэшаКонтекстныхНовостей.Добавить(
					Выборка.ИдентификаторМетаданных,
					Выборка.ИдентификаторФормы);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	Возврат СписокДанныхДляОчисткиКэшаКонтекстныхНовостей;

КонецФункции

#КонецОбласти
