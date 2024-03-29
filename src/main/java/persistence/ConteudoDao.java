package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import model.Conteudo;
import model.Disciplina;

public class ConteudoDao implements ICrud<Conteudo>, IIud<Conteudo>{
	private GenericDao gDao;
	
	public ConteudoDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public String iud(String acao, Conteudo c) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "CALL sp_iudconteudo (?,?,?,?,?)";
		CallableStatement cs = c.prepareCall(sql);                                                                      
		cs.setString(1, acao);
		cs.setInt(2, c);
	}

	@Override
	public Conteudo consultar(Conteudo c) throws SQLException, ClassNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Conteudo> listar() throws SQLException, ClassNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}
	
	
}
