package model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Disciplina {
	int codigo;
	String nome;
	int qtdAulas;
	String horario;
	String diaSemana;
	int cursoCodigo;
}
