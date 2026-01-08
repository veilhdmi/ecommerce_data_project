# 🛒 Olist E-commerce Data Architecture
### *End-to-End ELT Pipeline: From Raw Data to Executive Insights*

![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![Snowflake](https://img.shields.io/badge/snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-003545?style=for-the-badge&logo=postgresql&logoColor=white)

## 🎯 Project Overview
Este proyecto implementa una arquitectura de datos moderna para procesar el ecosistema de **Olist** (el marketplace más grande de Brasil). El objetivo es transformar datos crudos en una **Single Source of Truth (SSOT)** optimizada para análisis de negocio, permitiendo visualizar el rendimiento de ventas, logística y desempeño de vendedores en tiempo real.

---

## 🏗️ Technical Architecture
El pipeline sigue una estructura de **Modelado Dimensional** en Snowflake utilizando dbt:

* **Bronze Layer (Staging):** Ingesta y tipado de datos crudos.
* **Silver Layer (Intermediate):** Limpieza profunda, deduplicación de geolocalización y normalización de fechas.
* **Gold Layer (Marts):** Tablas de hechos y dimensiones enriquecidas (`fct_sales`, `fct_seller_performance`) preparadas para BI.

### Key Engineering Decisions:
* **Cross-Filtering Logic:** Estandarización de estados a formato ISO y mapeo de **Macro-regiones** para permitir filtros sincronizados en tableros de control.
* **Optimization:** Uso de materialización `ephemeral` para modelos intermedios, reduciendo costos de almacenamiento y cómputo en la nube.
* **Business Intelligence:** Integración con **Looker Studio** mediante filtros globales de categorías y regiones.

---

## 🚀 Quick Start

### 1. Pre-requisitos
* Tener instalado Python 3.8+
* Una cuenta activa en **Snowflake**.
* dbt-snowflake instalado (`pip install dbt-snowflake`).

### 2. Configuración
1. Clona el repositorio:
   ```bash
   git clone [https://github.com/veilhdmi/ecommerce_data_project.git](https://github.com/veilhdmi/ecommerce_data_project.git)
   cd ecommerce_data_project