view: user_day_by_day_v {
  derived_table: {
    sql: WITH total_user_by_day_lk AS (
        SELECT
            CAST(`vu1`.`created_at` AS date) AS `date`,  # Fecha de creación como date
            `vu1`.`user_id` AS created_user_id,  # ID de usuario creado
            `vu1`.`email` AS email,  # Añadir detalles de email
            `vu1`.`phone` AS phone,  # Añadir detalles de teléfono
            `vu1`.`status` AS status,  # Añadir el estatus
            `vu1`.`country_origin` AS country_origin,  # País de origen
            `vu1`.`application` AS application,  # Aplicación utilizada
            `vu2`.`user_id` AS closed_user_id  # ID de usuario cerrado
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
          total_user_by_day_lk.closed_user_id AS total_user_by_day_lk_closed_user_id,    # ID del usuario cerrado
          total_user_by_day_lk.email AS email,  # Email del usuario
          total_user_by_day_lk.phone AS phone,  # Teléfono del usuario
          total_user_by_day_lk.status AS status,  # Estatus del usuario
          total_user_by_day_lk.country_origin AS country_origin,  # País de origen
          total_user_by_day_lk.application AS application  # Aplicación usada
      FROM
          total_user_by_day_lk
      ORDER BY
          total_user_by_day_lk.date DESC ;;
  }

  # Dimensión de fecha (imprescindible para gráficos de línea de tiempo)
  dimension_group: date {
    type: time
    timeframes: [date, week, month, quarter, year]
    sql: ${TABLE}.total_user_by_day_lk_date_date ;;
    description: "Fecha de creación de los usuarios, con desglose de día, semana, mes, trimestre y año."
  }

  # Dimensiones adicionales para el drilldown
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

  # Medida que cuenta los usuarios creados
  measure: count_created_users {
    type: count_distinct
    sql: ${created_user_id} ;;
    description: "Número de usuarios creados en un día específico."
  }

  # Medida que cuenta los usuarios cerrados
  measure: count_closed_users {
    type: count_distinct
    sql: ${closed_user_id} ;;
    description: "Número de usuarios cerrados en un día específico."
  }

  # Medida que calcula la diferencia entre usuarios creados y cerrados
  measure: new_active_users {
    type: number
    sql: ${count_created_users} - ${count_closed_users} ;;
    description: "Número de nuevos usuarios activos, calculado como la diferencia entre usuarios creados y cerrados."
    drill_fields: [created_user_id, closed_user_id, date_date, email, phone, status, country_origin, application]
  }

  # Set de detalles para drilldown (sin agregación)
  set: detail {
    fields: [
      created_user_id,  # Mostrar los detalles de los usuarios creados
      closed_user_id,   # Mostrar los detalles de los usuarios cerrados
      date_date,        # Fecha de creación
      email,            # Email del usuario
      phone,            # Teléfono del usuario
      status,           # Estado del usuario
      country_origin,   # País de origen
      application       # Aplicación usada
    ]
  }
}
