# The name of this view in Looker is "Person Kyc Level"
view: person_kyc_level {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `general-dashboard-prod.dwh_sendola.person_kyc_level` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Full Name" in Explore.

  dimension: full_name {
    type: string
    sql: ${TABLE}.full_name ;;
  }

  dimension: kyc_level1_status {
    type: string
    sql: ${TABLE}.kyc_level1_status ;;
  }

  dimension: kyc_level2_status {
    type: string
    sql: ${TABLE}.kyc_level2_status ;;
  }

  dimension: kyc_level3_status {
    type: string
    sql: ${TABLE}.kyc_level3_status ;;
  }

  dimension: onboarding_status {
    type: string
    sql: ${TABLE}.onboarding_status ;;
  }

  dimension: pep_status {
    type: string
    sql: ${TABLE}.pep_status ;;
  }

  dimension: person_id {
    type: string
    sql: ${TABLE}.person_id ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
    drill_fields: [full_name]
  }
}
