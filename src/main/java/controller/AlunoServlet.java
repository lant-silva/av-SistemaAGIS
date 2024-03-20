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
import model.Aluno;

/**
 * Servlet implementation class AlunoServlet
 */
public class AlunoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AlunoServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
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
				String telefone = request.getParameter("telefone");
				String emailPessoal = request.getParameter("emailPessoal");
				String emailCorporativo = request.getParameter("emailCorporativo");
				String dataSegundoGrau = request.getParameter("dataSegundoGrau");
				String instituicaoSegundoGrau = request.getParameter("instituicaoSegundoGrau");
				String pontuacaoVestibular = request.getParameter("pontuacaoVestibular");
				String posicaoVestibular = request.getParameter("posicaoVestibular");
				String anoIngresso = request.getParameter("anoIngresso");
				String semestreIngresso = request.getParameter("semestreIngresso");
				
				//saida
				String saida="";
				String erro="";
				Aluno a = new Aluno();
				List<Aluno> alunos = new ArrayList<>();
				
				if(!cmd.contains("Listar")) {
					a.setRa(ra);
				}
				if(cmd.contains("Cadastrar") || cmd.contains("Alterar")) {
					a.setCpf(cpf);
					a.setNome(nome);
					a.setNomeSocial(nomeSocial);
					a.setDataNasc(dataNasc);
					a.addTelefone(telefone);
					a.setEmailPessoal(emailPessoal);
					a.setEmailCorporativo(emailCorporativo);
					a.setDataSegundoGrau(dataSegundoGrau);
					a.setInstituicaoSegundoGrau(instituicaoSegundoGrau);
					a.setPontuacaoVestibular(Double.parseDouble(pontuacaoVestibular));
					a.setPosicaoVestibular(Integer.parseInt(posicaoVestibular));
					a.setAnoIngresso(anoIngresso);
					a.setSemestreIngresso(semestreIngresso);
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
}
