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

import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Formatter;
import java.util.logging.LogRecord;

public class LogbackFormatter extends Formatter {

    private final ThreadLocal<SimpleDateFormat> dateFmt = new ThreadLocal<SimpleDateFormat>() {
        @Override
        protected SimpleDateFormat initialValue() {
            return new SimpleDateFormat("HH:mm:ss.SSS");
        }
    };

    @Override
    public String format(LogRecord record) {
//        <pattern>%d{HH:mm:ss.SSS} [%t] %level{WARN=WARN_, DEBUG=DEBUG, ERROR=ERROR, TRACE=TRACE, INFO=INFO_} %c{36}
// - %m%n</pattern>

        // %d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n
        StringBuilder buf = new StringBuilder(256);
        buf.append(dateFmt.get().format(new Date(record.getMillis())));
        buf.append(" [");
        buf.append(
                Thread.currentThread().getId() == record.getThreadID() ? Thread.currentThread().getName() : "Unknown");
        buf.append("] ");
        buf.append(record.getLevel().getName());
        buf.append(' ');
        buf.append(abbreviateClassName(record.getLoggerName(), 36));
        buf.append(" - ");
        if (record.getParameters() == null) {
            buf.append(record.getMessage());
        } else {
            buf.append(MessageFormat.format(record.getMessage(), record.getParameters()));
        }
        buf.append('\n');
        return buf.toString();
    }

    public String abbreviateClassName(String fqcn, int targetLength) {
        if (fqcn == null) {
            return "-";
        }
        int fqcnLength = fqcn.length();
        if (fqcnLength < targetLength) {
            return fqcn;
        }
        int[] indexes = new int[16];
        int[] lengths = new int[17];
        int count = 0;
        for (int i = fqcn.indexOf('.'); i != -1 && count < indexes.length; i = fqcn.indexOf('.', i + 1)) {
            indexes[count++] = i;
        }
        if (count == 0) {
            return fqcn;
        }
        StringBuilder buf = new StringBuilder(targetLength);
        int requiredSavings = fqcnLength - targetLength;
        for (int i = 0; i < count; i++) {
            int previous = i > 0 ? indexes[i - 1] : -1;
            int available = indexes[i] - previous - 1;
            int length = requiredSavings > 0 ? (available < 1) ? available : 1 : available;
            requiredSavings -= (available - length);
            lengths[i] = length + 1;
        }
        lengths[count] = fqcnLength - indexes[count - 1];
        for (int i = 0; i <= count; i++) {
            if (i == 0) {
                buf.append(fqcn.substring(0, lengths[i] - 1));
            } else {
                buf.append(fqcn.substring(indexes[i - 1], indexes[i - 1] + lengths[i]));
            }
        }
        return buf.toString();
    }

}
