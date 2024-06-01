package com.db_proj.student_reg_sys.models;


import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "score_grade")
public class ScoreGrade {
    @Id
    private double score;

    private String lgrade;

    // Getters and setters
    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public String getLgrade() {
        return lgrade;
    }

    public void setLgrade(String lgrade) {
        this.lgrade = lgrade;
    }
}
