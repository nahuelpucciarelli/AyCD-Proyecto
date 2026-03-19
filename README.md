# Proyecto Integrador Autómatas y Control Discreto - Aleo Rodrigo, Pucciarelli Nahuel
## Instrucciones de Uso y Ejecución
Para correr la simulación del sistema de forma correcta, es fundamental seguir el orden de ejecución y asegurarse de contar con el hardware necesario.

### Prerrequisitos
* **Hardware:** Es necesario tener un **joystick conectado** a la PC antes de iniciar. Este joystick debe poder ser reconocible como un mando de xbox. En caso de no contar con uno, se puede usar un mando genérico y usar alguna de las tantas aplicaciones que hay para remapear las entradas a un mando de xbox. El modelo de Simulink lo requiere para enviar los comandos de control. El mismo debe tener dos sticks analógicos. Se recomienda cableado, ya que los inalámbricos pueden causar errores de desconexión.
* **Software:** MATLAB/Simulink 2025b o superior.

### Paso a Paso para la Ejecución
1. **Cargar Parámetros:** Abre MATLAB y ejecuta primero el script de parámetros (`Matlab/parametros.m`). Esto cargará en el Workspace todas las variables, ganancias y configuraciones físicas necesarias para el modelo.
2. **Ejecutar la Animación:** Antes de iniciar el control, ejecuta el archivo `Build Unity/AnimacionGruaAyCD.exe`. Esta ventana es una visualización del modelo, y puede quedar abierta en segundo plano o en un monitor secundario para recibir los datos por red.
3. **Iniciar el Modelo:** Abre el modelo de Simulink (`Matlab/Simulink/modelo_planta.slx` o `Matlab/Simulink/modelo_planta_CODESYS.slx`). Verifica que el joystick esté encendido y reconocido por el sistema, y presiona el botón **Run** (Ejecutar) en Simulink.

---

### Controles e Interacción en Tiempo Real
El entorno de simulación y la interfaz gráfica están diseñados para ser totalmente interactivos mientras el modelo está corriendo:

**Controles de Entorno (Animación 3D):**
* `Barra Espaciadora`: Activa/desactiva la visualización de la línea de trayectoria en tiempo real.
* `Tecla C`: Borra el rastro actual en la pantalla.
* `Tecla R`: Reinicia el reloj interno (útil para medir tiempos de operación).
* `Rueda del Ratón (Scroll)`: Realiza Zoom In / Zoom Out sobre la animación.
* `Rueda del Ratón (Mantener Presionado) + Arrastrar`: Permite desplazar la cámara (paneo) para observar una sección específica del área de trabajo.

**Interacción con la Interfaz de Datos (Gráficas):**
* **Gestión de Gráficas:** Haz clic izquierdo sobre los nombres de las variables medidas en la interfaz para desplegar u ocultar su gráfica correspondiente.
* **Selección y Zoom:** Haz clic izquierdo (mantener presionado) sobre cualquier gráfica abierta para moverla por la pantalla. Utiliza la rueda del ratón (scroll) sobre la gráfica para hacer Zoom In / Zoom Out.

**Controles de la Grúa:**
* `Joystick Izquierdo (movimientos horizontales)`: Desplaza el carro hacia la izquierda/derecha.
* `Joystick Derecho (movimientos verticales)`: Desplaza la carga hacia arriba/abajo.
* `Botón Y (1)`: Pasa al modo Stand By y permite la recuperación de la grúa en caso de falla.
* `Botón B (2)`: Pasa al modo Manual, el cual también puede ser accedido usando cualquiera de los joysticks.
* `Botón A (3)`: Activación de los twistlocks, para tomar o soltar un contenedor (solo accesible cuando está apoyado correctamente sobre una carga).
* `Botón X (4)`: Pasa al modo Automático. Solo accesible cuando el spreader se encuentra fuera de la zona de la envolvente, y el sistema se encuentra en modo Stand By. A continuación usa el Joystick Izquierdo para elegir el punto inicial. Para seleccionar la posición presiona el Botón A (3). Repetir para el punto final.
* `Botón Start (9)`: Pasa al modo de Emergencia Manual (equivalente a parada de emergencia).
