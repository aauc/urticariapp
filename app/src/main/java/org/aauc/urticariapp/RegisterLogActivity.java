package org.aauc.urticariapp;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import org.aauc.urticariapp.data.Angioedema;
import org.aauc.urticariapp.data.Level;
import org.aauc.urticariapp.data.Limitation;
import org.aauc.urticariapp.data.LogItem;
import org.aauc.urticariapp.data.LogItemOpenHelper;

import java.text.DateFormat;
import java.util.Calendar;

public class RegisterLogActivity
extends Activity
implements DatePickerDialog.OnDateSetListener {

    private static final int COLOR_SELECTED = Color.argb(50, 0, 103, 159);
    private static final int COLOR_TRANSPARENT = Color.argb(0, 0, 0, 0);
    private LogItem item;
    private LogItemOpenHelper helper;
    private Toast futureDayToast;
    private Toast photoToast;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        helper = new LogItemOpenHelper(getApplicationContext());
        item = helper.findOrCreateLogItem();
        photoToast = Toast.makeText(getApplicationContext(), R.string.not_yet, Toast.LENGTH_SHORT);
        futureDayToast = Toast.makeText(getApplicationContext(), R.string.future_day, Toast.LENGTH_SHORT);
        setContentView(R.layout.activity_register_log);
        updateView();
    }

    private void updateView() {
        updateDate();
        updateWheals();
        updateItch();
    }

    private void updateDate() {
        DateFormat format = android.text.format.DateFormat.getDateFormat(getApplicationContext());
        ((TextView) this.findViewById(R.id.date)).setText(format.format(item.getDate()));
    }

    private void updateWheals() {
        int selectedId = item.getWheals().toWhealsId();
        for (Level level : Level.values()) {
            int id = level.toWhealsId();
            int bg = (id == selectedId) ? COLOR_SELECTED : COLOR_TRANSPARENT;
            ((Button) this.findViewById(id)).setBackgroundColor(bg);
        }
    }

    private void updateItch() {
        int selectedId = item.getItch().toItchId();
        for (Level level : Level.values()) {
            int id = level.toItchId();
            int bg = (id == selectedId) ? COLOR_SELECTED : COLOR_TRANSPARENT;
            ((Button) this.findViewById(id)).setBackgroundColor(bg);
        }
    }

    public void selectWheal(View view) {
        Level level = Level.fromId(view.getId());
        if (item.getWheals() != level) {
            item.setWheals(level);
            updateView();
        }
    }

    public void selectItch(View view) {
        Level level = Level.fromId(view.getId());
        if (item.getItch() != level) {
            item.setItch(level);
            updateView();
        }
    }

    public void selectDate(View view) {
        final Calendar c = item.getCalendar();
        int year = c.get(Calendar.YEAR);
        int month = c.get(Calendar.MONTH);
        int day = c.get(Calendar.DAY_OF_MONTH);
        DatePickerDialog dialog = new DatePickerDialog(this, this, year, month, day);
        dialog.getDatePicker().setMaxDate(c.getTimeInMillis());
        dialog.show();
    }

    public void addNote(View view) {
        final EditText input = new EditText(this);
        input.setMinLines(3);
        input.setMaxLines(10);
        input.setHint(R.string.note_hint);
        input.setText(item.getNote());
        new AlertDialog.Builder(this)
                .setTitle(R.string.note_title)
                .setView(input)
                .setPositiveButton(R.string.save, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int whichButton) {
                        item.setNote(input.getText().toString());
                    }
                }).setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int whichButton) {
                // Do nothing.
            }
        }).show();
    }

    public void addPhoto(View view) {
        photoToast.show();
    }

    public void addAngio(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle(R.string.angio_question)
                .setMultiChoiceItems(angioItems(), angioItemsStatus(),
                        new DialogInterface.OnMultiChoiceClickListener() {
                            @Override
                            public void onClick(final DialogInterface dialogInterface, final int i, final boolean b) {
                                saveAngio(i, b);
                            }
                        })
                .setNeutralButton(R.string.close_button, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        //closing is fine, nothing to do as it's saved on selection
                    }
                });
        builder.create().show();
    }

    private CharSequence[] angioItems() {
        CharSequence[] items = new CharSequence[Angioedema.values().length];
        for (int i = 0; i < items.length; i++) {
            items[i] = getResources().getText(Angioedema.values()[i].toResourceId());
        }
        return items;
    }

    private boolean[] angioItemsStatus() {
        boolean[] status = new boolean[Angioedema.values().length];
        for (int i = 0; i < status.length; i++) {
            status[i] = item.hasAngio(Angioedema.values()[i]);
        }
        return status;
    }

    public void addLimitations(View view) {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle(R.string.limitations_question)
                .setMultiChoiceItems(limitationItems(), limitationItemsStatus(),
                        new DialogInterface.OnMultiChoiceClickListener() {
                            @Override
                            public void onClick(final DialogInterface dialogInterface, final int i, final boolean b) {
                                saveLimitations(i, b);
                            }
                        })
                .setNeutralButton(R.string.close_button, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        //closing is fine, nothing to do as it's saved on selection
                    }
                });
        builder.create().show();
    }

    private CharSequence[] limitationItems() {
        CharSequence[] items = new CharSequence[Limitation.values().length];
        for (int i = 0; i < items.length; i++) {
            items[i] = getResources().getText(Limitation.values()[i].toResourceId());
        }
        return items;
    }

    private boolean[] limitationItemsStatus() {
        boolean[] status = new boolean[Limitation.values().length];
        for (int i = 0; i < status.length; i++) {
            status[i] = item.hasLimitation(Limitation.values()[i]);
        }
        return status;
    }

    @Override
    public void onDateSet(DatePicker datePicker, int year, int month, int day) {
        changeDate(year, month, day);
    }

    public void dayLess(View view) {
        Calendar newDate = item.dayBefore();
        changeDate(newDate);
    }

    public void dayMore(View view) {
        Calendar newDate = item.dayAfter();
        changeDate(newDate);
    }

    private void changeDate(Calendar newDate) {
        changeDate(newDate.get(Calendar.YEAR),
                newDate.get(Calendar.MONTH),
                newDate.get(Calendar.DAY_OF_MONTH));
    }

    private void changeDate(int year, int month, int day) {
        if (validDate(year, month, day)) {
            item = helper.findOrCreateLogItem(year, month, day);
            updateView();
        } else {
            futureDayToast.show();
        }
    }

    private boolean validDate(final int year, final int month, final int day) {
        Calendar now = Calendar.getInstance();
        Calendar toSet = Calendar.getInstance();
        toSet.set(year, month, day, 0, 0 , 0);
        return toSet.before(now);
    }

    public void saveLimitations(final int which,
                                final boolean checked) {
        Limitation limitation = Limitation.values()[which];
        if (checked) {
            item.addLimitation(limitation);
        } else {
            item.removeLimitation(limitation);
        }
    }

    public void saveAngio(final int which,
                          final boolean checked) {
        Angioedema angio = Angioedema.values()[which];
        if (checked) {
            item.addAngio(angio);
        } else {
            item.removeAngio(angio);
        }
    }
}
