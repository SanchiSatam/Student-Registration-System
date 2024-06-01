package com.db_proj.student_reg_sys.controller;

import org.springframework.beans.factory.annotation.Autowired;
import oracle.jdbc.OracleTypes;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.sql.DataSource;
import java.sql.CallableStatement;
import java.sql.Connection;
//import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.ArrayList;
import java.util.List;
import java.sql.Statement;


@Controller
public class enroll_student {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/enroll_student")
    public String showEnrollStudentForm() {
        return "enroll_student";
    }

    @PostMapping("/enroll_student")
    public String enrollStudent(@RequestParam String bNumber,
                                @RequestParam String classId,
                                Model model) {
        List<String> outputMessages = new ArrayList<>();
        
        // Validate input
        // if (!isValidBNumber(bNumber) || !isValidClassId(classId)) {
        //     model.addAttribute("errorMessage", "Invalid input. Please enter valid B# and Class ID.");
        //     return "enroll_student";
        // }

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.enroll_student(?, ?)}")) {

            // Set parameters
            cs.setString(1, bNumber);
            cs.setString(2, classId);


            
             // Enable DBMS_OUTPUT
             enableDBMSOutput(conn);

             // Execute procedure
             cs.execute();
 
             // Retrieve output messages from DBMS_OUTPUT
             outputMessages = retrieveDBMSOutput(conn);
             
             // Pass output messages to the model
             model.addAttribute("outputMessages", outputMessages);
            

        } catch (SQLException ex) {
            model.addAttribute("errorMessage", "An error occurred while enrolling the student.");
            ex.printStackTrace(); 
        }

        return "enroll_student";
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
    
    
    private boolean isValidBNumber(String bNumber) {
        // Check if the B# is not null and has a length of 9 characters
        if (bNumber == null || bNumber.length() != 9) {
            return false;
        }
        
        // Check if the B# starts with 'B'
        if (!bNumber.startsWith("B")) {
            return false;
        }
        
        
        return true;
    }

    private static boolean isValidClassId(String classId) {
        String regex = "^c\\d{4}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(classId);
        return matcher.matches();
    }
}
