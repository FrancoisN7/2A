import java.util.HashMap;

public class EvaluateurExpression implements VisiteurExpression<Integer> {
	private HashMap<String, Integer> environnement; 
	private int g;
	private int d;
	
	public EvaluateurExpression( HashMap<String, Integer> environnement) {
		this.environnement = environnement;
	
	}
	
	public Integer visiterAccesVariable(AccesVariable v) {
		return environnement.get(v.getNom());
	}

	public Integer visiterConstante(Constante c) {
		return c.getValeur();
	}

	public Integer visiterExpressionBinaire(ExpressionBinaire e) {
		int g = e.getOperandeGauche().accepter(this);	
		 d = e.getOperandeDroite().accepter(this);
		 this.g = g;
		  return e.getOperateur().accepter(this)  
			;
	}

	public Integer visiterAddition(Addition a) {
		return g + d;
	}

	public Integer visiterMultiplication(Multiplication m) {
		return g*d;
	}

	public Integer visiterExpressionUnaire(ExpressionUnaire e) {
		d = e.getOperande().accepter(this);
		return e.getOperateur().accepter(this)
			 ;
	}

	public Integer visiterNegation(Negation n) {
		return -d;
	}
	
	public Integer visiterSoustraction(Soustraction s) {
		return g-d;
	}
}
