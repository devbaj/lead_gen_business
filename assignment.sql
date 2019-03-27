-- 1. What query would you run to get the total revenue for March of 2012?
SELECT 
    EXTRACT(MONTH FROM billing.charged_datetime) AS 'month',
    SUM(billing.amount) AS revenue
FROM
    billing
WHERE
    billing.charged_datetime >= '2012/03/01'
        AND billing.charged_datetime < '2012/04/01';

-- 2. What query would you run to get total revenue collected from the client with an id of 2?
SELECT 
    clients.client_id,
    CONCAT(clients.first_name,
            ' ',
            clients.last_name) AS client_name,
    SUM(billing.amount) AS revenue
FROM
    clients
        JOIN
    billing ON clients.client_id = billing.client_id
        AND clients.client_id = 2
GROUP BY client_name;

-- 3. What query would you run to get all the sites that client=10 owns?
SELECT 
    clients.client_id,
    CONCAT(clients.first_name,
            ' ',
            clients.last_name) AS client_name,
    sites.domain_name
FROM
    clients
        JOIN
    sites ON clients.client_id = sites.client_id
        AND clients.client_id = 10;

-- 4. What query would you run to get total # of sites created per month per year for the client with an id of 1? What about for client=20?
	SELECT 
    clients.client_id,
    COUNT(sites.site_id) AS sites_created,
    MONTH(sites.created_datetime) AS 'month',
    YEAR(sites.created_datetime) AS 'year'
FROM
    clients
        JOIN
    sites ON clients.client_id = sites.client_id
        AND clients.client_id = 1
GROUP BY MONTH(sites.created_datetime) , YEAR(sites.created_datetime)
ORDER BY MONTH(sites.created_datetime) ASC;
	-- got something wrong here, it is combining both sites created in November into one row even though they are in different years
SELECT 
    clients.client_id,
    COUNT(sites.site_id) AS sites_created,
    MONTH(sites.created_datetime) AS 'month',
    YEAR(sites.created_datetime) AS 'year'
FROM
    clients
        JOIN
    sites ON clients.client_id = sites.client_id
        AND clients.client_id = 20
GROUP BY MONTH(sites.created_datetime) , YEAR(sites.created_datetime)
ORDER BY MONTH(sites.created_datetime) ASC;

-- 5. What query would you run to get the total # of leads generated for each of the sites between January 1, 2011 to February 15, 2011?
SELECT 
    COUNT(leads.leads_id) AS '# of leads',
    sites.domain_name,
    leads.registered_datetime
FROM
    sites
        JOIN
    leads ON sites.site_id = leads.site_id
        AND leads.registered_datetime >= '2011-01-01'
        AND leads.registered_datetime <= '2011-02-15'
GROUP BY sites.domain_name;
	-- there is a problem, we got a different answer than the answer key
SELECT 
    CONCAT(clients.first_name,
            ' ',
            clients.last_name) AS 'client_name',
    COUNT(leads.leads_id) AS 'number_of_leads'
FROM
    clients
        LEFT JOIN
    sites ON clients.client_id = sites.client_id
        LEFT JOIN
    leads ON sites.site_id = leads.site_id
        AND leads.registered_datetime >= '2011-01-01'
        AND leads.registered_datetime <= '2011-12-31'
GROUP BY clients.client_id
ORDER BY '# of leads' DESC;
	-- there is a problem, answer differs from key
SELECT 
    CONCAT(clients.first_name,
            ' ',
            clients.last_name) AS 'client name',
    COUNT(leads.leads_id) AS '# of leads',
    MONTH(leads.registered_datetime) AS 'month'
FROM
    clients
        LEFT JOIN
    sites ON clients.client_id = sites.client_id
        JOIN
    leads ON sites.site_id = leads.site_id
        AND leads.registered_datetime >= '2011-01-01'
        AND leads.registered_datetime < '2011-07-01'
GROUP BY clients.client_id , MONTH(leads.registered_datetime)
ORDER BY '# of leads' DESC;
	-- problem, answer differs from key
SELECT 
    clients.client_id,
    CONCAT(clients.first_name,
            ' ',
            clients.last_name) AS 'client name',
    sites.domain_name,
    COUNT(leads.leads_id) AS '# of leads'
FROM
    clients
        LEFT JOIN
    sites ON clients.client_id = sites.client_id
        JOIN
    leads ON sites.site_id = leads.site_id
        AND leads.registered_datetime >= '2011-01-01'
        AND leads.registered_datetime <= '2011-12-31'
GROUP BY sites.domain_name
ORDER BY clients.client_id ASC;
	-- answer differs from key
SELECT 
    CONCAT(clients.first_name,
            ' ',
            clients.last_name) AS 'clients',
    sites.domain_name,
    COUNT(leads.leads_id) AS '# of leads'
FROM
    clients
        LEFT JOIN
    sites ON clients.client_id = sites.client_id
        JOIN
    leads ON sites.site_id = leads.site_id
GROUP BY sites.domain_name
ORDER BY clients.client_id;
    
-- 9. Write a single query that retrieves total revenue collected from each client for each month of the year. Order it by client id.
SELECT 
    clients.client_id,
    CONCAT(clients.first_name,
            ' ',
            clients.last_name) AS 'client_name',
    SUM(billing.amount) AS revenue,
    MONTH(billing.charged_datetime) AS 'month',
    YEAR(billing.charged_datetime) AS 'year'
FROM
    clients
        JOIN
    billing ON clients.client_id = billing.client_id
GROUP BY clients.client_id , MONTH(billing.charged_datetime)
ORDER BY clients.client_id ASC , MONTH(billing.charged_datetime) ASC , YEAR(billing.charged_datetime) ASC;
	-- answer differs from key
SELECT 
    clients.client_id,
    CONCAT(clients.first_name,
            ' ',
            clients.last_name) AS 'client_name',
    GROUP_CONCAT(' ', sites.domain_name) AS 'sites'
FROM
    clients
        LEFT JOIN
    sites ON clients.client_id = sites.client_id
GROUP BY clients.client_id;
	-- answer differs, missing 2 rows
    -- resolved, there are 2 clients with no sites, so changing our join to a left join adds those two clients to our query