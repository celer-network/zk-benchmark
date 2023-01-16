/*
    Copyright 2018 0KIMS association.

    This file is part of circom (Zero Knowledge Circuit Compiler).

    circom is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    circom is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with circom. If not, see <https://www.gnu.org/licenses/>.
*/
pragma circom 2.0.0;

include "../sha256_2/sha256_2_nopad.circom";

template Main() {
    signal input a[15];
    signal input b[15];
    signal output out[15];

    component hashers[15];

    var i;
    for (i=0; i < 15; i++) {
        hashers[i] = Sha256_2();
        hashers[i].a <== a[i];
        hashers[i].b <== a[i];
        out[i] <== hashers[i].out;
    }
}

component main = Main();
