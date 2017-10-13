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
        <link rel="stylesheet" type="text/css" href="css/style.css">
    </head>
    <body>
        <%
            // параметры для подключения к базе данных hrdb
            String url = "jdbc:derby://localhost:1527/hrdb";
            String username = "root";
            String password = "bcenter";
            // получение соединения с БД, расположенной по url, используя username/password     
            Connection connection = DriverManager.getConnection(url, username, password);
            Statement statement = connection.createStatement();
            String query = String.valueOf(request.getSession().getAttribute("query"));
            ResultSet rs = statement.executeQuery(query); 
            System.out.println("downloading > QUERY: " + query);
        %>

        <div class="containerDownload">
            <div class="row">
                <div class="panel panel-default">
                    <div id="download">
                        <form action="Download" method="Get">
                            <div>&ensp;</div>
                            <div> 
                                <select class='gap-bottom' name='branch'>
                                    <%
                                        String spb = "", dmt = "", rft = "", asb = "", chl = "", dom = "", null_branch = "";

                                        if ("СанктПетербург".equals(session.getAttribute("branch-download")))       { spb = "selected";}
                                        else if ("Димитровград".equals(session.getAttribute("branch-download")))    { dmt = "selected";}
                                        else if ("Рефтинский".equals(session.getAttribute("branch-download")))      { rft = "selected";}
                                        else if ("Асбест".equals(session.getAttribute("branch-download")))          { asb = "selected";}
                                        else if ("Челябинск".equals(session.getAttribute("branch-download")))       { chl = "selected";}
                                        else if ("ДО".equals(session.getAttribute("branch-download")))              { dom = "selected";}
                                        else { null_branch = "selected";}

                                        out.print(
                                            "<option " + null_branch + " value='null'>Все</option>"
                                          + "<option " + spb + " value='СанктПетербург'>Санкт-Петербург</option>"
                                          + "<option " + dmt + " >Димитровград</option>"
                                          + "<option " + rft + " >Рефтинский</option>"
                                          + "<option " + asb + " >Асбест</option>"
                                          + "<option " + chl + " >Челябинск</option>"
                                          + "<option " + dom + " value='ДО'>Домашний оператор</option>");

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
                                        String[] status = new String[9];
                                        String null_status = "";

                                        for (int i = 0; i < status.length; i++) {
                                            status[i] = ""; 
                                        }
                                        
                                        if ("1) пригл. на собесед.".equals(session.getAttribute("status"))) { status[0] = "selected";}
                                        else if ("2) пригл. на обучение".equals(session.getAttribute("status"))) {  status[1] = "selected";}
                                        else if ("3) на обучении".equals(session.getAttribute("status")))   {  status[2] = "selected";}
                                        else if ("4) выход на линию".equals(session.getAttribute("status")))    { status[3] = "selected";}
                                        else if ("5) на линии".equals(session.getAttribute("status")))   {   status[4] = "selected";}
                                        else if ("6) уволен".equals(session.getAttribute("status")))   {   status[5] = "selected";}
                                        else if ("X) отказ".equals(session.getAttribute("status")))   {   status[6] = "selected";}
                                        else if ("X) отказался".equals(session.getAttribute("status")))   {   status[7] = "selected";}
                                        else if ("X) не выходит на связь".equals(session.getAttribute("status")))   {   status[8] = "selected";}
                                        else { null_status = "selected";}

                                        out.print(
                                          "<option " + null_status + " value='null'>Все</option>"
                                        + "<option " + status[0] + ">1) пригл. на собесед.</option>"
                                        + "<option " + status[1] + ">2) пригл. на обучение</option>"
                                        + "<option " + status[2] + ">3) на обучении</option>"
                                        + "<option " + status[3] + ">4) выход на линию</option>"
                                        + "<option " + status[4] + ">5) на линии</option>"
                                        + "<option " + status[5] + ">6) уволен</option>"
                                        + "<option " + status[6] + ">X) отказ</option>"
                                        + "<option " + status[7] + ">X) отказался</option>"
                                        + "<option " + status[8] + ">X) не выходит на связь</option>"); %>
                                </select>
                            </div>


                            <div>
                                <select class="gap-bottom" name="project">
                                    <%
                                        String gf = "", tf = "", dst = "", kst = "", null_project = "";

                                        if ("Грузовичкоф".equals(session.getAttribute("project")))          { gf = "selected";}
                                        else if ("Таксовичкоф".equals(session.getAttribute("project")))     { tf = "selected";}
                                        else if ("Достаевский".equals(session.getAttribute("project")))     { dst = "selected";}
                                        else if ("Кисточки".equals(session.getAttribute("project")))        { kst = "selected";}
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

                                        if ("Исх.отклик".equals(session.getAttribute("project")))       { ot = "selected";}
                                        else if ("Исх.хол.зв.".equals(session.getAttribute("project"))) { hol = "selected";}
                                        else if ("Входящий".equals(session.getAttribute("project")))    { vh = "selected";}
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
                                        String[] adv = new String[27]; 
                                        String null_advertising = "";
                                        String advertising = String.valueOf(session.getAttribute("advertising"));
                                        
                                        for (int i = 0; i < adv.length; i++) {
                                            adv[i] = ""; 
                                        }
                                        
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
                                        else { null_status = "advertising";}

                                        out.print(
                                          "<option " + null_advertising + " value='null'>Все</option>"
                                        + "<option " + adv[0] + "  value='HeadHunter'>HeadHunter</option>"
                                        + "<option " + adv[1] + "  value='SuperJob'>SuperJob</option>"
                                        + "<option " + adv[2] + "  value='Avito'>Avito</option>"
                                        + "<option " + adv[3] + "  value='gruzovichkof.ru'>gruzovichkof.ru</option>"
                                        + "<option " + adv[4] + "  value='taxovichkof.ru'>taxovichkof.ru'</option>"
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
                                        + "<option " + adv[26] + " value='chelyabinsk.sopta.ru'>chelyabinsk.sopta.ru</option>"); %>
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
                                    <button type="submit" class="btn btn-success">Выгрузить</button>
                                    <button class="btn" onclick="this.form.reset();">Очистить</button>
                                    <a href="/hr" class="btn btn-link">Вернуться к Dashboard</a>
                                </div>
                        </form>
                    </div> 

                    <div class="panel-heading">Результаты выгрузки</div>
                    <div class="panel-body">
                        <table>
                            <tr>
                                <!--td>Фамилия	</td>
                                <td>Имя         </td>
                                <td>Отчество    </td-->
                                <td>Фамилия Имя Отчество</td>
                                <td>Телефон	</td>
                                <td>e-mail	</td>
                                <!--td>Тек. статус	</td-->
                                <td>Проект	</td>
                                <td>Регион	</td>
                                <!--td>Дата	</td-->
                                <!--td>Время	</td-->
                                <td>Канал связи	</td>
                                <td>Рекламный источник</td>
                                <!--td>Время регистрации</td-->
                                <!--td>Добавил</td-->
                                <td>Пригл. на собесед.</td>  
                                <td>Пригл. на обучение</td>            
                                <td>На обучении</td>                        
                                <td>Выход на линию</td>                        
                                <td>На линии</td>    
                                <td>Уволен</td>
                                <td>Отказ</td>
                                <td>Отказался</td>
                                <td>Не выходит на связь</td>
                                <td>Причина</td>
                            </tr>
                            <%
                                while (rs.next()) {
                                    out.print("<tr>"
                                        /*+ "<td>" + rs.getString(2) + "</td>" // Ф
                                        + "<td>" + rs.getString(3) + "</td>" // И
                                        + "<td>" + rs.getString(4) + "</td>" // О */
                                        + "<td>" + rs.getString(2) + "&nbsp;" + rs.getString(3) + "&nbsp;" + rs.getString(4) + "</td>"  
                                        + "<td>" + rs.getString(5) + "</td>" // тел.
                                        + "<td>" + rs.getString(6) + "</td>" // почта
                                        //+ "<td>" + rs.getString(7) + "</td>" // статус
                                        + "<td>" + rs.getString(8) + "</td>" // проект
                                        + "<td>" + rs.getString(9) + "</td>" // регион
                                        //+ "<td>" + rs.getString(10) + "</td>" // дата
                                        //+ "<td>" + rs.getString(11) + "</td>" // время
                                        + "<td>" + rs.getString(12) + "</td>" // канал
                                        + "<td>" + rs.getString(13) + "</td>" // рекл.ист.
                                        //+ "<td>" + rs.getString(14) + "</td>" // время рег.
                                        //+ "<td>" + rs.getString(15) + "</td>" // добавил
                                    ); 
                                    for (int i = 16; i < 25; i++) {
                                        if (i == 18 && rs.getString(7).equals("3) на обучении")) out.print("<td class='bigfontsize'>🎓</td>"); 
                                        else if (i == 20 && rs.getString(7).equals("5) на линии")) out.print("<td class='bigfontsize'>☎</td>"); 
                                        else if (rs.getString(i) == null) out.print("<td>&#8209;&#8209;.&#8209;&#8209;.&#8209;&#8209;&#8209;&#8209;</td>");
                                        else {
                                            String displayDate = LocalDate.parse(rs.getString(i), DateTimeFormatter.ofPattern("yyyy-MM-dd")).format(DateTimeFormatter.ofPattern("dd.MM.yyyy", new Locale("ru")));                              
                                            out.print("<td>" + displayDate + "</td>");
                                        }  
                                    }     
                                    if (rs.getString(25) == null) out.print("<td>–</td>"); else out.print("<td>" + rs.getString(25) + "</td>");
                                }
      
                                connection.close();
                                connection = null;
                                statement.close();
                                statement = null;
                                rs.close();
                                rs = null;
                            %>
                        </table>
                    </div>
                    <!--div class="sign"> 
                        &copy; This application has been developed by Roman Kharitonov. All rights reserved.
                    </div--> 
                </div> 
            </div>
        </div> 
    </body>
</html>
