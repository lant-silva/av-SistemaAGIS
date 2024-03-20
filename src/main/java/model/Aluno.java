package model;

import java.time.LocalDate;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Aluno {
	String cpf;
	String ra;
	String nome;
	String nomeSocial;
	LocalDate dataNasc;
	List<Telefone> telefones;
	String emailPessoal;
	String emailCorporativo;
	LocalDate dataSegundoGrau;
	String instituicaoSegundoGrau;
	double pontuacaoVestibular;
	int posicaoVestibular;
}
