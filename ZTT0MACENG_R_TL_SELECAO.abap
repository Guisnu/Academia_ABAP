*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_R_TL_SELECAO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTT0MACENG_R_TL_SELECAO MESSAGE-ID ZTT0SEGURH_CM_REPORT.

PARAMETERS: p_chassi TYPE ztt0maceng_tm_cr-chassi OBLIGATORY,
            p_marca  TYPE ztt0maceng_tm_cr-marca,

            p_cor    RADIOBUTTON GROUP grp1,
            p_modelo RADIOBUTTON GROUP grp1,

            p_leilao AS CHECKBOX,
            p_aran AS CHECKBOX,

            p_placa TYPE c LENGTH 10 LOWER CASE.

SELECT-OPTIONS: s_datum  FOR sy-datum NO INTERVALS.

START-OF-SELECTION.