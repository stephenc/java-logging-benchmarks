/*
 * The MIT License
 *
 * Copyright (c) 2017, Stephen Connolly.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package me.justpitch.loggingbenchmarks;

import org.openjdk.jmh.annotations.Benchmark;
import org.openjdk.jmh.annotations.Scope;
import org.openjdk.jmh.annotations.State;
import org.openjdk.jmh.annotations.TearDown;
import org.openjdk.jmh.infra.Blackhole;

@State(Scope.Thread)
public class LoggingBenchmark {

    private static final StrawLog LOGGER = new StrawLog(LoggingBenchmark.class);
    private static final VolLog VLOGGER = new VolLog(LoggingBenchmark.class);
    private static final FinalLog FLOGGER = new FinalLog(LoggingBenchmark.class);
    private static final StaticFinalLog SLOGGER = new StaticFinalLog(LoggingBenchmark.class);
    private static final CacheLineStrawLog CLOGGER = new CacheLineStrawLog(LoggingBenchmark.class);
    private static final CacheLineVolLog KLOGGER = new CacheLineVolLog(LoggingBenchmark.class);
    private final CacheLineStrawLog logger = CacheLineStrawLog.getLogger(LoggingBenchmark.class);
    private final CacheLineStrawLog logger2 = new CacheLineStrawLog(LoggingBenchmark.class);

    private int i;

    @Benchmark
    public void strawmanLog_nolog___Style() {
        LOGGER.info("Simple {} Param String", new Integer(i++));
    }

    @Benchmark
    public void vollog__Log_nolog___Style() {
        VLOGGER.info("Simple {} Param String", new Integer(i++));
    }

    @Benchmark
    public void staticf_Log_nolog___Style() {
        SLOGGER.info("Simple {} Param String", new Integer(i++));
    }

    @Benchmark
    public void finallogLog_nolog___Style() {
        FLOGGER.info("Simple {} Param String", new Integer(i++));
    }

    @Benchmark
    public void cachelogLog_nolog___Style() {
        CLOGGER.info("Simple {} Param String", new Integer(i++));
    }

    @Benchmark
    public void field___Log_nolog___Style() {
        logger.info("Simple {} Param String", new Integer(i++));
    }

    @Benchmark
    public void field2__Log_nolog___Style() {
        logger2.info("Simple {} Param String", new Integer(i++));
    }

    @Benchmark
    public void vcachlogLog_nolog___Style() {
        KLOGGER.info("Simple {} Param String", new Integer(i++));
    }

    @Benchmark
    public void nothing_Log_nolog___Style() {
        new Integer(i++);
    }

    @TearDown
    public void tearDown(Blackhole x) {
        x.consume(i);
    }
}
