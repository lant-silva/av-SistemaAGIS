package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Curso;
import persistence.CursoDao;
import persistence.GenericDao;


public class CursoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public CursoServlet() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cmd = request.getParameter("botao");
		String codigo = request.getParameter("codigo");
		String nome = request.getParameter("nome");
		String cargaHoraria = request.getParameter("cargaHoraria");
		String sigla = request.getParameter("sigla");
		String notaEnade = request.getParameter("notaEnade");
		
		String saida="";
		String erro="";
		Curso cr = new Curso();
		List<Curso> cursos = new ArrayList<>();
		
		if(!cmd.contains("Listar")) {
			cr.setCodigo(Integer.parseInt(codigo));
		}
		if(cmd.contains("Cadastrar") || cmd.contains("Alterar")) {
			cr.setCodigo(Integer.parseInt(codigo));
			cr.setNome(nome);
			cr.setCargaHoraria(Integer.parseInt(cargaHoraria));
			cr.setSigla(sigla);
			cr.setNotaEnade(Integer.parseInt(notaEnade));
		}
		try {
			if(cmd.contains("Cadastrar")) {
				saida = cadastrarCurso(cr);
				cr = null;
			}
			if(cmd.contains("Alterar")) {
				saida = atualizarCurso(cr);
				cr = null;
			}
			if(cmd.contains("Excluir")) {
				saida = excluirCurso(cr);
				cr = null;
			}
			if(cmd.contains("Buscar")) {
				cr = buscarCurso(cr);
			}
			if(cmd.contains("Listar")) {
				cursos = listarCursos();
			}
		} catch (SQLException | ClassNotFoundException e) {
			
		} finally {
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			request.setAttribute("curso", cr);
			request.setAttribute("cursos", cursos);
			
			RequestDispatcher rd = request.getRequestDispatcher("curso.jsp");
			rd.forward(request, response);
		}
	}


	private String cadastrarCurso(Curso cr) throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		CursoDao cDao = new CursoDao(gDao);
		String saida = cDao.iud("I", cr);
		return saida;
	}


	private String atualizarCurso(Curso cr) throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		CursoDao cDao = new CursoDao(gDao);
		String saida = cDao.iud("U", cr);
		return saida;
	}


	private String excluirCurso(Curso cr) throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		CursoDao cDao = new CursoDao(gDao);
		String saida = cDao.iud("D", cr);
		return saida;
	}


	private Curso buscarCurso(Curso cr) throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		CursoDao cDao = new CursoDao(gDao);
		cr = cDao.consultar(cr);
		return cr;
	}


	private List<Curso> listarCursos() throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		List<Curso> cursos = new ArrayList<>();
		CursoDao cDao = new CursoDao(gDao);
		cursos = cDao.listar();
		return cursos;
	}
}
