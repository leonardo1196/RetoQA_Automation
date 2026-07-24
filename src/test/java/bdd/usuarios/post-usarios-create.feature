@crear-usuarios
Feature: Validar el endpoint de creacion de usuarios del api de usuarios

  Background:
    * def body_json = read('classpath:bdd/res/post-usuarios-create/body.json')

  @happypath
  Scenario Outline: [Status 200] Validar la creacion de un usuario de forma exitosa
    Given url UrlHost + '/usuarios'
    And request body_json
    When method post
    Then status 201
    * match response.message == "Cadastro realizado com sucesso"

    Examples:
      | karate.call('classpath:bdd/usuarios/utilitarios/generacionData.feature@CrearUsuariosSinRegistrar').data|


  @unhappypath
  Scenario Outline: [Status 400] Validar creacion de usuario con datos con formato incorrecto o nulos
    Given url UrlHost + '/usuarios'
    And request body_json
    When method post
    Then status 400
    Examples:
      |Name      |email              |password    |administrador|
      |          | CarlosV11@test.com| Pass434194!| true        |
      | CarlosV1 |                   | Pass771557!| false       |
      | CarlosV1 |       5           | Pass771557!| false       |
      | CarlosV2 | CarlosV2@test.com |            | true        |
      | CarlosV3 | CarlosV3@test.com | Pass673491!|             |
      | CarlosV6 | CarlosV6test.com  | Pass837399!| true        |
      | CarlosV7 | CarlosV7@test.com | Pass837399!| adsa        |
      | CarlosV8 | CarlosV8@test.com | Pass837399!| 8           |


  @unhappypath
  Scenario Outline: [Status 400] Validar creacion de usuario con correo ya registrado
    Given url UrlHost + '/usuarios'
    And request body_json
    When method post
    Then status 400
    * match response.message == "Este email já está sendo usado"
    Examples:
      |Name           |email                    |password    |administrador|
      | CarlosV7      | usuario837399@test.com | Pass837399! | false        |

  @unhappypath
  Scenario Outline: [Status 405] Validar creacion de usuario con endpoint incorrecto
    Given url UrlHost + '/usuario'
    And request body_json
    When method post
    Then status 405
    Examples:
      |Name           |email                    |password    |administrador|
      | LeonardoV3      | mlroncerosW@test.com | Pass837399! | false        |

  @unhappypath
  Scenario Outline: [Status 405] Validar creacion de usuario con metodo incorrecto
    Given url UrlHost + '/usuarios'
    And request body_json
    When method patch
    Then status 405
    Examples:
      |Name           |email                    |password    |administrador|
      | LeonardoV3      | mlroncerosW@test.com | Pass837399! | false        |






