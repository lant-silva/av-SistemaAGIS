package persistence;

import java.sql.SQLException;
import java.util.List;

import model.MatriculaDisciplinas;

public interface IDisciplina {
	public void inserirEmMatricula(int codigoMatricula, int codigoDisciplina, String situacao) throws SQLException, ClassNotFoundException;
	public List<MatriculaDisciplinas> listarSituacao(int codigoMatricula, int codigoDisciplina) throws SQLException, ClassNotFoundException;
}
