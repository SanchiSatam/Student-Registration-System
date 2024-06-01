package com.db_proj.student_reg_sys.controller;

import com.db_proj.student_reg_sys.models.Student;
import oracle.jdbc.OracleTypes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Controller
public class get_students_in_class {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/students_in_class")
    public String showStudentsForm() {
        return "students_in_class";
    }

    @PostMapping("/students_in_class")
    public String fetchStudentsInClass(@RequestParam(required = false) String classId, Model model) {
        if (!isValidClassId(classId)) {
            model.addAttribute("outputMessages", "Invalid class ID format. Please enter a valid class ID in the format 'c0001'.");
            return "students_in_class";
        }
        List<String> outputMessages = new ArrayList<>();
        List<Student> students = new ArrayList<>();
        String errorMessage = null;

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall("{call project_package.show_students_in_class(?, ?)}")) {

            cs.setString(1, classId);
            cs.registerOutParameter(2, OracleTypes.CURSOR);

            enableDBMSOutput(conn);
            cs.execute();
            outputMessages = retrieveDBMSOutput(conn);
            model.addAttribute("outputMessages", outputMessages);

            try (ResultSet rs = (ResultSet) cs.getObject(2)) {
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
        } catch (SQLException ex) {
            errorMessage = "An error occurred while fetching students: " + ex.getMessage();
            System.out.println("\n*** SQLException caught ***\n" + ex.getMessage());
        } catch (Exception e) {
            errorMessage = "An unexpected error occurred: " + e.getMessage();
            System.out.println("\n*** other Exception caught ***\n");
        }

        model.addAttribute("students", students);
        model.addAttribute("errorMessage", errorMessage);
        return "students_in_class";
    }

    // Validate class ID format
    private static boolean isValidClassId(String classId) {
        String regex = "^c\\d{4}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(classId);
        return matcher.matches();
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
