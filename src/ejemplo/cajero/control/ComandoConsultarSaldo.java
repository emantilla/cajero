package ejemplo.cajero.control;

import java.util.Scanner;

import ejemplo.cajero.modelo.Banco;
import ejemplo.cajero.modelo.Cuenta;

/**
 * Comando usado para listar las cuentas 
 */
public class ComandoConsultarSaldo implements Comando {

	@Override
	public String getNombre() {
		return "Consultar Saldo";
	}

	@Override
	public void ejecutar(Banco contexto) throws Exception {
		System.out.println("Consultar Saldo");
		System.out.println();
		
		// la clase Console no funciona bien en Eclipse
		Scanner console = new Scanner(System.in);			
		
		// Ingresa los datos
		System.out.println("Ingrese el número de cuenta");
		String numeroDeCuenta = console.nextLine();
		
		Cuenta cuenta = contexto.buscarCuenta(numeroDeCuenta);
		if (cuenta == null) {
			throw new Exception("No existe cuenta con el número " + numeroDeCuenta);
		}
		System.out.println("Saldo de la cuenta: " + cuenta.getSaldo());
	}

}
