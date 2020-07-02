*&---------------------------------------------------------------------*
*& Report ymbh_test_scripts
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ymbh_test_scripts.
START-OF-SELECTION.

CONSTANTS : lv_string TYPE char40 VALUE 'we%123456789 gift%happy birthday',
            lv_c1     TYPE char03 VALUE 'we%',
            lv_c2     TYPE char05 VALUE 'gift%'.

DATA: str1 TYPE string,
      str2 TYPE string,
      s1   TYPE string,
      s2   TYPE string,
      s3   TYPE string,
      s4   TYPE string.


SPLIT : lv_string AT ' ' INTO str1 str2,
        str1 AT lv_c1 INTO s1 s2,
        str2 AT lv_c2 INTO s3 s4.

WRITE:/ str1.
WRITE:/ str2.
WRITE:/ s1.
WRITE:/ s2.
WRITE:/ s3.
WRITE:/ s4.
