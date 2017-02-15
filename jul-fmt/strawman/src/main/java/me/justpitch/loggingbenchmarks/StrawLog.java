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

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Date;

public class StrawLog {
    private final String name;
    private final ThreadLocal<SimpleDateFormat> date = new ThreadLocal<SimpleDateFormat>() {
        @Override
        protected SimpleDateFormat initialValue() {
            return new SimpleDateFormat("MMM dd, yyyy hh:mm:ss aa");
        }
    };
    private final ThreadLocal<StringBuilder> builder = new ThreadLocal<StringBuilder>() {
        @Override
        protected StringBuilder initialValue() {
            return new StringBuilder(1024);
        }
    };
    private int charCount = 0;
    private BufferedOutputStream log;
    private File[] files;


    public StrawLog(Class clazz) {
        this.name = clazz.getName();
        files = new File[5];
        for (int i = 0; i < files.length; i++) {
            files[i] = new File(String.format("java%d.log", i + 1));
        }
        rotate();
    }

    private synchronized void rotate() {
        if (log != null) {
            try {
                log.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        if (files[files.length - 1].isFile()) {
            files[files.length - 1].delete();
        }
        for (int i = files.length - 2; i >= 0; i--) {
            if (files[i].isFile()) {
                files[i].renameTo(files[i + 1]);
            }
        }
        try {
            log = new BufferedOutputStream(new FileOutputStream(files[0]), 256 * 1024);
        } catch (FileNotFoundException e) {
            // ignore
        }
        charCount = 0;
    }

    public void info(String message, Object... args) {
        StringBuilder msg = builder.get();
        msg.setLength(0);
        msg.append(date.get().format(new Date()));
        msg.append(' ');
        msg.append(name);
        msg.append(' ');
        Throwable location = new Throwable();
        location.fillInStackTrace();
        String method = null;
        String ignore = getClass().getName();
        boolean haveIgnore = false;
        for (StackTraceElement e : location.getStackTrace()) {
            if (ignore.equals(e.getClassName())) {
                haveIgnore = true;
            } else {
                if (haveIgnore) {
                    method = e.getMethodName();
                    break;
                }
            }
        }
        msg.append(method == null ? "?" : method);
        msg.append("\nINFO: ");
        int state = 0;
        int index = 0;
        for (char c : message.toCharArray()) {
            switch (state) {
                case 0:
                    switch (c) {
                        case '\\':
                            state = 1;
                            break;
                        case '{':
                            state = 2;
                            break;
                        default:
                            msg.append(c);
                            break;
                    }
                    break;
                case 1:
                    switch (c) {
                        case '{':
                        case '\\':
                            msg.append(c);
                            break;
                        default:
                            msg.append('\\');
                            msg.append(c);
                            break;
                    }
                    state = 0;
                    break;
                case 2:
                    if (c == '}') {
                        if (index < args.length) {
                            msg.append(args[index++]);
                        } else {
                            msg.append("{}");
                        }
                    } else {
                        msg.append('{');
                        msg.append(c);
                    }
                    state = 0;
                    break;
            }
        }
        msg.append('\n');
        try {
            byte[] bytes = msg.toString().getBytes(StandardCharsets.UTF_8);
            synchronized (this) {
                charCount += bytes.length;
                log.write(bytes);
                if (charCount > 500000) {
                    rotate();
                }
            }
        } catch (IOException e) {
            // ignore
        }
    }
}
