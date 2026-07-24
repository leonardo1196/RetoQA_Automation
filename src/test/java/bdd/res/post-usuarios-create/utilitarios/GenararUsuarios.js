function GeneracionUsuarios(cantidad) {
    var usuarios = [];
    for (var i = 0; i < cantidad; i++) {
        var random = Math.floor(Math.random() * 1000000);
        var esAdmin = Math.random() < 0.5
        usuarios.push({
            Name: 'Usuario' + random,
            email: 'usuario' + random + '@test.com',
            password: 'Pass' + random + '!',
            administrador: esAdmin
        });
    }
    return usuarios;
}