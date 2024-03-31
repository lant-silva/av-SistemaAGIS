package model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MatriculaDisciplinas {
	int codigoMatricula;
	int codigoDisciplina;
	String situacao;
	Disciplina disciplina;
}
