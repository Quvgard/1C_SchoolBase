﻿
&НаКлиенте
Процедура КлассПриИзменении(Элемент)
	ОбновлениеИнформации(); 
	Объект.КлассНаМоментЗаписи = Объект.Класс;
КонецПроцедуры

&НаКлиенте
Процедура ГодУчебыСПриИзменении(Элемент)
	ОбновлениеИнформации();
КонецПроцедуры

&НаКлиенте
Процедура ГодУчебыПоПриИзменении(Элемент)
	ОбновлениеИнформации();
КонецПроцедуры

&НаСервере
Процедура ОбновлениеИнформации()
	Если НЕ Объект.ГодУчебыС = Дата('00010101') И 
		НЕ Объект.ГодУчебыПо = Дата('00010101') Тогда
		Объект.Ученики.Очистить();
		МассивДанных = ПолучитьЗаписиРегистра(Объект.Класс);
		Для Каждого Стр Из МассивДанных Цикл 
			СтрокаТЧ = Объект.Ученики.Добавить();
			СтрокаТЧ.Ученик = Стр.Ученики;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры                       

&НаСервере
Функция ПолучитьЗаписиРегистра(Класс)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Ученики.Ссылка КАК Ученики,
	|	Ученики.Наименование КАК Наименование
	|ИЗ
	|	Справочник.Ученики КАК Ученики
	|ГДЕ
	|	Ученики.Класс = &Класс
	|	И Ученики.ПометкаОВыпуске <> Истина"; 
	
	Запрос.УстановитьПараметр("Класс", Класс);
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	МассивДанных = Новый Массив;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Данные = Новый Структура;
		Данные.Вставить("Ученики",ВыборкаДетальныеЗаписи.Ученики);
		МассивДанных.Добавить(Данные);
	КонецЦикла;
	
	Возврат МассивДанных;
КонецФункции

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	КлассСсылка = Справочники.Классы.НайтиПоНаименованию(Объект.Класс);    
	КлассОбъект = КлассСсылка.ПолучитьОбъект();
	КлассОбъект.Класс = КлассОбъект.Класс + 1;
	КлассОбъект.Наименование = "" + КлассОбъект.Класс + " '" + КлассОбъект.Буква + "'";
	КлассОбъект.Записать();

КонецПроцедуры

