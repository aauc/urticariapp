package org.aauc.urticariapp.data;

import org.aauc.urticariapp.R;

public enum Level {
    NONE(0, R.id.level0Wheals, R.id.level0Itch, R.drawable.uas_level_0),
    MILD(1, R.id.level1Wheals, R.id.level1Itch, R.drawable.uas_level_1),
    MODERATE(2, R.id.level2Wheals, R.id.level2Itch, R.drawable.uas_level_2),
    SEVERE(3, R.id.level3Wheals, R.id.level3Itch, R.drawable.uas_level_3);

    private final int value;
    private final int whealsId;
    private final int itchId;
    private final int iconId;

    Level(final int value, final int whealsId, final int itchId, final int iconId) {
        this.value = value;
        this.whealsId = whealsId;
        this.itchId = itchId;
        this.iconId = iconId;
    }

    public int toWhealsId() {
        return whealsId;
    }
    public int toItchId() {
        return itchId;
    }
    public int toIconId() {
        return iconId;
    }
    public int toValue() {
        return this.value;
    }

    public static Level fromId(int id) {
        switch (id) {
            case R.id.level0Wheals:
            case R.id.level0Itch: return Level.NONE;
            case R.id.level1Wheals:
            case R.id.level1Itch: return Level.MILD;
            case R.id.level2Wheals:
            case R.id.level2Itch: return Level.MODERATE;
            default: return Level.SEVERE;
        }
    }

}
