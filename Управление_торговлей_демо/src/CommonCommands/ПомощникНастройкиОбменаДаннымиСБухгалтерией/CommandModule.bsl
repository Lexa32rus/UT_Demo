#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИмяОбмена = "ОбменУправлениеТорговлейБухгалтерияПредприятия";
	ИдентификаторНастройки = ИдентификаторНастройкиОбменаБП30();

	ОбменДаннымиКлиент.ОткрытьПомощникНастройкиОбменаДанными(ИмяОбмена, ИдентификаторНастройки);
	
КонецПроцедуры

&НаСервере
Функция ИдентификаторНастройкиОбменаБП30()
	
	Возврат ОбменДаннымиЛокализация.ИдентификаторНастройкиОбменаБазовойУТБП30();
	
КонецФункции

#КонецОбласти