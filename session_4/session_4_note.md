https://hackmd.io/@vb7401/zk-crypto-4

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
    // even though m is not involved in the circuit, 
    // it is still constrained and cannot be 
    // changed after it is set.
    signal input m;
    
    signal input sk;    
    signal input pk[n];
    
    // get the public key
     component checker = SecretToPublic();
     checker.sk <== sk;
     
     // make sure computedPk is in the inputted group
    signal zeroChecker[n+1];
    zeroChecker[0] <== 1;
    for (var i = 0; i < n; i++) {
        zeroChecker[i+1] <== zeroChecker[i] * (pk[i] - checker.pk);
    }
    zeroChecker[n] === 0;
    
    signal mSquared;
    mSquared <== m * m;
}

// 多路复用器
// if index == 0 returns [in[0], in[1]]
// if index == 1 returns [in[1], in[0]]
template DualMux() {
    signal input index;
    signal input in[2];
    signal output out[2];

    index * (1 - index) === 0;
    out[0] <== (in[1] - in[0]) * index + in[0];
    out[1] <== (in[0] - in[1]) * index + in[1];
   
}

template MerkleTreeMembership(nLevels) { 
    signal input root;
    signal input siblings[nLevels];
    signal intermediateHash[nLevels+1];
    signal input pathIndices[nLevels];  // 0 if left sibling, 1 if right sibling
    signal input leaf; 
    
    component poseidons[nLevels];
    component muxes[nLevels];
   
    intermediateHash[0] <== leaf;

    for (var i = 0; i < nLevels; i++) {
        muxes[i] = DualMux();
        muxes[i].in[0] <== intermediateHash[i];
        muxes[i].in[1] <== siblings[i];
        muxes[i].index <== pathIndices[i];
    
        poseidons[i] = Poseidon(2);
        poseidons[i].inputs[0] <== muxes[i].out[0];
        poseidons[i].inputs[1] <== muxes[i].out[1];
        
        intermediateHash[i+1] <== poseidons[i].out;
    }
    
    root === intermediateHash[nLevels];
}  

template MerkleGroupSign(nLevels) {
    signal input m;
    signal input root;
    signal input sk;
    signal input siblings[nLevels];
    signal input pathIndices[nLevels];
    
    component checker = SecretToPublic();
    checker.sk <== sk;
    
    // we know the secret key corresponding to a public key inside this merkle tree
    component merkle = MerkleTreeMembership(nLevels);
    
    merkle.root <== root;
    merkle.leaf <== checker.pk;
    
    for (var i = 0; i < nLevels; i++) {
        merkle.siblings[i] <== siblings[i];
        merkle.pathIndices[i] <== pathIndices[i];
    }
    
    signal mSquared;
    mSquared <== m * m;
}

// component main { public [ pk, m ] } = Sign();
// component main { public [ pk, m ] } = GroupSign(5);
component main { public [ root ] } = MerkleTreeMembership(5);

// "m"表示message，可以是任意消息
/* INPUT = {
    "sk": "5",
    "pk": "19065150524771031435284970883882288895168425523179566388456001105768498065277",
    "m": "1"
} */

// MerkleTreeMembership用
/* INPUT = {
    "root": "12890874683796057475982638126021753466203617277177808903147539631297044918772",
    "leaf": "1355224352695827483975080807178260403365748530407",
    "siblings": [
        "1",
        "217234377348884654691879377518794323857294947151490278790710809376325639809",
        "18624361856574916496058203820366795950790078780687078257641649903530959943449",
        "19831903348221211061287449275113949495274937755341117892716020320428427983768",
        "5101361658164783800162950277964947086522384365207151283079909745362546177817",
        "11552819453851113656956689238827707323483753486799384854128595967739676085386",
        "10483540708739576660440356112223782712680507694971046950485797346645134034053",
        "7389929564247907165221817742923803467566552273918071630442219344496852141897",
        "6373467404037422198696850591961270197948259393735756505350173302460761391561",
        "14340012938942512497418634250250812329499499250184704496617019030530171289909",
        "10566235887680695760439252521824446945750533956882759130656396012316506290852",
        "14058207238811178801861080665931986752520779251556785412233046706263822020051",
        "1841804857146338876502603211473795482567574429038948082406470282797710112230",
        "6068974671277751946941356330314625335924522973707504316217201913831393258319",
        "10344803844228993379415834281058662700959138333457605334309913075063427817480"
    ],
    "pathIndices": [
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1"
    ]
} */

```

---

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