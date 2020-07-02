REPORT ymbh_factory_method_sample.

INTERFACE lif_person.
  METHODS shout_out
    RETURNING
      VALUE(rv_phrase) TYPE string.
ENDINTERFACE.

CLASS lcl_policeman DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_person.

ENDCLASS.

CLASS lcl_policeman IMPLEMENTATION.

  METHOD lif_person~shout_out.
    rv_phrase = |Shoot first, then ask.|.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_rebel DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_person.

ENDCLASS.

CLASS lcl_rebel IMPLEMENTATION.

  METHOD lif_person~shout_out.
    rv_phrase = |ACAB, Black lives matter.|.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_person DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS create_person
      IMPORTING
        iv_person        TYPE string
      RETURNING
        VALUE(ro_person) TYPE REF TO lif_person.
ENDCLASS.
CLASS lcl_person IMPLEMENTATION.

  METHOD create_person.
    ro_person = SWITCH #( iv_person WHEN 'COP' THEN NEW lcl_policeman( )
                                    WHEN 'REBEL' THEN NEW lcl_rebel( ) ).
  ENDMETHOD.

ENDCLASS.


START-OF-SELECTION.

  WRITE / lcl_person=>create_person( |COP| )->shout_out( ).
  WRITE / lcl_person=>create_person( |REBEL| )->shout_out( ).
