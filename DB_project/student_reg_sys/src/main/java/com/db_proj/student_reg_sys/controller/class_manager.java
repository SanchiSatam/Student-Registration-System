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
public class class_manager {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/addClass")
    public String showAddClassForm() {
        return "addClass";
    }

    @PostMapping("/addClass")
    public String addClass(@RequestParam String classId,
                            @RequestParam String departmentCode,
                            @RequestParam int courseNumber,
                            @RequestParam int sectionNumber,
                            @RequestParam int year,
                            @RequestParam String semester,
                            @RequestParam int limit,
                            @RequestParam int classSize,
                            @RequestParam String room,
                            Model model) {
        List<String> outputMessages = new ArrayList<>();

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.manage_classes(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}")) {

            cs.setString(1, classId);
            cs.setString(2, departmentCode);
            cs.setInt(3, courseNumber);
            cs.setInt(4, sectionNumber);
            cs.setInt(5, year);
            cs.setString(6, semester);
            cs.setInt(7, limit);
            cs.setInt(8, classSize);
            cs.setString(9, room);
            cs.setString(10, "ADD");

            enableDBMSOutput(conn);
            cs.execute();
            outputMessages = retrieveDBMSOutput(conn);
            model.addAttribute("outputMessages", outputMessages);

        } catch (SQLException ex) {
            model.addAttribute("errorMessage", "An error occurred while adding class record: " + ex.getMessage());
            ex.printStackTrace();
        }

        return "addClass";
    }

    @GetMapping("/deleteClass")
    public String showDeleteClassForm() {
        return "deleteClass";
    }

    @PostMapping("/deleteClass")
    public String deleteClass(@RequestParam String classId,
                               Model model) {
        List<String> outputMessages = new ArrayList<>();

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.delete_class_data(?)}")) {

            cs.setString(1, classId);

            enableDBMSOutput(conn);
            cs.execute();
            outputMessages = retrieveDBMSOutput(conn);
            model.addAttribute("outputMessages", outputMessages);

        } catch (SQLException ex) {
            model.addAttribute("errorMessage", "An error occurred while deleting class record: " + ex.getMessage());
            ex.printStackTrace();
        }

        return "deleteClass";
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
