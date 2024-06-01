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
public class delete_student {
    
    @Autowired
    private DataSource dataSource;

    @GetMapping("/delete_student")
    public String showDeleteStudentForm() {
        return "delete_student";
    }

    @PostMapping("/delete_student")
    public String deleteStudent(@RequestParam String bNumber,
                                Model model) {
        List<String> outputMessages = new ArrayList<>();

        try(Connection conn = dataSource.getConnection();
        CallableStatement cs = conn.prepareCall("{call project_package.delete_student(?)}")){
        
        cs.setString(1,bNumber);

        enableDBMSOutput(conn);

        cs.execute();

        outputMessages = retrieveDBMSOutput(conn);

        model.addAttribute("outputMessages", outputMessages);

    } catch(SQLException ex){
        model.addAttribute("errorMessage", "An error occurred while deleting student record");
        ex.printStackTrace();
    }
        
        return "delete_student";
    }
    
    private void enableDBMSOutput(Connection conn) throws SQLException{
        try(Statement stmt = conn.createStatement()){
            stmt.execute("BEGIN DBMS_OUTPUT.ENABLE(); END;");
        }
    }

    private List<String> retrieveDBMSOutput(Connection conn) throws SQLException{
        List<String> messages = new ArrayList<>();
        try (CallableStatement cs = conn.prepareCall("{CALL DBMS_OUTPUT.GET_LINE(?, ?)}")){
            cs.registerOutParameter(1, OracleTypes.VARCHAR);
            cs.registerOutParameter(2, OracleTypes.INTEGER);
            int status = 0;

            do{
                cs.execute();
                String line = cs.getString(1);
                status = cs.getInt(2);
                if (line != null){
                    messages.add(line);
                }
            } while (status == 0);
        }
        return messages;
    }
    
}
