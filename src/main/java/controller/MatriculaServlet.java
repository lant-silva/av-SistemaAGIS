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
import model.Disciplina;
import model.Matricula;
import model.MatriculaDisciplinas;
import persistence.DisciplinaDao;
import persistence.GenericDao;
import persistence.MatriculaDisciplinaDao;

public class MatriculaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public MatriculaServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String erro = "";
		List<Disciplina> disciplinas = new ArrayList<>();
		
		GenericDao gDao = new GenericDao();
		DisciplinaDao dDao = new DisciplinaDao(gDao);
		try {
			disciplinas = dDao.listar();
			for(Disciplina d : disciplinas) {
				
			}
		} catch (ClassNotFoundException | SQLException e){
			erro = e.getMessage();
		} finally {
			request.setAttribute("erro", erro);
			request.setAttribute("disciplinas", disciplinas);
		}
		
		RequestDispatcher rd = request.getRequestDispatcher("matricula.jsp");
		rd.forward(request, response);
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Entrada
		String cmd = request.getParameter("botao");
		String cpf = request.getParameter("cpf");
		String[] disciplinasSelecionadas = request.getParameterValues("disciplinasSelecionadas");
		if(disciplinasSelecionadas != null) {
			for(String str : disciplinasSelecionadas) {			
				System.out.println(str);
			}
		}
		
		// Saída
		String saida="";
		String erro="";
		Matricula matricula = new Matricula();
		List<Disciplina> disciplinas = new ArrayList<>();
		List<MatriculaDisciplinas> matriculaDisciplinas = new ArrayList<>();
		
		try {
			if(cmd.contains("Iniciar Matricula")) {
				matriculaDisciplinas = listarDisciplinas(cpf);
			}
			if(cmd.contains("Confirmar Matricula")) {
				inserirMatricula(disciplinasSelecionadas, cpf);
				saida = "Matricula finalizada";
			}
		} catch (SQLException | ClassNotFoundException e) {		
			erro = e.getMessage();
		} finally {
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			request.setAttribute("disciplinas", matriculaDisciplinas);
			
			RequestDispatcher rd = request.getRequestDispatcher("matricula.jsp");
			rd.forward(request, response);
		}
	}
	
	/**
	 * Insere, em uma nova matrícula, as disciplinas selecionadas na página de matrícula
	 * 
	 * @param disciplinasSelecionadas
	 * @param cpf
	 * @return String saída, indicando o resultado determinado da query 
	 * @throws ClassNotFoundException Caso nenhuma classe seja encontrada
	 * @throws SQLException Caso haja algum erro nos parâmetros inseridos ao executar a query SQL
	 */
	private String inserirMatricula(String[] disciplinasSelecionadas, String cpf) throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		MatriculaDisciplinaDao mdDao = new MatriculaDisciplinaDao(gDao);
		String codigoMatricula = mdDao.gerarMatricula(cpf);
		String saida = null;
		for(String str : disciplinasSelecionadas) {
			saida = mdDao.inserirMatricula(Integer.parseInt(codigoMatricula), Integer.parseInt(str), cpf);
		}
		return saida;
	}
	
	/**
	 * Lista todas as disciplinas disponíveis para um aluno matricular. A função assume que um aluno já possui uma matrícula, ver {@link cadastrarAluno}
	 * 
	 * 
	 * @param alunoCpf
	 * @return
	 * @throws ClassNotFoundException
	 * @throws SQLException Caso haja algum erro nos parâmetros inseridos ao executar a query SQL
	 * @see cadastrarAluno
	 */
	private List<MatriculaDisciplinas> listarDisciplinas(String alunoCpf) throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		MatriculaDisciplinaDao mdDao = new MatriculaDisciplinaDao(gDao);
		List<MatriculaDisciplinas> md = new ArrayList<>();
		md = mdDao.listarSituacao(alunoCpf);
		return md;
	}
}
