@obtener-usuarios
Feature: Validar el endpoint de traer los datos del cliente del api de usuarios

  @Reutilizable @ignore
  Scenario: [Status 200] Validar traer informacion de usuario correctamente
    Given url UrlHost + '/usuarios/'+_id
    When method get
    Then status 200
    * def datos_usuario = response

  @happypath
  Scenario Outline: [Status 200] Validar traer informacion de usuario correctamente
    Given url UrlHost + '/usuarios/'+_id
    When method get
    Then status 200
    * match response.nome != null
    * match response.email != null
    * match response.password != null
    * match response.administrador != null
    * match response._id != null

    Examples:
      | karate.read('classpath:bdd/res/post-usuarios-create/data.csv')|


  @happypath
  Scenario Outline: [Status 200] Validar consistencia de datos
    Given url UrlHost + '/usuarios/'+_id
    When method get
    Then status 200
    * match response.nome == Name
    * match response.email == email
    * match response.password == password
    * match response.administrador == administrador
    * match response._id == _id

    Examples:
      | karate.read('classpath:bdd/res/post-usuarios-create/data.csv')|


  @unhappypath
  Scenario Outline: [Status 400] Validar respuesta al obtener datos de usuario no existente o id vacio
    Given url UrlHost + '/usuarios/'+id_erroneo
    When method get
    Then status 400
    Examples:
      |id_erroneo|
      | |
      |5|
      |a*|


  @unhappypath
  Scenario Outline: [Status 411] Validar respuesta al obtener datos con metodo que no corresponde
    Given url UrlHost + '/usuarios/'+_id
    When method post
    Then status 411
    Examples:
      | karate.read('classpath:bdd/res/post-usuarios-create/data.csv')|