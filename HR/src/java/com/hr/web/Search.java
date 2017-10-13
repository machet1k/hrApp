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

        String query = "SELECT * FROM candidates WHERE phonenumber = '" + request.getParameter("phonenumber") + "'";
        System.out.println("\nSearch > QUERY: " + query);
        
        try {
            Connection connection = DriverManager.getConnection(url, username, password);
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(query);
            request.getSession().setAttribute("search", "true");
            if (rs.next()) {
                request.getSession().setAttribute("branchSearch", rs.getString(9));
                request.getSession().setAttribute("dateSearch", rs.getString(10));
                request.getSession().setAttribute("timeSearch", rs.getString(11));
            }
            redirect("/hr");
        } catch (IOException | SQLException e) { e.printStackTrace(); }
    }
}
