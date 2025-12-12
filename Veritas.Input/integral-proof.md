---
title: "The Integral of 1/(xⁿ + 1)"
date: "December 2025"
lang: en
chapterstyle: minimal
---

# Roots of xⁿ + 1

We seek the solutions to $x^n = -1$. Writing $-1 = e^{i\pi(2m+1)}$ for any integer $m$, we obtain:

$$x = e^{i\pi(2k+1)/n}, \quad k = 0, 1, \ldots, n-1$$

\begin{definition}
Let $\omega_k = e^{i\pi(2k+1)/n}$ denote the $k$-th root of $x^n + 1 = 0$.
\end{definition}

\begin{proposition}
The roots satisfy:

1. $|\omega_k| = 1$ for all $k$
2. $\omega_k$ and $\omega_{n-1-k}$ are complex conjugates
3. For odd $n$, exactly one root is real, namely $\omega_{(n-1)/2} = -1$
4. For even $n$, no root is real
\end{proposition}

\begin{proof}
Statement (1) follows from $|e^{i\theta}| = 1$. For (2), observe that:
$$\overline{\omega_k} = e^{-i\pi(2k+1)/n}$$
and
$$\omega_{n-1-k} = e^{i\pi(2(n-1-k)+1)/n} = e^{i\pi(2n-2k-1)/n} = e^{i\pi(2 - (2k+1)/n)} = e^{-i\pi(2k+1)/n}$$
since $e^{2\pi i} = 1$. For (3), a real root requires $(2k+1)/n \in \mathbb{Z}$; with odd $n$, this occurs when $k = (n-1)/2$, yielding $e^{i\pi} = -1$. For even $n$, $(2k+1)/n$ is never an integer.
\end{proof}

# Factorisation over ℝ

\begin{theorem}[Real Factorisation]
The polynomial $x^n + 1$ factors over $\mathbb{R}$ as follows:

**Case I** ($n$ odd):
$$x^n + 1 = (x + 1)\prod_{k=0}^{(n-3)/2}\left(x^2 - 2\cos\frac{\pi(2k+1)}{n}\,x + 1\right)$$

**Case II** ($n$ even):
$$x^n + 1 = \prod_{k=0}^{n/2 - 1}\left(x^2 - 2\cos\frac{\pi(2k+1)}{n}\,x + 1\right)$$
\end{theorem}

\begin{proof}
Each conjugate pair $\omega_k, \bar{\omega}_k$ contributes the real quadratic:
$$(x - \omega_k)(x - \overline{\omega_k}) = x^2 - (\omega_k + \overline{\omega_k})x + \omega_k\overline{\omega_k}$$
$$= x^2 - 2\,\text{Re}(\omega_k)\,x + 1 = x^2 - 2\cos\frac{\pi(2k+1)}{n}\,x + 1$$

The quadratics are irreducible over $\mathbb{R}$ since their discriminant $4\cos^2(\pi(2k+1)/n) - 4 < 0$ for $0 < (2k+1)/n < 1$. The stated index ranges enumerate precisely one representative from each conjugate pair.
\end{proof}

**Notation.** Henceforth, define:
$$\theta_k = \frac{\pi(2k+1)}{n}, \qquad Q_k(x) = x^2 - 2\cos\theta_k\,x + 1$$

# Partial Fraction Decomposition

\begin{lemma}[Residue at Simple Pole]
If $P(a) = 0$ and $P'(a) \neq 0$, then:
$$\frac{1}{P(x)} = \frac{1}{P'(a)(x-a)} + \text{(terms regular at } a\text{)}$$
\end{lemma}

\begin{proposition}
For the real root $x = -1$ (when $n$ is odd):
$$\text{Res}_{x=-1}\frac{1}{x^n+1} = \frac{1}{n(-1)^{n-1}} = \frac{1}{n}$$
\end{proposition}

\begin{proof}
Since $\frac{d}{dx}(x^n+1) = nx^{n-1}$, and for odd $n$ we have $(-1)^{n-1} = 1$.
\end{proof}

\begin{theorem}[Partial Fraction Coefficients]
The decomposition takes the form:

**Case I** ($n$ odd):
$$\frac{1}{x^n+1} = \frac{1/n}{x+1} + \sum_{k=0}^{(n-3)/2}\frac{A_k x + B_k}{Q_k(x)}$$

**Case II** ($n$ even):
$$\frac{1}{x^n+1} = \sum_{k=0}^{n/2-1}\frac{A_k x + B_k}{Q_k(x)}$$

where in both cases:
$$A_k = -\frac{2\cos\theta_k}{n}, \qquad B_k = \frac{2}{n}$$
\end{theorem}

\begin{proof}
The coefficient over the linear factor (when $n$ is odd) follows from the previous proposition. For the quadratic factors, we employ the method of complex residues.

Consider the partial fraction over $\mathbb{C}$:
$$\frac{1}{x^n+1} = \sum_{j=0}^{n-1}\frac{r_j}{x - \omega_j}$$

where, by the residue lemma:
$$r_j = \frac{1}{n\omega_j^{n-1}} = \frac{\omega_j}{n\omega_j^n} = \frac{\omega_j}{n(-1)} = -\frac{\omega_j}{n}$$

Combining conjugate pairs $\omega_k$ and $\bar{\omega}_k = \omega_{n-1-k}$:
$$\frac{r_k}{x-\omega_k} + \frac{\overline{r_k}}{x-\overline{\omega_k}} = \frac{r_k(x-\overline{\omega_k}) + \overline{r_k}(x-\omega_k)}{(x-\omega_k)(x-\overline{\omega_k})}$$

The numerator is:
$$(r_k + \overline{r_k})x - (r_k\overline{\omega_k} + \overline{r_k}\omega_k) = 2\,\text{Re}(r_k)\,x - 2\,\text{Re}(r_k\overline{\omega_k})$$

Now:
$$\text{Re}(r_k) = \text{Re}\left(-\frac{\omega_k}{n}\right) = -\frac{\cos\theta_k}{n}$$

$$\text{Re}(r_k\overline{\omega_k}) = \text{Re}\left(-\frac{\omega_k\overline{\omega_k}}{n}\right) = \text{Re}\left(-\frac{1}{n}\right) = -\frac{1}{n}$$

Therefore:
$$A_k = 2\,\text{Re}(r_k) = -\frac{2\cos\theta_k}{n}$$
$$B_k = -2\,\text{Re}(r_k\overline{\omega_k}) = \frac{2}{n}$$
as claimed.
\end{proof}

# Integration of Component Terms

\begin{lemma}[Linear Factor]
$$\int\frac{dx}{x+1} = \ln|x+1| + C$$
\end{lemma}

\begin{lemma}[Quadratic Factor — Logarithmic Part]
For $Q(x) = x^2 + bx + c$ with $\Delta = b^2 - 4c < 0$:
$$\int\frac{x\,dx}{x^2+bx+c} = \frac{1}{2}\ln(x^2+bx+c) - \frac{b}{2}\int\frac{dx}{x^2+bx+c}$$
\end{lemma}

\begin{proof}
Write $x = \frac{1}{2}(2x + b) - \frac{b}{2}$ and observe that $\frac{d}{dx}(x^2 + bx + c) = 2x + b$.
\end{proof}

\begin{lemma}[Quadratic Factor — Arctangent Part]
For $Q(x) = x^2 + bx + c$ with $\Delta = b^2 - 4c < 0$:
$$\int\frac{dx}{x^2+bx+c} = \frac{2}{\sqrt{-\Delta}}\arctan\frac{2x+b}{\sqrt{-\Delta}} + C$$
\end{lemma}

\begin{proof}
Complete the square: $x^2 + bx + c = (x + b/2)^2 + (c - b^2/4) = (x + b/2)^2 + (-\Delta/4)$. Substituting $u = x + b/2$ and recognising the standard arctangent integral yields the result.
\end{proof}

\begin{proposition}
For $Q_k(x) = x^2 - 2\cos\theta_k\, x + 1$, we have $\Delta_k = 4\cos^2\theta_k - 4 = -4\sin^2\theta_k$, whence:
$$\int\frac{dx}{Q_k(x)} = \frac{1}{\sin\theta_k}\arctan\frac{x - \cos\theta_k}{\sin\theta_k} + C$$
\end{proposition}

\begin{theorem}[Integration of Quadratic Term]
$$\int\frac{A_k x + B_k}{Q_k(x)}\,dx = -\frac{\cos\theta_k}{n}\ln Q_k(x) + \frac{1}{n\sin\theta_k}\arctan\frac{x - \cos\theta_k}{\sin\theta_k} + C$$
\end{theorem}

# The General Solution

\begin{theorem}[Main Result]
The integral of $1/(x^n + 1)$ is given by:

**Case I** ($n$ odd):
$$\int\frac{dx}{x^n+1} = \frac{1}{n}\ln|x+1| + \sum_{k=0}^{(n-3)/2}\left[-\frac{\cos\theta_k}{n}\ln Q_k(x) + \frac{1}{n\sin\theta_k}\arctan\frac{x-\cos\theta_k}{\sin\theta_k}\right] + C$$

**Case II** ($n$ even):
$$\int\frac{dx}{x^n+1} = \sum_{k=0}^{n/2-1}\left[-\frac{\cos\theta_k}{n}\ln Q_k(x) + \frac{1}{n\sin\theta_k}\arctan\frac{x-\cos\theta_k}{\sin\theta_k}\right] + C$$

where $\theta_k = \pi(2k+1)/n$ and $Q_k(x) = x^2 - 2\cos\theta_k\, x + 1$.
\end{theorem}

# Unified Compact Form

\begin{corollary}
The integral admits the symmetric representation:
$$\int\frac{dx}{x^n+1} = \frac{1}{n}\sum_{j=0}^{n-1}\overline{\omega_j}\ln(x - \omega_j) + C$$
where the sum is interpreted over $\mathbb{C}$ and the logarithm is complex. Taking real parts and combining conjugates recovers the main theorem.
\end{corollary}

# Application to n = 5

Setting $n = 5$, we have $\theta_0 = \pi/5$ and $\theta_1 = 3\pi/5$. The exact values are:

$$\cos\frac{\pi}{5} = \frac{1+\sqrt{5}}{4}, \quad \sin\frac{\pi}{5} = \frac{\sqrt{10-2\sqrt{5}}}{4}$$

$$\cos\frac{3\pi}{5} = \frac{1-\sqrt{5}}{4}, \quad \sin\frac{3\pi}{5} = \frac{\sqrt{10+2\sqrt{5}}}{4}$$

Substitution into the main theorem (Case I) yields the explicit formula.

# Algorithmic Summary

To integrate $1/(x^n + 1)$:

1. **Compute** $\theta_k = \pi(2k+1)/n$ for $k = 0, 1, \ldots, \lfloor(n-2)/2\rfloor$
2. **Form** $Q_k(x) = x^2 - 2\cos\theta_k\, x + 1$
3. **If $n$ odd**, include $(1/n)\ln|x+1|$
4. **For each $k$**, add:
   - $-(\cos\theta_k)/n \cdot \ln Q_k(x)$
   - $(1/(n\sin\theta_k)) \cdot \arctan((x - \cos\theta_k)/\sin\theta_k)$

This procedure generalises immediately to integrals of the form $1/(x^n + a^n)$ via the substitution $u = x/a$.
