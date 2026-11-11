# Chapter 8. Advanced Procedures

MASM과 Irvine32 라이브러리를 활용하여 프로시저의 매개변수, 지역 변수, 스택 프레임, 호출 규약에 대해 학습했다.

---

## 8.10.1 Short Answer

### 1. 프로시저에 스택 매개변수와 지역 변수가 있을 때 Epilogue에 포함되는 명령어는?

일반적으로 프로시저의 Epilogue에서는 지역 변수를 정리하고 호출 전의 스택 상태로 되돌린다.

대표적인 형태는 다음과 같다.

```asm
mov esp, ebp
pop ebp
ret
```

`mov esp, ebp`를 통해 지역 변수가 사용하던 스택 공간을 정리하고, `pop ebp`로 이전의 EBP 값을 복원한다.

---

### 2. C 함수가 32비트 정수를 반환할 때 반환 값은 어디에 저장되는가?

32비트 정수 반환 값은 일반적으로 **EAX 레지스터**에 저장된다.

```asm
mov eax, result
ret
```

---

### 3. STDCALL 호출 규약에서는 프로시저 호출 후 누가 스택을 정리하는가?

STDCALL 호출 규약에서는 **호출된 프로시저(callee)가 스택을 정리한다.**

예를 들어 2개의 DWORD 매개변수를 사용하는 경우 다음과 같이 사용할 수 있다.

```asm
ret 8
```

매개변수 2개 × 4바이트이므로 총 8바이트를 스택에서 제거한다.

---

### 4. LEA 명령어가 OFFSET 연산자보다 더 강력한 이유는?

`OFFSET`은 변수의 주소를 가져오는 데 사용하지만, `LEA`는 메모리 주소를 계산하여 레지스터에 저장할 수 있다.

예를 들어 배열의 특정 위치 주소를 계산할 수 있다.

```asm
lea eax, [ebx + esi*4]
```

따라서 `LEA`는 단순한 변수 주소뿐만 아니라 레지스터와 인덱스를 활용한 복잡한 주소 계산도 가능하다.

---

### 5. C++ 예제에서 int형 변수는 스택 공간을 얼마나 사용하는가?

32비트 환경에서 `int`형 변수는 일반적으로 **4바이트**의 스택 공간을 사용한다.

---

### 6. C 호출 규약이 STDCALL 호출 규약보다 가질 수 있는 장점은?

C 호출 규약에서는 **호출자(caller)가 스택을 정리한다.**

이 방식의 장점은 가변 개수의 매개변수를 사용하는 함수에 사용할 수 있다는 점이다.

예를 들어 `printf`처럼 전달되는 매개변수의 개수가 일정하지 않은 함수에 적합하다.

---

### 7. PROC 지시어를 사용할 때 모든 매개변수는 같은 줄에 작성해야 한다.

**False**

매개변수 선언은 줄을 나누어 작성할 수도 있다.

---

### 8. BYTE 배열의 오프셋을 WORD 배열 포인터를 기대하는 프로시저에 전달하면 어셈블러가 오류를 표시한다.

**True**

MASM의 타입 검사 기능을 사용하면 전달하는 주소의 자료형이 프로시저에서 기대하는 포인터 자료형과 맞지 않을 경우 오류를 확인할 수 있다.

---

### 9. 참조 매개변수를 기대하는 프로시저에 즉시 값을 전달하면 General-Protection Fault가 발생할 수 있다.

**True**

참조 매개변수는 메모리 주소를 기대한다. 즉시 값을 전달하면 그 값이 주소처럼 사용될 수 있으므로 잘못된 메모리에 접근하여 오류가 발생할 가능성이 있다.

---

# 8.10.2 Algorithm Workbench

## 1. AddThree 프로시저의 스택 프레임

다음 코드에서 매개변수는 오른쪽부터 스택에 쌓이는 것이 아니라 작성된 순서대로 `push`되기 때문에, 마지막으로 넣은 값이 가장 낮은 주소에 위치한다.

```asm
push 10h
push 20h
push 30h
call AddThree
```

프로시저 내부에서 EBP를 저장한 직후의 스택 구조는 다음과 같이 생각할 수 있다.

```text
높은 주소
┌─────────────────────┐
│  10h                │  [EBP+16]
├─────────────────────┤
│  20h                │  [EBP+12]
├─────────────────────┤
│  30h                │  [EBP+8]
├─────────────────────┤
│  Return Address     │  [EBP+4]
├─────────────────────┤
│  Old EBP            │  [EBP]
└─────────────────────┘
낮은 주소
```

---

## 2. AddThree 프로시저 만들기

세 개의 정수를 전달받아 합계를 EAX에 반환하도록 작성할 수 있다.

```asm
AddThree PROC,
    num1:DWORD,
    num2:DWORD,
    num3:DWORD

    mov eax, num1
    add eax, num2
    add eax, num3

    ret
AddThree ENDP
```

---

## 3. DWORD 배열을 가리키는 포인터 pArray 선언

```asm
LOCAL pArray:PTR DWORD
```

---

## 4. 20바이트 크기의 buffer 배열 선언

```asm
LOCAL buffer[20]:BYTE
```

---

## 5. 16비트 부호 없는 정수를 가리키는 pwArray 선언

```asm
LOCAL pwArray:PTR WORD
```

---

## 6. 8비트 부호 있는 정수를 저장하는 myByte 선언

```asm
LOCAL myByte:SBYTE
```

---

## 7. DWORD 20개로 이루어진 myArray 선언

```asm
LOCAL myArray[20]:DWORD
```

---

## 8. SetColor 프로시저

전경색과 배경색을 매개변수로 전달받아 Irvine32 라이브러리의 `SetTextColor`를 호출한다.

```asm
SetColor PROC forecolor:DWORD, backcolor:DWORD

    mov eax, backcolor
    shl eax, 4
    or eax, forecolor

    call SetTextColor

    ret
SetColor ENDP
```

배경색은 상위 4비트에 위치하므로 왼쪽으로 4비트 이동시킨 후 전경색과 결합한다.

---

## 9. WriteColorChar 프로시저

문자와 전경색, 배경색을 전달받아 지정된 색상으로 문자 하나를 출력한다.

```asm
WriteColorChar PROC char:DWORD, forecolor:DWORD, backcolor:DWORD

    mov eax, backcolor
    shl eax, 4
    or eax, forecolor
    call SetTextColor

    mov eax, char
    call WriteChar

    ret
WriteColorChar ENDP
```

---

## 10. DumpMemory 프로시저

Irvine32의 `DumpMem`을 감싸는 프로시저를 선언할 수 있다.

```asm
DumpMemory PROTO,
    pArray:PTR DWORD,
    arrayLength:DWORD,
    elementSize:DWORD
```

프로시저 내부에서는 전달받은 값을 `DumpMem`이 사용하는 레지스터에 맞게 설정한다.

```asm
DumpMemory PROC USES eax ecx edx,
    pArray:PTR DWORD,
    arrayLength:DWORD,
    elementSize:DWORD

    mov esi, pArray
    mov ecx, arrayLength
    mov ebx, elementSize

    call DumpMem
    ret

DumpMemory ENDP
```

호출 예시는 다음과 같다.

```asm
INVOKE DumpMemory, OFFSET array, LENGTHOF array, TYPE array
```

---

## 11. MultArray 프로시저와 PROTO 선언

두 개의 DWORD 배열 포인터와 배열의 크기를 전달받는 프로시저를 다음과 같이 선언할 수 있다.

```asm
MultArray PROTO,
    pArray1:PTR DWORD,
    pArray2:PTR DWORD,
    arraySize:DWORD
```

프로시저 선언은 다음과 같다.

```asm
MultArray PROC,
    pArray1:PTR DWORD,
    pArray2:PTR DWORD,
    arraySize:DWORD

    ; 배열 연산 코드 작성

    ret
MultArray ENDP
```

---

# 8.11 Programming Exercises

## 1. FindLargest Procedure

배열의 주소와 배열의 길이를 전달받아 가장 큰 값을 EAX에 반환하는 프로시저이다.

음수도 포함될 수 있으므로 첫 번째 배열 값을 기준으로 시작한다.

```asm
INCLUDE Irvine32.inc

FindLargest PROTO,
    pArray:PTR SDWORD,
    arraySize:DWORD

.data

array1 SDWORD 10, -5, 30, 20, -8
array2 SDWORD -10, -3, -20, -1
array3 SDWORD 100, 50, 200, -30, 150

.code

main PROC

    INVOKE FindLargest, OFFSET array1, LENGTHOF array1
    call WriteInt
    call Crlf

    INVOKE FindLargest, OFFSET array2, LENGTHOF array2
    call WriteInt
    call Crlf

    INVOKE FindLargest, OFFSET array3, LENGTHOF array3
    call WriteInt
    call Crlf

    exit

main ENDP


FindLargest PROC USES esi ecx edx,
    pArray:PTR SDWORD,
    arraySize:DWORD

    mov esi, pArray
    mov ecx, arraySize

    mov eax, [esi]
    add esi, TYPE SDWORD
    dec ecx

L1:
    cmp ecx, 0
    je L2

    mov edx, [esi]
    cmp edx, eax
    jle NextValue

    mov eax, edx

NextValue:
    add esi, TYPE SDWORD
    dec ecx
    jmp L1

L2:
    ret

FindLargest ENDP

END main
```

### 배운 점

가장 큰 값을 찾을 때 배열에 음수가 포함될 수 있기 때문에 EAX를 0으로 초기화하면 문제가 발생할 수 있다. 그래서 배열의 첫 번째 값을 기준값으로 설정하는 방법을 사용했다.

---

## 4. FindThrees Procedure

배열 안에 연속된 숫자 `3`이 세 번 등장하면 EAX에 1을 반환하고, 없으면 0을 반환한다.

```asm
FindThrees PROTO,
    pArray:PTR DWORD,
    arraySize:DWORD


FindThrees PROC USES esi ecx edx,
    pArray:PTR DWORD,
    arraySize:DWORD

    mov esi, pArray
    mov ecx, arraySize

    xor eax, eax
    xor edx, edx

L1:
    cmp ecx, 0
    je NotFound

    cmp DWORD PTR [esi], 3
    jne ResetCount

    inc edx
    cmp edx, 3
    je Found

    jmp NextElement

ResetCount:
    xor edx, edx

NextElement:
    add esi, TYPE DWORD
    dec ecx
    jmp L1

Found:
    mov eax, 1
    ret

NotFound:
    mov eax, 0
    ret

FindThrees ENDP
```

---

## 5. DifferentInputs Procedure

세 개의 입력값이 모두 서로 다르면 EAX에 1을 반환하고, 같은 값이 하나라도 있으면 0을 반환한다.

```asm
DifferentInputs PROTO,
    value1:DWORD,
    value2:DWORD,
    value3:DWORD


DifferentInputs PROC,
    value1:DWORD,
    value2:DWORD,
    value3:DWORD

    mov eax, value1

    cmp eax, value2
    je Same

    cmp eax, value3
    je Same

    mov eax, value2
    cmp eax, value3
    je Same

    mov eax, 1
    ret

Same:
    mov eax, 0
    ret

DifferentInputs ENDP
```

---

## 6. Exchanging Integers

배열의 인접한 두 원소를 순서대로 교환하는 프로그램이다.

예를 들어 다음 배열이 있다고 가정한다.

```text
1, 2, 3, 4, 5, 6
```

교환 후에는 다음과 같이 된다.

```text
2, 1, 4, 3, 6, 5
```

인접한 두 값의 주소를 전달하여 `Swap` 프로시저를 반복적으로 호출하는 방식으로 구현할 수 있다.

---

## 7. Greatest Common Divisor

유클리드 알고리즘을 재귀적으로 구현한다.

두 수 `a`, `b`에 대해 다음 과정을 반복한다.

```text
GCD(a, b) = GCD(b, a mod b)
```

나머지가 0이 되면 현재의 `b`가 최대공약수이다.

```asm
GCD PROTO,
    num1:DWORD,
    num2:DWORD


GCD PROC,
    num1:DWORD,
    num2:DWORD

    mov eax, num1
    mov ebx, num2

    cmp ebx, 0
    jne DivideNumbers

    mov eax, num1
    ret

DivideNumbers:
    xor edx, edx
    div ebx

    INVOKE GCD, ebx, edx

    ret

GCD ENDP
```

테스트할 숫자 조합은 다음과 같다.

```text
(5, 20)
(24, 18)
(11, 7)
(432, 226)
(26, 13)
```

---

## 8. CountMatches

두 배열의 같은 위치에 있는 값이 서로 같은 경우 개수를 세어 EAX에 반환한다.

```asm
CountMatches PROTO,
    pArray1:PTR SDWORD,
    pArray2:PTR SDWORD,
    arraySize:DWORD


CountMatches PROC USES esi edi ecx edx,
    pArray1:PTR SDWORD,
    pArray2:PTR SDWORD,
    arraySize:DWORD

    mov esi, pArray1
    mov edi, pArray2
    mov ecx, arraySize

    xor eax, eax

L1:
    mov edx, [esi]
    cmp edx, [edi]
    jne NextElement

    inc eax

NextElement:
    add esi, TYPE SDWORD
    add edi, TYPE SDWORD

    loop L1

    ret

CountMatches ENDP
```

---

## 9. CountNearMatches

두 배열의 같은 위치에 있는 값의 차이가 `diff` 이하인 경우 개수를 센다.

구현할 때 중요한 부분은 두 값의 차이를 절댓값으로 계산하는 것이다.

```text
difference = |x - y|
```

차이가 음수가 될 수도 있기 때문에 부호를 확인하여 양수로 변환한 후 `diff`와 비교해야 한다.

---

## 10. ShowParams

호출한 프로시저의 스택에 있는 매개변수 주소와 16진수 값을 출력하는 프로시저이다.

예를 들어 다음과 같이 호출할 수 있다.

```asm
INVOKE MySample, 1234h, 5000h, 6543h
```

출력 결과는 매개변수의 주소와 값을 낮은 주소부터 높은 주소 순서로 보여준다.

```text
Stack parameters:
--------------------------
Address 0012FF80 = 00001234
Address 0012FF84 = 00005000
Address 0012FF88 = 00006543
```

이 문제를 통해 스택에 매개변수가 저장되는 위치와 EBP를 기준으로 매개변수에 접근하는 방법을 다시 확인할 수 있었다.

---

# 학습 내용 정리

이번 Chapter 8에서는 이전보다 프로시저와 스택의 구조를 자세히 학습했다.

특히 다음 내용을 중점적으로 공부했다.

- `PROC`를 이용한 매개변수 선언
- `PROTO`와 `INVOKE` 사용 방법
- `LOCAL`을 이용한 지역 변수 선언
- `USES`를 이용한 레지스터 보존
- EBP와 ESP를 이용한 스택 프레임 이해
- STDCALL과 C 호출 규약의 차이
- 프로시저의 반환 값을 EAX로 전달하는 방법
- 배열 주소와 포인터를 프로시저에 전달하는 방법

이번 내용을 공부하면서 어셈블리어에서 프로시저를 호출할 때 단순히 함수를 실행하는 것이 아니라, **매개변수와 반환 주소, 지역 변수가 모두 스택을 통해 관리된다는 점**을 이해할 수 있었다.

특히 `PROTO`, `INVOKE`, `PROC`를 함께 사용하면 매개변수의 자료형과 호출 방법을 좀 더 명확하게 작성할 수 있다는 점이 인상적이었다.
