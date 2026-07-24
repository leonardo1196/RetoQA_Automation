function UtilidadesArchivo() {
    var Files = Java.type('java.nio.file.Files');
    var Paths = Java.type('java.nio.file.Paths');
    var StandardOpenOption = Java.type('java.nio.file.StandardOpenOption');

    function escribirArchivo(contenido, ruta) {
        var rutaArchivo = Paths.get(ruta);
        Files.write(rutaArchivo, contenido.getBytes('UTF-8'));
    }


    function agregarId(ruta, nombreUsuario, id) {
        var rutaArchivo = Paths.get(ruta);
        var lineasLeidas = Files.readAllLines(rutaArchivo);
        var lineas = [];
        for (var i = 0; i < lineasLeidas.size(); i++) {
            lineas.push(lineasLeidas.get(i));
        }
        if (lineas.length > 0 && lineas[0].indexOf('_id') === -1) {
            lineas[0] = lineas[0] + ',_id';
        }
        for (var i = 1; i < lineas.length; i++) {
            var columnas = lineas[i].split(',');
            if (columnas[0] === nombreUsuario) {
                lineas[i] = lineas[i] + ',' + id;
            }
        }
        Files.write(rutaArchivo, lineas.join('\n').getBytes('UTF-8'));
    }

    return {
        escribirArchivo: escribirArchivo,
        agregarId: agregarId
    };
}
