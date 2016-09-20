package org.aauc.urticariapp.data;

import org.aauc.urticariapp.R;

public enum Limitation {
    WORK(R.string.limit_work),
    SPORT(R.string.limit_sport),
    LEISURE(R.string.limit_leisure),
    HOBBY(R.string.limit_hobby),
    CLOTHING(R.string.limit_clothing),
    SLEEP(R.string.limit_sleep),
    SEX(R.string.limit_sex);

    private final int resourceId;

    Limitation(final int resourceId) {
        this.resourceId = resourceId;
    }

    public int toResourceId() {
        return resourceId;
    }

}
