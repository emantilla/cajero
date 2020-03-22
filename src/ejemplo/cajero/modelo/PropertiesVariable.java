package ejemplo.cajero.modelo;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;

public class PropertiesVariable {

	private static Properties opciones;

	public static Properties getInstance() {
		if (opciones == null) {
			new PropertiesVariable();
			return opciones;
		} else {
			return opciones;
		}
	}

	private PropertiesVariable() {
		opciones = new Properties();
		File file = new File(
				"src/config.properties");
		try {
			opciones.load(new FileReader(file));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
