package com.db_proj.student_reg_sys.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import oracle.jdbc.OracleTypes;
import javax.sql.DataSource;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Controller
public class course_manager {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/addCourse")
    public String showAddCourseForm() {
        return "addCourse";
    }

    @PostMapping("/addCourse")
    public String addCourse(@RequestParam String deptCode,
                            @RequestParam int courseNumber,
                            @RequestParam String title,
                            Model model) {
        List<String> outputMessages = new ArrayList<>();

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.manage_courses(?, ?, ?, ?)}")) {

            cs.setString(1, deptCode);
            cs.setInt(2, courseNumber);
            cs.setString(3, title);
            cs.setString(4, "ADD");

            enableDBMSOutput(conn);
            cs.execute();
            outputMessages = retrieveDBMSOutput(conn);
            model.addAttribute("outputMessages", outputMessages);

        } catch (SQLException ex) {
            model.addAttribute("errorMessage", "An error occurred while adding course record: " + ex.getMessage());
            ex.printStackTrace();
        }

        return "addCourse";
    }

    @GetMapping("/deleteCourse")
    public String showDeleteCourseForm() {
        return "deleteCourse";
    }

    @PostMapping("/deleteCourse")
    public String deleteCourse(@RequestParam String deptCode,
                               @RequestParam int courseNumber,
                               Model model) {
        List<String> outputMessages = new ArrayList<>();

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.delete_course_data(?, ?)}")) {

            cs.setString(1, deptCode);
            cs.setInt(2, courseNumber);

            enableDBMSOutput(conn);
            cs.execute();
            outputMessages = retrieveDBMSOutput(conn);
            model.addAttribute("outputMessages", outputMessages);

        } catch (SQLException ex) {
            model.addAttribute("errorMessage", "An error occurred while deleting course record: " + ex.getMessage());
            ex.printStackTrace();
        }

        return "deleteCourse";
    }

    private void enableDBMSOutput(Connection conn) throws SQLException {
        try (java.sql.Statement stmt = conn.createStatement()) {
            stmt.execute("BEGIN DBMS_OUTPUT.ENABLE(); END;");
        }
    }

    private List<String> retrieveDBMSOutput(Connection conn) throws SQLException {
        List<String> messages = new ArrayList<>();
        try (CallableStatement cs = conn.prepareCall("{CALL DBMS_OUTPUT.GET_LINE(?, ?)}")) {
            cs.registerOutParameter(1, OracleTypes.VARCHAR);
            cs.registerOutParameter(2, OracleTypes.INTEGER);
            int status = 0;

            do {
                cs.execute();
                String line = cs.getString(1);
                status = cs.getInt(2);
                if (line != null) {
                    messages.add(line);
                }
            } while (status == 0);
        }
        return messages;
    }
}
