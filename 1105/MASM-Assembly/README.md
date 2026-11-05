# MASM - 학번과 이름 출력

##  프로젝트 소개

Visual Studio의 MASM(Microsoft Macro Assembler)을 사용하여 화면에 학번과 이름을 출력하는 프로그램입니다.

##  학생 정보

- **학번:** 2023764006
- **이름:** 김도현

##  개발 환경

- Visual Studio
- MASM (Microsoft Macro Assembler)
- Irvine32 Library

##  파일 구성

```text
MASM-Assembly
├── StudentInfo.asm
└── README.md
```

##  소스 코드

```asm
INCLUDE Irvine32.inc

.data
studentID BYTE "2023764006", 0
studentName BYTE "Kim Dohyeon", 0

.code
main PROC
    ; 학번 출력
    mov edx, OFFSET studentID
    call WriteString
    call Crlf

    ; 이름 출력
    mov edx, OFFSET studentName
    call WriteString
    call Crlf

    exit
main ENDP

END main
```

##  실행 결과

```text
2023764006
Kim Dohyeon
```

##  배운 내용

- MASM 프로그램의 기본 구조를 이해했습니다.
- `.data` 영역에서 문자열 데이터를 선언하는 방법을 학습했습니다.
- `OFFSET`을 사용하여 문자열의 메모리 주소를 가져오는 방법을 학습했습니다.
- `WriteString`을 사용하여 문자열을 화면에 출력했습니다.
- `Crlf`를 사용하여 줄바꿈을 처리했습니다.

##  느낀 점

이번 실습을 통해 어셈블리 언어에서도 데이터를 메모리에 저장하고, 메모리 주소를 이용하여 화면에 출력할 수 있다는 것을 배웠습니다. 고급 프로그래밍 언어와는 다른 방식으로 컴퓨터가 데이터를 처리하는 과정을 이해할 수 있었습니다.
