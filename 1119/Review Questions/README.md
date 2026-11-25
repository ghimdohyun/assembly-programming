# Chapter 10. Structures and Macros
## 10.7 Review Questions and Exercises / 10.8 Programming Exercises

---

# 10.7 복습 문제 및 연습 문제

## 10.7.1 단답형 문제

### 1. STRUCT 지시어의 목적은 무엇인가?

`STRUCT` 지시어는 여러 개의 데이터 항목을 하나의 구조체로 묶어서 정의할 때 사용한다.

구조체를 사용하면 서로 관련된 데이터를 하나의 자료형처럼 관리할 수 있다.

### 2. 다음 구조체 선언에서 각 선언이 올바른지 판단하시오.

```asm
RentalInvoice STRUCT
    invoiceNum BYTE 5 DUP(' ')
    dailyPrice WORD ?
    daysRented WORD ?
RentalInvoice ENDS
```

**a.**
```asm
rentals RentalInvoice <>
```
- 올바른 선언이다.
- `rentals`라는 이름으로 `RentalInvoice` 구조체 변수를 생성한다.

**b.**
```asm
RentalInvoice rentals <>
```
- 올바르지 않은 선언이다.
- MASM 구조체 변수 선언은 변수 이름을 먼저 작성하고 구조체 이름을 뒤에 작성해야 한다.

**c.**
```asm
march RentalInvoice <'12345', 10, 0>
```
- 올바른 선언이다.
- 송장 번호는 `'12345'`, 일일 요금은 `10`, 대여 일수는 `0`으로 초기화한다.

**d.**
```asm
RentalInvoice <, 10, 0>
```
- 올바르지 않은 선언이다.
- 구조체 변수의 이름이 지정되지 않았다.

**e.**
```asm
current RentalInvoice <, 15, 0, 0>
```
- 올바르지 않은 선언이다.
- 구조체에 정의된 필드는 총 3개이지만 초기화 값이 4개이므로 개수가 일치하지 않는다.

### 3. 매크로에는 데이터 정의를 포함할 수 없다. (참 또는 거짓)

**정답: 거짓**

매크로 내부에는 데이터 정의를 포함할 수 있다. 다만 매크로가 확장되는 위치와 어셈블리 문법에 맞게 작성해야 한다.

### 4. LOCAL 지시어의 목적은 무엇인가?

`LOCAL` 지시어는 매크로 내부에서 사용하는 지역 레이블을 선언할 때 사용한다.

매크로가 여러 번 호출되더라도 각 확장마다 고유한 레이블이 생성되므로 레이블 이름이 중복되는 문제를 방지할 수 있다.

### 5. %OUT 지시어의 목적은 무엇인가?

`%OUT` 지시어는 어셈블리 과정에서 프로그래머에게 메시지를 출력할 때 사용한다.

주로 매크로를 디버깅하거나 조건부 어셈블리 과정에서 오류 메시지를 표시하는 데 활용한다.

### 6. ENDIF 지시어의 목적은 무엇인가?

`ENDIF` 지시어는 조건부 어셈블리 블록을 종료할 때 사용한다.

`IF`, `ELSE` 등으로 시작한 조건부 어셈블리 구문의 끝을 나타낸다.

### 7. 매크로에서 사용할 수 있는 관계 연산자를 작성하시오.

| 연산자 | 의미 |
|---|---|
| EQ | 같음 |
| NE | 같지 않음 |
| LT | 작음 |
| LE | 작거나 같음 |
| GT | 큼 |
| GE | 크거나 같음 |

### 8. 매크로에서 & 기호의 목적은 무엇인가?

`&` 기호는 매크로 매개변수와 주변 문자열을 연결하는 데 사용한다.

매크로 매개변수 뒤에 다른 문자가 붙어 있을 때 매개변수의 끝을 명확하게 구분하거나, 문자열과 식별자를 결합할 수 있다.

### 9. 매크로에서 ! 기호의 목적은 무엇인가?

`!` 기호는 매크로에서 특별한 의미를 가지는 문자를 일반 문자로 처리하도록 하는 이스케이프 문자로 사용한다.

### 10. 매크로에서 % 기호의 목적은 무엇인가?

`%` 기호는 매크로에서 표현식을 어셈블리 시간에 평가하도록 할 때 사용한다.

이를 통해 매크로 확장 과정에서 계산된 결과를 사용할 수 있다.

---

## 10.7.2 알고리즘 워크벤치

### 1. 다음 구조체를 정의하시오.

요구사항:
- `field1`은 WORD 형식이다.
- `field2`는 DWORD 형식의 배열이며 원소가 20개이다.

**정답**

```asm
SampleStruct STRUCT
    field1 WORD ?
    field2 DWORD 20 DUP(?)
SampleStruct ENDS
```

**설명**

- `STRUCT`는 구조체의 시작을 나타낸다.
- `WORD ?`는 초기화되지 않은 2바이트 데이터를 의미한다.
- `DWORD 20 DUP(?)`는 초기화되지 않은 4바이트 데이터를 20개 생성한다.
- `ENDS`는 구조체 정의를 종료한다.

### 2. SYSTEMTIME 구조체의 wHour 필드 값을 AX 레지스터에 복사하는 명령어를 작성하시오.

**정답**

```asm
mov ax, systemTime.wHour
```

**설명**

`systemTime` 구조체 변수의 `wHour` 필드에 저장된 값을 AX 레지스터로 복사한다.

### 3. Triangle 구조체 변수를 선언하고 세 꼭짓점의 좌표를 초기화하시오.

**정답**

```asm
myTriangle Triangle <<0,0>, <5,0>, <7,6>>
```

**설명**

세 꼭짓점의 좌표를 다음과 같이 초기화한다.

| 꼭짓점 | X 좌표 | Y 좌표 |
|---|---:|---:|
| Vertex1 | 0 | 0 |
| Vertex2 | 5 | 0 |
| Vertex3 | 7 | 6 |

중첩된 꺾쇠괄호는 각 좌표 구조체의 초기화 값을 나타낸다.

### 4. Triangle 구조체 배열을 10개 생성하고 각 꼭짓점의 X 좌표를 0~10 사이의 난수로 초기화하시오.

**정답 예시**

```asm
INCLUDE Irvine32.inc

Triangle STRUCT
    Vertex1 COORD <>
    Vertex2 COORD <>
    Vertex3 COORD <>
Triangle ENDS

.data
triangles Triangle 10 DUP(<>)

.code
main PROC
    call Randomize

    mov esi, 0
    mov ecx, LENGTHOF triangles

L1:
    ; Vertex1의 X 좌표
    mov eax, 11
    call RandomRange
    mov triangles[esi].Vertex1.X, ax

    ; Vertex2의 X 좌표
    mov eax, 11
    call RandomRange
    mov triangles[esi].Vertex2.X, ax

    ; Vertex3의 X 좌표
    mov eax, 11
    call RandomRange
    mov triangles[esi].Vertex3.X, ax

    add esi, SIZEOF Triangle
    loop L1

    exit
main ENDP
END main
```

**설명**

- `Triangle 10 DUP(<>)`는 Triangle 구조체 변수 10개를 생성한다.
- `Randomize`는 난수 생성기의 초기값을 설정한다.
- `RandomRange`는 0부터 지정한 값보다 작은 범위의 난수를 생성한다.
- `RandomRange`에 11을 전달하면 0~10 사이의 난수가 생성된다.
- `SIZEOF Triangle`은 구조체 하나의 크기를 바이트 단위로 반환한다.

### 5. 문자를 지정한 횟수만큼 출력하는 mPrintChar 매크로를 작성하시오.

**정답**

```asm
mPrintChar MACRO char, count
    LOCAL L1

    mov ecx, count
    mov al, char

L1:
    call WriteChar
    loop L1
ENDM
```

**사용 예시**

```asm
mPrintChar 'X', 20
```

**설명**

`mPrintChar` 매크로는 전달받은 문자를 지정한 횟수만큼 출력한다.

- `char`: 출력할 문자
- `count`: 반복 횟수
- `LOCAL L1`: 매크로가 여러 번 호출되어도 레이블이 중복되지 않도록 한다.
- `WriteChar`: AL 레지스터에 저장된 문자를 출력한다.

※ 반복 횟수는 1 이상이라고 가정한다.

### 6. 0부터 지정한 값보다 작은 난수를 생성하는 mGenRandom 매크로를 작성하시오.

**정답**

```asm
mGenRandom MACRO n
    mov eax, n
    call RandomRange
ENDM
```

**사용 예시**

```asm
call Randomize
mGenRandom 100
```

**설명**

`RandomRange`는 EAX에 전달된 범위에서 난수를 생성한다.

위 예시에서는 0~99 사이의 난수가 EAX에 반환된다.

### 7. 정수를 입력받아 지정한 변수에 저장하는 mPromptInteger 매크로를 작성하시오.

**정답**

```asm
mPromptInteger MACRO prompt, variable
    mWrite prompt
    call ReadInt
    mov variable, eax
ENDM
```

**사용 예시**

```asm
.data
minVal SDWORD ?

.code
mPromptInteger "최솟값을 입력하세요: ", minVal
```

**설명**

- `mWrite`는 안내 메시지를 출력한다.
- `ReadInt`는 사용자가 입력한 부호 있는 정수를 EAX에 저장한다.
- `mov variable, eax`는 입력한 값을 지정한 변수에 저장한다.

※ `mWrite`는 교재에서 제공하는 Irvine32 매크로 라이브러리를 사용한다.

### 8. 지정한 좌표에 문자열을 출력하는 mWriteAt 매크로를 작성하시오.

**정답**

```asm
mWriteAt MACRO x, y, string
    mGotoxy x, y
    mWrite string
ENDM
```

**사용 예시**

```asm
mWriteAt 10, 5, "Hello World"
```

**설명**

- `mGotoxy`는 화면 커서를 지정한 좌표로 이동시킨다.
- `mWrite`는 문자열을 출력한다.
- 따라서 위 예시는 화면의 X 좌표 10, Y 좌표 5 위치에 문자열을 출력한다.

### 9. 교재 10.2.5절의 mWriteStr 매크로가 확장된 어셈블리 코드를 작성하시오.

**예시**

```asm
mWriteStr namePrompt
```

**설명**

매크로는 호출될 때 전달된 매개변수를 실제 명령어로 치환한다.

예를 들어 문자열 주소를 전달하여 출력하는 형태라면 다음과 같은 명령어가 사용될 수 있다.

```asm
push edx
mov edx, OFFSET namePrompt
call WriteString
pop edx
```

※ 실제 확장 코드는 교재 10.2.5절에 제시된 `mWriteStr` 매크로 정의에 따라 결정된다. 위 코드는 문자열 출력 매크로의 동작을 설명하기 위한 예시이다.

### 10. mReadStr 매크로를 호출했을 때 확장되는 어셈블리 코드를 작성하시오.

**예시**

```asm
mReadStr customerName
```

**설명**

문자열을 입력받으려면 입력 버퍼의 주소와 최대 입력 크기를 전달해야 한다.

일반적인 `ReadString` 호출 형태는 다음과 같다.

```asm
push ecx
push edx

mov edx, OFFSET customerName
mov ecx, SIZEOF customerName
call ReadString

pop edx
pop ecx
```

※ 위 코드는 일반적인 `ReadString` 호출 형태를 설명한 것이다. 교재의 실제 `mReadStr` 정의에 따라 확장 결과는 달라질 수 있다.

### 11. 배열 정보를 출력하는 mDumpMemx 매크로를 작성하시오.

**정답**

```asm
mDumpMemx MACRO variable
    mDumpMem OFFSET variable, LENGTHOF variable, TYPE variable
ENDM
```

**설명**

- `OFFSET variable`: 배열의 시작 주소를 전달한다.
- `LENGTHOF variable`: 배열의 원소 개수를 반환한다.
- `TYPE variable`: 배열 원소 하나의 크기를 바이트 단위로 반환한다.
- `mDumpMem`: 메모리 내용을 출력하는 매크로이다.

### 12. 기본 매개변수 값을 설정하는 매크로를 작성하시오.

**정답**

```asm
mWriteText MACRO text, count:=1
    mov ecx, count
ENDM
```

**설명**

`count:=1`은 매크로 호출 시 두 번째 인수를 생략하면 기본값으로 1을 사용한다는 의미이다.

**사용 예시**

```asm
mWriteText "Hello"
```

위 호출에서는 `count`가 기본값인 1로 설정된다.

### 13. IF, ELSE, ENDIF를 이용한 조건부 어셈블리 코드를 작성하시오.

**정답**

```asm
VALUE = 10

IF VALUE GT 5
    mov eax, 1
ELSE
    mov eax, 0
ENDIF
```

**설명**

- `IF`는 조건을 검사한다.
- `ELSE`는 조건이 거짓일 때 실행할 명령어를 지정한다.
- `ENDIF`는 조건부 어셈블리 블록을 종료한다.

위 예시에서는 VALUE가 5보다 크기 때문에 `mov eax, 1`이 어셈블된다.

### 14. Z가 0보다 작으면 오류 메시지를 출력하는 코드를 작성하시오.

**정답**

```asm
Z = -1

IF Z LT 0
    %OUT Error: Z must be greater than or equal to zero.
ENDIF
```

**설명**

`IF Z LT 0`은 Z가 0보다 작은지 검사한다.

조건이 참이면 `%OUT`을 통해 어셈블리 과정에서 오류 메시지를 출력한다.

### 15. & 기호를 이용하여 매크로 매개변수와 문자열을 결합하는 예시를 작성하시오.

**정답**

```asm
mCreateMessage MACRO number
    msg&number BYTE "Message"
ENDM
```

**사용 예시**

```asm
mCreateMessage 1
```

**설명**

`&` 기호는 매크로 매개변수와 주변 문자를 연결하는 데 사용한다.

위 예시에서는 매개변수 `number`가 식별자에 연결되어 `msg1`이라는 이름을 생성하는 형태로 확장된다.

### 16. mLocate 매크로를 분석하시오.

**매크로**

```asm
mLocate MACRO xval, yval
    IF xval LT 0
        EXITM
    ENDIF

    IF yval LT 0
        EXITM
    ENDIF

    mov bx, 0
    mov ah, 2
    mov dh, yval
    mov dl, xval
    int 10h
ENDM
```

**a.**

```asm
mLocate -2, 20
```

**결과**

```asm
; 생성되는 실행 명령어 없음
```

**설명**

X 좌표가 -2이므로 첫 번째 조건인 `xval LT 0`이 참이다.

따라서 `EXITM`을 실행하고 매크로 확장을 종료한다.

**b.**

```asm
mLocate 10, 20
```

**결과**

```asm
mov bx, 0
mov ah, 2
mov dh, 20
mov dl, 10
int 10h
```

**설명**

X 좌표와 Y 좌표가 모두 0 이상이므로 조건을 통과한다.

- `DH = 20`: Y 좌표
- `DL = 10`: X 좌표
- `INT 10h`: BIOS 비디오 서비스를 호출한다.

**c.**

```asm
.data
col BYTE 60
row BYTE 40

.code
mLocate col, row
```

**설명**

`col`과 `row`는 메모리 변수이므로 숫자 상수처럼 조건부 어셈블리의 `IF`에서 비교할 수 없다.

`IF` 조건식에는 어셈블리 시간에 계산할 수 있는 상수 표현식이 필요하다.

따라서 위 호출은 매크로의 조건 검사 단계에서 상수 표현식 관련 오류가 발생할 수 있다.

---

# 10.8 프로그래밍 연습 문제

## 1. 키보드 입력을 받아 ASCII 코드와 스캔 코드를 저장하는 mReadkey 매크로를 작성하시오.

**정답**

```asm
mReadkey MACRO asciiCode, scanCode
    call ReadChar
    mov asciiCode, al
    mov scanCode, ah
ENDM
```

**사용 예시**

```asm
.data
ascii BYTE ?
scan BYTE ?

.code
mReadkey ascii, scan
```

**설명**

- `ReadChar`는 키보드에서 문자 하나를 입력받는다.
- AL에는 ASCII 코드가 저장된다.
- AH에는 스캔 코드가 저장된다.
- 입력된 두 값을 각각 지정한 변수에 저장한다.

※ 교재에서 사용하는 Irvine32 라이브러리의 `ReadChar` 반환 규약을 기준으로 한다.

## 2. 지정한 색상으로 문자열을 출력하는 mWriteStringAttr 매크로를 작성하시오.

**정답**

```asm
mWriteStringAttr MACRO color, stringName
    push eax
    push edx

    mov eax, color
    call SetTextColor

    mov edx, OFFSET stringName
    call WriteString

    pop edx
    pop eax
ENDM
```

**사용 예시**

```asm
.data
message BYTE "Hello World", 0

.code
mWriteStringAttr red, message
```

**설명**

- `SetTextColor`는 출력 글자의 색상을 변경한다.
- EAX에 전달된 색상 값을 사용한다.
- `WriteString`은 EDX가 가리키는 문자열을 출력한다.
- `push`, `pop`을 사용하여 EAX와 EDX의 기존 값을 보존한다.

## 3. 두 개의 32비트 메모리 데이터를 이동시키는 mMove32 매크로를 작성하시오.

**정답**

```asm
mMove32 MACRO destination, source
    mov eax, source
    mov destination, eax
ENDM
```

**사용 예시**

```asm
.data
num1 DWORD 100
num2 DWORD ?

.code
mMove32 num2, num1
```

**설명**

1. `source`에 저장된 값을 EAX로 이동한다.
2. EAX의 값을 `destination`에 저장한다.
3. 결과적으로 `num1`의 값이 `num2`에 복사된다.

## 4. 두 개의 32비트 값을 곱하는 mMult32 매크로를 작성하시오.

**정답**

```asm
mMult32 MACRO destination, source1, source2
    mov eax, source1
    imul eax, source2
    mov destination, eax
ENDM
```

**사용 예시**

```asm
.data
num1 SDWORD 10
num2 SDWORD 20
result SDWORD ?

.code
mMult32 result, num1, num2
```

**설명**

- `source1`을 EAX에 저장한다.
- `imul`을 사용하여 EAX와 `source2`를 곱한다.
- 계산 결과를 `destination`에 저장한다.

결과는 32비트로 저장되므로 표현 범위를 초과하는 값은 상위 비트가 손실될 수 있다.

## 5. 16비트 또는 32비트 정수를 입력받는 mReadInt 매크로를 작성하시오.

**정답**

```asm
mReadInt MACRO variable
    call ReadInt

    IF SIZEOF variable EQ 2
        mov variable, ax
    ELSEIF SIZEOF variable EQ 4
        mov variable, eax
    ENDIF
ENDM
```

**사용 예시**

```asm
.data
num16 SWORD ?
num32 SDWORD ?

.code
mReadInt num16
mReadInt num32
```

**설명**

- `ReadInt`는 입력받은 정수를 EAX에 반환한다.
- `SIZEOF`는 변수의 크기를 바이트 단위로 확인한다.
- 2바이트 변수에는 AX를 저장한다.
- 4바이트 변수에는 EAX를 저장한다.

※ 16비트 변수에 저장하는 경우 입력값은 부호 있는 16비트 정수 범위에 포함되어야 한다.

## 6. 8비트, 16비트 또는 32비트 정수를 출력하는 mWriteInt 매크로를 작성하시오.

**정답**

```asm
mWriteInt MACRO variable
    IF SIZEOF variable EQ 1
        movsx eax, variable
    ELSEIF SIZEOF variable EQ 2
        movsx eax, variable
    ELSEIF SIZEOF variable EQ 4
        mov eax, variable
    ENDIF

    call WriteInt
ENDM
```

**사용 예시**

```asm
.data
num8 SBYTE -10
num16 SWORD -100
num32 SDWORD -1000

.code
mWriteInt num8
mWriteInt num16
mWriteInt num32
```

**설명**

`WriteInt`는 EAX에 저장된 부호 있는 32비트 정수를 출력한다.

- 8비트 변수는 `MOVSX`를 이용하여 32비트로 부호 확장한다.
- 16비트 변수도 `MOVSX`를 이용하여 32비트로 부호 확장한다.
- 32비트 변수는 EAX에 직접 저장한다.

## 7. Professor's Lost Phone

**문제 설명**

DrunkardWalk 프로그램을 수정하여 술에 취한 사람이 이동하는 도중 휴대전화를 떨어뜨리도록 한다.

휴대전화를 떨어뜨리는 시점과 위치는 무작위로 결정한다.

**알고리즘**

1. 난수 생성기를 초기화한다.
2. 휴대전화를 떨어뜨릴 이동 횟수를 무작위로 결정한다.
3. 술에 취한 사람의 이동을 시작한다.
4. 이동할 때마다 이동 횟수를 증가시킨다.
5. 현재 이동 횟수가 휴대전화를 떨어뜨리는 시점과 같으면 현재 위치를 휴대전화 위치로 저장한다.
6. 휴대전화가 떨어진 위치를 표시한다.

**핵심 코드 예시**

```asm
.data
phoneDropStep DWORD ?
stepCount DWORD 0

phoneX DWORD ?
phoneY DWORD ?

.code
call Randomize

; 휴대전화를 떨어뜨릴 시점 결정
mov eax, 100
call RandomRange
inc eax
mov phoneDropStep, eax
```

이후 기존 DrunkardWalk의 이동 루프 안에 다음 코드를 추가한다.

```asm
inc stepCount

mov eax, stepCount
cmp eax, phoneDropStep
jne ContinueWalk

; 현재 위치를 휴대전화 위치로 저장
mov eax, currentX
mov phoneX, eax

mov eax, currentY
mov phoneY, eax

ContinueWalk:
```

**설명**

`RandomRange`를 이용하여 휴대전화를 떨어뜨릴 이동 횟수를 무작위로 결정한다.

이동 루프에서 현재 이동 횟수와 지정된 횟수를 비교하고, 일치하면 현재 좌표를 휴대전화 위치로 저장한다.

※ `currentX`, `currentY`는 기존 DrunkardWalk 프로그램의 실제 위치 변수명에 맞게 수정해야 한다. 위 코드는 기존 이동 프로그램에 삽입하는 핵심 코드 예시이다.

## 8. Drunkard's Walk with Probabilities

**문제 설명**

DrunkardWalk 프로그램을 수정하여 이동 방향을 확률적으로 결정한다.

**이동 확률**

| 이동 방향 | 확률 |
|---|---:|
| 현재 방향 유지 | 50% |
| 반대 방향 | 10% |
| 오른쪽 방향 | 20% |
| 왼쪽 방향 | 20% |

**정답 예시**

```asm
.data
direction DWORD 0

.code
; 0~3 중 초기 방향 선택
mov eax, 4
call RandomRange
mov direction, eax

; 이동 방향을 확률적으로 변경
mov eax, 100
call RandomRange

cmp eax, 50
jb KeepDirection

cmp eax, 60
jb ReverseDirection

cmp eax, 80
jb TurnRight

; 왼쪽 방향
dec direction
and direction, 3
jmp ContinueWalk

KeepDirection:
jmp ContinueWalk

ReverseDirection:
add direction, 2
and direction, 3
jmp ContinueWalk

TurnRight:
inc direction
and direction, 3

ContinueWalk:
```

**설명**

`RandomRange 100`을 이용하여 0~99 사이의 난수를 생성한다.

- 0~49: 현재 방향 유지
- 50~59: 반대 방향
- 60~79: 오른쪽 방향
- 80~99: 왼쪽 방향

방향을 0~3으로 표현하고 `AND 3`을 사용하여 방향 값이 0~3 범위를 유지하도록 한다.

※ 위 코드는 방향 선택 로직이다. 실제 이동 명령은 기존 DrunkardWalk 프로그램의 방향 표현 방식과 이동 코드에 연결해야 한다.

## 9. mShiftDoublewords 매크로를 작성하시오.

**문제 설명**

32비트 정수 배열 전체를 왼쪽 또는 오른쪽으로 지정한 비트 수만큼 이동시키는 매크로를 작성한다.

**정답 예시**

```asm
mShiftDoublewords MACRO arrayName, bitCount, direction
    LOCAL LeftLoop, RightLoop, EndShift

    push eax
    push ebx
    push ecx
    push esi

    mov cl, bitCount

    IF direction EQ 'L'

        ; 가장 높은 DWORD부터 왼쪽으로 이동
        mov esi, (LENGTHOF arrayName - 1) * 4

    LeftLoop:
        cmp esi, 0
        je EndShift

        mov eax, arrayName[esi]
        mov ebx, arrayName[esi-4]

        shld eax, ebx, cl
        mov arrayName[esi], eax

        sub esi, 4
        jmp LeftLoop

    EndShift:
        shl arrayName[0], cl

    ELSE

        ; 가장 낮은 DWORD부터 오른쪽으로 이동
        mov esi, 0

    RightLoop:
        cmp esi, (LENGTHOF arrayName - 1) * 4
        jae EndShiftRight

        mov eax, arrayName[esi]
        mov ebx, arrayName[esi+4]

        shrd eax, ebx, cl
        mov arrayName[esi], eax

        add esi, 4
        jmp RightLoop

    EndShiftRight:
        shr arrayName[esi], cl

    ENDIF

    pop esi
    pop ecx
    pop ebx
    pop eax
ENDM
```

**설명**

배열을 하나의 큰 정수처럼 취급하기 위해 각 DWORD 사이의 비트를 연결하여 이동한다.

- `SHLD`: 왼쪽 이동 시 인접한 낮은 DWORD의 비트를 높은 DWORD로 전달한다.
- `SHRD`: 오른쪽 이동 시 인접한 높은 DWORD의 비트를 낮은 DWORD로 전달한다.
- `SHL`: 가장 낮은 DWORD의 남은 비트를 왼쪽으로 이동한다.
- `SHR`: 가장 높은 DWORD의 남은 비트를 오른쪽으로 이동한다.

배열의 가장 낮은 DWORD가 인덱스 0에 저장된다고 가정한다.

※ 이 코드는 32비트 배열과 1~31 사이의 이동 비트 수를 가정한 예시이다. 실제 교재의 매크로 매개변수 규칙 및 MASM 버전에 맞춰 확인이 필요하다.

## 10. Three-Operand Instructions

**문제 설명**

세 개의 매개변수를 사용하는 다음 매크로를 작성한다.

- `add3`: 두 값을 더한다.
- `sub3`: 첫 번째 값에서 두 번째 값을 뺀다.
- `mul3`: 두 값을 곱한다.
- `div3`: 첫 번째 값을 두 번째 값으로 나눈다.

모든 매개변수는 부호 있는 32비트 메모리 변수로 가정한다.

### 1) add3 매크로

```asm
add3 MACRO destination, source1, source2
    mov eax, source1
    add eax, source2
    mov destination, eax
ENDM
```

### 2) sub3 매크로

```asm
sub3 MACRO destination, source1, source2
    mov eax, source1
    sub eax, source2
    mov destination, eax
ENDM
```

### 3) mul3 매크로

```asm
mul3 MACRO destination, source1, source2
    mov eax, source1
    imul eax, source2
    mov destination, eax
ENDM
```

### 4) div3 매크로

```asm
div3 MACRO destination, source1, source2
    push edx

    mov eax, source1
    cdq
    idiv source2

    mov destination, eax

    pop edx
ENDM
```

**사용 예시**

```asm
.data
a SDWORD 20
b SDWORD 10
c SDWORD 5
d SDWORD 2

result1 SDWORD ?
result2 SDWORD ?
result3 SDWORD ?
result4 SDWORD ?

.code

; (a + b) * c
add3 result1, a, b
mul3 result1, result1, c

; (a - b) * c
sub3 result2, a, b
mul3 result2, result2, c

; (a * b) / c
mul3 result3, a, b
div3 result3, result3, c

; (a + b) / d
add3 result4, a, b
div3 result4, result4, d
```

**계산 결과**

| 계산식 | 계산 과정 | 결과 |
|---|---|---:|
| (a + b) × c | (20 + 10) × 5 | 150 |
| (a - b) × c | (20 - 10) × 5 | 50 |
| (a × b) ÷ c | (20 × 10) ÷ 5 | 40 |
| (a + b) ÷ d | (20 + 10) ÷ 2 | 15 |

**설명**

- `add3`는 두 정수를 더한 결과를 저장한다.
- `sub3`는 첫 번째 정수에서 두 번째 정수를 뺀 결과를 저장한다.
- `mul3`는 `IMUL`을 사용하여 부호 있는 정수를 곱한다.
- `div3`는 `CDQ`로 EAX의 부호를 EDX에 확장한 뒤 `IDIV`를 사용하여 부호 있는 나눗셈을 수행한다.
- `IDIV`의 몫은 EAX에 저장되므로 EAX의 값을 목적지 변수에 저장한다.

※ 나눗셈을 수행할 때 제수가 0이면 안 되며, 계산 결과가 32비트 범위를 초과하지 않도록 주의해야 한다.

---

# 마무리

이번 장에서는 MASM 어셈블리 언어의 구조체와 매크로 사용 방법을 학습하였다.

주요 학습 내용은 다음과 같다.

1. `STRUCT`를 이용한 구조체 정의와 데이터 관리
2. 구조체 변수 선언 및 필드 접근
3. `MACRO`를 이용한 반복 명령어의 재사용
4. `LOCAL`을 이용한 매크로 내부 레이블 관리
5. `IF`, `ELSE`, `ENDIF`를 이용한 조건부 어셈블리
6. `RandomRange`를 이용한 난수 생성
7. `SHLD`, `SHRD`를 이용한 다중 DWORD 비트 이동
8. 여러 매개변수를 사용하는 산술 연산 매크로 작성

구조체는 관련 데이터를 효율적으로 관리할 수 있게 해주며, 매크로는 반복되는 명령어를 재사용하여 프로그램의 가독성과 유지보수성을 높여준다.
