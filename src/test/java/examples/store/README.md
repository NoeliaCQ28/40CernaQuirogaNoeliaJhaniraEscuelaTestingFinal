# Automatización Store - Petstore API

## ¿Qué hace esta automatización?

Automatiza las pruebas del módulo **Store** de la API pública [Petstore](https://petstore.swagger.io/v2), verificando el comportamiento de los siguientes endpoints:

| Método | Endpoint | Descripción |
|---|---|---|
| GET | /store/inventory | Obtiene el inventario de mascotas por estado |
| POST | /store/order | Crea una nueva orden de compra |
| GET | /store/order/{orderId} | Busca una orden por su ID |
| DELETE | /store/order/{orderId} | Elimina una orden por su ID |

Los datos de prueba (payloads JSON) se encuentran separados en la carpeta `jsonData/store/` para mantenerlos fuera del feature file.

---

## Escenarios de prueba

### GET /store/inventory

**TEST-STORE-01** `@happypath`
Verifica que el endpoint de inventario responde con código 200 y retorna la información del estado actual de las mascotas en la tienda.

**TEST-STORE-02** `@happypath`
Verifica que la respuesta del inventario contiene al menos un estado registrado, confirmando que la API retorna datos y no una respuesta vacía.

---

### POST /store/order

**TEST-STORE-03** `@happypath`
Verifica que se puede crear una orden válida con estado `placed`, confirmando que la API acepta el request y responde con código 200.

**TEST-STORE-04** `@happypath`
Verifica que se puede crear una orden con estado `approved` y el campo `complete` en `true`, confirmando que la API acepta distintas combinaciones de datos válidos.

**TEST-STORE-05** `@happypath`
Verifica mediante un Scenario Outline que la API acepta órdenes con los tres estados válidos posibles: `placed`, `approved` y `delivered`, ejecutando un escenario por cada uno.

**TEST-STORE-06** `@unhappypath`
Verifica el comportamiento de la API al enviar un body vacío en la creación de una orden. Se implementó para documentar que la API Petstore es permisiva y acepta el request retornando código 200 en lugar de rechazarlo.

---

### GET /store/order/{orderId}

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

---

### DELETE /store/order/{orderId}

**TEST-STORE-12** `@happypath`
Verifica el flujo completo de eliminación: primero crea una orden y luego la elimina por su ID, confirmando que la API responde con código 200 en ambas operaciones.

**TEST-STORE-13** `@unhappypath`
Verifica que al intentar eliminar una orden con un ID que no existe en el sistema la API retorna código 404.

**TEST-STORE-14** `@unhappypath`
Verifica que al intentar eliminar una orden con un ID negativo la API retorna código 404, documentando el comportamiento ante valores inválidos.

**TEST-STORE-15** `@unhappypath`
Verifica que al intentar eliminar una orden que ya fue eliminada previamente la API retorna código 404 en el segundo intento, confirmando que no es posible eliminar el mismo recurso dos veces.

---

## ¿Cómo se ejecuta?

### Requisitos previos

- Java 17
- Maven

### Comando para ejecutar todas las pruebas del proyecto

```bash
mvn test
```

### Comando para ejecutar solo los escenarios de Store

```bash
mvn test -Dkarate.options="--tags @TEST-STORE"
```

### Comando para ejecutar solo los happy path de Store

```bash
mvn test -Dkarate.options="--tags @happypath"
```

### Comando para ejecutar solo los unhappy path de Store

```bash
mvn test -Dkarate.options="--tags @unhappypath"
```

> El entorno configurado por defecto es `cert`, apuntando a `https://petstore.swagger.io/v2`.
