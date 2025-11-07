*&---------------------------------------------------------------------*
*& Include          ZMINESWEEPER_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SET_ALV_RANK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_RANK .

  IF GO_DOCKING_RANK IS INITIAL.
    " 초기 생성
    CREATE OBJECT GO_DOCKING_RANK
      EXPORTING
        REPID                       = SY-REPID
        DYNNR                       = SY-DYNNR
        SIDE                        = 3
        EXTENSION                   = 450
      EXCEPTIONS
        CNTL_ERROR                  = 1
        CNTL_SYSTEM_ERROR           = 2
        CREATE_ERROR                = 3
        LIFETIME_ERROR              = 4
        LIFETIME_DYNPRO_DYNPRO_LINK = 5
        OTHERS                      = 6.

    CREATE OBJECT GO_GRID_RANK
      EXPORTING
        I_PARENT      = GO_DOCKING_RANK
        I_APPL_EVENTS = 'X'.

    "Field Catalog
*    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*      EXPORTING
*        I_STRUCTURE_NAME = 'ZMINERANK'
*      CHANGING
*        CT_FIELDCAT      = GT_FCAT_RANK.

    TRY.
        GT_FCAT_RANK = CORRESPONDING #( CL_SALV_DATA_DESCR=>READ_STRUCTDESCR(
                       CAST CL_ABAP_STRUCTDESCR(
                       CAST CL_ABAP_TABLEDESCR(
                       CL_ABAP_STRUCTDESCR=>DESCRIBE_BY_DATA( GT_RANKING )
                                            )->GET_TABLE_LINE_TYPE( ) ) ) ).
      CATCH CX_SY_MOVE_CAST_ERROR.

    ENDTRY.

    GS_LAYO-COL_OPT = 'X'.
    GS_LAYO-CTAB_FNAME = 'COLOR'.
    GS_LAYO-GRID_TITLE = '랭킹'.

    LOOP AT GT_FCAT_RANK ASSIGNING FIELD-SYMBOL(<FS_FCAT_RANK>).
      CASE <FS_FCAT_RANK>-FIELDNAME.
        WHEN 'RANK'.
          <FS_FCAT_RANK>-COLTEXT = '랭킹등수'.
          <FS_FCAT_RANK>-OUTPUTLEN = 4.
          <FS_FCAT_RANK>-COL_POS = 10.
        WHEN 'USERID'.
          <FS_FCAT_RANK>-COLTEXT = '유저 ID'.
          <FS_FCAT_RANK>-OUTPUTLEN = 5.
          <FS_FCAT_RANK>-COL_POS = 70.
        WHEN 'NAME'.
          <FS_FCAT_RANK>-COLTEXT = '닉네임'.
          <FS_FCAT_RANK>-OUTPUTLEN = 8.
          <FS_FCAT_RANK>-COL_POS = 20.
        WHEN 'STEP'.
          <FS_FCAT_RANK>-COLTEXT = '난이도'.
          <FS_FCAT_RANK>-OUTPUTLEN = 4.
          <FS_FCAT_RANK>-COL_POS = 40.
        WHEN 'RANGE'.
          <FS_FCAT_RANK>-COLTEXT = '범위'.
          <FS_FCAT_RANK>-OUTPUTLEN = 5.
          <FS_FCAT_RANK>-COL_POS = 50.
        WHEN 'TIME'.
          <FS_FCAT_RANK>-COLTEXT = '걸린 시간'.
          <FS_FCAT_RANK>-OUTPUTLEN = 7.
          <FS_FCAT_RANK>-COL_POS = 60.
        WHEN 'TOTAL'.
          <FS_FCAT_RANK>-COLTEXT = '총 점수 합계'.
          <FS_FCAT_RANK>-OUTPUTLEN = 10.
          <FS_FCAT_RANK>-COL_POS = 30.
        WHEN 'MINE_TOT'.
          <FS_FCAT_RANK>-COLTEXT = '지뢰 수'.
          <FS_FCAT_RANK>-OUTPUTLEN = 5.
          <FS_FCAT_RANK>-COL_POS = 45.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

    SELECT * FROM ZMINERANK INTO CORRESPONDING FIELDS OF TABLE GT_RANKING
      ORDER BY TOTAL DESCENDING.
    LOOP AT GT_RANKING ASSIGNING <FS_RANK>.
      <FS_RANK>-RANK = SY-TABIX.
      IF <FS_RANK>-RANK = 1. " 1등
        CLEAR: GS_COLOR, GT_COLOR.
        GS_COLOR-COLOR-COL = '5'.
        GS_COLOR-COLOR-INT = '1'.
        GS_COLOR-COLOR-INV = '0'.
        GS_COLOR-NOKEYCOL = 'X'.
        APPEND GS_COLOR TO GT_COLOR.
        MOVE-CORRESPONDING GT_COLOR TO <FS_RANK>-COLOR.
      ELSEIF <FS_RANK>-RANK = 2. " 2등
        CLEAR: GS_COLOR, GT_COLOR.
        GS_COLOR-COLOR-COL = '3'.
        GS_COLOR-COLOR-INT = '0'.
        GS_COLOR-COLOR-INV = '0'.
        GS_COLOR-NOKEYCOL = 'X'.
        APPEND GS_COLOR TO GT_COLOR.
        MOVE-CORRESPONDING GT_COLOR TO <FS_RANK>-COLOR.
      ELSEIF <FS_RANK>-RANK = 3. " 3등
        CLEAR: GS_COLOR, GT_COLOR.
        GS_COLOR-COLOR-COL = '7'.
        GS_COLOR-COLOR-INT = '0'.
        GS_COLOR-COLOR-INV = '0'.
        GS_COLOR-NOKEYCOL = 'X'.
        APPEND GS_COLOR TO GT_COLOR.
        MOVE-CORRESPONDING GT_COLOR TO <FS_RANK>-COLOR.
      ELSE.
        CLEAR: GS_COLOR, GT_COLOR.
        GS_COLOR-NOKEYCOL = 'X'.
        APPEND GS_COLOR TO GT_COLOR.
        MOVE-CORRESPONDING GT_COLOR TO <FS_RANK>-COLOR.
      ENDIF.
*      UNASSIGN: <FS_RANK>.
    ENDLOOP.



    CALL METHOD GO_GRID_RANK->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
        IS_LAYOUT       = GS_LAYO
      CHANGING
        IT_OUTTAB       = GT_RANKING
        IT_FIELDCATALOG = GT_FCAT_RANK.

    IF SY-SUBRC <> 0.
*     Implement suitable error handling here
    ENDIF.


  ELSE.
    SELECT * FROM ZMINERANK INTO CORRESPONDING FIELDS OF TABLE GT_RANKING.

    SELECT * FROM ZMINERANK INTO CORRESPONDING FIELDS OF TABLE GT_RANKING
       ORDER BY TOTAL DESCENDING.
    LOOP AT GT_RANKING ASSIGNING <FS_RANK>.
      <FS_RANK>-RANK = SY-TABIX.

      IF <FS_RANK>-RANK = 1. " 1등
        CLEAR: GS_COLOR, GT_COLOR.
        GS_COLOR-COLOR-COL = '5'.
        GS_COLOR-COLOR-INT = '1'.
        GS_COLOR-COLOR-INV = '0'.
        GS_COLOR-NOKEYCOL = 'X'.
        APPEND GS_COLOR TO GT_COLOR.
        MOVE-CORRESPONDING GT_COLOR TO <FS_RANK>-COLOR.
      ELSEIF <FS_RANK>-RANK = 2. " 2등
        CLEAR: GS_COLOR, GT_COLOR.
        GS_COLOR-COLOR-COL = '3'.
        GS_COLOR-COLOR-INT = '0'.
        GS_COLOR-COLOR-INV = '0'.
        GS_COLOR-NOKEYCOL = 'X'.
        APPEND GS_COLOR TO GT_COLOR.
        MOVE-CORRESPONDING GT_COLOR TO <FS_RANK>-COLOR.
      ELSEIF <FS_RANK>-RANK = 3. " 3등
        CLEAR: GS_COLOR, GT_COLOR.
        GS_COLOR-COLOR-COL = '7'.
        GS_COLOR-COLOR-INT = '0'.
        GS_COLOR-COLOR-INV = '0'.
        GS_COLOR-NOKEYCOL = 'X'.
        APPEND GS_COLOR TO GT_COLOR.
        MOVE-CORRESPONDING GT_COLOR TO <FS_RANK>-COLOR.
      ELSE.
        CLEAR: GS_COLOR, GT_COLOR.
        GS_COLOR-NOKEYCOL = 'X'.
        APPEND GS_COLOR TO GT_COLOR.
        MOVE-CORRESPONDING GT_COLOR TO <FS_RANK>-COLOR.
      ENDIF.
*      UNASSIGN: <FS_RANK>.
    ENDLOOP.
    IF SY-SUBRC = 0.
      CALL METHOD GO_GRID_RANK->REFRESH_TABLE_DISPLAY.

    ENDIF.


  ENDIF.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_PLAY_GROUND_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_PLAY_GROUND_FCAT .
  DATA  LT_FIELDCAT  TYPE  SLIS_T_FIELDCAT_ALV.
  DATA  LT_ALV_CAT   TYPE TABLE OF LVC_S_FCAT.
  DATA: LT_FCAT TYPE LVC_T_FCAT.

  TRY.
      GT_FCAT_FIELD = CORRESPONDING #( CL_SALV_DATA_DESCR=>READ_STRUCTDESCR(
                     CAST CL_ABAP_STRUCTDESCR(
                     CAST CL_ABAP_TABLEDESCR(
                     CL_ABAP_STRUCTDESCR=>DESCRIBE_BY_DATA( GT_DISPLAY )
                                          )->GET_TABLE_LINE_TYPE( ) ) ) ).
    CATCH CX_SY_MOVE_CAST_ERROR.

  ENDTRY.






  LOOP AT GT_FCAT_FIELD ASSIGNING FIELD-SYMBOL(<FS_FCAT_FIELD>).
    IF SY-TABIX >= GV_SIZE + 2. " 사이즈 할당 완료 시 나머지 No Out
      <FS_FCAT_FIELD>-NO_OUT = 'X'.
      CONTINUE.
    ELSEIF <FS_FCAT_FIELD>-FIELDNAME = 'INDEX'.
*      <FS_FCAT_FIELD>-NO_OUT = 'X'.
      <FS_FCAT_FIELD>-KEY = 'X'.
      CONTINUE.
    ENDIF.
    <FS_FCAT_FIELD>-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_BUTTON.
    <FS_FCAT_FIELD>-COL_POS = SY-TABIX.
    <FS_FCAT_FIELD>-OUTPUTLEN = 2.
    <FS_FCAT_FIELD>-COLTEXT = '*'.
    <FS_FCAT_FIELD>-TOOLTIP = <FS_FCAT_FIELD>-FIELDNAME.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SETTLEMENT_PLAY_GROUND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SETTLEMENT_PLAY_GROUND .
  DATA: LV_SORT TYPE N LENGTH 2 VALUE 0..
  DATA: LV_RANDOM_NUMBER TYPE I.

  GV_SIZE = COND #( WHEN P_SIZE1 = 'X' THEN 10
                    WHEN P_SIZE2 = 'X' THEN 15
                    WHEN P_SIZE3 = 'X' THEN 20 ).

  GV_STEP = COND #( WHEN P_STEP1 = 'X' THEN 10
                    WHEN P_STEP2 = 'X' THEN 19
                    WHEN P_STEP3 = 'X' THEN 35 ).

  DO GV_SIZE TIMES.
    LV_SORT += 1.

    DO GV_SIZE + 1 TIMES.
      IF SY-INDEX = 1.
        GS_FIELD-INDEX = LV_SORT.
      ELSE.

        CALL FUNCTION 'QF05_RANDOM_INTEGER'
          EXPORTING
            RAN_INT_MIN = 1  " Minimum value (inclusive)
            RAN_INT_MAX = 100 " Maximum value (inclusive)
          IMPORTING
            RAN_INT     = LV_RANDOM_NUMBER.

        IF LV_RANDOM_NUMBER =< GV_STEP.
          ASSIGN COMPONENT SY-INDEX OF STRUCTURE GS_FIELD TO <FS_COL>.
          <FS_COL> = GC_MINE. " 지뢰 심기
          GV_TOTAL_MINE += 1.
          UNASSIGN <FS_COL>.
        ENDIF.

      ENDIF.

    ENDDO.

    APPEND GS_FIELD TO GT_FIELD.
    CLEAR GS_FIELD.

  ENDDO.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_MINE_MAP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_MINE_MAP .

  DATA: LV_COL_POS1   TYPE N LENGTH 2,
        LV_COL_POS2   TYPE N LENGTH 2,
        LV_COL_POS3   TYPE N LENGTH 2,

        LV_MINE_COUNT TYPE N LENGTH 1 VALUE 0.

  LOOP AT GT_FIELD INTO GS_FIELD.

    DO GV_SIZE + 1 TIMES.
      ASSIGN COMPONENT SY-INDEX  OF STRUCTURE GS_FIELD TO <FS_COL>.
      IF SY-INDEX = 1.
        CONTINUE.
      ELSEIF <FS_COL> NE GC_MINE.
        CLEAR: LV_COL_POS1, LV_COL_POS2, LV_COL_POS3.
        LV_COL_POS1 = SY-INDEX - 1.
        LV_COL_POS2 = SY-INDEX.
        LV_COL_POS3 = SY-INDEX + 1.


        READ TABLE GT_FIELD INTO DATA(LS_BEF) INDEX GS_FIELD-INDEX - 1.
        READ TABLE GT_FIELD INTO DATA(LS_MID) INDEX GS_FIELD-INDEX.
        READ TABLE GT_FIELD INTO DATA(LS_AFT) INDEX GS_FIELD-INDEX + 1.

        IF LV_COL_POS1 NE 01.

          ASSIGN COMPONENT LV_COL_POS1 OF STRUCTURE LS_BEF TO FIELD-SYMBOL(<FS_COL1>).
          ASSIGN COMPONENT LV_COL_POS1 OF STRUCTURE LS_MID TO FIELD-SYMBOL(<FS_COL4>).
          ASSIGN COMPONENT LV_COL_POS1 OF STRUCTURE LS_AFT TO FIELD-SYMBOL(<FS_COL7>).

        ENDIF.

        ASSIGN COMPONENT LV_COL_POS2 OF STRUCTURE LS_BEF TO FIELD-SYMBOL(<FS_COL2>).
*        ASSIGN COMPONENT LV_COL_POS2 OF STRUCTURE LS_MID TO FIELD-SYMBOL(<FS_COL5>).
        ASSIGN COMPONENT LV_COL_POS2 OF STRUCTURE LS_AFT TO FIELD-SYMBOL(<FS_COL8>).

        IF LV_COL_POS3 NE CONV NUMC2( GV_SIZE + 2 ).

          ASSIGN COMPONENT LV_COL_POS3 OF STRUCTURE LS_BEF TO FIELD-SYMBOL(<FS_COL3>).
          ASSIGN COMPONENT LV_COL_POS3 OF STRUCTURE LS_MID TO FIELD-SYMBOL(<FS_COL6>).
          ASSIGN COMPONENT LV_COL_POS3 OF STRUCTURE LS_AFT TO FIELD-SYMBOL(<FS_COL9>).

        ENDIF.


        IF <FS_COL1> IS ASSIGNED.
          IF <FS_COL1> EQ GC_MINE.
            LV_MINE_COUNT += 1.
          ENDIF.
          UNASSIGN <FS_COL1>.
        ENDIF.

        IF <FS_COL2> IS ASSIGNED.
          IF <FS_COL2> EQ GC_MINE.
            LV_MINE_COUNT += 1.
          ENDIF.
          UNASSIGN <FS_COL2>.
        ENDIF.

        IF <FS_COL3> IS ASSIGNED.
          IF <FS_COL3> EQ GC_MINE.
            LV_MINE_COUNT += 1.
          ENDIF.
          UNASSIGN <FS_COL3>.
        ENDIF.

        IF <FS_COL4> IS ASSIGNED.
          IF <FS_COL4> EQ GC_MINE.
            LV_MINE_COUNT += 1.
          ENDIF.
          UNASSIGN <FS_COL4>.
        ENDIF.

        IF <FS_COL6> IS ASSIGNED.
          IF <FS_COL6> EQ GC_MINE.
            LV_MINE_COUNT += 1.
          ENDIF.
          UNASSIGN <FS_COL6>.
        ENDIF.

        IF <FS_COL7> IS ASSIGNED.
          IF <FS_COL7> EQ GC_MINE.
            LV_MINE_COUNT += 1.
          ENDIF.
          UNASSIGN <FS_COL7>.
        ENDIF.

        IF <FS_COL8> IS ASSIGNED.
          IF <FS_COL8> EQ GC_MINE.
            LV_MINE_COUNT += 1.
          ENDIF.
          UNASSIGN <FS_COL8>.
        ENDIF.

        IF <FS_COL9> IS ASSIGNED.
          IF <FS_COL9> EQ GC_MINE.
            LV_MINE_COUNT += 1.
            UNASSIGN <FS_COL9>.
          ENDIF.
        ENDIF.

        <FS_COL> = CONV CHAR1( LV_MINE_COUNT ).

        CLEAR: LV_MINE_COUNT, LS_BEF, LS_MID, LS_AFT.

      ENDIF.
    ENDDO.

    MODIFY GT_FIELD FROM GS_FIELD.

  ENDLOOP.

  CLEAR GT_DISPLAY.
  GT_DISPLAY = CORRESPONDING #( GT_FIELD ).

  LOOP AT GT_DISPLAY ASSIGNING FIELD-SYMBOL(<FS_DISPLAY>).
    CLEAR: <FS_DISPLAY>.
    <FS_DISPLAY>-INDEX = SY-TABIX.

  ENDLOOP.

  "타이머 시작
  GS_RANKING-TIME = SY-TIMLO.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GAME_OVER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GAME_OVER .

  GT_DISPLAY = CORRESPONDING #( GT_FIELD ).

  CALL METHOD GO_GRID_PLAY->REFRESH_TABLE_DISPLAY.

  MESSAGE '@1B@ 폭탄을 밟았습니다!' TYPE 'I'.

  WRITE: '??? : 잘 좀 하지 ㅋㅋㅋ 그걸 그렇게 하냐 '.

  LEAVE TO SCREEN 0.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form Check_COMPLATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHECK_COMPLATE .

  DATA LV_COUNT_MINE TYPE I VALUE 0.

  LOOP AT GT_DISPLAY INTO DATA(LS_DISPLAY).

    DO GV_SIZE + 1 TIMES.

      IF SY-INDEX = 1.

        CONTINUE.

      ENDIF.

      ASSIGN COMPONENT SY-INDEX OF STRUCTURE LS_DISPLAY TO FIELD-SYMBOL(<FS_CHECK_COL>).

      IF <FS_CHECK_COL> = GC_FLAG.
        READ TABLE GT_FIELD INTO DATA(LS_FIELD) INDEX SY-TABIX.
        ASSIGN COMPONENT SY-INDEX OF STRUCTURE LS_FIELD TO FIELD-SYMBOL(<FS_COMPARE_COL>).
        IF <FS_COMPARE_COL> = GC_MINE.

          LV_COUNT_MINE += 1.

        ENDIF.

      ENDIF.

      UNASSIGN: <FS_CHECK_COL>, <FS_COMPARE_COL>.

    ENDDO.

  ENDLOOP.

  IF GV_TOTAL_MINE = LV_COUNT_MINE.

    PERFORM SUCCESS_GAME.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SUCCESS_GAME
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SUCCESS_GAME .

  GS_RANKING-TIME = SY-TIMLO - GS_RANKING-TIME.

  LOOP AT GT_FIELD INTO DATA(LS_FIELD).

    DO GV_SIZE + 1 TIMES.
      IF SY-INDEX = 1.

        CONTINUE.

      ENDIF.

      ASSIGN COMPONENT SY-INDEX  OF STRUCTURE LS_FIELD TO FIELD-SYMBOL(<FS>).
      IF <FS> = GC_MINE.

        <FS_COL> = GC_FLAG.

      ENDIF.
      UNASSIGN <FS>.
    ENDDO.

  ENDLOOP.

  GT_DISPLAY = CORRESPONDING #( GT_FIELD ).

  CALL METHOD GO_GRID_PLAY->REFRESH_TABLE_DISPLAY.

  MESSAGE '축하드립니다! 모든 지뢰를 찾았습니다!' TYPE 'I'.

  MESSAGE I001 WITH GV_SIZE GV_STEP GS_RANKING-TIME.

  " 점수 계산 방식
  " 사이즈 난이도 걸린시간 = 5 2 3 = + + -
  GS_RANKING-TOTAL = ( ( GV_SIZE * GV_SIZE ) * ( GV_TOTAL_MINE ** 2 ) * 1000 ) / ( GS_RANKING-TIME + 1 ).


  GS_RANKING-RANGE = COND #( WHEN GV_SIZE = 10 THEN '10X10'
                             WHEN GV_SIZE = 15 THEN '15X15'
                             WHEN GV_SIZE = 20 THEN '20X20' ).

  GS_RANKING-STEP  = COND #( WHEN GV_STEP = 10 THEN '초급'
                             WHEN GV_STEP = 19 THEN '중급'
                             WHEN GV_STEP = 35 THEN '고급' ).
  GS_RANKING-MINE_TOT = GV_TOTAL_MINE.
  DATA: LS_RANK TYPE ZMINERANK.
  MOVE-CORRESPONDING GS_RANKING TO LS_RANK.

  MODIFY ZMINERANK FROM LS_RANK.


  LEAVE TO SCREEN 0.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROPAGATION_ZERO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ES_ROW_NO_ROW_ID
*&      --> ES_COL_ID_FIELDNAME
*&---------------------------------------------------------------------*
FORM PROPAGATION_ZERO  USING    P_ROW_ID
                                P_FIELDNAME.

  DATA: LV_BEF         TYPE SY-INDEX,
        LV_MID         TYPE SY-INDEX,
        LV_AFT         TYPE SY-INDEX,

        LS_FIELD_BEF   LIKE GS_FIELD,
        LS_FIELD_MID   LIKE GS_FIELD,
        LS_FIELD_AFT   LIKE GS_FIELD,

        LV_LEFT_COL    TYPE LVC_FNAME,
        LV_RIGHT_COL   TYPE LVC_FNAME,

        LV_LEFT_TEMP1  TYPE C LENGTH 1,
        LV_LEFT_TEMP2  TYPE C LENGTH 1,
        LV_RIGHT_TEMP1 TYPE C LENGTH 1,
        LV_RIGHT_TEMP2 TYPE C LENGTH 1.


  LV_MID = P_ROW_ID.
  LV_BEF = P_ROW_ID - 1.
  LV_AFT = P_ROW_ID + 1.




  "위 아래 먼저 확인
  "위
  IF LV_BEF NE 0.
    READ TABLE GT_FIELD INTO LS_FIELD_BEF INDEX LV_BEF.
    READ TABLE GT_DISPLAY ASSIGNING FIELD-SYMBOL(<FS_DIS_COL1>) INDEX LV_BEF.

    ASSIGN COMPONENT P_FIELDNAME OF STRUCTURE LS_FIELD_BEF TO FIELD-SYMBOL(<FS_BEF>).
    IF <FS_BEF> = '0' AND <FS_DIS_COL1>-(P_FIELDNAME) IS INITIAL.
      <FS_DIS_COL1>-(P_FIELDNAME) = <FS_BEF>.
      PERFORM PROPAGATION_ZERO USING LV_BEF P_FIELDNAME.
* U1
    ELSEIF <FS_BEF> NE GC_MINE AND <FS_DIS_COL1>-(P_FIELDNAME) IS INITIAL.
      <FS_DIS_COL1>-(P_FIELDNAME) = <FS_BEF>.

    ENDIF.

  ENDIF.

  "아래
  IF LV_AFT =< GV_SIZE.
    READ TABLE GT_FIELD INTO LS_FIELD_AFT INDEX LV_AFT.
    READ TABLE GT_DISPLAY ASSIGNING FIELD-SYMBOL(<FS_DIS_COL2>) INDEX LV_AFT.

    ASSIGN COMPONENT P_FIELDNAME OF STRUCTURE LS_FIELD_AFT TO FIELD-SYMBOL(<FS_AFT>).
    IF <FS_AFT> = '0' AND <FS_DIS_COL2>-(P_FIELDNAME) IS INITIAL.
      <FS_DIS_COL2>-(P_FIELDNAME) = <FS_AFT>.
      PERFORM PROPAGATION_ZERO USING LV_AFT P_FIELDNAME.
* U1
    ELSEIF <FS_AFT> NE GC_MINE AND <FS_DIS_COL2>-(P_FIELDNAME) IS INITIAL.
      <FS_DIS_COL2>-(P_FIELDNAME) = <FS_AFT>.

    ENDIF.

  ENDIF.
  "양옆
  LV_LEFT_TEMP1 = P_FIELDNAME+0(1).
  LV_LEFT_TEMP2 = P_FIELDNAME+1(1).
  "왼쪽
  LV_LEFT_TEMP1 = COND #( WHEN LV_LEFT_TEMP2 = '0' AND LV_LEFT_TEMP1 = 'B' THEN 'A'
                          WHEN LV_LEFT_TEMP2 = '0' AND LV_LEFT_TEMP1 = 'C' THEN 'B'
                          WHEN LV_LEFT_TEMP2 = '0' AND LV_LEFT_TEMP1 = 'D' THEN 'C'
                          WHEN LV_LEFT_TEMP2 = '0' AND LV_LEFT_TEMP1 = 'E' THEN 'D'
                          ELSE LV_LEFT_TEMP1 ).

  LV_LEFT_TEMP2 = COND #( WHEN LV_LEFT_TEMP2 = '0' THEN '9'
                          WHEN LV_LEFT_TEMP2 = '9' THEN '8'
                          WHEN LV_LEFT_TEMP2 = '8' THEN '7'
                          WHEN LV_LEFT_TEMP2 = '7' THEN '6'
                          WHEN LV_LEFT_TEMP2 = '6' THEN '5'
                          WHEN LV_LEFT_TEMP2 = '5' THEN '4'
                          WHEN LV_LEFT_TEMP2 = '4' THEN '3'
                          WHEN LV_LEFT_TEMP2 = '3' THEN '2'
                          WHEN LV_LEFT_TEMP2 = '2' THEN '1'
                          WHEN LV_LEFT_TEMP2 = '1' THEN '0' ).

  LV_LEFT_COL = |{ LV_LEFT_TEMP1 }{ LV_LEFT_TEMP2 }|.
  READ TABLE GT_FIELD INTO LS_FIELD_MID INDEX LV_MID.
  READ TABLE GT_DISPLAY ASSIGNING FIELD-SYMBOL(<FS_LEFT>) INDEX LV_MID.

  IF LS_FIELD_MID-(LV_LEFT_COL) = '0' AND <FS_LEFT>-(LV_LEFT_COL) IS INITIAL.
    <FS_LEFT>-(LV_LEFT_COL) = LS_FIELD_MID-(LV_LEFT_COL).
    PERFORM PROPAGATION_ZERO USING LV_MID LV_LEFT_COL.

* U1
  ELSEIF LS_FIELD_MID-(LV_LEFT_COL) NE GC_MINE AND <FS_LEFT>-(LV_LEFT_COL) IS INITIAL.
    <FS_LEFT>-(LV_LEFT_COL) = LS_FIELD_MID-(LV_LEFT_COL).

  ENDIF.

  "오른쪽
  LV_RIGHT_TEMP1 = P_FIELDNAME+0(1).
  LV_RIGHT_TEMP2 = P_FIELDNAME+1(1).


  LV_RIGHT_TEMP1 = COND #( WHEN LV_RIGHT_TEMP2 = '9' AND LV_RIGHT_TEMP1 = 'A' THEN 'B'
                           WHEN LV_RIGHT_TEMP2 = '9' AND LV_RIGHT_TEMP1 = 'B' THEN 'C'
                           WHEN LV_RIGHT_TEMP2 = '9' AND LV_RIGHT_TEMP1 = 'C' THEN 'D'
                           WHEN LV_RIGHT_TEMP2 = '9' AND LV_RIGHT_TEMP1 = 'D' THEN 'E'
                           ELSE LV_RIGHT_TEMP1 ).

  LV_RIGHT_TEMP2 = COND #( WHEN LV_RIGHT_TEMP2 = '0' THEN '1'
                           WHEN LV_RIGHT_TEMP2 = '9' THEN '0'
                           WHEN LV_RIGHT_TEMP2 = '8' THEN '9'
                           WHEN LV_RIGHT_TEMP2 = '7' THEN '8'
                           WHEN LV_RIGHT_TEMP2 = '6' THEN '7'
                           WHEN LV_RIGHT_TEMP2 = '5' THEN '6'
                           WHEN LV_RIGHT_TEMP2 = '4' THEN '5'
                           WHEN LV_RIGHT_TEMP2 = '3' THEN '4'
                           WHEN LV_RIGHT_TEMP2 = '2' THEN '3'
                           WHEN LV_RIGHT_TEMP2 = '1' THEN '2' ).

  LV_RIGHT_COL = |{ LV_RIGHT_TEMP1 }{ LV_RIGHT_TEMP2 }|.
  IF LS_FIELD_MID-(LV_RIGHT_COL) = '0' AND <FS_LEFT>-(LV_RIGHT_COL) IS INITIAL.
    <FS_LEFT>-(LV_RIGHT_COL) = LS_FIELD_MID-(LV_RIGHT_COL).
    PERFORM PROPAGATION_ZERO USING LV_MID LV_RIGHT_COL.
* U1
  ELSEIF LS_FIELD_MID-(LV_RIGHT_COL) NE GC_MINE AND <FS_LEFT>-(LV_RIGHT_COL) IS INITIAL.
    <FS_LEFT>-(LV_RIGHT_COL) = LS_FIELD_MID-(LV_RIGHT_COL).

  ENDIF.


  RETURN.


ENDFORM.
