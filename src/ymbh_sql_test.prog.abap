REPORT ymbh_sql_test.

START-OF-SELECTION.

  SELECT carrid, connid FROM sflight INTO TABLE @DATA(lt_flights).
