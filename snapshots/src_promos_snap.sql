{% snapshot src_promos_snap %}

{{
    config(
      target_schema='snapshots',
      unique_key='md5(concat(promo_id, discount))',
      strategy='timestamp',
      updated_at='_fivetran_synced',
      invalidate_hard_deletes=True,
    )
}}

select 
    md5(concat(promo_id, discount)) as id_promo,
    *
from {{ source('sql_server_dbo', 'promos') }}

{% endsnapshot %}