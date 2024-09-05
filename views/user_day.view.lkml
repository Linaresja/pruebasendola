
view: user_day {
  derived_table: {
    sql: WITH total_user_by_day_lk AS (
        SELECT
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
            1
      )
      SELECT
          total_user_by_day_lk.date AS total_user_by_day_lk_date_date,  -- No se convierte nuevamente, ya está en formato de fecha
          COALESCE(SUM(total_user_by_day_lk.new_active_users), 0) AS total_user_by_day_lk_new_active_users
      FROM
          total_user_by_day_lk
      GROUP BY
          1
      ORDER BY
          1 DESC ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: total_user_by_day_lk_date_date {
    type: date
    datatype: date
    sql: ${TABLE}.total_user_by_day_lk_date_date ;;
  }

  dimension: total_user_by_day_lk_new_active_users {
    type: number
    sql: ${TABLE}.total_user_by_day_lk_new_active_users ;;
  }

  set: detail {
    fields: [
        total_user_by_day_lk_date_date,
	total_user_by_day_lk_new_active_users
    ]
  }
}
