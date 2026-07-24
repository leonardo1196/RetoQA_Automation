function ActualizarUsuarioCsv() {
    var Files = Java.type('java.nio.file.Files');
    var Paths = Java.type('java.nio.file.Paths');

    function actualizarUsuario(ruta, id, nuevosDatos) {
        var rutaArchivo = Paths.get(ruta);
        var lineasLeidas = Files.readAllLines(rutaArchivo);
        var lineas = [];
        for (var i = 0; i < lineasLeidas.size(); i++) {
            lineas.push(lineasLeidas.get(i));
        }

        var headers = lineas[0].split(',');
        var idxId = headers.indexOf('_id');

        function fueProvisto(valor) {
            return valor !== undefined && valor !== null && valor !== '';
        }

        for (var i = 1; i < lineas.length; i++) {
            var columnas = lineas[i].split(',');
            if (columnas[idxId] === id) {
                for (var j = 0; j < headers.length; j++) {
                    var campo = headers[j];
                    if (campo !== '_id' && fueProvisto(nuevosDatos[campo])) {
                        columnas[j] = nuevosDatos[campo];
                    }
                }
                lineas[i] = columnas.join(',');
            }
        }

        Files.write(rutaArchivo, lineas.join('\n').getBytes('UTF-8'));
    }

    return {
        actualizarUsuario: actualizarUsuario
    };
}
