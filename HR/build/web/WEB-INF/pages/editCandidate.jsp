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

        <script>
            var СанктПетербург = Array('HeadHunter', 'SuperJob', 'Avito', 'gruzovichkof.ru', 'taxovichkof.ru', 'biznesfon.ru', 'Яндекс.Работа', 'Rabota.ru', 'Знакомые', 'Не помнят');
            var Димитровград = Array('HeadHunter', 'SuperJob', 'Avito', 'gruzovichkof.ru', 'taxovichkof.ru', 'biznesfon.ru', 'Яндекс.Работа', 'Rabota.ru', 'Знакомые', 'Не помнят', 'trisosny.ru', '25kanal.ru', 'dimitrovgradros.flagma.ru');
            var Асбест = Array('HeadHunter', 'SuperJob', 'Avito', 'gruzovichkof.ru', 'taxovichkof.ru', 'biznesfon.ru', 'Яндекс.Работа', 'Rabota.ru', 'Знакомые', 'Не помнят', 'maxz.ru', 'asbest-gid.ru', 'asbest.name', 'asbet.ru', 'asbest-online.ru');
            var Рефтинский = Array('HeadHunter', 'SuperJob', 'Avito', 'gruzovichkof.ru', 'taxovichkof.ru', 'biznesfon.ru', 'Яндекс.Работа', 'Rabota.ru', 'Знакомые', 'Не помнят', 'reftinskiy.ru', 'reftnews.ru');
            var Челябинск = Array('HeadHunter', 'SuperJob', 'Avito', 'gruzovichkof.ru', 'taxovichkof.ru', 'biznesfon.ru', 'Яндекс.Работа', 'Rabota.ru', 'Знакомые', 'Не помнят', '74.ru', 'chel.barahla.net', 'ubu.ru/chelyabinsk', 'chelyabinsk.gde.ru', 'chelyabinsk.dorus.ru', 'chelyabinsk.bestru.ru', 'chelyabinsk.sopta.ru');
            var ДО = Array('HeadHunter', 'SuperJob', 'Avito', 'gruzovichkof.ru', 'taxovichkof.ru', 'biznesfon.ru', 'Яндекс.Работа', 'Rabota.ru', 'Знакомые', 'Не помнят');
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
            }
        </script>

    </head>
    <body onload="showAdv('СанктПетербург')">
        <a href="http://biznesfon.ru"><img class="logimg" src="https://pp.userapi.com/c837636/v837636687/526af/LMmzKvJQDdM.jpg" alt="logotype"></a>
        <div class="containerEdit">
            <div class="headertext">Редактирование данных кандидата:</div>
            <div id="buffer"></div>
            <div id="edit">
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
                        // Статус
                        out.print("<select class='gap-bottom' required name='status'>"
                                + "<option selected >" + rs.getString(7) + "</option>"
                                + "<option>собеседование</option><option>обучение</option>"
                                + "<option>принят</option>"
                                + "<option>отказ</option>"
                                + "<option>неявка</option></select>");
                        // Проект
                        out.print("<select class='gap-bottom' name='project' required>"
                                + "<option selected>" + rs.getString(8) + "</option>"
                                + "<option>Грузовичкоф</option>"
                                + "<option>Таксовичкоф</option>"
                                + "<option>Достаевский</option>"
                                + "<option>Кисточки</option></select>");
                        // Регион
                        out.print("<select class='gap-bottom' name='branch' required onchange='showAdv(this.value)'>"
                                + "<option value='СанктПетербург'>Санкт-Петербург</option>"
                                + "<option value='Димитровград'>Димитровград</option>"
                                + "<option value='Рефтинский'>Рефтинский</option>"
                                + "<option value='Асбест'>Асбест</option>"
                                + "<option value='Челябинск'>Челябинск</option>"
                                + "<option value='ДО'>Домашний оператор</option></select>");
                        // Канал связи
                        out.print("<select class='gap-bottom' name='channel' required>"
                                + "<option selected>" + rs.getString(12) + "</option>"
                                + "<option title='Исходящий (отклик)'>Исх.отклик</option>"
                                + "<option title='Исходящий (холодный звонок)'>Исх.хол.зв.</option>"
                                + "<option title='Входящий'>Входящий</option></select>");

                        // Рекламный источник
                        out.print("<select class='gap-bottom' name='advertising' required id='adv'>"
                                + "<option selected>" + rs.getString(13) + "</option></select>");

                        // Дата
                        out.print("<select class='gap-bottom' name='dates' required>");
                        
                        String currentDate = String.valueOf(request.getSession().getAttribute("dates"));
                        System.out.println("editCandidate > currentDate = " + currentDate);
                        
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

                        // Время
                        out.print("<select class='gap-bottom' name='times' required>");
                        
                        String currentTime = String.valueOf(request.getSession().getAttribute("times")).substring(0, 5);
                        System.out.println("editCandidate > currentTime = " + currentTime);
                        
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
            <div id="statusdate">
                <%
                    String queryStatus = "select status, dates, times from statuses where phonenumber = '" + candidateNumber + "'";
                    rs = statement.executeQuery(queryStatus);
                    while (rs.next()) {
                        date = LocalDate.parse(String.valueOf(rs.getString(2)), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        displayDate = date.format(DateTimeFormatter.ofPattern("dd.MM.yyyy", new Locale("ru")));
                        out.print("<span>" + displayDate + "</span><span>" + rs.getString(3) + "</span><span>" + rs.getString(1) + "</span><br>");
                    }
                %> 
            </div>
        </div>
    </body>
</html>
