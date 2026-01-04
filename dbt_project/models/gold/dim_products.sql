{{ config(materialized='table') }}

WITH products AS (
    SELECT * FROM {{ ref('int_products_cleansed') }}
),
translations AS (
    SELECT * FROM {{ ref('stg_category_translation') }}
),
-- Paso intermedio: Traducimos antes de clasificar
translated_products AS (
    SELECT
        p.product_id,
        p.weight_kg,
        COALESCE(t.product_category_name_english, p.category_name) AS category_name_en
    FROM products p
    LEFT JOIN translations t ON p.category_name = t.product_category_name
)

SELECT
    product_id,
    category_name_en AS category_name,
    
    -- Jerarquía de Macro-categorías mejorada (Evaluando sobre el nombre en inglés)
    CASE 
        -- HOGAR Y DECORACIÓN (Home & Furniture)
        WHEN category_name_en IN ('home_confort', 'home_comfort_2', 'home_construction', 'home_appliances', 'home_appliances_2', 'furniture_living_room', 'furniture_bedroom', 'furniture_mattress_and_upholstery', 'office_furniture', 'kitchen_dining_laundry_garden_furniture', 'la_cuisine', 'flowers', 'bed_bath_table', 'furniture_decor', 'housewares') THEN 'Home & Furniture'
        
        -- TECNOLOGÍA Y ELECTRÓNICOS (Technology & Gadgets)
        WHEN category_name_en IN ('computers', 'telephony', 'fixed_telephony', 'tablets_printing_image', 'pc_gamer', 'consoles_games', 'audio', 'watches_gifts', 'computers_accessories', 'electronics') THEN 'Technology & Gadgets'
        
        -- SALUD, BELLEZA Y MODA (Health, Beauty & Fashion)
        WHEN category_name_en IN ('perfumery', 'health_beauty', 'fashion_bags_accessories', 'fashion_shoes', 'fashion_male_clothing', 'fashio_female_clothing', 'fashion_childrens_clothes', 'fashion_underwear_beach', 'fashion_sport', 'diapers_and_hygiene') THEN 'Health, Beauty & Fashion'
        
        -- DEPORTES, HOBBIES Y MEDIA (Sports, Hobbies & Media)
        WHEN category_name_en IN ('sports_leisure', 'toys', 'musical_instruments', 'music', 'books_general_interest', 'books_technical', 'books_imported', 'dvds_blu_ray', 'cds_dvds_musicals', 'cine_photo', 'arts_and_craftmanship', 'party_supplies', 'christmas_supplies', 'cool_stuff') THEN 'Sports, Hobbies & Media'
        
        -- HERRAMIENTAS Y CONSTRUCCIÓN (Tools & Construction)
        WHEN category_name_en IN ('garden_tools', 'construction_tools_construction', 'construction_tools_safety', 'costruction_tools_garden', 'construction_tools_lights', 'costruction_tools_tools', 'signaling_and_security', 'air_conditioning') THEN 'Tools & Construction'
        
        -- ELECTRODOMÉSTICOS Y COMIDA (Appliances & Food)
        WHEN category_name_en IN ('small_appliances', 'small_appliances_home_oven_and_coffee', 'portateis_cozinha_e_preparadores_de_alimentos', 'food', 'food_drink', 'drinks') THEN 'Appliances & Food'
        
        -- PROFESIONAL Y OTROS (Professional & Specialized)
        WHEN category_name_en IN ('auto', 'baby', 'pet_shop', 'stationery', 'luggage_accessories', 'market_place', 'agro_industry_and_commerce', 'industry_commerce_and_business', 'security_and_services') THEN 'Professional & Specialized'
        
        ELSE 'Others'
    END AS macro_category,

    weight_kg,

    -- Clasificación por peso
    CASE 
        WHEN weight_kg > 15 THEN 'Heavy/Bulky'
        WHEN weight_kg BETWEEN 5 AND 15 THEN 'Medium'
        ELSE 'Small/Light'
    END AS shipping_size_class

FROM translated_products