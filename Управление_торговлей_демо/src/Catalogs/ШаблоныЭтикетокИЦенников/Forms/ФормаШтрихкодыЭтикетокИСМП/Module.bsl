#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СразуНаПринтер               = Параметры.СразуНаПринтер;
	КоличествоЭкземпляров = 1;
	НазначениеШаблона     = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаКодМаркировкиИСМП;
	ШаблонЭтикетки        = Параметры.ШаблонЭтикетки;
	
	Если Не ЗначениеЗаполнено(ШаблонЭтикетки) Тогда
		ШаблонЭтикетки = Справочники.ШаблоныЭтикетокИЦенников.ШаблонПоУмолчанию(НазначениеШаблона);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.АдресВХранилище) Тогда
		АдресВХранилище = ПоместитьВоВременноеХранилище(
			ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище),
			УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ИмяОбработкиПечатьЭтикетокИЦенников = ЦенообразованиеКлиент.ИмяОбработкиПечатьЭтикетокИЦенников();
	
	ПараметрКоманды = Новый Массив;
	ПараметрКоманды.Добавить(ПредопределенноеЗначение("Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка"));
	
	ПараметрыПечати = Новый Структура("КоличествоЭкземпляров, АдресВХранилище, КаждаяЭтикеткаНаНовомЛисте",
		1,
		ПоместитьВоВременноеХранилище(ДанныеПечатиСЗаполненнымШаблоном(), УникальныйИдентификатор),
		Истина);
	ПараметрыПечати.Вставить("СразуНаПринтер", СразуНаПринтер);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		ИмяОбработкиПечатьЭтикетокИЦенников,
		"ЭтикеткаКодМаркировкиИСМП",
		ПараметрКоманды,
		Неопределено,
		ПараметрыПечати);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДанныеПечатиСЗаполненнымШаблоном()
	
	ДанныеПечати = ПолучитьИзВременногоХранилища(АдресВХранилище);
	
	Для Каждого СтрокаПечати Из ДанныеПечати.ОбъектыПечати Цикл
		СтрокаПечати.ШаблонЭтикетки = ШаблонЭтикетки;
	КонецЦикла;
	
	Возврат ДанныеПечати;
	
КонецФункции

#КонецОбласти