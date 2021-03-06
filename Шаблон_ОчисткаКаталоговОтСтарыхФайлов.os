﻿//*****************************************************************
// Автор: Онянов Виталий (Tavalik.ru)
// Описание: 
//		- Скрипт удаляет старые файл с указанных каталогов по маске и числу дней с последнего изменения.
// Аргументы командной строки:
//		- Нет

//***************************************************************
// ПОДКЛЮЧАЕМЫЕ БИБЛИОТЕКИ

//Логирование
#Использовать "TLog"
//Электронная почта 
#Использовать "TMail" 
//Файловые операции
#Использовать "TFile" 

//***************************************************************
// НАСТРАИВАЕМЫЕ ПАРАМЕТРЫ

ТаблицаДляОчистки = Новый ТаблицаЗначений;
ТаблицаДляОчистки.Колонки.Добавить("Путь"); 			// Строка - Путь к каталогу
ТаблицаДляОчистки.Колонки.Добавить("КоличествоДней");	// Число - Число дней с изменения, если 0 - не удалять
ТаблицаДляОчистки.Колонки.Добавить("Маска");			// Строка - Маска для поиска фалов, "" - все файлы
//Добавляем пути для очистки
НоваяСтрока = ТаблицаДляОчистки.Добавить(); НоваяСтрока.Путь = "C:\Temp\Day"; НоваяСтрока.КоличествоДней = 60;
НоваяСтрока = ТаблицаДляОчистки.Добавить(); НоваяСтрока.Путь = "C:\Temp\Month"; НоваяСтрока.КоличествоДней = 367;

// Каталог для хранения логов
ИдентификаторЗадания = "ОчисткаКаталоговОтСтарыхФайлов";
Логирование = Новый ТУправлениеЛогированием(); //TLog
Логирование.ДатаВремяВКаждойСтроке = Истина;
Логирование.ВыводитьСообщенияПриЗаписи = Истина;
КаталогХраненияЛогов = ".\_Logs\";
ХранитьЛогиДней = 365;

// Инициируем параметры для отправки сообщения
УправлениеЭП = Новый ТУправлениеЭлектроннойПочтой(); //TMail
УчетнаяЗаписьЭП = УправлениеЭП.УчетнаяЗаписьЭП;
УчетнаяЗаписьЭП.АдресSMTP = "smtp.mydomen.com";
УчетнаяЗаписьЭП.ПортSMTP = 465;  
УчетнаяЗаписьЭП.ПользовательSMTP = "report@mydomen.com";
УчетнаяЗаписьЭП.ПарольSMTP = "pass_mail";
УчетнаяЗаписьЭП.ИспользоватьSSL = Истина;

СтруктураСообщения = УправлениеЭП.СтруктураСообщения;
СтруктураСообщения.АдресЭлектроннойПочтыПолучателя = "admin@mydomen.com;";

ТемаСообщенияПриУспехе = "[The job succeeded.] " + ИдентификаторЗадания + " - ОК";
ТемаСообщенияПриОшибке = "[The job failed.] " + ИдентификаторЗадания + " - ERROR";


//***************************************************************
// ТЕЛО СКРИПТА

// Сделаем записть о начале выполнения задания
Логирование.СоздатьФайлЛога(ИдентификаторЗадания,КаталогХраненияЛогов);
Логирование.ЗаписатьСтрокуЛога("Начало выполнения задания """ + ИдентификаторЗадания + """");
Логирование.УвеличитьУровень();

БылиОшибки = Ложь;
ФайловыеОперации = Новый ТУправлениеФайловымиОперациями(); //TFile

Для Каждого СтрокаТаблицы Из ТаблицаДляОчистки Цикл

	Логирование.ЗаписатьСтрокуЛога();

	//Проверим существование каталога
	Если Не ФайловыеОперации.КаталогСуществует(СтрокаТаблицы.Путь) Тогда
		Логирование.ЗаписатьСтрокуЛога("Каталог """ + СтрокаТаблицы.Путь + " не найден!");
		Продолжить;
	КонецЕсли;
	
	//Удалим старые файлы
	Если СтрокаТаблицы.КоличествоДней > 0 Тогда
		
		Логирование.ЗаписатьСтрокуЛога("В каталоге: """ + СтрокаТаблицы.Путь + """ удаляем файлы старше " + СтрокаТаблицы.КоличествоДней + " дней");
		ФайловыеОперации.УдалитьФайлыИзмененныеБолееДнейНазад(СтрокаТаблицы.Путь,СтрокаТаблицы.КоличествоДней,,Истина);
		
		Логирование.ЗаписатьСтрокуЛога("Удаляем пустые каталоги в: " + СтрокаТаблицы.Путь);
		ФайловыеОперации.УдалитьПустыеКаталоги(СтрокаТаблицы.Путь);
		
	Иначе
		
		Логирование.ЗаписатьСтрокуЛога("Пропускаем каталог: " + СтрокаТаблицы.Путь);		
		
	КонецЕсли;

КонецЦикла;

Логирование.ЗаписатьСтрокуЛога();
Логирование.ЗаписатьСтрокуЛога("Результат выполнения задания: " + ?(БылиОшибки,"БЫЛИ ОШИБКИ","УСПЕШНОЕ ВЫПОЛНЕНИЕ"));
Логирование.ЗаписатьСтрокуЛога();
Логирование.УменьшитьУровень();
Логирование.ЗаписатьСтрокуЛога("Завершение задания """ + ИдентификаторЗадания + """");

//Удалим старые логи
ФайловыеОперации.УдалитьФайлыИзмененныеБолееДнейНазад(КаталогХраненияЛогов,ХранитьЛогиДней,,Истина);

// Отправляем эклектронное сообщение с файлом лога во вложении
Если ЗначениеЗаполнено(УчетнаяЗаписьЭП.АдресSMTP) Тогда

	Если БылиОшибки Тогда
		СтруктураСообщения.ТемаСообщения = ТемаСообщенияПриОшибке;
	Иначе
		СтруктураСообщения.ТемаСообщения = ТемаСообщенияПриУспехе;
	КонецЕсли;	
	СтруктураСообщения.ТекстСообщения = СтруктураСообщения.ТемаСообщения;
	
	// Часть имеющегося лога добавим в письмо
	ИмяВременногоФайла = ФайловыеОперации.СкопироватьФайл(Логирование.ИмяФайлаЛога);
	СтруктураСообщения.Вложения = ИмяВременногоФайла;
	
	// Отправим сообщение
	Логирование.ЗаписатьСтрокуЛога();
	Логирование.ЗаписатьСтрокуЛога("Попытка отправки электронного сообщения:");
	КопироватьФайл(Логирование.ИмяФайлаЛога,ПолучитьИмяВременногоФайла("txt"));
	Если УправлениеЭП.ОтправитьСообщение() Тогда
		Логирование.ЗаписатьСтрокуЛога("Отправлено электорнное сообщение на адреса: " + СтруктураСообщения.АдресЭлектроннойПочтыПолучателя);
	Иначе
		Логирование.ЗаписатьСтрокуЛога("ОШИБКА: Не удалось отправить электронное сообщение с smtp-сервера: " + УчетнаяЗаписьЭП.АдресSMTP);
		Логирование.ЗаписатьСтрокуЛога("	по причине " + УправлениеЭП.ТекстОшибки);
		БылиОшибки = Истина;
	КонецЕсли;
	
	УдалитьФайлы(ИмяВременногоФайла);

КонецЕсли;
	
	




