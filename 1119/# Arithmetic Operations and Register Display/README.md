# 두 개의 숫자를 입력받아 사칙연산 및 레지스터 출력

## 1. 문제 설명

두 개의 숫자를 입력받아 사칙연산(덧셈, 뺄셈, 곱셈, 나눗셈)을 수행하고, 각 연산 결과와 AX, BX, CX, DX 레지스터의 내용을 화면에 출력하는 프로그램을 작성한다.

## 2. 프로그램 목표

- 두 개의 숫자를 입력받는다.
- 두 숫자의 덧셈 결과를 계산한다.
- 두 숫자의 뺄셈 결과를 계산한다.
- 두 숫자의 곱셈 결과를 계산한다.
- 두 숫자의 나눗셈 결과를 계산한다.
- AX, BX, CX, DX 레지스터의 값을 출력한다.

## 3. 알고리즘

1. 프로그램을 시작한다.
2. 첫 번째 숫자를 입력받는다.
3. 두 번째 숫자를 입력받는다.
4. 두 숫자를 더하고 결과를 저장한다.
5. 두 숫자를 빼고 결과를 저장한다.
6. 두 숫자를 곱하고 결과를 저장한다.
7. 첫 번째 숫자를 두 번째 숫자로 나누고 몫과 나머지를 저장한다.
8. AX, BX, CX, DX 레지스터의 내용을 출력한다.
9. 프로그램을 종료한다.

## 4. 어셈블리 코드

```asm
.MODEL SMALL
.STACK 100H

.DATA
    MSG1 DB 'Enter first number: $'
    MSG2 DB 13, 10, 'Enter second number: $'
    MSG3 DB 13, 10, 'AX = $'
    MSG4 DB 13, 10, 'BX = $'
    MSG5 DB 13, 10, 'CX = $'
    MSG6 DB 13, 10, 'DX = $'

    NUM1 DW ?
    NUM2 DW ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; 첫 번째 숫자 입력
    LEA DX, MSG1
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H
    SUB AL, '0'
    MOV NUM1, AX

    ; 두 번째 숫자 입력
    LEA DX, MSG2
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H
    SUB AL, '0'
    MOV NUM2, AX

    ; 덧셈
    MOV AX, NUM1
    ADD AX, NUM2

    ; 뺄셈
    MOV BX, NUM1
    SUB BX, NUM2

    ; 곱셈
    MOV AX, NUM1
    MUL NUM2
    MOV CX, AX

    ; 나눗셈
    MOV AX, NUM1
    MOV DX, 0
    DIV NUM2

    ; 레지스터 출력
    LEA DX, MSG3
    MOV AH, 09H
    INT 21H

    MOV DL, '0'
    ADD DL, AL
    MOV AH, 02H
    INT 21H

    LEA DX, MSG4
    MOV AH, 09H
    INT 21H

    MOV DL, '0'
    ADD DL, BL
    MOV AH, 02H
    INT 21H

    LEA DX, MSG5
    MOV AH, 09H
    INT 21H

    MOV DL, '0'
    ADD DL, CL
    MOV AH, 02H
    INT 21H

    LEA DX, MSG6
    MOV AH, 09H
    INT 21H

    MOV DL, '0'
    ADD DL, AH
    MOV AH, 02H
    INT 21H

    ; 종료
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
```

## 5. 레지스터 설명

| 레지스터 | 역할 |
|---|---|
| AX | 덧셈 및 나눗셈 연산에 사용 |
| BX | 뺄셈 결과 저장 |
| CX | 곱셈 결과 저장 |
| DX | 나눗셈의 나머지 저장 및 출력 보조 |

## 6. 실행 결과 예시

입력값이 다음과 같다고 가정한다.

- 첫 번째 숫자: 8
- 두 번째 숫자: 2

예상 연산 결과

| 연산 | 결과 |
|---|---:|
| 덧셈 | 10 |
| 뺄셈 | 6 |
| 곱셈 | 16 |
| 나눗셈 | 4 |

## 7. 주의사항

- 위 코드는 한 자리 숫자 입력을 기준으로 작성한 기본 예제이다.
- 두 번째 숫자는 0이 될 수 없다.
- 실제 레지스터 출력 시에는 연산 결과가 덮어쓰이지 않도록 별도의 메모리 공간에 결과를 저장해야 한다.
- 여러 자리 숫자를 처리하려면 입력값을 문자열로 받아 정수로 변환하는 과정이 추가로 필요하다.

## 8. 마무리

이번 과제를 통해 어셈블리 언어에서 숫자 입력 방법과 ADD, SUB, MUL, DIV 명령어를 활용한 사칙연산 방법을 학습할 수 있다.

또한 AX, BX, CX, DX 레지스터의 역할과 연산 결과가 레지스터에 저장되는 과정을 이해할 수 있다.
