package com.hr.web;

import com.hr.core.AbstractServlet;
import com.hr.model.Credentials;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet({"/sign-in", "/sign-out", "/add/adding"})
public class Authentication extends AbstractServlet{

    public static String dates = "2017-07-01";
    public static String times = "10:00";
    public static String branch = "Санкт-Петербург";

    @Override
    protected void doGet(String address) throws ServletException, IOException {
        switch(address) {
            case "/sign-in":
                index();
                break;
            case "/sign-out":
                onSignOut(getSession(), getResponse());
                break;
                
            case "/add/adding":
                addCand(getRequest());
                break;
                
            default:
                super.doGet(address);
        }
    }

    @Override
    protected void doPost(String address) throws ServletException, IOException {
        switch(address) {
            case "/sign-in":
                onSignIn(getRequest(), getSession());
                break;
            default:
                super.doPost(address);
        }
    }
    
    private void addCand(HttpServletRequest request)  {
        String url = "jdbc:derby://localhost:1527/hrdb";
        String username = "root";
        String password = "bcenter";
        String query = "insert into candidates(surname, name, patronymic, phonenumber, status, project, branch, dates, times) values('" +
                request.getParameter("surname") + "','" +
                request.getParameter("name") + "','" +
                request.getParameter("patronymic") + "','" +
                request.getParameter("phonenumber") + "','" +
                request.getParameter("status") + "','" +
                request.getParameter("project") + "','" +
                branch + "','" +
                dates + "','" +
                times + "')";
        try {
            redirect("/hr");
            Connection connection = DriverManager.getConnection(url, username, password);
            Statement statement = connection.createStatement();
            statement.executeUpdate(query);
            System.out.println(query);
        } catch (IOException | SQLException  e){
            System.out.println("CRASHED! " + e.getLocalizedMessage() +"\n"+ e.getMessage());
        }
    }

    private void onSignOut(HttpSession session, HttpServletResponse response) throws IOException {
        session.invalidate();
        redirect(getHeader("Referer"));
    }

    private void index() throws ServletException, IOException {
        forward("/login.html");
    }

    private void onSignIn(HttpServletRequest request, HttpSession session) throws ServletException, IOException {
        Credentials credentials = new Credentials(request);
        if (credentials.equals(new Credentials("root", "root"))) {
            session.setAttribute("isAuth", true);
            redirect("/hr");
        } else {
            System.out.println(credentials.getLogin() + " " + credentials.getPassword());
            forward("/error.html");
        }
    }
}
