package persistence;

import java.sql.SQLException;
import java.util.List;
import model.Aluno;
import model.Telefone;

public interface ITelefone<T> {
	/**Insere uma lista de telefones no banco de dados do sistema, lista essa determinada no CRUD do aluno.
	 * 
	 * @param t - Lista de telefones 
	 * @param a - Uma instância de um objeto Aluno
	 * @throws SQLException
	 * @throws ClassNotFoundException
	 */
	public void insereTelefone(List<Telefone> t, Aluno a) throws SQLException, ClassNotFoundException;
	public void inserir(T t) throws SQLException, ClassNotFoundException;
	public void atualizar(T t) throws SQLException, ClassNotFoundException;
	public void excluir(T t) throws SQLException, ClassNotFoundException;
	public T consultar(T t) throws SQLException, ClassNotFoundException;
}
