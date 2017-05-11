﻿//*****************************************************************
// Библиотека: TRun1C
// Автор: Онянов Виталий (Tavalik.ru)
// Версия от 05.05.2017
//

//*****************************************************************
// ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ

// Структура параметров запуска, описание в процедуре ИнициироватьПараметры()
Перем ПараметрыЗапуска Экспорт;
// Переменная для возврата ошибки, если таковая имела место быть
Перем ТекстОшибки Экспорт;


//*****************************************************************
// ЛОКАЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

//*****************************************************************
Процедура ИнициироватьПараметры()
   
	ПараметрыЗапуска = Новый Структура;
	
	//Путь к платформе 1С, 
	//Пример:
	//	C:\Program Files (x86)\1cv8\8.3.8.2054\bin\1cv8.exe
	ПараметрыЗапуска.Вставить("ПутьКПлатформе1С","");
	
	//Версия COMConnector
	//Пример:
	//	81
	//	82
	//	83
	ПараметрыЗапуска.Вставить("ВерсияCOMConnector",83);
	
	//Тип базы 1С
	//Варианты:
	//	F - файловая 
	//  S - серверная
	//  WS - веб
	ПараметрыЗапуска.Вставить("ТипБазы","S");
	
	//Имя базы 1С
	//Указывается как для файловой, так и для серверной базы:
	ПараметрыЗапуска.Вставить("ИмяБазы","");

	//Параметры сервера 1С
	//Указывается только для серверной базы
	ПараметрыЗапуска.Вставить("АдресКластера","localhost");
	ПараметрыЗапуска.Вставить("ПортКластера","1541");
	ПараметрыЗапуска.Вставить("ПортАгента","1540");
	ПараметрыЗапуска.Вставить("ИмяПользователяАдминистратораКластера","");
	ПараметрыЗапуска.Вставить("ПарольПользователяАдминистратораКластера","");
	ПараметрыЗапуска.Вставить("КодРазрешения","987654321");
	ПараметрыЗапуска.Вставить("СообщениеПриБлокировке","Информационная база заблокирована для обслуживания.");
	
	//Параметры авторизации в информационной базе
	ПараметрыЗапуска.Вставить("ИмяПользователя","");
	ПараметрыЗапуска.Вставить("ПарольПользователя","");
	
	//Параметры работы с хранилищем
	ПараметрыЗапуска.Вставить("АдресХранилища","");
	ПараметрыЗапуска.Вставить("ИмяПользователяХранилища","");
	ПараметрыЗапуска.Вставить("ПарольПользователяХранилища","");
	
	//При установке данного флага, все дейстия в пакетном запуске конфигуратора будут видны пользователю
	ПараметрыЗапуска.Вставить("ВидныДействияВПакетномРежиме",Ложь);
	//При указании имени файла, результат работы конфигуратора в пакетном режиме будет записан в данные файл файл
	ПараметрыЗапуска.Вставить("ФайлДляЗаписиРезультатовРаботыВПакетномРежиме","");

КонецПроцедуры

//*****************************************************************
Функция ВсеПараметрыЗапускаЗаполненыКорректно(ПроверятьАдресХранилища=Ложь, ПроверятьИмяПользователяХранилища=Ложь)

	Если НЕ ЗначениеЗаполнено(ПараметрыЗапуска.ПутьКПлатформе1С) Тогда
		ТекстОшибки = "Не заполнен путь к платформе 1С!";
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПараметрыЗапуска.ВерсияCOMConnector) Тогда
		ТекстОшибки = "Не заполнена версия COMConnector!";
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПараметрыЗапуска.ТипБазы) Тогда
		ТекстОшибки = "Не заполнен тип базы 1С!";
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПараметрыЗапуска.ИмяБазы) Тогда
		ТекстОшибки = "Не заполнено имя базы 1С!";
		Возврат Ложь;
	КонецЕсли;
	
	Если ПараметрыЗапуска.ТипБазы = "S" Тогда
		
		Если НЕ ЗначениеЗаполнено(ПараметрыЗапуска.АдресКластера) Тогда
			ТекстОшибки = "Не заполнен адрес кластера серверов 1С!";
			Возврат Ложь;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ПараметрыЗапуска.ПортКластера) Тогда
			ТекстОшибки = "Не заполнен порт кластера серверов 1С!";
			Возврат Ложь;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ПараметрыЗапуска.ПортАгента) Тогда
			ТекстОшибки = "Не заполнен порт агента кластера серверов 1С!";
			Возврат Ложь;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ПараметрыЗапуска.КодРазрешения) Тогда
			ТекстОшибки = "Не заполнен код разрешения при блокировке сансов 1С!";
			Возврат Ложь;
		КонецЕсли;
	
	КонецЕсли;
	
	Если ПроверятьАдресХранилища Тогда		
		Если НЕ ЗначениеЗаполнено(ПараметрыЗапуска.АдресХранилища) Тогда
			ТекстОшибки = "Не заполнен адрес хранилища конфигурации!";
			Возврат Ложь;
		КонецЕсли;		
	КонецЕсли;
	
	Если ПроверятьИмяПользователяХранилища Тогда		
		Если НЕ ЗначениеЗаполнено(ПараметрыЗапуска.ИмяПользователяХранилища) Тогда
			ТекстОшибки = "Не заполнено имя пользователя хранилища конфигурации!";
			Возврат Ложь;
		КонецЕсли;		
	КонецЕсли;		
	
	Возврат Истина;

КонецФункции
 
//*****************************************************************
Функция ОбернутьВКавычки(ВходящаяСтрока)
	Возврат """" + ВходящаяСтрока + """";
КонецФункции

//*****************************************************************
Функция ВставитьПараметрЗапуска(Параметр, Ключ="", СимволКлюча = "/", ОбернутьВКавычки=Истина)

	Если СтрДлина(Параметр)=0 Тогда
		Возврат "";
	Иначе
		Если СтрДлина(Ключ)=0 Тогда
			Если ОбернутьВКавычки Тогда
				Возврат ОбернутьВКавычки(СокрЛП(Параметр)) + " ";
			Иначе
				Возврат Параметр + " ";
			КонецЕсли;
		Иначе
			Если ОбернутьВКавычки Тогда		
				Возврат СимволКлюча + Ключ + ОбернутьВКавычки(СокрЛП(Параметр)) + " ";
			Иначе
				Возврат СимволКлюча + Ключ + СокрЛП(Параметр) + " ";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции 


 
//*****************************************************************
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

//*****************************************************************
// Возвращает имя файла, построенном по принципу: ИмяБазы + ДатаВремя + Расширение
// Пример: Base_2017_04_28_19_02_12.dt
//
Функция ИмяФайлаПоИмениБазыНаДату(Расширение) Экспорт

	ТекИмяБазы = СокрЛП(ПараметрыЗапуска.ИмяБазы); 
	Если ПараметрыЗапуска.ТипБазы = "F" Тогда		
		НомерСлеша = 0;		
		Для Сч = 1 По СтрДлина(ТекИмяБазы) Цикл
			Если Сред(ТекИмяБазы,Сч,1) = "\" Тогда
				НомерСлеша = Сч;
			КонецЕсли
		КонецЦикла;
		ТекИмяБазы = Сред(ТекИмяБазы,НомерСлеша+1);
	КонецЕсли;
		
	Возврат СокрЛП(ТекИмяБазы) + Формат(ТекущаяДата(),"ДФ=_yyyy_MM_dd_ЧЧ_мм_сс") + "." + Расширение;

КонецФункции


//*****************************************************************
// Завершает работу пользователей для серверной базы
//
Функция ЗавершитьРаботуПользователей() Экспорт
 
 	БазаБылаНайдена = Ложь;
	ТекстОшибки  = "";
	
	//Проверим, не файловая ли база
	Если ПараметрыЗапуска.ТипБазы = "F" Тогда
		ТекстОшибки = "Недоступно для файловой базы";
		Возврат Ложь;
	КонецЕсли;
	
	//Проверим ключевые параметры запуска
	Если НЕ ВсеПараметрыЗапускаЗаполненыКорректно() Тогда
		Возврат Ложь;
	КонецЕсли;
 	
	Попытка
		
		//Получаем COMConnector
		Коннектор = Новый COMОбъект("v" + ПараметрыЗапуска.ВерсияCOMConnector + ".COMConnector");
		//Получаем Соединение с агентом сервера
		СоединениеСАгентомСервера = Коннектор.ConnectAgent(ПараметрыЗапуска.АдресКластера + ":" + ПараметрыЗапуска.ПортАгента);
		
		//Получаем список кластеров		
		КластерыСерверов = СоединениеСАгентомСервера.GetClusters(); 
		Для Каждого КластерСерверов Из КластерыСерверов Цикл			
			
			//Аутентификация администратора кластера серверов
			СоединениеСАгентомСервера.Authenticate(КластерСерверов,ПараметрыЗапуска.ИмяПользователяАдминистратораКластера,ПараметрыЗапуска.ПарольПользователяАдминистратораКластера);
			
			//Получаем все рабочие процессы
			РабочиеПроцессы = СоединениеСАгентомСервера.GetWorkingProcesses(КластерСерверов);
			Для Каждого РабочийПроцесс Из РабочиеПроцессы Цикл
				
				//Создаем соединение с рабочим процессом
				СоединениеСРабочимПроцессом = Коннектор.ConnectWorkingProcess(ПараметрыЗапуска.АдресКластера + ":" + СтрЗаменить(РабочийПроцесс.MainPort, Символы.НПП, ""));
				//Выполняем аутентификацию
				СоединениеСРабочимПроцессом.AddAuthentication(ПараметрыЗапуска.ИмяПользователя, ПараметрыЗапуска.ПарольПользователя);
				
				//Получаем информационные базы
				ИнформационныеБазы = СоединениеСРабочимПроцессом.GetInfoBases();				
				Для Каждого ИнформационнаяБаза ИЗ ИнформационныеБазы Цикл
					
					Если НРег(ИнформационнаяБаза.Name) = НРег(ПараметрыЗапуска.ИмяБазы) Тогда
					
						//Пометим, что база была найдена
						БазаБылаНайдена = Истина;
						
						//Получаем массив соединений информационной базы
						Соединения = СоединениеСРабочимПроцессом.GetInfoBaseConnections(ИнформационнаяБаза);
						Для Каждого Соединение ИЗ Соединения Цикл
							
							//Не трогаем сенасы в коносле кластера
							Если НРег(Соединение.AppID) = "comconsole" Тогда
								Продолжить;
							КонецЕсли;
							
							//Разрываем соединение
							СоединениеСРабочимПроцессом.Disconnect(Соединение);
							
						КонецЦикла;						
			
						Прервать;					
  
					КонецЕсли;
					
				КонецЦикла;
		
			КонецЦикла;
			
		КонецЦикла;	
		
	Исключение		
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;	
	
	Если НЕ БазаБылаНайдена Тогда
		ТекстОшибки = "Информационная база не была найдена в кластере";
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

//*****************************************************************
// Устанавливает блокирвку сенасов для серверной базы
//
Функция УстановитьБлокировкуНачалаСеансов() Экспорт
	
 	БазаБылаНайдена = Ложь;
	ТекстОшибки  = "";
	
	//Проверим, не файловая ли база
	Если ПараметрыЗапуска.ТипБазы = "F" Тогда
		ТекстОшибки = "Недоступно для файловой базы";
		Возврат Ложь;
	КонецЕсли;
	
	//Проверим ключевые параметры запуска
	Если НЕ ВсеПараметрыЗапускаЗаполненыКорректно() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		
		//Получаем COMConnector
		Коннектор = Новый COMОбъект("v" + ПараметрыЗапуска.ВерсияCOMConnector + ".COMConnector");
		//Получаем Соединение с агентом сервера
		СоединениеСАгентомСервера = Коннектор.ConnectAgent(ПараметрыЗапуска.АдресКластера + ":" + ПараметрыЗапуска.ПортАгента);
		
		//Получаем список кластеров		
		КластерыСерверов = СоединениеСАгентомСервера.GetClusters(); 
		Для Каждого КластерСерверов Из КластерыСерверов Цикл			
			
			//Аутентификация администратора кластера серверов
			СоединениеСАгентомСервера.Authenticate(КластерСерверов,ПараметрыЗапуска.ИмяПользователяАдминистратораКластера,ПараметрыЗапуска.ПарольПользователяАдминистратораКластера);
			
			//Получаем все рабочие процессы
			РабочиеПроцессы = СоединениеСАгентомСервера.GetWorkingProcesses(КластерСерверов);
			Для Каждого РабочийПроцесс Из РабочиеПроцессы Цикл
				
				//Создаем соединение с рабочим процессом
				СоединениеСРабочимПроцессом = Коннектор.ConnectWorkingProcess(ПараметрыЗапуска.АдресКластера + ":" + СтрЗаменить(РабочийПроцесс.MainPort, Символы.НПП, ""));
				//Выполняем аутентификацию
				СоединениеСРабочимПроцессом.AddAuthentication(ПараметрыЗапуска.ИмяПользователя, ПараметрыЗапуска.ПарольПользователя);
				
				//Получаем информационные базы
				ИнформационныеБазы = СоединениеСРабочимПроцессом.GetInfoBases();				
				Для Каждого ИнформационнаяБаза ИЗ ИнформационныеБазы Цикл
					
					Если НРег(ИнформационнаяБаза.Name) = НРег(ПараметрыЗапуска.ИмяБазы) Тогда
					
						//Пометим, что база была найдена
						БазаБылаНайдена = Истина;
						
						//Блокируем начало сеансов
						ИнформационнаяБаза.SessionsDenied = Истина;
						ИнформационнаяБаза.PermissionCode = ПараметрыЗапуска.КодРазрешения;
						ИнформационнаяБаза.DeniedMessage = ПараметрыЗапуска.СообщениеПриБлокировке;
						
						//Блокируем регламентные задания
						ИнформационнаяБаза.ScheduledJobsDenied = Истина;
						
						//Изменяем параметры информационной базы
						СоединениеСРабочимПроцессом.UpdateInfoBase(ИнформационнаяБаза);
					
						Прервать;
						
					КонецЕсли;
					
				КонецЦикла;
		
			КонецЦикла;
			
		КонецЦикла;	
		
	Исключение		
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;	
	
	Если НЕ БазаБылаНайдена Тогда
		ТекстОшибки = "Информационная база не была найдена в кластере";
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции
 
//*****************************************************************
// Снимает блокировку сеансов для серверной базы
//
Функция СнятьБлокировкуНачалаСеансов() Экспорт
	
 	БазаБылаНайдена = Ложь;
	ТекстОшибки  = "";
	
	//Проверим, не файловая ли база
	Если ПараметрыЗапуска.ТипБазы = "F" Тогда
		ТекстОшибки = "Недоступно для файловой базы";
		Возврат Ложь;
	КонецЕсли;
	
	//Проверим ключевые параметры запуска
	Если НЕ ВсеПараметрыЗапускаЗаполненыКорректно() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		
		//Получаем COMConnector
		Коннектор = Новый COMОбъект("v" + ПараметрыЗапуска.ВерсияCOMConnector + ".COMConnector");
		//Получаем Соединение с агентом сервера
		СоединениеСАгентомСервера = Коннектор.ConnectAgent(ПараметрыЗапуска.АдресКластера + ":" + ПараметрыЗапуска.ПортАгента);
		
		//Получаем список кластеров		
		КластерыСерверов = СоединениеСАгентомСервера.GetClusters(); 
		Для Каждого КластерСерверов Из КластерыСерверов Цикл			
			
			//Аутентификация администратора кластера серверов
			СоединениеСАгентомСервера.Authenticate(КластерСерверов,ПараметрыЗапуска.ИмяПользователяАдминистратораКластера,ПараметрыЗапуска.ПарольПользователяАдминистратораКластера);
			
			//Получаем все рабочие процессы
			РабочиеПроцессы = СоединениеСАгентомСервера.GetWorkingProcesses(КластерСерверов);
			Для Каждого РабочийПроцесс Из РабочиеПроцессы Цикл
				
				//Создаем соединение с рабочим процессом
				СоединениеСРабочимПроцессом = Коннектор.ConnectWorkingProcess(ПараметрыЗапуска.АдресКластера + ":" + СтрЗаменить(РабочийПроцесс.MainPort, Символы.НПП, ""));
				//Выполняем аутентификацию
				СоединениеСРабочимПроцессом.AddAuthentication(ПараметрыЗапуска.ИмяПользователя, ПараметрыЗапуска.ПарольПользователя);
				
				//Получаем информационные базы
				ИнформационныеБазы = СоединениеСРабочимПроцессом.GetInfoBases();				
				Для Каждого ИнформационнаяБаза ИЗ ИнформационныеБазы Цикл
					
					Если НРег(ИнформационнаяБаза.Name) = НРег(ПараметрыЗапуска.ИмяБазы) Тогда
					
						//Пометим, что база была найдена
						БазаБылаНайдена = Истина;
						
						//Блокируем начало сеансов
						ИнформационнаяБаза.SessionsDenied = Ложь;
						ИнформационнаяБаза.PermissionCode = "";
						ИнформационнаяБаза.DeniedMessage = "";
						
						//Блокируем регламентные задания
						ИнформационнаяБаза.ScheduledJobsDenied = Ложь;
						
						//Изменяем параметры информационной базы
						СоединениеСРабочимПроцессом.UpdateInfoBase(ИнформационнаяБаза);
						
 						Прервать;
						
					КонецЕсли;
					
				КонецЦикла;
		
			КонецЦикла;
			
		КонецЦикла;	
		
	Исключение		
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;	
	
	Если НЕ БазаБылаНайдена Тогда
		ТекстОшибки = "Информационная база не была найдена в кластере";
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции


//*****************************************************************
// Запускает 1С:Предприятие
//
Функция ЗапуститьПредприятие() Экспорт

	КодВозврата = 0;
	ТекстОшибки = "";
	
	//Проверим ключевые параметры запуска
	Если НЕ ВсеПараметрыЗапускаЗаполненыКорректно() Тогда
		Возврат Ложь;
	КонецЕсли;

	//Выполним команду
	Попытка
		СтрокаЗапуска = 
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПутьКПлатформе1С) +
			"ENTERPRISE " + 
			?(ПараметрыЗапуска.ТипБазы = "S",
			ВставитьПараметрЗапуска(ПараметрыЗапуска.АдресКластера + ":" + ПараметрыЗапуска.ПортКластера + "\" + ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы),
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы))	+ 
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяПользователя,"N") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПарольПользователя,"P") +
			"/DisableStartupMessages " +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.КодРазрешения,"UC",,Ложь);
			
  		ЗапуститьПриложение(СтрокаЗапуска,,,КодВозврата);
 
  	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
	
	//Проверим код возврата
	Если КодВозврата <> 0 Тогда
		ТекстОшибки = "Ошибка запуска 1С:Предприятие, КодВозврата=" + ПараметрыЗапуска.КодВозврата;
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

//*****************************************************************
// Запускает конфигуратор
//
Функция ЗапуститьКонфигуратор() Экспорт

	КодВозврата = 0;
	ТекстОшибки = "";
	
	//Проверим ключевые параметры запуска
	Если НЕ ВсеПараметрыЗапускаЗаполненыКорректно() Тогда
		Возврат Ложь;
	КонецЕсли;

	//Выполним команду
	Попытка
		СтрокаЗапуска = 
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПутьКПлатформе1С) +
			"DESIGNER " + 
			?(ПараметрыЗапуска.ТипБазы = "S",
			ВставитьПараметрЗапуска(ПараметрыЗапуска.АдресКластера + ":" + ПараметрыЗапуска.ПортКластера + "\" + ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы),
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы))	+ 
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяПользователя,"N") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПарольПользователя,"P") +
			"/DisableStartupMessages " +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.КодРазрешения,"UC",,Ложь);
			
  		ЗапуститьПриложение(СтрокаЗапуска,,,КодВозврата);
 
  	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
	
	//Проверим код возврата
	Если КодВозврата <> 0 Тогда
		ТекстОшибки = "Ошибка запуска конфигуратора, КодВозврата=" + ПараметрыЗапуска.КодВозврата;
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции
 
//*****************************************************************
// Выгружает информационную базу в указанный файл (dt)
//
// Параметры:
//	ПолныйПутьКФайлу - Строка - Полный путь к файлу
//	
Функция ВыгрузитьИнформационнуюБазу(ПолныйПутьКФайлу) Экспорт
 
	КодВозврата = 0;
	ТекстОшибки = "";
	
	//Проверим ключевые параметры запуска
	Если НЕ ВсеПараметрыЗапускаЗаполненыКорректно() Тогда
		Возврат Ложь;
	КонецЕсли;
 
	//Удалим файл, если таковой имеется
	УдалитьФайлы(ПолныйПутьКФайлу);
	
	//Выполним команду
	Попытка
		СтрокаЗапуска = 
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПутьКПлатформе1С) +
			"DESIGNER " + 
			?(ПараметрыЗапуска.ТипБазы = "S",
			ВставитьПараметрЗапуска(ПараметрыЗапуска.АдресКластера + ":" + ПараметрыЗапуска.ПортКластера + "\" + ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы),
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы))	+
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяПользователя,"N") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПарольПользователя,"P") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.КодРазрешения,"UC",,Ложь) +			
			ВставитьПараметрЗапуска(ПолныйПутьКФайлу,"DumpIB ") + 
			"/DisableStartupMessages " +
			?(ПараметрыЗапуска.ВидныДействияВПакетномРежиме,"/Visible ","") + 
			?(ЗначениеЗаполнено(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме),ВставитьПараметрЗапуска(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме,"DumpResult "),"");
		
  		ЗапуститьПриложение(СтрокаЗапуска,,Истина,КодВозврата);
 
  	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
	
	//Проверим код возврата
	Если КодВозврата <> 0 Тогда
		ТекстОшибки = "Ошибка выгрузки информационной базы, КодВозврата=" + КодВозврата;
		Возврат Ложь;
	КонецЕсли;
	
	//Проверим, создался ли файл?
	Если НайтиФайлы(ПолныйПутьКФайлу).Количество() = 0 Тогда
		ТекстОшибки = "Команда выполнена успешно, но файл не найден после завершения.";
		Возврат Ложь;
	Иначе
		Возврат Истина; 
	КонецЕсли;
   
КонецФункции

//*****************************************************************
// Загружает информационную базу из указанного файла (dt)
//
// Параметры:
//	ПолныйПутьКФайлу - Строка - Полный путь к файлу
//
Функция ЗагрузитьИнформационнуюБазу(ПолныйПутьКФайлу) Экспорт
 
	КодВозврата = 0;
	ТекстОшибки = "";
	
	//Проверим ключевые параметры запуска
	Если НЕ ВсеПараметрыЗапускаЗаполненыКорректно() Тогда
		Возврат Ложь;
	КонецЕсли;
 
	//Проверим, есть ли файл?
	Если НайтиФайлы(ПолныйПутьКФайлу).Количество() = 0 Тогда
		ТекстОшибки = "Не найден файл " + ПолныйПутьКФайлу;
		Возврат Ложь;
	КонецЕсли;
	
	//Выполним команду
	Попытка
		СтрокаЗапуска = 
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПутьКПлатформе1С) +
			"DESIGNER " + 
			?(ПараметрыЗапуска.ТипБазы = "S",
			ВставитьПараметрЗапуска(ПараметрыЗапуска.АдресКластера + ":" + ПараметрыЗапуска.ПортКластера + "\" + ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы),
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы))	+
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяПользователя,"N") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПарольПользователя,"P") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.КодРазрешения,"UC",,Ложь) +			
			ВставитьПараметрЗапуска(ПолныйПутьКФайлу,"RestoreIB ") +
			"/DisableStartupMessages " +
			?(ПараметрыЗапуска.ВидныДействияВПакетномРежиме,"/Visible ","") +
			?(ЗначениеЗаполнено(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме),ВставитьПараметрЗапуска(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме,"DumpResult "),"");
		
  		ЗапуститьПриложение(СтрокаЗапуска,,Истина,КодВозврата);
 
  	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
	
	//Проверим код возврата
	Если КодВозврата <> 0 Тогда
		ТекстОшибки = "Ошибка загрузки информационной базы, КодВозврата=" + КодВозврата;
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

//*****************************************************************
// Сохраняет текущую конфигурацию в указаннй файл (cf)
//
// Параметры:
//	ПолныйПутьКФайлу - Строка - Полный путь к файлу
//
Функция СохранитьКонфигурациюВФайл(ПолныйПутьКФайлу) Экспорт
 
	КодВозврата = 0;
	ТекстОшибки = "";
	
	//Проверим ключевые параметры запуска
	Если НЕ ВсеПараметрыЗапускаЗаполненыКорректно() Тогда
		Возврат Ложь;
	КонецЕсли;
 
	//Удалим файл, если таковой имеется
	УдалитьФайлы(ПолныйПутьКФайлу);
	
	//Выполним команду
	Попытка
		СтрокаЗапуска = 
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПутьКПлатформе1С) +
			"DESIGNER " + 
			?(ПараметрыЗапуска.ТипБазы = "S",
			ВставитьПараметрЗапуска(ПараметрыЗапуска.АдресКластера + ":" + ПараметрыЗапуска.ПортКластера + "\" + ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы),
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы))	+
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяПользователя,"N") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПарольПользователя,"P") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.КодРазрешения,"UC",,Ложь) +			
			ВставитьПараметрЗапуска(ПолныйПутьКФайлу,"DumpCfg ") + 
			"/DisableStartupMessages " +
			?(ПараметрыЗапуска.ВидныДействияВПакетномРежиме,"/Visible ","") + 
			?(ЗначениеЗаполнено(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме),ВставитьПараметрЗапуска(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме,"DumpResult "),"");
		
  		ЗапуститьПриложение(СтрокаЗапуска,,Истина,КодВозврата);
 
  	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
	
	//Проверим код возврата
	Если КодВозврата <> 0 Тогда
		ТекстОшибки = "Ошибка сохранения конфигурации в файл, КодВозврата=" + КодВозврата;
		Возврат Ложь;
	КонецЕсли;
	
	//Проверим, создался ли файл?
	Если НайтиФайлы(ПолныйПутьКФайлу).Количество() = 0 Тогда
		ТекстОшибки = "Команда выполнена успешно, но файл не найден после завершения.";
		Возврат Ложь;
	Иначе
		Возврат Истина; 
	КонецЕсли;
   
КонецФункции

//*****************************************************************
// Сохраняет конфигурацию базы данных в указаннй файл (cf)
//
// Параметры:
//	ПолныйПутьКФайлу - Строка - Полный путь к файлу
//
Функция СохранитьКонфигурациюБазыДанныхВФайл(ПолныйПутьКФайлу) Экспорт
 
	КодВозврата = 0;
	ТекстОшибки = "";
	
	//Проверим ключевые параметры запуска
	Если НЕ ВсеПараметрыЗапускаЗаполненыКорректно() Тогда
		Возврат Ложь;
	КонецЕсли;
 
	//Удалим файл, если таковой имеется
	УдалитьФайлы(ПолныйПутьКФайлу);
	
	//Выполним команду
	Попытка
		СтрокаЗапуска = 
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПутьКПлатформе1С) +
			"DESIGNER " + 
			?(ПараметрыЗапуска.ТипБазы = "S",
			ВставитьПараметрЗапуска(ПараметрыЗапуска.АдресКластера + ":" + ПараметрыЗапуска.ПортКластера + "\" + ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы),
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы))	+
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяПользователя,"N") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПарольПользователя,"P") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.КодРазрешения,"UC",,Ложь) +			
			ВставитьПараметрЗапуска(ПолныйПутьКФайлу,"DumpDBCfg ") + 
			"/DisableStartupMessages " +
			?(ПараметрыЗапуска.ВидныДействияВПакетномРежиме,"/Visible ","") + 
			?(ЗначениеЗаполнено(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме),ВставитьПараметрЗапуска(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме,"DumpResult "),"");
		
  		ЗапуститьПриложение(СтрокаЗапуска,,Истина,КодВозврата);
 
  	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
	
	//Проверим код возврата
	Если КодВозврата <> 0 Тогда
		ТекстОшибки = "Ошибка сохранения конфигурации базы данных в файл, КодВозврата=" + КодВозврата;
		Возврат Ложь;
	КонецЕсли;
	
	//Проверим, создался ли файл?
	Если НайтиФайлы(ПолныйПутьКФайлу).Количество() = 0 Тогда
		ТекстОшибки = "Команда выполнена успешно, но файл не найден после завершения.";
		Возврат Ложь;
	Иначе
		Возврат Истина; 
	КонецЕсли;
   
КонецФункции

//*****************************************************************
// Загружает конфигурацию из указанного файла (cf)
//
// Параметры:
//	ПолныйПутьКФайлу - Строка - Полный путь к файлу
//
Функция ЗагрузитьКонфигурациюИзФайла(ПолныйПутьКФайлу) Экспорт
 
	КодВозврата = 0;
	ТекстОшибки = "";
	
	//Проверим ключевые параметры запуска
	Если НЕ ВсеПараметрыЗапускаЗаполненыКорректно() Тогда
		Возврат Ложь;
	КонецЕсли;
 
	//Проверим, есть ли файл?
	Если НайтиФайлы(ПолныйПутьКФайлу).Количество() = 0 Тогда
		ТекстОшибки = "Не найден файл " + ПолныйПутьКФайлу;
		Возврат Ложь;
	КонецЕсли;
	
	//Выполним команду
	Попытка
		СтрокаЗапуска = 
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПутьКПлатформе1С) +
			"DESIGNER " + 
			?(ПараметрыЗапуска.ТипБазы = "S",
			ВставитьПараметрЗапуска(ПараметрыЗапуска.АдресКластера + ":" + ПараметрыЗапуска.ПортКластера + "\" + ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы),
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы))	+
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяПользователя,"N") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПарольПользователя,"P") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.КодРазрешения,"UC",,Ложь) +			
			ВставитьПараметрЗапуска(ПолныйПутьКФайлу,"LoadCfg ") +
			"/DisableStartupMessages " +
			?(ПараметрыЗапуска.ВидныДействияВПакетномРежиме,"/Visible ","") +
			?(ЗначениеЗаполнено(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме),ВставитьПараметрЗапуска(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме,"DumpResult "),"");
		
  		ЗапуститьПриложение(СтрокаЗапуска,,Истина,КодВозврата);
 
  	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
	
	//Проверим код возврата
	Если КодВозврата <> 0 Тогда
		ТекстОшибки = "Ошибка загрузки конфигурации из файла, КодВозврата=" + КодВозврата;
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

//*****************************************************************
// Обновлет конфигурацию базы данных
// 
// Параметры:
//	ПредупрежденияКакОшибки - Булево - Если Истина, то все предупреждения трактуются как ошибки.
//	НаСервере - Булево - Если Истина, то обновление будет выполняться на сервере (имеет смысл только в клиент-серверном варианте работы).
//	
Функция ОбновитьКонфигурациюБазыДанных(ПредупрежденияКакОшибки=Ложь, НаСервере=Ложь) Экспорт
 
	КодВозврата = 0;
	ТекстОшибки = "";
	
	//Проверим ключевые параметры запуска
	Если НЕ ВсеПараметрыЗапускаЗаполненыКорректно() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	//Выполним команду
	Попытка
		СтрокаЗапуска = 
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПутьКПлатформе1С) +
			"DESIGNER " + 
			?(ПараметрыЗапуска.ТипБазы = "S",
			ВставитьПараметрЗапуска(ПараметрыЗапуска.АдресКластера + ":" + ПараметрыЗапуска.ПортКластера + "\" + ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы),
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы))	+
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяПользователя,"N") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПарольПользователя,"P") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.КодРазрешения,"UC",,Ложь) +			
			"/UpdateDBCfg " +
			?(ПредупрежденияКакОшибки,"-WarningsAsErrors ","") +
			?(НаСервере,"-Server ","") +
			"/DisableStartupMessages " +
			?(ПараметрыЗапуска.ВидныДействияВПакетномРежиме,"/Visible ","") +
			?(ЗначениеЗаполнено(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме),ВставитьПараметрЗапуска(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме,"DumpResult "),"");
		
  		ЗапуститьПриложение(СтрокаЗапуска,,Истина,КодВозврата);
 
  	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
	
	//Проверим код возврата
	Если КодВозврата <> 0 Тогда
		ТекстОшибки = "Ошибка загрузки конфигурации из файла, КодВозврата=" + КодВозврата;
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции


//*****************************************************************
// Сохраняет конфигурацию из хранилища в файл
//
// Параметры:
// 	НомерВерсии (-v [номер версии хранилища]) 
//		— номер версии хранилища, если номер версии не указан, или равен -1, будет сохранена последняя версия
//
Функция СохранитьКонфигурациюИзХранилищаВФайл(ПолныйПутьКФайлу, НомерВерсии="") Экспорт
 
	КодВозврата = 0;
	ТекстОшибки = "";
	
	//Проверим ключевые параметры запуска
	Если НЕ ВсеПараметрыЗапускаЗаполненыКорректно(Истина,Истина) Тогда
		Возврат Ложь;
	КонецЕсли;
 
	//Удалим файл, если таковой имеется
	УдалитьФайлы(ПолныйПутьКФайлу);
	
	//Выполним команду
	Попытка
		СтрокаЗапуска = 
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПутьКПлатформе1С) +
			"DESIGNER " + 
			?(ПараметрыЗапуска.ТипБазы = "S",
			ВставитьПараметрЗапуска(ПараметрыЗапуска.АдресКластера + ":" + ПараметрыЗапуска.ПортКластера + "\" + ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы),
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы))	+
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяПользователя,"N") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПарольПользователя,"P") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.КодРазрешения,"UC",,Ложь) +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.АдресХранилища,"ConfigurationRepositoryF ") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяПользователяХранилища,"ConfigurationRepositoryN ") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПарольПользователяХранилища,"ConfigurationRepositoryP ") +
			ВставитьПараметрЗапуска(ПолныйПутьКФайлу,"ConfigurationRepositoryDumpCfg ") + 
			?(ЗначениеЗаполнено(НомерВерсии),"-v " + Формат(НомерВерсии,"ЧДЦ=0; ЧГ=0") + " ","") +
			"/DisableStartupMessages " +
			?(ПараметрыЗапуска.ВидныДействияВПакетномРежиме,"/Visible ","") + 
			?(ЗначениеЗаполнено(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме),ВставитьПараметрЗапуска(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме,"DumpResult "),"");
		
  		ЗапуститьПриложение(СтрокаЗапуска,,Истина,КодВозврата);
 
  	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
	
	//Проверим код возврата
	Если КодВозврата <> 0 Тогда
		ТекстОшибки = "Ошибка сохранения конфигурации в файл, КодВозврата=" + КодВозврата;
		Возврат Ложь;
	КонецЕсли;
	
	//Проверим, создался ли файл?
	Если НайтиФайлы(ПолныйПутьКФайлу).Количество() = 0 Тогда
		ТекстОшибки = "Команда выполнена успешно, но файл не найден после завершения.";
		Возврат Ложь;
	Иначе
		Возврат Истина; 
	КонецЕсли;
   
КонецФункции

//*****************************************************************
// Обновляет текущую конфигурацию из хранилища
//
// Параметры:
// 	НомерВерсии (-v [номер версии хранилища]) 
//		— номер версии хранилища, если номер версии не указан, или равен -1, будет сохранена последняя версия, если конфигурация не подключена к хранилищу, то параметр игнорируется;
// 	ПолучатьЗахваченныеОбъекты (-revised) 
//		— получать захваченные объекты, если потребуется. Если конфигурация не подключена к хранилищу, то параметр игнорируется;
// 	Форсировать (-force)
//		— если при пакетном обновлении конфигурации из хранилища должны быть получены новые объекты конфигурации или удалиться существующие, указание этого параметра свидетельствует о подтверждении пользователем описанных выше операций. Если параметр не указан — действия выполнены не будут.
//
Функция ОбновитьКонфигурациюИзХранилища(НомерВерсии="", ПолучатьЗахваченныеОбъекты = Ложь, Форсировать = Истина) Экспорт
 
	КодВозврата = 0;
	ТекстОшибки = "";
	
	//Проверим ключевые параметры запуска
	Если НЕ ВсеПараметрыЗапускаЗаполненыКорректно(Истина,Истина) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	//Выполним команду
	Попытка
		СтрокаЗапуска = 
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПутьКПлатформе1С) +
			"DESIGNER " + 
			?(ПараметрыЗапуска.ТипБазы = "S",
			ВставитьПараметрЗапуска(ПараметрыЗапуска.АдресКластера + ":" + ПараметрыЗапуска.ПортКластера + "\" + ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы),
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы))	+
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяПользователя,"N") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПарольПользователя,"P") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.КодРазрешения,"UC",,Ложь) +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.АдресХранилища,"ConfigurationRepositoryF") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяПользователяХранилища,"ConfigurationRepositoryN") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПарольПользователяХранилища,"ConfigurationRepositoryP") +			
			"/ConfigurationRepositoryUpdateCfg " +
			?(ЗначениеЗаполнено(НомерВерсии),"-v " + Формат(НомерВерсии,"ЧДЦ=0; ЧГ=0") + " ","") +
			?(ПолучатьЗахваченныеОбъекты,"-revised ","") +
			?(Форсировать,"-force ","") +
			"/DisableStartupMessages " +
			?(ПараметрыЗапуска.ВидныДействияВПакетномРежиме,"/Visible ","") +
			?(ЗначениеЗаполнено(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме),ВставитьПараметрЗапуска(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме,"DumpResult "),"");
		
  		ЗапуститьПриложение(СтрокаЗапуска,,Истина,КодВозврата);
 
  	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
	
	//Проверим код возврата
	Если КодВозврата <> 0 Тогда
		ТекстОшибки = "Ошибка загрузки конфигурации из файла, КодВозврата=" + КодВозврата;
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

//*****************************************************************
// Отключает конфигурацию от хранилища
//
// Параметры:
// 	Форсировать (-force)
//		— ключ для форсирования отключения от хранилища (пропуск диалога аутентификации, если не указаны параметры пользователя хранилища, игнорирование наличия захваченных и измененных объектов).
//
Функция ОтключитьКонфигурациюОтХранилища(Форсировать = Истина) Экспорт
 
	КодВозврата = 0;
	ТекстОшибки = "";
	
	//Проверим ключевые параметры запуска
	Если НЕ ВсеПараметрыЗапускаЗаполненыКорректно(Истина,НЕ Форсировать) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	//Выполним команду
	Попытка
		СтрокаЗапуска = 
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПутьКПлатформе1С) +
			"DESIGNER " + 
			?(ПараметрыЗапуска.ТипБазы = "S",
			ВставитьПараметрЗапуска(ПараметрыЗапуска.АдресКластера + ":" + ПараметрыЗапуска.ПортКластера + "\" + ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы),
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяБазы,ПараметрыЗапуска.ТипБазы))	+
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяПользователя,"N") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПарольПользователя,"P") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.КодРазрешения,"UC",,Ложь) +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.АдресХранилища,"ConfigurationRepositoryF") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ИмяПользователяХранилища,"ConfigurationRepositoryN") +
			ВставитьПараметрЗапуска(ПараметрыЗапуска.ПарольПользователяХранилища,"ConfigurationRepositoryP") +			
			"/ConfigurationRepositoryUnbindCfg " +
			?(Форсировать,"-force ","") +
			"/DisableStartupMessages " +
			?(ПараметрыЗапуска.ВидныДействияВПакетномРежиме,"/Visible ","") +
			?(ЗначениеЗаполнено(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме),ВставитьПараметрЗапуска(ПараметрыЗапуска.ФайлДляЗаписиРезультатовРаботыВПакетномРежиме,"DumpResult "),"");
		
  		ЗапуститьПриложение(СтрокаЗапуска,,Истина,КодВозврата);
 
  	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
	
	//Проверим код возврата
	Если КодВозврата <> 0 Тогда
		ТекстОшибки = "Ошибка загрузки конфигурации из файла, КодВозврата=" + КодВозврата;
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции


//*****************************************************************
// Сразу при создании инициируем параметры
ИнициироватьПараметры();
   
