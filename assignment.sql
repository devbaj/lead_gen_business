-- 1. What query would you run to get the total revenue for March of 2012?
select SUM(billing.amount)
from billing
where billing.charged_datetime >= '2012/03/01' and billing.charged_datetime < '2012/04/01';

