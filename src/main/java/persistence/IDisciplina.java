package persistence;

import java.sql.SQLException;
import java.util.List;

import model.Aluno;
import model.MatriculaDisciplinas;

public interface IDisciplina {
	public String gerarMatricula(String alunoCpf) throws SQLException, ClassNotFoundException;
	public String inserirMatricula(int codigoMatricula, int codigoDisciplina, String alunoCpf) throws SQLException, ClassNotFoundException;
	public List<MatriculaDisciplinas> listarSituacao(String alunoCpf) throws SQLException, ClassNotFoundException;
}
