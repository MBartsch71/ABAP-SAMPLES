REPORT ymbh_factory_pattern_sample.


CLASS lcl_ophandler DEFINITION ABSTRACT.
  PUBLIC SECTION.
    CLASS-METHODS factory
      IMPORTING iv_output_type   TYPE char10
      RETURNING
                VALUE(ro_object) TYPE REF TO lcl_ophandler.

    METHODS process_output ABSTRACT.

ENDCLASS.

CLASS lcl_ophandler_abc DEFINITION INHERITING FROM lcl_ophandler.
  PUBLIC SECTION.
    METHODS process_output REDEFINITION.
ENDCLASS.

CLASS lcl_ophandler_abc IMPLEMENTATION.

  METHOD process_output.
    WRITE / 'Processing ABC'.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_ophandler_xyz DEFINITION INHERITING FROM lcl_ophandler.
  PUBLIC SECTION.
    METHODS process_output REDEFINITION.
ENDCLASS.

CLASS lcl_ophandler_xyz IMPLEMENTATION.

  METHOD process_output.
    WRITE / 'Processing XYZ'.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_ophandler IMPLEMENTATION.

  METHOD factory.
    ro_object = SWITCH #( iv_output_type WHEN 'ABC' THEN NEW lcl_ophandler_abc( )
                                         WHEN 'XYZ' THEN NEW lcl_ophandler_xyz( ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS run.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION.

  METHOD run.
    DATA(lo_handler) = lcl_ophandler=>factory( 'ABC' ).
    lo_handler->process_output( ).

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA(lo_main) = NEW lcl_main( ).
  lo_main->run( ).
