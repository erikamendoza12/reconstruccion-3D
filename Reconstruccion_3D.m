% -------------------------------------------------------------------------
% Reconstrucción 3D usando imágenes obtenidas de un video
% -------------------------------------------------------------------------

% Cierra todas las ventanas y limpia el espacio de trabajo
% close all
% clear

% Ruta de la carpeta con las imágenes a procesar
path = "";

% Número total de imágenes en la secuencia
num_imagenes = 210; 

% Inicializa celda para guardar columnas del sinograma
sinogramas = cell(1,256); 

for i = 1:num_imagenes
    if mod(i,7) ~= 0  % Filtra imágenes (por ejemplo, descarta cada 7ma imagen)
        
        % --- Paso 1: Cargar imagen ---
        nombre_archivo = sprintf('frame_%04d.png', i);
        ruta_completa = fullfile(path, nombre_archivo);
        imagen_original = imread(ruta_completa);
        
        % --- Paso 2: Mejorar y recortar imagen ---
        imagen_modificada = mejorar_img(imagen_original, 2.5, 500, 1);
        imagen_recortada = recortar_img(imagen_modificada);
        imagen_recortada = imresize(imagen_recortada, [256, 345]);  % Redimensionar

        % --- Paso 3: Binarizar imagen ---
        umbral_bajo = 0.70;
        imagen_binarizada = binarizar_img(imagen_recortada, umbral_bajo);

        % --- Construir sinograma (almacena cada fila de la imagen binarizada) ---
        for j = 1:256
            sinogramas{i, j} = imagen_binarizada(j, :);
        end
    end 
end

% Construcción de sinogramas por columna (cada entrada es una imagen)
matrices_sinograma = cell(1, 256);
for j = 1:256
    matrices_sinograma{j} = cat(1, sinogramas{:, j});
end

%% --- Retroproyección inversa (iradon) para cada columna del sinograma ---

BackProjection = [];
theta = 1:1:180;
for i = 1:256
    sinograma_actual = matrices_sinograma{i};    
    BackProjection(:,:,i) = iradon(sinograma_actual', theta, 'Linear');
end

% Copia de respaldo
BackProjetcion_respaldo = BackProjection;

% Visualización inicial
% volumeViewer(BackProjection)

%% --- Post-procesamiento del volumen reconstruido ---

BackProjection = BackProjetcion_respaldo;
umbral_bajo = 0.0045;
BackProjection(BackProjection < umbral_bajo) = 0;
BackProjection(BackProjection > 0 & BackProjection < 0.01) = BackProjection(BackProjection > 0 & BackProjection < 0.01) * 0.3;
BackProjection = 5 * BackProjection;
BackProjection(BackProjection > 0 & BackProjection < 0.01) = BackProjection(BackProjection > 0 & BackProjection < 0.01) * 0.3;
BackProjection = 20 * BackProjection;

% Visualización final
volumeViewer(BackProjection)

%% --- Funciones auxiliares ---

function [imagen_modificada] = mejorar_img(imagen_original, factor_hue, factor_saturacion, factor_value)
    % Convierte RGB a HSV y ajusta los canales
    imagen_hsv = rgb2hsv(imagen_original);
    imagen_hsv(:,:,1) = min(imagen_hsv(:,:,1) * factor_hue, 1);
    imagen_hsv(:,:,2) = min(imagen_hsv(:,:,2) * factor_saturacion, 1);
    imagen_hsv(:,:,3) = min(imagen_hsv(:,:,3) * factor_value, 1);
    imagen_modificada = hsv2rgb(imagen_hsv);

    % Conversión a LAB y ajuste de canales de color
    imagen_lab = rgb2lab(imagen_modificada);
    imagen_lab(:,:,3) = imagen_lab(:,:,3) * 1.5;  % Aumenta amarillos
    imagen_lab(:,:,2) = imagen_lab(:,:,2) * 0.8;  % Reduce verdes
    imagen_modificada = lab2rgb(imagen_lab);    
end

function [imagen_recortada] = recortar_img(imagen)
    % Recorta una región específica de la imagen
    x_inicio = 1; 
    y_inicio = 950; 
    ancho = 1080;
    altura = 800;
    imagen_recortada = imagen(y_inicio:y_inicio+altura-1, x_inicio:x_inicio+ancho-1);
end

function [imagen_binarizada] = binarizar_img(imagen, umbral)
    % Convierte imagen en binaria según umbral
    imagen_binarizada = imbinarize(imagen, umbral);
end

function sinograma = calcular_sinograma(imagen_binarizada)
    % Suma de cada fila para formar el sinograma
    num_filas = size(imagen_binarizada, 1);
    sinograma = zeros(num_filas, 1);
    for j = 1:num_filas
        sinograma(j) = sum(imagen_binarizada(j, :));
    end
end
