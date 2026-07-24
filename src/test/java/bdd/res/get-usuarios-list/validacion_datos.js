function validarDatos(listausuarios){
    var cantidadusuarios = listausuarios.length ;
    for(var i=0;i< cantidadusuarios; i++){
        karate.match(listausuarios[i].nome,'#notnull');
        karate.match(listausuarios[i].email,'#notnull');
        karate.match(listausuarios[i].password,'#notnull');
        karate.match(listausuarios[i].administrador,'#notnull');
        karate.match(listausuarios[i]._id,'#notnull');
    }
}