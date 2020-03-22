import java.io.BufferedWriter;

import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

public aspect archivo {
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
		operaciones.add("Retiro dinero: " + ((Long) thisJoinPoint.getArgs()[0]).longValue());
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
		FileWriter  writer = null;
		BufferedWriter bw = null;
		try {
			writer = new FileWriter ("log.txt", true);
			bw = new BufferedWriter(writer);
			bw.write(operaciones.toString());
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				// Cierra instancias de FileWriter y BufferedWriter
				if (bw != null)
					bw.close();
				if (writer != null)
					writer.close();
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}

	}
}
