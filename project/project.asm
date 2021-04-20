%include "st_io.inc"

global _start

section .bss
a resb 100

section .data
digitL equ 0x30
digitH equ 0x39

letterL equ 0x61
letterH equ 0x7A

const equ 0x20
excl equ 0x8A

qchar equ 0x00 ;quitting char
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

;check the first symbol
mov edx, digitL
cmp [a], edx
jb no
mov edx, digitH
cmp [a], edx
ja no

;check the last symbol
mov edx, digitL
cmp [a+esi], edx
jb skip ; <
mov edx, digitH
cmp [a+esi], edx
ja skip ; >

;yes rule
yes:
;edi-temp cycle counter
mov edx, letterL
cmp [a+edi], edx
jb skip1
mov edx, letterH
cmp [a+edi], edx
ja skip1

sub byte[a+edi], const

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
jne pskip

PUTCHAR [a+edi]

pskip:
inc edi
cmp edi,esi
jbe print

FINISH
