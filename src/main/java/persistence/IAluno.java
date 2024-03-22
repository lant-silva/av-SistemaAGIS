package persistence;

import java.sql.SQLException;
import model.Aluno;

public interface IAluno{
	public String gerarRA(Aluno a) throws SQLException, ClassNotFoundException;
	public String gerarSemestre(Aluno a) throws SQLException, ClassNotFoundException;
}
