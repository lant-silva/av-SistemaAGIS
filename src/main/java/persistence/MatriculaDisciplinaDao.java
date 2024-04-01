package persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
	public void inserirMatricula(String cpf, int codigoDisciplina) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "CALL sp_inserirmatricula(?,?,?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setInt(1, codigoMatricula);
		ps.setInt(2, codigoDisciplina);
		ps.setString(3, situacao);
		ps.execute();
		ps.close();
		c.close();
	}

	@Override
	public List<MatriculaDisciplinas> listarSituacao(String alunoCpf)
			throws SQLException, ClassNotFoundException {
		List<MatriculaDisciplinas> ms = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT d.codigo AS codigo, d.nome AS nome, d.qtd_aulas AS qtd_aulas,"
				+ " d.horario AS horario, d.dia AS dia, md.situacao AS situacao, d.curso_codigo AS curso_codigo,"
				+ "	md.codigo_matricula AS codigo_matricula"
				+ "	FROM matricula_disciplina md, disciplina d, aluno a, matricula m"
				+ "	WHERE m.codigo = md.codigo_matricula"
				+ "	AND d.codigo = md.codigo_disciplina"
				+ "	AND m.aluno_cpf = ? ";
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

}
