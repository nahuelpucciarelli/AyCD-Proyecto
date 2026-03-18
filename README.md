Proyecto Integrador Autómatas y Control Discreto - Aleo Rodrigo, Pucciarelli Nahuel
## Instrucciones de Uso y Ejecución
Para correr la simulación del sistema de forma correcta, es fundamental seguir el orden de ejecución y asegurarse de contar con el hardware necesario.

### Prerrequisitos
* **Hardware:** Es necesario tener un **joystick conectado** a la PC antes de iniciar, ya que el modelo de Simulink lo requiere para enviar los comandos de control. El mismo debe tener dos sticks analógicos. Se recomienda cableado, ya que los inalámbricos pueden causar errores de desconexión.
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
* `Rueda del Ratón (Scroll)`: Realiza Zoom In / Zoom Out sobre la animación.
* `Clic Izquierdo + Arrastrar`: Permite desplazar la cámara (paneo) para observar una sección específica del área de trabajo.

**Interacción con la Interfaz de Datos (Gráficas):**
* **Gestión de Gráficas:** Haz clic sobre los nombres de las variables medidas en la interfaz para desplegar u ocultar su gráfica correspondiente.
* **Selección y Zoom:** Haz clic izquierdo sobre cualquier gráfica abierta para moverla por la pantalla. Utiliza la rueda del ratón (Scroll) sobre la gráfica para hacer ampliar la gráfica.
