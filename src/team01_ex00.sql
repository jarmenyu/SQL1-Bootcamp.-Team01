with updated_currency as (
    select id, name, rate_to_usd
    from (
        select id, name, rate_to_usd, updated,
        row_number() over (partition by id order by updated desc) as rank 
        from currency
    ) as ranked
    where rank = 1
)

select coalesce(u.name, 'not defined') as name, 
       coalesce(u.lastname, 'not defined') as lastname,
       b.type as type, SUM(b.money) as volume,
       coalesce(c.name, 'not defined') as currency_name,
       coalesce(c.rate_to_usd, 1) as last_rate_to_usd,
       (coalesce(c.rate_to_usd, 1) * SUM(b.money)) as total_volume_in_usd
from balance as b
left join "user" as u on b.user_id = u.id
left join updated_currency as c on b.currency_id = c.id
group by u.name, u.lastname, b.type, c.name, c.rate_to_usd
order by name desc, lastname asc, type asc;
