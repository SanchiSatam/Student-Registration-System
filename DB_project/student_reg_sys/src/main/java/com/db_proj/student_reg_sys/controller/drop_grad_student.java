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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Statement;

@Controller
public class drop_grad_student {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/drop_grad_student")
    public String showDeleteStudentForm() {
        return "drop_grad_student";
    }

    @PostMapping("/drop_grad_student")
    public String deleteStudent(@RequestParam String bNumber,
                                @RequestParam String classId,
                                Model model) {
        List<String> outputMessages = new ArrayList<>();


        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.drop_student(?, ?, ?)}")) {

            // Set parameters
            cs.setString(1, bNumber);
            cs.setString(2, classId);
            cs.registerOutParameter(3, OracleTypes.CURSOR);

            // Enable DBMS_OUTPUT
            enableDBMSOutput(conn);

            // Execute procedure
            cs.execute();

            // Retrieve output messages from DBMS_OUTPUT
            outputMessages = retrieveDBMSOutput(conn);

            // Pass output messages to the model
            model.addAttribute("outputMessages", outputMessages);

        } catch (SQLException ex) {
            model.addAttribute("errorMessage", "An error occurred while dropping the student from the class.");
            ex.printStackTrace(); 
        }

        return "drop_grad_student";
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

