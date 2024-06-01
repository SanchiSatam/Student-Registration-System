package com.db_proj.student_reg_sys.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "g_enrollments")
public class Enrollment {
    @Id
    @Column(name = "g_B#")
    private String bNumber;

    @Id
    @Column(name = "classid")
    private String classId;

    private double score;

    // Getters and setters
    public String getbNumber() {
        return bNumber;
    }

    public void setbNumber(String bNumber) {
        this.bNumber = bNumber;
    }

    public String getClassId() {
        return classId;
    }

    public void setClassId(String classId) {
        this.classId = classId;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }
}
