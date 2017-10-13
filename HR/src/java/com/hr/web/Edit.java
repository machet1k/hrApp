package com.hr.web;

import com.hr.core.AbstractServlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Edit")
public class Edit extends AbstractServlet {
    
    private static final com.hr.helpers.Sender SENDER = new com.hr.helpers.Sender("neutrinoteammachet1k@gmail.com", "decbblec0olP");
    
    String url = "jdbc:derby://localhost:1527/hrdb";
    String username = "root";
    String password = "bcenter";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String phonenumber = request.getParameter("candidate");
        String candidateNumber = String.valueOf(request.getSession().getAttribute("number"));
        
        String surname;
        String name;
        String patronymic;
        String email;
        String status = request.getParameter("status");
        String changedStatus = request.getParameter("changedStatus");
        String reason = request.getParameter("reason");
        String query;

        switch (action) {

            case "Delete":
                query = "delete from candidates where phonenumber = '" + phonenumber + "'";
                System.out.println("Edit.java > QUERY: " + query);
                try(Connection connection = DriverManager.getConnection(url, username, password);
                    Statement statement = connection.createStatement()) {
                    response.sendRedirect(request.getHeader("Referer"));              
                    statement.executeUpdate(query); 
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                break;
            
            case "Edit":
                forward("/editCandidate.jsp");
                break;
            
            case "Editing":
                
                surname = request.getParameter("surname").replaceAll("[' \"]","");
                name = request.getParameter("name").replaceAll("[' \"]","");
                patronymic = request.getParameter("patronymic").replaceAll("[' \"]","");
                email = request.getParameter("email").replaceAll("[' \"]","");
                
                query = "update candidates set surname = '" + surname
                        + "', name = '" + name
                        + "', patronymic = '" + patronymic
                        + "', email = '" + email
                        + "', project = '" + request.getParameter("project")
                        + "', status = '" + request.getParameter("status")
                        + "', dates = '" + request.getParameter("dates")
                        + "', times = '" + request.getParameter("times") + ":00"
                        + "', channel = '" + request.getParameter("channel")
                        + "', advertising = '" + request.getParameter("advertising")
                        + "', branch = '" + request.getParameter("branch");
                        
                        if (!request.getParameter("status").equals(request.getSession().getAttribute("status"))) {
                            System.out.println("parameter: " + request.getParameter("status") + ", Attribute: " + request.getSession().getAttribute("status"));
                            if (status.equals("1) пригл. на собесед.")) query += "', interview = '" + changedStatus;
                            if (status.equals("2) пригл. на обучение")) query += "', study = '" + changedStatus;
                            //if (status.equals("3) на обучении")) query += "', studying = '" + changedStatus;
                            if (status.equals("4) выход на линию")) query += "', beginwork = '" + changedStatus;
                            //if (status.equals("5) на линии")) query += "', working = '" + changedStatus;
                            if (status.equals("6) уволен")) query += "', refused = '" + changedStatus;
                            if (status.equals("X) отказ")) query += "', failure = '" + changedStatus;
                            if (status.equals("X) отказался")) query += "', fired = '" + changedStatus;
                            if (status.equals("X) не выходит на связь")) query += "', notresponding = '" + request.getParameter("changedStatus");
                            if (reason != null) query += "', reason = '" + request.getParameter("reason");
                        }

                        query += "' where phonenumber = '" + candidateNumber + "'";
                        
                System.out.println("Edit.java > QUERY: " + query);          
                
                
                // сохраняем в переменные старые и новые значения даты и времени
                String oldTime = request.getSession().getAttribute("times").toString().substring(0, 5);
                String oldDate = request.getSession().getAttribute("dates").toString();
                String newTime = request.getParameter("times");
                String newDate = request.getParameter("dates");

                // в случае изменения даты или времени вебинара, кандидата информируем через email
                if (!oldDate.equals(newDate) || !oldTime.equals(newTime)) {
                    if (!oldDate.equals(newDate)) System.out.println("> Изменилась дата собеседования с " + oldDate + " на " + newDate);
                    if (!oldTime.equals(newTime)) System.out.println("> Изменилось время собеседования с " + oldTime + " на " + newTime);
                    SENDER.send(
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
                
                try (Connection connection = DriverManager.getConnection(url, username, password);
                     Statement statement = connection.createStatement()) {
                    
                    if ("".equals(surname) || "".equals(name) || "".equals(patronymic) || "".equals(email)) {
                        forward("/isEmpty.html");
                    } else {
                        redirect("/hr");
                        statement.executeUpdate(query);
                    } 
                } catch (SQLException e) {
                    System.out.println("CRASHED! " + e.getLocalizedMessage());
                }
                break;
            
            default:
                break;
        }
    }    
}
