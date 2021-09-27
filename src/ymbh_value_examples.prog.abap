REPORT ymbh_value_examples.

CLASS lcl_value_example DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_name,
             forename TYPE text20,
             surname  TYPE text30,
           END OF ts_name.
    TYPES tt_names TYPE STANDARD TABLE OF ts_name WITH DEFAULT KEY.

    TYPES: BEGIN OF ts_name_record,
             id        TYPE i,
             firstname TYPE text20,
             lastname  TYPE text30,
           END OF ts_name_record.
    TYPES tt_name_records TYPE STANDARD TABLE OF ts_name_record WITH DEFAULT KEY.

    METHODS simple_value              RETURNING VALUE(rt_result) TYPE stringtab.

    METHODS seven_lines_new_style     RETURNING VALUE(rt_result) TYPE stringtab.
    METHODS seven_lines_old_style     RETURNING VALUE(rt_result) TYPE stringtab.


    METHODS transfer_old_style        IMPORTING it_input_values  TYPE lcl_value_example=>tt_names
                                      RETURNING VALUE(rt_result) TYPE lcl_value_example=>tt_name_records.

    METHODS transfer_new_style        IMPORTING it_input_values  TYPE lcl_value_example=>tt_names
                                      RETURNING VALUE(rt_result) TYPE lcl_value_example=>tt_name_records.


    METHODS extract_actors_old_style  IMPORTING it_input_values  TYPE lcl_value_example=>tt_names
                                      RETURNING VALUE(rt_result) TYPE lcl_value_example=>tt_name_records.

    METHODS extract_actors_cond_value IMPORTING it_input_values  TYPE lcl_value_example=>tt_names
                                      RETURNING VALUE(rt_result) TYPE lcl_value_example=>tt_name_records.

    METHODS extract_actors_new_style  IMPORTING it_input_values  TYPE lcl_value_example=>tt_names
                                      RETURNING VALUE(rt_result) TYPE lcl_value_example=>tt_name_records.


    METHODS fizzbuzz                  IMPORTING iv_start         TYPE i
                                                iv_end           TYPE i
                                      RETURNING VALUE(rt_result) TYPE stringtab.

  PRIVATE SECTION.
    METHODS actor_is_special IMPORTING is_value         TYPE ts_name
                             RETURNING VALUE(rv_result) TYPE abap_bool.

ENDCLASS.

CLASS lcl_value_example IMPLEMENTATION.

  METHOD simple_value.
    rt_result = VALUE #( ( |James| )
                         ( |Bond|  ) ).
  ENDMETHOD.


  METHOD seven_lines_old_style.
    DATA lv_line TYPE string.
    DATA lv_counter TYPE c LENGTH 1.

    DO 7 TIMES.
      lv_counter = sy-index.
      CONCATENATE `zeile` lv_counter INTO lv_line SEPARATED BY space.
      APPEND lv_line TO rt_result.
    ENDDO.
  ENDMETHOD.

  METHOD seven_lines_new_style.
    rt_result = VALUE #( FOR i = 1 THEN i + 1 UNTIL i > 7
                            ( |zeile { i }| ) ).
  ENDMETHOD.


  METHOD transfer_old_style.
    LOOP AT it_input_values ASSIGNING FIELD-SYMBOL(<value>).
      APPEND INITIAL LINE TO rt_result ASSIGNING FIELD-SYMBOL(<new_line>).
      <new_line>-id        = sy-tabix.
      <new_line>-firstname = <value>-forename.
      <new_line>-lastname  = <value>-surname.
    ENDLOOP.
  ENDMETHOD.

  METHOD transfer_new_style.
    rt_result = VALUE #( FOR <value> IN it_input_values
                             INDEX INTO lv_index
                             ( id        = lv_index
                               firstname = <value>-forename
                               lastname  = <value>-surname ) ).
  ENDMETHOD.


  METHOD extract_actors_old_style.
    DATA lv_index TYPE i.

    LOOP AT it_input_values ASSIGNING FIELD-SYMBOL(<value>).
      lv_index = sy-tabix.
      IF actor_is_special( <value> ).
        APPEND INITIAL LINE TO rt_result ASSIGNING FIELD-SYMBOL(<new_line>).
        <new_line>-id        = lv_index.
        <new_line>-firstname = <value>-forename.
        <new_line>-lastname  = <value>-surname.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD extract_actors_cond_value.
    rt_result = VALUE #( FOR <value> IN it_input_values
                            INDEX INTO lv_index
                            LET new_line = VALUE ts_name_record( id = lv_index firstname = <value>-forename lastname = <value>-surname  )
                            IN
                            ( COND #( WHEN actor_is_special( <value> )
                                        THEN new_line ) ) ) .
  ENDMETHOD.

  METHOD extract_actors_new_style.
    rt_result = VALUE #( FOR <value> IN it_input_values
                            INDEX INTO lv_index
                            ( LINES OF COND #( WHEN actor_is_special( <value> )
                                                  THEN VALUE #( ( id = lv_index firstname = <value>-forename lastname = <value>-surname ) ) ) ) ).
  ENDMETHOD.

  METHOD actor_is_special.
    rv_result = xsdbool( is_value-surname = |Connery| OR
                         is_value-surname = |Moore|   OR
                         is_value-surname = |Craig| ).
  ENDMETHOD.


  METHOD fizzbuzz.
    rt_result = VALUE stringtab( FOR i = iv_start WHILE i <= iv_end
                                 ( COND #( WHEN i MOD 5 = 0 AND i MOD 3 = 0 THEN |FizzBuzz|
                                           WHEN i MOD 5 = 0 THEN |Buzz|
                                           WHEN i MOD 3 = 0 THEN |Fizz|
                                           ELSE |{ i }| ) ) ).
  ENDMETHOD.

ENDCLASS.

CLASS ltc_value_examples DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO lcl_value_example.

    METHODS setup.
    METHODS simple_value_expression  FOR TESTING.

    METHODS seven_lines_old_style    FOR TESTING.
    METHODS seven_lines_with_value   FOR TESTING.

    METHODS transfer_value_old_style FOR TESTING.
    METHODS transfer_value_new_style FOR TESTING.

    METHODS extract_values_old_style FOR TESTING.
    METHODS value_with_lines_of      FOR TESTING.
    METHODS value_cond_wrong_way     FOR TESTING.

    METHODS short_fizzbuzz_till_30   FOR TESTING.

ENDCLASS.

CLASS ltc_value_examples IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD simple_value_expression.
    DATA(lt_expected_result) = VALUE stringtab( ( |James| )
                                                ( |Bond|  ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_result
        act = mo_cut->simple_value( ) ).
  ENDMETHOD.

  METHOD seven_lines_old_style.
    DATA(lt_expected_result) = VALUE stringtab( ( |zeile 1| )
                                                ( |zeile 2| )
                                                ( |zeile 3| )
                                                ( |zeile 4| )
                                                ( |zeile 5| )
                                                ( |zeile 6| )
                                                ( |zeile 7| ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_result
        act = mo_cut->seven_lines_old_style( ) ).
  ENDMETHOD.

  METHOD seven_lines_with_value.
    DATA(lt_expected_result) = VALUE stringtab( ( |zeile 1| )
                                                ( |zeile 2| )
                                                ( |zeile 3| )
                                                ( |zeile 4| )
                                                ( |zeile 5| )
                                                ( |zeile 6| )
                                                ( |zeile 7| ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_result
        act = mo_cut->seven_lines_new_style( ) ).
  ENDMETHOD.


  METHOD transfer_value_old_style.
    DATA(lt_input_values) = VALUE lcl_value_example=>tt_names( ( forename = |Sean|    surname = |Connery| )
                                                               ( forename = |George|  surname = |Lazenby| )
                                                               ( forename = |Roger|   surname = |Moore| )
                                                               ( forename = |Timothy| surname = |Dalton| )
                                                               ( forename = |Pierce|  surname = |Brosnan| )
                                                               ( forename = |Daniel|  surname = |Craig| ) ).

    DATA(lt_expected_values) = VALUE lcl_value_example=>tt_name_records( ( id = 1 firstname = |Sean|    lastname = |Connery| )
                                                                         ( id = 2 firstname = |George|  lastname = |Lazenby| )
                                                                         ( id = 3 firstname = |Roger|   lastname = |Moore| )
                                                                         ( id = 4 firstname = |Timothy| lastname = |Dalton| )
                                                                         ( id = 5 firstname = |Pierce|  lastname = |Brosnan| )
                                                                         ( id = 6 firstname = |Daniel|  lastname = |Craig| ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_values
        act = mo_cut->transfer_old_style( lt_input_values ) ).
  ENDMETHOD.

  METHOD transfer_value_new_style.
    DATA(lt_input_values) = VALUE lcl_value_example=>tt_names( ( forename = |Sean|    surname = |Connery| )
                                                               ( forename = |George|  surname = |Lazenby| )
                                                               ( forename = |Roger|   surname = |Moore| )
                                                               ( forename = |Timothy| surname = |Dalton| )
                                                               ( forename = |Pierce|  surname = |Brosnan| )
                                                               ( forename = |Daniel|  surname = |Craig| ) ).

    DATA(lt_expected_values) = VALUE lcl_value_example=>tt_name_records( ( id = 1 firstname = |Sean|    lastname = |Connery| )
                                                                         ( id = 2 firstname = |George|  lastname = |Lazenby| )
                                                                         ( id = 3 firstname = |Roger|   lastname = |Moore| )
                                                                         ( id = 4 firstname = |Timothy| lastname = |Dalton| )
                                                                         ( id = 5 firstname = |Pierce|  lastname = |Brosnan| )
                                                                         ( id = 6 firstname = |Daniel|  lastname = |Craig| ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_values
        act = mo_cut->transfer_new_style( lt_input_values ) ).
  ENDMETHOD.


  METHOD extract_values_old_style.
    DATA(lt_input_values) = VALUE lcl_value_example=>tt_names( ( forename = |Sean|    surname = |Connery| )
                                                               ( forename = |George|  surname = |Lazenby| )
                                                               ( forename = |Roger|   surname = |Moore| )
                                                               ( forename = |Timothy| surname = |Dalton| )
                                                               ( forename = |Pierce|  surname = |Brosnan| )
                                                               ( forename = |Daniel|  surname = |Craig| ) ).
    "Only actors with more than 4 movies
    DATA(lt_expected_values) = VALUE lcl_value_example=>tt_name_records( ( id = 1 firstname = |Sean|   lastname = |Connery| )
                                                                         ( id = 3 firstname = |Roger|  lastname = |Moore| )
                                                                         ( id = 6 firstname = |Daniel| lastname = |Craig| ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_values
        act = mo_cut->extract_actors_old_style( lt_input_values ) ).
  ENDMETHOD.

  METHOD value_cond_wrong_way.
    DATA(lt_input_values) = VALUE lcl_value_example=>tt_names( ( forename = |Sean|    surname = |Connery| )
                                                               ( forename = |George|  surname = |Lazenby| )
                                                               ( forename = |Roger|   surname = |Moore| )
                                                               ( forename = |Timothy| surname = |Dalton| )
                                                               ( forename = |Pierce|  surname = |Brosnan| )
                                                               ( forename = |Daniel|  surname = |Craig| ) ).
    "Only actors with more than 4 movies
    DATA(lt_expected_values) = VALUE lcl_value_example=>tt_name_records( ( id = 1 firstname = |Sean|   lastname = |Connery| )
                                                                         ( )
                                                                         ( id = 3 firstname = |Roger|  lastname = |Moore| )
                                                                         ( )
                                                                         ( )
                                                                         ( id = 6 firstname = |Daniel| lastname = |Craig| ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_values
        act = mo_cut->extract_actors_cond_value( lt_input_values ) ).
  ENDMETHOD.

  METHOD value_with_lines_of.
    DATA(lt_input_values) = VALUE lcl_value_example=>tt_names( ( forename = |Sean|    surname = |Connery| )
                                                               ( forename = |George|  surname = |Lazenby| )
                                                               ( forename = |Roger|   surname = |Moore| )
                                                               ( forename = |Timothy| surname = |Dalton| )
                                                               ( forename = |Pierce|  surname = |Brosnan| )
                                                               ( forename = |Daniel|  surname = |Craig| ) ).
    "Only actors with more than 4 movies
    DATA(lt_expected_values) = VALUE lcl_value_example=>tt_name_records( ( id = 1 firstname = |Sean|   lastname = |Connery| )
                                                                         ( id = 3 firstname = |Roger|  lastname = |Moore| )
                                                                         ( id = 6 firstname = |Daniel| lastname = |Craig| ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_values
        act = mo_cut->extract_actors_new_style( lt_input_values ) ).
  ENDMETHOD.

  METHOD short_fizzbuzz_till_30.
    DATA(lt_expected_values) = VALUE stringtab( ( |1| )    ( |2| )    ( |Fizz| ) ( |4| )    ( |Buzz| )
                                                ( |Fizz| ) ( |7| )    ( |8| )    ( |Fizz| ) ( |Buzz| )
                                                ( |11| )   ( |Fizz| ) ( |13| )   ( |14| )   ( |FizzBuzz| )
                                                ( |16| )   ( |17| )   ( |Fizz| ) ( |19| )   ( |Buzz| )
                                                ( |Fizz| ) ( |22| )   ( |23| )   ( |Fizz| ) ( |Buzz| )
                                                ( |26| )   ( |Fizz| ) ( |28| )   ( |29| )   ( |FizzBuzz| ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_values
        act = mo_cut->fizzbuzz( iv_start = 1 iv_end   = 30 ) ).

  ENDMETHOD.

ENDCLASS.
