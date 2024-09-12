view: person_kyc_level {
  sql_table_name: `general-dashboard-prod.dwh_sendola.person_kyc_level` ;;

  dimension: full_name {
    type: string
    sql: ${TABLE}.full_name ;;
  }
  dimension: kyc_level1_status {
    type: string
    sql: CASE
        WHEN ${TABLE}.kyc_level1_status = 'approved' THEN 'Approved'
        WHEN ${TABLE}.kyc_level1_status = 'started' THEN 'Started'
        WHEN ${TABLE}.kyc_level1_status = 'inReview' THEN 'In Review'
        WHEN ${TABLE}.kyc_level1_status = 'declined' THEN 'Declined'
        WHEN ${TABLE}.kyc_level1_status = 'notStarted' THEN 'Not Started'
        ELSE ${TABLE}.kyc_level1_status
    END ;;
  }

  dimension: kyc_level2_status {
    type: string
    sql: CASE
        WHEN ${TABLE}.kyc_level2_status = 'approved' THEN 'Approved'
        WHEN ${TABLE}.kyc_level2_status = 'started' THEN 'Started'
        WHEN ${TABLE}.kyc_level2_status = 'inReview' THEN 'In Review'
        WHEN ${TABLE}.kyc_level2_status = 'declined' THEN 'Declined'
        WHEN ${TABLE}.kyc_level2_status = 'notStarted' THEN 'Not Started'
        ELSE ${TABLE}.kyc_level2_status
    END ;;
  }

  dimension: kyc_level3_status {
    type: string
    sql: CASE
        WHEN ${TABLE}.kyc_level3_status = 'approved' THEN 'Approved'
        WHEN ${TABLE}.kyc_level3_status = 'started' THEN 'Started'
        WHEN ${TABLE}.kyc_level3_status = 'inReview' THEN 'In Review'
        WHEN ${TABLE}.kyc_level3_status = 'declined' THEN 'Declined'
        WHEN ${TABLE}.kyc_level3_status = 'notStarted' THEN 'Not Started'
        ELSE ${TABLE}.kyc_level3_status
    END ;;
  }

  dimension: onboarding_status {
    type: string
    sql: CASE
        WHEN ${TABLE}.onboarding_status = 'completed' THEN 'Completed'
        WHEN ${TABLE}.onboarding_status = 'started' THEN 'Started'
        WHEN ${TABLE}.onboarding_status = 'notStarted' THEN 'Not Started'
        ELSE ${TABLE}.onboarding_status
    END ;;
  }

  dimension: pep_status {
    type: string
    sql: ${TABLE}.pep_status ;;
  }

  dimension: person_id {
    type: string
    sql: ${TABLE}.person_id ;;
  }

  dimension_group: timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  # Updated measure to show more fields in drill-down
  measure: count {
    type: count
    drill_fields: [
      full_name,
      onboarding_status,
      kyc_level1_status,
      kyc_level2_status,
      kyc_level3_status,
      pep_status,
      person_id
    ]
  }
}
