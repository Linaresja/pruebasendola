view: combined_view_unique_user_transaction {
  derived_table: {
    sql: SELECT
            tp.customer_id,
            tp.txn_type,
            tp.description,
            vu.sponsor_bank,
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

  # Aquí puedes definir otras dimensiones y medidas según sea necesario.
  }
