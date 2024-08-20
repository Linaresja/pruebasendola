# The name of this view in Looker is "Bank Accounts"
view: bank_accounts {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `dwh_sendola.bank_accounts` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Account ID" in Explore.

  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: account_interest_frequency {
    type: string
    sql: ${TABLE}.account_interest_frequency ;;
  }

  dimension: account_number {
    type: string
    sql: ${TABLE}.account_number ;;
  }

  dimension: account_type {
    type: string
    sql: ${TABLE}.account_type ;;
  }

  dimension: available_balance {
    type: number
    sql: ${TABLE}.available_balance ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_available_balance {
    type: sum
    sql: ${available_balance} ;;  }
  measure: average_available_balance {
    type: average
    sql: ${available_balance} ;;  }

  dimension: card_country {
    type: string
    sql: ${TABLE}.card_country ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_date ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: customer {
    type: string
    sql: ${TABLE}.customer ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: fees {
    type: number
    sql: ${TABLE}.fees ;;
  }

  dimension: gp_pending_transactions {
    type: number
    sql: ${TABLE}.gp_pending_transactions ;;
  }

  dimension: interest {
    type: number
    sql: ${TABLE}.interest ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: pending_credit {
    type: number
    sql: ${TABLE}.pending_credit ;;
  }

  dimension: pending_debit {
    type: number
    sql: ${TABLE}.pending_debit ;;
  }

  dimension: person_id {
    type: string
    sql: ${TABLE}.person_id ;;
  }

  dimension: routing_number {
    type: string
    sql: ${TABLE}.routing_number ;;
  }

  dimension: sponsor_bank_name {
    type: string
    sql: ${TABLE}.sponsor_bank_name ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_name {
    type: string
    sql: ${TABLE}.user_name ;;
  }
  measure: count {
    type: count
    drill_fields: [user_name, sponsor_bank_name]
  }
}
