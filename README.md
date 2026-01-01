# 1D-CSP Optimization using Hippopotamus Algorithm (HOA)

![Status](https://img.shields.io/badge/status-active-success.svg)

This repository contains an implementation of the **Hippopotamus Optimization Algorithm (HOA)** to solve the **One-Dimensional Cutting Stock Problem (1D-CSP)**. The project aims to minimize material wastage (trim loss) in industrial cutting processes using this novel nature-inspired meta-heuristic approach introduced in 2024.

## 📌 Project Overview

The **One-Dimensional Cutting Stock Problem (1D-CSP)** is a classic NP-hard optimization problem commonly found in industries such as steel, paper, and textile manufacturing. The primary objective is to cut standard-sized stock materials into smaller, specified demand pieces while minimizing the total waste.

This project approaches the problem using the **Hippopotamus Optimization Algorithm (HOA)**. HOA mimics the social behavior, defense mechanisms, and evasion strategies of hippopotamuses to find optimal or near-optimal solutions in complex search spaces, overcoming the local optima limitations of traditional methods.

## 🚀 Key Features

* **Trim Loss Minimization:** Efficiently calculates optimal cutting patterns to reduce waste.
* **Novel Meta-heuristic:** Implements the recently developed HOA (2024).
* **Dynamic Search Mechanism:** Utilizes HOA's "escape from predator" phase to avoid local optima.
* **Customizable Inputs:** Supports variable stock lengths and demand requirements.

## 📂 Mathematical Model

The problem is modeled to minimize the total trim loss $Z$:

$$\min Z = \sum_{j=1}^{m} t_j$$

**Subject to:**

1.  **Stock Constraint:** The total length of cut items plus waste must equal the stock length.
    $$\sum_{i=1}^{n} x_{ij} w_i + t_j = c \cdot y_j$$
2.  **Demand Constraint:** All customer demands must be met.
    $$\sum_{j=1}^{m} x_{ij} = v_i$$

## 🛠️ Algorithm: Hippopotamus Optimization (HOA)

The code implements the three main phases of the HOA:
1.  **Position Update:** Simulating the social position of hippos in the river (Exploitation).
2.  **Defense against Predators:** Moving towards the herd for safety.
3.  **Escaping from Predators:** Random movements to explore new areas of the search space (Exploration).

## 💻 Installation & Usage

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/SidikaEtci/hoa-cutting-stock-problem.git
    ```
2.  **Navigate to the project directory:**
    ```bash
    cd hoa-cutting-stock-problem
    ```
3.  **Run the Solver:**
    *(Please follow the instructions for your specific environment)*
    ```bash
    # If using Java
    javac Main.java
    java Main

    # If using Python
    python main.py
    ```

## 👏 Acknowledgements & Code Origin

This project's core algorithm implementation is adapted and modified from the original MATLAB source code:

* **Original Source:** [Hippopotamus Optimization Algorithm (HO) on MathWorks File Exchange](https://www.mathworks.com/matlabcentral/fileexchange/160088-hippopotamus-optimization-algorithm-ho)
* **Modifications:** The original code has been translated and specifically tailored to solve the discrete constraints of the One-Dimensional Cutting Stock Problem.

## 📚 References

This project is built upon the following academic researches:

* **[1] Algorithm Source:** M. H. Amiri, N. M. Hashjin, M. Montazeri, S. Mirjalili, and N. Khodadadi, "Hippopotamus optimization algorithm: a novel nature-inspired optimization algorithm," *Sci. Rep.*, vol. 14, no. 1, p. 5032, Feb. 2024. [DOI: 10.1038/s41598-024-54910-3](https://www.nature.com/articles/s41598-024-54910-3)
* **[2] Problem Definition:** M. H. Akyüz and N. Aras, "A New Approach to the One-Dimensional Cutting Stock Problem," *arXiv preprint arXiv:1606.01419*, 2016.
