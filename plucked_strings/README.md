# Equations behind the Selection of Plucked Strings

Derivation of string vibration equations can be found here https://en.wikipedia.org/wiki/String_vibration#Derivation 

Definitions for the <u>vibrating</u> portion of <u>each</u> string:

$$
\begin{align*}
d & \equiv \textrm{diameter } (m) \\
L & \equiv \textrm{vibrating length, scale length } (m) \\
\rho & \equiv \textrm{density } (kg/m^3) \\
n & \equiv \textrm{nth harmonic} \\ \\
f_{n} & \equiv \textrm{frequency of the nth harmonic } (Hz) \\
\rho & \equiv \textrm{density } (kg/m^3) \\
\mu & \equiv \textrm{mass per length, linear-density } (kg/m) \\
T & \equiv \textrm{tension } (Newtons) \\
\end{align*}
$$


The following equations are for the <u>vibrating</u> portion of <u>each</u> string:

$$
\begin{align*}
A &=\pi\frac{d^2}{4} & \textrm{area (m)}^2 \\
V &= A \cdot L & \textrm{volume (m)}^3 \\
m &=\rho\cdot{V} = \rho \cdot ( A \cdot L ) & \textrm{mass (kg)} \\
v &=\sqrt{\frac{T}{\mu}} & \textrm{wave velocity (m/s)} \\
f_{n} &=\frac{n}{2L} v & \textrm{frequency of the nth harmonic (Hz)} \\
f_{n} &=\frac{n}{2L} \sqrt{\frac{T}{\mu}} & \textrm{frequency of the nth harmonic (Hz)} \\
{\lambda}_n &= \frac {v}{f_n} & \textrm{wavelength (m)} \\
\sigma & = \frac {T}{A} & \textrm{stress (Pa)} \\
\end{align*}
$$

$$
\begin{align*}
T &= 4 \cdot \left(\frac{f_{n} \cdot L}{n}\right)^2 \cdot \mu \\
f_{n} &=\frac{n}{2L} \sqrt{\frac{T}{\mu}} \\
\therefore \mu &= T ( \frac{n}{2f_{n}L} )^2 = \rho \cdot (area) = \rho \pi \cdot (\frac{d^2}{4}) \\
\textrm{now solve for diameter, d:} \\
d &= (\frac{n}{(f_{n}L)})\cdot \sqrt( \frac{T}{\rho \pi} ) \\
\therefore \\
d &= f(f_{n},L,T,\rho,n) \\
Z_{0} & = \frac{\pi \rho d^2 f_{n} L}{2} & \textrm{wave impedance}
\end{align*}
$$

The following equation gives the frequency f of the nth key, as shown in the table:
https://en.wikipedia.org/wiki/Piano_key_frequencies

$$
f(n) = \left(\sqrt[12]{2}\,\right)^{n-49} \times 440 \,\text{Hz}\,\\
$$

$$a = A_{4} = A440$$
is the 49th key on the idealized standard piano

Alternatively, this can be written as:

$$
f(n) = 2^{\frac{n-49}{12}} \times 440 \,\text{Hz}\,
$$

Conversely, starting from a frequency on the idealized standard piano tuned to A440, one obtains the key number by:

$$
n = 12 \, \log_2\left({\frac{f}{440 \,\text{Hz}}}\right) + 49
$$

