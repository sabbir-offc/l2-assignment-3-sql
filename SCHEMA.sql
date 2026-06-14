-- =========================================================================
-- SYSTEM: Football Ticket Booking System
-- DESC:   Table creation + sample data insertion
-- =========================================================================

-- Drop existing tables 
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;


-- =========================================================================
-- 1. USERS TABLE
-- =========================================================================
CREATE TABLE Users (
    user_id      INT          NOT NULL,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(150) NOT NULL,
    role         VARCHAR(50)  NOT NULL,
    phone_number VARCHAR(20),                        -- nullable: Jannat has no phone

    CONSTRAINT pk_users    PRIMARY KEY (user_id),
    CONSTRAINT uq_email    UNIQUE (email),
    CONSTRAINT chk_role    CHECK (role IN ('Football Fan', 'Ticket Manager'))
);


-- =========================================================================
-- 2. MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
    match_id             INT            NOT NULL,
    fixture              VARCHAR(200)   NOT NULL,
    tournament_category  VARCHAR(100)   NOT NULL,
    base_ticket_price    DECIMAL(10, 2) NOT NULL,
    match_status         VARCHAR(50)    NOT NULL,

    CONSTRAINT pk_matches         PRIMARY KEY (match_id),
    CONSTRAINT chk_positive_price CHECK (base_ticket_price >= 0),
    CONSTRAINT chk_match_status   CHECK (match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);


-- =========================================================================
-- 3. BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
    booking_id     INT            NOT NULL,
    user_id        INT            NOT NULL,
    match_id       INT            NOT NULL,
    seat_number    VARCHAR(20),                      -- nullable: booking 504 has no seat yet
    payment_status VARCHAR(20),                      -- nullable: booking 504 has no status yet
    total_cost     DECIMAL(10, 2) NOT NULL,

    CONSTRAINT pk_bookings         PRIMARY KEY (booking_id),
    CONSTRAINT fk_bookings_user    FOREIGN KEY (user_id)  REFERENCES Users(user_id),
    CONSTRAINT fk_bookings_match   FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    CONSTRAINT chk_total_cost      CHECK (total_cost >= 0),
    CONSTRAINT chk_payment_status  CHECK (
        payment_status IS NULL OR
        payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
    )
);


-- =========================================================================
-- SEED DATA: USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan',    '+8801711111111'),
(2, 'Asif Haque',    'asif@mail.com',   'Football Fan',    '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager',  '+8801733333333'),
(4, 'Jannat Ara',    'jannat@mail.com', 'Football Fan',    NULL);


-- =========================================================================
-- SEED DATA: MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool',    'Premier League',   120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG',     'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan',  'Serie A',           90.00, 'Sold Out'),
(105, 'Juventus vs Roma',         'Serie A',           80.00, 'Available');


-- =========================================================================
-- SEED DATA: BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101,  NULL,   NULL,       150.00),   -- incomplete booking: seat + payment missing
(505, 3, 102, 'C-20', 'Pending',   120.00);