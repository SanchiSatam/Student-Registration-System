package com.db_proj.student_reg_sys.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import oracle.jdbc.OracleTypes;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import javax.sql.DataSource;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.sql.Statement;

@Controller
public class student_controller {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/addStudent")
    public String showAddStudentForm() {
        return "addStudent";
    }

    @PostMapping("/addStudent")
    public String addStudent(@RequestParam String bNumber,
                             @RequestParam String firstName,
                             @RequestParam String lastName,
                             @RequestParam String studentLevel,
                             @RequestParam double gpa,
                             @RequestParam String email,
                             @RequestParam String birthDate,
                             Model model) {
        List<String> outputMessages = new ArrayList<>();

        // Validate birth date format
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yy");
        sdf.setLenient(false); 
        Date date = null;
        try {
            date = sdf.parse(birthDate);
        } catch (ParseException e) {
            model.addAttribute("errorMessage", "Invalid date format. Please enter the date in the format DD-MMM-YY.");
            return "addStudent";
        }


        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.add_student(?, ?, ?, ?, ?, ?, ?)}")) {


            cs.setString(1, bNumber);
            cs.setString(2, firstName);
            cs.setString(3, lastName);
            cs.setString(4, studentLevel);
            cs.setDouble(5, gpa);
            cs.setString(6, email);
            cs.setDate(7, new java.sql.Date(date.getTime()));

            enableDBMSOutput(conn);
            cs.execute();
            outputMessages = retrieveDBMSOutput(conn);
            model.addAttribute("outputMessages", outputMessages);

        } catch (SQLException ex) {
            model.addAttribute("errorMessage", "An error occurred while adding student record");
            ex.printStackTrace();
        }

        return "addStudent";
    }

    private void enableDBMSOutput(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
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