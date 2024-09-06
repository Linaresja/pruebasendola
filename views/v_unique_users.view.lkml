view: v_unique_users {
  sql_table_name: `dwh_sendola.v_unique_users` ;;

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type: tier
    tiers: [20, 25, 30, 35, 40, 45]
    style: integer
    sql: ${age} ;;
  }

  measure: total_age {
    type: sum
    sql: ${age} ;;
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
  }

  dimension: application {
    type: string
    sql: ${TABLE}.application ;;
  }

  dimension: banner_accounts {
    type: number
    sql: ${TABLE}.banner_accounts ;;
  }

  dimension: coppel_access_status {
    type: string
    sql: ${TABLE}.coppel_access_status ;;
  }

  dimension: coppel_access_status_at {
    type: string
    sql: ${TABLE}.coppel_access_status_at ;;
  }

  dimension: coppel_accounts {
    type: number
    sql: ${TABLE}.coppel_accounts ;;
  }

  dimension: coppel_external_status {
    type: string
    sql: ${TABLE}.coppel_external_status ;;
  }

  dimension: country_origin {
    type: string
    sql: ${TABLE}.country_origin ;;
  }

  # Ajuste a tipo string en lugar de location
  dimension: country_origin_geo {
    type: string
    sql:
      CASE
        WHEN ${TABLE}.country_origin = 'COL' THEN 'Colombia'
        WHEN ${TABLE}.country_origin = 'GTM' THEN 'Guatemala'
        WHEN ${TABLE}.country_origin = 'HND' THEN 'Honduras'
        WHEN ${TABLE}.country_origin = 'IND' THEN 'India'
        WHEN ${TABLE}.country_origin IN ('MEX', 'Mex') THEN 'Mexico'
        WHEN ${TABLE}.country_origin = 'SLV' THEN 'El Salvador'
        WHEN ${TABLE}.country_origin = 'USA' THEN 'United States'
        ELSE NULL
      END ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension: customer {
    type: string
    sql: ${TABLE}.customer ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension_group: date_of_birth {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_of_birth ;;
  }

  dimension: dd_accepted_at {
    type: string
    sql: ${TABLE}.dd_accepted_at ;;
  }

  dimension: dd_form_accepted {
    type: string
    sql: ${TABLE}.dd_form_accepted ;;
  }

  dimension: dd_form_active_feature {
    type: string
    sql: ${TABLE}.dd_form_active_feature ;;
  }

  dimension: dd_percentage {
    type: number
    sql: ${TABLE}.dd_percentage ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: full_name {
    type: string
    sql: CONCAT(${first_name}, ' ', ${middle_name}, ' ', ${last_name}) ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: invitation_code {
    type: string
    sql: ${TABLE}.invitation_code ;;
  }

  dimension: is_gpm {
    type: yesno
    sql: ${TABLE}.is_gpm ;;
  }

  dimension: is_one {
    type: yesno
    sql: ${TABLE}.is_one ;;
  }

  dimension_group: kyc_approved {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.kyc_approved_date ;;
  }

  dimension: kyc_status {
    type: string
    sql: ${TABLE}.kyc_status ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: last_payroll_received_at {
    type: string
    sql: ${TABLE}.last_payroll_received_at ;;
  }

  dimension: middle_name {
    type: string
    sql: ${TABLE}.middle_name ;;
  }

  dimension_group: modified {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.modified_at ;;
  }

  dimension: monthly_payroll {
    type: number
    sql: ${TABLE}.monthly_payroll ;;
  }

  dimension: nationality {
    type: string
    sql: ${TABLE}.nationality ;;
  }

  dimension: penwheel_accounts {
    type: number
    sql: ${TABLE}.penwheel_accounts ;;
  }

  dimension: person_id {
    type: string
    sql: ${TABLE}.person_id ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: plaid_accounts {
    type: number
    sql: ${TABLE}.plaid_accounts ;;
  }

  dimension: solid_accounts {
    type: number
    sql: ${TABLE}.solid_accounts ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: usi_accounts {
    type: number
    sql: ${TABLE}.usi_accounts ;;
  }

  dimension: sponsor_bank {
    type: string
    sql:
    CASE
      WHEN ${banner_accounts} > 0 THEN 'Banner Bank'
      WHEN ${banner_accounts} = 0 AND ${coppel_accounts} > 0 THEN 'Coppel'
      WHEN ${banner_accounts} = 0 AND ${coppel_accounts} = 0 AND ${usi_accounts} > 0 THEN 'USI'
      ELSE 'Without Program'
    END ;;
  }

  # Medida de conteo con drill_fields mejorado
  measure: count {
    type: count
    drill_fields: [
      first_name,
      last_name,
      middle_name,
      full_name,
      email,
      phone,
      status,
      created_date,
      modified_date
    ]
  }
}
