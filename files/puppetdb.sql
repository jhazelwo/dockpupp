
CREATE ROLE puppetdb PASSWORD 'md5b1158657786cc332d1812fe6b542dd80' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;
CREATE DATABASE puppetdb OWNER puppetdb ENCODING 'UTF8' TEMPLATE template0;
create extension pg_trgm
