package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Aluno;
import persistence.AlunoDao;
import persistence.GenericDao;

@WebServlet("/aluno")
public class AlunoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public AlunoServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//entrada
				String cmd = request.getParameter("botao");
				String ra = request.getParameter("ra");
				String cpf = request.getParameter("cpf");
				String nome = request.getParameter("nome");
				String nomeSocial = request.getParameter("nomeSocial");
				String dataNasc = request.getParameter("dataNasc");
				String emailPessoal = request.getParameter("emailPessoal");
				String emailCorporativo = request.getParameter("emailCorporativo");
				String dataSegundoGrau = request.getParameter("dataSegundoGrau");
				String instituicaoSegundoGrau = request.getParameter("instituicaoSegundoGrau");
				String pontuacaoVestibular = request.getParameter("pontuacaoVestibular");
				String posicaoVestibular = request.getParameter("posicaoVestibular");
				String anoIngresso = request.getParameter("anoIngresso");
				String semestreIngresso = request.getParameter("semestreIngresso");
				String semestreGraduacao = request.getParameter("semestreGraduacao");
				
				//saida
				String saida="";
				String erro="";
				Aluno a = new Aluno();
				List<Aluno> alunos = new ArrayList<>();
				
				if(!cmd.contains("Listar")) {
					a.setCpf(cpf);
				}
				if(cmd.contains("Cadastrar") || cmd.contains("Alterar")) {
					a.setCpf(cpf);
					a.setNome(nome);
					a.setNomeSocial(nomeSocial);
					a.setDataNasc(dataNasc);
					a.setEmailPessoal(emailPessoal);
					a.setEmailCorporativo(emailCorporativo);
					a.setDataSegundoGrau(dataSegundoGrau);
					a.setInstituicaoSegundoGrau(instituicaoSegundoGrau);
					a.setPontuacaoVestibular(Double.parseDouble(pontuacaoVestibular));
					a.setPosicaoVestibular(Integer.parseInt(posicaoVestibular));
					a.setAnoIngresso(anoIngresso);
					a.setSemestreIngresso(semestreIngresso);
					a.setSemestreGraduacao(semestreGraduacao);
				}
				try {
					if(cmd.contains("Cadastrar")) {
						saida = cadastrarAluno(a);
						a = null;
					}
					if(cmd.contains("Alterar")) {
						saida = atualizarAluno(a);
						a = null;
					}
					if(cmd.contains("Excluir")) {
						saida = excluirAluno(a);
						a = null;
					}
					if(cmd.contains("Buscar")) {
						a = buscarAluno(a);
					}
					if(cmd.contains("Listar")) {
						alunos = listarAlunos();
					}
					
				} catch(SQLException | ClassNotFoundException e) {
					erro = e.getMessage();
				} finally {
					request.setAttribute("saida", saida);
					request.setAttribute("erro", erro);
					request.setAttribute("aluno", a);
					request.setAttribute("alunos", alunos);
					
					RequestDispatcher rd = request.getRequestDispatcher("aluno.jsp");
					rd.forward(request, response);
				}
	}

	private String cadastrarAluno(Aluno a) throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		AlunoDao aDao = new AlunoDao(gDao);
		String saida = aDao.iud("I", a);
		return saida;
	}

	private String atualizarAluno(Aluno a) throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		AlunoDao aDao = new AlunoDao(gDao);
		String saida = aDao.iud("U", a);
		return saida;
	}

	private String excluirAluno(Aluno a) {
		// TODO Auto-generated method stub
		return null;
	}

	private Aluno buscarAluno(Aluno a) throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		AlunoDao aDao = new AlunoDao(gDao);
		a = aDao.consultar(a);
		return a;
	}

	private List<Aluno> listarAlunos() throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		List<Aluno> alunos = new ArrayList<>();
		AlunoDao aDao = new AlunoDao(gDao);
		alunos = aDao.listar();
		System.out.println(alunos.get(0));
		return alunos;
	}
}
