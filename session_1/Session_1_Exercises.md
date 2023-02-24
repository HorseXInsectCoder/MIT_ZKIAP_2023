# ZK interactive demo
http://web.mit.edu/~ezyang/Public/graph/svg.html

## Exercise 1
Q: Currently, you can only select adjacent pairs of nodes to check. Would the proof still be zero knowledge if you could pick arbitrary pairs of nodes to check?
A: No. The verifier can't know the correct answer if the prover prove the wrong answer.

---

## Exercise 2
Q: The equation currently being used for confidence is 1-(1/E)^n, where E is the number of edges in the graph, and n is the number of trials run. Is this the correct equation? Why is there no prior?
A: Yes, correct. Each edge picked independently.