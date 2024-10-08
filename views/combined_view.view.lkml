# Esta vista combinada, llamada "derived_table", fue creada para unir y transformar datos
# de dos tablas principales: `transaction_plattform` y `v_unique_users`.
# La vista tiene como objetivo simplificar el análisis de transacciones que
# involucren depósitos directos (dd_deposit) y categorizarlos según el banco patrocinador (sponsor_bank).
# Además, se considera la presencia de cuentas asociadas en la tabla `v_unique_users` para determinar reglas adicionales.

view: derived_table {
  # This derived table performs a SQL query joining the `transaction_plattform` (tp)
  # and `v_unique_users` (vu) tables based on the `user_id` field.
  derived_table: {
    sql: SELECT
            tp.user_id,
            tp.txn_type,
            tp.description,
            CASE
              WHEN vu.banner_accounts > 0 THEN 'Banner Bank'
              WHEN vu.banner_accounts = 0 AND vu.coppel_accounts > 0 THEN 'Coppel'
              WHEN vu.banner_accounts = 0 AND vu.coppel_accounts = 0 AND vu.usi_accounts > 0 THEN 'USI'
              ELSE 'Without Program'
            END AS sponsor_bank,
            vu.plaid_accounts,
            vu.customer_id  -- Ensure customer_id is included
          FROM `dwh_sendola.v_unique_users` vu
          LEFT JOIN `dwh_sendola.transaction_plattform` tp
          ON tp.user_id = vu.user_id ;;
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

  # Yes/No dimension to check if the transaction is a direct deposit (dd_deposit)
  dimension: dd_deposit {
    type: yesno
    sql:
      CASE
        WHEN ${txn_type} = 'credit' AND (
          REGEXP_CONTAINS(${description}, r'PAYROLL') OR
          REGEXP_CONTAINS(${description}, r'JRNL ENTRY - SHARE DRAFT FROM REGULAR SHARE') OR
          REGEXP_CONTAINS(${description}, r'PAY \d+')
        )
        OR ( ${sponsor_bank} = 'Banner Bank'
        AND ${plaid_accounts} > 0)
        THEN TRUE
        ELSE FALSE
      END ;;
  }

  # Measure that counts the total number of records
  measure: count {
    type: count
    drill_fields: [
      customer_id,
      txn_type,
      description,
      sponsor_bank,
      plaid_accounts,
      user_id,
      dd_deposit
    ]  # Include all relevant fields to drill down
  }

  # Measure that counts distinct users based on user_id
  measure: distinct_user_count {
    type: count_distinct
    sql: ${user_id} ;;
    description: "Counts the number of distinct users based on the user_id field."
    drill_fields: [
      customer_id,
      txn_type,
      sponsor_bank,
      user_id
    ]  # Include necessary fields to see user-specific details during drill-down
  }

  # Optional: Define additional measures or dimensions as needed.
}
