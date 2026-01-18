# Signal Processing Project 

This repository contains the course project work for the **Signal Processing**. 

---

## Problem Statements

### Part 1: Non-Ideal Sampling

In ideal conditions, band-limited signals sampled above the Nyquist rate can be perfectly reconstructed. However, in practice, sampling often deviates from ideal assumptions. This part of the project addresses reconstruction under two non-ideal sampling scenarios.

Let the continuous-time signal be denoted by (x(t)), sampled with interval (T_s). The ideal discrete-time signal is:

x[n] = x(nT_s)

The following non-ideal cases are considered:

#### (a) Sampling Time Jitter

The (n)-th sample is not taken exactly at (nT_s), but at a perturbed time instant:

x̂[n] = x(nT_s + k_n Δ)

where:

* Δ = T_s / 10
* k_n is an integer-valued random variable
* k_n ∈ [−K, K], with 1 ≤ K ≤ 4


Although the deviation is known for each sample, it varies randomly across samples. The task is to **estimate the ideal samples (x[n])** from the jittered samples (\hat{x}[n]).

The performance of the proposed estimation method is **quantified as a function of (K)**.

---

#### (b) Missing Samples

In this scenario, sampling occurs at the correct instants, but samples may be missing. Each sample is available with probability (1-p), where:

[ p \in (0,1) ]

The available samples are:

[ \tilde{x}[n] = x(nT_s) ]

The objective is to **reconstruct the original signal (x[n])** from incomplete observations. The reconstruction performance is **quantified as a function of the missing probability (p \in (0.01, 0.1))**.

---

For both scenarios (a) and (b):

* Appropriate reconstruction methods are developed
* Results are demonstrated using **at least three distinct band-limited signals**
* Analytical justification and performance evaluation are provided

---

### Part 2: Find the Beats

In this part, real-world **audio signal analysis** is performed using recordings of drum sounds.

Given multiple audio files containing drum recordings, the tasks are:

* Identify and output all **time instants corresponding to drum hits**
* Estimate the **duration of each drum hit**
* Determine the **number of distinct drum instruments** present in each recording
* Group detected hits according to the instrument producing them

This part emphasizes practical signal processing techniques such as envelope extraction, peak detection, and time–frequency analysis.

---



