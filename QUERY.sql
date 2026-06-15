-- =========================================================================
-- SYSTEM: Football Ticket Booking System
-- DESC:   Part 2 — SQL Queries
-- =========================================================================


-- -------------------------------------------------------------------------
-- Query 1
-- Retrieve all upcoming football matches belonging to the 'Champions League'
-- where the match status is 'Available'.
-- -------------------------------------------------------------------------
SELECT
    match_id,
    fixture,
    base_ticket_price
FROM Matches
WHERE tournament_category = 'Champions League'
  AND match_status = 'Available';

/*
Expected output:
 match_id | fixture                  | base_ticket_price
----------+--------------------------+-------------------
 101      | Real Madrid vs Barcelona |            150.00
 103      | Bayern Munich vs PSG     |            130.00
*/


-- -------------------------------------------------------------------------
-- Query 2
-- Search for all users whose full name starts with 'Tanvir'
-- OR contains the phrase 'Haque' (case-insensitive).
-- Concepts: LIKE / ILIKE
-- -------------------------------------------------------------------------
SELECT
    user_id,
    full_name,
    email
FROM Users
WHERE full_name ILIKE 'Tanvir%'        -- starts with Tanvir (case-insensitive)
   OR full_name ILIKE '%Haque%';       -- contains Haque anywhere

/*
Expected output:
 user_id | full_name     | email
---------+---------------+-----------------
 1       | Tanvir Rahman | tanvir@mail.com
 2       | Asif Haque    | asif@mail.com
*/


-- -------------------------------------------------------------------------
-- Query 3
-- Retrieve all booking records where payment_status is NULL,
-- replacing the NULL with 'Action Required' in the output.
-- Concepts: IS NULL, COALESCE
-- -------------------------------------------------------------------------
SELECT
    booking_id,
    user_id,
    match_id,
    COALESCE(payment_status, 'Action Required') AS systematic_status
FROM Bookings
WHERE payment_status IS NULL;

/*
Expected output:
 booking_id | user_id | match_id | systematic_status
------------+---------+----------+-------------------
 504        | 2       | 101      | Action Required
*/


-- -------------------------------------------------------------------------
-- Query 4
-- Retrieve booking details along with the user's full name
-- and the match fixture.
-- Concepts: INNER JOIN
-- -------------------------------------------------------------------------
SELECT
    b.booking_id,
    u.full_name,
    m.fixture,
    b.total_cost
FROM Bookings b
INNER JOIN Users   u ON b.user_id  = u.user_id
INNER JOIN Matches m ON b.match_id = m.match_id;

/*
Expected output:
 booking_id | full_name     | fixture                  | total_cost
------------+---------------+--------------------------+------------
 501        | Tanvir Rahman | Real Madrid vs Barcelona |     150.00
 502        | Tanvir Rahman | Man City vs Liverpool    |     120.00
 503        | Asif Haque    | Real Madrid vs Barcelona |     150.00
 504        | Asif Haque    | Real Madrid vs Barcelona |     150.00
 505        | Sajjad Rahman | Man City vs Liverpool    |     120.00
*/


-- -------------------------------------------------------------------------
-- Query 5
-- Display all users and their booking IDs, including fans who have
-- never bought a ticket (they appear with NULL for booking_id).
-- Concepts: LEFT JOIN
-- -------------------------------------------------------------------------
SELECT
    u.user_id,
    u.full_name,
    b.booking_id
FROM Users u
LEFT JOIN Bookings b ON u.user_id = b.user_id
ORDER BY u.user_id, b.booking_id;

/*
Expected output:
 user_id | full_name     | booking_id
---------+---------------+------------
 1       | Tanvir Rahman | 501
 1       | Tanvir Rahman | 502
 2       | Asif Haque    | 503
 2       | Asif Haque    | 504
 3       | Sajjad Rahman | 505
 4       | Jannat Ara    | NULL        ← never bought a ticket
*/


-- -------------------------------------------------------------------------
-- Query 6
-- Find all bookings where the total cost is STRICTLY HIGHER than
-- the average cost of all bookings.
-- Concepts: Subquery with AVG
-- -------------------------------------------------------------------------
SELECT
    booking_id,
    match_id,
    total_cost
FROM Bookings
WHERE total_cost > (
    SELECT AVG(total_cost)
    FROM Bookings
);

/*
Average of all bookings = (150 + 120 + 150 + 150 + 120) / 5 = 138.00
So only rows with total_cost > 138.00 qualify (i.e. the three 150.00 bookings).

Expected output:
 booking_id | match_id | total_cost
------------+----------+------------
 501        | 101      |     150.00
 503        | 101      |     150.00
 504        | 101      |     150.00
*/


-- -------------------------------------------------------------------------
-- Query 7
-- Retrieve the top 2 most expensive matches sorted by base ticket price,
-- SKIPPING the single most expensive match (OFFSET 1).
-- Concepts: ORDER BY, LIMIT, OFFSET (pagination)
-- -------------------------------------------------------------------------
SELECT
    match_id,
    fixture,
    base_ticket_price
FROM Matches
ORDER BY base_ticket_price DESC
LIMIT  2
OFFSET 1;    -- skip rank #1 (Real Madrid vs Barcelona at 150.00)

/*
Expected output:
 match_id | fixture              | base_ticket_price
----------+----------------------+-------------------
 103      | Bayern Munich vs PSG |            130.00
 102      | Man City vs Liverpool|            120.00
*/