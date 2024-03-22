package model;

import java.util.ArrayList;
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
	String dataNasc;
	List<Telefone> telefones;
	String emailPessoal;
	String emailCorporativo;
	String dataSegundoGrau;
	String instituicaoSegundoGrau;
	double pontuacaoVestibular;
	int posicaoVestibular;
	String anoIngresso;
	String semestreIngresso;
	String semestreGraduacao;
	String anoLimite;
	
	public void addTelefone(String telefone) {
		Telefone t = new Telefone();
		if(telefones == null) {
			telefones = new ArrayList<>();
		}
		t.setTelefone(telefone);
		telefones.add(t);
	}

	public void remTelefone(String telefone) {
		telefones.remove(telefones.size()-1);
	}
}
