# Automatización User - Petstore API

## ¿Qué hace esta automatización?

Automatiza las pruebas del módulo **User** de la API pública [Petstore](https://petstore.swagger.io/v2), verificando el comportamiento de los siguientes endpoints:

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

Los datos de prueba (payloads JSON) se encuentran separados en la carpeta `jsonData/user/` para mantenerlos fuera del feature file.

---

## Escenarios de prueba

### POST /user

**TEST-USER-01** `@happypath`
Verifica que se puede crear un nuevo usuario enviando todos los datos requeridos y que la API responde con código 200, confirmando que el registro fue aceptado correctamente.

**TEST-USER-02** `@unhappypath`
Verifica el comportamiento de la API al enviar un body vacío en la creación de un usuario. Se implementó para documentar que la API Petstore es permisiva y acepta el request retornando código 200 en lugar de rechazarlo.

---

### GET /user/login

**TEST-USER-03** `@happypath`
Verifica que el login funciona correctamente enviando credenciales válidas (username y password), confirmando que la API responde con código 200 y retorna el token de sesión.

**TEST-USER-04** `@unhappypath`
Verifica el comportamiento de la API al intentar hacer login con credenciales vacías. Se implementó para documentar que la API Petstore no valida este caso y retorna código 200 en lugar de rechazar la solicitud.

---

### GET /user/logout

**TEST-USER-05** `@happypath`
Verifica que el endpoint de logout responde correctamente con código 200, confirmando que el cierre de sesión es procesado por la API.

---

### GET /user/{username}

**TEST-USER-06** `@happypath`
Verifica la búsqueda de un usuario por username. Se implementó para documentar que el usuario `user1` no existe en la base de datos de la API al momento de la ejecución, retornando código 404.

**TEST-USER-07** `@unhappypath`
Verifica que al buscar un usuario con un username que claramente no existe en el sistema la API retorna código 404, confirmando el manejo correcto de recursos no encontrados.

---

### PUT /user/{username}

**TEST-USER-08** `@happypath`
Verifica que se pueden actualizar los datos de un usuario enviando la información modificada y que la API responde con código 200, confirmando que la actualización fue aceptada.

**TEST-USER-09** `@unhappypath`
Verifica el comportamiento de la API al intentar actualizar un usuario que no existe. Se implementó para documentar que la API Petstore es permisiva en este endpoint y retorna código 200 en lugar de un error 404.

---

### DELETE /user/{username}

**TEST-USER-10** `@happypath`
Verifica el flujo completo de eliminación: primero crea un usuario y luego lo elimina por su username, confirmando que la API responde con código 200 en ambas operaciones.

**TEST-USER-11** `@unhappypath`
Verifica que al intentar eliminar un usuario que no existe en el sistema la API retorna código 404, confirmando el manejo correcto al intentar eliminar un recurso inexistente.

---

### POST /user/createWithArray

**TEST-USER-12** `@happypath`
Verifica que se pueden crear múltiples usuarios en una sola petición enviando un array con los datos de cada uno, confirmando que la API responde con código 200 y procesa correctamente la creación en bloque.

---

### POST /user/createWithList

**TEST-USER-13** `@happypath`
Verifica que se pueden crear múltiples usuarios en una sola petición enviando una lista con los datos de cada uno, confirmando que la API responde con código 200 y procesa correctamente este formato alternativo de creación en bloque.

---

## ¿Cómo se ejecuta?

### Requisitos previos

- Java 17
- Maven

### Comando para ejecutar todas las pruebas del proyecto

```bash
mvn test
```

### Comando para ejecutar solo los escenarios de User

```bash
mvn test -Dkarate.options="--tags @TEST-USER"
```

### Comando para ejecutar solo los happy path de User

```bash
mvn test -Dkarate.options="--tags @happypath"
```

### Comando para ejecutar solo los unhappy path de User

```bash
mvn test -Dkarate.options="--tags @unhappypath"
```

> El entorno configurado por defecto es `cert`, apuntando a `https://petstore.swagger.io/v2`.
