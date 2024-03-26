package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Curso;
import persistence.CursoDao;
import persistence.GenericDao;

@WebServlet("/disciplina")
public class DisciplinaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public DisciplinaServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String erro = "";
		List<Curso> cursos = new ArrayList<>();
		
		GenericDao gDao = new GenericDao();
		CursoDao cDao = new CursoDao(gDao);
		try {
			cursos = cDao.listar();
		} catch (ClassNotFoundException | SQLException e){
			erro = e.getMessage();
		} finally {
			request.setAttribute("erro", erro);
			request.setAttribute("cursos", cursos);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
