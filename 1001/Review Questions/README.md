# 4.9 복습 문제 및 연습문제

## 4.9.1 단답형 문제

### 1. MOVSX와 MOVZX의 차이점은 무엇인가?

`MOVSX`와 `MOVZX`는 작은 크기의 값을 큰 크기의 레지스터로 옮길 때 사용한다.

| 명령어     | 의미       | 확장 방식        |
| ------- | -------- | ------------ |
| `MOVSX` | 부호 확장 이동 | 부호 비트를 유지    |
| `MOVZX` | 0 확장 이동  | 빈 공간을 0으로 채움 |

예를 들어:

```asm
one WORD 8002h

movsx edx, one
; EDX = FFFF8002h

movzx edx, one
; EDX = 00008002h
```

`8002h`의 최상위 비트가 1이므로 `MOVSX`는 1로 확장하고, `MOVZX`는 0으로 확장한다.

---

### 2. 다음 명령어를 실행한 후 EAX의 값은 무엇인가?

```asm
mov eax, 1002FFFFh
inc ax
```

`AX`는 `FFFFh`에서 `0000h`로 증가한다.

따라서:

```text
EAX = 10020000h
```

---

### 3. 다음 명령어를 실행한 후 EAX의 값은 무엇인가?

```asm
mov eax, 30020000h
dec ax
```

`AX`는 `0000h`에서 `FFFFh`로 감소한다.

따라서:

```text
EAX = 3002FFFFh
```

---

### 4. 다음 명령어를 실행한 후 EAX의 값은 무엇인가?

```asm
mov eax, 1002FFFFh
neg ax
```

`AX = FFFFh`를 `NEG`하면 `0001h`가 된다.

따라서:

```text
EAX = 10020001h
```

---

### 5. 다음 명령어를 실행한 후 패리티 플래그의 값은 얼마인가?

```asm
mov al, 1
add al, 3
```

계산 결과:

```text
1 + 3 = 4
4 = 00000100b
```

1의 개수가 1개이므로 홀수 개이다.

따라서:

```text
PF = 0
```

---

### 6. 다음 명령어를 실행한 후 부호 플래그의 값은 얼마인가?

```asm
mov eax, 5
sub eax, 6
```

계산 결과:

```text
5 - 6 = -1
```

32비트로 표현하면:

```text
FFFFFFFFh
```

최상위 비트가 1이므로 음수이다.

따라서:

```text
SF = 1
```

---

### 7. 다음 명령어가 유효한 signed 정수를 생성하는지 판단하는 데 Overflow 플래그를 사용할 수 있는가?

```asm
mov al, -1
add al, 130
```

8비트 signed 정수의 범위는:

```text
-128 ~ 127
```

`130`은 signed byte로 표현할 수 없는 값이다.

8비트 연산에서는 `130`이 `82h`라는 비트 패턴으로 처리되고, 결과는:

```text
FFh + 82h = 81h
```

`81h`는 signed byte로 `-127`이다.

이 실제 8비트 연산에서는 두 피연산자의 부호가 모두 음수이므로 `OF = 0`이다.

따라서 **Overflow Flag만으로 프로그래머가 의도한 `+130`이 signed byte 범위를 벗어났는지는 알 수 없다.**

```text
AL = 81h
OF = 0
```

---

### 8. 다음 명령어를 실행한 후 RAX의 값은 얼마인가?

```asm
mov rax, 44445555h
```

64비트 레지스터인 RAX에 값이 저장되므로:

```text
RAX = 0000000044445555h
```

---

### 9. 다음 명령어를 실행한 후 RAX의 값은 무엇인가?

```asm
dwordVal DWORD 84326732h

mov rax, 0FFFFFFFF00000000h
mov rax, dwordVal
```

`dwordVal`은 32비트 변수이므로 `mov rax, dwordVal`은 피연산자 크기가 맞지 않는다.

따라서 **MASM에서는 이 명령을 그대로 사용할 수 없다.**

만약 다음과 같이 작성했다면:

```asm
mov eax, dwordVal
```

32비트 EAX에 값을 넣는 순간 RAX의 상위 32비트가 0으로 설정된다.

따라서:

```text
RAX = 0000000084326732h
```

---

### 10. 다음 명령어를 실행한 후 EAX의 값은 무엇인가?

```asm
dVal DWORD 12345678h

mov ax, 3
mov WORD PTR dVal+2, ax
mov eax, dVal
```

처음:

```text
dVal = 12345678h
```

`dVal+2`는 상위 WORD를 가리킨다.

```text
1234h → 0003h
```

따라서:

```text
dVal = 00035678h
```

결과:

```text
EAX = 00035678h
```

---

### 11. 다음 명령어를 실행한 후 dVal의 값은 무엇인가?

```asm
dVal DWORD 12345678h

mov ax, WORD PTR dVal+2
add ax, 3
mov WORD PTR dVal+2, ax
```

처음 상위 WORD:

```text
1234h
```

3을 더하면:

```text
1234h + 3 = 1237h
```

따라서:

```text
dVal = 12341237h
```

---

### 12. 양수와 음수를 더할 때 Overflow 플래그가 설정될 수 있는가?

아니요.

양수와 음수를 더하면 결과의 부호가 바뀌는 signed overflow가 발생할 수 없으므로:

```text
OF = 0
```

---

### 13. 두 음수를 더해서 양수가 나온 경우 Overflow 플래그가 설정될 수 있는가?

네.

두 음수를 더했는데 결과가 양수가 되면 signed overflow가 발생한다.

예:

```asm
mov al, 100
neg al
add al, -50
```

개념적으로 두 음수의 덧셈 결과가 양수가 되는 경우:

```text
OF = 1
```

---

### 14. NEG 명령어가 Overflow 플래그를 설정할 수 있는가?

네.

가장 작은 signed 정수에 `NEG`를 수행하면 표현할 수 있는 반대값이 없기 때문에 `OF`가 설정된다.

8비트의 경우:

```text
-128 = 80h
```

```asm
mov al, 80h
neg al
```

결과는 다시 `80h`가 되며:

```text
OF = 1
```

---

### 15. Sign 플래그와 Zero 플래그가 동시에 설정될 수 있는가?

아니요.

`ZF = 1`이 되려면 결과가 0이어야 한다.

0의 최상위 비트는 0이므로 `SF = 0`이다.

따라서 일반적인 정수 연산 결과에서는:

```text
SF = 1
ZF = 1
```

이 동시에 될 수 없다.

---

### 16. 다음 각 명령어가 유효한지 또는 유효하지 않은지 판단하시오.

#### a.

```asm
mov ax, var1
```

`var1`이 BYTE라면 크기가 맞지 않으므로:

```text
Invalid
```

#### b.

```asm
mov ax, var2
```

WORD → AX이므로:

```text
Valid
```

#### c.

```asm
mov eax, var3
```

`var3`가 WORD라면 크기가 맞지 않으므로:

```text
Invalid
```

#### d.

```asm
mov var2, var3
```

메모리 → 메모리 이동은 `MOV`에서 직접 지원하지 않으므로:

```text
Invalid
```

#### e.

```asm
movzx ax, var2
```

원본과 목적지 크기가 같으므로 `MOVZX`의 조건에 맞지 않는다.

```text
Invalid
```

#### f.

```asm
movzx var2, al
```

`MOVZX`의 목적지는 레지스터여야 한다.

```text
Invalid
```

#### g.

```asm
mov ds, ax
```

AX의 값을 DS 세그먼트 레지스터에 이동할 수 있으므로:

```text
Valid
```

#### h.

```asm
mov ds, 1000h
```

즉시값을 세그먼트 레지스터에 직접 이동할 수 없으므로:

```text
Invalid
```

---

### 17. 다음 명령어를 실행한 후 AX의 값은 무엇인가?

```asm
var1 BYTE 0FCh, 0FEh, 03h, 01h

mov al, var1
mov ah, [var1+3]
```

`AL`에는 첫 번째 바이트가 들어간다.

```text
AL = FCh
```

`AH`에는 네 번째 바이트가 들어간다.

```text
AH = 01h
```

따라서:

```text
AX = 01FCh
```

---

### 18. 다음 각 명령어를 실행했을 때 AX에 저장되는 값을 구하시오.

```asm
var2 WORD 1000h, 2000h, 3000h, 4000h
var3 SWORD -16, -42
```

#### a.

```asm
mov ax, var2
```

첫 번째 WORD이므로:

```text
AX = 1000h
```

#### b.

```asm
mov ax, [var2+4]
```

WORD 하나가 2바이트이므로 `+4`는 세 번째 WORD이다.

```text
AX = 3000h
```

#### c.

```asm
mov ax, var3
```

`var3`의 첫 번째 값은 `-16`이다.

16비트 2의 보수 표현:

```text
-16 = FFF0h
```

따라서:

```text
AX = FFF0h
```

#### d.

```asm
mov ax, [var3-2]
```

`var3` 바로 앞의 WORD는 `var2`의 마지막 값이다.

```text
var2 = 1000h, 2000h, 3000h, 4000h
```

따라서:

```text
AX = 4000h
```

---

### 19. 다음 각 명령어를 실행한 후 EDX의 값을 구하시오.

```asm
var1 SBYTE -4
var2 WORD 1000h
var4 WORD 1, 2, 3, 4
```

#### a.

```asm
movzx edx, var2
```

Zero Extension이므로:

```text
EDX = 00001000h
```

#### b.

```asm
movzx edx, var4
```

첫 번째 값이 `1`이므로:

```text
EDX = 00000001h
```

#### c.

```asm
movsx edx, var1
```

`var1 = -4`이고 Sign Extension을 수행하므로:

```text
EDX = FFFFFFFCh
```

---

# 4.9.2 알고리즘 워크벤치

## 1. DWORD 변수의 상위 WORD와 하위 WORD를 서로 교환하시오.

```asm
.data
three DWORD 12345678h

.code
mov ax, WORD PTR three
mov bx, WORD PTR three+2

mov WORD PTR three, bx
mov WORD PTR three+2, ax
```

처음:

```text
three = 12345678h
```

상위 WORD:

```text
1234h
```

하위 WORD:

```text
5678h
```

교환하면:

```text
three = 56781234h
```

---

## 2. XCHG 명령어를 사용하여 AL, BL, CL, DL의 내용을 순환 교환하시오.

현재:

```text
AL = A
BL = B
CL = C
DL = D
```

목표:

```text
AL = B
BL = C
CL = D
DL = A
```

코드:

```asm
xchg al, bl
xchg bl, cl
xchg cl, dl
```

결과:

```text
AL = B
BL = C
CL = D
DL = A
```

---

## 3. AL에 01110101b가 저장되어 있을 때 패리티 플래그를 설정하는 명령어를 작성하시오.

```asm
mov al, 01110101b
add al, 0
```

`01110101b`에는 1이 5개 있다.

```text
1의 개수 = 5
```

홀수 패리티이므로:

```text
PF = 0
```

`ADD AL, 0`은 AL의 값을 변경하지 않으면서 플래그를 갱신한다.

---

## 4. 두 개의 음수 바이트를 더했을 때 Overflow 플래그가 설정되도록 명령어를 작성하시오.

```asm
mov al, -128
add al, -1
```

계산:

```text
-128 + (-1) = -129
```

8비트 signed 범위:

```text
-128 ~ 127
```

범위를 벗어나므로:

```text
OF = 1
```

---

## 5. Zero 플래그와 Carry 플래그를 모두 설정하는 명령어를 작성하시오.

```asm
mov al, 0FFh
add al, 1
```

계산 결과:

```text
FFh + 1 = 00h
```

결과가 0이므로:

```text
ZF = 1
```

FFh에 1을 더하면서 carry가 발생하므로:

```text
CF = 1
```

따라서:

```text
ZF = 1
CF = 1
```

---

## 6. 뺄셈을 사용하여 Carry 플래그를 설정하는 명령어를 작성하시오.

```asm
mov al, 1
sub al, 2
```

계산:

```text
1 - 2 = -1
```

unsigned 관점에서 빌림이 발생하므로:

```text
CF = 1
```

---

## 7. EAX = -val2 + 7 - val3 + val1을 계산하는 명령어를 작성하시오.

```asm
mov eax, val2
neg eax
add eax, 7
sub eax, val3
add eax, val1
```

순서대로 계산하면:

```text
EAX = val2
EAX = -val2
EAX = -val2 + 7
EAX = -val2 + 7 - val3
EAX = -val2 + 7 - val3 + val1
```

---

## 8. DWORD 배열의 합을 계산하는 반복문을 작성하시오.

```asm
.data
array DWORD 10, 20, 30, 40, 50

ArraySize = LENGTHOF array

.code
mov eax, 0
mov esi, 0
mov ecx, ArraySize

L1:
    add eax, array[esi*TYPE array]
    inc esi
    loop L1
```

`TYPE array`는 DWORD이므로:

```text
TYPE array = 4
```

따라서 `esi`에 0, 1, 2, 3, 4를 넣으면서 실제 주소는:

```text
0, 4, 8, 12, 16
```

으로 이동한다.

최종 결과:

```text
EAX = 10 + 20 + 30 + 40 + 50
    = 150
```

---

## 9. AX = (val2 + BX) - val4를 계산하는 명령어를 작성하시오.

```asm
mov ax, val2
add ax, bx
sub ax, val4
```

계산 순서:

```text
AX = val2
AX = val2 + BX
AX = (val2 + BX) - val4
```

---

## 10. Carry 플래그와 Overflow 플래그를 모두 설정하는 명령어를 작성하시오.

```asm
mov al, 80h
add al, 80h
```

계산:

```text
80h + 80h = 00h
```

unsigned 관점에서는 carry가 발생하므로:

```text
CF = 1
```

signed 관점에서는:

```text
-128 + -128 = -256
```

8비트 signed 범위를 벗어나므로:

```text
OF = 1
```

따라서:

```text
CF = 1
OF = 1
```

---

## 11. INC와 DEC를 Zero 플래그와 함께 사용하여 Wraparound를 감지하는 방법을 설명하시오.

### INC

```asm
mov al, 0FFh
inc al
jz IncOverflow
```

`FFh + 1`은:

```text
00h
```

따라서:

```text
ZF = 1
```

`JZ`가 실행된다.

```text
FFh → 00h
```

### DEC

```asm
mov al, 00h
or al, al
jz DecOverflow

dec al
```

`AL = 0`인지 먼저 확인한 후 `DEC`를 수행한다.

```text
00h → FFh
```

따라서 0에서 감소할 경우 unsigned wraparound가 발생한다.

> `DEC` 자체가 0에서 `FFh`로 바뀐 뒤에는 ZF가 0이 되므로, ZF는 감소하기 전 값이 0인지 확인하는 데 사용한다.

---

# 4.9.3 데이터 정의 및 주소 지정

다음 데이터를 기준으로 한다.

```asm
.data
myBytes  BYTE 10h, 20h, 30h, 40h
myWords  WORD 3 DUP(?), 2000h
myString BYTE "ABCDE"
```

---

## 12. myBytes가 짝수 주소에서 시작하도록 정렬하시오.

```asm
ALIGN 2
myBytes BYTE 10h, 20h, 30h, 40h
```

`ALIGN 2`는 주소를 2의 배수로 맞춘다.

따라서 `myBytes`는 짝수 주소에서 시작한다.

---

## 13. 각 변수의 TYPE, LENGTHOF, SIZEOF 값은 무엇인가?

### myBytes

```asm
myBytes BYTE 10h, 20h, 30h, 40h
```

```text
TYPE     = 1
LENGTHOF = 4
SIZEOF   = 4
```

### myWords

```asm
myWords WORD 3 DUP(?), 2000h
```

총 4개의 WORD이므로:

```text
TYPE     = 2
LENGTHOF = 4
SIZEOF   = 8
```

### myString

```asm
myString BYTE "ABCDE"
```

문자 5개이므로:

```text
TYPE     = 1
LENGTHOF = 5
SIZEOF   = 5
```

---

## 14. 다음 명령어를 실행한 후 DX의 값은 무엇인가?

```asm
mov dx, WORD PTR myBytes
```

메모리는 Little Endian 방식으로 저장된다.

```text
myBytes:
10h 20h 30h 40h
```

WORD로 읽으면:

```text
DX = 2010h
```

---

## 15. myWords의 두 번째 바이트를 AL로 이동하는 명령어를 작성하시오.

```asm
mov al, BYTE PTR [myWords+1]
```

첫 번째 WORD의 첫 번째 바이트가 `+0`이고 두 번째 바이트가 `+1`이므로:

```text
AL = [myWords+1]
```

---

## 16. myBytes의 첫 번째 DWORD를 EAX로 이동하는 명령어를 작성하시오.

```asm
mov eax, DWORD PTR myBytes
```

메모리:

```text
10h 20h 30h 40h
```

Little Endian이므로:

```text
EAX = 40302010h
```

---

## 17. LABEL을 사용하여 myWords에 대한 DWORD 별칭을 생성하시오.

```asm
myWordsD LABEL DWORD
myWords  WORD 3 DUP(?), 2000h
```

이제 `myWordsD`는 `myWords`와 같은 메모리 위치를 DWORD로 참조한다.

```asm
mov eax, myWordsD
```

`LABEL`은 새로운 데이터를 만드는 것이 아니라 같은 메모리를 다른 크기로 참조하기 위한 별칭이다.

---

## 18. LABEL을 사용하여 myBytes에 대한 WORD 별칭을 생성하시오.

```asm
myBytesW LABEL WORD
myBytes  BYTE 10h, 20h, 30h, 40h
```

이제:

```asm
mov ax, myBytesW
```

와 같이 `myBytes`의 첫 2바이트를 WORD로 사용할 수 있다.

Little Endian이므로:

```text
AX = 2010h
```

---

# 4.10 프로그래밍 연습문제

## 1. Big Endian 값을 Little Endian 형식으로 변환하기

### 문제

Big Endian 방식으로 저장된 DWORD 값의 바이트 순서를 반대로 뒤집는 프로그램을 작성하시오.

예:

```text
Big Endian:
12 34 56 78

Little Endian 메모리:
78 56 34 12
```

### 코드

```asm
TITLE BigEndian to LittleEndian Conversion

.386
.MODEL flat,stdcall
INCLUDE Irvine32.inc

.data
bigEndian     BYTE 12h, 34h, 56h, 78h
littleEndian  DWORD ?

.code
main PROC

    mov al, bigEndian+3
    mov BYTE PTR littleEndian, al

    mov al, bigEndian+2
    mov BYTE PTR littleEndian+1, al

    mov al, bigEndian+1
    mov BYTE PTR littleEndian+2, al

    mov al, bigEndian
    mov BYTE PTR littleEndian+3, al

    exit

main ENDP
END main
```

### 결과

`bigEndian`의 메모리:

```text
12 34 56 78
```

`littleEndian`의 메모리:

```text
78 56 34 12
```

중요한 점은 Little Endian 메모리에 `78 56 34 12`가 저장되면 DWORD의 **숫자값 자체는 `12345678h`**라는 것이다.

---

## 2. 배열의 인접한 원소를 서로 교환하기

### 문제

DWORD 배열에서 서로 인접한 원소를 교환하는 반복문을 작성하시오.

```text
Before:
1, 2, 3, 4, 5, 6

After:
2, 1, 4, 3, 6, 5
```

### 코드

```asm
.data
myArray DWORD 1, 2, 3, 4, 5, 6

arraySize = ($ - myArray) / TYPE myArray

.code
mov esi, 0
mov ecx, arraySize / 2

L1:
    mov eax, myArray[esi]
    mov edx, myArray[esi+4]

    xchg eax, edx

    mov myArray[esi], eax
    mov myArray[esi+4], edx

    add esi, 8

    loop L1
```

### 결과

```text
Before:
1, 2, 3, 4, 5, 6

After:
2, 1, 4, 3, 6, 5
```

DWORD는 4바이트이므로 다음 요소로 이동할 때 4바이트를 사용하고, 두 개씩 처리하기 때문에 `8`을 더한다.

---

## 3. 배열 원소 사이의 차이의 합 계산하기

### 문제

배열에서 인접한 원소 사이의 차이를 모두 더하는 프로그램을 작성하시오.

예:

```text
1, 3, 6, 10
```

계산:

```text
(3-1) + (6-3) + (10-6)
= 2 + 3 + 4
= 9
```

### 코드

```asm
.data
myArray DWORD 1, 3, 6, 10

.code
mov esi, 0
mov eax, 0
mov ecx, LENGTHOF myArray - 1

L1:
    mov edx, myArray[esi+TYPE myArray]
    sub edx, myArray[esi]

    add eax, edx

    add esi, TYPE myArray

    loop L1
```

### 결과

```text
EAX = 9
```

---

## 4. 부호 없는 WORD 배열을 DWORD 배열로 복사하기

### 문제

부호 없는 WORD 배열의 각 원소를 DWORD 배열로 복사하는 프로그램을 작성하시오.

### 코드

```asm
.data
sourceArray WORD 10h, 20h, 30h, 40h
destArray   DWORD 4 DUP(?)

.code
mov esi, 0
mov edi, 0
mov ecx, LENGTHOF sourceArray

L1:
    movzx eax, sourceArray[esi]
    mov destArray[edi], eax

    add esi, TYPE sourceArray
    add edi, TYPE destArray

    loop L1
```

### 설명

`sourceArray`는 WORD이므로 2바이트이고, `destArray`는 DWORD이므로 4바이트이다.

따라서:

```asm
movzx eax, sourceArray[esi]
```

를 사용하여 WORD 값을 32비트로 Zero Extension한다.

예:

```text
0010h → 00000010h
```

---

## 5. 피보나치 수열 배열 만들기

### 문제

처음 7개의 피보나치 수를 배열에 저장하는 프로그램을 작성하시오.

```text
1, 1, 2, 3, 5, 8, 13
```

### 코드

```asm
.data
fibonacci DWORD 7 DUP(?)

.code
mov DWORD PTR fibonacci[0], 1
mov DWORD PTR fibonacci[4], 1

mov ecx, 5
mov esi, 8

L1:
    mov eax, fibonacci[esi-4]
    add eax, fibonacci[esi-8]

    mov fibonacci[esi], eax

    add esi, 4

    loop L1
```

### 결과

```text
fibonacci =
1, 1, 2, 3, 5, 8, 13
```

각 항은 바로 앞의 두 항을 더해서 계산한다.

```text
1 + 1 = 2
1 + 2 = 3
2 + 3 = 5
3 + 5 = 8
5 + 8 = 13
```

---

## 6. 배열의 원소 순서를 반대로 뒤집기

### 문제

`TYPE`, `LENGTHOF`, `SIZEOF`를 사용하여 배열의 원소 순서를 반대로 뒤집는 프로그램을 작성하시오.

예:

```text
Before:
1, 2, 3, 4, 5

After:
5, 4, 3, 2, 1
```

### 코드

```asm
.data
myArray DWORD 1, 2, 3, 4, 5

arrayType   = TYPE myArray
arrayLength = LENGTHOF myArray
arraySize   = SIZEOF myArray

.code
mov esi, OFFSET myArray
mov edi, OFFSET myArray + arraySize - arrayType
mov ecx, arrayLength / 2

L1:
    mov eax, [esi]
    mov edx, [edi]

    xchg eax, edx

    mov [esi], eax
    mov [edi], edx

    add esi, arrayType
    sub edi, arrayType

    loop L1
```

### 설명

처음에는:

```text
ESI → 첫 번째 요소
EDI → 마지막 요소
```

두 값을 교환한 뒤:

```text
ESI → 다음 요소
EDI → 이전 요소
```

로 이동한다.

배열의 절반만 처리하면 전체 배열이 뒤집힌다.

---

## 7. 문자열을 역순으로 복사하기

### 문제

`source` 문자열을 역순으로 `target` 문자열에 복사하는 프로그램을 작성하시오.

### 코드

```asm
.data
source BYTE "This is the source string", 0
target BYTE SIZEOF source DUP('#')

sourceLength = LENGTHOF source - 1

.code
mov esi, OFFSET source + sourceLength - 1
mov edi, OFFSET target
mov ecx, sourceLength

L1:
    mov al, [esi]
    mov [edi], al

    dec esi
    inc edi

    loop L1

mov BYTE PTR [edi], 0
```

### 결과

```text
source:
This is the source string

target:
gnirts ecruos eht si sihT
```

`source`의 마지막 `0`은 문자열 종료 문자이므로 실제 문자열 길이에서는 제외한다.

따라서:

```asm
sourceLength = LENGTHOF source - 1
```

로 작성한다.

---

## 8. 배열을 오른쪽으로 한 칸 회전시키기

### 문제

배열의 원소를 오른쪽으로 한 칸씩 회전시키는 프로그램을 작성하시오.

예:

```text
Before:
1, 2, 3, 4, 5

After:
5, 1, 2, 3, 4
```

### 코드

```asm
.data
myArray DWORD 1, 2, 3, 4, 5

arraySize = LENGTHOF myArray

.code
mov esi, (arraySize - 1) * TYPE myArray
mov eax, myArray[esi]

mov ecx, arraySize - 1

L1:
    mov edx, myArray[esi-TYPE myArray]
    mov myArray[esi], edx

    sub esi, TYPE myArray

    loop L1

mov myArray[0], eax
```

### 설명

먼저 마지막 값을 저장한다.

```text
마지막 값 = 5
```

그다음 뒤에서부터 한 칸씩 오른쪽으로 이동한다.

```text
4 → 5
3 → 4
2 → 3
1 → 2
```

마지막에 저장해 둔 `5`를 첫 번째 위치에 넣는다.

최종 결과:

```text
5, 1, 2, 3, 4
```

---

# 정리

이번 Chapter에서는 다음 내용을 학습했다.

| 주제            | 핵심 내용                     |
| ------------- | ------------------------- |
| `MOVSX`       | 부호 확장                     |
| `MOVZX`       | 0 확장                      |
| `INC` / `DEC` | 1 증가 / 1 감소               |
| `NEG`         | 2의 보수 방식으로 부호 반전          |
| `XCHG`        | 두 피연산자의 값 교환              |
| `CF`          | Carry / Borrow 발생 여부      |
| `OF`          | Signed Overflow 발생 여부     |
| `SF`          | 결과의 부호                    |
| `ZF`          | 결과가 0인지 확인                |
| `PF`          | 하위 바이트의 1 비트 개수에 따른 패리티   |
| `TYPE`        | 한 요소의 크기                  |
| `LENGTHOF`    | 배열의 요소 개수                 |
| `SIZEOF`      | 배열 전체 크기                  |
| `LABEL`       | 같은 메모리를 다른 자료형으로 참조       |
| Little Endian | 낮은 주소에 낮은 바이트 저장          |
| `MOVZX` 배열 복사 | 작은 unsigned 값을 큰 자료형으로 확장 |
| `LOOP`        | ECX를 이용한 반복문              |
