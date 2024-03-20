package persistence;

import java.sql.SQLException;

public interface IIud<T> {
	public String iud(String acao, T t) throws SQLException, ClassNotFoundException;
}
