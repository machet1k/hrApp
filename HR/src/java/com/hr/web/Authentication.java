package com.hr.web;

import com.hr.core.AbstractServlet;
import com.hr.model.Credentials;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Calendar;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@WebServlet({"/sign-in", "/sign-out", "/add/adding"})
public class Authentication extends AbstractServlet {

    //private static final com.hr.helpers.Sender sender = new com.hr.helpers.Sender("haritonov.r@b-fon.ru", "m9VCPPmN");    
    private static final com.hr.helpers.Sender SENDER = new com.hr.helpers.Sender("neutrinoteammachet1k@gmail.com", "decbblec0olP");

    private static final String HR = "HR";
    private static final String PASS_HR = "biznesfon";

    private static final String MANAGER = "manager";
    private static final String PASS_MANAGER = "biznesfon";

    @Override
    protected void doGet(String address) throws ServletException, IOException {
        switch (address) {
            case "/sign-in":
                index();
                break;
            case "/sign-out":
                onSignOut(getSession());
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
        switch (address) {
            case "/sign-in":
                onSignIn(getRequest(), getSession());
                break;
            default:
                super.doPost(address);
        }
    }

    private void onSignOut(HttpSession session) throws IOException {
        session.invalidate();
        redirect(getHeader("Referer"));
    }

    private void index() throws ServletException, IOException {
        forward("/login.html");
    }

    private void onSignIn(HttpServletRequest request, HttpSession session) throws ServletException, IOException {

        Calendar calendar = Calendar.getInstance();
        int currentMonth = calendar.get(Calendar.MONTH) + 1;
        int currentDay = calendar.get(Calendar.DAY_OF_MONTH);

        String prepareMonth, prepareDay;
        if (currentMonth < 10) {
            prepareMonth = "0" + currentMonth;
        } else {
            prepareMonth = String.valueOf(currentMonth);
        }

        if (currentDay < 10) {
            prepareDay = ("0" + currentDay);
        } else {
            prepareDay = "" + currentDay;
        }

        request.getSession().setAttribute("dates", "2017-" + prepareMonth + "-" + prepareDay);
        request.getSession().setAttribute("times", "10:00:00");
        request.getSession().setAttribute("branch", "СанктПетербург");
        request.getSession().setAttribute("search", "false");

        Credentials credentials = new Credentials(request);
        if (credentials.equals(new Credentials(HR, PASS_HR))
         || credentials.equals(new Credentials(MANAGER, PASS_MANAGER))) {
            session.setAttribute("role", credentials.getLogin());
            session.setAttribute("isAuth", true);
            redirect("/hr");
        } else {
            System.out.println(credentials.getLogin() + " " + credentials.getPassword());
            forward("/error.html");
        }
    }

    private void addCand(HttpServletRequest request) throws ServletException {
        String url = "jdbc:derby://localhost:1527/hrdb";
        String username = "root";
        String password = "bcenter";
        
        String query4help = "SELECT * FROM candidates WHERE phonenumber = '" + request.getParameter("phonenumber") + "'";
        System.out.println("\nAutentication > QUERY: " + query4help);
        
        try(Connection connection = DriverManager.getConnection(url, username, password);
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(query4help)){
            if (rs.next()) {
                request.getSession().setAttribute("isExist", "true");
                forward("/isExist.html");
                return;
            }
        } catch (IOException | ServletException | SQLException e) { e.printStackTrace(); }

        String surname = request.getParameter("surname").replaceAll("[' \"]","");
        String name = request.getParameter("name").replaceAll("[' \"]","");
        String patronymic = request.getParameter("patronymic").replaceAll("[' \"]","");
        String email = request.getParameter("email").replaceAll("[' \"]","");
        
        String query = "insert into candidates(surname, name, patronymic, phonenumber, email, status, project, branch, dates, times, channel, advertising, manager) values('"
                + surname
                + "','" + name
                + "','" + patronymic
                + "','" + request.getParameter("phonenumber")
                + "','" + email
                + "','" + /*request.getParameter("status")*/ "1) пригл. на собесед."
                + "','" + request.getParameter("project")
                + "','" + request.getParameter("branch")
                + "','" + request.getSession().getAttribute("dates")
                + "','" + request.getSession().getAttribute("times")
                + "','" + request.getParameter("channel")
                + "','" + request.getParameter("advertising")
                + "','" + request.getSession().getAttribute("role") + "')";
        
        SENDER.send(
                "Приглашение на вебинар \"БизнесФон\"\n\n", "Добрый день, "
                + request.getParameter("name")
                + " "
                + request.getParameter("patronymic") + "!\nПриглашаем Вас на вебинар по проекту \""
                + request.getParameter("project") + "\", который начнётся "
                + request.getSession().getAttribute("dates") + " в "
                + request.getSession().getAttribute("times") + ".\n\nС уважением, HR-менеджер \"БизнесФон\".",
                request.getParameter("email")
        );

        String queryStatus = "insert into statuses(phonenumber, status, dates, reason) values('"
                + request.getParameter("phonenumber") + "','"
                + /*request.getParameter("status")*/ "1) пригл. на собесед.','"
                + request.getSession().getAttribute("dates") + "','-')";
        System.out.println(queryStatus);

        
        try (Connection connection = DriverManager.getConnection(url, username, password);
            Statement statement = connection.createStatement()){
            
            if ("".equals(surname) || "".equals(name) || "".equals(patronymic) || "".equals(email)) {
                forward("/isEmpty.html");
            } else {
                statement.executeUpdate(query);
                statement.executeUpdate(queryStatus);
                redirect("/hr");
                System.out.println(query);
            }
        } catch (IOException | SQLException e) {
            System.out.println("CRASHED! " + e.getLocalizedMessage());
        }
    }

}
