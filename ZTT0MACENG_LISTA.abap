*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_LISTA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTT0MACENG_LISTA LINE-SIZE 64.

WRITE:
  sy-vline,
  2(15)'MARCA',
  sy-vline,
  19(20)'MODELO',
  sy-vline,
  41(10)'ANO',
  sy-vline,
  53(10)'Cor',
  sy-vline,
  sy-uline.

WRITE:
  sy-vline,
  2(15)'Chevrolet',
  sy-vline,
  19(20)'Sedan',
  sy-vline,
  41(10)'2004',
  sy-vline,
  53(10)'Vermelho' COLOR COL_NEGATIVE,
  sy-vline,
  sy-uline.