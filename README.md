# 📊 Olist E-commerce Data Engineering Project

## 🚀 Descripción
Este repositorio contiene un pipeline de datos robusto que transforma datos crudos del marketplace brasileño **Olist** en una arquitectura de análisis de alta calidad (**Gold Layer**). Utilizando la metodología de modelado dimensional, este proyecto permite extraer insights estratégicos sobre ventas, logística y comportamiento de productos.

[Image of a modern data stack architecture showing Snowflake, dbt, and Looker Studio]

---

## 🛠️ Tech Stack
* **Warehouse:** [Snowflake](https://www.snowflake.com/) (Cloud Data Platform)
* **Transformación:** [dbt Core](https://www.getdbt.com/) (v1.11.2)
* **Lenguajes:** SQL (Snowflake Dialect) & Jinja
* **Entorno:** Python 3.9+ (venv)
* **Visualización:** Looker Studio
* **Control de Versiones:** Git & GitHub

---

## 🏗️ Arquitectura de Datos: Capa Medallón
El flujo de datos se divide en tres etapas para garantizar la integridad y trazabilidad:

1. **Bronze (Raw):** Ingesta inicial de los datos de Olist sin modificaciones.
2. **Silver (Intermediate):** Limpieza de nulos, tipado de datos y normalización de categorías (Traducción de Portugués a Inglés).
3. **Gold (Analytics):** Modelado final en **Esquema de Estrella (Star Schema)**.

### Tablas en Capa Gold:
* **Hechos:** `FCT_SALES`, `FCT_PRODUCT_PERFORMANCE`, `FCT_SELLER_PERFORMANCE`.
* **Dimensiones:** `DIM_PRODUCTS`, `DIM_CUSTOMERS_ENRICHED`, `DIM_CALENDAR`, `DIM_SELLERS`.

[Image of medallion architecture diagram showing bronze silver and gold layers]

---

## 📈 KPIs Clave Implementados
* **GMV (Gross Merchandise Volume):** Volumen total de ventas transaccionado.
* **AOV (Average Order Value):** Ticket promedio por pedido.
* **Delivery Efficiency:** Tiempo promedio de entrega (Lead Time) por estado.
* **Product Pareto:** Análisis 80/20 de las categorías que impulsan el negocio.

---

## 🔧 Instalación y Uso

### 1. Requisitos Previos
* Cuenta en Snowflake.
* Python instalado localmente.

### 2. Configuración del Proyecto
```bash
# Clonar el repositorio
git clone [https://github.com/TU_USUARIO/TU_REPO.git](https://github.com/TU_USUARIO/TU_REPO.git)
cd TU_REPO

# Crear y activar entorno virtual
python -m venv venv
.\venv\Scripts\activate  # Windows
source venv/bin/activate # Mac/Linux

# Instalar dependencias de Python y dbt
pip install -r requirements.txt
dbt deps
