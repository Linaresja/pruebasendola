# The name of this view in Looker is "Total Users By Day"
view: total_users_by_day {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `general-dashboard-prod.dwh_sendola.total_users_by_day` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Closed Users" in Explore.

  dimension: closed_users {
    type: number
    sql: ${TABLE}.closed_users ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_closed_users {
    type: sum
    sql: ${closed_users} ;;  }
  measure: average_closed_users {
    type: average
    sql: ${closed_users} ;;  }

  dimension: created_users {
    type: number
    sql: ${TABLE}.created_users ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: new_active_users {
    type: number
    sql: ${TABLE}.new_active_users ;;
  }
  measure: count {
    type: count
  }
}
