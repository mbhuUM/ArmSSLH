	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0
	.globl	_victim_function                ; -- Begin function victim_function
	.p2align	2
_victim_function:                       ; @victim_function
	.cfi_startproc
; %bb.0:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_setup                          ; -- Begin function setup
	.p2align	2
_setup:                                 ; @setup
	.cfi_startproc
; %bb.0:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
Lloh0:
	adrp	x19, _array@PAGE
Lloh1:
	add	x19, x19, _array@PAGEOFF
	mov	x0, x19
	mov	w1, #131072                     ; =0x20000
	bl	_bzero
	mov	w8, #10                         ; =0xa
	strb	w8, [x19, #1024]
	add	x0, x19, #1024
	bl	_cache_remove_prepare
	adrp	x8, _arr_context@PAGE
	str	x0, [x8, _arr_context@PAGEOFF]
Lloh2:
	adrp	x0, _val@PAGE
Lloh3:
	add	x0, x0, _val@PAGEOFF
	bl	_cache_remove_prepare
	adrp	x8, _val_context@PAGE
	str	x0, [x8, _val_context@PAGEOFF]
Lloh4:
	adrp	x0, _val2@PAGE
Lloh5:
	add	x0, x0, _val2@PAGEOFF
	bl	_cache_remove_prepare
	adrp	x8, _val2_context@PAGE
	str	x0, [x8, _val2_context@PAGEOFF]
Lloh6:
	adrp	x0, _is_public@PAGE
Lloh7:
	add	x0, x0, _is_public@PAGEOFF
	bl	_cache_remove_prepare
	adrp	x8, _is_public_context@PAGE
	str	x0, [x8, _is_public_context@PAGEOFF]
Lloh8:
	adrp	x0, _secret@PAGE
Lloh9:
	add	x0, x0, _secret@PAGEOFF
	bl	_cache_remove_prepare
	adrp	x8, _secret_context@PAGE
	str	x0, [x8, _secret_context@PAGEOFF]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpAdd	Lloh6, Lloh7
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpAdd	Lloh0, Lloh1
	.cfi_endproc
                                        ; -- End function
	.globl	_leakValue                      ; -- Begin function leakValue
	.p2align	2
_leakValue:                             ; @leakValue
	.cfi_startproc
; %bb.0:
	stp	x24, x23, [sp, #-64]!           ; 16-byte Folded Spill
	stp	x22, x21, [sp, #16]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #32]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	mov	w19, #-41                       ; =0xffffffd7
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	adrp	x20, _arr_context@PAGE
	adrp	x21, _val_context@PAGE
	adrp	x22, _val2_context@PAGE
	adrp	x23, _is_public_context@PAGE
LBB2_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x0, [x20, _arr_context@PAGEOFF]
	bl	_cache_remove
	ldr	x0, [x21, _val_context@PAGEOFF]
	bl	_cache_remove
	ldr	x0, [x22, _val2_context@PAGEOFF]
	bl	_cache_remove
	ldr	x0, [x23, _is_public_context@PAGEOFF]
	bl	_cache_remove
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	adds	w19, w19, #1
	b.lo	LBB2_1
; %bb.2:
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
Lloh10:
	adrp	x8, _timestamp@GOTPAGE
Lloh11:
	ldr	x8, [x8, _timestamp@GOTPAGEOFF]
	ldr	w9, [x8]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
Lloh12:
	adrp	x11, _val@PAGE
Lloh13:
	add	x11, x11, _val@PAGEOFF
	; InlineAsm Start
	ldr	x10, [x11]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	w8, [x8]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	sub	w0, w8, w9
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp], #64             ; 16-byte Folded Reload
	ret
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpLdrGot	Lloh10, Lloh11
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	stp	x28, x27, [sp, #-96]!           ; 16-byte Folded Spill
	stp	x26, x25, [sp, #16]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #32]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #48]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #64]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #80]             ; 16-byte Folded Spill
	add	x29, sp, #80
	sub	sp, sp, #480
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	mov	x19, x1
	add	x27, sp, #192
Lloh14:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh15:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh16:
	ldr	x8, [x8]
	stur	x8, [x29, #-104]
	bl	_timer_start
	ldr	x0, [x19, #8]
	bl	_atoi
Lloh17:
	adrp	x20, _secret@PAGE
Lloh18:
	add	x20, x20, _secret@PAGEOFF
	str	w0, [x20]
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x27, #224]
	stp	q0, q0, [x27, #192]
	stp	q0, q0, [x27, #160]
	stp	q0, q0, [x27, #128]
	stp	q0, q0, [sp, #288]
	stp	q0, q0, [sp, #256]
	stp	q0, q0, [sp, #224]
	stp	q0, q0, [sp, #192]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
Lloh19:
	adrp	x19, _array@PAGE
Lloh20:
	add	x19, x19, _array@PAGEOFF
	mov	x0, x19
	mov	w1, #131072                     ; =0x20000
	bl	_bzero
	mov	w8, #10                         ; =0xa
	strb	w8, [x19, #1024]
	add	x0, x19, #1024
	bl	_cache_remove_prepare
	adrp	x21, _arr_context@PAGE
	str	x0, [x21, _arr_context@PAGEOFF]
Lloh21:
	adrp	x19, _val@PAGE
Lloh22:
	add	x19, x19, _val@PAGEOFF
	mov	x0, x19
	bl	_cache_remove_prepare
	adrp	x22, _val_context@PAGE
	str	x0, [x22, _val_context@PAGEOFF]
Lloh23:
	adrp	x0, _val2@PAGE
Lloh24:
	add	x0, x0, _val2@PAGEOFF
	bl	_cache_remove_prepare
	adrp	x23, _val2_context@PAGE
	str	x0, [x23, _val2_context@PAGEOFF]
Lloh25:
	adrp	x0, _is_public@PAGE
Lloh26:
	add	x0, x0, _is_public@PAGEOFF
	bl	_cache_remove_prepare
	adrp	x24, _is_public_context@PAGE
	str	x0, [x24, _is_public_context@PAGEOFF]
	mov	x0, x20
	bl	_cache_remove_prepare
	adrp	x8, _secret_context@PAGE
	str	x0, [x8, _secret_context@PAGEOFF]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	str	wzr, [sp, #188]
	ldr	w8, [sp, #188]
	cmp	w8, #31
	b.gt	LBB3_6
; %bb.1:
Lloh27:
	adrp	x20, _timestamp@GOTPAGE
Lloh28:
	ldr	x20, [x20, _timestamp@GOTPAGEOFF]
LBB3_2:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB3_3 Depth 2
	ldr	w8, [sp, #188]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	mov	w25, #-41                       ; =0xffffffd7
LBB3_3:                                 ;   Parent Loop BB3_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x0, [x21, _arr_context@PAGEOFF]
	bl	_cache_remove
	ldr	x0, [x22, _val_context@PAGEOFF]
	bl	_cache_remove
	ldr	x0, [x23, _val2_context@PAGEOFF]
	bl	_cache_remove
	ldr	x0, [x24, _is_public_context@PAGEOFF]
	bl	_cache_remove
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	adds	w25, w25, #1
	b.lo	LBB3_3
; %bb.4:                                ;   in Loop: Header=BB3_2 Depth=1
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	w8, [x20]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	; InlineAsm Start
	ldr	x10, [x19]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	w9, [x20]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	sub	w8, w9, w8
	sxtw	x8, w8
	ldrsw	x9, [sp, #188]
	str	x8, [x27, x9, lsl #3]
	ldr	w8, [sp, #188]
	add	w8, w8, #1
	str	w8, [sp, #188]
	ldr	w8, [sp, #188]
	cmp	w8, #32
	b.lt	LBB3_2
; %bb.5:
	ldp	x8, x24, [sp, #192]
	ldp	x23, x22, [sp, #208]
	ldp	x21, x20, [sp, #224]
	ldp	x28, x26, [sp, #240]
	ldr	x10, [sp, #256]
	ldr	x9, [sp, #264]
	stp	x10, x9, [sp, #8]               ; 16-byte Folded Spill
	ldr	x10, [sp, #272]
	ldr	x9, [sp, #280]
	stp	x10, x9, [sp, #24]              ; 16-byte Folded Spill
	ldr	x10, [sp, #288]
	ldr	x9, [sp, #296]
	stp	x10, x9, [sp, #40]              ; 16-byte Folded Spill
	ldr	x10, [x27, #128]
	ldr	x9, [x27, #136]
	stp	x10, x9, [sp, #56]              ; 16-byte Folded Spill
	ldr	x10, [x27, #144]
	ldr	x9, [x27, #152]
	stp	x10, x9, [sp, #72]              ; 16-byte Folded Spill
	ldr	x10, [x27, #160]
	ldr	x9, [x27, #168]
	stp	x10, x9, [sp, #88]              ; 16-byte Folded Spill
	ldr	x10, [x27, #176]
	ldr	x9, [x27, #184]
	stp	x10, x9, [sp, #104]             ; 16-byte Folded Spill
	ldr	x10, [x27, #192]
	ldr	x9, [x27, #200]
	stp	x10, x9, [sp, #120]             ; 16-byte Folded Spill
	ldr	x10, [x27, #208]
	ldr	x9, [x27, #216]
	stp	x10, x9, [sp, #136]             ; 16-byte Folded Spill
	ldr	x10, [x27, #224]
	ldr	x9, [x27, #232]
	stp	x10, x9, [sp, #152]             ; 16-byte Folded Spill
	ldr	x10, [x27, #240]
	ldr	x9, [x27, #248]
	stp	x10, x9, [sp, #168]             ; 16-byte Folded Spill
	ldp	x25, x27, [sp, #304]
	b	LBB3_7
LBB3_6:
	stp	xzr, xzr, [sp, #168]            ; 16-byte Folded Spill
	stp	xzr, xzr, [sp, #152]            ; 16-byte Folded Spill
	stp	xzr, xzr, [sp, #136]            ; 16-byte Folded Spill
	stp	xzr, xzr, [sp, #120]            ; 16-byte Folded Spill
	stp	xzr, xzr, [sp, #104]            ; 16-byte Folded Spill
	stp	xzr, xzr, [sp, #88]             ; 16-byte Folded Spill
	stp	xzr, xzr, [sp, #72]             ; 16-byte Folded Spill
	stp	xzr, xzr, [sp, #56]             ; 16-byte Folded Spill
	mov	x27, #0                         ; =0x0
	mov	x25, #0                         ; =0x0
	stp	xzr, xzr, [sp, #40]             ; 16-byte Folded Spill
	stp	xzr, xzr, [sp, #24]             ; 16-byte Folded Spill
	stp	xzr, xzr, [sp, #8]              ; 16-byte Folded Spill
	mov	x26, #0                         ; =0x0
	mov	x28, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	x21, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
	mov	x23, #0                         ; =0x0
	mov	x24, #0                         ; =0x0
	mov	x8, #0                          ; =0x0
LBB3_7:
	str	x8, [sp]
Lloh29:
	adrp	x19, l_.str@PAGE
Lloh30:
	add	x19, x19, l_.str@PAGEOFF
	mov	x0, x19
	bl	_printf
	str	x24, [sp]
	mov	x0, x19
	bl	_printf
	str	x23, [sp]
	mov	x0, x19
	bl	_printf
	str	x22, [sp]
	mov	x0, x19
	bl	_printf
	str	x21, [sp]
	mov	x0, x19
	bl	_printf
	str	x20, [sp]
	mov	x0, x19
	bl	_printf
	str	x28, [sp]
	mov	x0, x19
	bl	_printf
	str	x26, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #48]                   ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	str	x25, [sp]
	mov	x0, x19
	bl	_printf
	str	x27, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #64]                   ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #72]                   ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #80]                   ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #88]                   ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #96]                   ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #104]                  ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #112]                  ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #128]                  ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #136]                  ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #152]                  ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #160]                  ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #168]                  ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	ldr	x8, [sp, #176]                  ; 8-byte Folded Reload
	str	x8, [sp]
	mov	x0, x19
	bl	_printf
	bl	_timer_stop
	ldur	x8, [x29, #-104]
Lloh31:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh32:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh33:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB3_9
; %bb.8:
	mov	w0, #0                          ; =0x0
	add	sp, sp, #480
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #32]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #16]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp], #96             ; 16-byte Folded Reload
	ret
LBB3_9:
	bl	___stack_chk_fail
	.loh AdrpAdd	Lloh25, Lloh26
	.loh AdrpAdd	Lloh23, Lloh24
	.loh AdrpAdd	Lloh21, Lloh22
	.loh AdrpAdd	Lloh19, Lloh20
	.loh AdrpAdd	Lloh17, Lloh18
	.loh AdrpLdrGotLdr	Lloh14, Lloh15, Lloh16
	.loh AdrpLdrGot	Lloh27, Lloh28
	.loh AdrpLdrGotLdr	Lloh31, Lloh32, Lloh33
	.loh AdrpAdd	Lloh29, Lloh30
	.cfi_endproc
                                        ; -- End function
	.section	__DATA,__data
	.globl	_val                            ; @val
	.p2align	11, 0x0
_val:
	.quad	3203383023                      ; 0xbeefbeef

	.globl	_val2                           ; @val2
	.p2align	11, 0x0
_val2:
	.quad	19088743                        ; 0x1234567

	.globl	_is_public                      ; @is_public
	.p2align	11, 0x0
_is_public:
	.long	1                               ; 0x1

	.globl	_secret                         ; @secret
	.p2align	11, 0x0
_secret:
	.long	3735927486                      ; 0xdeadbabe

.zerofill __DATA,__bss,_array,131072,11 ; @array
	.globl	_array_ctx                      ; @array_ctx
.zerofill __DATA,__common,_array_ctx,8,3
	.globl	_arr_context                    ; @arr_context
.zerofill __DATA,__common,_arr_context,8,11
	.globl	_val_context                    ; @val_context
.zerofill __DATA,__common,_val_context,8,11
	.globl	_val2_context                   ; @val2_context
.zerofill __DATA,__common,_val2_context,8,11
	.globl	_is_public_context              ; @is_public_context
.zerofill __DATA,__common,_is_public_context,8,11
	.globl	_secret_context                 ; @secret_context
.zerofill __DATA,__common,_secret_context,8,11
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"%3lld "

	.globl	_training_offset                ; @training_offset
.zerofill __DATA,__common,_training_offset,8,3
.subsections_via_symbols
