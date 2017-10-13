package com.hr.model;

public class Candidate {
    String surname;
    String name;
    String patronymic;
    String phonenumber;
    String status;

    public Candidate(String surname, String name, String patronymic, String phonenumber, String status) {
        this.surname = surname;
        this.name = name;
        this.patronymic = patronymic;
        this.phonenumber = phonenumber;
        this.status = status;
    }

    public String getSurname() {
        return surname;
    }

    public String getName() {
        return name;
    }

    public String getPatronymic() {
        return patronymic;
    }

    public String getPhonenumber() {
        return phonenumber;
    }

    public String getStatus() {
        return status;
    }

    

}
