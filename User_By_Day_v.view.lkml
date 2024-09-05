view: user_day {
  derived_table: {
    sql: WITH total_user_by_day_lk AS (
        SELECT
            CAST(`vu1`.`created_at` AS date) AS `date`,  # Fecha de creación como date
            `vu1`.`user_id` AS created_user_id,  # Incluir el ID de usuario creado
            `vu2`.`user_id` AS closed_user_id    # Incluir el ID de usuario cerrado
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
          total_user_by_day_lk.date AS total_user_by_day_lk_date_date,  # Fecha ya en formato de fecha
          total_user_by_day_lk.created_user_id AS total_user_by_day_lk_created_user_id,  # ID del usuario creado
          total_user_by_day_lk.closed_user_id AS total_user_by_day_lk_closed_user_id    # ID del usuario cerrado
      FROM
          total_user_by_day_lk
      ORDER BY
          total_user_by_day_lk.date DESC ;;
  }

  # Dimensión de fecha (imprescindible para gráficos de línea de tiempo)
  dimension_group: date {
    type: time
    timeframes: [date, week, month, quarter, year]  # Añadir los timeframes que necesitas para el gráfico de línea
    sql: ${TABLE}.total_user_by_day_lk_date_date ;;
    description: "Fecha de creación de los usuarios, con desglose de día, semana, mes, trimestre y año."
  }

  # Dimensiones para mostrar los IDs de los usuarios creados y cerrados
  dimension: created_user_id {
    type: string
    sql: ${TABLE}.total_user_by_day_lk_created_user_id ;;
    description: "ID del usuario creado en un día específico."
  }

  dimension: closed_user_id {
    type: string
    sql: ${TABLE}.total_user_by_day_lk_closed_user_id ;;
    description: "ID del usuario cerrado en un día específico."
  }

  # Definir COUNT como dimensión calculada
  dimension: count_created_users {
    type: number
    sql: COUNT(${created_user_id}) ;;
    description: "Número de usuarios creados en un día específico."
  }

  dimension: count_closed_users {
    type: number
    sql: COUNT(${closed_user_id}) ;;
    description: "Número de usuarios cerrados en un día específico."
  }

  # Métrica calculada para nuevos usuarios activos
  measure: new_active_users {
    type: number
    sql: ${count_created_users} - ${count_closed_users} ;;
    description: "Número de nuevos usuarios activos, calculado como la diferencia entre usuarios creados y cerrados."
    drill_fields: [created_user_id, closed_user_id, date_date]  # Hacer drilldown en los IDs y la fecha
  }

  # Set de detalles para drilldown
  set: detail {
    fields: [
      date_date,  # Referencia correcta a la dimensión de fecha derivada del grupo
      created_user_id,  # Mostrar los detalles de los usuarios creados
      closed_user_id,   # Mostrar los detalles de los usuarios cerrados
      new_active_users
    ]
  }
}
