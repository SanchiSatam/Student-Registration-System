package com.db_proj.student_reg_sys.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import javax.sql.DataSource;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import oracle.jdbc.OracleTypes;
import java.util.ArrayList;
import java.util.List;

@Controller
public class prerequisite_controller {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/prerequisites")
    public String showPrerequisitesForm() {
        return "prerequisites";
    }

    @PostMapping("/prerequisites")
    public String fetchPrerequisites(@RequestParam String deptCode,
                                     @RequestParam String courseNum,
                                     Model model) {
        List<String> outputMessages = new ArrayList<>();

        // Validate input
        if (!isValidDeptCode(deptCode) || !isValidCourseNum(courseNum)) {
            model.addAttribute("errorMessage", "Invalid input. Please enter a valid Department Code (up to 4 uppercase letters) and Course Number (up to 3 digits).");
            return "prerequisites";
        }

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.get_prerequisites(?, ?)}")) {

            enableDBMSOutput(conn);
            // Set parameters
            cs.setString(1, deptCode);
            cs.setString(2, courseNum);
            //cs.registerOutParameter(3, OracleTypes.CURSOR);

            // Execute procedure
            cs.execute();

             
             // Retrieve output messages from DBMS_OUTPUT
            outputMessages = retrieveDBMSOutput(conn);
             
             // Pass output messages to the model
            model.addAttribute("outputMessages", outputMessages);

            

        } catch (SQLException ex) {
            model.addAttribute("errorMessage", "An error occurred while fetching prerequisites: " + ex.getMessage());
            ex.printStackTrace(); 
        }

        return "prerequisites";
    }

    private boolean isValidDeptCode(String deptCode) {
        // Validating as per the database constraints: up to 4 uppercase letters
        return deptCode != null && deptCode.matches("[A-Z]{1,4}");
    }

    private boolean isValidCourseNum(String courseNum) {
        // Validating as per the database constraints: a number up to 3 digits
        return courseNum != null && courseNum.matches("\\d{1,3}");
    }

    private void enableDBMSOutput(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("BEGIN DBMS_OUTPUT.ENABLE(); END;");
        }
    }

    private List<String> retrieveDBMSOutput(Connection conn) throws SQLException {
        List<String> messages = new ArrayList<>();
        try (CallableStatement cs = conn.prepareCall("{CALL DBMS_OUTPUT.GET_LINE(?, ?)}")) {
            cs.registerOutParameter(1, OracleTypes.VARCHAR); // for the line
            cs.registerOutParameter(2, OracleTypes.INTEGER); // for the status
            int status = 0;
    
            do {
                cs.execute(); // Execute the procedure
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