# The name of this view in Looker is "Transaction Plattform"
view: transaction_plattform {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `dwh_sendola.transaction_plattform` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Account ID" in Explore.

  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: account_number {
    type: string
    sql: ${TABLE}.account_number ;;
  }

  dimension: account_type {
    type: string
    sql: ${TABLE}.account_type ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_amount {
    type: sum
    sql: ${amount} ;;  }
  measure: average_amount {
    type: average
    sql: ${amount} ;;  }

  dimension: balance {
    type: number
    sql: ${TABLE}.balance ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: person_id {
    type: string
    sql: ${TABLE}.person_id ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: transaction_id {
    type: string
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: transfer_type {
    type: string
    sql: ${TABLE}.transfer_type ;;
  }

  dimension: txn_type {
    type: string
    sql: ${TABLE}.txn_type ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }



  measure: count {
    type: count
    drill_fields: [name]
  }
}
