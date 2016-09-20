package org.aauc.urticariapp.data;

import android.test.AndroidTestCase;

import java.util.Calendar;

public class LogItemTest extends AndroidTestCase {

    public void testConstructorShouldBlaBla() throws InterruptedException {
        Calendar c1 = Calendar.getInstance();
        c1.set(10, Calendar.FEBRUARY, 10);
        Thread.sleep(1000);
        Calendar c2 = Calendar.getInstance();
        c2.set(10, Calendar.FEBRUARY, 10);

        assertEquals(c1, c2);
    }
}