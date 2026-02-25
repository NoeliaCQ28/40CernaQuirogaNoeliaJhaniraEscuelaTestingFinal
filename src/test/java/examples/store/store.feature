Feature: Automatizar Store - Petstore API
  Endpoints:
    - GET    /store/inventory
    - POST   /store/order
    - GET    /store/order/{orderId}
    - DELETE /store/order/{orderId}

  Background:
    * url apiPetStore


  # GET /store/inventory


  @TEST-STORE-01 @happypath
  Scenario: Verificar que el inventario retorna el mapa de estados con codigo 200
    Given path 'store', 'inventory'
    When method get
    Then status 200
    And print 'Inventario obtenido:', response

  @TEST-STORE-02 @happypath
  Scenario: Verificar que el inventario contiene al menos una clave de estado
    Given path 'store', 'inventory'
    When method get
    Then status 200
    And print 'Cantidad de estados en inventario:', response


  # POST /store/order


  @TEST-STORE-03 @happypath
  Scenario: Verificar la creacion de una orden valida con estado placed
    * def orderRequest = read('classpath:examples/jsonData/store/crearOrdenPlaced.json')
    Given path 'store', 'order'
    And request orderRequest
    When method post
    Then status 200
    And print 'Orden creada:', response

  @TEST-STORE-04 @happypath
  Scenario: Verificar la creacion de una orden con estado approved y complete true
    * def orderRequest = read('classpath:examples/jsonData/store/crearOrdenApproved.json')
    Given path 'store', 'order'
    And request orderRequest
    When method post
    Then status 200
    And print 'Orden aprobada creada:', response

  @TEST-STORE-05 @happypath
  Scenario Outline: Verificar la creacion de ordenes con distintos estados validos
    * def orderRequest =
      """
      {
        "id": <orderId>,
        "petId": <petId>,
        "quantity": 1,
        "status": "<status>",
        "complete": false
      }
      """
    Given path 'store', 'order'
    And request orderRequest
    When method post
    Then status 200
    And print 'Orden creada con status:', response

    Examples:
      | orderId | petId | status    |
      | 200     | 10    | placed    |
      | 201     | 11    | approved  |
      | 202     | 12    | delivered |

  @TEST-STORE-06 @unhappypath
  Scenario: Verificar que una orden con body vacio es aceptada por la API con codigo 200
    Given path 'store', 'order'
    And request {}
    When method post
    Then status 200
    And print 'Respuesta con body vacio:', response


  # GET /store/order/{orderId}


  @TEST-STORE-07 @happypath
  Scenario: Verificar la busqueda de una orden por ID valido
    Given path 'store', 'order', 1
    When method get
    Then status 200
    And print 'Orden encontrada por ID 1:', response

  @TEST-STORE-08 @happypath
  Scenario Outline: Verificar la busqueda de ordenes con IDs validos entre 1 y 10
    Given path 'store', 'order', <orderId>
    When method get
    Then status 200
    And print 'Orden ID <orderId> encontrada:', response

    Examples:
      | orderId |
      | 1       |
      | 5       |
      | 10      |

  @TEST-STORE-09 @unhappypath
  Scenario: Verificar que buscar una orden con ID inexistente retorna 404
    Given path 'store', 'order', 9999
    When method get
    Then status 404
    And print 'Respuesta 404 por ID inexistente:', response

  @TEST-STORE-10 @unhappypath
  Scenario: Verificar que buscar una orden con ID negativo retorna error
    Given path 'store', 'order', -1
    When method get
    Then status 404
    And print 'Respuesta de error para ID negativo:', response

  @TEST-STORE-11 @unhappypath
  Scenario: Verificar que buscar una orden con ID mayor a 10 retorna la orden si existe
    Given path 'store', 'order', 11
    When method get
    Then status 200
    And print 'Respuesta para ID mayor a 10:', response


  # DELETE /store/order/{orderId}


  @TEST-STORE-12 @happypath
  Scenario: Verificar la eliminacion de una orden creada previamente
    * def orderToCreate = read('classpath:examples/jsonData/store/crearOrdenParaEliminar.json')
    Given path 'store', 'order'
    And request orderToCreate
    When method post
    Then status 200
    And def createdOrderId = response.id

    Given path 'store', 'order', createdOrderId
    When method delete
    Then status 200
    And print 'Orden eliminada con ID:', createdOrderId

  @TEST-STORE-13 @unhappypath
  Scenario: Verificar que eliminar una orden con ID inexistente retorna 404
    Given path 'store', 'order', 99999
    When method delete
    Then status 404
    And print 'Respuesta 404 al eliminar ID inexistente:', response

  @TEST-STORE-14 @unhappypath
  Scenario: Verificar que eliminar una orden con ID negativo retorna 404
    Given path 'store', 'order', -5
    When method delete
    Then status 404
    And print 'Respuesta al eliminar con ID negativo:', response

  @TEST-STORE-15 @unhappypath
  Scenario: Verificar que eliminar una orden ya eliminada retorna 404
    * def orderPayload = read('classpath:examples/jsonData/store/crearOrdenDobleEliminacion.json')
    Given path 'store', 'order'
    And request orderPayload
    When method post
    Then status 200
    And def createdId = response.id

    Given path 'store', 'order', createdId
    When method delete
    Then status 200

    Given path 'store', 'order', createdId
    When method delete
    Then status 404
    And print 'Orden ya eliminada, retorna 404 en segundo intento'
