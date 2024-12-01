

{% snapshot src_product_unit_costs_snap %}

{{
    config(
      target_schema='snapshots',
      unique_key='product_name',
      strategy='check',
      check_cols=['product_name','product_unit_costs'],
      invalidate_hard_deletes=True,
    )
}}

select 
    *
from {{ source('sql_server_dbo', 'product_unit_costs') }}

{% endsnapshot %}