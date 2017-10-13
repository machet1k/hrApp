package com.hr.web;

import com.hr.core.AbstractServlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Search")
public class Search extends AbstractServlet {
    
    String url = "jdbc:derby://localhost:1527/hrdb";
    String username = "root";
    String password = "bcenter";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        try{
            String query = "SELECT * FROM candidates WHERE phonenumber = '" + request.getParameter("phonenumber") + "'";   
            System.out.println(query);
            Connection connection = DriverManager.getConnection(url, username, password);
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(query);
            if (rs.next()) {
                System.out.println(rs.getString(8) + " " + rs.getString(9));
                request.getSession().setAttribute("search", "true");
                request.getSession().setAttribute("dateSearch", rs.getString(8));
                request.getSession().setAttribute("timeSearch", rs.getString(9));
                request.getSession().setAttribute("branchSearch", rs.getString(10));
            }
            else System.out.println("Кандидата с данным номером нет в БД.");
            
            
            redirect("/hr");
        } catch (IOException | SQLException  e){
            System.out.println("CRASHED! " + e.getLocalizedMessage());
        }
    }
}

        