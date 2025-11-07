*&---------------------------------------------------------------------*
*& Report ZMINESWEEPER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZMINESWEEPER_T01.

INCLUDE ZMINESWEEPER_C01.
INCLUDE ZMINESWEEPER_O01.
INCLUDE ZMINESWEEPER_I01.
INCLUDE ZMINESWEEPER_F01.

INITIALIZATION.
  GV_TEXT1 = '게임 룰 설명 - 모든 지뢰를 찾아내는 것이 목표입니다!'.
  GV_TEXT2 = |{ GC_MINE } - 해당 지뢰를 건들이지 않고 모든 지뢰를 찾아내는 게임입니다.|.
  GV_TEXT3 = |{ GC_FLAG } - 해당 깃발로 지뢰가 있는 곳을 표시하면 성공입니다.|.
  GV_TEXT4 = |# 랭킹의 점수는 선택한 게임판의 범위, 매립된 지뢰 수, 걸린 시간을 종합한 점수로 랭킹이 정해집니다.|.
  GV_TEXT5 = |# 오류가 발생한 경우 종오한테 문의 바랍니다.|.
  GV_TEXT6 = | * Made By 김종오 *.|.

  SELECT SINGLE NAME FROM ZMINERANK
    INTO @DATA(LV_NAME)
    WHERE USERID = @SY-UNAME.

  IF SY-SUBRC = 0.
    P_NAME = LV_NAME.
  ENDIF.



AT SELECTION-SCREEN OUTPUT.
  PERFORM SET_ALV_RANK.

AT SELECTION-SCREEN.

START-OF-SELECTION.
  PERFORM SETTLEMENT_PLAY_GROUND.

  PERFORM SET_MINE_MAP.

  GS_RANKING-NAME = P_NAME.
  GS_RANKING-USERID = SY-UNAME.

  CALL SCREEN 100.

END-OF-SELECTION.
