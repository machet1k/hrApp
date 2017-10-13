package com.biznesfon;
 
public class Main {
    
    private static com.biznesfon.tls.Sender tlsSender = new com.biznesfon.tls.Sender("neutrinoteammachet1k@gmail.com", "decbblec0olP");
    private static com.biznesfon.ssl.Sender sslSender = new com.biznesfon.ssl.Sender("neutrinoteammachet1k@gmail.com", "decbblec0olP");
 
    public static void main(String[] args){
        //tlsSender.send("Отдел Кадров \"БизнесФон\"", "TLS: This is text!", "machet1k@yandex.ru");
        sslSender.send("Приглашение на вебинар \"БизнесФон\"", 
                "Добрый день! Приглашаем Вас на вебинар \"Автопарк\", который начнётся 21.08.2017 в 10:00. С уважением, HR-менеджер Иванов Иван.", 
                "machet1k@yandex.ru");
    }
}