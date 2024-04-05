package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Aluno;
import model.Telefone;

public class TelefoneDao implements ITelefone<Telefone>{
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
	
	public String iud(String acao, Telefone a) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "CALL sp_iudtelefone (?,?,?,?)";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, acao);
		cs.setString(2,a.getTelefone());
		cs.setString(3, a.getAluno().getCpf());
		cs.registerOutParameter(4, Types.VARCHAR);
		cs.execute();
		String saida = cs.getString(4);
		cs.close();
		c.close();
		return saida;
	}
	
	@Override	
	public void inserir(Telefone t) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "INSERT INTO aluno_telefone VALUES (?,?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, t.getTelefone());
		ps.setString(2, t.getAluno().getRa());
		ps.execute();
		ps.close();
		c.close();
	}

	@Override
	public void atualizar(Telefone t) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "UPDATE telefone SET telefone = ? WHERE aluno_ra = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, t.getTelefone());
		ps.setString(2, t.getAluno().getRa());
		ps.execute();
		ps.close();
		c.close();
	}

	@Override
	public void excluir(Telefone t) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "DELETE aluno_telefone WHERE telefone = ?   AND  aluno_ra = ? ";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, t.getTelefone());
		ps.setString(2, t.getAluno().getRa());
		ps.execute();
		ps.close();
		c.close();
		
	}

	@Override
	public Telefone consultar(Telefone t) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT * FROM aluno_telefone WHERE telefone = ? AND aluno_ra = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1,  t.getTelefone());
		 ps.setString(2, t.getAluno().getRa());
		 ResultSet rs = ps.executeQuery();
		 
		 Telefone telefone = null;
		 if(rs.next()) {
			 telefone = new Telefone();
			 telefone.setTelefone(rs.getString("telefone"));
		
			 Aluno aluno = new Aluno();
			 aluno.setRa(rs.getString("aluno_ra"));
			 
			 telefone.setAluno(aluno);
		 }
		 
		 rs.close();
		 ps.close();
		 c.close();
		 
		 return telefone;
	}
	
	public List<Telefone> listar() throws SQLException, ClassNotFoundException {
        List<Telefone> telefones = new ArrayList<>();        
        
        	Connection c = gDao.getConnection();
            String sql = "SELECT * FROM aluno_telefone";
            PreparedStatement   ps = c.prepareStatement(sql);
            ResultSet  rs = ps.executeQuery();

            while (rs.next()) {
                Telefone telefone = new Telefone();
                telefone.setTelefone(rs.getString("telefone"));

                Aluno aluno = new Aluno();
                aluno.setRa(rs.getString("aluno_ra"));
                
                telefone.setAluno(aluno);

                telefones.add(telefone);
            }
        
		rs.close();
		ps.close();
		c.close();
        return telefones;
    }		

}
