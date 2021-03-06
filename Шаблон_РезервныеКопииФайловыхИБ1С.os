﻿//*****************************************************************
// Автор: Онянов Виталий (Tavalik.ru)
// Описание: 
//	Скрипт выполняет резервное копирование указанных файловых баз 1С, алгоритм работы следующий:
//		1. Для каждой базы
//			1.1 Создается архив полного каталога с информационной базой
//			1.2 Если полный архив создать не удалось, создается архив с:
//				- файлом 1Cv8.1CD
//				- каталогом 1Cv8Log
//				- каталогом 1Cv8FTxt
//			1.3 В каталоге хранения ежедневных архивов удалюятся старые копии (опционально)
//			1.4 Если сегодня - первое число месяца, то архив копируется в каталог хранения копий на первое число месяца (опционально)
//			1.5 Если сегодня - первое число месяца, то в каталоге хранения архивов на первое число месяца удалюятся старые копии (опционально)
//			1.3 Архив копируется на FTP-сервер (опционально)
//			1.4 На FTP-сервере удалюятся старые копии (опционально)
//		3. Отправляется электорнное сообщение о результатах выполнения задания (опционально)
// Аргументы командной строки:
//	Нет

//***************************************************************
// ПОДКЛЮЧАЕМЫЕ БИБЛИОТЕКИ

// Логирование
#Использовать "TLog"
// Файловые операции
#Использовать "TFile"
// Работа с FTP
#Использовать "TFTP"
// Электронная почта 
#Использовать "TMail" 


//***************************************************************
// АРГУМЕНТЫ КОМАНДНОЙ СТРОКИ

// Нет

//***************************************************************
// НАСТРАИВАЕМЫЕ ПАРАМЕТРЫ

// Параметры по умолчанию для всех баз
КаталогРезервнойКопии = "C:\DATA\Backup\Day\";				// В данном каталоге будут создаваться подпаки с именами баз, резервные копии на каждый день
КоличествоДнейХранения = 60; 								// Если 0, то не удаляются копии
КаталогРезервнойКопииПервоеЧисло = "C:\DATA\Backup\Month\";	// В данном каталоге будут создаваться подпаки с именами баз, резеврные копии на певое число каждого месяца
КоличествоДнейХраненияПервоеЧисло = 720;					// Если 0, то не удаляются копии
КаталогРезервнойКопииНаFTP = "!BACKUP/VION/";				// Если путой, то не не копируется на FTP
КоличествоДнейХраненияНаFTP = 365;							// Если 0, то не удалются копии

// Таблица с указанием источников копирования
ДанныеДляАрхива = Новый ТаблицаЗначений;
ДанныеДляАрхива.Колонки.Добавить("ИмяФайла");
ДанныеДляАрхива.Колонки.Добавить("КаталогРезервнойКопии");
ДанныеДляАрхива.Колонки.Добавить("КоличествоДнейХранения"); 
ДанныеДляАрхива.Колонки.Добавить("КаталогРезервнойКопииПервоеЧисло"); 
ДанныеДляАрхива.Колонки.Добавить("КоличествоДнейХраненияПервоеЧисло");
ДанныеДляАрхива.Колонки.Добавить("КаталогРезервнойКопииНаFTP"); 
ДанныеДляАрхива.Колонки.Добавить("КоличествоДнейХраненияНаFTP"); 

// Список баз для копирования
НоваяСтрокаДляАрхива = ДанныеДляАрхива.Добавить();
НоваяСтрокаДляАрхива.ИмяФайла = "C:\BASE\DemoHRM";  

// Каталог для хранения логов
КаталогХраненияЛогов = ".\_Logs\";
ХранитьЛогиДней = 365;
Логирование = Новый ТУправлениеЛогированием(); //TLog
Логирование.СоздатьФайлЛога("РезервнаяКопияФайловыхИБ",КаталогХраненияЛогов);

// Инициируем параметры для отправки сообщения
УправлениеЭП = Новый ТУправлениеЭлектроннойПочтой(); //TMail
УчетнаяЗаписьЭП = УправлениеЭП.УчетнаяЗаписьЭП;
УчетнаяЗаписьЭП.АдресSMTP = "smtp.mydomen.com"; // Если не указан, не отправляется сообщение
УчетнаяЗаписьЭП.ПортSMTP = 465;  
УчетнаяЗаписьЭП.ПользовательSMTP = "report@mydomen.com";
УчетнаяЗаписьЭП.ПарольSMTP = "pass_mail";
УчетнаяЗаписьЭП.ИспользоватьSSL = Истина;
СтруктураСообщения = УправлениеЭП.СтруктураСообщения;
СтруктураСообщения.АдресЭлектроннойПочтыПолучателя = "admin@mydomen.com;";

// Темы сообщений
СИ = Новый СистемнаяИнформация();
ТемаСообщенияПриОшибке = "ВНИМАНИЕ! Задание ""РезервнаяКопияФайловыхИБ"" на сервере " + СИ.ИмяКомпьютера + " завершено с ошибками";
ТемаСообщенияПриУспехе = "Успешное выполнение задания ""РезервнаяКопияФайловыхИБ"" на сервере " + СИ.ИмяКомпьютера;

// Введем параметры подключения к FTP-серверу
ОперацииСFTP = Новый ТОперацииСFTP(); //TFTP
ПараметрыFTP = ОперацииСFTP.ПараметрыFTP;
ПараметрыFTP.Адрес = "ftp.iis.mydomen.com";
ПараметрыFTP.ИмяПользователя = "username_iis";
ПараметрыFTP.ПарольПользователя = "pass_iis";
ПараметрыFTP.ПроверятьРезультат = Истина;

// Файловые операции
ФайловыеОперации = Новый ТУправлениеФайловымиОперациями(); //TFile

//***************************************************************
// ТЕЛО СКРИПТА

// Сделаем записть о начале выполнения задания
Логирование.ЗаписатьСтрокуЛога(Строка(ТекущаяДата()) + ": Начало выполнения задания ""РезервнаяКопияФайловыхИБ""");
Логирование.УвеличитьУровень();

// Служебные переменные
БылиОшибки = Ложь;

// Цикл по файлам, которые необходимо скопировать
Для Каждого СтрокаДляАрхива Из ДанныеДляАрхива Цикл

	ТекПолноеИмяФайла = СтрокаДляАрхива.ИмяФайла;

	// Запишем лог
	Логирование.ЗаписатьСтрокуЛога();
	Логирование.ЗаписатьСтрокуЛога("Попытка создания резервной копии файла: " + ТекПолноеИмяФайла);

	// Проверим существование файла
	Файл = Новый Файл(ТекПолноеИмяФайла);
	Если Не Файл.Существует() Тогда	
		Логирование.ЗаписатьСтрокуЛога("ОШИБКА: Не наден файл по пути: " + ТекПолноеИмяФайла,1);
		БылиОшибки = Истина;
		Продолжить;
	КонецЕсли;
	
	// Вычислим все значения переменных
	Если Файл.ЭтоФайл() Тогда
		ТекИмяБезРасширения = ФайловыеОперации.СтрокаЛатиницей(Файл.ИмяБезРасширения);
	Иначе
		ТекИмяБезРасширения = ФайловыеОперации.СтрокаЛатиницей(Файл.Имя);
	КонецЕсли;	
	Если ЗначениеЗаполнено(СтрокаДляАрхива.КаталогРезервнойКопии) Тогда
		ТекКаталогРезервнойКопии = СтрокаДляАрхива.КаталогРезервнойКопии;
	Иначе
		ТекКаталогРезервнойКопии = ОбъединитьПути(КаталогРезервнойКопии,ТекИмяБезРасширения);
	КонецЕсли;
	ТекИмяАрхива = ОбъединитьПути(ТекКаталогРезервнойКопии,ФайловыеОперации.ИмяФайлаНаДату(ТекИмяБезРасширения,"zip"));
	Если ЗначениеЗаполнено(СтрокаДляАрхива.КоличествоДнейХранения) Тогда
		ТекКоличествоДнейХранения = СтрокаДляАрхива.КоличествоДнейХранения;
	Иначе
		ТекКоличествоДнейХранения = КоличествоДнейХранения;
	КонецЕсли;
	Если ЗначениеЗаполнено(СтрокаДляАрхива.КаталогРезервнойКопииПервоеЧисло) Тогда
		ТекКаталогРезервнойКопииПервоеЧисло = СтрокаДляАрхива.КаталогРезервнойКопииПервоеЧисло;
	Иначе
		ТекКаталогРезервнойКопииПервоеЧисло = ОбъединитьПути(КаталогРезервнойКопииПервоеЧисло,ТекИмяБезРасширения);
	КонецЕсли;
	Если ЗначениеЗаполнено(СтрокаДляАрхива.КоличествоДнейХраненияПервоеЧисло) Тогда
		ТекКоличествоДнейХраненияПервоеЧисло = СтрокаДляАрхива.КоличествоДнейХраненияПервоеЧисло;
	Иначе
		ТекКоличествоДнейХраненияПервоеЧисло = КоличествоДнейХраненияПервоеЧисло;
	КонецЕсли;
	Если ЗначениеЗаполнено(СтрокаДляАрхива.КаталогРезервнойКопииНаFTP) Тогда
		ТекКаталогРезервнойКопииНаFTP = СтрокаДляАрхива.КаталогРезервнойКопииНаFTP;
	Иначе
		ТекКаталогРезервнойКопииНаFTP = КаталогРезервнойКопииНаFTP;
	КонецЕсли;
	Если ЗначениеЗаполнено(СтрокаДляАрхива.КоличествоДнейХраненияНаFTP) Тогда
		ТекКоличествоДнейХраненияНаFTP = СтрокаДляАрхива.КоличествоДнейХраненияНаFTP;
	Иначе
		ТекКоличествоДнейХраненияНаFTP = КоличествоДнейХраненияНаFTP;
	КонецЕсли;
	
	// Проверим существование каталогов или создадим их
	Если Не ФайловыеОперации.ОбеспечитьКаталог(ТекКаталогРезервнойКопии) Тогда
		Логирование.ЗаписатьСтрокуЛога("ОШИБКА: " + ФайловыеОперации.ТекстОшибки,1);
		БылиОшибки = Истина;
		Продолжить;
	КонецЕсли;
	Если Не ФайловыеОперации.ОбеспечитьКаталог(ТекКаталогРезервнойКопииПервоеЧисло) Тогда
		Логирование.ЗаписатьСтрокуЛога("ОШИБКА: " + ФайловыеОперации.ТекстОшибки,1);
		БылиОшибки = Истина;
		Продолжить;
	КонецЕсли;
	
	// Если не получится сделать архив всего каталога, сделаем архивы только указанных файлов
	МассивФайлов = Новый Массив;
	МассивФайлов.Добавить(ОбъединитьПути(ТекПолноеИмяФайла,"1Cv8.1CD"));
	МассивФайлов.Добавить(ОбъединитьПути(ТекПолноеИмяФайла,"1Cv8Log"));
	МассивФайлов.Добавить(ОбъединитьПути(ТекПолноеИмяФайла,"1Cv8FTxt"));
	
	// Создадим архив
	Если ФайловыеОперации.ДобавитьВАрхив(ТекПолноеИмяФайла,ТекИмяАрхива) Тогда
		// Пробуем создать архив всего каталогоа
		Логирование.ЗаписатьСтрокуЛога("Создан архив: " + ТекИмяАрхива,1);
	ИначеЕсли ФайловыеОперации.ДобавитьВАрхив(МассивФайлов,ТекИмяАрхива) Тогда
		// Пробуем создать архив выбранных важных каталогов
		Логирование.ЗаписатьСтрокуЛога("Создан архив: " + ТекИмяАрхива,1);
	Иначе
		Логирование.ЗаписатьСтрокуЛога("ОШИБКА: Не удалось создать архив: " + ТекИмяАрхива,1);
		Логирование.ЗаписатьСтрокуЛога("Текст ошибки: " + ФайловыеОперации.ТекстОшибки,2);
		БылиОшибки = Истина;
		Продолжить;
	КонецЕсли;
	
	// Удалим старые резервные копии
	Если ЗначениеЗаполнено(ТекКоличествоДнейХранения)
		И ТекКоличествоДнейХранения > 0 Тогда
		ФайловыеОперации.УдалитьФайлыСозданныеБолееДнейНазад(ТекКаталогРезервнойКопии,ТекКоличествоДнейХранения,"*.zip");
		Логирование.ЗаписатьСтрокуЛога("В каталоге: " + ТекКаталогРезервнойКопии + " удалены архивы, созданные более " 
			+ ТекКоличествоДнейХранения + " дней назад.",1);
	КонецЕсли;
	
	// Если сегодня первое число, то скопируем архив в каталог для хранения месячных копий
	Если День(ТекущаяДата()) = 10 Тогда
	
		ИмяСкопированногоФайла = ФайловыеОперации.СкопироватьФайл(ТекИмяАрхива,ТекКаталогРезервнойКопииПервоеЧисло);
		Если ИмяСкопированногоФайла <> Неопределено Тогда
			Логирование.ЗаписатьСтрокуЛога("Скопирован архив: " + ИмяСкопированногоФайла,1);
		Иначе
			Логирование.ЗаписатьСтрокуЛога("ОШИБКА: Не удалось скопировать архив в: " + ИмяСкопированногоФайла,1);
			Логирование.ЗаписатьСтрокуЛога("Текст ошибки: " + ФайловыеОперации.ТекстОшибки,2);
		КонецЕсли;
		
		// Удалим старые резервные копии за перове число		
		Если ИмяСкопированногоФайла <> Неопределено
			И ЗначениеЗаполнено(ТекКоличествоДнейХраненияПервоеЧисло)
			И ТекКоличествоДнейХраненияПервоеЧисло > 0 Тогда
			ФайловыеОперации.УдалитьФайлыСозданныеБолееДнейНазад(ТекКаталогРезервнойКопииПервоеЧисло,ТекКоличествоДнейХраненияПервоеЧисло,"*.zip");
			Логирование.ЗаписатьСтрокуЛога("В каталоге: " + ТекКаталогРезервнойКопииПервоеЧисло + " удалены архивы, созданные более " 
				+ ТекКоличествоДнейХраненияПервоеЧисло + " дней назад.",1);
		КонецЕсли;
		
	КонецЕсли;
	
	// Скопируем архив на FTP-сервер
	Если ЗначениеЗаполнено(ТекКаталогРезервнойКопииНаFTP) Тогда
	
		// Проверим существование каталога на FTP-сервере
		Если Не ОперацииСFTP.СоздатьКаталогНаFTP(ТекКаталогРезервнойКопииНаFTP,ТекИмяБезРасширения) Тогда
			Логирование.ЗаписатьСтрокуЛога("ОШИБКА: Не удалось создать каталог: " + ТекКаталогРезервнойКопииНаFTP + " на FTP-сервере." +
				"	Текст ошбики: " + ОперацииСFTP.ТекстОшибки,1);
			Логирование.ЗаписатьСтрокуЛога("Текст ошибки: " + ОперацииСFTP.ТекстОшибки,2);
			БылиОшибки = Истина;
			Продолжить;
		КонецЕсли;
		
		// Загрузим файл на FTP-сервер
		ТекКаталогРезервнойКопииНаFTP = ОбъединитьПути(ТекКаталогРезервнойКопииНаFTP,ТекИмяБезРасширения);		
		Если ОперацииСFTP.ЗагрузитьФайлНаFTP(ТекКаталогРезервнойКопииНаFTP,ТекИмяАрхива) Тогда
			Логирование.ЗаписатьСтрокуЛога("Файл: " + ТекИмяАрхива + " загружен на FTP-сервер в каталог " + ТекКаталогРезервнойКопииНаFTP,1);
		Иначе
			Логирование.ЗаписатьСтрокуЛога("ОШИБКА: Не удалось загрузить файл: " + ТекИмяАрхива + " на FTP-сервер в каталог " + ТекКаталогРезервнойКопииНаFTP,1);
			Логирование.ЗаписатьСтрокуЛога("Текст ошибки: " + ОперацииСFTP.ТекстОшибки,2);
			БылиОшибки = Истина;
			Продолжить;
		КонецЕсли;
		
		// Удалим старые копии на FTP-сервере
		Если ЗначениеЗаполнено(ТекКоличествоДнейХраненияНаFTP)
			И ТекКоличествоДнейХраненияНаFTP > 0 Тогда
			Если ОперацииСFTP.УдалитьФайлыНаFTPЗагруженныеБолееДнейНазад(ТекКаталогРезервнойКопииНаFTP,ТекКоличествоДнейХраненияНаFTP) Тогда
				Логирование.ЗаписатьСтрокуЛога("На FTP-сервере в каталоге " + ТекКаталогРезервнойКопииНаFTP + " удалены архивы, созданные более " 
					+ ТекКоличествоДнейХраненияНаFTP + " дней назад.",1);
			Иначе
				Логирование.ЗаписатьСтрокуЛога("ОШИБКА: Не удалось на FTP-сервере в каталоге " + ТекКаталогРезервнойКопииНаFTP + " удалить архивы, созданные более " 
					+ ТекКоличествоДнейХраненияНаFTP + " дней назад.",1);
				Логирование.ЗаписатьСтрокуЛога("Текст ошибки: " + ОперацииСFTP.ТекстОшибки,2);
				БылиОшибки = Истина;
				Продолжить;
			КонецЕсли
		КонецЕсли;
		
	КонецЕсли;
	
КонецЦикла;

// Сделаем записть о завершении выполнения задания
Логирование.ЗаписатьСтрокуЛога();
Логирование.ЗаписатьСтрокуЛога("Результат выполнения задания: " + ?(БылиОшибки,"БЫЛИ ОШИБКИ","УСПЕШНОЕ ВЫПОЛНЕНИЕ"));
Логирование.ЗаписатьСтрокуЛога();
Логирование.УменьшитьУровень();
Логирование.ЗаписатьСтрокуЛога(Строка(ТекущаяДата()) + ": Завершение выполнения задания ""РезервнаяКопияФайловыхИБ""");

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
	
	
	
