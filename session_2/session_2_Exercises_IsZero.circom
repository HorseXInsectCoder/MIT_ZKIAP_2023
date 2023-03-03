pragma circom 2.1.2;

/*
    Parameters: none
    Input signal(s): in
    Output signal(s): out
    Specification: If in is zero, out should be 1. If in is nonzero, out should be 0
*/
template IsZero() {
    signal input in;
    signal output out;
    
    // 中间变量
    signal inv;
    
    inv <-- in != 0 ? 1/in : 0;
    
    // out <-- -in*inv +1;
    // out === -in*inv +1;
    out <== -in * inv + 1;
    
    // 约束，如果in是零，那么out = -in * inv + 1 = 1。如果out为零，则它遵循in * inv = 1，这意味着in不能为零。
    in * out === 0;
}

component main = IsZero();

/* INPUT = {
    "in": ["1"]
} */