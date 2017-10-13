package com.hr.helpers;

import java.util.Properties;
 
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
 
public class Sender {
 
    private final String username;
    private final String password;
    private final Properties props;
 
    public Sender(String username, String password) {
        this.username = username;
        this.password = password;
        props = new Properties(); 
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
    }
 
    public void send(String subject, String text, String toEmail){
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
 
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username)); //от кого
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail)); //кому 
            message.setSubject(subject); //Заголовок письма
            message.setText(text); //Содержимое
            Transport.send(message); //Отправляем сообщение
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }
}