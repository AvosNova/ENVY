#!/bin/bash

psql << EOF
        CREATE OR REPLACE VIEW leaderboard_vew AS SELECT a.name, a.username, b.financial_score 
        FROM envy_account_info a, envy_financials b;

        SELECT * FROM leaderboard_vew;
EOF

chmod +x navList.sh
./navList.sh