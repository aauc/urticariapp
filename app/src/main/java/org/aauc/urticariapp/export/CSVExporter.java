package org.aauc.urticariapp.export;

import android.content.res.Resources;
import android.os.Environment;

import org.aauc.urticariapp.R;
import org.aauc.urticariapp.data.Angioedema;
import org.aauc.urticariapp.data.Limitation;
import org.aauc.urticariapp.data.LogItem;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Set;

public class CSVExporter {

    private final Resources resources;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

    public CSVExporter(final Resources resources) {
        this.resources = resources;
    }

    public File export(final Collection<LogItem> items) {
        File outputFile = createOutputFile("registro-urticaria.csv");
        writeContents(outputFile, items);
        return outputFile;
    }

    private File createOutputFile(final String filename) {
        File outputDir = Environment.getExternalStoragePublicDirectory("aauc/");
        outputDir.mkdirs();
        return new File(outputDir, filename);
    }

    private void writeContents(final File outputFile, final Collection<LogItem> items) {
        try {
            Writer writer = new BufferedWriter(
                    new OutputStreamWriter(new FileOutputStream(outputFile), "UTF-8"));
            writer.write(textResource(R.string.csv_header) + "\n");
            for (LogItem item : items) {
                int wheals = item.getWheals().toValue();
                int itch = item.getWheals().toValue();
                writer.write(dateFormat.format(item.getDate()) + "," +
                             wheals+ "," +
                             itch + "," +
                             (wheals + itch) + "," +
                             formatAngioedemaCSV(item.getAngio()) + "," +
                             formatLimitationsCSV(item.getLimitations()) + ",\"" +
                             item.getNote() + "\"\n");
            }
            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private String formatAngioedemaCSV(final Set<Angioedema> angio) {
        StringBuilder result = new StringBuilder();
        result.append('"');
        for (Angioedema item : angio) {
            result.append(textResource(item.toResourceId()))
                  .append('\n');
        }
        result.append('"');
        return result.toString();
    }

    private String formatLimitationsCSV(final Set<Limitation> limitations) {
        StringBuilder result = new StringBuilder();
        result.append('"');
        for (Limitation item : limitations) {
            result.append(textResource(item.toResourceId()))
                  .append('\n');
        }
        result.append('"');
        return result.toString();
    }

    private String textResource(final int id) {
        return resources.getText(id).toString();
    }

}
