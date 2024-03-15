////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен с банками. Выплаты самозанятым".
// Модуль предназначен для размещения переопределяемых процедур подсистемы.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПолучениеДанныхВыгружаемогоДокумента

// Возвращает данные в виде структуры по связанному документу ПлатежноеПоручение
//
// Параметры:
//		РеестрВыплатыСамозанятым - ДокументСсылка
//		ДанныеПлатежногоПоручения - Структура - структура задается функцией-конструктором ОбменСБанкамиВыплатыСамозанятымСлужебный.ДанныеПлатежногоПоручения()
//
Процедура ДанныеПлатежногоПорученияРеестраВыплатСамозанятым(РеестрВыплатыСамозанятым, ДанныеПлатежногоПоручения) Экспорт
	
КонецПроцедуры

// Получает данные документов из документа РеестрВыплатыСамозанятым и заполняет данные в структуре ДанныеДокументов 
//
// Параметры:
//		РеестрВыплатыСамозанятым - ДокументСсылка - ссылка на документ,
//										по которому требуется получить данные.
//		ДанныеДокумента - Структура - структура задается функцией-конструктором 
//										ОбменСБанкамиВыплатыСамозанятымСлужебный.ДанныеЗаполненияРеестрВыплатСамозанятым()
//		
Процедура ДанныеРеестраВыплатСамозанятым(РеестрВыплатыСамозанятым, ДанныеДокумента) Экспорт
		
КонецПроцедуры

#КонецОбласти

#Область ЗаписьДанныхВЗагружаемыйДокумент

// Осуществляет загрузку информации по чекам самозанятых в документ Выплаты самозанятым
//
// Параметры:
//		ДанныеЗаполнения - Структура - данные для заполнения информации по чекам
//			- ОбщиеДанные - Структура - данные для заполнения обшей информации по чекам, 
//								определяется функцией-конструктором ОбменСБанкамиВыплатыСамозанятымСлужебный.ДанныеЗаполненияОбщиеДанные()
//			- МассивЧеков - Массив - массив из структур ДанныеЗаполненияЧекСамозанятого
//				* ДанныеЗаполненияЧекСамозанятого - Структура - данные для заполнения информации по чекам по каждому самозянятому, 
//						определяется функцийей-конструктором ОбменСБанкамиВыплатыСамозанятымСлужебный.ДанныеЗаполненияЧекСамозанятого()
//			- КонтрольныеСуммы - Струкутра - данные для контроля заполнения
//				* КоличествоЗаписей - Число - количество записей про выплаты самозанятым
//				* СуммаИтого - Число - итоговая сумма, выплаченная самозанятым банком
//		СсылкаНаДокумент - ДокументСсылка - документ, в котором происходит заполнение данных
//
Процедура ПриЗагрузкеРеестраЧековВыплатСамозанятым(ДанныеЗаполнения, СсылкаНаДокумент) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
