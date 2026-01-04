import streamlit as st
import duckdb
import pandas as pd
import plotly.express as px

# Configuración de la página
st.set_page_config(page_title="Olist E-commerce Insights", layout="wide")
st.title("📊 Dashboard de Ventas Olist")

# Conexión a la base de datos
con = duckdb.connect('data/ecommerce.db')

# Carga de datos desde la capa Gold
df_sales = con.execute("""
    SELECT 
        purchase_at::DATE as date,
        total_order_value,
        order_status,
        delivery_time_days
    FROM fct_sales
    WHERE total_order_value IS NOT NULL
""").df()

# Métricas Principales (KPIs)
col1, col2, col3 = st.columns(3)
with col1:
    st.metric("Ventas Totales", f"${df_sales['total_order_value'].sum():,.2f}")
with col2:
    st.metric("Total de Pedidos", f"{len(df_sales):,}")
with col3:
    st.metric("Promedio de Entrega", f"{df_sales['delivery_time_days'].mean():.1f} días")

# Gráfica de Ventas en el Tiempo
st.subheader("Evolución de Ventas")
sales_daily = df_sales.groupby('date')['total_order_value'].sum().reset_index()
fig_line = px.line(sales_daily, x='date', y='total_order_value', title="Ventas Diarias")
st.plotly_chart(fig_line, use_container_width=True)

# Gráfica de Estados de Pedido
st.subheader("Estado de los Pedidos")
fig_pie = px.pie(df_sales, names='order_status', title="Distribución de Estados")
st.plotly_chart(fig_pie)

con.close()