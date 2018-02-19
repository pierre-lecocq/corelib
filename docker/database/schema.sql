--
-- Create schema
--

CREATE TABLE IF NOT EXISTS article (
    article_id SERIAL NOT NULL PRIMARY KEY,
    member_id integer NOT NULL DEFAULT 0,
    state integer NOT NULL DEFAULT 0,
    title text NOT NULL,
    created timestamp without time zone NOT NULL DEFAULT (now() at time zone 'utc')
);
