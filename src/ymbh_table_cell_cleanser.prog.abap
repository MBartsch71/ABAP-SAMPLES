REPORT ymbh_table_cell_cleanser.

CLASS lcl_table_cleanser DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES: BEGIN OF table_cell,
             col1 TYPE char10,
             col2 TYPE char10,
             col3 TYPE char10,
             col4 TYPE char10,
           END OF table_cell.
    TYPES table_cells TYPE STANDARD TABLE OF table_cell WITH EMPTY KEY.

    METHODS process_table IMPORTING input_values  TYPE lcl_table_cleanser=>table_cells
                          RETURNING VALUE(result) TYPE lcl_table_cleanser=>table_cells.

ENDCLASS.

CLASS lcl_table_cleanser IMPLEMENTATION.

  METHOD process_table.
    result = input_values.
    LOOP AT result ASSIGNING FIELD-SYMBOL(<result_line>).
      CHECK sy-tabix > 1.
      IF <result_line>-col1 = result[ sy-tabix - 1 ]-col1.
        CLEAR <result_line>-col1.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.


CLASS ltc_table_cleanser DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA cut TYPE REF TO lcl_table_cleanser.
    METHODS delete_value_inline_two FOR TESTING.
ENDCLASS.


CLASS ltc_table_cleanser IMPLEMENTATION.

  METHOD delete_value_inline_two.
    cut = NEW #( ).
    DATA(lt_input_values) = VALUE lcl_table_cleanser=>table_cells(
                                        ( col1 = 'a' col2 = 'b' col3 = 'c' col4 = 'd' )
                                        ( col1 = 'a' col2 = 'c' col3 = 'b' col4 = '1' )
                                        ( col1 = '1' col2 = 'b' col3 = 'c' col4 = '1' ) ).

    DATA(lt_expected_values) = VALUE lcl_table_cleanser=>table_cells(
                                        ( col1 = 'a' col2 = 'b' col3 = 'c' col4 = 'd' )
                                        ( col1 = ''  col2 = 'c' col3 = 'b' col4 = '1' )
                                        ( col1 = '1' col2 = 'b' col3 = 'c' col4 = '1' ) ).

    cl_abap_unit_assert=>assert_equals(
        exp = lt_expected_values
        act = cut->process_table( lt_input_values ) ).
  ENDMETHOD.

ENDCLASS.
