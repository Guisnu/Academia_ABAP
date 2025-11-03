REPORT ZTT0MACENG_R_DOWNLOAD.

START-OF-SELECTION.
*BREAK-POINT.
PERFORM zf_download.

*/usr/sap/trans/Guilherme_Top_Talents.txt

*&---------------------------------------------------------------------*
*& Form zf_download                                                    *
*&---------------------------------------------------------------------*
FORM zf_download .
  DATA: vl_arq    TYPE string.
  DATA: tl_line   TYPE STANDARD TABLE OF string.
  DATA: vl_target TYPE string.

  vl_target = '/usr/sap/trans/Guilherme_Top_Talents.txt'.

  CLEAR tl_line.
  APPEND 'Linha 1' TO tl_line.
  APPEND 'Linha 2' TO tl_line.
  APPEND 'Linha 3' TO tl_line.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
*     BIN_FILESIZE                    =
     filename                        = vl_target
     FILETYPE                        = 'ASC'
*   IMPORTING
*     FILELENGTH                      =
    tables
      data_tab                        = tl_line
   EXCEPTIONS
     FILE_WRITE_ERROR                = 1
     NO_BATCH                        = 2
     GUI_REFUSE_FILETRANSFER         = 3
     INVALID_TYPE                    = 4
     NO_AUTHORITY                    = 5
     UNKNOWN_ERROR                   = 6
     HEADER_NOT_ALLOWED              = 7
     SEPARATOR_NOT_ALLOWED           = 8
     FILESIZE_NOT_ALLOWED            = 9
     HEADER_TOO_LONG                 = 10
     DP_ERROR_CREATE                 = 11
     DP_ERROR_SEND                   = 12
     DP_ERROR_WRITE                  = 13
     UNKNOWN_DP_ERROR                = 14
     ACCESS_DENIED                   = 15
     DP_OUT_OF_MEMORY                = 16
     DISK_FULL                       = 17
     DP_TIMEOUT                      = 18
     FILE_NOT_FOUND                  = 19
     DATAPROVIDER_EXCEPTION          = 20
     CONTROL_FLUSH_ERROR             = 21
     OTHERS                          = 22
            .
  IF sy-subrc = 0.
    MESSAGE 'Arquivo salvo' TYPE 'S'.
  ELSE.
    MESSAGE |Erro ao salvar arquivo [{ sy-subrc }]| TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.