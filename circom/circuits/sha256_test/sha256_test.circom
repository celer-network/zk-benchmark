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
pragma circom 2.0.3;

include "../sha256/sha256_bytes.circom";

template Main() {
    var N = 8;
    signal input in[N][64];
    signal input start;
    signal output out[32];

    component sha256[N];

    for (var i=0; i<N; i++) {
        sha256[i] = Sha256Bytes(64);
        sha256[i].in <== in[i];
    }
    out <== sha256[0].out;

    log("start ================");
    for (var i = 0; i < 32; i++) {
        log(out[i]);
    }
    log("finish ================");

    out[0] === start;
}

component main = Main();

