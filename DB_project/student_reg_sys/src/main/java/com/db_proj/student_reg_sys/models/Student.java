package com.db_proj.student_reg_sys.models;

import java.sql.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

import jakarta.persistence.Table;

@Entity
@Table (name="students")
public class Student {
    @Id
    @Column(name = "B#")
    private String bNumber;
    private String first_name;
    private String last_name;
    @Column(name = "st_level")
    private String st_level;
    @Column(name = "gpa")
    private double gpa;
    @Column(name = "email")
    private String email;
    @Column(name = "bdate")
    private Date bdate;

    // Constructors
    public Student() {
    }

    // Getters and setters
    public String getbNumber() {
        return bNumber;
    }

    public void setbNumber(String bnumber) {
        this.bNumber = bnumber;
    }

    public String getFirstName() {
        return first_name;
    }

    public void setFirstName(String firstName) {
        this.first_name = firstName;
    }

    public String getLastName() {
        return last_name;
    }

    public void setLastName(String lastName) {
        this.last_name = lastName;
    }

    public String getStudentLevel() {
        return st_level;
    }

    public void setStudentLevel(String studentLevel) {
        this.st_level = studentLevel;
    }

    public double getGpa() {
        return gpa;
    }

    public void setGpa(double gpa) {
        this.gpa = gpa;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Date getBirthDate() {
        return bdate;
    }

    public void setBirthDate(Date birthDate) {
        this.bdate = birthDate;
    }
}
