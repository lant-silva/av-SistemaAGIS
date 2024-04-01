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
import model.MatriculaDisciplinas;

public class MatriculaDisciplinaDao implements IDisciplina{
	private GenericDao gDao;
	
	public MatriculaDisciplinaDao(GenericDao gDao) {
		this.gDao = gDao;
	}

	@Override
	public String inserirMatricula(int codigoMatricula, int codigoDisciplina, String cpf) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "CALL sp_inserirmatricula(?,?,?)";
		CallableStatement cs = c.prepareCall(sql);
		cs.setInt(1, codigoDisciplina);
		cs.setString(2, cpf);
		cs.registerOutParameter(3, Types.VARCHAR);
		cs.execute();
		String saida = cs.getString(3);
		cs.close();
		c.close();
		return saida;
	}

	@Override
	public List<MatriculaDisciplinas> listarSituacao(String alunoCpf)
			throws SQLException, ClassNotFoundException {
		List<MatriculaDisciplinas> ms = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT TOP 1 md.codigo_matricula AS codigo_matricula, d.codigo AS codigo, d.nome AS nome, d.qtd_aulas AS qtd_aulas,"
				+ " d.horario AS horario, d.dia AS dia, md.situacao AS situacao, d.curso_codigo AS curso_codigo"
				+ "	FROM matricula_disciplina md, disciplina d, aluno a, matricula m"
				+ "	WHERE m.codigo = md.codigo_matricula"
				+ "	AND d.codigo = md.codigo_disciplina"
				+ "	AND m.aluno_cpf = ? "
				+ " ORDER BY codigo_matricula DESC";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, alunoCpf);
		ResultSet rs = ps.executeQuery();
		while(rs.next()) {
			MatriculaDisciplinas m = new MatriculaDisciplinas();
			Disciplina d = new Disciplina();
			d.setCodigo(rs.getInt("codigo"));
			d.setNome(rs.getString("nome"));
			d.setQtdAulas(rs.getInt("qtd_aulas"));
			d.setHorario(rs.getString("horario"));
			d.setDiaSemana(rs.getString("dia"));
			d.setCursoCodigo(rs.getInt("curso_codigo"));
			m.setDisciplina(d);
			m.setCodigoMatricula(rs.getInt("codigo_matricula"));
			m.setSituacao(rs.getString("situacao"));
			ms.add(m);
		}
		rs.close();
		ps.close();
		c.close();
		return ms;
	}

	@Override
	public String gerarMatricula(String alunoCpf) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "CALL sp_gerarmatricula (?,?)";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, alunoCpf);
		cs.registerOutParameter(2, Types.VARCHAR);
		cs.execute();
		String saida = cs.getString(2);
		cs.close();
		c.close();
		return saida;
	}

}
