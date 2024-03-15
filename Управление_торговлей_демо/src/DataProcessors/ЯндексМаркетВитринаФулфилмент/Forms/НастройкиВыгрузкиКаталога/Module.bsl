
&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	ВидЦен = Константы.ЦенаПродажиЯндексМаркет.Получить(); 
	ИсточникКатегории = Константы.ИсточникКатегорииЯндексМаркет.Получить();
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаСервере
Процедура СохранитьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	Константы.ЦенаПродажиЯндексМаркет.Установить(ВидЦен); 
	Константы.ИсточникКатегорииЯндексМаркет.Установить(ИсточникКатегории);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранитьНаСервере();
	ЭтаФорма.Закрыть();
	
КонецПроцедуры
