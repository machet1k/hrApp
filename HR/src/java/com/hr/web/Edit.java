package com.hr.web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
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
        String candidate_number = (String) request.getSession().getAttribute("number");

        switch (action) {
            
            case "Delete":
                String query = "delete from candidates where phonenumber = '" + request.getParameter("candidate") + "'";
                System.out.println(query);
                try {
                    response.sendRedirect(request.getHeader("Referer"));
                    Connection connection = DriverManager.getConnection(url, username, password);
                    Statement statement = connection.createStatement();
                    statement.executeUpdate(query);
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
                        + "', branch = '" + request.getParameter("branch") + "' where phonenumber = '" + candidate_number + "'";
                System.out.println(query);
                try {
                    response.sendRedirect("/hr");
                    Connection connection = DriverManager.getConnection(url, username, password);
                    Statement statement = connection.createStatement();
                    statement.executeUpdate(query);
                } catch (IOException | SQLException  e){
                    System.out.println("CRASHED! " + e.getLocalizedMessage() +"\n"+ e.getMessage());
                }   
            break;
                
            default:break;
        }
    }   
}

        