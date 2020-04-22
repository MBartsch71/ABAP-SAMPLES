REPORT ymbh_right_bicep.

CLASS lcl_bicep DEFINITION.
  PUBLIC SECTION.
    METHODS arithmetic_mean_of_2_numbers
      IMPORTING
        iv_number_1          TYPE i
        iv_number_2          TYPE i
      RETURNING
        VALUE(rv_arith_mean) TYPE i.

    METHODS read_7th_char_of_string
      IMPORTING
        iv_string      TYPE string
      RETURNING
        VALUE(rv_char) TYPE char1
      RAISING
        cx_sy_range_out_of_bounds.
    METHODS square_root
      IMPORTING
        iv_number        TYPE i
      RETURNING
        VALUE(rv_result) TYPE i.
ENDCLASS.

CLASS lcl_bicep IMPLEMENTATION.

  METHOD arithmetic_mean_of_2_numbers.
    rv_arith_mean = ( iv_number_1 + iv_number_2 ) / 2.
  ENDMETHOD.


  METHOD read_7th_char_of_string.
    rv_char = iv_string+6(1).
  ENDMETHOD.

  METHOD square_root.
    rv_result = sqrt( iv_number ).
  ENDMETHOD.

ENDCLASS.

CLASS ltc_right_result DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut   TYPE REF TO lcl_bicep.
    DATA mx_error TYPE REF TO cx_sy_conversion_no_number.

    METHODS setup.
    METHODS right_compute_correct_answers  FOR TESTING.
    METHODS b_excption_boundary_invld_vals FOR TESTING.
    METHODS b_exception_at_offset_overflow FOR TESTING.
    METHODS i_check_inverse_calcuation     FOR TESTING.

ENDCLASS.


CLASS ltc_right_result IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW lcl_bicep( ).
  ENDMETHOD.

  METHOD right_compute_correct_answers.
    DATA(lo_cut) = NEW lcl_bicep( ).
    cl_abap_unit_assert=>assert_equals(
        exp = 6
        act = lo_cut->arithmetic_mean_of_2_numbers( iv_number_1 = 7 iv_number_2 = 5 ) ).
  ENDMETHOD.

  METHOD b_excption_boundary_invld_vals.
    DATA(lo_cut) = NEW lcl_bicep( ).
    TRY.
        DATA(lv_mean) = lo_cut->arithmetic_mean_of_2_numbers( iv_number_1 = CONV #( 'X' )
                                                              iv_number_2 = 10 ).
      CATCH cx_sy_conversion_no_number INTO mx_error.
    ENDTRY.

    cl_abap_unit_assert=>assert_bound(
        act = mx_error
        msg = |An exception should be raised| ).
  ENDMETHOD.

  METHOD b_exception_at_offset_overflow.
    TRY.
        DATA(lv_char) = mo_cut->read_7th_char_of_string( |Teting| ).
      CATCH cx_sy_range_out_of_bounds INTO DATA(lx_string_error).
    ENDTRY.

    cl_abap_unit_assert=>assert_bound(
        act = lx_string_error
        msg = |An exception should be raised| ).

  ENDMETHOD.

  METHOD i_check_inverse_calcuation.
    DATA(lv_result) = mo_cut->square_root( 256 ).
    cl_abap_unit_assert=>assert_equals(
        exp = 256
        act = lv_result * lv_result ).
  ENDMETHOD.

ENDCLASS.
