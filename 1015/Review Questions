# Chapter 6. Conditional Processing

## 6.10 Review Questions and Exercises

### 6.10.1 Short Answer

이 문서는 Chapter 6의 Short Answer 문제 1~19번을 정리한 것입니다.

---

### 1. AND 연산 후 BX의 값

```asm
mov bx, 0FFFFh
and bx, 6Bh
```

**Answer:** `006Bh`

AND 연산은 두 비트가 모두 1인 위치만 1로 남깁니다.

### 2. AND 연산 후 BX의 값

```asm
mov bx, 91BAh
and bx, 92h
```

**Answer:** `0092h`

### 3. OR 연산 후 BX의 값

```asm
mov bx, 0649Bh
or bx, 3Ah
```

**Answer:** `64BBh`

OR 연산은 두 비트 중 하나라도 1이면 결과가 1입니다.

### 4. XOR 연산 후 BX의 값

```asm
mov bx, 029D6h
xor bx, 8181h
```

**Answer:** `A857h`

XOR 연산은 두 비트가 서로 다를 때 결과가 1입니다.

### 5. OR 연산 후 EBX의 값

```asm
mov ebx, 0AFAF649Bh
or ebx, 3A219604h
```

**Answer:** `BFAFF69Fh`

### 6. XOR 연산 후 RBX의 값

```asm
mov rbx, 0AFAF649Bh
xor rbx, 0FFFFFFFFh
```

**Answer:** `FFFFFFFF50509B64h`

64비트 레지스터를 대상으로 하는 이 명령어에서는 32비트 즉시값이 부호 확장됩니다.

### 7. AL의 결과를 2진수로 표시

**(a)**

```asm
mov al, 01101111b
and al, 00101101b
```

**Answer:** `00101101b`

**(b)**

```asm
mov al, 6Dh
and al, 4Ah
```

**Answer:** `01001000b`

**(c)**

```asm
mov al, 00001111b
or al, 61h
```

**Answer:** `01101111b`

**(d)**

```asm
mov al, 94h
xor al, 37h
```

**Answer:** `10100011b`

### 8. AL의 결과를 16진수로 표시

**(a)**

```asm
mov al, 7Ah
not al
```

**Answer:** `85h`

**(b)**

```asm
mov al, 3Dh
and al, 74h
```

**Answer:** `34h`

**(c)**

```asm
mov al, 9Bh
or al, 35h
```

**Answer:** `BFh`

**(d)**

```asm
mov al, 72h
xor al, 0DCh
```

**Answer:** `AEh`

### 9. Carry, Zero, Sign 플래그의 값

**(a)**

```asm
mov al, 00001111b
test al, 00000010b
```

**Answer:** `CF = 0, ZF = 0, SF = 0`

**(b)**

```asm
mov al, 00000110b
cmp al, 00000101b
```

**Answer:** `CF = 0, ZF = 0, SF = 0`

**(c)**

```asm
mov al, 00000101b
cmp al, 00000111b
```

**Answer:** `CF = 1, ZF = 0, SF = 1`

### 10. ECX의 값에 따라 분기하는 명령어

**Answer:** `JECXZ`

ECX가 0이면 지정된 레이블로 분기합니다.

### 11. JA와 JNBE의 조건

**Answer:** `CF = 0` 그리고 `ZF = 0`

두 명령어는 부호 없는 비교에서 왼쪽 값이 오른쪽 값보다 클 때 분기합니다.

### 12. EDX의 최종 값

```asm
mov edx, 1
mov eax, 7FFFh
cmp eax, 8000h
jl L1
mov edx, 0
L1:
```

**Answer:** `EDX = 1`

부호 있는 비교에서 `7FFFh`는 양수이고 `8000h`는 음수로 해석됩니다. 따라서 `JL`이 분기합니다.

### 13. EDX의 최종 값

```asm
mov edx, 1
mov eax, 7FFFh
cmp eax, 8000h
jb L1
mov edx, 0
L1:
```

**Answer:** `EDX = 1`

부호 없는 비교에서 `7FFFh`는 `8000h`보다 작으므로 `JB`가 분기합니다.

### 14. EDX의 최종 값

```asm
mov edx, 1
mov eax, 7FFFh
cmp eax, 0FFFF8000h
jl L2
mov edx, 0
L2:
```

**Answer:** `EDX = 0`

부호 있는 비교에서 `7FFFh`는 양수이고 `0FFFF8000h`는 음수입니다. 따라서 `JL`은 분기하지 않습니다.

### 15. 조건 분기 여부

```asm
mov eax, -30
cmp eax, -50
jg Target
```

**Answer:** `True`

부호 있는 비교에서 `-30`은 `-50`보다 크므로 분기합니다.

### 16. 조건 분기 여부

```asm
mov eax, -42
cmp eax, 26
ja Target
```

**Answer:** `True`

`JA`는 부호 없는 비교를 사용합니다. `-42`의 32비트 표현을 부호 없는 정수로 해석하면 `26`보다 크므로 분기합니다.

### 17. AND 연산 후 RBX의 값

```asm
mov rbx, 0FFFFFFFFFFFFFFFFh
and rbx, 80h
```

**Answer:** `0000000000000080h`

### 18. AND 연산 후 RBX의 값

```asm
mov rbx, 0FFFFFFFFFFFFFFFFh
and rbx, 808080h
```

**Answer:** `0000000000808080h`

### 19. AND 연산 후 RBX의 값

```asm
mov rbx, 0FFFFFFFFFFFFFFFFh
and rbx, 80808080h
```

**Answer:** `FFFFFFFF80808080h`

64비트 연산에서 `80808080h`가 32비트 즉시값으로 사용되면 최상위 비트가 1이므로 부호 확장됩니다.

---

**End of 6.10.1 Short Answer**
