; The Scrypt! v.0.4 Unpacker v0.1
; Copyright (c) 1998 MERLiN // Delirium Tremens Group
.386p
cseg            segment         use16
                assume          cs:cseg,ds:cseg,es:cseg
                org             100h
begin           proc
                lea             dx,msg1
                call            view
                mov             si,81h
                lodsb
                cmp             al,13
                jnz             _keep_scan
                lea             dx,msg2
                call            view
                retn
_keep_scan:
                lodsb
                cmp             al,32
                jz              _keep_scan
                dec             si
                mov             di,si
                push            di di
                mov             al,13
                repne           scasb
                dec             di
                lea             si,ppp
                mov             cx,_out-ppp
                rep             movsb
                pop             dx
                mov             ax,3d02h
                int             21h
                jc              nf
                xchg            bx,ax
                lea             dx,unp
                call            view
                pop             dx
                push            0
                pop             ds
                mov             word ptr ds:[1*4],offset int1
                mov             word ptr ds:[1*4+2],cs
                call            view

;
; Здесь начинается блок "считывания в себя"
; Комментарии специально для ДаркГрей //[ДСА]
;
                mov             ax,es          ; переслать es в ax
                add             ah,16          ; добавить к ax 4096
                mov             ds,ax          ; переслать ax в ds
                mov             es,ax          ; переслать ax в es
                mov             dx,256         ; заслать в dx 256
                push            dx ds dx       ; записать в стек dx,ds,dx
                mov             cx,-1          ; заслать в cx -1
                mov             ah,3fh         ; заслать в ah 63
                int             21h            ; выполнить int 21h
                cmp             word ptr ds:[100h],'ZM' ; в ds:[256] есть 'MZ'?
                jnz             a3             ; если z<>1 перейти на a3
                lea             dx,msg3        ; заслать в dx смещение msg3
                jmp             nf2            ; переход на nf2
a3:
                mov             cs:sz,ax       ; записать в cs:sz ax
                mov             ah,3eh         ; заслать в ah 62
                int             21h            ; выполнить int 21h
;
;
;
;
                xor             di,di
                mov             cx,64
                xor             ax,ax
                rep             stosd
                iret
int1:
                cmp             word ptr [esp],256
                jnz             no_shit
                cmp             cs:flag,0
                jz              nf
no_shit:
                push            ds si
                lds             si,[esp+4]
                cmp             word ptr [si],21cdh
                jz              nf
                cmp             word ptr [si],64e6h
                jnz             a2
                mov             cs:scrypt,260
                add             word ptr [esp+4],2
a2:
                cmp             dword ptr [si],8b575f5ah
                jnz             a1
                mov             cs:flag,1
a1:
                cmp             dword ptr [si],01006861h
                pop             si ds
                jz              got_it
                iret
got_it:
                lea             dx,done
                call            view
                lea             dx,_out
                mov             ah,3ch
                int             21h
                xchg            bx,ax
                mov             ax,sz
                db              02dh
scrypt          dw              244
                xchg            cx,ax
                mov             ds,[esp+2]
                mov             dx,256
                mov             ah,40h
                int             21h
                mov             ah,3eh
                int             21h
                mov             ah,4ch
                int             21h
nf:
                lea             dx,_sd
nf2:
                call            view
                mov             ah,4ch
                int             21h
view:
                push            cs
                pop             ds
                mov             ah,9
                int             21h
                retn
flag            db              0
msg1            db              'USCRYPT! v0.1 unpacks files crypted with [ Scrypt! v.0.4 by DarkGrey //[PSA] ]',13,10
                db              'Copyright (c) 1998 MERLiN // Delirium Tremens Group',13,10,'$'
msg2            db              'Usage: uscrypt! file.ext',13,10,'$'
msg3            db              13,10,'EXE-files are not supported',10,'$'
_sd             db              '2 User : Super-Druper Scrypt! v.0.4 not found',10,'$'
unp             db              'Unpacking $'
done            db              'Done',13,10,'$'
ppp             db              0,'... $'
sz              dw              244
_out            db              'out.com',0
begin           endp
cseg            ends
                end             begin