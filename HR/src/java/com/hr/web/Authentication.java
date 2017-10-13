package com.hr.web;

import com.hr.core.AbstractServlet;
import com.hr.model.Credentials;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet({"/sign-in", "/sign-out", "/add/adding"})
public class Authentication extends AbstractServlet{

    //private static final com.hr.helpers.Sender sslSender = new com.hr.helpers.Sender("haritonov.r@b-fon.ru", "m9VCPPmN");
    private static final com.hr.helpers.Sender sslSender = new com.hr.helpers.Sender("neutrinoteammachet1k@gmail.com", "decbblec0olP");
    
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
        String message;
        
        String query = "insert into candidates(surname, name, patronymic, phonenumber, email, status, project, branch, dates, times, channel, advertising) values('" +
                      request.getParameter("surname") 
            + "','" + request.getParameter("name")
            + "','" + request.getParameter("patronymic")
            + "','" + request.getParameter("phonenumber")
            + "','" + request.getParameter("email")
            + "','" + request.getParameter("status")
            + "','" + request.getParameter("project")
            + "','" + request.getParameter("branch")
            + "','" + request.getSession().getAttribute("dates")
            + "','" + request.getSession().getAttribute("times")
            + "','" + request.getParameter("channel")
            + "','" + request.getParameter("advertising") + "')";
        System.out.println(query);
        

        sslSender.send(
            "Приглашение на вебинар \"БизнесФон\"\n\n", "Добрый день, "
            + request.getParameter("name") 
            + " " 
            + request.getParameter("patronymic") + "!\nПриглашаем Вас на вебинар по проекту \""
            + request.getParameter("project") + "\", который начнётся " 
            + request.getSession().getAttribute("dates") + " в " 
            + request.getSession().getAttribute("times") + ".\n\nС уважением, HR-менеджер \"БизнесФон\" Иванов Иван.", 
            request.getParameter("email")
        );
        
        
        long currentTimeMillis = System.currentTimeMillis(); 
        String currentDate = new SimpleDateFormat("dd.MM.yyyy").format(currentTimeMillis); 
        String currentDateBD = new SimpleDateFormat("yyyy-MM-dd").format(currentTimeMillis); 
        String currentTime = new SimpleDateFormat("HH:mm").format(currentTimeMillis); 
        System.out.println(currentTimeMillis + " " + currentDate + " " + currentDateBD + " " + currentTime);

        String queryStatus = "insert into statuses(phonenumber, status, dates, times) values('" +
                request.getParameter("phonenumber") + "','" +
                request.getParameter("status") + "','" +
                currentDateBD + "','" +
                currentTime + "')";
        System.out.println(queryStatus);
        try {
            redirect("/hr");
            Connection connection = DriverManager.getConnection(url, username, password);
            Statement statement = connection.createStatement();
            statement.executeUpdate(query);
            statement.executeUpdate(queryStatus);
            System.out.println(query);
        } catch (IOException | SQLException  e){
            System.out.println("CRASHED! " + e.getLocalizedMessage());
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
        
        Calendar calendar = Calendar.getInstance();//TimeZone.getTimeZone("GMT+2:00")
        int preCurrentMonth = calendar.get(Calendar.MONTH) + 1;
        String currentMonth;
        if (preCurrentMonth < 10) currentMonth = "0" + preCurrentMonth;
        else currentMonth = String.valueOf(preCurrentMonth);
                
        request.getSession().setAttribute("dates", "2017-" + currentMonth + "-01");
        request.getSession().setAttribute("times", "10:00");
        request.getSession().setAttribute("branch", "СанктПетербург");
        request.getSession().setAttribute("search", "false");
        
        Credentials credentials = new Credentials(request);
        if (credentials.equals(new Credentials("manager", "biznesfon"))) {
            session.setAttribute("isAuth", true);
            redirect("/hr");
        } else {
            System.out.println(credentials.getLogin() + " " + credentials.getPassword());
            forward("/error.html");
        }
    }
}
