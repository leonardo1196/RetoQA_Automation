Feature: Generar datos para escenarios

  Background:
    * def body_json = read('classpath:bdd/res/post-usuarios-create/body.json')

    @CrearUsuariosSinRegistrar
    Scenario: Generacion de datos de usuarios para registrar
      * def generarUsuarios = read('classpath:bdd/res/post-usuarios-create/utilitarios/GenararUsuarios.js')
      * def arrayACsv = read('classpath:bdd/res/post-usuarios-create/utilitarios/ArrayToCsv.js')
      * def escribirArchivo = read('classpath:bdd/res/post-usuarios-create/utilitarios/EscribirArchivo.js')()
      * def usuariosNuevos = generarUsuarios(5)
      * def contenidoCsv = arrayACsv(usuariosNuevos)
      * escribirArchivo.escribirArchivo(contenidoCsv, 'src/test/java/bdd/res/post-usuarios-create/data.csv')
      * def data = read('file:src/test/java/bdd/res/post-usuarios-create/data.csv')

      @RegistrarUsuarios
      Scenario Outline: [Status 200] Validar la creacion de un usuario de forma exitosa
        Given url UrlHost + '/usuarios'
        And request body_json
        When method post
        Then status 201
        * def id = response._id
        * def escribirArchivo = read('classpath:bdd/res/post-usuarios-create/utilitarios/EscribirArchivo.js')()
        * escribirArchivo.agregarId('src/test/java/bdd/res/post-usuarios-create/data.csv', Name, id)
        Examples:
          | karate.call('classpath:bdd/usuarios/utilitarios/generacionData.feature@CrearUsuariosSinRegistrar').data |