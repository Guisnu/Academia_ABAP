*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_R_REPORTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztt0maceng_r_reports MESSAGE-ID ztt0maceng_cm_report.

START-OF-SELECTION.

  DATA: vl_msg TYPE STRING.

* WITH PARA SUBSTITUIR O &
  MESSAGE s000 WITH 'Ola' 'tudo bem?'.

  MESSAGE s000 WITH 'Ola' 'tudo bem?' DISPLAY LIKE 'E'.

  MESSAGE s001 WITH sy-uname INTO vl_msg.

  WRITE: vl_msg.

  Write: / 'Ola, Tudo bem?'(q01).
  Write: /'Ola, beleza?'(q02).