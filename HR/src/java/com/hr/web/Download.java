package com.hr.web;

import com.hr.core.AbstractServlet;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Download")
public class Download extends AbstractServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
 
        String query, branch, from, to, status, project, channel, advertising;
        
        branch = request.getParameter("branch");
        from = request.getParameter("from");
        to = request.getParameter("to");
        status = request.getParameter("status");
        project = request.getParameter("project");
        channel = request.getParameter("channel");
        advertising = request.getParameter("advertising");
        
        query = "select CANDIDATES.ID, CANDIDATES.SURNAME, CANDIDATES.NAME, CANDIDATES.patronymic, CANDIDATES.PHONENUMBER, CANDIDATES.email, " +
                "CANDIDATES.STATUS as currentStatus, CANDIDATES.project, CANDIDATES.branch, CANDIDATES.DATES, CANDIDATES.TIMES, CANDIDATES.CHANNEL, " +
                "CANDIDATES.advertising, CANDIDATES.regtime, CANDIDATES.manager, STATUSES.status, STATUSES.DATES as changed, STATUSES.REASON " +
                "from CANDIDATES inner join STATUSES on (CANDIDATES.phonenumber = STATUSES.phonenumber) WHERE CANDIDATES.DATES >= '" + 
                from + "' and CANDIDATES.DATES <= '" + to + "'";
        
        if (branch != null && !"null".equals(branch)) {
            request.getSession().setAttribute("branch-download", branch);
            query += " and branch = '" + branch + "'"; 
        }
        if (from != null && !"null".equals(from)) request.getSession().setAttribute("from", from);
        if (to != null && !"null".equals(to)) request.getSession().setAttribute("to", to);
        
        if (status != null && !"null".equals(status)) {
            request.getSession().setAttribute("status", status);
            query += " and CANDIDATES.status = '" + status + "'"; 
        }
        if (project != null && !"null".equals(project)) {
            request.getSession().setAttribute("project", project);
            query += " and project = '" + project + "'";  
        }
        if (channel != null && !"null".equals(channel)) {
            request.getSession().setAttribute("channel", channel);
            query += " and channel = '" + channel + "'";  
        }
        if (advertising != null && !"null".equals(advertising)) {
            request.getSession().setAttribute("advertising", advertising);
            query += " and advertising = '" + advertising + "'";
        }
        
        query += " order by PHONENUMBER, statuses.status";
  
        request.getSession().setAttribute("query", query);
       
        
        forward("/downloading.jsp");
    }
}