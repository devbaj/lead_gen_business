-- 1. What query would you run to get the total revenue for March of 2012?
select SUM(billing.amount)
from billing
where billing.charged_datetime >= '2012/03/01' and billing.charged_datetime < '2012/04/01';

-- 2. What query would you run to get total revenue collected from the client with an id of 2?
select concat(clients.first_name, ' ', clients.last_name) as client_name, sum(billing.amount) as revenue
from clients
join billing on clients.client_id = billing.client_id and clients.client_id = 2
group by client_name ;