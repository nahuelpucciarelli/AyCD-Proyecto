%% ============================================================
% PROYECTO GLOBAL INTEGRADOR – AUTÓMATAS Y CONTROL DISCRETO (317)
% Modelo físico – Definición de constantes y variables
% Grúa Portacontenedores STS (Carro – Izaje – Carga)
%
% Todas las constantes se extraen DIRECTAMENTE de la Guía de Trabajo
% Rev.0 – 11/11/2025 (UNCUYO – Ing. Mecatrónica)
%
% Unidades indicadas explícitamente en cada variable
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

% Masa total suspendida (depende del estado de twistlocks)
% ml = Ms + McX  (cuando TLK = ON)

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

yh_min = -20.0;            % [m] Posición mínima de izaje
yh_max =  40.0;            % [m] Posición máxima de izaje
vh_max_loaded   = 1.5;     % [m/s] Velocidad máx izaje con carga
vh_max_unloaded = 3.0;     % [m/s] Velocidad máx izaje sin carga
ah_max = 0.75;             % [m/s^2] Aceleración máxima izaje

%% ======================
% CONTACTO CARGA – APOYO
%% ======================

Kcy = 1.8e9;               % [N/m] Rigidez de contacto vertical
bcy = 10.0e6;              % [N/(m/s)] Fricción interna o amortiguamiento de compresión por contacto vertical
bcx = 1.0e6;               % [N/(m/s)] Fricción de arrastre horizontal por contacto vertical.

%% ======================
% CABLE DE IZAJE (parámetros unitarios)
%% ======================

khwu = 236e6;              % [N/m] Rigidez unitaria por ¡¡¡¡metro de cable!!!!
bhwu = 150;                % [N/(m·s)] Amortiguamiento unitario por metro
Lh0  = 110;                % [m] Longitud fija de cable (sin péndulo)

%% ======================
% ACCIONAMIENTO DE IZAJE
%% ======================
rhd = 0.75;                % [m] Radio del tambor de izaje
J_hd_hEb = 3800;           % [kg·m^2] Inercia eje lento (tambor + freno emer.)
bhd = 8.0;                 % [N·m/(rad/s)] Fricción viscosa eje lento

bhEb = 2.2e9;              % [N·m/(rad/s)] Fricción freno emergencia
ThEb_Max = 1.1e6;          % [N·m] Torque máx freno emergencia

ih = 22.0;                 % [-] Relación de reducción izaje

J_hm_hb = 30.0;            % [kg·m^2] Inercia eje rápido (motor)
bhm = 18.0;                % [N·m/(rad/s)] Fricción viscosa eje rápido

bhb = 100e6;               % [N·m/(rad/s)] Fricción freno operación
Thb_Max = 50e3;            % [N·m] Torque máx freno operación

tau_hm = 1.0e-3;           % [s] Constante de tiempo modulador de torque
Thm_Max = 20e3;            % [N·m] Torque máximo motor izaje

%% ======================
% CARRO – MASA Y CABLE
%% ======================

Mt  = 30000;               % [kg] Masa equivalente del carro
bt  = 90.0;                % [N/(m/s)] Fricción viscosa del carro

Ktw = 480e3;               % [N/m] Rigidez total cable de carro
btw = 3.0e3;               % [N/(m/s)] Fricción interna o amortiguamiento cable de carro

%% ======================
% ACCIONAMIENTO DE CARRO
%% ======================

rtd = 0.50;                % [m] Radio tambor carro
Jtd = 1200;                % [kg·m^2] Inercia eje lento carro
btd = 1.8;                 % [N·m/(rad/s)] Fricción eje lento

it = 30.0;                 % [-] Relación de reducción carro

Jtm_tb = 7.0;              % [kg·m^2] Inercia eje rápido carro
btm = 6.0;                 % [N·m/(rad/s)] Fricción eje rápido

btb = 5.0e6;               % [N·m/(rad/s)] Fricción freno operación
Ttb_Max = 5.0e3;           % [N·m] Torque máx freno carro

tau_tm = 1.0e-3;           % [s] Constante de tiempo modulador torque carro
Ttm_Max = 4.0e3;           % [N·m] Torque máximo motor carro

%% ======================
% TIEMPOS DE MUESTREO
%% ======================

Ts2 = 1e-3;                % [s] Nivel 2 – Control regulatorio
Ts1 = 20e-3;               % [s] Nivel 1 – Control supervisor
Ts0 = 20e-3;               % [s] Nivel 0 – Seguridad / Protección

%% ======================
% VARIABLES DE ESTADO (INICIALIZACIÓN TÍPICA)
%% ======================

xt  = 0;                   % [m] Posición del carro
vt  = 0;                   % [m/s] Velocidad del carro

yl  = Yt0 - 10;             % [m] Posición vertical carga
vlx = 0;                   % [m/s] Velocidad horizontal carga
vly = 0;                   % [m/s] Velocidad vertical carga

theta_l = 0;               % [rad] Ángulo de balanceo
omega_l = 0;               % [rad/s] Velocidad angular balanceo

%% ============================================================
% FIN DEL ARCHIVO DE PARÁMETROS
%% ============================================================