%include "st_io.inc"

global _start

section .bss
a resb 100

section .data
digitL equ 0x30
digitH equ 0x39

letterL equ 0x41
letterH equ 0x5A

const equ 0x20
excl equ 0x8A

qchar equ 0x21 ;quitting char
section .text
_start:

;getting the text
get:

GETCHAR
cmp al, qchar
je getskip
mov byte[a+esi], al
inc esi ;esi-counter
jmp get

getskip:

;printin the text

print1:
mov edx, excl
cmp [a+edi], edx
je pskip1

PUTCHAR [a+edi]

pskip1:
inc edi
cmp edi,esi
jbe print1

;check the first symbol
mov edx, digitL
cmp [a], edx
jb no
mov edx, digitH
cmp [a], edx
ja no

;check the last symbol
mov edx, digitL
cmp [a+esi-1], edx
jb no ; <
mov edx, digitH
cmp [a+esi-1], edx
ja no ; >

; check equality
mov edx, [a]
cmp [a+esi-1], edx
je no

;yes rule
yes:
mov edi, 0
;edi-temp cycle counter
mov edx, letterL
cmp [a+edi], edx
jb skip1
mov edx, letterH
cmp [a+edi], edx
ja skip1

mov dh, 0d32
add byte[a+edi], dh

skip1:
inc edi
cmp edi,esi
jbe yes

;no rule
no:
mov cl,1
mov ah, byte[a]
no1:
;cl-temp cycle counter
cmp [a+edi], ah
jne skip

;deleting
mov edx, excl
mov [a+edi], edx

skip:
inc edi
cmp edi, esi
jbe no1

;printin the text
mov edi,0
print:
mov edx, excl
cmp [a+edi], edx
je pskip

PUTCHAR [a+edi]

pskip:
inc edi
cmp edi,esi
jbe print

FINISH
