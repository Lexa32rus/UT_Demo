
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Распоряжение", Распоряжение);
	Параметры.Свойство("СуммаКОплате", СуммаКОплате);
	Параметры.Свойство("Валюта", Валюта);
	Параметры.Свойство("Склад", Склад);
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДекорацияОтправитьСсылкуПоSMSНажатие(Элемент)
	
#Если МобильныйКлиент Тогда
	
	Если Не СредстваТелефонии.ПоддерживаетсяОтправкаSMS(Истина) Тогда
		Возврат;
	КонецЕсли;
		
	СМС = Новый SMSСообщение();
	СМС.Текст = СтрШаблон(НСтр("ru='Ссылка на оплату заказа: %1'"), СсылкаНаОплату);
	НомерТелефона = НомерТелефонаКонтактногоЛицаИзДокумента(Распоряжение);
	
	Если НомерТелефона <> "" Тогда
		СМС.Получатели.Добавить(НомерТелефона);
		СредстваТелефонии.ПослатьSMS(СМС, Истина);
	Иначе
		ТекстОшибки = НСтр("ru='Не указан номер телефона.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		Ошибка = Истина;
	КонецЕсли;
	
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОбновитьСтатусОплатыНажатие(Элемент)
	
	ПолучитьСтатусОплаты();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьКомандуПоПроцессу(Команда)
	
	Если СтатусОплаты = 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросПоСтатусуЗавершение", ЭтаФорма);
		ТекстВопроса = НСтр("ru = 'Платежный документ не создан. Продолжить?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	ПринятьОплатуИОформитьЧек(Отказ);
	
	Если Не Отказ Тогда
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПоСтатусуЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Отказ = Ложь;
		ПринятьОплатуИОформитьЧек(Отказ);
		
		Если Не Отказ Тогда
			Закрыть(Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДанныеФормы()
	
	Модуль = Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки;
	СуммаКОплатеПредставление = Модуль.СуммаКОплатеПредставление(ЭтаФорма);

//++ Локализация
	Если Не ЗначениеЗаполнено(СсылкаНаОплату) Тогда
		
		СсылкаНаОплату = ОнлайнОплаты.ПлатежнаяСсылка(Распоряжение);
		
		QRКод = Новый Картинка(ГенерацияШтрихкода.ДанныеQRКода(СсылкаНаОплату, 0, 190));
		ОбластьQRКод = Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки.ПолучитьМакет("QRКод").ПолучитьОбласть("ОбластьQRКод");
		ОбластьQRКод.Рисунки.QRКод.Картинка = QRКод;
		ТабличноеПолеQRКод.Вывести(ОбластьQRКод);
	КонецЕсли;
//-- Локализация

	СтатусОплатыПредставление = Модуль.СтатусОплатыПредставление(ЭтаФорма);
	
	Элементы.ДекорацияСуммаКОплате.Заголовок = Новый ФорматированнаяСтрока(СуммаКОплатеПредставление,
		ШрифтыСтиля.ШрифтТекстаУвеличенныйВыделенныйСборкаИДоставка,
		ЦветаСтиля.ЦветТекстаОснонойСборкаИДоставка);
		
	Элементы.ДекорацияСтатусОплаты.Заголовок =  Новый ФорматированнаяСтрока(СтатусОплатыПредставление,
		ШрифтыСтиля.ШрифтТекстаВыделенныйСборкаИДоставка,
		?(СтатусОплаты = 0, ЦветаСтиля.ЦветТекстаСтатусаВРаботеСборкаИДоставка,
			ЦветаСтиля.ЦветТекстаСтатусаГотовСборкаИДоставка));
		
	ПереопределитьТекущуюКомандуПоПроцессу();
		
КонецПроцедуры

&НаСервере
Функция НомерТелефонаКонтактногоЛицаИзДокумента(Распоряжение)
	
	Возврат Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки.НомерТелефонаКонтактногоЛицаИзДокумента(Распоряжение);
	
КонецФункции

&НаСервере
Процедура ПолучитьСтатусОплаты()
	
//++ Локализация
	Модуль = Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки;
	СтатусОплаты = Модуль.СтатусОплатыПоЯндексКассе(Распоряжение);
//-- Локализация

	ОбновитьДанныеФормы();
	
КонецПроцедуры

#Область ДействияПоПроцессу

&НаСервере
Процедура ПереопределитьТекущуюКомандуПоПроцессу()
	
	Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки.ПереопределитьТекущуюКомандуПоПроцессу(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПринятьОплатуИОформитьЧек(Отказ = Ложь) 
	
	Модуль = Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки;
	
	Если СтрНайти(ТекущееДействие, "ОформитьЧек") Тогда
		Модуль.ОформитьЧек(Распоряжение, Отказ);
	КонецЕсли;
	
	Если Не Отказ Тогда
		Модуль.ЗавершитьДоставку(Распоряжение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
