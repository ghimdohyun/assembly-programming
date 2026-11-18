# Chapter 9 — Strings and Arrays

Assembly Language (MASM / Irvine32) 연습문제 풀이

> 기준: 32-bit MASM, Irvine32 라이브러리, null-terminated 문자열  
> 모든 코드는 학습용 예시다. 각 코드 블록은 문제에서 요구하는 핵심 구현을 보여준다. 실행 환경에 따라 프로젝트의 Irvine32 경로와 시작 코드(`.386`, `.model flat, stdcall`, `option casemap:none`)를 설정해야 한다.

## 목차

- [9.9.1 Short Answer](#991-short-answer)
- [9.9.2 Algorithm Workbench](#992-algorithm-workbench)
- [9.10 Programming Exercises](#910-programming-exercises)

---

# 9.9.1 Short Answer

## 1. Direction flag가 인덱스 레지스터를 역방향으로 이동하게 하는 설정은?

**DF를 1로 설정하는 `STD` 명령어**이다. 문자열 명령어 실행 후 인덱스 레지스터가 감소한다.

## 2. 반복 접두사와 STOSW를 사용할 때 인덱스 레지스터의 증감량은?

`STOSW`는 word(2바이트)를 저장하므로 DF가 0이면 인덱스 레지스터가 **2 증가**하고, DF가 1이면 **2 감소**한다.

## 3. CMPS 명령어는 어떤 점에서 모호한가?

두 메모리 피연산자를 비교하지만 명령어 자체에는 어느 문자열이 목적 문자열인지, 어느 쪽이 원본 문자열인지가 드러나지 않는다. 실제 비교 대상은 `DS:ESI`와 `ES:EDI`가 가리키는 값이다.

## 4. DF가 clear된 상태에서 SCASB가 일치하는 문자를 찾으면 EDI는 어디를 가리키는가?

`SCASB` 실행 후 EDI는 비교한 문자 다음 위치를 가리킨다. DF=0이면 비교 후 EDI가 1 증가하기 때문이다.

## 5. 배열에서 특정 문자의 첫 번째 일치 항목을 찾을 때 적합한 반복 접두사는?

**`REPNE`** (`REPNZ`)이다. 일치하지 않는 동안 반복하고, 일치하면 반복을 멈춘다.

## 6. Section 9.3의 Str_trim 프로시저에서 사용하는 Direction flag 설정은?

문자열을 뒤에서 앞으로 검사하는 방식이므로 **DF=1 (`STD`)**을 사용한다. 프로시저가 끝난 뒤 다른 문자열 명령어에 영향을 주지 않도록 DF를 다시 clear하는 것이 안전하다.

## 7. Str_trim 프로시저가 JNE를 사용하는 이유는?

현재 문자가 제거 대상 문자와 **같지 않은 동안** 뒤쪽 문자를 계속 검사하거나 종료 위치를 찾기 위해서다. `JNE`는 Zero flag가 0일 때 분기한다.

## 8. Str_ucase 프로시저의 대상 문자열에 숫자가 있으면 어떻게 되는가?

정상적인 대문자 변환 구현은 소문자 `a`~`z`만 대문자로 바꾸므로 숫자는 그대로 유지된다. 숫자는 소문자 범위에 포함되지 않는다.

## 9. SCASB를 사용하도록 Str_length를 작성한다면 어떤 반복 접두사가 적합한가?

**`REPNE SCASB`**가 적합하다. null 문자(0)를 찾을 때까지 검색한다.

## 10. SCASB를 사용하는 Str_length는 문자열 길이를 어떻게 계산하는가?

문자열 끝의 null 문자를 찾을 때까지 검사한 횟수를 이용한다. 시작 주소와 null 문자를 찾은 뒤의 EDI 위치 차이에서 null 문자 1바이트를 제외하면 길이가 된다.

예를 들어 시작 주소를 `startEDI`라 하면 길이는 `(EDI - startEDI) - 1`이다.

## 11. 원소가 1,024개인 배열의 이진 검색에서 필요한 최대 비교 횟수는?

최대 **11회**이다. 이진 검색의 최악 비교 횟수는 `ceil(log2(n + 1))`이며, `ceil(log2(1025)) = 11`이다.

## 12. Binary Search 예제의 FillArray에서 CLD가 필요한 이유는?

`STOSD` 등의 문자열 저장 명령어가 배열의 낮은 주소에서 높은 주소 방향으로 이동하도록 하기 위해서다. `CLD`는 Direction flag를 0으로 설정한다.

## 13. BinarySearch의 L2 문장을 제거해도 결과가 바뀌지 않는 이유는?

L2 문장이 현재 반복에서 이미 수행한 비교 또는 레지스터 값을 다시 설정하는 중복 작업이기 때문이다. 이후 분기와 탐색 범위 갱신에 영향을 주지 않는다면 제거해도 검색 결과는 같다.

> L2의 정확한 명령어는 교재 Section 9.5의 원본 코드가 있어야 특정할 수 있다. 이 답은 문제에 제시된 제거 가능 조건에 대한 일반적인 설명이다.

## 14. BinarySearch의 L4 문장을 어떻게 제거할 수 있는가?

L4가 조건 분기를 위한 중간 레이블 또는 중복된 범위 갱신 명령어라면, 해당 분기 조건을 앞선 분기와 결합하거나 L4로 향하는 분기를 실제 처리 명령어로 직접 연결할 수 있다.

> L4의 실제 명령어가 제공되지 않아 구체적인 대체 코드는 단정할 수 없다. 교재 Section 9.5의 BinarySearch 코드와 대조해야 한다.

---

# 9.9.2 Algorithm Workbench

## 1. 32-bit mode의 base-index operand 예시

```asm
mov eax, [ebx + esi]
```

EBX를 base register, ESI를 index register로 사용한다.

## 2. 32-bit mode의 base-index-displacement operand 예시

```asm
mov eax, [ebx + esi + 8]
```

유효 주소는 `EBX + ESI + 8`이다.

## 3. 3행 4열 doubleword 배열에서 두 번째 행의 세 번째 열 주소

행과 열의 인덱스는 0부터 시작한다. 따라서 대상은 row=1, column=2이다.

```asm
; ESI = 배열 시작 주소
; EDI = 열 인덱스(2)
; 각 원소는 4바이트, 한 행은 4 * 4 = 16바이트
mov eax, [esi + 16 + edi*4]
```

이때 EDI에 2가 들어 있어야 한다. 주소는 `base + 1*16 + 2*4 = base + 24`이다.

## 4. CMPSW로 두 16-bit 배열 비교

```asm
.data
sourcew WORD 10, 20, 30, 40
targetw WORD 10, 20, 35, 40

.code
mov esi, OFFSET sourcew
mov edi, OFFSET targetw
mov ecx, LENGTHOF sourcew
cld
repe cmpsw              ; 서로 같은 동안 비교
je arraysEqual
; 다르면 이곳으로 진행
```

두 배열의 원소 개수가 같다는 전제다. `REPE`는 비교 결과가 같을 동안 반복한다.

## 5. SCASW로 0100h를 검색하고 일치 원소의 offset을 EAX에 저장

```asm
.data
wordArray WORD 0010h, 0020h, 0100h, 0200h
.code
mov edi, OFFSET wordArray
mov ecx, LENGTHOF wordArray
mov ax, 0100h
cld
repne scasw
jnz notFound

mov eax, edi
sub eax, TYPE wordArray ; SCASW 후 EDI는 다음 원소를 가리킴
jmp searchDone

notFound:
mov eax, 0FFFFFFFFh      ; 찾지 못한 경우 -1 표시

searchDone:
```

## 6. Str_compare로 두 입력 문자열 중 더 큰 문자열을 콘솔에 출력

Irvine32의 `Str_compare`는 ESI와 EDI가 가리키는 문자열을 비교한다. 아래 예시는 비교 결과가 ESI 문자열 - EDI 문자열의 순서로 플래그에 반영된다는 전제다.

```asm
.data
firstStr  BYTE "ORANGE", 0
secondStr BYTE "APPLE", 0
.code
mov esi, OFFSET firstStr
mov edi, OFFSET secondStr
call Str_compare
ja firstIsLarger          ; unsigned 비교에서 ESI > EDI
mov edx, OFFSET secondStr
jmp printLarger

firstIsLarger:
mov edx, OFFSET firstStr

printLarger:
call WriteString
call Crlf
```

문자열 비교의 대소 판정은 문자 코드의 사전식(lexicographic) 비교다.

## 7. Str_trim을 호출하여 문자열 끝의 @ 제거

Irvine32의 `Str_trim`을 사용한다.

```asm
.data
target BYTE "HELLO@@@@", 0
.code
mov edx, OFFSET target
mov al, '@'
call Str_trim

mov edx, OFFSET target
call WriteString
call Crlf
```

## 8. Str_ucase를 소문자 변환 프로시저로 수정

대문자 `A`~`Z`에 해당하는 문자에 20h를 더하면 소문자가 된다.

```asm
; ESI = 문자열 시작 주소
; null 문자를 만날 때까지 대문자만 소문자로 변경
Str_lcase PROC
    push esi
    push eax

L1:
    mov al, [esi]
    cmp al, 0
    je L2

    cmp al, 'A'
    jb Lnext
    cmp al, 'Z'
    ja Lnext

    add BYTE PTR [esi], 20h

Lnext:
    inc esi
    jmp L1

L2:
    pop eax
    pop esi
    ret
Str_lcase ENDP
```

## 9. 64-bit 버전의 Str_trim

아래는 문자열 끝의 지정 문자를 제거하는 간단한 x64 예시다. RCX는 문자열 주소, DL은 제거할 문자다.

```asm
; RCX = 문자열 주소
; DL  = 제거할 문자
Str_trim64 PROC
    push rsi
    push rax
    push rdx

    mov rsi, rcx

; 문자열 끝 찾기
L1:
    cmp BYTE PTR [rsi], 0
    je L2
    inc rsi
    jmp L1

; 마지막 문자부터 제거
L2:
    dec rsi
    cmp rsi, rcx
    jb Ldone

    mov al, [rsi]
    cmp al, dl
    jne Ldone

    mov BYTE PTR [rsi], 0
    jmp L2

Ldone:
    pop rdx
    pop rax
    pop rsi
    ret
Str_trim64 ENDP
```

## 10. 64-bit mode의 base-index operand 예시

```asm
mov rax, [rbx + rsi]
```

RBX와 RSI를 이용해 메모리 주소를 계산한다.

## 11. EBX 행 인덱스, EDI 열 인덱스로 32-bit 배열 원소를 EAX에 저장

행의 원소 수(열 개수)가 필요하다. 아래는 **한 행에 4개 원소가 있는 배열**을 가정한 주소 계산이다.

```asm
; EBX = row index, EDI = column index
; 한 행은 4개의 DWORD = 16바이트
; x86 주소식은 scaled index를 하나만 허용하므로
; 행 바이트 오프셋을 먼저 계산해야 한다.
lea ebx, [ebx*8 + ebx*8] ; EBX = row index * 16
mov eax, myArray[ebx + edi*4]
```

실제 배열의 열 개수가 4가 아니라면 `16`을 `열 개수 * 4`로 바꿔야 한다. `mov` 한 문장만으로 두 개의 독립적인 scaled index를 표현할 수는 없다.

## 12. RBX 행 인덱스, RDI 열 인덱스로 64-bit 배열 원소를 RAX에 저장

한 행에 4개의 QWORD가 있다고 가정하면 행 크기는 32바이트다.

```asm
; RBX = row index, RDI = column index
; 한 행은 4개의 QWORD = 32바이트
imul rbx, rbx, 32       ; RBX = row index * 32
mov rax, myArray[rbx + rdi*8]
```

배열의 실제 열 개수에 따라 행 크기를 조정해야 한다. x86-64 메모리 주소식도 scaled index는 하나만 직접 표현할 수 있다.

---

# 9.10 Programming Exercises

각 문제는 32-bit MASM / Irvine32 기준이다. 프로시저의 매개변수 전달 방식은 문제의 예시와 읽기 쉬운 레지스터 규약을 우선해 작성했다.

## 1. Improved Str_copy Procedure

**요구사항:** 최대 복사 문자 수를 추가로 전달하는 `Str_copyN`을 작성한다. 아래 코드는 ESI=source, EDI=target, ECX=maxCount를 사용한다. 대상 문자열은 최대 복사 길이 + null 문자 1바이트의 공간이 있어야 한다.

```asm
Str_copyN PROC
    push eax
    push ecx
    push esi
    push edi

    cld
    jecxz copyDone

copyLoop:
    lodsb
    stosb
    cmp al, 0
    je copyDone
    loop copyLoop

    ; 최대 길이만큼 복사했으면 null 종료
    mov BYTE PTR [edi], 0

copyDone:
    pop edi
    pop esi
    pop ecx
    pop eax
    ret
Str_copyN ENDP
```

호출 예시:

```asm
.data
source BYTE "Assembly Language", 0
target BYTE 11 DUP(0)

.code
mov esi, OFFSET source
mov edi, OFFSET target
mov ecx, 10
call Str_copyN
```

## 2. Str_concat Procedure

**요구사항:** source 문자열을 target 문자열 끝에 연결한다. target에는 연결 결과를 저장할 충분한 공간이 있어야 한다.

```asm
Str_concat PROC
    ; ESI = source 주소, EDI = target 주소
    push eax
    push esi
    push edi

    ; target의 null 문자 위치 찾기
findEnd:
    cmp BYTE PTR [edi], 0
    je appendStart
    inc edi
    jmp findEnd

appendStart:
    ; source를 target 끝에 복사
copyLoop:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0
    jne copyLoop

    pop edi
    pop esi
    pop eax
    ret
Str_concat ENDP
```

호출 예시:

```asm
.data
targetStr BYTE "ABCDE", 10 DUP(0)
sourceStr BYTE "FGH", 0

.code
mov edi, OFFSET targetStr
mov esi, OFFSET sourceStr
call Str_concat
```

결과: `ABCDEFGH`

## 3. Str_remove Procedure

**요구사항:** 문자열의 특정 위치에서 n개의 문자를 제거한다. ESI는 제거 시작 주소, ECX는 제거할 문자 수다. 제거 뒤 문자열의 나머지 부분과 null 문자까지 앞으로 이동시킨다.

```asm
Str_remove PROC
    ; ESI = 제거 시작 위치, ECX = 제거할 문자 수
    push eax
    push ebx
    push esi
    push edi

    mov edi, esi
    add esi, ecx

moveRest:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0
    jne moveRest

    pop edi
    pop esi
    pop ebx
    pop eax
    ret
Str_remove ENDP
```

호출 예시:

```asm
.data
target BYTE "abcxxxxdefghijklmop", 0

.code
mov esi, OFFSET target
add esi, 3
mov ecx, 4
call Str_remove
```

결과: `abcdefghijklmop`

## 4. Str_find Procedure

**요구사항:** target 문자열 안에서 source 문자열이 처음 나타나는 위치를 찾는다. 찾으면 EAX에 일치 위치를 반환하고 ZF=1, 찾지 못하면 ZF=0이다.

```asm
Str_find PROC
    ; ESI = source 시작 주소, EDI = target 시작 주소
    ; 반환: 찾으면 EAX = target 내 일치 주소, ZF=1
    ;       못 찾으면 EAX=0, ZF=0
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov ebx, esi             ; source 시작 주소 보관

tryPosition:
    cmp BYTE PTR [edi], 0
    je findFailed

    mov esi, ebx             ; source 처음부터 비교
    mov edx, edi             ; 현재 target 후보 위치

compareChars:
    mov al, [esi]
    cmp al, 0
    je findSucceeded         ; source 전체가 일치

    cmp al, [edx]
    jne nextPosition

    inc esi
    inc edx
    jmp compareChars

nextPosition:
    inc edi
    jmp tryPosition

findSucceeded:
    mov eax, edi
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    cmp eax, eax             ; 성공: ZF=1
    ret

findFailed:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    mov eax, 0
    or eax, 1                ; 실패: ZF=0
    ret
Str_find ENDP
```

호출 예시:

```asm
.data
target BYTE "123ABC342432", 0
source BYTE "ABC", 0
pos    DWORD ?

.code
mov esi, OFFSET source
mov edi, OFFSET target
call Str_find
jnz notFound
mov pos, eax

notFound:
```

> 주의: 위 예시는 프로시저의 ZF 반환 규칙을 보여주기 위한 구현이다. 호출 규약을 변경하거나 스택 프레임을 추가할 경우 `[esp+16]`의 위치도 함께 조정해야 한다. 실제 프로젝트에서는 아래처럼 source 시작 주소를 별도 보존 레지스터에 두는 구현이 더 단순하고 안전하다.

## 5. Str_nextWord Procedure

**요구사항:** 지정한 delimiter를 찾아 null 문자로 바꾸고, 다음 문자의 주소를 EAX에 반환한다. 찾으면 ZF=1이다.

```asm
Str_nextWord PROC USES ebx esi, pString:PTR BYTE, delimiter:BYTE
    ; 찾으면 EAX = delimiter 다음 문자 주소, ZF=1
    ; 못 찾으면 EAX=0, ZF=0
    mov esi, pString
    mov bl, delimiter

scanLoop:
    mov al, [esi]
    cmp al, 0
    je delimiterNotFound

    cmp al, bl
    je delimiterFound

    inc esi
    jmp scanLoop

delimiterFound:
    mov BYTE PTR [esi], 0
    lea eax, [esi+1]
    cmp eax, eax             ; ZF=1
    ret

delimiterNotFound:
    mov eax, 0
    or eax, 1                 ; ZF=0
    ret
Str_nextWord ENDP
```

호출 예시:

```asm
.data
target BYTE "Johnson,Calvin", 0

.code
INVOKE Str_nextWord, ADDR target, ','
jnz notFound
; EAX는 "Calvin"의 시작 주소
mov edx, eax
call WriteString
```

## 6. Constructing a Frequency Table

**요구사항:** 문자열의 각 문자가 등장한 횟수를 ASCII 코드에 해당하는 frequency table 위치에 저장한다. 배열은 DWORD 256개이며 0으로 초기화되어 있어야 한다.

```asm
Get_frequencies PROC
    ; ESI = 문자열 주소, EDI = DWORD[256] frequency table
    push eax
    push ebx
    push esi
    push edi

scanString:
    mov al, [esi]
    cmp al, 0
    je frequencyDone

    movzx ebx, al
    inc DWORD PTR [edi + ebx*4]

    inc esi
    jmp scanString

frequencyDone:
    pop edi
    pop esi
    pop ebx
    pop eax
    ret
Get_frequencies ENDP
```

호출 예시:

```asm
.data
target BYTE "AAEBDCFBBC", 0
freqTable DWORD 256 DUP(0)

.code
mov esi, OFFSET target
mov edi, OFFSET freqTable
call Get_frequencies
```

예상 결과 일부:

| 문자 | ASCII | 빈도 |
|---|---:|---:|
| A | 41h | 2 |
| B | 42h | 3 |
| C | 43h | 2 |
| D | 44h | 1 |
| E | 45h | 1 |
| F | 46h | 1 |

## 7. Sieve of Eratosthenes

**요구사항:** 2부터 65,000까지의 소수를 에라토스테네스의 체로 구한다. 배열은 65,001바이트이며, 0은 소수 후보, 1은 합성수 표시로 사용한다.

```asm
INCLUDE Irvine32.inc

.data
sieve BYTE 65001 DUP(?)
msg BYTE "Prime numbers:", 0

.code
main PROC
    ; 배열 전체를 0으로 초기화
    mov edi, OFFSET sieve
    mov ecx, LENGTHOF sieve
    mov al, 0
    cld
    rep stosb

    ; 0과 1은 소수가 아님
    mov sieve[0], 1
    mov sieve[1], 1

    mov ebx, 2              ; 현재 소수 후보

outerLoop:
    mov eax, ebx
    imul eax, ebx           ; ebx * ebx
    cmp eax, 65000
    ja doneSieve

    cmp sieve[ebx], 0
    jne nextCandidate

    ; ebx의 배수를 합성수로 표시
    mov eax, ebx
    add eax, ebx            ; 2 * ebx부터 시작
markMultiples:
    cmp eax, 65000
    ja nextCandidate
    mov sieve[eax], 1
    add eax, ebx
    jmp markMultiples

nextCandidate:
    inc ebx
    jmp outerLoop

doneSieve:
    mov edx, OFFSET msg
    call WriteString
    call Crlf

    mov ebx, 2
printPrimes:
    cmp ebx, 65000
    ja finish

    cmp sieve[ebx], 0
    jne nextPrint

    mov eax, ebx
    call WriteDec
    mov al, ' '
    call WriteChar

nextPrint:
    inc ebx
    jmp printPrimes

finish:
    call Crlf
    exit
main ENDP
END main
```

## 8. Bubble Sort — Exchange Flag

**요구사항:** 한 번의 전체 pass에서 교환이 한 번도 발생하지 않으면 정렬을 조기에 종료한다.

```asm
BubbleSort PROC
    ; ESI = DWORD 배열 주소, ECX = 원소 개수
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    cmp ecx, 1
    jbe sortDone

    dec ecx                  ; pass당 비교 횟수
outerPass:
    mov ebx, 0               ; exchange flag = 0
    mov edi, 0               ; 현재 인덱스

innerLoop:
    cmp edi, ecx
    jae endPass

    mov eax, [esi + edi*4]
    mov edx, [esi + edi*4 + 4]
    cmp eax, edx
    jbe noExchange

    mov [esi + edi*4], edx
    mov [esi + edi*4 + 4], eax
    mov ebx, 1

noExchange:
    inc edi
    jmp innerLoop

endPass:
    cmp ebx, 0
    je sortDone              ; 교환이 없으면 정렬 완료

    dec ecx
    jnz outerPass

sortDone:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
BubbleSort ENDP
```

## 9. Binary Search

**요구사항:** `mid`, `first`, `last`를 레지스터로 관리하고 주석으로 역할을 설명한다. 배열은 오름차순으로 정렬되어 있어야 한다.

```asm
BinarySearch PROC
    ; ESI = DWORD 배열 주소
    ; ECX = 원소 개수
    ; EAX = 찾을 값
    ; 반환: EDX = 인덱스, 못 찾으면 -1
    push ebx
    push edi

    mov ebx, 0               ; first
    mov edi, ecx
    dec edi                  ; last

searchLoop:
    cmp ebx, edi
    ja notFound

    ; mid = (first + last) / 2
    mov edx, ebx
    add edx, edi
    shr edx, 1

    cmp eax, [esi + edx*4]
    je found

    jb searchLeft            ; 찾을 값 < 중간값

    ; 찾을 값 > 중간값: 오른쪽 절반
    lea ebx, [edx+1]
    jmp searchLoop

searchLeft:
    ; 왼쪽 절반
    lea edi, [edx-1]
    jmp searchLoop

found:
    ; EDX에 찾은 인덱스
    pop edi
    pop ebx
    ret

notFound:
    mov edx, -1
    pop edi
    pop ebx
    ret
BinarySearch ENDP
```

## 10. Letter Matrix

**요구사항:** 모음이 선택될 확률이 50%인 4×4 대문자 행렬을 만든다. 아래 예시는 Irvine32의 `RandomRange`를 사용한다.

```asm
INCLUDE Irvine32.inc

.data
vowels BYTE "AEIOU"
consonants BYTE "BCDFGHJKLMNPQRSTVWXYZ"
matrix BYTE 16 DUP(?)

.code
main PROC
    call Randomize

    mov esi, OFFSET matrix
    mov ecx, 16

makeMatrix:
    ; 0 또는 1을 선택해 모음/자음 확률을 50:50으로 설정
    mov eax, 2
    call RandomRange
    cmp eax, 0
    jne chooseConsonant

    ; 모음 5개 중 하나
    mov eax, 5
    call RandomRange
    mov al, vowels[eax]
    jmp storeLetter

chooseConsonant:
    ; 자음 21개 중 하나
    mov eax, 21
    call RandomRange
    mov al, consonants[eax]

storeLetter:
    mov [esi], al
    inc esi
    loop makeMatrix

    ; 4 x 4 출력
    mov esi, OFFSET matrix
    mov ecx, 16
    mov ebx, 0

printMatrix:
    mov al, [esi]
    call WriteChar
    mov al, ' '
    call WriteChar

    inc esi
    inc ebx
    cmp ebx, 4
    jne continuePrint

    call Crlf
    mov ebx, 0

continuePrint:
    loop printMatrix

    exit
main ENDP
END main
```

## 11. Letter Matrix / Sets with Vowels

**요구사항:** 4×4 행렬의 각 행, 열, 두 대각선을 4글자 집합으로 검사하고 모음이 정확히 2개인 집합만 출력한다.

아래 예시는 교재에 나온 행렬을 사용해 10개 집합(행 4개 + 열 4개 + 대각선 2개)을 모두 검사한다.

```asm
INCLUDE Irvine32.inc

.data
matrix BYTE "POAZ", "AEAU", "GKAE", "IAGD"
setBuffer BYTE 5 DUP(0)

.code
; ESI = 검사할 4글자 집합
; 모음이 정확히 2개이면 해당 집합 출력
CheckAndPrintSet PROC
    push eax
    push ebx
    push ecx
    push esi
    push edx

    mov ebx, 0
    mov ecx, 4

countLoop:
    mov al, [esi]
    cmp al, 'A'
    je vowelFound
    cmp al, 'E'
    je vowelFound
    cmp al, 'I'
    je vowelFound
    cmp al, 'O'
    je vowelFound
    cmp al, 'U'
    je vowelFound
    jmp nextChar

vowelFound:
    inc ebx

nextChar:
    inc esi
    loop countLoop

    cmp ebx, 2
    jne checkDone

    ; 원래 집합 주소는 저장된 ESI 값
    mov edx, [esp+4]
    call WriteString
    call Crlf

checkDone:
    pop edx
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
CheckAndPrintSet ENDP

; 네 인덱스로 matrix에서 4글자를 모아 검사
MAKE_SET MACRO i1, i2, i3, i4
    mov al, matrix[i1]
    mov setBuffer[0], al
    mov al, matrix[i2]
    mov setBuffer[1], al
    mov al, matrix[i3]
    mov setBuffer[2], al
    mov al, matrix[i4]
    mov setBuffer[3], al
    mov BYTE PTR setBuffer[4], 0
    mov esi, OFFSET setBuffer
    call CheckAndPrintSet
ENDM

main PROC
    ; 행 4개
    MAKE_SET 0, 1, 2, 3
    MAKE_SET 4, 5, 6, 7
    MAKE_SET 8, 9, 10, 11
    MAKE_SET 12, 13, 14, 15

    ; 열 4개
    MAKE_SET 0, 4, 8, 12
    MAKE_SET 1, 5, 9, 13
    MAKE_SET 2, 6, 10, 14
    MAKE_SET 3, 7, 11, 15

    ; 두 대각선
    MAKE_SET 0, 5, 10, 15
    MAKE_SET 3, 6, 9, 12

    exit
main ENDP
END main
```

예시 행렬:

```text
P O A Z
A E A U
G K A E
I A G D
```

정확히 모음 2개인 집합만 출력된다. 교재 예시의 결과는 `POAZ`, `GKAE`, `IAGD`, `PAGI`, `ZUED`, `PEAD`, `ZAKI`이다.

## 12. Calculating the Sum of an Array Row

**요구사항:** 배열 주소, 행 크기, 원소 타입 크기, 행 인덱스를 스택 매개변수로 전달한다. `INVOKE`나 확장 PROC를 사용하지 않는다. 결과는 EAX로 반환한다.

아래 구현에서 `rowSize`는 한 행의 원소 개수, `arrayType`은 원소 크기(1, 2, 4바이트)다.

```asm
calc_row_sum PROC
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    push edx
    push esi

    ; [ebp+8]  = array offset
    ; [ebp+12] = row size (원소 개수)
    ; [ebp+16] = array type (1, 2, 4)
    ; [ebp+20] = row index

    mov esi, [ebp+8]        ; 배열 시작 주소
    mov eax, [ebp+20]       ; row index
    mul DWORD PTR [ebp+12]  ; row index * row size
    mul DWORD PTR [ebp+16]  ; 바이트 오프셋

    add esi, eax            ; 선택한 행의 시작 주소

    mov ecx, [ebp+12]       ; 행의 원소 수
    mov ebx, [ebp+16]       ; 원소 크기
    xor eax, eax            ; 합계

sumLoop:
    cmp ecx, 0
    je sumDone

    cmp ebx, 1
    je sumByte
    cmp ebx, 2
    je sumWord

    mov edx, [esi]          ; DWORD
    add esi, 4
    jmp addValue

sumWord:
    movzx edx, WORD PTR [esi]
    add esi, 2
    jmp addValue

sumByte:
    movzx edx, BYTE PTR [esi]
    inc esi

addValue:
    add eax, edx
    dec ecx
    jmp sumLoop

sumDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop ebp
    ret 16
calc_row_sum ENDP
```

호출 예시(스택에 오른쪽부터 push):

```asm
; push row index
; push array type
; push row size
; push array offset
; call calc_row_sum
push 1
push 4
push 3
push OFFSET dwordArray
call calc_row_sum
; EAX = 두 번째 행의 합
```

## 13. Trimming Leading Characters

**요구사항:** 문자열 앞부분에서 지정한 문자가 연속으로 나타나는 동안 제거한다.

```asm
Str_trimLeading PROC
    ; ESI = 문자열 주소, AL = 제거할 문자
    push ebx
    push ecx
    push esi
    push edi

    mov bl, al
    mov edi, esi

findFirst:
    mov al, [esi]
    cmp al, bl
    jne shiftString
    inc esi
    jmp findFirst

shiftString:
    ; 제거 후 문자열 전체를 앞으로 이동(null 포함)
copyRest:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0
    jne copyRest

    pop edi
    pop esi
    pop ecx
    pop ebx
    ret
Str_trimLeading ENDP
```

호출 예시:

```asm
.data
target BYTE "###ABC", 0

.code
mov esi, OFFSET target
mov al, '#'
call Str_trimLeading
```

결과: `ABC`

## 14. Trimming a Set of Characters

**요구사항:** 문자열 끝에서 filter 배열에 포함된 문자를 모두 제거한다. 문자열과 필터 배열은 null-terminated라고 가정한다.

```asm
Str_trimSet PROC
    ; ESI = 대상 문자열 주소, EDI = 필터 문자열 주소
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov ebx, esi             ; 대상 문자열 시작 주소
    mov edx, edi             ; 필터 문자열 시작 주소

trimAgain:
    mov esi, ebx             ; 문자열 처음부터 끝 위치 찾기

findStringEnd:
    cmp BYTE PTR [esi], 0
    je checkLast
    inc esi
    jmp findStringEnd

checkLast:
    cmp esi, ebx
    je trimDone              ; 빈 문자열이면 종료

    dec esi
    mov al, [esi]            ; 마지막 문자
    mov edi, edx             ; 필터 문자열 처음부터 검사

checkFilter:
    mov cl, [edi]
    cmp cl, 0
    je trimDone              ; 필터에 없으면 종료

    cmp al, cl
    je removeLast

    inc edi
    jmp checkFilter

removeLast:
    mov BYTE PTR [esi], 0
    jmp trimAgain            ; 새 문자열의 마지막 문자 다시 검사

trimDone:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
Str_trimSet ENDP
```

호출 예시:

```asm
.data
target BYTE "ABC#$&", 0
filter BYTE "%#!;$&*", 0

.code
mov esi, OFFSET target
mov edi, OFFSET filter
call Str_trimSet
```

결과: `ABC`

---
