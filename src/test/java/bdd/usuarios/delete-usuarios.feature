@delete-usuarios
Feature: Validar el endpoint de eliminar usuarios del api de usuarios

  @happypath
  Scenario Outline: [Status 200] Validar la eliminacion exitosa
    Given url UrlHost + '/usuarios/'+ _id
    When method delete
    Then status 200
    * match response.message == 'Registro excluído com sucesso'
    * def eliminarCsv = read('classpath:bdd/res/delete-usuarios/utilitarios/EliminarUsuarioCsv.js')()
    * eliminarCsv.eliminarUsuario('src/test/java/bdd/res/post-usuarios-create/data.csv', _id)
    Examples:
      | karate.read('file:src/test/java/bdd/res/post-usuarios-create/data.csv')|


  @happypath
  Scenario: [Status 200] Validar la eliminacion exitosa
    * def randomStr = java.util.UUID.randomUUID() + ''
    * def randomStr8 = randomStr.replace('-', '').substring(0, 8)
    Given url UrlHost + '/usuarios/'+ randomStr8
    When method delete
    Then status 200
    * match response.message == 'Nenhum registro excluído'

  @unhappypath
  Scenario: [Status 411] Validar la eliminacion exitosa
    * def randomStr = java.util.UUID.randomUUID() + ''
    * def randomStr8 = randomStr.replace('-', '').substring(0, 8)
    Given url UrlHost + '/usuarios/'+ randomStr8
    When method put
    Then status 411