*&---------------------------------------------------------------------*
*& Report ZTT0MACENG_FUNDAMENTOS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTT0MACENG_FUNDAMENTOS.

Data: vl_nome  TYPE string,
vl_sobrenome   TYPE string,
vl_idade       TYPE i,
vl_peso        TYPE p LENGTH 3 DECIMALS 2,
vl_cidade_nasc TYPE string,
vl_sexualidade TYPE c,
vl_altura      TYPE p LENGTH 2 DECIMALS 2,
vl_data_nasc   TYPE d,
vl_hora_nasc   TYPE t.

vl_nome = 'Guilherme'.
vl_sobrenome = 'Nunes Macena'.
vl_idade = 20.
vl_peso = 80.
vl_cidade_nasc = 'São Paulo'.
vl_sexualidade = 'M'.
vl_altura = '1.75'.
vl_data_nasc = '20040602'.
vl_hora_nasc = sy-uzeit.

WRITE:
/ 'Nome: ', vl_nome, vl_sobrenome,
/ 'Idade: ', vl_idade,
/ 'Peso: ', vl_peso,
/ 'Cidade: ', vl_cidade_nasc,
/ 'Sexualidade: ', vl_sexualidade,
/ 'Altura: ', vl_altura,
/ 'Data de Nascimento: ', vl_data_nasc,
/ 'Hora do Nascimento: ', vl_hora_nasc.