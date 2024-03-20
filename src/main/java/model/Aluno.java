package model;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Aluno {
	String ra;
	String cpf;
	String nome;
	String nomeSocial;
	LocalDate dataNasc;
	String emailPessoal;
	String emailCorporativo;
	LocalDate dataSegundoGrau;
	String instituicaoSegundoGrau;
	double pontuacaoVestibular;
	int posicaoVestibular;
	
}
