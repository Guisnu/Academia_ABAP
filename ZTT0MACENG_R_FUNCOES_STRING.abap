REPORT ztt0maceng_r_funcoes_string NO STANDARD PAGE HEADING MESSAGE-ID ZTT0MACENG_CM_REPORT.

*00000000000
*00.000.000/0000-00

PARAMETERS: p_regis TYPE c LENGTH 18.

START-OF-SELECTION.

  DATA: vl_result TYPE string.
  DATA: vl_strlen TYPE i.
  vl_strlen = strlen( p_regis ).

  TRANSLATE p_regis USING '. '.
  TRANSLATE p_regis USING '- '.
  TRANSLATE p_regis USING '/ '.
  CONDENSE p_regis NO-GAPS.

  IF vl_strlen = 11.
    CONCATENATE 'PF:' p_regis INTO vl_result SEPARATED BY space.
    WRITE vl_result.

  ELSEIF vl_strlen = 14.
    CONCATENATE 'PJ:' p_regis INTO vl_result SEPARATED BY space.
    WRITE: vl_result.

  ELSE.
    MESSAGE s004 WITH p_regis DISPLAY LIKE 'E'.
  ENDIF.