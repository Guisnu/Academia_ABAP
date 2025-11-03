*&---------------------------------------------------------------------*
*& Include          ZTT0MACENG_TM_VD_TOP1
*&---------------------------------------------------------------------*
*--------------------------------------------------------------------*
*Declarações globais                                                 *
*--------------------------------------------------------------------*
TABLES: but000, lfa1, kna1.

TYPES: ty_titulo TYPE c LENGTH 20.

TYPES: BEGIN OF ty_s_vend_link,
         partner_guid TYPE cvi_vend_link-partner_guid, "Business Partner GUID
         vendor       TYPE cvi_vend_link-vendor, "Account Number of Supplier
       END   OF ty_s_vend_link.

TYPES: BEGIN OF ty_s_cust_link,
         partner_guid TYPE cvi_cust_link-partner_guid, "Business Partner GUID
         customer     TYPE cvi_cust_link-customer, "Customer Number
       END   OF ty_s_cust_link.

TYPES: BEGIN OF ty_s_but000,
         partner      TYPE but000-partner, "Business Partner Number
         partner_guid TYPE but000-partner_guid, "Business Partner GUID
       END   OF ty_s_but000.

TYPES: BEGIN OF ty_s_adr6,
             addrnumber type adr6-addrnumber, "Address Number
             smtp_addr  type adr6-smtp_addr, "E-Mail Address
           END   OF ty_s_adr6.

TYPES: BEGIN OF ty_s_lfa1,
         lifnr TYPE lfa1-lifnr, "Código do Fornecedor
         name1 TYPE lfa1-name1, "Nome do Fornecedor
         land1 TYPE lfa1-land1, "Pais do Fornecedor
         ort01 TYPE lfa1-ort01, "Cidade do Fornecedor
         pstlz TYPE lfa1-pstlz, "Código postal do Fornecedor
         regio TYPE lfa1-regio, "Região do país do Fornecedor
         sortl TYPE lfa1-sortl, "Ajuda de pesquisa para o fornecedor
         stras TYPE lfa1-stras, "Rua do Fornecedor
         mcod1 TYPE lfa1-mcod1, "Nome do Fornecedor Reduzido
         mcod3 TYPE lfa1-mcod1, "Nome do Fornecedor Reduzido
         adrnr TYPE lfa1-adrnr, "Numero do endereço de email
       END OF ty_s_lfa1.

TYPES: BEGIN OF ty_s_kna1,
         kunnr TYPE kna1-kunnr, "Código do cliente
         name1 TYPE kna1-name1, "Nome do cliente
         land1 TYPE kna1-land1, "País do cliente
         ort01 TYPE kna1-ort01, "País do cliente
         pstlz TYPE kna1-pstl2, "Código postal do cliente
         regio TYPE kna1-regio, "Região do País do cliente
         sortl TYPE kna1-sortl, "Ajuda de Pesquisa para o cliente
         stras TYPE kna1-stras, "Rua do cliente
         mcod1 TYPE kna1-mcod1, "Nome do cliente reduzido
         mcod3 TYPE kna1-mcod3, "Nome do cliente reduzido
         adrnr TYPE kna1-adrnr, "Numero do endereço de email
       END OF ty_s_kna1.

"Tipos de Tabela
TYPES: ty_t_vend_link       TYPE SORTED      TABLE OF ty_s_vend_link               WITH UNIQUE KEY partner_guid,
       ty_t_cust_link       TYPE SORTED      TABLE OF ty_s_cust_link               WITH UNIQUE KEY partner_guid,
       ty_t_but000          TYPE SORTED      TABLE OF ty_s_but000                  WITH UNIQUE KEY partner_guid,
       ty_t_lfa1            TYPE SORTED      TABLE OF ty_s_lfa1                    WITH UNIQUE KEY lifnr,
       ty_t_kna1            TYPE SORTED      TABLE OF ty_s_kna1                    WITH UNIQUE KEY kunnr,
       ty_t_adr6            TYPE SORTED      TABLE OF ty_s_adr6                    WITH UNIQUE KEY addrnumber,
       ty_t_parceiro_alv    TYPE STANDARD    TABLE OF ztt0maceng_s_parceiros_alv   WITH NON-UNIQUE KEY partner status kunnr,
       ty_t_fornecedor_alv  TYPE STANDARD    TABLE OF ztt0maceng_s_fornecedor_alv  WITH NON-UNIQUE KEY lifnr partner,
       ty_t_cliente_alv     TYPE STANDARD    TABLE OF ztt0maceng_s_cliente_alv     WITH NON-UNIQUE KEY kunnr partner.

"Tabelas Internas, Work-areas e FIELD-SYMBOLS
DATA: tg_vend_link        TYPE ty_t_vend_link,
      tg_cust_link        TYPE ty_t_cust_link,
      tg_but000           TYPE ty_t_but000,
      tg_lfa1             TYPE ty_t_lfa1,
      tg_kna1             TYPE ty_t_kna1,
      tg_adr6             TYPE ty_t_adr6,
      tg_parceiro_alv     TYPE ty_t_parceiro_alv,
      tg_fornecedores_alv TYPE ty_t_fornecedor_alv,
      tg_cliente_alv      TYPE ty_t_cliente_alv.

DATA: tg_fldcat TYPE slis_t_fieldcat_alv.
DATA: wg_fldcat TYPE slis_fieldcat_alv.

DATA: wg_parceiro_alv   TYPE ztt0maceng_s_parceiros_alv,
      wg_fornecedor_alv TYPE ztt0maceng_s_fornecedor_alv,
      wg_cliente_alv    TYPE ztt0maceng_s_cliente_alv.

FIELD-SYMBOLS: <alv> TYPE STANDARD TABLE.