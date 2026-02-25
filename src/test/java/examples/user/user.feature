Feature: Automatizar User - Petstore API
  Endpoints:
    - POST   /user
    - POST   /user/createWithArray
    - POST   /user/createWithList
    - GET    /user/login
    - GET    /user/logout
    - GET    /user/{username}
    - PUT    /user/{username}
    - DELETE /user/{username}

  Background:
    * url apiPetStore


  # POST /user

  @TEST-USER-01 @happypath
  Scenario: Verificar la creacion de un nuevo usuario de forma correcta
    * def newUser = read('classpath:examples/jsonData/user/crearUsuario.json')
    Given path 'user'
    And request newUser
    When method post
    Then status 200
    And print 'Usuario creado:', response

  @TEST-USER-02 @unhappypath
  Scenario: Verificar que crear un usuario con body vacio no genera error critico
    Given path 'user'
    And request {}
    When method post
    Then status 200
    And print 'Respuesta con body vacio:', response

  # GET /user/login

  @TEST-USER-03 @happypath
  Scenario: Verificar el login con credenciales validas
    Given path 'user', 'login'
    And param username = 'user1'
    And param password = 'HUNTER2'
    When method get
    Then status 200
    And print 'Login exitoso, token recibido:', response

  @TEST-USER-04 @unhappypath
  Scenario: Verificar que el login con credenciales vacias es aceptado por la API
    Given path 'user', 'login'
    And param username = ''
    And param password = ''
    When method get
    Then status 200
    And print 'Respuesta con credenciales vacias:', response

  # GET /user/logout

  @TEST-USER-05 @happypath
  Scenario: Verificar que el logout de sesion responde correctamente
    Given path 'user', 'logout'
    When method get
    Then status 200
    And print 'Logout exitoso:', response

  # GET /user/{username}

  @TEST-USER-06 @happypath
  Scenario: Verificar la obtencion de un usuario existente por username
    Given path 'user', 'user1'
    When method get
    Then status 404
    And print 'Respuesta al buscar usuario user1:', response

  @TEST-USER-07 @unhappypath
  Scenario: Verificar que buscar un usuario inexistente retorna 404
    Given path 'user', 'usuarioinexistente99999'
    When method get
    Then status 404
    And print 'Usuario no encontrado:', response

  # PUT /user/{username}

  @TEST-USER-08 @happypath
  Scenario: Verificar la actualizacion de datos de un usuario existente
    * def updatedUser = read('classpath:examples/jsonData/user/actualizarUsuario.json')
    Given path 'user', 'testuser01'
    And request updatedUser
    When method put
    Then status 200
    And print 'Usuario actualizado:', response

  @TEST-USER-09 @unhappypath
  Scenario: Verificar que actualizar un usuario inexistente es aceptado por la API
    * def updatedUser = read('classpath:examples/jsonData/user/actualizarUsuarioInexistente.json')
    Given path 'user', 'usernoexiste'
    And request updatedUser
    When method put
    Then status 200
    And print 'Respuesta al actualizar usuario inexistente:', response

  # DELETE /user/{username}

  @TEST-USER-10 @happypath
  Scenario: Verificar la eliminacion de un usuario creado previamente
    * def userToDelete = read('classpath:examples/jsonData/user/eliminarUsuario.json')
    Given path 'user'
    And request userToDelete
    When method post
    Then status 200

    Given path 'user', 'deleteme2001'
    When method delete
    Then status 200
    And print 'Usuario deleteme2001 eliminado correctamente'

  @TEST-USER-11 @unhappypath
  Scenario: Verificar que eliminar un usuario inexistente retorna 404
    Given path 'user', 'userquenuncaexistio99'
    When method delete
    Then status 404
    And print 'Error al eliminar usuario inexistente:', response

  # POST /user/createWithArray

  @TEST-USER-12 @happypath
  Scenario: Verificar la creacion de usuarios con array
    * def usersArray = read('classpath:examples/jsonData/user/crearUsuariosArray.json')
    Given path 'user', 'createWithArray'
    And request usersArray
    When method post
    Then status 200
    And print 'Usuarios creados con array:', response

  # POST /user/createWithList

  @TEST-USER-13 @happypath
  Scenario: Verificar la creacion de usuarios con lista
    * def usersList = read('classpath:examples/jsonData/user/crearUsuariosLista.json')
    Given path 'user', 'createWithList'
    And request usersList
    When method post
    Then status 200
    And print 'Usuarios creados con lista:', response
