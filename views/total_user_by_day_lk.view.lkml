view: total_user_by_day_lk {

  derived_table: {
    sql: SELECT
        CAST(`vu1`.`created_at` AS date) AS `date`,
        COUNT(`vu1`.`user_id`) AS created_users,
        COUNT(`vu2`.`user_id`) AS closed_users,
        COUNT(`vu1`.`user_id`) - COUNT(`vu2`.`user_id`) AS new_active_users
      FROM
        `dwh_sendola.v_unique_users` `vu1`
      LEFT JOIN
        `dwh_sendola.v_unique_users` `vu2`
      ON
        CAST(`vu1`.`created_at` AS date) = CAST(`vu2`.`modified_at` AS date)
        AND `vu2`.`status` != "active"
        AND `vu2`.`modified_at` IS NOT NULL
      GROUP BY
        1
      ORDER BY
        1 ;;
  }

  # Medida que cuenta el número total de registros en esta vista.
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # Métrica que calcula el número de nuevos usuarios activos como la diferencia entre usuarios creados y cerrados.
  measure: new_active_users {
    type: sum
    sql: ${TABLE}.new_active_users ;;
    description: "Número de nuevos usuarios activos, calculado como la diferencia entre usuarios creados y cerrados."
    drill_fields: [detail*]  # Agregar el set de drill down aquí
  }

  # Dimensión para el conteo de usuarios creados en un día específico.
  dimension: created_users {
    type: number
    sql: ${TABLE}.created_users ;;
    description: "Número de usuarios creados en un día específico."
  }

  # Dimensión para el conteo de usuarios cerrados en un día específico.
  dimension: closed_users {
    type: number
    sql: ${TABLE}.closed_users ;;
    description: "Número de usuarios cerrados en un día específico."
  }

  # Dimensión de grupo para la fecha, con desglose de día, mes y año.
  dimension_group: date {
    type: time
    timeframes: [date, month, year]
    sql: ${TABLE}.date ;;
    description: "Fecha de creación de los usuarios, con desglose de día, mes y año."
  }

  # Conjunto de campos para realizar drill down y explorar en más detalle.
  set: detail {
    fields: [
      date_date,          # Desglose diario (date_date).
      date_month,         # Desglose mensual (date_month).
      date_year,          # Desglose anual (date_year).
      created_users,
      closed_users,
      new_active_users
    ]
  }
}
