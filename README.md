# RetoQA_Automation

Suite de pruebas automatizadas para la API pública [ServeRest](https://serverest.dev), enfocada en el recurso `/usuarios` (listar, crear, obtener por id, actualizar y eliminar). Implementada con [Karate DSL](https://github.com/karatelabs/karate) sobre Java + Maven, siguiendo un enfoque BDD (Gherkin).

## Tecnologías

- **Java 11**
- **Maven** (gestión de dependencias y ejecución)
- **Karate DSL 1.4.1** (`karate-junit5`)
- **JUnit 5** (runner de las features)

## Estructura del proyecto

```
src/test/java
├── karate-config.js                     # Configuración global (URL base, ambiente)
├── logback-test.xml                     # Configuración de logs
└── bdd
    ├── RunneTest.java                   # Runner JUnit 5 que ejecuta todas las features
    ├── usuarios
    │   ├── get-usuarios-list.feature     # GET /usuarios (listado)
    │   ├── post-usarios-create.feature   # POST /usuarios (creación)
    │   ├── get-usuarios-id.feature       # GET /usuarios/{id}
    │   ├── put-usuarios-update.feature   # PUT /usuarios/{id}
    │   ├── delete-usuarios.feature       # DELETE /usuarios/{id}
    │   └── utilitarios
    │       └── generacionData.feature    # Utilitario: genera y registra usuarios de prueba
    └── res                               # Datos y utilitarios de soporte (JSON, CSV, JS)
        ├── post-usuarios-create/
        │   ├── body.json
        │   ├── data.csv                  # Dataset de usuarios creados (usado por get/put/delete)
        │   └── utilitarios/              # Generación de usuarios y escritura de CSV
        ├── patch-usuarios-update/
        ├── delete-usuarios/
        └── get-usuarios-list/
```

## Prerrequisitos

- JDK 11 o superior
- Maven 3.6+
- Conexión a internet (las pruebas apuntan al ambiente público `https://serverest.dev`)

## Configuración

La URL base y el ambiente se definen en [`karate-config.js`](src/test/java/karate-config.js). Por defecto se usa el ambiente `dev`, que apunta a `https://serverest.dev`.

> ⚙️ **Todos los comandos de ejecución de este README corren con `env=dev`** (el ambiente por defecto cuando no se especifica `karate.env`). Actualmente `dev` y `qa` apuntan a la misma URL (`https://serverest.dev`), por lo que no es necesario indicar el ambiente explícitamente.

Si en el futuro se configura un ambiente `qa` con una URL distinta, se puede ejecutar contra él pasando la propiedad del sistema `karate.env`:

```bash
mvn test -Dkarate.env=qa
```

## ⚠️ Paso previo obligatorio: generación de datos

Las features **`get-usuarios-id.feature`**, **`put-usuarios-update.feature`** y **`delete-usuarios.feature`** dependen de datos de usuarios ya registrados en la API. Estos datos se leen desde el archivo [`data.csv`](src/test/java/bdd/res/post-usuarios-create/data.csv), el cual es generado y poblado por el utilitario **`generacionData.feature`**.

Por lo tanto, **antes de ejecutar dichos escenarios es obligatorio ejecutar primero**:

```
src/test/java/bdd/usuarios/utilitarios/generacionData.feature
```

Este utilitario:
1. Genera usuarios aleatorios de prueba.
2. Los registra contra la API (`POST /usuarios`).
3. Escribe los datos generados (incluyendo el `_id` devuelto por la API) en `data.csv`.

Sin este paso, las pruebas de `get-usuarios-id`, `put-usuarios-update` y `delete-usuarios` fallarán porque `data.csv` estará vacío, desactualizado o sus `_id` ya no existirán en el servicio.

> Nota: `put-usuarios-update.feature` y `delete-usuarios.feature` actualizan/eliminan filas de `data.csv` a medida que se ejecutan, por lo que se recomienda regenerar el dataset (`generacionData.feature`) antes de cada corrida completa de la suite.

## Cómo ejecutar las pruebas

### Ejecutar toda la suite (vía el runner JUnit)

El runner [`RunneTest.java`](src/test/java/bdd/RunneTest.java) ejecuta en paralelo (5 hilos) todas las features bajo `classpath:bdd`:

```bash
mvn test
```

### Ejecutar únicamente el utilitario de generación de datos

```bash
mvn test -Dkarate.options="classpath:bdd/usuarios/utilitarios/generacionData.feature" -Dtest=RunneTest
```

### Ejecutar una feature puntual

```bash
mvn test -Dkarate.options="classpath:bdd/usuarios/get-usuarios-list.feature" -Dtest=RunneTest
```

### Flujo recomendado para ejecutar toda la suite de casos de prueba

`put-usuarios-update.feature` y `delete-usuarios.feature` modifican/eliminan filas de `data.csv` a medida que se ejecutan, por lo que el orden importa: primero se necesitan ids válidos en el CSV, y al finalizar conviene regenerar el dataset para dejarlo listo para una siguiente corrida.

1. **`get-usuarios-list.feature`** — no depende de datos previos.
2. **`post-usuarios-create.feature`** — no depende de `data.csv` (genera sus propios usuarios de prueba de forma transitoria).
3. **`generacionData.feature`** — genera y registra usuarios contra la API y puebla `data.csv` con los `_id` necesarios para los siguientes pasos.
4. **`get-usuarios-id.feature`** — requiere los ids generados en el paso anterior.
5. **`put-usuarios-update.feature`** — requiere los ids generados en el paso 3; actualiza las filas correspondientes en `data.csv`.
6. **`delete-usuarios.feature`** — requiere los ids generados en el paso 3; elimina las filas correspondientes en `data.csv`.
7. **`generacionData.feature`** — se vuelve a ejecutar para regenerar `data.csv`, ya que los pasos 5 y 6 dejan el dataset modificado/vacío.

```bash
# 1. Listado de usuarios
mvn test -Dkarate.options="classpath:bdd/usuarios/get-usuarios-list.feature" -Dtest=RunneTest

# 2. Creación de usuarios
mvn test -Dkarate.options="classpath:bdd/usuarios/post-usarios-create.feature" -Dtest=RunneTest

# 3. Generar los ids necesarios en el CSV
mvn test -Dkarate.options="classpath:bdd/usuarios/utilitarios/generacionData.feature" -Dtest=RunneTest

# 4-6. Continuar el flujo con las features que dependen de data.csv
mvn test -Dkarate.options="classpath:bdd/usuarios/get-usuarios-id.feature" -Dtest=RunneTest
mvn test -Dkarate.options="classpath:bdd/usuarios/put-usuarios-update.feature" -Dtest=RunneTest
mvn test -Dkarate.options="classpath:bdd/usuarios/delete-usuarios.feature" -Dtest=RunneTest

# 7. Regenerar data.csv para dejar el dataset listo para la siguiente corrida
mvn test -Dkarate.options="classpath:bdd/usuarios/utilitarios/generacionData.feature" -Dtest=RunneTest
```

### Ejecutar por tags

Las features están etiquetadas (`@happypath`, `@unhappypath`, `@crear-usuarios`, `@listar-usarios`, `@put-usuarios-update`, `@delete-usuarios`, `@obtener-usuarios`, etc.). Se puede filtrar la ejecución por tag, por ejemplo:

```bash
mvn test -Dkarate.options="--tags @happypath" -Dtest=RunneTest
```

## Reportes

Al finalizar la ejecución, Karate genera reportes HTML en:

```
target/karate-reports/
```

Abre `karate-summary.html` en un navegador para ver el resumen de la ejecución.

## Casos cubiertos por feature

| Feature | Endpoint | Casos |
|---|---|---|
| `get-usuarios-list.feature` | `GET /usuarios` | Listado exitoso, validación de campos, consistencia de cantidad, error 405/411 |
| `post-usarios-create.feature` | `POST /usuarios` | Creación exitosa, datos inválidos/nulos, correo duplicado, endpoint/método incorrecto |
| `get-usuarios-id.feature` | `GET /usuarios/{id}` | Obtención exitosa, consistencia de datos, id inexistente/vacío, método incorrecto |
| `put-usuarios-update.feature` | `PUT /usuarios/{id}` | Actualización exitosa, consistencia post-actualización, creación si el id no existe, correo duplicado |
| `delete-usuarios.feature` | `DELETE /usuarios/{id}` | Eliminación exitosa, id inexistente, método incorrecto |
| `generacionData.feature` | `POST /usuarios` (utilitario) | Generación y registro de usuarios de prueba para alimentar `data.csv` |
