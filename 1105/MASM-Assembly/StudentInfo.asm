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
