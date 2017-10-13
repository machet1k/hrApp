package com.hr.web;

import com.hr.core.AbstractServlet;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Add")
public class Add extends AbstractServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        request.getSession().setAttribute("dates", request.getParameter("dates"));
        request.getSession().setAttribute("times", request.getParameter("times"));
        
        if (null == action) {
            redirect("/hr");
        } else switch (action) {
            case "Add":
                forward("/addCandidate.jsp");
                break;
            case "SetBranch":
                request.getSession().setAttribute("branch", request.getParameter("branch"));
                redirect("/hr");
                break;
            default:
                redirect("/hr");
                break;
        }
    }   
}
