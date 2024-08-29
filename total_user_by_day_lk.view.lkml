
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

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: countusernew {
    type: count
    drill_fields: [new_active_users]
  }

  dimension: date {
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: created_users {
    type: number
    sql: ${TABLE}.created_users ;;
  }

  dimension: closed_users {
    type: number
    sql: ${TABLE}.closed_users ;;
  }

  dimension: new_active_users {
    type: number
    sql: ${TABLE}.new_active_users ;;
  }

  set: detail {
    fields: [
        date,
  created_users,
  closed_users,
  new_active_users
    ]
  }
}
