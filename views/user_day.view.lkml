view: user_day {
  derived_table: {
    sql: WITH total_user_by_day_lk AS (
        SELECT
            CAST(`vu1`.`created_at` AS date) AS `date`,  # Fecha de creación como date
            COUNT(`vu1`.`user_id`) AS created_users,
            COUNT(`vu2`.`user_id`) AS closed_users
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
            1
      )
      SELECT
          total_user_by_day_lk.date AS total_user_by_day_lk_date_date,  # Fecha ya en formato de fecha
          SUM(total_user_by_day_lk.created_users) AS total_user_by_day_lk_created_users,
          SUM(total_user_by_day_lk.closed_users) AS total_user_by_day_lk_closed_users
      FROM
          total_user_by_day_lk
      GROUP BY
          1
      ORDER BY
          1 DESC ;;
  }

  # Métrica para contar el número total de registros
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # Dimensión de fecha (imprescindible para gráficos de línea de tiempo)
  dimension_group: date {
    type: time
    timeframes: [date, week, month, quarter, year]  # Añadir los timeframes que necesitas para el gráfico de línea
    sql: ${TABLE}.total_user_by_day_lk_date_date ;;
    description: "Fecha de creación de los usuarios, con desglose de día, semana, mes, trimestre y año."
  }

  # Métricas para usuarios creados y cerrados
  measure: created_users {
    type: sum
    sql: ${TABLE}.total_user_by_day_lk_created_users ;;
    description: "Número de usuarios creados en un día específico."
    drill_fields: [date_date]  # Referenciamos la dimensión generada del grupo de fechas
  }

  measure: closed_users {
    type: sum
    sql: ${TABLE}.total_user_by_day_lk_closed_users ;;
    description: "Número de usuarios cerrados en un día específico."
    drill_fields: [date_date]  # Referenciamos la dimensión generada del grupo de fechas
  }

  # Métrica para nuevos usuarios activos, basada en la diferencia entre usuarios creados y cerrados
  measure: new_active_users {
    type: number
    sql: ${created_users} - ${closed_users} ;;
    description: "Número de nuevos usuarios activos, calculado como la diferencia entre usuarios creados y cerrados."
    drill_fields: [created_users, closed_users, date_date]  # Hacer drilldown en los componentes y la fecha
  }

  # Set de detalles para drilldown
  set: detail {
    fields: [
      date_date,  # Referencia correcta a la dimensión de fecha derivada del grupo
      created_users,
      closed_users,
      new_active_users
    ]
  }
}
