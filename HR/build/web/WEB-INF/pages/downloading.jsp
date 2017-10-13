<%@page import="java.util.Locale"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.hr.web.Add"%>
<%@page import="com.hr.web.Authentication"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet;"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.time.LocalDate;"%>
<%@page import="java.time.format.DateTimeFormatter;"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Результаты выгрузки</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script src="http://code.jquery.com/jquery-latest.js"></script>
        <script src="js/script.js"></script>
        <link href="css/groundwork.css" type="text/css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.12.2/css/bootstrap-select.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.12.2/js/bootstrap-select.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.12.2/js/i18n/defaults-*.min.js"></script>
        <link rel="icon" type="image/x-icon" href="http://savepic.ru/14659608.png"/>
        <%
            // параметры для подключения к базе данных hrdb
            String url = "jdbc:derby://localhost:1527/hrdb";
            String username = "root";
            String password = "bcenter";
            // получение соединения с БД, расположенной по url, используя username/password
            Connection connection = DriverManager.getConnection(url, username, password);
            Statement statement = connection.createStatement();
            String query = String.valueOf(request.getSession().getAttribute("query"));
            ResultSet rs = null;

            System.out.println("downloading > QUERY: " + query);
        %>
        <link rel="stylesheet" type="text/css" href="css/style.css">
    </head>
    <body>
        <a href="http://biznesfon.ru"><img class="logimg" src="https://pp.userapi.com/c837636/v837636687/526af/LMmzKvJQDdM.jpg" alt="logotype"></a>
        <div class="containerDownload">
            <div class="row">
                <div class="panel panel-default">

                    <div id="download">
                        <form action="Download" method="Post">

                            <div> </div>
                            <div>
                                <select class='gap-bottom' name='branch'>
                                    <%
                                        String spb = "", dmt = "", rft = "", asb = "", chl = "", dom = "", null_branch = "";

                                        if ("СанктПетербург".equals(session.getAttribute("branch-download"))) { spb = "selected";}
                                        else if ("Димитровград".equals(session.getAttribute("branch-download"))) { dmt = "selected";}
                                        else if ("Рефтинский".equals(session.getAttribute("branch-download")))   { rft = "selected";}
                                        else if ("Асбест".equals(session.getAttribute("branch-download")))    { asb = "selected";}
                                        else if ("Челябинск".equals(session.getAttribute("branch-download")))   { chl = "selected";}
                                        else if ("ДО".equals(session.getAttribute("branch-download")))   { dom = "selected";}
                                        else { null_branch = "selected";}

                                        out.print(
                                            "<option " + null_branch + " value='null'>Все</option>"
                                          + "<option " + spb + " value='СанктПетербург'>Санкт-Петербург</option>"
                                          + "<option " + dmt + " >Димитровград</option>"
                                          + "<option " + rft + " >Рефтинский</option>"
                                          + "<option " + asb + " >Асбест</option>"
                                          + "<option " + chl + " >Челябинск</option>"
                                          + "<option " + dom + "  value='ДО'>Домашний оператор</option>");

                                    %>
                                </select>
                            </div>

                            <div>c</div>
                            <% out.print("<div><input type='date' name='from' required value='" + session.getAttribute("from") + "'></div>"); %>

                            <div>по</div>
                            <% out.print("<div><input type='date' name='to' required value='" + session.getAttribute("to") + "'></div>"); %>

                            <div>
                                <select class="gap-bottom" name="status">
                                    <% 
                                        String sob = "", ob = "", pr = "", otk = "", n = "", null_status = "";

                                        if ("собеседование".equals(session.getAttribute("status"))) { sob = "selected";}
                                        else if ("обучение".equals(session.getAttribute("status"))) {  ob = "selected";}
                                        else if ("принят".equals(session.getAttribute("status")))   {  pr = "selected";}
                                        else if ("отказ".equals(session.getAttribute("status")))    { otk = "selected";}
                                        else if ("неявка".equals(session.getAttribute("status")))   {   n = "selected";}
                                        else { null_status = "selected";}

                                        out.print(
                                          "<option " + null_status + " value='null'>Все</option>"
                                        + "<option " + sob + " value='собеседование'>собеседование</option>"
                                        + "<option " + ob + " value='обучение'>обучение</option>"
                                        + "<option " + pr + " value='принят'>принят</option>"
                                        + "<option " + otk + " value='отказ'>отказ</option>"
                                        + "<option " + n + " value='неявка'>неявка</option>"); %>
                                </select>
                            </div>


                            <div>
                                <select class="gap-bottom" name="project">
                                    <%
                                        String gf = "", tf = "", dst = "", kst = "", null_project = "";

                                        if ("Грузовичкоф".equals(session.getAttribute("project"))) { gf = "selected";}
                                        else if ("Таксовичкоф".equals(session.getAttribute("project"))) { tf = "selected";}
                                        else if ("Достаевский".equals(session.getAttribute("project")))   { dst = "selected";}
                                        else if ("Кисточки".equals(session.getAttribute("project")))    { kst = "selected";}
                                        else { null_project = "project";}

                                        out.print(
                                          "<option " + null_project + " value='null'>Все</option>"
                                        + "<option " + gf + " value='Грузовичкоф'>Грузовичкоф</option>"
                                        + "<option " + tf + " value='Таксовичкоф'>Таксовичкоф</option>"
                                        + "<option " + dst + " value='Достаевский'>Достаевский</option>"
                                        + "<option " + kst + " value='Кисточки'>Кисточки</option>"); %>
                                </select>
                            </div>

                            <div>
                                <select class="gap-bottom" name="channel">
                                    <%
                                        String ot = "", hol = "", vh = "", null_channel = "";

                                        if ("Исх.отклик".equals(session.getAttribute("project"))) { ot = "selected";}
                                        else if ("Исх.хол.зв.".equals(session.getAttribute("project"))) { hol = "selected";}
                                        else if ("Входящий".equals(session.getAttribute("project")))   { vh = "selected";}
                                        else { null_channel = "channel";}

                                        out.print(
                                          "<option " + null_channel + " value='null'>Все</option>"
                                        + "<option " + ot + " value='Исх.отклик'>Исх.отклик</option>"
                                        + "<option " + hol + " value='Исх.хол.зв.'>Исх.хол.зв.</option>"
                                        + "<option " + vh + " value='Входящий'>Входящий</option>"); %>
                                    %>
                                </select>
                            </div>

                            <div>
                                <select class="gap-bottom" name="advertising">
                                    <%
                                        String adv1 = "", adv2 = "", adv3 = "", adv4 = "", adv5 = "", adv6 = "", adv7 = "", adv8 = "", adv9 = "", adv10 = "",
                                               adv11 = "", adv12 = "", adv13 = "", adv14 = "", adv15 = "", adv16 = "", adv17 = "", adv18 = "", adv19 = "", adv20 = "",
                                               adv21 = "", adv22 = "", adv23 = "", adv24 = "", adv25 = "", adv26 = "", adv27 = "", null_advertising = "";

                                        if      ("HeadHunter".equals(session.getAttribute("advertising"))) { adv1 = "selected";}
                                        else if ("SuperJob".equals(session.getAttribute("advertising"))) { adv2 = "selected";}
                                        else if ("Avito".equals(session.getAttribute("advertising"))) { adv3  = "selected";}
                                        else if ("gruzovichkof.ru".equals(session.getAttribute("advertising"))) { adv4  = "selected";}
                                        else if ("taxovichkof.ru".equals(session.getAttribute("advertising"))) { adv5  = "selected";}
                                        else if ("biznesfon.ru".equals(session.getAttribute("advertising"))) { adv6  = "selected";}
                                        else if ("Яндекс.Работа".equals(session.getAttribute("advertising"))) { adv7  = "selected";}
                                        else if ("Rabota.ru".equals(session.getAttribute("advertising"))) { adv8  = "selected";}
                                        else if ("Не помнят".equals(session.getAttribute("advertising"))) { adv9  = "selected";}
                                        else if ("Знакомые".equals(session.getAttribute("advertising"))) { adv10 = "selected";}
                                        else if ("trisosny.ru".equals(session.getAttribute("advertising"))) { adv11 = "selected";}
                                        else if ("25kanal.ru".equals(session.getAttribute("advertising"))) { adv12 = "selected";}
                                        else if ("dimitrovgradros.flagma.ru".equals(session.getAttribute("advertising"))) { adv13 = "selected";}
                                        else if ("maxz.ru".equals(session.getAttribute("advertising"))) { adv14 = "selected";}
                                        else if ("asbest-gid.ru".equals(session.getAttribute("advertising"))) { adv15 = "selected";}
                                        else if ("asbest.name".equals(session.getAttribute("advertising"))) { adv16 = "selected";}
                                        else if ("asbet.ru".equals(session.getAttribute("advertising"))) { adv17 = "selected";}
                                        else if ("asbest-online.ru".equals(session.getAttribute("advertising"))) { adv18 = "selected";}
                                        else if ("reftinskiy.ru".equals(session.getAttribute("advertising"))) { adv19 = "selected";}
                                        else if ("reftnews.ru".equals(session.getAttribute("advertising"))) { adv20 = "selected";}
                                        else if ("74.ru".equals(session.getAttribute("advertising"))) { adv21 = "selected";}
                                        else if ("chel.barahla.net".equals(session.getAttribute("advertising"))) { adv22 = "selected";}
                                        else if ("ubu.ru/chelyabinsk".equals(session.getAttribute("advertising"))) { adv23 = "selected";}
                                        else if ("chelyabinsk.gde.ru".equals(session.getAttribute("advertising"))) { adv24 = "selected";}
                                        else if ("chelyabinsk.dorus.ru".equals(session.getAttribute("advertising"))) { adv25 = "selected";}
                                        else if ("chelyabinsk.bestru.ru".equals(session.getAttribute("advertising"))) { adv26 = "selected";}
                                        else if ("chelyabinsk.sopta.ru".equals(session.getAttribute("advertising"))) { adv27 = "selected";}
                                        else { null_status = "advertising";}

                                        out.print(
                                          "<option " + null_advertising + " value='null'>Все</option>"
                                        + "<option " + adv1 + "  value='HeadHunter'>HeadHunter</option>"
                                        + "<option " + adv2 + "  value='SuperJob'>SuperJob</option>"
                                        + "<option " + adv3 + "  value='Avito'>Avito</option>"
                                        + "<option " + adv4 + "  value='gruzovichkof.ru'>gruzovichkof.ru</option>"
                                        + "<option " + adv5 + "  value='taxovichkof.ru'>taxovichkof.ru'</option>"
                                        + "<option " + adv6 + "  value='biznesfon.ru'>biznesfon.ru</option>"
                                        + "<option " + adv7 + "  value='Яндекс.Работа'>Яндекс.Работа</option>"
                                        + "<option " + adv8 + "  value='Rabota.ru'>Rabota.ru</option>"
                                        + "<option " + adv9 + "  value='Не помнят'>Не помнят</option>"
                                        + "<option " + adv10 + " value='Знакомые'>Знакомые</option>"
                                        + "<option " + adv11 + " value='trisosny.ru'>trisosny.ru</option>"
                                        + "<option " + adv12 + " value='25kanal.ru'>25kanal.ru</option>"
                                        + "<option " + adv13 + " value='dimitrovgradros.flagma.ru'>dimitrovgradros.flagma.ru</option>"
                                        + "<option " + adv14 + " value='maxz.ru'>maxz.ru</option>"
                                        + "<option " + adv15 + " value='asbest-gid.ru'>asbest-gid.ru</option>"
                                        + "<option " + adv16 + " value='asbest.name'>asbest.name</option>"
                                        + "<option " + adv17 + " value='asbet.ru'>asbet.ru</option>"
                                        + "<option " + adv18 + " value='asbest-online.ru'>asbest-online.ru</option>"
                                        + "<option " + adv19 + " value='reftinskiy.ru'>reftinskiy.ru</option>"
                                        + "<option " + adv20 + " value='reftnews.ru'>reftnews.ru</option>"
                                        + "<option " + adv21 + " value='74.ru'>74.ru</option>"
                                        + "<option " + adv22 + " value='chel.barahla.net'>chel.barahla.net</option>"
                                        + "<option " + adv23 + " value='ubu.ru/chelyabinsk'>ubu.ru/chelyabinsk</option>"
                                        + "<option " + adv24 + " value='chelyabinsk.gde.ru'>chelyabinsk.gde.ru</option>"
                                        + "<option " + adv25 + " value='chelyabinsk.dorus.ru'>chelyabinsk.dorus.ru</option>"
                                        + "<option " + adv26 + " value='chelyabinsk.bestru.ru'>chelyabinsk.bestru.ru</option>"
                                        + "<option " + adv27 + " value='chelyabinsk.sopta.ru'>chelyabinsk.sopta.ru</option>"); %>
                                    </select>
                                </div>

                                <% 
                                    request.getSession().setAttribute("branch-download", null);
                                    request.getSession().setAttribute("status", null);
                                    request.getSession().setAttribute("project", null);
                                    request.getSession().setAttribute("channel", null);
                                    request.getSession().setAttribute("advertising", null);
                                %>        

                                <div class="downloadbtn">
                                    <button type="submit" class="btn btn-primary">Выгрузить</button>
                                    <button class="btn" onclick="this.form.reset();">Очистить</button>
                                </div>
                        </form>
                    </div> 

                    <div class="panel-heading">Результаты выгрузки</div>
                    <div class="panel-body">
                        <table>
                            <tr>
                                <td>Фамилия	</td>
                                <td>Имя         </td>
                                <td>Отчество    </td>
                                <td>Телефон	</td>
                                <td>e-mail	</td>
                                <td>Статус	</td>
                                <td>Проект	</td>
                                <td>Регион	</td>
                                <td>Дата	</td>
                                <td>Время	</td>
                                <td>Канал связи	</td>
                                <td>Рекламный источник</td>
                                <td>Время регистрации</td>
                                <td>Менеджер</td>
                            </tr>
                            <%connection = DriverManager.getConnection(url, username, password);
                                statement = connection.createStatement();
                                rs = statement.executeQuery(query);

                                while (rs.next()) {
                                    out.print("<tr>"
                                            + "<td>" + rs.getString(2) + "</td>"
                                            + "<td>" + rs.getString(3) + "</td>"
                                            + "<td>" + rs.getString(4) + "</td>"
                                            + "<td>" + rs.getString(5) + "</td>"
                                            + "<td>" + rs.getString(6) + "</td>"
                                            + "<td>" + rs.getString(7) + "</td>"
                                            + "<td>" + rs.getString(8) + "</td>"
                                            + "<td>" + rs.getString(9) + "</td>"
                                            + "<td>" + rs.getString(10) + "</td>"
                                            + "<td>" + rs.getString(11) + "</td>"
                                            + "<td>" + rs.getString(12) + "</td>"
                                            + "<td>" + rs.getString(13) + "</td>"
                                            + "<td>" + rs.getString(14) + "</td>"
                                            + "<td>" + rs.getString(15) + "</td></tr>"
                                    );
                                }
                            %>

                        </table>
                    </div>
                    <!--div class="sign"> 
                        &copy; This application has been created by Roman Kharitonov. All rights reserved.
                    </div--> 
                </div> 
            </div>
        </div> 
    </body>
</html>