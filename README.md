# BD-RIS Sparsity Patterns

This repository constructs and visualizes the sparsity patterns of the susceptance matrix $\mathbf{B}\in\mathbb{R}^{N_I\times N_I}$
for different **Beyond-Diagonal Reconfigurable Intelligent Surfaces (BD-RIS)** architectures.

Each figure shows the position of **nonzero vs zero elements** in the real, symmetric susceptance matrix $\mathbf{B}$.

This repository is based on the graph-theoretic BD-RIS modeling framework proposed in [1]–[3].

Running `main_visualize_bdris_sparsity.m` constructs and visualizes the sparsity patterns of the real symmetric susceptance matrix $\mathbf{B}$ for different BD-RIS architectures.  
The index sets $\mathcal{S}_i$, which specify **which RIS vertices are connected to which other vertices**, are constructed by `arch_sparsity_sets_all` as described in [2,3], and `project_B_to_arch` then constructs $\mathbf{B}$ accordingly.

---

## Fully-Connected RIS

<!-- ![Fully-Connected RIS](assets/Bpattern_fully.png) -->

<!-- <img src="assets/Bpattern_fully.png" width="450"> -->

<p align="center">
  <a href="assets/Bpattern_fully.png">
    <img src="assets/Bpattern_fully.png" width="450">
  </a><br>
  <sub><b>Fully-Connected BD-RIS Sparsity Pattern</b></sub>
</p>

---

## Group-Connected RIS

<!-- <img src="assets/Bpattern_group.png" width="450"> -->

<p align="center">
  <a href="assets/Bpattern_group.png">
    <img src="assets/Bpattern_group.png" width="450">
  </a><br>
  <sub><b>Group-Connected BD-RIS Sparsity Pattern</b></sub>
</p>

---

## Single-Connected RIS
<!-- <img src="assets/Bpattern_single.png" width="450"> -->

<p align="center">
  <a href="assets/Bpattern_single.png">
    <img src="assets/Bpattern_single.png" width="450">
  </a><br>
  <sub><b>Single-Connected BD-RIS Sparsity Pattern</b></sub>
</p>

---

## Tridiagonal RIS
<!-- <img src="assets/Bpattern_tridiagonal.png" width="450"> -->

<p align="center">
  <a href="assets/Bpattern_tridiagonal.png">
    <img src="assets/Bpattern_tridiagonal.png" width="450">
  </a><br>
  <sub><b>Tridiagonal-Connected BD-RIS Sparsity Pattern</b></sub>
</p>

---

## Arrowhead RIS
<!-- <img src="assets/Bpattern_arrowhead.png" width="450"> -->

<p align="center">
  <a href="assets/Bpattern_arrowhead.png">
    <img src="assets/Bpattern_arrowhead.png" width="450">
  </a><br>
  <sub><b>Arrowhead-Connected BD-RIS Sparsity Pattern</b></sub>
</p>

---

## Band-Connected RIS (band width q = 3)
<!-- <img src="assets/Bpattern_band.png" width="450"> -->

<p align="center">
  <a href="assets/Bpattern_band.png">
    <img src="assets/Bpattern_band.png" width="450">
  </a><br>
  <sub><b>Band-Connected BD-RIS Sparsity Pattern</b></sub>
</p>

---

## Stem-Connected RIS (stem width q = 3)
<!-- <img src="assets/Bpattern_stem.png" width="450"> -->

<p align="center">
  <a href="assets/Bpattern_stem.png">
    <img src="assets/Bpattern_stem.png" width="450">
  </a><br>
  <sub><b>Stem-Connected BD-RIS Sparsity Pattern</b></sub>
</p>



<!-- show them side by side -->
<!---->
<!-- <p align="center"> -->
<!--   <img src="assets/Bpattern_fully.png" width="220"> -->
<!--   <img src="assets/Bpattern_group.png" width="220"> -->
<!--   <img src="assets/Bpattern_single.png" width="220"> -->
<!-- </p> -->
<!---->
<!-- <p align="center"> -->
<!--   <img src="assets/Bpattern_tridiagonal.png" width="220"> -->
<!--   <img src="assets/Bpattern_arrowhead.png" width="220"> -->
<!-- </p> -->
<!---->
<!-- <p align="center"> -->
<!--   <img src="assets/Bpattern_band.png" width="220"> -->
<!--   <img src="assets/Bpattern_stem.png" width="220"> -->
<!-- </p> -->



---

## 📚 References and Further Reading

For more detailed theoretical background on the **graph-theoretic modeling**, **architecture design**, and **optimization of BD-RIS**, please refer to the following key papers:

1. **Beyond Diagonal Reconfigurable Intelligent Surfaces Utilizing Graph Theory: Modeling, Architecture Design, and Optimization**  
   M. Nerini, S. Shen, H. Li, and B. Clerckx,  
   *IEEE Transactions on Wireless Communications*, 2024.  
   🔗 https://ieeexplore.ieee.org/document/10453384  
   💻 MATLAB code: https://github.com/matteonerini/bdris-utilizing-graph-theory  

2. **Beyond-Diagonal RIS in Multiuser MIMO: Graph Theoretic Modeling and Optimal Architectures With Low Complexity**  
   *IEEE Transactions on Information Theory*, 2025.  
   🔗 https://ieeexplore.ieee.org/document/11162566  

3. **Optimization of Beyond Diagonal RIS: A Universal Framework Applicable to Arbitrary Architectures**  
   arXiv preprint, 2024.  
   🔗 https://arxiv.org/abs/2412.15965  

