#!/bin/bash

## Initiallizes all tables

psql << EOF
                \connect atahernia

                BEGIN;
                        CREATE TABLE IF NOT EXISTS envy_accounts 
                                (username VARCHAR(20), password VARCHAR(20), 
                                region CHAR(2), hint VARCHAR(20), 
                                        PRIMARY KEY(username));

                        CREATE TABLE IF NOT EXISTS envy_account_info 
                                (account_id VARCHAR(9), username VARCHAR(20),
                                financial_score NUMERIC, name VARCHAR(255), 
                                address VARCHAR(255), occupation VARCHAR(255),
                                education VARCHAR(255), relationship VARCHAR(6), 
                                goals VARCHAR(255), bio VARCHAR(255),
                                        PRIMARY KEY(account_id), 
                                                FOREIGN KEY(username) REFERENCES envy_accounts(username));

                        CREATE TABLE IF NOT EXISTS envy_friends 
                                (group_id VARCHAR(9), account_id VARCHAR(9),
                                friend_id VARCHAR(9),
                                        PRIMARY KEY(group_id), 
                                                FOREIGN KEY(account_id) REFERENCES envy_account_info(account_id),
                                                FOREIGN KEY(friend_id) REFERENCES envy_account_info(account_id));

                        CREATE TABLE IF NOT EXISTS envy_guilds
                                (guild_id VARCHAR(9), account_id VARCHAR(9) UNIQUE,
                                guild_name VARCHAR(20) UNIQUE,
                                        PRIMARY KEY(guild_id),
                                                FOREIGN KEY(account_id) REFERENCES envy_account_info(account_id));

                        CREATE TABLE IF NOT EXISTS envy_guild_list
                                (member_id VARCHAR(9), guild_name VARCHAR(20),
                                guild_id VARCHAR(9), account_id VARCHAR(9),
                                member_rank VARCHAR(20), join_date TEXT,
                                        PRIMARY KEY(member_id),
                                                FOREIGN KEY(guild_name) REFERENCES envy_guilds(guild_name),
                                                FOREIGN KEY(guild_id) REFERENCES envy_guilds(guild_id),
                                                FOREIGN KEY(account_id) REFERENCES envy_account_info(account_id));      

                        CREATE TABLE IF NOT EXISTS envy_content 
                                (content_id VARCHAR(9), account_id VARCHAR(9),
                                guild_id VARCHAR(9), content TEXT, 
                                date TEXT, type TEXT, 
                                        PRIMARY KEY(content_id),
                                                FOREIGN KEY(account_id) REFERENCES envy_account_info(account_id));
        
                        CREATE TABLE IF NOT EXISTS envy_homefeed
                                (home_content_id VARCHAR(9), content_id VARCHAR(9),
                                account_id VARCHAR(9),
                                        PRIMARY KEY(home_content_id),
                                                FOREIGN KEY(content_id) REFERENCES envy_content(content_id));

                        CREATE TABLE IF NOT EXISTS envy_guildfeed
                                (guild_content_id VARCHAR(9), guild_id VARCHAR (9),
                                account_id VARCHAR(9),
                                        PRIMARY KEY(guild_content_id),
                                                FOREIGN KEY(guild_id) REFERENCES envy_guilds(guild_id),
                                                FOREIGN KEY(account_id) REFERENCES envy_account_info(account_id));

                        CREATE TABLE IF NOT EXISTS envy_financials
                                (finance_id VARCHAR(9), account_id VARCHAR(9),
                                financial_score NUMERIC UNIQUE, current_finances NUMERIC,
                                weekly_finances NUMERIC, monthly_finances NUMERIC,
                                annual_finances NUMERIC,
                                        PRIMARY KEY(finance_id),
                                                FOREIGN KEY(account_id) REFERENCES envy_account_info(account_id));
        
                        CREATE TABLE IF NOT EXISTS envy_leaderboard
                                (rank NUMERIC, finance_id VARCHAR(9),
                                financial_score NUMERIC UNIQUE, status VARCHAR(7),
                                date TEXT,
                                        PRIMARY KEY(rank),
                                                FOREIGN KEY(finance_id) REFERENCES envy_financials(finance_id),
                                                FOREIGN KEY(financial_score) REFERENCES envy_financials(financial_score));
        COMMIT;
EOF

chmod +x envy.sh
./envy.sh