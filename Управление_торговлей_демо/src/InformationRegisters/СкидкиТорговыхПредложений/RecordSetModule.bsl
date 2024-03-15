#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ Тогда
		ПараметрыИзменения = ТорговыеПредложенияСлужебный.НовыйПараметрыИзмененияСостоянияТорговыхПредложений();
		ПараметрыИзменения.ТорговыеПредложения.Добавить(Отбор.ТорговоеПредложение.Значение);
		РегистрыСведений.СостоянияСинхронизацииТорговыеПредложения.ИзменитьСостояниеПубликацииПрайсЛистов(ПараметрыИзменения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли