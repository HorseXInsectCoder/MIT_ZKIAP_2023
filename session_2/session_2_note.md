https://zkrepl.dev/



Demo#1

```
pragma circom 2.1.2;

// include "circomlib/poseidon.circom";
// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";

template Example () {
    signal input x1;
    signal input x2;
    signal input x3;
    signal input x4;
    
    signal input y1;
    signal input y2;

    signal input out;

    // constraints, using "==="
    y1 === x1 + x2;
    y2 === y1 * x3;
    y2 === out + x4; 
}

// specify variables as public to verifier， here is "out", the rest if private.
component main { public [ out ] } = Example();

// JSON format. As input
/* INPUT = {
    "x1": "2",
    "x2": "4",
    "x3": "8",
    "x4": "5",
    "y1": "6",
    "y2": "48",
    "out": "43"
} */
```



shift + enter：compile and run

![image-20230301233458015](session_2_note/image-20230301233458015.png)



Demo #2: num to bits

```
pragma circom 2.1.2;

// include "circomlib/poseidon.circom";
// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";

template Example () {
    signal input in;

    signal input b0;
    signal input b1;
    signal input b2;
    signal input b3;
    
    in === 8 * b3 + 4 * b2 + 2 * b1 * b0;
    0 === b0 * (b0 - 1);
		0 === b1 * (b1 - 1);
		0 === b2 * (b2 - 1);
		0 === b3 * (b3 - 1);
}

// specify variables as public to verifier， here is "out", the rest if private.
component main { public [ b0, b1, b2, b3 ] } = Example();

// JSON format. As input
/* INPUT = {
    "in": "11",
    "b0": "1",
    "b1": "1",
    "b2": "0",
    "b3": "1",
} */
```



引入语法糖