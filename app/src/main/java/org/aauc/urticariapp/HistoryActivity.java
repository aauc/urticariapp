package org.aauc.urticariapp;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;

import com.squareup.timessquare.CalendarPickerView;

import org.aauc.urticariapp.data.LogItem;
import org.aauc.urticariapp.data.LogItemOpenHelper;
import org.aauc.urticariapp.export.CSVExporter;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

public class HistoryActivity extends Activity implements CalendarPickerView.OnDateSelectedListener {

    private static final int[] ANGIO_IDS = {R.drawable.angio_0, R.drawable.angio_1,
                                            R.drawable.angio_2, R.drawable.angio_3,
                                            R.drawable.angio_4, R.drawable.angio_5,
                                            R.drawable.angio_6, R.drawable.angio_7,
                                            R.drawable.angio_8};

    private HashMap<Date, LogItem> indexedItems;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    private CSVExporter exporter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_history);

        exporter = new CSVExporter(getResources());

        Calendar maxDate = Calendar.getInstance();
        maxDate.add(Calendar.DAY_OF_MONTH, 1);

        LogItemOpenHelper helper = new LogItemOpenHelper(getApplicationContext());
        List<LogItem> items = helper.selectLogItems(maxDate);
        List<Date> dates = new LinkedList<Date>();
        indexedItems = new HashMap<Date, LogItem>();
        for (LogItem item : items) {
            dates.add(item.getDate());
            indexedItems.put(item.getDate(), item);
        }

        Calendar minDate = Calendar.getInstance();
        if (dates.size() > 0) {
            minDate.setTime(dates.get(0));
        }
        minDate.set(Calendar.DAY_OF_MONTH, 1);

        CalendarPickerView calendar = (CalendarPickerView) findViewById(R.id.calendar_view);
        calendar.init(minDate.getTime(), maxDate.getTime());

        calendar.highlightDates(dates);

        calendar.setOnDateSelectedListener(this);
    }

    @Override
    public boolean onCreateOptionsMenu(final Menu menu) {
        getMenuInflater().inflate(R.menu.history, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        if (id == R.id.action_export) {
            exportToFile();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    private void exportToFile() {
        File outputFile = exporter.export(indexedItems.values());
        shareFile(outputFile);
    }

    private void shareFile(final File outputFile) {
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_SEND);
        Uri uri = Uri.fromFile(outputFile);
        intent.putExtra(Intent.EXTRA_STREAM, uri);
        intent.setType("text/csv");
        startActivity(Intent.createChooser(intent, "Enviar a "));
    }

    @Override
    public void onDateUnselected(Date date) {
        //do nothing
    }

    @Override
    public void onDateSelected(Date date) {
        if (indexedItems.containsKey(date)) {
            LogItem item = indexedItems.get(date);
            String note = item.getNote();
            updateItemInfo(note.isEmpty() ? textResource(R.string.no_note) : note,
                           item.getWheals().toIconId(),
                           item.getItch().toIconId(),
                           item.getAngio().size());
        } else {
            updateItemInfo(textResource(R.string.item_info_hint),
                           R.drawable.uas_level_none,
                           R.drawable.uas_level_none,
                           0);
        }
    }

    private void updateItemInfo(final String notes, final int whealsIcon,
                                final int itchIcon, final int angioCount) {
        ((TextView) findViewById(R.id.itemInfoNotes)).setText(notes);
        ((TextView) findViewById(R.id.whealsIcon)).setCompoundDrawablesWithIntrinsicBounds(whealsIcon, 0, 0, 0);
        ((TextView) findViewById(R.id.itchIcon)).setCompoundDrawablesWithIntrinsicBounds(itchIcon, 0, 0, 0);
        ((TextView) findViewById(R.id.angioIcon)).setCompoundDrawablesWithIntrinsicBounds(ANGIO_IDS[angioCount], 0, 0, 0);
    }

    private String textResource(final int id) {
        return getResources().getText(id).toString();
    }
}
