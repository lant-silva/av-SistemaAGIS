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
import model.Telefone;
import persistence.DisciplinaDao;
import persistence.GenericDao;
import persistence.TelefoneDao;

@WebServlet("/listaTelefone")
public class TelefoneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public TelefoneServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	String erro = "";
    	List<Telefone> telefones = new ArrayList<>();
    	GenericDao gDao = new GenericDao();
    	TelefoneDao pDao = new TelefoneDao(gDao);
    	
    	try {
    		telefones = pDao.listar();
    	} catch (ClassNotFoundException | SQLException e) {
			erro = e.getMessage();

		} finally {
			request.setAttribute("erro", erro);
			request.setAttribute("telefones", telefones);

			RequestDispatcher rd = request.getRequestDispatcher("listaTelefone.jsp");
			rd.forward(request, response);
		}
        
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
        String acao = request.getParameter("acao");
        String telefone = request.getParameter("telefone");
        String alunoRa = request.getParameter("aluno_ra");
        
        String saida = "";
        String erro = "";
        Telefone t = new Telefone();
        
        List<Telefone> telefones = new ArrayList<>();
        List<Aluno> alunos = new ArrayList<>();
        
        if (!acao.contains("Listar")) {
            t.setTelefone((telefone));
        }
        try {
            telefones = listarTelefones();
            if (acao.contains("Cadastrar") || acao.contains("Alterar")) {
                t.setTelefone(telefone);
                Aluno a = new Aluno();
                a.setRa(alunoRa);
                a = buscarTelefone(a);
                t.setAluno(a);
            }
            if (acao.contains("Cadastrar")) {
                cadastrarTelefone(t);
                saida = "Telefone cadastrado com sucesso";
                t = null;
            }
            if (acao.contains("Alterar")) {
                alterarTelefone(t);
                t = null;
            }
            if (acao.contains("Excluir")) {
                excluirTelefone(t);
                saida = "Telefone excluido com sucesso";
                t = null;
            }
            if(acao.contains("Buscar")) {
                t = buscarTelefone(t);
            }
            if(acao.contains("Listar")) {
                telefones = listarTelefones();
            }
        } catch (SQLException | ClassNotFoundException e) {
            erro = e.getMessage();
        } finally {
            request.setAttribute("saida", saida);
            request.setAttribute("erro", erro);
            request.setAttribute("telefone", t);
            request.setAttribute("telefones", telefones);
            request.setAttribute("alunos", alunos);
            
            RequestDispatcher rd = request.getRequestDispatcher("listaTelefone.jsp");
            rd.forward(request, response);
        }
    }

    private Aluno buscarTelefone(Aluno a) {
        // Método para buscar telefone
        return null;
    }

    private String cadastrarTelefone(Telefone t) throws ClassNotFoundException, SQLException {
        // Método para cadastrar telefone
    	GenericDao gDao = new GenericDao();
    	TelefoneDao pDao = new TelefoneDao (gDao);
    	String saida = pDao.iud("I", t);
    	return saida;
    }

    private void alterarTelefone (Telefone t) throws ClassNotFoundException, SQLException {
        // Método para alterar telefone
    	GenericDao gDao = new GenericDao();
    	TelefoneDao pDao = new TelefoneDao (gDao);
    	pDao.atualizar(t);
    			
    			
    }

    private void excluirTelefone(Telefone t) throws ClassNotFoundException, SQLException {
        // Método para excluir telefone
    	GenericDao gDao = new GenericDao();
    	TelefoneDao pDao = new TelefoneDao (gDao);
    	pDao.excluir(t);
    }

    private Telefone buscarTelefone(Telefone t) throws ClassNotFoundException, SQLException {
        // Método para buscar telefone
    	GenericDao gDao = new GenericDao();
    	TelefoneDao pDao = new TelefoneDao (gDao);
    	t = pDao.consultar(t);
    	return t;
    }

    private List<Telefone> listarTelefones() throws ClassNotFoundException, SQLException {
        // Método para listar telefones
    	GenericDao gDao = new GenericDao();
    	TelefoneDao pDao = new TelefoneDao(gDao);
    	List<Telefone> telefones = pDao.listar();
    	
    	return telefones;
    }
    
    

}
