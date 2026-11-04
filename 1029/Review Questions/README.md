# Chapter 7. Integer Arithmetic
## Review Questions & Exercises

> 정수 산술(Integer Arithmetic)의 기본 개념과 시프트, 회전, 곱셈, 나눗셈, BCD 연산을 학습한다.

# 7.9 Review Questions and Exercises

## 7.9.1 Short Answer

### 1. Shift and Rotate Instructions

초기값은 `AL = D4h`이다.

```asm
mov al, 0D4h
shr al, 1
```

| 명령어 | 결과(AL) | 설명 |
|---|---|---|
| SHR AL, 1 | 6Ah | 오른쪽 논리 시프트 |
| SAR AL, 1 | EAh | 부호 비트를 유지하며 오른쪽 시프트 |
| SAR AL, 4 | FDh | 부호 비트를 유지하며 4비트 시프트 |
| ROL AL, 1 | A9h | 왼쪽으로 1비트 회전 |

**풀이**

- `D4h = 11010100b`
- `SHR`: 왼쪽에 0을 채운다.
- `SAR`: 최상위 부호 비트를 유지한다.
- `ROL`: 왼쪽으로 밀려난 비트를 오른쪽 끝에 다시 넣는다.

### 2. Rotate Instructions and Carry Flag

초기값은 `AL = D4h`이다.

| 명령어 | 결과(AL) | CF |
|---|---:|---:|
| ROR AL, 3 | 9Ah | 1 |
| ROL AL, 7 | 6Ah | 0 |
| STC / RCL AL, 1 | A9h | 1 |
| STC / RCR AL, 3 | FAh | 1 |

**풀이**

- `ROR`: 오른쪽 회전
- `ROL`: 왼쪽 회전
- `RCL`: Carry Flag를 포함하여 왼쪽 회전
- `RCR`: Carry Flag를 포함하여 오른쪽 회전
- `STC`: Carry Flag를 1로 설정한다.

### 3. MUL Instruction

```asm
mov ax, 0222h
mov bx, 0100h
mul bx
```

**풀이**

```text
0222h × 0100h = 00022200h
```

16비트 곱셈 결과는 DX:AX에 저장된다.

| 레지스터 | 결과 |
|---|---|
| DX | 0002h |
| AX | 2200h |

### 4. DIV Instruction

```asm
mov ax, 0063h
mov bl, 10h
div bl
```

**풀이**

```text
63h ÷ 10h = 6 ... 3
```

8비트 나눗셈 결과는 AL에 몫, AH에 나머지가 저장된다.

| 레지스터 | 결과 |
|---|---|
| AL | 06h |
| AH | 03h |
| AX | 0306h |

### 5. 32-bit DIV Instruction

```asm
mov edx, 0
mov eax, 00123400h
mov ebx, 10h
div ebx
```

**풀이**

```text
00123400h ÷ 10h = 00012340h
```

| 레지스터 | 결과 |
|---|---|
| EAX | 00012340h |
| EDX | 00000000h |

32비트 나눗셈에서 피제수는 EDX:EAX에 저장된다.

### 6. 16-bit DIV Instruction

```asm
mov dx, 0005h
mov ax, 4000h
mov bx, 10h
div bx
```

**풀이**

```text
00054000h ÷ 10h = 00005400h
```

| 레지스터 | 결과 |
|---|---|
| AX | 5400h |
| DX | 0000h |

### 7. ADC Instruction

```asm
mov bx, 5
stc
mov ax, 60h
adc bx, ax
```

**풀이**

`ADC`는 Carry Flag를 포함하여 덧셈을 수행한다.

```text
BX = 5
AX = 60h
CF = 1

BX = 5 + 60h + 1
BX = 66h
```

**결과**

```text
BX = 0066h
```

### 8. 64-bit DIV Instruction

```asm
mov rdx, 108h
mov rax, 33300020h
mov rcx, 100h
div rcx
```

**풀이**

```text
RDX:RAX = 108h:33300020h
Divisor = 100h
```

수학적으로 계산하면 다음과 같다.

```text
Quotient  = 10800000000333000h
Remainder = 20h
```

그러나 몫이 64비트 범위를 초과한다.

**결과**

```text
Divide Error (#DE)
```

64비트 `DIV` 명령어는 몫이 RAX에 저장될 수 있어야 한다. 따라서 이 명령어는 정상적으로 완료되지 않는다.

### 9. Correcting the Subtraction Program

8바이트 정수 두 개를 빼는 프로그램이다.

**기존 코드의 문제점**

- `MOV ESI, val1`은 주소가 아닌 메모리 값을 불러온다.
- 뺄셈 결과를 저장할 위치가 명확하지 않다.
- `DEC`를 사용하므로 가장 높은 바이트부터 처리해야 한다.

**수정 코드**

```asm
.data
val1   BYTE 8 DUP(0)
val2   BYTE 8 DUP(0)
result BYTE 8 DUP(0)

.code
    lea esi, val1+7
    lea edi, val2+7
    lea ebx, result+7

    mov ecx, 8
    clc

L1:
    mov al, [esi]
    sbb al, [edi]
    mov [ebx], al

    dec esi
    dec edi
    dec ebx

    loop L1
```

**풀이**

- 가장 낮은 자리부터 계산하기 위해 마지막 바이트에서 시작한다.
- `SBB`는 Carry Flag를 이용하여 이전 바이트의 빌림을 반영한다.
- `DEC`와 `LOOP`는 Carry Flag를 변경하지 않으므로 빌림이 다음 반복으로 전달된다.
- 계산 결과는 `result`에 저장한다.

### 10. 64-bit Multiplication

```asm
mov rax, 0001020304050000h
mov rbx, 4
mul rbx
```

**풀이**

```text
0001020304050000h × 4
= 0004080C10140000h
```

**결과**

```text
RAX = 0004080C10140000h
RDX = 0000000000000000h
```

---

## 7.9.2 Algorithm Workbench

### 1. Sign Extension

AX의 부호를 EAX 전체에 확장한다.

```asm
shl eax, 16
sar eax, 16
```

**풀이**

- `SHL`로 AX의 상위 비트를 제거한다.
- `SAR`로 부호 비트를 유지하면서 오른쪽으로 이동한다.
- 결과적으로 AX의 부호가 EAX 전체에 확장된다.

### 2. Rotate Right Using SHR

```asm
shr al, 1
jnc Skip
or al, 80h

Skip:
```

**풀이**

`SHR`로 오른쪽 이동 후 Carry Flag에 저장된 비트를 확인한다.

Carry Flag가 1이면 `OR`를 사용하여 최상위 비트를 1로 설정한다.

### 3. Shift Left by 4

```asm
shl eax, 4
```

EAX의 비트를 왼쪽으로 4칸 이동한다.

### 4. Shift Right by 2

```asm
shr ebx, 2
```

EBX를 오른쪽으로 2비트 논리 시프트한다.

### 5. Rotate Left by 4

```asm
rol dl, 4
```

DL의 비트를 왼쪽으로 4칸 회전한다.

### 6. SHLD Instruction

```asm
shld dx, ax, 1
```

AX의 비트를 DX의 왼쪽으로 이동시키면서 DX를 1비트 시프트한다.

### 7. Shift a 24-bit Array Right

```asm
.data
byteArray BYTE 81h, 20h, 33h

.code
shr BYTE PTR [byteArray+2], 1
rcr BYTE PTR [byteArray+1], 1
rcr BYTE PTR [byteArray], 1
```

**풀이**

24비트 배열을 오른쪽으로 1비트 이동한다.

`SHR`로 마지막 바이트를 이동하고, `RCR`로 Carry Flag를 통해 앞쪽 바이트로 비트를 전달한다.

**결과**

| 배열 위치 | 결과 |
|---|---|
| byteArray[0] | 40h |
| byteArray[1] | 90h |
| byteArray[2] | 19h |

### 8. Shift a WORD Array Left

```asm
.data
wordArray WORD 010Dh, 4064h, 13ABh

.code
shl WORD PTR [wordArray], 1
rcl WORD PTR [wordArray+2], 1
rcl WORD PTR [wordArray+4], 1
```

**풀이**

세 개의 WORD를 하나의 연속된 48비트 정수처럼 취급하여 왼쪽으로 1비트 이동한다.

**결과**

| 배열 위치 | 결과 |
|---|---|
| wordArray[0] | 021Ah |
| wordArray[1] | 80C9h |
| wordArray[2] | 2757h |

### 9. Multiply Two Values

```asm
.data
val1 WORD ?

.code
mov ax, 5
mov bx, 3
mul bx
mov val1, ax
```

**풀이**

```text
5 × 3 = 15
```

**결과**

```text
val1 = 000Fh
```

### 10. Divide Two Values

```asm
.data
val1 WORD ?

.code
mov ax, 276
mov dx, 0
mov bx, 10
div bx
mov val1, ax
```

**풀이**

```text
276 ÷ 10 = 27 ... 6
```

| 레지스터 | 결과 |
|---|---|
| AX | 001Bh |
| DX | 0006h |

### 11. Unsigned Arithmetic

```asm
mov eax, val2
mul val3

mov ebx, val4
sub ebx, 3

div ebx
mov val1, eax
```

**풀이**

- `MUL`로 val2와 val3을 곱한다.
- 곱셈 결과는 EDX:EAX에 저장된다.
- val4에서 3을 뺀 값을 제수로 사용한다.
- `DIV`로 나눗셈을 수행한다.
- 몫을 val1에 저장한다.

※ 제수가 0이 아니어야 하며 몫이 32비트에 들어가야 한다.

### 12. Signed Arithmetic

```asm
mov eax, val2
cdq
idiv val3

mov ebx, eax

mov eax, val1
add eax, val2
imul eax, ebx

mov val1, eax
```

**풀이**

- `CDQ`는 EAX의 부호를 EDX로 확장한다.
- `IDIV`는 부호 있는 나눗셈을 수행한다.
- `IMUL`은 부호 있는 곱셈을 수행한다.
- 최종 결과를 val1에 저장한다.

※ 나눗셈에서 0으로 나누거나 결과가 범위를 초과하면 예외가 발생한다.

### 13. Convert a Byte to Decimal ASCII

AL에 저장된 0~99의 숫자를 두 자리 ASCII 문자로 출력한다.

```asm
showDecimal8 PROC
    xor ah, ah
    mov bl, 10
    div bl

    mov dl, ah
    add al, '0'
    call WriteChar

    mov al, dl
    add al, '0'
    call WriteChar

    ret
showDecimal8 ENDP
```

**풀이**

- 10으로 나누어 십의 자리와 일의 자리를 구한다.
- 몫은 AL에 저장된다.
- 나머지는 AH에 저장된다.
- ASCII 문자 `'0'`을 더하여 숫자를 문자로 변환한다.

**예시**

```text
AL = 25
출력 = 25
```

### 14. AAA Instruction

초기값:

```asm
AX = 0072h
AF = 1
```

`AAA`는 ASCII 덧셈 결과를 조정한다.

**풀이**

- AF가 1이므로 AL에 6을 더한다.
- AH에 1을 더한다.
- AL의 상위 4비트를 제거한다.

**결과**

```text
AX = 0108h
AF = 1
CF = 1
```

### 15. Calculate Modulo Using AND

y가 2의 거듭제곱일 때 다음 식을 사용할 수 있다.

```asm
mov eax, y
sub eax, 1
and eax, n
```

**풀이**

2의 거듭제곱인 수로 나눈 나머지는 다음과 같이 계산할 수 있다.

```text
n % y = n AND (y - 1)
```

**예시**

```text
n = 29
y = 8

29 AND 7 = 5
```

### 16. Calculate Absolute Value Without Jumps

```asm
mov edx, eax
sar edx, 31

mov ecx, edx
xor ecx, -1
add ecx, 1

xor eax, edx
add eax, ecx
```

**풀이**

- `SAR`로 EAX의 부호에 따라 EDX를 0 또는 -1로 만든다.
- XOR와 ADD를 이용하여 음수일 경우 2의 보수를 계산한다.
- 양수일 경우 원래 값을 유지한다.

※ `80000000h`(INT_MIN)는 32비트 부호 있는 정수로 절댓값을 표현할 수 없으므로 예외적으로 처리해야 한다.

---

# 7.10 Programming Exercises

## 1. WriteScaled Procedure

문자열에 소수점을 삽입하여 출력하는 프로시저를 작성한다.

**코드**

```asm
WriteScaled PROC
    pushad

    mov esi, edx
    mov edi, ecx

    mov eax, ecx
    sub eax, ebx
    mov ebp, eax

    xor ecx, ecx

L1:
    cmp ecx, ebp
    jne SkipPoint

    mov al, '.'
    call WriteChar

SkipPoint:
    mov al, [esi]
    call WriteChar

    inc esi
    inc ecx

    cmp ecx, edi
    jb L1

    popad
    ret
WriteScaled ENDP
```

**테스트 코드**

```asm
.data
decimal_one   BYTE "100123456789765"
decimal_two   BYTE "123456"
decimal_three BYTE "987654321"

.code
mov edx, OFFSET decimal_one
mov ecx, LENGTHOF decimal_one
mov ebx, 5
call WriteScaled

call Crlf

mov edx, OFFSET decimal_two
mov ecx, LENGTHOF decimal_two
mov ebx, 2
call WriteScaled

call Crlf

mov edx, OFFSET decimal_three
mov ecx, LENGTHOF decimal_three
mov ebx, 3
call WriteScaled
```

**실행 결과**

```text
1001234567.89765
1234.56
987654.321
```

**풀이**

- EDX: 문자열의 시작 주소
- ECX: 문자열 길이
- EBX: 오른쪽에서부터 소수점 위치
- ESI: 문자열 탐색 포인터
- EBP: 소수점 삽입 위치

`PUSHAD`와 `POPAD`를 이용하여 레지스터 값을 보존한다.

※ 소수점 위치는 문자열 길이보다 작고 0보다 커야 한다.

## 2. Extended_Sub Procedure

두 개의 확장 정수 배열을 빼는 프로시저를 작성한다.

**코드**

```asm
Extended_Sub PROC
    clc

L1:
    mov eax, [esi]
    sbb eax, [edi]
    mov [edx], eax

    lea esi, [esi+4]
    lea edi, [edi+4]
    lea edx, [edx+4]

    loop L1

    ret
Extended_Sub ENDP
```

**풀이**

- ESI: 첫 번째 정수 배열 주소
- EDI: 두 번째 정수 배열 주소
- EDX: 결과 배열 주소
- ECX: DWORD 개수

`SBB`는 이전 연산에서 발생한 빌림을 반영한다.

`LEA`와 `LOOP`는 Carry Flag를 변경하지 않으므로 여러 DWORD에 걸친 뺄셈이 가능하다.

## 3. PackedToAsc Procedure

Packed BCD를 ASCII 문자열로 변환하는 프로시저를 작성한다.

**코드**

```asm
PackedToAsc PROC
    pushad

    mov esi, edx
    mov edi, ebx
    mov ecx, 4

L1:
    mov al, [esi]

    mov ah, al
    shr ah, 4
    and ah, 0Fh
    add ah, '0'

    and al, 0Fh
    add al, '0'

    mov [edi], ah
    mov [edi+1], al

    inc esi
    add edi, 2

    loop L1

    mov BYTE PTR [edi], 0

    popad
    ret
PackedToAsc ENDP
```

**테스트 데이터**

```asm
.data
packed1 BYTE 12h, 34h, 56h, 78h
packed2 BYTE 98h, 76h, 54h, 32h
packed3 BYTE 11h, 22h, 33h, 44h
packed4 BYTE 55h, 66h, 77h, 88h
packed5 BYTE 90h, 12h, 34h, 56h
```

**실행 결과**

```text
12345678
98765432
11223344
55667788
90123456
```

**풀이**

Packed BCD는 1바이트에 10진수 숫자 두 개를 저장한다.

- 상위 4비트: 첫 번째 숫자
- 하위 4비트: 두 번째 숫자

각 숫자에 ASCII `'0'`을 더하여 문자열로 변환한다.

※ 이 코드는 부호 없는 4바이트 Packed BCD를 기준으로 한다.

## 4. Encryption Procedure

키 배열을 이용하여 문자열을 암호화한다.

**키 배열**

```asm
.data
key BYTE -2, 4, 1, 0, -3, 5, 2, -4, -4, 6
```

**코드**

```asm
Encrypt PROC
    push ebx
    push ebp

    mov ebx, ecx
    xor ebp, ebp

L1:
    cmp ebx, 0
    je Done

    movsx edx, BYTE PTR [key+ebp]

    cmp edx, 0
    jl RotateLeft

    mov cl, dl
    ror BYTE PTR [esi], cl
    jmp Next

RotateLeft:
    neg edx
    mov cl, dl
    rol BYTE PTR [esi], cl

Next:
    inc esi
    inc ebp

    cmp ebp, LENGTHOF key
    jb Continue

    xor ebp, ebp

Continue:
    dec ebx
    jmp L1

Done:
    pop ebp
    pop ebx
    ret
Encrypt ENDP
```

**테스트 문자열**

```asm
.data
message1 BYTE "HELLOWORLD"
message2 BYTE "ASSEMBLY!!"
```

**풀이**

- 키 값이 음수이면 왼쪽으로 회전한다.
- 키 값이 양수이면 오른쪽으로 회전한다.
- 키 배열의 끝에 도달하면 처음으로 돌아간다.
- 문자열의 모든 문자를 순차적으로 암호화한다.

※ 암호화 결과는 일반적인 출력 가능 ASCII 문자열이 아닐 수 있으므로 16진수로 확인하는 것이 좋다.

## 5. Sieve of Eratosthenes

에라토스테네스의 체를 이용하여 1000 이하의 소수를 출력한다.

**코드**

```asm
.data
isPrime BYTE 1001 DUP(1)

.code
mov BYTE PTR [isPrime], 0
mov BYTE PTR [isPrime+1], 0

mov ebx, 2

OuterLoop:
    mov eax, ebx
    mul ebx

    cmp eax, 1000
    ja Done

    cmp BYTE PTR [isPrime+ebx], 1
    jne NextNumber

    mov esi, eax

MarkLoop:
    cmp esi, 1000
    ja NextNumber

    mov BYTE PTR [isPrime+esi], 0
    add esi, ebx
    jmp MarkLoop

NextNumber:
    inc ebx
    jmp OuterLoop

Done:

; 소수 출력
mov esi, 2

PrintLoop:
    cmp esi, 1000
    ja PrintDone

    cmp BYTE PTR [isPrime+esi], 1
    jne NextPrint

    mov eax, esi
    call WriteDec
    call Crlf

NextPrint:
    inc esi
    jmp PrintLoop

PrintDone:
```

**풀이**

1. 0부터 1000까지 모든 값을 소수 후보로 설정한다.
2. 0과 1은 소수가 아니므로 0으로 설정한다.
3. 2부터 시작하여 해당 숫자의 배수를 제거한다.
4. 숫자의 제곱이 1000을 초과하면 제거 작업을 종료한다.
5. 남아 있는 값이 소수이다.
6. `PrintLoop`를 통해 남아 있는 소수를 순서대로 출력한다.

**결과**

- 1000 이하의 소수 개수: 168개
- 가장 큰 소수: 997

## 6. Greatest Common Divisor (GCD)

유클리드 호제법을 이용하여 최대공약수를 계산한다.

**코드**

```asm
GCD PROC
    push ebx
    push ecx
    push edx

    test eax, eax
    jns CheckY
    neg eax

CheckY:
    test ebx, ebx
    jns StartLoop
    neg ebx

StartLoop:
    cmp ebx, 0
    je Done

L1:
    xor edx, edx
    div ebx

    mov eax, ebx
    mov ebx, edx

    cmp ebx, 0
    jne L1

Done:
    pop edx
    pop ecx
    pop ebx
    ret
GCD ENDP
```

**테스트**

| x | y | GCD |
|---:|---:|---:|
| 48 | 18 | 6 |
| 100 | 25 | 25 |
| 81 | 27 | 27 |

**풀이**

유클리드 호제법의 핵심 공식은 다음과 같다.

```text
GCD(a, b) = GCD(b, a mod b)
```

나머지가 0이 될 때까지 반복하면 마지막으로 남은 값이 최대공약수이다.

※ `80000000h`와 같은 최솟값은 부호 있는 32비트 정수로 절댓값을 표현할 수 없으므로 별도 처리가 필요하다.

## 7. Bitwise Multiplication

`MUL`과 `IMUL`을 사용하지 않고 시프트와 덧셈으로 곱셈을 구현한다.

**코드**

```asm
BitwiseMultiply PROC
    mov ecx, ebx
    mov edx, eax
    xor eax, eax

L1:
    shr edx, 1
    jnc SkipAdd

    add eax, ecx

SkipAdd:
    shl ecx, 1

    test edx, edx
    jnz L1

    ret
BitwiseMultiply ENDP
```

**테스트**

```asm
mov ebx, 12
mov eax, 10
call BitwiseMultiply
```

**결과**

```text
12 × 10 = 120
EAX = 120
```

**풀이**

- EBX의 값을 ECX에 복사한다.
- EAX의 값을 EDX에 복사한다.
- EDX를 오른쪽으로 시프트하면서 최하위 비트를 확인한다.
- 최하위 비트가 1이면 ECX를 EAX에 더한다.
- ECX를 왼쪽으로 시프트하여 다음 자리의 곱셈을 준비한다.

※ 결과가 32비트 범위에 들어가는 양의 정수 곱셈을 기준으로 한다.

## 8. AddPacked Procedure

Packed BCD 형식의 두 숫자를 더하는 프로시저를 작성한다.

**코드**

```asm
AddPacked PROC
    clc

L1:
    mov al, [esi]
    adc al, [edi]
    daa

    mov [edx], al

    inc esi
    inc edi
    inc edx

    loop L1

    ret
AddPacked ENDP
```

**풀이**

- ESI: 첫 번째 Packed BCD 배열 주소
- EDI: 두 번째 Packed BCD 배열 주소
- EDX: 결과 배열 주소
- ECX: 배열의 바이트 수

`ADC`는 Carry Flag를 포함하여 덧셈을 수행한다.

`DAA`는 덧셈 결과를 Packed BCD 형식에 맞게 조정한다.

`INC`와 `LOOP`는 Carry Flag를 변경하지 않으므로 다음 바이트 연산에 올림값이 전달된다.

**예시 데이터**

```asm
.data
num1_16 BYTE 16 DUP(11h)
num2_16 BYTE 16 DUP(22h)
result_16 BYTE 16 DUP(?)
```

**예상 결과**

```text
33 33 33 33 33 33 33 33
33 33 33 33 33 33 33 33
```

※ 위 코드는 부호 없는 Packed BCD 형식을 가정한다. 최종 바이트에서 올림이 발생할 수 있다면 결과 배열에 추가 바이트를 확보하여 최종 Carry를 별도로 저장해야 한다. `DAA`는 32비트 x86 환경을 기준으로 한다.

---

# Chapter 7 학습 정리

## 핵심 명령어

| 명령어 | 기능 |
|---|---|
| SHL | 왼쪽 논리 시프트 |
| SHR | 오른쪽 논리 시프트 |
| SAR | 오른쪽 산술 시프트 |
| ROL | 왼쪽 회전 |
| ROR | 오른쪽 회전 |
| RCL | Carry를 포함한 왼쪽 회전 |
| RCR | Carry를 포함한 오른쪽 회전 |
| SHLD | 두 레지스터를 이용한 왼쪽 시프트 |
| MUL | 부호 없는 곱셈 |
| IMUL | 부호 있는 곱셈 |
| DIV | 부호 없는 나눗셈 |
| IDIV | 부호 있는 나눗셈 |
| ADC | Carry를 포함한 덧셈 |
| SBB | Borrow를 포함한 뺄셈 |
| CDQ | EAX의 부호를 EDX로 확장 |
| AAA | ASCII 덧셈 조정 |
| DAA | 10진수 덧셈 조정 |

## 학습하면서 배운 점

1. 시프트와 회전 명령어를 사용하면 비트 단위의 데이터를 효율적으로 처리할 수 있다.
2. Carry Flag는 여러 바이트 또는 워드에 걸친 연산에서 중요한 역할을 한다.
3. MUL과 DIV는 결과가 저장되는 레지스터 구조를 정확히 이해해야 한다.
4. SBB와 ADC를 사용하면 여러 데이터 단위에 걸친 뺄셈과 덧셈을 구현할 수 있다.
5. Packed BCD와 ASCII는 숫자를 표현하는 방식이 다르므로 변환 과정이 필요하다.
6. 반복문과 배열 포인터를 활용하면 큰 정수 연산도 구현할 수 있다.

---
