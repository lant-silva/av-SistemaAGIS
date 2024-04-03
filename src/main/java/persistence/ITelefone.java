package persistence;

import java.sql.SQLException;
import java.util.List;
import model.Aluno;
import model.Telefone;

public interface ITelefone {
	/**Insere uma lista de telefones no banco de dados do sistema, lista essa determinada no CRUD do aluno.
	 * 
	 * @param t - Lista de telefones 
	 * @param a - Uma instância de um objeto Aluno
	 * @throws SQLException
	 * @throws ClassNotFoundException
	 */
	public void insereTelefone(List<Telefone> t, Aluno a) throws SQLException, ClassNotFoundException;
}
