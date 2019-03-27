-- 1. What query would you run to get the total revenue for March of 2012?
select extract(month from billing.charged_datetime) as "month", SUM(billing.amount) as revenue
from billing
where billing.charged_datetime >= '2012/03/01' and billing.charged_datetime < '2012/04/01';

-- 2. What query would you run to get total revenue collected from the client with an id of 2?
select clients.client_id, concat(clients.first_name, ' ', clients.last_name) as client_name, sum(billing.amount) as revenue
from clients
join billing on clients.client_id = billing.client_id and clients.client_id = 2
group by client_name ;

-- 3. What query would you run to get all the sites that client=10 owns?
select clients.client_id, concat(clients.first_name, ' ', clients.last_name) as client_name, sites.domain_name
from clients
join sites on clients.client_id = sites.client_id and clients.client_id = 10;

-- 4. What query would you run to get total # of sites created per month per year for the client with an id of 1? What about for client=20?
	-- For client id 1
select clients.client_id, count(sites.site_id) as sites_created, month(sites.created_datetime) as "month", year(sites.created_datetime) as "year"
from clients
join sites on clients.client_id = sites.client_id and clients.client_id = 1
group by month(sites.created_datetime), year(sites.created_datetime)
order by month(sites.created_datetime) asc;
	-- got something wrong here, it is combining both sites created in November into one row even though they are in different years
    -- error corrected, I was only grouping by month, not month and year

	-- For client 20
select clients.client_id, count(sites.site_id) as sites_created, month(sites.created_datetime) as "month", year(sites.created_datetime) as "year"
from clients
join sites on clients.client_id = sites.client_id and clients.client_id = 20
group by month(sites.created_datetime), year(sites.created_datetime)
order by month(sites.created_datetime) asc;

-- 5. What query would you run to get the total # of leads generated for each of the sites between January 1, 2011 to February 15, 2011?
select count(leads.leads_id) as "# of leads", sites.domain_name, leads.registered_datetime
from sites
join leads on sites.site_id = leads.site_id and leads.registered_datetime >= "2011-01-01" and leads.registered_datetime <= "2011-02-15"
group by sites.domain_name;
	-- there is a problem, we got a different answer than the answer key
    -- problem resolved, I was querying sites.created_datetime instead of leads.registered_datetime

-- 6. What query would you run to get a list of client names and the total # of leads we've generated for each of our clients between January 1, 2011 to December 31, 2011?
select concat(clients.first_name, ' ', clients.last_name) as "client_name", count(leads.leads_id) as "number_of_leads"
from clients
left join sites on clients.client_id = sites.client_id
left join leads on sites.site_id = leads.site_id and leads.registered_datetime >= "2011-01-01" and leads.registered_datetime <= "2011-12-31"
group by clients.client_id
order by "# of leads" desc;
	-- there is a problem, answer differs from key
    -- problem resolved, I had commented out my "group by" section when I was testing something


-- 7. What query would you run to get a list of client names and the total # of leads we've generated for each client each month between months 1 - 6 of Year 2011?
select concat(clients.first_name, ' ', clients.last_name) as "client name", count(leads.leads_id) as "# of leads", month(leads.registered_datetime) as "month"
from clients
left join sites on clients.client_id = sites.client_id
join leads on sites.site_id = leads.site_id and leads.registered_datetime >= "2011-01-01" and leads.registered_datetime < "2011-07-01"
group by clients.client_id, month(leads.registered_datetime)
order by "# of leads" desc;
	-- problem, answer differs from key
    -- problem solved, added second grouping condition and added month registered to query

-- 8. What query would you run to get a list of client names and the total # of leads we've generated for each of our clients' sites between January 1, 2011 to December 31, 2011? Order this query by client id.  Come up with a second query that shows all the clients, the site name(s), and the total number of leads generated from each site for all time.
select clients.client_id, concat(clients.first_name, ' ', clients.last_name) as "client name", count(leads.leads_id) as "# of leads"
from clients
left join sites on clients.client_id = sites.client_id
join leads on sites.site_id = leads.site_id and leads.registered_datetime >= "2011-01-01" and leads.registered_datetime <= "2011-12-31"
group by "client name"
order by clients.client_id desc;
	-- Part 2
    select concat(clients.first_name, ' ', clients.last_name) as "clients", sites.domain_name, count(leads.leads_id) as "# of leads"
    from clients
    left join sites on clients.client_id = sites.client_id
    join leads on sites.site_id = leads.site_id
    group by sites.domain_name;
    
-- 9. Write a single query that retrieves total revenue collected from each client for each month of the year. Order it by client id.
select clients.client_id, SUM(billing.amount) as revenue, extract(month from billing.charged_datetime) as "month"
from clients
join billing on clients.client_id = billing.client_id
group by clients.client_id, extract(month from billing.charged_datetime)
order by clients.client_id asc, extract(month from billing.charged_datetime) asc;

-- 10. Write a single query that retrieves all the sites that each client owns. Group the results so that each row shows a new client. It will become clearer when you add a new field called 'sites' that has all the sites that the client owns. (HINT: use GROUP_CONCAT)
select clients.client_id, concat(clients.first_name, ' ', clients.last_name) as "client", group_concat(' ', sites.domain_name)
from clients
join sites on clients.client_id = sites.client_id
group by clients.client_id;