
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекстПредупреждения = НСтр("ru = 'Для подготовки отчета СЗВ-М:
	|<OL>
	|<LI>
	|<DIV>Нажмите кнопку ""Создать"".</DIV><LI>
	|<DIV>В открывшейся форме нажмите на  клавиатуре ""Ins"", или воспользуйтесь командой ""Добавить"" по правой кнопке мыши.</DIV><LI>
	|<DIV>Выберите работника, по которому формируется отчет, при необходимости заполните ИНН и СНИЛС.</DIV><LI>
	|<DIV>После заполнения табличной части нажмите  ""Провести"".</DIV></LI></OL>
	|<DIV></DIV>
	|<DIV>Отчет можно выгрузить, отправить в ПФР или распечатать.</DIV>
	|<DIV></DIV>
	|<DIV>Программа проведет проверку, что сотрудники приняты на работу в организации. Если будет выдана ошибка, ее можно игнорировать и нажать на кнопку ""Да"". Отчет будет записан.</DIV>'");
	
	
	Шаблон = "<HTML><HEAD>
	|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type></META><LINK rel=stylesheet type=text/css href=""__STYLE__""></LINK>
	|<META name=GENERATOR content=""MSHTML 8.00.7600.16700""></META>
	|<STYLE type=text/css>BODY {
	|FONT-SIZE: 8pt; FONT-FAMILY: ""MS Sans Serif"", sans-serif; MARGIN: 5px; BACKGROUND-COLOR: #ffffff
	|}
	|DIV {
	|BORDER-TOP-COLOR: #dadac4; BORDER-LEFT-COLOR: #dadac4; PADDING-BOTTOM: 3px; BORDER-BOTTOM-COLOR: #dadac4; PADDING-TOP: 3px; PADDING-LEFT: 3px; BORDER-RIGHT-COLOR: #dadac4; PADDING-RIGHT: 0px
	|}
	|DIV.top {
	|PADDING-BOTTOM: 0px; PADDING-TOP: 0px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px
	|}
	|A {
	|PADDING-BOTTOM: 1px; PADDING-TOP: 1px
	|}
	|A:link {
	|COLOR: #3366ff
	|}
	|A:visited {
	|COLOR: #3366ff
	|}
	|A:active {
	|COLOR: #3366ff
	|}
	|IMG {
	|MARGIN-LEFT: 3px
	|}
	|</STYLE>
	|</HEAD>
	|<BODY scroll=auto>
	|<DIV class=top><FONT size=2>%text%</FONT> </DIV></BODY></HTML>";
	
	ТекстПредупреждения = СтрЗаменить(Шаблон, "%text%", ТекстПредупреждения);
	
	Описание = ТекстПредупреждения;
	
КонецПроцедуры
