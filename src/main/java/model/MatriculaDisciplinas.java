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
	Disciplina disciplina;
	int codigoMatricula;
	String situacao;
}
