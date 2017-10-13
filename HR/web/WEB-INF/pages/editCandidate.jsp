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
            var СанктПетербург = Array('HeadHunter', 'SuperJob', 'Avito', 'Сайт Грузовичкоф', 'Сайт Таксовичкоф', 'Сайт БизнесФон', 'Яндекс.Работа', 'Rabota.ru', 'Знакомые', 'Не помнят');
            var Димитровград = СанктПетербург.concat(Array('trisosny.ru', '25kanal.ru', 'dimitrovgradros.flagma.ru'));
            var Асбест = СанктПетербург.concat(Array('maxz.ru', 'asbest-gid.ru', 'asbest.name', 'asbet.ru', 'asbest-online.ru'));
            var Рефтинский = СанктПетербург.concat(Array('reftinskiy.ru', 'reftnews.ru'));
            var Челябинск = СанктПетербург.concat(Array('74.ru', 'chel.barahla.net', 'ubu.ru/chelyabinsk', 'chelyabinsk.gde.ru', 'chelyabinsk.dorus.ru', 'chelyabinsk.bestru.ru', 'chelyabinsk.sopta.ru'));
            var ДО = СанктПетербург.concat(Array('HeadHunter', 'SuperJob', 'Avito', 'Сайт Грузовичкоф', 'Сайт Таксовичкоф', 'Сайт БизнесФон', 'Яндекс.Работа', 'Rabota.ru', 'Знакомые', 'Не помнят'));

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


            var requiredReason = "";
            var requiredNoteToStatus = "";
            
            function visible(v) {
                if (v === "3) на обучении" || v === "5) на линии") {
                    $('#changedStatus').css('display', 'none');
                    $("#changedStatus").removeAttr('required');
                } else {
                    $('#changedStatus').css('display', 'inline');
                    $("#changedStatus").attr('required', '');
                }
                if (v === "6) уволен" || v === "X) отказ" || v === "X) отказался" || v === "X) не выходит на связь") {
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
        <a href="http://biznesfon.ru"><img class="logimg" src="https://pp.userapi.com/c837636/v837636687/526af/LMmzKvJQDdM.jpg" alt="logotype"></a>
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

                        LocalDate date = LocalDate.parse(String.valueOf(request.getSession().getAttribute("dates")), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        String displayDate = date.format(DateTimeFormatter.ofPattern("dd.MM.yyyy", new Locale("ru")));

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

                        // Проект
                        out.print("<select class='gap-bottom' name='project' required>"
                                + "<option selected>" + rs.getString(8) + "</option>"
                                + "<option>Грузовичкоф</option>"
                                + "<option>Таксовичкоф</option>"
                                + "<option>Достаевский</option>"
                                + "<option>Кисточки</option></select>");
                        // Регион
                        out.print("<select class='gap-bottom' name='branch' required onchange='showAdv(this.value)'>"
                                
                                + "<option>" + rs.getString(9) + "</option>"
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
                        out.print("<select class='gap-bottom' name='status' onchange='visible(this.value)'>"
                                + "<option style='background-color: #000;' selected>" + rs.getString(7) + "</option>"
                                + "<option style='background-color: #ffffaa;'>1) пригл. на собесед.</option>"
                                + "<option style='background-color: #ffffaa;'>2) пригл. на обучение</option>"
                                + "<option style='background-color: #aaffaa;'>3) на обучении</option>"
                                + "<option style='background-color: #ffffaa;'>4) выход на линию</option>"
                                + "<option style='background-color: #aaffaa;'>5) на линии</option>"
                                + "<option style='background-color: #ffaaaa;'>6) уволен</option>"
                                + "<option style='background-color: #ffaaaa;'>X) отказ</option>"
                                + "<option style='background-color: #ffaaaa;'>X) отказался</option>"
                                + "<option style='background-color: #ffaaaa;'>X) не выходит на связь</option></select>");

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
                <%
                    String queryStatus = "select status, dates from statuses where phonenumber = '" + candidateNumber + "'";
                    rs = statement.executeQuery(queryStatus);
                    while (rs.next()) {
                        date = LocalDate.parse(String.valueOf(rs.getString(2)), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        displayDate = date.format(DateTimeFormatter.ofPattern("dd.MM.yyyy", new Locale("ru")));
                        out.print("<span>" + displayDate + "</span><span>" + rs.getString(1) + "</span><br>");
                    }
                %> 
            </div>
        </div>
    </body>
</html>
