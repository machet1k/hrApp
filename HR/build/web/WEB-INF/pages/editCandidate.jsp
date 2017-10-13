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
        <div class="animated fadeInDownBig">
            <div class="align_center">Редактирование данных кандидата:</div>
            <div class="one sevenths centered triple-padded">    
                <form action="Edit" method="Post">
                    
    <%
        String candidate_number = request.getParameter("candidate");
        session.setAttribute("number", candidate_number);
        String url = "jdbc:derby://localhost:1527/hrdb";
        String username = "root";
        String password = "bcenter";
        String query = "SELECT * FROM candidates where phonenumber = '" + candidate_number + "'";
        System.out.println(query);
        Connection connection = DriverManager.getConnection(url, username, password);
        Statement statement = connection.createStatement();
        ResultSet rs = statement.executeQuery(query);rs.next();
        
        out.print("<input required class='gap-bottom' type='text' name='surname' placeholder='Фамилия' value='" + rs.getString(2) + "'>");
        out.print("<input required class='gap-bottom' type='text' name='name' placeholder='Имя' value='" + rs.getString(3) + "'>");
        out.print("<input required class='gap-bottom' type='text' name='patronymic' placeholder='Отчество' value='" + rs.getString(4) + "'>");
        out.print("<input required class='gap-bottom' type='text' name='phonenumber' placeholder='9115557799' value='"
                + candidate_number + "'aria-required='true' pattern='[9]{1}[0-9]{9}' readonly>");
        out.print("<select class='gap-bottom' required name='status'>"
                + "<option selected >"+ rs.getString(6) +"</option>"
                + "<option>собеседование</option><option>обучение</option>"
                + "<option>принят</option>"
                + "<option>отказ</option>"
                + "<option>неявка</option></select>");
        out.print("<select class='gap-bottom' name='project' required>"
                + "<option selected>"+ rs.getString(7) +"</option>"
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
