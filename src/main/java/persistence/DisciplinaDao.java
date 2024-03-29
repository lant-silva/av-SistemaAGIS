package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Disciplina;

public class DisciplinaDao implements ICrud<Disciplina>, IIud<Disciplina>{
	private GenericDao gDao;
	
	public DisciplinaDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public String iud(String acao, Disciplina d) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "CALL sp_iuddisciplina (?,?,?,?,?,?,?,?)";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, acao);
		cs.setInt(2, d.getCodigo());
		cs.setString(3, d.getNome());
		cs.setInt(4, d.getQtdAulas());
		cs.setString(5, d.getHorario());
		cs.setString(6, d.getDiaSemana());
		cs.setInt(7, d.getCursoCodigo());
		cs.registerOutParameter(8, Types.VARCHAR);
		cs.execute();
		String saida = cs.getString(8);
		cs.close();
		c.close();
		return saida;
	}

	@Override
	public Disciplina consultar(Disciplina d) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT * FROM v_disciplinas";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		if(rs.next()) {
			d.setCodigo(rs.getInt("codigo"));
			d.setNome(rs.getString("nome"));
			d.setQtdAulas(rs.getInt("qtd_aulas"));
			d.setHorario(rs.getString("horario"));
			d.setDiaSemana(rs.getString("dia"));
			d.setCursoCodigo(rs.getInt("curso_codigo"));
		}
		rs.close();
		ps.close();
		c.close();
		return d;
	}

	@Override
	public List<Disciplina> listar() throws SQLException, ClassNotFoundException {
		List<Disciplina> disciplinas = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT * FROM v_disciplinas";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while(rs.next()) {
			Disciplina d = new Disciplina();
			d.setCodigo(rs.getInt("codigo"));
			d.setNome(rs.getString("nome"));
			d.setQtdAulas(rs.getInt("qtd_aulas"));
			d.setHorario(rs.getString("horario"));
			d.setDiaSemana(rs.getString("dia"));
			d.setCursoCodigo(rs.getInt("curso_codigo"));
			disciplinas.add(d);
		}
		rs.close();
		ps.close();
		c.close();
		return disciplinas;
	}
}
