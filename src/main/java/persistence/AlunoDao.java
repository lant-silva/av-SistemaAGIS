package persistence;

import java.sql.SQLException;
import java.util.List;

import model.Aluno;

public class AlunoDao implements ICrud<Aluno>, IIud<Aluno>{

	@Override
	public String iud(String acao, Aluno t) throws SQLException, ClassNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Aluno consultar(Aluno t) throws SQLException, ClassNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Aluno> listar() throws SQLException, ClassNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}

}
