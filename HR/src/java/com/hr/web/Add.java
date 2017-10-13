package com.hr.web;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Add")
public class Add extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        Authentication.dates = request.getParameter("dates");
        Authentication.times = request.getParameter("times");
        
        if ("Add".equals(action)) {     
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages/addCandidate.html");
            dispatcher.forward(request, response);
        } else if ("SetBranch".equals(action)) {
            Authentication.branch = request.getParameter("branch");
            response.sendRedirect("/hr"); 
        } else {
            response.sendRedirect("/hr");
        }
    }   
}