	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0
	.globl	_evset_init                     ; -- Begin function evset_init
	.p2align	2
_evset_init:                            ; @evset_init
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
	mov	x19, x4
	mov	x20, x3
	mov	x21, x2
	mov	x22, x1
	mov	x23, x0
	mov	x0, #0                          ; =0x0
	bl	_time
                                        ; kill: def $w0 killed $w0 killed $x0
	bl	_srand
	bl	_timer_start
	adrp	x8, _traverser@PAGE
	ldr	x9, [x8, _traverser@PAGEOFF]
	cbnz	x9, LBB0_2
; %bb.1:
	str	x23, [x8, _traverser@PAGEOFF]
LBB0_2:
	adrp	x8, _evset_size@PAGE
	ldr	w9, [x8, _evset_size@PAGEOFF]
	cbnz	w9, LBB0_4
; %bb.3:
	str	w22, [x8, _evset_size@PAGEOFF]
LBB0_4:
	adrp	x8, _page_size@PAGE
	ldr	x9, [x8, _page_size@PAGEOFF]
	cbnz	x9, LBB0_6
; %bb.5:
	sxtw	x9, w21
	str	x9, [x8, _page_size@PAGEOFF]
LBB0_6:
	adrp	x8, _evset_memory_size@PAGE
	ldr	x9, [x8, _evset_memory_size@PAGEOFF]
	cbnz	x9, LBB0_8
; %bb.7:
	sxtw	x9, w20
	str	x9, [x8, _evset_memory_size@PAGEOFF]
LBB0_8:
	adrp	x8, _threshold@PAGE
	ldr	x9, [x8, _threshold@PAGEOFF]
	cbnz	x9, LBB0_10
; %bb.9:
	sxtw	x9, w19
	str	x9, [x8, _threshold@PAGEOFF]
LBB0_10:
	adrp	x19, _eviction_sets@PAGE
	ldr	x8, [x19, _eviction_sets@PAGEOFF]
	cbnz	x8, LBB0_12
; %bb.11:
	mov	w0, #1                          ; =0x1
	mov	w1, #8                          ; =0x8
	bl	_calloc
	str	x0, [x19, _eviction_sets@PAGEOFF]
LBB0_12:
	adrp	x19, _eviction_sets_pages@PAGE
	ldr	x8, [x19, _eviction_sets_pages@PAGEOFF]
	cbnz	x8, LBB0_14
; %bb.13:
	mov	w0, #1                          ; =0x1
	mov	w1, #8                          ; =0x8
	bl	_calloc
	str	x0, [x19, _eviction_sets_pages@PAGEOFF]
LBB0_14:
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp], #64             ; 16-byte Folded Reload
	b	_timer_stop
	.cfi_endproc
                                        ; -- End function
	.globl	_evset_find                     ; -- Begin function evset_find
	.p2align	2
_evset_find:                            ; @evset_find
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #112
	stp	x28, x27, [sp, #16]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #32]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #48]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #64]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #80]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #96]             ; 16-byte Folded Spill
	add	x29, sp, #96
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
	mov	x19, x0
	adrp	x26, _page_size@PAGE
	ldr	x11, [x26, _page_size@PAGEOFF]
	sub	x9, x11, #1
Lloh0:
	adrp	x8, _cache_line_size@PAGE
Lloh1:
	ldr	x8, [x8, _cache_line_size@PAGEOFF]
	neg	x8, x8
	and	x10, x8, x0
	adrp	x23, _evsets_count@PAGE
	ldr	w8, [x23, _evsets_count@PAGEOFF]
	adrp	x21, _eviction_sets_pages@PAGE
	adrp	x22, _eviction_sets@PAGE
	udiv	x24, x0, x11
	cmp	w8, #2
	b.lt	LBB1_4
; %bb.1:
	mov	x11, #0                         ; =0x0
	sub	w8, w8, #1
	ldr	x12, [x21, _eviction_sets_pages@PAGEOFF]
	ubfiz	x13, x8, #3, #32
LBB1_2:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x14, [x12, x11]
	cmp	x14, x24
	b.eq	LBB1_20
; %bb.3:                                ;   in Loop: Header=BB1_2 Depth=1
	add	x11, x11, #8
	cmp	x13, x11
	b.ne	LBB1_2
LBB1_4:
	and	x28, x10, x9
	adrp	x25, _evset_memory_size@PAGE
	ldr	x1, [x25, _evset_memory_size@PAGEOFF]
	mov	x0, #0                          ; =0x0
	mov	w2, #3                          ; =0x3
	mov	w3, #4098                       ; =0x1002
	mov	w4, #0                          ; =0x0
	mov	x5, #0                          ; =0x0
	bl	_mmap
	mov	x20, x0
	cbnz	x0, LBB1_6
; %bb.5:
Lloh2:
	adrp	x0, l_str@PAGE
Lloh3:
	add	x0, x0, l_str@PAGEOFF
	bl	_puts
LBB1_6:
	add	x8, x20, x28
	str	x8, [sp, #8]
	ldr	x8, [x25, _evset_memory_size@PAGEOFF]
	sub	x8, x8, #64
	cmp	x8, x28
	b.ls	LBB1_11
; %bb.7:
	mov	x11, #0                         ; =0x0
	mov	w9, #-2                         ; =0xfffffffe
	mov	x10, x28
	b	LBB1_9
LBB1_8:                                 ;   in Loop: Header=BB1_9 Depth=1
	ldr	x11, [x26, _page_size@PAGEOFF]
	add	x10, x11, x10
	cmp	x10, x8
	mov	x11, x12
	b.hs	LBB1_11
LBB1_9:                                 ; =>This Inner Loop Header: Depth=1
	add	x12, x20, x10
	str	w9, [x12, #16]
	str	xzr, [x12, #24]
	stp	xzr, x11, [x12]
	cbz	x11, LBB1_8
; %bb.10:                               ;   in Loop: Header=BB1_9 Depth=1
	str	x12, [x11]
	b	LBB1_8
LBB1_11:
	str	xzr, [sp]
	add	x0, sp, #8
	mov	x1, sp
	mov	x2, x19
	bl	_gt_eviction
	cbz	w0, LBB1_27
; %bb.12:
	mov	w27, #0                         ; =0x0
Lloh4:
	adrp	x22, l_str.12@PAGE
Lloh5:
	add	x22, x22, l_str.12@PAGEOFF
	mov	w23, #-2                        ; =0xfffffffe
	b	LBB1_14
LBB1_13:                                ;   in Loop: Header=BB1_14 Depth=1
	str	xzr, [sp]
	add	w27, w21, #1
	add	x0, sp, #8
	mov	x1, sp
	mov	x2, x19
	bl	_gt_eviction
	cbz	w0, LBB1_26
LBB1_14:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB1_18 Depth 2
	mov	x21, x27
	mov	x0, x22
	bl	_puts
	cmp	w27, #21
	b.eq	LBB1_28
; %bb.15:                               ;   in Loop: Header=BB1_14 Depth=1
	ldr	x1, [x25, _evset_memory_size@PAGEOFF]
	mov	x0, x20
	bl	_munmap
	ldr	x1, [x25, _evset_memory_size@PAGEOFF]
	mov	x0, #0                          ; =0x0
	mov	w2, #3                          ; =0x3
	mov	w3, #4098                       ; =0x1002
	mov	w4, #0                          ; =0x0
	mov	x5, #0                          ; =0x0
	bl	_mmap
	mov	x20, x0
	add	x8, x0, x28
	str	x8, [sp, #8]
	ldr	x8, [x25, _evset_memory_size@PAGEOFF]
	sub	x8, x8, #64
	cmp	x8, x28
	b.ls	LBB1_13
; %bb.16:                               ;   in Loop: Header=BB1_14 Depth=1
	mov	x10, #0                         ; =0x0
	mov	x9, x28
	b	LBB1_18
LBB1_17:                                ;   in Loop: Header=BB1_18 Depth=2
	ldr	x10, [x26, _page_size@PAGEOFF]
	add	x9, x10, x9
	cmp	x9, x8
	mov	x10, x11
	b.hs	LBB1_13
LBB1_18:                                ;   Parent Loop BB1_14 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x11, x20, x9
	str	w23, [x11, #16]
	str	xzr, [x11, #24]
	stp	xzr, x10, [x11]
	cbz	x10, LBB1_17
; %bb.19:                               ;   in Loop: Header=BB1_18 Depth=2
	str	x11, [x10]
	b	LBB1_17
LBB1_20:
	ldr	x12, [x22, _eviction_sets@PAGEOFF]
	ldr	x11, [x12, x11]
	eor	x10, x10, x11
	and	x9, x9, x10
	cbz	x11, LBB1_25
; %bb.21:
	mov	x13, #0                         ; =0x0
	mov	w10, #-2                        ; =0xfffffffe
	mov	x12, x11
	b	LBB1_23
LBB1_22:                                ;   in Loop: Header=BB1_23 Depth=1
	ldr	x12, [x12]
	mov	x13, x14
	cbz	x12, LBB1_25
LBB1_23:                                ; =>This Inner Loop Header: Depth=1
	eor	x14, x9, x12
	str	w10, [x14, #16]
	str	xzr, [x14, #24]
	stp	xzr, x13, [x14]
	cbz	x13, LBB1_22
; %bb.24:                               ;   in Loop: Header=BB1_23 Depth=1
	str	x14, [x13]
	b	LBB1_22
LBB1_25:
	eor	x9, x9, x11
	b	LBB1_36
LBB1_26:
	cmp	w21, #18
	adrp	x21, _eviction_sets_pages@PAGE
	adrp	x22, _eviction_sets@PAGE
	adrp	x23, _evsets_count@PAGE
	b.hi	LBB1_30
LBB1_27:
Lloh6:
	adrp	x0, l_str.11@PAGE
Lloh7:
	add	x0, x0, l_str.11@PAGEOFF
	b	LBB1_29
LBB1_28:
	adrp	x21, _eviction_sets_pages@PAGE
	adrp	x22, _eviction_sets@PAGE
	adrp	x23, _evsets_count@PAGE
Lloh8:
	adrp	x0, l_str.13@PAGE
Lloh9:
	add	x0, x0, l_str.13@PAGEOFF
LBB1_29:
	bl	_puts
LBB1_30:
	ldr	x20, [sp]
	cbz	x20, LBB1_35
; %bb.31:
Lloh10:
	adrp	x19, l_str.10@PAGE
Lloh11:
	add	x19, x19, l_str.10@PAGEOFF
	b	LBB1_33
LBB1_32:                                ;   in Loop: Header=BB1_33 Depth=1
	str	x20, [sp]
	cbz	x20, LBB1_35
LBB1_33:                                ; =>This Inner Loop Header: Depth=1
	ldr	x1, [x26, _page_size@PAGEOFF]
	neg	x8, x1
	and	x0, x8, x20
	ldr	x20, [x20]
	bl	_munmap
	cbz	w0, LBB1_32
; %bb.34:                               ;   in Loop: Header=BB1_33 Depth=1
	mov	x0, x19
	bl	_puts
	b	LBB1_32
LBB1_35:
	ldr	x9, [sp, #8]
	ldr	w8, [x23, _evsets_count@PAGEOFF]
	sub	w8, w8, #1
LBB1_36:
	ldr	x10, [x22, _eviction_sets@PAGEOFF]
                                        ; kill: def $w8 killed $w8 killed $x8 def $x8
	sbfiz	x8, x8, #3, #32
	str	x9, [x10, x8]
	ldr	x9, [x21, _eviction_sets_pages@PAGEOFF]
	str	x24, [x9, x8]
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
	.loh AdrpLdr	Lloh0, Lloh1
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpAdd	Lloh6, Lloh7
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpAdd	Lloh10, Lloh11
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function gt_eviction
lCPI2_0:
	.long	0                               ; 0x0
	.long	1                               ; 0x1
	.long	2                               ; 0x2
	.long	3                               ; 0x3
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_gt_eviction
	.p2align	2
_gt_eviction:                           ; @gt_eviction
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #240
	stp	d11, d10, [sp, #112]            ; 16-byte Folded Spill
	stp	d9, d8, [sp, #128]              ; 16-byte Folded Spill
	stp	x28, x27, [sp, #144]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #160]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #176]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #192]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #208]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #224]            ; 16-byte Folded Spill
	add	x29, sp, #224
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
	.cfi_offset b8, -104
	.cfi_offset b9, -112
	.cfi_offset b10, -120
	.cfi_offset b11, -128
	mov	x19, x2
	mov	x21, x1
	mov	x22, x0
Lloh12:
	adrp	x8, _evset_size@PAGE
Lloh13:
	ldrsw	x26, [x8, _evset_size@PAGEOFF]
	add	x24, x26, #1
	mov	x0, x24
	mov	w1, #8                          ; =0x8
	bl	_calloc
	cbz	x0, LBB2_5
; %bb.1:
	mov	x20, x0
	mov	x0, x24
	mov	w1, #4                          ; =0x4
	bl	_calloc
	cbz	x0, LBB2_6
; %bb.2:
	mov	x27, x0
	ldr	x23, [x22]
	cbz	x23, LBB2_7
; %bb.3:
	mov	w9, #0                          ; =0x0
	mov	x8, x23
LBB2_4:                                 ; =>This Inner Loop Header: Depth=1
	add	w9, w9, #1
	ldr	x8, [x8]
	cbnz	x8, LBB2_4
	b	LBB2_8
LBB2_5:
Lloh14:
	adrp	x0, l_str.14@PAGE
Lloh15:
	add	x0, x0, l_str.14@PAGEOFF
	bl	_puts
	b	LBB2_106
LBB2_6:
Lloh16:
	adrp	x0, l_str.15@PAGE
Lloh17:
	add	x0, x0, l_str.15@PAGEOFF
	bl	_puts
	mov	x0, x20
	b	LBB2_87
LBB2_7:
	mov	w9, #0                          ; =0x0
LBB2_8:
	scvtf	d0, w26
	mov	x28, x9
	scvtf	d1, w9
	fdiv	d8, d0, d1
	scvtf	d1, w24
	fdiv	d9, d0, d1
	fmov	d0, d8
	bl	_log
	fmov	d10, d0
	fmov	d0, d9
	bl	_log
	fdiv	d0, d10, d0
	fcvtps	w24, d0
	lsl	w25, w24, #1
	sxtw	x0, w25
	mov	w1, #8                          ; =0x8
	bl	_calloc
	str	x0, [sp, #88]                   ; 8-byte Folded Spill
	cbz	x0, LBB2_84
; %bb.9:
	stp	x25, x24, [sp, #56]             ; 16-byte Folded Spill
	str	x21, [sp, #72]                  ; 8-byte Folded Spill
	mov	w25, #0                         ; =0x0
	str	wzr, [sp, #80]                  ; 4-byte Folded Spill
	add	x8, x27, #32
	str	x8, [sp, #48]                   ; 8-byte Folded Spill
Lloh18:
	adrp	x8, lCPI2_0@PAGE
Lloh19:
	ldr	q0, [x8, lCPI2_0@PAGEOFF]
	str	q0, [sp, #32]                   ; 16-byte Folded Spill
	movi.4s	v4, #4
	adrp	x23, _traverser@PAGE
Lloh20:
	adrp	x24, _timestamp@GOTPAGE
Lloh21:
	ldr	x24, [x24, _timestamp@GOTPAGEOFF]
	movi.4s	v5, #8
	movi.4s	v6, #12
	movi.4s	v7, #16
	mov	x8, x26
	mov	x13, x28
	str	x27, [sp, #104]                 ; 8-byte Folded Spill
LBB2_10:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB2_14 Depth 2
                                        ;     Child Loop BB2_16 Depth 2
                                        ;     Child Loop BB2_19 Depth 2
                                        ;     Child Loop BB2_25 Depth 2
                                        ;       Child Loop BB2_27 Depth 3
                                        ;       Child Loop BB2_31 Depth 3
                                        ;         Child Loop BB2_34 Depth 4
                                        ;       Child Loop BB2_40 Depth 3
                                        ;         Child Loop BB2_44 Depth 4
                                        ;         Child Loop BB2_50 Depth 4
                                        ;           Child Loop BB2_54 Depth 5
                                        ;         Child Loop BB2_62 Depth 4
                                        ;       Child Loop BB2_67 Depth 3
                                        ;     Child Loop BB2_70 Depth 2
                                        ;     Child Loop BB2_75 Depth 2
                                        ;     Child Loop BB2_81 Depth 2
	add	w9, w8, #1
	tbnz	w8, #31, LBB2_17
; %bb.11:                               ;   in Loop: Header=BB2_10 Depth=1
	cmp	w9, #16
	b.hs	LBB2_13
; %bb.12:                               ;   in Loop: Header=BB2_10 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB2_16
LBB2_13:                                ;   in Loop: Header=BB2_10 Depth=1
	and	x10, x9, #0xfffffff0
	mov	x11, x10
	ldr	x12, [sp, #48]                  ; 8-byte Folded Reload
	ldr	q0, [sp, #32]                   ; 16-byte Folded Reload
LBB2_14:                                ;   Parent Loop BB2_10 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add.4s	v1, v0, v4
	add.4s	v2, v0, v5
	add.4s	v3, v0, v6
	stp	q0, q1, [x12, #-32]
	stp	q2, q3, [x12], #64
	add.4s	v0, v0, v7
	subs	x11, x11, #16
	b.ne	LBB2_14
; %bb.15:                               ;   in Loop: Header=BB2_10 Depth=1
	cmp	x10, x9
	b.eq	LBB2_17
LBB2_16:                                ;   Parent Loop BB2_10 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	str	w10, [x27, x10, lsl #2]
	add	x10, x10, #1
	cmp	x9, x10
	b.ne	LBB2_16
LBB2_17:                                ;   in Loop: Header=BB2_10 Depth=1
	cmp	w9, #2
	b.lo	LBB2_21
; %bb.18:                               ;   in Loop: Header=BB2_10 Depth=1
	mov	x28, x13
	mov	x26, x22
	mov	x21, #0                         ; =0x0
	sxtw	x22, w9
LBB2_19:                                ;   Parent Loop BB2_10 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	bl	_rand
	mov	w9, #2147483647                 ; =0x7fffffff
                                        ; kill: def $w0 killed $w0 def $x0
	sxtw	x8, w0
	udiv	x9, x9, x22
	add	x9, x9, #1
	udiv	x8, x8, x9
	add	x8, x8, x21
	lsl	x8, x8, #2
	ldr	w9, [x27, x8]
	lsl	x10, x21, #2
	ldr	w11, [x27, x10]
	str	w11, [x27, x8]
	str	w9, [x27, x10]
	add	x21, x21, #1
	sub	x22, x22, #1
	cmp	x22, #1
	b.ne	LBB2_19
; %bb.20:                               ;   in Loop: Header=BB2_10 Depth=1
Lloh22:
	adrp	x8, _evset_size@PAGE
Lloh23:
	ldr	w8, [x8, _evset_size@PAGEOFF]
	mov	x22, x26
	mov	x13, x28
LBB2_21:                                ;   in Loop: Header=BB2_10 Depth=1
	cmp	w13, w8
	b.le	LBB2_93
; %bb.22:                               ;   in Loop: Header=BB2_10 Depth=1
                                        ; kill: def $w25 killed $w25 killed $x25 def $x25
	sxtw	x11, w25
	ldr	x9, [x22]
	b	LBB2_25
LBB2_23:                                ;   in Loop: Header=BB2_25 Depth=2
	mov	w13, #0                         ; =0x0
	ldr	x27, [sp, #104]                 ; 8-byte Folded Reload
LBB2_24:                                ;   in Loop: Header=BB2_25 Depth=2
	add	x11, x11, #1
	cmp	w13, w8
	b.le	LBB2_93
LBB2_25:                                ;   Parent Loop BB2_10 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB2_27 Depth 3
                                        ;       Child Loop BB2_31 Depth 3
                                        ;         Child Loop BB2_34 Depth 4
                                        ;       Child Loop BB2_40 Depth 3
                                        ;         Child Loop BB2_44 Depth 4
                                        ;         Child Loop BB2_50 Depth 4
                                        ;           Child Loop BB2_54 Depth 5
                                        ;         Child Loop BB2_62 Depth 4
                                        ;       Child Loop BB2_67 Depth 3
	str	x11, [sp, #96]                  ; 8-byte Folded Spill
	str	w13, [sp, #84]                  ; 4-byte Folded Spill
	cbz	x9, LBB2_39
; %bb.26:                               ;   in Loop: Header=BB2_25 Depth=2
	mov	w13, #0                         ; =0x0
	add	w10, w8, #1
	mov	x11, x9
LBB2_27:                                ;   Parent Loop BB2_10 Depth=1
                                        ;     Parent Loop BB2_25 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	add	w13, w13, #1
	ldr	x11, [x11]
	cbnz	x11, LBB2_27
; %bb.28:                               ;   in Loop: Header=BB2_25 Depth=2
	tbnz	w8, #31, LBB2_39
; %bb.29:                               ;   in Loop: Header=BB2_25 Depth=2
	mov	x11, #0                         ; =0x0
	mov	w12, w8
	sdiv	w13, w13, w10
	b	LBB2_31
LBB2_30:                                ;   in Loop: Header=BB2_31 Depth=3
	add	x11, x11, #1
	cmp	x11, x10
	b.eq	LBB2_39
LBB2_31:                                ;   Parent Loop BB2_10 Depth=1
                                        ;     Parent Loop BB2_25 Depth=2
                                        ; =>    This Loop Header: Depth=3
                                        ;         Child Loop BB2_34 Depth 4
	str	x9, [x20, x11, lsl #3]
	cbz	x9, LBB2_30
; %bb.32:                               ;   in Loop: Header=BB2_31 Depth=3
	str	xzr, [x9, #8]
	mov	w14, #1                         ; =0x1
	b	LBB2_34
LBB2_33:                                ;   in Loop: Header=BB2_34 Depth=4
	add	w14, w14, #1
	cbz	x9, LBB2_30
LBB2_34:                                ;   Parent Loop BB2_10 Depth=1
                                        ;     Parent Loop BB2_25 Depth=2
                                        ;       Parent Loop BB2_31 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	ldr	x9, [x9]
	cmp	x11, x12
	b.eq	LBB2_33
; %bb.35:                               ;   in Loop: Header=BB2_34 Depth=4
	cmp	w14, w13
	b.lt	LBB2_33
; %bb.36:                               ;   in Loop: Header=BB2_31 Depth=3
	cbz	x9, LBB2_30
; %bb.37:                               ;   in Loop: Header=BB2_31 Depth=3
	ldr	x14, [x9, #8]
	cbz	x14, LBB2_30
; %bb.38:                               ;   in Loop: Header=BB2_31 Depth=3
	str	xzr, [x14]
	b	LBB2_30
LBB2_39:                                ;   in Loop: Header=BB2_25 Depth=2
	mov	x9, #0                          ; =0x0
LBB2_40:                                ;   Parent Loop BB2_10 Depth=1
                                        ;     Parent Loop BB2_25 Depth=2
                                        ; =>    This Loop Header: Depth=3
                                        ;         Child Loop BB2_44 Depth 4
                                        ;         Child Loop BB2_50 Depth 4
                                        ;           Child Loop BB2_54 Depth 5
                                        ;         Child Loop BB2_62 Depth 4
	mov	x26, x9
	ldr	x9, [sp, #104]                  ; 8-byte Folded Reload
	ldrsw	x27, [x9, x26, lsl #2]
	ldr	x9, [x22]
	cbz	x9, LBB2_61
; %bb.41:                               ;   in Loop: Header=BB2_40 Depth=3
	add	w8, w8, #1
	add	w9, w27, #1
	sdiv	w10, w9, w8
	msub	w9, w10, w8, w9
	ldr	x10, [x20, w9, sxtw #3]
	cbz	x10, LBB2_61
; %bb.42:                               ;   in Loop: Header=BB2_40 Depth=3
	ldr	x11, [x20, x27, lsl #3]
	cbz	x11, LBB2_44
; %bb.43:                               ;   in Loop: Header=BB2_40 Depth=3
	str	xzr, [x11, #8]
LBB2_44:                                ;   Parent Loop BB2_10 Depth=1
                                        ;     Parent Loop BB2_25 Depth=2
                                        ;       Parent Loop BB2_40 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	cbz	x11, LBB2_47
; %bb.45:                               ;   in Loop: Header=BB2_44 Depth=4
	mov	x12, x11
	ldr	x11, [x11]
	cmp	x11, #0
	ccmp	x11, x10, #4, ne
	b.ne	LBB2_44
; %bb.46:                               ;   in Loop: Header=BB2_40 Depth=3
	str	xzr, [x12]
LBB2_47:                                ;   in Loop: Header=BB2_40 Depth=3
	str	x10, [x22]
	str	xzr, [x10, #8]
	cmp	w9, w27
	b.eq	LBB2_60
; %bb.48:                               ;   in Loop: Header=BB2_40 Depth=3
	mov	x11, x10
	b	LBB2_50
LBB2_49:                                ;   in Loop: Header=BB2_50 Depth=4
	cmp	w9, w27
	b.eq	LBB2_59
LBB2_50:                                ;   Parent Loop BB2_10 Depth=1
                                        ;     Parent Loop BB2_25 Depth=2
                                        ;       Parent Loop BB2_40 Depth=3
                                        ; =>      This Loop Header: Depth=4
                                        ;           Child Loop BB2_54 Depth 5
	cbz	x10, LBB2_59
; %bb.51:                               ;   in Loop: Header=BB2_50 Depth=4
	add	w9, w9, #1
	sdiv	w10, w9, w8
	msub	w9, w10, w8, w9
	sxtw	x10, w9
	cbz	x11, LBB2_57
; %bb.52:                               ;   in Loop: Header=BB2_50 Depth=4
	ldr	x12, [x20, x10, lsl #3]
	ldr	x13, [x11]
	cbz	x13, LBB2_55
; %bb.53:                               ;   in Loop: Header=BB2_50 Depth=4
	cmp	x13, x12
	b.eq	LBB2_55
LBB2_54:                                ;   Parent Loop BB2_10 Depth=1
                                        ;     Parent Loop BB2_25 Depth=2
                                        ;       Parent Loop BB2_40 Depth=3
                                        ;         Parent Loop BB2_50 Depth=4
                                        ; =>        This Inner Loop Header: Depth=5
	mov	x14, x13
	str	x11, [x13, #8]
	ldr	x13, [x13]
	cmp	x13, #0
	ccmp	x13, x12, #4, ne
	mov	x11, x14
	b.ne	LBB2_54
	b	LBB2_56
LBB2_55:                                ;   in Loop: Header=BB2_50 Depth=4
	mov	x14, x11
LBB2_56:                                ;   in Loop: Header=BB2_50 Depth=4
	str	x12, [x14]
	mov	x11, x14
LBB2_57:                                ;   in Loop: Header=BB2_50 Depth=4
	ldr	x10, [x20, x10, lsl #3]
	cbz	x10, LBB2_49
; %bb.58:                               ;   in Loop: Header=BB2_50 Depth=4
	str	x11, [x10, #8]
	b	LBB2_49
LBB2_59:                                ;   in Loop: Header=BB2_40 Depth=3
	mov	x10, x11
	cbz	x11, LBB2_61
LBB2_60:                                ;   in Loop: Header=BB2_40 Depth=3
	str	xzr, [x10]
LBB2_61:                                ;   in Loop: Header=BB2_40 Depth=3
	mov	w21, #0                         ; =0x0
	mov	x28, x22
	ldr	x25, [x22]
	mov	w22, #50                        ; =0x32
LBB2_62:                                ;   Parent Loop BB2_10 Depth=1
                                        ;     Parent Loop BB2_25 Depth=2
                                        ;       Parent Loop BB2_40 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	; InlineAsm Start
	ldr	x10, [x19]
	; InlineAsm End
	; InlineAsm Start
	ldr	x10, [x19]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x8, [x23, _traverser@PAGEOFF]
	mov	x0, x25
	blr	x8
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	w8, [x24]
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
	ldr	w9, [x24]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	sub	w8, w9, w8
	cmp	w8, #800
	csel	w8, w8, wzr, lo
	add	w21, w8, w21
	subs	w22, w22, #1
	b.ne	LBB2_62
; %bb.63:                               ;   in Loop: Header=BB2_40 Depth=3
	add	x9, x26, #1
	ucvtf	s0, w21
	mov	w8, #1112014848                 ; =0x42480000
	fmov	s1, w8
	fdiv	s0, s0, s1
	fcvtzs	w8, s0
	sxtw	x10, w8
Lloh24:
	adrp	x8, _threshold@PAGE
Lloh25:
	ldr	x11, [x8, _threshold@PAGEOFF]
Lloh26:
	adrp	x8, _evset_size@PAGE
Lloh27:
	ldr	w8, [x8, _evset_size@PAGEOFF]
	sxtw	x12, w8
	cmp	x11, x10
	ccmp	x26, x12, #0, hs
	mov	x22, x28
	movi.4s	v4, #4
	movi.4s	v5, #8
	movi.4s	v6, #12
	movi.4s	v7, #16
	b.lt	LBB2_40
; %bb.64:                               ;   in Loop: Header=BB2_25 Depth=2
	cmp	x11, x10
	ccmp	x26, x12, #0, lo
	b.ge	LBB2_68
; %bb.65:                               ;   in Loop: Header=BB2_25 Depth=2
	ldr	x9, [x20, x27, lsl #3]
	ldp	x10, x11, [sp, #88]             ; 16-byte Folded Reload
	str	x9, [x10, x11, lsl #3]
	ldr	x9, [x22]
	cbz	x9, LBB2_23
; %bb.66:                               ;   in Loop: Header=BB2_25 Depth=2
	mov	w13, #0                         ; =0x0
	mov	x10, x9
	ldr	x27, [sp, #104]                 ; 8-byte Folded Reload
LBB2_67:                                ;   Parent Loop BB2_10 Depth=1
                                        ;     Parent Loop BB2_25 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	add	w13, w13, #1
	ldr	x10, [x10]
	cbnz	x10, LBB2_67
	b	LBB2_24
LBB2_68:                                ;   in Loop: Header=BB2_10 Depth=1
	ldr	x9, [x20, x27, lsl #3]
	ldr	x10, [x22]
	ldr	x12, [sp, #96]                  ; 8-byte Folded Reload
	subs	w25, w12, #1
	ldr	w13, [sp, #84]                  ; 4-byte Folded Reload
	b.lt	LBB2_88
; %bb.69:                               ;   in Loop: Header=BB2_10 Depth=1
	ldr	x27, [sp, #104]                 ; 8-byte Folded Reload
	cbz	x10, LBB2_73
LBB2_70:                                ;   Parent Loop BB2_10 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x11, x10
	ldr	x10, [x10]
	cbnz	x10, LBB2_70
; %bb.71:                               ;   in Loop: Header=BB2_10 Depth=1
	str	x9, [x11]
	cbz	x9, LBB2_74
; %bb.72:                               ;   in Loop: Header=BB2_10 Depth=1
	str	x11, [x9, #8]
	b	LBB2_74
LBB2_73:                                ;   in Loop: Header=BB2_10 Depth=1
	str	x9, [x22]
LBB2_74:                                ;   in Loop: Header=BB2_10 Depth=1
	ldr	x9, [sp, #88]                   ; 8-byte Folded Reload
	ldr	x9, [x9, w25, uxtw #3]
	ldr	x11, [x22]
	cbz	x11, LBB2_79
LBB2_75:                                ;   Parent Loop BB2_10 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x10, x11
	ldr	x11, [x11]
	cbnz	x11, LBB2_75
; %bb.76:                               ;   in Loop: Header=BB2_10 Depth=1
	str	x9, [x10]
	cbz	x9, LBB2_78
; %bb.77:                               ;   in Loop: Header=BB2_10 Depth=1
	str	x10, [x9, #8]
LBB2_78:                                ;   in Loop: Header=BB2_10 Depth=1
	ldr	x9, [x22]
	b	LBB2_80
LBB2_79:                                ;   in Loop: Header=BB2_10 Depth=1
	str	x9, [x22]
LBB2_80:                                ;   in Loop: Header=BB2_10 Depth=1
	ldr	x10, [sp, #88]                  ; 8-byte Folded Reload
	str	xzr, [x10, x25, lsl #3]
	mov	w13, #0                         ; =0x0
	cbz	x9, LBB2_82
LBB2_81:                                ;   Parent Loop BB2_10 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	w13, w13, #1
	ldr	x9, [x9]
	cbnz	x9, LBB2_81
LBB2_82:                                ;   in Loop: Header=BB2_10 Depth=1
	cmp	w12, #1
	b.le	LBB2_93
; %bb.83:                               ;   in Loop: Header=BB2_10 Depth=1
	ldr	w10, [sp, #80]                  ; 4-byte Folded Reload
	add	w9, w10, #1
	cmp	w10, #50
	str	w9, [sp, #80]                   ; 4-byte Folded Spill
	b.lo	LBB2_10
	b	LBB2_93
LBB2_84:
	mov	w8, #0                          ; =0x0
	cbz	x23, LBB2_86
LBB2_85:                                ; =>This Inner Loop Header: Depth=1
	add	w8, w8, #1
	ldr	x23, [x23]
	cbnz	x23, LBB2_85
LBB2_86:
	str	x8, [sp, #24]
	stp	d8, d9, [sp, #8]
	str	x24, [sp]
Lloh28:
	adrp	x0, l_.str.9@PAGE
Lloh29:
	add	x0, x0, l_.str.9@PAGEOFF
	bl	_printf
	mov	x0, x20
	bl	_free
	mov	x0, x27
LBB2_87:
	bl	_free
	b	LBB2_106
LBB2_88:
	ldr	x27, [sp, #104]                 ; 8-byte Folded Reload
	cbz	x10, LBB2_92
LBB2_89:                                ; =>This Inner Loop Header: Depth=1
	mov	x8, x10
	ldr	x10, [x10]
	cbnz	x10, LBB2_89
; %bb.90:
	str	x9, [x8]
	cbz	x9, LBB2_93
; %bb.91:
	str	x8, [x9, #8]
	b	LBB2_93
LBB2_92:
	str	x9, [x22]
LBB2_93:
	mov	x25, x13
	ldp	x8, x13, [sp, #64]              ; 16-byte Folded Reload
	cmp	w8, #1
	b.lt	LBB2_102
; %bb.94:
	mov	x8, #0                          ; =0x0
	ldr	x9, [sp, #56]                   ; 8-byte Folded Reload
	cmp	w9, #1
	csinc	w9, w9, wzr, gt
	b	LBB2_97
LBB2_95:                                ;   in Loop: Header=BB2_97 Depth=1
	str	x10, [x13]
LBB2_96:                                ;   in Loop: Header=BB2_97 Depth=1
	add	x8, x8, #1
	cmp	x8, x9
	b.eq	LBB2_102
LBB2_97:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB2_99 Depth 2
	ldr	x10, [sp, #88]                  ; 8-byte Folded Reload
	ldr	x10, [x10, x8, lsl #3]
	cbz	x13, LBB2_95
; %bb.98:                               ;   in Loop: Header=BB2_97 Depth=1
	ldr	x12, [x13]
	cbz	x12, LBB2_95
LBB2_99:                                ;   Parent Loop BB2_97 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x11, x12
	ldr	x12, [x12]
	cbnz	x12, LBB2_99
; %bb.100:                              ;   in Loop: Header=BB2_97 Depth=1
	str	x10, [x11]
	cbz	x10, LBB2_96
; %bb.101:                              ;   in Loop: Header=BB2_97 Depth=1
	str	x11, [x10, #8]
	b	LBB2_96
LBB2_102:
	mov	x0, x20
	bl	_free
	mov	x0, x27
	bl	_free
	ldr	x0, [sp, #88]                   ; 8-byte Folded Reload
	bl	_free
	mov	w21, #0                         ; =0x0
	ldr	x20, [x22]
	mov	w22, #50                        ; =0x32
LBB2_103:                               ; =>This Inner Loop Header: Depth=1
	; InlineAsm Start
	ldr	x10, [x19]
	; InlineAsm End
	; InlineAsm Start
	ldr	x10, [x19]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x8, [x23, _traverser@PAGEOFF]
	mov	x0, x20
	blr	x8
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	w8, [x24]
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
	ldr	w9, [x24]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	sub	w8, w9, w8
	cmp	w8, #800
	csel	w8, w8, wzr, lo
	add	w21, w8, w21
	subs	w22, w22, #1
	b.ne	LBB2_103
; %bb.104:
	ucvtf	s0, w21
	mov	w8, #1112014848                 ; =0x42480000
	fmov	s1, w8
	fdiv	s0, s0, s1
	fcvtzs	w8, s0
Lloh30:
	adrp	x9, _threshold@PAGE
Lloh31:
	ldr	x9, [x9, _threshold@PAGEOFF]
	cmp	x9, w8, sxtw
	b.hs	LBB2_106
; %bb.105:
Lloh32:
	adrp	x8, _evset_size@PAGE
Lloh33:
	ldr	w8, [x8, _evset_size@PAGEOFF]
	cmp	w25, w8
	cset	w0, gt
	b	LBB2_107
LBB2_106:
	mov	w0, #1                          ; =0x1
LBB2_107:
	ldp	x29, x30, [sp, #224]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #208]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #192]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #176]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #160]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #144]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #128]              ; 16-byte Folded Reload
	ldp	d11, d10, [sp, #112]            ; 16-byte Folded Reload
	add	sp, sp, #240
	ret
	.loh AdrpLdr	Lloh12, Lloh13
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpLdrGot	Lloh20, Lloh21
	.loh AdrpLdr	Lloh18, Lloh19
	.loh AdrpLdr	Lloh22, Lloh23
	.loh AdrpLdr	Lloh26, Lloh27
	.loh AdrpAdrp	Lloh24, Lloh26
	.loh AdrpLdr	Lloh24, Lloh25
	.loh AdrpAdd	Lloh28, Lloh29
	.loh AdrpLdr	Lloh30, Lloh31
	.loh AdrpLdr	Lloh32, Lloh33
	.cfi_endproc
                                        ; -- End function
	.globl	_cache_remove                   ; -- Begin function cache_remove
	.p2align	2
_cache_remove:                          ; @cache_remove
	.cfi_startproc
; %bb.0:
Lloh34:
	adrp	x8, _traverser@PAGE
Lloh35:
	ldr	x1, [x8, _traverser@PAGEOFF]
Lloh36:
	adrp	x8, _eviction_sets@PAGE
Lloh37:
	ldr	x8, [x8, _eviction_sets@PAGEOFF]
	ldr	x0, [x8, w0, uxtw #3]
	br	x1
	.loh AdrpLdr	Lloh36, Lloh37
	.loh AdrpAdrp	Lloh34, Lloh36
	.loh AdrpLdr	Lloh34, Lloh35
	.cfi_endproc
                                        ; -- End function
	.globl	_probe_cache_miss               ; -- Begin function probe_cache_miss
	.p2align	2
_probe_cache_miss:                      ; @probe_cache_miss
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
	mov	w20, #46339                     ; =0xb503
	movk	w20, #42366, lsl #16
	mov	w21, #99                        ; =0x63
Lloh38:
	adrp	x22, _timestamp@GOTPAGE
Lloh39:
	ldr	x22, [x22, _timestamp@GOTPAGEOFF]
LBB4_1:                                 ; =>This Inner Loop Header: Depth=1
	mov	w0, #1638400                    ; =0x190000
	bl	_malloc
	mov	x19, x0
	bl	_rand
	smull	x8, w0, w20
	lsr	x8, x8, #32
	add	w8, w8, w0
	lsr	w9, w8, #6
	add	w8, w9, w8, lsr #31
	msub	w8, w8, w21, w0
	lsl	w8, w8, #14
	add	x23, x19, w8, sxtw
	bl	_rand
	negs	w8, w0
	and	w8, w8, #0x1fff
	and	w9, w0, #0x1fff
	csneg	w8, w9, w8, mi
	add	x8, x23, w8, sxtw
	; InlineAsm Start
	ldr	x10, [x8]
	; InlineAsm End
	bl	_rand
	negs	w8, w0
	and	w8, w8, #0x3fff
	and	w9, w0, #0x3fff
	csneg	w8, w9, w8, mi
	and	w9, w8, #0x8000
	add	w8, w8, w9, lsr #15
	sbfx	w8, w8, #1, #15
	add	x8, x23, w8, sxtw
	add	x8, x8, #2, lsl #12             ; =8192
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x23, [x22]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	; InlineAsm Start
	ldr	x10, [x8]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x24, [x22]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	mov	x0, x19
	bl	_free
	subs	x0, x24, x23
	b.eq	LBB4_1
; %bb.2:
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp], #64             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh38, Lloh39
	.cfi_endproc
                                        ; -- End function
	.globl	_probe_cache_hit                ; -- Begin function probe_cache_hit
	.p2align	2
_probe_cache_hit:                       ; @probe_cache_hit
	.cfi_startproc
; %bb.0:
	stp	x22, x21, [sp, #-48]!           ; 16-byte Folded Spill
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
Lloh40:
	adrp	x19, _timestamp@GOTPAGE
Lloh41:
	ldr	x19, [x19, _timestamp@GOTPAGEOFF]
LBB5_1:                                 ; =>This Inner Loop Header: Depth=1
	mov	w0, #16384                      ; =0x4000
	bl	_malloc
	add	x8, x0, #1024
	; InlineAsm Start
	ldr	x10, [x8]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x20, [x19]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	; InlineAsm Start
	ldr	x10, [x8]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x21, [x19]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	bl	_free
	subs	x0, x21, x20
	b.eq	LBB5_1
; %bb.2:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh40, Lloh41
	.cfi_endproc
                                        ; -- End function
	.globl	_find_threshold                 ; -- Begin function find_threshold
	.p2align	2
_find_threshold:                        ; @find_threshold
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #96
	stp	x24, x23, [sp, #32]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #48]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #64]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #80]             ; 16-byte Folded Spill
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	mov	x19, #0                         ; =0x0
	mov	w20, #1000                      ; =0x3e8
LBB6_1:                                 ; =>This Inner Loop Header: Depth=1
	bl	_probe_cache_miss
	add	x19, x0, x19
	subs	w20, w20, #1
	b.ne	LBB6_1
; %bb.2:
	mov	w21, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
Lloh42:
	adrp	x22, _timestamp@GOTPAGE
Lloh43:
	ldr	x22, [x22, _timestamp@GOTPAGEOFF]
LBB6_3:                                 ; =>This Inner Loop Header: Depth=1
	mov	w0, #16384                      ; =0x4000
	bl	_malloc
	add	x8, x0, #1024
	; InlineAsm Start
	ldr	x10, [x8]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x23, [x22]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	; InlineAsm Start
	ldr	x10, [x8]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x24, [x22]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	bl	_free
	cmp	x24, x23
	b.eq	LBB6_3
; %bb.4:                                ;   in Loop: Header=BB6_3 Depth=1
	sub	x8, x20, x23
	add	x20, x8, x24
	add	w21, w21, #1
	cmp	w21, #1000
	b.ne	LBB6_3
; %bb.5:
	lsr	x8, x19, #3
	mov	x9, #63439                      ; =0xf7cf
	movk	x9, #58195, lsl #16
	movk	x9, #39845, lsl #32
	movk	x9, #8388, lsl #48
	umulh	x8, x8, x9
	lsr	x8, x8, #4
	lsr	x10, x20, #3
	umulh	x9, x10, x9
	lsr	x9, x9, #4
	add	x10, x19, x19, lsl #1
	add	x10, x20, x10
	lsr	x10, x10, #5
	mov	x11, #16253                     ; =0x3f7d
	movk	x11, #24117, lsl #16
	movk	x11, #18874, lsl #32
	movk	x11, #524, lsl #48
	umulh	x19, x10, x11
	stp	x8, x9, [sp]
	str	x19, [sp, #16]
Lloh44:
	adrp	x0, l_.str.5@PAGE
Lloh45:
	add	x0, x0, l_.str.5@PAGEOFF
	bl	_printf
	mov	x0, x19
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #96
	ret
	.loh AdrpLdrGot	Lloh42, Lloh43
	.loh AdrpAdd	Lloh44, Lloh45
	.cfi_endproc
                                        ; -- End function
	.globl	_cache_remove_prepare           ; -- Begin function cache_remove_prepare
	.p2align	2
_cache_remove_prepare:                  ; @cache_remove_prepare
	.cfi_startproc
; %bb.0:
	stp	x26, x25, [sp, #-80]!           ; 16-byte Folded Spill
	stp	x24, x23, [sp, #16]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #32]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #48]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #64]             ; 16-byte Folded Spill
	add	x29, sp, #64
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
	mov	x19, x0
Lloh46:
	adrp	x8, _cache_line_size@PAGE
Lloh47:
	ldr	x8, [x8, _cache_line_size@PAGEOFF]
	cmp	x8, #63
	b.hi	LBB7_2
; %bb.1:
Lloh48:
	adrp	x0, l_str.16@PAGE
Lloh49:
	add	x0, x0, l_str.16@PAGEOFF
	bl	_puts
LBB7_2:
	adrp	x21, _eviction_sets@PAGE
	ldr	x8, [x21, _eviction_sets@PAGEOFF]
	cbnz	x8, LBB7_4
; %bb.3:
Lloh50:
	adrp	x0, _traverse_list_skylake@PAGE
Lloh51:
	add	x0, x0, _traverse_list_skylake@PAGEOFF
	mov	w1, #32                         ; =0x20
	mov	w2, #16384                      ; =0x4000
	mov	w3, #33554432                   ; =0x2000000
	mov	w4, #220                        ; =0xdc
	bl	_evset_init
LBB7_4:
	bl	_timer_start
	adrp	x22, _evsets_count@PAGE
	ldr	w8, [x22, _evsets_count@PAGEOFF]
	cbz	w8, LBB7_9
; %bb.5:
	mov	x20, #0                         ; =0x0
	adrp	x24, _traverser@PAGE
Lloh52:
	adrp	x25, _timestamp@GOTPAGE
Lloh53:
	ldr	x25, [x25, _timestamp@GOTPAGEOFF]
	adrp	x26, _threshold@PAGE
LBB7_6:                                 ; =>This Inner Loop Header: Depth=1
	; InlineAsm Start
	ldr	x10, [x19]
	; InlineAsm End
	; InlineAsm Start
	ldr	x10, [x19]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x8, [x24, _traverser@PAGEOFF]
	ldr	x9, [x21, _eviction_sets@PAGEOFF]
	lsl	x23, x20, #3
	ldr	x0, [x9, x23]
	blr	x8
	ldr	x8, [x24, _traverser@PAGEOFF]
	ldr	x9, [x21, _eviction_sets@PAGEOFF]
	ldr	x0, [x9, x23]
	blr	x8
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x8, [x25]
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
	ldr	x9, [x25]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x10, [x26, _threshold@PAGEOFF]
	sub	x8, x9, x8
	cmp	x8, x10
	b.hi	LBB7_12
; %bb.7:                                ;   in Loop: Header=BB7_6 Depth=1
	add	x20, x20, #1
	ldr	w8, [x22, _evsets_count@PAGEOFF]
	sxtw	x23, w8
	cmp	x20, x23
	b.lo	LBB7_6
; %bb.8:
	add	w9, w8, #1
	str	w9, [x22, _evsets_count@PAGEOFF]
	and	w9, w9, #0x80000007
	cmp	w9, #1
	b.eq	LBB7_10
	b	LBB7_11
LBB7_9:
	mov	x23, #0                         ; =0x0
	mov	w9, #1                          ; =0x1
	str	w9, [x22, _evsets_count@PAGEOFF]
LBB7_10:
	ldr	x0, [x21, _eviction_sets@PAGEOFF]
	add	w8, w8, #9
	sbfiz	x1, x8, #3, #32
	bl	_realloc
	str	x0, [x21, _eviction_sets@PAGEOFF]
	adrp	x20, _eviction_sets_pages@PAGE
	ldr	x0, [x20, _eviction_sets_pages@PAGEOFF]
	ldrsw	x8, [x22, _evsets_count@PAGEOFF]
	lsl	x8, x8, #3
	add	x1, x8, #64
	bl	_realloc
	str	x0, [x20, _eviction_sets_pages@PAGEOFF]
LBB7_11:
	mov	x0, x19
	bl	_evset_find
	bl	_timer_stop
	mov	x20, x23
LBB7_12:
	mov	x0, x20
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp], #80             ; 16-byte Folded Reload
	ret
	.loh AdrpLdr	Lloh46, Lloh47
	.loh AdrpAdd	Lloh48, Lloh49
	.loh AdrpAdd	Lloh50, Lloh51
	.loh AdrpLdrGot	Lloh52, Lloh53
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function traverse_list_skylake
_traverse_list_skylake:                 ; @traverse_list_skylake
	.cfi_startproc
; %bb.0:
	cbz	x0, LBB8_4
LBB8_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x0]
	cbz	x8, LBB8_4
; %bb.2:                                ;   in Loop: Header=BB8_1 Depth=1
	ldr	x8, [x8]
	cbz	x8, LBB8_4
; %bb.3:                                ;   in Loop: Header=BB8_1 Depth=1
	; InlineAsm Start
	ldr	x10, [x0]
	; InlineAsm End
	ldr	x8, [x0]
	; InlineAsm Start
	ldr	x10, [x8]
	; InlineAsm End
	ldr	x8, [x0]
	ldr	x8, [x8]
	; InlineAsm Start
	ldr	x10, [x8]
	; InlineAsm End
	; InlineAsm Start
	ldr	x10, [x0]
	; InlineAsm End
	ldr	x8, [x0]
	; InlineAsm Start
	ldr	x10, [x8]
	; InlineAsm End
	ldr	x8, [x0]
	ldr	x8, [x8]
	; InlineAsm Start
	ldr	x10, [x8]
	; InlineAsm End
	ldr	x0, [x0]
	cbnz	x0, LBB8_1
LBB8_4:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_list_length                    ; -- Begin function list_length
	.p2align	2
_list_length:                           ; @list_length
	.cfi_startproc
; %bb.0:
	mov	w8, #0                          ; =0x0
	cbz	x0, LBB9_2
LBB9_1:                                 ; =>This Inner Loop Header: Depth=1
	add	w8, w8, #1
	ldr	x0, [x0]
	cbnz	x0, LBB9_1
LBB9_2:
	mov	x0, x8
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_list_concat                    ; -- Begin function list_concat
	.p2align	2
_list_concat:                           ; @list_concat
	.cfi_startproc
; %bb.0:
	cbz	x0, LBB10_6
; %bb.1:
	ldr	x8, [x0]
	cbz	x8, LBB10_6
LBB10_2:                                ; =>This Inner Loop Header: Depth=1
	mov	x9, x8
	ldr	x8, [x8]
	cbnz	x8, LBB10_2
; %bb.3:
	str	x1, [x9]
	cbz	x1, LBB10_5
; %bb.4:
	str	x9, [x1, #8]
LBB10_5:
	ret
LBB10_6:
	str	x1, [x0]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_list_split                     ; -- Begin function list_split
	.p2align	2
_list_split:                            ; @list_split
	.cfi_startproc
; %bb.0:
	cbz	x0, LBB11_14
; %bb.1:
	mov	w11, #0                         ; =0x0
	mov	x8, x0
LBB11_2:                                ; =>This Inner Loop Header: Depth=1
	add	w11, w11, #1
	ldr	x8, [x8]
	cbnz	x8, LBB11_2
; %bb.3:
	subs	w8, w2, #1
	b.lt	LBB11_14
; %bb.4:
	mov	x9, #0                          ; =0x0
	mov	w10, w2
	sdiv	w11, w11, w2
	b	LBB11_6
LBB11_5:                                ;   in Loop: Header=BB11_6 Depth=1
	add	x9, x9, #1
	cmp	x9, x10
	b.eq	LBB11_14
LBB11_6:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB11_9 Depth 2
	str	x0, [x1, x9, lsl #3]
	cbz	x0, LBB11_5
; %bb.7:                                ;   in Loop: Header=BB11_6 Depth=1
	str	xzr, [x0, #8]
	mov	w12, #1                         ; =0x1
	b	LBB11_9
LBB11_8:                                ;   in Loop: Header=BB11_9 Depth=2
	add	w12, w12, #1
	cbz	x0, LBB11_5
LBB11_9:                                ;   Parent Loop BB11_6 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x0, [x0]
	cmp	w12, w11
	b.lt	LBB11_8
; %bb.10:                               ;   in Loop: Header=BB11_9 Depth=2
	cmp	x9, x8
	b.eq	LBB11_8
; %bb.11:                               ;   in Loop: Header=BB11_6 Depth=1
	cbz	x0, LBB11_5
; %bb.12:                               ;   in Loop: Header=BB11_6 Depth=1
	ldr	x12, [x0, #8]
	cbz	x12, LBB11_5
; %bb.13:                               ;   in Loop: Header=BB11_6 Depth=1
	str	xzr, [x12]
	b	LBB11_5
LBB11_14:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_list_from_chunks               ; -- Begin function list_from_chunks
	.p2align	2
_list_from_chunks:                      ; @list_from_chunks
	.cfi_startproc
; %bb.0:
	cbz	x1, LBB12_15
; %bb.1:
	ldr	x8, [x0]
	cbz	x8, LBB12_15
; %bb.2:
	add	w8, w2, #1
	sdiv	w9, w8, w3
	msub	w9, w9, w3, w8
	ldr	x8, [x1, w9, sxtw #3]
	cbz	x8, LBB12_15
; %bb.3:
	ldr	x10, [x1, w2, sxtw #3]
	cbz	x10, LBB12_5
; %bb.4:
	str	xzr, [x10, #8]
LBB12_5:
	sxtw	x8, w9
LBB12_6:                                ; =>This Inner Loop Header: Depth=1
	cbz	x10, LBB12_10
; %bb.7:                                ;   in Loop: Header=BB12_6 Depth=1
	mov	x11, x10
	ldr	x10, [x10]
	cbz	x10, LBB12_9
; %bb.8:                                ;   in Loop: Header=BB12_6 Depth=1
	ldr	x12, [x1, x8, lsl #3]
	cmp	x10, x12
	b.ne	LBB12_6
LBB12_9:
	str	xzr, [x11]
LBB12_10:
	ldr	x8, [x1, x8, lsl #3]
	str	x8, [x0]
	cbz	x8, LBB12_12
; %bb.11:
	str	xzr, [x8, #8]
LBB12_12:
	cmp	w9, w2
	b.ne	LBB12_16
LBB12_13:
	cbz	x8, LBB12_15
; %bb.14:
	str	xzr, [x8]
LBB12_15:
	ret
LBB12_16:
                                        ; kill: def $w9 killed $w9 killed $x9 def $x9
	b	LBB12_18
LBB12_17:                               ;   in Loop: Header=BB12_18 Depth=1
	cmp	w9, w2
	b.eq	LBB12_13
LBB12_18:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB12_22 Depth 2
	ldr	x10, [x1, w9, sxtw #3]
	cbz	x10, LBB12_13
; %bb.19:                               ;   in Loop: Header=BB12_18 Depth=1
	add	w9, w9, #1
	sdiv	w10, w9, w3
	msub	w9, w10, w3, w9
	sxtw	x10, w9
	cbz	x8, LBB12_24
; %bb.20:                               ;   in Loop: Header=BB12_18 Depth=1
	ldr	x12, [x8]
	ldr	x11, [x1, x10, lsl #3]
	cbz	x12, LBB12_23
; %bb.21:                               ;   in Loop: Header=BB12_18 Depth=1
	cmp	x12, x11
	b.eq	LBB12_23
LBB12_22:                               ;   Parent Loop BB12_18 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x11, x8
	mov	x8, x12
	str	x11, [x12, #8]
	ldr	x12, [x12]
	ldr	x11, [x1, x10, lsl #3]
	cmp	x12, #0
	ccmp	x12, x11, #4, ne
	b.ne	LBB12_22
LBB12_23:                               ;   in Loop: Header=BB12_18 Depth=1
	str	x11, [x8]
LBB12_24:                               ;   in Loop: Header=BB12_18 Depth=1
	ldr	x10, [x1, x10, lsl #3]
	cbz	x10, LBB12_17
; %bb.25:                               ;   in Loop: Header=BB12_18 Depth=1
	str	x8, [x10, #8]
	b	LBB12_17
	.cfi_endproc
                                        ; -- End function
	.globl	_shuffle                        ; -- Begin function shuffle
	.p2align	2
_shuffle:                               ; @shuffle
	.cfi_startproc
; %bb.0:
	cmp	x1, #2
	b.lo	LBB13_4
; %bb.1:
	stp	x22, x21, [sp, #-48]!           ; 16-byte Folded Spill
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	mov	x19, x1
	mov	x20, x0
	mov	x21, #0                         ; =0x0
	mov	w22, #2147483647                ; =0x7fffffff
LBB13_2:                                ; =>This Inner Loop Header: Depth=1
	bl	_rand
                                        ; kill: def $w0 killed $w0 def $x0
	sxtw	x8, w0
	udiv	x9, x22, x19
	add	x9, x9, #1
	udiv	x8, x8, x9
	add	x8, x8, x21
	lsl	x8, x8, #2
	ldr	w9, [x20, x8]
	lsl	x10, x21, #2
	ldr	w11, [x20, x10]
	str	w11, [x20, x8]
	str	w9, [x20, x10]
	add	x21, x21, #1
	sub	x19, x19, #1
	cmp	x19, #1
	b.ne	LBB13_2
; %bb.3:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
LBB13_4:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_test_set                       ; -- Begin function test_set
	.p2align	2
_test_set:                              ; @test_set
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
	mov	x19, x1
	; InlineAsm Start
	ldr	x10, [x1]
	; InlineAsm End
	; InlineAsm Start
	ldr	x10, [x1]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
Lloh54:
	adrp	x8, _traverser@PAGE
Lloh55:
	ldr	x8, [x8, _traverser@PAGEOFF]
	blr	x8
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
Lloh56:
	adrp	x8, _timestamp@GOTPAGE
Lloh57:
	ldr	x8, [x8, _timestamp@GOTPAGEOFF]
	ldr	w9, [x8]
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
	ldr	w8, [x8]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	sub	w0, w8, w9
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh56, Lloh57
	.loh AdrpLdr	Lloh54, Lloh55
	.cfi_endproc
                                        ; -- End function
	.globl	_tests_avg                      ; -- Begin function tests_avg
	.p2align	2
_tests_avg:                             ; @tests_avg
	.cfi_startproc
; %bb.0:
	stp	x26, x25, [sp, #-80]!           ; 16-byte Folded Spill
	stp	x24, x23, [sp, #16]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #32]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #48]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #64]             ; 16-byte Folded Spill
	add	x29, sp, #64
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
	mov	x19, x2
	cmp	w2, #1
	b.lt	LBB15_4
; %bb.1:
	mov	x20, x1
	mov	x21, x0
	mov	w22, #0                         ; =0x0
	adrp	x23, _traverser@PAGE
Lloh58:
	adrp	x24, _timestamp@GOTPAGE
Lloh59:
	ldr	x24, [x24, _timestamp@GOTPAGEOFF]
	mov	x25, x19
LBB15_2:                                ; =>This Inner Loop Header: Depth=1
	; InlineAsm Start
	ldr	x10, [x20]
	; InlineAsm End
	; InlineAsm Start
	ldr	x10, [x20]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	x8, [x23, _traverser@PAGEOFF]
	mov	x0, x21
	blr	x8
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	w8, [x24]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	; InlineAsm Start
	ldr	x10, [x20]
	; InlineAsm End
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	ldr	w9, [x24]
	; InlineAsm Start
	dmb	sy
	isb
	; InlineAsm End
	sub	w8, w9, w8
	cmp	w8, #800
	csel	w8, w8, wzr, lo
	add	w22, w8, w22
	subs	w25, w25, #1
	b.ne	LBB15_2
; %bb.3:
	ucvtf	s0, w22
	b	LBB15_5
LBB15_4:
	movi	d0, #0000000000000000
LBB15_5:
	scvtf	s1, w19
	fdiv	s0, s0, s1
	fcvtzs	w8, s0
Lloh60:
	adrp	x9, _threshold@PAGE
Lloh61:
	ldr	x9, [x9, _threshold@PAGEOFF]
	cmp	x9, w8, sxtw
	cset	w0, lo
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp], #80             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh58, Lloh59
	.loh AdrpLdr	Lloh60, Lloh61
	.cfi_endproc
                                        ; -- End function
	.globl	_threshold                      ; @threshold
.zerofill __DATA,__common,_threshold,8,3
	.globl	_eviction_sets                  ; @eviction_sets
.zerofill __DATA,__common,_eviction_sets,8,3
	.globl	_eviction_sets_pages            ; @eviction_sets_pages
.zerofill __DATA,__common,_eviction_sets_pages,8,3
	.globl	_evset_size                     ; @evset_size
.zerofill __DATA,__common,_evset_size,4,2
	.globl	_evsets_count                   ; @evsets_count
.zerofill __DATA,__common,_evsets_count,4,2
	.globl	_page_size                      ; @page_size
.zerofill __DATA,__common,_page_size,8,3
	.globl	_evset_memory_size              ; @evset_memory_size
.zerofill __DATA,__common,_evset_memory_size,8,3
	.globl	_traverser                      ; @traverser
.zerofill __DATA,__common,_traverser,8,3
	.section	__DATA,__data
	.globl	_cache_line_size                ; @cache_line_size
	.p2align	3, 0x0
_cache_line_size:
	.quad	64                              ; 0x40

	.section	__TEXT,__cstring,cstring_literals
l_.str.5:                               ; @.str.5
	.asciz	"miss: %llu, hit: %llu, threshold: %llu\n"

l_.str.9:                               ; @.str.9
	.asciz	"Could not allocate back (%d, %f, %f, %d)!\n"

l_str:                                  ; @str
	.asciz	"MMAP FAILED"

l_str.10:                               ; @str.10
	.asciz	"munmap failed!"

l_str.11:                               ; @str.11
	.asciz	"Eviction set found!"

l_str.12:                               ; @str.12
	.asciz	"finding eviction set failed!"

l_str.13:                               ; @str.13
	.asciz	"max retries exceeded!"

l_str.14:                               ; @str.14
	.asciz	"Could not allocate chunks!"

l_str.15:                               ; @str.15
	.asciz	"Could not allocate ichunks!"

l_str.16:                               ; @str.16
	.asciz	"ERROR: Entries are bigger than cache line!"

.subsections_via_symbols
