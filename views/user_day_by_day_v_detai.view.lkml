view: user_day_by_day_v_detail {
  derived_table: {
    sql: WITH total_user_by_day_lk AS (
        SELECT
            CAST(`vu1`.`created_at` AS date) AS `date`,
            `vu1`.`user_id` AS created_user_id,
            `vu1`.`email` AS email,
            `vu1`.`phone` AS phone,
            `vu1`.`status` AS status,
            `vu1`.`country_origin` AS country_origin,
            `vu1`.`application` AS application,
            `vu2`.`user_id` AS closed_user_id
        FROM
            `dwh_sendola.v_unique_users` `vu1`
        LEFT JOIN
            `dwh_sendola.v_unique_users` `vu2`
        ON
            CAST(`vu1`.`created_at` AS date) = CAST(`vu2`.`modified_at` AS date)
            AND `vu2`.`status` != "active"
            AND `vu2`.`modified_at` IS NOT NULL
      )
      SELECT
          total_user_by_day_lk.date AS total_user_by_day_lk_date_date,
          total_user_by_day_lk.created_user_id AS total_user_by_day_lk_created_user_id,
          total_user_by_day_lk.closed_user_id AS total_user_by_day_lk_closed_user_id,
          total_user_by_day_lk.email AS email,
          total_user_by_day_lk.phone AS phone,
          total_user_by_day_lk.status AS status,
          total_user_by_day_lk.country_origin AS country_origin,
          total_user_by_day_lk.application AS application
      FROM
          total_user_by_day_lk
      ORDER BY
          total_user_by_day_lk.date DESC ;;
  }

  dimension: created_user_id {
    type: string
    sql: ${TABLE}.total_user_by_day_lk_created_user_id ;;
    description: "ID del usuario creado."
  }

  dimension: closed_user_id {
    type: string
    sql: ${TABLE}.total_user_by_day_lk_closed_user_id ;;
    description: "ID del usuario cerrado."
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    description: "Email del usuario."
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
    description: "Teléfono del usuario."
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    description: "Estado del usuario."
  }

  dimension: country_origin {
    type: string
    sql: ${TABLE}.country_origin ;;
    description: "País de origen del usuario."
  }

  dimension: application {
    type: string
    sql: ${TABLE}.application ;;
    description: "Aplicación usada por el usuario."
  }

  dimension_group: date {
    type: time
    timeframes: [date, week, month, quarter, year]
    sql: ${TABLE}.total_user_by_day_lk_date_date ;;
    description: "Fecha de creación del usuario."
  }

  # Set que agrupa todas las dimensiones para usar en el drilldown
  set: drilldown_fields {
    fields: [
      created_user_id,
      closed_user_id,
      email,
      phone,
      status,
      country_origin,
      application,
      date_date
    ]
  }
}
