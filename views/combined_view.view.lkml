# Esta vista combinada, llamada "derived_table", fue creada para unir y transformar datos
# de dos tablas principales: `transaction_plattform` y `v_unique_users`.
# La vista tiene como objetivo simplificar el análisis de transacciones que
# involucren depósitos directos (dd_deposit) y categorizarlos según el banco patrocinador (sponsor_bank).
# Además, se considera la presencia de cuentas asociadas en la tabla `v_unique_users` para determinar reglas adicionales.

view: derived_table {
  # Esta tabla derivada realiza una consulta SQL que une las tablas `transaction_plattform` (tp)
  # y `v_unique_users` (vu) sobre la base del campo `customer_id`.
  derived_table: {
    sql: SELECT
            tp.customer_id,
            tp.txn_type,
            tp.description,
            CASE
              WHEN vu.banner_accounts > 0 THEN 'Banner Bank'
              WHEN vu.banner_accounts = 0 AND vu.coppel_accounts > 0 THEN 'Coppel'
              WHEN vu.banner_accounts = 0 AND vu.coppel_accounts = 0 AND vu.usi_accounts > 0 THEN 'USI'
              ELSE 'Without Program'
            END AS sponsor_bank,
            vu.plaid_accounts
          FROM `dwh_sendola.v_unique_users` vu
          LEFT JOIN `dwh_sendola.transaction_plattform` tp
          ON tp.customer_id = vu.customer_id ;;
  }


  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: txn_type {
    type: string
    sql: ${TABLE}.txn_type ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: sponsor_bank {
    type: string
    sql: ${TABLE}.sponsor_bank ;;
  }

  dimension: plaid_accounts {
    type: number
    sql: ${TABLE}.plaid_accounts ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

 # Esta dimensión calcula si una transacción es un depósito directo (dd_deposit).
  # La regla se basa en que el tipo de transacción sea "credit" y que la descripción coincida con ciertos patrones,
  # además de que el banco patrocinador sea "Banner Bank" y el cliente tenga más de 0 cuentas Plaid.
  dimension: dd_deposit {
    type: yesno
    sql:
      CASE
        WHEN ${txn_type} = 'credit' AND (
          REGEXP_CONTAINS(${description}, r'PAYROLL') OR
          REGEXP_CONTAINS(${description}, r'JRNL ENTRY - SHARE DRAFT FROM REGULAR SHARE') OR
          REGEXP_CONTAINS(${description}, r'PAY \d+')
        )
        or ( ${sponsor_bank} = 'Banner Bank'
        AND ${plaid_accounts} > 0)
        THEN TRUE
        ELSE FALSE
      END ;;
  }
# Medida que cuenta el número de registros en la vista combinada.
 measure: count {
  type: count
}

  # Aquí puedes definir otras dimensiones y medidas según sea necesario.
  }
