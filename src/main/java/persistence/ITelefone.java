package persistence;

import java.sql.SQLException;
import java.util.List;
import model.Aluno;
import model.Telefone;

public interface ITelefone {
	public void insereTelefone(List<Telefone> t, Aluno a) throws SQLException, ClassNotFoundException;
}
