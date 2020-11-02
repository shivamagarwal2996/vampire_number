# COP 5615 - Project 1
The goal of the first project is use Elixir and the actor model to build a good solution to find a 
vampire number with distinct pair of fangs.


## Instructions
```mix run project1.exs lb ub ``` where the program finds all vampire numbers and its fangs between lb to ub. 

Sample Input:
```
mix run project1.exs 100000 200000
```
Note: No. of actors fir minimal real time is 7.

## Conclusions
#### Processor used
1.4 GHz Intel Core i5 Quad Cor

#### Ratio(cpu/real) vs no. of actors
![N|Solid](https://i.imgur.com/9OzT8u9.png)
 Figure - 1: 7 is the optimal number of actors
 
![N|Solid](https://i.imgur.com/PtstCvV.png)
Figure - 2: 

Size of work unit is 14285 as the number of actors is 7.So dividing the work equally to each worker gives that number.

#### Result of running for lb=100000 and ub =200000

Sample Output:
```
Result
102510 201 510
104260 260 401
105210 210 501
105264 204 516
105750 150 705
108135 135 801
110758 158 701
115672 152 761
116725 161 725
117067 167 701
118440 141 840
120600 201 600
123354 231 534
124483 281 443
125248 152 824
125433 231 543
125460 204 615 246 510
125500 251 500
126027 201 627
126846 261 486
129640 140 926
129775 179 725
131242 311 422
132430 323 410
133245 315 423
134725 317 425
135828 231 588
135837 351 387
136525 215 635
136948 146 938
140350 350 401
145314 351 414
146137 317 461
146952 156 942
150300 300 501
152608 251 608
152685 261 585
153436 356 431
156240 240 651
156289 269 581
156915 165 951
162976 176 926
163944 396 414
172822 221 782
173250 231 750
174370 371 470
175329 231 759
180225 225 801
180297 201 897
182250 225 810
182650 281 650
186624 216 864
190260 210 906
192150 210 915
193257 327 591
193945 395 491
197725 275 719
```

Observations:
 - Best **Real time 693ms**, **CPU-Real time ratio 4.3737** was acheived on using 7 actors (depicted in Table -1, Figure - 3), thus reinforcing the conclusion made earlier. 
![N|Solid](https://i.imgur.com/nw0Rnu6.png)

#### Largest problem solved
 - N = 10000000 20000000. 
 - Real time 6m50.371s
 - User 39m54.771s


