package org.aauc.urticariapp;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ComponentName;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;


public class MainActivity extends Activity {

    private static final String AAUC_URL = "http://www.urticariacronica.org/?utm_source=app&utm_medium=app&utm_campaign=logo";
    private static final String MEMBER_URL = "https://docs.google.com/forms/d/13LprW5q24OTfVAMBzx1L3HUsl0uE_6SW8ef5tjlbtvo/viewform";
    private static final String URTICARIA_URL = "http://www.urticariacronica.org/la-urticariapp/?utm_source=app&utm_medium=app&utm_campaign=urticariapp";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.action_disclaimer) {
            showDisclaimer();
            return true;
        } else if (id == R.id.action_suggestions) {
            showSuggestions();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    private void showDisclaimer() {
        showDialog(R.string.action_disclaimer, R.string.text_disclaimer);
    }

    private void showSuggestions() {
        showDialog(R.string.action_suggestions, R.string.text_suggestions);
    }


    private void showDialog(final int title, final int message) {
        AlertDialog alertDialog = new AlertDialog.Builder(this)
                .setIcon(R.drawable.ic_launcher)
                .setTitle(title)
                .setMessage(message)
                .setNeutralButton(R.string.close_button, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {

                    }
                })
                .create();
        alertDialog.show();
    }

    public void uasAction(View view) {
        Intent intent = new Intent(this, RegisterLogActivity.class);
        startActivity(intent);
    }

    public void memberAction(View view) {
        viewWebpage(".MemberActivity", MEMBER_URL);
    }

    public void logoAction(View view) {
        openUrl(AAUC_URL);
    }

    public void historyAction(View view) {
        Intent intent = new Intent(this, HistoryActivity.class);
        startActivity(intent);
    }

    public void urticariaAction(View view) {
        viewWebpage(".UrticariaActivity", URTICARIA_URL);
    }

    private void openUrl(String url) {
        Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
        startActivity(browserIntent);
    }

    private void viewWebpage(final String activityAlias, final  String url) {
        Intent intent = new Intent();
        String packageName = getBaseContext().getPackageName();
        ComponentName componentName = new ComponentName(packageName, packageName + activityAlias);
        intent.setComponent(componentName);
        intent.setData(Uri.parse(url));
        startActivity(intent);
    }

}
