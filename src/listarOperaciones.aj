import java.util.ArrayList;
import java.util.List;

public aspect listarOperaciones {

	List<String> operaciones;
	long valor = 0;

	pointcut retirar() : call (* ejemplo.cajero.modelo.Cuenta.retirar(long));

	pointcut consignar() : call (* ejemplo.cajero.modelo.Cuenta.consignar(long));

	pointcut transferir() : call (void ejemplo.cajero.control.Comando.ejecutar(*));
	
	pointcut valor() : call (long ejemplo.cajero.control.ComandoTransferir.obtenerValor(String));
	
	pointcut saldo() : call (* ejemplo.cajero.modelo.Cuenta.getSaldo());

	pointcut salir() : execution (void ejemplo.cajero.Cajero.main(*));

	after() : saldo() {

		if (operaciones == null) {
			operaciones = new ArrayList<String>();
		}
		operaciones.add("Consultar Saldo");
	}
	
	after() : retirar() {

		if (operaciones == null) {
			operaciones = new ArrayList<String>();
		}
		operaciones.add("Retiro dinero: "+ ((Long) thisJoinPoint.getArgs()[0]).longValue());
	}

	after() : consignar() {

		if (operaciones == null) {
			operaciones = new ArrayList<String>();
		}
		operaciones.add("Consignar dinero: " + ((Long) thisJoinPoint.getArgs()[0]).longValue());
	}

	after(): transferir() {
		if (operaciones == null) {
			operaciones = new ArrayList<String>();
		}

		String metodo = thisJoinPoint.getTarget().toString().substring(
				thisJoinPoint.getTarget().toString().lastIndexOf(".") + 1,
				thisJoinPoint.getTarget().toString().lastIndexOf("@"));

		if (metodo.equalsIgnoreCase("ComandoTransferir")) {
			operaciones.remove(operaciones.size() - 1);
			operaciones.remove(operaciones.size() - 1);
			operaciones.add("Transferir dinero: " + valor);
		}

	}
	
	after(): valor() {
		valor = Long.parseLong((String) thisJoinPoint.getArgs()[0]);
	}
	

	after(): salir() {

		System.out.println("\t Saliendo ");
		if (operaciones != null) {
			System.out.println("\t Operaciones: " + operaciones);
		}
	}
}
