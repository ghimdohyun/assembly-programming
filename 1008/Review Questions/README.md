# Chapter 5. Procedures

**범위:** 5.8.1 Short Answer 1--20, 5.8.2 Algorithm Workbench 1--5, 5.9
Programming Exercises 1--11\
**환경:** 32비트 MASM + Irvine32 라이브러리

## 5.8.1 Short Answer

1.  **PUSHAD** --- 32비트 범용 레지스터들을 스택에 저장한다.

2.  **PUSHFD** --- EFLAGS를 스택에 저장한다.

3.  **POPFD** --- 스택의 값을 EFLAGS로 복원한다.

4.  필요한 레지스터만 지정해 저장하면 PUSHAD로 모든 레지스터를 저장하는
    것보다 불필요한 저장과 스택 사용을 줄일 수 있다.

5.  ``` asm
    sub esp, 4
    mov DWORD PTR [esp], eax
    ```

6.  **True** --- RET은 스택의 복귀 주소를 명령어 포인터로 가져온다.

7.  **False** --- 프로시저 안에서 다른 프로시저를 호출하는 중첩 호출은
    가능하다.

8.  **True** --- 32비트 보호 모드의 near CALL은 4바이트 복귀 주소를
    스택에 저장한다.

9.  **False** --- ESI와 EDI도 매개변수 전달에 사용할 수 있다.

10. **True** --- 교재의 ArraySum은 배열의 시작 주소를 전달받아
    doubleword 배열을 처리한다.

11. **True** --- USES를 이용해 프로시저에서 보존할 레지스터를 지정할 수
    있다.

12. **False** --- USES는 저장뿐 아니라 복원 코드도 생성한다.

13. **False** --- MASM의 USES 레지스터 목록은 공백으로 구분해 쓸 수
    있다. 예: `Example PROC USES eax ebx ecx`

14. WORD 배열을 처리하려면 doubleword 기준의 원소 읽기와 주소 증가를
    바꿔야 한다. 아래는 ESI=배열 주소, ECX=원소 개수, EAX=합계인
    버전이다. 부호 없는 WORD 배열 기준이다.

``` asm
ArraySum PROC USES esi ecx edx
    mov eax, 0
    cmp ecx, 0
    je Done
L1:
    movzx edx, WORD PTR [esi]
    add eax, edx
    add esi, TYPE WORD
    loop L1
Done:
    ret
ArraySum ENDP
```

`MOVZX`로 WORD를 32비트로 확장하고, WORD 크기인 2바이트만큼 ESI를
증가시킨다. ECX가 0일 때 LOOP를 실행하면 언더플로가 생길 수 있으므로
먼저 검사한다. 15. **EAX = 5** --- 6을 먼저 꺼내고, 이어서 5를 꺼내기
때문이다. 16. **d. Line 11에서 런타임 오류** --- `POP EAX`가 복귀 주소를
꺼내 버려 RET이 20을 복귀 주소로 사용한다. 17. **c. Line 6에서 EAX =
30** --- PUSHA/POPA가 레지스터 값을 보존·복원한다. 예제의 값은 16비트
복원 후에도 EAX=30이다. 18. **a. Line 7에서 EAX = 30** ---
`push OFFSET Here`로 주소를 쌓고 Ex4Sub로 점프한다. RET이 Here로
이동하고 EAX를 30으로 설정한다. 19. **a. Line 6에서 EDX = 40** ---
프로시저가 복귀 주소를 잠시 꺼내고, 그 아래의 40을 EDX로 꺼낸 뒤 복귀
주소를 다시 넣는다. 20. 배열 결과는 다음과 같다.

``` text
array[0] = 10
array[1] = 20
array[2] = 30
array[3] = 40
```

proc_3에서 10을 저장하고, 각 호출에서 돌아올 때 ESI와 EAX가 증가하며 20,
30, 40이 저장된다.

## 5.8.2 Algorithm Workbench

### 1. EAX와 EBX 교환

``` asm
push eax
push ebx
pop eax
pop ebx
```

### 2. 복귀 주소보다 3바이트 높은 주소로 복귀

``` asm
pop eax
add eax, 3
push eax
ret
```

EAX를 임시 레지스터로 사용한다. 이 코드는 복귀 주소를 변경하는 예시이며
EAX의 원래 값은 보존하지 않는다.

### 3. doubleword 지역 변수 2개 공간 확보 및 값 저장

``` asm
sub esp, 8
mov DWORD PTR [esp], 1000h
mov DWORD PTR [esp+4], 2000h
```

각 doubleword는 4바이트이므로 총 8바이트를 확보한다. 해당 공간은
프로시저 종료 전에 호출 규약에 맞게 정리해야 한다.

### 4. 배열의 현재 doubleword를 이전 위치로 복사

``` asm
mov eax, [esi]
mov [esi-4], eax
```

ESI가 현재 doubleword 원소를 가리킨다고 가정한다.

### 5. 복귀 주소 출력

``` asm
mov eax, [esp]
call WriteHex
```

`[ESP]`를 읽기만 하고 스택에서 제거하지 않으므로 복귀 주소가 남는다.
Irvine32의 `WriteHex`를 사용한다.

## 5.9 Programming Exercises

각 문제는 별도 MASM 소스 파일로 실행한다.

### 1. Draw Text Colors

``` asm
INCLUDE Irvine32.inc

.data
msg BYTE "Hello Assembly!",0
colors DWORD 1, 2, 4, 10

.code
main PROC
    call Clrscr
    mov esi, OFFSET colors
    mov ecx, LENGTHOF colors
L1:
    mov eax, [esi]
    call SetTextColor
    mov edx, OFFSET msg
    call WriteString
    call Crlf
    add esi, TYPE colors
    loop L1

    mov eax, 7
    call SetTextColor
    exit
main ENDP
END main
```

같은 문자열을 네 가지 색상으로 출력한다.

### 2. Linking Array Items

교재의 링크 순서대로 문자를 새 배열에 복사한다. 출력 배열에는
`A,B,C,D,E,F,G,H` 순서로 저장된다.

``` asm
INCLUDE Irvine32.inc

.data
chars BYTE 'H','A','C','E','B','D','F','G'
links DWORD 0,4,5,6,2,3,7,0
output BYTE 8 DUP(?)

.code
main PROC
    mov esi, 1
    mov edi, OFFSET output
    mov ecx, LENGTHOF chars
L1:
    mov al, chars[esi]
    mov [edi], al
    inc edi
    mov esi, [links + esi*4]
    loop L1

    mov esi, 0
    mov ecx, LENGTHOF output
L2:
    mov al, output[esi]
    call WriteChar
    inc esi
    loop L2
    call Crlf
    exit
main ENDP
END main
```

예상 출력은 `ABCDEFGH`이다. 쉼표는 배열 값 목록을 구분하는 표기이며,
배열에는 문자 8개가 저장된다.

### 3. Simple Addition (1)

``` asm
INCLUDE Irvine32.inc

.data
prompt1 BYTE "첫 번째 정수 입력: ",0
prompt2 BYTE "두 번째 정수 입력: ",0
resultMsg BYTE "합계: ",0
sum DWORD ?

.code
main PROC
    call Clrscr
    mov dh, 12
    mov dl, 20
    call Gotoxy

    mov edx, OFFSET prompt1
    call WriteString
    call ReadInt
    mov ebx, eax

    mov edx, OFFSET prompt2
    call WriteString
    call ReadInt
    add eax, ebx
    mov sum, eax

    call Crlf
    mov edx, OFFSET resultMsg
    call WriteString
    mov eax, sum
    call WriteInt
    call Crlf
    exit
main ENDP
END main
```

두 정수를 입력받아 더한 뒤 합계를 출력한다. 합계를 변수에 보관해 출력
함수 호출 후에도 값이 유지되도록 했다.

### 4. Simple Addition (2)

``` asm
INCLUDE Irvine32.inc

.data
prompt1 BYTE "첫 번째 정수 입력: ",0
prompt2 BYTE "두 번째 정수 입력: ",0
resultMsg BYTE "합계: ",0
sum DWORD ?

.code
main PROC
    mov ecx, 3
L1:
    push ecx
    call Clrscr

    mov edx, OFFSET prompt1
    call WriteString
    call ReadInt
    mov ebx, eax

    mov edx, OFFSET prompt2
    call WriteString
    call ReadInt
    add eax, ebx
    mov sum, eax

    call Crlf
    mov edx, OFFSET resultMsg
    call WriteString
    mov eax, sum
    call WriteInt
    call Crlf
    call WaitMsg

    pop ecx
    loop L1
    exit
main ENDP
END main
```

3번 프로그램을 세 번 반복한다. ECX는 반복 횟수이므로 스택에 보관했다가
복원한다. 화면은 각 반복이 시작될 때 지운다.

### 5. BetterRandomRange Procedure

EBX에 M, EAX에 N을 전달하며 결과 범위는 M 이상 N 미만이다.

``` asm
INCLUDE Irvine32.inc

.code
BetterRandomRange PROC USES ebx
    sub eax, ebx
    call RandomRange
    add eax, ebx
    ret
BetterRandomRange ENDP

main PROC
    call Randomize
    mov ecx, 50
L1:
    push ecx
    mov ebx, -300
    mov eax, 100
    call BetterRandomRange
    call WriteInt
    call Crlf
    pop ecx
    loop L1
    exit
main ENDP
END main
```

`N-M` 범위의 난수를 생성한 뒤 M을 더한다. 예제의 범위는 -300부터
99까지다. M은 N보다 작아야 한다.

### 6. Random Strings

EAX에 길이 L, EDX에 문자열 버퍼 주소를 전달한다. 버퍼는 L+1바이트여야
한다.

``` asm
INCLUDE Irvine32.inc

.data
strBuffer BYTE 11 DUP(0)

.code
RandomString PROC USES ecx edi
    mov ecx, eax
    mov edi, edx
    cmp ecx, 0
    je Done
L1:
    mov eax, 26
    call RandomRange
    add eax, 'A'
    mov [edi], al
    inc edi
    loop L1
Done:
    mov BYTE PTR [edi], 0
    ret
RandomString ENDP

main PROC
    call Randomize
    mov ecx, 20
L1:
    push ecx
    mov eax, 10
    mov edx, OFFSET strBuffer
    call RandomString
    mov edx, OFFSET strBuffer
    call WriteString
    call Crlf
    pop ecx
    loop L1
    exit
main ENDP
END main
```

A\~Z 중 무작위 문자를 생성해 길이 10의 문자열을 만든다. 이를 20번
출력한다.

### 7. Random Screen Locations

``` asm
INCLUDE Irvine32.inc

.data
maxX BYTE ?
maxY BYTE ?
xPos BYTE ?
yPos BYTE ?

.code
main PROC
    call Randomize
    call GetMaxXY
    mov maxX, dl
    mov maxY, dh

    mov ecx, 100
L1:
    push ecx

    movzx eax, maxX
    call RandomRange
    mov xPos, al

    movzx eax, maxY
    call RandomRange
    mov yPos, al

    mov dl, xPos
    mov dh, yPos
    call Gotoxy

    mov al, '*'
    call WriteChar
    mov eax, 100
    call Delay

    pop ecx
    loop L1
    exit
main ENDP
END main
```

**수정 포인트:** 첫 좌표를 레지스터 DL에만 보관하면 두 번째
`RandomRange` 호출이 EDX를 변경할 수 있다. 따라서 x와 y를 메모리에 각각
저장한 뒤 Gotoxy에 전달한다.

### 8. Color Matrix

``` asm
INCLUDE Irvine32.inc

.code
main PROC
    mov ebx, 0              ; 배경색 0~15
L1:
    mov esi, 0              ; 전경색 0~15
L2:
    mov eax, ebx
    shl eax, 4
    or eax, esi
    call SetTextColor

    mov al, '*'
    call WriteChar

    inc esi
    cmp esi, 16
    jl L2

    call Crlf
    inc ebx
    cmp ebx, 16
    jl L1

    mov eax, 7
    call SetTextColor
    exit
main ENDP
END main
```

색상 값은 `배경색 × 16 + 전경색`으로 만든다. 전경색과 배경색을 각각
0\~15로 순회해 256개 조합을 표시한다.

### 9. Recursive Procedure

``` asm
INCLUDE Irvine32.inc

.data
counter DWORD 0

.code
RecursiveProc PROC
    push ecx
    inc counter
    loop Recurse
    jmp Done
Recurse:
    call RecursiveProc
Done:
    pop ecx
    ret
RecursiveProc ENDP

main PROC
    mov ecx, 5
    call RecursiveProc
    mov eax, counter
    call WriteDec
    call Crlf
    exit
main ENDP
END main
```

ECX를 5로 시작하면 카운터는 5가 된다. 각 호출은 ECX를 스택에 보관하고,
LOOP가 0이 아닐 때만 재귀 호출을 진행한다. 이 방식은 조건 분기 대신
LOOP를 사용한다.

### 10. Fibonacci Generator

``` asm
INCLUDE Irvine32.inc

.data
fibArray DWORD 47 DUP(?)

.code
Fibonacci PROC USES eax ebx ecx edx esi
    ; ESI = 배열 주소, ECX = 생성할 원소 수
    mov ebx, 1
    mov edx, 1

    cmp ecx, 0
    je Done

    mov [esi], ebx
    add esi, 4
    dec ecx
    cmp ecx, 0
    je Done

    mov [esi], edx
    add esi, 4
    dec ecx

L1:
    mov eax, ebx
    add eax, edx
    mov [esi], eax
    add esi, 4
    mov ebx, edx
    mov edx, eax
    loop L1

Done:
    ret
Fibonacci ENDP

main PROC
    mov esi, OFFSET fibArray
    mov ecx, LENGTHOF fibArray
    call Fibonacci
    exit
main ENDP
END main
```

배열에는 1, 1, 2, 3, 5, ... 순서로 47개가 저장된다. 마지막 값은
**2,971,215,073**이며 2,147,483,647보다 크므로 디버거에서 부호 없는
DWORD 값으로 확인한다.

### 11. Finding Multiples of K

``` asm
INCLUDE Irvine32.inc

.data
N = 50
numbers BYTE N DUP(0)

.code
FindMultiples PROC USES eax ebx ecx esi
    ; ESI = 배열 주소, EBX = K, ECX = N
    cmp ebx, 0
    jle Done
    mov eax, ebx

L1:
    cmp ebx, ecx
    jge Done
    mov BYTE PTR [esi+ebx], 1
    add ebx, eax
    jmp L1

Done:
    ret
FindMultiples ENDP

main PROC
    mov esi, OFFSET numbers
    mov ebx, 2
    mov ecx, N
    call FindMultiples

    mov esi, OFFSET numbers
    mov ebx, 3
    mov ecx, N
    call FindMultiples
    exit
main ENDP
END main
```

배열은 처음에 0으로 초기화된다. K=2를 먼저 실행하고 K=3을 실행하면 2
또는 3의 양의 배수인 인덱스 2\~49에 1이 표시된다. 인덱스 0은 이 풀이에서
양의 배수 목록에 포함하지 않는다. USES를 사용해 변경한 레지스터를
보존한다.
