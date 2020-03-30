REPORT ymbh_abstract_class.

CLASS lcl_ticket DEFINITION ABSTRACT.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        location TYPE string
        name     TYPE string
        price    TYPE f.

    METHODS calculate_ticket_price ABSTRACT.
    METHODS print_ticket_data.
    METHODS build_ticket_data.
    METHODS get_ticket_data
      RETURNING
        VALUE(r_result) TYPE string.

  PROTECTED SECTION.

    DATA ticket_data    TYPE string.
    DATA base_price     TYPE i.
    DATA ticket_price   TYPE i.

  PRIVATE SECTION.
    DATA event_location TYPE string.
    DATA event_name     TYPE string.

ENDCLASS.

CLASS lcl_ticket IMPLEMENTATION.

  METHOD constructor.
    event_location = location.
    event_name     = name.
    base_price     = price.
  ENDMETHOD.

  METHOD print_ticket_data.
    build_ticket_data( ).
    cl_demo_output=>display_text( ticket_data ).
  ENDMETHOD.

  METHOD build_ticket_data.
    ticket_data = |Eventort: { event_location }\n|.
    ticket_data = |{ ticket_data }Eventname: { event_name }\n|.
    ticket_data = |{ ticket_data }Ticketpreis: CHF { ticket_price }|.
  ENDMETHOD.

  METHOD get_ticket_data.
    r_result = ticket_data.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_sport_ticket DEFINITION INHERITING FROM lcl_ticket.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        location TYPE string
        name     TYPE string
        price    TYPE f
        level    TYPE i.
    METHODS calculate_ticket_price REDEFINITION.

  PRIVATE SECTION.
    DATA cup_level TYPE i.

ENDCLASS.

CLASS lcl_sport_ticket IMPLEMENTATION.

  METHOD constructor.
    super->constructor( location = location
                        name     = name
                        price    = price ).
    cup_level = level.
  ENDMETHOD.

  METHOD calculate_ticket_price.
    ticket_price = base_price + ( 10 * cup_level ).
  ENDMETHOD.

ENDCLASS.

CLASS ltc_sport_ticket DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS build_valid_ticket_data FOR TESTING.

ENDCLASS.


CLASS ltc_sport_ticket IMPLEMENTATION.

  METHOD build_valid_ticket_data.
    DATA(check_data) = |Eventort: Berlin\nEventname: DFB Pokal\nTicketpreis: CHF 90|.
    DATA(cut) = NEW lcl_sport_ticket( location = |Berlin|
                                      name     = |DFB Pokal|
                                      price    = 20
                                      level    = 7 ).
    cut->calculate_ticket_price( ).
    cut->build_ticket_data( ).
    cl_abap_unit_assert=>assert_equals(
        exp = check_data
        act = cut->get_ticket_data( ) ).
  ENDMETHOD.

ENDCLASS.


CLASS lcl_concert_ticket DEFINITION INHERITING FROM lcl_ticket.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        location TYPE string
        name     TYPE string
        price    TYPE f
        row      TYPE i.

    METHODS calculate_ticket_price REDEFINITION.

  PRIVATE SECTION.
    DATA seat_row TYPE i.

ENDCLASS.

CLASS lcl_concert_ticket IMPLEMENTATION.

  METHOD constructor.
    super->constructor( location = location
                        name     = name
                        price    = price ).
    seat_row = row.
  ENDMETHOD.

  METHOD calculate_ticket_price.
    DATA additions TYPE f.
    additions =  1 + ( 1 / seat_row ).
    ticket_price = base_price * additions.
  ENDMETHOD.

ENDCLASS.

CLASS ltc_concert_ticket DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS build_valid_ticket_data FOR TESTING.

ENDCLASS.


CLASS ltc_concert_ticket IMPLEMENTATION.

  METHOD build_valid_ticket_data.
    DATA(check_data) = |Eventort: Zürich\nEventname: Metallica - Hardwired Tour\nTicketpreis: CHF 114|.
    DATA(cut) = NEW lcl_concert_ticket( location = |Zürich|
                                        name     = |Metallica - Hardwired Tour|
                                        price    = 100
                                        row      = 7 ).
    cut->calculate_ticket_price( ).
    cut->build_ticket_data( ).
    cl_abap_unit_assert=>assert_equals(
        exp = check_data
        act = cut->get_ticket_data( ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS run.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION.

  METHOD run.
    DATA(sport_ticket) = NEW lcl_sport_ticket(
      location = |Luzern|
      name     = |SuperLigue|
      price    = 10
      level    = 7 ).
    sport_ticket->calculate_ticket_price( ).
    sport_ticket->print_ticket_data( ).

    DATA(concert_ticket) = NEW lcl_concert_ticket(
      location = |Zürich|
      name     = |System of a down|
      price    = 90
      row      = 5 ).
    concert_ticket->calculate_ticket_price( ).
    concert_ticket->print_ticket_data( ).

  ENDMETHOD.

ENDCLASS.


START-OF-SELECTION.
  DATA(main) = NEW lcl_main( ).
  main->run( ).
