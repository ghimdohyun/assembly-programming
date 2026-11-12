# 어셈블리 프로그래밍 - 숫자 5개의 평균 계산

## 1. 프로그램 설명

사용자로부터 정수 5개를 입력받아 합계를 계산하고, 입력한 숫자의 평균을 출력하는 어셈블리 프로그램입니다.

## 2. 개발 환경

- 언어: Assembly
- 개발 환경: MASM
- 라이브러리: Irvine32

## 3. 프로그램 동작 과정

1. 사용자로부터 정수 5개를 입력받습니다.
2. 입력받은 숫자 5개를 저장합니다.
3. 저장된 숫자들을 모두 더해 합계를 계산합니다.
4. 합계를 5로 나누어 평균을 계산합니다.
5. 계산된 평균을 화면에 출력합니다.

## 4. 소스 코드

```asm
INCLUDE Irvine32.inc

.data
    msg1 BYTE "Enter 5 numbers: ", 0
    msg2 BYTE "Average = ", 0

    num1 DWORD ?
    num2 DWORD ?
    num3 DWORD ?
    num4 DWORD ?
    num5 DWORD ?

.code
main PROC

    ; 숫자 5개 입력
    mov edx, OFFSET msg1
    call WriteString

    call ReadInt
    mov num1, eax

    call ReadInt
    mov num2, eax

    call ReadInt
    mov num3, eax

    call ReadInt
    mov num4, eax

    call ReadInt
    mov num5, eax

    ; 입력한 숫자 5개 합산
    mov eax, num1
    add eax, num2
    add eax, num3
    add eax, num4
    add eax, num5

    ; 평균 계산
    mov ebx, 5
    cdq
    idiv ebx

    ; 평균 출력
    mov edx, OFFSET msg2
    call WriteString
    call WriteInt
    call Crlf

    exit

main ENDP
END main
```

## 5. 실행 결과 예시

```text
Enter 5 numbers:
10
20
30
40
50
Average = +30
```

## 6. 평균 계산 공식

평균 = (숫자1 + 숫자2 + 숫자3 + 숫자4 + 숫자5) / 5

## 7. 사용된 주요 명령어

| 명령어 | 설명 |
|---|---|
| `ReadInt` | 정수 입력 |
| `mov` | 데이터 이동 |
| `add` | 덧셈 |
| `cdq` | 부호 확장 |
| `idiv` | 부호 있는 정수 나눗셈 |
| `WriteString` | 문자열 출력 |
| `WriteInt` | 정수 출력 |
| `Crlf` | 줄바꿈 |

## 8. 참고 사항

- 총 5개의 정수를 입력받습니다.
- 평균은 정수 형태로 출력됩니다.
- 정수 나눗셈이므로 소수점 이하 값은 버려집니다.

