# Review Questions 답안

Chapter 2에서 배운 CPU 구조, 레지스터, 프로세서 동작 모드, 메모리, 입출력 시스템에 대한 내용을 다시 확인하기 위해 Review Questions를 정리하였다.

이번 문제를 풀면서 단순히 정답만 외우기보다는 각각의 개념이 실제 프로세서에서 어떤 역할을 하는지 이해하는 것을 중심으로 정리하였다.

1. In 32-bit mode, aside from the stack pointer (ESP), what other register points to variables on the stack?

---

32비트 모드에서 스택 포인터(ESP) 외에 스택에 있는 변수를 가리키는 레지스터는 무엇인가?

답

EBP (Extended Base Pointer, 확장 베이스 포인터)

풀이

스택을 사용할 때 ESP는 현재 스택의 가장 위쪽 위치를 가리키는 역할을 한다.

하지만 함수가 실행되면서 PUSH나 POP 등의 명령이 사용되면 ESP의 위치가 계속 변할 수 있다. 그래서 함수 내부에서 매개변수나 지역 변수의 위치를 일정하게 참조하기 위해 EBP를 사용할 수 있다.

스택의 구조를 간단하게 나타내면 다음과 같다.

```text
높은 주소
┌─────────────────┐
│ 함수의 매개변수  │
├─────────────────┤
│ 반환 주소        │
├─────────────────┤
│ 이전 EBP        │ ← EBP 기준으로 접근
├─────────────────┤
│ 지역 변수        │
├─────────────────┤
│ 현재 스택 위치   │ ← ESP
└─────────────────┘
낮은 주소
```

따라서 ESP가 현재 스택 위치를 나타내는 데 사용된다면 EBP는 스택 프레임 안의 변수나 매개변수를 접근할 때 기준점으로 사용할 수 있다.

회고

ESP와 EBP가 둘 다 스택과 관련된 레지스터라 처음에는 비슷하게 느껴졌다. 하지만 ESP는 계속 움직일 수 있고 EBP는 함수 내부의 기준점으로 사용할 수 있다는 차이를 알게 되었다.

2. Name at least four CPU status flags.

---

CPU 상태 플래그를 최소 4개 이상 말하시오.

답

Carry Flag (CF)

Overflow Flag (OF)

Sign Flag (SF)

Zero Flag (ZF)

풀이

CPU의 상태 플래그는 연산 결과에 대한 정보를 저장한다. 대표적인 플래그를 정리하면 다음과 같다.

| 플래그 | 의미                           |
| --- | ---------------------------- |
| CF  | 부호 없는 연산에서 자리올림 또는 빌림 발생     |
| OF  | 부호 있는 연산에서 표현 범위를 벗어남        |
| SF  | 연산 결과가 음수임을 나타냄              |
| ZF  | 연산 결과가 0임을 나타냄               |
| AF  | 비트 3에서 비트 4로 자리올림 발생         |
| PF  | 결과의 하위 바이트에서 1의 개수가 짝수인지 나타냄 |

특히 CF와 OF는 둘 다 오버플로와 관련되어 보이지만 사용하는 기준이 다르다.

```text
부호 없는 연산
      ↓
범위를 넘었는가?
      ↓
     CF

부호 있는 연산
      ↓
표현 가능한 범위를 넘었는가?
      ↓
     OF
```

회고

플래그는 단순히 이름만 외우려고 하면 헷갈리기 쉬웠다. 특히 CF와 OF가 어떤 상황에서 사용되는지를 구분해서 보는 것이 중요하다고 느꼈다.

3. Which flag is set when the result of an unsigned arithmetic operation is too large to fit into the destination?

---

부호 없는 산술 연산의 결과가 너무 커서 목적지에 담기지 못할 때 설정되는 플래그는 무엇인가?

답

Carry Flag (CF)

풀이

CF는 부호 없는 정수 연산에서 결과가 해당 비트 수로 표현할 수 있는 범위를 넘어갔을 때 사용된다.

예를 들어 8비트에서 다음과 같은 연산을 생각할 수 있다.

```text
11111111
+00000001
---------
1 00000000
```

8비트 레지스터에는 아래의 00000000만 저장되고 맨 앞의 1은 저장할 수 없다.

이때 발생한 자리올림을 CF가 나타낸다.

따라서 부호 없는 연산에서 결과가 너무 커서 저장 공간을 넘어가면 Carry Flag를 확인할 수 있다.

회고

2진수 계산을 직접 적어보니 CF의 역할이 훨씬 이해하기 쉬웠다. 단순히 "캐리가 발생하면 CF"라고 외우는 것보다 실제 계산 결과를 보는 게 기억하기 좋았다.

4. Which flag is set when the result of a signed arithmetic operation is either too large or too small to fit into the destination?

---

부호 있는 산술 연산의 결과가 너무 크거나 너무 작아서 목적지에 담기지 못할 때 설정되는 플래그는 무엇인가?

답

Overflow Flag (OF)

풀이

OF는 부호 있는 정수 연산에서 결과가 표현 가능한 범위를 벗어났을 때 사용한다.

예를 들어 8비트 signed 정수의 표현 범위는 다음과 같다.

```text
-128 ───────────────────── +127
```

이 범위를 넘어서는 결과가 나오면 실제 비트 패턴으로는 결과를 올바르게 표현할 수 없기 때문에 Overflow가 발생한다.

CF와 OF를 비교하면 다음과 같다.

| 플래그 | 기준       |
| --- | -------- |
| CF  | 부호 없는 연산 |
| OF  | 부호 있는 연산 |

따라서 문제에서 signed arithmetic operation이라고 명시되어 있으므로 OF가 정답이다.

회고

CF와 OF를 같이 공부하면서 두 플래그를 구분하는 기준이 부호 여부라는 것을 확실하게 알게 되었다.

5. (True/False): When a register operand size is 32 bits and the REX prefix is used, the R8D register is available for programs to use.

---

레지스터 오퍼랜드 크기가 32비트이고 REX 접두사를 사용하면 프로그램에서 R8D 레지스터를 사용할 수 있다.

답

True

풀이

x86-64에서는 기존 x86 레지스터에 R8부터 R15까지 추가적인 범용 레지스터가 제공된다.

각 64비트 레지스터에는 하위 32비트에 접근하는 이름도 존재한다.

```text
R8
│
└── R8D  ← 하위 32비트

R9
│
└── R9D  ← 하위 32비트

...

R15
│
└── R15D ← 하위 32비트
```

따라서 32비트 레지스터 오퍼랜드를 사용하면서 REX 접두사를 통해 확장 레지스터를 지정하면 R8D를 사용할 수 있다.

회고

R8이라는 이름만 보면 64비트 레지스터라고 생각하기 쉬웠는데 R8D처럼 하위 비트에 접근하는 이름이 따로 있다는 점을 알게 되었다.

6. Which flag is set when an arithmetic or logical operation generates a negative result?

---

산술 연산이나 논리 연산이 음수 결과를 만들 때 설정되는 플래그는 무엇인가?

답

Sign Flag (SF)

풀이

SF는 연산 결과의 부호를 나타내는 플래그이다.

2의 보수 표현을 사용하는 signed 정수에서는 최상위 비트가 부호를 나타내는 데 사용된다.

```text
양수
0xxxxxxx

음수
1xxxxxxx
```

결과의 최상위 비트가 1이면 음수 결과를 나타내므로 SF가 설정된다.

따라서 연산 결과가 음수인지 확인하려면 Sign Flag를 확인한다.

회고

SF는 다른 플래그보다 직관적으로 이해할 수 있었다. 결과의 부호와 최상위 비트가 연결된다는 점을 같이 기억하면 좋을 것 같다.

7. Which part of the CPU performs floating-point arithmetic?

---

CPU의 어느 부분이 부동소수점 연산을 수행하는가?

답

FPU (Floating-Point Unit)

풀이

FPU는 Floating-Point Unit의 약자로 부동소수점 연산을 담당하는 장치이다.

정수 연산과 부동소수점 연산은 표현 방식과 처리 방식이 다르기 때문에 CPU에서는 부동소수점 계산을 위한 별도의 연산 기능을 제공한다.

```text
CPU
│
├── Control Unit
│
├── ALU
│    └── 정수 중심의 산술 및 논리 연산
│
└── FPU
     └── 부동소수점 연산
```

따라서 문제에서 floating-point arithmetic을 수행하는 CPU의 부분을 묻고 있으므로 FPU가 정답이다.

회고

ALU와 FPU의 역할이 비슷하게 느껴졌는데, 정수 연산과 부동소수점 연산을 구분해서 생각하니 차이가 명확해졌다.

8. On a 32-bit processor, how many bits are contained in each floating-point data register?

---

32비트 프로세서에서 각 부동소수점 데이터 레지스터는 몇 비트로 구성되는가?

답

80비트

풀이

교재에서는 x86 계열의 부동소수점 레지스터와 관련하여 x87 부동소수점 환경을 설명하고 있으며, 각 floating-point data register는 80비트 값을 저장할 수 있는 것으로 다룬다.

따라서 프로세서가 32비트라고 해서 부동소수점 레지스터 역시 32비트라고 생각하면 안 된다.

```text
일반적인 32비트 환경
        │
        ├── 일반 레지스터 → 32비트
        │
        └── x87 FP 레지스터 → 80비트
```

레지스터의 비트 수는 어떤 종류의 레지스터인지에 따라 달라질 수 있다.

회고

처음에는 32비트 프로세서이므로 모든 레지스터가 32비트일 것이라고 생각했는데, 레지스터 종류에 따라 크기가 다를 수 있다는 것을 알게 되었다.

9. (True/False): The x86-64 instruction set is backward-compatible with the x86 instruction set.

---

x86-64 명령어 집합은 x86 명령어 집합과 하위 호환된다.

답

True

풀이

x86-64는 기존 x86 명령어 집합을 기반으로 64비트 기능을 확장한 구조이다.

따라서 기존 x86에서 사용하던 명령어와 레지스터 구조를 어느 정도 유지하면서 64비트 연산과 확장된 레지스터 등을 사용할 수 있다.

구조를 간단하게 보면 다음과 같다.

```text
기존 x86
   │
   └── 기존 명령어 집합
          │
          ↓
       x86-64
          │
          ├── 기존 x86 기능
          └── 64비트 확장 기능
```

이러한 특성 때문에 기존 x86 소프트웨어와의 호환성을 고려할 수 있다.

회고

64비트가 완전히 새로운 구조라고 생각했는데 기존 x86을 확장한 형태라는 점이 중요하다는 것을 알게 되었다.

10. (True/False): In current 64-bit chip implementations, all 64 bits are used for addressing.

---

현재의 64비트 칩 구현에서는 64비트 전체가 주소 지정에 사용된다.

답

False

풀이

64비트 프로세서라고 해서 실제 주소를 표현하는 데 항상 64비트 전체를 사용하는 것은 아니다.

교재에서는 현재의 64비트 프로세서 구현에서 주소 공간의 일부 비트만 사용하는 사례를 설명한다.

따라서 다음과 같이 생각할 수 있다.

```text
64-bit address representation
┌───────────────────────────────┐
│       사용 가능한 주소 비트     │
├───────────────────────────────┤
│   구현에서 사용하지 않는 부분   │
└───────────────────────────────┘
```

즉, 프로세서의 레지스터나 데이터 처리 능력이 64비트라는 것과 실제 하드웨어가 주소 지정에 사용하는 비트 수는 동일한 개념이 아니다.

회고

64비트라는 숫자를 보고 주소도 당연히 64비트 전체를 사용하는 줄 알았다. 데이터 크기와 주소 공간을 따로 생각해야 한다는 점을 알게 되었다.

11. (True/False): The Itanium instruction set is completely different from the x86 instruction set.

---

아이테니엄(Itanium) 명령어 집합은 x86 명령어 집합과 완전히 다르다.

답

True

풀이

Itanium은 x86-64와 같은 방식으로 기존 x86 명령어 집합을 확장한 프로세서가 아니다.

Itanium 계열은 별도의 명령어 집합 구조를 사용했기 때문에 x86 명령어 집합과는 구조적으로 큰 차이가 있다.

이를 비교하면 다음과 같다.

```text
x86
 │
 ├── 16비트
 ├── 32비트
 └── x86-64 확장

Itanium
 │
 └── 별도의 명령어 집합 구조
```

따라서 x86과 Itanium의 명령어 집합은 같은 계열로 볼 수 없다.

회고

x86-64와 Itanium을 모두 64비트 프로세서라고 생각하면 비슷할 것 같았지만, 비트 수와 명령어 집합 구조는 별개의 문제라는 것을 알게 되었다.

12. (True/False): Static RAM is usually less expensive than dynamic RAM.

---

정적 RAM(SRAM)은 보통 동적 RAM(DRAM)보다 저렴하다.

답

False

풀이

SRAM과 DRAM은 모두 메모리이지만 내부적인 저장 방식이 다르다.

| 구분      | SRAM       | DRAM        |
| ------- | ---------- | ----------- |
| 이름      | Static RAM | Dynamic RAM |
| 저장 방식   | 플립플롭 기반    | 커패시터 기반     |
| 리프레시    | 필요하지 않음    | 필요함         |
| 일반적인 비용 | 높음         | 낮음          |
| 일반적인 용도 | 캐시 메모리     | 주기억장치       |

SRAM은 빠르고 리프레시가 필요하지 않지만 회로 구성이 복잡하기 때문에 일반적으로 DRAM보다 비싸다.

따라서 "SRAM이 DRAM보다 저렴하다"는 문장은 틀렸다.

회고

SRAM과 DRAM의 차이를 단순히 속도 차이로만 생각했는데 가격과 용도까지 연결해서 보니 왜 서로 다른 메모리를 사용하는지 이해하기 쉬웠다.

13. (True/False): The 64-bit RDI register is available when the REX prefix is used.

---

REX 접두사를 사용하면 64비트 RDI 레지스터를 사용할 수 있다.

답

True

풀이

RDI는 x86-64 환경에서 사용할 수 있는 64비트 범용 레지스터 중 하나이다.

REX prefix는 x86 명령어를 64비트 환경에서 확장하는 역할을 한다.

기존 x86 레지스터 구조에 64비트 레지스터와 추가 레지스터를 사용할 수 있도록 확장되었다.

```text
x86
 │
 └── 기존 범용 레지스터

       ↓ REX prefix를 통한 확장

x86-64
 │
 ├── 64비트 레지스터
 └── R8 ~ R15 등의 확장 레지스터
```

따라서 REX prefix가 사용되는 64비트 환경에서 RDI를 사용할 수 있다.

회고

REX prefix가 단순히 새로운 명령어를 추가하는 기능이 아니라 64비트 레지스터 사용과도 관련 있다는 것을 알게 되었다.

14. (True/False): In native 64-bit mode, you can use 16-bit real mode, but not the virtual-8086 mode.

---

네이티브 64비트 모드에서는 16비트 리얼 모드는 사용할 수 있지만 가상 8086 모드는 사용할 수 없다.

답

False

풀이

문장에서 두 가지 모드를 구분해서 볼 필요가 있다.

Real-Address Mode는 16비트 환경에서 사용되는 실행 모드이고, Virtual-8086 Mode는 보호 모드에서 8086 프로그램을 실행하기 위한 방식이다.

네이티브 64비트 모드에서는 이러한 16비트 실행 모드를 그대로 사용할 수 없다.

```text
Native 64-bit Mode
        │
        ├── 16-bit Real Mode       X
        │
        └── Virtual-8086 Mode      X
```

따라서 "리얼 모드는 사용할 수 있지만 Virtual-8086 Mode는 사용할 수 없다"라는 문장은 전체적으로 틀렸기 때문에 False이다.

회고

Real Mode와 Virtual-8086 Mode가 모두 8086 계열과 관련되어 있어서 헷갈렸다. 각각이 어떤 실행 환경에서 사용되는지 구분해서 외우는 것이 좋을 것 같다.

15. (True/False): The x86-64 processors have 4 more general-purpose registers than the x86 processors.

---

x86-64 프로세서는 x86 프로세서보다 범용 레지스터가 4개 더 많다.

답

False

풀이

x86-64에서는 기존 범용 레지스터에 더해 R8부터 R15까지 추가 범용 레지스터를 제공한다.

```text
추가된 범용 레지스터

R8
R9
R10
R11
R12
R13
R14
R15

총 8개
```

따라서 4개가 아니라 8개의 추가 범용 레지스터가 존재한다.

문제의 핵심은 "4개"라는 숫자가 틀렸다는 것이다.

회고

R8부터 R15까지 직접 세어보면 8개라는 것을 쉽게 확인할 수 있었다. 숫자를 기억할 때 범위를 함께 외우는 게 더 편할 것 같다.

16. (True/False): The 64-bit version of Microsoft Windows does not support virtual-8086 mode.

---

64비트 버전의 Microsoft Windows는 Virtual-8086 Mode를 지원하지 않는다.

답

True

풀이

Virtual-8086 Mode는 보호 모드 환경에서 8086 프로그램을 실행하기 위해 사용되던 방식이다.

하지만 x86-64의 네이티브 64비트 환경에서는 Virtual-8086 Mode를 사용할 수 없다.

따라서 64비트 버전의 Microsoft Windows에서는 Virtual-8086 Mode를 지원하지 않는다는 설명이 맞다.

```text
64-bit Windows
      │
      └── Native 64-bit execution
               │
               └── Virtual-8086 Mode 지원하지 않음
```

회고

14번 문제와 연결해서 공부하니 이해하기 쉬웠다. 운영체제가 64비트라는 사실이 프로세서의 실행 모드와 직접 연결된다는 점을 같이 기억했다.

17. (True/False): DRAM can only be erased using ultraviolet light.

---

DRAM은 자외선을 이용해서만 지울 수 있다.

답

False

풀이

자외선을 이용해서 메모리 내용을 지우는 것은 DRAM이 아니라 EPROM과 관련된 특징이다.

DRAM은 Dynamic RAM으로, 데이터를 저장하기 위해 커패시터를 사용하는 메모리이다. 일정 시간이 지나면 저장된 전하가 감소하기 때문에 주기적으로 refresh가 필요하다.

반면 EPROM은 자외선을 이용하여 저장된 내용을 지울 수 있는 비휘발성 메모리이다.

```text
DRAM
 │
 ├── Dynamic RAM
 ├── refresh 필요
 └── 자외선으로 지우는 메모리 아님

EPROM
 │
 └── 자외선으로 내용 삭제 가능
```

따라서 문제의 설명은 False이다.

회고

DRAM과 EPROM이 모두 메모리 종류라서 처음에는 헷갈렸지만, "자외선으로 지운다"는 특징은 EPROM과 연결해서 기억하면 될 것 같다.

18. (True/False): In 64-bit mode, you can use up to eight floating-point registers.

---

64비트 모드에서는 최대 8개의 부동소수점 레지스터를 사용할 수 있다.

답

True

풀이

x87 floating-point unit에서는 부동소수점 연산을 위한 레지스터 스택을 사용하며 최대 8개의 floating-point data register를 사용할 수 있다.

구조는 다음과 같이 표현할 수 있다.

```text
x87 Floating-Point Registers

ST(0)
ST(1)
ST(2)
ST(3)
ST(4)
ST(5)
ST(6)
ST(7)

총 8개
```

따라서 문제에서 말하는 최대 8개의 floating-point registers를 사용할 수 있다는 설명은 True이다.

회고

일반 범용 레지스터와 부동소수점 레지스터를 같은 종류라고 생각하지 않는 것이 중요했다. 레지스터마다 용도가 다르다는 것을 다시 확인했다.

19. (True/False): A bus is a plastic cable that is attached to the motherboard at both ends, but does not sit directly on the motherboard.

---

버스는 양 끝이 메인보드에 연결된 플라스틱 케이블이며, 메인보드 위에 직접 놓이지는 않는다.

답

False

풀이

컴퓨터에서 버스는 CPU, 메모리, I/O 장치 사이에서 데이터와 신호를 전달하는 통신 경로이다.

교재에서는 버스를 메인보드에 구성된 병렬 배선의 묶음으로 설명한다.

```text
CPU
 │
 │  Bus
 ├──────────────────┐
 │                  │
Memory              I/O
```

따라서 버스를 단순히 메인보드 양 끝에 연결된 플라스틱 케이블이라고 설명하는 것은 맞지 않다.

버스는 데이터, 주소, 제어 신호 등을 전달하는 통신 경로라는 개념으로 이해하는 것이 중요하다.

회고

버스라는 단어 때문에 실제 케이블을 먼저 생각했는데, 컴퓨터 구조에서 말하는 버스는 데이터를 전달하는 통신 경로라는 의미가 더 중요하다는 것을 알게 되었다.

20. (True/False): CMOS RAM is the same as static RAM, meaning that it holds its value without any extra power or refresh cycles.

---

CMOS RAM은 정적 RAM과 같아서 추가 전원이나 리프레시 주기 없이도 값을 유지한다.

답

False

풀이

CMOS RAM은 데이터를 유지할 때 지속적인 전원이 필요하다.

일반적인 시스템에서는 배터리를 이용하여 CMOS RAM에 저장된 설정 정보를 유지할 수 있다.

```text
CMOS RAM
   │
   ├── 시스템 전원 OFF
   │
   └── 배터리 전원
           │
           ↓
       저장 내용 유지
```

따라서 "추가 전원 없이 값을 유지한다"는 문장이 틀렸다.

문제에서 Static RAM이라는 표현이 나오더라도, CMOS RAM이 실제 시스템에서 설정 정보를 유지하기 위해 배터리 전원을 사용하는 부분을 함께 이해해야 한다.

회고

SRAM이라는 단어 때문에 전원이 없어도 내용이 유지될 것이라고 생각하기 쉬웠다. CMOS RAM은 배터리와 연결해서 기억하는 것이 더 확실할 것 같다.

21. (True/False): PCI connectors are used for graphics cards and sound cards.

---

PCI 커넥터는 그래픽 카드와 사운드 카드에 사용된다.

답

True

풀이

PCI는 주변 장치를 컴퓨터 시스템에 연결하기 위한 인터페이스이다.

과거 컴퓨터에서는 그래픽 카드나 사운드 카드와 같은 확장 카드를 PCI 슬롯에 연결하여 사용했다.

```text
Motherboard
      │
      ├── PCI Slot
      │      ├── Graphics Card
      │      └── Sound Card
      │
      └── Other Expansion Devices
```

현재에는 그래픽 카드에서 PCI Express가 주로 사용되지만, 교재의 컴퓨터 구조 설명에서는 PCI 커넥터를 그래픽 카드와 사운드 카드 등의 확장 장치와 연결하는 용도로 설명한다.

따라서 교재의 문맥에서는 True이다.

회고

PCI라는 이름은 알고 있었지만 실제로 어떤 장치를 연결하는지까지는 확실하지 않았다. PCI와 PCI Express를 구분해서 알아둘 필요도 있다고 느꼈다.

22. (True/False): The 8259A is a controller that handles external interrupts from hardware devices.

---

8259A는 하드웨어 장치로부터 오는 외부 인터럽트를 처리하는 컨트롤러이다.

답

True

풀이

8259A는 Programmable Interrupt Controller, 즉 PIC로 사용되는 인터럽트 컨트롤러이다.

하드웨어 장치에서 인터럽트가 발생하면 8259A와 같은 인터럽트 컨트롤러가 해당 인터럽트를 관리하고 CPU가 처리할 수 있도록 전달한다.

```text
Hardware Device
      │
      │ Interrupt Request
      ↓
   8259A PIC
      │
      ↓
     CPU
      │
      ↓
Interrupt Handler
```

따라서 8259A가 하드웨어 장치에서 발생하는 외부 인터럽트를 처리하는 컨트롤러라는 설명은 True이다.

회고

인터럽트가 단순히 CPU 내부에서만 발생하는 것이 아니라 키보드나 다른 하드웨어 장치와도 연결되어 있다는 점을 이해하는 데 도움이 되었다.

23. (True/False): The acronym PCI stands for programmable component interface.

---

PCI는 programmable component interface의 약자이다.

답

False

풀이

PCI의 정확한 의미는 다음과 같다.

Peripheral Component Interconnect

각 단어를 나누면 다음과 같다.

```text
P → Peripheral
C → Component
I → Interconnect
```

따라서 Programmable Component Interface가 아니라 Peripheral Component Interconnect가 정확한 표현이다.

PCI는 컴퓨터 내부에서 주변 장치와 시스템을 연결하기 위한 인터페이스이다.

회고

약어 문제는 단어 하나만 바뀌어도 정답이 달라지기 때문에 정확한 명칭을 확인하는 것이 중요하다고 느꼈다.

24. (True/False): VRAM stands for virtual random access memory.

---

VRAM은 virtual random access memory의 약자이다.

답

False

풀이

VRAM은 Virtual Random Access Memory가 아니라 Video RAM의 약자이다.

```text
VRAM
 │
 └── Video RAM
       │
       └── 그래픽 관련 데이터 저장
```

그래픽 처리에서는 화면에 표시할 이미지나 픽셀 등의 데이터를 저장하기 위한 메모리가 필요하다.

따라서 VRAM의 V는 Virtual이 아니라 Video를 의미한다.

회고

약어를 처음 보면 Virtual이라고 생각하기 쉬웠다. VRAM은 Video RAM이라는 뜻을 그대로 연결해서 기억하면 헷갈리지 않을 것 같다.

25. At which level(s) can an assembly language program manipulate input/output?

---

어셈블리어 프로그램은 어느 수준에서 입출력을 다룰 수 있는가?

답

모든 수준에서 가능하다.

풀이

어셈블리어 프로그램은 높은 수준의 라이브러리부터 직접적인 하드웨어 포트 접근까지 여러 단계에서 입출력을 처리할 수 있다.

교재에서 설명하는 입출력 접근 수준은 다음과 같다.

| Level   | 접근 방법            | 설명                   |
| ------- | ---------------- | -------------------- |
| Level 3 | Library          | 고급 언어 라이브러리 함수 등을 이용 |
| Level 2 | Operating System | 운영체제 함수나 API를 이용     |
| Level 1 | BIOS             | BIOS 서비스 루틴을 이용      |
| Level 0 | Hardware Ports   | 하드웨어 포트에 직접 접근       |

입출력 접근 구조를 아래처럼 생각할 수 있다.

```text
Level 3
Library
   ↓
Level 2
Operating System
   ↓
Level 1
BIOS
   ↓
Level 0
Hardware Ports
```

높은 레벨을 사용할수록 사용하기 편하고 하드웨어에 대한 의존성이 낮아진다.

반대로 낮은 레벨로 내려갈수록 하드웨어를 직접 제어할 수 있지만 특정 하드웨어에 의존할 가능성이 높아진다.

```text
높은 레벨
   │
   ├── 사용하기 쉬움
   ├── 이식성 높음
   └── 하드웨어 제어 ↓

낮은 레벨
   │
   ├── 직접 제어 가능
   ├── 성능 향상 가능
   └── 하드웨어 의존성 ↑
```

따라서 어셈블리어 프로그램은 Level 3부터 Level 0까지 모든 수준에서 입출력을 다룰 수 있다.

회고

입출력에도 여러 단계가 있다는 것이 이번 문제에서 가장 기억에 남았다. 높은 수준의 접근은 편리하고 낮은 수준으로 갈수록 직접적인 제어가 가능하다는 관계를 이해하는 것이 중요했다.

26. Why do game programs often send their sound output directly to the sound card's hardware ports?

---

게임 프로그램은 왜 사운드 출력을 사운드 카드의 하드웨어 포트로 직접 보내는 경우가 많은가?

답

속도와 성능 때문이다.

풀이

입출력은 여러 계층을 통해 처리할 수 있다.

```text
게임 프로그램
      │
      ↓
Operating System
      │
      ↓
BIOS
      │
      ↓
Sound Card
```

운영체제나 BIOS와 같은 중간 계층을 거치면 프로그램이 하드웨어에 직접 접근하지 않아도 된다는 장점이 있다.

하지만 게임과 같이 빠른 반응이 중요한 프로그램에서는 처리 과정에서 발생하는 추가적인 오버헤드를 줄이는 것이 중요할 수 있다.

하드웨어 포트에 직접 접근하면 다음과 같은 구조가 된다.

```text
게임 프로그램
      │
      │ 직접 접근
      ↓
Sound Card Hardware
```

중간 계층을 줄이기 때문에 더 빠르게 하드웨어를 제어할 수 있고, 실시간성이 중요한 상황에서 성능상의 이점을 얻을 수 있다.

다만 직접 하드웨어에 접근하는 방식은 특정 하드웨어에 대한 의존성이 커질 수 있다는 단점도 있다.

따라서 입출력 접근 수준을 선택할 때는 다음과 같은 관계를 생각할 수 있다.

```text
높은 레벨
편리성 ↑
이식성 ↑
직접 제어 ↓
성능상 직접 제어 이점 ↓

        ↕

낮은 레벨
편리성 ↓
이식성 ↓
직접 제어 ↑
하드웨어 제어 성능 ↑
```

게임 프로그램이 사운드 카드의 하드웨어 포트에 직접 접근하는 이유는 빠른 응답과 성능을 얻기 위해서이다.

회고

마지막 문제를 통해 입출력 레벨의 장단점을 한 번에 정리할 수 있었다. 낮은 레벨이 항상 좋은 것이 아니라 성능과 이식성 사이에서 목적에 맞는 방법을 선택해야 한다는 점이 중요하다고 생각했다.

# 과제를 마치고

이번 Review Questions를 풀면서 CPU의 기본 구조부터 레지스터, 플래그, 메모리, 프로세서 동작 모드, 입출력 시스템까지 Chapter 2의 내용을 다시 확인할 수 있었다.

처음에는 각각의 개념이 따로 나뉘어 있는 것처럼 보였지만 문제를 하나씩 풀어보면서 서로 연결되어 있다는 것을 알게 되었다.

특히 CF와 OF처럼 비슷해 보이는 개념도 연산의 기준에 따라 역할이 달라졌고, SRAM과 DRAM도 단순히 이름을 외우는 것보다 저장 방식과 사용 목적을 같이 봐야 이해하기 쉬웠다.

또한 x86-64에서는 기존 x86 구조를 기반으로 레지스터와 기능이 확장되었다는 점, 입출력에서는 높은 수준의 접근과 낮은 수준의 직접적인 하드웨어 접근 사이에 차이가 있다는 점도 다시 정리할 수 있었다.

이번 과제를 통해 문제의 답을 맞히는 것뿐만 아니라 왜 그런 답이 나오는지를 설명할 수 있도록 공부해야 한다는 것을 느꼈다.

