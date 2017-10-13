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

            System.out.println("D..ing " + query);
        %>
        <link rel="stylesheet" type="text/css" href="css/style.css">
    </head>
    <body>
        <a href="http://biznesfon.ru"><img class="logimg" src="https://pp.userapi.com/c837636/v837636687/526af/LMmzKvJQDdM.jpg" alt="logotype"></a>
        <div class="containerDownload">
            <div class="row">
                <div class="panel panel-default">
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
                            </tr>
                            <%
                                connection = DriverManager.getConnection(url, username, password);
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
                                            + "<td>" + rs.getString(13) + "</td></tr>"
                                    );
                                }
                            %>

                        </table>
                    </div>
                    <!--div class="sign"> 
                        &copy; This application has been created by Roman Kharitonov. All rights reserved.
                    </div--> 
                </div> 
                </body>
                </html>