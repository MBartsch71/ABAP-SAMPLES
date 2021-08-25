REPORT ymbh_filter_example.

CLASS lcl_filter_example DEFINITION FINAL.
  PUBLIC SECTION.
    TYPES tt_sorted_email_addresses TYPE SORTED TABLE OF bapiadsmtp WITH UNIQUE KEY primary_key COMPONENTS e_mail valid_from
    WITH NON-UNIQUE SORTED KEY date_from COMPONENTS valid_from.

    METHODS constructor                IMPORTING it_incoming_email_addresses TYPE tt_sorted_email_addresses
                                                 it_existing_email_addresses TYPE tt_sorted_email_addresses.

    METHODS filter_emails_loop_at      RETURNING VALUE(rt_result) TYPE tt_sorted_email_addresses.

    METHODS filter_emails_lookup_table RETURNING VALUE(rt_result) TYPE tt_sorted_email_addresses.

    METHODS filter_email_where         RETURNING VALUE(rt_result) TYPE tt_sorted_email_addresses.

  PRIVATE SECTION.
    DATA mt_incoming_email_addresses TYPE tt_sorted_email_addresses.
    DATA mt_existing_email_addresses TYPE tt_sorted_email_addresses.
ENDCLASS.

CLASS lcl_filter_example IMPLEMENTATION.

  METHOD constructor.
    mt_incoming_email_addresses = it_incoming_email_addresses.
    mt_existing_email_addresses = it_existing_email_addresses.
  ENDMETHOD.

  METHOD filter_emails_loop_at.
    LOOP AT mt_incoming_email_addresses ASSIGNING FIELD-SYMBOL(<email_address>).
      READ TABLE mt_existing_email_addresses WITH KEY e_mail = <email_address>-e_mail
                                                      valid_from = <email_address>-valid_from TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        APPEND <email_address> TO rt_result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD filter_emails_lookup_table.
    rt_result = FILTER #( mt_incoming_email_addresses EXCEPT IN mt_existing_email_addresses
                                                      WHERE e_mail = e_mail AND
                                                            valid_from = valid_from ).
  ENDMETHOD.

  METHOD filter_email_where.
    rt_result = FILTER #( mt_existing_email_addresses USING KEY date_from
                                                      WHERE valid_from = CONV #( |19700101| ) ).
  ENDMETHOD.

ENDCLASS.

CLASS ltc_filter_with DEFINITION FINAL FOR TESTING
DURATION SHORT
RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO lcl_filter_example.

    METHODS setup.
    METHODS extract_values_loop_at      FOR TESTING.
    METHODS extract_values_lookup_table FOR TESTING.
    METHODS extract_values_filter_where FOR TESTING.

ENDCLASS.

CLASS ltc_filter_with IMPLEMENTATION.

  METHOD setup.
    DATA(lt_incoming_email_addresses) = VALUE lcl_filter_example=>tt_sorted_email_addresses( ( e_mail     = |james.bond@mi6.com|
                                                                                               valid_from = |19700101| )
                                                                                             ( e_mail     = |q.tinkerer@mi6.com|
                                                                                               valid_from = |20001023| ) ).

    DATA(lt_existing_email_addresses) = VALUE lcl_filter_example=>tt_sorted_email_addresses( ( e_mail     = |james.bond@mi6.com|
                                                                                               valid_from = |19700101| ) ).
    mo_cut = NEW #( it_incoming_email_addresses = lt_incoming_email_addresses
                    it_existing_email_addresses = lt_existing_email_addresses ).

  ENDMETHOD.

  METHOD extract_values_loop_at.
    DATA(lt_expected_emails) = VALUE lcl_filter_example=>tt_sorted_email_addresses( ( e_mail     = |q.tinkerer@mi6.com|
                                                                                      valid_from = |20001023| ) ).

    cl_abap_unit_assert=>assert_equals(
          exp = lt_expected_emails
          act = mo_cut->filter_emails_loop_at( ) ).

  ENDMETHOD.

  METHOD extract_values_lookup_table.
    DATA(lt_expected_emails) = VALUE lcl_filter_example=>tt_sorted_email_addresses( ( e_mail     = |q.tinkerer@mi6.com|
                                                                                      valid_from = |20001023| ) ).

    cl_abap_unit_assert=>assert_equals(
          exp = lt_expected_emails
          act = mo_cut->filter_emails_lookup_table( ) ).

  ENDMETHOD.

  METHOD extract_values_filter_where.
    DATA(lt_expected_emails) = VALUE lcl_filter_example=>tt_sorted_email_addresses( ( e_mail     = |james.bond@mi6.com|
                                                                                      valid_from = |19700101| ) ).
    cl_abap_unit_assert=>assert_equals(
    exp = lt_expected_emails
    act = mo_cut->filter_email_where( ) ).
  ENDMETHOD.

ENDCLASS.
