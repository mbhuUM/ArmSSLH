	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 12, 0	sdk_version 13, 1
	.globl	_victim_function                ; -- Begin function victim_function
	.p2align	2
_victim_function:                       ; @victim_function
	.cfi_startproc
; %bb.0:
	cmp	sp, #0
	csetm	x16, ne
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	w0, [sp, #28]
	str	w1, [sp, #24]
	ldr	w8, [sp, #24]
	and	w8, w8, w16
	adrp	x9, _array@PAGE
	add	x9, x9, _array@PAGEOFF
	ldrb	w9, [x9, #1024]
	and	w9, w9, w16
	csdb
	subs	w8, w8, w9
	cset	w8, ge
	and	w8, w8, #0x1
	ands	w8, w8, #0x3
	b.ne	LBB0_2
; %bb.1:
	csel	x16, x16, xzr, eq
	b	LBB0_3
LBB0_2:
	csel	x16, x16, xzr, ne
	b	LBB0_9
LBB0_3:
	ldr	w8, [sp, #28]
	and	w8, w8, w16
	csdb
	subs	w8, w8, #0
	cset	w8, eq
	and	w8, w8, #0x1
	ands	w8, w8, #0x3
	b.ne	LBB0_5
; %bb.4:
	csel	x16, x16, xzr, eq
	b	LBB0_6
LBB0_5:
	csel	x16, x16, xzr, ne
	b	LBB0_7
LBB0_6:
	adrp	x8, _val@PAGE
	ldr	x8, [x8, _val@PAGEOFF]
	and	x8, x8, x16
	csdb
	str	x8, [sp, #16]
	b	LBB0_8
LBB0_7:
	adrp	x8, _val2@PAGE
	ldr	x8, [x8, _val2@PAGEOFF]
	and	x8, x8, x16
	csdb
	str	x8, [sp, #8]
	b	LBB0_8
LBB0_8:
	b	LBB0_9
LBB0_9:
	add	sp, sp, #32
	mov	x0, sp
	and	x0, x0, x16
	mov	sp, x0
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_setup                          ; -- Begin function setup
	.p2align	2
_setup:                                 ; @setup
	.cfi_startproc
; %bb.0:
	cmp	sp, #0
	csetm	x16, ne
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
	and	x8, x8, x16
	csdb
	subs	x8, x8, #32, lsl #12            ; =131072
	cset	w8, hs
	and	w8, w8, #0x1
	ands	w8, w8, #0x3
	b.ne	LBB1_3
; %bb.2:                                ;   in Loop: Header=BB1_1 Depth=1
	csel	x16, x16, xzr, eq
	b	LBB1_4
LBB1_3:
	csel	x16, x16, xzr, ne
	b	LBB1_6
LBB1_4:                                 ;   in Loop: Header=BB1_1 Depth=1
	ldursw	x9, [x29, #-4]
	and	x9, x9, x16
	adrp	x8, _array@PAGE
	add	x8, x8, _array@PAGEOFF
	csdb
	add	x8, x8, x9
	strb	wzr, [x8]
	b	LBB1_5
LBB1_5:                                 ;   in Loop: Header=BB1_1 Depth=1
	ldur	w8, [x29, #-4]
	and	w8, w8, w16
	csdb
	add	w8, w8, #1
	stur	w8, [x29, #-4]
	b	LBB1_1
LBB1_6:
	adrp	x9, _array@PAGE
	add	x9, x9, _array@PAGEOFF
	add	x0, x9, #1024
	mov	w8, #10                         ; =0xa
	strb	w8, [x9, #1024]
	mov	x1, sp
	and	x1, x1, x16
	mov	sp, x1
	bl	_cache_remove_prepare
	cmp	sp, #0
	csetm	x16, ne
	adrp	x8, _arr_context@PAGE
	str	x0, [x8, _arr_context@PAGEOFF]
	adrp	x0, _val@PAGE
	add	x0, x0, _val@PAGEOFF
	mov	x1, sp
	and	x1, x1, x16
	mov	sp, x1
	bl	_cache_remove_prepare
	cmp	sp, #0
	csetm	x16, ne
	adrp	x8, _val_context@PAGE
	str	x0, [x8, _val_context@PAGEOFF]
	adrp	x0, _val2@PAGE
	add	x0, x0, _val2@PAGEOFF
	mov	x1, sp
	and	x1, x1, x16
	mov	sp, x1
	bl	_cache_remove_prepare
	cmp	sp, #0
	csetm	x16, ne
	adrp	x8, _val2_context@PAGE
	str	x0, [x8, _val2_context@PAGEOFF]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	and	x29, x29, x16
	and	x30, x30, x16
	add	sp, sp, #32
	mov	x0, sp
	and	x0, x0, x16
	mov	sp, x0
	csdb
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_leakValue                      ; -- Begin function leakValue
	.p2align	2
_leakValue:                             ; @leakValue
	.cfi_startproc
; %bb.0:
	cmp	sp, #0
	csetm	x16, ne
	sub	sp, sp, #96
	stp	x29, x30, [sp, #80]             ; 16-byte Folded Spill
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	w0, [sp, #28]
	str	wzr, [sp, #24]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	mov	w8, #40                         ; =0x28
	str	w8, [sp, #20]
	b	LBB2_1
LBB2_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #20]
	and	w8, w8, w16
	csdb
	subs	w8, w8, #0
	cset	w8, lt
	and	w8, w8, #0x1
	ands	w8, w8, #0x3
	b.ne	LBB2_3
; %bb.2:                                ;   in Loop: Header=BB2_1 Depth=1
	csel	x16, x16, xzr, eq
	b	LBB2_4
LBB2_3:
	csel	x16, x16, xzr, ne
	b	LBB2_6
LBB2_4:                                 ;   in Loop: Header=BB2_1 Depth=1
	ldr	w8, [sp, #20]
	and	w8, w8, w16
	csdb
	subs	w8, w8, #0
	cset	w8, eq
	and	w8, w8, #0x1
	mov	w9, #10                         ; =0xa
	mul	w8, w8, w9
	str	w8, [sp, #16]
	adrp	x8, _arr_context@PAGE
	ldr	x0, [x8, _arr_context@PAGEOFF]
	and	x0, x0, x16
	mov	x1, sp
	and	x1, x1, x16
	mov	sp, x1
	csdb
	bl	_cache_remove
	cmp	sp, #0
	csetm	x16, ne
	adrp	x8, _val_context@PAGE
	ldr	x0, [x8, _val_context@PAGEOFF]
	and	x0, x0, x16
	mov	x1, sp
	and	x1, x1, x16
	mov	sp, x1
	csdb
	bl	_cache_remove
	cmp	sp, #0
	csetm	x16, ne
	adrp	x8, _val2_context@PAGE
	ldr	x0, [x8, _val2_context@PAGEOFF]
	and	x0, x0, x16
	mov	x1, sp
	and	x1, x1, x16
	mov	sp, x1
	csdb
	bl	_cache_remove
	cmp	sp, #0
	csetm	x16, ne
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	w0, [sp, #28]
	and	w0, w0, w16
	ldr	w1, [sp, #16]
	and	w1, w1, w16
	mov	x2, sp
	and	x2, x2, x16
	mov	sp, x2
	csdb
	bl	_victim_function
	cmp	sp, #0
	csetm	x16, ne
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	b	LBB2_5
LBB2_5:                                 ;   in Loop: Header=BB2_1 Depth=1
	ldr	w8, [sp, #20]
	and	w8, w8, w16
	csdb
	subs	w8, w8, #1
	str	w8, [sp, #20]
	b	LBB2_1
LBB2_6:
	adrp	x8, _val@PAGE
	add	x8, x8, _val@PAGEOFF
	stur	x8, [x29, #-8]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	adrp	x8, _timestamp@GOTPAGE
	ldr	x8, [x8, _timestamp@GOTPAGEOFF]
	and	x8, x8, x16
	csdb
	ldr	x9, [x8]
	and	x9, x9, x16
	csdb
	stur	x9, [x29, #-16]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldur	x9, [x29, #-8]
	and	x9, x9, x16
	csdb
	; InlineAsm Start
	ldr	x10, [x9]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x9, [x8]
	and	x9, x9, x16
	csdb
	stur	x9, [x29, #-24]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldur	x9, [x29, #-24]
	and	x9, x9, x16
	ldur	x10, [x29, #-16]
	and	x10, x10, x16
	csdb
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
	and	x9, x9, x16
	csdb
	str	x9, [sp, #40]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldur	x9, [x29, #-32]
	and	x9, x9, x16
	csdb
	; InlineAsm Start
	ldr	x10, [x9]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x8, [x8]
	and	x8, x8, x16
	csdb
	str	x8, [sp, #32]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x8, [sp, #32]
	and	x8, x8, x16
	ldr	x9, [sp, #40]
	and	x9, x9, x16
	csdb
	subs	x8, x8, x9
	adrp	x9, _time2@PAGE
	str	x8, [x9, _time2@PAGEOFF]
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	and	x29, x29, x16
	and	x30, x30, x16
	add	sp, sp, #96
	mov	x0, sp
	and	x0, x0, x16
	mov	sp, x0
	csdb
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	cmp	sp, #0
	csetm	x16, ne
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
	and	x8, x8, x16
	csdb
	ldr	x8, [x8]
	and	x8, x8, x16
	csdb
	stur	x8, [x29, #-24]
	str	wzr, [sp, #52]
	str	w0, [sp, #48]
	str	x1, [sp, #40]
	mov	x0, sp
	and	x0, x0, x16
	mov	sp, x0
	bl	_timer_start
	cmp	sp, #0
	csetm	x16, ne
	ldr	x8, [sp, #40]
	and	x8, x8, x16
	csdb
	ldr	x0, [x8, #8]
	and	x0, x0, x16
	mov	x1, sp
	and	x1, x1, x16
	mov	sp, x1
	csdb
	bl	_atoi
	cmp	sp, #0
	csetm	x16, ne
	str	w0, [sp, #36]
	str	wzr, [sp, #32]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	mov	x0, sp
	and	x0, x0, x16
	mov	sp, x0
	bl	_setup
	cmp	sp, #0
	csetm	x16, ne
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	str	wzr, [sp, #28]
	b	LBB3_1
LBB3_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #28]
	and	w8, w8, w16
	csdb
	subs	w8, w8, #32
	cset	w8, ge
	and	w8, w8, #0x1
	ands	w8, w8, #0x3
	b.ne	LBB3_3
; %bb.2:                                ;   in Loop: Header=BB3_1 Depth=1
	csel	x16, x16, xzr, eq
	b	LBB3_4
LBB3_3:
	csel	x16, x16, xzr, ne
	b	LBB3_6
LBB3_4:                                 ;   in Loop: Header=BB3_1 Depth=1
	ldr	w0, [sp, #36]
	and	w0, w0, w16
	mov	x1, sp
	and	x1, x1, x16
	mov	sp, x1
	csdb
	bl	_leakValue
	cmp	sp, #0
	csetm	x16, ne
	adrp	x8, _time1@PAGE
	ldr	x8, [x8, _time1@PAGEOFF]
	and	x8, x8, x16
	ldrsw	x10, [sp, #28]
	and	x10, x10, x16
	add	x9, sp, #312
	csdb
	str	x8, [x9, x10, lsl #3]
	adrp	x8, _time2@PAGE
	ldr	x8, [x8, _time2@PAGEOFF]
	and	x8, x8, x16
	ldrsw	x10, [sp, #28]
	and	x10, x10, x16
	add	x9, sp, #56
	csdb
	str	x8, [x9, x10, lsl #3]
	b	LBB3_5
LBB3_5:                                 ;   in Loop: Header=BB3_1 Depth=1
	ldr	w8, [sp, #28]
	and	w8, w8, w16
	csdb
	add	w8, w8, #1
	str	w8, [sp, #28]
	b	LBB3_1
LBB3_6:
	str	wzr, [sp, #24]
	b	LBB3_7
LBB3_7:                                 ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #24]
	and	w8, w8, w16
	csdb
	subs	w8, w8, #32
	cset	w8, ge
	and	w8, w8, #0x1
	ands	w8, w8, #0x3
	b.ne	LBB3_9
; %bb.8:                                ;   in Loop: Header=BB3_7 Depth=1
	csel	x16, x16, xzr, eq
	b	LBB3_10
LBB3_9:
	csel	x16, x16, xzr, ne
	b	LBB3_12
LBB3_10:                                ;   in Loop: Header=BB3_7 Depth=1
	ldrsw	x9, [sp, #24]
	and	x9, x9, x16
	add	x8, sp, #312
	csdb
	ldr	x8, [x8, x9, lsl #3]
	and	x8, x8, x16
	mov	x9, sp
	csdb
	str	x8, [x9]
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF
	mov	x1, sp
	and	x1, x1, x16
	mov	sp, x1
	bl	_printf
	cmp	sp, #0
	csetm	x16, ne
	b	LBB3_11
LBB3_11:                                ;   in Loop: Header=BB3_7 Depth=1
	ldr	w8, [sp, #24]
	and	w8, w8, w16
	csdb
	add	w8, w8, #1
	str	w8, [sp, #24]
	b	LBB3_7
LBB3_12:
	adrp	x0, l_.str.1@PAGE
	add	x0, x0, l_.str.1@PAGEOFF
	mov	x1, sp
	and	x1, x1, x16
	mov	sp, x1
	bl	_printf
	cmp	sp, #0
	csetm	x16, ne
	str	wzr, [sp, #20]
	b	LBB3_13
LBB3_13:                                ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #20]
	and	w8, w8, w16
	csdb
	subs	w8, w8, #32
	cset	w8, ge
	and	w8, w8, #0x1
	ands	w8, w8, #0x3
	b.ne	LBB3_15
; %bb.14:                               ;   in Loop: Header=BB3_13 Depth=1
	csel	x16, x16, xzr, eq
	b	LBB3_16
LBB3_15:
	csel	x16, x16, xzr, ne
	b	LBB3_18
LBB3_16:                                ;   in Loop: Header=BB3_13 Depth=1
	ldrsw	x9, [sp, #20]
	and	x9, x9, x16
	add	x8, sp, #56
	csdb
	ldr	x8, [x8, x9, lsl #3]
	and	x8, x8, x16
	mov	x9, sp
	csdb
	str	x8, [x9]
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF
	mov	x1, sp
	and	x1, x1, x16
	mov	sp, x1
	bl	_printf
	cmp	sp, #0
	csetm	x16, ne
	b	LBB3_17
LBB3_17:                                ;   in Loop: Header=BB3_13 Depth=1
	ldr	w8, [sp, #20]
	and	w8, w8, w16
	csdb
	add	w8, w8, #1
	str	w8, [sp, #20]
	b	LBB3_13
LBB3_18:
	mov	x0, sp
	and	x0, x0, x16
	mov	sp, x0
	bl	_timer_stop
	cmp	sp, #0
	csetm	x16, ne
	ldr	w8, [sp, #52]
	and	w8, w8, w16
	csdb
	str	w8, [sp, #16]                   ; 4-byte Folded Spill
	ldur	x9, [x29, #-24]
	and	x9, x9, x16
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	and	x8, x8, x16
	csdb
	ldr	x8, [x8]
	and	x8, x8, x16
	csdb
	subs	x8, x8, x9
	cset	w8, eq
	and	w8, w8, #0x1
	ands	w8, w8, #0x3
	b.ne	LBB3_20
; %bb.19:
	csel	x16, x16, xzr, eq
	b	LBB3_21
LBB3_20:
	csel	x16, x16, xzr, ne
	b	LBB3_22
LBB3_21:
	mov	x0, sp
	and	x0, x0, x16
	mov	sp, x0
	bl	___stack_chk_fail
	cmp	sp, #0
	csetm	x16, ne
LBB3_22:
	ldr	w0, [sp, #16]                   ; 4-byte Folded Reload
	and	w0, w0, w16
	add	sp, sp, #576
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	and	x29, x29, x16
	and	x30, x30, x16
	ldp	x28, x27, [sp], #32             ; 16-byte Folded Reload
	and	x28, x28, x16
	and	x27, x27, x16
	mov	x1, sp
	and	x1, x1, x16
	mov	sp, x1
	csdb
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

.zerofill __DATA,__bss,_array,131072,11 ; @array
	.globl	_array_ctx                      ; @array_ctx
.zerofill __DATA,__common,_array_ctx,8,3
	.globl	_arr_context                    ; @arr_context
.zerofill __DATA,__common,_arr_context,8,11
	.globl	_val_context                    ; @val_context
.zerofill __DATA,__common,_val_context,8,11
	.globl	_val2_context                   ; @val2_context
.zerofill __DATA,__common,_val2_context,8,11
	.globl	_time1                          ; @time1
.zerofill __DATA,__common,_time1,8,3
	.globl	_time2                          ; @time2
.zerofill __DATA,__common,_time2,8,3
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"%3lld "

l_.str.1:                               ; @.str.1
	.asciz	"\n"

	.globl	_secret_context                 ; @secret_context
.zerofill __DATA,__common,_secret_context,8,11
	.globl	_is_public_context              ; @is_public_context
.zerofill __DATA,__common,_is_public_context,8,11
	.globl	_training_offset                ; @training_offset
.zerofill __DATA,__common,_training_offset,8,3
	.no_dead_strip	_victim_function
.subsections_via_symbols
