package org.aauc.urticariapp.data;

import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

public class LogItem {

    private final Calendar date;
    private Level wheals;
    private Level itch;
    private String note;
    private Set<Angioedema> angio;
    private LogItemOpenHelper helper;

    LogItem(final Calendar date) {
        this(date, Level.NONE, Level.NONE, "", new HashSet<Angioedema>());
    }

    LogItem(final Calendar date, final Level wheals, final Level itch,
            final String note, final Set<Angioedema> angio) {
        this.date = date;
        this.wheals = wheals;
        this.itch = itch;
        this.note = note;
        this.angio = new HashSet<Angioedema>(angio);
    }

    public Date getDate() {
        return date.getTime();
    }

    public Calendar getCalendar() {
        return date;
    }

    public Level getWheals() {
        return wheals;
    }

    public Level getItch() {
        return itch;
    }

    public String getNote() {
        return note;
    }

    public Set<Angioedema> getAngio() {
        return new HashSet<Angioedema>(angio);
    }

    public void setWheals(final Level wheals) {
        this.wheals = wheals;
        save();
    }

    public void setItch(final Level itch) {
        this.itch = itch;
        save();
    }

    public void setNote(final String note) {
        this.note = note;
        save();
    }

    public boolean hasAngio(final Angioedema angioedema) {
        return angio.contains(angioedema);
    }

    public void addAngio(final Angioedema angio) {
        this.angio.add(angio);
        save();
    }

    public void removeAngio(final Angioedema angio) {
        this.angio.remove(angio);
        save();
    }

    private void save() {
        helper.save(this);
    }

    public void setHelper(LogItemOpenHelper helper) {
        this.helper = helper;
    }

    public Calendar dayBefore() {
        Calendar dayLess = (Calendar) date.clone();
        dayLess.add(Calendar.DAY_OF_MONTH, -1);
        return dayLess;
    }

    public Calendar dayAfter() {
        Calendar dayMore = (Calendar) date.clone();
        dayMore.add(Calendar.DAY_OF_MONTH, 1);
        return dayMore;
    }

}
