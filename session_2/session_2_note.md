https://zkrepl.dev/

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