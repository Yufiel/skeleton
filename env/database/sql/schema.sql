\set ON_ERROR_STOP true

DROP DATABASE IF EXISTS skeleton;
CREATE DATABASE skeleton;

\connect skeleton;

DROP SCHEMA IF EXISTS users CASCADE;
CREATE SCHEMA users AUTHORIZATION postgres;

START TRANSACTION;

-- add table for keeping track of schema version
DROP TABLE IF EXISTS public.db_schema_version;

CREATE TABLE public.db_schema_version (
    id bigint PRIMARY KEY,
    version text NOT NULL,
    CHECK(id=1)
);

CREATE OR REPLACE FUNCTION public.assert_db_schema_version( _expectedVersion text ) RETURNS void AS
$$
  DECLARE
    _actual text;
  BEGIN
    SELECT version INTO _actual FROM public.db_schema_version LIMIT 1;
    IF COALESCE(_actual,'') <> _expectedVersion THEN
      RAISE EXCEPTION 'DB schema version mismatch, expected % but got %', _expectedVersion, _actual;
    END IF;
  END;
$$ LANGUAGE plpgsql;

-- Drop Tables
SET search_path='users';

DROP TABLE IF EXISTS user_role CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS roles CASCADE;

-- User Table
DROP SEQUENCE IF EXISTS user_id_seq;
CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE user_id_seq OWNER TO postgres;

CREATE TABLE users (
                              id                      bigint PRIMARY KEY DEFAULT nextval('user_id_seq'::regclass),
                              username                varchar(100) NOT NULL UNIQUE,
                              password                varchar(100) NOT NULL,
                              email                   varchar(100) NOT NULL,
                              first_name              varchar(100),
                              last_name               varchar(100),
                              last_successful_login   timestamp with time zone default now(),
                              enabled                 boolean NOT NULL DEFAULT FALSE
);
ALTER TABLE user_id_seq owner TO postgres;

-- Role Table
DROP SEQUENCE IF EXISTS role_id_seq;
CREATE SEQUENCE role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE role_id_seq OWNER TO postgres;
create table roles (
                              id              bigint PRIMARY KEY DEFAULT nextval('role_id_seq'::regclass),
                              role_name       varchar(100) NOT NULL
);

-- User-Role Table
CREATE TABLE user_role (
                                   user_id     bigint NOT NULL,
                                   role_id     bigint NOT NULL,
                                   UNIQUE(user_id, role_id),
                                   FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                                   FOREIGN KEY (role_id) REFERENCES roles(id)  ON DELETE CASCADE);
ALTER TABLE user_role owner TO postgres;

COMMIT;
