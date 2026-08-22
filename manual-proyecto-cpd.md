# 📊 Manual Guía del Proyecto Integrador: Diseño y Virtualización de un CPD Distribuido
### Asignatura: Procesamiento de Datos | Docente: Ing. David Britez | UCOM

Este documento constituye la guía oficial de laboratorio paso a paso para el desarrollo del proyecto integrador del curso. Está diseñado de manera secuencial, progresiva y enfocado en estudiantes que se inician en la programación y administración de servidores. 

---

## 🏛️ Descripción del Escenario de Negocio
Simularemos la infraestructura de un Centro de Procesamiento de Datos (CPD) para una empresa comercializadora distribuida geográficamente:
*   **Casa Matriz (Asunción):** Servidor central de consolidación transaccional.
*   **Sucursal A (Ciudad del Este):** Nodo local con base de datos propia.
*   **Sucursal B (Encarnación):** Nodo local con base de datos propia.
*   **Sucursal C (Coronel Oviedo):** Nodo local con base de datos propia.

---

## 📅 CLASE 1: CONTROL DE VERSIONES Y PREPARACIÓN DEL HOST

En esta clase preparamos nuestro entorno local de trabajo (WSL 2 y VS Code) y enlazamos nuestra máquina con GitHub mediante la creación y clonación de nuestro repositorio remoto usando el canal seguro HTTPS.

### **Paso 1.1: Configuración de Identidad en Git**
Antes de guardar confirmaciones de cambio (commits), debemos identificarnos en la terminal de Ubuntu Linux para que GitHub reconozca quién escribe el código.

Abre la terminal de Ubuntu y ejecuta:
```bash
# Configurar tu nombre real (entre comillas)
git config --global user.name "Tu Nombre y Apellido"

# Configurar tu correo electrónico de la UCOM
git config --global user.email "tu_correo@ucom.edu.py"

# Verificar que los cambios se hayan guardado correctamente
git config --list
```

---

### **Paso 1.2: Creación del Repositorio en GitHub Web**
1. Inicia sesión en tu cuenta de [GitHub](https://github.com/).
2. Haz clic en el botón **"New"** (Nuevo) o en el signo **"+"** de la esquina superior derecha $\rightarrow$ **New repository**.
3. Rellena los siguientes campos obligatorios:
   *   **Repository name:** `proyecto-cpd`
   *   **Description:** "Simulación del CPD Corporativo de Facturación Distribuida - UCOM"
   *   **Public/Private:** Selecciona **Public** (Público).
   *   **Initialize this repository with:** Marca la casilla **Add a README file** (esto crea el archivo inicial para poder clonarlo inmediatamente).
4. Haz clic en **Create repository**.

---

### **Paso 1.3: Clonar el Repositorio Localmente en WSL 2**
Descargaremos una copia exacta y conectada de nuestro proyecto web dentro de nuestro sistema operativo Linux (Ubuntu).

1. En la página web de tu repositorio recién creado, haz clic en el botón verde **"<> Code"**.
2. Asegúrate de seleccionar la pestaña **HTTPS** y copia la URL (ejemplo: `https://github.com/tu_usuario/proyecto-cpd.git`).
3. Abre tu terminal de **Ubuntu** en WSL 2 y ejecuta:
   ```bash
   # Ir a tu carpeta personal de inicio en Linux
   cd ~

   # Clonar el proyecto (pega la dirección copiada con clic derecho)
   git clone https://github.com/tu_usuario/proyecto-cpd.git
   ```

---

### **Paso 1.4: Abrir el Espacio de Trabajo en VS Code**
1. Entra a la carpeta que Git creó automáticamente al clonar el repositorio:
   ```bash
   cd proyecto-cpd
   ```
2. Levanta Visual Studio Code directamente dentro de esta carpeta de Linux ejecutando:
   ```bash
   code .
   ```
3. *Nota:* Si VS Code te solicita instalar la extensión "WSL", acepta la sugerencia. Verás que en la esquina inferior izquierda de tu editor se muestra un indicador verde que dice **"WSL: Ubuntu"**.

---

## 🌐 CLASE 2: ORQUESTACIÓN MULTI-CONTENEDOR Y RED LÓGICA

En esta clase diseñamos la arquitectura lógica de nuestro CPD. Levantaremos los cuatro servidores PostgreSQL independientes en la misma computadora utilizando Docker Compose, aislándolos de manera lógica en una red interna privada para evitar riesgos de intrusión y colisiones de puertos en Windows.

### **Paso 2.1: Crear el Archivo de Infraestructura `compose.yaml`**
1. En VS Code, crea un archivo en la raíz del proyecto llamado exactamente **`compose.yaml`**.
2. Copia y pega el código completo de infraestructura declarativa:

```yaml
version: '3.8'

services:
  # ==========================================
  # NODO MATRIZ (ASUNCIÓN)
  # ==========================================
  postgres-matriz:
    image: postgres:15-alpine
    container_name: cpd-matriz-db
    networks:
      - red_empresarial
    ports:
      - "5432:5432" # Puerto estándar expuesto a Windows
    environment:
      POSTGRES_DB: matriz_db
      POSTGRES_USER: ucom_admin
      POSTGRES_PASSWORD: password_matriz

  # ==========================================
  # NODO SUCURSAL A (CIUDAD DEL ESTE)
  # ==========================================
  postgres-sucursal-a:
    image: postgres:15-alpine
    container_name: cpd-sucursala-db
    networks:
      - red_empresarial
    ports:
      - "5433:5432" # Mapeamos puerto 5433 en Windows al 5432 interno
    environment:
      POSTGRES_DB: sucursal_a_db
      POSTGRES_USER: ucom_admin
      POSTGRES_PASSWORD: password_sucursal_a

  # ==========================================
  # NODO SUCURSAL B (ENCARNACIÓN)
  # ==========================================
  postgres-sucursal-b:
    image: postgres:15-alpine
    container_name: cpd-sucursalb-db
    networks:
      - red_empresarial
    ports:
      - "5434:5432" # Mapeamos puerto 5434 en Windows al 5432 interno
    environment:
      POSTGRES_DB: sucursal_b_db
      POSTGRES_USER: ucom_admin
      POSTGRES_PASSWORD: password_sucursal_b

  # ==========================================
  # NODO SUCURSAL C (CORONEL OVIEDO)
  # ==========================================
  postgres-sucursal-c:
    image: postgres:15-alpine
    container_name: cpd-sucursalc-db
    networks:
      - red_empresarial
    ports:
      - "5435:5432" # Mapeamos puerto 5435 en Windows al 5432 interno
    environment:
      POSTGRES_DB: sucursal_c_db
      POSTGRES_USER: ucom_admin
      POSTGRES_PASSWORD: password_sucursal_c

# Definición del conmutador virtual de red para aislar comunicaciones
networks:
  red_empresarial:
    driver: bridge
```

---

### **Paso 2.2: Desplegar la Infraestructura**
Abre la terminal integrada de VS Code (**Ctrl + `**) y arranca los cuatro servidores en segundo plano:
```bash
docker compose up -d
```

Verifica que los contenedores estén activos y mapeando correctamente los puertos:
```bash
docker ps
```

---

### **Paso 2.3: Validación del DNS Interno del CPD**
Comprobaremos que la sucursal de Ciudad del Este (`cpd-sucursala-db`) puede conectarse por red remota simulada con la casa matriz de Asunción (`postgres-matriz`) usando únicamente su nombre de host DNS:

1. Entra a la consola interactiva de la Sucursal A:
   ```bash
   docker exec -it cpd-sucursala-db sh
   ```
2. Desde adentro, realiza una petición de conexión de base de datos remota hacia la Matriz:
   ```bash
   psql -h postgres-matriz -U ucom_admin -d matriz_db
   ```
3. Introduce la contraseña: `password_matriz`.
4. Una vez que visualices el prompt `matriz_db=>`, habrás validado la conectividad interna. Sal de la consola:
   ```sql
   \q
   exit
   ```

---

### **Paso 2.4: Registrar Avance en GitHub**
Registramos la estructura del Compose en nuestro repositorio remoto:
```bash
git status
git add compose.yaml
git commit -m "feat: implementar compose.yaml con 4 nodos Postgres y red_empresarial"
git push origin main
```

---

## 📁 CLASE 3: PERSISTENCIA BASE Y EXCLUSIONES DE CONTROL DE VERSIONES

En esta clase solucionamos teóricamente la "amnesia" de los contenedores creando directorios físicos persistentes en WSL 2, e implementando de forma profesional un archivo `.gitignore` para no subir archivos basura o base de datos pesadas al repositorio de GitHub.

### **Paso 3.1: Crear Directorios Físicos de Almacenamiento en Ubuntu**
Ejecuta el siguiente comando para generar las carpetas reales donde PostgreSQL volcará sus datos en el disco duro:
```bash
mkdir -p almacenamiento/matriz_data almacenamiento/sucursal_a_data almacenamiento/sucursal_b_data almacenamiento/sucursal_c_data
```

Audita los permisos de las carpetas para garantizar que Docker tenga control total de escritura:
```bash
ls -la almacenamiento/
```

---

### **Paso 3.2: Configuración del Filtro `.gitignore`**
Los datos de la base de datos se escriben en formato binario propietario altamente pesado y contienen información sensible. **Nunca deben subirse a Git.**

1. En la raíz de tu proyecto en VS Code, crea un nuevo archivo llamado exactamente **`.gitignore`** (con un punto inicial).
2. Agrega la carpeta de almacenamiento y los temporales de sistema:

```text
# Excluir base de datos física del CPD virtual
almacenamiento/

# Excluir archivos temporales del sistema operativo
.DS_Store
Thumbs.db
```

---

### **Paso 3.3: Registrar Cambios en GitHub**
Validamos en la consola que Git no rastree la carpeta `almacenamiento/`:
```bash
git status
# Verás que solo lista el archivo .gitignore como nuevo

git add .gitignore
git commit -m "chore: configurar .gitignore para excluir base de datos fisica"
git push origin main
```

---

## 💾 CLASE 4: ENLACE FISICO-LÓGICO (VINCULACIÓN DE VOLÚMENES)

En esta clase acoplamos de forma definitiva la capa de almacenamiento físico (creada en la Clase 3) con la capa lógica de procesamiento (creada en la Clase 2) utilizando volúmenes de montaje directo (*bind mounts*), y realizamos la primera prueba de validación ante fallos del CPD.

### **Paso 4.1: Modificar `compose.yaml` con Enlaces de Volúmenes**
1. Abre tu archivo **`compose.yaml`** en VS Code.
2. Actualiza la estructura para incorporar la directiva `volumes` en cada servicio, asociando de forma relativa la carpeta física de WSL con el directorio de almacenamiento interno estándar de Postgres (`/var/lib/postgresql/data`):

```yaml
version: '3.8'

services:
  # ==========================================
  # NODO MATRIZ (ASUNCIÓN)
  # ==========================================
  postgres-matriz:
    image: postgres:15-alpine
    container_name: cpd-matriz-db
    networks:
      - red_empresarial
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: matriz_db
      POSTGRES_USER: ucom_admin
      POSTGRES_PASSWORD: password_matriz
    volumes:
      - ./almacenamiento/matriz_data:/var/lib/postgresql/data

  # ==========================================
  # NODO SUCURSAL A (CIUDAD DEL ESTE)
  # ==========================================
  postgres-sucursal-a:
    image: postgres:15-alpine
    container_name: cpd-sucursala-db
    networks:
      - red_empresarial
    ports:
      - "5433:5432"
    environment:
      POSTGRES_DB: sucursal_a_db
      POSTGRES_USER: ucom_admin
      POSTGRES_PASSWORD: password_sucursal_a
    volumes:
      - ./almacenamiento/sucursal_a_data:/var/lib/postgresql/data

  # ==========================================
  # NODO SUCURSAL B (ENCARNACIÓN)
  # ==========================================
  postgres-sucursal-b:
    image: postgres:15-alpine
    container_name: cpd-sucursalb-db
    networks:
      - red_empresarial
    ports:
      - "5434:5432"
    environment:
      POSTGRES_DB: sucursal_b_db
      POSTGRES_USER: ucom_admin
      POSTGRES_PASSWORD: password_sucursal_b
    volumes:
      - ./almacenamiento/sucursal_b_data:/var/lib/postgresql/data

  # ==========================================
  # NODO SUCURSAL C (CORONEL OVIEDO)
  # ==========================================
  postgres-sucursal-c:
    image: postgres:15-alpine
    container_name: cpd-sucursalc-db
    networks:
      - red_empresarial
    ports:
      - "5435:5432"
    environment:
      POSTGRES_DB: sucursal_c_db
      POSTGRES_USER: ucom_admin
      POSTGRES_PASSWORD: password_sucursal_c
    volumes:
      - ./almacenamiento/sucursal_c_data:/var/lib/postgresql/data

networks:
  red_empresarial:
    driver: bridge
```

*Guarda los cambios con **Ctrl + S**.*

---

### **Paso 4.2: Re-desplegar Clúster con Persistencia**
Para aplicar el montaje de volúmenes, detenemos los contenedores anteriores y los volvemos a levantar con la nueva configuración:
```bash
# Apagar y eliminar los contenedores sin persistencia
docker compose down

# Volver a encender los contenedores mapeando las carpetas físicas de WSL 2
docker compose up -d
```

---

### **Paso 4.3: Prueba de Resiliencia y Validación de Persistencia**
Demostraremos de manera práctica cómo los datos sobreviven a la destrucción absoluta de un contenedor:

1. Conéctate directamente a la base de datos de la **Sucursal A**:
   ```bash
   docker exec -it cpd-sucursala-db psql -U ucom_admin -d sucursal_a_db
   ```
2. Crea una tabla de pruebas transaccionales de facturación:
   ```sql
   CREATE TABLE prueba_persistencia (
       id SERIAL PRIMARY KEY,
       sucursal VARCHAR(50) NOT NULL,
       monto NUMERIC(10,2) NOT NULL
   );
   ```
3. Inserta un registro de venta simulado:
   ```sql
   INSERT INTO prueba_persistencia (sucursal, monto) VALUES ('Ciudad del Este', 150000.00);
   ```
4. Realiza una consulta para verificar que se guardó en memoria:
   ```sql
   SELECT * FROM prueba_persistencia;
   ```
5. Sal del motor Postgres:
   ```sql
   \q
   ```
6. **¡Haremos caer el servidor por completo!** Destruimos la infraestructura simulando un apagón crítico o mantenimiento mayor en el CPD:
   ```bash
   docker compose down
   ```
7. Volvemos a levantar el clúster desde cero:
   ```bash
   docker compose up -d
   ```
8. Nos conectamos nuevamente a la base de datos de la **Sucursal A**:
   ```bash
   docker exec -it cpd-sucursala-db psql -U ucom_admin -d sucursal_a_db
   ```
9. Volvemos a consultar la tabla de transacciones:
   ```sql
   SELECT * FROM prueba_persistencia;
   ```
   *   **Resultado Exitoso:** Los datos de tu factura de 150.000 Gs siguen allí intactos, demostrando que la persistencia física en el almacenamiento local de WSL 2 funciona de manera impecable y profesional.
10. Sal de la consola:
    ```sql
    \q
    ```

---

### **Paso 4.4: Sincronizar Cambios de Infraestructura con GitHub**
Subimos la actualización final del `compose.yaml` a nuestro repositorio remoto:
```bash
git status
git add compose.yaml
git commit -m "feat: enlazar servicios Postgres a carpetas persistentes de WSL"
git push origin main
```

---
¡Felicidades, Ing. David! Tus alumnos han completado con total éxito el despliegue del almacenamiento persistente distribuido de la Clase 4. Sus repositorios de GitHub contienen ahora la infraestructura declarativa de CPD documentada de forma impecable y lista para la evaluación continua.
