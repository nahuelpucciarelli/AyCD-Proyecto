%% ============================================================
% PROYECTO GLOBAL INTEGRADOR – AUTÓMATAS Y CONTROL DISCRETO (317)
% Modelo físico – Definición de constantes y variables
% Grúa Portacontenedores STS (Carro – Izaje – Carga)
%% ============================================================

clear; clc;

%% ======================
% PARÁMETROS GENERALES
%% ======================

g = 9.80665;               % [m/s^2] Aceleración gravitatoria estándar

%% ======================
% GEOMETRÍA DEL SISTEMA
%% ======================

Yt0 = 45.0;                % [m] Altura fija de poleas de izaje en el carro
Hc  = 2.59;                % [m] Altura del container estándar ISO
Wc  = 2.44;                % [m] Ancho del container estándar ISO

%% ======================
% MASAS
%% ======================

Ms     = 15000;            % [kg] Masa spreader + headblock (sin container)
Mc_max = 50000;            % [kg] Masa máxima container cargado
Mc_min = 2000;             % [kg] Masa mínima container vacío

% McX:   [kg] Masa del container actual (variable, aleatoria por escenario)
% ml:    [kg] Masa total suspendida (depende de TLK): ml = Ms + (TLK?McX:0)

%% ======================
% LÍMITES OPERATIVOS – CARRO (eje x)
%% ======================

xt_min = -30.0;            % [m] Límite mínimo posición carro
xt_max =  50.0;            % [m] Límite máximo posición carro
vt_max =  4.0;             % [m/s] Velocidad máxima carro
at_max =  0.80;            % [m/s^2] Aceleración máxima carro

%% ======================
% LÍMITES OPERATIVOS – IZAJE (eje y)
%% ======================

yh_min = -20.0;            % [m] Posición mínima de izaje (y_h = Yt0 - l_h)
yh_max =  40.0;            % [m] Posición máxima de izaje
vh_max_loaded   = 1.5;     % [m/s] Velocidad máx izaje con carga
vh_max_unloaded = 3.0;     % [m/s] Velocidad máx izaje sin carga
ah_max = 0.75;             % [m/s^2] Aceleración máxima izaje

%% ======================
% CONTACTO CARGA – APOYO
%% ======================

Kcy = 1.8e9;               % [N/m] Rigidez de contacto vertical (compresión)
bcy = 10.0e6;              % [N/(m/s)] Amortiguamiento vertical de contacto
bcx = 1.0e6;               % [N/(m/s)] Fricción/arrastre horizontal en contacto

%% ======================
% CABLE DE IZAJE (parámetros unitarios)
%% ======================

% OJO UNIDADES (según ecuación de la guía):
% Khw(lh) = khwu / (2*lh + Lh0)  -> entonces khwu debe tener [N] (no [N/m])
% (en el PDF aparece como "(236e6 N/m)·m" que equivale a N)
khwu = 236e6;              % [N]     Parámetro de rigidez unitaria "escalado"
bhwu = 150;                % [N/(m·s)] Amortiguamiento unitario por metro
Lh0  = 110;                % [m] Longitud fija de cable (sin péndulo)

%% ======================
% ACCIONAMIENTO DE IZAJE
%% ======================

rhd = 0.75;                % [m] Radio del tambor de izaje
J_hd_hEb = 3800;           % [kg·m^2] Inercia eje lento (tambor + freno emer.)
bhd = 8.0;                 % [N·m/(rad/s)] Fricción viscosa eje lento

bhEb = 2.2e9;              % [N·m/(rad/s)] Fricción viscosa freno emergencia (cerrado)
ThEb_Max = 1.1e6;          % [N·m] Torque máx freno emergencia

ih = 22.0;                 % [-] Relación de reducción izaje

J_hm_hb = 30.0;            % [kg·m^2] Inercia eje rápido (motor + freno op.)
bhm = 18.0;                % [N·m/(rad/s)] Fricción viscosa eje rápido

bhb = 100e6;               % [N·m/(rad/s)] Fricción viscosa freno operación (cerrado)
Thb_Max = 50e3;            % [N·m] Torque máx freno operación

tau_hm = 1.0e-3;           % [s] Constante de tiempo modulador de torque (izaje)
Thm_Max = 20e3;            % [N·m] Torque máximo motor izaje

%% ======================
% CARRO – MASA Y CABLE
%% ======================

Mt  = 30000;               % [kg] Masa equivalente del carro
bt  = 90.0;                % [N/(m/s)] Fricción viscosa del carro

Ktw = 480e3;               % [N/m] Rigidez total cable de carro
btw = 3.0e3;               % [N/(m/s)] Amortiguamiento total cable de carro

%% ======================
% ACCIONAMIENTO DE CARRO
%% ======================

rtd = 0.50;                % [m] Radio tambor carro
Jtd = 1200;                % [kg·m^2] Inercia eje lento carro
btd = 1.8;                 % [N·m/(rad/s)] Fricción viscosa eje lento

it = 30.0;                 % [-] Relación de reducción carro

Jtm_tb = 7.0;              % [kg·m^2] Inercia eje rápido carro
btm = 6.0;                 % [N·m/(rad/s)] Fricción viscosa eje rápido

btb = 5.0e6;               % [N·m/(rad/s)] Fricción viscosa freno operación carro (cerrado)
Ttb_Max = 5.0e3;           % [N·m] Torque máx freno carro

tau_tm = 1.0e-3;           % [s] Constante de tiempo modulador torque carro
Ttm_Max = 4.0e3;           % [N·m] Torque máximo motor carro

%% ======================
% TIEMPOS DE MUESTREO
%% ======================

Ts2 = 1e-3;                % [s] Nivel 2 – Control regulatorio
Ts1 = 20e-3;               % [s] Nivel 1 – Control supervisor
Ts0 = 20e-3;               % [s] Nivel 0 – Seguridad / Protección

%% ============================================================
% VARIABLES (NO CONSTANTES) – TOMADAS DE LAS ECUACIONES DEL MODELO
% Estas NO se fijan acá: se calculan/actualizan durante simulación.
% Se listan para documentar NOMBRE, UNIDADES y SIGNIFICADO.
%% ============================================================

% % --- Estados/variables cinemáticas globales ---
% xt  = 0;                   % [m]   Posición horizontal del carro (trolley)
% vt  = 0;                   % [m/s] Velocidad horizontal del carro
% at  = 0;                   % [m/s^2] Aceleración del carro (derivada de vt)
% 
% xl  = 0;                   % [m]   Posición horizontal de la carga (punto material)
% yl  = Yt0 - 10;            % [m]   Posición vertical de la carga (spreader/base)
% vlx = 0;                   % [m/s] Velocidad horizontal de la carga
% vly = 0;                   % [m/s] Velocidad vertical de la carga
% 
% % --- Coordenadas del péndulo equivalente (restricción geométrica) ---
% l       = 10;              % [m]     Longitud geométrica instantánea (carga–carro)
% dl      = 0;               % [m/s]   Derivada temporal de l(t)
% theta_l = 0;               % [rad]   Ángulo de balanceo respecto de la vertical
% omega_l = 0;               % [rad/s] Velocidad angular de balanceo
% 
% % --- Izaje: longitud de cable colgante / variable de accionamiento ---
% lh   = 10;                 % [m]   Longitud colgante equivalente del izaje (parte variable)
% dlh  = 0;                  % [m/s] Derivada temporal de lh(t)
% yh   = Yt0 - lh;           % [m]   Posición de izaje: y_h = Yt0 - l_h
% vh   = 0;                  % [m/s] Velocidad de izaje (vh = dyh/dt = -dlh/dt)
% ah   = 0;                  % [m/s^2] Aceleración de izaje
% 
% % --- Perfil de obstáculos / apoyo (ambiente) ---
% yc0 = 0;                   % [m] Perfil vertical de obstáculos/apoyo evaluado en x (yc0(x,t))
% % Nota: en el modelo completo es una función yc0(x,t), no un escalar.
% 
% % --- Fuerzas principales en las ecuaciones ---
% Fhw = 0;                   % [N] Fuerza de tensión del cable de izaje (solo si cable tenso)
% Fc_x = 0;                  % [N] Fuerza de contacto horizontal (arrastre) si hay apoyo
% Fc_y = 0;                  % [N] Fuerza de contacto vertical (reacción elástica amortiguada)
% Ftw = 0;                   % [N] Fuerza equivalente del cable/accionamiento de carro
% 
% % --- Variables del accionamiento de izaje (rotacionales) ---
% omega_hd = 0;              % [rad/s] Velocidad angular del tambor (eje lento) izaje
% theta_hd = 0;              % [rad]   Posición angular del tambor izaje
% omega_hm = 0;              % [rad/s] Velocidad angular del motor izaje (eje rápido)
% theta_hm = 0;              % [rad]   Posición angular del motor izaje
% 
% Thd    = 0;                % [N·m] Torque en eje lento (salida reductor)
% Thdl   = 0;                % [N·m] Torque de carga en tambor (Fhw*rhd)
% Thml   = 0;                % [N·m] Torque equivalente de carga referido a eje motor
% Thm    = 0;                % [N·m] Torque real del motor (salida del modulador)
% Thm_ref = 0;               % [N·m] Consigna de torque al drive (Tm*(k*Ts2))
% Thb    = 0;                % [N·m] Torque freno operación izaje
% ThEb   = 0;                % [N·m] Torque freno emergencia izaje
% 
% % --- Variables del accionamiento de carro (rotacionales) ---
% omega_td = 0;              % [rad/s] Velocidad angular tambor carro (eje lento)
% theta_td = 0;              % [rad]   Posición angular tambor carro
% omega_tm = 0;              % [rad/s] Velocidad angular motor carro (eje rápido)
% theta_tm = 0;              % [rad]   Posición angular motor carro
% 
% Ttd    = 0;                % [N·m] Torque en eje lento carro
% Ttdl   = 0;                % [N·m] Torque de carga en tambor carro (Ftw*rtd)
% Ttml   = 0;                % [N·m] Torque equivalente de carga referido a eje motor
% Ttm    = 0;                % [N·m] Torque real del motor carro
% Ttm_ref = 0;               % [N·m] Consigna de torque al drive (Tm*(k*Ts2))
% Ttb    = 0;                % [N·m] Torque freno operación carro
% 
% % --- Variables discretas / modos (booleanos) del modelo híbrido ---
% TLK   = false;             % [bool] Twistlocks: 0=abiertos (vacío), 1=cerrados (con container)
% BRKh  = true;              % [bool] Freno operación izaje: true=energizado/abierto; false=cerrado (NC)
% BRKhE = true;              % [bool] Freno emergencia izaje: true=energizado/abierto; false=cerrado (NC)
% BRKt  = true;              % [bool] Freno operación carro: true=energizado/abierto; false=cerrado (NC)
% 
% contact = false;           % [bool] Contacto vertical: 0=suspendido; 1=apoyado
% rope_taut = true;          % [bool] Cable izaje tenso: 1 si l>=lh, 0 si cable flojo (Fhw=0)