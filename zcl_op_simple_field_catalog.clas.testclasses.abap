*"* use this source file for your ABAP unit test classes
CLASS ltcl_fieldcatalog_should DEFINITION DEFERRED.
CLASS ZCL_OP_SIMPLE_FIELD_CATALOG DEFINITION LOCAL FRIENDS ltcl_fieldcatalog_should.
CLASS ltcl_fieldcatalog_should DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    DATA: lo_cut TYPE REF TO ZCL_OP_SIMPLE_FIELD_CATALOG.
    METHODS:
      setup,
      get_fields_in_right_order         FOR TESTING RAISING cx_static_check,
      get_fieldcatalog_of_local_type    FOR TESTING RAISING cx_static_check,
      get_fieldcat_of_local_typ_incl    for testing raising cx_static_check.
ENDCLASS.


CLASS ltcl_fieldcatalog_should IMPLEMENTATION.

  METHOD get_fields_in_right_order.
    DATA: field_catalog TYPE lvc_t_fcat.


    TYPES: BEGIN OF t_col2,
             col1 TYPE i,
             col2 TYPE i,
           END OF t_col2.

    TYPES: BEGIN OF t_struct,
             col1 TYPE i,
             col2 TYPE t_col2,
           END OF t_struct.

    TYPES: my_itab_type TYPE STANDARD TABLE OF t_struct WITH DEFAULT KEY.
    TYPES: BEGIN OF nested_type,
             col1 TYPE i,
             col2 TYPE t_col2,
             col3 TYPE my_itab_type,
           END OF nested_type.

    DATA(itab_in_struc) = VALUE nested_type( col1 = 1

                                    col2 = VALUE #(
                                                    col1 = 11
                                                    col2 = 22
                                                  )
                                    col3 = VALUE #(
                                                   ( col1 = 311 col2 = VALUE #( col1 = 3121 col2 = 3122 ) )
                                                   ( col1 = 321 col2 = VALUE #( col1 = 3221 col2 = 3222 ) )
                                                  )
                                  ).

    field_catalog = lo_cut->get_by_data( EXPORTING i_structure  = itab_in_struc ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = field_catalog[ 1 ]-fieldname
        exp                  = |COL1|
        msg                  = |Order of fieldcatalog fieldnames is not ok|   ).
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = field_catalog[ 2 ]-fieldname
        exp                  = |COL2|
        msg                  = |Order of fieldcatalog fieldnames is not ok|   ).
    cl_abap_unit_assert=>assert_equals(
     EXPORTING
       act                  = field_catalog[ 3 ]-fieldname
       exp                  = |COL3|
       msg                  = |Order of fieldcatalog fieldnames is not ok|   ).
  ENDMETHOD.


  METHOD setup.
    lo_cut = NEW ZCL_OP_SIMPLE_FIELD_CATALOG( ).
  ENDMETHOD.


  METHOD get_fieldcatalog_of_local_type.

    TYPES: BEGIN OF ts_flight_data,
             carrid TYPE s_carr_id,
             connid TYPE s_conn_id,
             fldate TYPE s_date,
             price  TYPE s_price,
           END OF ts_flight_data,
           tt_flight_data TYPE STANDARD TABLE OF ts_flight_data WITH EMPTY KEY,
           BEGIN OF ts_flight_data_deep,
             col1 TYPE tt_flight_data,
           END OF ts_flight_data_deep,
           tt_flight_data_deep TYPE STANDARD TABLE OF ts_flight_data_deep WITH EMPTY KEY.


    DATA(flights) = VALUE tt_flight_data_deep( ( col1 = VALUE #(
                                            ( carrid = 'AA'   connid = '0017' fldate = '20170810' price = '422.94 ' )
                                            ( carrid = 'AA'   connid = '0017' fldate = '20170810' price = '422.94 ' )
                                          )
                          )
                          ( col1 = VALUE #(
                                            ( carrid = 'AA'   connid = '0017' fldate = '20170810' price = '422.94 ' )
                                            ( carrid = 'AA'   connid = '0017' fldate = '20170810' price = '422.94 ' )
                                          )
                          )
                        ).

    DATA(lt_field_catalog)  = lo_cut->get_by_data( i_table = flights ).

    cl_abap_unit_assert=>assert_not_initial(  EXPORTING   act     = lt_field_catalog[]
                                                          msg     = |Field catalog was not created|         ).

  ENDMETHOD.

  method get_fieldcat_of_local_typ_incl.

    types begin of gtyp_struct.
    include type t000.
    types dummy_field_1 type i.
    types dummy_field_2 type string.
    types end of gtyp_struct .

    data(ls_struct)
        = value gtyp_struct(
            mandt         = '000'
            logsys        = 'DUMMY_1'
            dummy_field_1 = 666
            dummy_field_2 = 'Hello'
        ).

    data(lt_field_catalog_act)
        = lo_cut->get_fieldcat_from_local_type(
            i_structure_description
                = cast cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( p_data = ls_struct ) )
        ).

    data(lt_field_catalog_exp) = value lvc_t_fcat(
                       (
                        fieldname = 'MANDT'
                        outputlen = '000003'
                        seltext = 'MANDT'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'MTEXT'
                        outputlen = '000025'
                        seltext = 'MTEXT'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'ORT01'
                        outputlen = '000025'
                        seltext = 'ORT01'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'MWAER'
                        outputlen = '000005'
                        seltext = 'MWAER'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'ADRNR'
                        outputlen = '000010'
                        seltext = 'ADRNR'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'CCCATEGORY'
                        outputlen = '000001'
                        seltext = 'CCCATEGORY'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'CCCORACTIV'
                        outputlen = '000001'
                        seltext = 'CCCORACTIV'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'CCNOCLIIND'
                        outputlen = '000001'
                        seltext = 'CCNOCLIIND'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'CCCOPYLOCK'
                        outputlen = '000001'
                        seltext = 'CCCOPYLOCK'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'CCNOCASCAD'
                        outputlen = '000001'
                        seltext = 'CCNOCASCAD'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'CCSOFTLOCK'
                        outputlen = '000001'
                        seltext = 'CCSOFTLOCK'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'CCORIGCONT'
                        outputlen = '000001'
                        seltext = 'CCORIGCONT'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'CCIMAILDIS'
                        outputlen = '000001'
                        seltext = 'CCIMAILDIS'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'CCTEMPLOCK'
                        outputlen = '000001'
                        seltext = 'CCTEMPLOCK'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'CHANGEUSER'
                        outputlen = '000012'
                        seltext = 'CHANGEUSER'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'CHANGEDATE'
                        outputlen = '000010'
                        seltext = 'CHANGEDATE'
                        inttype = 'D'
                        )
                       (
                        fieldname = 'LOGSYS'
                        outputlen = '000010'
                        convexit = '==ALP'
                        seltext = 'LOGSYS'
                        inttype = 'C'
                        )
                       (
                        fieldname = 'DUMMY_FIELD_1'
                        outputlen = '000011'
                        seltext = 'DUMMY_FIELD_1'
                        inttype = 'I'
                        )
                       (
                        fieldname = 'DUMMY_FIELD_2'
                        seltext = 'DUMMY_FIELD_2'
                        inttype = 'g'
                        )
                       ).


    cl_abap_unit_assert=>assert_equals(
      exporting
        act                  = lt_field_catalog_act
        exp                  = lt_field_catalog_exp
*    ignore_hash_sequence = abap_false
*    tol                  =
*    msg                  =
*    level                = if_abap_unit_constant=>severity-medium
*    quit                 = if_abap_unit_constant=>quit-test
*  receiving
*    assertion_failed     =
    ).

  endmethod.

ENDCLASS.
