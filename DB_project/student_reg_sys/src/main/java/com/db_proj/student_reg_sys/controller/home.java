package com.db_proj.student_reg_sys.controller;

// import javax.servlet.*;
// import javax.servlet.http.*;
// import java.io.*;

// public class home extends HttpServlet {

//     public void doGet(HttpServletRequest request, HttpServletResponse response)
//             throws ServletException, IOException {
//                 RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/home.jsp");

//         dispatcher.forward(request, response);
//     }
// }

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class home{
    @GetMapping("/")
    public String showIndex() {
        return "home";
    }
    
}

