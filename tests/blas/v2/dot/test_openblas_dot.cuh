/*
 *  Performance test for OpenBLAS DOT
 *
 *  Copyright 2021 by Konstantin Isupov.
 *
 *  This file is part of the MPRES-BLAS library.
 *
 *  MPRES-BLAS is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  MPRES-BLAS is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with MPRES-BLAS.  If not, see <https://www.gnu.org/licenses/>.
 */
#ifndef TEST_OPENBLAS_DOT_CUH
#define TEST_OPENBLAS_DOT_CUH

#include "logger.cuh"
#include "timers.cuh"
#include "tsthelper.cuh"
#include "cblas.h"

#define OPENBLAS_THREADS 4

extern "C" void openblas_set_num_threads(int num_threads);

void test_openblas(const int n, mpfr_t *x, mpfr_t *y, const int repeats){
    InitCpuTimer();
    Logger::printDash();
    PrintTimerName("[CPU] OpenBLAS dot");

    openblas_set_num_threads(OPENBLAS_THREADS);

    //CPU data
    double *dx = new double[n];
    double *dy = new double[n];
    double dr = 0;
    for (int i = 0; i < n; ++i) {
        dx[i] = mpfr_get_d(x[i], MPFR_RNDN);
        dy[i] = mpfr_get_d(y[i], MPFR_RNDN);
    }
    StartCpuTimer();
    for(int i = 0; i < repeats; i ++) {
        dr = cblas_ddot((blasint) n, (const double *) dx, (blasint) 1, (const double *) dy, (blasint) 1);
    }
    EndCpuTimer();
    PrintAndResetCpuTimer("took");
    print_double_sum(&dr, 1);
    delete[] dx;
    delete[] dy;
}

#endif //TEST_OPENBLAS_DOT_CUH
