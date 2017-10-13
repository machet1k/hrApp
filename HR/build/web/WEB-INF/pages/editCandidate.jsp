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
    </head>
    <body>
        <a href="http://biznesfon.ru" target="_blank">
            <img class="logimg" src="http://savepic.ru/14679379.png" alt="logotype">
        </a>
        <div class="fadeInDownBig">
            <div class="align_center">Редактирование данных кандидата:</div>
            <div class="one sevenths centered triple-padded">    
                <form action="Edit" method="Post">

                    <%
                        String url = "jdbc:derby://localhost:1527/hrdb";
                        String username = "root";
                        String password = "bcenter";
                        Connection connection = DriverManager.getConnection(url, username, password);
                        Statement statement = connection.createStatement();
                        String query;
                        ResultSet rs = null;

                        LocalDate date = LocalDate.parse(String.valueOf(request.getSession().getAttribute("dates")), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
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

                        String candidate_number = request.getParameter("candidate");
                        session.setAttribute("number", candidate_number);

                        query = "SELECT * FROM candidates where phonenumber = '" + candidate_number + "'";
                        System.out.println(query);
                        
                        connection = DriverManager.getConnection(url, username, password);
                        statement = connection.createStatement();
                        rs = statement.executeQuery(query);
                        rs.next();

                        out.print("<input required class='gap-bottom' type='text' name='surname' placeholder='Фамилия' value='" + rs.getString(2) + "'>");
                        out.print("<input required class='gap-bottom' type='text' name='name' placeholder='Имя' value='" + rs.getString(3) + "'>");
                        out.print("<input required class='gap-bottom' type='text' name='patronymic' placeholder='Отчество' value='" + rs.getString(4) + "'>");
                        out.print("<input required class='gap-bottom' type='text' name='phonenumber' placeholder='9115557799' value='"
                                + candidate_number + "'aria-required='true' pattern='[9]{1}[0-9]{9}' readonly>");
                        out.print("<select class='gap-bottom' required name='status'>"
                                + "<option selected >" + rs.getString(6) + "</option>"
                                + "<option>собеседование</option><option>обучение</option>"
                                + "<option>принят</option>"
                                + "<option>отказ</option>"
                                + "<option>неявка</option></select>");
                        out.print("<select class='gap-bottom' name='project' required>"
                                + "<option selected>" + rs.getString(7) + "</option>"
                                + "<option>Грузовичкоф</option>"
                                + "<option>Таксовичкоф</option>"
                                + "<option>Достаевский</option>"
                                + "<option>Кисточки</option></select>");
                        out.print("<select class='gap-bottom' name='branch' required>"
                                + "<option selected>" + rs.getString(10) + "</option>"
                                + "<option>Санкт-Петербург</option>"
                                + "<option>Димитровград</option>"
                                + "<option>Рефтинский</option>"
                                + "<option>Асбест</option>"
                                + "<option>Челябинск</option></select>");
                        
                        out.print("<select class='gap-bottom' name='dates' required>");
                        
                        String currentDate = String.valueOf(request.getSession().getAttribute("dates"));
                        
                        for (int month = currentMonth + 1; month < currentMonth + 3; month++) {

                            calendar.set(2017, month - 1, 1);
                            int countOfDays = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

                            for (int day = 1; day <= countOfDays; day++) {
                                String prepareDay, selected = "";
                                if (day < 10) {
                                    prepareDay = ("0" + day);
                                } else {
                                    prepareDay = "" + day;
                                }
                                if (("2017-0" + month + "-" + prepareDay).equals(currentDate)) {
                                    selected = "selected";
                                }
                                out.print("<option " + selected + " value='2017-0"
                                        + month + "-" + prepareDay + "'>"
                                        + prepareDay + ".0" + month + ".2017</option>");
                            }
                        }
                        out.print("</select>");                            
                        out.print("<select class='gap-bottom' name='times' required>");
                        
                        String currentTime = String.valueOf(request.getSession().getAttribute("times"));
                        
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
                    %>

                    <button type="submit" name="action" value="Editing" class="pull-left btn-warning">Изменить</button>
                </form>    
                <form action="/hr">
                    <button class="pull-right btn-danger">Отмена</button>
                </form>  
            </div>
        </div>
    </body>
</html>
