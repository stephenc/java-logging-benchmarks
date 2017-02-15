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

import java.util.Date;
import java.util.logging.Formatter;
import java.util.logging.LogRecord;

public class Log4JFormatter extends Formatter {
    @Override
    public String format(LogRecord record) {
        // %d [%t] %p %c - %m%n
        StringBuilder buf = new StringBuilder(256);
        buf.append(new Date(record.getMillis()));
        buf.append(" [");
        buf.append(
                Thread.currentThread().getId() == record.getThreadID() ? Thread.currentThread().getName() : "Unknown");
        buf.append("] ");
        buf.append(record.getLevel().getName());
        buf.append(' ');
        buf.append(record.getLoggerName());
        buf.append(" - ");
        if (record.getParameters() == null) {
            buf.append(record.getMessage());
        } else {
            buf.append(String.format(record.getMessage(), record.getParameters()));
        }
        buf.append('\n');
        return buf.toString();
    }
}
