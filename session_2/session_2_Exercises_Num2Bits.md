```
pragma circom 2.1.2;

// 把十进制数字转换为二进制位，b[0]是最低有效位，如：5 -> 1010
/*  Parameters: nBits
    Input signal(s): in
    Output signal(s): b[nBits] 
*/
template Num2Bits(nBits) {
    signal input in;
    signal output b[nBits];
    var sum = 0;        // 校验变成bit后加起来是否还等于输入
    var e = 1;
    
    for (var i = 0; i < nBits; i++) {
        // 右移i位并且&1，得到每次最右边的bit
        b[i] <-- (in >> i) & 1;
        
        // 给定约束
        // b[i]只能为0或1
        b[i] * (b[i] - 1) === 0;
        
        // 二进制转成十进制累加
        sum += b[i] * e;
        e = 2 * e;
    }
    
    // sum 必须与输入 in 相等
    sum === in;
}
```