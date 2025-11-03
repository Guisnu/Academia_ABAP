REPORT ztt0maceng_r_vendas_sum_incld NO STANDARD PAGE HEADING MESSAGE-ID ZTT0MACENG_CM_REPORT.

INCLUDE ztt0maceng_tm_vd_top.
INCLUDE ztt0maceng_tm_vd_s01.
INCLUDE ztt0maceng_tm_vd_f01.

START-OF-SELECTION.

PERFORM carrega_dados.

  IF <alv> IS ASSIGNED.
    PERFORM zf_alv.
  ENDIF.