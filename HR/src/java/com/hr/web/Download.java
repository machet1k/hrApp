package com.hr.web;

import com.hr.core.AbstractServlet;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Download")
public class Download extends AbstractServlet {
    
    String url = "jdbc:derby://localhost:1527/hrdb";
    String username = "root";
    String password = "bcenter";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String query, branch, from, to, project, channel, advertising;

        branch = request.getParameter("branch");
        from = request.getParameter("from");
        to = request.getParameter("to");
        project = request.getParameter("project");
        channel = request.getParameter("channel");
        advertising = request.getParameter("advertising");

        query = "SELECT * FROM candidates WHERE dates >= '" + from + "' and dates <= '" + to + "'";
        if (     branch != null) query += " and branch = '" + branch + "'";  
        if (    project != null) query += " and project = '" + project + "'";  
        if (    channel != null) query += " and channel = '" + channel + "'";  
        if (advertising != null) query += " and advertising = '" + advertising + "'";
  
        request.getSession().setAttribute("query", query);
        
        forward("/downloading.jsp");
    }
}