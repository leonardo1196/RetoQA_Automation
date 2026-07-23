@listar-usarios
Feature: Validar el endpoint de listar usarios del api de usuarios

  Background:
    * def validacion_datos = read ('classpath:bdd/res/get-usuarios-list/validacion_datos.js')
  @happypath
  Scenario: [Status 200] Validar que trae correctamente el listado de usuarios registrados
    Given url UrlHost + '/usuarios'
    When method get
    Then status 200

  @happypath
  Scenario: [Status 200] Validar que los campos principales de cantidad y usuarios no sean nulos
    Given url UrlHost + '/usuarios'
    When method get
    Then status 200
    * match response.quantidade != null
    * match response.usuarios != null

  @happypath
  Scenario: [Status 200] Validar que la cantidad contabilizada corresponda con el numero total de usuarios registrados
    Given url UrlHost + '/usuarios'
    When method get
    Then status 200
    And def quantidade = response.quantidade
    And def usuarios = response.usuarios
    And def cantidad_usuarios = usuarios.length
    * match quantidade == cantidad_usuarios

  @happypath
  Scenario: [Status 200] Validar que los datos de los usuarios contengan los campos requeridos
    Given url UrlHost + '/usuarios'
    When method get
    Then status 200
    And def usuarios = response.usuarios
    * eval validacion_datos(usuarios)

  @unhappypath
  Scenario: [Status 405] Validar que la api de error 404 cuando se envia un endpoint incorrecto
    Given url UrlHost + '/usuario'
    When method get
    Then status 405


  @unhappypath
  Scenario: [Status 411] Validar que la api de error 411 cuando se ejecuta con un metodo incorrecto
    Given url UrlHost + '/usuario'
    When method put
    Then status 411


