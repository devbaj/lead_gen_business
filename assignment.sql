-- 1. What query would you run to get the total revenue for March of 2012?
select SUM(billing.amount)
from billing
where billing.charged_datetime >= '2012/03/01' and billing.charged_datetime < '2012/04/01';

-- 2. What query would you run to get total revenue collected from the client with an id of 2?
select concat(clients.first_name, ' ', clients.last_name) as client_name, sum(billing.amount) as revenue
from clients
join billing on clients.client_id = billing.client_id and clients.client_id = 2
group by client_name ;

-- 3. What query would you run to get all the sites that client=10 owns?
select concat(clients.first_name, ' ', clients.last_name) as client_name, sites.domain_name
from clients
join sites on clients.client_id = sites.client_id and clients.client_id = 10;

-- 4. What query would you run to get total # of sites created per month per year for the client with an id of 1? What about for client=20?
	-- For client id 1
select clients.client_id, count(sites.site_id) as sites_created, extract(month from sites.created_datetime) as "month", extract(year from sites.created_datetime) as "year"
from clients
join sites on clients.client_id = sites.client_id and clients.client_id = 1
group by extract(month from sites.created_datetime)
order by sites.created_datetime asc;
	-- For client 20
select clients.client_id, count(sites.site_id) as sites_created, extract(month from sites.created_datetime) as "month", extract(year from sites.created_datetime) as "year"
from clients
join sites on clients.client_id = sites.client_id and clients.client_id = 20
group by extract(month from sites.created_datetime)
order by sites.created_datetime asc;

