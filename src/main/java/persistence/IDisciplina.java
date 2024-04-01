package persistence;

import java.sql.SQLException;
import java.util.List;

import model.Aluno;
import model.MatriculaDisciplinas;

public interface IDisciplina {
	public void inserirMatricula(String[] disciplinasSelecionadas) throws SQLException, ClassNotFoundException;
	public List<MatriculaDisciplinas> listarSituacao(String alunoCpf) throws SQLException, ClassNotFoundException;
}
