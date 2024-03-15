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

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// Описание параметров процедуры см. в ТекущиеДелаСлужебный.НоваяТаблицаТекущихДел().
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ИмяФормы = Метаданные.Обработки.ЖурналДокументовОтчетыКомитентам.Формы.СписокДокументов.ПолноеИмя();
	
	ОбщиеПараметрыЗапросов = ТекущиеДелаСервер.ОбщиеПараметрыЗапросов();
	
	// Определим доступны ли текущему пользователю показатели группы
	Доступность =
		(ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь
			Или ПравоДоступа("Просмотр", Метаданные.Документы.ОтчетКомитенту))
		И (ПравоДоступа("Добавление", Метаданные.Документы.ОтчетКомитенту)
			ИЛИ ПравоДоступа("Добавление", Метаданные.Документы.ОтчетКомитентуОСписании))
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКОформлениюОтчетовКомитенту)
		И ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриЗакупках");
		
	Если НЕ Доступность Тогда
		Возврат;
	КонецЕсли;
	
	// Расчет показателей
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СУММА(ВложенныйЗапрос.КоличествоДокументов) КАК ОтчетыКомитентамТребуетсяОформить
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВложенныйЗапрос.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|		ВложенныйЗапрос.ПериодСписания КАК ПериодСписания,
	|		ВложенныйЗапрос.Валюта КАК Валюта,
	|		ВложенныйЗапрос.Организация КАК Организация,
	|		ВложенныйЗапрос.ВладелецТовара КАК ВладелецТовара,
	|		ВложенныйЗапрос.Контрагент КАК Контрагент,
	|		ВложенныйЗапрос.Соглашение КАК Соглашение,
	|		ВложенныйЗапрос.Договор КАК Договор,
	|		ВложенныйЗапрос.НалогообложениеНДС КАК НалогообложениеНДС,
	|		1 КАК КоличествоДокументов
	|	ИЗ
	|		(ВЫБРАТЬ
	|			0 КАК ХозяйственнаяОперация,
	|			NULL КАК ПериодСписания,
	|			ТоварыКОформлению.Валюта КАК Валюта,
	|			ТоварыКОформлению.ВидЗапасов.Организация КАК Организация,
	|			ТоварыКОформлению.ВидЗапасов.ВладелецТовара КАК ВладелецТовара,
	|			ТоварыКОформлению.ВидЗапасов.Контрагент КАК Контрагент,
	|			ТоварыКОформлению.ВидЗапасов.Соглашение КАК Соглашение,
	|			ТоварыКОформлению.ВидЗапасов.Договор КАК Договор,
	|			ТоварыКОформлению.ВидЗапасов.НалогообложениеНДС КАК НалогообложениеНДС,
	|			СУММА(ТоварыКОформлению.КоличествоСписаноКОформлениюОстаток) КАК Количество
	|		ИЗ
	|			РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту.Остатки(, ) КАК ТоварыКОформлению
	|		ГДЕ
	|			ТоварыКОформлению.ВидЗапасов.ВладелецТовара ССЫЛКА Справочник.Партнеры
	|			И ТоварыКОформлению.КоличествоСписаноКОформлениюОстаток <> 0
	|
	|		СГРУППИРОВАТЬ ПО
	|			0,
	|			ТоварыКОформлению.Валюта,
	|			ТоварыКОформлению.ВидЗапасов.Организация,
	|			ТоварыКОформлению.ВидЗапасов.ВладелецТовара,
	|			ТоварыКОформлению.ВидЗапасов.Контрагент,
	|			ТоварыКОформлению.ВидЗапасов.Соглашение,
	|			ТоварыКОформлению.ВидЗапасов.Договор,
	|			ТоварыКОформлению.ВидЗапасов.НалогообложениеНДС
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			0 КАК ХозяйственнаяОперация,
	|			NULL,
	|			УслугиКОформлению.Валюта,
	|			УслугиКОформлению.Организация,
	|			Партнер.Ссылка,
	|			НЕОПРЕДЕЛЕНО КАК Контрагент,
	|			УслугиКОформлению.Соглашение,
	|			НЕОПРЕДЕЛЕНО,
	|			НЕОПРЕДЕЛЕНО,
	|			NULL
	|		ИЗ
	|			РегистрНакопления.УслугиКОформлениюОтчетовПринципалу.Остатки(, ) КАК УслугиКОформлению
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнер
	|				ПО УслугиКОформлению.АналитикаУчетаНоменклатуры.Партнер = Партнер.Ссылка
	|		ГДЕ
	|			УслугиКОформлению.АналитикаУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Партнер)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			1,
	|			УслугиКОформлению.Валюта,
	|			УслугиКОформлению.Организация,
	|			Партнер.Ссылка,
	|			УслугиКОформлению.Соглашение
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			1 КАК ХозяйственнаяОперация,
	|			NULL,
	|			Остатки.Валюта,
	|			Остатки.ВидЗапасов.Организация,
	|			Остатки.ВидЗапасов.ВладелецТовара,
	|			Остатки.ВидЗапасов.Контрагент,
	|			Остатки.ВидЗапасов.Соглашение,
	|			Остатки.ВидЗапасов.Договор,
	|			Остатки.ВидЗапасов.НалогообложениеНДС,
	|			СУММА(Остатки.КоличествоКОформлениюОстаток)
	|		ИЗ
	|			РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту.Остатки(, ) КАК Остатки
	|		ГДЕ
	|			Остатки.ВидЗапасов.ВладелецТовара ССЫЛКА Справочник.Партнеры
	|			И Остатки.КоличествоКОформлениюОстаток <> 0
	|		
	|		СГРУППИРОВАТЬ ПО
	|			1,
	|			Остатки.Валюта,
	|			Остатки.ВидЗапасов.Организация,
	|			Остатки.ВидЗапасов.ВладелецТовара,
	|			Остатки.ВидЗапасов.Контрагент,
	|			Остатки.ВидЗапасов.Соглашение,
	|			Остатки.ВидЗапасов.Договор,
	|			Остатки.ВидЗапасов.НалогообложениеНДС) КАК ВложенныйЗапрос
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ВложенныйЗапрос.ХозяйственнаяОперация,
	|		ВложенныйЗапрос.ПериодСписания,
	|		ВложенныйЗапрос.Валюта,
	|		ВложенныйЗапрос.Организация,
	|		ВложенныйЗапрос.ВладелецТовара,
	|		ВложенныйЗапрос.Контрагент,
	|		ВложенныйЗапрос.Соглашение,
	|		ВложенныйЗапрос.Договор,
	|		ВложенныйЗапрос.НалогообложениеНДС) КАК ВложенныйЗапрос";
	
	Результат = ТекущиеДелаСервер.ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов);
	
	// Заполнение дел.
	// ОтчетыКомиссионеров
	ДелоРодитель = ТекущиеДела.Добавить();
	ДелоРодитель.Идентификатор  = "ОтчетыКомитентам";
	ДелоРодитель.Представление  = НСтр("ru = 'Отчеты комитентам'");
	ДелоРодитель.ЕстьДела       = Результат.ОтчетыКомитентамТребуетсяОформить > 0;
	ДелоРодитель.Владелец       = Метаданные.Подсистемы.Закупки;
	
	// ОтчетыКомитентамТребуетсяОформить
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ВладелецТовара", Справочники.Партнеры.ПустаяСсылка());
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	ПараметрыФормы.Вставить("ИмяТекущейСтраницы", "СтраницаРаспоряженияНаОформление");
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ОтчетыКомитентамТребуетсяОформить";
	Дело.ЕстьДела       = Результат.ОтчетыКомитентамТребуетсяОформить > 0;
	Дело.Представление  = НСтр("ru = 'Требуется оформить'");
	Дело.Количество     = Результат.ОтчетыКомитентамТребуетсяОформить;
	Дело.Важное         = Ложь;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = ПараметрыФормы;
	Дело.Владелец       = "ОтчетыКомитентам";
	
КонецПроцедуры

#КонецОбласти

Функция КлючНазначенияФормыПоУмолчанию() Экспорт
	
	Возврат "ДокументыОтчетыКомитентам";
	
КонецФункции

#КонецОбласти

#КонецЕсли