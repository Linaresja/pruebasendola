view: user_day_by_day_v {
  derived_table: {
    sql: WITH total_user_by_day_lk AS (
        SELECT
            CAST(`vu1`.`created_at` AS date) AS `date`,  # Fecha de creación como date
            `vu1`.`user_id` AS created_user_id,  # ID de usuario creado
            `vu2`.`user_id` AS closed_user_id    # ID de usuario cerrado
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
    timeframes: [date, week, month, quarter, year]
    sql: ${TABLE}.total_user_by_day_lk_date_date ;;
    description: "Fecha de creación de los usuarios, con desglose de día, semana, mes, trimestre y año."
  }

  # Si no puedes traer los campos de nombre, puedes ajustar el campo full_name como un placeholder
  dimension: full_name {
    type: string
    sql: "'Desconocido'" ;;  # Placeholder de texto para manejar la falta de campos de nombre
    description: "Nombre completo del usuario."
  }

  # Otros campos para el drilldown
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
    drill_fields: [created_user_id, closed_user_id, date_date, full_name, email, phone, status, country_origin, application]
  }

  # Set de detalles para drilldown
  set: detail {
    fields: [
      date_date,  # Referencia correcta a la dimensión de fecha derivada del grupo
      created_user_id,  # Mostrar los detalles de los usuarios creados
      closed_user_id,   # Mostrar los detalles de los usuarios cerrados
      full_name,        # Nombre completo del usuario
      email,            # Email del usuario
      phone,            # Teléfono del usuario
      status,           # Estado del usuario
      country_origin,   # País de origen
      application,      # Aplicación usada
      new_active_users  # Usuarios nuevos activos
    ]
  }
}
