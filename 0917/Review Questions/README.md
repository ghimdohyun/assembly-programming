# Chapter 3 — Assembly Language Fundamentals

## 3.9 Review Questions and Exercises

> **기준:** MASM / Irvine32 / 32-bit x86 Assembly
> **목표:** 각 문제의 핵심 개념을 이해하고, 필요한 경우 실제 Assembly 코드로 확인한다.

---

# 3.9.1 Short Answer

## 1. 서로 다른 명령어 니모닉(mnemonic) 3개의 예를 제시하시오.

대표적인 명령어 니모닉은 다음과 같다.

```asm
MOV
ADD
SUB
```

* `MOV` : 데이터를 이동한다.
* `ADD` : 두 값을 더한다.
* `SUB` : 두 값을 뺀다.

---

## 2. Calling Convention이란 무엇이며, Assembly 언어 선언에서 어떻게 사용되는가?

**Calling Convention(호출 규약)**은 프로시저를 호출할 때 인자를 전달하고 결과를 반환하며 레지스터와 스택을 관리하는 방법에 대한 규칙이다.

예를 들어 다음과 같은 내용을 결정한다.

* 인자를 레지스터와 스택 중 어디에 전달하는가?
* 반환값은 어디에 저장하는가?
* 어떤 레지스터를 호출 전후에 보존해야 하는가?
* 스택 정리는 누가 담당하는가?

Assembly에서는 프로시저를 호출할 때 호출하는 쪽과 호출되는 쪽이 동일한 규칙을 사용해야 한다.

---

## 3. 프로그램에서 Stack 공간을 어떻게 예약하는가?

`.stack` 지시어를 사용한다.

```asm
.stack 4096
```

위 코드는 **4096바이트의 Stack 공간**을 예약한다.

---

## 4. 왜 "assembler language"라는 용어가 정확하지 않은가?

**Assembly language**는 프로그래밍 언어이고, **assembler**는 Assembly language를 기계어 또는 목적 코드로 변환하는 프로그램이다.

즉,

```text
Assembly Language → Assembler → Object File
```

따라서 `assembler language`라고 하면 **언어와 번역 프로그램을 혼동하는 표현**이 된다.

일반적으로 **assembly language**라고 부르는 것이 정확하다.

---

## 5. Big Endian과 Little Endian의 차이를 설명하시오. 또한 이 용어의 유래를 조사하시오.

### Big Endian

가장 중요한 바이트인 **MSB(Most Significant Byte)**를 낮은 메모리 주소에 저장한다.

예를 들어:

```text
12345678h
```

메모리에 다음과 같이 저장된다.

```text
12 34 56 78
↑
낮은 주소
```

### Little Endian

가장 덜 중요한 바이트인 **LSB(Least Significant Byte)**를 낮은 메모리 주소에 저장한다.

```text
78 56 34 12
↑
낮은 주소
```

x86 프로세서는 **Little Endian 방식**을 사용한다.

### 용어의 유래

"Big Endian"과 "Little Endian"이라는 표현은 조너선 스위프트(Jonathan Swift)의 소설 **《걸리버 여행기》**에서 사람들이 달걀을 어느 쪽부터 깨먹는지를 두고 갈등하는 **Big-Endians와 Little-Endians**라는 표현에서 유래했다.

컴퓨터 분야에서는 이 표현을 데이터의 바이트를 어느 쪽부터 저장하는지를 설명하는 용어로 사용하게 되었다.

---

## 6. 정수 리터럴 대신 Symbolic Constant를 사용하는 이유는 무엇인가?

코드의 **가독성과 유지보수성**을 높일 수 있기 때문이다.

예를 들어:

```asm
MAX_VALUE = 100
```

다음과 같이 사용할 수 있다.

```asm
mov eax, MAX_VALUE
```

단순히

```asm
mov eax, 100
```

이라고 작성하는 것보다 `MAX_VALUE`가 무엇을 의미하는지 쉽게 알 수 있다.

또한 값이 변경되었을 때 Symbolic Constant의 정의만 수정하면 된다.

---

## 7. Source File과 Listing File의 차이는 무엇인가?

### Source File

프로그래머가 작성한 Assembly 언어 프로그램이다.

예:

```text
program.asm
```

### Listing File

Assembler가 Source File을 처리하면서 생성하는 파일로, Assembly 명령어와 주소, 기계어 코드 등의 정보를 확인할 수 있다.

예:

```text
program.lst
```

즉,

```text
Source File
    ↓
Assembler
    ↓
Object File + Listing File
```

---

## 8. Data Label과 Code Label은 어떻게 다른가?

### Data Label

메모리에 저장된 데이터를 나타내는 이름이다.

```asm
myValue DWORD 10
```

여기서 `myValue`가 Data Label이다.

### Code Label

프로그램의 특정 명령어 위치를 나타내는 이름이다.

```asm
L1:
    mov eax, 10
```

여기서 `L1`이 Code Label이다.

즉,

```text
Data Label → 데이터가 저장된 메모리 위치
Code Label → 실행할 명령어의 위치
```

---

## 9. True / False

> 식별자(identifier)는 숫자로 시작할 수 없다.

**정답: True**

Assembly의 identifier는 숫자로 시작할 수 없다.

잘못된 예:

```asm
2value DWORD 10
```

올바른 예:

```asm
value2 DWORD 10
```

---

## 10. True / False

> 16진수 리터럴은 `0x3A`와 같이 작성할 수 있다.

**정답: False**

MASM에서는 일반적으로 다음과 같이 작성한다.

```asm
3Ah
```

즉,

```asm
3Ah
```

가 MASM의 일반적인 16진수 표현이다.

---

## 11. True / False

> Assembly language directive는 프로그램 실행 중에 실행된다.

**정답: False**

Directive는 **Assembler가 프로그램을 번역할 때 처리하는 명령**이다.

따라서 CPU가 프로그램을 실행할 때 직접 실행되는 명령이 아니다.

예:

```asm
.data
.stack 4096
```

---

## 12. True / False

> Assembly language directive는 대문자와 소문자를 어떤 조합으로 작성해도 된다.

**정답: True**

MASM은 일반적으로 명령어와 Directive의 대소문자를 구분하지 않는다.

예:

```asm
.data
.DATA
.Data
```

모두 같은 의미로 사용할 수 있다.

---

## 13. Assembly language instruction의 기본 4가지 부분을 쓰시오.

기본적인 Assembly instruction의 구성 요소는 다음과 같다.

```text
Label     Mnemonic     Operand     Comment
```

예:

```asm
L1:       mov          eax, 10     ; EAX에 10을 저장
```

각각:

1. Label
2. Mnemonic
3. Operand
4. Comment

---

## 14. True / False

> `MOV`는 instruction mnemonic의 예이다.

**정답: True**

```asm
MOV EAX, EBX
```

여기서 `MOV`가 instruction mnemonic이다.

---

## 15. True / False

> Code Label은 콜론(`:`)으로 끝나지만 Data Label은 콜론으로 끝나지 않는다.

**정답: True**

예:

```asm
L1:
    mov eax, 10
```

Code Label:

```asm
L1:
```

Data Label:

```asm
myValue DWORD 10
```

---

## 16. Block Comment의 예를 작성하시오.

MASM에서는 `COMMENT` 지시어를 사용하여 여러 줄의 주석을 작성할 수 있다.

```asm
COMMENT !
이 부분은 여러 줄의
주석으로 처리된다.
프로그램 실행에는
영향을 주지 않는다.
!
```

---

## 17. 변수를 접근하는 명령어를 작성할 때 숫자 주소를 직접 사용하는 것이 좋지 않은 이유는?

메모리 주소를 직접 사용하면 프로그램의 **유지보수성이 크게 떨어지기 때문**이다.

예를 들어:

```asm
mov eax, [00404000h]
```

보다는

```asm
mov eax, myValue
```

처럼 변수 이름을 사용하는 것이 좋다.

변수의 메모리 위치가 변경되더라도 Label을 사용하면 Assembler가 새로운 주소를 처리할 수 있다.

따라서 Symbolic Name을 사용하는 것이 더 안전하고 읽기 쉽다.

---

## 18. ExitProcess 프로시저에는 어떤 종류의 인자를 전달해야 하는가?

`ExitProcess`에는 프로그램의 **종료 코드(exit code)**를 전달한다.

일반적으로 32비트 정수 값을 사용한다.

예:

```asm
INVOKE ExitProcess, 0
```

여기서 `0`은 정상적으로 프로그램이 종료되었음을 나타내는 종료 코드로 사용할 수 있다.

---

## 19. 어떤 Directive가 Procedure를 끝내는가?

```asm
ENDP
```

예:

```asm
main PROC

    ; instructions

main ENDP
```

---

## 20. 32-bit mode에서 END Directive의 identifier는 어떤 목적을 가지는가?

`END` 뒤의 identifier는 **프로그램의 시작점(entry point)**을 지정한다.

예:

```asm
END main
```

여기서 `main`은 프로그램이 시작할 위치를 나타낸다.

---

## 21. PROTO Directive의 목적은 무엇인가?

`PROTO`는 **프로시저의 프로토타입을 선언**하는 데 사용한다.

즉, 프로시저의 이름과 매개변수 정보를 미리 알려준다.

예:

```asm
ExitProcess PROTO, dwExitCode:DWORD
```

이후 다음과 같이 호출할 수 있다.

```asm
INVOKE ExitProcess, 0
```

---

## 22. True / False

> Object File은 Linker가 생성한다.

**정답: False**

Object File은 **Assembler가 생성**한다.

```text
.asm
 ↓
Assembler
 ↓
.obj
```

---

## 23. True / False

> Listing File은 Assembler가 생성한다.

**정답: True**

Assembler가 `.lst` 파일을 생성할 수 있다.

---

## 24. True / False

> Link Library는 Executable File을 만들기 직전에 프로그램에 추가된다.

**정답: True**

Linker가 Object File과 필요한 Library를 결합하여 Executable File을 만든다.

```text
Object File + Library
        ↓
      Linker
        ↓
      .exe
```

---

## 25. 32-bit signed integer 변수를 생성하는 Data Directive는?

```asm
SDWORD
```

예:

```asm
myValue SDWORD -100
```

---

## 26. 16-bit signed integer 변수를 생성하는 Data Directive는?

```asm
SWORD
```

예:

```asm
myValue SWORD -100
```

---

## 27. 64-bit unsigned integer 변수를 생성하는 Data Directive는?

```asm
QWORD
```

예:

```asm
myValue QWORD 100
```

---

## 28. 8-bit signed integer 변수를 생성하는 Data Directive는?

```asm
SBYTE
```

예:

```asm
myValue SBYTE -10
```

---

## 29. 10-byte packed BCD 변수를 생성하는 Data Directive는?

```asm
TBYTE
```

예:

```asm
myValue TBYTE ?
```

`TBYTE`는 10바이트 크기의 데이터를 정의할 때 사용한다.

---

# 3.9.2 Algorithm Workbench

## 1. 10진수, 2진수, 8진수, 16진수 형식으로 정수 25를 나타내는 Symbolic Constant 4개를 정의하시오.

```asm
DECIMAL_25 = 25
BINARY_25 = 11001b
OCTAL_25 = 31o
HEX_25 = 19h
```

각 값은 모두 동일하다.

```text
25(10진수)
= 11001(2진수)
= 31(8진수)
= 19(16진수)
```

---

## 2. 하나의 프로그램에 여러 개의 Code Segment와 Data Segment를 사용할 수 있는지 시행착오를 통해 확인하시오.

가능하다.

예:

```asm
.data

value1 DWORD 10

.code

main PROC

    mov eax, value1

main ENDP

.data

value2 DWORD 20

.code

another PROC

    mov eax, value2

another ENDP
```

MASM에서는 여러 Segment를 사용할 수 있다.

다만 일반적인 프로그램에서는 불필요하게 여러 Segment를 사용하는 것보다 구조를 명확하게 유지하는 것이 좋다.

---

## 3. Doubleword를 Big Endian 형식으로 메모리에 저장하는 Data Definition을 작성하시오.

예를 들어 다음 값을 저장한다고 하자.

```asm
value DWORD 12345678h
```

x86은 Little Endian을 사용하므로 실제 메모리에는:

```text
78 56 34 12
```

순서로 저장된다.

Big Endian으로 저장하고 싶다면 각 바이트의 순서를 직접 지정한다.

```asm
value BYTE 12h, 34h, 56h, 78h
```

메모리에는 다음 순서로 저장된다.

```text
12 34 56 78
```

---

## 4. DWORD 타입의 변수를 선언하고 음수 값을 저장할 수 있는지 확인하시오. 이것은 Assembler의 Type Checking에 대해 무엇을 알려주는가?

다음과 같이 작성할 수 있다.

```asm
value DWORD -10
```

MASM은 이를 허용할 수 있다.

하지만 `DWORD`는 **부호 없는 32비트 데이터 타입**으로 사용되는 것이 일반적이다.

따라서 음수 값을 넣는 것이 의미상 signed integer라는 뜻은 아니다.

이것은 Assembler의 Type Checking이 고급 언어의 Type Checking만큼 엄격하지 않다는 것을 보여준다.

즉, 개발자가 데이터의 의미와 해석을 올바르게 관리해야 한다.

---

## 5. 다음 두 명령어를 작성하고 Listing File에서 생성된 Machine Code를 비교하시오.

### 프로그램

```asm
INCLUDE Irvine32.inc

.code

main PROC

    mov eax, 0
    mov edx, 0

    add eax, 5
    add edx, 5

    exit

main ENDP
END main
```

핵심 비교:

```asm
add eax, 5
add edx, 5
```

두 명령어는 모두 동일한 동작을 수행한다.

차이점은 **사용하는 레지스터가 다르기 때문에 Machine Code에서 레지스터를 지정하는 부분이 달라진다.**

즉,

```text
ADD + EAX + 5
ADD + EDX + 5
```

는 같은 형태의 명령어지만 EAX와 EDX를 구분하기 위한 Machine Code가 다르다.

---

## 6. `456789ABh`의 Byte 값을 Little Endian 순서로 나열하시오.

원래 값:

```text
456789ABh
```

Byte 단위로 나누면:

```text
45 67 89 AB
```

Little Endian에서는 가장 작은 Byte부터 저장한다.

따라서:

```text
AB 89 67 45
```

정답:

```text
ABh, 89h, 67h, 45h
```

---

## 7. 초기화되지 않은 unsigned doubleword 120개의 배열을 선언하시오.

```asm
array DWORD 120 DUP(?)
```

---

## 8. 알파벳의 처음 5개 문자를 초기화한 Byte 배열을 선언하시오.

```asm
letters BYTE 'A', 'B', 'C', 'D', 'E'
```

또는:

```asm
letters BYTE "ABCDE"
```

---

## 9. 32-bit signed integer 변수를 선언하고 가능한 가장 작은 음수 10진수 값으로 초기화하시오.

32-bit signed integer의 범위는:

```text
-2,147,483,648 ~ 2,147,483,647
```

따라서:

```asm
minValue SDWORD -2147483648
```

---

## 10. `wArray`라는 이름의 unsigned 16-bit integer 배열을 선언하고 3개의 초기값을 사용하시오.

```asm
wArray WORD 10, 20, 30
```

---

## 11. 좋아하는 색상의 이름을 포함하는 문자열 변수를 선언하고 Null-Terminated String으로 초기화하시오.

예를 들어 좋아하는 색상을 `Blue`라고 하면:

```asm
color BYTE "Blue", 0
```

마지막의 `0`이 Null Terminator이다.

---

## 12. `dArray`라는 이름으로 초기화되지 않은 signed doubleword 50개를 배열로 선언하시오.

```asm
dArray SDWORD 50 DUP(?)
```

---

## 13. `"TEST"`라는 단어가 500번 반복되는 문자열 변수를 선언하시오.

```asm
testString BYTE 500 DUP("TEST")
```

총 문자열 크기는:

```text
4 × 500 = 2000 bytes
```

---

## 14. `bArray`라는 이름의 unsigned byte 20개를 선언하고 모든 원소를 0으로 초기화하시오.

```asm
bArray BYTE 20 DUP(0)
```

---

## 15. 다음 Doubleword 변수의 각 Byte가 메모리의 낮은 주소에서 높은 주소 순서로 어떻게 저장되는지 나타내시오.

```asm
val1 DWORD 87654321h
```

값을 Byte 단위로 나누면:

```text
87 65 43 21
```

x86은 Little Endian이므로:

```text
21 43 65 87
```

따라서 낮은 주소 → 높은 주소 순서는:

```text
21h → 43h → 65h → 87h
```

---

# 3.10 Programming Exercises

## 1. Integer Expression Calculation

다음 식을 계산하는 프로그램을 작성한다.

```text
A = (A + B) - (C + D)
```

EAX, EBX, ECX, EDX에 각각 값을 저장한다.

### 풀이

```asm
INCLUDE Irvine32.inc

.code

main PROC

    ; A = EAX
    ; B = EBX
    ; C = ECX
    ; D = EDX

    mov eax, 10
    mov ebx, 20
    mov ecx, 5
    mov edx, 3

    ; A + B
    add eax, ebx

    ; C + D
    add ecx, edx

    ; (A + B) - (C + D)
    sub eax, ecx

    call DumpRegs

    exit

main ENDP
END main
```

계산 과정:

```text
A = 10
B = 20
C = 5
D = 3

(A + B) - (C + D)
= (10 + 20) - (5 + 3)
= 30 - 8
= 22
```

따라서 최종적으로:

```text
EAX = 22
```

---

# 2. Symbolic Integer Constants

7개의 요일을 나타내는 Symbolic Constant를 정의하고 배열의 초기값으로 사용한다.

```asm
INCLUDE Irvine32.inc

MONDAY    = 1
TUESDAY   = 2
WEDNESDAY = 3
THURSDAY  = 4
FRIDAY    = 5
SATURDAY  = 6
SUNDAY    = 7

.data

days BYTE MONDAY, TUESDAY, WEDNESDAY, THURSDAY,
          FRIDAY, SATURDAY, SUNDAY

.code

main PROC

    exit

main ENDP
END main
```

---

# 3. Data Definitions

Chapter 3에서 다루는 주요 Data Type을 각각 선언한다.

```asm
.data

byteValue   BYTE  10
sbyteValue  SBYTE -10

wordValue   WORD  1000
swordValue  SWORD -1000

dwordValue  DWORD 100000
sdwordValue SDWORD -100000

qwordValue  QWORD 10000000000
sqwordValue QWORD -10000000000

tbyteValue  TBYTE 12345678901234567890h
```

각 자료형의 기본 크기:

| 자료형    |       크기 |
| ------ | -------: |
| BYTE   |   1 Byte |
| SBYTE  |   1 Byte |
| WORD   |  2 Bytes |
| SWORD  |  2 Bytes |
| DWORD  |  4 Bytes |
| SDWORD |  4 Bytes |
| QWORD  |  8 Bytes |
| TBYTE  | 10 Bytes |

> `QWORD`는 unsigned 데이터 표현에 사용되며, signed 64-bit 값을 명시적으로 표현할 때는 해당 교재의 MASM 문법에 맞춰 주의해야 한다.

---

# 4. Symbolic Text Constants

여러 문자열을 Symbolic Name으로 정의하고 변수 정의에 사용한다.

```asm
INCLUDE Irvine32.inc

GREETING TEXTEQU <"Hello">
NAME_TEXT TEXTEQU <"Assembly">
LANGUAGE TEXTEQU <"MASM">

.data

str1 BYTE GREETING, 0
str2 BYTE NAME_TEXT, 0
str3 BYTE LANGUAGE, 0

.code

main PROC

    exit

main ENDP
END main
```

---

# 5. Listing File for AddTwoSum

`AddTwoSum` 프로그램을 Assembly한 후 Listing File을 생성하여 각 명령어의 Machine Code를 확인한다.

예를 들어:

```asm
mov eax, 10
add eax, 20
```

와 같은 명령어는 Assembler에 의해 Machine Code로 변환된다.

Listing File에서는 일반적으로 다음과 같은 정보를 확인할 수 있다.

```text
주소        Machine Code       Assembly Instruction
---------------------------------------------------
00000000    ...                mov eax, 10
00000005    ...                add eax, 20
```

여기서 중요한 점은 Assembly 명령어가 CPU가 직접 이해할 수 있는 **Machine Code Byte**로 변환된다는 것이다.

실제 Byte 값은 사용하는 MASM 버전, 명령어 형태 및 옵션에 따라 확인해야 하므로 Listing File에서 직접 확인하는 것이 가장 정확하다.

---

# 6. AddVariables Program을 64-bit 변수로 수정하시오.

기존 프로그램에서 일반적으로 사용하는 32-bit 자료형:

```asm
DWORD
SDWORD
```

를 64-bit 자료형인:

```asm
QWORD
```

로 변경한다.

예를 들어 기존 코드가 다음과 같다고 하자.

```asm
.data

var1 DWORD 10000
var2 DWORD 20000
```

64-bit 변수로 변경하면:

```asm
.data

var1 QWORD 10000
var2 QWORD 20000
```

그러나 여기서 중요한 문제가 발생한다.

32-bit 레지스터인:

```asm
EAX
EBX
ECX
EDX
```

는 64-bit 값을 저장할 수 없다.

64-bit 환경에서는 일반적으로:

```asm
RAX
RBX
RCX
RDX
```

와 같은 64-bit 레지스터를 사용한다.

따라서 단순히 `DWORD`를 `QWORD`로 변경하는 것만으로는 기존 프로그램을 완전히 64-bit 프로그램으로 변환할 수 없다.

또한 **Irvine32는 32-bit 환경을 대상으로 하는 라이브러리**이므로, 기존 Irvine32 기반 프로그램을 그대로 64-bit 방식으로 변경할 때는 라이브러리와 프로젝트 설정까지 함께 변경해야 한다.

---

# 핵심 정리

Chapter 3에서 가장 중요한 내용은 다음과 같다.

```text
Assembly Source Code
        ↓
     Assembler
        ↓
 Object File (.obj)
        ↓
      Linker
        ↓
Executable File (.exe)
```

그리고 Assembly 프로그램은 크게 다음 요소로 구성된다.

```text
Label
Mnemonic
Operand
Comment
```

데이터를 정의할 때는:

```asm
BYTE
WORD
DWORD
QWORD
TBYTE
```

등의 Data Directive를 사용한다.

x86에서 여러 바이트로 이루어진 값은 **Little Endian** 방식으로 메모리에 저장된다.

예:

```asm
value DWORD 12345678h
```

메모리:

```text
낮은 주소 → 높은 주소

78h  56h  34h  12h
```

마지막으로 Assembly에서는 사람이 읽기 쉬운 **Symbolic Name**을 사용하는 것이 중요하다.

```asm
MAX_VALUE = 100

mov eax, MAX_VALUE
```

숫자 주소나 의미 없는 숫자를 직접 사용하는 것보다 프로그램의 **가독성, 유지보수성, 오류 방지**에 유리하다.
