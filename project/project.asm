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

qchar equ 0 ;quitting char
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


PUTCHAR 0x0A

;check the first symbol
mov dl, digitL
cmp byte[a], dl
jb no

mov dl, digitH
cmp byte[a], dl
ja no

;check the last symbol
mov dl, digitL
dec esi
cmp byte[a+esi], dl
jb no ; <
mov dl, digitH
cmp byte[a+esi], dl
inc esi
ja no ; >

; check equality
mov dl, byte[a]
cmp byte [a+esi-1], dl
je no

mov edi, 0
;yes rule
yes:
;edi-temp cycle counter
mov dl, letterL
cmp byte[a+edi], dl
jb skip1
mov dl, letterH
cmp byte[a+edi], dl
ja skip1

;mov byte[a+edi], 0
add byte[a+edi], 0x20

skip1:
inc edi
cmp edi,esi
jbe yes
jmp jumpspot

;no rule
no:
mov edi,1
mov ah, byte[a]
no1:
;edi-temp cycle counter
cmp byte[a+edi], ah
jne skip

;deleting
mov dh, excl
mov byte[a+edi], dh

skip:
inc edi
cmp edi, esi
jbe no1

jumpspot:
;printin the text
mov edi,0
print:
mov dh, excl
cmp byte[a+edi], dh
je pskip

PUTCHAR [a+edi]

pskip:
inc edi
cmp edi,esi
jbe print

PUTCHAR 0x0A
FINISH
