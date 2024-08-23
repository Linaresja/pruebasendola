view: derived_table {
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
          FROM `dwh_sendola.transaction_plattform` tp
          LEFT JOIN `dwh_sendola.v_unique_users` vu
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

  dimension: dd_deposit {
    type: yesno
    sql:
      CASE
        WHEN ${txn_type} = 'credit' AND (
          REGEXP_CONTAINS(${description}, r'PAYROLL') OR
          REGEXP_CONTAINS(${description}, r'JRNL ENTRY - SHARE DRAFT FROM REGULAR SHARE') OR
          REGEXP_CONTAINS(${description}, r'PAY \d+')
        )
        AND ${sponsor_bank} = 'Banner Bank'
        AND ${plaid_accounts} > 0
        THEN TRUE
        ELSE FALSE
      END ;;
  }


  # Aquí puedes definir otras dimensiones y medidas según sea necesario.
  }
