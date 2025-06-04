# Reconstrucción de Imágenes con Retroproyección Inversa (MATLAB)

Este proyecto utiliza una secuencia de imágenes para construir un volumen tridimensional mediante retroproyección inversa (`iradon`) en MATLAB.

## 📂 Estructura del Proyecto

- **Entrada**: Imágenes `.png` ubicadas en una carpeta local.
- **Procesos**:
  1. **Mejora de imagen** (ajuste de color y brillo)
  2. **Recorte y redimensionamiento**
  3. **Binarización**
  4. **Generación de sinograma**
  5. **Reconstrucción mediante retroproyección**
  6. **Post-procesamiento del volumen**

## 📸 Requisitos

- MATLAB con Image Processing Toolbox
- Imágenes de entrada en formato `.png` con nombres como `frame_0001.png`, `frame_0002.png`, etc.

## 🔧 Uso

1. Edita la variable `path` en el script principal para apuntar a tu carpeta de imágenes.
2. Ejecuta el script en MATLAB.
3. Visualiza el resultado usando el visor volumétrico (`volumeViewer`).

## 🧠 Funciones clave

- `mejorar_img`: Ajusta los canales HSV y LAB para mejorar la visibilidad.
- `recortar_img`: Extrae una región de interés de la imagen.
- `binarizar_img`: Convierte la imagen en binaria.
- `iradon`: Reconstruye la imagen a partir de su sinograma.

## 🧪 Ejemplo de Resultado

Una visualización 3D del volumen reconstruido:

```matlab
volumeViewer(BackProjection)

