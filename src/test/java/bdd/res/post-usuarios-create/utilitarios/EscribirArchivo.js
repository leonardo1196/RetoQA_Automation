function UtilidadesArchivo() {
    var Files = Java.type('java.nio.file.Files');
    var Paths = Java.type('java.nio.file.Paths');
    var StandardOpenOption = Java.type('java.nio.file.StandardOpenOption');

    function escribirArchivo(contenido, ruta) {
        var rutaArchivo = Paths.get(ruta);
        Files.write(rutaArchivo, contenido.getBytes('UTF-8'));
    }

    function escribirLinea(contenido, ruta) {
        var rutaArchivo = Paths.get(ruta);
        var textoAEscribir = contenido;
        if (Files.exists(rutaArchivo) && Files.size(rutaArchivo) > 0) {
            textoAEscribir = '\n' + contenido;
        }
        Files.write(rutaArchivo, textoAEscribir.getBytes('UTF-8'), StandardOpenOption.CREATE, StandardOpenOption.APPEND);
    }

    return {
        escribirArchivo: escribirArchivo,
        escribirLinea: escribirLinea
    };
}
