%macro _Push_all_reg 0
	PUSH eax
	PUSH ecx
	PUSH edx
	PUSH ebx
	PUSH ebp
	PUSH esi
	PUSH edi
%endmacro

%macro _Pop_all_reg 0
	POP edi
	POP esi
	POP ebp
	POP ebx
	POP edx
	POP ecx
	POP eax
%endmacro

%macro _PRINT 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .data
    subs db 'ABCA'
    text db 'AAACCCCBCBC'
    len dd $ - text
   
section .text
    global _start
    
procedure:
_Push_all_reg
	pushf
loop_start:
    PUSH edi
i:
    mov al, [esi]
    mov dl, [edi]
    cmp al, dl
    je equal
    inc edi
    jmp i
equal:
    inc edi
    mov dl, [edi]
    mov [esi], dl
    inc esi
    POP edi
    loop loop_start
    popf 
	_Pop_all_reg
    ret
    
_start:
    mov esi, text
    mov ecx, [len]
    mov edi, subs
    call procedure
    
    _PRINT text, [len]
    
    mov eax, 1
    mov ebx, 0
    int 0x80