view: v_unique_users {
  sql_table_name: `dwh_sendola.v_unique_users` ;;

  # Dimensiones y medidas relacionadas con fechas
  dimension_group: created {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  # Definir la dimensión `modified_at`
  dimension_group: modified {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.modified_at ;;
  }

  # Medidas para contar usuarios creados y cerrados
  measure: created_users {
    type: count_distinct
    sql: ${TABLE}.user_id ;;
    description: "Número de usuarios creados."
  }

  # Medida ajustada para contar usuarios cerrados
  measure: closed_users {
    type: count_distinct
    sql: CASE
           WHEN ${status} != 'active' AND ${modified_raw} IS NOT NULL THEN ${user_id}
           ELSE NULL
         END ;;
    description: "Número de usuarios cerrados."
  }

  # Medida para calcular la diferencia entre usuarios creados y cerrados
  measure: new_active_users {
    type: number
    sql: ${created_users} - ${closed_users} ;;
    description: "Número de nuevos usuarios activos (usuarios creados - usuarios cerrados)."
    drill_fields: [
      user_id,
      first_name,
      last_name,
      email,
      phone,
      status,
      created_date,
      modified_date
    ]
  }

  # Otras dimensiones
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

  # Medidas de edad
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
    map_layer_name: countries  # Usar la capa predefinida de países
    sql: ${TABLE}.country_origin ;;
  }

  # Dimensión geográfica usando latitud y longitud
  dimension: country_origin_geo {
    type: location
    sql_latitude:
      CASE
        WHEN ${TABLE}.country_origin = 'COL' THEN 4.0000
        WHEN ${TABLE}.country_origin = 'GTM' THEN 15.7835
        WHEN ${TABLE}.country_origin = 'HND' THEN 15.2000
        WHEN ${TABLE}.country_origin = 'IND' THEN 20.5937
        WHEN ${TABLE}.country_origin IN ('MEX', 'Mex') THEN 23.6345
        WHEN ${TABLE}.country_origin = 'SLV' THEN 13.8333
        WHEN ${TABLE}.country_origin = 'USA' THEN 37.0902
        ELSE NULL
      END ;;
    sql_longitude:
      CASE
        WHEN ${TABLE}.country_origin = 'COL' THEN -72.0000
        WHEN ${TABLE}.country_origin = 'GTM' THEN -90.2308
        WHEN ${TABLE}.country_origin = 'HND' THEN -86.2419
        WHEN ${TABLE}.country_origin = 'IND' THEN 78.9629
        WHEN ${TABLE}.country_origin IN ('MEX', 'Mex') THEN -102.5528
        WHEN ${TABLE}.country_origin = 'SLV' THEN -88.9167
        WHEN ${TABLE}.country_origin = 'USA' THEN -95.7129
        ELSE NULL
      END ;;
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
