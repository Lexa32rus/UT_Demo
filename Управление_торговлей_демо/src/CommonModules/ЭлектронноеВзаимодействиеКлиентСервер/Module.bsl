////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеКлиентСервер: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует служебную структуру, которая может быть использована для указания параметров обработки ошибок для
// реквизитов дерева данных электронного документа.
//
// Параметры:
//  КлючДанных			 - ЛюбаяСсылка - ключ данных для обработки через сообщение пользователю (см. СообщениеПользователю).
//  ПутьКДанным			 - Строка - путь к данным для обработки через сообщение пользователю (см. СообщениеПользователю).
//  НавигационнаяСсылка	 - Строка - навигационная ссылка, по которой нужно перейти при клике на ошибку.
//  ИмяФормы			 - Строка - имя формы, которую нужно открыть при клике на ошибку.
//  ПараметрыФормы		 - Структура - параметры, передаваемые в форму, открываемую при клике на ошибку.
//  ТекстОшибки			 - Строка - используется для переопределения стандартного текста ошибки.
// 
// Возвращаемое значение:
//  Структура - см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки.
//
Функция НовыеПараметрыОбработкиОшибки(КлючДанных = Неопределено, ПутьКДанным = "", НавигационнаяСсылка = "", ИмяФормы = "",
	ПараметрыФормы = Неопределено, ТекстОшибки = "") Экспорт

	Возврат ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки(КлючДанных, ПутьКДанным,
		НавигационнаяСсылка, ИмяФормы, ПараметрыФормы, ТекстОшибки);

КонецФункции

#КонецОбласти