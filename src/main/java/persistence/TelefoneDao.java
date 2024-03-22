package persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import model.Aluno;
import model.Telefone;

public class TelefoneDao implements ITelefone{
	private GenericDao gDao;
	
	public TelefoneDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public void insereTelefone(List<Telefone> t, Aluno a) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		PreparedStatement ps = null;
		for(Telefone tel : t) {
			String sql = "INSERT INTO aluno_telefone VALUES (?,?)";
			ps = c.prepareStatement(sql);
			ps.setObject(1, tel);
			ps.setString(2, a.getCpf());
			ps.executeQuery(sql);
		}
		ps.close();
		c.close();
	}
}
