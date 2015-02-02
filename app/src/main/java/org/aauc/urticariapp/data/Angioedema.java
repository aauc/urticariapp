package org.aauc.urticariapp.data;

import org.aauc.urticariapp.R;

public enum Angioedema {
    LIPS(R.string.angio_lips),
    TONGUE(R.string.angio_tongue),
    EYES(R.string.angio_eyes),
    THROAT(R.string.angio_throat),
    FACE(R.string.angio_face),
    HANDS(R.string.angio_hands),
    FEET(R.string.angio_feet),
    GENITALS(R.string.angio_genitals);

    private final int resourceId;

    Angioedema(final int resourceId) {
        this.resourceId = resourceId;
    }

    public int toResourceId() {
        return resourceId;
    }

}
