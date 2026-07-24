@put-usuarios-update
Feature: Validar la actualizacion de los datos en el api de usuarios
  Background:
    * def body_json_update = read('classpath:bdd/res/patch-usuarios-update/body.json')

    @happypath
  Scenario Outline: [Status 200] Validar la actualizacion correcta
    * def generarUsuarios = read('classpath:bdd/res/post-usuarios-create/utilitarios/GenararUsuarios.js')
    * def usuariosNuevos = generarUsuarios(1)
    Given url UrlHost + '/usuarios/'+ _id
    * set body_json_update.nome = usuariosNuevos[0].Name
    * set body_json_update.email = usuariosNuevos[0].email
    * set body_json_update.password = usuariosNuevos[0].password
    * set body_json_update.administrador = usuariosNuevos[0].administrador.toString()
    And request body_json_update
    When method put
    Then status 200
    * match response.message == 'Registro alterado com sucesso'
    * def actualizarCsv = read('classpath:bdd/res/patch-usuarios-update/utilitarios/ActualizarUsuarioCsv.js')()
    * actualizarCsv.actualizarUsuario('src/test/java/bdd/res/post-usuarios-create/data.csv', _id,usuariosNuevos[0])
    Examples:
      | karate.read('file:src/test/java/bdd/res/post-usuarios-create/data.csv')|

  @happypath
  Scenario Outline: [Status 200] Validar la consistencia de los datos actualizados
    * def generarUsuarios = read('classpath:bdd/res/post-usuarios-create/utilitarios/GenararUsuarios.js')
    * def usuariosNuevos = generarUsuarios(1)
    Given url UrlHost + '/usuarios/'+ _id
    * set body_json_update.nome = usuariosNuevos[0].Name
    * set body_json_update.email = usuariosNuevos[0].email
    * set body_json_update.password = usuariosNuevos[0].password
    * set body_json_update.administrador = usuariosNuevos[0].administrador.toString()
    And request body_json_update
    When method put
    Then status 200
    * call read('classpath:bdd/usuarios/get-usuarios-id.feature@Reutilizable')
    * match datos_usuario.nome == usuariosNuevos[0].Name
    * match datos_usuario.email == usuariosNuevos[0].email
    * match datos_usuario.password == usuariosNuevos[0].password
    * match datos_usuario.administrador == usuariosNuevos[0].administrador.toString()
    * def actualizarCsv = read('classpath:bdd/res/patch-usuarios-update/utilitarios/ActualizarUsuarioCsv.js')()
    * actualizarCsv.actualizarUsuario('src/test/java/bdd/res/post-usuarios-create/data.csv', _id,usuariosNuevos[0])
    Examples:
      | karate.read('file:src/test/java/bdd/res/post-usuarios-create/data.csv')|

    @happypath
    Scenario Outline: [Status 201] Validar creacion de usuario si el id no existe para actualizar
      * def generarUsuarios = read('classpath:bdd/res/post-usuarios-create/utilitarios/GenararUsuarios.js')
      * def usuariosNuevos = generarUsuarios(1)
      Given url UrlHost + '/usuarios/'+ id
      * set body_json_update.nome = usuariosNuevos[0].Name
      * set body_json_update.email = usuariosNuevos[0].email
      * set body_json_update.password = usuariosNuevos[0].password
      * set body_json_update.administrador = usuariosNuevos[0].administrador.toString()
      And request body_json_update
      When method put
      Then status 201
      * match response.message == "Cadastro realizado com sucesso"
      * match response._id != null
      Examples:
        | id |
        |asdasda|
        | 52456 |

  @unhappypath
  Scenario Outline: [Status 400] Validar la actualizacion de datos con correo ya utilizado
    * def randomStr = java.util.UUID.randomUUID() + ''
    * def randomStr8 = randomStr.replace('-', '').substring(0, 8)
    Given url UrlHost + '/usuarios/'+ randomStr8
    And request body_json_update
    When method put
    Then status 400
    Examples:
      | karate.read('file:src/test/java/bdd/res/post-usuarios-create/data.csv')|




