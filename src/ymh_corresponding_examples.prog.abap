REPORT ymh_corresponding_examples.




##TODO "- Corresponding simple
"- Corresponding with mapping
"- Corresponding with mapping and except
"- Corresponding with BASE
"- Corresponding with DEEP

CLASS lcl_corresponding_example DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_actors,
             id        TYPE i,
             firstname TYPE text20,
             lastname  TYPE text30,
           END OF ts_actors.
    TYPES tt_actors TYPE STANDARD TABLE OF ts_actors WITH EMPTY KEY.

    METHODS simple_corresponding RETURNING VALUE(rt_result) TYPE tt_actors.


ENDCLASS.

CLASS lcl_corresponding_example IMPLEMENTATION.


  METHOD simple_corresponding.

  ENDMETHOD.

ENDCLASS.

CLASS ltc_corresponding_example DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO lcl_corresponding_example.

    METHODS setup.
    METHODS simple_corresponding FOR TESTING.

ENDCLASS.


CLASS ltc_corresponding_example IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD simple_corresponding.
    DATA(lt_expected_values) = VALUE lcl_corresponding_example=>tt_actors( ( id = 1 firstname = |Sean|   lastname = |Connery| )
                                                                           ( id = 2 firstname = |Pierce| lastname = |Brosnan| )
                                                                           ( id = 3 firstname = |Daniel| lastname = |Craig| ) ).
    data(lt_input_values) = value lcl_corresponding_example=>tt_actors( ( ) ).
    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_values
        act = mo_cut->simple_corresponding( ) ).
  ENDMETHOD.

ENDCLASS.
