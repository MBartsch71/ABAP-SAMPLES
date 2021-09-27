REPORT ymbh_corresponding_examples.

CLASS lcl_corresponding_example DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_actor,
             firstname TYPE text20,
             lastname  TYPE text30,
             movies    TYPE i,
           END OF ts_actor.
    TYPES tt_actors TYPE STANDARD TABLE OF ts_actor WITH EMPTY KEY.

    TYPES: BEGIN OF ts_old_actor,
             number    TYPE i,
             firstname TYPE text20,
             lastname  TYPE text30,
             movies    TYPE i,
           END OF ts_old_actor.
    TYPES tt_old_actors TYPE STANDARD TABLE OF ts_old_actor WITH EMPTY KEY.

    TYPES: BEGIN OF ts_modified_actor,
             id         TYPE i,
             name_first TYPE text20,
             name_last  TYPE text30,
             movies     TYPE i,
           END OF ts_modified_actor.
    TYPES tt_modified_actors TYPE STANDARD TABLE OF ts_modified_actor WITH EMPTY KEY.

    TYPES: BEGIN OF ts_movie_source,
             id     TYPE i,
             name   TYPE text30,
             year   TYPE char4,
             actors TYPE tt_old_actors,
           END OF ts_movie_source.
    TYPES tt_movies_source TYPE SORTED TABLE OF ts_movie_source WITH UNIQUE KEY primary_key COMPONENTS id.

    TYPES: BEGIN OF ts_movie,
             name   TYPE text30,
             year   TYPE char4,
             actors TYPE tt_actors,
           END OF ts_movie.
    TYPES tt_movies TYPE SORTED TABLE OF ts_movie WITH UNIQUE KEY primary_key COMPONENTS year name.


    DATA mt_actors        TYPE tt_actors.
    DATA mt_movies_source TYPE tt_movies_source.

    METHODS constructor.

    METHODS simple_corresponding        IMPORTING it_input_values  TYPE tt_old_actors
                                        RETURNING VALUE(rt_result) TYPE tt_actors.

    METHODS corresponding_keeping_lines IMPORTING it_input_values  TYPE tt_old_actors
                                        RETURNING VALUE(rt_result) TYPE tt_actors.

    METHODS corresponding_mapping       IMPORTING it_input_values  TYPE tt_old_actors
                                        RETURNING VALUE(rt_result) TYPE tt_modified_actors.

    METHODS corresponding_with_except   IMPORTING it_input_values  TYPE tt_old_actors
                                        RETURNING VALUE(rt_result) TYPE tt_actors.

    METHODS corresponding_with_deep     IMPORTING it_movies_input  TYPE tt_movies_source
                                        RETURNING VALUE(rt_result) TYPE tt_movies.

ENDCLASS.

CLASS lcl_corresponding_example IMPLEMENTATION.

  METHOD constructor.
    mt_actors = VALUE #( ( firstname = |Timothy| lastname = |Dalton| movies = 2 )
                         ( firstname = |Roger|   lastname = |Moore|  movies = 7 ) ).

  ENDMETHOD.

  METHOD simple_corresponding.
    rt_result = CORRESPONDING #( it_input_values ).
  ENDMETHOD.

  METHOD corresponding_keeping_lines.
    rt_result = mt_actors.
    rt_result = CORRESPONDING #( BASE ( rt_result ) it_input_values ).
  ENDMETHOD.

  METHOD corresponding_mapping.
    rt_result = CORRESPONDING #( it_input_values MAPPING id         = number
                                                         name_first = firstname
                                                         name_last  = lastname ).
  ENDMETHOD.


  METHOD corresponding_with_except.
    rt_result = CORRESPONDING #( it_input_values EXCEPT movies ).
  ENDMETHOD.

  METHOD corresponding_with_deep.
    rt_result = CORRESPONDING #( DEEP it_movies_input ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_application DEFINITION.
  PUBLIC SECTION.
    METHODS run.
ENDCLASS.

CLASS lcl_application IMPLEMENTATION.

  METHOD run.
    DATA(lo_corresponding_example) = NEW lcl_corresponding_example( ).
    cl_demo_output=>write_text( |Simple corresponding| ).
    cl_demo_output=>write_text( |Source table| ).
    DATA(lt_simple_source) = VALUE lcl_corresponding_example=>tt_old_actors( ( number = 1 firstname = |Sean|   lastname = |Connery| )
                                                                             ( number = 2 firstname = |Roger|  lastname = |Moore|   )
                                                                             ( number = 3 firstname = |Daniel| lastname = |Craig| ) ).
    cl_demo_output=>write_data( lt_simple_source ).
    cl_demo_output=>write_text( |Resulting table| ).
    cl_demo_output=>write_data( lo_corresponding_example->simple_corresponding( lt_simple_source ) ).

    cl_demo_output=>display( ).
  ENDMETHOD.

ENDCLASS.


CLASS ltc_corresponding_example DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mt_input_values TYPE lcl_corresponding_example=>tt_old_actors.
    DATA mt_movies_input TYPE lcl_corresponding_example=>tt_movies_source.

    DATA mo_cut TYPE REF TO lcl_corresponding_example.

    METHODS setup.
    METHODS simple_corresponding        FOR TESTING.
    METHODS corresponding_keeping_lines FOR TESTING.
    METHODS corresponding_with_mapping  FOR TESTING.
    METHODS corresponding_with_except   FOR TESTING.
    METHODS corresponding_with_deep     FOR TESTING.
ENDCLASS.


CLASS ltc_corresponding_example IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
    mt_input_values = VALUE #( ( number = 1 firstname = |Sean|   lastname = |Connery| movies = 6 )
                               ( number = 2 firstname = |Pierce| lastname = |Brosnan| movies = 4 )
                               ( number = 3 firstname = |Daniel| lastname = |Craig|   movies = 5 ) ).

    mt_movies_input = VALUE #( ( id    = 1
                                 name  = |Golden Eye|
                                 year  = |1995|
                                 actors = VALUE #( ( number = 1 firstname = |Pierce|   lastname = |Brosnan| )
                                                   ( number = 2 firstname = |Sean|     lastname = |Bean| )
                                                   ( number = 3 firstname = |Izabella| lastname = |Scorupco| ) ) )
                               ( id    = 2
                                 name  = |Skyfall|
                                 year  = |2012|
                                 actors = VALUE #( ( number = 1 firstname = |Daniel| lastname = |Craig|   )
                                                   ( number = 2 firstname = |Javier| lastname = |Bardem|  )
                                                   ( number = 3 firstname = |Ralph|  lastname = |Fiennes| ) ) ) ).
  ENDMETHOD.

  METHOD simple_corresponding.
    DATA(lt_expected_values) = VALUE lcl_corresponding_example=>tt_actors( ( firstname = |Sean|   lastname = |Connery| movies = 6 )
                                                                           ( firstname = |Pierce| lastname = |Brosnan| movies = 4 )
                                                                           ( firstname = |Daniel| lastname = |Craig|   movies = 5 ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_values
        act = mo_cut->simple_corresponding( mt_input_values ) ).
  ENDMETHOD.

  METHOD corresponding_keeping_lines.
    DATA(lt_expected_values) = VALUE lcl_corresponding_example=>tt_actors( ( firstname = |Timothy| lastname = |Dalton|  movies = 2 )
                                                                           ( firstname = |Roger|   lastname = |Moore|   movies = 7 )
                                                                           ( firstname = |Sean|    lastname = |Connery| movies = 6 )
                                                                           ( firstname = |Pierce|  lastname = |Brosnan| movies = 4 )
                                                                           ( firstname = |Daniel|  lastname = |Craig|   movies = 5 ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_values
        act = mo_cut->corresponding_keeping_lines( mt_input_values ) ).
  ENDMETHOD.

  METHOD corresponding_with_mapping.
    DATA(lt_expected_values) = VALUE lcl_corresponding_example=>tt_modified_actors( ( id = 1 name_first = |Sean|   name_last = |Connery| movies = 6 )
                                                                                    ( id = 2 name_first = |Pierce| name_last = |Brosnan| movies = 4 )
                                                                                    ( id = 3 name_first = |Daniel| name_last = |Craig|   movies = 5 ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_values
        act = mo_cut->corresponding_mapping( mt_input_values ) ).
  ENDMETHOD.

  METHOD corresponding_with_except.
    DATA(lt_expected_values) = VALUE lcl_corresponding_example=>tt_actors( ( firstname = |Sean|   lastname = |Connery| movies = 0 )
                                                                           ( firstname = |Pierce| lastname = |Brosnan| movies = 0 )
                                                                           ( firstname = |Daniel| lastname = |Craig|   movies = 0 ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_values
        act = mo_cut->corresponding_with_except( mt_input_values ) ).
  ENDMETHOD.

  METHOD corresponding_with_deep.
    DATA(lt_expected_values) = VALUE lcl_corresponding_example=>tt_movies( ( name   = |Golden Eye|
                                                                             year   = |1995|
                                                                             actors = VALUE #( ( firstname = |Pierce|   lastname = |Brosnan| )
                                                                                               ( firstname = |Sean|     lastname = |Bean|    )
                                                                                               ( firstname = |Izabella| lastname = |Scorupco| ) ) )
                                                                           ( name   = |Skyfall|
                                                                             year   = |2012|
                                                                             actors = VALUE #( ( firstname = |Daniel| lastname = |Craig|   )
                                                                                               ( firstname = |Javier| lastname = |Bardem|  )
                                                                                               ( firstname = |Ralph|  lastname = |Fiennes| ) ) ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_values
        act = mo_cut->corresponding_with_deep( mt_movies_input ) ).
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  NEW lcl_application( )->run( ).
