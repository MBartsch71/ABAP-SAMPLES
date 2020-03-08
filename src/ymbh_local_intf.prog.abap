REPORT ymbh_local_intf.

INTERFACE lif_friend.
ENDINTERFACE.

CLASS lcl_printing DEFINITION FRIENDS lif_friend.
  PRIVATE SECTION.
    METHODS build_header_line
      IMPORTING
        iv_name        TYPE string
      RETURNING
        VALUE(rv_line) TYPE string.
ENDCLASS.

CLASS lcl_printing IMPLEMENTATION.
  METHOD build_header_line.
    rv_line = |Hello { iv_name }.|.
  ENDMETHOD.
ENDCLASS.

CLASS ltc_printing DEFINITION FOR TESTING
    DURATION SHORT
  RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    INTERFACES lif_friend.
  PRIVATE SECTION.
    METHODS receive_proper_header_line FOR TESTING.
ENDCLASS.

CLASS ltc_printing IMPLEMENTATION.
  METHOD receive_proper_header_line.
    DATA(lo_cut) = NEW lcl_printing( ).
    cl_abap_unit_assert=>assert_equals(
        msg = 'The expected line should be returned.'
        exp = |Hello Dude.|
        act = lo_cut->build_header_line( |Dude| ) ).
  ENDMETHOD.
ENDCLASS.
