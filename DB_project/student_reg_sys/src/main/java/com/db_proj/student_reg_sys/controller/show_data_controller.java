package com.db_proj.student_reg_sys.controller;

import com.db_proj.student_reg_sys.models.Student;
import com.db_proj.student_reg_sys.models.Class;
import com.db_proj.student_reg_sys.models.Course;
import com.db_proj.student_reg_sys.models.CourseCredit;
import com.db_proj.student_reg_sys.models.Enrollment;
import com.db_proj.student_reg_sys.models.Log;
import com.db_proj.student_reg_sys.models.ScoreGrade;
import com.db_proj.student_reg_sys.models.Prerequisite;
import oracle.jdbc.OracleTypes;
import org.springframework.stereotype.Controller;
import org.springframework.beans.factory.annotation.Autowired;
import javax.sql.DataSource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.ui.Model;
import java.util.ArrayList;
import java.util.List;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;



@Controller
public class show_data_controller {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/showStudents")
    public String showStudents(Model model) {
        List<Student> students = new ArrayList<>();

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.show_students(?)}")) {

            // Register the OUT parameter 
            cs.registerOutParameter(1, OracleTypes.CURSOR);

            // Execute the stored procedure
            cs.execute();

            // Retrieve the result set from the stored procedure
            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                // Iterate through the result set and add students to the list
                while (rs.next()) {
                    Student student = new Student();
                    student.setbNumber(rs.getString("B#"));
                    student.setFirstName(rs.getString("first_name"));
                    student.setLastName(rs.getString("last_name"));
                    student.setStudentLevel(rs.getString("st_level"));
                    student.setGpa(rs.getDouble("gpa"));
                    student.setEmail(rs.getString("email"));
                    student.setBirthDate(rs.getDate("bdate"));
                    students.add(student);
                }
            }
            // try (ResultSet rs = (ResultSet) cs.getObject(1)) {
            // used for debugging    
            //     System.out.println("Printing result set:");
            //     while (rs.next()) {
            //         System.out.println(rs.getString("bNumber") + "\t" + rs.getString("first_name") + "\t" + rs.getString("last_name") + "\t" + rs.getString("st_level") + "\t" + rs.getDouble("gpa") + "\t" + rs.getString("email") + "\t" + rs.getDate("bdate"));
            //     }
            //     System.out.println("End of result set.");
            // }

        } catch (SQLException ex) {
            System.out.println("\n*** SQLException caught ***\n" + ex.getMessage());
        } catch (Exception e) {
            System.out.println("\n*** other Exception caught ***\n");
        }

        // Add the list of students to the model
        model.addAttribute("students", students);

        // Return the name of the JSP page
        return "showStudents";
    }

    @GetMapping("/show_classes")
    public String showClasses(Model model) {
        List<Class> classes = new ArrayList<>();

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.show_classes(?)}")) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    Class classObj = new Class();
                    classObj.setClassId(rs.getString("classid"));
                    classObj.setDepartmentCode(rs.getString("dept_code"));
                    classObj.setCourseNumber(rs.getInt("course#"));
                    classObj.setSectionNumber(rs.getInt("sect#"));
                    classObj.setYear(rs.getInt("year"));
                    classObj.setSemester(rs.getString("semester"));
                    classObj.setLimit(rs.getInt("limit"));
                    classObj.setClassSize(rs.getInt("class_size"));
                    classObj.setRoom(rs.getString("room"));
                    classes.add(classObj);
                }
            }

        } catch (SQLException ex) {
            System.out.println("\n*** SQLException caught ***\n" + ex.getMessage());
        } catch (Exception e) {
            System.out.println("\n*** other Exception caught ***\n");
        }

        model.addAttribute("classes", classes);
        return "show_classes";
    }

    @GetMapping("/showCourseCredit")
    public String showCourseCredit(Model model) {
        List<CourseCredit> courseCredits = new ArrayList<>();

        try (Connection conn = dataSource.getConnection();
            CallableStatement cs = conn.prepareCall("{call project_package.show_course_credit(?)}")) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    CourseCredit courseCredit = new CourseCredit();
                    courseCredit.setCourseNumber(rs.getInt("course#"));
                    courseCredit.setCredits(rs.getInt("credits"));
                    courseCredits.add(courseCredit);
                }
            }

        } catch (SQLException ex) {
            System.out.println("\n*** SQLException caught ***\n" + ex.getMessage());
        } catch (Exception e) {
            System.out.println("\n*** other Exception caught ***\n");
        }

        model.addAttribute("courseCredits", courseCredits);
        return "showCourseCredit";
    }

    @GetMapping("/showEnrollments")
    public String showEnrollments(Model model) {
        List<Enrollment> enrollments = new ArrayList<>();
    
        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.show_g_enrollments(?)}")) {
    
            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();
    
            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    Enrollment enrollment = new Enrollment();
                    enrollment.setbNumber(rs.getString("g_B#"));
                    enrollment.setClassId(rs.getString("classid"));
                    enrollment.setScore(rs.getDouble("score"));
                    enrollments.add(enrollment);
                }
            }
    
        } catch (SQLException ex) {
            System.out.println("\n*** SQLException caught ***\n" + ex.getMessage());
        } catch (Exception e) {
            System.out.println("\n*** other Exception caught ***\n");
        }
    
        model.addAttribute("enrollments", enrollments);
        return "showEnrollments";
    }

    @GetMapping("/showLogs")
    public String showLogs(Model model) {
        List<Log> logs = new ArrayList<>();
    
        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.show_logs(?)}")) {
    
            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();
    
            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    Log log = new Log();
                    log.setLogNumber(rs.getInt("log#"));
                    log.setUserName(rs.getString("user_name"));
                    log.setOperationTime(rs.getDate("op_time"));
                    log.setTableName(rs.getString("table_name"));
                    log.setOperation(rs.getString("operation"));
                    log.setTupleKeyValue(rs.getString("tuple_keyvalue"));
                    logs.add(log);
                }
            }
    
        } catch (SQLException ex) {
            System.out.println("\n*** SQLException caught ***\n" + ex.getMessage());
        } catch (Exception e) {
            System.out.println("\n*** other Exception caught ***\n");
        }
    
        model.addAttribute("logs", logs);
        return "showLogs";
    }

    @GetMapping("/showPrerequisites")
    public String showPrerequisites(Model model) {
        List<Prerequisite> prerequisites = new ArrayList<>();
    
        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.show_prerequisites(?)}")) {
    
            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();
    
            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    Prerequisite prerequisite = new Prerequisite();
                    prerequisite.setDepartmentCode(rs.getString("dept_code"));
                    prerequisite.setCourseNumber(rs.getInt("course#"));
                    prerequisite.setPrerequisiteDepartmentCode(rs.getString("pre_dept_code"));
                    prerequisite.setPrerequisiteCourseNumber(rs.getInt("pre_course#"));
                    prerequisites.add(prerequisite);
                }
            }
    
        } catch (SQLException ex) {
            System.out.println("\n*** SQLException caught ***\n" + ex.getMessage());
        } catch (Exception e) {
            System.out.println("\n*** other Exception caught ***\n");
        }
    
        model.addAttribute("prerequisites", prerequisites);
        return "showPrerequisites";
    }

    @GetMapping("/showScoreGrade")
    public String showScoreGrade(Model model) {
        List<ScoreGrade> scoreGrades = new ArrayList<>();
    
        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.show_score_grade(?)}")) {
    
            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();
    
            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    ScoreGrade scoreGrade = new ScoreGrade();
                    scoreGrade.setScore(rs.getDouble("score"));
                    scoreGrade.setLgrade(rs.getString("lgrade"));
                    scoreGrades.add(scoreGrade);
                }
            }
    
        } catch (SQLException ex) {
            System.out.println("\n*** SQLException caught ***\n" + ex.getMessage());
        } catch (Exception e) {
            System.out.println("\n*** other Exception caught ***\n");
        }
    
        model.addAttribute("scoreGrades", scoreGrades);
        return "showScoreGrade";
    }

    @GetMapping("/showCourses")
    public String showCourses(Model model) {
        List<Course> courses = new ArrayList<>();
    
        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.show_courses(?)}")) {
    
            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();
    
            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseNumber(rs.getInt("course#"));
                    course.setDepartmentCode(rs.getString("dept_code"));
                    course.setTitle(rs.getString("title"));
                    courses.add(course);
                }
            }
    
        } catch (SQLException ex) {
            System.out.println("\n*** SQLException caught ***\n" + ex.getMessage());
        } catch (Exception e) {
            System.out.println("\n*** other Exception caught ***\n");
        }
    
        model.addAttribute("courses", courses);
        return "showCourses";
    }
        

}