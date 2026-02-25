# Automatización API Karate (Petstore Swagger)

## ¿Qué hace esta automatización?

Proyecto de automatización de pruebas API sobre la API pública [Petstore](https://petstore.swagger.io/v2), construido con **Karate DSL** sobre **Java 17** y **Maven**.

Cubre dos módulos principales con un total de **28 escenarios** entre happy path y unhappy path:

| Módulo | Escenarios | Endpoints cubiertos |
|---|---|---|
| Store | 15 | `/store/inventory`, `/store/order`, `/store/order/{orderId}` |
| User | 13 | `/user`, `/user/createWithArray`, `/user/createWithList`, `/user/login`, `/user/logout`, `/user/{username}` |

### Estructura del proyecto

```
src/test/java/
├── karate-config.js              # Configuración global de entornos
└── examples/
    ├── ExamplesTest.java         # Runner principal
    ├── jsonData/
    │   ├── store/                # Payloads JSON del módulo Store
    │   └── user/                 # Payloads JSON del módulo User
    ├── store/
    │   ├── StoreRunner.java
    │   └── store.feature
    └── user/
        ├── UserRunner.java
        └── user.feature
```

Los datos de prueba (payloads JSON) están separados de los feature files en la carpeta `jsonData/` para evitar exponer información sensible dentro de los escenarios.

---

## Módulo Store

Automatiza el comportamiento de los endpoints de órdenes de la tienda.

| Método | Endpoint | Descripción |
|---|---|---|
| GET | /store/inventory | Obtiene el inventario de mascotas por estado |
| POST | /store/order | Crea una nueva orden de compra |
| GET | /store/order/{orderId} | Busca una orden por su ID |
| DELETE | /store/order/{orderId} | Elimina una orden por su ID |

### Escenarios de prueba

#### GET /store/inventory

**TEST-STORE-01** `@happypath`
Verifica que el endpoint de inventario responde con código 200 y retorna la información del estado actual de las mascotas en la tienda.

**TEST-STORE-02** `@happypath`
Verifica que la respuesta del inventario contiene al menos un estado registrado, confirmando que la API retorna datos y no una respuesta vacía.

#### POST /store/order

**TEST-STORE-03** `@happypath`
Verifica que se puede crear una orden válida con estado `placed`, confirmando que la API acepta el request y responde con código 200.

**TEST-STORE-04** `@happypath`
Verifica que se puede crear una orden con estado `approved` y el campo `complete` en `true`, confirmando que la API acepta distintas combinaciones de datos válidos.

**TEST-STORE-05** `@happypath`
Verifica mediante un Scenario Outline que la API acepta órdenes con los tres estados válidos posibles: `placed`, `approved` y `delivered`, ejecutando un escenario por cada uno.

**TEST-STORE-06** `@unhappypath`
Verifica el comportamiento de la API al enviar un body vacío en la creación de una orden. Se implementó para documentar que la API Petstore es permisiva y acepta el request retornando código 200 en lugar de rechazarlo.

#### GET /store/order/{orderId}

**TEST-STORE-07** `@happypath`
Verifica que se puede consultar una orden existente por su ID y que la API responde con código 200.

**TEST-STORE-08** `@happypath`
Verifica mediante un Scenario Outline que la búsqueda por ID funciona correctamente para múltiples IDs válidos (1, 5 y 10), ejecutando un escenario por cada uno.

**TEST-STORE-09** `@unhappypath`
Verifica que al buscar una orden con un ID que no existe en el sistema la API retorna código 404, confirmando el manejo correcto de recursos no encontrados.

**TEST-STORE-10** `@unhappypath`
Verifica que al buscar una orden con un ID negativo la API retorna código 404, documentando cómo responde ante valores fuera del rango permitido.

**TEST-STORE-11** `@unhappypath`
Verifica el comportamiento de la API al consultar un ID mayor a 10. Se implementó para documentar que si el ID existe en la base de datos la API retorna código 200 independientemente del rango.

#### DELETE /store/order/{orderId}

**TEST-STORE-12** `@happypath`
Verifica el flujo completo de eliminación: primero crea una orden y luego la elimina por su ID, confirmando que la API responde con código 200 en ambas operaciones.

**TEST-STORE-13** `@unhappypath`
Verifica que al intentar eliminar una orden con un ID que no existe en el sistema la API retorna código 404.

**TEST-STORE-14** `@unhappypath`
Verifica que al intentar eliminar una orden con un ID negativo la API retorna código 404, documentando el comportamiento ante valores inválidos.

**TEST-STORE-15** `@unhappypath`
Verifica que al intentar eliminar una orden que ya fue eliminada previamente la API retorna código 404 en el segundo intento, confirmando que no es posible eliminar el mismo recurso dos veces.

---

## Módulo User

Automatiza el comportamiento de los endpoints de gestión de usuarios.

| Método | Endpoint | Descripción |
|---|---|---|
| POST | /user | Crea un nuevo usuario |
| POST | /user/createWithArray | Crea múltiples usuarios enviando un array |
| POST | /user/createWithList | Crea múltiples usuarios enviando una lista |
| GET | /user/login | Inicia sesión con credenciales de usuario |
| GET | /user/logout | Cierra la sesión activa |
| GET | /user/{username} | Obtiene un usuario por su username |
| PUT | /user/{username} | Actualiza los datos de un usuario |
| DELETE | /user/{username} | Elimina un usuario por su username |

### Escenarios de prueba

#### POST /user

**TEST-USER-01** `@happypath`
Verifica que se puede crear un nuevo usuario enviando todos los datos requeridos y que la API responde con código 200, confirmando que el registro fue aceptado correctamente.

**TEST-USER-02** `@unhappypath`
Verifica el comportamiento de la API al enviar un body vacío en la creación de un usuario. Se implementó para documentar que la API Petstore es permisiva y acepta el request retornando código 200 en lugar de rechazarlo.

#### GET /user/login

**TEST-USER-03** `@happypath`
Verifica que el login funciona correctamente enviando credenciales válidas (username y password), confirmando que la API responde con código 200 y retorna el token de sesión.

**TEST-USER-04** `@unhappypath`
Verifica el comportamiento de la API al intentar hacer login con credenciales vacías. Se implementó para documentar que la API Petstore no valida este caso y retorna código 200 en lugar de rechazar la solicitud.

#### GET /user/logout

**TEST-USER-05** `@happypath`
Verifica que el endpoint de logout responde correctamente con código 200, confirmando que el cierre de sesión es procesado por la API.

#### GET /user/{username}

**TEST-USER-06** `@happypath`
Verifica la búsqueda de un usuario por username. Se implementó para documentar que el usuario `user1` no existe en la base de datos de la API al momento de la ejecución, retornando código 404.

**TEST-USER-07** `@unhappypath`
Verifica que al buscar un usuario con un username que claramente no existe en el sistema la API retorna código 404, confirmando el manejo correcto de recursos no encontrados.

#### PUT /user/{username}

**TEST-USER-08** `@happypath`
Verifica que se pueden actualizar los datos de un usuario enviando la información modificada y que la API responde con código 200, confirmando que la actualización fue aceptada.

**TEST-USER-09** `@unhappypath`
Verifica el comportamiento de la API al intentar actualizar un usuario que no existe. Se implementó para documentar que la API Petstore es permisiva en este endpoint y retorna código 200 en lugar de un error 404.

#### DELETE /user/{username}

**TEST-USER-10** `@happypath`
Verifica el flujo completo de eliminación: primero crea un usuario y luego lo elimina por su username, confirmando que la API responde con código 200 en ambas operaciones.

**TEST-USER-11** `@unhappypath`
Verifica que al intentar eliminar un usuario que no existe en el sistema la API retorna código 404, confirmando el manejo correcto al intentar eliminar un recurso inexistente.

#### POST /user/createWithArray

**TEST-USER-12** `@happypath`
Verifica que se pueden crear múltiples usuarios en una sola petición enviando un array con los datos de cada uno, confirmando que la API responde con código 200 y procesa correctamente la creación en bloque.

#### POST /user/createWithList

**TEST-USER-13** `@happypath`
Verifica que se pueden crear múltiples usuarios en una sola petición enviando una lista con los datos de cada uno, confirmando que la API responde con código 200 y procesa correctamente este formato alternativo de creación en bloque.

---

## ¿Cómo se ejecuta?

### Requisitos previos

- Java 17
- Maven

### Ejecutar todas las pruebas

```bash
mvn test
```

### Ejecutar solo el módulo Store

```bash
mvn test -Dkarate.options="--tags @TEST-STORE"
```

### Ejecutar solo el módulo User

```bash
mvn test -Dkarate.options="--tags @TEST-USER"
```

### Ejecutar solo los happy path

```bash
mvn test -Dkarate.options="--tags @happypath"
```

### Ejecutar solo los unhappy path

```bash
mvn test -Dkarate.options="--tags @unhappypath"
```

> El entorno configurado por defecto es `cert`, apuntando a `https://petstore.swagger.io/v2`.
