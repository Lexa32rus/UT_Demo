
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
	
	ОткрытьФорму("Документ.РасходныйКассовыйОрдер.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти
