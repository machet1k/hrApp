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
        <title>Набор персонала БизнесФон</title>
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
        <link href="css/style.css" type="text/css" rel="stylesheet">
        
        <%
            String url = "jdbc:derby://localhost:1527/hrdb";
            String username = "root";
            String password = "bcenter";
            Connection connection = DriverManager.getConnection(url, username, password);
            Statement statement = connection.createStatement();
            String query;
            ResultSet rs = null;

            String dates = "", times = "", branch = "";

            if (session.getAttribute("search").equals("true")) {
                if (session.getAttribute("dateSearch") != null
                        && session.getAttribute("timeSearch") != null
                        && session.getAttribute("branchSearch") != null) {
                    dates = String.valueOf(session.getAttribute("dateSearch"));
                    times = String.valueOf(session.getAttribute("timeSearch"));
                    branch = String.valueOf(session.getAttribute("branchSearch"));
                } else {
                    out.print("<script type='text/javascript'>alert('Кандидата с данным номером нет в Базе Данных.');</script>");
                    dates = String.valueOf(session.getAttribute("dates"));
                    times = String.valueOf(session.getAttribute("times"));
                    branch = String.valueOf(session.getAttribute("branch"));
                }
            } else {
                dates = String.valueOf(session.getAttribute("dates"));
                times = String.valueOf(session.getAttribute("times"));
                branch = String.valueOf(session.getAttribute("branch"));
            }
        %>

    </head>

    <body>

        <a href="/hr/sign-out" class="pull-right btn btn-link">Выход [<% out.print(session.getAttribute("role")); %>]</a>
        <a target="_blank" rel="nofollow noopener" href="http://biznesfon.ru"><img class="logimg" src="https://s8.hostingkartinok.com/uploads/images/2017/10/96bfde63dbe76ee39596a1cbed77c3bb.png" alt="logotype"></a>

        <div class="containerIndex">
            <div class="row">
                <form action="Search" method="Post">
                    <div class="pull-right"> 
                        <input required class="phonenumber" type="text" name="phonenumber" placeholder="9115557799" pattern="[9]{1}[0-9]{9}">
                        <button class="pull-right btn btn-link searchbtn" type="submit" name="action" value="SetBranch" >Поиск</button>
                    </div>
                </form>

                <form action="Add" method="Post">
                    <div class="align_right">

                        <button type="submit" name="action" value="SetBranch" class="pull-right btn btn-link choose">Выбрать</button>
                        <select data-width='175px' class='gap-bottom branch selectpicker show-tick' name='branch' required>
                            <%
                                String spb = "", dmt = "", rft = "", asb = "", chl = "", dom = "";

                                if ("СанктПетербург".equals(session.getAttribute("branch")))       { spb = "selected";}
                                else if ("Димитровград".equals(session.getAttribute("branch")))    { dmt = "selected";}
                                else if ("Рефтинский".equals(session.getAttribute("branch")))      { rft = "selected";}
                                else if ("Асбест".equals(session.getAttribute("branch")))          { asb = "selected";}
                                else if ("Челябинск".equals(session.getAttribute("branch")))       { chl = "selected";}
                                else if ("ДО".equals(session.getAttribute("branch")))              { dom = "selected";}

                                out.print(
                                    "<option " + spb + " value='СанктПетербург'>Санкт-Петербург</option>"
                                  + "<option " + dmt + " >Димитровград</option>"
                                  + "<option " + rft + " >Рефтинский</option>"
                                  + "<option " + asb + " >Асбест</option>"
                                  + "<option " + chl + " >Челябинск</option>"
                                  + "<option " + dom + " value='ДО'>Домашний оператор</option>");

                            %>
                        </select>
                        
                        
                    </div>
                    <h3><span>Human Resourse App:</span> Набор персонала БизнесФон.</h3>

                    <div id="date">
                        <div class="panel panel-default">
                            <div class="panel-heading">Дата</div>
                            <div class="panel-body scalable">
                                <%                                   
                                    LocalDate date = LocalDate.parse(dates, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                                    String displayDate = date.format(DateTimeFormatter.ofPattern("dd.MM.yyyy", new Locale("ru")));

                                    Calendar calendar = (Calendar) Calendar.getInstance();
                                    int currentMonth = calendar.getTime().getMonth() + 1;
                                    int nextMonth = calendar.getTime().getMonth() + 2;
                                    int currentDay = calendar.getTime().getDate();
                                    int countOfDays = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

                                    out.print("<h4><span>Месяц:</span></h4><ul>");
                                    
                                    for (int day = currentDay; day <= countOfDays; day++) {
                                        String prepareDay, prepareMonth, checked = "";

                                        if (currentMonth < 10) prepareMonth = ("0" + currentMonth);
                                        else prepareMonth = "" + currentMonth;
                                        
                                        if (day < 10) prepareDay = ("0" + day);
                                        else prepareDay = "" + day;

                                        query = "SELECT count(*) FROM candidates where dates = '2017-" + prepareMonth + "-" + prepareDay + "' and branch = '" + branch + "'";
                                        System.out.println("currentMonth -->: " + query);
                                        rs = statement.executeQuery(query);
                                        rs.next();
                                        if (("2017-" + prepareMonth + "-" + prepareDay).equals(dates)) checked = "checked";

                                        String fill = "";
                                        if (!rs.getString(1).equals("0")) fill = "fill";

                                        out.print("<li><label><input onClick='this.form.submit()' "
                                                + checked + " required type='radio' name='dates' value='2017-"
                                                + prepareMonth + "-" + prepareDay + "'>"
                                                + prepareDay + "." + prepareMonth + ".2017</label><span class='badge " + fill + "'>" + rs.getString(1) + "</span></li>");
                                    }
  
                                    for (int day = 1; day < currentDay; day++) {
                                        String prepareDay, prepareMonth, checked = "";

                                        if (nextMonth < 10) prepareMonth = ("0" + nextMonth);
                                        else prepareMonth = "" + nextMonth;
                                        
                                        if (day < 10) prepareDay = ("0" + day);
                                        else prepareDay = "" + day;

                                        query = "SELECT count(*) FROM candidates where dates = '2017-" + prepareMonth + "-" + prepareDay + "' and branch = '" + branch + "'";
                                        System.out.println("nextMonth -->: " + query);
                                        rs = statement.executeQuery(query);
                                        rs.next();
                                        if (("2017-" + prepareMonth + "-" + prepareDay).equals(dates)) checked = "checked";

                                        String fill = "";
                                        if (!rs.getString(1).equals("0")) fill = "fill";

                                        out.print("<li><label><input onClick='this.form.submit()' "
                                                + checked + " required type='radio' name='dates' value='2017-"
                                                + prepareMonth + "-" + prepareDay + "'>"
                                                + prepareDay + "." + prepareMonth + ".2017</label><span class='badge " + fill + "'>" + rs.getString(1) + "</span></li>");
                                    }
                                    
                                    
                                    out.print("</ul>");
                                %>
                            </div>
                        </div>
                    </div>
                    <div id="time">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                Время
                                <button type="submit" name="action" value="Add" class="pull-right btn btn-success">Добавить</button>
                            </div>
                            <div class="panel-body scalable">

                                <%
                                    out.print("<h4><span>" + displayDate + ":</span></h4><ul>");
                                    for (int hoursFrom = 10; hoursFrom < 19; hoursFrom++) {

                                        for (int j = 0; j < 2; j++) {

                                            String minutesFrom;
                                            String minutesTo;
                                            int hoursTo;
                                            String checked = "";

                                            if (j % 2 == 0) {
                                                minutesFrom = ":00";
                                                minutesTo = ":30";
                                                hoursTo = hoursFrom;
                                            } else {
                                                minutesFrom = ":30";
                                                minutesTo = ":00";
                                                hoursTo = hoursFrom + 1;
                                            }
                                            query = "SELECT count(*) FROM candidates where dates = '" + dates
                                                    + "' and times = '" + hoursFrom + minutesFrom
                                                    + "' and branch = '" + branch + "'";
                                            rs = statement.executeQuery(query);
                                            rs.next();
                                            if ((hoursFrom + minutesFrom).equals(times) || (hoursFrom + minutesFrom + ":00").equals(times)) {
                                                checked = "checked";
                                            }

                                            String fill = "";
                                            if (!rs.getString(1).equals("0")) {
                                                fill = "fill";
                                            }
                                            out.print("<li><label><input onClick='this.form.submit()' "
                                                    + checked + " required type='radio' name='times' value='" + hoursFrom + minutesFrom + "'>"
                                                    + hoursFrom + minutesFrom + " – " + hoursTo + minutesTo + "</label><span class='badge " + fill + "'>"
                                                    + rs.getString(1) + "</span></li>");
                                        }
                                    }
                                    out.print("</ul>");
                                %>

                            </div>
                        </div>
                    </div>
                </form>
                <form action="Edit" method="Post">
                    <div id="candidates">
                        <div class="panel panel-default">
                            <div class="panel-heading">Кандидаты на
                                <%
                                    out.print(displayDate + " к " + times.substring(0, 5));
                                %>
                                <button type="submit" name="action" value="Delete" class="pull-right btn btn-danger">Удалить</button>
                                <button type="submit" name="action" value="Edit" class="pull-right btn btn-warning">Изменить</button>
                            </div>
                            <div class="panel-body">
                                <div class='stroke header'>
                                    <div class="verywider">Фамилия Имя Отчество</div>
                                    <!--div class="normal">Фамилия</div>
                                    <div class="normal">Имя</div>
                                    <div class="normal">Отчество</div-->
                                    <div class="normal">Телефон</div>
                                    <div class="wider">e-mail</div>
                                    <div class="normal">Проект</div>
                                    <div class="wider">Статус</div>
                                    <!--div class="narrower">Action</div-->
                                    <!--div class="normal">Менеджер</div-->
                                </div>
                                <hr>
                                <%
                                    query = "SELECT * FROM candidates where dates = '" + dates
                                            + "' and times = '" + times
                                            + "' and branch = '" + branch + "'";
                                    System.out.println("index > QUERY: " + query);
                                    connection = DriverManager.getConnection(url, username, password);
                                    statement = connection.createStatement();
                                    rs = statement.executeQuery(query);

                                    while (rs.next()) {

                                        String shortEmail = rs.getString(6);
                                        if (shortEmail.length() > 20) {
                                            shortEmail = shortEmail.substring(0, 20).concat("..");
                                        }

                                        out.print("<label><input required type='radio' name='candidate' value='" + rs.getString(5) + "'><div class='stroke'>"
                                                + "<div class='verywider'>" + rs.getString(2) + " " + rs.getString(3) + " " + rs.getString(4) + "</div>"
                                                /*+ "<div class='normal'>" + rs.getString(3) + "</div>"
                                                + "<div class='normal'>" + rs.getString(4) + "</div>"*/
                                                + "<div class='normal'>" + rs.getString(5) + "</div>"
                                                + "<div class='wider' title='" + rs.getString(6) + "'>" + shortEmail + "</div>"
                                                + "<div class='normal'>" + rs.getString(8) + "</div>"
                                                /*+ "<div class='normal'>" + rs.getString(15) + "</div>"*/
                                                + "<div class='wider'>" + rs.getString(7) + "</div>"
                                                /*+ "<div class='narrower'><button class='btn btn-warning btn-xs' type='button'>Ред.</button></div>"*/
                                                + "</div></label>");
                                    }
                                    request.getSession().setAttribute("search", "false");
                                    request.getSession().setAttribute("dateSearch", null);
                                    request.getSession().setAttribute("timeSearch", null);
                                    request.getSession().setAttribute("branchSearch", null);
                                    
                                    connection.close();
                                    connection = null;
                                    statement.close();
                                    statement = null;
                                    rs.close();
                                    rs = null;                                    

                                %>
                                <hr>
                            </div>
                        </div>
                    </div>
                </form>

                <form action="Download" method="Get" target="_blank">
                    <div id="download">

                        
                        <div>
                            <select class="gap-bottom" name="branch">
                                <option selected disabled value=''>Площадка</option>
                                <option value="СанктПетербург">Санкт-Петербург</option>
                                <option>Димитровград</option>
                                <option>Рефтинский</option>
                                <option>Асбест</option>
                                <option>Челябинск</option>
                                <option value='ДО'>Домашний оператор</option>
                            </select>
                        </div>

                        <%
                            String prepareMonth, prepareDay;
                            if (currentMonth < 10) prepareMonth = ("0" + currentMonth);
                                else prepareMonth = "" + currentMonth;

                                if (currentDay < 10) prepareDay = ("0" + currentDay);
                                else prepareDay = "" + currentDay;
                        %>
                        
                        <div>c</div>
                        <% out.print("<div><input type='date' name='from' required value='2017-" + prepareMonth + "-" + prepareDay + "'></div>"); %>
                        <div>по</div>
                        <% out.print("<div><input type='date' name='to' required value='2017-" + prepareMonth + "-" + calendar.getActualMaximum(Calendar.DAY_OF_MONTH) + "'></div>"); %>
                        
                        <div><select class="gap-bottom" name="status">
                                <option selected disabled value=''>Статус</option>
                                <option>1) пригл. на собесед.</option>
                                <option>2) пригл. на обучение</option>
                                <option>3) на обучении</option>
                                <option>4) выход на линию</option>
                                <option>5) на линии</option>
                                <option>6) уволен</option>
                                <option>X) отказ</option>
                                <option>X) отказался</option>
                                <option>X) не выходит на связь</option>
                            </select></div>

                        <div><select class="gap-bottom" name="project">
                                <option selected disabled value=''>Проект</option>
                                <option>Грузовичкоф</option>
                                <option>Таксовичкоф</option>
                                <option>Достаевский</option>
                                <option>Кисточки</option>
                            </select></div>

                        <div><select class="gap-bottom" name="channel">
                                <option selected disabled value=''>Канал связи</option>
                                <option title="Исходящий(отклик)">Исх.отклик</option>
                                <option title="Исходящий(холодный звонок)">Исх.хол.зв.</option>
                                <option title="Входящий">Входящий</option>
                            </select></div>

                        <div><select class="gap-bottom" name="advertising">
                                https://s8.hostingkartinok.com/uploads/images/2017/10/96bfde63dbe76ee39596a1cbed77c3bb.png
                                <option>HeadHunter</option>
                                <option>SuperJob</option>
                                <option>Avito</option>
                                <option>Сайт Грузовичкоф</option>
                                <option>Сайт Таксовичкоф</option>
                                <option>Сайт БизнесФон</option>
                                <option>Яндекс.Работа</option>
                                <option>Rabota.ru</option>
                                <option>Не помнят</option>
                                <option>Знакомые</option>
                                <option>trisosny.ru</option>
                                <option>25kanal.ru</option>
                                <option>dimitrovgradros.flagma.ru</option>
                                <option>maxz.ru</option>
                                <option>asbest-gid.ru</option>
                                <option>asbest.name</option>
                                <option>asbet.ru</option>
                                <option>asbest-online.ru</option>
                                <option>reftinskiy.ru</option>
                                <option>reftnews.ru</option>
                                <option>74.ru</option>
                                <option>chel.barahla.net</option>
                                <option>ubu.ru/chelyabinsk</option>
                                <option>chelyabinsk.gde.ru</option>
                                <option>chelyabinsk.dorus.ru</option>
                                <option>chelyabinsk.bestru.ru</option>
                                <option>chelyabinsk.sopta.ru</option>
                            </select></div>

                        <div class="downloadbtn">
                            <button type="submit" class="btn btn-primary">Выгрузить</button>
                            <button type="reset" class="btn">Очистить</button>
                        </div>
                    </div> 
                </form>
                <div class="sign"> 
                    &copy; This application has been developed by Roman Kharitonov. All rights reserved.
                </div> 
            </div>                                
        </div> 
    </body>
</html>