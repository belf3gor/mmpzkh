&НаСервере
Функция ЗнакомствоС1СБухгалтерией()
	
	Возврат ПолучитьОбщийМакет("ЗнакомствоС1СБухгалтерией").ПолучитьТекст();
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОбщегоНазначенияБПКлиент.ОткрытьВебСтраницу(ЗнакомствоС1СБухгалтерией(), НСтр("ru='Как устроена программа?'"));
	
КонецПроцедуры
