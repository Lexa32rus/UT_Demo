#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ДляЗаданийКЗакрытиюМесяца") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	// В форме списка регистра заданий к закрытию месяца для выбора доступны только те значения перечисления,
	// которые поддерживаются в механизме закрытия месяца.
	// см. использование функции ЗакрытиеМесяцаСервер.ПроверитьНаличиеЗаданийКЗакрытиюМесяца().
	ДанныеВыбора = Новый СписокЗначений;
	
	ДанныеВыбора.Добавить(Перечисления.ОперацииЗакрытияМесяца.ПереоценкаДенежныхСредствИФинансовыхИнструментов);
	Если ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		ДанныеВыбора.Добавить(Перечисления.ОперацииЗакрытияМесяца.ФормированиеДвиженийПоРасчетамСПартнерамиИПереоценкаРасчетов);
	КонецЕсли;
	ДанныеВыбора.Добавить(Перечисления.ОперацииЗакрытияМесяца.РаспределениеРасходовПоНаправлениямДеятельности);
	ДанныеВыбора.Добавить(Перечисления.ОперацииЗакрытияМесяца.РаспределениеДоходовПоНаправлениямДеятельности);
	ДанныеВыбора.Добавить(Перечисления.ОперацииЗакрытияМесяца.РаспределениеНДС);
	Если ПолучитьФункциональнуюОпцию("УчетДисконтированнойКредиторскойЗадолженностиПоставщикам") Тогда
		ДанныеВыбора.Добавить(Перечисления.ОперацииЗакрытияМесяца.РасчетПроцентныхРасходовДисконтирования);
	КонецЕсли;
	ЗакрытиеМесяцаЛокализация.ДополнитьДанныеВыбораОперацийЗакрытияМесяца(ДанныеВыбора);
КонецПроцедуры

#КонецОбласти

#КонецЕсли
