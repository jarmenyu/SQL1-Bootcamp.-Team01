SELECT distinct
    COALESCE(u.name, 'not defined') AS name,
    COALESCE(u.lastname, 'not defined') AS lastname,
    c.name AS currency_name,
    b.money * COALESCE(
        (SELECT rate_to_usd
         FROM currency cur_past
         WHERE cur_past.id = b.currency_id
           AND cur_past.updated <= b.updated
         ORDER BY cur_past.updated DESC
         LIMIT 1),
        (SELECT rate_to_usd
         FROM currency cur_future
         WHERE cur_future.id = b.currency_id
           AND cur_future.updated > b.updated
         ORDER BY cur_future.updated ASC
         LIMIT 1)
    ) AS currency_in_usd
FROM balance b
LEFT JOIN "user" u ON b.user_id = u.id
LEFT JOIN currency c ON b.currency_id = c.id
WHERE c.name IS NOT NULL
ORDER BY name DESC, lastname ASC, currency_name ASC;
