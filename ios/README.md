# Urticaria app for iOS

### Miscellanea 

- **i18n**
    
    How to get all labels? Run this command on MacOS.

        > cd {path-to-the-project}/ios
        > find ./ -name \*.m -print0 | xargs -0 genstrings -o urticariapp/i18n/es.lproj
        > find ./ -name \*.m -print0 | xargs -0 genstrings -o urticariapp/i18n/en.lproj

    Where is the i18n files? We have a folder in _ios/urticariapp_ called `i18n`. Inside this folder we will find one folder for each language (e.g.: en.lproj and es.lproj) where we have the files `.strings` what we need to modify for our translations.
    