   .text

    .globl make_node
    .globl insert
    .globl get
    .globl getAtMost


make_node:
    addi sp, sp, -32
    sd   ra, 24(sp)
    sd   s0, 16(sp)
    sd   s1,  8(sp)
    mv   s1, a0            # save val
    li   a0, 24            # sizeof(struct Node) = 24
    call malloc
    mv   s0, a0            # s0 = new node ptr
    sw   s1,  0(s0)        # node->val = val
    sd   x0,  8(s0)        # node->left = NULL
    sd   x0, 16(s0)        # node->right = NULL
    mv   a0, s0
    ld   ra, 24(sp)
    ld   s0, 16(sp)
    ld   s1,  8(sp)
    addi sp, sp, 32
    ret


insert:
    addi sp, sp, -48
    sd   ra, 40(sp)
    sd   s0, 32(sp)
    sd   s1, 24(sp)
    sd   s2, 16(sp)
    mv   s0, a0            # s0 = root
    mv   s1, a1            # s1 = val
    # if root == NULL, make a new node
    bne  s0, x0, insert_notnull
    mv   a0, s1
    call make_node
    j    insert_done

insert_notnull:
    lw   s2, 0(s0)         # s2 = root->val
    beq  s1, s2, insert_return_root   # duplicate: do nothing
    # if val < root->val, go left
    blt  s1, s2, insert_left
    # else go right
    ld   a0, 16(s0)
    mv   a1, s1
    call insert
    sd   a0, 16(s0)        # root->right = returned node
    mv   a0, s0
    j    insert_done

insert_left:
    ld   a0, 8(s0)
    mv   a1, s1
    call insert
    sd   a0, 8(s0)         # root->left = returned node
    mv   a0, s0
    j    insert_done

insert_return_root:
    mv   a0, s0

insert_done:
    ld   ra, 40(sp)
    ld   s0, 32(sp)
    ld   s1, 24(sp)
    ld   s2, 16(sp)
    addi sp, sp, 48
    ret


get:
    addi sp, sp, -32
    sd   ra, 24(sp)
    sd   s0, 16(sp)
    sd   s1,  8(sp)
    mv   s0, a0            # s0 = root
    mv   s1, a1            # s1 = val
    # if root == NULL, return NULL
    beq  s0, x0, get_null
    lw   t0, 0(s0)         # t0 = root->val
    beq  s1, t0, get_found
    blt  s1, t0, get_left
    # go right
    ld   a0, 16(s0)
    mv   a1, s1
    call get
    j    get_done

get_left:
    ld   a0, 8(s0)
    mv   a1, s1
    call get
    j    get_done

get_found:
    mv   a0, s0
    j    get_done

get_null:
    li   a0, 0

get_done:
    ld   ra, 24(sp)
    ld   s0, 16(sp)
    ld   s1,  8(sp)
    addi sp, sp, 32
    ret


getAtMost:
    addi sp, sp, -48
    sd   ra, 40(sp)
    sd   s0, 32(sp)
    sd   s1, 24(sp)
    sd   s2, 16(sp)
    mv   s0, a0            # s0 = val
    mv   s1, a1            # s1 = root
    # if root == NULL, return -1
    beq  s1, x0, getAtMost_null
    lw   s2, 0(s1)         # s2 = root->val
    # if root->val == val, exact match
    beq  s2, s0, getAtMost_exact
    # if root->val > val (s0 < s2), go left only
    blt  s0, s2, getAtMost_left
    # root->val < val: candidate found, check right for better
    mv   a0, s0
    ld   a1, 16(s1)        # root->right
    call getAtMost
    li   t0, -1
    beq  a0, t0, getAtMost_use_current   # right had nothing better
    j    getAtMost_done                  # right result is closer

getAtMost_use_current:
    mv   a0, s2
    j    getAtMost_done

getAtMost_left:
    mv   a0, s0
    ld   a1, 8(s1)         # root->left
    call getAtMost
    j    getAtMost_done

getAtMost_exact:
    mv   a0, s2
    j    getAtMost_done

getAtMost_null:
    li   a0, -1

getAtMost_done:
    ld   ra, 40(sp)
    ld   s0, 32(sp)
    ld   s1, 24(sp)
    ld   s2, 16(sp)
    addi sp, sp, 48
    ret