package com.hr.web;

import com.hr.core.AbstractServlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Edit")
public class Edit extends AbstractServlet {
    
    private static final com.hr.helpers.Sender sender = new com.hr.helpers.Sender("neutrinoteammachet1k@gmail.com", "decbblec0olP");
    
    String url = "jdbc:derby://localhost:1527/hrdb";
    String username = "root";
    String password = "bcenter";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String phonenumber = request.getParameter("candidate");
        String candidateNumber = (String) request.getSession().getAttribute("number");
        String queryStatus = "";
        
        switch (action) {

            case "Delete":
                String query = "delete from candidates where phonenumber = '" + phonenumber + "'";
                queryStatus = "delete from statuses where phonenumber = '" + phonenumber + "'";
                System.out.println("Edit.java > QUERY: " + query);
                try {
                    response.sendRedirect(request.getHeader("Referer"));
                    Connection connection = DriverManager.getConnection(url, username, password);
                    Statement statement = connection.createStatement();
                    statement.executeUpdate(query);
                    statement.executeUpdate(queryStatus);
                } catch (SQLException e) {
                    e.printStackTrace();
                }                
                break;
            
            case "Edit":
                forward("/editCandidate.jsp");
                break;
            
            case "Editing":
                query = "update candidates set surname = '" + request.getParameter("surname")
                        + "', name = '" + request.getParameter("name")
                        + "', patronymic = '" + request.getParameter("patronymic")
                        + "', project = '" + request.getParameter("project")
                        + "', status = '" + request.getParameter("status")
                        + "', dates = '" + request.getParameter("dates")
                        + "', times = '" + request.getParameter("times")
                        + "', channel = '" + request.getParameter("channel")
                        + "', advertising = '" + request.getParameter("advertising")
                        + "', branch = '" + request.getParameter("branch") + "' where phonenumber = '" + candidateNumber + "'";
                System.out.println("Edit.java > QUERY: " + query);
                
                long currentTimeMillis = System.currentTimeMillis();                
                
                String currentDateBD = new SimpleDateFormat("yyyy-MM-dd").format(currentTimeMillis);                
                String currentTime = new SimpleDateFormat("HH:mm").format(currentTimeMillis);                
                
                // пишем историю изменения статусов
                if (!request.getParameter("status").equals(request.getSession().getAttribute("status"))) {
                    queryStatus = "insert into statuses(phonenumber, status, dates, times) values('"
                            + request.getParameter("phonenumber") + "','"
                            + request.getParameter("status") + "','"
                            + currentDateBD + "','"
                            + currentTime + "')";
                    System.out.println("Edit.java > QUERY (status): " + queryStatus);
                }
                
                // сохраняем в переменные старые и новые значения даты и времени
                String oldTime = request.getSession().getAttribute("times").toString().substring(0, 5);
                String oldDate = request.getSession().getAttribute("dates").toString();
                String newTime = request.getParameter("times");
                String newDate = request.getParameter("dates");

                // в случае изменения даты или времени вебинара, кандидата информируем через email
                if (!oldDate.equals(newDate) || !oldTime.equals(newTime)) {
                    if (!oldDate.equals(newDate)) System.out.println("> Изменилась дата собеседования с " + oldDate + " на " + newDate);
                    if (!oldTime.equals(newTime)) System.out.println("> Изменилось время собеседования с " + oldTime + " на " + newTime);
                    sender.send(
                            "Приглашение на вебинар \"БизнесФон\"", "Добрый день, "
                            + request.getParameter("name")
                            + " "
                            + request.getParameter("patronymic") + "!\nИнформируем Вас о том, что изменилось время начала вебинара по проекту \""
                            + request.getParameter("project") + "\", на который Вы были записаны. Новое время: "
                            + newDate + " в "
                            + newTime + ".\n\nС уважением, HR-менеджер \"БизнесФон\".",
                            request.getParameter("email")
                    );
                    // устанавливаем радиобоксы в новое положение, чтобы увидеть пользователя в случае изменения даты и времени
                    request.getSession().setAttribute("dates", newDate);
                    request.getSession().setAttribute("times", newTime);
                    request.getSession().setAttribute("branch", request.getParameter("branch"));
                }
                
                try {
                    redirect("/hr");
                    Connection connection = DriverManager.getConnection(url, username, password);
                    Statement statement = connection.createStatement();
                    statement.executeUpdate(query);
                    statement.executeUpdate(queryStatus);
                } catch (IOException | SQLException e) {
                    e.printStackTrace();
                }                
                break;
            
            default:
                break;
        }
    }    
}
