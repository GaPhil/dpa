# Differential Power Analysis (DPA)

This repository contatins the code for the [Hardware Security](https://www.kth.se/student/kurser/kurs/IL1333?l=en) course taught at KTH Royal Institue of Technology.

#### Side Channel Attack: Differential Power Analysis (DPA) on AES encryption algorithm to deduce secret keys

<p align="center">
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/AES-AddRoundKey.svg/810px-AES-AddRoundKey.svg.png" width="300"> <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/AES-SubBytes.svg/810px-AES-SubBytes.svg.png" width="300">
</p>

DPA can be performed as follows:

* Choose an intermediate value that depends on data and key v<sub>i, k</sub> = f(d<sub>i</sub>, k)
* Measure power traces t<sub>i, j</sub> while encrypting data d<sub>i</sub>
* Build a matrix of hypothetical intermediate values inside the cipher for all possible keys and traces v<sub>i, k</sub>
* Using a power model, compute the matrix of hypothetical power consumption for all keys and traces h<sub>i, k</sub>
* Statistically evaluate which key hypothesis best matches the measured power at each individual time

<p align="center">
<img src="https://github.com/GaPhil/kth-il1333/blob/master/traces.png" width="400">
</p>
