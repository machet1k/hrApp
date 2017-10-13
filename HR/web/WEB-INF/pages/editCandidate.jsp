<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Locale"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet;"%>
<%@page import="com.hr.web.Authentication;"%>
<%@page import="com.hr.web.Edit;"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Редактирование кандидата</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link href="css/groundwork.css" type="text/css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="icon" type="image/x-icon" href="http://savepic.ru/14659608.png"/>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

        <script>
            /* var СанктПетербург = Array('HeadHunter', 'SuperJob', 'Avito', 'Сайт Грузовичкоф', 'Сайт Таксовичкоф', 'Сайт БизнесФон', 'Яндекс.Работа', 'Rabota.ru', 'Знакомые', 'Не помнят');
            var Димитровград = СанктПетербург.concat(Array('trisosny.ru', '25kanal.ru', 'dimitrovgradros.flagma.ru'));
            var Асбест = СанктПетербург.concat(Array('maxz.ru', 'asbest-gid.ru', 'asbest.name', 'asbet.ru', 'asbest-online.ru'));
            var Рефтинский = СанктПетербург.concat(Array('reftinskiy.ru', 'reftnews.ru'));
            var Челябинск = СанктПетербург.concat(Array('74.ru', 'chel.barahla.net', 'ubu.ru/chelyabinsk', 'chelyabinsk.gde.ru', 'chelyabinsk.dorus.ru', 'chelyabinsk.bestru.ru', 'chelyabinsk.sopta.ru'));
            var ДО = СанктПетербург.concat(Array('HeadHunter', 'SuperJob', 'Avito', 'Сайт Грузовичкоф', 'Сайт Таксовичкоф', 'Сайт БизнесФон', 'Яндекс.Работа', 'Rabota.ru'));

            function showAdv(v) {
                var mas = eval(v);
                var el = document.getElementById('adv');
                while (el.childNodes.length > 0) {
                    el.removeChild(el.childNodes[el.childNodes.length - 1]);
                }
                for (var i = 0; i < mas.length; i++) {
                    var opt = document.createElement("option");
                    opt.innerHTML = mas[i];
                    el.appendChild(opt);
                }
            } */

            var requiredReason = "";
            var requiredNoteToStatus = "";
            
            function visible(v) {
                if (v == "3) на обучении" || v == "5) на линии") {
                    $('#changedStatus').css('display', 'none');
                    $("#changedStatus").removeAttr('required');
                } else {
                    $('#changedStatus').css('display', 'inline');
                    $("#changedStatus").attr('required', '');
                }
                if (v == "6) уволен" || v == "X) отказ" || v == "X) отказался" || v == "X) не выходит на связь") {
                    $('#reason').css('display', 'inline');
                    $("#reason").attr('required', '');
                } else {
                    $('#reason').css('display', 'none');
                    $("#reason").removeAttr('required');
                }
            }


        </script>

    </head>
    <body onload="showAdv('СанктПетербург')">
        <a href="http://biznesfon.ru"><img class="logimg" src="https://s8.hostingkartinok.com/uploads/images/2017/10/96bfde63dbe76ee39596a1cbed77c3bb.png" alt="logotype"></a>
        <div class="containerEdit">
            <div class="headertext">Редактирование данных кандидата:</div>
            <div id="buffer"></div>
            <div id="edit">
                <form name="myform" action="Edit" method="Post">
                    <%
                        String url = "jdbc:derby://localhost:1527/hrdb";
                        String username = "root";
                        String password = "bcenter";
                        Connection connection = DriverManager.getConnection(url, username, password);
                        Statement statement = connection.createStatement();
                        String query;
                        ResultSet rs = null;

                        //LocalDate date = LocalDate.parse(String.valueOf(request.getSession().getAttribute("dates")), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        //String displayDate = date.format(DateTimeFormatter.ofPattern("dd.MM.yyyy", new Locale("ru")));

                        Calendar calendar = (Calendar) Calendar.getInstance();
                        int currentMonth = calendar.getTime().getMonth();

                        String candidateNumber = request.getParameter("candidate");
                        session.setAttribute("number", candidateNumber);

                        query = "SELECT * FROM candidates WHERE phonenumber = '" + candidateNumber + "'";
                        System.out.println("editCandidate > QUERY: " + query);

                        connection = DriverManager.getConnection(url, username, password);
                        statement = connection.createStatement();
                        rs = statement.executeQuery(query);
                        rs.next();

                        session.setAttribute("status", rs.getString(7));
                        session.setAttribute("dates", rs.getString(10));
                        session.setAttribute("times", rs.getString(11));

                        out.print("<input required class='gap-bottom' type='text' name='surname' placeholder='Фамилия' value='" + rs.getString(2) + "'>");
                        out.print("<input required class='gap-bottom' type='text' name='name' placeholder='Имя' value='" + rs.getString(3) + "'>");
                        out.print("<input required class='gap-bottom' type='text' name='patronymic' placeholder='Отчество' value='" + rs.getString(4) + "'>");
                        out.print("<input required class='gap-bottom' type='text' name='phonenumber' value='"
                                + rs.getString(5) + "'aria-required='true' pattern='[9]{1}[0-9]{9}' readonly>");
                        out.print("<input required class='gap-bottom' type='text' name='email' value='"
                                + rs.getString(6) + "'aria-required='true'>");

                        // Проект V
                        out.print("<select class='gap-bottom' name='project' required>");
                            
                            String gf = "", tf = "", dst = "", kst = "";

                            if ("Грузовичкоф".equals(rs.getString(8)))          { gf = "selected";}
                            else if ("Таксовичкоф".equals(rs.getString(8)))     { tf = "selected";}
                            else if ("Достаевский".equals(rs.getString(8)))     { dst = "selected";}
                            else if ("Кисточки".equals(rs.getString(8)))        { kst = "selected";}

                            out.print(
                                "<option " +  gf + " >Грузовичкоф</option>"
                              + "<option " +  tf + " >Таксовичкоф</option>"
                              + "<option " + dst + " >Достаевский</option>"
                              + "<option " + kst + " >Кисточки</option></select>");
                        
                        // Регион V
                        out.print("<select class='gap-bottom' name='branch' required>"); /*onchange='showAdv(this.value)'*/    
                        
                                String spb = "", dmt = "", rft = "", asb = "", chl = "", dom = "";
                                
                                if ("СанктПетербург".equals(rs.getString(9)))       { spb = "selected";}
                                else if ("Димитровград".equals(rs.getString(9)))    { dmt = "selected";}
                                else if ("Рефтинский".equals(rs.getString(9)))      { rft = "selected";}
                                else if ("Асбест".equals(rs.getString(9)))          { asb = "selected";}
                                else if ("Челябинск".equals(rs.getString(9)))       { chl = "selected";}
                                else if ("ДО".equals(rs.getString(9)))              { dom = "selected";}
                                
                                out.print(
                                    "<option " + spb + " value='СанктПетербург'>Санкт-Петербург</option>"
                                  + "<option " + dmt + " >Димитровград</option>"
                                  + "<option " + rft + " >Рефтинский</option>"
                                  + "<option " + asb + " >Асбест</option>"
                                  + "<option " + chl + " >Челябинск</option>"
                                  + "<option " + dom + " value='ДО'>Домашний оператор</option></select>");
                                
                        // Канал связи V
                        out.print("<select class='gap-bottom' name='channel' required>");
                        
                                String ot = "", hol = "", vh = "";

                                if ("Исх.отклик".equals(rs.getString(12)))       {  ot = "selected";}
                                else if ("Исх.хол.зв.".equals(rs.getString(12))) { hol = "selected";}
                                else if ("Входящий".equals(rs.getString(12)))    {  vh = "selected";}

                                out.print(
                                    "<option " +  ot + " >Исх.отклик</option>"
                                  + "<option " + hol + " >Исх.хол.зв.</option>"
                                  + "<option " +  vh + " >Входящий</option></select>");

                        // Рекламный источник                        
                        out.print("<select class='gap-bottom' name='advertising' required>");
             
                        String[] adv = new String[27]; 
                        String advertising = rs.getString(13);

                        for (int i = 0; i < adv.length; i++) adv[i] = ""; 

                        if      ("HeadHunter".equals(advertising))                  { adv[0]  = "selected";}
                        else if ("SuperJob".equals(advertising))                    { adv[1]  = "selected";}
                        else if ("Avito".equals(advertising))                       { adv[2]  = "selected";}
                        else if ("gruzovichkof.ru".equals(advertising))             { adv[3]  = "selected";}
                        else if ("taxovichkof.ru".equals(advertising))              { adv[4]  = "selected";}
                        else if ("biznesfon.ru".equals(advertising))                { adv[5]  = "selected";}
                        else if ("Яндекс.Работа".equals(advertising))               { adv[6]  = "selected";}
                        else if ("Rabota.ru".equals(advertising))                   { adv[7]  = "selected";}
                        else if ("Не помнят".equals(advertising))                   { adv[8]  = "selected";}
                        else if ("Знакомые".equals(advertising))                    { adv[9]  = "selected";}
                        else if ("trisosny.ru".equals(advertising))                 { adv[10] = "selected";}
                        else if ("25kanal.ru".equals(advertising))                  { adv[11] = "selected";}
                        else if ("dimitrovgradros.flagma.ru".equals(advertising))   { adv[12] = "selected";}
                        else if ("maxz.ru".equals(advertising))                     { adv[13] = "selected";}
                        else if ("asbest-gid.ru".equals(advertising))               { adv[14] = "selected";}
                        else if ("asbest.name".equals(advertising))                 { adv[15] = "selected";}
                        else if ("asbet.ru".equals(advertising))                    { adv[16] = "selected";}
                        else if ("asbest-online.ru".equals(advertising))            { adv[17] = "selected";}
                        else if ("reftinskiy.ru".equals(advertising))               { adv[18] = "selected";}
                        else if ("reftnews.ru".equals(advertising))                 { adv[19] = "selected";}
                        else if ("74.ru".equals(advertising))                       { adv[20] = "selected";}
                        else if ("chel.barahla.net".equals(advertising))            { adv[21] = "selected";}
                        else if ("ubu.ru/chelyabinsk".equals(advertising))          { adv[22] = "selected";}
                        else if ("chelyabinsk.gde.ru".equals(advertising))          { adv[23] = "selected";}
                        else if ("chelyabinsk.dorus.ru".equals(advertising))        { adv[24] = "selected";}
                        else if ("chelyabinsk.bestru.ru".equals(advertising))       { adv[25] = "selected";}
                        else if ("chelyabinsk.sopta.ru".equals(advertising))        { adv[26] = "selected";}

                        out.print(
                          "<option " + adv[0] + "  value='HeadHunter'>HeadHunter</option>"
                        + "<option " + adv[1] + "  value='SuperJob'>SuperJob</option>"
                        + "<option " + adv[2] + "  value='Avito'>Avito</option>"
                        + "<option " + adv[3] + "  value='gruzovichkof.ru'>gruzovichkof.ru</option>"
                        + "<option " + adv[4] + "  value='taxovichkof.ru'>taxovichkof.ru</option>"
                        + "<option " + adv[5] + "  value='biznesfon.ru'>biznesfon.ru</option>"
                        + "<option " + adv[6] + "  value='Яндекс.Работа'>Яндекс.Работа</option>"
                        + "<option " + adv[7] + "  value='Rabota.ru'>Rabota.ru</option>"
                        + "<option " + adv[8] + "  value='Не помнят'>Не помнят</option>"
                        + "<option " + adv[9] + " value='Знакомые'>Знакомые</option>"
                        + "<option " + adv[10] + " value='trisosny.ru'>trisosny.ru</option>"
                        + "<option " + adv[11] + " value='25kanal.ru'>25kanal.ru</option>"
                        + "<option " + adv[12] + " value='dimitrovgradros.flagma.ru'>dimitrovgradros.flagma.ru</option>"
                        + "<option " + adv[13] + " value='maxz.ru'>maxz.ru</option>"
                        + "<option " + adv[14] + " value='asbest-gid.ru'>asbest-gid.ru</option>"
                        + "<option " + adv[15] + " value='asbest.name'>asbest.name</option>"
                        + "<option " + adv[16] + " value='asbet.ru'>asbet.ru</option>"
                        + "<option " + adv[17] + " value='asbest-online.ru'>asbest-online.ru</option>"
                        + "<option " + adv[18] + " value='reftinskiy.ru'>reftinskiy.ru</option>"
                        + "<option " + adv[19] + " value='reftnews.ru'>reftnews.ru</option>"
                        + "<option " + adv[20] + " value='74.ru'>74.ru</option>"
                        + "<option " + adv[21] + " value='chel.barahla.net'>chel.barahla.net</option>"
                        + "<option " + adv[22] + " value='ubu.ru/chelyabinsk'>ubu.ru/chelyabinsk</option>"
                        + "<option " + adv[23] + " value='chelyabinsk.gde.ru'>chelyabinsk.gde.ru</option>"
                        + "<option " + adv[24] + " value='chelyabinsk.dorus.ru'>chelyabinsk.dorus.ru</option>"
                        + "<option " + adv[25] + " value='chelyabinsk.bestru.ru'>chelyabinsk.bestru.ru</option>"
                        + "<option " + adv[26] + " value='chelyabinsk.sopta.ru'>chelyabinsk.sopta.ru</option></select>");

                        
                        // Дата
                        out.print("<select class='gap-bottom' name='dates' required>");

                        String currentDate = String.valueOf(request.getSession().getAttribute("dates"));

                        for (int month = currentMonth + 1; month < currentMonth + 3; month++) {

                            String prepareMonth;

                            calendar.set(2017, month - 1, 1);
                            int countOfDays = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

                            if (month < 10) {
                                prepareMonth = ("0" + month);
                            } else {
                                prepareMonth = "" + month;
                            }

                            for (int day = 1; day <= countOfDays; day++) {
                                String prepareDay, selected = "";

                                if (day < 10) {
                                    prepareDay = ("0" + day);
                                } else {
                                    prepareDay = "" + day;
                                }

                                if (("2017-" + prepareMonth + "-" + prepareDay).equals(currentDate)) {
                                    selected = "selected";
                                }

                                out.print("<option " + selected + " value='2017-"
                                        + prepareMonth + "-" + prepareDay + "'>"
                                        + prepareDay + "." + prepareMonth + ".2017</option>");
                            }
                        }
                        out.print("</select>");

                        // Время
                        out.print("<select class='gap-bottom' name='times' required>");

                        String currentTime = String.valueOf(request.getSession().getAttribute("times")).substring(0, 5);

                        for (int hoursFrom = 10; hoursFrom < 19; hoursFrom++) {
                            for (int j = 0; j < 2; j++) {
                                String minutesFrom;
                                String minutesTo;
                                int hoursTo;
                                String selected = "";

                                if (j % 2 == 0) {
                                    minutesFrom = ":00";
                                    minutesTo = ":30";
                                    hoursTo = hoursFrom;
                                } else {
                                    minutesFrom = ":30";
                                    minutesTo = ":00";
                                    hoursTo = hoursFrom + 1;
                                }

                                if ((hoursFrom + minutesFrom).equals(currentTime)) {
                                    selected = "selected";
                                }
                                out.print("<option " + selected + " value='" + hoursFrom + minutesFrom + "'>"
                                        + hoursFrom + minutesFrom + " – " + hoursTo + minutesTo + "</option>");
                            }
                        }
                        out.print("</select>");

                        // Статус    
                        out.print("<hr>Изменение статуса<hr>");                   
                        out.print("<select class='gap-bottom' name='status' onchange='visible(this.value)'>");
             
                        String[] statuses = new String[9]; 
                        String status = rs.getString(7);

                        for (int i = 0; i < statuses.length; i++) statuses[i] = ""; 

                        if      ("1) пригл. на собесед.".equals(status))    { statuses[0]  = "selected";}
                        else if ("2) пригл. на обучение".equals(status))    { statuses[1]  = "selected";}
                        else if ("3) на обучении".equals(status))           { statuses[2]  = "selected";}
                        else if ("4) выход на линию".equals(status))        { statuses[3]  = "selected";}
                        else if ("5) на линии".equals(status))              { statuses[4]  = "selected";}
                        else if ("6) уволен".equals(status))                { statuses[5]  = "selected";}
                        else if ("X) отказ".equals(status))                 { statuses[6]  = "selected";}
                        else if ("X) отказался".equals(status))             { statuses[7]  = "selected";}
                        else if ("X) не выходит на связь".equals(status))   { statuses[8]  = "selected";}
                        
                        out.print(
                          "<option style='background-color: #ffffaa;'" + statuses[0] + ">1) пригл. на собесед.</option>"
                        + "<option style='background-color: #ffffaa;'" + statuses[1] + ">2) пригл. на обучение</option>"
                        + "<option style='background-color: #aaffaa;'" + statuses[2] + ">3) на обучении</option>"
                        + "<option style='background-color: #ffffaa;'" + statuses[3] + ">4) выход на линию</option>"
                        + "<option style='background-color: #aaffaa;'" + statuses[4] + ">5) на линии</option>"
                        + "<option style='background-color: #ffaaaa;'" + statuses[5] + ">6) уволен</option>"
                        + "<option style='background-color: #ffaaaa;'" + statuses[6] + ">X) отказ</option>"
                        + "<option style='background-color: #ffaaaa;'" + statuses[7] + ">X) отказался</option>"
                        + "<option style='background-color: #ffaaaa;'" + statuses[8] + ">X) не выходит на связь</option></select>");

                        out.print("<input type='date' id='changedStatus' name='changedStatus'>");

                        out.print("<select class='gap-bottom' name='reason' id='reason'>"
                                + "<option selected disabled value=''>Укажите причину отказа/увольнения</option>"
                                + "<option>По состоянию здоровья</option>"
                                + "<option>Нашел др.работу</option>"
                                + "<option>Не отвечает/выкл.</option>"
                                + "<option>Нет оформления</option>"
                                + "<option>Дефекты речи/акцент</option>"
                                + "<option>Не устраивает ЗП</option>"
                                + "<option>Не устраивает график работы</option>"
                                + "<option>Дисциплинарное нарушение</option>"
                                + "<option>Курение</option>"
                                + "<option>Плохие отзывы о компании</option>"
                                + "<option>Не хочет работать оператором</option>"
                                + "<option>Без объяснения причин</option>"
                                + "<option>Изменились планы</option>"
                                + "<option>Не устраивают условия работы</option>"
                                + "<option>Сложно обучаться</option>"
                                + "<option>Ранее работал у нас</option>"
                                + "<option>Не подходит по ТХ</option>"
                                + "<option>Личные причины</option>"
                                + "<option>Возраст</option></select>");

                        out.print("<hr>");
                    %>
                    <button type="submit" name="action" value="Editing" class="pull-left btn-warning">Изменить</button>
                </form>    
                <form action="/hr">
                    <button class="pull-right btn-danger">Отмена</button>

                </form> 
            </div>

            <div id="statusdate">
                <%/*
                    String queryStatus = "select status, dates from statuses where phonenumber = '" + candidateNumber + "'";
                    rs = statement.executeQuery(queryStatus);
                    while (rs.next()) {
                        date = LocalDate.parse(String.valueOf(rs.getString(2)), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        displayDate = date.format(DateTimeFormatter.ofPattern("dd.MM.yyyy", new Locale("ru")));
                        out.print("<span>" + displayDate + "</span><span>" + rs.getString(1) + "</span><br>");
                    }
                    connection.close();
                    connection = null;
                    statement.close();
                    statement = null;
                    rs.close();
                    rs = null;*/
                %> 
            </div>
        </div>
    </body>
</html>
