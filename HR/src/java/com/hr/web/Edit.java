package com.hr.web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Edit")
public class Edit extends HttpServlet {
    
    String url = "jdbc:derby://localhost:1527/hrdb";
    String username = "root";
    String password = "bcenter";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String phonenumber = request.getParameter("candidate");
        String candidateNumber = (String) request.getSession().getAttribute("number");
        String candidateStatus = (String) request.getSession().getAttribute("status");
        String queryStatus = "";
        
        switch (action) {
            
            case "Delete":
                String query = "delete from candidates where phonenumber = '" + phonenumber + "'";
                queryStatus = "delete from statuses where phonenumber = '" + phonenumber + "'";
                System.out.println(query);
                try {
                    response.sendRedirect(request.getHeader("Referer"));
                    Connection connection = DriverManager.getConnection(url, username, password);
                    Statement statement = connection.createStatement();
                    statement.executeUpdate(query);
                    statement.executeUpdate(queryStatus);
                } catch (SQLException e){
                    System.out.println("CRASHED! " + e.getLocalizedMessage() + "\n" + e.getMessage());
                }   
            break;
            
            case "Edit":
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/editCandidate.jsp");
                dispatcher.forward(request, response);
            break;
                
            case "Editing":
                query = "update candidates set surname = '" + request.getParameter("surname")
                        + "', name = '" + request.getParameter("name")
                        + "', patronymic = '" + request.getParameter("patronymic")
                        + "', project = '" + request.getParameter("project")
                        + "', status = '" + request.getParameter("status")
                        + "', dates = '" + request.getParameter("dates")
                        + "', times = '" + request.getParameter("times")
                        + "', branch = '" + request.getParameter("branch") + "' where phonenumber = '" + candidateNumber + "'";
                System.out.println(query);
                
                long currentTimeMillis = System.currentTimeMillis(); 
                String currentDate = new SimpleDateFormat("dd.MM.yyyy").format(currentTimeMillis); 
                String currentDateBD = new SimpleDateFormat("yyyy-MM-dd").format(currentTimeMillis); 
                String currentTime = new SimpleDateFormat("HH:mm").format(currentTimeMillis); 
                System.out.println(currentTimeMillis + " " + currentDate + " " + currentDateBD + " " + currentTime);
                
                if (!request.getParameter("status").equals(request.getSession().getAttribute("status"))) {
                    queryStatus = "insert into statuses(phonenumber, status, dates, times) values('" +
                    request.getParameter("phonenumber") + "','" +
                    request.getParameter("status") + "','" +
                    currentDateBD + "','" +
                    currentTime + "')";
                    System.out.println(queryStatus);
                }
                
                try {
                    response.sendRedirect("/hr");
                    Connection connection = DriverManager.getConnection(url, username, password);
                    Statement statement = connection.createStatement();
                    statement.executeUpdate(query);
                    statement.executeUpdate(queryStatus);
                } catch (IOException | SQLException  e){
                    System.out.println("CRASHED! " + e.getLocalizedMessage() +"\n"+ e.getMessage());
                }   
            break;
                
            default:break;
        }
    }   
}

        