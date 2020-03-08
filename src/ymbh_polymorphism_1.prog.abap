REPORT ymbh_polymorphism_1.

CLASS cx_city_without_airport DEFINITION INHERITING FROM cx_static_check.

ENDCLASS.

CLASS flight_plan DEFINITION.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        airline_id    TYPE s_carrid
        connection_id TYPE s_conn_id.

    METHODS get_city_from
      RETURNING
        VALUE(result) TYPE s_from_cit.

    METHODS set_city_from
      IMPORTING
        city TYPE s_from_cit
      RAISING
        cx_city_without_airport.

  PRIVATE SECTION.
    DATA airline_id          TYPE s_carrid.
    DATA connection_id       TYPE s_conn_id.
    DATA time_zone_city_from TYPE s_tzone.
    DATA city_from           TYPE s_from_cit.

    METHODS city_has_airport
      IMPORTING
        city_from     TYPE s_from_cit
      RETURNING
        VALUE(result) TYPE abap_bool.
    METHODS get_time_zone_city
      IMPORTING
        icity_from      TYPE s_from_cit
      RETURNING
        VALUE(timezone) TYPE s_tzone.

ENDCLASS.

CLASS flight_plan IMPLEMENTATION.

  METHOD constructor.
    me->airline_id    = airline_id.
    me->connection_id = connection_id.
  ENDMETHOD.

  METHOD get_city_from.
    result = city_from.
  ENDMETHOD.

  METHOD set_city_from.
    IF city_has_airport( city ) = abap_false.
      RAISE EXCEPTION TYPE cx_city_without_airport.
    ENDIF.
    city_from = city.
    time_zone_city_from = get_time_zone_city( city_from ).
  ENDMETHOD.

  METHOD city_has_airport.
    result = abap_true.
  ENDMETHOD.


  METHOD get_time_zone_city.
    timezone = SWITCH #( city_from WHEN 'BERLIN' THEN 'UTC+2'
                                   ELSE 'UTC' ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_main DEFINITION.

  PUBLIC SECTION.
    METHODS run.

    METHODS copy.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.

  METHOD run.
    DATA(lo_flight_plan) = NEW flight_plan( airline_id    = 'LHA'
                                            connection_id = '1234' ).
  ENDMETHOD.

  METHOD copy.
    DATA copy_flight_plan TYPE REF TO flight_plan.

    DATA(ba_flight_plan) = NEW flight_plan( airline_id    = 'BA'
                                            connection_id = '400' ).
    copy_flight_plan = ba_flight_plan.

    ba_flight_plan->set_city_from( 'London' ).
    copy_flight_plan->set_city_from( 'Frankfurt' ).

    WRITE ba_flight_plan->get_city_from(  ).
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA(lo_main) = NEW lcl_main( ).
  lo_main->copy( ).
