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
        <%
            String url = "jdbc:derby://localhost:1527/hrdb";
            String username = "root";
            String password = "bcenter";
            Connection connection = DriverManager.getConnection(url, username, password);
            Statement statement = connection.createStatement();
            String query;
            ResultSet rs = null;

            String dates, times, branch;

            if (session.getAttribute("search").equals("true")) {
                dates = String.valueOf(session.getAttribute("dateSearch"));
                times = String.valueOf(session.getAttribute("timeSearch"));
                branch = String.valueOf(session.getAttribute("branchSearch"));
            } else {
                dates = String.valueOf(session.getAttribute("dates"));
                times = String.valueOf(session.getAttribute("times"));
                branch = String.valueOf(session.getAttribute("branch"));
            }

        %>
        <script type="text/javascript"></script>
        <link rel="stylesheet" type="text/css" href="css/style.css">
    </head>

    <body>
        <a href="/hr/sign-out" class="pull-right btn btn-link">Выход</a>
        <a href="http://biznesfon.ru"><img class="logimg" src="http://savepic.ru/14679379.png" alt="logotype"></a>
        
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
                        
                        <button type="submit" name="action" value="SetBranch" class="pull-right btn btn-link citybtn">&#10003;</button>
                        <% out.print("<select data-width='180px' class='gap-bottom branch selectpicker show-tick' name='branch' required>"
                                    + "<option selected>" + branch + "</option>"
                                    + "<option>Санкт-Петербург</option>"
                                    + "<option>Димитровград</option>"
                                    + "<option>Рефтинский</option>"
                                    + "<option>Асбест</option>"
                                    + "<option>Челябинск</option></select>");
                        %>
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
                                    int currentMonth = calendar.getTime().getMonth();

                                    ArrayList<String> months = new ArrayList<String>();
                                    months.add("Январь");
                                    months.add("Февраль");
                                    months.add("Март");
                                    months.add("Апрель");
                                    months.add("Май");
                                    months.add("Июнь");
                                    months.add("Июль");
                                    months.add("Август");
                                    months.add("Сентябрь");
                                    months.add("Октябрь");
                                    months.add("Ноябрь");
                                    months.add("Декабрь");

                                    for (int month = currentMonth + 1; month < currentMonth + 3; month++) {

                                        out.print("<h4><span>" + months.get(month - 1) + ":</span></h4><ul>");

                                        calendar.set(2017, month - 1, 1);
                                        int countOfDays = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

                                        for (int day = 1; day <= countOfDays; day++) {
                                            String prepareDay, checked = "";
                                            if (day < 10) {
                                                prepareDay = ("0" + day);
                                            } else {
                                                prepareDay = "" + day;
                                            }
                                            query = "SELECT count(*) FROM candidates where dates = '2017-0" + month + "-" + prepareDay + "' and branch = '" + branch + "'";
                                            rs = statement.executeQuery(query);
                                            rs.next();
                                            if (("2017-0" + month + "-" + prepareDay).equals(dates)) {
                                                checked = "checked";
                                            }
                                            out.print("<li><label><input onClick='this.form.submit()' "
                                                    + checked + " required type='radio' name='dates' value='2017-0"
                                                    + month + "-" + prepareDay + "'>"
                                                    + prepareDay + ".0" + month + ".2017</label><span class='badge'>" + rs.getString(1) + "</span></li>");
                                        }
                                        out.print("</ul>");
                                    }
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

                                            out.print("<li><label><input onClick='this.form.submit()' "
                                                    + checked + " required type='radio' name='times' value='" + hoursFrom + minutesFrom + "'>"
                                                    + hoursFrom + minutesFrom + " – " + hoursTo + minutesTo + "</label><span class='badge'>"
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
                                <button type="submit" name="action" value="Edit" class="pull-right btn btn-warning">Ред.</button>
                            </div>
                            <div class="panel-body">
                                <div class='stroke header'>
                                    <div>Фамилия</div>
                                    <div>Имя</div>
                                    <div>Отчество</div>
                                    <div>Телефон</div>
                                    <div>Статус</div>
                                    <div>Проект</div>
                                </div>
                                <hr>
                                <%
                                    query = "SELECT * FROM candidates where dates = '" + dates
                                            + "' and times = '" + times
                                            + "' and branch = '" + branch + "'";
                                    System.out.println(query);
                                    connection = DriverManager.getConnection(url, username, password);
                                    statement = connection.createStatement();
                                    rs = statement.executeQuery(query);

                                    while (rs.next()) {
                                        out.print("<label><input required type='radio' name='candidate' value='" + rs.getString(5) + "'><div class='stroke'>"
                                                + "<div>" + rs.getString(2) + "</div>"
                                                + "<div>" + rs.getString(3) + "</div>"
                                                + "<div>" + rs.getString(4) + "</div>"
                                                + "<div>" + rs.getString(5) + "</div>"
                                                + "<div>" + rs.getString(6) + "</div>"
                                                + "<div>" + rs.getString(7) + "</div></div></label>");
                                    }
                                    request.getSession().setAttribute("search", "false");
                                %>
                                <hr>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="sign"> 
                &copy; This application has been created by Roman Kharitonov. All rights reserved.
            </div>
        </div> 
    </body>
</html>