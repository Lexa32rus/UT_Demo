
&НаКлиентеНаСервереБезКонтекста
Функция ШаблонШтрихкода(Весовой, Диапазон, ДиапазонУзлаШтрихкода)
	
	Если НЕ Весовой Тогда
		Код = "ТТТТТТТТТ"; //@NON-NLS
	Иначе
		Код = "ТТТТВВВВВ"; //@NON-NLS
	КонецЕсли;
	
	Возврат Диапазон + "У" + Код + "К"; //@NON-NLS-1 //@NON-NLS-2
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция НастроитьФорму(Форма)
	
	Форма.Элементы.ДекорацияПрефиксУзлаШтрихкода.Заголовок = " - " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Префикс узла штрихкода (В данном узле %1)'"),
		Форма.ПрефиксУзлаШтрихкода);
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПрефиксУзлаШтрихкода = РегистрыСведений.ШтрихкодыНоменклатуры.ПрефиксУзлаШтрихкода();
	
	НастроитьФорму(ЭтаФорма);
	
	НастройкиДиапазоновШтрихкодов = РегистрыСведений.ШтрихкодыНоменклатуры.НастройкиДиапазоновШтрихкодов();
	Для Каждого СтрокаТЧ Из НастройкиДиапазоновШтрихкодов Цикл
		Настройка = Диапазоны.Добавить();
		Настройка.Весовой  = СтрокаТЧ.Весовой;
		Настройка.Диапазон = СтрокаТЧ.Диапазон;
		Настройка.ШаблонШтрихкода = ШаблонШтрихкода(Настройка.Весовой, Настройка.Диапазон, ПрефиксУзлаШтрихкода);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	
	Константы.НастройкиПрефиксацииШтрихкодов.Установить(Новый ХранилищеЗначения(Диапазоны.Выгрузить(,"Весовой, Диапазон")));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНаСервере();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДиапазоныТипШтрихкодаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Диапазоны.ТекущиеДанные;
	ТекущаяСтрока.ШаблонШтрихкода = ШаблонШтрихкода(ТекущаяСтрока.Весовой, ТекущаяСтрока.Диапазон, ПрефиксУзлаШтрихкода);
	
КонецПроцедуры
