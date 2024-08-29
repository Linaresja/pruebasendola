view: total_user_by_day_lk {

  # Esta tabla derivada genera un resumen diario de usuarios creados, usuarios cerrados y nuevos usuarios activos,
  # calculado a partir de las tablas de usuarios únicos (`v_unique_users`).
  derived_table: {
    sql: SELECT
        CAST(`vu1`.`created_at` AS date) AS `date`,  # Convertimos la fecha de creación a formato de fecha para agrupar por día.
        COUNT(`vu1`.`user_id`) AS created_users,     # Contamos los usuarios creados por día.
        COUNT(`vu2`.`user_id`) AS closed_users,      # Contamos los usuarios cerrados por día.
        COUNT(`vu1`.`user_id`) - COUNT(`vu2`.`user_id`) AS new_active_users  # Calculamos los nuevos usuarios activos como la diferencia.
      FROM
        `dwh_sendola.v_unique_users` `vu1`
      LEFT JOIN
        `dwh_sendola.v_unique_users` `vu2`
      ON
        CAST(`vu1`.`created_at` AS date) = CAST(`vu2`.`modified_at` AS date)  # Unimos las tablas por fecha.
        AND `vu2`.`status` != "active"                                       # Consideramos solo usuarios cuyo estado no sea "activo".
        AND `vu2`.`modified_at` IS NOT NULL                                  # Filtramos los usuarios que han sido modificados.
      GROUP BY
        1  # Agrupamos por la fecha.
      ORDER BY
        1 ;;  # Ordenamos por la fecha.
  }

  # Medida para contar el número total de registros en esta vista.
  measure: count {
    type: count  # Cuenta el número total de filas.
    drill_fields: [detail*]  # Campos adicionales a mostrar al hacer drill.
  }


  # Dimensión para la fecha, basada en la fecha de creación de los usuarios.
  dimension: date {
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
    description: "Fecha de creación de los usuarios."
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

  # Dimensión para el cálculo de nuevos usuarios activos en un día específico.
  dimension: new_active_users {
    type: number
    sql: ${TABLE}.new_active_users ;;
    description: "Número de nuevos usuarios activos, calculado como la diferencia entre usuarios creados y cerrados."
  }

  # Conjunto de campos para realizar drill down y explorar en más detalle.
  set: detail {
    fields: [
      date,
      created_users,
      closed_users,
      new_active_users
    ]
  }
}
