#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область Команды

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт

КонецПроцедуры

#Область ФормированиеГиперссылкиВЖурналеПродаж

Функция СформироватьГиперссылкуКОформлению(Параметры) Экспорт
	
	ПоказыватьЗаказы = ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах")
		И ПравоДоступа("Чтение", Метаданные.Документы.ОтчетКомиссионера)
		И ПравоДоступа("Использование", Метаданные.Обработки.ЖурналДокументовОтчетыКомиссионеров);
		
	Гиперссылка = Неопределено;
	ТекстГиперссылки = НСтр("ru = 'Отчеты комиссионеров/реализации через комиссионеров'");
	
	Если ПоказыватьЗаказы Тогда
		Гиперссылка = Новый ФорматированнаяСтрока(ТекстГиперссылки,,,,
			ИмяФормыСпискаОтчетыКомиссионера());
	КонецЕсли;
	
	Возврат Гиперссылка;
	
КонецФункции

Функция ИмяФормыСпискаОтчетыКомиссионера() Экспорт
	
	Возврат "Обработка.ЖурналДокументовОтчетыКомиссионеров.Форма.КОформлениюОтчетовКомиссионеров";
	
КонецФункции

Процедура СформироватьГиперссылкуКОформлениюФоновоеЗадание(Параметры, АдресХранилища) Экспорт

	Результат = Новый Структура("КОформлению, СмТакжеВРаботе");

	МассивМенеджеровРасчетаСмТакжеВРаботе = Новый Массив();
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Документ.ОтчетКомиссионера");
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Документ.РеализацияТоваровУслуг");
	
	Результат.СмТакжеВРаботе = ОбщегоНазначенияУТ.СформироватьГиперссылкуСмТакжеВРаботе(МассивМенеджеровРасчетаСмТакжеВРаботе, Параметры[0]);

	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// Описание параметров процедуры см. в ТекущиеДелаСлужебный.НоваяТаблицаТекущихДел().
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ИмяФормы = Метаданные.Обработки.ЖурналДокументовОтчетыКомиссионеров.Формы.СписокДокументов.ПолноеИмя();
	
	ОбщиеПараметрыЗапросов = ТекущиеДелаСервер.ОбщиеПараметрыЗапросов();
	
	// Определим доступны ли текущему пользователю показатели группы
	Доступность =
		(ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь
			Или ПравоДоступа("Просмотр", Метаданные.Документы.ОтчетКомиссионера))
		И (ПравоДоступа("Добавление", Метаданные.Документы.ОтчетКомиссионера)
			ИЛИ ПравоДоступа("Добавление", Метаданные.Документы.ОтчетКомиссионераОСписании))
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыПереданныеНаКомиссию)
		И ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах");
	
	Если НЕ Доступность Тогда
		Возврат;
	КонецЕсли;
	
	// Расчет показателей
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(*) КАК ОтчетыКомиссионеровТребуетсяОформить
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ТоварыПереданные.Организация КАК Организация,
	|		ТоварыПереданные.АналитикаУчетаНоменклатуры.МестоХранения КАК Комиссионер,
	|		ТоварыПереданные.Соглашение КАК Соглашение
	|	ИЗ
	|		РегистрНакопления.ТоварыПереданныеНаКомиссию.Остатки(,
	|															АналитикаУчетаНоменклатуры.МестоХранения <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|															И АналитикаУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Партнер)) КАК ТоварыПереданные
	|	) КАК ОтчетыКомиссионеров";
	
	Результат = ТекущиеДелаСервер.ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов);
	
	// Заполнение дел.
	// ОтчетыКомиссионеров
	ДелоРодитель = ТекущиеДела.Добавить();
	ДелоРодитель.Идентификатор  = "ОтчетыКомиссионеров";
	ДелоРодитель.Представление  = НСтр("ru = 'Отчеты комиссионеров'");
	ДелоРодитель.ЕстьДела       = Результат.ОтчетыКомиссионеровТребуетсяОформить > 0;
	ДелоРодитель.Владелец       = Метаданные.Подсистемы.Продажи;
	
	// ОтчетыКомиссионеровТребуетсяОформить
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Комиссионер", Справочники.Партнеры.ПустаяСсылка());
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	ПараметрыФормы.Вставить("ИмяТекущейСтраницы", "СтраницаКомиссионеры");
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ОтчетыКомиссионеровТребуетсяОформить";
	Дело.ЕстьДела       = Результат.ОтчетыКомиссионеровТребуетсяОформить > 0;
	Дело.Представление  = НСтр("ru = 'Требуется оформить'");
	Дело.Количество     = Результат.ОтчетыКомиссионеровТребуетсяОформить;
	Дело.Важное         = Ложь;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = ПараметрыФормы;
	Дело.Владелец       = "ОтчетыКомиссионеров";
	
КонецПроцедуры

#КонецОбласти

Функция КлючНазначенияФормыПоУмолчанию() Экспорт
	
	Возврат "ДокументыОтчетыКомиссионеров";
	
КонецФункции

#КонецОбласти

#КонецЕсли