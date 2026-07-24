function EliminarUsuarioCsv() {
    var Files = Java.type('java.nio.file.Files');
    var Paths = Java.type('java.nio.file.Paths');

    function eliminarUsuario(ruta, id) {
        var rutaArchivo = Paths.get(ruta);
        var lineasLeidas = Files.readAllLines(rutaArchivo);
        var lineas = [];
        for (var i = 0; i < lineasLeidas.size(); i++) {
            lineas.push(lineasLeidas.get(i));
        }

        var headers = lineas[0].split(',');
        var idxId = headers.indexOf('_id');

        var lineasRestantes = [lineas[0]];
        for (var i = 1; i < lineas.length; i++) {
            var columnas = lineas[i].split(',');
            if (columnas[idxId] !== id) {
                lineasRestantes.push(lineas[i]);
            }
        }

        Files.write(rutaArchivo, lineasRestantes.join('\n').getBytes('UTF-8'));
    }

    return {
        eliminarUsuario: eliminarUsuario
    };
}
