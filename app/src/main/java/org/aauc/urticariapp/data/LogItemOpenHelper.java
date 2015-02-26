package org.aauc.urticariapp.data;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.util.Calendar;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.TimeZone;

public class LogItemOpenHelper extends SQLiteOpenHelper {

    private static final int DATABASE_VERSION = 2;
    private static final String LOG_ITEM_TABLE_NAME = "log_items";
    private static final String DATE = "adate";
    private static final String WHEALS = "wheals";
    private static final String ITCH = "itch";
    private static final String NOTE = "note";
    private static final String ANGIO = "angio";
    private static final String PICTURE = "picture";
    private static final String LIMITATIONS = "limits";
    private static final String[] ALL_FIELDS = new String[] { DATE, WHEALS, ITCH, NOTE, ANGIO, PICTURE, LIMITATIONS };
    private static final String LOG_ITEM_TABLE_CREATE =
                "CREATE TABLE " + LOG_ITEM_TABLE_NAME + " (" +
                DATE + " INT PRIMARY KEY, " +
                WHEALS + " TINYINT, " +
                ITCH + " TINYINT, " +
                NOTE + " TEXT, " +
                ANGIO + " TEXT, " +
                PICTURE + " TEXT, " +
                LIMITATIONS + " TEXT);";
    private static final String DATABASE_NAME = "urticariapp";
    private static final String FIELD_SEPARATOR = ",";

    public LogItemOpenHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(LOG_ITEM_TABLE_CREATE);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        if (oldVersion == 1 && newVersion == 2) {
            db.execSQL("ALTER TABLE " + LOG_ITEM_TABLE_NAME +
                    " ADD COLUMN " + PICTURE + " TEXT DEFAULT NULL");
            db.execSQL("ALTER TABLE " + LOG_ITEM_TABLE_NAME +
                    " ADD COLUMN " + LIMITATIONS + " TEXT DEFAULT NULL");
        }
    }

    public LogItem findOrCreateLogItem(int year, int month, int day) {
        Calendar cal = Calendar.getInstance();
        cal.set(year, month, day);
        return findOrCreateLogItem(cal);
    }

    public LogItem findOrCreateLogItem() {
        return findOrCreateLogItem(Calendar.getInstance());
    }

    private LogItem findOrCreateLogItem(Calendar when) {
        Cursor cursor = getReadableDatabase().query(LOG_ITEM_TABLE_NAME,
                ALL_FIELDS,
                DATE + " = ?",
                new String[]{encodeDate(when)},
                null, null, null);
        LogItem item;
        if (cursor.moveToFirst()) {
            item = createLogItem(cursor);
        } else {
            item = new LogItem(when);
            item.setHelper(this);
        }
        item.setHelper(this);
        return item;
    }

    private LogItem createLogItem(final Cursor cursor) {
        Calendar date = decodeDate(cursor.getLong(0));
        int whealsOrdinal = cursor.getInt(1);
        int itchOrdinal = cursor.getInt(2);
        String note = cursor.getString(3);
        Set<Angioedema> angio = decodeAngio(cursor.getString(4));
        String picture = cursor.getString(5);
        Set<Limitation> limitations = decodeLimitations(cursor.getString(6));
        return new LogItem(date,
                           Level.values()[whealsOrdinal],
                           Level.values()[itchOrdinal],
                           note,
                           angio,
                           picture,
                           limitations);
    }

    private Calendar decodeDate(final long millis) {
        Calendar date = Calendar.getInstance();
        date.setTimeInMillis(millis * 1000);
        return date;
    }

    private Set<Angioedema> decodeAngio(final String raw) {
        Set<Angioedema> result = new HashSet<Angioedema>();
        for (String angio : raw.split(FIELD_SEPARATOR)) {
            try {
                Angioedema val = Angioedema.valueOf(angio);
                result.add(val);
            } catch (IllegalArgumentException iae) {
                //No constant found, usually that's because of an empty one, ignore it
            }
        }
        return result;
    }

    private String encodeAngio(final Set<Angioedema> angio) {
        StringBuilder encoded = new StringBuilder();
        for (Angioedema elem : angio) {
            encoded.append(elem.toString());
            encoded.append(FIELD_SEPARATOR);
        }
        return encoded.toString();
    }

    private Set<Limitation> decodeLimitations(final String raw) {
        Set<Limitation> result = new HashSet<Limitation>();
        for (String limitation : raw.split(FIELD_SEPARATOR)) {
            try {
                Limitation val = Limitation.valueOf(limitation);
                result.add(val);
            } catch (IllegalArgumentException iae) {
                //No constant found, usually that's because of an empty one, ignore it
            }
        }
        return result;
    }

    private String encodeLimitations(final Set<Limitation> limitations) {
        StringBuilder encoded = new StringBuilder();
        for (Limitation elem : limitations) {
            encoded.append(elem.toString());
            encoded.append(FIELD_SEPARATOR);
        }
        return encoded.toString();
    }

    private String encodeDate(final Calendar when) {
        return "" + (normaliseDate(when).getTimeInMillis() / 1000);
    }

    private Calendar normaliseDate(final Calendar input) {
        Calendar cal = Calendar.getInstance();
        cal.setTimeZone(TimeZone.getTimeZone("UTC"));
        cal.setTimeInMillis(0);
        cal.set(input.get(Calendar.YEAR),
                input.get(Calendar.MONTH),
                input.get(Calendar.DAY_OF_MONTH));
        return cal;
    }

    void save(final LogItem item) {
        Object[] args = new Object[] {encodeDate(item.getCalendar()),
                                      item.getWheals().ordinal(),
                                      item.getItch().ordinal(),
                                      item.getNote(),
                                      encodeAngio(item.getAngio()),
                                      item.getPicture(),
                                      encodeLimitations(item.getLimitations())};
        SQLiteDatabase db = getWritableDatabase();
        db.execSQL("REPLACE INTO " + LOG_ITEM_TABLE_NAME + " VALUES (?, ?, ?, ?, ?, ?, ?)", args);
    }

    public List<LogItem> selectLogItems() {
        Cursor cursor = getReadableDatabase().query(LOG_ITEM_TABLE_NAME, ALL_FIELDS,
                                                    null, null, null, null, DATE + " ASC");
        List<LogItem> items = new LinkedList<LogItem>();
        while (cursor.moveToNext()) {
            LogItem item = createLogItem(cursor);
            item.setHelper(this);
            items.add(item);
        }
        return items;
    }

}