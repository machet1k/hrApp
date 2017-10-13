package com.hr.core;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public abstract class AbstractServlet extends HttpServlet{
      
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private String context;

    protected final HttpServletRequest getRequest() { return request; }
    protected final HttpServletResponse getResponse() { return response; }
    protected final HttpSession getSession() { return session; }
    
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        context = config.getServletContext().getContextPath();
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.request = request;
        this.response = response;
        session = request.getSession();
        super.service(request, response);
    }
    
    protected void doGet(String address) throws ServletException, IOException {
        super.doGet(request, response);
    }
    
    protected void doPost(String address) throws ServletException, IOException {
        super.doPost(request, response);
    }

    private String getRelativeUri() {
        return request.getRequestURI().replace(context, "");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(getRelativeUri());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(getRelativeUri());
    }
    
    protected final String getHeader(String header) {
        return request.getHeader(header);
    }
    
    protected final void forward(String path) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/pages" + path);
        dispatcher.forward(request, response);
    }
    
    protected final void redirect(String location) throws IOException {
        response.sendRedirect(location);
    }
    
}
