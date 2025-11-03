*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_R_BLOQUEIO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTT0MACENG_R_BLOQUEIO.

START-OF-SELECTION.

CALL FUNCTION 'ENQUEUE_E_TABLE'
 EXPORTING
*   MODE_RSTABLE       = 'E'
   TABNAME            = 'ZTT0MACENG_TM_TR'
*   VARKEY             =
*   X_TABNAME          = ' '
*   X_VARKEY           = ' '
*   _SCOPE             = '3'
*   _SYNCHRON          = ' '
*   _COLLECT           = ' '
          .
BREAK-POINT.