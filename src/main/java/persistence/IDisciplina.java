package persistence;

import java.sql.SQLException;
import java.util.List;

import model.Aluno;
import model.MatriculaDisciplinas;

public interface IDisciplina {
	public String gerarMatricula(String alunoRa) throws SQLException, ClassNotFoundException;
	public String inserirMatricula(String ra, int codigoMatricula, int codigoDisciplina) throws SQLException, ClassNotFoundException;
	public List<MatriculaDisciplinas> listarSituacao(String alunoRa) throws SQLException, ClassNotFoundException;
}
