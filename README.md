📊 E-commerce Data Engineering: Olist Analytics Stack
🚀 Descripción del Proyecto
Este proyecto implementa una arquitectura de datos moderna (Modern Data Stack) para transformar los datos crudos del marketplace brasileño Olist en una capa de analítica avanzada (Gold Layer). El objetivo es proporcionar KPIs estratégicos sobre el rendimiento de productos, logística y vendedores.

🛠️ Tecnologías Utilizadas
Almacenamiento: Snowflake (Cloud Data Warehouse)

Transformación: dbt (Data Build Tool) - Core v1.11.2

Lenguajes: SQL (JinJa en dbt) & Python (entorno virtual)

Visualización: Looker Studio

Control de Versiones: Git & GitHub

🏗️ Arquitectura de Datos (Capa Medallón)
El proyecto sigue la arquitectura de Medallón para garantizar la calidad y trazabilidad del dato:

Bronze (Raw): Datos crudos importados de Olist.

Silver (Integration): Limpieza, tipado de datos y traducción de categorías del portugués al inglés.

Gold (Analytics): Modelado en esquema de estrella (Star Schema) optimizado para BI.

Tablas de Hechos: FCT_SALES, FCT_PRODUCT_PERFORMANCE, FCT_SELLER_PERFORMANCE.

Dimensiones: DIM_PRODUCTS, DIM_CUSTOMERS, DIM_CALENDAR, DIM_SELLERS.

📈 KPIs Implementados
GMV (Gross Merchandise Volume): Valor total transaccionado.

AOV (Average Order Value): Ticket promedio por pedido.

Delivery Lead Time: Tiempo promedio de entrega al cliente final.

Pareto de Categorías: Identificación de las categorías que generan el 80% de los ingresos.

🔧 Instalación y Configuración
Clonar el repositorio:

Bash

git clone https://github.com/tu-usuario/tu-repositorio.git
cd tu-repositorio
Configurar el Entorno Virtual:

Bash

python -m venv venv
# Activar en Windows:
.\venv\Scripts\activate
# Activar en Mac/Linux:
source venv/bin/activate
Instalar dependencias:

Bash

pip install -r requirements.txt
dbt deps
Configurar dbt: Asegúrate de configurar tu archivo profiles.yml con tus credenciales de Snowflake.

Ejecutar el pipeline:

Bash

dbt run
dbt test
