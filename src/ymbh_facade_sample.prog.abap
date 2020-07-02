REPORT ymbh_facade_sample.


CLASS lcl_cpu DEFINITION.
  PUBLIC SECTION.
    METHODS excecute_program
      IMPORTING
        iv_program       TYPE string
      RETURNING
        VALUE(rv_result) TYPE string.

ENDCLASS.

CLASS lcl_cpu IMPLEMENTATION.

  METHOD excecute_program.
    rv_result = |Program { iv_program } executed without error.|.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_memory DEFINITION.
  PUBLIC SECTION.
    METHODS store_value
      IMPORTING
        iv_value         TYPE string
        iv_address       TYPE i
      RETURNING
        VALUE(rv_result) TYPE string.

    METHODS read_value
      IMPORTING
        iv_address      TYPE i
      RETURNING
        VALUE(rv_value) TYPE string.

  PRIVATE SECTION.
    DATA mv_value TYPE string.
ENDCLASS.

CLASS lcl_memory IMPLEMENTATION.

  METHOD read_value.
    rv_value = mv_value.
  ENDMETHOD.

  METHOD store_value.
    mv_value = iv_value.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_hard_disk DEFINITION.
  PUBLIC SECTION.
    METHODS read_from_disk
      IMPORTING
        iv_sector       TYPE i
      RETURNING
        VALUE(rv_value) TYPE string.

ENDCLASS.

CLASS lcl_hard_disk IMPLEMENTATION.

  METHOD read_from_disk.
    rv_value = 'Fahrrad'.
  ENDMETHOD..

ENDCLASS.

CLASS lcl_computer_facade DEFINITION.
  PUBLIC SECTION.


    METHODS constructor.
    METHODS start.
  PRIVATE SECTION.
    DATA mo_cpu       TYPE REF TO lcl_cpu.
    DATA mo_memory    TYPE REF TO lcl_memory.
    DATA mo_hard_disk TYPE REF TO lcl_hard_disk.

ENDCLASS.

CLASS lcl_computer_facade IMPLEMENTATION.

  METHOD constructor.
    mo_cpu       = NEW lcl_cpu( ).
    mo_memory    = NEW lcl_memory( ).
    mo_hard_disk = NEW lcl_hard_disk( ).
  ENDMETHOD.

  METHOD start.
    DATA(lv_value_to_store) = mo_hard_disk->read_from_disk( 1 ).
    WRITE / |Read value from Hard Disk: { lv_value_to_store }|.
    DATA(lv_value_stored_in_memory) = mo_memory->store_value( iv_address = 1
                                                              iv_value = lv_value_to_store ).
    WRITE / |Store value: { lv_value_stored_in_memory } in Memory at Address: 1|.
    DATA(lv_result) = mo_cpu->excecute_program( 'BERECHNE_PI' ).
    DATA(lv_calculated_value) = mo_memory->read_value( 1 ).
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA(lo_computer) = NEW lcl_computer_facade( ).
  lo_computer->start( ).
