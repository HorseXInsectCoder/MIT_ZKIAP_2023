```
pragma circom 2.1.2;

include "circomlib/poseidon.circom";

template SecretToPublic() {
    signal input sk;
    signal output pk;
    
    component poseidon = Poseidon(1);
    poseidon.inputs[0] <== sk;
    pk <== poseidon.out;
}

template Sign() {
    signal input m;
    signal input sk;    // private
    signal input pk;

    // verify prover knows correct sk. Check that we know the secret kye corresponding to the public key
    component checker = SecretToPublic();
    checker.sk <== sk;
    pk === checker.pk;
    
    signal mSquared;
    mSquared <== m * m;
}

template GroupSign(n) {
    signal input m;
    signal input sk;    
    signal input pk[n];
    
     component checker = SecretToPublic();
     checker.sk <== pk;
     
     signal mSquared;
     mSquared <== m * m;
}

component main { public [ pk, m ] } = Sign();

// "m"表示message，可以是任意消息
/* INPUT = {
    "sk": "5",
    "pk": "19065150524771031435284970883882288895168425523179566388456001105768498065277",
    "m": "1"
} */

```

```
pragma circom 2.1.2;

include "circomlib/poseidon.circom";

template isCorrect() {
    // signal input m;
    signal input m;    // private
    signal input h;
    signal output isCorrect;

    // verify prover knows correct sk. Check that we know the secret kye corresponding to the public key
    component pose = Poseidon(1);

    // 对 m 进行 Poseidon hash
    pose.inputs[0] <== m;
    // h === pose.out;
   
    // 检查进行 Poseidon hash 后是否与 input 的 h 值相等
    var res = (h!=pose.out)?0:1;
    isCorrect<--res;
}

component main { public [h ] } = isCorrect();


/* INPUT = {
    "m": "5",
    "h": "19065150524771031435284970883882288895168425523179566388456001105768498065277"
} */
```

补充：
Q：component main { public [ pk ]} = Sign();，这里的public是不是必须的，因为在上面已经声明为output了
A：output本身是公开的。只需要对input设置是否需要public。设置public的原因可能是有些输入需要公开。