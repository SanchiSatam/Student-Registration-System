package com.db_proj.student_reg_sys.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "prerequisites")
public class Prerequisite {
    
    @Column(name = "dept_code")
    private String departmentCode;

    @Column(name = "course#")
    private int courseNumber;

    @Column(name = "pre_dept_code")
    private String prerequisiteDepartmentCode;

    @Column(name = "pre_course#")
    private int prerequisiteCourseNumber;

    // Getters and setters
    
    public String getDepartmentCode() {
        return departmentCode;
    }

    public void setDepartmentCode(String departmentCode) {
        this.departmentCode = departmentCode;
    }

    public int getCourseNumber() {
        return courseNumber;
    }

    public void setCourseNumber(int courseNumber) {
        this.courseNumber = courseNumber;
    }

    public String getPrerequisiteDepartmentCode() {
        return prerequisiteDepartmentCode;
    }

    public void setPrerequisiteDepartmentCode(String prerequisiteDepartmentCode) {
        this.prerequisiteDepartmentCode = prerequisiteDepartmentCode;
    }

    public int getPrerequisiteCourseNumber() {
        return prerequisiteCourseNumber;
    }

    public void setPrerequisiteCourseNumber(int prerequisiteCourseNumber) {
        this.prerequisiteCourseNumber = prerequisiteCourseNumber;
    }
}
