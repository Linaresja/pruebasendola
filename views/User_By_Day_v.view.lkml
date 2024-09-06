view: user_day_by_day_v {
  derived_table: {
    sql: WITH total_user_by_day_lk AS (
        SELECT
            CAST(`vu1`.`created_at` AS date) AS `date`,  # Fecha de creación
            `vu1`.`user_id` AS created_user_id,  # ID del usuario creado
            `vu2`.`user_id` AS closed_user_id  # ID del usuario cerrado
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
          total_user_by_day_lk.date AS total_user_by_day_lk_date_date,  # Fecha
          total_user_by_day_lk.created_user_id AS total_user_by_day_lk_created_user_id,  # ID usuario creado
          total_user_by_day_lk.closed_user_id AS total_user_by_day_lk_closed_user_id    # ID usuario cerrado
      FROM
          total_user_by_day_lk
      ORDER BY
          total_user_by_day_lk.date DESC ;;
  }

  # Dimensiones para acceder a los IDs creados y cerrados
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

  # Definir medidas
  measure: count_created_users {
    type: count_distinct
    sql: ${created_user_id} ;;
    description: "Número de usuarios creados."
  }

  measure: count_closed_users {
    type: count_distinct
    sql: ${closed_user_id} ;;
    description: "Número de usuarios cerrados."
  }

 measure: new_active_users {
  type: number
  sql: ${count_created_users} - ${count_closed_users} ;;
  description: "Número de nuevos usuarios activos."
  drill_fields: [
    user_day_by_day_v_detail.created_user_id,
    user_day_by_day_v_detail.closed_user_id,
    user_day_by_day_v_detail.email,
    user_day_by_day_v_detail.phone,
    user_day_by_day_v_detail.status,
    user_day_by_day_v_detail.country_origin,
    user_day_by_day_v_detail.application,
    user_day_by_day_v_detail.date
  ]  # Incluir las dimensiones específicas en el drilldown
}

  # Dimensiones para fecha y drilldown básico
  dimension_group: date {
    type: time
    timeframes: [date, week, month, quarter, year]
    sql: ${TABLE}.total_user_by_day_lk_date_date ;;
  }
}
